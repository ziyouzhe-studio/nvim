return {
    -- 编码符号自动补全
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- 注释
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- 缩进优化
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)
            require("ibl").setup{indent = {highlight = highlight}}
        end,
    },

    -- vim-markdown
    {
        "plasticboy/vim-markdown",
        ft = markdown,
        config = function()
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_conceal = 0
            vim.g.vim_markdown_new_list_item_indent = 0
        end,
    },

    -- render-markdown预览
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.nvim",
        },
        opts = {},
        config = function()
            require("render-markdown").setup({
                completions = {lsp = {enabled = true}},
                code = {
                    width = "block",
                    left_pad = 2,
                    right_pad = 4,
                },
                checkbox = {
                    checked = {scope_highlight = "@markup.strikethrough"}
                },
                quote = {repeat_linebreak = true},
                win_options = {
                    showbreak = {
                        default = '',
                        rendered = '',
                    },
                    breakindent = {
                        default = false,
                        rendered = true,
                    },
                    breakindentopt = {
                        default = '',
                        rendered = '',
                    },
                },
                pipe_table = {preset = " round"},
                -- 链接
                link = {
                    image = '󰋵 ',
                    email = ' ',
                    hyperlink = '󰌷 ',
                    custom = {
                        python = {
                            pattern = '%.py$',
                            icon = '󰌠 ',
                        },
                    },
                },
                -- 缩进
                heading = {border = true},
                indent = {
                    enabled = true,
                    skip_heading = true,
                },
            })
        end
    },
}
