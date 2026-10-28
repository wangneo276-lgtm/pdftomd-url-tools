package com.pdftomd.urltools;

import static java.util.Map.entry;

import java.util.Map;
import java.util.Set;

/** Canonical URLs for pages that exist on https://pdftomd.tools/. */
public final class Canonical {
    /** Site origin without a trailing path. */
    public static final String ORIGIN = "https://pdftomd.tools";
    /** Homepage description copied from the public site. */
    public static final String DESCRIPTION = "Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.";
    private static final String HOST = "pdftomd.tools";
    private static final Set<String> PATHS = Set.of("/", "/about", "/batch-pdf-to-markdown", "/blog", "/blog/best-document-format-for-chatgpt", "/blog/convert-multiple-pdfs-to-markdown", "/blog/convert-pdf-tables-to-markdown", "/blog/convert-pdf-to-markdown-locally", "/blog/convert-pdf-to-markdown-without-losing-formatting", "/blog/import-pdf-into-obsidian-as-notes", "/blog/markdown-to-pdf-page-breaks", "/blog/print-markdown-to-pdf-with-tables", "/blog/pymupdf4llm-vs-pdfplumber-vs-marker", "/convert-pdf-to-md", "/markdown-to-pdf", "/md-to-pdf", "/pdf-to-markdown-for-llm", "/pdf-to-markdown-obsidian", "/pdf-to-markdown-python", "/pdf-to-md-converter", "/privacy-policy", "/terms-of-service");
    private static final Map<String, String> PAGES = Map.ofEntries(entry("home", "/"), entry("pdf-to-md", "/pdf-to-md-converter"), entry("convert", "/convert-pdf-to-md"), entry("md-to-pdf", "/md-to-pdf"), entry("markdown-to-pdf", "/markdown-to-pdf"), entry("llm", "/pdf-to-markdown-for-llm"), entry("batch", "/batch-pdf-to-markdown"), entry("obsidian", "/pdf-to-markdown-obsidian"), entry("python", "/pdf-to-markdown-python"), entry("about", "/about"), entry("privacy", "/privacy-policy"), entry("terms", "/terms-of-service"), entry("blog", "/blog"));
    private static final Map<String, String> BLOGS = Map.ofEntries(entry("pymupdf4llm-vs-pdfplumber-vs-marker", "/blog/pymupdf4llm-vs-pdfplumber-vs-marker"), entry("import-pdf-into-obsidian-as-notes", "/blog/import-pdf-into-obsidian-as-notes"), entry("convert-multiple-pdfs-to-markdown", "/blog/convert-multiple-pdfs-to-markdown"), entry("convert-pdf-to-markdown-locally", "/blog/convert-pdf-to-markdown-locally"), entry("markdown-to-pdf-page-breaks", "/blog/markdown-to-pdf-page-breaks"), entry("best-document-format-for-chatgpt", "/blog/best-document-format-for-chatgpt"), entry("convert-pdf-to-markdown-without-losing-formatting", "/blog/convert-pdf-to-markdown-without-losing-formatting"), entry("print-markdown-to-pdf-with-tables", "/blog/print-markdown-to-pdf-with-tables"), entry("convert-pdf-tables-to-markdown", "/blog/convert-pdf-tables-to-markdown"));

    private Canonical() {}

    /**
     * Build the canonical URL for a known public path.
     *
     * @param input a site path or absolute URL on pdftomd.tools
     * @return the canonical https URL
     */
    public static String canonicalUrl(String input) {
        if (input == null) throw new IllegalArgumentException("path required");
        String raw = input.trim();
        if (raw.isEmpty()) throw new IllegalArgumentException("path required");
        if (raw.indexOf('\\') >= 0 || raw.indexOf('%') >= 0) throw new IllegalArgumentException("invalid path");
        int hash = raw.indexOf('#');
        if (hash >= 0) raw = raw.substring(0, hash);
        int query = raw.indexOf('?');
        if (query >= 0) raw = raw.substring(0, query);
        String path;
        String lower = raw.toLowerCase();
        if (lower.startsWith("https://") || lower.startsWith("http://") || raw.startsWith("//")) {
            String rest;
            if (lower.startsWith("https://")) rest = raw.substring(8);
            else if (lower.startsWith("http://")) rest = raw.substring(7);
            else rest = raw.substring(2);
            int slash = rest.indexOf('/');
            String hostport = slash < 0 ? rest : rest.substring(0, slash);
            path = slash < 0 ? "/" : rest.substring(slash);
            if (hostport.indexOf('@') >= 0) throw new IllegalArgumentException("userinfo not allowed");
            if (hostport.indexOf(':') >= 0) throw new IllegalArgumentException("port not allowed");
            if (!hostport.equalsIgnoreCase(HOST)) throw new IllegalArgumentException("host not allowed");
        } else if (raw.startsWith("/")) {
            path = raw;
        } else {
            path = "/" + raw;
        }
        path = path.toLowerCase();
        while (path.contains("//")) path = path.replace("//", "/");
        for (String seg : path.split("/", -1)) {
            if (seg.equals(".") || seg.equals("..")) throw new IllegalArgumentException("path traversal");
        }
        if (path.length() > 1) {
            while (path.endsWith("/")) path = path.substring(0, path.length() - 1);
        }
        if (path.isEmpty()) path = "/";
        if (!PATHS.contains(path)) throw new IllegalArgumentException("unknown path: " + path);
        return "/".equals(path) ? ORIGIN + "/" : ORIGIN + path;
    }

    /**
     * Homepage URL.
     *
     * @return https://pdftomd.tools/
     */
    public static String homeUrl() { return canonicalUrl("/"); }

    /**
     * URL for a named page.
     *
     * @param name page key such as pdf-to-md
     * @return canonical URL
     */
    public static String pageUrl(String name) {
        String path = PAGES.get(name);
        if (path == null) throw new IllegalArgumentException("unknown page: " + name);
        return canonicalUrl(path);
    }

    /**
     * URL for a blog slug.
     *
     * @param slug blog slug
     * @return canonical URL
     */
    public static String blogUrl(String slug) {
        String path = BLOGS.get(slug);
        if (path == null) throw new IllegalArgumentException("unknown blog: " + slug);
        return canonicalUrl(path);
    }
}
