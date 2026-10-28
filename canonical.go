// Package pdftomd builds canonical HTTPS URLs for pages on https://pdftomd.tools/.
package pdftomd

import (
	"fmt"
	"strings"
)

const Origin = "https://pdftomd.tools"
const Description = "Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required."

var paths = map[string]struct{}{
	"/": struct{}{},
	"/about": struct{}{},
	"/batch-pdf-to-markdown": struct{}{},
	"/blog": struct{}{},
	"/blog/best-document-format-for-chatgpt": struct{}{},
	"/blog/convert-multiple-pdfs-to-markdown": struct{}{},
	"/blog/convert-pdf-tables-to-markdown": struct{}{},
	"/blog/convert-pdf-to-markdown-locally": struct{}{},
	"/blog/convert-pdf-to-markdown-without-losing-formatting": struct{}{},
	"/blog/import-pdf-into-obsidian-as-notes": struct{}{},
	"/blog/markdown-to-pdf-page-breaks": struct{}{},
	"/blog/print-markdown-to-pdf-with-tables": struct{}{},
	"/blog/pymupdf4llm-vs-pdfplumber-vs-marker": struct{}{},
	"/convert-pdf-to-md": struct{}{},
	"/markdown-to-pdf": struct{}{},
	"/md-to-pdf": struct{}{},
	"/pdf-to-markdown-for-llm": struct{}{},
	"/pdf-to-markdown-obsidian": struct{}{},
	"/pdf-to-markdown-python": struct{}{},
	"/pdf-to-md-converter": struct{}{},
	"/privacy-policy": struct{}{},
	"/terms-of-service": struct{}{},
}

var pages = map[string]string{
	"home": "/",
	"pdf-to-md": "/pdf-to-md-converter",
	"convert": "/convert-pdf-to-md",
	"md-to-pdf": "/md-to-pdf",
	"markdown-to-pdf": "/markdown-to-pdf",
	"llm": "/pdf-to-markdown-for-llm",
	"batch": "/batch-pdf-to-markdown",
	"obsidian": "/pdf-to-markdown-obsidian",
	"python": "/pdf-to-markdown-python",
	"about": "/about",
	"privacy": "/privacy-policy",
	"terms": "/terms-of-service",
	"blog": "/blog",
}

var blogs = map[string]string{
	"pymupdf4llm-vs-pdfplumber-vs-marker": "/blog/pymupdf4llm-vs-pdfplumber-vs-marker",
	"import-pdf-into-obsidian-as-notes": "/blog/import-pdf-into-obsidian-as-notes",
	"convert-multiple-pdfs-to-markdown": "/blog/convert-multiple-pdfs-to-markdown",
	"convert-pdf-to-markdown-locally": "/blog/convert-pdf-to-markdown-locally",
	"markdown-to-pdf-page-breaks": "/blog/markdown-to-pdf-page-breaks",
	"best-document-format-for-chatgpt": "/blog/best-document-format-for-chatgpt",
	"convert-pdf-to-markdown-without-losing-formatting": "/blog/convert-pdf-to-markdown-without-losing-formatting",
	"print-markdown-to-pdf-with-tables": "/blog/print-markdown-to-pdf-with-tables",
	"convert-pdf-tables-to-markdown": "/blog/convert-pdf-tables-to-markdown",
}

func CanonicalURL(input string) (string, error) {
	raw := strings.TrimSpace(input)
	if raw == "" {
		return "", fmt.Errorf("path required")
	}
	if strings.Contains(raw, "\\") || strings.Contains(raw, "%") {
		return "", fmt.Errorf("invalid path")
	}
	if i := strings.IndexByte(raw, '#'); i >= 0 {
		raw = raw[:i]
	}
	if i := strings.IndexByte(raw, '?'); i >= 0 {
		raw = raw[:i]
	}
	lower := strings.ToLower(raw)
	var path string
	switch {
	case strings.HasPrefix(lower, "https://"), strings.HasPrefix(lower, "http://"), strings.HasPrefix(raw, "//"):
		rest := raw
		switch {
		case strings.HasPrefix(lower, "https://"):
			rest = raw[len("https://"):]
		case strings.HasPrefix(lower, "http://"):
			rest = raw[len("http://"):]
		default:
			rest = raw[2:]
		}
		hostport := rest
		path = "/"
		if i := strings.IndexByte(rest, '/'); i >= 0 {
			hostport = rest[:i]
			path = rest[i:]
		}
		if strings.Contains(hostport, "@") {
			return "", fmt.Errorf("userinfo not allowed")
		}
		if strings.Contains(hostport, ":") {
			return "", fmt.Errorf("port not allowed")
		}
		if !strings.EqualFold(hostport, "pdftomd.tools") {
			return "", fmt.Errorf("host not allowed")
		}
	case strings.HasPrefix(raw, "/"):
		path = raw
	default:
		path = "/" + raw
	}
	path = strings.ToLower(path)
	for strings.Contains(path, "//") {
		path = strings.ReplaceAll(path, "//", "/")
	}
	for _, seg := range strings.Split(path, "/") {
		if seg == "." || seg == ".." {
			return "", fmt.Errorf("path traversal")
		}
	}
	if len(path) > 1 {
		path = strings.TrimRight(path, "/")
	}
	if path == "" {
		path = "/"
	}
	if _, ok := paths[path]; !ok {
		return "", fmt.Errorf("unknown path: %s", path)
	}
	if path == "/" {
		return Origin + "/", nil
	}
	return Origin + path, nil
}

func lookup(table map[string]string, key, label string) (string, error) {
	path, ok := table[key]
	if !ok {
		return "", fmt.Errorf("unknown %s: %s", label, key)
	}
	return CanonicalURL(path)
}

func HomeURL() string {
	u, err := CanonicalURL("/")
	if err != nil {
		panic(err)
	}
	return u
}

func PageURL(name string) (string, error) { return lookup(pages, name, "page") }
func BlogURL(slug string) (string, error) { return lookup(blogs, slug, "blog") }
