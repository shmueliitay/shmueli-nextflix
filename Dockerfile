# Stage 1: Build
FROM node:20-slim AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build

# Stage 2: Production image
FROM node:20-slim AS production
WORKDIR /app
COPY --from=builder /app ./
CMD ["npm", "start"]

