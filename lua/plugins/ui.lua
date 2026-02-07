return { 
    -- 文件树
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
                layout = {
                    min_width = 20,
                },
                on_attach = function(bufnr)
                    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", {buffer = bufnr})
                    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", {buffer = bufnr})
                end,
            })
        end,
        vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    },

    -- 仪表盘
    {
        'goolord/alpha-nvim',
        event = "VimEnter", -- 仅在进入时加载，不影响启动速度
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- ---------------------------------------------------------
            -- 1. Header (ASCII Logo)
            -- ---------------------------------------------------------
            dashboard.section.header.val = {
                [[                                                                       ]],
                [[  ██████   █████                   █████   █████  ███                  ]],
                [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
                [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
                [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
                [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
                [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
                [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
                [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
                [[                                                                       ]],
                
                -- [[                                                                       ]],
	            -- [[                                                                     ]],
	            -- [[       ████ ██████           █████      ██                     ]],
	            -- [[      ███████████             █████                             ]],
	            -- [[      █████████ ███████████████████ ███   ███████████   ]],
	            -- [[     █████████  ███    █████████████ █████ ██████████████   ]],
	            -- [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
	            -- [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
	            -- [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
	            -- [[                                                                       ]],
            }

            -- ---------------------------------------------------------
            -- 2. Buttons (快捷键)
            -- ---------------------------------------------------------
            -- 参数: 快捷键, 图标+文字, 执行的命令
            dashboard.section.buttons.val = {
                dashboard.button("f", "󰈞  Find File", ":Telescope find_files <CR>"),
                dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", "󰄉  Recent Files", ":Telescope oldfiles <CR>"),
                dashboard.button("g", "󰱼  Find Text", ":Telescope live_grep <CR>"),
                dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
                dashboard.button("l", "󰒲  Lazy.nvim", ":Lazy<CR>"),
                dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
            }

            -- -- ---------------------------------------------------------
            -- -- 3. Footer (底部信息)
            -- -- ---------------------------------------------------------
            -- -- 这里我们通过设置为空或者自定义文字来避开原生版本号
            local stats = vim.loop.hrtime()       -- 只是演示，可以写死
            dashboard.section.footer.val = "Today is a good day to code."
            dashboard.section.footer.opts.hl = "Type" -- 设置页脚颜色

            -- ---------------------------------------------------------
            -- 4. 样式调整
            -- ---------------------------------------------------------
            dashboard.opts.opts.noautocmd = true
            alpha.setup(dashboard.opts)
        end
    },

    -- telescope 实现仪表盘文件创建和搜索
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.5",
        dependencies = {"nvim-lua/plenary.nvim"},
    },

    -- 1. 通知UI
    {
        "rcarriga/nvim-notify",
        cofnig = function()
            require("notify").setup({
                background_colour = "#000000", -- 颜色
                timeout = 3000, -- 三秒消失
                stages = "static", -- 动画风格: fade, slide, static
            })
            -- 让vim的普通通知也走这个插件
            vim.ontify = require("notify")
        end,
    },

    -- 2. 消息界面重构
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
        },
        -- 预设功能
        presets = {
            bottom_search = true, -- 搜索栏移到中间
            command_palette = true, -- 命令栏变为悬浮框
            long_message_to_split = true, -- 长消息自动分屏显示
            inc_rename = false, -- 增量重命名提示
            lsp_doc_border = false, -- 给LSP文档加边框
        },
        messages = {
            enabled = true,
            view = "notify", -- 默认视图设为通知
            view_error = "notify", -- 报错消息设为通知
            view_warn = "notify", -- 警告消息设为通知
        }
    },
}
