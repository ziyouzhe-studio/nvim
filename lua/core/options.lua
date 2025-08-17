-- 基础配置 --

-- 设置默认编码为 UTF-8
vim.opt.encoding = "utf-8"
-- 设置文件默认保存为 UTF-8 编码 (读取文件时的编码列表)
vim.opt.fileencodings = { "utf-8", "ucs-bom", "gb18030", "latin1" }
-- 保存文件时使用 UTF-8 编码
vim.opt.fileencoding = "utf-8"

-- 显示行对行号
vim.opt.number = true
vim.opt.relativenumber = true

-- 显示标尺 命令 模式
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.showmode = true

-- 高亮当前行
vim.opt.cursorline = true

-- 缩进
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 设置文本宽度限制和颜色列
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"

-- 搜索设置: 高亮匹配 增量搜索 忽略大小写+智能大小写
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 使用系统剪贴板
vim.opt.clipboard = 'unnamedplus'

-- 消除错误铃声
vim.opt.errorbells = false
vim.opt.visualbell = true

-- 删除更自然
vim.opt.backspace = 'indent,eol,start'
