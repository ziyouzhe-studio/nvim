return {
    {
        "folke/tokyonight.nvim",
        lazy = false,          -- 立即加载，保证启动时主题生效
        priority = 1000,
        opts = {
            -- transparent = true, -- 背景透明
            styles = { sidebars = "transparent", floats = "transparent" }
        }
    },

    {
        "Ferouk/bearded-nvim",   -- 修正用户名
        name = "bearded",
        priority = 1000,
        build = function()
            local doc = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "bearded", "doc")
            pcall(vim.cmd, "helptags " .. doc)   -- 注意原代码中 helptags 和 doc 之间缺少空格，建议加上
        end,
        config = function()
            require("bearded").setup({
                flavor = "arc",
            })
        end,
    },

    {
        "navarasu/onedark.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('onedark').setup {
                style = 'deep' -- themes eselect "dark" "darker" "Cool" "Deep" "Warm" "Warmer"
            }
        require('onedark').load()
        end
    },

    -- 以下为备用主题（懒加载）
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        opts = {},
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavor = "macchiato",
            })
        end,
    },

    {
        "ellisonleao/gruvbox.nvim",
        lazy = true,
        opts = {}
    },

    {
        "craftzdog/solarized-osaka.nvim",
        lazy = true,
        opts = { transparent = true }
    }
}
