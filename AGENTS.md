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

- Mỗi PR, khi merge, phải thêm đúng 1 mục vào `data/changelog.json` với:
  - `date`: ngày merge (định dạng YYYY-MM-DD).
  - `title`: một câu ngắn, lời dễ hiểu.
  - `description`: 1–2 câu giải thích cho PHỤ HUYNH hiểu sản phẩm đã thay đổi
    ra sao. Cấm từ chuyên môn chưa giải nghĩa (không viết "deploy", "refactor",
    "responsive", "API"... mà không nói rõ nghĩa).
  - `category`: một trong 4 nhãn: `Giao diện`, `Tính năng mới`, `Sửa lỗi`,
    `Cải tiến`.
  - `pr_url`: đường link tới PR đó, nếu có.
- Checklist này nằm trong mẫu PR (`.github/pull_request_template.md`) và agent
  phải kiểm tra nó trước khi xin review. Thiếu mục nhật ký = PR chưa xong.

## 5. An toàn khóa và thông tin

- TUYỆT ĐỐI không dán khóa, mật khẩu, token vào repo, slide, hay khung chat
  chung. Khóa chỉ nằm ở biến môi trường do giáo viên quản lý.
- Không đưa thông tin cá nhân thật (số điện thoại, email, địa chỉ) vào repo.
  Chỉ dùng tên sản phẩm và tên nhóm dạng placeholder.

## 6. Cách làm việc với code

- Làm việc trên nhánh riêng (branch), mở PR, chờ review, rồi mới merge.
  Không bao giờ push thẳng lên nhánh `main`.
- Mỗi PR nhỏ, một việc. PR lớn, nhiều việc lẫn lộn thì tách ra.
- Trước khi xin review: tự kiểm tra preview mở được, trang nhật ký vẫn hiển thị
  đúng, không vỡ bố cục trên màn hình điện thoại.

## 7. "Xong" nghĩa là gì

- "Xong" = có đường link preview/production mở được, đúng tiêu chí nghiệm thu
  của thẻ việc, và đã có mục nhật ký phát triển. Chỉ viết code xong mà chưa
  có link chạy được thì CHƯA xong.
- Cuối mỗi buổi, agent cùng học viên ghi 1 dòng Retro ngắn: hôm nay học được
  gì, còn vướng gì — lưu vào PR hoặc nhật ký buổi của nhóm.
