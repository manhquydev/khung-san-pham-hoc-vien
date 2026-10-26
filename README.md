# Khung sản phẩm học viên

Khung xương sườn dùng chung cho khóa học "Build website bằng AI" (học sinh
lớp 7–10). Mỗi học viên/nhóm theo **một sản phẩm xuyên suốt khóa học** trong
khung này: dự án khác nhau, nhưng chung khung, chung quy trình, chung trang
nhật ký phát triển.

## PHẦN DÀNH CHO GIÁO VIÊN

### Dùng repo này làm template

1. Repo này được bật chế độ Template trên GitHub (riêng tư cho tới khi khóa
   học bắt đầu, giáo viên mở công khai khi tới thời điểm triển khai).
2. Mỗi nhóm bấm **Use this template** → tạo repo riêng của nhóm → clone về máy.
3. Học viên đổi tên sản phẩm ở 2 chỗ (xem phần học viên bên dưới) rồi bắt đầu
   bằng 1 câu prompt thường — agent tự đưa vào quy trình FlowSkill, không cần
   gõ `/flow`.

### Mô hình tài khoản đã chốt: MỘT tài khoản giáo viên, mỗi nhóm một project

- **Một tài khoản Cloudflare duy nhất do giáo viên đứng tên** (gói miễn
  phí, không cần thẻ). Mỗi nhóm có **một project Pages + một database
  D1 riêng** trong tài khoản đó.
- **Học viên KHÔNG tạo tài khoản Cloudflare, KHÔNG đăng nhập wrangler,
  KHÔNG giữ bất kỳ khóa nền tảng nào.** Tài khoản GitHub cá nhân + lịch
  sử PR vẫn là bằng chứng đóng góp của từng em — phía Cloudflare không
  cần thêm tài khoản nào nữa.
- Hạn mức tính theo tài khoản, không tính theo project — cả lớp dùng
  chung 100.000 request/ngày và 500 lượt build/tháng (xem
  `docs/gioi-han-free.md`). Với 2 nhóm thì mức này vẫn dư dả; giáo viên
  xem mục Usage mỗi tuần trong thời gian lớp deploy nhiều.

### Giáo viên chuẩn bị trước khi học viên clone (bắt buộc, theo thứ tự)

Làm đủ phần **"Giáo viên chuẩn bị trước"** trong
`docs/setup-windows.md` cho mỗi nhóm, theo đúng thứ tự: tạo project
Pages + database D1 của nhóm → điền `database_name`/`database_id` vào
bản copy `wrangler.toml` của repo nhóm và commit → đặt `TEACHER_KEY`
cho project đó bằng `wrangler pages secret put` → nối repo nhóm với
project qua Dashboard (Connect to Git). **Tuyệt đối không nối Git khi
`database_id` còn là TO-FILL.** Ghi lại mọi project vào
`docs/bang-theo-doi-giao-vien.md` (không bao giờ ghi giá trị khóa vào đó).

Sau khi nối xong, **merge vào `main` là tự deploy** — học viên không
deploy bằng lệnh. Đường link `*.pages.dev` của nhóm là "bằng chứng xong"
cho mỗi mốc: link thật mở được, không chỉ chạy trên máy học viên. Deploy
bằng lệnh CLI (nếu cần) là **chỉ giáo viên** làm.

### Cài đặt lần đầu cho học viên Windows

Học viên làm theo `docs/setup-windows.md`: phần Lần đầu, Stage 0 (cài
Git/Node.js/VS Code, clone repo, chạy script kiểm tra, code, mở PR, kiểm
tra preview, merge, kiểm tra production) rồi mới tới phần Stage 1/2 khi
lớp tới đó. Các bước tạo D1, migration remote và đặt khóa giáo viên là
việc của giáo viên — học viên chỉ chạy migration và database **local**
trên máy mình để tập. Chạy script kiểm tra môi trường ở thư mục gốc của
repo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```

Script báo PASS/FAIL từng mục kèm cách sửa; sửa xong chạy lại tới khi
toàn PASS. Mục đăng nhập Cloudflare chỉ là ghi chú cho giáo viên, không
chặn học viên — học viên không cần đăng nhập cũng đạt toàn PASS cho các
mục của mình.

### Lộ trình đi dần sang full-stack (Stage 0–2 đã có trong repo)

Khung v1 chỉ là trang tĩnh để học viên lên mạng được trong vài phút. Bản
nâng cấp này đã đưa Stage 1 và Stage 2 vào repo (xem chi tiết, cách kiểm
chứng từng stage và mức tốn hạn mức trong `docs/roadmap.md`):

1. **Stage 0 — tĩnh + JSON:** trang đọc `public/data/changelog.json`.
   File JSON này vẫn giữ lại làm dự phòng: khi chưa có D1, trang tự dùng nó.
2. **Stage 1 — Functions đọc D1:** `functions/api/changelog.js` (GET) đọc
   bảng `changelog` từ D1; `functions/api/health.js` báo database đã cấu
   hình chưa. Trang nhật ký tự gọi API trước, chỉ khi API không dùng được
   mới dùng file JSON. Tạo bảng bằng migration, không sửa tay trên Dashboard.
3. **Stage 2 — ghi qua API có khóa giáo viên:** POST `/api/changelog`
   cần header `x-teacher-key` khớp secret `TEACHER_KEY` (đặt bằng
   `npx --yes wrangler pages secret put`, không viết vào repo). Đây là cổng giữ lớp
   học, **không phải hệ thống đăng nhập thật** — ai biết khóa đều ghi
   được, nên khóa chỉ nằm ở giáo viên. Nói thẳng: POST ghi thẳng vào D1
   production, không đi qua PR — nên ở Stage 2, giáo viên rà soát trang
   nhật ký trực tiếp hằng tuần và xóa mục sai bằng lệnh DELETE (xem
   `docs/roadmap.md` Stage 2), thay vì tưởng PR review vẫn đang giữ mục
   nhật ký.
4. **Stage 3–4 (sau này, chưa làm):** tính năng riêng từng sản phẩm, rồi
   tùy chọn R2 upload, KV cache, đăng nhập thật — xem `docs/roadmap.md`.

### Quyết định về cổng kiểm chứng (đã chốt, đừng tự ý đổi)

- **Khởi động (Idea → Contract): học viên phải tự xác nhận từng cổng.**
  Đây là chỗ học viên học cách nghĩ về sản phẩm, nên agent chỉ gợi ý và hỏi,
  không tick hộ, không viết hộ SPEC/PRD.
- **Làm thẻ việc (Cards → Verify): cổng tự qua khi kiểm chứng máy đạt**,
  và **giáo viên review PR là cổng người cuối cùng trước khi merge**.
- Mọi PR đã merge đều phải có 1 mục nhật ký viết bằng lời dễ hiểu cho phụ
  huynh (xem `AGENTS.md` mục 4 — cách ghi theo đúng stage: Stage 0 ghi
  vào `public/data/changelog.json`; Stage 1 trở đi ghi qua POST
  `/api/changelog` kèm khóa giáo viên; sau khi lên D1 không sửa file
  JSON nữa).

## PHẦN DÀNH CHO HỌC VIÊN

### Bắt đầu

1. Bấm **Use this template** để tạo repo riêng của nhóm, rồi clone về máy.
2. Học viên Windows làm theo `docs/setup-windows.md` từng bước: phần Lần
   đầu, Stage 0 (cài Git, Node.js LTS, VS Code → clone → chạy
   `scripts\check-env.ps1` → code → mở PR → kiểm tra preview → merge →
   mở `/nhat-ky` và `/api/health` kiểm tra production). **Không tạo tài
   khoản Cloudflare, không đăng nhập wrangler, không deploy bằng lệnh —
   giáo viên đã nối sẵn repo nhóm với project Pages, merge vào `main`
   là tự lên mạng.** Phần Stage 1/2 chỉ làm khi giáo viên báo lớp tới
   đó; các bước tạo D1, migration remote và đặt khóa là việc của giáo
   viên, học viên chỉ tập trên database local của máy mình.
3. Đổi tên sản phẩm ở các chỗ sau (tên thật của SẢN PHẨM, không phải tên
   thật của con):
   - `public/index.html`: dòng `<title>` và dòng `<h1>[Tên sản phẩm]</h1>`.
   - `public/nhat-ky.html`: dòng `<title>` (thay `[Tên sản phẩm]` bằng tên thật của sản phẩm).
   - `wrangler.toml`: dòng `name` **do giáo viên điền** tên project
     Pages thật của nhóm vào bản copy của repo nhóm — học viên không tự
     đổi dòng này.
4. Xóa 3 mục VÍ DỤ trong `public/data/changelog.json` và thay bằng mục thật đầu tiên
   của nhóm mình khi có mốc hoàn thành. Sau khi lên Stage 1 (D1), xóa 3 dòng
   ví dụ trong database bằng lệnh trong `docs/setup-windows.md` phần Stage 1/2.

### Nói gì với agent đầu tiên?

Không cần gõ lệnh gì đặc biệt. Chỉ cần nói bằng lời thường, ví dụ:

- "Con muốn làm trang web giới thiệu câu lạc bộ đọc sách của lớp mình, giúp
  các bạn xem được danh sách truyện và đăng ký mượn truyện."
- "Con muốn làm trang web bán đồ handmade của nhóm, có trang xem sản phẩm và
  trang ghi lại từng ngày nhóm đã làm được gì."

Agent sẽ tự hỏi thêm, cùng con điền bản mô tả sản phẩm, rồi tách thành từng
thẻ việc nhỏ để làm dần. Mỗi thẻ làm xong, nhớ kiểm tra đường link thật và
ghi 1 mục vào trang Nhật ký phát triển.
