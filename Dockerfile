FROM node:20-slim

# Install native deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    imagemagick \
    webp \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy only package files first
COPY package*.json ./

# Install ONLY production deps
RUN npm install --omit=dev \
 && npm cache clean --force

# Copy application code
COPY . .

# Heroku sets PORT automatically
EXPOSE 3000

# Environment
ENV NODE_ENV=production \
    NODE_OPTIONS="--max-old-space-size=768 --optimize-for-size --gc-interval=100"

# Run Node directly
CMD ["node", "index.js"]