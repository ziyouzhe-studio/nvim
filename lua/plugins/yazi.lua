-- yazi文件浏览器
return {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
        "folke/snacks.nvim",
    },

    config = function(_, opts)
        require("yazi").setup(opts)
        require("options.yazi-keymap").setup() -- 绑定快捷键
    end,

    opst = {
        open_for_directories = false,
        keymaps = {
            show_help = "<F1>",
        },
    },

    init = function()
        vim.g.loaded_netrwPlugin = 1
        vim.g.loaded_netrw = 1
    end,
}
