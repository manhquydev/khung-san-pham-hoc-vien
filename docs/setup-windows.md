# Cài đặt lần đầu cho học viên dùng Windows

Tài liệu này đi từng bước một, từ máy trống tới khi trang web của con chạy
trên mạng. Mỗi bước đều có: **lệnh cần gõ → kết quả đúng sẽ thấy → nếu
lỗi thì sửa thế nào**. Làm theo đúng thứ tự, đừng nhảy bước.

> ⚠️ **Mỗi học viên dùng tài khoản Cloudflare MIỄN PHÍ của riêng mình**
> (đăng ký không cần thẻ). Hạn mức tính theo tài khoản — xem
> `docs/gioi-han-free.md` trước khi deploy. Tài khoản giáo viên chỉ để demo.
>
> Mọi lệnh trong tài liệu này gõ trong **PowerShell** (không phải Git Bash,
> không phải Command Prompt cũ), đứng ở thư mục gốc của repo.
> Đường dẫn trên Windows dùng dấu `\`, ví dụ `scripts\check-env.ps1`.

## Bước 0 — Tạo tài khoản Cloudflare miễn phí (không cần thẻ)

1. Mở https://dash.cloudflare.com/sign-up, đăng ký bằng email của con.
2. Cloudflare có thể hỏi thêm thẻ cho một số dịch vụ — **đừng nhập thẻ**.
   Gói Free dùng cho khóa học không yêu cầu thẻ.
3. Đăng nhập xong thấy được Dashboard là đạt.

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
- **Nếu lỗi** (`git không được nhận dạng...`): Git chưa vào PATH. Cài lại,
  tới bước "Adjusting your PATH environment" chọn **"Git from the command
  line and also from 3rd-party software"**, rồi đóng mở lại PowerShell.

## Bước 2 — Cài Node.js LTS

1. Tải tại https://nodejs.org, chọn nút **LTS** (không chọn Current).
2. Cài mặc định, nhớ tích chọn **"Add to PATH"** (mặc định đã tích).
3. Đóng rồi mở lại PowerShell, gõ:

```powershell
node --version
npm --version
```

- **Kết quả đúng:** `v20.x.x` trở lên (ví dụ `v20.19.0`, `v22.x.x`) và
  `10.x.x` cho npm.
- **Nếu lỗi** (báo `v18` trở xuống): máy đang có Node.js cũ. Gỡ bản cũ
  trong Settings → Apps rồi cài lại bản LTS.
- **Nếu lỗi** (`node không được nhận dạng...`): cài lại Node.js, kiểm tra
  đã tích "Add to PATH", đóng mở lại PowerShell.

## Bước 3 — Cài VS Code

1. Tải tại https://code.visualstudio.com, cài mặc định.
2. Mở VS Code → Extensions → tìm **"Prettier"** và **"ESLint"** (tùy chọn,
   giúp code gọn hơn, không bắt buộc).

## Bước 4 — Chạy script kiểm tra môi trường

Script này kiểm tra một lượt: Git, Node.js, npm, wrangler, đăng nhập
Cloudflare, đủ file khung, và `database_id` đã điền chưa. Chạy ở thư mục
gốc của repo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```

- **Kết quả đúng (lúc mới bắt đầu):** PASS ở Git, Node.js, npm, wrangler;
  FAIL ở "Cloudflare login" và "D1 database_id" là **bình thường** — 2 mục
  đó sẽ PASS sau bước 5 và bước 7. Script thoát mã 1 khi còn FAIL, đó là
  cố tình để con biết còn việc chưa xong.
- **Ghi chú về ExecutionPolicy:** Windows mặc định chặn chạy file `.ps1`.
  Cờ `-ExecutionPolicy Bypass` ở lệnh trên chỉ mở cửa cho đúng lần chạy
  này, không đổi cài đặt máy vĩnh viễn. Muốn chạy trực tiếp về sau thì gõ
  một lần: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.
- **Nếu lỗi** (báo không tìm thấy file script): con đang đứng sai thư mục.
  Gõ `cd` tới thư mục repo (nơi có file `index.html`) rồi chạy lại.

## Bước 5 — Đăng nhập Cloudflare bằng wrangler

```powershell
npx wrangler login
```

Trình duyệt sẽ tự mở ra, hỏi cho phép wrangler truy cập tài khoản → bấm
**Allow**. Quay lại PowerShell, gõ:

```powershell
npx wrangler whoami
```

- **Kết quả đúng:** có dòng tài khoản/email của con (ví dụ `Account Name`
  hoặc email đăng ký).
- **Nếu lỗi** (trình duyệt không mở): copy đường link mà PowerShell in ra,
  dán vào trình duyệt đang đăng nhập Cloudflare rồi bấm Allow.
- **Nếu lỗi** (mạng trường chặn): thử mạng điện thoại phát wifi, hoặc nhờ
  giáo viên đăng nhập demo trên máy giáo viên trước.

Chạy lại script kiểm tra: mục "Cloudflare login" giờ phải PASS.

## Bước 6 — Lấy repo về máy

1. Trên GitHub, vào repo khung của lớp, bấm **Use this template** → tạo
   repo riêng (đặt tên theo sản phẩm của nhóm, để chế độ Private).
2. Bấm **Code** → copy đường link, rồi trong PowerShell gõ (thay link thật):

```powershell
git clone https://github.com/<ten-cua-con>/<ten-repo>.git
cd <ten-repo>
```

- **Kết quả đúng:** thư mục mới xuất hiện, bên trong có `index.html`,
  `nhat-ky.html`, `wrangler.toml`.
- **Nếu lỗi** (hỏi username/password khi clone repo private): đăng nhập
  GitHub trên trình duyệt trước, hoặc dùng GitHub Desktop để clone.
  Không dán mật khẩu GitHub vào khung chat chung.

## Bước 7 — Tạo database D1 và điền database_id

Đứng ở thư mục repo, gõ:

```powershell
npx wrangler d1 create khung-san-pham-hoc-vien
```

- **Kết quả đúng:** in ra một khối giống thế này (dãy id của con sẽ khác):

```
[[d1_databases]]
binding = "DB"
database_name = "khung-san-pham-hoc-vien"
database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

Mở file `wrangler.toml`, thay dòng `database_id = "TO-FILL"` bằng dãy id
thật vừa nhận được, lưu file.

- **Nếu lỗi** (`database already exists`): tên database đã có người dùng
  trong tài khoản của con — đổi tên thành `khung-<ten-nhom>` rồi tạo lại,
  đồng thời sửa `database_name` trong `wrangler.toml` cho khớp.
- **Nếu lỗi** (chưa đăng nhập): làm lại bước 5.

Chạy lại script kiểm tra: mục "D1 database_id" giờ phải PASS.

## Bước 8 — Chạy migration và dữ liệu ví dụ

```powershell
npx wrangler d1 migrations apply DB --local
npx wrangler d1 migrations apply DB --remote
npx wrangler d1 execute DB --remote --file migrations\seed.sql
```

- **Kết quả đúng:** mỗi lệnh báo thành công (applied / executed). Lệnh
  `--local` tạo database thử trên máy con để tập; `--remote` mới là
  database thật trên Cloudflare.
- **Nếu lỗi** (báo không tìm thấy database): kiểm tra `database_id`
  trong `wrangler.toml` đã điền đúng chưa (bước 7), và tên binding là `DB`.
- **Nếu lỗi** (báo bảng đã tồn tại): migration đã chạy rồi, bỏ qua và
  chạy tiếp lệnh sau.
- Sau khi nhóm có mục nhật ký thật đầu tiên, **xóa 3 dòng ví dụ** bằng:

```powershell
npx wrangler d1 execute DB --remote --command "DELETE FROM changelog WHERE tieu_de LIKE 'VÍ DỤ%';"
```

## Bước 9 — Đặt khóa giáo viên (Stage 2)

Khóa này do **giáo viên giữ và tự đặt**, học viên không tự tạo:

```powershell
npx wrangler pages secret put TEACHER_KEY --project-name khung-san-pham-hoc-vien
```

PowerShell sẽ hỏi nhập giá trị khóa (gõ xong bấm Enter, chữ khóa không
hiện lên màn hình là bình thường).

- **Kết quả đúng:** báo secret đã lưu.
- **Nếu lỗi** (chưa có project Pages): deploy lần đầu ở bước 10 trước,
  rồi quay lại bước này.
- **TUYỆT ĐỐI KHÔNG** viết khóa vào `wrangler.toml`, vào code, hay gửi
  khóa qua chat chung. Khóa lộ thì coi như cổng giữ lớp đã mở toang.

## Bước 10 — Deploy: 2 cách, chọn 1

### Cách A — Nối qua Dashboard (khuyên dùng lần đầu)

1. Cloudflare Dashboard → Pages → Create application → Pages →
   Connect to Git → chọn repo của nhóm.
2. Framework preset: **None**. Build command: **để trống**. Build output
   directory: **/** (thư mục gốc). Bấm **Save and Deploy**.
3. Chờ vài phút, Dashboard báo thành công và cho đường link
   `https://<ten-project>.pages.dev`.

### Cách B — Deploy bằng lệnh

```powershell
npx wrangler pages deploy . --project-name khung-san-pham-hoc-vien
```

- **Kết quả đúng:** in ra đường link `*.pages.dev`.
- **Nếu lỗi** (báo vượt 500 lượt build/tháng): tài khoản đó đã deploy quá
  nhiều — xem `docs/gioi-han-free.md` (mỗi người một tài khoản, đừng dồn
  cả lớp vào một tài khoản).
- **Nếu lỗi** (báo file quá 25 MiB hoặc quá 20.000 file): kiểm tra có
  nhét nhầm video/ảnh nặng hoặc thư mục `node_modules` vào repo không —
  `node_modules` đã nằm trong `.gitignore`, đừng commit nó.

## Bước 11 — Kiểm tra lần cuối

Mở trình duyệt, vào 3 đường link (thay bằng link thật của nhóm):

1. `https://<ten-project>.pages.dev/` — trang chủ mở được.
2. `https://<ten-project>.pages.dev/nhat-ky` — trang Nhật ký hiện đủ 3
   mục ví dụ, nhóm theo ngày, không vỡ bố cục trên điện thoại.
3. `https://<ten-project>.pages.dev/api/health` — thấy
   `"d1_configured": true` (sau Stage 1) và `"teacher_key_configured": true`
   (sau Stage 2). Trang này chỉ báo có/không, không lộ khóa.

- **Nếu trang nhật ký trống:** mở `/api/health` xem `d1_configured` có
  phải `true` không. Nếu `false` mà `data/changelog.json` vẫn còn trong
  repo thì trang phải hiện mục ví dụ từ file JSON — nếu cũng trống thì
  kiểm tra lại file JSON có còn nguyên không (xem `docs/roadmap.md`
  Stage 1, phần kiểm chứng).
- **Nếu `/api/health` báo 404:** Functions chưa deploy theo — kiểm tra
  thư mục `functions/` đã commit và push lên GitHub chưa, rồi deploy lại.

Khi cả 3 link đều đúng, môi trường của con đã xong. Từ đây, mỗi tính năng
mới đi theo quy trình trong `AGENTS.md`: nói ý tưởng bằng lời thường →
agent đưa vào flow → làm trên nhánh → mở PR → giáo viên review → merge →
mục nhật ký mới hiện lên trang.
