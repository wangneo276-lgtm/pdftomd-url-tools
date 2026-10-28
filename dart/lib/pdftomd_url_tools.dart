const origin = 'https://pdftomd.tools';
const description = 'Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.';
const hostName = 'pdftomd.tools';
const paths = <String>{'/', '/about', '/batch-pdf-to-markdown', '/blog', '/blog/best-document-format-for-chatgpt', '/blog/convert-multiple-pdfs-to-markdown', '/blog/convert-pdf-tables-to-markdown', '/blog/convert-pdf-to-markdown-locally', '/blog/convert-pdf-to-markdown-without-losing-formatting', '/blog/import-pdf-into-obsidian-as-notes', '/blog/markdown-to-pdf-page-breaks', '/blog/print-markdown-to-pdf-with-tables', '/blog/pymupdf4llm-vs-pdfplumber-vs-marker', '/convert-pdf-to-md', '/markdown-to-pdf', '/md-to-pdf', '/pdf-to-markdown-for-llm', '/pdf-to-markdown-obsidian', '/pdf-to-markdown-python', '/pdf-to-md-converter', '/privacy-policy', '/terms-of-service'};
const pages = <String, String>{'home': '/', 'pdf-to-md': '/pdf-to-md-converter', 'convert': '/convert-pdf-to-md', 'md-to-pdf': '/md-to-pdf', 'markdown-to-pdf': '/markdown-to-pdf', 'llm': '/pdf-to-markdown-for-llm', 'batch': '/batch-pdf-to-markdown', 'obsidian': '/pdf-to-markdown-obsidian', 'python': '/pdf-to-markdown-python', 'about': '/about', 'privacy': '/privacy-policy', 'terms': '/terms-of-service', 'blog': '/blog'};
const blogs = <String, String>{'pymupdf4llm-vs-pdfplumber-vs-marker': '/blog/pymupdf4llm-vs-pdfplumber-vs-marker', 'import-pdf-into-obsidian-as-notes': '/blog/import-pdf-into-obsidian-as-notes', 'convert-multiple-pdfs-to-markdown': '/blog/convert-multiple-pdfs-to-markdown', 'convert-pdf-to-markdown-locally': '/blog/convert-pdf-to-markdown-locally', 'markdown-to-pdf-page-breaks': '/blog/markdown-to-pdf-page-breaks', 'best-document-format-for-chatgpt': '/blog/best-document-format-for-chatgpt', 'convert-pdf-to-markdown-without-losing-formatting': '/blog/convert-pdf-to-markdown-without-losing-formatting', 'print-markdown-to-pdf-with-tables': '/blog/print-markdown-to-pdf-with-tables', 'convert-pdf-tables-to-markdown': '/blog/convert-pdf-tables-to-markdown'};

String canonicalUrl(String input) {
  final raw0 = input.trim();
  if (raw0.isEmpty) throw ArgumentError('path required');
  if (raw0.contains('\\') || raw0.contains('%')) throw ArgumentError('invalid path');
  var raw = raw0.split('#').first.split('?').first;
  final lower = raw.toLowerCase();
  late String path;
  if (lower.startsWith('https://') || lower.startsWith('http://') || raw.startsWith('//')) {
    var rest = raw;
    if (lower.startsWith('https://')) rest = raw.substring(8);
    else if (lower.startsWith('http://')) rest = raw.substring(7);
    else rest = raw.substring(2);
    final slash = rest.indexOf('/');
    final hostport = slash < 0 ? rest : rest.substring(0, slash);
    path = slash < 0 ? '/' : rest.substring(slash);
    if (hostport.contains('@')) throw ArgumentError('userinfo not allowed');
    if (hostport.contains(':')) throw ArgumentError('port not allowed');
    if (hostport.toLowerCase() != hostName) throw ArgumentError('host not allowed');
  } else if (raw.startsWith('/')) {
    path = raw;
  } else {
    path = '/$raw';
  }
  path = path.toLowerCase().replaceAll(RegExp(r'/{2,}'), '/');
  for (final seg in path.split('/')) {
    if (seg == '.' || seg == '..') throw ArgumentError('path traversal');
  }
  if (path.length > 1) path = path.replaceAll(RegExp(r'/+$'), '');
  if (path.isEmpty) path = '/';
  if (!paths.contains(path)) throw ArgumentError('unknown path: $path');
  return path == '/' ? '$origin/' : '$origin$path';
}

String homeUrl() => canonicalUrl('/');
String pageUrl(String name) {
  final path = pages[name];
  if (path == null) throw ArgumentError('unknown page: $name');
  return canonicalUrl(path);
}
String blogUrl(String slug) {
  final path = blogs[slug];
  if (path == null) throw ArgumentError('unknown blog: $slug');
  return canonicalUrl(path);
}
