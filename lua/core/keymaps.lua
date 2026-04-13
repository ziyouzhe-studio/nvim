-- leader 键统一为空格（确保在任何映射之前）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 插入模式下 jk 退出
vim.keymap.set("i", "jk", "<ESC>", { noremap = true })

-- 撤销（覆盖默认的 Ctrl+Z 挂起行为）
vim.keymap.set({ "n", "i" }, "<C-z>", "<Cmd>undo<CR>", { silent = true })

-- 常用文件操作
vim.keymap.set("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<Cmd>quit<CR>", { desc = "Quit buffer" })
vim.keymap.set("n", "<leader>Q", "<Cmd>qa<CR>", { desc = "Quit all" })

-- 快速清除搜索高亮
vim.keymap.set("n", "<leader>h", "<Cmd>nohlsearch<CR>", { desc = "Clear highlight" })

-- LuaSnip 片段内跳转（使用 Ctrl + j/k，避免与窗口移动冲突）
-- 注意：你之前用 <C-j> 和 <C-k> 移动窗口（<C-w>j/k），这里直接用可能会冲突
-- 如果冲突，改用 <C-n> / <C-p> 或 <A-j> / <A-k>
vim.keymap.set({"i", "s"}, "<C-n>", function()
    if require("luasnip").jumpable(1) then
        require("luasnip").jump(1)
    end
end, {silent = true, desc = "LuaSnip next placeholder"})

vim.keymap.set({"i", "s"}, "<C-p>", function()
    if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
    end
end, {silent = true, desc = "LuaSnip previous placeholder"})
