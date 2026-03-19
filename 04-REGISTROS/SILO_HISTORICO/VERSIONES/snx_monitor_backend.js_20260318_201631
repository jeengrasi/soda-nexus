import { serve } from "bun";
import { readdirSync, statSync } from "fs";
import { join } from "path";

function scanFolder(path) {
  const items = readdirSync(path);
  return items.map(item => {
    const full = join(path, item);
    const stats = statSync(full);
    return {
      name: item,
      path: full,
      type: stats.isDirectory() ? "folder" : "file",
      size: stats.size,
      modified: stats.mtime
    };
  });
}

serve({
  port: 7777,
  fetch(req) {
    const url = new URL(req.url);

    if (url.pathname === "/folders") {
      const base = "/data/data/com.termux/files/home/soda";
      const tree = scanFolder(base);
      return new Response(JSON.stringify(tree, null, 2), {
        headers: { "Content-Type": "application/json" }
      });
    }

    return new Response("SNX Monitor Backend");
  }
});
