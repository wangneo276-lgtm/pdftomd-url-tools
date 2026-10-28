import PdfToMdUrlTools

guard PdfToMdUrlTools.homeUrl() == "https://pdftomd.tools/" else { fatalError("home") }
guard try PdfToMdUrlTools.pageUrl("pdf-to-md") == "https://pdftomd.tools/pdf-to-md-converter" else { fatalError("page") }
guard try PdfToMdUrlTools.blogUrl("convert-pdf-tables-to-markdown") == "https://pdftomd.tools/blog/convert-pdf-tables-to-markdown" else { fatalError("blog") }
print("swift ok")
