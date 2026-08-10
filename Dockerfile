FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    xvfb \
    curl \
    procps \
    software-properties-common \
    && apt-get clean

# Install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt-get update && apt-get install -y python3 python3-pip \
    && apt-get clean

WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy application files
COPY solver.py service.py clientsend.py ./

# Set environment variables
ENV MAX_WORKERS=4
ENV PORT=8191
ENV PYTHONUNBUFFERED=1

# Expose the port
EXPOSE 8191

# Start the service
CMD ["python3", "service.py"]
