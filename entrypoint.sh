#!/bin/bash
set -e

# ============================================================================
# Goose Docker Entrypoint Script
# ============================================================================

# الألوان للطباعة
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# المسارات
GOOSE_CONFIG_DIR="${HOME}/.config/goose"
SESSIONS_DIR="${GOOSE_CONFIG_DIR}/sessions"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}🪿 Goose Startup Script${NC}"
echo -e "${BLUE}========================================${NC}\n"

# ============================================================================
# 1. التحقق من مفتاح API المطلوب
# ============================================================================
echo -e "${YELLOW}[1/3] التحقق من مفتاح API...${NC}"

if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ] && \
   [ -z "$GOOGLE_API_KEY" ] && [ -z "$OPENROUTER_API_KEY" ] && \
   [ -z "$AZURE_OPENAI_API_KEY" ]; then
    echo -e "${RED}❌ تحذير: لم يتم اكتشاف أي مفتاح API${NC}"
    echo "يمكنك تعيين أحد هذه المتغيرات:"
    echo "  - OPENAI_API_KEY"
    echo "  - ANTHROPIC_API_KEY"
    echo "  - GOOGLE_API_KEY"
    echo "  - OPENROUTER_API_KEY"
    echo "  - AZURE_OPENAI_API_KEY"
    echo ""
    echo "⏳ سيحاول Goose البدء بدونه..."
else
    echo -e "${GREEN}✅ تم اكتشاف مفتاح API${NC}"
fi

# ============================================================================
# 2. إعداد مجلدات التكوينات
# ============================================================================
echo -e "\n${YELLOW}[2/3] إعداد مجلدات التكوينات...${NC}"

if [ ! -d "$GOOSE_CONFIG_DIR" ]; then
    echo "📁 إنشاء مجلد التكوينات: $GOOSE_CONFIG_DIR"
    mkdir -p "$GOOSE_CONFIG_DIR"
    chmod 700 "$GOOSE_CONFIG_DIR"
fi

if [ ! -d "$SESSIONS_DIR" ]; then
    echo "📁 إنشاء مجلد الجلسات: $SESSIONS_DIR"
    mkdir -p "$SESSIONS_DIR"
    chmod 700 "$SESSIONS_DIR"
fi

echo -e "${GREEN}✅ تم إعداد المجلدات${NC}"

# ============================================================================
# 3. عرض معلومات البدء
# ============================================================================
echo -e "\n${YELLOW}[3/3] معلومات البدء...${NC}"
echo -e "${BLUE}📡 المنفذ: ${PORT:-3000}${NC}"
echo -e "${BLUE}📝 مجلد التكوينات: ${GOOSE_CONFIG_DIR}${NC}"
echo -e "${BLUE}📊 مستوى السجلات: ${RUST_LOG:-info,goose=debug}${NC}"
echo -e "\n${GREEN}🚀 بدء تشغيل Goose...${NC}\n"

# ============================================================================
# تشغيل Goose
# ============================================================================
exec goose "$@"
