# Giới hạn gói Free của Cloudflare — đọc trước khi deploy

> ⚠️ **CẢNH BÁO QUAN TRỌNG NHẤT: hạn mức tính theo TÀI KHOẢN, không tính
> theo từng project.**
>
> Nếu một tài khoản giáo viên chứa project của cả lớp, tất cả học viên
> **dùng chung** 100.000 request/ngày, 500 lượt build/tháng và các mức D1
> bên dưới. Lớp 8 học viên mà deploy dồn dập hoàn toàn có thể cạn lượt
> build trong tháng.
>
> **Khuyến nghị: mỗi học viên dùng tài khoản Cloudflare MIỄN PHÍ của riêng
> mình** (đăng ký không cần thẻ). Tài khoản giáo viên chỉ dùng để demo.
> Ở gói Free không gắn thẻ, vượt hạn mức thì request bị lỗi cho tới khi
> reset — **không phát sinh hóa đơn bất ngờ**.

Nguồn số liệu chính thức (truy cập và ghi lại ngày 25/10/2026):
- https://developers.cloudflare.com/workers/platform/limits/
- https://developers.cloudflare.com/workers/platform/pricing/

## Bảng hạn mức gói Free

### Workers (chạy code Functions — mọi API của sản phẩm đều tính vào đây)

| Hạng mục | Gói Free |
|---|---|
| Request | 100.000 request/ngày (reset lúc 0h UTC) |
| CPU mỗi lần chạy | 10 ms CPU — tính thời gian CPU, **không** tính thời gian chờ D1/mạng |
| Bộ nhớ | 128 MB |
| Gọi dịch vụ con mỗi request | 50 subrequest |
| Số Worker mỗi tài khoản | 100 |
| Biến môi trường mỗi Worker | 64 |

### Pages (chỗ chứa trang web tĩnh + Functions)

| Hạng mục | Gói Free |
|---|---|
| Lượt build | 500 lượt/tháng |
| Build chạy cùng lúc | 1 |
| Thời gian build tối đa | 20 phút/lượt |
| File mỗi lần deploy | 20.000 file |
| File lớn nhất | 25 MiB |
| Số project mỗi tài khoản | 100 |
| Request + băng thông cho file tĩnh | **Không giới hạn** |

Lưu ý: Pages Functions dùng chung hạn mức Workers ở trên, không có hạn mức
riêng. Trang tĩnh (HTML/CSS/JS/JSON) thì không tốn request Workers.

### D1 (database)

| Hạng mục | Gói Free |
|---|---|
| Dòng đọc/ngày | 5.000.000 dòng |
| Dòng ghi/ngày | 100.000 dòng |
| Tổng dung lượng | 5 GB |
| Mỗi database tối đa | 500 MB |

**D1 tính số dòng QUÉT, không tính số dòng trả về.** Ví dụ: bảng có 10.000
dòng mà câu truy vấn không dùng index, mỗi lần đọc có thể quét cả 10.000
dòng. Vì vậy bảng `changelog` đã có index theo ngày (`migrations/0001_changelog.sql`)
— đừng xóa index đó, và đừng viết truy vấn quét toàn bảng khi bảng đã lớn.

### KV (bộ nhớ key-value, dùng ở Stage 4 nếu cần cache)

| Hạng mục | Gói Free |
|---|---|
| Đọc/ngày | 100.000 |
| Ghi/xóa/liệt kê/ngày | 1.000 |
| Dung lượng | 1 GB |

### R2 (chỗ chứa file, ví dụ ảnh upload — Stage 4, tùy chọn)

| Hạng mục | Gói Free |
|---|---|
| Dung lượng | 10 GB |
| Tác vụ loại A/tháng (ghi, liệt kê...) | 1.000.000 |
| Tác vụ loại B/tháng (đọc...) | 10.000.000 |
| Phí tải file ra ngoài | 0 (không tính egress) |

## Sản phẩm học viên thì vừa hay không vừa?

**Vừa thoải mái:**
- Trang web giới thiệu, trang nhật ký, trang sản phẩm tĩnh: request tĩnh
  không giới hạn, gần như không tốn gì.
- Nhật ký đọc từ D1: mỗi lần mở trang nhật ký = 1 request Workers + số
  dòng quét bằng đúng số mục nhật ký (nhờ index). Lớp 8 học viên, mỗi
  người vài chục lượt xem/ngày thì chỉ tốn vài trăm request/ngày.
- Ghi nhật ký qua API: mỗi lần ghi = 1 request + 1 dòng ghi. Cả lớp ghi
  vài chục mục/ngày thì không đáng kể so với mức 100.000 dòng ghi/ngày.

**Không vừa / cần tránh:**
- Làm mới trang liên tục (auto-refresh mỗi giây) hoặc vòng lặp gọi API:
  1 học viên refresh mỗi giây trong 1 giờ đã tốn 3.600 request.
- Ảnh/video nặng đưa thẳng vào repo: file tối đa 25 MiB, deploy tối đa
  20.000 file. Ảnh sản phẩm nên nén nhỏ trước khi đưa lên; video nên để
  link ngoài (YouTube) thay vì nhét vào repo.
- Cả lớp deploy dồn vào một tài khoản: 500 lượt build/tháng chia cho 8
  người chỉ còn ~60 lượt/người/tháng — deploy liên tục khi sửa lỗi vặt sẽ
  cạn nhanh. Mỗi người một tài khoản thì mỗi người có đủ 500 lượt.
- Chạy tác vụ nặng trên Functions (xử lý ảnh, vòng lặp lớn): CPU chỉ
  10 ms/lần chạy, việc nặng sẽ bị ngắt giữa chừng.

## Cách xem mình đã dùng bao nhiêu

- **Workers/Pages:** Cloudflare Dashboard → Account → Usage, hoặc vào
  Workers & Pages → chọn project → Metrics (số request theo ngày).
- **D1:** Dashboard → D1 → chọn database → Metrics (dòng đọc/ghi).
- **Build:** Dashboard → Pages → project → Deployments (đếm số lần deploy
  trong tháng).

Giáo viên nên xem mục Usage một lần mỗi tuần trong thời gian lớp deploy
nhiều, để nhắc học viên trước khi chạm hạn mức.

## Khi chạm hạn mức thì sao?

- Gói Free **không gắn thẻ**: request vượt mức sẽ lỗi (thường là lỗi 1027
  hoặc trang báo quá tải) cho tới khi hạn mức reset (request/ngày reset
  0h UTC, build/tháng reset đầu tháng). Không có hóa đơn.
- Cách xử lý: chờ reset, giảm tần suất gọi API, hoặc chia project sang
  tài khoản khác. Đừng gắn thẻ để "mở thêm hạn mức" khi chưa có sự đồng ý
  của phụ huynh/giáo viên.
