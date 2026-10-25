# Lộ trình đi dần từ tĩnh sang full-stack

Khung này cố tình **không** nhét full-stack vào ngày đầu. Mỗi stage là một
bài học riêng, làm xong stage trước mới sang stage sau. Học viên nào cũng
đi qua Stage 0; các stage sau đi theo tiến độ của lớp.

> Nhắc lại quy tắc hạn mức (xem `docs/gioi-han-free.md`): hạn mức tính theo
> **tài khoản**. Mỗi học viên dùng tài khoản Cloudflare miễn phí của riêng
> mình; tài khoản giáo viên chỉ để demo.

## Stage 0 — Trang tĩnh + file JSON (bắt đầu ở đây)

- **Có gì:** `index.html`, `nhat-ky.html`, `nhat-ky.js` đọc
  `data/changelog.json`, hiển thị nhật ký theo ngày, lời dễ hiểu cho phụ huynh.
- **Thay đổi so với trước:** không có — đây là bản khung v1.
- **Kiểm chứng:** deploy qua Dashboard (xem `docs/setup-windows.md` bước 10),
  mở đường link `*.pages.dev`, mở trang Nhật ký thấy 3 mục ví dụ.
- **Tốn hạn mức:** gần như 0. File tĩnh không giới hạn request/băng thông.
  Chỉ tốn lượt build (500 lượt/tháng/tài khoản).

## Stage 1 — Functions đọc từ database D1

- **Thay đổi:** tạo database D1 (`wrangler d1 create`), điền `database_id`
  vào `wrangler.toml`, chạy migration (`migrations/0001_changelog.sql`) và
  seed (`migrations/seed.sql`). Trang nhật ký **tự động** gọi
  `/api/changelog` trước, không cần sửa `nhat-ky.js`.
- **Kiểm chứng:** mở `/api/health` thấy `d1_configured: true`; mở trang
  Nhật ký thấy đúng 3 mục ví dụ; xóa file `data/changelog.json` khỏi bản
  deploy thử (hoặc đổi tên tạm) mà trang vẫn hiện đủ mục — chứng tỏ trang
  đang đọc từ D1 thật, không còn đọc file cũ.
- **Tốn hạn mức (ước tính):** mỗi lần mở trang nhật ký = 1 request
  Workers + số dòng D1 quét bằng đúng số mục nhật ký (nhờ index theo
  ngày). Lớp 8 học viên, mỗi người vài chục lượt xem/ngày: vài trăm
  request/ngày, không đáng kể so với mức 100.000/ngày.

## Stage 2 — Ghi nhật ký qua API có khóa giáo viên

- **Thay đổi:** đặt secret `TEACHER_KEY` bằng
  `wrangler pages secret put TEACHER_KEY` (không viết khóa vào repo).
  Từ đây, thêm mục nhật ký bằng cách POST tới `/api/changelog` kèm header
  `x-teacher-key` thay vì sửa file JSON tay.
- **Kiểm chứng:** POST không kèm khóa phải bị từ chối (401); POST kèm
  khóa đúng thì mục mới hiện lên trang Nhật ký; mở `/api/health` thấy
  `teacher_key_configured: true`.
- **Lưu ý trung thực:** đây là cổng giữ lớp học, **không phải hệ thống
  đăng nhập thật**. Ai biết khóa đều ghi được. Khóa chỉ nằm ở giáo viên,
  và mọi mục ghi vào vẫn phải qua review PR trước khi coi là chính thức.
- **Tốn hạn mức (ước tính):** mỗi lần ghi = 1 request + 1 dòng ghi D1.
  Cả lớp ghi vài chục mục/ngày là không đáng kể so với mức
  100.000 dòng ghi/ngày.

## Stage 3 — Tính năng riêng của từng sản phẩm

- **Thay đổi:** mỗi nhóm tự thêm tính năng của sản phẩm mình (form đăng ký,
  danh sách sản phẩm, tìm kiếm...) theo mẫu đã học: **thêm bảng mới bằng
  file migration mới** (`migrations/0002_....sql`), thêm Function mới
  trong `functions/api/`, thêm trang mới. Không sửa bảng `changelog` đang
  chạy bằng cách sửa tay trên Dashboard.
- **Kiểm chứng:** tính năng mới có SPEC/card riêng, có preview thật, có
  mục nhật ký, qua review PR của giáo viên.
- **Tốn hạn mức:** tùy tính năng. Nguyên tắc: đọc có index, không quét
  toàn bảng; không gọi API trong vòng lặp; không auto-refresh mỗi giây
  (1 người refresh mỗi giây trong 1 giờ đã tốn 3.600 request).

## Stage 4 — Tùy chọn nâng cao (chỉ khi lớp đã vững)

- **Upload file lên R2:** ảnh sản phẩm, file đính kèm. Gói Free: 10 GB,
  1 triệu tác vụ ghi/tháng, 10 triệu tác vụ đọc/tháng, không phí tải ra.
  Ảnh phải nén nhỏ trước khi upload (file deploy tối đa 25 MiB).
- **KV làm cache:** lưu kết quả tính sẵn để đỡ gọi D1. Gói Free:
  100.000 đọc/ngày, 1.000 ghi/ngày — ghi ít, đọc nhiều mới hợp.
- **Đăng nhập thật:** thay khóa giáo viên bằng hệ thống tài khoản thật
  (ví dụ Cloudflare Access hoặc đăng nhập bằng email). Đây là mốc riêng,
  không làm chung với Stage 2, và cần giáo viên duyệt thiết kế trước vì
  liên quan tới thông tin học viên.

## Khi nào thì KHÔNG lên stage tiếp theo?

- Trang ở stage hiện tại còn lỗi hiển thị trên điện thoại.
- Học viên chưa giải thích được bằng lời của mình stage hiện tại chạy ra sao.
- Lớp đang deploy dồn dập và sắp chạm 500 lượt build/tháng của tài khoản.

Lên stage là để học thêm, không phải để chạy đua. Một sản phẩm Stage 1
chạy tốt và có nhật ký đẹp vẫn hơn sản phẩm Stage 3 chắp vá.
