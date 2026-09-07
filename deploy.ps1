# deploy.ps1 - Zola blog 發布腳本
#
#   .\deploy.ps1              一般發布
#   .\deploy.ps1 -Message "新增 CRTE 心得"   自訂 commit 訊息
#
# 流程:
#   1. zola build            本機建置到 public/
#   2. 原始碼 commit + push 到 main(備份)
#   3. public/ 產物 push 到 master(發布,GitHub Pages 讀這裡)

param(
    [string]$Message = "Update site $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
Set-Location $root

$remote = (git remote get-url origin 2>$null)
if (-not $remote) { Write-Error "尚未設定 remote origin,請先跑初始化步驟"; exit 1 }

Write-Host "==> 1/4 建置..." -ForegroundColor Cyan
zola build --output-dir public --force
if ($LASTEXITCODE -ne 0) { Write-Error "zola build 失敗,已中止"; exit 1 }

Write-Host "==> 2/4 備份原始碼到 main..." -ForegroundColor Cyan
git add -A
$dirty = git status --porcelain
if ($dirty) { git commit -m $Message } else { Write-Host "    原始碼無變動,略過 commit" }
git push origin main

Write-Host "==> 3/4 發布產物到 master..." -ForegroundColor Cyan
# 用 git worktree 把 public/ 推成 master 的內容,不影響工作目錄
$tmp = Join-Path $env:TEMP "zola_deploy_$(Get-Random)"
git worktree add -q --detach $tmp
try {
    Copy-Item "$root\public\*" $tmp -Recurse -Force
    Set-Location $tmp
    # GitHub Pages 需要:.nojekyll 讓底線開頭的檔案不被 Jekyll 忽略
    New-Item -ItemType File -Path "$tmp\.nojekyll" -Force | Out-Null
    git add -A
    $pd = git status --porcelain
    if ($pd) {
        git commit -q -m "Deploy: $Message"
        git push -f origin HEAD:master
        Write-Host "    已發布" -ForegroundColor Green
    } else {
        Write-Host "    產物無變動,略過" -ForegroundColor Yellow
    }
} finally {
    Set-Location $root
    git worktree remove -f $tmp 2>$null
}

Write-Host "==> 4/4 完成。約 1-2 分鐘後上線:" -ForegroundColor Green
Write-Host "    https://jimmysured.github.io/" -ForegroundColor Green
