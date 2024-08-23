# Use the official Node.js image.
FROM node:18

# Set the working directory.
WORKDIR /usr/src/app

# Copy package.json and package-lock.json.
COPY package*.json ./

# Install dependencies.
RUN npm install 

# RUN npm run build

# Copy the rest of the application code.
COPY . .

# Expose port 3000.
EXPOSE 3000

# Start the application.
CMD ["npm", "start"]
