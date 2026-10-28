#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
bin="$root/bin/pdftomd-url-tools"
out=$("$bin" home)
[ "$out" = "https://pdftomd.tools/" ]
out=$("$bin" page pdf-to-md)
[ "$out" = "https://pdftomd.tools/pdf-to-md-converter" ]
out=$("$bin" blog convert-pdf-tables-to-markdown)
[ "$out" = "https://pdftomd.tools/blog/convert-pdf-tables-to-markdown" ]
if "$bin" canonical "https://example.com/" >/dev/null 2>&1; then
  echo "host should fail" >&2
  exit 1
fi
echo "shell ok"
