// Cloud Function para proxificar imágenes de Google Books con CORS habilitado
const functions = require("firebase-functions");
const fetch = require("node-fetch");

exports.proxyImage = functions.https.onRequest(async (req, res) => {
  // ===== CORS GENERAL =====
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept");
  res.setHeader("Access-Control-Allow-Credentials", "false");

  // ===== manejo de preflight =====
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  const target = req.query.url;

  if (!target) {
    res.status(400).send(
        "❗ Missing ?url=  → Ejemplo: /proxyImage?url=https://books.google...",
    );
    return;
  }

  try {
    console.log("📡 Proxy Request → ", target);

    const response = await fetch(
        String(target),
        {redirect: "follow", timeout: 15000},
    );

    const contentType = response.headers.get("content-type") ||
        "application/octet-stream";

    const buffer = Buffer.from(await response.arrayBuffer());

    // CORS nuevamente para asegurar inclusión en toda salida
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Content-Type", contentType);
    res.setHeader("Cache-Control", "public, max-age=3600");

    return res.status(response.status).send(buffer);
  } catch (err) {
    console.error("🔥 Proxy ERROR →", err.message);

    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Content-Type", "text/plain; charset=utf-8");

    return res.status(500).send("Proxy error → " + err.message);
  }
});
