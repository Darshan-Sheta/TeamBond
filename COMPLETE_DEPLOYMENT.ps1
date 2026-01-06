# Complete Deployment Script with Error Handling and Logging

$ErrorActionPreference = "Continue"
$logFile = "DEPLOYMENT_LOG.txt"

function Write-Log {
    param($message, $color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $message"
    Write-Host $logMessage -ForegroundColor $color
    Add-Content -Path $logFile -Value $logMessage
}

Write-Log "========================================" "Green"
Write-Log "Complete Deployment Started" "Green"
Write-Log "========================================" "Green"
Write-Log ""

# Step 1: Check Railway Login
Write-Log "Step 1: Checking Railway login..." "Cyan"
$railwayStatus = railway whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Log "Railway not logged in. Opening login page..." "Yellow"
    Start-Process "https://railway.app/login"
    Write-Log "Please login to Railway in the browser, then press Enter..." "Yellow"
    Read-Host
    $railwayStatus = railway whoami 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log "ERROR: Railway login failed. Please login manually: railway login" "Red"
        exit 1
    }
}
Write-Log "✓ Railway logged in: $railwayStatus" "Green"

# Step 2: Check Vercel Login
Write-Log ""
Write-Log "Step 2: Checking Vercel login..." "Cyan"
$vercelStatus = vercel whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Log "Vercel not logged in. Opening login page..." "Yellow"
    Start-Process "https://vercel.com/login"
    Write-Log "Please login to Vercel in the browser, then press Enter..." "Yellow"
    Read-Host
    $vercelStatus = vercel whoami 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log "ERROR: Vercel login failed. Please login manually: vercel login" "Red"
        exit 1
    }
}
Write-Log "✓ Vercel logged in: $vercelStatus" "Green"

# Step 3: Railway Backend Setup
Write-Log ""
Write-Log "Step 3: Setting up Railway backend..." "Cyan"
Set-Location backend

# Link project
Write-Log "Linking Railway project..." "Cyan"
$linkResult = railway link 2>&1
Write-Log "Link result: $linkResult" "Gray"

# Set environment variables
Write-Log "Setting environment variables..." "Cyan"
$vars = @{
    "GEMINI_API_KEY" = "AIzaSyBwe7u1tv_QbPZv3Er9pt6yvOaZ1y-gDSk"
    "MONGODB_USERNAME" = "rajeshthummar1978_db_user"
    "MONGODB_PASSWORD" = "Qpu0kc0TqJst3zXz"
    "MONGODB_DB" = "TeamBond2"
    "REDIS_URI" = "redis-16929.c330.asia-south1-1.gce.cloud.redislabs.com"
    "REDIS_PORT" = "16929"
    "REDIS_PASSWORD" = "4Z1zv1iNjQzqabWVadFBhw6c2w7GfPmH"
    "YOUR_CLIENT_ID" = "Ov23liRLmGozCPFRwScG"
    "YOUR_CLIENT_SECRET" = "984f2680a553e888076fd28d376ca703757d0ab5"
    "redirect-uri" = "https://teambond-production.up.railway.app/login/oauth2/code/github"
    "open.cage.api" = "40327afcd6e04c7a958c71bcd439a800"
    "MAIL_ID" = "shetadarshan61@gmail.com"
    "APP_PASSWORD" = "rhfj rnce vqen wbbp"
    "RAZORPAY_WEBHOOK_SECRET" = "OWGi2QD133o9Ch2mXcxdcIGx"
    "RAZORPAY_KEY_ID" = "rzp_test_Rsg1l0yAzhuowS"
    "RAZORPAY_KEY_SECRET" = "OWGi2QD133o9Ch2mXcxdcIGx"
    "rabbitmq.port" = "5671"
    "rabbitmq.host" = "b-16012807-86aa-4809-9aa5-500695b7a431.mq.eu-north-1.on.aws"
    "rabbitmq.username" = "ShetaDarshan1710"
    "rabbitmq.password" = "ShetaDarshan1710"
    "rabbitmq.queue" = "TeamBond"
    "rabbitmq.dlq.queue" = "dlqTeamBond"
    "SSL_CONNECTION" = "true"
    "JWT_SECRET_KEY" = "qwertyuiopasdfghjklzxcvbnm1234567890QWERTYUIOP"
    "frontend.url" = "https://your-frontend.vercel.app"
}

foreach ($var in $vars.GetEnumerator()) {
    Write-Log "Setting $($var.Key)..." "Gray"
    $result = railway variables set "$($var.Key)=$($var.Value)" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Log "  ✓ $($var.Key) set" "Green"
    } else {
        Write-Log "  ✗ Failed to set $($var.Key): $result" "Red"
    }
}

# Deploy to Railway
Write-Log ""
Write-Log "Deploying to Railway..." "Cyan"
$deployResult = railway up --detach 2>&1
Write-Log "Deploy output: $deployResult" "Gray"
if ($LASTEXITCODE -eq 0) {
    Write-Log "✓ Railway deployment initiated" "Green"
} else {
    Write-Log "✗ Railway deployment failed: $deployResult" "Red"
}

# Get Railway URL
Write-Log "Getting Railway URL..." "Cyan"
$railwayUrlOutput = railway domain 2>&1
$railwayUrl = $railwayUrlOutput | Out-String
Write-Log "Railway URL: $railwayUrl" "Green"

Set-Location ..

# Step 4: Vercel Frontend Setup
Write-Log ""
Write-Log "Step 4: Setting up Vercel frontend..." "Cyan"
Set-Location "frontend\CodeAmigos--Frontend-main"

# Initialize frontend URL variable
$frontendUrl = "Not deployed yet"

# Set environment variable
Write-Log "Setting VITE_API_BASE_URL..." "Cyan"
$cleanRailwayUrl = $railwayUrl -replace "`n", "" -replace "`r", ""
if ($cleanRailwayUrl -match "https?://[^\s]+") {
    $backendUrl = $matches[0]
    Write-Log "Backend URL detected: $backendUrl" "Green"
    Write-Log "Note: Set VITE_API_BASE_URL=$backendUrl in Vercel dashboard" "Yellow"
} else {
    Write-Log "Warning: Could not detect Railway URL. Set VITE_API_BASE_URL manually in Vercel dashboard." "Yellow"
}

# Deploy to Vercel
Write-Log ""
Write-Log "Deploying to Vercel..." "Cyan"
$vercelDeploy = vercel --prod 2>&1 | Out-String
Write-Log "Vercel deploy output: $vercelDeploy" "Gray"
if ($LASTEXITCODE -eq 0) {
    Write-Log "✓ Vercel deployment successful" "Green"
    if ($vercelDeploy -match "https?://[^\s]+") {
        $frontendUrl = $matches[0]
        Write-Log "Frontend URL: $frontendUrl" "Green"
    }
} else {
    Write-Log "✗ Vercel deployment failed: $vercelDeploy" "Red"
}

Set-Location ..\..

# Final Summary
Write-Log ""
Write-Log "========================================" "Green"
Write-Log "Deployment Summary" "Green"
Write-Log "========================================" "Green"
Write-Log "Railway Backend URL: $railwayUrl" "Green"
Write-Log "Vercel Frontend URL: $frontendUrl" "Green"
Write-Log ""
Write-Log "Deployment Complete! Check logs above for any errors." "Green"
Write-Log "Full log saved to: $logFile" "Cyan"

