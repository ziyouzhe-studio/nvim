-- 编码
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "ucs-bom", "gb18030", "latin1" }

-- 行号
vim.opt.number = true
vim.opt.relativenumber = true

-- UI 元素
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- 缩进（4 空格）
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 文本宽度
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"

-- 搜索
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 剪贴板
vim.opt.clipboard = "unnamedplus"

-- 提示音
vim.opt.errorbells = false
vim.opt.visualbell = false

-- Backspace 行为
vim.opt.backspace = "indent,eol,start"