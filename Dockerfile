FROM golang:1.24 AS builder

# Installa Node dentro l'immagine Go
RUN apt-get update && \
    apt-get install -y curl make && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

ENV GOPATH=/go \
    CGO_ENABLED=0 \
    PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

WORKDIR /app
COPY . .

RUN make dist

FROM alpine:latest

# Install dependencies
RUN apk --no-cache add ca-certificates tzdata shadow su-exec

# Set the working directory
WORKDIR /listmonk

# Copy only the necessary files
COPY --from=builder /app/listmonk .

COPY config.toml.sample config.toml

# Copy the entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose the application port
EXPOSE 9000

# Define the command to run the application
CMD ["sh", "-c", "./listmonk --install --idempotent --yes && ./listmonk --upgrade --yes  && ./listmonk"]