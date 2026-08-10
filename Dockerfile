FROM python:3.10-slim

# Install Xvfb, Chrome, and all dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    xvfb \
    curl \
    procps \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
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

# Start the service normally - service.py will handle Xvfb
CMD ["python", "service.py"]
