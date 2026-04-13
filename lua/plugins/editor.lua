return {
    -- 全局搜索替换
    { "MagicDuck/grug-far.nvim", cmd = "GrugFar", opts = {} },

    -- 包围文本
    { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

    -- Treesitter 语法高亮
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        event = "VeryLazy",
        config = function()
            require("nvim-treesitter.config").setup({
                auto_install = true,
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "markdown" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true }
            })
        end
    },

    -- 文件管理器 (Yazi)
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        dependencies = { "folke/snacks.nvim" },
        opts = { open_for_directories = false, keymaps = { show_help = "<F1>" } },
        config = function(_, opts)
            require("yazi").setup(opts)
            -- Yazi 快捷键内嵌于此
            local map = vim.keymap.set
            local opt = { noremap = true, silent = true }
            map("n", "<leader>fo", "<cmd>Yazi<CR>", vim.tbl_extend("force", opt, { desc = "Yazi at current file" }))
            map("n", "<leader>fc", "<cmd>Yazi cwd<CR>", vim.tbl_extend("force", opt, { desc = "Yazi at working dir" }))
            map("n", "<leader>fr", "<cmd>Yazi toggle<CR>", vim.tbl_extend("force", opt, { desc = "Resume Yazi" }))
        end,
        init = function()
            vim.g.loaded_netrwPlugin = 1
            vim.g.loaded_netrw = 1
        end
    },

     -- ============================================================
    -- Leap.nvim (智能快速跳转) – 替代 Hop.nvim
    -- ============================================================
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        dependencies = { "tpope/vim-repeat" },   -- 支持 . 重复 Leap 操作
        config = function()
            -- 官方推荐的默认映射
            vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
            vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)")

            -- 可选：自定义 leap 外观或行为（如需要可取消注释）
            -- require("leap").setup({
            --     safe_labels = "sfnut/SFNLHMUGTZ?",
            --     labels = "sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?",
            --     highlight_unlabeled = true,
            -- })
        end
    },

    -- ============================================================
    -- Telescope (模糊查找器) – 最终稳定版
    -- ============================================================
    {
        "nvim-telescope/telescope.nvim",
        -- 注意：不锁定版本，使用最新以兼容 treesitter
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- fzf-native 扩展可选，若编译失败请注释下行
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local builtin = require("telescope.builtin")

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
                        n = {
                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["q"] = actions.close,
                        }
                    },
                    -- 关键修复：禁用 treesitter 预览高亮（避免 ft_to_lang 错误）
                    preview = { treesitter = false }
                }
            })

            -- 可选：如果 fzf-native 编译成功，取消下面注释
            -- pcall(require("telescope").load_extension, "fzf")

            -- 快捷键映射
            local map = vim.keymap.set
            map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
            map("n", "<leader>fw", builtin.grep_string, { desc = "Grep word under cursor" })
            map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
            map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
            map("n", "<leader>fc", builtin.commands, { desc = "Commands" })
            map("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
            map("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
            map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
            map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
            map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document Symbols" })
            map("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
            -- 功能分类	快捷键	对应方法 (builtin.*)	功能说明
            -- 文件查找	<leader>ff	find_files()	模糊搜索项目中的文件名
            -- 实时内容搜索	<leader>fg	live_grep()	使用 ripgrep 实时搜索文件内容
            -- 光标下词搜索	<leader>fw	grep_string()	搜索当前光标下的单词
            -- 缓冲区管理	<leader>fb	buffers()	列出所有打开的缓冲区
            -- 帮助文档	<leader>fh	help_tags()	快速查找 Vim/Neovim 帮助标签
            -- 快捷键查询	<leader>fk	keymaps()	浏览所有已定义的快捷键映射
            -- LSP 诊断	<leader>fd	diagnostics()	查看项目中 LSP 报告的错误和警告
            -- 最近文件	<leader>fr	oldfiles()	列出最近打开过的文件
            -- Neovim 命令	<leader>fc	commands()	列出所有 Ex 命令
            -- Git 状态	<leader>gs	git_status()	显示 Git 仓库的当前状态
            -- Git 提交历史	<leader>gc	git_commits()	查看当前 Git 仓库的提交记录
            -- LSP 符号	<leader>fs	lsp_document_symbols()	列出当前文件中的函数、类等符号
        end
    }
}
