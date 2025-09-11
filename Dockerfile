# Stage 1: Build
FROM node:20-slim AS builder
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy source code and build
COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build

# Stage 2: Production image
FROM node:20-slim AS production
WORKDIR /app

# Copy only the necessary files from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# Expose port 80
EXPOSE 80

# Start the app
CMD ["npm", "start"]

