# Website sản phẩm của nhóm mình

Repo này là "ngôi nhà" của website mà nhóm bạn sẽ xây trong khóa học
"Build website bằng AI" (dành cho học sinh lớp 7-10). Mỗi nhóm làm một
sản phẩm thật, đi hết khóa học trong chính repo này: từ ý tưởng đầu tiên
tới website chạy được trên mạng, ai cũng mở xem được.

Trong khóa này, người gõ code chính không phải bạn, mà là một AI agent.
Việc của bạn là: quyết định làm sản phẩm gì, mô tả cho agent hiểu, kiểm
tra kết quả agent làm, và làm việc với nhóm theo đúng quy trình của một
đội làm phần mềm thật.

## Bắt đầu ở đây

Làm theo đúng thứ tự này trong buổi đầu tiên.

### 1. Lấy repo của nhóm về máy

Giáo viên đã tạo sẵn repo của nhóm và đưa đường link cho bạn. Bạn chỉ
cần clone theo link đó (xem `docs/setup-windows.md`, phần Lần đầu).

Bạn **không** tự bấm nút **Use this template** trên GitHub. Repo tự tạo
sẽ không nối được với trang web của nhóm, và sẽ không chạy được.

### 2. Chạy script kiểm tra máy

Mở thư mục repo, chạy lệnh này trong PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```

Script sẽ báo từng mục PASS hay FAIL, kèm cách sửa. Sửa xong thì chạy
lại cho tới khi toàn PASS. Bạn không cần tạo tài khoản Cloudflare, không
cần đăng nhập wrangler, không deploy bằng lệnh. Giáo viên đã nối sẵn repo
với trang web của nhóm rồi: cứ merge vào nhánh `main` là website tự cập
nhật.

### 3. Điền thông tin nhóm (buổi 1)

Mở file `README-NHOM.md` và điền: tên nhóm, tên sản phẩm, thành viên
cùng tài khoản GitHub, vai của từng bạn trong vòng đầu, ý tưởng sơ bộ
của nhóm (1-2 câu). Điền bằng cách mở nhánh mới, sửa file, rồi mở
Pull Request như buổi 1 đã học. **Đừng ghi đè file `README.md` này
bằng thông tin nhóm.** File này là tài liệu chung của cả khóa, giữ
nguyên.

### 4. Đổi tên sản phẩm

Tên sản phẩm là tên của thứ nhóm bạn bán hoặc giới thiệu, không phải tên
thật của bạn. Đổi ở 3 chỗ sau:

- `public/index.html`: dòng `<title>`, dòng `<h1>[Tên sản phẩm]</h1>`
  và dòng `<meta name="description" ...>` (viết một câu ngắn: sản phẩm
  này giúp ai làm gì).
- `public/nhat-ky.html`: dòng `<title>` (thay `[Tên sản phẩm]` bằng
  tên thật của sản phẩm).
- `wrangler.toml`: dòng `name` **do giáo viên điền** tên project thật
  của nhóm. Bạn không tự đổi dòng này.

### 5. Nói với agent điều bạn muốn làm

Không cần gõ lệnh gì đặc biệt. Cứ nói bằng lời thường, ví dụ:

- "Mình muốn làm trang web giới thiệu câu lạc bộ đọc sách của lớp, giúp
  các bạn xem được danh sách truyện và đăng ký mượn truyện."
- "Mình muốn làm trang web bán đồ handmade của nhóm, có trang xem sản
  phẩm và trang ghi lại từng ngày nhóm đã làm được gì."

Agent sẽ hỏi thêm, cùng bạn điền bản mô tả sản phẩm, rồi tách thành
từng thẻ việc nhỏ để làm dần.

## Mỗi lần làm việc thì làm thế nào

Mọi thay đổi trong repo đều đi theo cùng một vòng lặp. Làm đúng vòng
này thì việc của bạn luôn có dấu vết rõ ràng, giáo viên và phụ huynh đều
xem được nhóm đã làm gì.

1. **Nói ý tưởng với agent.** Agent hỏi lại, cùng bạn viết bản mô tả
   sản phẩm (mẫu ở `docs/SPEC-TEMPLATE.md`) rồi tách thành thẻ việc
   (mẫu ở `docs/CARD-TEMPLATE.md`). Bạn phải tự đọc và đồng ý với bản
   mô tả trước khi làm tiếp. Agent không được viết hộ hay quyết hộ
   phần này.
2. **Mở một nhánh mới** cho một thẻ việc. Một thẻ việc là một nhánh,
   đừng dồn nhiều việc vào cùng một nhánh. Không bao giờ đẩy thẳng lên
   nhánh `main`.
3. **Làm việc cùng agent trên nhánh đó.** Xong thì mở **Pull Request
   (PR)** và viết rõ: đã thay đổi gì, vì sao làm, đã tự kiểm tra gì.
   Mẫu PR có sẵn một checklist, tick đủ các mục rồi mới xin review.
4. **Đợi giáo viên review.** Giáo viên là người duyệt cuối cùng trước
   khi merge. Chưa được review thì chưa merge, và agent cũng không tự
   merge.
5. **Merge xong, mở đường link thật của nhóm để kiểm tra.** Website
   chạy được trên mạng, đúng tiêu chí của thẻ việc, mới tính là xong.
   Chạy được trên máy mình thì chưa đủ.
6. **Soạn sẵn 1 mục cho trang Nhật ký phát triển** trong mô tả PR:
   ngày merge, một câu ngắn nói đã làm được gì, 1-2 câu giải thích cho
   phụ huynh hiểu sản phẩm đã thay đổi ra sao, và chọn 1 trong 4 nhãn:
   Giao diện, Tính năng mới, Sửa lỗi, Cải tiến. Viết bằng lời dễ hiểu,
   không dùng từ chuyên môn chưa giải nghĩa. Giáo viên sẽ đăng mục này
   lên trang Nhật ký sau khi merge. Lúc đầu, khi nhóm chưa lên Stage 1,
   3 mục ví dụ trong `public/data/changelog.json` sẽ được xóa và thay
   bằng mục thật đầu tiên của nhóm; sau khi đã lên Stage 1 thì không
   sửa file này nữa.

Cuối mỗi buổi, cả nhóm ghi 1 dòng ngắn: hôm nay học được gì, còn vướng
gì. Quy trình đầy đủ, kèm các cổng kiểm chứng, nằm trong
`docs/FLOW-GUIDE.md`. Khi nào lớp học tới Stage 1 và Stage 2 (trang web
đọc và ghi dữ liệu thật), giáo viên sẽ báo. Các bước tạo database và đặt
khóa là việc của giáo viên, bạn chỉ tập trên database local của máy mình.

## Các file bạn sẽ chạm vào

| File | Để làm gì |
|---|---|
| `README-NHOM.md` | Thông tin nhóm: tên nhóm, thành viên, vai, ý tưởng |
| `public/index.html` | Trang chính của website |
| `public/nhat-ky.html` | Trang Nhật ký phát triển |
| `public/data/changelog.json` | Các mục nhật ký (bản dự phòng, dùng trước khi lên Stage 1) |
| `docs/SPEC-TEMPLATE.md` | Mẫu bản mô tả sản phẩm |
| `docs/CARD-TEMPLATE.md` | Mẫu thẻ việc |
| `docs/PHIEU-KIEM-THU-CHEO.md` | Phiếu kiểm thử chéo: nhờ nhóm khác bấm thử website của mình |
| `docs/FLOW-GUIDE.md` | Quy trình làm sản phẩm, bản rút gọn |
| `docs/setup-windows.md` | Hướng dẫn cài đặt và các bước theo từng Stage |
| `AGENTS.md` | Hướng dẫn dành cho agent làm việc cùng bạn (bạn đọc cũng được) |

Các file còn lại trong repo là khung kỹ thuật đã chuẩn bị sẵn. Bạn không
cần sửa chúng trừ khi giáo viên hoặc agent hướng dẫn cụ thể.

## Quy tắc giữ an toàn

- **Không bao giờ ghi mật khẩu, mã hay khóa vào repo.** Mã quản trị
  đơn hàng (buổi 8) giáo viên sẽ đưa riêng cho nhóm, bạn không chia sẻ
  ra ngoài nhóm và không ghi vào bất kỳ file nào trong repo. Khóa lộ thì
  báo ngay cho giáo viên đổi khóa.
- **Không đăng thông tin cá nhân lên repo hay lên website:** họ tên đầy
  đủ, số điện thoại, email, địa chỉ nhà, tên trường lớp, ảnh của mình
  hay của bạn khác. Chỉ dùng tên sản phẩm và tên nhóm. Tên trên trang
  web luôn là tên sản phẩm, không phải tên học viên.
- **Không tự ý đổi tên project hay đường link của nhóm.** Phần đó do
  giáo viên giữ.
- **Một PR chỉ làm một việc.** PR càng nhỏ, càng dễ review, càng ít lỗi.
- **Chưa được giáo viên review thì chưa merge.** Merge là bước đưa
  thay đổi lên website thật của cả nhóm.
- **Kẹt thì hỏi, đừng đoán mò rồi đẩy bừa.** Hỏi agent trước, hỏi bạn
  trong nhóm, rồi hỏi giáo viên. Lỗi nào cũng có cách sửa, và sửa sớm
  thì rẻ hơn sửa muộn.

## Khi bị kẹt thì làm gì

1. Đọc kỹ thông báo lỗi trên màn hình, chụp lại nếu cần.
2. Hỏi agent: dán lỗi vào và nói bạn đang làm bước nào.
3. Kiểm tra lại 3 thứ hay sai nhất: bạn có đang ở đúng nhánh không,
   file có lưu chưa, và lệnh có gõ đúng chính tả không.
4. Vẫn kẹt thì giơ tay hỏi giáo viên, kèm theo ảnh chụp lỗi và bước bạn
   đang làm dở.

## Ghi chú cho giáo viên

Phần chuẩn bị trước khóa học, tạo repo nhóm, tạo project Pages và
database D1, đặt khóa, nối repo với project, theo dõi hạn mức miễn phí:
xem `docs/setup-windows.md` (Phần 0) và
`docs/bang-theo-doi-giao-vien.md`. Tài liệu kỹ thuật theo từng Stage:
xem `docs/roadmap.md`.
