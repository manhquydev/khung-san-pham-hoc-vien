# Kiểm tra môi trường lần đầu cho học viên dùng Windows.
#
# Cách chạy (đứng ở thư mục gốc của repo, mở PowerShell):
#   powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
#
# MÔ HÌNH TÀI KHOẢN ĐÃ CHỐT: MỘT tài khoản Cloudflare do giáo viên đứng tên,
# mỗi nhóm một project Pages + một database D1. Học viên KHÔNG cần đăng nhập
# Cloudflare — mục đăng nhập bên dưới chỉ là ghi chú cho giáo viên và luôn
# đạt với học viên. Học viên không cần đăng nhập vẫn đạt toàn PASS cho các
# mục của mình (xem docs/setup-windows.md phần "Giáo viên chuẩn bị trước").
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

# 5. Dang nhap Cloudflare — CHI LA GHI CHU CHO GIAO VIEN, LUON DAT VOI HOC VIEN.
# Mo hinh da chot: mot tai khoan Cloudflare do giao vien dung ten, moi nhom
# mot project Pages + mot D1. Hoc vien KHONG can dang nhap, KHONG chay whoami,
# KHONG bi muc nay chan. Neu may nay la may giao vien thi giao vien tu kiem
# tra dang nhap bang: npx --yes wrangler whoami
Write-Host "[INFO] Cloudflare login : chi giao vien can dang nhap (tai khoan giao vien, xem docs/setup-windows.md phan 'Giao vien chuan bi truoc'). Hoc vien bo qua muc nay." -ForegroundColor Gray

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
Write-Result $dbFilled "D1 database_id" $dbDetail "Giao vien dien database_id that cua nhom vao wrangler.toml o phan 'Giao vien chuan bi truoc' (docs/setup-windows.md phan 0, buoc G2) truoc khi hoc vien clone. Neu van la TO-FILL thi bao giao vien, hoc vien KHONG tu tao D1 hay tu dien id."

Write-Host ""
if ($failCount -gt 0) {
    Write-Host "Ket qua: $failCount muc FAIL. Sua theo huong dan tren roi chay lai script." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Ket qua: TOAN PASS. May cua con da san sang de code va mo PR (merge vao main la tu deploy, xem docs/setup-windows.md phan 1)." -ForegroundColor Green
    exit 0
}
