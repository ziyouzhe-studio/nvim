return {
    -- 替换
    {
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        opts = {},
        config = function()
            require("grug-far").setup({});
        end
    },

    -- 快速跳转
    {
        "smoka7/hop.nvim",
        opts = {
            hint_opsition = 3
        },
        keys = {
            {"<leader>hp", ":HopWord<CR>", silent = true}
        },
    },

    -- 懒加载特殊事件
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },

    -- 代码高亮
    {
        "nvim-treesitter/nvim-treesitter",
        buid = ":TSUpdate",
        main = "nvim-treesitter.configs",
        event = "VeryLazy",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                auto_install = true,
                ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html"},
                sync_install = false,
                highlight = {enable = true},
                indent = {enable = true},
            })
        end
    },

    -- 文件浏览和搜索
    -- yazi
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        dependencies = {
            "folke/snacks.nvim",
        },
        config = function(_, opts)
            require("yazi").setup(opts)
            require("options.yazi-keymap").setup()
        end,
        opts = {
            open_for_directories = false,
            keymaps = {
                show_help = "<F1>",
            },
        },
        init = function()
            vim.g.loaded_netrwPlugin = 1
            vim.g.loaded_netrw = 1
        end, 
    },
    
    -- fzf
    {
        "ibhagwan/fzf-lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        keys = {
            -- 文件搜索
            {"<leader>ff", function() require("fzf-lua").files() end, desc = "Find Files"},
            -- 最近打开的文件
            {"<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent Files"},
            -- 模糊搜索
            {"<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live Grep"},
            -- 当前光标搜索
            {"<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "Grep Word Under Cursor"},
            -- 查看buffers
            {"<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers"},
            -- 命令行
            {"<leader>fc", function() require("fzf-lua").commands() end, desc = "Commands"},
            -- Git状态(修改，新增文件)
            {"<leader>gs", function() require("fzf-lua").git_status() end, desc = "Git Status"},
            -- Git提交记录
            {"<leader>gc", function() require("fzf-lua").git_commits() end, desc = "Git Commits"},
        },
    },
}
