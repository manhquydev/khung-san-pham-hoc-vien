# AGENTS.md — Hướng dẫn cho agent làm việc với học viên trong repo này

> Đọc file này trước khi làm bất cứ việc gì. Học viên ở đây là học sinh lớp 7–10.
> Ngôn ngữ làm việc: tiếng Việt, lời dễ hiểu, không dùng từ chuyên môn khi giải thích
> cho học viên nếu chưa giải nghĩa.

## 1. Mọi yêu cầu làm sản phẩm đều đi qua FlowSkill — không cần học viên gõ /flow

- Học viên chỉ cần nói bằng lời thường điều mình muốn ("con muốn thêm trang
  giới thiệu", "làm cho nút này bấm được", ...).
- Agent tự đưa yêu cầu đó vào quy trình FlowSkill, ở chế độ teach (dạy học):
  `Idea → Research → Scope → PRD → ADR → Contract → Cards → Build → Review
  → Deploy → Verify-live → Retro`.
- Nếu máy đã cài skill flow, dùng đúng skill đó. Nếu chưa cài, làm theo bản rút gọn
  trong `docs/FLOW-GUIDE.md` — không tự bịa ra quy trình khác.
- **Đừng lẫn hai chữ "skill":** "skill flow" ở đây là skill của agent
  FlowSkill chạy quy trình trên, khác với "skill OMP" là skill học viên
  tự tạo/cài trong OMP để làm bài (khóa dạy ở HP2). Từ vựng quy trình
  nối sang từ của khóa như sau (bảng nối đầy đủ ở giáo án HP1 buổi 3):
  PRD = bản mô tả sản phẩm (SPEC), ADR = 1–3 dòng quyết định kèm lý do,
  Contract = tiêu chí xong, Cards = thẻ việc.
- **Agent luôn nói rõ mình đang ở đâu:** đầu mỗi câu trả lời, ghi rõ stage
  hiện tại và cổng vừa qua/chưa qua (ví dụ: "Đang ở stage Build, cổng Review
  chưa qua vì chưa có preview"). Cuối mỗi thẻ việc, ghi tiến độ stage vào
  phần "Nhìn lại" của thẻ để giáo viên kiểm tra được agent có chạy đúng
  flow thật không — flow chạy ngầm mà không ai thấy thì coi như chưa chạy.
- Không bao giờ làm tắt: không viết code trước khi có SPEC/card được duyệt, không
  coi "code chạy trên máy mình" là xong.

## 2. Giai đoạn khởi động: học viên phải xác nhận từng cổng — agent không tick hộ

- Các stage Idea → Research → Scope → PRD → ADR → Contract là nơi học viên HỌC
  cách nghĩ về sản phẩm, nên mỗi cổng (gate) chỉ được qua khi chính học viên
  xác nhận.
- Agent KHÔNG được tự đánh dấu hoàn thành, tự viết hộ SPEC/PRD, hay tự quyết
  phạm vi thay học viên. Agent được gợi ý, đặt câu hỏi, sửa theo ý học viên —
  nhưng quyết định cuối là của học viên.
- Nếu học viên chưa rõ, agent hỏi tối đa 3 câu một lượt, bằng lời dễ hiểu.

## 3. Giai đoạn làm thẻ việc: cổng tự qua khi kiểm chứng đạt, giáo viên là cổng người

- Từ stage Cards trở đi (Cards → Build → Review → Deploy → Verify), cổng được
  tự động qua khi kiểm chứng máy đạt (preview mở được, không lỗi hiển thị,
  đúng tiêu chí nghiệm thu của thẻ).
- Cổng người duy nhất còn lại là **giáo viên review PR trước khi merge**.
  Agent không merge khi chưa có review của giáo viên.

## 4. Mọi PR đã merge đều phải có 1 mục nhật ký phát triển

- Mỗi PR, khi merge, phải thêm đúng 1 mục nhật ký với:
  - `date`: ngày merge (định dạng YYYY-MM-DD).
  - `title`: một câu ngắn, lời dễ hiểu.
  - `description`: 1–2 câu giải thích cho PHỤ HUYNH hiểu sản phẩm đã thay đổi
    ra sao. Cấm từ chuyên môn chưa giải nghĩa (không viết "deploy", "refactor",
    "responsive", "API"... mà không nói rõ nghĩa).
  - `category`: một trong 4 nhãn: `Giao diện`, `Tính năng mới`, `Sửa lỗi`,
    `Cải tiến`.
  - `pr_url`: đường link tới PR đó, nếu có.
- **Cách thêm mục, người làm đã chốt** (xem `docs/roadmap.md`):
  - Học sinh viết sẵn nội dung mục (tiêu đề + mô tả + 1 trong 4 nhãn)
    trong mô tả PR. Học sinh không tự ghi lên production vì không giữ
    khóa giáo viên.
  - **Giáo viên POST mục đó lên production sau khi merge** bằng API
    `POST /api/changelog` kèm `TEACHER_KEY`. Từ Stage 1 tới Stage 2
    (HP1 buổi 8 tới buổi 10) cũng theo quy tắc này: giáo viên POST cho
    các PR đã merge, học sinh chỉ soạn nội dung.
  - Trường hợp chưa có D1 (chỉ khi giáo viên chưa làm xong phần chuẩn
    bị): thêm vào `public/data/changelog.json`. Sau khi đã lên D1 thì
    không sửa file JSON nữa, tránh hai nguồn dữ liệu lệch nhau. Trang
    nhật ký tự đọc từ D1 trước, chỉ khi API không dùng được mới dùng
    file JSON.
- Checklist này nằm trong mẫu PR (`.github/pull_request_template.md`) và agent
  phải kiểm tra nó trước khi xin review. Thiếu nội dung mục nhật ký
  trong mô tả PR = PR chưa xong (giáo viên đăng mục lên production sau
  khi merge).

## 5. Quy tắc database, secret và môi trường Windows

- **Mô hình tài khoản đã chốt: MỘT tài khoản Cloudflare do giáo viên
  đứng tên, mỗi nhóm một project Pages + một database D1 riêng trong
  tài khoản đó. Học viên KHÔNG tạo tài khoản Cloudflare, KHÔNG đăng nhập
  wrangler, KHÔNG giữ bất kỳ khóa nền tảng nào.** Giáo viên là người
  duy nhất giữ `TEACHER_KEY` và mọi secret kiểu `ADMIN_CODE` của
  project; deploy chạy qua Git (merge vào `main` là tự deploy), deploy
  bằng lệnh CLI là chỉ giáo viên làm.
- **Thay đổi database chỉ qua migration:** thêm/sửa bảng luôn bằng file
  migration mới (`migrations/0002_....sql`, ...), chạy
  `npx --yes wrangler d1 migrations apply DB --local` thử trên máy mình.
  Lệnh `--remote` (database thật của nhóm) là **CHỈ GIÁO VIÊN** chạy từ
  máy giáo viên. Không bao giờ sửa bảng trực tiếp trên Dashboard — sửa
  tay sẽ lệch với code trong repo và các bạn khác không chạy lại được.
- **Secret không bao giờ commit:** `TEACHER_KEY` và mọi khóa khác chỉ đặt
  bằng `npx --yes wrangler pages secret put` từ máy giáo viên, không viết
  vào `wrangler.toml`, code, hay chat. Học viên tập POST local bằng file
  `.dev.vars` (xem `.dev.vars.example`) — file thật không bao giờ commit,
  hết buổi giáo viên thu hồi hoặc đổi khóa. Khóa lộ thì báo ngay cho giáo
  viên đổi khóa.
- **Học viên Windows dùng PowerShell:** mọi lệnh trong tài liệu đều viết
  cho PowerShell, đường dẫn dùng dấu `\`. Chạy file `.ps1` bằng
  `powershell -ExecutionPolicy Bypass -File ...` (xem
  `docs/setup-windows.md`, phần chạy script kiểm tra).
- **Dấu xuống dòng:** repo đã có `.gitattributes` (`* text=auto`) để Git
  tự đổi dấu xuống dòng cho đúng từng hệ điều hành — không tự sửa file
  này, không commit file với dấu xuống dòng lạ gây nhiễu diff.

## 6. An toàn khóa và thông tin

- TUYỆT ĐỐI không dán khóa, mật khẩu, token vào repo, slide, hay khung chat
  chung. Khóa chỉ nằm ở biến môi trường do giáo viên quản lý — học viên
  không giữ khóa nền tảng nào, kể cả khóa của chính project nhóm mình.
- Không đưa thông tin cá nhân thật (số điện thoại, email, địa chỉ) vào repo.
  Chỉ dùng tên sản phẩm và tên nhóm dạng placeholder.
- Không đưa tên thật, ảnh, tên trường/lớp của học viên lên trang web công
  khai khi chưa có đồng ý của giáo viên và phụ huynh. Tên trên trang web
  luôn là tên sản phẩm, không phải tên học viên.

## 7. Cách làm việc với code

- Làm việc trên nhánh riêng (branch), mở PR, chờ review, rồi mới merge.
  Không bao giờ push thẳng lên nhánh `main`.
- Mỗi PR nhỏ, một việc. PR lớn, nhiều việc lẫn lộn thì tách ra.
- Trước khi xin review: tự kiểm tra preview mở được, trang nhật ký vẫn hiển thị
  đúng, không vỡ bố cục trên màn hình điện thoại.

## 8. "Xong" nghĩa là gì

- "Xong" = có đường link preview/production mở được, đúng tiêu chí nghiệm thu
  của thẻ việc, và đã có mục nhật ký phát triển. Chỉ viết code xong mà chưa
  có link chạy được thì CHƯA xong.
- Cuối mỗi buổi, agent cùng học viên ghi 1 dòng Retro ngắn: hôm nay học được
  gì, còn vướng gì — lưu vào PR hoặc nhật ký buổi của nhóm. Dòng Retro
  phải ghi rõ stage vừa xong và cổng đã qua, để giáo viên thấy được tiến
  độ flow (xem mục 1).

## 9. Phần nhóm bổ sung ở HP2 buổi 2 (nhóm điền — các mục khung 1–8 giữ nguyên)

Từ HP2 buổi 2, nhóm BỔ SUNG các mục dưới đây vào file này theo dự án
của nhóm, KHÔNG viết lại hay xóa các mục khung 1–8 ở trên. Đây là phần
của nhóm; các luật khung (cổng xác nhận, quy tắc nhật ký §4, quy tắc
migration/secret §5) vẫn giữ nguyên hiệu lực.

### 9.1. Vùng đỏ của dự án

[Nhóm liệt kê các vùng code/dữ liệu "cấm chạm" của riêng dự án mình —
ví dụ: file dữ liệu sản phẩm đã chốt, bảng đơn hàng đang chạy, khóa cấu
hình. Ai muốn sửa vùng đỏ phải hỏi cả nhóm + giáo viên trước.]

### 9.2. Vòng kiểm chứng của nhóm

[Nhóm ghi rõ vòng kiểm chứng mình dùng trước khi mở PR — ví dụ: chạy
lệnh nào, mở link nào, kiểm tra trên điện thoại ra sao, ai kiểm lại.]

### 9.3. Định dạng báo cáo agent

[Nhóm ghi rõ agent phải báo cáo kết quả theo định dạng nào — ví dụ:
đã làm gì / kiểm chứng ra sao / còn vướng gì — để cả nhóm đọc hiểu
được mà không cần hỏi lại.]
## 10. Project-info cho Showcase

Project-info là 1 file `public/data/project-info.json` nói cho phụ huynh
biết nhóm đang làm sản phẩm gì, tới mốc nào (M0–M3), xem thử ở đâu, ảnh
chụp ra sao. Trang Showcase của lớp đọc file này để hiện thẻ dự án của nhóm.

1. **Khi nào cập nhật project-info:** mỗi lần nhóm đạt 1 mốc (M0/M1/M2/M3)
   hoặc đổi tên/mô tả dự án; cập nhật file project-info cùng PR với công
   việc của mốc đó (không mở PR riêng chỉ để sửa file này, trừ khi chỉ sửa
   mô tả).
2. **Ai viết project-info:** học sinh viết nháp (agent hỗ trợ soạn câu cho
   phụ huynh hiểu); **giáo viên duyệt bằng cách merge PR** — file
   project-info chưa merge thì chưa hiện lên Showcase.
3. **Luật viết project-info cho phụ huynh:** mô tả 1–2 câu, không dùng từ
   chuyên môn chưa giải nghĩa (khớp §4: cấm "deploy", "refactor",
   "responsive", "API"... mà không nói rõ nghĩa); không tên thật học sinh,
   không ảnh học sinh, không số điện thoại, không email.
4. **Ảnh chụp:** file `public/screenshots/showcase.png` (tối đa 2MB, PNG/JPG),
   chụp từ trang chủ production; thay ảnh = commit file mới qua PR như code;
   ghi `screenshot_updated_at` trong project-info = ngày chụp.
5. **Cấm trong project-info:** không ghi key, token, mật khẩu vào file này;
   không ghi link ngoài `production_url` / `repo_url` / `screenshot_url`
   (không link mạng xã hội cá nhân).
6. **Mốc M0–M3 trong project-info:** mỗi mốc chỉ có 3 trạng thái — `todo`
   (chưa làm), `in_progress` (đang làm), `done` (đã xong); khi mốc xong thì
   ghi `date` là ngày xong thật (dạng YYYY-MM-DD), chưa xong thì để `date`
   là `null`. Đừng ghi ngày trong tương lai.
