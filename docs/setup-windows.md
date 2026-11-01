# Cài đặt lần đầu cho học viên dùng Windows

Tài liệu này đi từng bước một, từ máy trống tới khi trang web của con chạy
trên mạng. Mỗi bước đều có: **lệnh cần gõ → kết quả đúng sẽ thấy → nếu
lỗi thì sửa thế nào**. Làm theo đúng thứ tự, đừng nhảy bước.

> ⚠️ **MÔ HÌNH TÀI KHOẢN ĐÃ CHỐT: MỘT tài khoản Cloudflare do giáo viên
> đứng tên, mỗi nhóm một project Pages + một database D1 riêng trong tài
> khoản đó. Học viên KHÔNG tạo tài khoản Cloudflare, KHÔNG đăng nhập
> wrangler, KHÔNG giữ bất kỳ khóa nền tảng nào, KHÔNG deploy bằng lệnh.**
> Giáo viên nối sẵn repo của nhóm với project Pages — học viên chỉ cần
> code, mở PR, merge là trang tự lên mạng. Hạn mức tính theo tài khoản
> giáo viên (xem `docs/gioi-han-free.md`); với 2 nhóm thì vẫn dư dả.
>
> Mọi lệnh trong tài liệu này gõ trong **PowerShell** — chương trình gõ
> lệnh có sẵn trên Windows (không phải Git Bash, không phải Command Prompt
> cũ), đứng ở thư mục gốc của repo. Đường dẫn trên Windows dùng dấu `\`,
> ví dụ `scripts\check-env.ps1`.
>
> **Đồng ý của phụ huynh + tài khoản GitHub dưới 13 tuổi:** GitHub yêu
> cầu người dùng từ 13 tuổi trở lên. Với em dưới 13 tuổi, con chỉ dùng
> GitHub khi có đủ cả hai văn bản: (i) văn bản chấp thuận của
> trường/trung tâm; (ii) phiếu đồng ý của phụ huynh. Ba mẹ tạo tài khoản
> cùng con KHÔNG thay thế được hai văn bản này. Thiếu một trong hai văn
> bản thì em đó không dùng GitHub — giáo viên bố trí vai trò thay thế
> ngoài GitHub (xem bước 4). Học viên không tạo bất kỳ tài khoản hạ
> tầng nào khác — xem tờ thông báo phụ huynh
> (`docs/thong-bao-phu-huynh.md`).

---

# PHẦN 0 — Giáo viên chuẩn bị trước (CHỈ GIÁO VIÊN, làm TRƯỚC khi học viên clone)

Phần này giáo viên làm một lần cho mỗi nhóm, theo đúng thứ tự dưới đây.
Học viên bỏ qua toàn bộ phần 0. Ghi lại mọi project vào
`docs/bang-theo-doi-giao-vien.md` (không bao giờ ghi giá trị khóa vào đó).

## Bước G0 — Tạo repo nhóm trong Organization TRƯỚC buổi 1

Giáo viên tạo repo của nhóm từ template (bấm **Use this template**)
trong Organization của lớp, thêm học sinh vào repo, rồi mới làm các
bước G1–G5 dưới đây. **Học viên KHÔNG tự bấm Use this template tạo
repo riêng** — repo tự tạo sẽ không nối Pages, `wrangler.toml` còn
TO-FILL, script kiểm tra sẽ FAIL, và nhóm sẽ có hai repo chồng nhau.

## Bước G0b — Bật ruleset bảo vệ nhánh `main` (trước khi học sinh clone)

Ngay sau khi tạo repo nhóm (bước G0), giáo viên bật ruleset cho nhánh
`main` trong repo nhóm (GitHub → Settings → Rules → Rulesets → New
ruleset, áp cho nhánh `main`): chặn push thẳng lên `main`, bắt buộc mọi
thay đổi đi qua PR và có review của giáo viên trước khi merge. Làm bước
này TRƯỚC khi học sinh clone, để ngay từ buổi 1 repo nhóm đã có rào
bảo vệ (xem KHUNG §4).

## Bước G1 — Tạo project Pages + database D1 của nhóm

Trong tài khoản Cloudflare của giáo viên (gói miễn phí, không cần thẻ):

1. Tạo một project Pages cho nhóm (đặt tên theo nhóm, ví dụ
   `khung-<ten-nhom>`).
2. Tạo một database D1 cho nhóm (cùng tên hoặc tên tương ứng).

## Bước G2 — Điền database vào bản copy `wrangler.toml` của repo nhóm và commit

Mở bản copy repo của nhóm, thay trong `wrangler.toml`:

- Dòng `name` thành tên project Pages thật của nhóm.
- Dòng `database_name` và `database_id` (mục `[[d1_databases]]`) thành
  tên và id database vừa tạo ở bước G1.

Commit và push thay đổi này lên nhánh `main` của repo nhóm.

> **Quy tắc binding đã chốt (đọc kỹ trước HP1 buổi 8):** database D1
> của nhóm chứa cả 2 bảng — bảng `changelog` (nhật ký, từ template)
> và bảng `orders` (đơn hàng, tạo bằng migration
> `migrations/0002_orders.sql` giáo viên đã chạy trước khóa; học sinh
> chỉ đọc hiểu ở HP1 buổi 8, xem giáo án HP1 Phụ lục F.1). File
> `wrangler.toml` của nhóm vì thế có 2 mục `[[d1_databases]]` trỏ
> cùng 1 `database_id` đó: binding `DB` (có sẵn từ template, cho bảng
> changelog) và binding `ORDERS_DB` (giáo viên thêm khi lớp tới HP1
> buổi 8, cho bảng orders — xem giáo án HP1 Phụ lục F). Môi trường
> Preview mặc định dùng cùng D1 của nhóm, không tạo D1 thứ hai; nếu
> giáo viên muốn Preview dùng D1 riêng thì khai rõ trong
> `[env.preview]` trước buổi 8, không để tới buổi 8 mới quyết.

## Bước G3 — Đặt khóa giáo viên cho project (Stage 2)

Từ **máy giáo viên** (đã đăng nhập wrangler bằng tài khoản giáo viên),
gõ một lần cho mỗi project:

```powershell
npx --yes wrangler pages secret put TEACHER_KEY --project-name <ten-project-cua-nhom>
```

Thay `<ten-project-cua-nhom>` bằng tên project Pages thật của nhóm.
PowerShell sẽ hỏi nhập giá trị khóa (gõ xong bấm Enter, chữ khóa không
hiện lên màn hình là bình thường).

- **Kết quả đúng:** báo secret đã lưu.
- **TUYỆT ĐỐI KHÔNG** viết khóa vào `wrangler.toml`, vào code, hay gửi
  khóa qua chat chung. Khóa lộ thì coi như cổng giữ lớp đã mở toang —
  đổi khóa ngay và đặt lại bằng lệnh trên.

## Bước G4 — Nối repo nhóm với project qua Dashboard (đường deploy DUY NHẤT)

1. Cloudflare Dashboard → Pages → Create application → Pages →
   Connect to Git → chọn repo của nhóm.
2. Framework preset: **None**. Build command: **để trống**. Build output
   directory: **public**. Bấm **Save and Deploy**.

> ⚠️ **TUYỆT ĐỐI KHÔNG nối Git khi `database_id` còn là TO-FILL.**
> Deploy đầu tiên sẽ kèm Functions gắn binding giả, trang nhật ký lỗi
> thay vì hiện mục ví dụ. Chỉ nối Git sau khi bước G2 đã điền
> `database_id` thật và commit. File `wrangler.toml` là nguồn cấu hình
> chuẩn của project Pages, nên deploy qua Dashboard vẫn nhận đúng cấu
> hình trong file (kể cả binding database).

## Bước G5 — Chạy migration + seed cho database thật của nhóm

Cũng từ máy giáo viên, chạy một lần cho mỗi nhóm để lần deploy đầu tiên
đã có bảng và 3 mục ví dụ trong D1 (nếu không, trang nhật ký sẽ lỗi vì
bảng chưa tồn tại):

```powershell
npx --yes wrangler d1 migrations apply DB --remote
npx --yes wrangler d1 execute DB --remote --file migrations\seed.sql
```

- **Kết quả đúng:** mỗi lệnh báo thành công (applied / executed).
- **Chỉ chạy seed một lần cho mỗi nhóm:** sau khi nhóm đã có mục nhật ký
  thật và giáo viên đã xóa 3 mục ví dụ (xem bước S2), chạy lại
  `seed.sql` sẽ đưa 3 mục ví dụ trở lại. Mỗi nhóm chỉ chạy seed một lần
  ở bước này; về sau không chạy lại.
- Sau bước này, đường link `https://<ten-project>.pages.dev/` của nhóm
  đã chạy thật: trang chủ, trang Nhật ký (3 mục ví dụ từ D1) và
  `/api/health` báo `d1_configured: true`.

Từ đây, **merge vào `main` là tự deploy** — học viên không deploy bằng
lệnh, không đăng nhập wrangler, không chạm vào tài khoản giáo viên.

**Cài sẵn wrangler vào máy lớp trước buổi 1:** trên mỗi máy lớp, khi
máy đang có mạng, giáo viên mở PowerShell gõ một lần
`npx --yes wrangler --version` để wrangler được tải sẵn về máy. Buổi
đầu script kiểm tra sẽ dùng bản đã tải sẵn, không tắc vì mạng chặn
npm. Nếu máy chưa cài sẵn mà mạng chặn thì báo giáo viên xử lý mạng
hoặc cài sẵn lại — học viên đừng tự tìm cách khác.

---

# PHẦN 1 — Lần đầu, Stage 0 (mọi học viên làm buổi đầu)

Phần này đưa trang của nhóm lên mạng qua quy trình: code → mở PR → giáo
viên review → merge → production tự cập nhật. Học viên không đụng tới
tài khoản Cloudflare hay database thật. Phần 2 (database local, khóa
giáo viên) chỉ làm khi lớp tới Stage 1/2 — đừng làm trước.

## Bước 0 — Nhận link từ giáo viên (không tạo tài khoản gì cả)

Trước buổi đầu, giáo viên đưa cho nhóm 2 đường link:

1. Đường link repo GitHub của nhóm (để clone ở bước 4).
2. Đường link `https://<ten-project>.pages.dev/` của nhóm (để kiểm tra
   ở bước 7).

**Con không tạo tài khoản Cloudflare, không đăng nhập wrangler, không
deploy bằng lệnh.** Nếu ai đó bảo con đăng ký tài khoản Cloudflare hay
dán khóa vào đâu đó thì dừng lại và hỏi giáo viên — đó không phải quy
trình của lớp.

## Bước 1 — Cài Git for Windows

1. Tải tại https://git-scm.com/download/win, bấm Next mặc định tới hết
   (mục "Choosing the default editor" cứ để mặc định là được).
2. Đóng rồi mở lại PowerShell, gõ:

```powershell
git --version
```

- **Kết quả đúng:** `git version 2.x.x` (số x nào cũng được).
3. Cấu hình tên + email cho git ngay (bắt buộc trước commit đầu tiên
   ở buổi 1 — nếu không, tới commit đầu git sẽ báo lỗi
   "Please tell me who you are" và buổi đầu tắc):

```powershell
git config --global user.name "Tên hiển thị của con"
git config --global user.email "email tài khoản GitHub của con"
```

Thay bằng tên hiển thị và email của chính tài khoản GitHub của con
(hỏi ba mẹ nếu chưa rõ). Gõ xong kiểm tra lại bằng
`git config --global --list`.
- **Nếu lỗi** (`git không được nhận dạng...`): Git chưa vào PATH.
  PATH là danh sách thư mục mà máy tính tìm lệnh khi con gõ một lệnh —
  chưa có Git trong đó thì máy không biết lệnh `git` nằm ở đâu. Cài lại,
  tới bước "Adjusting your PATH environment" chọn **"Git from the command
  line and also from 3rd-party software"**, rồi đóng mở lại PowerShell.

## Bước 2 — Cài Node.js LTS

1. Tải tại https://nodejs.org, chọn nút **LTS** (không chọn Current).
2. Cài mặc định là đủ (Node.js tự thêm mình vào PATH, không có ô chọn
   riêng nào cần tích thêm).
3. Đóng rồi mở lại PowerShell, gõ:

```powershell
node --version
npm --version
```

- **Kết quả đúng:** `v20.x.x` trở lên (ví dụ `v20.19.0`, `v22.x.x`) và
  `10.x.x` cho npm.
- **Nếu lỗi** (báo `v18` trở xuống): máy đang có Node.js cũ. Gỡ bản cũ
  trong Settings → Apps rồi cài lại bản LTS.
- **Nếu lỗi** (`node không được nhận dạng...`): cài lại Node.js, đóng mở
  lại PowerShell rồi thử lại.

## Bước 3 — Cài VS Code

1. Tải tại https://code.visualstudio.com, cài mặc định.
2. Mở VS Code → Extensions → tìm **"Prettier"** và **"ESLint"** (tùy chọn,
   giúp code gọn hơn, không bắt buộc).

## Bước 4 — Lấy repo về máy (clone trước, kiểm tra sau)

1. Nhờ ba mẹ/người giám hộ tạo tài khoản GitHub cùng con hoặc đồng ý cho
   con tạo. **Với em dưới 13 tuổi:** GitHub yêu cầu người dùng từ 13
   tuổi trở lên — ba mẹ tạo tài khoản cùng KHÔNG đủ. Con chỉ dùng GitHub
   khi có đủ cả hai văn bản: (i) văn bản chấp thuận của trường/trung tâm;
   (ii) phiếu đồng ý của phụ huynh. Thiếu một trong hai văn bản thì em
   không dùng GitHub, giáo viên bố trí vai trò thay thế ngoài GitHub.
2. Giáo viên đã tạo sẵn repo của nhóm trong Organization của lớp (xem
   phần 0, bước G0) và đưa đường link repo đó cho nhóm ở bước 0.
   **Con KHÔNG tự bấm Use this template tạo repo riêng** — repo tự
   tạo sẽ không nối Pages và không chạy được.
3. Mở đường link repo nhóm giáo viên đã đưa, bấm **Code** → copy đường
   link, rồi trong PowerShell gõ lệnh clone bằng cách **dán đường link
   vừa copy vào** (đừng gõ nguyên văn ví dụ dưới đây, vì `<...>` chỉ
   là chỗ giữ sẵn cho link thật):

```powershell
git clone <dán-đường-link-vừa-copy-vào-đây>
cd <ten-repo>
```

- **Kết quả đúng:** thư mục mới xuất hiện, bên trong có `public/index.html`,
  `public/nhat-ky.html`, `wrangler.toml`.
- **Nếu lỗi** (trang repo báo không tìm thấy, 404): giáo viên chưa mở
  repo của nhóm cho con — hỏi giáo viên, đừng tự tìm repo khác thay thế
  và đừng tự bấm Use this template tạo repo mới.
- **Nếu lỗi** (hỏi username/password khi clone repo private): lần clone
  đầu sẽ bật cửa sổ đăng nhập GitHub riêng — đăng nhập ở cửa sổ đó.
  Không bao giờ gõ mật khẩu GitHub vào PowerShell. Đăng nhập trình duyệt
  trước không tự đăng nhập cho git CLI. Nếu máy đã bật Git Credential
  Manager thì cửa sổ đăng nhập là đường đi đúng; nếu không, dùng GitHub
  Desktop để clone.

## Bước 5 — Chạy script kiểm tra môi trường

Script này kiểm tra một lượt: Git, Node.js, npm, wrangler, đủ file
khung, và `database_id` đã điền chưa. **Script không yêu cầu con đăng
nhập Cloudflare** — mục đăng nhập chỉ là ghi chú cho giáo viên và luôn
đạt với học viên. Chạy ở thư mục gốc của repo (nơi có file
`wrangler.toml`):

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```

- **Kết quả đúng (lúc mới bắt đầu, Stage 0):** PASS ở Git, Node.js,
  npm, wrangler, "File khung" (vì con đã clone ở bước 4 nên đủ file)
  và "D1 database_id" (vì giáo viên đã điền database thật của nhóm
  vào `wrangler.toml` ở phần 0, bước G2, trước khi con clone).
  Script thoát mã 1 khi còn FAIL, đó là cố tình để con biết còn việc
  chưa xong.
- **Nếu "D1 database_id" FAIL (vẫn là TO-FILL):** giáo viên chưa làm
  xong phần 0 — báo giáo viên, **đừng tự tạo database hay tự điền id**.
- **Nếu "File khung" FAIL:** con đang đứng sai thư mục. Gõ `cd` tới
  thư mục repo (nơi có file `wrangler.toml`) rồi chạy lại. Đừng lờ output
  FAIL đi — mỗi mục FAIL đều kèm cách sửa ngay bên dưới nó.
- **Ghi chú về ExecutionPolicy:** Windows mặc định chặn chạy file `.ps1`.
  Cờ `-ExecutionPolicy Bypass` ở lệnh trên chỉ mở cửa cho đúng lần chạy
  này, không đổi cài đặt máy vĩnh viễn. Muốn chạy trực tiếp về sau thì gõ
  một lần: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

## Bước 6 — Không đăng nhập, không deploy bằng lệnh (giáo viên đã nối sẵn)

**Học viên bỏ qua đăng nhập wrangler và deploy bằng lệnh.** Giáo viên
đã nối repo của nhóm với project Pages ở phần 0, bước G4 — từ đây,
đường lên mạng của nhóm chạy như sau:

1. Con code trên nhánh riêng, mở PR, giáo viên review.
2. Merge PR vào `main` → Cloudflare tự build và deploy production.
3. Mở đường link `https://<ten-project>.pages.dev/` là thấy bản mới.

Deploy bằng lệnh CLI (`wrangler pages deploy ...`) là **CHỈ GIÁO VIÊN**
làm khi cần, vì lệnh đó dùng tài khoản của giáo viên. Học viên gõ lệnh
đó sẽ bị hỏi đăng nhập — dừng lại, đừng đăng nhập bằng tài khoản nào
khác, hỏi giáo viên.

## Bước 7 — Kiểm tra lần cuối Stage 0

Mở trình duyệt, vào 3 đường link (dùng link thật giáo viên đã đưa ở
bước 0):

1. `https://<ten-project>.pages.dev/` — trang chủ mở được, tiêu đề trang
   không còn dấu `[ ]` (nghĩa là con đã đổi `[Tên sản phẩm]` thành tên
   thật của SẢN PHẨM, không phải tên thật của con).
2. `https://<ten-project>.pages.dev/nhat-ky` — trang Nhật ký hiện đủ 3
   mục ví dụ (đọc từ database của nhóm, giáo viên đã seed ở phần 0),
   nhóm theo ngày, không vỡ bố cục trên điện thoại.
3. `https://<ten-project>.pages.dev/api/health` — thấy
   `"d1_configured": true` và `"teacher_key_configured": true` là
   **ĐÚNG** (giáo viên đã chuẩn bị database và khóa ở phần 0). Trang
   này chỉ báo có/không, không lộ khóa.

- **Nếu trang nhật ký trống:** kiểm tra lại file
  `public/data/changelog.json` có còn nguyên không (file này là dự
  phòng khi API không dùng được), rồi báo giáo viên kiểm tra database
  của nhóm.
- **Nếu `/api/health` báo 404:** Functions chưa deploy theo — báo giáo
  viên kiểm tra kết nối Git của project, học viên không tự deploy lại.
- **Nếu `/api/health` báo `d1_configured: false`:** giáo viên chưa làm
  xong phần 0 hoặc binding chưa gắn — báo giáo viên vào Dashboard →
  Pages project → Settings → Functions → D1 database bindings → gắn
  database của nhóm vào binding `DB`, rồi deploy lại.

Khi cả 3 link đều đúng, môi trường của con đã xong cho Stage 0. Từ đây,
mỗi tính năng mới đi theo quy trình trong `AGENTS.md`: nói ý tưởng bằng
lời thường → agent đưa vào flow → làm trên nhánh → mở PR → giáo viên
review → merge → production tự cập nhật, mục nhật ký mới hiện lên trang.

---

# PHẦN 2 — Khi lớp tới Stage 1/2 (KHÔNG làm ngày đầu)

Phần này chỉ làm khi giáo viên báo lớp đã tới Stage 1 hoặc Stage 2. Làm
trước sẽ bỏ qua bài học Stage 0 và dễ sai thứ tự.

> Phân công đã chốt: **việc chạm vào tài khoản giáo viên là của giáo
> viên** (tạo D1, migration remote, đặt khóa, xóa mục sai trên
> production). **Học viên chỉ tập trên máy mình** (migration local,
> database local, dev server local) và **không bao giờ chạy lệnh remote
> nào bằng tài khoản giáo viên, không đăng nhập wrangler.**

## Bước S1 — Database D1 của nhóm (GIÁO VIÊN ĐÃ LÀM Ở PHẦN 0)

D1 là nơi chứa bảng dữ liệu chạy trên Cloudflare (nôm na là "cuốn sổ
ghi chép" mà trang web đọc/ghi qua mạng). **Binding** là tên gọi để code
tìm thấy database đó — trong khung này, binding tên là `DB`.

Giáo viên đã tạo database của nhóm và điền `database_name` /
`database_id` thật vào `wrangler.toml` ở phần 0, bước G2, trước khi học
viên clone. **Học viên không tự tạo database, không tự điền id.** Tới
HP1 buổi 8, giáo viên thêm binding `ORDERS_DB` trỏ cùng database này
cho bảng orders (xem phần 0, quy tắc binding đã chốt) — database của
nhóm chứa cả 2 bảng, không tạo database thứ hai.

- **Nếu script kiểm tra báo "D1 database_id" FAIL (vẫn là TO-FILL):**
  giáo viên chưa làm xong phần 0 — báo giáo viên, đừng tự tạo database.
- Lệnh giáo viên đã chạy (chỉ để học viên đọc hiểu, không gõ lại):

```powershell
npx --yes wrangler d1 create khung-<ten-nhom>
```

## Bước S2 — Migration: local thì học viên tập, remote thì CHỈ GIÁO VIÊN

**Migration** là file ghi các bước tạo bảng — chạy nó để tạo bảng, thay
vì bấm tạo bảng bằng tay trên Dashboard (tạo tay sẽ lệch với code trong
repo và các bạn khác không chạy lại được).

**Học viên tập trên máy mình** (không cần tài khoản, không cần đăng nhập):

```powershell
npx --yes wrangler d1 migrations apply DB --local
npx --yes wrangler pages dev --d1
```

Lệnh `--local` tạo database thử trên máy con để tập; dev server local
cũng đọc database local đó.

**CHỈ GIÁO VIÊN chạy lệnh remote** (đã chạy ở phần 0, bước G5, và chạy
lại mỗi khi có migration mới):

```powershell
npx --yes wrangler d1 migrations apply DB --remote
npx --yes wrangler d1 execute DB --remote --file migrations\seed.sql
```

- **Kết quả đúng:** mỗi lệnh báo thành công (applied / executed).
- **Nếu lỗi** (báo bảng đã tồn tại): migration đã chạy rồi, bỏ qua và
  chạy tiếp lệnh sau.
- Sau khi nhóm có mục nhật ký thật đầu tiên, **giáo viên xóa 3 dòng ví
  dụ trên production** bằng:

```powershell
npx --yes wrangler d1 execute DB --remote --command "DELETE FROM changelog WHERE tieu_de LIKE 'VÍ DỤ%';"
```

> **Chỉ chạy seed một lần cho mỗi nhóm:** file `seed.sql` dùng
> `INSERT OR IGNORE` — chỉ bỏ qua dòng đang tồn tại. Sau khi đã xóa 3
> mục ví dụ ở trên, chạy lại seed sẽ chèn lại 3 mục ví dụ đó. Vì vậy
> mỗi nhóm chỉ chạy seed một lần (ở bước G5); về sau không chạy lại.

> Quirk cần biết khi test trên máy: `npx --yes wrangler d1 migrations apply DB
> --local` và `npx --yes wrangler pages dev --d1` dùng hai file database local
> khác nhau. Muốn test API trên máy thì phải seed đúng store mà dev
> server đang dùng (seed lại bằng lệnh dev server chỉ tới), đừng ngạc
> nhiên nếu database `--local` đã seed mà dev server vẫn thấy trống.
> Luồng deploy thật (migration `--remote` → Functions đọc remote) không
> bị ảnh hưởng.

## Bước S3 — CHỈ GIÁO VIÊN LÀM — Đặt khóa giáo viên (Stage 2)

**Học viên bỏ qua bước này.** Khóa này do giáo viên giữ và tự đặt từ
**máy giáo viên** (đã làm ở phần 0, bước G3, một lần cho mỗi project).
Học viên không tự tạo khóa và không giữ khóa sau đó.

```powershell
npx --yes wrangler pages secret put TEACHER_KEY --project-name <ten-project-cua-nhom>
```

Thay `<ten-project-cua-nhom>` bằng tên project Pages thật của nhóm.
PowerShell sẽ hỏi nhập giá trị khóa (gõ xong bấm Enter, chữ khóa không
hiện lên màn hình là bình thường).

- **Kết quả đúng:** báo secret đã lưu.
- **Nếu lỗi** (chưa có project Pages): làm bước G1 và G4 ở phần 0
  trước, rồi quay lại bước này. Thứ tự này là bắt buộc vì lệnh đặt
  secret đòi project Pages đã tồn tại.
- **TUYỆT ĐỐI KHÔNG** viết khóa vào `wrangler.toml`, vào code, hay gửi
  khóa qua chat chung. Khóa lộ thì coi như cổng giữ lớp đã mở toang.

### Ví dụ ghi mục nhật ký qua API (Stage 2, giáo viên demo)

Giáo viên gõ trên PowerShell (học viên xem, không giữ khóa):

```powershell
$body = @{
  date = "2026-11-02"
  title = "Trang giới thiệu nhóm đã lên mạng"
  description = "Hôm nay trang web của nhóm đã có trang giới thiệu với tên nhóm và lời chào ngắn, ai mở đường link cũng xem được."
  category = "Tính năng mới"
  pr_url = $null
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://<ten-project>.pages.dev/api/changelog" `
  -Method Post `
  -Headers @{ "x-teacher-key" = "<khoa-giao-vien>" } `
  -Body $body -ContentType "application/json"
```

- **Kết quả đúng:** trả về mã 201 và JSON của mục vừa tạo (gồm `id`,
  `date`, `title`, `description`, `category`, `pr_url`).
- **Không kèm khóa** phải bị từ chối (401), **chưa cấu hình khóa** phải bị
  từ chối (503) — đó là cổng giữ lớp hoạt động đúng, không phải lỗi.

### Ghi mục nhật ký local trên máy học viên (không cần khóa thật)

Khi lớp tới Stage 2 và học viên muốn tập ghi qua API trên máy mình, giáo
viên gõ khóa thật vào file `.dev.vars` trên máy đó (xem
`.dev.vars.example` — file mẫu này không chứa khóa thật, không bao giờ
commit file thật). Sau đó chạy dev server local và POST tới
`http://localhost:8788/api/changelog` như ví dụ trên. Hết buổi, giáo
viên thu hồi file `.dev.vars` trên máy đó hoặc đổi khóa.

## Bước S4 — Kiểm tra lần cuối Stage 1/2

Mở trình duyệt (thay bằng link thật của nhóm):

1. `https://<ten-project>.pages.dev/api/health` — thấy
   `"d1_configured": true` và `"teacher_key_configured": true`
   (giáo viên đã chuẩn bị xong ở phần 0).
2. `https://<ten-project>.pages.dev/nhat-ky` — trang Nhật ký hiện đủ mục
   từ D1 (không còn đọc file JSON nữa, trừ khi API không dùng được).
3. Ghi thử 1 mục qua API theo ví dụ ở bước S3, thấy mục mới hiện lên trang.

- **Nếu `/api/health` báo `d1_configured: false`:** giáo viên vào
  Dashboard → Pages project → Settings → Functions → D1 database
  bindings → gắn database của nhóm vào binding `DB`, rồi deploy lại.
  File `wrangler.toml` vốn là nguồn cấu hình chuẩn nên thường không
  cần bước này — chỉ làm khi kiểm tra báo false. Học viên báo giáo
  viên, không tự sửa.
- **Nếu trang nhật ký trống sau khi lên D1:** mở `/api/health` xem
  `d1_configured` có phải `true` không. Nếu `true` mà trang vẫn trống
  thì kiểm tra migration đã chạy `--remote` chưa (bước S2, giáo viên
  chạy) — API trả lỗi 500 lúc này là lỗi thật, trang sẽ báo "tạm thời
  chưa tải được" chứ không tự hiện file JSON ví dụ che lỗi.
