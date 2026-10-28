package com.pdftomd.urltools;

/** Checks the canonical URL helper. */
public final class CanonicalTest {
    private CanonicalTest() {}

    /**
     * Run the checks.
     *
     * @param args unused
     */
    public static void main(String[] args) {
        if (!"https://pdftomd.tools/".equals(Canonical.homeUrl())) throw new AssertionError("home");
        if (!"https://pdftomd.tools/pdf-to-md-converter".equals(Canonical.pageUrl("pdf-to-md"))) throw new AssertionError("page");
        if (!"https://pdftomd.tools/blog/convert-pdf-tables-to-markdown".equals(Canonical.blogUrl("convert-pdf-tables-to-markdown"))) throw new AssertionError("blog");
        if (!"https://pdftomd.tools/about".equals(Canonical.canonicalUrl("https://pdftomd.tools/about?x=1#y"))) throw new AssertionError("query");
        try {
            Canonical.canonicalUrl("https://example.com/");
            throw new AssertionError("host");
        } catch (IllegalArgumentException expected) {
            System.out.println("java ok");
        }
    }
}
