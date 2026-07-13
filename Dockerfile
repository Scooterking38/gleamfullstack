# --- Stage 1: Build Frontend & Backend Together (2-in-1 Builder) ---
FROM ghcr.io/gleam-lang/gleam:v1.14.0-erlang-alpine AS builder

# Install Node.js and npm via alpine package manager for Lustre compilation
RUN apk add --no-cache nodejs npm

WORKDIR /app
COPY shared ./shared
COPY client ./client
COPY server ./server

# 1. Compile the Lustre frontend assets
WORKDIR /app/client
RUN gleam deps download
RUN gleam run -m lustre/dev build --minify

# 2. Move compiled frontend assets into backend's static directory
RUN mkdir -p /app/server/priv/static && \
    cp -r /app/client/dist/* /app/server/priv/static/

# 3. Export standalone Erlang release (shipment)
WORKDIR /app/server
RUN gleam deps download
RUN gleam export erlang-shipment

# --- Stage 2: Minimal Production Runtime ---
FROM erlang:27-alpine AS runner

WORKDIR /app
# Copy the final shipment release
COPY --from=builder /app/server/build/erlang-shipment ./

ENV PORT=8080
EXPOSE 8080

CMD ["./entrypoint.sh", "run"]
