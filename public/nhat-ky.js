// Nhật ký phát triển: gom nhóm theo ngày, mới nhất trước.
// Nguồn dữ liệu theo từng giai đoạn (xem docs/roadmap.md):
//   - Stage 1 trở đi: gọi /api/changelog (đọc từ database D1).
//   - Stage 0 (chưa có D1): API trả 503, trả 404 (chưa deploy Functions,
//     hoặc trang đang chạy trên máy chủ tĩnh thuần túy), hoặc không tới
//     được -> tự dùng data/changelog.json (file nằm cùng thư mục
//     public/). Cả 3 trường hợp đều nghĩa là "chưa có API", không phải
//     "API bị lỗi".
//   - API trả 500 là lỗi thật (ví dụ chưa chạy migration): báo lỗi rõ
//     ràng, KHÔNG dùng file JSON che lỗi (xem quy tắc fallback bên dưới).
// Cách hiển thị theo ngày và lời dễ hiểu giữ nguyên ở cả 2 nguồn.
// Không dùng từ chuyên môn ở phần hiển thị: mọi chữ trên trang đều là lời dễ hiểu.
(function () {
  var timeline = document.getElementById("timeline");

  function formatDate(iso) {
    // iso: "YYYY-MM-DD" -> "ngày D tháng M năm YYYY"
    var parts = iso.split("-");
    var y = parseInt(parts[0], 10);
    var m = parseInt(parts[1], 10);
    var d = parseInt(parts[2], 10);
    return "ngày " + d + " tháng " + m + " năm " + y;
  }

  function escapeHtml(text) {
    return String(text)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function render(entries) {
    // Mới nhất trước.
    entries.sort(function (a, b) {
      if (a.date < b.date) { return 1; }
      if (a.date > b.date) { return -1; }
      return 0;
    });
    // Gom nhóm theo ngày, giữ thứ tự ngày mới nhất trước.
    var days = [];
    var byDay = {};
    entries.forEach(function (e) {
      if (!byDay[e.date]) {
        byDay[e.date] = [];
        days.push(e.date);
      }
      byDay[e.date].push(e);
    });
    var html = "";
    days.forEach(function (day) {
      html += '<section class="day"><h2>' + escapeHtml(formatDate(day)) + "</h2>";
      byDay[day].forEach(function (e) {
        html += '<article class="entry">';
        html += "<h3>" + escapeHtml(e.title) + "</h3>";
        html += '<p><span class="tag">' + escapeHtml(e.category) + "</span></p>";
        html += "<p>" + escapeHtml(e.description) + "</p>";
        if (e.pr_url) {
          html += '<p><a href="' + escapeHtml(e.pr_url) + '">Xem chi tiết kỹ thuật (dành cho thầy cô) &rarr;</a></p>';
        }
        html += "</article>";
      });
      html += "</section>";
    });
    timeline.innerHTML = html || "<p>Chưa có mục nhật ký nào.</p>";
  }

  // Nguồn dữ liệu theo từng giai đoạn (xem docs/roadmap.md):
  //   - Stage 1 trở đi: gọi /api/changelog (đọc từ database D1).
  //   - Stage 0 (chưa có D1): API không dùng được -> tự dùng
  //     data/changelog.json (file nằm cùng thư mục public/).
  // Quy tắc fallback (quan trọng, đừng đổi bừa): chỉ dùng file JSON khi
  // API không tới được (mất mạng), trả 503 (chưa cấu hình database),
  // hoặc trả 404 (chưa deploy Functions / máy chủ tĩnh thuần túy) — cả
  // 3 trường hợp đều nghĩa là "chưa có API". API trả 500 nghĩa là
  // database đã cấu hình nhưng bị lỗi thật (ví dụ chưa chạy migration)
  // — lúc đó phải báo lỗi rõ ràng, KHÔNG được lặng lẽ hiện file JSON
  // ví dụ khiến người xem tưởng database đang chạy tốt.

  function fetchApi() {
    return fetch("/api/changelog").then(function (res) {
      if (res.status === 503 || res.status === 404) { return { fallback: true }; }
      if (!res.ok) {
        var err = new Error("API " + res.status);
        err.status = res.status;
        throw err;
      }
      return res.json().then(function (data) { return { data: data }; });
    });
  }

  function fetchJsonFile() {
    return fetch("data/changelog.json").then(function (res) {
      if (!res.ok) { throw new Error("HTTP " + res.status); }
      return res.json();
    }).then(function (entries) {
      if (!Array.isArray(entries)) { throw new Error("JSON không phải danh sách"); }
      return entries;
    });
  }

  function showParentError() {
    timeline.innerHTML = '<div class="error"><p>Trang nhật ký tạm thời chưa tải được, hãy tải lại trang sau.</p></div>';
  }

  // Thử API (D1) trước; chỉ khi API không dùng được mới dùng file JSON.
  // API trả về mảng rỗng là hợp lệ (database đã có nhưng chưa có mục nào):
  // trường hợp đó KHÔNG dùng lại file JSON để tránh hiện mục ví dụ cũ.
  fetchApi()
    .then(function (result) {
      if (result.fallback) { return fetchJsonFile().then(render); }
      if (!Array.isArray(result.data)) { throw new Error("API không trả về danh sách"); }
      render(result.data);
    })
    .catch(function (err) {
      // Mất mạng (fetch bị từ chối) -> dùng file JSON dự phòng.
      // Lỗi 500 từ API -> báo lỗi, KHÔNG dùng file JSON che lỗi.
      if (err && err.status === 500) {
        console.warn("API nhật ký báo lỗi 500: kiểm tra migration đã chạy chưa, rồi tải lại trang.");
        showParentError();
        return;
      }
      if (err && err.status) {
        // Lỗi HTTP khác (không phải 404/503 — hai mã này đã được xử lý
        // ở fetchApi) cũng không che bằng file JSON.
        console.warn("API nhật ký báo lỗi HTTP " + err.status + ": kiểm tra Functions đã deploy chưa.");
        showParentError();
        return;
      }
      return fetchJsonFile()
        .then(render)
        .catch(function () {
          console.warn("Không tải được API lẫn file data/changelog.json; kiểm tra lại deploy.");
          showParentError();
        });
    });
})();
