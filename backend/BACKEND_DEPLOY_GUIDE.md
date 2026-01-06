# 🚀 Backend Deployment Guide - Spring Boot

તમારું backend **Spring Boot** છે, તેથી Vercel નહીં. આ platforms પર deploy કરી શકો છો:

---

## 🎯 Best Options (Recommended)

### 1. **Railway** ⭐ (સૌથી સરળ - Recommended)
- ✅ Free tier available
- ✅ Docker support (તમારું Dockerfile ready છે)
- ✅ Automatic deployments
- ✅ Environment variables easy setup
- ✅ MongoDB, Redis, RabbitMQ add-on support

**Website**: https://railway.app

---

### 2. **Render** ⭐ (Free tier સાથે)
- ✅ Free tier available
- ✅ Docker support
- ✅ Easy setup
- ✅ Automatic SSL

**Website**: https://render.com

---

### 3. **Fly.io**
- ✅ Docker support
- ✅ Global edge deployment
- ✅ Good for WebSocket apps

**Website**: https://fly.io

---

### 4. **DigitalOcean App Platform**
- ✅ Docker support
- ✅ Managed databases available
- ⚠️ Paid (પણ affordable)

**Website**: https://www.digitalocean.com/products/app-platform

---

## 📋 Railway પર Deploy કરવું (Step-by-Step)

### Step 1: Railway Account બનાવો
1. https://railway.app પર જાઓ
2. **"Start a New Project"** પર click કરો
3. GitHub સાથે sign up કરો

### Step 2: New Project બનાવો
1. **"New Project"** પર click કરો
2. **"Deploy from GitHub repo"** select કરો
3. તમારું repository select કરો
4. **Root Directory**: `backend` set કરો
   - ⚠️ **કેમ?** કારણ કે તમારું repository monorepo છે (backend + frontend બંને છે)
   - Railway ને કહેવું પડે કે backend code `backend/` folder માં છે
   - જો Root Directory set ન કરો તો Railway repository root માં `pom.xml` શોધશે, પણ તે `backend/` માં છે!

### Step 3: Build Settings
Railway automatically detect કરશે:
- **Build Command**: `./mvnw clean package -DskipTests` (અથવા Dockerfile use કરશે)
- **Start Command**: `java -jar target/CodeAmigos--Backend-0.0.1-SNAPSHOT.jar`
- **Port**: `8080`

### Step 4: Environment Variables Add કરો
Railway Dashboard → Variables section માં આ બધા add કરો:

```
MONGODB_USERNAME=your_mongodb_username
MONGODB_PASSWORD=your_mongodb_password
MONGODB_DB=your_database_name
REDIS_URI=your_redis_host
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
MAIL_ID=your_email@gmail.com
APP_PASSWORD=your_app_password
YOUR_CLIENT_ID=github_oauth_client_id
YOUR_CLIENT_SECRET=github_oauth_client_secret
redirect-uri=https://your-backend-url.railway.app/login/oauth2/code/github
open.cage.api=your_opencage_api_key
frontend.url=https://your-frontend.vercel.app
RAZORPAY_WEBHOOK_SECRET=your_razorpay_webhook_secret
RAZORPAY_KEY_ID=your_razorpay_key_id
RAZORPAY_KEY_SECRET=your_razorpay_key_secret
GEMINI_API_KEY=your_gemini_api_key
rabbitmq.queue=your_queue_name
rabbitmq.dlq.queue=your_dlq_queue_name
rabbitmq.port=5672
rabbitmq.host=your_rabbitmq_host
rabbitmq.username=your_rabbitmq_username
rabbitmq.password=your_rabbitmq_password
SSL_CONNECTION=false
```

### Step 5: MongoDB Add-on (Optional)
1. Railway Dashboard → **"+ New"** → **"Database"** → **"MongoDB"**
2. Railway automatically connection string provide કરશે
3. Environment variables update કરો

### Step 6: Deploy
1. Railway automatically deploy કરશે
2. Build complete થયા પછી તમને URL મળશે
3. Example: `https://your-backend.railway.app`

---

## 📋 Render પર Deploy કરવું

### Step 1: Account બનાવો
1. https://render.com પર જાઓ
2. GitHub સાથે sign up કરો

### Step 2: New Web Service
1. **"New +"** → **"Web Service"**
2. GitHub repository connect કરો
3. **Root Directory**: `backend` set કરો

### Step 3: Build Settings
- **Name**: `codeamigos-backend`
- **Environment**: `Docker`
- **Dockerfile Path**: `backend/Dockerfile`
- **Docker Context**: `backend`

### Step 4: Environment Variables
ઉપર જેવી જ environment variables add કરો

### Step 5: Deploy
- Render automatically build અને deploy કરશે
- URL મળશે: `https://your-backend.onrender.com`

---

## 🔧 Dockerfile Optimization (Production માટે)

તમારું Dockerfile સારું છે, પણ production માટે આ changes કરી શકો છો:

```dockerfile
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

COPY mvnw .
COPY mvnw.cmd .
COPY .mvn .mvn
COPY pom.xml .

RUN ./mvnw dependency:go-offline -B

COPY src ./src
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/target/CodeAmigos--Backend-0.0.1-SNAPSHOT.jar app.jar

# Environment variables will be provided by platform
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## ⚠️ Important Notes

### 1. CORS Settings Update
Backend માં CORS update કરો frontend URL માટે:

```java
@CrossOrigin(origins = {
    "https://your-frontend.vercel.app",
    "http://localhost:5173"
})
```

### 2. MongoDB Connection
- Production માટે MongoDB Atlas use કરો (free tier available)
- Connection string update કરો

### 3. Redis & RabbitMQ
- Railway/Render પર managed services add કરો
- અથવા external services use કરો (Upstash for Redis, CloudAMQP for RabbitMQ)

### 4. WebSocket Support
- Railway અને Render બંને WebSocket support કરે છે
- Port configuration check કરો

### 5. GitHub OAuth Redirect URI
- Production backend URL update કરો GitHub OAuth settings માં
- Example: `https://your-backend.railway.app/login/oauth2/code/github`

---

## 🎯 Quick Comparison

| Platform | Free Tier | Docker | Ease of Use | Best For |
|----------|-----------|--------|-------------|----------|
| **Railway** | ✅ Yes | ✅ Yes | ⭐⭐⭐⭐⭐ | Quick deployment |
| **Render** | ✅ Yes | ✅ Yes | ⭐⭐⭐⭐ | Free tier projects |
| **Fly.io** | ✅ Yes | ✅ Yes | ⭐⭐⭐ | Global edge |
| **DigitalOcean** | ❌ No | ✅ Yes | ⭐⭐⭐⭐ | Production apps |

---

## 📝 Deployment Checklist

- [ ] Backend code GitHub પર push કર્યું
- [ ] Platform account created
- [ ] Project created અને repository connected
- [ ] Root directory set (`backend`)
- [ ] All environment variables added
- [ ] MongoDB connection configured
- [ ] Redis connection configured (જો needed)
- [ ] RabbitMQ configured (જો needed)
- [ ] CORS settings updated with frontend URL
- [ ] GitHub OAuth redirect URI updated
- [ ] Deployed અને tested

---

## 🚀 Recommended: Railway

Railway સૌથી સરળ અને fastest option છે:
1. GitHub connect કરો
2. Environment variables add કરો
3. Deploy!

**તમારું backend live થશે 5-10 minutes માં!** 🎉

---

કોઈ પણ platform પર deploy કરવામાં મદદ જોઈએ? કહો!

