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

Làm theo đúng thứ tự này trong buổi đầu tiên. Buổi đầu chỉ có một việc
khó là cài đặt — đã có script làm hộ, con chỉ cần gõ đúng từng lệnh
dưới đây, đọc kết quả trên màn hình và trả lời khi script hỏi.

Bản chi tiết từng bước (cài tay từng thứ, sửa từng lỗi): xem
`docs/setup-windows.md`, phần Lần đầu, Stage 0.

### 1. Chạy script cài đặt lần đầu

Giáo viên đưa cho con 2 thứ: file `setup-lan-dau.ps1` và đường link
repo của nhóm. Lưu file script vào thư mục Tài liệu (Documents) trên
máy, rồi mở PowerShell và gõ 2 lệnh này:

```powershell
cd $HOME\Documents
powershell -ExecutionPolicy Bypass -File .\setup-lan-dau.ps1
```

- **Kết quả đúng sẽ thấy:** script in ra từng mục nó kiểm tra — Git,
  Node.js, VS Code — kèm phiên bản tìm được trên máy con, rồi hỏi con
  từng việc một (cài cái còn thiếu không, tên và email GitHub của con
  là gì, link repo nhóm là gì).
- **Lỗi thường gặp — "không nhận dạng được lệnh" hay "script bị chặn":**
  con gõ thiếu cờ `-ExecutionPolicy Bypass` hoặc đang đứng sai thư mục.
  Gõ `cd $HOME\Documents` lại rồi gõ đúng lệnh ở trên. Cờ
  `-ExecutionPolicy Bypass` chỉ mở cửa cho đúng lần chạy này, không đổi
  cài đặt máy.
- **Lỗi thường gặp — script báo thiếu công cụ nhưng không tự cài:**
  script chỉ cài khi con gõ `Y` đồng ý. Không gõ `Y` thì con tự cài tay
  theo `docs/setup-windows.md` (Bước 1–3), rồi chạy lại script.

Nếu con đã clone repo nhóm về máy trước rồi thì mở PowerShell ở ngay
trong thư mục repo đó rồi chạy lệnh trên — script sẽ nhận ra repo có
sẵn và bỏ qua bước clone.

### 2. Trả lời khi script hỏi, rồi để script làm nốt

Script hỏi gì thì trả lời đó, theo đúng thứ tự:

1. **Thiếu công cụ nào thì gõ `Y` để cài.** Script in sẵn lệnh cài
   (winget) trước khi hỏi — con thấy rõ nó sắp chạy lệnh gì. Cài xong,
   nếu script dặn đóng rồi mở lại PowerShell thì làm đúng như vậy rồi
   chạy lại script từ bước 1.
2. **Gõ tên hiển thị và email tài khoản GitHub của con** để Git nhớ ai
   là người làm (không có 2 dòng này thì tới commit đầu tiên Git sẽ
   báo lỗi).
3. **Dán đường link repo nhóm** giáo viên đã đưa (mở link repo, bấm
   **Code**, copy link, dán vào PowerShell). Con không tự gõ lệnh
   `git clone` — script clone giúp con.

Xong 3 việc trên, script tự chạy `scripts\check-env.ps1` để kiểm tra
lại toàn bộ máy.

- **Kết quả đúng sẽ thấy:** các dòng `[PASS]` cho Git, Node.js, npm,
  wrangler, File khung và D1 database_id.
- **Lỗi thường gặp — clone báo không tìm thấy (404):** giáo viên chưa
  mở repo của nhóm cho con — hỏi giáo viên, đừng tự tìm repo khác hay
  tự bấm **Use this template** tạo repo mới.
- **Lỗi thường gặp — hiện cửa sổ đăng nhập GitHub:** đăng nhập ở cửa
  sổ đó. Không bao giờ gõ mật khẩu GitHub vào PowerShell.
- **Lỗi thường gặp — Node.js báo bản cũ (dưới v20):** script sẽ hỏi
  cài lại bản LTS mới — gõ `Y`.

### 3. Nếu còn mục FAIL thì sửa rồi chạy lại bước kiểm tra

Mục nào `[FAIL]` thì đọc ngay dòng "Cách sửa" bên dưới nó, sửa xong
thì vào thư mục repo vừa clone và chạy lại lệnh kiểm tra cho tới khi
toàn `[PASS]`:

```powershell
cd <tên-repo-vừa-clone>
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```

Thay `<tên-repo-vừa-clone>` bằng tên thư mục thật (là phần cuối của
đường link repo, ví dụ `khung-nhom-1`). Chạy lệnh này phải đứng ở thư
mục gốc của repo — nơi có file `wrangler.toml`. Nếu script báo "File
khung FAIL" thì con đang đứng sai thư mục, gõ `cd` tới đúng thư mục
repo rồi chạy lại.

- **Lỗi thường gặp — "D1 database_id" FAIL (vẫn là TO-FILL):** giáo
  viên chưa làm xong phần chuẩn bị — báo giáo viên, con **không** tự
  tạo database hay tự điền id.
- **Lỗi thường gặp — "Git identity" FAIL:** con chưa đặt tên/email ở
  bước 2. Gõ 2 lệnh sau (thay bằng tên và email thật của con), rồi
  chạy lại lệnh kiểm tra:

```powershell
git config --global user.name "Tên hiển thị của con"
git config --global user.email "email tài khoản GitHub của con"
```

Con không cần tạo tài khoản Cloudflare, không cần đăng nhập wrangler,
không deploy bằng lệnh. Giáo viên đã nối sẵn repo với trang web của
nhóm rồi: cứ merge vào nhánh `main` là website tự cập nhật.

### 4. Điền thông tin nhóm (buổi 1)

Mở file `README-NHOM.md` và điền: tên nhóm, tên sản phẩm, thành viên
cùng tài khoản GitHub, vai của từng bạn trong vòng đầu, ý tưởng sơ bộ
của nhóm (1-2 câu). Điền bằng cách mở nhánh mới, sửa file, rồi mở
Pull Request như buổi 1 đã học. **Đừng ghi đè file `README.md` này
bằng thông tin nhóm.** File này là tài liệu chung của cả khóa, giữ
nguyên.

### 5. Đổi tên sản phẩm

Tên sản phẩm là tên của thứ nhóm bạn bán hoặc giới thiệu, không phải tên
thật của bạn. Đổi ở 3 chỗ sau:

- `public/index.html`: dòng `<title>`, dòng `<h1>[Tên sản phẩm]</h1>`
  và dòng `<meta name="description" ...>` (viết một câu ngắn: sản phẩm
  này giúp ai làm gì).
- `public/nhat-ky.html`: dòng `<title>` (thay `[Tên sản phẩm]` bằng
  tên thật của sản phẩm).
- `wrangler.toml`: dòng `name` **do giáo viên điền** tên project thật
  của nhóm. Bạn không tự đổi dòng này.

### 6. Nói với agent điều bạn muốn làm

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
