# Use Debian-based Node image for easier Chromium deps
FROM node:22-bookworm-slim

# System deps for running Chromium headless + common fonts
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    ca-certificates \
    fonts-liberation \
    fonts-noto-color-emoji \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libxrender1 \
    libxshmfence1 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw CLI
RUN npm install -g openclaw

# Persist OpenClaw state/config to /data (mount a Railway Volume here)
ENV OPENCLAW_STATE_DIR=/data/openclaw
ENV OPENCLAW_CONFIG_PATH=/data/openclaw/openclaw.json

# Help OpenClaw / Chrome find Chromium in this container
ENV CHROME_PATH=/usr/bin/chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Railway injects PORT; default for local runs
ENV PORT=18789
EXPOSE 18789

# Ensure state dir exists
RUN mkdir -p /data/openclaw

# Start the gateway
CMD ["sh", "-lc", "openclaw gateway --bind 0.0.0.0 --port ${PORT}"]
