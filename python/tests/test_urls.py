import unittest
from pdftomd_url_tools import blog_url, canonical_url, home_url, metadata, page_url

class UrlsTest(unittest.TestCase):
    def test_known(self):
        self.assertEqual(home_url(), "https://pdftomd.tools/")
        self.assertEqual(page_url("pdf-to-md"), "https://pdftomd.tools/pdf-to-md-converter")
        self.assertEqual(blog_url("convert-pdf-tables-to-markdown"), "https://pdftomd.tools/blog/convert-pdf-tables-to-markdown")
        self.assertEqual(canonical_url("HTTPS://pdftomd.tools/md-to-pdf?x=1#y"), "https://pdftomd.tools/md-to-pdf")
        self.assertIn("https://pdftomd.tools/", metadata()["homepage"])
        self.assertIn("Free in-browser pdf to md tool", metadata()["description"])

    def test_reject(self):
        with self.assertRaises(ValueError):
            canonical_url("/nope")
        with self.assertRaises(ValueError):
            canonical_url("https://example.com/")

if __name__ == "__main__":
    unittest.main()
