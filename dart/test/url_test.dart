import 'package:pdftomd_url_tools/pdftomd_url_tools.dart';
import 'package:test/test.dart';

void main() {
  test('known pages', () {
    expect(homeUrl(), 'https://pdftomd.tools/');
    expect(pageUrl('pdf-to-md'), 'https://pdftomd.tools/pdf-to-md-converter');
    expect(blogUrl('convert-pdf-tables-to-markdown'), 'https://pdftomd.tools/blog/convert-pdf-tables-to-markdown');
    expect(canonicalUrl('https://pdftomd.tools/about?x=1#y'), 'https://pdftomd.tools/about');
    expect(() => canonicalUrl('https://example.com/'), throwsArgumentError);
  });
}
