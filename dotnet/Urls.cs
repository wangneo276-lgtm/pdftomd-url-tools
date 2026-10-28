namespace PdfToMd.UrlTools;

public static class Urls
{
    public const string Origin = "https://pdftomd.tools";
    public const string Description = "Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.";
    private const string Host = "pdftomd.tools";
    private static readonly HashSet<string> Paths = new(StringComparer.Ordinal)
    {
        "/", "/about", "/batch-pdf-to-markdown", "/blog", "/blog/best-document-format-for-chatgpt", "/blog/convert-multiple-pdfs-to-markdown", "/blog/convert-pdf-tables-to-markdown", "/blog/convert-pdf-to-markdown-locally", "/blog/convert-pdf-to-markdown-without-losing-formatting", "/blog/import-pdf-into-obsidian-as-notes", "/blog/markdown-to-pdf-page-breaks", "/blog/print-markdown-to-pdf-with-tables", "/blog/pymupdf4llm-vs-pdfplumber-vs-marker", "/convert-pdf-to-md", "/markdown-to-pdf", "/md-to-pdf", "/pdf-to-markdown-for-llm", "/pdf-to-markdown-obsidian", "/pdf-to-markdown-python", "/pdf-to-md-converter", "/privacy-policy", "/terms-of-service"
    };
    private static readonly Dictionary<string, string> Pages = new()
    {
        ["home"] = "/", ["pdf-to-md"] = "/pdf-to-md-converter", ["convert"] = "/convert-pdf-to-md", ["md-to-pdf"] = "/md-to-pdf", ["markdown-to-pdf"] = "/markdown-to-pdf", ["llm"] = "/pdf-to-markdown-for-llm", ["batch"] = "/batch-pdf-to-markdown", ["obsidian"] = "/pdf-to-markdown-obsidian", ["python"] = "/pdf-to-markdown-python", ["about"] = "/about", ["privacy"] = "/privacy-policy", ["terms"] = "/terms-of-service", ["blog"] = "/blog"
    };
    private static readonly Dictionary<string, string> Blogs = new()
    {
        ["pymupdf4llm-vs-pdfplumber-vs-marker"] = "/blog/pymupdf4llm-vs-pdfplumber-vs-marker", ["import-pdf-into-obsidian-as-notes"] = "/blog/import-pdf-into-obsidian-as-notes", ["convert-multiple-pdfs-to-markdown"] = "/blog/convert-multiple-pdfs-to-markdown", ["convert-pdf-to-markdown-locally"] = "/blog/convert-pdf-to-markdown-locally", ["markdown-to-pdf-page-breaks"] = "/blog/markdown-to-pdf-page-breaks", ["best-document-format-for-chatgpt"] = "/blog/best-document-format-for-chatgpt", ["convert-pdf-to-markdown-without-losing-formatting"] = "/blog/convert-pdf-to-markdown-without-losing-formatting", ["print-markdown-to-pdf-with-tables"] = "/blog/print-markdown-to-pdf-with-tables", ["convert-pdf-tables-to-markdown"] = "/blog/convert-pdf-tables-to-markdown"
    };

    public static string CanonicalUrl(string input)
    {
        if (input is null) throw new ArgumentException("path required");
        var raw = input.Trim();
        if (raw.Length == 0) throw new ArgumentException("path required");
        if (raw.Contains('\\') || raw.Contains('%')) throw new ArgumentException("invalid path");
        var hash = raw.IndexOf('#');
        if (hash >= 0) raw = raw[..hash];
        var query = raw.IndexOf('?');
        if (query >= 0) raw = raw[..query];
        string path;
        var lower = raw.ToLowerInvariant();
        if (lower.StartsWith("https://") || lower.StartsWith("http://") || raw.StartsWith("//"))
        {
            var rest = raw;
            if (lower.StartsWith("https://")) rest = raw[8..];
            else if (lower.StartsWith("http://")) rest = raw[7..];
            else rest = raw[2..];
            var slash = rest.IndexOf('/');
            var hostport = slash < 0 ? rest : rest[..slash];
            path = slash < 0 ? "/" : rest[slash..];
            if (hostport.Contains('@')) throw new ArgumentException("userinfo not allowed");
            if (hostport.Contains(':')) throw new ArgumentException("port not allowed");
            if (!hostport.Equals(Host, StringComparison.OrdinalIgnoreCase)) throw new ArgumentException("host not allowed");
        }
        else if (raw.StartsWith("/")) path = raw;
        else path = "/" + raw;
        path = path.ToLowerInvariant();
        while (path.Contains("//")) path = path.Replace("//", "/");
        foreach (var seg in path.Split('/'))
        {
            if (seg is "." or "..") throw new ArgumentException("path traversal");
        }
        if (path.Length > 1) path = path.TrimEnd('/');
        if (path.Length == 0) path = "/";
        if (!Paths.Contains(path)) throw new ArgumentException("unknown path: " + path);
        return path == "/" ? Origin + "/" : Origin + path;
    }

    public static string HomeUrl() => CanonicalUrl("/");
    public static string PageUrl(string name) => Pages.TryGetValue(name, out var path) ? CanonicalUrl(path) : throw new ArgumentException("unknown page: " + name);
    public static string BlogUrl(string slug) => Blogs.TryGetValue(slug, out var path) ? CanonicalUrl(path) : throw new ArgumentException("unknown blog: " + slug);
}
