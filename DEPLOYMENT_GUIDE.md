# 📚 دليل النشر الشامل لـ Goose على Railway

## ✅ المرحلة 1: التحديثات المدمجة بنجاح

تم دمج **4 Commits** مهمة مباشرة في الفرع `main`:

### 1. **Commit 9c1faa67** (Enhanced .env.example)
```bash
refactor: enhance .env.example with complete provider configuration
```
- إضافة جميع مزودي الذكاء الاصطناعي
- إضافة الخدمات الخارجية (Telegram, Search, TTS)
- توثيق شامل وتنظيم منطقي

### 2. **Commit 79b18779** (Enhanced railway.json)
```bash
refactor: enhance railway.json with comprehensive deployment config
```
- إضافة Health Check
- إضافة متغيرات البيئة الكاملة
- إضافة استراتيجية Fallback
- إضافة تحديدات الموارد والإعادة التلقائية

### 3. **Commit b399cc5b** (Railway Environment Template)
```bash
feat: add Railway deployment environment template with all providers
```
- ملف `.env.railway` كامل للنشر على Railway
- جميع المزودين الرئيسيين والاحتياطيين

### 4. **Commit 0add30f3** (Enhanced Dockerfile)
```bash
refactor: enhance Dockerfile with production best practices
```
- Health Check
- Security (Non-root user: goose:goose)
- Signal Handling مع Tini
- Multi-stage Build لتقليل الحجم

---

## 📋 المتغيرات المطلوبة الكاملة

### **المزودون الأساسيون (يجب اختيار واحد على الأقل)**

```env
# OpenAI (الموصى به)
OPENAI_API_KEY=sk-proj-YOUR_KEY_HERE

# Anthropic (Claude)
ANTHROPIC_API_KEY=sk-ant-YOUR_KEY_HERE

# Google Gemini
GOOGLE_API_KEY=YOUR_KEY_HERE

# OpenRouter (Multi-model)
OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY_HERE
```

### **المزودون الاحتياطيون (Fallback) - 15 مفتاح**

```env
# 1. Mistral AI
MISTRAL_API_KEY=YOUR_KEY_HERE

# 2. Groq
GROQ_API_KEY=gsk-YOUR_KEY_HERE

# 3. DeepSeek
DEEPSEEK_API_KEY=YOUR_KEY_HERE

# 4. XAI (X.com AI)
XAI_API_KEY=YOUR_KEY_HERE

# 5. OpenRouter (إضافي)
OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY_HERE

# 6. Telegram Bot
TELEGRAM_BOT_TOKEN=123456:ABCdef-YOUR_TOKEN_HERE

# 7. Tavily Search
TAVILY_API_KEY=YOUR_KEY_HERE

# 8. Firecrawl
FIRECRAWL_API_KEY=YOUR_KEY_HERE

# 9. ElevenLabs (TTS)
ELEVENLABS_API_KEY=YOUR_KEY_HERE

# 10. Google Search API
GOOGLE_SEARCH_API_KEY=YOUR_KEY_HERE

# 11. Google Search Engine ID
GOOGLE_SEARCH_ENGINE_ID=YOUR_ENGINE_ID_HERE

# 12. Exa Search
EXA_API_KEY=YOUR_KEY_HERE

# 13-15. إضافي (حسب الحاجة)
```

### **تكوين الخادم**

```env
PORT=3000
GOOSE_ADDR=0.0.0.0
RUST_LOG=info,goose=debug
ENVIRONMENT=production
```

### **تخزين البيانات والتكوين**

```env
GOOSE_CONFIG_HOME=/app/config
GOOSE_DATA_HOME=/app/data
GOOSE_CACHE_DIR=/app/cache
```

### **إعدادات متقدمة**

```env
GOOSE_DEFAULT_MODEL=gpt-4
GOOSE_REQUEST_TIMEOUT=300
GOOSE_MAX_CONCURRENT_REQUESTS=5
GOOSE_EXPERIMENTAL_FEATURES=false
GOOSE_VERBOSE_LOGGING=false
```

### **استراتيجية Fallback**

```env
GOOSE_PROVIDER_FALLBACK_ENABLED=true
GOOSE_PROVIDER_TIMEOUT=30
```

---

## 🔐 متغيرات تسجيل الدخول للمدير (Admin Login)

**ملاحظة مهمة:** Goose هو Agent AI، لا يوجد "لوحة تحكم ويب" تقليدية. التحكم يتم عبر:

### **طرق الوصول للمدير:**

1. **SSH/Terminal (للسيرفر)**
```bash
# الاتصال بـ Railway
railway login

# عرض السجلات
railway logs -s goose

# تشغيل الأوامر
railway run goose --help
```

2. **Railway Dashboard (لوحة التحكم)**
- https://railway.app
- عبر حسابك على GitHub
- عرض/تعديل المتغيرات
- مراقبة الأداء والسجلات

3. **API/SDK للتحكم البرمجي**
```bash
# استخدام Railway CLI
railway variables set OPENAI_API_KEY=sk-proj-...
railway variables get OPENAI_API_KEY

# أو استخدام Railway API (باستخدام Token)
curl -H "Authorization: Bearer YOUR_RAILWAY_TOKEN" \
  https://api.railway.app/graphql
```

4. **لا توجد "كلمة مرور Admin"** لأن Goose:
- Agent CLI فقط (بدون واجهة ويب)
- يتم التحكم به عبر متغيرات البيئة
- الأمان عبر Railway's Secret Management

---

## 🚀 أوامر التشغيل على Railway

### **1. الإعداد الأولي**

```bash
# تثبيت Railway CLI (إذا لم تثبت بعد)
npm i -g @railway/cli

# تسجيل الدخول
railway login

# ربط المشروع
cd /path/to/goose
railway link

# اختيار/إنشاء Project
# (سيطلب منك اختيار المشروع أو إنشاء واحد جديد)
```

### **2. تعيين المتغيرات**

```bash
# إضافة المتغيرات الأساسية
railway variables set OPENAI_API_KEY=sk-proj-YOUR_KEY_HERE
railway variables set ANTHROPIC_API_KEY=sk-ant-YOUR_KEY_HERE
railway variables set PORT=3000
railway variables set GOOSE_ADDR=0.0.0.0
railway variables set RUST_LOG=info,goose=debug
railway variables set ENVIRONMENT=production

# إضافة مسارات التخزين
railway variables set GOOSE_CONFIG_HOME=/app/config
railway variables set GOOSE_DATA_HOME=/app/data
railway variables set GOOSE_CACHE_DIR=/app/cache

# تفعيل Fallback
railway variables set GOOSE_PROVIDER_FALLBACK_ENABLED=true
railway variables set GOOSE_PROVIDER_TIMEOUT=30

# إضافة المزودين الاحتياطيين (اختياري)
railway variables set MISTRAL_API_KEY=YOUR_KEY_HERE
railway variables set GROQ_API_KEY=gsk-YOUR_KEY_HERE
railway variables set DEEPSEEK_API_KEY=YOUR_KEY_HERE
```

### **3. النشر والتشغيل**

```bash
# دفع التغييرات (Push)
git push origin main

# Railway سيكتشف التغييرات تلقائياً ويبدأ النشر

# عرض حالة النشر
railway status

# عرض السجلات
railway logs

# عرض السجلات مع التتبع (real-time)
railway logs --tail
```

### **4. التحقق من التشغيل**

```bash
# التحقق من Health Check
curl https://YOUR_RAILWAY_DOMAIN/health

# تشغيل أمر Goose
railway run goose --help

# عرض الإصدار
railway run goose version
```

### **5. إدارة المتغيرات**

```bash
# عرض جميع المتغيرات
railway variables

# تحديث متغير معين
railway variables set OPENAI_API_KEY=sk-proj-NEW_KEY

# حذف متغير
railway variables unset OPENAI_API_KEY

# عرض قيمة متغير معين
railway variables get OPENAI_API_KEY

# استيراد من .env
railway variables import < .env.railway
```

---

## 📄 محتوى railway.json النهائي

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "DOCKERFILE",
    "dockerfile": "./Dockerfile",
    "buildArgs": {
      "RUST_VERSION": "1.94.1"
    },
    "context": "."
  },
  "deploy": {
    "startCommand": "goose",
    "numReplicas": 1,
    "restartPolicyType": "on_failure",
    "restartPolicyMaxRetries": 5,
    "memory": "2Gi",
    "cpu": 1.5,
    "timeout": 300,
    "healthchecks": {
      "liveness": {
        "httpPath": "/health",
        "initialDelaySeconds": 30,
        "periodSeconds": 30,
        "timeoutSeconds": 10,
        "failureThreshold": 3
      }
    }
  },
  "environmentVariables": {
    "PORT": "3000",
    "GOOSE_ADDR": "0.0.0.0",
    "RUST_LOG": "info,goose=debug",
    "GOOSE_CONFIG_HOME": "/app/config",
    "GOOSE_DATA_HOME": "/app/data",
    "ENVIRONMENT": "production"
  },
  "volumes": [
    {
      "mountPath": "/app/config",
      "name": "goose-config"
    },
    {
      "mountPath": "/app/data",
      "name": "goose-data"
    }
  ]
}
```

---

## 🔄 كيف يعمل Fallback (التبديل التلقائي بين المزودين)

Goose يدعم استراتيجية Fallback الذكية:

### **1. ترتيب المزودين (Priority Order)**

```
1️⃣  OPENAI_API_KEY (الأول - الموصى به)
2️⃣  ANTHROPIC_API_KEY 
3️⃣  OPENROUTER_API_KEY
4️⃣  GOOGLE_API_KEY
5️⃣+ المزودون الآخرون (حسب التفعيل)
```

### **2. كيفية التبديل التلقائي**

عند استدعاء Goose:

```
1. يحاول استخدام OPENAI_API_KEY
   ├─ إذا نجح → استخدمه ✅
   └─ إذا فشل (خطأ، انقطاع، Rate Limit) → انتقل للتالي

2. يحاول ANTHROPIC_API_KEY
   ├─ إذا نجح → استخدمه ✅
   └─ إذا فشل → انتقل للتالي

3. يحاول OPENROUTER_API_KEY
   └─ وهكذا...

4. إذا فشل الجميع → خطأ واضح ❌
```

### **3. مثال عملي**

```bash
# إذا كان لديك:
OPENAI_API_KEY=sk-proj-... (متوقف حالياً)
ANTHROPIC_API_KEY=sk-ant-... (يعمل بشكل جيد)
GROQ_API_KEY=gsk-... (احتياطي إضافي)

# عند استدعاء Goose:
$ goose "Hello"

# ستحدث هذه السلسلة:
1. حاول OpenAI → فشل (خادم قيد الصيانة)
   ⏳ انتظر GOOSE_PROVIDER_TIMEOUT (30 ثانية)
2. حاول Anthropic → نجح! ✅
3. استخدم Claude للرد

# لو أيضاً Anthropic فشل:
1. حاول OpenAI → فشل
2. حاول Anthropic → فشل
3. حاول Groq → نجح! ✅
4. استخدم Groq
```

### **4. تخصيص استراتيجية Fallback**

```env
# تفعيل/تعطيل
GOOSE_PROVIDER_FALLBACK_ENABLED=true  # أو false

# المهلة الزمنية لكل محاولة (ثانية)
GOOSE_PROVIDER_TIMEOUT=30  # الافتراضي

# معدل التحديث
GOOSE_RATE_LIMIT=100  # طلبات/دقيقة
```

---

## 🔌 دمج public-apis في Goose

### **الحالة الحالية:**
❌ **لم يتم دمجه كـ Tool عملي حتى الآن**

### **الخطة المقترحة:**

#### **الخيار 1: كـ Data Reference (البسيط)**
```bash
# 1. نسخ ملف public-apis README إلى Goose
cp /path/to/public-apis/README.md \
   crates/goose/data/apis-reference.md

# 2. إنشاء Tool يقرأ البيانات
# File: crates/goose/src/tools/api_reference.rs
pub struct APIReferenceTool {
    apis_data: String,
}

impl APIReferenceTool {
    pub fn search_api(&self, query: &str) -> Vec<String> {
        // بحث في قائمة APIs عن كلمات مفتاحية
        self.apis_data
            .lines()
            .filter(|line| line.contains(query))
            .collect()
    }
}
```

#### **الخيار 2: كـ MCP Server (الاحترافي)**
```bash
# إنشاء MCP Server منفصل
mkdir -p crates/goose-mcp-apis

# ملف: crates/goose-mcp-apis/src/lib.rs
#[mcp::tool]
pub async fn search_public_apis(
    query: String,
    category: Option<String>,
) -> Result<Vec<API>> {
    // قراءة من public-apis
    // تطبيق بحث متقدم
    // إرجاع النتائج
}
```

#### **الخيار 3: كـ Embedded Database**
```rust
// تحويل public-apis إلى SQLite
// لاستعلامات سريعة ومتقدمة

// مثال على الاستعلام:
let api = db
    .query("SELECT * FROM apis WHERE auth = 'apiKey'")
    .execute()?;
```

### **التوصية:**
استخدم **الخيار 1** الآن (Data Reference) لأنه:
- ✅ سهل التنفيذ
- ✅ لا يتطلب تبعيات إضافية
- ✅ يعمل مع الملفات النصية الموجودة

**للنشر المستقبلي:** استخدم **الخيار 2** (MCP Server) للميزات المتقدمة

---

## 🛠️ خطوات النشر النهائية (Step-by-Step)

### **الخطوة 1: التحضير المحلي**
```bash
# 1. تحديث المستودع
git clone https://github.com/Yousivar/goose.git
cd goose

# 2. التحقق من الملفات
ls -la
# يجب أن ترى: Dockerfile, railway.json, .env.example, .env.railway
```

### **الخطوة 2: الاتصال بـ Railway**
```bash
# 1. تثبيت Railway CLI
npm install -g @railway/cli

# 2. تسجيل الدخول (سيفتح المتصفح)
railway login

# 3. ربط المشروع
railway link

# 4. اختيار Project اسم مثل "goose-production"
```

### **الخطوة 3: إضافة المتغيرات**
```bash
# انسخ والصق جميع المفاتيح من .env.railway
railway variables set OPENAI_API_KEY=sk-proj-YOUR_KEY

# أو استيراد جملة واحدة
cat .env.railway | sed 's/=.*//g' | while read var; do
  if [ ! -z "$var" ]; then
    read -p "Enter value for $var: " value
    railway variables set $var=$value
  fi
done
```

### **الخطوة 4: النشر**
```bash
# دفع التغييرات
git push origin main

# Railway سيكتشف تلقائياً ويبدأ النشر
# (يمكنك مراقبة التقدم في لوحة التحكم)
```

### **الخطوة 5: التحقق**
```bash
# عرض حالة النشر
railway status

# عرض السجلات
railway logs --tail

# اختبار Health Check
curl https://YOUR_RAILWAY_URL.up.railway.app/health

# تشغيل Goose
railway run goose --version
```

---

## 📊 ملخص الملفات المحدثة

| الملف | الحالة | الحجم | الوصف |
|------|--------|-------|-------|
| `.env.example` | ✅ محدث | 5.9 KB | قالب شامل لجميع المتغيرات |
| `.env.railway` | ✅ جديد | 4.0 KB | قالب خاص بـ Railway |
| `railway.json` | ✅ محدث | 1.0 KB | تكوين النشر الكامل |
| `Dockerfile` | ✅ محدث | 2.7 KB | بناء متعدد المراحل آمن |
| `.dockerignore` | ✅ موجود | 0.5 KB | استبعاد الملفات غير المهمة |

---

## ⚠️ ملاحظات مهمة

1. **الأمان:** لا تلتزم أبداً بملفات `.env` أو مفاتيح API
2. **Railway:** استخدم Secret Management بدلاً من .env
3. **Monitoring:** فعّل Health Check من Railway Dashboard
4. **Backup:** احفظ نسخة احتياطية من متغيراتك
5. **Testing:** اختبر محلياً قبل النشر على الإنتاج

---

## 🎯 الخطوات التالية

- [ ] شغّل `railway login` وربط المشروع
- [ ] أضف جميع المفاتيح المطلوبة
- [ ] اختبر النشر على البيئة الإحدى (Staging)
- [ ] راقب السجلات والأداء
- [ ] فعّل التنبيهات على Railway
- [ ] وثق العملية للفريق

---

**تم إعداد Goose بنجاح ✅**

للمساعدة أو الأسئلة: https://github.com/Yousivar/goose/discussions
