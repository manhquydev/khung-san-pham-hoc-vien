// Nhật ký phát triển: đọc data/changelog.json, gom nhóm theo ngày, mới nhất trước.
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

  fetch("data/changelog.json")
    .then(function (res) {
      if (!res.ok) { throw new Error("HTTP " + res.status); }
      return res.json();
    })
    .then(function (entries) {
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
    })
    .catch(function () {
      timeline.innerHTML = '<div class="error"><p>Chưa tải được nhật ký. Hãy kiểm tra lại file <code>data/changelog.json</code> rồi tải lại trang.</p></div>';
    });
})();
