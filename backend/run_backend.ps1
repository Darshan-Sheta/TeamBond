# Stop any running Java processes
Write-Host "Stopping existing Java processes..."
Stop-Process -Name "java" -Force -ErrorAction SilentlyContinue

# Build the project
Write-Host "Building project..."
./mvnw clean package -DskipTests

# Check if build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful! Starting server..."
    # Run the server
    java -jar target/CodeAmigos--Backend-0.0.1-SNAPSHOT.jar
} else {
    Write-Host "Build failed. Fix errors and try again." -ForegroundColor Red
}
