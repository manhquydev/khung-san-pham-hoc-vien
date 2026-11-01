-- Migration 0002: bảng đơn hàng (orders) trong D1.
-- Câu chuyện đã chốt: GIÁO VIÊN chạy migration này khi chuẩn bị trước
-- khóa (cùng lúc với migration 0001 ở bước G5, xem docs/setup-windows.md);
-- ở HP1 buổi 8, học sinh chỉ ĐỌC HIỂU bảng này, không chạy lại file tạo
-- bảng. Mọi thay đổi cấu trúc bảng sau đó — kể cả bảng orders — đều qua
-- file migration mới (0003_....sql, ...), KHÔNG sửa trực tiếp trên
-- Dashboard. Nội dung bảng theo giáo án HP1 Phụ lục F.1.
-- Áp dụng: npx --yes wrangler d1 migrations apply DB --local (thử trên máy)
-- rồi npx --yes wrangler d1 migrations apply DB --remote (lên Cloudflare).

CREATE TABLE IF NOT EXISTS orders (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  customer    TEXT    NOT NULL,   -- tên khách (DỮ LIỆU GIẢ)
  phone       TEXT,               -- số điện thoại GIẢ do nhóm tự nghĩ ra khi test
  items       TEXT    NOT NULL,   -- danh sách sản phẩm + số lượng (ghi dạng chữ/JSON đơn giản)
  total       INTEGER NOT NULL,   -- tổng tiền (đồng), tính từ dữ liệu sản phẩm
  created_at  TEXT    NOT NULL DEFAULT (datetime('now'))
);
