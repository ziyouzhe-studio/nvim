-- 代码高亮
return {
    "nvim-treesitter/nvim-treesitter",
    buid = ":TSUpdate",
    main = "nvim-treesitter.configs",
    event = "VeryLazy",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            auto_install = true,
            ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html"},
            sync_install = false,
            highlight = {enable = true},
            indent = {enable = true},
        })
    end
}


