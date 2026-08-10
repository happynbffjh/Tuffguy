FROM python:3.10-slim

# Install Xvfb and Chrome (using modern method without apt-key)
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    xvfb \
    curl \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome using the modern method
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY solver.py service.py clientsend.py ./

# Set environment variables
ENV MAX_WORKERS=4
ENV PORT=8191
ENV PYTHONUNBUFFERED=1

# Expose the port
EXPOSE 8191

# Start the service
CMD ["python", "service.py"]
