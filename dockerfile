# --- Stage 1: Build the Go Binary ---
FROM golang:1.22-alpine AS builder

# Install build dependencies and security tools (git/ca-certificates if needed)
RUN apk add --no-cache git ca-certificates && update-ca-certificates

# Create a non-root system user and group for runtime security
RUN adduser -D -g '' -u 10001 appuser

WORKDIR /src

# Copy dependency files first to leverage Docker layer caching
COPY go.mod ./
RUN go mod download

# Copy the rest of your application files
COPY main.go ./

# Build a statically linked, hardened binary
# CGO_ENABLED=0 removes C library dependencies
# -ldflags="-w -s" strips debugging information and symbols to shrink size
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s" \
    -o /app/server main.go


# --- Stage 2: Hardened Runtime (Distroless) ---
# Using Google's static distroless image: no shell, no package manager, highly secure
FROM gcr.io/distroless/static-debian12:latest-amd64 AS runner

WORKDIR /app

# Copy system files for SSL/TLS connections and the non-root user from builder
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Copy only the compiled binary from the builder stage
COPY --from=builder /app/server ./server

# Switch to the non-root user for runtime execution
USER appuser:appuser

# Expose your Go application's port (adjust if your main.go uses a different port)
EXPOSE 8080

# Execute the binary directly
ENTRYPOINT ["./server"]