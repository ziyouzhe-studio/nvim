-- markdown 预览
return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
        require('render-markdown').setup({
            completions = {lsp = {enabled = true}},
            heading = {
                icons = {'[1]', '[2]', '[3]', '[4]', '[5]', '[6]'},
            },
            code = {
                width = 'block',
                left_pad = 2,
                right_pad = 4,
            },
            checkbox = {
                checked = {scope_highlight = '@markup.strikethrough'}
            },
            quote = {repeat_linebreak = true},
            win_options = {
                showbreak = {
                    default = '',
                    rendered = ' ',
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
            pipe_table = {preset = 'round'},
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
}
