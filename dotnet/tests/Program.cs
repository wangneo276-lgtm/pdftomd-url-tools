using PdfToMd.UrlTools;

if (Urls.HomeUrl() != "https://pdftomd.tools/") return 1;
if (Urls.PageUrl("pdf-to-md") != "https://pdftomd.tools/pdf-to-md-converter") return 1;
if (Urls.BlogUrl("convert-pdf-tables-to-markdown") != "https://pdftomd.tools/blog/convert-pdf-tables-to-markdown") return 1;
if (Urls.CanonicalUrl("https://pdftomd.tools/about?x=1#y") != "https://pdftomd.tools/about") return 1;
try { Urls.CanonicalUrl("https://example.com/"); return 1; } catch (ArgumentException) {}
Console.WriteLine("dotnet ok");
return 0;
