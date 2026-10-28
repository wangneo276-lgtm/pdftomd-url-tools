# pdftomd-url-tools

Builds canonical HTTPS URLs for pages that exist on [PDF to MD Converter](https://pdftomd.tools/).

Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.

Not an official SDK. The helper only accepts paths that are already on the public site. It does not upload files or call the site.

## Examples

- `canonicalUrl("/")` → https://pdftomd.tools/
- `canonicalUrl("https://pdftomd.tools/md-to-pdf?ref=1#top")` → https://pdftomd.tools/md-to-pdf
- `pageUrl("pdf-to-md")` → https://pdftomd.tools/pdf-to-md-converter
- `pageUrl("markdown-to-pdf")` → https://pdftomd.tools/markdown-to-pdf
- `blogUrl("convert-pdf-tables-to-markdown")` → https://pdftomd.tools/blog/convert-pdf-tables-to-markdown

Source: https://github.com/wangneo276-lgtm/pdftomd-url-tools

License: MIT.
