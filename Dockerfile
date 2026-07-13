# --- Stage 1: Build Frontend (JavaScript) ---
FROM ghcr.io/gleam-lang/gleam:v1.8.0-node AS client-builder

WORKDIR /app
# Copy shared code and client
COPY shared ./shared
COPY client ./client

# Compile client SPA assets
WORKDIR /app/client
RUN gleam deps download
RUN gleam run -m lustre/dev build --minify

# --- Stage 2: Build Backend & Bundle App (Erlang) ---
FROM ghcr.io/gleam-lang/gleam:v1.8.0-erlang-alpine AS server-builder

WORKDIR /app
COPY shared ./shared
COPY server ./server

# Copy compiled frontend assets into backend's static directory
COPY --from=client-builder /app/client/dist /app/server/priv/static

WORKDIR /app/server
RUN gleam deps download
# Export standalone Erlang release (shipment)
RUN gleam export erlang-shipment

# --- Stage 3: Minimal Production Runtime ---
FROM erlang:27-alpine AS runner

WORKDIR /app
# Copy exported release contents directly into /app
COPY --from=server-builder /app/server/build/erlang-shipment ./

# SnapDeploy will read this environment variable automatically
ENV PORT=8080
EXPOSE 8080

# FIX: Gleam names this file entry.sh
CMD ["./entry.sh", "run"]
