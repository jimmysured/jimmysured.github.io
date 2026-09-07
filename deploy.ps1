# deploy.ps1 - Zola blog publish script
#
#   .\deploy.ps1
#   .\deploy.ps1 -Message "add CRTE review"
#
# main   = source (backup)
# master = built output (GitHub Pages reads this)

param(
    [string]$Message = "Update site $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
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
# master 只放 build 產物。用 orphan worktree 確保不含原始碼 / .gitmodules,
# 否則 GitHub Pages 會誤以為有 submodule 而去 clone theme(依賴 codeberg,會壞)。
$tmp = Join-Path $env:TEMP ("zola_deploy_" + (Get-Random))
git worktree add -q --detach $tmp

$ok = $true
try {
    Set-Location $tmp
    # 清掉 worktree 裡從 main 帶進來的所有檔案(含 .gitmodules / 原始碼)
    git rm -rq . 2>$null
    Get-ChildItem $tmp -Force | Where-Object { $_.Name -ne ".git" } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    # 只放 build 產物
    Copy-Item "$root\public\*" $tmp -Recurse -Force
    New-Item -ItemType File -Path (Join-Path $tmp ".nojekyll") -Force | Out-Null
    git add -A
    if (git status --porcelain) {
        git commit -q -m "Deploy: $Message"
        git push -f origin HEAD:master
        Write-Host "    published" -ForegroundColor Green
    }
    else {
        Write-Host "    output unchanged, skipped" -ForegroundColor Yellow
    }
}
catch {
    $ok = $false
    Write-Host ("    ERROR: " + $_.Exception.Message) -ForegroundColor Red
}

Set-Location $root
git worktree remove -f $tmp 2>$null

if ($ok) {
    Write-Host "==> 4/4 done. Live in ~1-2 min:" -ForegroundColor Green
    Write-Host "    https://jimmysured.github.io/" -ForegroundColor Green
}
else {
    Write-Host "==> deploy failed, see error above." -ForegroundColor Red
    exit 1
}
