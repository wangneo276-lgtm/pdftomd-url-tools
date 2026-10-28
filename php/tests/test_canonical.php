<?php
require __DIR__ . '/../src/PdfToMd/UrlTools/Canonical.php';
use PdfToMd\UrlTools\Canonical;
if (Canonical::homeUrl() !== 'https://pdftomd.tools/') { fwrite(STDERR, "home\n"); exit(1); }
if (Canonical::pageUrl('pdf-to-md') !== 'https://pdftomd.tools/pdf-to-md-converter') { fwrite(STDERR, "page\n"); exit(1); }
if (Canonical::blogUrl('convert-pdf-tables-to-markdown') !== 'https://pdftomd.tools/blog/convert-pdf-tables-to-markdown') { fwrite(STDERR, "blog\n"); exit(1); }
if (Canonical::canonicalUrl('https://pdftomd.tools/about?x=1#y') !== 'https://pdftomd.tools/about') { fwrite(STDERR, "query\n"); exit(1); }
try { Canonical::canonicalUrl('https://example.com/'); fwrite(STDERR, "host\n"); exit(1); } catch (InvalidArgumentException $e) {}
echo "php ok\n";
