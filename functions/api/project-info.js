// API Thông tin dự án — Cloudflare Pages Function.
// GET /api/project-info -> nội dung public/data/project-info.json đã validate.
// Dữ liệu đã qua merge PR = đã qua giáo viên duyệt nên endpoint này công khai,
// không cần key. File thiếu / JSON lỗi / validate trượt -> 503 (fail-closed).
// Không dùng D1: file trong repo là nguồn sự thật duy nhất, API chỉ validate
// và phục vụ (khớp nguyên tắc "một nguồn sự thật" của template).
var STATUSES = ["todo", "in_progress", "done"];
var MILESTONES = ["M0", "M1", "M2", "M3"];

function jsonResponse(obj, status, cache) {
  var headers = { "content-type": "application/json; charset=utf-8" };
  if (cache) { headers["cache-control"] = "public, max-age=300"; }
  return new Response(JSON.stringify(obj), { status: status || 200, headers: headers });
}

function isValidDate(s) {
  // Kiểm tra ngày thật trên lịch, không chỉ đúng dạng chữ (kiểu changelog.js).
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

function isNonEmptyString(v, maxLen) {
  return typeof v === "string" && !!v.trim() && (!maxLen || v.length <= maxLen);
}

function isHttpUrl(v) {
  return typeof v === "string" && /^https?:\/\//.test(v) && v.length <= 500;
}

function validate(info) {
  if (!info || typeof info !== "object" || Array.isArray(info)) { return false; }
  if (info.schema_version !== 1) { return false; }
  if (!isNonEmptyString(info.group_id, 100)) { return false; }
  if (!isNonEmptyString(info.project_name, 200)) { return false; }
  if (!isNonEmptyString(info.tagline, 500)) { return false; }
  if (!isNonEmptyString(info.description, 500)) { return false; }
  if (info.description_en !== undefined && info.description_en !== null &&
      !isNonEmptyString(info.description_en, 500)) { return false; }
  if (info.production_url !== undefined && info.production_url !== null &&
      !isHttpUrl(info.production_url)) { return false; }
  if (info.repo_url !== undefined && info.repo_url !== null &&
      !isHttpUrl(info.repo_url)) { return false; }
  if (info.screenshot_url !== undefined && info.screenshot_url !== null &&
      !isHttpUrl(info.screenshot_url)) { return false; }
  if (!info.milestones || typeof info.milestones !== "object") { return false; }
  for (var i = 0; i < MILESTONES.length; i++) {
    var m = info.milestones[MILESTONES[i]];
    if (!m || typeof m !== "object") { return false; }
    if (STATUSES.indexOf(m.status) === -1) { return false; }
    if (m.date !== null && !isValidDate(m.date)) { return false; }
  }
  return true;
}

export async function onRequest(context) {
  var request = context.request;
  if (request.method !== "GET") {
    return jsonResponse({ error: "Chỉ hỗ trợ GET." }, 405);
  }
  var data;
  try {
    // Fetch cùng origin (cơ chế F-15 đã chốt): đọc file tĩnh trong repo,
    // không đọc đĩa, không dùng D1.
    var res = await fetch(new URL("/data/project-info.json", request.url));
    if (!res.ok) {
      console.error("GET /api/project-info: file missing, status", res.status);
      return jsonResponse({ error: "Chưa có thông tin dự án hợp lệ." }, 503);
    }
    data = await res.json();
  } catch (err) {
    console.error("GET /api/project-info failed:", err);
    return jsonResponse({ error: "Chưa có thông tin dự án hợp lệ." }, 503);
  }
  if (!validate(data)) {
    console.error("GET /api/project-info: validate failed");
    return jsonResponse({ error: "Chưa có thông tin dự án hợp lệ." }, 503);
  }
  return jsonResponse(data, 200, true);
}
