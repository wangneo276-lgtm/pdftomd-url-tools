package pdftomd

import "testing"

func TestKnown(t *testing.T) {
	if HomeURL() != "https://pdftomd.tools/" {
		t.Fatal(HomeURL())
	}
	u, err := PageURL("pdf-to-md")
	if err != nil || u != "https://pdftomd.tools/pdf-to-md-converter" {
		t.Fatal(u, err)
	}
	b, err := BlogURL("convert-pdf-tables-to-markdown")
	if err != nil || b != "https://pdftomd.tools/blog/convert-pdf-tables-to-markdown" {
		t.Fatal(b, err)
	}
	c, err := CanonicalURL("https://pdftomd.tools/about?x=1#y")
	if err != nil || c != "https://pdftomd.tools/about" {
		t.Fatal(c, err)
	}
	if _, err := CanonicalURL("https://example.com/"); err == nil {
		t.Fatal("expected host error")
	}
}
