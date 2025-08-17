-- markdown
return {
    -- 基础语法高亮
    {
        "plasticboy/vim-markdown",
        ft = "markdown",
        config = function()
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_conceal = 0
            vim.g.vim_markdown_new_list_item_indent = 0
        end,
    },
}
