# Use Node.js base image
FROM node:16

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package*.json ./

#Install dependencies
RUN npm install

# 5. Copy rest of the application
COPY . .
RUN mkdir -p logs

# Bundle app source
COPY app.js .

# Expose the port your app runs on
EXPOSE 3030

# Command to start the app
CMD ["node", "app.js"]
