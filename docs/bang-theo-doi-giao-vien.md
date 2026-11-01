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

| Nhóm | Repo GitHub của nhóm | Tên project Pages | Tên database D1 | `database_id` đã điền vào `wrangler.toml` | `TEACHER_KEY` đã đặt bằng `secret put` | `ADMIN_CODE` đã đặt cho nhóm (mã mở trang quản trị đơn) | Đã nối Git (Dashboard) | Đã chạy migration + seed remote | Hồ sơ đồng ý phụ huynh (tham chiếu) |
|---|---|---|---|---|---|---|---|---|---|
| Nhóm 1 | | | | ☐ | ☐ | ☐ | ☐ | ☐ | |
| Nhóm 2 | | | | ☐ | ☐ | ☐ | ☐ | ☐ | |

Thêm dòng nếu lớp có hơn 2 nhóm. Mỗi nhóm một dòng — không dùng chung
project hay database giữa các nhóm. **Mỗi nhóm một `TEACHER_KEY`
riêng, không dùng chung** — lộ khóa nhóm này không được mở cổng ghi
của nhóm kia. **`ADMIN_CODE` và `TEACHER_KEY` là hai khóa khác nhau,
không dùng chung giá trị** (xem hộp hai khóa trong `README.md`):
`ADMIN_CODE` mở trang quản trị đơn hàng (học sinh được biết),
`TEACHER_KEY` bảo vệ cổng ghi nhật ký (chỉ giáo viên giữ).

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
8. ☐ Template đã mở công khai cho lớp trước khi đưa link cho nhóm
   (nếu chưa mở, học viên gặp 404 ở bước clone).

## Sao lưu D1 định kỳ (giáo viên làm)

Runbook sự cố giả định luôn có "bản sao lưu gần nhất" — bản sao lưu đó
chỉ có nếu giáo viên xuất D1 định kỳ. Mỗi nhóm xuất một lần theo lịch
dưới đây, từ máy giáo viên (đã đăng nhập wrangler bằng tài khoản giáo viên):

```powershell
npx --yes wrangler d1 export DB --remote --output <tên-file-sao-lưu>.sql
```

- Tần suất xuất: [giáo viên điền, ví dụ: mỗi tuần một lần]
- Nơi lưu bản sao lưu: [giáo viên điền]
- Lần xuất gần nhất — Nhóm 1 (ngày + tên file):
- Lần xuất gần nhất — Nhóm 2 (ngày + tên file):

## Cuối khóa — thu hồi và dọn dẹp

1. ☐ Đổi hoặc xóa `TEACHER_KEY` của từng project (Dashboard → Pages
   project → Settings → Environment variables, hoặc đặt lại bằng
   `secret put` với giá trị mới rồi thu hồi giá trị cũ). Sau khi đổi,
   kiểm chứng khóa cũ đã chết: thử POST bằng khóa cũ, phải nhận 401;
   thử GET `/api/health` vẫn thấy `teacher_key_configured` là true
   với khóa mới.
2. ☐ Ngắt kết nối Git của project nếu không dùng tiếp, hoặc giữ nguyên
   nếu nhóm được giữ sản phẩm — quyết theo thông báo phụ huynh
   (`docs/thong-bao-phu-huynh.md`).
3. ☐ Thu hồi file `.dev.vars` trên mọi máy học viên đã từng tập POST local
   (xóa file, không để khóa local sót lại).
4. ☐ Xóa quyền truy cập repo của học viên đã rời lớp (nếu áp dụng).
