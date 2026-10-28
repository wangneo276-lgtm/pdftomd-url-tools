local M = {}
M.ORIGIN = 'https://pdftomd.tools'
M.DESCRIPTION = 'Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.'
local HOST = 'pdftomd.tools'
local PATHS = { ['/']=true, ['/about']=true, ['/batch-pdf-to-markdown']=true, ['/blog']=true, ['/blog/best-document-format-for-chatgpt']=true, ['/blog/convert-multiple-pdfs-to-markdown']=true, ['/blog/convert-pdf-tables-to-markdown']=true, ['/blog/convert-pdf-to-markdown-locally']=true, ['/blog/convert-pdf-to-markdown-without-losing-formatting']=true, ['/blog/import-pdf-into-obsidian-as-notes']=true, ['/blog/markdown-to-pdf-page-breaks']=true, ['/blog/print-markdown-to-pdf-with-tables']=true, ['/blog/pymupdf4llm-vs-pdfplumber-vs-marker']=true, ['/convert-pdf-to-md']=true, ['/markdown-to-pdf']=true, ['/md-to-pdf']=true, ['/pdf-to-markdown-for-llm']=true, ['/pdf-to-markdown-obsidian']=true, ['/pdf-to-markdown-python']=true, ['/pdf-to-md-converter']=true, ['/privacy-policy']=true, ['/terms-of-service']=true }
local PAGES = { ['home']='/', ['pdf-to-md']='/pdf-to-md-converter', ['convert']='/convert-pdf-to-md', ['md-to-pdf']='/md-to-pdf', ['markdown-to-pdf']='/markdown-to-pdf', ['llm']='/pdf-to-markdown-for-llm', ['batch']='/batch-pdf-to-markdown', ['obsidian']='/pdf-to-markdown-obsidian', ['python']='/pdf-to-markdown-python', ['about']='/about', ['privacy']='/privacy-policy', ['terms']='/terms-of-service', ['blog']='/blog' }
local BLOGS = { ['pymupdf4llm-vs-pdfplumber-vs-marker']='/blog/pymupdf4llm-vs-pdfplumber-vs-marker', ['import-pdf-into-obsidian-as-notes']='/blog/import-pdf-into-obsidian-as-notes', ['convert-multiple-pdfs-to-markdown']='/blog/convert-multiple-pdfs-to-markdown', ['convert-pdf-to-markdown-locally']='/blog/convert-pdf-to-markdown-locally', ['markdown-to-pdf-page-breaks']='/blog/markdown-to-pdf-page-breaks', ['best-document-format-for-chatgpt']='/blog/best-document-format-for-chatgpt', ['convert-pdf-to-markdown-without-losing-formatting']='/blog/convert-pdf-to-markdown-without-losing-formatting', ['print-markdown-to-pdf-with-tables']='/blog/print-markdown-to-pdf-with-tables', ['convert-pdf-tables-to-markdown']='/blog/convert-pdf-tables-to-markdown' }

local function canonical_url(input)
  if type(input) ~= "string" then error("path required") end
  local raw = input:match("^%s*(.-)%s*$")
  if raw == "" then error("path required") end
  if raw:find("\\", 1, true) or raw:find("%", 1, true) then error("invalid path") end
  raw = raw:match("([^#]*)")
  raw = raw:match("([^?]*)")
  local lower = raw:lower()
  local path
  if lower:sub(1, 8) == "https://" or lower:sub(1, 7) == "http://" or raw:sub(1, 2) == "//" then
    local rest = raw
    if lower:sub(1, 8) == "https://" then rest = raw:sub(9)
    elseif lower:sub(1, 7) == "http://" then rest = raw:sub(8)
    else rest = raw:sub(3) end
    local slash = rest:find("/", 1, true)
    local hostport = slash and rest:sub(1, slash - 1) or rest
    path = slash and rest:sub(slash) or "/"
    if hostport:find("@", 1, true) then error("userinfo not allowed") end
    if hostport:find(":", 1, true) then error("port not allowed") end
    if hostport:lower() ~= HOST then error("host not allowed") end
  elseif raw:sub(1, 1) == "/" then
    path = raw
  else
    path = "/" .. raw
  end
  path = path:lower():gsub("//+", "/")
  for seg in path:gmatch("[^/]+") do
    if seg == "." or seg == ".." then error("path traversal") end
  end
  if #path > 1 then path = path:gsub("/+$", "") end
  if path == "" then path = "/" end
  if not PATHS[path] then error("unknown path: " .. path) end
  if path == "/" then return M.ORIGIN .. "/" end
  return M.ORIGIN .. path
end

function M.canonical_url(input) return canonical_url(input) end
function M.home_url() return canonical_url("/") end
function M.page_url(name)
  local path = PAGES[name]
  if not path then error("unknown page: " .. tostring(name)) end
  return canonical_url(path)
end
function M.blog_url(slug)
  local path = BLOGS[slug]
  if not path then error("unknown blog: " .. tostring(slug)) end
  return canonical_url(path)
end
return M
