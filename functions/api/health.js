// GET /api/health — kiểm tra môi trường đã cấu hình tới đâu.
// Chỉ trả về "có/không có", KHÔNG BAO GIỜ trả về giá trị của secret.
// Trang này dùng để chẩn đoán khi deploy lần đầu (xem docs/setup-windows.md).
export async function onRequest(context) {
  var env = context.env;
  return new Response(
    JSON.stringify({
      ok: true,
      d1_configured: !!env.DB,
      teacher_key_configured: !!env.TEACHER_KEY,
      now: new Date().toISOString(),
    }),
    { headers: { "content-type": "application/json; charset=utf-8" } }
  );
}
