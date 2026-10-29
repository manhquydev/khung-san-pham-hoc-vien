# Mẫu nhật ký vòng lặp điều phối (HP2 buổi 3)

> Mỗi đầu việc chạy theo vòng lặp observe → plan → act → verify: observe
> là đọc SPEC, dữ liệu và trạng thái hiện tại trước khi làm; plan là kế
> hoạch từng bước có tiêu chí xong (phải được duyệt trước khi act); act
> là thực thi trong giới hạn file luật; verify là kiểm chứng bằng bằng
> chứng (chạy thử, xem link preview, đối chiếu tiêu chí), không phải
> "nhìn có vẻ ổn".
>
> Người điều phối (OP) giao đúng 1 đầu việc cho agent mỗi vòng; người
> kiểm chứng (RV) kiểm chứng kết quả vòng trước khi sang vòng sau; người
> ghi chép (GC) ghi nhật ký ngay tại chỗ. Giữa buổi đổi vai điều phối
> sau mỗi vòng để mỗi thành viên làm điều phối viên ít nhất 1 vòng trọn
> vẹn. Có thể gộp file này vào `LOG.md` nếu nhóm đã quen tay.

## Thông tin chung

- Nhóm:
- Ngày:
- Đầu việc đang chạy (mô tả ngắn + tiêu chí xong):

## Bảng vòng lặp

| Vòng | Plan (đã duyệt trước khi act) | Act (đã làm gì) | Kết quả verify (bằng chứng, không phải cảm nhận) | Quyết định: đi tiếp / dừng / sửa hướng | Người điều phối | Số vòng đã chạy tích lũy |
|---|---|---|---|---|---|---|
| 1 | | | | | | 1 |
| 2 | | | | | | 2 |
| 3 | | | | | | 3 |

Ghi chú khi điền:

- Cột "Kết quả verify" phải ghi bằng chứng cụ thể: đường link preview
  mở được, ảnh chụp màn hình, hay dòng kết quả kiểm chứng — không ghi
  "ổn", "đẹp", "chạy được" mà không có bằng chứng.
- Cột "Quyết định" chỉ có 3 giá trị: đi tiếp (sang vòng sau), dừng (việc
  đã xong hoặc không làm tiếp được, ghi lý do), sửa hướng (quay lại sửa
  plan, ghi rõ sửa chỗ nào).
- Cột "Số vòng đã chạy tích lũy" cộng dồn qua các buổi cho cùng một đầu
  việc, để cả nhóm nhìn thấy chi phí của việc giao một cục so với giao
  theo vòng.
- Vòng nào agent đi lệch (làm vượt phạm vi đã duyệt): ghi rõ dấu hiệu
  lệch nằm ở bước nào và người điều phối đã quyết định gì ngay tại điểm
  quyết định đó — đây là tư liệu tốt cho vấn đáp buổi 12.
