-- 文件搜索插件
return {
    "ibhagwan/fzf-lua",
    dependencies = {
         "nvim-tree/nvim-web-devicons"
    },
    keys = {
        -- 文件搜索
        { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find Files" },
        -- 最近打开的文件
        { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent Files" },
        -- 模糊全文搜索
        { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live Grep" },
        -- 当前光标单词搜索
        { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "Grep Word Under Cursor" },
        -- 查看buffers
        { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
        -- 命令行
        { "<leader>fc", function() require("fzf-lua").commands() end, desc = "Commands" },
        -- LSP 定义/引用/实现跳转
        { "gd", function() require("fzf-lua").lsp_definitions() end, desc = "Go to Definition" },
        { "gr", function() require("fzf-lua").lsp_references() end, desc = "Go to References" },
        { "gi", function() require("fzf-lua").lsp_implementations() end, desc = "Go to Implementation" },
        -- 文档诊断（LSP）
        { "<leader>ld", function() require("fzf-lua").lsp_document_diagnostics() end, desc = "Document Diagnostics" },
        -- Git状态(修改,新增文件)
        {"<leader>gs", function() require("fzf-lua").git_status() end, desc = "Git Status"},
        --- Git 提交记录
        { "<leader>gc", function() require("fzf-lua").git_commits() end, desc = "Git Commits" },
    },
}
