#!/bin/sh
set -eu
ORIGIN='https://pdftomd.tools'

die() {
  printf '%s\n' "$1" >&2
  exit 2
}

is_known() {
  case "$1" in
    /|/about|/batch-pdf-to-markdown|/blog|/blog/best-document-format-for-chatgpt|/blog/convert-multiple-pdfs-to-markdown|/blog/convert-pdf-tables-to-markdown|/blog/convert-pdf-to-markdown-locally|/blog/convert-pdf-to-markdown-without-losing-formatting|/blog/import-pdf-into-obsidian-as-notes|/blog/markdown-to-pdf-page-breaks|/blog/print-markdown-to-pdf-with-tables|/blog/pymupdf4llm-vs-pdfplumber-vs-marker|/convert-pdf-to-md|/markdown-to-pdf|/md-to-pdf|/pdf-to-markdown-for-llm|/pdf-to-markdown-obsidian|/pdf-to-markdown-python|/pdf-to-md-converter|/privacy-policy|/terms-of-service) return 0 ;;
    *) return 1 ;;
  esac
}

canonical() {
  raw=$(printf '%s' "${1:-}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [ -n "$raw" ] || die "path required"
  case "$raw" in
    *\\*) die "invalid path" ;;
    *%*) die "invalid path" ;;
  esac
  raw=${raw%%#*}
  raw=${raw%%\?*}
  lower=$(printf '%s' "$raw" | tr 'A-Z' 'a-z')
  case "$lower" in
    https://*|http://*|//*)
      rest=$raw
      case "$lower" in
        https://*) rest=${rest#https://} ;;
        http://*) rest=${rest#http://} ;;
        //*) rest=${rest#//} ;;
      esac
      host=${rest%%/*}
      case "$rest" in
        */*) path=/${rest#*/} ;;
        *) path=/ ;;
      esac
      case "$host" in
        *@*) die "userinfo not allowed" ;;
        *:*) die "port not allowed" ;;
      esac
      host=$(printf '%s' "$host" | tr 'A-Z' 'a-z')
      [ "$host" = 'pdftomd.tools' ] || die "host not allowed"
      ;;
    /*) path=$raw ;;
    *) path=/$raw ;;
  esac
  path=$(printf '%s' "$path" | tr 'A-Z' 'a-z' | sed 's#//*#/#g')
  oldifs=$IFS
  IFS=/
  for seg in $path; do
    case "$seg" in
      .|..) die "path traversal" ;;
    esac
  done
  IFS=$oldifs
  if [ "$path" != "/" ]; then
    while [ "${path%/}" != "$path" ]; do
      path=${path%/}
    done
  fi
  [ -n "$path" ] || path=/
  is_known "$path" || die "unknown path"
  if [ "$path" = "/" ]; then
    printf '%s\n' "$ORIGIN/"
  else
    printf '%s\n' "$ORIGIN$path"
  fi
}

cmd=${1:-}
arg=${2:-}
case "$cmd" in
  canonical) canonical "$arg" ;;
  page)
    case "$arg" in
    home) canonical / ;;
    pdf-to-md) canonical /pdf-to-md-converter ;;
    convert) canonical /convert-pdf-to-md ;;
    md-to-pdf) canonical /md-to-pdf ;;
    markdown-to-pdf) canonical /markdown-to-pdf ;;
    llm) canonical /pdf-to-markdown-for-llm ;;
    batch) canonical /batch-pdf-to-markdown ;;
    obsidian) canonical /pdf-to-markdown-obsidian ;;
    python) canonical /pdf-to-markdown-python ;;
    about) canonical /about ;;
    privacy) canonical /privacy-policy ;;
    terms) canonical /terms-of-service ;;
    blog) canonical /blog ;;
      *) die "unknown page" ;;
    esac
    ;;
  blog)
    case "$arg" in
    pymupdf4llm-vs-pdfplumber-vs-marker) canonical /blog/pymupdf4llm-vs-pdfplumber-vs-marker ;;
    import-pdf-into-obsidian-as-notes) canonical /blog/import-pdf-into-obsidian-as-notes ;;
    convert-multiple-pdfs-to-markdown) canonical /blog/convert-multiple-pdfs-to-markdown ;;
    convert-pdf-to-markdown-locally) canonical /blog/convert-pdf-to-markdown-locally ;;
    markdown-to-pdf-page-breaks) canonical /blog/markdown-to-pdf-page-breaks ;;
    best-document-format-for-chatgpt) canonical /blog/best-document-format-for-chatgpt ;;
    convert-pdf-to-markdown-without-losing-formatting) canonical /blog/convert-pdf-to-markdown-without-losing-formatting ;;
    print-markdown-to-pdf-with-tables) canonical /blog/print-markdown-to-pdf-with-tables ;;
    convert-pdf-tables-to-markdown) canonical /blog/convert-pdf-tables-to-markdown ;;
      *) die "unknown blog" ;;
    esac
    ;;
  home) canonical / ;;
  *)
    echo "usage: pdftomd-url-tools canonical <path> | page <name> | blog <slug> | home" >&2
    exit 2
    ;;
esac
