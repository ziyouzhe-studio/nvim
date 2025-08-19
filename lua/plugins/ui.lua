return { 
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                window = {
                    width = 20,
                },
            })
            vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {desc = "切换NeoTree"})
        end,
    },
    
    -- 状态栏
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
        "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    icons_enable = true,
                    theme = "auto",
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 100,
                        tabline = 100,
                        winbar = 100,
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            })
        end
    },

    -- buffer(标签栏)
    {
        "akinsho/bufferline.nvim",
        dependencies = {
        "nvim-tree/nvim-web-devicons",
        },
        opts = {},
        lazy = false,
    },

    -- 仪表盘
    {
        "nvimdev/dashboard-nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        event = "VimEnter",
    },

    -- 代码小地图
    { 
        "gorbit99/codewindow.nvim",
        config = function()
            local codewindow = require("codewindow")
            codewindow.setup({
                auto_enable = true,
                width = 10,
                use_lsp = true,
            })
            codewindow.apply_default_keybinds()
        end,
        keys = {
            {
                "<leader>mm", function()
                    local cw = require("codewindow")
                    if cw.is_minimap_open() then
                        cw.close_minimap()
                    else
                        cw.open_minimap()
                    end
                end, desc = "Toggle Minimap"
            },
        },
    },

    -- 代码大纲
    {
        "stevearc/aerial.nvim",
        opts = {},
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("aerial").setup({
                on_attach = function(bufnr)
                    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", {buffer = bufnr})
                    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", {buffer = bufnr})
                end,
            })
        end,
        vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    },
}
