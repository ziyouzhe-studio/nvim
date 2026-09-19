-- =============================================================================
-- 文件位置: lua/core/keymaps.lua
-- 说明: 全局基础快捷键映射 (Leader 键统一为空格)
-- =============================================================================

-- 设置 Leader 主按键 (必须在任何 keymap 定义之前执行)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 插入模式快速退出到 Normal 模式
map("i", "jk", "<ESC>", opts)

-- 撤销/重做快捷键优化 (覆盖默认的 Ctrl+Z 挂起行为)
map({ "n", "i" }, "<C-z>", "<Cmd>undo<CR>", opts)

-- 常用文件与缓冲区快速操作
map("n", "<leader>w", "<Cmd>write<CR>", { desc = "保存当前文件" })
map("n", "<leader>q", "<Cmd>quit<CR>", { desc = "关闭当前缓冲区" })
map("n", "<leader>Q", "<Cmd>qa<CR>", { desc = "强行退出所有缓冲区" })

-- 快速清除搜索匹配高亮
map("n", "<leader>h", "<Cmd>nohlsearch<CR>", { desc = "清除搜索高亮" })

-- LuaSnip 占位符跳转 (使用 Alt + n/p 彻底避开窗口移动快捷键冲突)
map({ "i", "s" }, "<A-n>", function()
    if require("luasnip").jumpable(1) then
        require("luasnip").jump(1)
    end
end, { silent = true, desc = "LuaSnip 下一个占位符" })

map({ "i", "s" }, "<A-p>", function()
    if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
    end
end, { silent = true, desc = "LuaSnip 上一个占位符" })
