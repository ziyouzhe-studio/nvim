-- =============================================================================
-- 文件位置: lua/plugins/ui.lua
-- 说明: 界观 UI 美化组件（图标库、文件树、标签栏、状态栏、通知弹窗等）
-- =============================================================================

return {
    -- -------------------------------------------------------------------------
    -- 1. 图标核心引擎 (全框架最高优先级加载，伪装并替换 nvim-web-devicons)
    -- -------------------------------------------------------------------------
    {
        "echasnovski/mini.icons",
        lazy = false,    -- 必须立即加载
        priority = 1000, -- 赋予最高优先级，确保其他 UI 插件初始化前完成 Mock
        opts = {
            style = "glyph",
            -- 特殊文件夹外观与彩色高亮定义
            directory = {
                default          = { glyph = "󰉋 ", hl = "MiniIconsAzure" },
                open             = { glyph = "󰝰 ", hl = "MiniIconsAzure" },
                [".git"]         = { glyph = "󰊢 ", hl = "MiniIconsOrange" },
                [".config"]      = { glyph = " ", hl = "MiniIconsGrey" },
                ["node_modules"] = { glyph = " ", hl = "MiniIconsGreen" },
                ["src"]          = { glyph = "󰅩 ", hl = "MiniIconsBlue" },
                ["lua"]          = { glyph = "󰢱 ", hl = "MiniIconsAzure" },
                ["doc"]          = { glyph = "󰈙 ", hl = "MiniIconsYellow" },
                ["docs"]         = { glyph = "󰈙 ", hl = "MiniIconsYellow" },
                ["images"]       = { glyph = "󰋩 ", hl = "MiniIconsPurple" },
                ["assets"]       = { glyph = "󰋩 ", hl = "MiniIconsPurple" },
                ["tests"]        = { glyph = "󰙨 ", hl = "MiniIconsRed" },
            },
            -- 编程语言与文件扩展名图标定义
            extension = {
                lua   = { glyph = "󰢱 ", hl = "MiniIconsAzure" },
                py    = { glyph = " ", hl = "MiniIconsYellow" },
                ts    = { glyph = "󰛦 ", hl = "MiniIconsBlue" },
                js    = { glyph = "󰌞 ", hl = "MiniIconsYellow" },
                json  = { glyph = " ", hl = "MiniIconsOrange" },
                md    = { glyph = " ", hl = "MiniIconsPurple" },
                sh    = { glyph = " ", hl = "MiniIconsGreen" },
                toml  = { glyph = " ", hl = "MiniIconsGrey" },
                -- Office 文档系列支持
                docx  = { glyph = "󰈬 ", hl = "MiniIconsBlue" },
                doc   = { glyph = "󰈬 ", hl = "MiniIconsBlue" },
                xlsx  = { glyph = "󰈙 ", hl = "MiniIconsGreen" },
                xls   = { glyph = "󰈙 ", hl = "MiniIconsGreen" },
                csv   = { glyph = "󰈙 ", hl = "MiniIconsGreen" },
                pptx  = { glyph = "󰈔 ", hl = "MiniIconsOrange" },
                ppt   = { glyph = "󰈔 ", hl = "MiniIconsOrange" },
                one   = { glyph = "󰏆 ", hl = "MiniIconsPurple" },
                accdb = { glyph = "󰆼 ", hl = "MiniIconsRed" },
            },
            file = {
                ["Dockerfile"]   = { glyph = " ", hl = "MiniIconsCyan" },
                ["package.json"] = { glyph = " ", hl = "MiniIconsRed" },
                ["git"]          = { glyph = "󰊢 ", hl = "MiniIconsOrange" },
            },
            lsp = {
                ["function"]  = { glyph = "󰊕 ", hl = "MiniIconsAzure" },
                ["method"]    = { glyph = "󰆧 ", hl = "MiniIconsBlue" },
                ["variable"]  = { glyph = "󰀫 ", hl = "MiniIconsCyan" },
                ["constant"]  = { glyph = "󰏿 ", hl = "MiniIconsOrange" },
                ["class"]     = { glyph = "󰠱 ", hl = "MiniIconsYellow" },
                ["interface"] = { glyph = " ", hl = "MiniIconsGreen" },
                ["struct"]    = { glyph = "󰌗 ", hl = "MiniIconsPurple" },
                ["field"]     = { glyph = "󰜢 ", hl = "MiniIconsRed" },
                ["property"]  = { glyph = "󰜢 ", hl = "MiniIconsRed" },
                ["module"]    = { glyph = " ", hl = "MiniIconsYellow" },
            },
        },
        config = function(_, opts)
            local mini_icons = require("mini.icons")
            mini_icons.setup(opts)
            -- 核心操作：假装自己是 nvim-web-devicons，无缝接管全局图标
            mini_icons.mock_nvim_web_devicons()
        end,
    },

    -- -------------------------------------------------------------------------
    -- 2. Neo-tree 侧边栏文件树
    -- -------------------------------------------------------------------------
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "echasnovski/mini.icons",
        },
        opts = {
            close_if_last_window = true,
            popup_border_style = "rounded",
            window = { width = 30 },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,   -- 显示隐藏的以 . 开头的文件
                    hide_gitignored = false, -- 显示被 .gitignore 忽略的文件
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- 开启文件夹层级小箭头
                    expander_folded = "",
                    expander_expanded = "",
                },
                icon = {
                    folder_closed = "󰉋",
                    folder_open = "󰝰",
                    folder_empty = "󰷏",
                    -- 关键回调：通过 provider 动态向 mini.icons 检索文件与特殊文件夹图标
                    provider = function(icon, node, _)
                        local mini_icons = require("mini.icons")
                        if node.type == "file" then
                            local text, hl = mini_icons.get("file", node.name)
                            if text then
                                icon.text = text; icon.highlight = hl
                            end
                        elseif node.type == "directory" then
                            local text, hl = mini_icons.get("directory", node.name)
                            if text then
                                icon.text = text; icon.highlight = hl
                            else
                                icon.text = node:is_expanded() and "󰝰" or "󰉋"
                            end
                        end
                    end,
                },
                name = { use_git_status_colors = true },
                git_status = {
                    symbols = {
                        added = "✚",
                        modified = "",
                        deleted = "✖",
                        renamed = "󰁕",
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                },
            },
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
            vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "切换文件树显示/隐藏" })
        end,
    },

    -- -------------------------------------------------------------------------
    -- 3. Bufferline 顶部标签栏
    -- -------------------------------------------------------------------------
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = { "echasnovski/mini.icons" },
        opts = function()
            local opts = {
                options = {
                    numbers = "none",
                    close_command = "bdelete! %d",
                    right_mouse_command = "bdelete! %d",
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level)
                        local icon = level:match("error") and " " or " "
                        return icon .. count
                    end,
                    offsets = { { filetype = "neo-tree", text = "Neo-tree", text_align = "left" } },
                    color_icons = true,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = true,
                    show_tab_indicators = true,
                    persist_buffer_sort = true,
                    separator_style = "thin",
                    always_show_bufferline = true,
                    hover = { enabled = true, reveal = { "close" } },
                },
            }
            -- 仅在激活 catppuccin 主题时接入专用样式
            if vim.g.colors_name and vim.g.colors_name:find("catppuccin") then
                local ok, cat_integrations = pcall(require, "catppuccin.groups.integrations.bufferline")
                if ok then opts.highlights = cat_integrations.get() end
            end
            return opts
        end,
    },

    -- -------------------------------------------------------------------------
    -- 4. Lualine 底部状态栏
    -- -------------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "echasnovski/mini.icons", "SmiteshP/nvim-navic" },
        config = function()
            local navic = require("nvim-navic")

            -- 计算并格式化当前文件大小
            local function file_size()
                local path = vim.api.nvim_buf_get_name(0)
                if path == "" then return "" end
                local stat = vim.loop.fs_stat(path)
                if not stat then return "" end
                local size = stat.size
                if size < 1024 then
                    return size .. "B"
                elseif size < 1024 * 1024 then
                    return string.format("%.1fK", size / 1024)
                else
                    return string.format("%.1fM", size / (1024 * 1024))
                end
            end

            -- 实时显示活动中的 LSP 服务名称
            local function lsp_client()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                local names = {}
                for _, client in ipairs(clients) do table.insert(names, client.name) end
                return table.concat(names, ", ")
            end

            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { "NvimTree", "neo-tree" },
                    globalstatus = true, -- 全局共享单行状态栏
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                local mode_icons = {
                                    NORMAL = " 🏠 ",
                                    INSERT = " ✏️ ",
                                    VISUAL = " 👁️ ",
                                    V_LINE = " 📄 ",
                                    V_BLOCK = " 🔳 ",
                                    COMMAND = " 💬 ",
                                    TERMINAL = " 🖥️ ",
                                }
                                return (mode_icons[str] or " ") .. str
                            end,
                        },
                    },
                    lualine_b = {
                        {
                            "branch",
                            icon = "󰘬",
                            color = { fg = "#ff9e64" },
                        },
                        {
                            "diff",
                            symbols = {
                                added   = " ",
                                modified = " ",
                                removed  = " ",
                            },
                            diff_color = {
                                added    = { fg = "#98c379" }, -- 绿色 (新增)
                                modified = { fg = "#e5c07b" }, -- 黄色 (修改)
                                removed  = { fg = "#e06c75" }, -- 红色 (删除)
                            },
                        },
                        {
                            "diagnostics",
                            sources = { "nvim_lsp" },
                            symbols = { error = " ", warn = " ", info = " ", hint = " " },
                            diagnostics_color = {
                                error = { fg = "#e06c75" }, -- 红色 (错误)
                                warn  = { fg = "#e5c07b" }, -- 黄色 (警告)
                                info  = { fg = "#61afef" }, -- 蓝色 (信息)
                                hint  = { fg = "#98c379" }, -- 绿色 (提示)
                            },
                        },
                    },
                    lualine_c = {
                        { "filename", path = 1, symbols = { modified = "●", readonly = "", unnamed = "" } },
                        { navic.get_location, cond = navic.is_available }, -- 接入代码位置面包屑
                    },
                    lualine_x = {
                        -- 文件大小
                        { file_size, icon = "󰉋", color = {fg = "#e5c07b", gui = "bold"} },
                        -- 文件类型
                        { "filetype", icon_only = true, separator = {left = " ", right = " "} },
                        -- LSP服务名称
                        { lsp_client, icon = "󰅩", color = {fg = "#bb9af7", gui = "bold"} },
                        -- 编码格式(UTF-8)
                        {
                            "encoding",
                            icon = "󰇚",
                            color = { fg = "#98c379" },
                        },
                        -- 换行符格式/操作系统
                        {
                            "fileformat",
                            symbols = {
                                unix = "", -- Linux 🐧 图标 (若是 Mac 可自动切换/设为 )
                                dos  = "", -- Windows  图标
                                mac  = "", -- macOS  图标
                            },
                            color = { fg = "#e5c07b" },
                        },
                        -- 实时显示当前时间
                        {
                            function() return "󰥔 " .. os.date("%H:%M:%S") end,
                            color = { fg = "#7aa2f7" },
                        },
                    },
                    lualine_y = {
                        {
                            "progress",
                            icon = "󰓅 ",
                            color = { fg = "#15161e", bg = "#56B6C2", gui = "bold" },
                        },
                    },
                    lualine_z = {
                        {
                            "location",
                            icon = "",
                            color = { fg = "#151613", bg = "#bb9af7", gui = "bold" },
                        },
                        {
                            function() return "ﯚ Recording @" .. vim.fn.reg_recording() end,
                        cond = function() return vim.fn.reg_recording() ~= "" end,
                        color = { fg = "#e06c75", gui = "bold" }, -- 宏录制状态警示红
                        },
                    },
                },
                extensions = { "fzf", "neo-tree" },
            })
        end,
    },

    -- -------------------------------------------------------------------------
    -- 5. Which-key 快捷键辅助菜单
    -- -------------------------------------------------------------------------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = { enabled = true } },
            win = { border = "rounded" },
            layout = { align = "center", spacing = 3 },
            preset = "helix", -- 2026 年现代弹窗预设风格
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            -- 注册按 Leader 键后的分组大纲
            wk.add({
                { "<leader>f", group = "文件查找 (File)" },
                { "<leader>g", group = "Git 工作流" },
                { "<leader>l", group = "Lazy 管理面板" },
                { "<leader>s", group = "全局搜索 (Search)" },
                { "<leader>w", group = "窗口管理" },
                { "<leader>h", group = "帮助 (Help)" },
                { "<leader>b", group = "面包屑导航" },
                { "<leader>m", group = "代码小地图" },
            })
        end,
    },

    -- -------------------------------------------------------------------------
    -- 6. Neominimap 代码小地图
    -- -------------------------------------------------------------------------
    {
        "Isrothy/neominimap.nvim",
        version = "v3.x.x",
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter", "lewis6991/gitsigns.nvim" },
        keys = {
            { "<leader>mm", "<cmd>Neominimap Toggle<cr>", desc = "切换全局小地图" },
            { "<leader>mo", "<cmd>Neominimap Enable<cr>", desc = "开启小地图" },
            { "<leader>mc", "<cmd>Neominimap Disable<cr>", desc = "关闭小地图" },
            { "<leader>mr", "<cmd>Neominimap Refresh<cr>", desc = "刷新小地图" },
        },
        init = function()
            vim.opt.wrap = false
            vim.opt.sidescrolloff = 36
            vim.g.neominimap = {
                auto_enable = false,
                layout = "float",
                x_multiplier = 4,
                y_multiplier = 1,
                exclude_filetypes = { "help", "bigfile", "gitcommit", "qf", "neo-tree" },
                exclude_buftypes = { "nofile", "nowrite", "quickfix", "terminal", "prompt" },
                treesitter = { enabled = true },
                diagnostic = { enabled = true },
                git = { enabled = true },
                winblend = 15,
                float = { minimap_width = 20, z_index = 10, window_border = "single" },
                click = { enabled = true, auto_switch_focus = true },
            }
        end,
    },

    -- -------------------------------------------------------------------------
    -- 7. Aerial 代码大纲
    -- -------------------------------------------------------------------------
    {
        "stevearc/aerial.nvim",
        dependencies = { "echasnovski/mini.icons" },
        opts = { layout = { min_width = 20 } },
        config = function(_, opts)
            require("aerial").setup(opts)
            vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "切换代码大纲显示" })
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { desc = "上一个符号" })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { desc = "下一个符号" })
        end,
    },

    -- -------------------------------------------------------------------------
    -- 8. Alpha-nvim 启动仪表盘
    -- -------------------------------------------------------------------------
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "echasnovski/mini.icons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                [[                                                      ]],
                [[      ████ ██████           █████      ██                     ]],
                [[     ███████████             █████                             ]],
                [[     █████████ ███████████████████ ███   ███████████   ]],
                [[    █████████  ███    █████████████ █████ ██████████████   ]],
                [[   █████████ ██████████ █████████ █████ █████ ████ █████   ]],
                [[ ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
                [[██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            }
            dashboard.section.buttons.val = {
                dashboard.button("f", "󰈞  查找文件", "<cmd>Telescope find_files<CR>"),
                dashboard.button("e", "  新建文件", ":ene <BAR> startinsert<CR>"),
                dashboard.button("r", "󰄉  最近文件", "<cmd>Telescope oldfiles<CR>"),
                dashboard.button("g", "󰱼  文本检索", "<cmd>Telescope live_grep<CR>"),
                dashboard.button("c", "  修改配置", ":e $MYVIMRC<CR>"),
                dashboard.button("l", "󰒲  Lazy 状态", ":Lazy<CR>"),
                dashboard.button("q", "󰅚  退出", ":qa<CR>"),
            }

            local lazy_stats = require("lazy").stats()
            dashboard.section.footer.val = string.format(
                " ⚡ NeoVim %d/%d 插件已加载 | 耗时 %.0f ms ⚡",
                lazy_stats.loaded, lazy_stats.count, lazy_stats.startuptime
            )
            dashboard.section.footer.opts.hl = "Type"
            alpha.setup(dashboard.opts)
        end,
    },

    -- -------------------------------------------------------------------------
    -- 9. Notify & Noice 消息与通知重构
    -- -------------------------------------------------------------------------
    {
        "rcarriga/nvim-notify",
        opts = {
            background_colour = "#000000",
            timeout = 3000,
            stages = "fade_in_slide_out",
            render = "compact",
            top_down = false,
            icons = { ERROR = " ", WARN = " ", INFO = " ", DEBUG = " ", TRACE = "✎" },
        },
        config = function(_, opts)
            require("notify").setup(opts)
            vim.notify = require("notify")
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        opts = {
            lsp = { override = { ["vim.lsp.util.convert_input_to_markdown_lines"] = true } },
            presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
            routes = { { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } } },
            messages = { view = "notify", view_error = "notify", view_warn = "notify" },
            popupmenu = { backend = "nui" },
            cmdline = { view = "cmdline_popup", format = { cmdline = { pattern = "^:", icon = "" } } },
        },
    },

    -- -------------------------------------------------------------------------
    -- 10. Nvim-navic 面包屑基础配置
    -- -------------------------------------------------------------------------
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        opts = {
            icons = {
                File = "󰈙 ",
                Module = " ",
                Namespace = "包 ",
                Package = " ",
                Class = "󰠱 ",
                Method = "󰆧 ",
                Property = " ",
                Field = "󰜢 ",
                Constructor = " ",
                Enum = " ",
                Interface = " ",
                Function = "󰊕 ",
                Variable = "󰀫 ",
                Constant = "󰏿 ",
                String = "󰀬 ",
                Number = "󰎠 ",
                Boolean = " ",
                Array = "󰅪 ",
                Object = "󰅩 ",
                Key = "󰌋 ",
                Null = "󰟢 ",
                EnumMember = " ",
                Struct = "󰙅 ",
                Event = " ",
                Operator = "󰆕 ",
                TypeParameter = "󰅲 ",
            },
            highlight = true,
            depth_limit = 5,
            depth_limit_indicator = "..",
        },
    },
}
