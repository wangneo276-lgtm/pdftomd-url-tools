const ORIGIN: &str = "https://pdftomd.tools";
const DESCRIPTION: &str = "Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.";

fn known(path: &str) -> bool {
    matches!(path, "/" | "/about" | "/batch-pdf-to-markdown" | "/blog" | "/blog/best-document-format-for-chatgpt" | "/blog/convert-multiple-pdfs-to-markdown" | "/blog/convert-pdf-tables-to-markdown" | "/blog/convert-pdf-to-markdown-locally" | "/blog/convert-pdf-to-markdown-without-losing-formatting" | "/blog/import-pdf-into-obsidian-as-notes" | "/blog/markdown-to-pdf-page-breaks" | "/blog/print-markdown-to-pdf-with-tables" | "/blog/pymupdf4llm-vs-pdfplumber-vs-marker" | "/convert-pdf-to-md" | "/markdown-to-pdf" | "/md-to-pdf" | "/pdf-to-markdown-for-llm" | "/pdf-to-markdown-obsidian" | "/pdf-to-markdown-python" | "/pdf-to-md-converter" | "/privacy-policy" | "/terms-of-service")
}

pub fn canonical_url(input: &str) -> Result<String, &'static str> {
    let raw = input.trim();
    if raw.is_empty() {
        return Err("path required");
    }
    if raw.contains('\\') || raw.contains('%') {
        return Err("invalid path");
    }
    let raw = raw.split('#').next().unwrap_or(raw);
    let raw = raw.split('?').next().unwrap_or(raw);
    let lower = raw.to_ascii_lowercase();
    let path = if lower.starts_with("https://") || lower.starts_with("http://") || raw.starts_with("//") {
        let rest = if lower.starts_with("https://") {
            &raw["https://".len()..]
        } else if lower.starts_with("http://") {
            &raw["http://".len()..]
        } else {
            &raw[2..]
        };
        let (hostport, path) = match rest.find('/') {
            Some(i) => (&rest[..i], &rest[i..]),
            None => (rest, "/"),
        };
        if hostport.contains('@') {
            return Err("userinfo not allowed");
        }
        if hostport.contains(':') {
            return Err("port not allowed");
        }
        if !hostport.eq_ignore_ascii_case("pdftomd.tools") {
            return Err("host not allowed");
        }
        path.to_string()
    } else if raw.starts_with('/') {
        raw.to_string()
    } else {
        format!("/{raw}")
    };
    let mut path = path.to_ascii_lowercase();
    while path.contains("//") {
        path = path.replace("//", "/");
    }
    for seg in path.split('/') {
        if seg == "." || seg == ".." {
            return Err("path traversal");
        }
    }
    if path.len() > 1 {
        path = path.trim_end_matches('/').to_string();
    }
    if path.is_empty() {
        path = "/".to_string();
    }
    if !known(&path) {
        return Err("unknown path");
    }
    if path == "/" {
        Ok(format!("{ORIGIN}/"))
    } else {
        Ok(format!("{ORIGIN}{path}"))
    }
}

fn lookup<'a>(table: &'a [(&str, &str)], key: &str, label: &'static str) -> Result<&'a str, String> {
    table.iter().find(|(k, _)| *k == key).map(|(_, v)| *v).ok_or_else(|| format!("unknown {label}"))
}

pub fn page_url(name: &str) -> Result<String, String> {
    let path = lookup(&[("home", "/"),
        ("pdf-to-md", "/pdf-to-md-converter"),
        ("convert", "/convert-pdf-to-md"),
        ("md-to-pdf", "/md-to-pdf"),
        ("markdown-to-pdf", "/markdown-to-pdf"),
        ("llm", "/pdf-to-markdown-for-llm"),
        ("batch", "/batch-pdf-to-markdown"),
        ("obsidian", "/pdf-to-markdown-obsidian"),
        ("python", "/pdf-to-markdown-python"),
        ("about", "/about"),
        ("privacy", "/privacy-policy"),
        ("terms", "/terms-of-service"),
        ("blog", "/blog")], name, "page")?;
    canonical_url(path).map_err(|e| e.to_string())
}

pub fn blog_url(slug: &str) -> Result<String, String> {
    let path = lookup(&[("pymupdf4llm-vs-pdfplumber-vs-marker", "/blog/pymupdf4llm-vs-pdfplumber-vs-marker"),
        ("import-pdf-into-obsidian-as-notes", "/blog/import-pdf-into-obsidian-as-notes"),
        ("convert-multiple-pdfs-to-markdown", "/blog/convert-multiple-pdfs-to-markdown"),
        ("convert-pdf-to-markdown-locally", "/blog/convert-pdf-to-markdown-locally"),
        ("markdown-to-pdf-page-breaks", "/blog/markdown-to-pdf-page-breaks"),
        ("best-document-format-for-chatgpt", "/blog/best-document-format-for-chatgpt"),
        ("convert-pdf-to-markdown-without-losing-formatting", "/blog/convert-pdf-to-markdown-without-losing-formatting"),
        ("print-markdown-to-pdf-with-tables", "/blog/print-markdown-to-pdf-with-tables"),
        ("convert-pdf-tables-to-markdown", "/blog/convert-pdf-tables-to-markdown")], slug, "blog")?;
    canonical_url(path).map_err(|e| e.to_string())
}

pub fn home_url() -> String {
    canonical_url("/").expect("home")
}

pub fn description() -> &'static str {
    DESCRIPTION
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn known_pages() {
        assert_eq!(home_url(), "https://pdftomd.tools/");
        assert_eq!(page_url("pdf-to-md").unwrap(), "https://pdftomd.tools/pdf-to-md-converter");
        assert_eq!(blog_url("convert-pdf-tables-to-markdown").unwrap(), "https://pdftomd.tools/blog/convert-pdf-tables-to-markdown");
        assert_eq!(canonical_url("https://pdftomd.tools/about?x=1#y").unwrap(), "https://pdftomd.tools/about");
        assert!(canonical_url("https://example.com/").is_err());
        assert!(description().contains("Free in-browser pdf to md tool"));
    }
}
