# Lộ trình đi dần từ tĩnh sang full-stack

Khung này cố tình **không** nhét full-stack vào ngày đầu. Mỗi stage là một
bài học riêng, làm xong stage trước mới sang stage sau. Học viên nào cũng
đi qua Stage 0; các stage sau đi theo tiến độ của lớp.

> Nhắc lại quy tắc hạn mức (xem `docs/gioi-han-free.md`): hạn mức tính theo
> **tài khoản**. Mô hình đã chốt: **MỘT tài khoản Cloudflare do giáo viên
> đứng tên, mỗi nhóm một project Pages + một database D1 riêng trong tài
> khoản đó**. Học viên không tạo tài khoản Cloudflare và không giữ khóa
> nền tảng nào — cả lớp dùng chung hạn mức của tài khoản giáo viên, với
> 2 nhóm thì vẫn dư dả.

## Stage 0 — Trang đã chạy trên Pages với Functions + D1 (bắt đầu ở đây)

- **Có gì:** `public/index.html`, `public/nhat-ky.html`,
  `public/nhat-ky.js` gọi `/api/changelog` trước, hiển thị nhật ký
  theo ngày, lời dễ hiểu cho phụ huynh. File
  `public/data/changelog.json` vẫn còn trong repo nhưng chỉ là
  **dự phòng khi API không dùng được** — không phải nguồn chính.
- **Vì sao không còn là "tĩnh + JSON":** trước khi học viên clone,
  giáo viên đã làm xong phần chuẩn bị (xem `docs/setup-windows.md`
  phần 0): tạo database D1, điền `database_id` vào `wrangler.toml`,
  chạy migration (`migrations/0001_changelog.sql`) + seed
  (`migrations/seed.sql`) trên database thật, đặt `TEACHER_KEY`, nối
  repo nhóm với project Pages. Nên deploy đầu tiên đã có Functions +
  D1, trang nhật ký đọc từ D1 ngay từ buổi đầu.
- **Kiểm chứng:** giáo viên đã nối repo nhóm với project Pages qua
  Dashboard ở phần chuẩn bị — merge vào `main` là tự deploy; mở đường
  link `*.pages.dev`, mở trang Nhật ký thấy 3 mục ví dụ từ database
  của nhóm.
- **Tốn hạn mức:** mỗi lần mở trang Nhật ký = 1 request Workers (gọi
  API trước). File tĩnh không giới hạn request/băng thông. Chỉ tốn
  lượt build (500 lượt/tháng/tài khoản).

## Stage 1 — Hiểu và tập trên máy mình cái đã chạy sẵn trên production

- **Thay đổi:** không có thay đổi nào trên production ở stage này —
  D1, migration, seed và Functions đã có từ phần chuẩn bị (xem
  `docs/setup-windows.md` phần 0). Stage 1 là lúc học viên HIỂU cơ chế
  đang chạy sẵn đó và TẬP trên máy mình: chạy migration trên database
  **local**, không chạy lệnh remote. Trang nhật ký **đã** gọi
  `/api/changelog` trước từ deploy đầu, không cần sửa
  `public/nhat-ky.js`.
- **Ai ghi mục nhật ký trong khoảng từ Stage 1 tới Stage 2:** học sinh
  chỉ SOẠN nội dung mục (tiêu đề + mô tả + 1 trong 4 nhãn) trong mô tả
  PR; **giáo viên là người POST mục đó lên production sau khi merge**
  (xem `AGENTS.md` mục 4). Học sinh không tự POST lên production vì
  không giữ `TEACHER_KEY`, và từ khi đã lên D1 thì không sửa file JSON
  nữa. Quy tắc này áp dụng cho mọi PR đã merge từ khi D1 lên sóng
  (HP1 buổi 8) tới khi lớp học POST ở Stage 2 (HP1 buổi 10).
- **Kiểm chứng:** mở `/api/health` thấy `d1_configured: true`; mở trang
  Nhật ký thấy đúng 3 mục ví dụ. Bài kiểm chứng API-first sau đây
  **do GIÁO VIÊN làm, học viên không deploy:** đổi tên tạm
  `public/data/changelog.json` thành `changelog.json.bak`, deploy thử,
  thấy trang vẫn hiện đủ mục — chứng tỏ trang đang đọc từ D1 thật,
  không còn đọc file cũ — rồi đổi tên lại ngay. **Không bao giờ xóa
  hẳn file dự phòng.** Bài này chứng minh trang đọc API trước, không
  phải là "chuyển stage" — stage không đổi vì D1 đã chạy từ đầu. Khi
  test API trên máy, nhớ quirk: `npx --yes wrangler d1 migrations
  apply DB --local` và `npx --yes wrangler pages dev --d1` dùng hai file database
  local khác nhau, nên phải seed đúng store mà dev server đang dùng
  (xem `docs/setup-windows.md` phần Stage 1/2).
- **Tốn hạn mức (ước tính):** mỗi lần mở trang nhật ký = 1 request
  Workers + số dòng D1 quét bằng đúng số mục nhật ký (nhờ index theo
  ngày). Lớp 8 học viên, mỗi người vài chục lượt xem/ngày: vài trăm
  request/ngày, không đáng kể so với mức 100.000/ngày.

## Stage 2 — Ghi nhật ký qua API có khóa giáo viên

- **Thay đổi:** giáo viên đặt secret `TEACHER_KEY` bằng
  `npx --yes wrangler pages secret put TEACHER_KEY --project-name
  <ten-project-cua-nhom>` từ **máy giáo viên**, một lần cho mỗi project
  (đã làm ở phần chuẩn bị, xem `docs/setup-windows.md` phần 0). Từ đây,
  thêm mục nhật ký bằng cách POST tới `/api/changelog` kèm header
  `x-teacher-key` thay vì sửa file JSON tay (ví dụ lệnh PowerShell đầy
  đủ ở phần Stage 1/2 của `docs/setup-windows.md`; học viên tập POST
  trên dev server local với `.dev.vars`, không giữ khóa thật).
- **Kiểm chứng:** POST không kèm khóa phải bị từ chối (401); POST kèm
  khóa đúng thì mục mới hiện lên trang Nhật ký; mở `/api/health` thấy
  `teacher_key_configured: true`.
- **Lưu ý trung thực:** đây là cổng giữ lớp học, **không phải hệ thống
  đăng nhập thật**. Ai biết khóa đều ghi được. Và nói thẳng một điểm
  khác với bản roadmap cũ: POST ghi **thẳng** vào D1 production, không
  đi qua PR — nên ở Stage 2, review PR không còn là cổng kiểm soát mục
  nhật ký nữa. Thay vào đó, giáo viên rà soát trang nhật ký trực tiếp
  hằng tuần; mục nào sai thì **giáo viên** xóa bằng lệnh (chạy ở thư mục
  repo trên máy giáo viên, đã đăng nhập wrangler bằng tài khoản giáo viên):

```powershell
npx --yes wrangler d1 execute DB --remote --command "DELETE FROM changelog WHERE id = <id-muc-sai>;"
```

  Khóa chỉ nằm ở giáo viên, và việc rà soát hằng tuần này là cổng người
  thật của Stage 2 — đừng tưởng PR review vẫn đang giữ mục nhật ký.
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

## Bảng map stage ↔ buổi học (đề xuất, giáo viên điều chỉnh)

Buổi học dưới đây lấy từ khung chương trình khóa "Build website bằng AI"
(2 học phần × 12 buổi). Bảng này là **đề xuất pacing** — giáo viên điều
chỉnh theo tiến độ lớp thật, nhưng đừng dạy stage sau khi stage trước
chưa vững (xem mục "Khi nào thì KHÔNG lên stage tiếp theo?" bên dưới).

| Stage | Buổi học gợi ý | Vì sao đặt ở đó |
|---|---|---|
| Stage 0 — tĩnh + JSON, deploy đầu | HP1 buổi 1 (tạo repo, cài máy) → HP1 buổi 5 (M0: deploy "hello" lên môi trường kiểm thử) | Buổi 1 lập repo và quy trình, buổi 5 là lần đầu sản phẩm có URL thật — đúng lúc khung tĩnh phát huy tác dụng. |
| Stage 1 — Functions đọc D1 | Không có buổi học riêng: đây là trạng thái deploy đã có từ trước buổi 1 (giáo viên chuẩn bị ở phần 0); học viên TẬP và HIỂU nó ở HP1 buổi 8 khi học phía máy chủ | Buổi 8 là lần đầu khung chương trình dạy phía máy chủ (bảng orders, binding `ORDERS_DB`), nên là lúc thích hợp để học viên hiểu cơ chế API/D1 đã chạy sẵn từ đầu khóa — chứ buổi 8 không dạy mới nội dung Stage 1 (API changelog, migration, health). |
| Stage 2 — ghi qua API có khóa | HP1 buổi 10 (hoàn thiện sản phẩm, không học kiến thức mới) | Buổi 10 không nhồi kiến thức mới nên có thời gian chuẩn hóa quy trình ghi nhật ký; từ đây mục nhật ký đi qua API thay vì sửa file. |
| Stage 3 — tính năng riêng | HP1 buổi 8 (bảng orders) và HP2 buổi 5–8 (graph, MCP, đa agent, kiểm thử & QA) | HP1 buổi 6–7 là tĩnh (trang chủ, danh mục + file dữ liệu), chỉ buổi 8 mới thêm bảng và Function; khung chỉ quy định cách thêm bảng (migration mới) và Function mới. |
| Stage 4 — R2 / KV / đăng nhập thật | HP2 buổi 8 (nhánh mở rộng tự chọn) và HP2 buổi 10–11 (hoàn thiện, tự tạo skill/hook) | Chỉ dành cho nhóm đã vững; lưu ý nội dung mặc định của nhánh mở rộng HP2 buổi 8 trong khóa là thanh toán sandbox — R2/KV/đăng nhập thật chỉ là phương án mở rộng, không phải nội dung mặc định của buổi đó. Đăng nhập thật cần giáo viên duyệt thiết kế trước vì liên quan tới thông tin học viên. |

Lưu ý: Stage 0–2 là đường đi chung bắt buộc của khung; Stage 3–4 diễn
ra trong chính các buổi build của khóa, không phải buổi riêng.

## Khi nào thì KHÔNG lên stage tiếp theo?

- Trang ở stage hiện tại còn lỗi hiển thị trên điện thoại.
- Học viên chưa giải thích được bằng lời của mình stage hiện tại chạy ra sao.
- Lớp đang deploy dồn dập và sắp chạm 500 lượt build/tháng của tài khoản.

Lên stage là để học thêm, không phải để chạy đua. Một sản phẩm Stage 1
chạy tốt và có nhật ký đẹp vẫn hơn sản phẩm Stage 3 chắp vá.
