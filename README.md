# Khung sản phẩm học viên

Khung xương sườn dùng chung cho khóa học "Build website bằng AI" (học sinh
lớp 7–10). Mỗi học viên/nhóm theo **một sản phẩm xuyên suốt khóa học** trong
khung này: dự án khác nhau, nhưng chung khung, chung quy trình, chung trang
nhật ký phát triển.

## PHẦN DÀNH CHO GIÁO VIÊN

### Dùng repo này làm template

1. Repo này được bật chế độ Template trên GitHub (riêng tư cho tới khi khóa
   học bắt đầu, giáo viên mở công khai khi tới thời điểm triển khai).
2. Học viên bấm **Use this template** → tạo repo riêng của mình → clone về máy.
3. Học viên đổi tên sản phẩm ở 2 chỗ (xem phần học viên bên dưới) rồi bắt đầu
   bằng 1 câu prompt thường — agent tự đưa vào quy trình FlowSkill, không cần
   gõ `/flow`.

### Đưa trang web lên mạng trong vài phút (Cloudflare Pages)

1. Vào Cloudflare Dashboard → Pages → Create application → Pages → Connect to Git.
2. Chọn repo của học viên, bấm Begin setup.
3. Framework preset: **None**. Build command: **để trống**. Build output
   directory: **/** (thư mục gốc). Bấm Save and Deploy.
4. Sau vài phút sẽ có đường link `*.pages.dev` — đó là "bằng chứng xong" cho
   mỗi mốc: link thật mở được, không chỉ chạy trên máy học viên.

> ⚠️ **Mỗi học viên dùng tài khoản Cloudflare miễn phí của riêng mình.**
> Hạn mức tính theo tài khoản, không tính theo project — cả lớp dồn vào
> một tài khoản sẽ dùng chung 100.000 request/ngày và 500 lượt build/tháng
> (xem `docs/gioi-han-free.md`). Tài khoản giáo viên chỉ để demo.

### Cài đặt lần đầu cho học viên Windows

Học viên làm theo `docs/setup-windows.md` (cài Git, Node.js LTS, VS Code,
đăng nhập wrangler, tạo D1, deploy, kiểm tra). Trước khi deploy, chạy
script kiểm tra môi trường ở thư mục gốc của repo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```

Script báo PASS/FAIL từng mục kèm cách sửa; sửa xong chạy lại tới khi toàn
PASS (trừ 2 mục Cloudflare login và D1 database_id sẽ PASS sau khi làm
xong bước đăng nhập và tạo D1).

### Lộ trình đi dần sang full-stack (Stage 0–2 đã có trong repo)

Khung v1 chỉ là trang tĩnh để học viên lên mạng được trong vài phút. Bản
nâng cấp này đã đưa Stage 1 và Stage 2 vào repo (xem chi tiết, cách kiểm
chứng từng stage và mức tốn hạn mức trong `docs/roadmap.md`):

1. **Stage 0 — tĩnh + JSON:** trang đọc `data/changelog.json`. File JSON
   này vẫn giữ lại làm dự phòng: khi chưa có D1, trang tự dùng nó.
2. **Stage 1 — Functions đọc D1:** `functions/api/changelog.js` (GET) đọc
   bảng `changelog` từ D1; `functions/api/health.js` báo database đã cấu
   hình chưa. Trang nhật ký tự gọi API trước, chỉ khi API không dùng được
   mới dùng file JSON. Tạo bảng bằng migration, không sửa tay trên Dashboard.
3. **Stage 2 — ghi qua API có khóa giáo viên:** POST `/api/changelog`
   cần header `x-teacher-key` khớp secret `TEACHER_KEY` (đặt bằng
   `wrangler pages secret put`, không viết vào repo). Đây là cổng giữ lớp
   học, **không phải hệ thống đăng nhập thật** — ai biết khóa đều ghi
   được, nên khóa chỉ nằm ở giáo viên và mọi mục vẫn qua review PR.
4. **Stage 3–4 (sau này, chưa làm):** tính năng riêng từng sản phẩm, rồi
   tùy chọn R2 upload, KV cache, đăng nhập thật — xem `docs/roadmap.md`.

### Quyết định về cổng kiểm chứng (đã chốt, đừng tự ý đổi)

- **Khởi động (Idea → Contract): học viên phải tự xác nhận từng cổng.**
  Đây là chỗ học viên học cách nghĩ về sản phẩm, nên agent chỉ gợi ý và hỏi,
  không tick hộ, không viết hộ SPEC/PRD.
- **Làm thẻ việc (Cards → Verify): cổng tự qua khi kiểm chứng máy đạt**,
  và **giáo viên review PR là cổng người cuối cùng trước khi merge**.
- Mọi PR đã merge đều phải có 1 mục trong `data/changelog.json` viết bằng lời
  dễ hiểu cho phụ huynh (xem `AGENTS.md` mục 4).

## PHẦN DÀNH CHO HỌC VIÊN

### Bắt đầu

1. Bấm **Use this template** để tạo repo riêng, rồi clone về máy.
2. Học viên Windows làm theo `docs/setup-windows.md` từng bước (cài Git,
   Node.js LTS, VS Code → chạy `scripts\check-env.ps1` → đăng nhập wrangler
   → tạo D1 → deploy → mở `/nhat-ky` và `/api/health` kiểm tra).
3. Đổi tên sản phẩm ở 2 chỗ:
   - `index.html`: dòng `<title>` và dòng `<h1>[Tên sản phẩm]</h1>`.
   - `nhat-ky.html`: dòng `<title>` (thay `[Tên sản phẩm]` bằng tên thật).
4. Xóa 3 mục VÍ DỤ trong `data/changelog.json` và thay bằng mục thật đầu tiên
   của nhóm mình khi có mốc hoàn thành. Sau khi lên Stage 1 (D1), xóa 3 dòng
   ví dụ trong database bằng lệnh trong `docs/setup-windows.md` bước 8.

### Nói gì với agent đầu tiên?

Không cần gõ lệnh gì đặc biệt. Chỉ cần nói bằng lời thường, ví dụ:

- "Con muốn làm trang web giới thiệu câu lạc bộ đọc sách của lớp mình, giúp
  các bạn xem được danh sách truyện và đăng ký mượn truyện."
- "Con muốn làm trang web bán đồ handmade của nhóm, có trang xem sản phẩm và
  trang ghi lại từng ngày nhóm đã làm được gì."

Agent sẽ tự hỏi thêm, cùng con điền bản mô tả sản phẩm, rồi tách thành từng
thẻ việc nhỏ để làm dần. Mỗi thẻ làm xong, nhớ kiểm tra đường link thật và
ghi 1 mục vào trang Nhật ký phát triển.
