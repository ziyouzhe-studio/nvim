return {
    -- ========================= 文件树 =========================
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        config = function()
            require("neo-tree").setup({
                window = { width = 25 },
                filesystem = { filtered_items = { hide_dotfiles = false, hide_gitignored = false } }
            })
            vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file tree" })
        end,
    },

    -- ========================= 标签栏 (Bufferline) 修复版 =========================
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
                    enforce_regular_tabs = false,
                    always_show_bufferline = true,
                    hover = { enabled = true, reveal = { "close" } }
                }
            }
            -- 安全地加载 catppuccin 集成（仅在主题激活时）
            if vim.g.colors_name and vim.g.colors_name:find("catppuccin") then
                local ok, cat_integrations = pcall(require, "catppuccin.groups.integrations.bufferline")
                if ok then
                    opts.highlights = cat_integrations.get()
                end
            end
            return opts
        end,
        config = function(_, opts)
            require("bufferline").setup(opts)
        end
    },

    -- ========================= 状态栏 (Lualine) 极致美化 =========================
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "SmiteshP/nvim-navic"
        },
        config = function()
            local navic = require("nvim-navic")
            local function file_size()
                local path = vim.api.nvim_buf_get_name(0)
                if path == "" then return "" end
                local stat = vim.loop.fs_stat(path)
                if not stat then return "" end
                local size = stat.size
                if size < 1024 then return size .. "B"
                elseif size < 1024 * 1024 then return string.format("%.1fK", size / 1024)
                elseif size < 1024 * 1024 * 1024 then return string.format("%.1fM", size / (1024 * 1024))
                else return string.format("%.1fG", size / (1024 * 1024 * 1024))
                end
            end

            local function lsp_client()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                local names = {}
                for _, client in ipairs(clients) do
                    table.insert(names, client.name)
                end
                return table.concat(names, ", ")
            end

            local function recording_status()
                local recording_reg = vim.fn.reg_recording()
                if recording_reg == "" then return "" end
                return "ﯚ Recording @" .. recording_reg
            end

            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { "NvimTree", "neo-tree" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { { "mode", fmt = function(str) return " " .. str end } },
                    lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " ", hint = " " } } },
                    lualine_c = {
                        { "filename", path = 1, symbols = { modified = "●", readonly = "", unnamed = "" } },
                        { function() return require("nvim-navic").get_location() end, cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end },
                       { navic.get_location, cond = navic.is_available },
                    },
                    lualine_x = {
                        { file_size, icon = "󰉋" },
                        { "filetype", icon_only = true },
                        { lsp_client, icon = "󰅩" },
                        "encoding",
                        "fileformat"
                    },
                    lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 0 } }, "location" },
                    lualine_z = { { recording_status, cond = function() return vim.fn.reg_recording() ~= "" end } }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                extensions = { "fzf", "nvim-tree" }
            })
        end
    },

    -- ========================= 快捷键提示 (which-key) =========================
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = { enabled = true } },
            win = { border = "rounded" },
            layout = { align = "center", spacing = 3 },
            icons = { breadcrumb = "»", separator = "➜", group = "+", ellipsis = "…" },
            show_help = true,
            show_keys = true,
            preset = "helix"
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.add({
                { "<leader>f", group = "File" },
                { "<leader>g", group = "Git" },
                { "<leader>l", group = "Lazy" },
                { "<leader>s", group = "Search" },
                { "<leader>w", group = "Window" },
                { "<leader>h", group = "Help" },
                { "s", group = "Leap (jump)"},
                { "S", group = "Leap across windows"},
            })
        end
    },

    -- ========================= 代码小地图 =========================
    {
      "Isrothy/neominimap.nvim",
      version = "v3.x.x",           -- 锁定版本，保证稳定性
      lazy = false,                 -- 必须立即加载
      dependencies = {
        -- 必要依赖
        "nvim-treesitter/nvim-treesitter",     -- 代码结构高亮（强烈推荐）
        "lewis6991/gitsigns.nvim",             -- Git 变更显示（强烈推荐）
        -- 可选美化
        "nvim-tree/nvim-web-devicons",
      },
      keys = {
        -- 全局小地图开关（推荐）
        { "<leader>mm", "<cmd>Neominimap Toggle<cr>",       desc = "Toggle global minimap" },
        { "<leader>mo", "<cmd>Neominimap Enable<cr>",       desc = "Enable global minimap" },
        { "<leader>mc", "<cmd>Neominimap Disable<cr>",      desc = "Disable global minimap" },
        { "<leader>mr", "<cmd>Neominimap Refresh<cr>",      desc = "Refresh global minimap" },
      },
      init = function()
        -- Float 布局时推荐设置
        vim.opt.wrap = false
        vim.opt.sidescrolloff = 36

        ---@type Neominimap.UserConfig
        vim.g.neominimap = {
          auto_enable = true,
          layout = "float",           -- 推荐使用 float 布局
          x_multiplier = 4,
          y_multiplier = 1,

          -- 排除不必要的缓冲区
          exclude_filetypes = { "help", "bigfile", "gitcommit", "gitrebase", "qf", "NvimTree", "neo-tree" },
          exclude_buftypes = { "nofile", "nowrite", "quickfix", "terminal", "prompt" },

          -- 集成
          treesitter = { enabled = true },
          diagnostic = { enabled = true },
          git = { enabled = true },
          fold = { enabled = true },

          -- 外观与交互
          winblend = 15,
          float = {
            minimap_width = 20,
            margin = { right = 1, top = 0, bottom = 0 },
            z_index = 10,
            window_border = "single",
            persist = true,
          },

          click = { enabled = true, auto_switch_focus = true },
          sync_cursor = true,
          delay = 150,
        }
      end,
    },
     -- ========================= 代码大纲 =========================
    {
        "stevearc/aerial.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { layout = { min_width = 20 } },
        config = function()
            require("aerial").setup()
            vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle outline" })
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { desc = "Previous symbol" })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { desc = "Next symbol" })
        end
    },

    -- ========================= 启动仪表盘 (Alpha) =========================
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
                dashboard.button("f", "󰈞  Find File", "<cmd>Telescope find_files<CR>"),
                dashboard.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
                dashboard.button("r", "󰄉  Recent Files", "<cmd>Telescope oldfiles<CR>"),
                dashboard.button("g", "󰱼  Find Text", "<cmd>Telescope live_grep<CR>"),
                dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
                dashboard.button("l", "󰒲  Lazy.nvim", ":Lazy<CR>"),
                dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
            }

            -- 获取 lazy.nvim 的统计信息
            local lazy_stats = require("lazy").stats()
            local plugin_count = lazy_stats.count           -- 总插件数
            local loaded_count = lazy_stats.loaded          -- 已加载插件数
            local startuptime = lazy_stats.startuptime      -- 启动耗时（毫秒）

            -- 格式化底部信息
            local footer_text = string.format(
                " ⚡ NeoVim %d/%d plugins loaded in %.0f ms   ⚡",
                loaded_count, plugin_count, startuptime
            )

            -- dashboard.section.footer.val = "⚡=== NeoVim === ⚡"
            dashboard.section.footer.val = footer_text
            dashboard.section.footer.opts.hl = "Type"
            alpha.setup(dashboard.opts)
        end
    },

    -- ========================= 通知美化 =========================
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
                timeout = 3000,
                stages = "fade_in_slide_out",
                render = "compact",
                top_down = false,
                icons = { ERROR = " ", WARN = " ", INFO = " ", DEBUG = " ", TRACE = "✎" }
            })
            vim.notify = require("notify")
        end
    },

    -- ========================= 消息界面重构 =========================
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
            cmdline = { view = "cmdline_popup", format = { cmdline = { pattern = "^:", icon = "" } } }
        }
    },

    -- ========================= LSP 面包屑 =========================
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
            icons = {
                File = "󰈙 ",
                Module = " ",
                Namespace = "󰦨 ",
                Package = "󰏗 ",
                Class = "󰠱 ",
                Method = "󰆧 "
            },
                separator = " > ",    -- 路径分隔符[reference:5]
                depth_limit = 3,      -- 限制显示的深度[reference:6]
                depth_limit_indicator = "…", -- 超出深度限制时的指示符[reference:7]
                highlight = true     -- 启用语法高亮[reference:8]
        },
        config = function()
            require("nvim-navic").setup({
                icons = { File = "󰈙 ", Module = " ", Namespace = " ", Package = " ", Class = "󰠱 ", Method = "󰊕 ", Property = " ", Field = "󰜢 ", Constructor = " ", Enum = " ", Interface = " ", Function = "󰊕 ", Variable = "󰀫 ", Constant = "󰏿 ", String = "󰀬 ", Number = "󰎠 ", Boolean = " ", Array = "󰅪 ", Object = "󰅩 ", Key = "󰌋 ", Null = "󰟢 ", EnumMember = " ", Struct = "󰙅 ", Event = " ", Operator = "󰆕 ", TypeParameter = "󰅲 " },
                highlight = true,
                depth_limit = 5,
                depth_limit_indicator = ".."
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("nvim-navic", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.server_capabilities.documentSymbolProvider then
                        require("nvim-navic").attach(client, args.buf)
                    end
                end
            })
        end
    }
}
