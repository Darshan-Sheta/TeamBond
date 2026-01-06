# 🔧 Railway Error Fix - "Script start.sh not found"

## ❌ Problem:
```
⚠ Script start.sh not found
✖ Railpack could not determine how to build the app.
```

**કારણ**: Railway repository root જોઈ રહ્યું છે, પણ backend code `backend/` folder માં છે.

---

## ✅ Solution - 3 Options:

### Option 1: Railway Settings માં Root Directory Set કરો (Recommended) ⭐

1. **Railway Dashboard** પર જાઓ
2. તમારું **Project** select કરો
3. **Settings** tab પર click કરો
4. **Root Directory** section માં જાઓ
5. **Root Directory** field માં type કરો: `backend`
6. **Save** કરો
7. **Redeploy** કરો

**આથી Railway `backend/` folder માં જશે અને `pom.xml` find કરશે!**

---

### Option 2: Project Delete કરીને નવું બનાવો (Root Directory સાથે)

1. **Existing project delete** કરો (જો હોય તો)
2. **"New Project"** પર click કરો
3. **"Deploy from GitHub repo"** select કરો
4. તમારું repository select કરો
5. **"Configure"** button પર click કરો
6. **Root Directory** માં: `backend` type કરો
7. **Deploy** કરો

---

### Option 3: Service Settings માં Root Directory Set કરો

1. Railway Dashboard → તમારું **Service**
2. **Settings** tab
3. **Root Directory** માં: `backend` set કરો
4. **Save** કરો
5. **Redeploy** કરો

---

## 📁 Files મેં બનાવ્યા છે:

મેં આ files બનાવ્યા છે જેથી Railway properly detect કરે:

1. ✅ `start.sh` - Startup script
2. ✅ `nixpacks.toml` - Nixpacks configuration
3. ✅ `railway.json` - Railway configuration

**પણ સૌથી important**: **Root Directory set કરવું!**

---

## 🎯 Step-by-Step Fix:

### Step 1: Root Directory Set કરો

**Railway Dashboard માં:**
1. તમારું Project → **Settings**
2. Scroll down to **"Root Directory"**
3. Type: `backend`
4. **Save Changes**

### Step 2: Redeploy

1. **Deployments** tab પર જાઓ
2. **"Redeploy"** button પર click કરો
3. અથવા નવું deployment trigger કરો

### Step 3: Verify

Build logs માં આવું જોવા મળવું જોઈએ:
```
[INFO] Building CodeAmigos--Backend 0.0.1-SNAPSHOT
[INFO] from pom.xml
```

---

## ⚠️ જો હજુ પણ Error આવે:

### Check 1: Root Directory Correct છે?
- Settings → Root Directory = `backend` (not `./backend` or `/backend`)

### Check 2: Files Commit કર્યા?
- `start.sh`, `nixpacks.toml`, `railway.json` files commit કર્યા?
- GitHub પર push કર્યું?

### Check 3: Build Settings
- Railway → Settings → Build
- **Build Command**: `mvn clean package -DskipTests` (auto-detect થશે)
- **Start Command**: `java -jar target/CodeAmigos--Backend-0.0.1-SNAPSHOT.jar`

---

## 🎉 Expected Result:

Build successful થયા પછી:
```
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
Starting application...
:: Spring Boot ::                (v3.3.2)
```

---

## 📝 Quick Checklist:

- [ ] Railway Settings → Root Directory = `backend` set કર્યું
- [ ] Files commit અને push કર્યા
- [ ] Redeploy કર્યું
- [ ] Build logs check કર્યા
- [ ] Application running છે

---

**મુખ્ય વાત**: **Root Directory: `backend` set કરવું જરૂરી છે!** 🎯

