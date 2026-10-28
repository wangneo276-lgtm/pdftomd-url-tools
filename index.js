const ORIGIN = 'https://pdftomd.tools';
const PATHS = new Set(['/', '/about', '/batch-pdf-to-markdown', '/blog', '/blog/best-document-format-for-chatgpt', '/blog/convert-multiple-pdfs-to-markdown', '/blog/convert-pdf-tables-to-markdown', '/blog/convert-pdf-to-markdown-locally', '/blog/convert-pdf-to-markdown-without-losing-formatting', '/blog/import-pdf-into-obsidian-as-notes', '/blog/markdown-to-pdf-page-breaks', '/blog/print-markdown-to-pdf-with-tables', '/blog/pymupdf4llm-vs-pdfplumber-vs-marker', '/convert-pdf-to-md', '/markdown-to-pdf', '/md-to-pdf', '/pdf-to-markdown-for-llm', '/pdf-to-markdown-obsidian', '/pdf-to-markdown-python', '/pdf-to-md-converter', '/privacy-policy', '/terms-of-service']);
const PAGES = {'home': '/', 'pdf-to-md': '/pdf-to-md-converter', 'convert': '/convert-pdf-to-md', 'md-to-pdf': '/md-to-pdf', 'markdown-to-pdf': '/markdown-to-pdf', 'llm': '/pdf-to-markdown-for-llm', 'batch': '/batch-pdf-to-markdown', 'obsidian': '/pdf-to-markdown-obsidian', 'python': '/pdf-to-markdown-python', 'about': '/about', 'privacy': '/privacy-policy', 'terms': '/terms-of-service', 'blog': '/blog'};
const BLOGS = {'pymupdf4llm-vs-pdfplumber-vs-marker': '/blog/pymupdf4llm-vs-pdfplumber-vs-marker', 'import-pdf-into-obsidian-as-notes': '/blog/import-pdf-into-obsidian-as-notes', 'convert-multiple-pdfs-to-markdown': '/blog/convert-multiple-pdfs-to-markdown', 'convert-pdf-to-markdown-locally': '/blog/convert-pdf-to-markdown-locally', 'markdown-to-pdf-page-breaks': '/blog/markdown-to-pdf-page-breaks', 'best-document-format-for-chatgpt': '/blog/best-document-format-for-chatgpt', 'convert-pdf-to-markdown-without-losing-formatting': '/blog/convert-pdf-to-markdown-without-losing-formatting', 'print-markdown-to-pdf-with-tables': '/blog/print-markdown-to-pdf-with-tables', 'convert-pdf-tables-to-markdown': '/blog/convert-pdf-tables-to-markdown'};
const DESCRIPTION = 'Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.';

function canonicalUrl(input) {
  if (typeof input !== "string") throw new Error("path required");
  let raw = input.trim();
  if (!raw) throw new Error("path required");
  if (raw.includes("\\") || raw.includes("%")) throw new Error("invalid path");
  const hash = raw.indexOf("#");
  if (hash >= 0) raw = raw.slice(0, hash);
  const query = raw.indexOf("?");
  if (query >= 0) raw = raw.slice(0, query);
  let path;
  const lower = raw.toLowerCase();
  if (lower.startsWith("https://") || lower.startsWith("http://") || raw.startsWith("//")) {
    let rest = raw;
    if (lower.startsWith("https://")) rest = raw.slice("https://".length);
    else if (lower.startsWith("http://")) rest = raw.slice("http://".length);
    else rest = raw.slice(2);
    const slash = rest.indexOf("/");
    const hostport = slash === -1 ? rest : rest.slice(0, slash);
    path = slash === -1 ? "/" : rest.slice(slash);
    if (hostport.includes("@")) throw new Error("userinfo not allowed");
    if (hostport.includes(":")) throw new Error("port not allowed");
    if (hostport.toLowerCase() !== 'pdftomd.tools') throw new Error("host not allowed");
  } else if (raw.startsWith("/")) {
    path = raw;
  } else {
    path = "/" + raw;
  }
  path = path.toLowerCase().replace(/\/{2,}/g, "/");
  for (const seg of path.split("/")) {
    if (seg === "." || seg === "..") throw new Error("path traversal");
  }
  if (path.length > 1) path = path.replace(/\/+$/, "");
  if (path === "") path = "/";
  if (!PATHS.has(path)) throw new Error("unknown path: " + path);
  return path === "/" ? ORIGIN + "/" : ORIGIN + path;
}

export function homeUrl() {
  return canonicalUrl("/");
}

export function pageUrl(name) {
  if (!Object.prototype.hasOwnProperty.call(PAGES, name)) throw new Error("unknown page: " + name);
  return canonicalUrl(PAGES[name]);
}

export function blogUrl(slug) {
  if (!Object.prototype.hasOwnProperty.call(BLOGS, slug)) throw new Error("unknown blog: " + slug);
  return canonicalUrl(BLOGS[slug]);
}

export function metadata() {
  return {
    name: "PDF to MD Converter",
    homepage: homeUrl(),
    description: DESCRIPTION,
  };
}

export { canonicalUrl, ORIGIN, DESCRIPTION };
