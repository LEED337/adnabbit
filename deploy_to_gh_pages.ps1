# PowerShell script to deploy Flutter web build to GitHub Pages

Write-Host "Building Flutter web app..." -ForegroundColor Green
flutter build web --release --base-href "/adnabbit/"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful! Deploying to GitHub Pages..." -ForegroundColor Green
    
    # Create or switch to gh-pages branch
    git checkout -B gh-pages
    
    # Remove all files except build/web
    Get-ChildItem -Path . -Exclude "build" | Remove-Item -Recurse -Force
    
    # Copy web build files to root
    Copy-Item -Path "build/web/*" -Destination . -Recurse -Force
    
    # Add and commit
    git add .
    git commit -m "Deploy Flutter web app to GitHub Pages - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    
    # Push to gh-pages branch
    git push origin gh-pages --force
    
    # Switch back to master
    git checkout master
    
    Write-Host "Deployment complete! Check https://LEED337.github.io/adnabbit/" -ForegroundColor Green
} else {
    Write-Host "Build failed!" -ForegroundColor Red
}