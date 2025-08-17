-- 绑定快捷键api: vim.keymap.set(mode, lhs, rhs, opts)
-- mode: 快捷键的生效模式
--  字符(单一模式)或table(多个模式)
--  每个模式由一个字母表示: n / i / c ...
--lhs: 快捷键的按键
--  Ctrl + a: <C-a>
--  Alt + a: <A-a>
--rhs: 快捷键的功能; 可以是映射的另一组按键或者一个lua函数
--opts:table, 包含对快捷键的额外配置

-- 插入模式下输入jk切换到普通模式
vim.keymap.set('i', 'jk', '<ESC>', { noremap = true })

-- 撤销输入
vim.keymap.set({"n", "i"}, "<C-z>", "<Cmd>undo<CR>", {silent = true})

-- 设置<leader>为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "
