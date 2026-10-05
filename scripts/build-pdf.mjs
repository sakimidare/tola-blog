// Generate a PDF for every content page by compiling it with the Typst CLI.
// The layouts branch on `target()`, so the same sources render to paged output.
// Usage: node scripts/build-pdf.mjs
import { execFileSync } from "node:child_process";
import { existsSync, mkdirSync, readdirSync, readFileSync, statSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const contentDir = join(root, "content");
const outDir = join(root, "public");
const pkgPath = join(root, ".tola", "packages");
const fontDir = join(root, "fonts-pdf");
const fontArgs = existsSync(fontDir) ? ["--font-path", fontDir] : [];

// `@tola/site`'s `info` is injected by Tola as `sys.inputs.__tola_site`, which the
// bare Typst CLI cannot reproduce (inputs are strings only). Pass the needed
// fields as string inputs so paged output can credit the site/author.
function readSiteInfo(tomlPath) {
  const info = {};
  let inSection = false;
  for (const raw of readFileSync(tomlPath, "utf8").split(/\r?\n/)) {
    const line = raw.trim();
    if (line.startsWith("[")) {
      inSection = line === "[site.info]";
      continue;
    }
    if (!inSection || line === "" || line.startsWith("#")) continue;
    const match = line.match(/^([A-Za-z0-9_]+)\s*=\s*"(.*)"\s*(?:#.*)?$/);
    if (match) info[match[1]] = match[2];
  }
  return info;
}

const siteInfo = readSiteInfo(join(root, "tola.toml"));
const inputArgs = [
  "--input", `site_title=${siteInfo.title ?? ""}`,
  "--input", `site_author=${siteInfo.author ?? ""}`,
  "--input", `site_description=${siteInfo.description ?? ""}`,
  "--input", `site_language=${siteInfo.language ?? ""}`,
];

function walk(dir) {
  const files = [];
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    if (statSync(full).isDirectory()) files.push(...walk(full));
    else if (name.endsWith(".typ") && !name.startsWith("_")) files.push(full);
  }
  return files;
}

if (!existsSync(pkgPath)) {
  console.error(`[pdf] missing ${relative(root, pkgPath)}; run a Tola build first`);
  process.exit(1);
}

let ok = 0;
const files = walk(contentDir);
for (const file of files) {
  // Drafts are not published, so they get no PDF either.
  if (/draft:\s*true/.test(readFileSync(file, "utf8"))) continue;
  const rel = relative(contentDir, file).replace(/\.typ$/, "");
  const out = join(outDir, rel + ".pdf");
  mkdirSync(dirname(out), { recursive: true });
  try {
    execFileSync("typst", ["compile", "--package-path", pkgPath, "--root", root, ...fontArgs, ...inputArgs, file, out], { stdio: "pipe" });
    ok += 1;
  } catch (error) {
    const message = error.stderr?.toString().trim().split("\n").slice(0, 3).join(" ") ?? String(error);
    console.error(`[pdf] failed: ${rel} -> ${message}`);
  }
}
console.log(`[pdf] generated ${ok}/${files.length}`);
