import Foundation

public enum PdfToMdUrlTools {
    public static let origin = "https://pdftomd.tools"
    public static let description = "Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required."
    private static let host = "pdftomd.tools"
    private static let paths: Set<String> = ["/", "/about", "/batch-pdf-to-markdown", "/blog", "/blog/best-document-format-for-chatgpt", "/blog/convert-multiple-pdfs-to-markdown", "/blog/convert-pdf-tables-to-markdown", "/blog/convert-pdf-to-markdown-locally", "/blog/convert-pdf-to-markdown-without-losing-formatting", "/blog/import-pdf-into-obsidian-as-notes", "/blog/markdown-to-pdf-page-breaks", "/blog/print-markdown-to-pdf-with-tables", "/blog/pymupdf4llm-vs-pdfplumber-vs-marker", "/convert-pdf-to-md", "/markdown-to-pdf", "/md-to-pdf", "/pdf-to-markdown-for-llm", "/pdf-to-markdown-obsidian", "/pdf-to-markdown-python", "/pdf-to-md-converter", "/privacy-policy", "/terms-of-service"]
    private static let pages = ["home": "/", "pdf-to-md": "/pdf-to-md-converter", "convert": "/convert-pdf-to-md", "md-to-pdf": "/md-to-pdf", "markdown-to-pdf": "/markdown-to-pdf", "llm": "/pdf-to-markdown-for-llm", "batch": "/batch-pdf-to-markdown", "obsidian": "/pdf-to-markdown-obsidian", "python": "/pdf-to-markdown-python", "about": "/about", "privacy": "/privacy-policy", "terms": "/terms-of-service", "blog": "/blog"]
    private static let blogs = ["pymupdf4llm-vs-pdfplumber-vs-marker": "/blog/pymupdf4llm-vs-pdfplumber-vs-marker", "import-pdf-into-obsidian-as-notes": "/blog/import-pdf-into-obsidian-as-notes", "convert-multiple-pdfs-to-markdown": "/blog/convert-multiple-pdfs-to-markdown", "convert-pdf-to-markdown-locally": "/blog/convert-pdf-to-markdown-locally", "markdown-to-pdf-page-breaks": "/blog/markdown-to-pdf-page-breaks", "best-document-format-for-chatgpt": "/blog/best-document-format-for-chatgpt", "convert-pdf-to-markdown-without-losing-formatting": "/blog/convert-pdf-to-markdown-without-losing-formatting", "print-markdown-to-pdf-with-tables": "/blog/print-markdown-to-pdf-with-tables", "convert-pdf-tables-to-markdown": "/blog/convert-pdf-tables-to-markdown"]

    public static func canonicalUrl(_ input: String) throws -> String {
        var raw = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if raw.isEmpty { throw UrlError.message("path required") }
        if raw.contains("\\") || raw.contains("%") { throw UrlError.message("invalid path") }
        if let hash = raw.firstIndex(of: "#") { raw = String(raw[..<hash]) }
        if let query = raw.firstIndex(of: "?") { raw = String(raw[..<query]) }
        let lower = raw.lowercased()
        var path: String
        if lower.hasPrefix("https://") || lower.hasPrefix("http://") || raw.hasPrefix("//") {
            var rest = raw
            if lower.hasPrefix("https://") { rest = String(raw.dropFirst(8)) }
            else if lower.hasPrefix("http://") { rest = String(raw.dropFirst(7)) }
            else { rest = String(raw.dropFirst(2)) }
            let hostport: String
            if let slash = rest.firstIndex(of: "/") {
                hostport = String(rest[..<slash])
                path = String(rest[slash...])
            } else {
                hostport = rest
                path = "/"
            }
            if hostport.contains("@") { throw UrlError.message("userinfo not allowed") }
            if hostport.contains(":") { throw UrlError.message("port not allowed") }
            if hostport.lowercased() != host { throw UrlError.message("host not allowed") }
        } else if raw.hasPrefix("/") {
            path = raw
        } else {
            path = "/" + raw
        }
        path = path.lowercased()
        while path.contains("//") { path = path.replacingOccurrences(of: "//", with: "/") }
        for seg in path.split(separator: "/", omittingEmptySubsequences: false) {
            if seg == "." || seg == ".." { throw UrlError.message("path traversal") }
        }
        if path.count > 1 {
            while path.hasSuffix("/") { path.removeLast() }
        }
        if path.isEmpty { path = "/" }
        if !paths.contains(path) { throw UrlError.message("unknown path") }
        return path == "/" ? origin + "/" : origin + path
    }

    public static func homeUrl() -> String { try! canonicalUrl("/") }
    public static func pageUrl(_ name: String) throws -> String {
        guard let path = pages[name] else { throw UrlError.message("unknown page") }
        return try canonicalUrl(path)
    }
    public static func blogUrl(_ slug: String) throws -> String {
        guard let path = blogs[slug] else { throw UrlError.message("unknown blog") }
        return try canonicalUrl(path)
    }
}

public enum UrlError: Error { case message(String) }
