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

### Quyết định về cổng kiểm chứng (đã chốt, đừng tự ý đổi)

- **Khởi động (Idea → Contract): học viên phải tự xác nhận từng cổng.**
  Đây là chỗ học viên học cách nghĩ về sản phẩm, nên agent chỉ gợi ý và hỏi,
  không tick hộ, không viết hộ SPEC/PRD.
- **Làm thẻ việc (Cards → Verify): cổng tự qua khi kiểm chứng máy đạt**,
  và **giáo viên review PR là cổng người cuối cùng trước khi merge**.
- Mọi PR đã merge đều phải có 1 mục trong `data/changelog.json` viết bằng lời
  dễ hiểu cho phụ huynh (xem `AGENTS.md` mục 4).

### Lộ trình nâng cấp sau này (không làm ở bản khung v1)

Bản khung v1 cố tình chỉ là trang tĩnh (HTML/CSS/JS, không cần build) để học
viên đưa lên mạng được trong vài phút. Khi lớp đã vững, nâng cấp theo từng
mốc sau — mỗi mốc là một bài học riêng, không dồn vào đầu khóa:

1. **Mốc Functions:** thêm Cloudflare Functions cho phần cần chạy ở máy chủ
   (ví dụ: nhận dữ liệu từ form). Trang tĩnh vẫn giữ nguyên.
2. **Mốc D1:** tạo database D1, chuyển các mục nhật ký từ
   `data/changelog.json` sang bảng `changelog` (cột: date, title, description,
   category, pr_url). Trang `nhat-ky.html` đổi từ đọc file JSON sang gọi API
   Functions đọc từ D1 — cách hiển thị theo ngày và lời dễ hiểu giữ nguyên.
3. Sau mốc D1, việc thêm mục nhật ký vẫn giữ nguyên quy tắc: 1 PR = 1 mục,
   lời dễ hiểu cho phụ huynh, qua review của giáo viên.

## PHẦN DÀNH CHO HỌC VIÊN

### Bắt đầu

1. Bấm **Use this template** để tạo repo riêng, rồi clone về máy.
2. Đổi tên sản phẩm ở 2 chỗ:
   - `index.html`: dòng `<title>` và dòng `<h1>[Tên sản phẩm]</h1>`.
   - `nhat-ky.html`: dòng `<title>` (thay `[Tên sản phẩm]` bằng tên thật).
3. Xóa 3 mục VÍ DỤ trong `data/changelog.json` và thay bằng mục thật đầu tiên
   của nhóm mình khi có mốc hoàn thành.

### Nói gì với agent đầu tiên?

Không cần gõ lệnh gì đặc biệt. Chỉ cần nói bằng lời thường, ví dụ:

- "Con muốn làm trang web giới thiệu câu lạc bộ đọc sách của lớp mình, giúp
  các bạn xem được danh sách truyện và đăng ký mượn truyện."
- "Con muốn làm trang web bán đồ handmade của nhóm, có trang xem sản phẩm và
  trang ghi lại từng ngày nhóm đã làm được gì."

Agent sẽ tự hỏi thêm, cùng con điền bản mô tả sản phẩm, rồi tách thành từng
thẻ việc nhỏ để làm dần. Mỗi thẻ làm xong, nhớ kiểm tra đường link thật và
ghi 1 mục vào trang Nhật ký phát triển.
