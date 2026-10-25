-- Migration 0001: bảng nhật ký phát triển.
-- Quy tắc: mọi thay đổi cấu trúc bảng chỉ qua file migration mới
-- (0002_....sql, 0003_....sql, ...), KHÔNG sửa trực tiếp trên Dashboard.
-- Áp dụng: wrangler d1 migrations apply DB --local (thử trên máy)
-- rồi wrangler d1 migrations apply DB --remote (lên Cloudflare).

CREATE TABLE IF NOT EXISTS changelog (
  id INTEGER PRIMARY KEY,
  ngay TEXT NOT NULL,
  tieu_de TEXT NOT NULL,
  mo_ta TEXT NOT NULL,
  loai TEXT NOT NULL,
  pr_url TEXT,
  created_at TEXT NOT NULL DEFAULT ''
);

-- Trang nhật ký luôn đọc theo ngày mới nhất trước, nên đánh index theo ngày.
-- D1 tính số dòng QUÉT (không phải số dòng trả về), index này giữ chi phí đọc thấp.
CREATE INDEX IF NOT EXISTS idx_changelog_ngay ON changelog (ngay DESC, id DESC);
