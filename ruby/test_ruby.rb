require_relative "lib/pdftomd_url_tools"
raise "home" unless PdfToMdUrlTools.home_url == "https://pdftomd.tools/"
raise "page" unless PdfToMdUrlTools.page_url("pdf-to-md") == "https://pdftomd.tools/pdf-to-md-converter"
raise "blog" unless PdfToMdUrlTools.blog_url("convert-pdf-tables-to-markdown") == "https://pdftomd.tools/blog/convert-pdf-tables-to-markdown"
raise "query" unless PdfToMdUrlTools.canonical_url("https://pdftomd.tools/about?x=1#y") == "https://pdftomd.tools/about"
begin
  PdfToMdUrlTools.canonical_url("https://example.com/")
  raise "host should fail"
rescue ArgumentError
end
puts "ruby ok"
