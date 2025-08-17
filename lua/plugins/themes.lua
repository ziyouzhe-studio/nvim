-- neovim themes
return {
    -- tokyonight
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        opts = {},
    },

    -- catppuccin
    {
        "catppuccin/nvim", 
        lazy = false, 
        name = "catppuccin",
        priority = 1000,
        opts = {
            transparent_background = true, 
            style = "Mocha"
        },
        config = function (_, opts)
            require("catppuccin").setup(opts)
            -- vim.cmd("colorscheme catppuccin")
        end
    },

    -- gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        priority = 10000,
        opts = {},
    },
}
