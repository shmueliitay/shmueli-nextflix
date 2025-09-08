# Stage 1: Build the application
FROM node:20 as builder

WORKDIR /app

# Set environment variables for the build process
ENV NODE_OPTIONS=--openssl-legacy-provider
ENV NEXT_SHARP_PATH=

# Copy package.json and install dependencies
COPY package*.json ./
COPY next.config.js ./
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build

# Stage 2: Create the production image
FROM node:20-slim as runner

# Set environment variables
ENV NODE_ENV=production
ENV NODE_OPTIONS=--openssl-legacy-provider

WORKDIR /app

# Copy the essential files from the builder stage
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the port the application will run on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
