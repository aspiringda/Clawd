FROM node:22-bookworm-slim

# Install system deps:
# - git: required for npm install (some packages fetch via git)
# - tini: clean PID 1 signal handling
# - chromium + libs: needed for WhatsApp Web / browser automation
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    tini \
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

# Install OpenClaw globally
RUN npm install -g openclaw

# Persist OpenClaw state/config to /data (mount a Railway Volume at /data)
ENV OPENCLAW_STATE_DIR=/data/openclaw
ENV OPENCLAW_CONFIG_PATH=/data/openclaw/openclaw.json

# Help OpenClaw find Chromium inside the container
ENV CHROME_PATH=/usr/bin/chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Railway injects PORT; default for local runs
ENV PORT=18789
EXPOSE 18789

# Ensure state dir exists
RUN mkdir -p /data/openclaw

# Use tini as PID 1 (handles shutdown/restart cleanly)
ENTRYPOINT ["tini", "--"]

# Start OpenClaw gateway
CMD ["sh", "-lc", "openclaw gateway --bind 0.0.0.0 --port ${PORT}"]
