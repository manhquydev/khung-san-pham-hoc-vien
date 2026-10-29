# Ví dụ SPEC đã điền hoàn chỉnh — Tiệm đồ handmade

> Đây là VÍ DỤ để chiếu trước lớp và đối chiếu khi điền SPEC của nhóm
> mình (theo mẫu `docs/SPEC-TEMPLATE.md`). Đừng copy nguyên văn ví dụ
> này thành SPEC của nhóm — SPEC thật phải viết từ ý tưởng của nhóm.

## 1. Sản phẩm là gì

- Tên sản phẩm: Tiệm Nhỏ Xinh — cửa hàng đồ handmade của nhóm.
- Một câu mô tả (giúp ai làm việc gì): Giúp người thích đồ handmade xem
  và đặt mua túi vải, nến thơm, móc khóa len do nhóm tự làm, ngay trên
  điện thoại.

## 2. Người dùng

- Ai sẽ dùng sản phẩm này: bạn bè, thầy cô và phụ huynh muốn mua quà
  tặng nhỏ xinh, giá vừa túi tiền học sinh.
- Họ đang gặp khó khăn gì: muốn mua đồ handmade nhưng chỉ thấy ảnh rời
  rạc trên mạng xã hội, không biết còn hàng không, giá bao nhiêu, đặt
  hàng bằng cách nào.

## 3. Tính năng chính (chọn 3–5 cái)

1. Trang chủ giới thiệu tiệm và 3 sản phẩm nổi bật.
2. Trang danh mục: xem tất cả sản phẩm, lọc theo loại (túi vải / nến
   thơm / móc khóa len).
3. Trang chi tiết sản phẩm: ảnh, mô tả, giá, còn hàng hay hết hàng.
4. Giỏ hàng thử + đặt hàng thử: chọn sản phẩm, đổi số lượng, đặt đơn,
   xem lại đơn; đơn hiện trong trang quản trị của nhóm.
5. Trang nhật ký phát triển: ghi lại từng mốc nhóm đã làm được, bằng
   lời dễ hiểu cho phụ huynh.

## 4. Có trang nào

- Trang chủ (`index.html`): giới thiệu tiệm + sản phẩm nổi bật.
- Trang danh mục (`catalog.html`): danh sách sản phẩm + lọc theo loại.
- Trang chi tiết (`product.html`): một sản phẩm, kèm nút thêm vào giỏ.
- Trang giỏ hàng (`cart.html`): xem giỏ, đổi số lượng, đặt đơn.
- Trang quản trị (`admin.html`): nhóm xem lại các đơn đã đặt (mở bằng mã
  giáo viên cấp, không công khai).
- Trang nhật ký (`nhat-ky.html`): các mốc phát triển của nhóm.
- Tất cả các trang đều nằm trong thư mục `public/` (thư mục xuất bản
  của template) để deploy lên được.

## 5. Dữ liệu ra sao

Mỗi sản phẩm có đúng 5 trường, dùng chung cho cả file dữ liệu tĩnh và
bảng đơn hàng về sau:

| Trường | Nghĩa | Ví dụ |
|---|---|---|
| `ma` | Mã sản phẩm, không trùng nhau | `tui-01` |
| `ten` | Tên sản phẩm | `Túi vải vẽ tay hoa cúc` |
| `moTa` | Mô tả ngắn, lời dễ hiểu | `Túi vải canvas vẽ tay, đựng vừa vở A5` |
| `gia` | Giá tiền (đồng) | `120000` |
| `anh` | Đường dẫn ảnh sản phẩm | `images/tui-01.jpg` |

Ba sản phẩm ví dụ lúc mở đầu (giá chỉ là ví dụ, nhóm tự đặt giá thật
của mình):

| ma | ten | moTa | gia | anh |
|---|---|---|---|---|
| `tui-01` | Túi vải vẽ tay hoa cúc | Túi vải canvas vẽ tay, đựng vừa vở A5 | 120000 | `images/tui-01.jpg` |
| `nen-01` | Nến thơm hương cam | Nến thơm làm tay, cháy khoảng 20 giờ | 85000 | `images/nen-01.jpg` |
| `moc-01` | Móc khóa len hình thỏ | Móc khóa len móc tay, dài khoảng 8 cm | 45000 | `images/moc-01.jpg` |

## 6. Không làm trong đợt này (ghi rõ để khỏi lan man)

- Không thanh toán thật (chỉ đặt hàng thử, không thu tiền).
- Không đăng nhập tài khoản khách hàng.
- Không giao hàng (khách nhận hàng trực tiếp ở lớp).

## 7. Tiêu chí "xong" (đo được, không chung chung)

- Mốc M0 (deploy đầu): mở đường link thật trên điện thoại thì thấy
  trang chủ của tiệm, không vỡ bố cục.
- Mốc M1 (trang tĩnh): mở đường link thật thì xem đủ trang chủ +
  danh mục, ảnh không vỡ, chữ không tràn trên điện thoại.
- Mốc M2 (giỏ hàng tĩnh): chọn sản phẩm, đổi số lượng, giỏ hàng tính
  đúng tổng tiền theo giá trong bảng trên.
- Mốc M3 (giỏ hàng thử + phía máy chủ): đặt đơn thử trọn vòng (giỏ →
  form → xác nhận → xem lại đúng nội dung và tổng tiền) và đơn xuất
  hiện trong trang quản trị khi mở từ MỘT MÁY KHÁC máy đặt đơn.
- Mở đường link thật trên máy tính thì: mọi trang hiển thị gọn gàng,
  không lỗi hiển thị.

## 8. Trang nhật ký phát triển

- Mỗi mốc hoàn thành sẽ ghi 1 mục nhật ký bằng lời dễ hiểu cho phụ
  huynh, thuộc 1 trong 4 nhãn: Giao diện / Tính năng mới / Sửa lỗi /
  Cải tiến.
- Cách ghi theo đúng stage, nguồn duy nhất là `AGENTS.md` mục 4: học
  sinh viết sẵn nội dung mục (tiêu đề + mô tả + nhãn) trong mô tả PR;
  giáo viên POST mục đó lên production sau khi merge. Sau khi đã lên
  D1 thì không sửa file JSON nữa, tránh hai nguồn lệch nhau.
