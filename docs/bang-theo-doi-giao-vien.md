# Bảng theo dõi của giáo viên — một tài khoản, mỗi nhóm một project

Bảng này là **nơi duy nhất** giáo viên ghi lại project nào thuộc nhóm
nào. Điền trước khi học viên clone (xem `docs/setup-windows.md`
phần 0, "Giáo viên chuẩn bị trước").

> ⚠️ **TUYỆT ĐỐI KHÔNG ghi giá trị khóa vào bảng này.** Chỉ ghi dấu
> xác nhận "đã đặt" (✓) — giá trị khóa chỉ sống trong Pages project
> (đặt bằng `wrangler pages secret put`) và trong đầu giáo viên.

## Tài khoản dùng chung

- Tài khoản Cloudflare: tài khoản của giáo viên (gói miễn phí, không thẻ).
- Học viên không tạo tài khoản Cloudflare, không giữ khóa nền tảng nào.

## Theo dõi theo nhóm

| Nhóm | Repo GitHub của nhóm | Tên project Pages | Tên database D1 | `database_id` đã điền vào `wrangler.toml` | `TEACHER_KEY` đã đặt bằng `secret put` | Đã nối Git (Dashboard) | Đã chạy migration + seed remote | Hồ sơ đồng ý phụ huynh (tham chiếu) |
|---|---|---|---|---|---|---|---|---|
| Nhóm 1 | | | | ☐ | ☐ | ☐ | ☐ | |
| Nhóm 2 | | | | ☐ | ☐ | ☐ | ☐ | |

Thêm dòng nếu lớp có hơn 2 nhóm. Mỗi nhóm một dòng — không dùng chung
project hay database giữa các nhóm.

## Checklist trước buổi đầu (mỗi nhóm)

1. ☐ Project Pages của nhóm đã tạo trong tài khoản giáo viên.
2. ☐ Database D1 của nhóm đã tạo.
3. ☐ `wrangler.toml` trong repo nhóm đã điền đúng `name`,
   `database_name`, `database_id` và đã commit lên `main`.
4. ☐ `TEACHER_KEY` đã đặt cho project bằng `secret put` (từ máy giáo viên).
5. ☐ Repo nhóm đã nối với project qua Dashboard — **chỉ nối sau khi
   `database_id` đã điền thật, tuyệt đối không nối khi còn TO-FILL.**
6. ☐ Migration + seed remote đã chạy — mở `https://<ten-project>.pages.dev/`
   thấy trang chủ, trang Nhật ký đủ 3 mục ví dụ, `/api/health` báo
   `d1_configured: true`.
7. ☐ Đường link repo + đường link `*.pages.dev` đã đưa cho nhóm.

## Cuối khóa — thu hồi và dọn dẹp

1. ☐ Đổi hoặc xóa `TEACHER_KEY` của từng project (Dashboard → Pages
   project → Settings → Environment variables, hoặc đặt lại bằng
   `secret put` với giá trị mới rồi thu hồi giá trị cũ).
2. ☐ Ngắt kết nối Git của project nếu không dùng tiếp, hoặc giữ nguyên
   nếu nhóm được giữ sản phẩm — quyết theo thông báo phụ huynh
   (`docs/thong-bao-phu-huynh.md`).
3. ☐ Thu hồi file `.dev.vars` trên mọi máy học viên đã từng tập POST local
   (xóa file, không để khóa local sót lại).
4. ☐ Xóa quyền truy cập repo của học viên đã rời lớp (nếu áp dụng).
