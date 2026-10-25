-- Dữ liệu VÍ DỤ cho bảng changelog — khớp với data/changelog.json (Stage 0).
-- Chạy: wrangler d1 execute DB --remote --file migrations/seed.sql
-- Khi nhóm đã có mục nhật ký thật đầu tiên, XÓA 3 dòng ví dụ này:
--   DELETE FROM changelog WHERE tieu_de LIKE 'VÍ DỤ%';
INSERT INTO changelog (ngay, tieu_de, mo_ta, loai, pr_url, created_at) VALUES
  ('2026-10-20', 'VÍ DỤ — Trang chủ đầu tiên đã lên mạng', 'VÍ DỤ, hãy thay bằng mục thật: hôm nay trang web của con đã có trang chủ với tên sản phẩm và lời giới thiệu ngắn, ai mở đường link cũng xem được.', 'Tính năng mới', NULL, '2026-10-20'),
  ('2026-10-21', 'VÍ DỤ — Trang web nhìn đẹp hơn trên điện thoại', 'VÍ DỤ, hãy thay bằng mục thật: hôm nay con đã chỉnh lại cách trình bày để trang web hiển thị gọn gàng trên màn hình điện thoại, chữ không bị tràn ra ngoài nữa.', 'Giao diện', NULL, '2026-10-21'),
  ('2026-10-22', 'VÍ DỤ — Sửa lỗi đường link bị hỏng', 'VÍ DỤ, hãy thay bằng mục thật: hôm nay con phát hiện nút bấm dẫn tới trang nhật ký bị hỏng, đã sửa lại để bấm vào là mở được trang.', 'Sửa lỗi', NULL, '2026-10-22');
