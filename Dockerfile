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
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# نسخ ملفات المشروع (تحسين الـ Cache)
COPY Cargo.toml Cargo.lock ./
COPY crates ./crates
COPY vendor ./vendor

# بناء المشروع في وضع الإصدار
RUN cargo build --release --locked 2>&1 | tail -20

# ============================================================================
# المرحلة الثانية: التشغيل (Runtime Stage)
# ============================================================================
FROM debian:bookworm-slim

LABEL maintainer="Goose Team" \
      version="1.50.0" \
      description="Open source AI agent for code, workflows, and automation"

# تثبيت المتطلبات التشغيل فقط
RUN apt-get update && apt-get install -y --no-install-recommends \
    libdbus-1-3 \
    libxcb1 \
    ca-certificates \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# نسخ البينري من مرحلة البناء
COPY --from=builder /build/target/release/goose /usr/local/bin/goose

# إنشاء مجلدات البيانات الدائمة
RUN mkdir -p /root/.config/goose /app/data && \
    chmod 700 /root/.config/goose && \
    chmod 755 /app/data

# تعيين المنفذ
EXPOSE 3000

# متغيرات البيئة الافتراضية
ENV RUST_LOG=info,goose=debug \
    GOOSE_ADDR=0.0.0.0 \
    PORT=3000 \
    PATH=/usr/local/bin:$PATH

# تشغيل التطبيق
CMD ["goose"]
