-- =============================================================================
-- 文件位置: lua/core/options.lua
-- 说明: Neovim 原生基础行为与 UI 显示选项配置
-- =============================================================================

local opt = vim.opt

-- 编码设置
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = { "utf-8", "ucs-bom", "gb18030", "latin1" }

-- 行号与高亮提示
opt.number = true             -- 显示绝对行号
opt.relativenumber = true     -- 显示相对行号 (方便配合 j/k 快速跳转)
opt.cursorline = true         -- 高亮光标所在行
opt.ruler = true              -- 底部标尺显示光标位置
opt.showcmd = true            -- 显示未完成的命令
opt.showmode = false          -- 禁用原生模式提示 (已使用 Lualine 替代)
opt.termguicolors = true      -- 开启终端 24-bit True Color 支持

-- 缩进与空格 (统一为 4 空格缩进)
opt.autoindent = true         -- 自动对齐新行
opt.smartindent = true        -- 智能代码缩进
opt.tabstop = 4               -- 1 个 Tab 占据 4 个空格宽度
opt.softtabstop = 4           -- 编辑模式下按 Tab 插入 4 空格
opt.shiftwidth = 4            -- 缩进层级宽度为 4 空格
opt.expandtab = true          -- 将 Tab 字符自动转为空格

-- 文本边界与显示
opt.textwidth = 80            -- 标准代码文本参考宽度
opt.colorcolumn = "+1"        -- 在第 81 列显示垂直边界导轨
opt.wrap = false              -- 默认关闭自动硬折行，保持代码排版干净

-- 搜索行为
opt.hlsearch = true           -- 高亮所有搜索匹配项
opt.incsearch = true          -- 边打字边实时匹配搜索结果
opt.ignorecase = true         -- 搜索时忽略大小写
opt.smartcase = true          -- 包含大写字母时自动切换为精确大小写匹配

-- 系统集成与性能增强
opt.clipboard = "unnamedplus" -- 开启系统剪贴板共享 (配合 + / * 寄存器)
opt.errorbells = false        -- 关闭错误响铃
opt.visualbell = false       -- 关闭视觉闪烁提示
opt.backspace = "indent,eol,start" -- 优化退格键能跨越换行符擦除
opt.updatetime = 250          -- 减少闪烁等待时间 (提升 LSP 和 Git 状态更新流畅度)
opt.timeoutlen = 300          -- 快捷键序列等待时间 (提升 which-key 唤出响应速度)
