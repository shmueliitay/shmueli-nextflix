# Use an official Node.js runtime as the base image
FROM node:20

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install application dependencies
RUN npm install
RUN npm install typescript@latest --save-dev

# Copy the rest of the application's source code
COPY . .

ENV NODE_OPTIONS=--openssl-legacy-provider
# Build the Next.js application for production
RUN npm run build

# Expose the port the application will run on
EXPOSE 3000

# Command to run the application in production mode
CMD ["npm", "start"]
