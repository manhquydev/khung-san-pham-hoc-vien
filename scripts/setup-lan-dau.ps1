# setup-lan-dau.ps1 — Cai dat lan dau cho hoc vien lop 7-10 (chay 1 lan duy nhat).
#
# Script nay lam theo dung thu tu:
#   1. Kiem tra Git, Node.js, VS Code da co tren may chua, in phien ban tim duoc.
#   2. Thieu cai nao thi in dung lenh winget de cai va HOI con go Y moi chay
#      (khong tu cai len, khong chay winget khi chua duoc dong y).
#   3. Dat ten + email GitHub cho Git (docs/setup-windows.md Buoc 1) de buoc
#      kiem tra sau khong FAIL o muc "Git identity" truoc commit dau tien.
#   4. Hoi link repo nhom (giao vien dua), clone ve may.
#   5. Chay scripts\check-env.ps1, in buoc tiep theo con can lam.
#   Gap loi o buoc nao thi in huong dan ro rang + DUNG LAI cho con xu ly,
#   khong doan mo, khong bo qua loi.
#
# Cach chay (mo PowerShell, dung o thu muc da luu file nay):
#   powershell -ExecutionPolicy Bypass -File .\setup-lan-dau.ps1
# Co -ExecutionPolicy Bypass chi mo cua cho dung lan chay nay, khong doi
# cai dat may vinh vien (xem docs/setup-windows.md Buoc 5).
#
# Chu y: file nay viet tieng Viet KHONG DAU de tranh loi font khi in
# ra tren PowerShell cu. README va tai lieu van dung tieng Viet co dau day du.
#
# Script KHONG tao tai khoan Cloudflare, KHONG dang nhap wrangler,
# KHONG deploy bang lenh — giao vien da noi san repo voi trang web
# cua nhom (xem docs/setup-windows.md).

$ErrorActionPreference = "Continue"

# --- Ham phu ----------------------------------------------------------

function Write-Step {
    param([string]$Text)
    Write-Host ""
    Write-Host "=== $Text ===" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Text)
    Write-Host "[OK] $Text" -ForegroundColor Green
}

function Write-Bad {
    param([string]$Text)
    Write-Host "[LOI] $Text" -ForegroundColor Red
}

function Write-Note {
    param([string]$Text)
    Write-Host "      $Text" -ForegroundColor Yellow
}

# Doc cau tra loi Y/N cua hoc vien. Chi tra $true khi go dung "Y".
function Read-YesNo {
    param([string]$Question)
    $answer = Read-Host "$Question (go Y roi Enter de dong y, go phim khac de bo qua)"
    return ($answer.Trim().ToUpper() -eq "Y")
}

# Chay "<lenh> <tham so>" (thuong la --version), tra ve dong dau tien
# cua ket qua, hoac $null neu lenh khong co tren may / bao loi.
function Get-ToolVersion {
    param([string]$Command, [string[]]$VersionArgs)
    try {
        $out = & $Command @VersionArgs 2>$null | Out-String
        if (($LASTEXITCODE -eq 0) -and ($out.Trim() -ne "")) {
            return ($out.Trim() -split '\r?\n')[0]
        }
    } catch {
        # Lenh khong co tren may: PowerShell nem loi, bat o day va tra $null.
    }
    return $null
}

# Nap lai PATH tu registry (sau khi winget cai xong) de PowerShell
# dang mo nhan ra lenh moi ma khong can dong mo lai.
function Update-PathFromRegistry {
    $machine = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $user = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user"
}

# Hoi hoc vien roi moi chay winget. Tra $true neu lenh winget chay
# xong khong bao loi, $false neu hoc vien khong dong y hoac cai loi.
function Install-WithWinget {
    param([string]$ToolName, [string]$PackageId, [string]$ManualUrl)
    Write-Host ""
    Write-Host "--- Cai $ToolName ---" -ForegroundColor Cyan
    Write-Host "Lenh se chay: winget install -e --id $PackageId"
    if (-not (Read-YesNo "Con co dong y cai $ToolName khong?")) {
        Write-Note "Con chon khong cai bang winget."
        Write-Note "Tu cai tay $ToolName tai: $ManualUrl"
        Write-Note "Cai xong thi chay lai script nay."
        return $false
    }
    Write-Host "Dang cai $ToolName, cho mot lat..." -ForegroundColor Gray
    Write-Host "(Neu Windows hien cua so xin phep thi bam Yes; khong chac thi hoi giao vien.)" -ForegroundColor Gray
    winget install -e --id $PackageId --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Bad "winget bao loi khi cai $ToolName (ma loi $LASTEXITCODE)."
        Write-Note "Cai tay $ToolName tai: $ManualUrl (xem docs/setup-windows.md)."
        Write-Note "Cai xong thi chay lai script nay."
        return $false
    }
    Update-PathFromRegistry
    return $true
}

# Kiem tra 1 cong cu, thieu thi hoi cai bang winget, cai xong kiem
# tra lai. Tra $true neu cuoi cung cong cu da co va dat yeu cau.
# $IsOk nhan vao chuoi phien ban va tra $true neu dat (mac dinh:
# chi can tim thay lenh la dat).
function Ensure-Tool {
    param(
        [string]$ToolName,
        [string]$Command,
        [string[]]$VersionArgs,
        [string]$PackageId,
        [string]$ManualUrl,
        [string]$NotOkNote = "",
        [scriptblock]$IsOk = { param($v) ($null -ne $v) -and ($v -ne "") }
    )
    $version = Get-ToolVersion $Command $VersionArgs
    if (& $IsOk $version) {
        Write-Ok "$ToolName : $version"
        return $true
    }
    if ($version) {
        Write-Host "[CHUA DAT] $ToolName : $version" -ForegroundColor Yellow
        if ($NotOkNote -ne "") { Write-Note $NotOkNote }
    } else {
        Write-Host "[CHUA CO] $ToolName : chua tim thay tren may" -ForegroundColor Yellow
    }
    if (-not $script:wingetAvailable) {
        Write-Note "May nay khong co winget nen script khong tu cai duoc."
        Write-Note "Cai tay $ToolName tai: $ManualUrl"
        Write-Note "Cai xong thi chay lai script nay."
        return $false
    }
    if (-not (Install-WithWinget $ToolName $PackageId $ManualUrl)) {
        return $false
    }
    $version2 = Get-ToolVersion $Command $VersionArgs
    if (& $IsOk $version2) {
        Write-Ok "$ToolName : $version2 (vua cai xong)"
        return $true
    }
    Write-Bad "Da cai $ToolName nhung PowerShell van chua thay lenh $Command."
    Write-Note "DONG PowerShell lai, mo lai PowerShell moi, roi chay lai script nay."
    return $false
}

# --- Bat dau ----------------------------------------------------------

Write-Host "=== Cai dat lan dau - khung san pham hoc vien ===" -ForegroundColor Cyan
Write-Host "Script nay se: kiem tra Git, Node.js, VS Code -> hoi cai cai nao thieu"
Write-Host "-> hoi ten + email GitHub -> hoi link repo nhom de clone -> chay kiem tra may."
Write-Host "Gap loi o buoc nao thi script DUNG LAI va in cach sua. Doc ky tung dong."
Write-Host "Thu muc hien tai: $(Get-Location)"
Write-Host "Con KHONG can tao tai khoan Cloudflare, KHONG dang nhap wrangler."

$script:wingetAvailable = $null -ne (Get-Command winget -ErrorAction SilentlyContinue)
if ($script:wingetAvailable) {
    Write-Host "Da thay winget tren may (dung de cai cong cu thieu)." -ForegroundColor Gray
} else {
    Write-Host "Chua thay winget tren may. Neu thieu cong cu thi con cai tay theo link trong docs/setup-windows.md." -ForegroundColor Yellow
}

# --- Buoc 1: kiem tra 3 cong cu, thieu thi hoi cai bang winget --------
Write-Step "Buoc 1 - Kiem tra Git, Node.js, VS Code"

# ID goi winget da kiem chung (nguon: winget.run, xem bao cao ban giao):
#   Git.Git, OpenJS.NodeJS.LTS, Microsoft.VisualStudioCode
$allOk = $true

if (-not (Ensure-Tool "Git" "git" @("--version") "Git.Git" "https://git-scm.com/download/win")) {
    $allOk = $false
}

# Node.js phai la ban 20 tro len (docs/setup-windows.md Buoc 2,
# scripts\check-env.ps1 cung kiem tra >= 20). Ban cu hon thi cai lai.
$nodeIsOk = { param($v)
    if (($null -eq $v) -or ($v -eq "")) { return $false }
    if ($v -match "v(\d+)\.") { return ([int]$Matches[1] -ge 20) }
    return $false
}
if (-not (Ensure-Tool "Node.js" "node" @("--version") "OpenJS.NodeJS.LTS" "https://nodejs.org" "Can Node.js v20 tro len (xem docs/setup-windows.md Buoc 2)." $nodeIsOk)) {
    $allOk = $false
}

if (-not (Ensure-Tool "VS Code" "code" @("--version") "Microsoft.VisualStudioCode" "https://code.visualstudio.com")) {
    $allOk = $false
}

if (-not $allOk) {
    Write-Host ""
    Write-Bad "Con thieu cong cu. Cai xong theo huong dan o tren roi chay lai script nay."
    Write-Host "Chay lai: powershell -ExecutionPolicy Bypass -File .\setup-lan-dau.ps1"
    exit 1
}

# --- Buoc 2: ten + email GitHub cho Git --------------------------------
Write-Step "Buoc 2 - Dat ten va email cho Git (de Git nho ai la nguoi lam)"

$gitName = Get-ToolVersion "git" @("config", "--global", "user.name")
$gitEmail = Get-ToolVersion "git" @("config", "--global", "user.email")
if (($null -ne $gitName) -and ($null -ne $gitEmail)) {
    Write-Ok "Git da nho: $gitName <$gitEmail>"
} else {
    Write-Host "Git chua biet con la ai. Nhap 2 dong sau (hoi ba me neu chua ro email nao dung)." -ForegroundColor Yellow
    $tries = 0
    $gitName = $null
    $gitEmail = $null
    while ($tries -lt 3) {
        $tries++
        $inName = (Read-Host "Ten hien thi cua con").Trim()
        $inEmail = (Read-Host "Email tai khoan GitHub cua con").Trim()
        if (($inName -eq "") -or ($inEmail -eq "")) {
            Write-Host "Con chua nhap du ca ten va email. Thu lai (lan $tries/3)." -ForegroundColor Yellow
            continue
        }
        if ($inEmail -notlike "*@*") {
            Write-Host "Email phai co dau @, vi du ten@email.com. Thu lai (lan $tries/3)." -ForegroundColor Yellow
            continue
        }
        $gitName = $inName
        $gitEmail = $inEmail
        break
    }
    if (($null -eq $gitName) -or ($null -eq $gitEmail)) {
        Write-Bad "Chua dat duoc ten + email cho Git sau 3 lan thu."
        Write-Note "Hoi giao vien roi chay lai script nay."
        exit 1
    }
    git config --global user.name "$gitName"
    git config --global user.email "$gitEmail"
    $checkName = Get-ToolVersion "git" @("config", "--global", "user.name")
    $checkEmail = Get-ToolVersion "git" @("config", "--global", "user.email")
    if (($null -eq $checkName) -or ($null -eq $checkEmail)) {
        Write-Bad "Khong luu duoc ten + email vao Git."
        Write-Note "Thu chay tay 2 lenh trong docs/setup-windows.md Buoc 1, roi chay lai script."
        exit 1
    }
    Write-Ok "Git da nho: $checkName <$checkEmail>"
}

# --- Buoc 3: lay repo nhom ve may ---------------------------------------
Write-Step "Buoc 3 - Lay repo cua nhom ve may"

if ((Test-Path "wrangler.toml") -and (Test-Path "scripts\check-env.ps1")) {
    Write-Host "Thu muc hien tai da la repo cua nhom (co wrangler.toml va scripts\check-env.ps1)." -ForegroundColor Gray
    Write-Host "Bo qua buoc clone, dung luon thu muc nay." -ForegroundColor Gray
} else {
    Write-Host "Giao vien da dua duong link repo cua nhom cho con o buoc truoc."
    Write-Host "Mo link do, bam Code, copy duong link, roi dan vao day."
    Write-Host "Con KHONG tu bam Use this template tao repo rieng." -ForegroundColor Yellow
    $repoUrl = (Read-Host "Dan duong link repo nhom vao day").Trim()
    if ($repoUrl -eq "") {
        Write-Bad "Con chua dan link. Chay lai script khi co link repo tu giao vien."
        exit 1
    }
    if ($repoUrl -notlike "https://*") {
        Write-Bad "Link repo phai bat dau bang https:// (link lay tu nut Code tren GitHub)."
        Write-Note "Copy lai link dung roi chay lai script."
        exit 1
    }
    $folderName = ($repoUrl.TrimEnd("/") -split "/")[-1] -replace "\.git$", ""
    if ([string]::IsNullOrWhiteSpace($folderName)) {
        Write-Bad "Khong doc duoc ten thu muc tu link nay."
        Write-Note "Copy lai link day du tu nut Code roi chay lai script."
        exit 1
    }
    if (Test-Path $folderName -PathType Container) {
        Write-Host "Da co thu muc $folderName roi (co the con da clone truoc do). Dung luon thu muc nay, khong clone lai." -ForegroundColor Gray
    } else {
        Write-Host "Dang clone $repoUrl ..." -ForegroundColor Gray
        git clone $repoUrl
        if ($LASTEXITCODE -ne 0) {
            Write-Bad "Clone that bai."
            Write-Note "Neu bao khong tim thay (404): giao vien chua mo repo cho con - hoi giao vien, dung tu tim repo khac."
            Write-Note "Neu hien cua so dang nhap GitHub: dang nhap o cua so do. KHONG BAO GIO go mat khau GitHub vao PowerShell."
            Write-Note "Sua xong thi chay lai script nay."
            exit 1
        }
        Write-Ok "Da clone xong ve thu muc $folderName."
    }
    Set-Location $folderName
    if (-not (Test-Path "wrangler.toml")) {
        Write-Bad "Thu muc $folderName khong co file wrangler.toml - co the con clone nham repo."
        Write-Note "Hoi giao vien kiem tra lai link repo nhom roi chay lai script."
        exit 1
    }
}

# --- Buoc 4: chay script kiem tra moi truong ----------------------------
Write-Step "Buoc 4 - Chay script kiem tra may (scripts\check-env.ps1)"

Write-Host "Script kiem tra se bao tung muc PASS hay FAIL kem cach sua."
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
$checkCode = $LASTEXITCODE

Write-Host ""
if ($checkCode -eq 0) {
    Write-Host "=== XONG PHAN CAI DAT ===" -ForegroundColor Green
    Write-Host "May cua con da san sang. Buoc tiep theo (xem README.md muc 'Bat dau o day'):"
    Write-Host "  1. Mo file README-NHOM.md, dien ten nhom, ten san pham, thanh vien (lam qua nhanh + PR)."
    Write-Host "  2. Doi ten san pham o public\index.html va public\nhat-ky.html."
    Write-Host "  3. Noi voi agent dieu nhom muon lam."
    Write-Host "  4. Kiem tra trang that cua nhom theo docs/setup-windows.md Buoc 7 (mo 3 duong link)."
    Write-Host "Con KHONG can tao tai khoan Cloudflare, KHONG dang nhap wrangler, KHONG deploy bang lenh."
    exit 0
} else {
    Write-Bad "Con muc FAIL o tren (script kiem tra thoat ma $checkCode)."
    Write-Note "Doc dong 'Cach sua' ngay duoi moi muc FAIL roi sua theo."
    Write-Note "Sua xong thi chay lai lenh kiem tra (dung o thu muc goc cua repo):"
    Write-Note "  powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1"
    Write-Note "Chay lai cho toi khi toan PASS."
    exit 1
}
