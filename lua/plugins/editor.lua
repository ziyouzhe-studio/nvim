-- =============================================================================
-- 文件位置: lua/plugins/editor.lua
-- 说明: 代码编辑增强工具（全局替换、Treesitter、搜索、终端、跳转等）
-- =============================================================================

return {
    -- -------------------------------------------------------------------------
    -- 1. Grug-far 全局搜索替换窗口 (替代传统的 far.vim / spectre)
    -- -------------------------------------------------------------------------
    { 
        "MagicDuck/grug-far.nvim", 
        cmd = "GrugFar", 
        opts = { headerMaxWidth = 80 },
        keys = {
            { "<leader>sr", "<cmd>GrugFar<cr>", desc = "全局搜索与替换 (GrugFar)" },
        },
    },

    -- -------------------------------------------------------------------------
    -- 2. Nvim-surround 快速处理包围字符 (括号、引号、HTML 标签等)
    -- -------------------------------------------------------------------------
    { 
        "kylechui/nvim-surround", 
        event = "VeryLazy", 
        opts = {} 
    },

    -- -------------------------------------------------------------------------
    -- 3. Treesitter 语法分析与深度高亮引擎 (修复兼容性报错版)
    -- -------------------------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false, -- 设为 false 确保首屏渲染高亮时不因加载时序报错
        config = function()
            -- 使用 pcall 兼容新旧版本 API (nvim-treesitter.configs 与 nvim-treesitter.config)
            local status_ok, configs = pcall(require, "nvim-treesitter.configs")
            if not status_ok then
                status_ok, configs = pcall(require, "nvim-treesitter.config")
            end

            if status_ok and configs then
                configs.setup({
                    auto_install = true, -- 首次打开未知语言文件时自动安装 Parser
                    ensure_installed = { 
                        "c", "lua", "vim", "vimdoc", "query", 
                        "javascript", "html", "markdown", "python", "bash" 
                    },
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        end,
    },

    -- -------------------------------------------------------------------------
    -- 4. Yazi 现代化终端文件管理器 (用于替代 netrw)
    -- -------------------------------------------------------------------------
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        opts = { 
            open_for_directories = false, 
            keymaps = { show_help = "<F1>" } 
        },
        keys = {
            { "<leader>fo", "<cmd>Yazi<CR>", desc = "在当前文件路径打开 Yazi" },
            { "<leader>fc", "<cmd>Yazi cwd<CR>", desc = "在工作根目录打开 Yazi" },
            { "<leader>fr", "<cmd>Yazi toggle<CR>", desc = "恢复 Yazi 挂起状态" },
        },
        init = function()
            -- 彻底禁用 Neovim 自带的 netrw 避开冲突
            vim.g.loaded_netrwPlugin = 1
            vim.g.loaded_netrw = 1
        end,
    },

    -- -------------------------------------------------------------------------
    -- 5. Leap.nvim 2 字符极速代码跳转
    -- -------------------------------------------------------------------------
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        event = "VeryLazy",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            local leap = require("leap")
            -- 绑定官方标准快捷键: s (向前/向后跳转), S (跨窗口跳转)
            leap.add_default_mappings()
        end,
    },

    -- -------------------------------------------------------------------------
    -- 6. Telescope 强力模糊查找器
    -- -------------------------------------------------------------------------
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "echasnovski/mini.icons",
            "nvim-telescope/telescope-media-files.nvim",
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "模糊查找文件名" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Ripgrep 实时文本内容搜索" },
            { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "搜索光标下的单词" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "最近打开的文件历史" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "活动中的缓冲区列表" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "查找 Neovim 帮助文档" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "LSP 全局诊断报错列表" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "当前文件函数/符号列表" },
            { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git 修改文件状态" },
            { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git 历史提交记录" },
            { "<leader>fm", "<cmd>Telescope media_files<cr>", desc = "多媒体/图片列表预览" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },
                    layout_strategy = "horizontal",
                    layout_config = { horizontal = { prompt_position = "top", preview_width = 0.55 } },
                    sorting_strategy = "ascending",
                    file_ignore_patterns = { "node_modules", ".git", "%.lock", "__pycache__" },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-c>"] = actions.close,
                            ["<CR>"] = actions.select_default,
                        },
                        n = { ["q"] = actions.close },
                    },
                    preview = { treesitter = false }, -- 关闭 preview 的 treesitter 以防解析报错
                },
            })
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "media_files")
        end,
    },

    -- -------------------------------------------------------------------------
    -- 7. Image.nvim 终端图片原生渲染预览支持
    -- -------------------------------------------------------------------------
    {
        "3rd/image.nvim",
        event = "VeryLazy",
        opts = {
            backend = "kitty",
            integrations = {
                markdown = { enabled = true, clear_in_insert_mode = false, download_remote_images = true },
                telescope = { enabled = true },
                neotree = { enabled = true },
            },
            max_width = 100,
            max_height = 12,
        },
    },

    -- -------------------------------------------------------------------------
    -- 8. Dropbar.nvim IDE 风格顶栏面包屑
    -- -------------------------------------------------------------------------
    {
        "Bekaboo/dropbar.nvim",
        event = "BufReadPost",
        dependencies = { "echasnovski/mini.icons" },
        config = function()
            local dropbar = require("dropbar")
            local api = require("dropbar.api")

            dropbar.setup({
                bar = {
                    enable = function(buf, win)
                        return vim.api.nvim_buf_is_valid(buf)
                            and vim.api.nvim_win_is_valid(win)
                            and vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
                            and vim.api.nvim_buf_get_name(buf) ~= ""
                            and not vim.wo[win].diff
                    end,
                    hover = true,
                },
                sources = {
                    path = {
                        relative_to = function(buf)
                            local root = vim.fs.dirname(
                                vim.fs.find({ ".git", "Makefile", "package.json" }, {
                                    upward = true, 
                                    path = vim.api.nvim_buf_get_name(buf),
                                })[1]
                            )
                            return root or vim.fn.getcwd()
                        end,
                    },
                },
                menu = {
                    keymaps = {
                        ["q"] = "<C-w>c",
                        ["<Esc>"] = "<C-w>c",
                        ["<CR>"] = function() api.fuzzy_find_toggle() end,
                        ["i"] = function() api.fuzzy_find_toggle() end,
                    },
                    win_configs = { border = "rounded" },
                },
            })

            vim.keymap.set("n", "<Leader>bs", api.pick, { desc = "Dropbar: 呼出面包屑菜单" })
            vim.keymap.set("n", "<Leader>bk", api.goto_context_start, { desc = "Dropbar: 跳至作用域开头" })
            vim.keymap.set("n", "<Leader>bj", api.select_next_context, { desc = "Dropbar: 选中外层上下文" })
        end,
    },

    -- -------------------------------------------------------------------------
    -- 9. Toggleterm 浮动终端与 Lazygit Git 界面集成
    -- -------------------------------------------------------------------------
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { [[<c-\>]], "<cmd>ToggleTerm<cr>", desc = "切换终端面板" },
            { "<leader>gg", desc = "切换 Lazygit 界面" },
        },
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                size = 20,
                start_in_insert = true,
                direction = "float",
                close_on_exit = true,
                float_opts = { border = "curved", winblend = 3 },
            })

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                float_opts = { border = "curved" },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    -- 打开 Lazygit 窗口时单独解除 <esc> 绑定，以便在内部正常按 Esc 键
                    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<esc>", { noremap = true, silent = true })
                end,
            })

            vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "切换 Lazygit 状态" })
        end,
    },
}
