# FLOW-GUIDE — Quy trình làm sản phẩm, bản rút gọn cho học viên

> Đây là bản tóm tắt quy trình FlowSkill để dùng khi máy chưa cài skill flow.
> Nếu máy đã cài skill, skill là bản đầy đủ; file này chỉ để tra cứu nhanh.
> Nguyên tắc chung: **mỗi stage đều có một cổng kiểm chứng, qua được cổng mới
> đi tiếp. Dừng ở cổng nào cũng là kết quả hợp lệ — không làm ẩu cho qua.**

## Các stage và cổng kiểm chứng

| Stage | Học viên làm gì | Cổng kiểm chứng (qua khi...) |
|---|---|---|
| 1. Idea (Ý tưởng) | Nói rõ sản phẩm giúp ai, giải quyết việc gì | Viết được 1 câu: "Sản phẩm giúp [ai] làm [việc gì]". |
| 2. Research (Tìm hiểu) | Xem 2–3 sản phẩm tương tự, ghi điều hay và điều dở | Ghi được ít nhất 2 điểm học được, có nguồn. |
| 3. Scope (Phạm vi) | Chọn 3–5 tính năng chính, gạch bỏ phần chưa làm | Danh sách tính năng vừa sức, phần "không làm" ghi rõ. |
| 4. PRD (Mô tả sản phẩm) | Điền `docs/SPEC-TEMPLATE.md` | Mọi mục đã điền, không còn ô trống hay chữ "sẽ tính sau". |
| 5. ADR (Quyết định kỹ thuật) | Ghi 1–3 quyết định lớn và lý do (ví dụ: dùng trang tĩnh vì đơn giản) | Mỗi quyết định có lý do và phương án đã loại bỏ. |
| 6. Contract (Hợp đồng xong) | Chốt tiêu chí "xong" cho toàn sản phẩm | Tiêu chí đo được, không chung chung ("đẹp", "hay"). |
| 7. Cards (Thẻ việc) | Tách sản phẩm thành thẻ việc nhỏ theo `docs/CARD-TEMPLATE.md` | Mỗi thẻ có tiêu chí nghiệm thu rõ ràng. |
| 8. Build (Làm) | Làm từng thẻ trên nhánh riêng | Code theo đúng thẻ, không làm thêm ngoài thẻ. |
| 9. Review (Soát lại) | Tự soát + giáo viên review PR | Hết lỗi hiển thị, đúng tiêu chí nghiệm thu, có mục nhật ký. |
| 10. Deploy (Đưa lên mạng) | Merge PR, trang production cập nhật | Mở được đường link thật, không chỉ chạy trên máy mình. |
| 11. Verify-live (Kiểm chứng trực tiếp) | Mở link thật trên điện thoại và máy tính | Mọi tính năng trong thẻ đều dùng được trên link thật. |
| 12. Retro (Nhìn lại) | Ghi 1 dòng: học được gì, còn vướng gì | Đã ghi, dù ngắn. |

## Quy tắc cổng ở 2 giai đoạn

- **Khởi động (stage 1–6): học viên tự xác nhận từng cổng.** Agent gợi ý và
  hỏi, nhưng không tự đánh dấu hoàn thành hay viết hộ.
- **Làm thẻ việc (stage 7–11): cổng tự qua khi kiểm chứng máy đạt**, và giáo
  viên review PR là cổng người cuối cùng trước khi merge.

## "Bằng chứng xong" nghĩa là gì

Không phải "em viết code rồi", mà là **đường link thật mở được + tính năng
dùng được trên link đó + mục nhật ký phát triển đã ghi**. Thiếu một trong ba
thì thẻ chưa xong.
