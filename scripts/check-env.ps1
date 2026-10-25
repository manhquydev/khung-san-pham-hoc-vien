# Kiểm tra môi trường lần đầu cho học viên dùng Windows.
#
# Cách chạy (đứng ở thư mục gốc của repo, mở PowerShell):
#   powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
#
# Ghi chú về ExecutionPolicy: Windows mặc định chặn chạy file .ps1 tải về.
# Lệnh trên chỉ "mở cửa" cho đúng lần chạy này, không đổi cài đặt máy vĩnh viễn.
# Nếu muốn chạy trực tiếp về sau: Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
#
# Kết quả: mỗi mục in PASS hoặc FAIL kèm cách sửa. Có bất kỳ FAIL nào
# thì script thoát với mã 1 — sửa xong chạy lại cho tới khi toàn PASS.

$ErrorActionPreference = "Stop"
$failCount = 0

function Write-Result {
    param([bool]$Ok, [string]$Name, [string]$Detail, [string]$Fix)
    if ($Ok) {
        Write-Host "[PASS] $Name : $Detail" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $Name : $Detail" -ForegroundColor Red
        if ($Fix) { Write-Host "       Cach sua: $Fix" -ForegroundColor Yellow }
        $script:failCount++
    }
}

function Get-CommandOutput {
    param([string[]]$Command)
    try {
        $out = & $Command[0] $Command[1..($Command.Length - 1)] 2>&1 | Out-String
        return @{ Ok = ($LASTEXITCODE -eq 0); Output = $out.Trim() }
    } catch {
        return @{ Ok = $false; Output = $_.Exception.Message }
    }
}

Write-Host "=== Kiem tra moi truong - khung san pham hoc vien ===" -ForegroundColor Cyan
Write-Host "Thu muc hien tai: $(Get-Location)"
Write-Host ""

# 1. Git
$git = Get-CommandOutput @("git", "--version")
Write-Result $git.Ok "Git" $git.Output "Cai Git for Windows: https://git-scm.com/download/win (chon Next mac dinh), dong mo lai PowerShell roi chay lai script."

# 2. Node.js >= 20
$node = Get-CommandOutput @("node", "--version")
$nodeOk = $false
$nodeDetail = $node.Output
if ($node.Ok -and ($node.Output -match "v(\d+)\.")) {
    $major = [int]$Matches[1]
    $nodeOk = ($major -ge 20)
    if (-not $nodeOk) { $nodeDetail = "$($node.Output) (can >= 20)" }
}
Write-Result $nodeOk "Node.js >= 20" $nodeDetail "Cai Node.js LTS: https://nodejs.org (chon ban LTS, tich 'Add to PATH'), dong mo lai PowerShell roi chay lai script."

# 3. npm
$npm = Get-CommandOutput @("npm", "--version")
Write-Result $npm.Ok "npm" $npm.Output "npm di kem Node.js. Neu Node.js da cai ma npm bao loi, cai lai Node.js LTS va chon 'Add to PATH'."

# 4. Wrangler (CLI cua Cloudflare). Uu tien wrangler cai san, neu khong thi dung qua npx.
$wranglerCmd = $null
$wranglerDetail = ""
if (Get-Command wrangler -ErrorAction SilentlyContinue) {
    $wranglerCmd = @("wrangler")
    $w = Get-CommandOutput @("wrangler", "--version")
    $wranglerDetail = $w.Output
} else {
    Write-Host "Chua thay wrangler cai san, thu chay qua npx (lan dau se tai ve, can mang)..." -ForegroundColor Gray
    $w = Get-CommandOutput @("npx", "--yes", "wrangler", "--version")
    if ($w.Ok) {
        $wranglerCmd = @("npx", "--yes", "wrangler")
        $wranglerDetail = $w.Output
    } else {
        $wranglerDetail = $w.Output
    }
}
Write-Result ($null -ne $wranglerCmd) "Wrangler" $wranglerDetail "Chay: npx --yes wrangler --version (lan dau tai ve hoi lau). Neu mang truong chan npm, nho thay co cap quyen."

# 5. Dang nhap Cloudflare (chi kiem tra khi wrangler chay duoc)
if ($null -ne $wranglerCmd) {
    $whoArgs = $wranglerCmd + @("whoami")
    $who = Get-CommandOutput $whoArgs
    $loggedIn = $who.Ok -and ($who.Output -match "logged in|Account|email")
    $whoDetail = if ($who.Output) { ($who.Output -split "`n")[0] } else { "" }
    Write-Result $loggedIn "Cloudflare login" $whoDetail "Chay: npx --yes wrangler login (trinh duyet se mo ra, dang nhap tai khoan Cloudflare MIEN PHI cua rieng con, khong can the)."
} else {
    Write-Result $false "Cloudflare login" "Bo qua vi wrangler chua chay duoc" "Sua muc Wrangler truoc roi chay lai script."
}

# 6. File bat buoc cua repo co mat khong
$requiredFiles = @(
    "public\index.html",
    "public\nhat-ky.html",
    "public\nhat-ky.js",
    "public\data\changelog.json",
    "wrangler.toml",
    "AGENTS.md",
    "functions\api\changelog.js",
    "functions\api\health.js"
)
$missing = @()
foreach ($f in $requiredFiles) {
    if (-not (Test-Path $f)) { $missing += $f }
}
Write-Result ($missing.Count -eq 0) "File khung" $(if ($missing.Count -eq 0) { "Du $($requiredFiles.Count) file" } else { "Thieu: $($missing -join ', ')" }) "Clone lai repo tu GitHub (Use this template -> git clone) va chay script o thu muc goc cua repo."

# 7. wrangler.toml da dien database_id that chua (Stage 1)
$dbFilled = $false
$dbDetail = ""
if (Test-Path "wrangler.toml") {
    $content = Get-Content "wrangler.toml" -Raw
    if ($content -match 'database_id\s*=\s*"([^"]+)"') {
        $dbId = $Matches[1]
        if ($dbId -ne "" -and $dbId -ne "TO-FILL") {
            $dbFilled = $true
            $dbDetail = "database_id da dien"
        } else {
            $dbDetail = "database_id dang la TO-FILL (chua tao D1)"
        }
    } else {
        $dbDetail = "Khong tim thay dong database_id trong wrangler.toml"
    }
} else {
    $dbDetail = "Khong tim thay wrangler.toml"
}
Write-Result $dbFilled "D1 database_id" $dbDetail "Chay: npx --yes wrangler d1 create khung-<ten-nhom>, copy database_id in ra roi dan vao wrangler.toml (xem docs/setup-windows.md phan Stage 1/2). O Stage 0 (chi trang tinh) muc nay FAIL la binh thuong — trang van chay bang public/data/changelog.json."

Write-Host ""
if ($failCount -gt 0) {
    Write-Host "Ket qua: $failCount muc FAIL. Sua theo huong dan tren roi chay lai script." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Ket qua: TOAN PASS. May cua con da san sang de deploy (xem docs/setup-windows.md phan Deploy)." -ForegroundColor Green
    exit 0
}
