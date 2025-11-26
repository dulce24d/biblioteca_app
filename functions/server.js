// server.js — proxy local simple (Express + node-fetch)
// Usage: http://localhost:8080/proxy?url=<encoded_url>
const express = require("express");
const fetch = require("node-fetch");
const cors = require("cors");

const app = express();
app.use(cors()); // permite CORS desde cualquier origen (dev only)

app.get("/proxy", async (req, res) => {
  const target = req.query.url;
  if (!target) {
    return res.status(400).send("Missing ?url=");
  }

  try {
    console.log("Proxy ->", target);
    const response = await fetch(String(target), { redirect: "follow", timeout: 15000 });

    const contentType = response.headers.get("content-type") || "application/octet-stream";
    const buffer = Buffer.from(await response.arrayBuffer());

    res.set("Content-Type", contentType);
    // cache opcional en dev
    res.set("Cache-Control", "public, max-age=3600");
    return res.status(response.status).send(buffer);
  } catch (err) {
    console.error("Proxy error:", err && err.message ? err.message : err);
    return res.status(500).send("Proxy error: " + (err && err.message ? err.message : String(err)));
  }
});

const port = process.env.PORT || 8080;
app.listen(port, () => console.log("Local proxy running on http://localhost:" + port));
