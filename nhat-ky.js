// Nhật ký phát triển: gom nhóm theo ngày, mới nhất trước.
// Nguồn dữ liệu theo từng giai đoạn (xem docs/roadmap.md):
//   - Stage 1 trở đi: gọi /api/changelog (đọc từ database D1).
//   - Stage 0 (chưa có D1): API lỗi/không có -> tự dùng data/changelog.json.
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
          html += '<p><a href="' + escapeHtml(e.pr_url) + '">Xem phần thay đổi này &rarr;</a></p>';
        }
        html += "</article>";
      });
      html += "</section>";
    });
    timeline.innerHTML = html || "<p>Chưa có mục nhật ký nào.</p>";
  }

  function fetchJson(url) {
    return fetch(url).then(function (res) {
      if (!res.ok) { throw new Error("HTTP " + res.status); }
      return res.json();
    });
  }

  // Thử API (D1) trước; chỉ khi API không dùng được mới dùng file JSON.
  // API trả về mảng rỗng là hợp lệ (database đã có nhưng chưa có mục nào):
  // trường hợp đó KHÔNG dùng lại file JSON để tránh hiện mục ví dụ cũ.
  fetchJson("/api/changelog")
    .then(function (entries) {
      if (!Array.isArray(entries)) { throw new Error("API không trả về danh sách"); }
      render(entries);
    })
    .catch(function () {
      return fetchJson("data/changelog.json")
        .then(function (entries) {
          if (!Array.isArray(entries)) { throw new Error("JSON không phải danh sách"); }
          render(entries);
        });
    })
    .catch(function () {
      timeline.innerHTML = '<div class="error"><p>Chưa tải được nhật ký. Nếu trang vừa deploy, hãy kiểm tra lại file <code>data/changelog.json</code> hoặc mở <code>/api/health</code> để xem database đã cấu hình chưa, rồi tải lại trang.</p></div>';
    });
})();
