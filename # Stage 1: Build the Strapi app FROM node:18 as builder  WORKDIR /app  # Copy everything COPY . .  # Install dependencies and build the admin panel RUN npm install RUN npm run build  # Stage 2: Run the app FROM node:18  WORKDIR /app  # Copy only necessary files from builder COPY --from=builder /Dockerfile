# Stage 1: Build the Strapi app
FROM node:18 as builder

WORKDIR /app

# Copy everything
COPY . .

# Install dependencies and build the admin panel
RUN npm install
RUN npm run build

# Stage 2: Run the app
FROM node:18

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app .

# Install only production dependencies
RUN npm install --omit=dev

EXPOSE 1337

CMD ["npm", "start"]
