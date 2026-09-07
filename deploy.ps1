# deploy.ps1 - Zola blog publish (ASCII only, no Chinese to avoid encoding bugs)
#
#   .\deploy.ps1
#   .\deploy.ps1 -Message "add CRTE review"
#
# main   = source (backup, normal history)
# master = built output only (force-pushed each deploy)

param(
    [string]$Message = "Update site $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$ErrorActionPreference = "Stop"

$root = "C:\Users\JLM\Desktop\zola_blog"
Set-Location $root

$remote = git remote get-url origin 2>$null
if (-not $remote) {
    Write-Host "No remote 'origin'. Run setup first." -ForegroundColor Red
    exit 1
}

Write-Host "==> 1/4 build" -ForegroundColor Cyan
zola build --output-dir public --force
if ($LASTEXITCODE -ne 0) {
    Write-Host "zola build failed, aborting." -ForegroundColor Red
    exit 1
}

Write-Host "==> 2/4 push source to main" -ForegroundColor Cyan
git add -A
if (git status --porcelain) {
    git commit -m $Message
}
git push origin main

Write-Host "==> 3/4 publish output to master" -ForegroundColor Cyan
# Fresh git repo in .deploy holding only the built output, force-pushed to master.
# This keeps master free of source and .gitmodules so Pages never clones the theme.
$deploy = Join-Path $root ".deploy"
if (Test-Path $deploy) {
    Remove-Item $deploy -Recurse -Force
}
New-Item -ItemType Directory -Path $deploy | Out-Null

Copy-Item "$root\public\*" $deploy -Recurse -Force
New-Item -ItemType File -Path (Join-Path $deploy ".nojekyll") -Force | Out-Null

Push-Location $deploy
git init -q
git remote add origin $remote
git checkout -q -b master
git add -A
git commit -q -m "Deploy: $Message"
git push -f origin master
$pushOk = ($LASTEXITCODE -eq 0)
Pop-Location

Remove-Item $deploy -Recurse -Force

if ($pushOk) {
    Write-Host "==> 4/4 done. Live in ~1-2 min:" -ForegroundColor Green
    Write-Host "    https://jimmysured.github.io/" -ForegroundColor Green
}
else {
    Write-Host "==> push to master failed, see above." -ForegroundColor Red
    exit 1
}
