FROM node:20-alpine

WORKDIR /app

# Install dependencies for native modules
RUN apk add --no-cache python3 make g++

# Create non-root user
RUN addgroup -g 1000 -S node_user && adduser -u 1000 -S node_user -G node_user

# Set ownership
RUN chown -R node_user:node_user /app

USER node_user

EXPOSE 3000

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
