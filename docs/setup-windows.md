# Cài đặt lần đầu cho học viên dùng Windows

Tài liệu này đi từng bước một, từ máy trống tới khi trang web của con chạy
trên mạng. Mỗi bước đều có: **lệnh cần gõ → kết quả đúng sẽ thấy → nếu
lỗi thì sửa thế nào**. Làm theo đúng thứ tự, đừng nhảy bước.

> ⚠️ **Mỗi học viên dùng tài khoản Cloudflare MIỄN PHÍ của riêng mình**
> (đăng ký không cần thẻ). Hạn mức tính theo tài khoản — xem
> `docs/gioi-han-free.md` trước khi deploy. Tài khoản giáo viên chỉ để demo.
>
> Mọi lệnh trong tài liệu này gõ trong **PowerShell** — chương trình gõ
> lệnh có sẵn trên Windows (không phải Git Bash, không phải Command Prompt
> cũ), đứng ở thư mục gốc của repo. Đường dẫn trên Windows dùng dấu `\`,
> ví dụ `scripts\check-env.ps1`.
>
> **Đồng ý của phụ huynh:** Nhờ ba mẹ/người giám hộ tạo tài khoản cùng
> con hoặc đồng ý cho con tạo; học viên dưới 13 tuổi phải có ba mẹ tạo
> tài khoản cùng. Quy tắc này áp dụng cho cả tài khoản Cloudflare (bước 0)
> và tài khoản GitHub (bước 4).

---

# PHẦN 1 — Lần đầu, Stage 0 (mọi học viên làm buổi đầu)

Phần này chỉ đưa trang tĩnh lên mạng, chưa đụng tới database. Xong phần 1,
trang chủ và trang Nhật ký đã chạy thật bằng file JSON. Phần 2 (database,
khóa giáo viên) chỉ làm khi lớp tới Stage 1/2 — đừng làm trước.

## Bước 0 — Tạo tài khoản Cloudflare miễn phí (không cần thẻ)

1. Mở https://dash.cloudflare.com/sign-up, đăng ký bằng email.
2. Cloudflare có thể hỏi thêm thẻ cho một số dịch vụ — **đừng nhập thẻ**.
   Gói Free dùng cho khóa học không yêu cầu thẻ.
3. Đăng nhập xong thấy được Dashboard là đạt.

- **Nếu con chưa có email riêng:** dùng email phụ huynh đồng ý cho con
  dùng, hoặc nhờ giáo viên cấp tài khoản. Đừng tự bịa email — email này
  là nơi nhận thông báo của tài khoản.
- **Nếu lỗi:** không nhận được email xác nhận → kiểm tra hộp Spam, hoặc
  bấm gửi lại email xác nhận trong Dashboard.

## Bước 1 — Cài Git for Windows

1. Tải tại https://git-scm.com/download/win, bấm Next mặc định tới hết
   (mục "Choosing the default editor" cứ để mặc định là được).
2. Đóng rồi mở lại PowerShell, gõ:

```powershell
git --version
```

- **Kết quả đúng:** `git version 2.x.x` (số x nào cũng được).
- **Nếu lỗi** (`git không được nhận dạng...`): Git chưa vào PATH.
  PATH là danh sách thư mục mà máy tính tìm lệnh khi con gõ một lệnh —
  chưa có Git trong đó thì máy không biết lệnh `git` nằm ở đâu. Cài lại,
  tới bước "Adjusting your PATH environment" chọn **"Git from the command
  line and also from 3rd-party software"**, rồi đóng mở lại PowerShell.

## Bước 2 — Cài Node.js LTS

1. Tải tại https://nodejs.org, chọn nút **LTS** (không chọn Current).
2. Cài mặc định là đủ (Node.js tự thêm mình vào PATH, không có ô chọn
   riêng nào cần tích thêm).
3. Đóng rồi mở lại PowerShell, gõ:

```powershell
node --version
npm --version
```

- **Kết quả đúng:** `v20.x.x` trở lên (ví dụ `v20.19.0`, `v22.x.x`) và
  `10.x.x` cho npm.
- **Nếu lỗi** (báo `v18` trở xuống): máy đang có Node.js cũ. Gỡ bản cũ
  trong Settings → Apps rồi cài lại bản LTS.
- **Nếu lỗi** (`node không được nhận dạng...`): cài lại Node.js, đóng mở
  lại PowerShell rồi thử lại.

## Bước 3 — Cài VS Code

1. Tải tại https://code.visualstudio.com, cài mặc định.
2. Mở VS Code → Extensions → tìm **"Prettier"** và **"ESLint"** (tùy chọn,
   giúp code gọn hơn, không bắt buộc).

## Bước 4 — Lấy repo về máy (clone trước, kiểm tra sau)

1. Nhờ ba mẹ/người giám hộ tạo tài khoản GitHub cùng con hoặc đồng ý cho
   con tạo; học viên dưới 13 tuổi phải có ba mẹ tạo tài khoản cùng.
2. Trên GitHub, vào repo khung của lớp, bấm **Use this template** → tạo
   repo riêng (đặt tên theo sản phẩm của nhóm, để chế độ Private).
3. Bấm **Code** → copy đường link, rồi trong PowerShell gõ lệnh clone
   bằng cách **dán đường link vừa copy vào** (đừng gõ nguyên văn ví dụ
   dưới đây, vì `<...>` chỉ là chỗ giữ sẵn cho link thật):

```powershell
git clone <dán-đường-link-vừa-copy-vào-đây>
cd <ten-repo>
```

- **Kết quả đúng:** thư mục mới xuất hiện, bên trong có `public/index.html`,
  `public/nhat-ky.html`, `wrangler.toml`.
- **Nếu lỗi** (trang template báo không tìm thấy, 404): repo khung chưa
  được mở cho lớp — hỏi giáo viên, đừng tự tìm repo khác thay thế.
- **Nếu lỗi** (hỏi username/password khi clone repo private): lần clone
  đầu sẽ bật cửa sổ đăng nhập GitHub riêng — đăng nhập ở cửa sổ đó.
  Không bao giờ gõ mật khẩu GitHub vào PowerShell. Đăng nhập trình duyệt
  trước không tự đăng nhập cho git CLI. Nếu máy đã bật Git Credential
  Manager thì cửa sổ đăng nhập là đường đi đúng; nếu không, dùng GitHub
  Desktop để clone.

## Bước 5 — Chạy script kiểm tra môi trường

Script này kiểm tra một lượt: Git, Node.js, npm, wrangler, đăng nhập
Cloudflare, đủ file khung, và `database_id` đã điền chưa. Chạy ở thư mục
gốc của repo (nơi có file `wrangler.toml`):

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```

- **Kết quả đúng (lúc mới bắt đầu, Stage 0):** PASS ở Git, Node.js,
  npm, wrangler và "File khung" (vì con đã clone ở bước 4 nên đủ file);
  FAIL ở "Cloudflare login" và "D1 database_id" là **bình thường** — 2 mục
  đó sẽ PASS sau bước 6 và phần Stage 1/2. Script thoát mã 1 khi còn
  FAIL, đó là cố tình để con biết còn việc chưa xong.
- **Nếu "File khung" FAIL:** con đang đứng sai thư mục. Gõ `cd` tới thư
  mục repo (nơi có file `wrangler.toml`) rồi chạy lại. Đừng lờ output
  FAIL đi — mỗi mục FAIL đều kèm cách sửa ngay bên dưới nó.
- **Ghi chú về ExecutionPolicy:** Windows mặc định chặn chạy file `.ps1`.
  Cờ `-ExecutionPolicy Bypass` ở lệnh trên chỉ mở cửa cho đúng lần chạy
  này, không đổi cài đặt máy vĩnh viễn. Muốn chạy trực tiếp về sau thì gõ
  một lần: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

## Bước 6 — Đăng nhập Cloudflare bằng wrangler

```powershell
npx --yes wrangler login
```

Cờ `--yes` nghĩa là "lần đầu máy chưa có wrangler thì tự đồng ý tải về",
để con không gặp câu hỏi tiếng Anh "Ok to proceed? (y)" mà tài liệu cũ
không chuẩn bị trước. Trình duyệt sẽ tự mở ra, hỏi cho phép wrangler
truy cập tài khoản → bấm **Allow**. Quay lại PowerShell, gõ:

```powershell
npx --yes wrangler whoami
```

- **Kết quả đúng:** có dòng tài khoản/email của con (ví dụ `Account Name`
  hoặc email đăng ký).
- **Nếu lỗi** (trình duyệt không mở): copy đường link mà PowerShell in ra,
  dán vào trình duyệt đang đăng nhập Cloudflare rồi bấm Allow.
- **Nếu lỗi** (mạng trường chặn): thử mạng điện thoại phát wifi, hoặc nhờ
  giáo viên đăng nhập demo trên máy giáo viên trước.

Chạy lại script kiểm tra: mục "Cloudflare login" giờ phải PASS.

## Bước 7 — Deploy lần đầu: 2 cách, chọn 1

Deploy nghĩa là đưa trang web lên mạng để ai mở đường link cũng xem được
(chứ không chỉ chạy trên máy con).

### Cách A — Nối qua Dashboard (khuyên dùng lần đầu)

1. Cloudflare Dashboard → Pages → Create application → Pages →
   Connect to Git → chọn repo của nhóm.
2. Framework preset: **None**. Build command: **để trống**. Build output
   directory: **public**. Bấm **Save and Deploy**.
3. Chờ vài phút, Dashboard báo thành công và cho đường link
   `https://<ten-project>.pages.dev`.

> Ghi chú: file `wrangler.toml` là nguồn cấu hình chuẩn của project
> Pages, nên deploy qua Dashboard vẫn nhận đúng cấu hình trong file
> (kể cả binding database ở Stage 1 sau này). Nếu sau này bước kiểm tra
> Stage 1/2 báo `d1_configured: false` thì mới cần vào Dashboard →
> Pages project → Settings → Functions → D1 database bindings → gắn
> database vào binding `DB` (xem phần Stage 1/2, bước S4).

### Cách B — Deploy bằng lệnh

```powershell
npx --yes wrangler pages deploy public --project-name <ten-project-cua-nhom>
```

Thay `<ten-project-cua-nhom>` bằng tên project Pages thật của nhóm (tên
repo con đã tạo ở bước 4, giáo viên sẽ xác nhận nếu con không chắc).

- **Kết quả đúng:** in ra đường link `*.pages.dev`.
- **Nếu lỗi** (báo vượt 500 lượt build/tháng): tài khoản đó đã deploy quá
  nhiều — xem `docs/gioi-han-free.md` (mỗi người một tài khoản, đừng dồn
  cả lớp vào một tài khoản).
- **Nếu lỗi** (báo file quá 25 MiB hoặc quá 20.000 file): kiểm tra có
  nhét nhầm video/ảnh nặng hoặc thư mục `node_modules` vào repo không —
  `node_modules` đã nằm trong `.gitignore`, đừng commit nó.

## Bước 8 — Kiểm tra lần cuối Stage 0

Mở trình duyệt, vào 3 đường link (thay bằng link thật của nhóm):

1. `https://<ten-project>.pages.dev/` — trang chủ mở được, tiêu đề trang
   không còn dấu `[ ]` (nghĩa là con đã đổi `[Tên sản phẩm]` thành tên
   thật của SẢN PHẨM, không phải tên thật của con).
2. `https://<ten-project>.pages.dev/nhat-ky` — trang Nhật ký hiện đủ 3
   mục ví dụ, nhóm theo ngày, không vỡ bố cục trên điện thoại.
3. `https://<ten-project>.pages.dev/api/health` — ở Stage 0, thấy
   `"d1_configured": false` và `"teacher_key_configured": false` là
   **ĐÚNG** (database và khóa giáo viên chỉ có từ Stage 1/2). Trang này
   chỉ báo có/không, không lộ khóa.

- **Nếu trang nhật ký trống:** kiểm tra lại file
  `public/data/changelog.json` có còn nguyên không.
- **Nếu `/api/health` báo 404:** Functions chưa deploy theo — kiểm tra
  thư mục `functions/` đã commit và push lên GitHub chưa, rồi deploy lại.

Khi cả 3 link đều đúng, môi trường của con đã xong cho Stage 0. Từ đây,
mỗi tính năng mới đi theo quy trình trong `AGENTS.md`: nói ý tưởng bằng
lời thường → agent đưa vào flow → làm trên nhánh → mở PR → giáo viên
review → merge → mục nhật ký mới hiện lên trang.

---

# PHẦN 2 — Khi lớp tới Stage 1/2 (KHÔNG làm ngày đầu)

Phần này chỉ làm khi giáo viên báo lớp đã tới Stage 1 hoặc Stage 2. Làm
trước sẽ bỏ qua bài học Stage 0 và dễ sai thứ tự.

## Bước S1 — Tạo database D1 và điền database_id

D1 là nơi chứa bảng dữ liệu chạy trên Cloudflare (nôm na là "cuốn sổ
ghi chép" mà trang web đọc/ghi qua mạng). **Binding** là tên gọi để code
tìm thấy database đó — trong khung này, binding tên là `DB`.

Đứng ở thư mục repo, gõ:

```powershell
npx --yes wrangler d1 create khung-<ten-nhom>
```

- **Kết quả đúng:** in ra một khối giống thế này (dãy id của con sẽ khác):

```
[[d1_databases]]
binding = "DB"
database_name = "khung-<ten-nhom>"
database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

Mở file `wrangler.toml`, thay dòng `database_name = "TO-FILL"` bằng tên
database vừa tạo và dòng `database_id = "TO-FILL"` bằng dãy id thật vừa
nhận được, lưu file.

- **Nếu lỗi** (`database already exists`): tên database đã có người dùng
  trong tài khoản của con — đổi tên thành `khung-<ten-nhom>-2` rồi tạo
  lại, đồng thời sửa `database_name` trong `wrangler.toml` cho khớp.
- **Nếu lỗi** (chưa đăng nhập): làm lại bước 6.

Chạy lại script kiểm tra: mục "D1 database_id" giờ phải PASS.

## Bước S2 — Chạy migration và dữ liệu ví dụ

**Migration** là file ghi các bước tạo bảng — chạy nó để tạo bảng, thay
vì bấm tạo bảng bằng tay trên Dashboard (tạo tay sẽ lệch với code trong
repo và các bạn khác không chạy lại được).

```powershell
npx --yes wrangler d1 migrations apply DB --local
npx --yes wrangler d1 migrations apply DB --remote
npx --yes wrangler d1 execute DB --remote --file migrations\seed.sql
```

- **Kết quả đúng:** mỗi lệnh báo thành công (applied / executed). Lệnh
  `--local` tạo database thử trên máy con để tập; `--remote` mới là
  database thật trên Cloudflare.
- **Nếu lỗi** (báo không tìm thấy database): kiểm tra `database_id`
  trong `wrangler.toml` đã điền đúng chưa (bước S1), và tên binding là `DB`.
- **Nếu lỗi** (báo bảng đã tồn tại): migration đã chạy rồi, bỏ qua và
  chạy tiếp lệnh sau.
- Sau khi nhóm có mục nhật ký thật đầu tiên, **xóa 3 dòng ví dụ** bằng:

```powershell
npx --yes wrangler d1 execute DB --remote --command "DELETE FROM changelog WHERE tieu_de LIKE 'VÍ DỤ%';"
```

> Quirk cần biết khi test trên máy: `npx --yes wrangler d1 migrations apply DB
> --local` và `npx --yes wrangler pages dev --d1` dùng hai file database local
> khác nhau. Muốn test API trên máy thì phải seed đúng store mà dev
> server đang dùng (seed lại bằng lệnh dev server chỉ tới), đừng ngạc
> nhiên nếu database `--local` đã seed mà dev server vẫn thấy trống.
> Luồng deploy thật (migration `--remote` → Functions đọc remote) không
> bị ảnh hưởng.

## Bước S3 — CHỈ GIÁO VIÊN LÀM — Đặt khóa giáo viên (Stage 2)

**Học viên bỏ qua bước này.** Khóa này do giáo viên giữ và tự đặt:
trong giờ setup, giáo viên gõ trực tiếp trên máy của từng học viên, học
viên không tự tạo khóa và không giữ khóa sau đó.

```powershell
npx --yes wrangler pages secret put TEACHER_KEY --project-name <ten-project-cua-nhom>
```

Thay `<ten-project-cua-nhom>` bằng tên project Pages thật của nhóm.
PowerShell sẽ hỏi nhập giá trị khóa (gõ xong bấm Enter, chữ khóa không
hiện lên màn hình là bình thường).

- **Kết quả đúng:** báo secret đã lưu.
- **Nếu lỗi** (chưa có project Pages): deploy lần đầu ở bước 7 trước,
  rồi quay lại bước này. Thứ tự này là bắt buộc vì lệnh đặt secret đòi
  project Pages đã tồn tại.
- **TUYỆT ĐỐI KHÔNG** viết khóa vào `wrangler.toml`, vào code, hay gửi
  khóa qua chat chung. Khóa lộ thì coi như cổng giữ lớp đã mở toang.

### Ví dụ ghi mục nhật ký qua API (Stage 2, giáo viên demo)

Giáo viên gõ trên PowerShell (học viên xem, không giữ khóa):

```powershell
$body = @{
  date = "2026-11-02"
  title = "Trang giới thiệu nhóm đã lên mạng"
  description = "Hôm nay trang web của nhóm đã có trang giới thiệu với tên nhóm và lời chào ngắn, ai mở đường link cũng xem được."
  category = "Tính năng mới"
  pr_url = $null
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://<ten-project>.pages.dev/api/changelog" `
  -Method Post `
  -Headers @{ "x-teacher-key" = "<khoa-giao-vien>" } `
  -Body $body -ContentType "application/json"
```

- **Kết quả đúng:** trả về mã 201 và JSON của mục vừa tạo (gồm `id`,
  `date`, `title`, `description`, `category`, `pr_url`).
- **Không kèm khóa** phải bị từ chối (401), **chưa cấu hình khóa** phải bị
  từ chối (503) — đó là cổng giữ lớp hoạt động đúng, không phải lỗi.

## Bước S4 — Kiểm tra lần cuối Stage 1/2

Mở trình duyệt (thay bằng link thật của nhóm):

1. `https://<ten-project>.pages.dev/api/health` — thấy
   `"d1_configured": true` (sau Stage 1) và `"teacher_key_configured": true`
   (sau Stage 2).
2. `https://<ten-project>.pages.dev/nhat-ky` — trang Nhật ký hiện đủ mục
   từ D1 (không còn đọc file JSON nữa).
3. Ghi thử 1 mục qua API theo ví dụ ở bước S3, thấy mục mới hiện lên trang.

- **Nếu `/api/health` báo `d1_configured: false` sau deploy qua
  Dashboard:** vào Dashboard → Pages project → Settings → Functions →
  D1 database bindings → gắn database của nhóm vào binding `DB`, rồi
  deploy lại. File `wrangler.toml` vốn là nguồn cấu hình chuẩn nên
  thường không cần bước này — chỉ làm khi kiểm tra báo false.
- **Nếu trang nhật ký trống sau khi lên D1:** mở `/api/health` xem
  `d1_configured` có phải `true` không. Nếu `true` mà trang vẫn trống
  thì kiểm tra migration đã chạy `--remote` chưa (bước S2) — API trả
  lỗi 500 lúc này là lỗi thật, trang sẽ báo "tạm thời chưa tải được"
  chứ không tự hiện file JSON ví dụ che lỗi.
