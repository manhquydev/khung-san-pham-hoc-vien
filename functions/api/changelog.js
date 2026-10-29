// API Nhật ký phát triển — Cloudflare Pages Function.
// GET  /api/changelog  -> danh sách mục nhật ký, mới nhất trước.
// POST /api/changelog  -> thêm 1 mục mới (cần header x-teacher-key khớp
//   với secret TEACHER_KEY). Đây là cổng giữ lớp học, KHÔNG phải hệ thống
//   đăng nhập thật — xem README và docs/gioi-han-free.md trước khi dùng
//   cho dữ liệu quan trọng. Dữ liệu thật luôn cần review của giáo viên.
//
// D1 binding: DB (khai báo trong wrangler.toml). Khi chưa cấu hình D1,
// GET trả 503 và trang nhat-ky.html tự dùng public/data/changelog.json (Stage 0).

var CATEGORIES = ["Giao diện", "Tính năng mới", "Sửa lỗi", "Cải tiến"];

function jsonResponse(obj, status) {
  return new Response(JSON.stringify(obj), {
    status: status || 200,
    headers: { "content-type": "application/json; charset=utf-8" },
  });
}

function isValidDate(s) {
  // Kiểm tra ngày thật trên lịch, không chỉ đúng dạng chữ:
  // "2026-13-40" hay "2026-02-30" đúng dạng nhưng không phải ngày thật.
  if (typeof s !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(s)) { return false; }
  var parts = s.split("-");
  var y = parseInt(parts[0], 10);
  var m = parseInt(parts[1], 10);
  var d = parseInt(parts[2], 10);
  var dt = new Date(Date.UTC(y, m - 1, d));
  return (
    dt.getUTCFullYear() === y &&
    dt.getUTCMonth() === m - 1 &&
    dt.getUTCDate() === d
  );
}

// So sánh khóa từng ký tự (không dừng sớm giữa chừng), nhưng hàm vẫn trả
// false ngay khi hai khóa khác độ dài — nên độ dài của khóa đúng vẫn có
// thể lộ qua thời gian đo được. Rò rỉ này được chấp nhận vì đây chỉ là
// cổng giữ lớp học, không phải hệ thống đăng nhập thật (xem cuối file).
function keysEqual(a, b) {
  if (typeof a !== "string" || typeof b !== "string") { return false; }
  if (a.length !== b.length) { return false; }
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return diff === 0;
}

export async function onRequest(context) {
  var env = context.env;
  var request = context.request;

  if (!env.DB) {
    return jsonResponse(
      { error: "Chưa cấu hình database D1 (binding DB). Trang đang dùng file JSON dự phòng." },
      503
    );
  }

  if (request.method === "GET") {
    try {
      var result = await env.DB.prepare(
        "SELECT id, ngay, tieu_de, mo_ta, loai, pr_url FROM changelog ORDER BY ngay DESC, id DESC"
      ).all();
      var entries = (result.results || []).map(function (row) {
        return {
          date: row.ngay,
          title: row.tieu_de,
          description: row.mo_ta,
          category: row.loai,
          pr_url: row.pr_url || null,
        };
      });
      return jsonResponse(entries);
    } catch (err) {
      console.error("GET /api/changelog failed:", err);
      return jsonResponse({ error: "Không đọc được database. Kiểm tra migration đã chạy chưa (xem docs/setup-windows.md phần Stage 1/2)." }, 500);
    }
  }

  if (request.method === "POST") {
    // Cổng giữ lớp học: so sánh khóa giáo viên. Không có khóa đã cấu hình
    // thì từ chối mọi lần ghi (fail-closed) thay vì mở ghi tự do.
    if (!env.TEACHER_KEY) {
      return jsonResponse(
        { error: "Chưa cấu hình TEACHER_KEY (xem docs/setup-windows.md phần Stage 1/2). Không nhận ghi mới." },
        503
      );
    }
    if (request.headers.get("x-teacher-key") === null || !keysEqual(request.headers.get("x-teacher-key"), env.TEACHER_KEY)) {
      return jsonResponse({ error: "Thiếu hoặc sai khóa giáo viên." }, 401);
    }

    var body;
    try {
      body = await request.json();
    } catch (err) {
      return jsonResponse({ error: "Nội dung gửi lên phải là JSON." }, 400);
    }

    var ngay = body.date;
    var tieu_de = body.title;
    var mo_ta = body.description;
    var loai = body.category;
    var pr_url = body.pr_url || null;

    if (!isValidDate(ngay)) {
      return jsonResponse({ error: "date phải có dạng YYYY-MM-DD." }, 400);
    }
    if (typeof tieu_de !== "string" || !tieu_de.trim() || tieu_de.length > 200) {
      return jsonResponse({ error: "title phải là chuỗi không rỗng, tối đa 200 ký tự." }, 400);
    }
    if (typeof mo_ta !== "string" || !mo_ta.trim() || mo_ta.length > 1000) {
      return jsonResponse({ error: "description phải là chuỗi không rỗng, tối đa 1000 ký tự." }, 400);
    }
    if (CATEGORIES.indexOf(loai) === -1) {
      return jsonResponse(
        { error: "category phải là một trong: " + CATEGORIES.join(", ") + "." },
        400
      );
    }
    if (pr_url !== null && (typeof pr_url !== "string" || pr_url.length > 500 || !/^https?:\/\//.test(pr_url))) {
      return jsonResponse({ error: "pr_url phải là null hoặc đường link bắt đầu bằng http:// hoặc https://, tối đa 500 ký tự." }, 400);
    }

    try {
      var inserted = await env.DB.prepare(
        "INSERT INTO changelog (ngay, tieu_de, mo_ta, loai, pr_url, created_at) VALUES (?, ?, ?, ?, ?, datetime('now'))"
      )
        .bind(ngay, tieu_de.trim(), mo_ta.trim(), loai, pr_url)
        .run();
      return jsonResponse(
        {
          id: inserted.meta.last_row_id,
          date: ngay,
          title: tieu_de.trim(),
          description: mo_ta.trim(),
          category: loai,
          pr_url: pr_url,
        },
        201
      );
    } catch (err) {
      console.error("POST /api/changelog failed:", err);
      return jsonResponse({ error: "Không ghi được vào database. Kiểm tra migration đã chạy chưa (xem docs/setup-windows.md phần Stage 1/2)." }, 500);
    }
  }

  return jsonResponse({ error: "Chỉ hỗ trợ GET và POST." }, 405);
}
