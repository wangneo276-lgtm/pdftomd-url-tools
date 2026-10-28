module PdfToMdUrlTools
  ORIGIN = 'https://pdftomd.tools'.freeze
  DESCRIPTION = 'Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.'.freeze
  HOST = 'pdftomd.tools'.freeze
  PATHS = ['/', '/about', '/batch-pdf-to-markdown', '/blog', '/blog/best-document-format-for-chatgpt', '/blog/convert-multiple-pdfs-to-markdown', '/blog/convert-pdf-tables-to-markdown', '/blog/convert-pdf-to-markdown-locally', '/blog/convert-pdf-to-markdown-without-losing-formatting', '/blog/import-pdf-into-obsidian-as-notes', '/blog/markdown-to-pdf-page-breaks', '/blog/print-markdown-to-pdf-with-tables', '/blog/pymupdf4llm-vs-pdfplumber-vs-marker', '/convert-pdf-to-md', '/markdown-to-pdf', '/md-to-pdf', '/pdf-to-markdown-for-llm', '/pdf-to-markdown-obsidian', '/pdf-to-markdown-python', '/pdf-to-md-converter', '/privacy-policy', '/terms-of-service'].freeze
  PAGES = {'home' => '/', 'pdf-to-md' => '/pdf-to-md-converter', 'convert' => '/convert-pdf-to-md', 'md-to-pdf' => '/md-to-pdf', 'markdown-to-pdf' => '/markdown-to-pdf', 'llm' => '/pdf-to-markdown-for-llm', 'batch' => '/batch-pdf-to-markdown', 'obsidian' => '/pdf-to-markdown-obsidian', 'python' => '/pdf-to-markdown-python', 'about' => '/about', 'privacy' => '/privacy-policy', 'terms' => '/terms-of-service', 'blog' => '/blog'}.freeze
  BLOGS = {'pymupdf4llm-vs-pdfplumber-vs-marker' => '/blog/pymupdf4llm-vs-pdfplumber-vs-marker', 'import-pdf-into-obsidian-as-notes' => '/blog/import-pdf-into-obsidian-as-notes', 'convert-multiple-pdfs-to-markdown' => '/blog/convert-multiple-pdfs-to-markdown', 'convert-pdf-to-markdown-locally' => '/blog/convert-pdf-to-markdown-locally', 'markdown-to-pdf-page-breaks' => '/blog/markdown-to-pdf-page-breaks', 'best-document-format-for-chatgpt' => '/blog/best-document-format-for-chatgpt', 'convert-pdf-to-markdown-without-losing-formatting' => '/blog/convert-pdf-to-markdown-without-losing-formatting', 'print-markdown-to-pdf-with-tables' => '/blog/print-markdown-to-pdf-with-tables', 'convert-pdf-tables-to-markdown' => '/blog/convert-pdf-tables-to-markdown'}.freeze

  module_function

  def canonical_url(input)
    raise ArgumentError, 'path required' unless input.is_a?(String)
    raw = input.strip
    raise ArgumentError, 'path required' if raw.empty?
    raise ArgumentError, 'invalid path' if raw.include?('\\') || raw.include?('%')
    raw = raw.split('#', 2)[0].split('?', 2)[0]
    lower = raw.downcase
    if lower.start_with?('https://') || lower.start_with?('http://') || raw.start_with?('//')
      rest = if lower.start_with?('https://')
               raw.delete_prefix('https://')
             elsif lower.start_with?('http://')
               raw.delete_prefix('http://')
             else
               raw.delete_prefix('//')
             end
      slash = rest.index('/')
      hostport = slash.nil? ? rest : rest[0...slash]
      path = slash.nil? ? '/' : rest[slash..]
      raise ArgumentError, 'userinfo not allowed' if hostport.include?('@')
      raise ArgumentError, 'port not allowed' if hostport.include?(':')
      raise ArgumentError, 'host not allowed' unless hostport.casecmp(HOST).zero?
    elsif raw.start_with?('/')
      path = raw
    else
      path = '/' + raw
    end
    path = path.downcase.gsub(%r{//+}, '/')
    path.split('/').each do |seg|
      raise ArgumentError, 'path traversal' if seg == '.' || seg == '..'
    end
    path = path.sub(%r{/+$}, '') if path.length > 1
    path = '/' if path.empty?
    raise ArgumentError, "unknown path: #{path}" unless PATHS.include?(path)
    path == '/' ? ORIGIN + '/' : ORIGIN + path
  end

  def home_url
    canonical_url('/')
  end

  def page_url(name)
    path = PAGES[name] or raise ArgumentError, "unknown page: #{name}"
    canonical_url(path)
  end

  def blog_url(slug)
    path = BLOGS[slug] or raise ArgumentError, "unknown blog: #{slug}"
    canonical_url(path)
  end
end
