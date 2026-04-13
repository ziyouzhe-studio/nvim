return {
    -- 自动补全括号/引号
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

    -- 注释增强
    { "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },

    -- 彩虹缩进线
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            local highlight = {
                "RainbowRed", "RainbowYellow", "RainbowBlue",
                "RainbowOrange", "RainbowGreen", "RainbowViolet", "RainbowCyan"
            }
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)
            require("ibl").setup({ indent = { highlight = highlight } })
        end
    },

    -- Markdown 支持
    {
        "plasticboy/vim-markdown",
        ft = "markdown",
        config = function()
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_conceal = 0
            vim.g.vim_markdown_new_list_item_indent = 0
        end
    },

    -- Markdown 渲染增强
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
        opts = {
            completions = { lsp = { enabled = true } },
            code = { width = "block", left_pad = 2, right_pad = 4 },
            checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
            quote = { repeat_linebreak = true },
            pipe_table = { preset = "round" },
            heading = { border = true },
            indent = { enabled = true, skip_heading = true }
        }
    },

    -- lua/plugins/editor.lua
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                -- 终端窗口的大小，可以是数字（高度）或百分比
                size = 20,
                -- 打开终端后是否自动进入插入模式
                start_in_insert = true,
                -- 终端的打开方向，可选 'float', 'horizontal', 'vertical', 'tab'
                direction = 'float',
                -- 浮动窗口的相关配置
                float_opts = {
                    border = 'rounded',   -- 边框样式：single, double, shadow, rounded 等
                    width = 80,
                    height = 20,
                    winblend = 3,         -- 窗口透明度
                },
            })
        end
    }
}
