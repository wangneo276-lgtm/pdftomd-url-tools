from __future__ import annotations

ORIGIN = 'https://pdftomd.tools'
DESCRIPTION = 'Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.'
PATHS = {'/blog/best-document-format-for-chatgpt', '/blog/markdown-to-pdf-page-breaks', '/pdf-to-markdown-obsidian', '/blog/print-markdown-to-pdf-with-tables', '/blog/convert-pdf-tables-to-markdown', '/blog', '/pdf-to-markdown-python', '/batch-pdf-to-markdown', '/blog/convert-pdf-to-markdown-without-losing-formatting', '/terms-of-service', '/markdown-to-pdf', '/about', '/md-to-pdf', '/pdf-to-markdown-for-llm', '/blog/convert-multiple-pdfs-to-markdown', '/blog/convert-pdf-to-markdown-locally', '/convert-pdf-to-md', '/', '/pdf-to-md-converter', '/blog/import-pdf-into-obsidian-as-notes', '/blog/pymupdf4llm-vs-pdfplumber-vs-marker', '/privacy-policy'}
PAGES = {'home': '/', 'pdf-to-md': '/pdf-to-md-converter', 'convert': '/convert-pdf-to-md', 'md-to-pdf': '/md-to-pdf', 'markdown-to-pdf': '/markdown-to-pdf', 'llm': '/pdf-to-markdown-for-llm', 'batch': '/batch-pdf-to-markdown', 'obsidian': '/pdf-to-markdown-obsidian', 'python': '/pdf-to-markdown-python', 'about': '/about', 'privacy': '/privacy-policy', 'terms': '/terms-of-service', 'blog': '/blog'}
BLOGS = {'pymupdf4llm-vs-pdfplumber-vs-marker': '/blog/pymupdf4llm-vs-pdfplumber-vs-marker', 'import-pdf-into-obsidian-as-notes': '/blog/import-pdf-into-obsidian-as-notes', 'convert-multiple-pdfs-to-markdown': '/blog/convert-multiple-pdfs-to-markdown', 'convert-pdf-to-markdown-locally': '/blog/convert-pdf-to-markdown-locally', 'markdown-to-pdf-page-breaks': '/blog/markdown-to-pdf-page-breaks', 'best-document-format-for-chatgpt': '/blog/best-document-format-for-chatgpt', 'convert-pdf-to-markdown-without-losing-formatting': '/blog/convert-pdf-to-markdown-without-losing-formatting', 'print-markdown-to-pdf-with-tables': '/blog/print-markdown-to-pdf-with-tables', 'convert-pdf-tables-to-markdown': '/blog/convert-pdf-tables-to-markdown'}
HOST = 'pdftomd.tools'


def canonical_url(value: str) -> str:
    if not isinstance(value, str):
        raise ValueError("path required")
    raw = value.strip()
    if not raw:
        raise ValueError("path required")
    if "\\" in raw or "%" in raw:
        raise ValueError("invalid path")
    raw = raw.split("#", 1)[0].split("?", 1)[0]
    lower = raw.lower()
    if lower.startswith("https://") or lower.startswith("http://") or raw.startswith("//"):
        if lower.startswith("https://"):
            rest = raw[len("https://"):]
        elif lower.startswith("http://"):
            rest = raw[len("http://"):]
        else:
            rest = raw[2:]
        slash = rest.find("/")
        hostport = rest if slash < 0 else rest[:slash]
        path = "/" if slash < 0 else rest[slash:]
        if "@" in hostport:
            raise ValueError("userinfo not allowed")
        if ":" in hostport:
            raise ValueError("port not allowed")
        if hostport.lower() != HOST:
            raise ValueError("host not allowed")
    elif raw.startswith("/"):
        path = raw
    else:
        path = "/" + raw
    while "//" in path:
        path = path.replace("//", "/")
    path = path.lower()
    for seg in path.split("/"):
        if seg in {".", ".."}:
            raise ValueError("path traversal")
    if len(path) > 1:
        path = path.rstrip("/")
    if path == "":
        path = "/"
    if path not in PATHS:
        raise ValueError("unknown path: " + path)
    return ORIGIN + "/" if path == "/" else ORIGIN + path


def home_url() -> str:
    return canonical_url("/")


def page_url(name: str) -> str:
    if name not in PAGES:
        raise ValueError("unknown page: " + name)
    return canonical_url(PAGES[name])


def blog_url(slug: str) -> str:
    if slug not in BLOGS:
        raise ValueError("unknown blog: " + slug)
    return canonical_url(BLOGS[slug])


def metadata() -> dict:
    return {"name": "PDF to MD Converter", "homepage": home_url(), "description": DESCRIPTION}
