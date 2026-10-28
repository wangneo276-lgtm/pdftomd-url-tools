<?php

declare(strict_types=1);

namespace PdfToMd\UrlTools;

final class Canonical
{
    public const ORIGIN = 'https://pdftomd.tools';
    public const DESCRIPTION = 'Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.';
    private const HOST = 'pdftomd.tools';

    /** @var array<string, true> */
    private const PATHS = [
        '/' => true,
        '/about' => true,
        '/batch-pdf-to-markdown' => true,
        '/blog' => true,
        '/blog/best-document-format-for-chatgpt' => true,
        '/blog/convert-multiple-pdfs-to-markdown' => true,
        '/blog/convert-pdf-tables-to-markdown' => true,
        '/blog/convert-pdf-to-markdown-locally' => true,
        '/blog/convert-pdf-to-markdown-without-losing-formatting' => true,
        '/blog/import-pdf-into-obsidian-as-notes' => true,
        '/blog/markdown-to-pdf-page-breaks' => true,
        '/blog/print-markdown-to-pdf-with-tables' => true,
        '/blog/pymupdf4llm-vs-pdfplumber-vs-marker' => true,
        '/convert-pdf-to-md' => true,
        '/markdown-to-pdf' => true,
        '/md-to-pdf' => true,
        '/pdf-to-markdown-for-llm' => true,
        '/pdf-to-markdown-obsidian' => true,
        '/pdf-to-markdown-python' => true,
        '/pdf-to-md-converter' => true,
        '/privacy-policy' => true,
        '/terms-of-service' => true,
    ];

    /** @var array<string, string> */
    private const PAGES = [
        'home' => '/',
        'pdf-to-md' => '/pdf-to-md-converter',
        'convert' => '/convert-pdf-to-md',
        'md-to-pdf' => '/md-to-pdf',
        'markdown-to-pdf' => '/markdown-to-pdf',
        'llm' => '/pdf-to-markdown-for-llm',
        'batch' => '/batch-pdf-to-markdown',
        'obsidian' => '/pdf-to-markdown-obsidian',
        'python' => '/pdf-to-markdown-python',
        'about' => '/about',
        'privacy' => '/privacy-policy',
        'terms' => '/terms-of-service',
        'blog' => '/blog',
    ];

    /** @var array<string, string> */
    private const BLOGS = [
        'pymupdf4llm-vs-pdfplumber-vs-marker' => '/blog/pymupdf4llm-vs-pdfplumber-vs-marker',
        'import-pdf-into-obsidian-as-notes' => '/blog/import-pdf-into-obsidian-as-notes',
        'convert-multiple-pdfs-to-markdown' => '/blog/convert-multiple-pdfs-to-markdown',
        'convert-pdf-to-markdown-locally' => '/blog/convert-pdf-to-markdown-locally',
        'markdown-to-pdf-page-breaks' => '/blog/markdown-to-pdf-page-breaks',
        'best-document-format-for-chatgpt' => '/blog/best-document-format-for-chatgpt',
        'convert-pdf-to-markdown-without-losing-formatting' => '/blog/convert-pdf-to-markdown-without-losing-formatting',
        'print-markdown-to-pdf-with-tables' => '/blog/print-markdown-to-pdf-with-tables',
        'convert-pdf-tables-to-markdown' => '/blog/convert-pdf-tables-to-markdown',
    ];

    public static function canonicalUrl(string $input): string
    {
        $raw = trim($input);
        if ($raw === '') {
            throw new \InvalidArgumentException('path required');
        }
        if (str_contains($raw, '\\') || str_contains($raw, '%')) {
            throw new \InvalidArgumentException('invalid path');
        }
        $raw = explode('#', $raw, 2)[0];
        $raw = explode('?', $raw, 2)[0];
        $lower = strtolower($raw);
        if (str_starts_with($lower, 'https://') || str_starts_with($lower, 'http://') || str_starts_with($raw, '//')) {
            if (str_starts_with($lower, 'https://')) {
                $rest = substr($raw, 8);
            } elseif (str_starts_with($lower, 'http://')) {
                $rest = substr($raw, 7);
            } else {
                $rest = substr($raw, 2);
            }
            $slash = strpos($rest, '/');
            $hostport = $slash === false ? $rest : substr($rest, 0, $slash);
            $path = $slash === false ? '/' : substr($rest, $slash);
            if (str_contains($hostport, '@')) {
                throw new \InvalidArgumentException('userinfo not allowed');
            }
            if (str_contains($hostport, ':')) {
                throw new \InvalidArgumentException('port not allowed');
            }
            if (strcasecmp($hostport, self::HOST) !== 0) {
                throw new \InvalidArgumentException('host not allowed');
            }
        } elseif (str_starts_with($raw, '/')) {
            $path = $raw;
        } else {
            $path = '/' . $raw;
        }
        $path = strtolower($path);
        $path = preg_replace('#//+#', '/', $path) ?? $path;
        foreach (explode('/', $path) as $seg) {
            if ($seg === '.' || $seg === '..') {
                throw new \InvalidArgumentException('path traversal');
            }
        }
        if (strlen($path) > 1) {
            $path = rtrim($path, '/');
        }
        if ($path === '') {
            $path = '/';
        }
        if (!isset(self::PATHS[$path])) {
            throw new \InvalidArgumentException('unknown path: ' . $path);
        }
        return $path === '/' ? self::ORIGIN . '/' : self::ORIGIN . $path;
    }

    public static function homeUrl(): string
    {
        return self::canonicalUrl('/');
    }

    public static function pageUrl(string $name): string
    {
        if (!isset(self::PAGES[$name])) {
            throw new \InvalidArgumentException('unknown page: ' . $name);
        }
        return self::canonicalUrl(self::PAGES[$name]);
    }

    public static function blogUrl(string $slug): string
    {
        if (!isset(self::BLOGS[$slug])) {
            throw new \InvalidArgumentException('unknown blog: ' . $slug);
        }
        return self::canonicalUrl(self::BLOGS[$slug]);
    }
}
