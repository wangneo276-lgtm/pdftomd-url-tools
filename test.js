import test from "node:test";
import assert from "node:assert/strict";
import { canonicalUrl, homeUrl, pageUrl, blogUrl, metadata } from "./index.js";

test("home and known pages", () => {
  assert.equal(homeUrl(), "https://pdftomd.tools/");
  assert.equal(pageUrl("md-to-pdf"), "https://pdftomd.tools/md-to-pdf");
  assert.equal(pageUrl("pdf-to-md"), "https://pdftomd.tools/pdf-to-md-converter");
  assert.equal(blogUrl("convert-pdf-tables-to-markdown"), "https://pdftomd.tools/blog/convert-pdf-tables-to-markdown");
  assert.equal(canonicalUrl("https://pdftomd.tools/about?ref=1#top"), "https://pdftomd.tools/about");
  assert.equal(metadata().homepage, "https://pdftomd.tools/");
  assert.match(metadata().description, /Free in-browser pdf to md tool/);
});

test("rejects unknown and other hosts", () => {
  assert.throws(() => canonicalUrl("/missing"), /unknown path/);
  assert.throws(() => canonicalUrl("https://example.com/"), /host not allowed/);
  assert.throws(() => pageUrl("nope"), /unknown page/);
});
