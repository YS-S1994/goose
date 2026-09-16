FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libdbus-1-3 libxcb1 ca-certificates curl bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /build/target/release/goose /usr/local/bin/goose
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh && \
    mkdir -p /root/.config/goose && \
    chmod 700 /root/.config/goose

EXPOSE 3000

ENV RUST_LOG=info,goose=debug \
    GOOSE_ADDR=0.0.0.0 \
    PORT=3000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD []
