# ============================================================================
# المرحلة الأولى: البناء (Builder Stage)
# ============================================================================
FROM rust:1.94.1 as builder

# تحسين الأداء والبناء
ENV CARGO_INCREMENTAL=0 \
    RUST_MIN_STACK=8388608 \
    RUSTFLAGS="-C opt-level=3 -C lto=thin" \
    CARGO_TERM_COLOR=always

# تثبيت المتطلبات النظام للبناء
RUN apt-get update && apt-get install -y --no-install-recommends \
    libdbus-1-dev \
    libxcb1-dev \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# نسخ ملفات المشروع (تحسين الـ Cache)
COPY Cargo.toml Cargo.lock ./
COPY crates ./crates
COPY vendor ./vendor

# بناء المشروع في وضع الإصدار
RUN cargo build --release --locked 2>&1 | tail -30

# ============================================================================
# المرحلة الثانية: التشغيل (Runtime Stage)
# ============================================================================
FROM debian:bookworm-slim

LABEL maintainer="Goose Team" \
      version="1.50.0" \
      description="Open source AI agent for code, workflows, and automation" \
      github="https://github.com/aaif-goose/goose"

# تثبيت المتطلبات التشغيل فقط
RUN apt-get update && apt-get install -y --no-install-recommends \
    libdbus-1-3 \
    libxcb1 \
    ca-certificates \
    curl \
    bash \
    tini \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مستخدم غير root لـ security
RUN useradd -m -u 1000 goose && \
    chown -R goose:goose /home/goose

WORKDIR /app

# نسخ البينري من مرحلة البناء
COPY --from=builder /build/target/release/goose /usr/local/bin/goose

# إنشاء مجلدات البيانات الدائمة وتعيين الأذونات
RUN mkdir -p /app/config /app/data /app/cache && \
    chown -R goose:goose /app && \
    chmod 750 /app/config /app/data /app/cache

# تبديل للمستخدم غير root
USER goose

# تعيين المنفذ
EXPOSE 3000

# متغيرات البيئة الافتراضية
ENV RUST_LOG=info,goose=debug \
    GOOSE_ADDR=0.0.0.0 \
    PORT=3000 \
    PATH=/usr/local/bin:$PATH \
    GOOSE_CONFIG_HOME=/app/config \
    GOOSE_DATA_HOME=/app/data \
    GOOSE_CACHE_DIR=/app/cache

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# استخدام tini لـ proper signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# تشغيل التطبيق
CMD ["goose"]
