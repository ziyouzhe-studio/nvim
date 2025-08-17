-- lspsaga-keymap
local lspsaga_keymap = {}
function lspsaga_keymap.setup()
    local map = vim.leymap.set
    local default_opts = {noremap = true, silent = true, desc = ""}
    -- 跳转声明
    map(
        bufnr, "n", "gd", "<cmd>Lspsaga peek_definition<CR>", {silent = true, noremap = true}
    )
    -- 跳转定义
    map(
        bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", {silent = true, noremap = true}
    )
    -- 显示注释文档
    map(
        bufnr, "n", "gh", "<cmd>Lspsaga lsp_finder<CR>", {silent = true, noremap = true}
    )
    -- 跳转到实现
    map(
        bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", {silent = true, noremap = true}
    )
    -- 跳转到引用位置
    map(
        bufnr, "n", "gr", "<cmd>Lspsaga rename<CR>", {silent = true, noremap = true}
    )
    -- 以浮窗形式显示错误
    map(
        bufnr, "n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", {silent = true, noremap = true},
        bufnr, "n", "gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {silent = true, noremap = true},
        bufnr, "n", "gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", {silent = true, noremap = true},
        bufnr, "n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", {silent = true, noremap = true},
        bufnr, "n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", {silent = true, noremap = true},
        bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", {silent = true, noremap = true},
        bufnr, "v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", {silent = true, noremap = true}
    )
end

return lspsaga_keymap
