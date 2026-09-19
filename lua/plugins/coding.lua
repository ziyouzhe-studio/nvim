-- =============================================================================
-- 文件位置: lua/plugins/coding.lua
-- 说明: 编码体验增强插件（括号自动配对、Markdown 增强、AI 自动补全等）
-- =============================================================================

return {
    -- 1. 自动配对括号/引号
    { "windwp/nvim-autopairs",  event = "InsertEnter", config = true },

    -- 2. 基于 Treesitter 的智能注释支持
    { "folke/ts-comments.nvim", event = "VeryLazy",    opts = {} },

    -- 3. 彩虹缩进彩线条 (Indent Blankline)
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)
            require("ibl").setup({
                indent = {
                    highlight = {
                        "RainbowRed", "RainbowYellow", "RainbowBlue",
                        "RainbowOrange", "RainbowGreen", "RainbowViolet", "RainbowCyan",
                    },
                },
            })
        end,
    },

    -- 4. Markdown 折叠与隐藏配置
    {
        "plasticboy/vim-markdown",
        ft = "markdown",
        config = function()
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_conceal = 0
            vim.g.vim_markdown_new_list_item_indent = 0
        end,
    },

    -- 5. Render-markdown 实时渲染增强
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "norg", "rmd", "org" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
        opts = {
            completions = { lsp = { enabled = true } },
            code = { width = "block", left_pad = 2, right_pad = 4 },
            checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
            quote = { repeat_linebreak = true },
            pipe_table = { preset = "round" },
            heading = { border = true, icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
            indent = { enabled = true, skip_heading = true }, },
    },

    -- 6. NeoCodeium AI 代码自动补全插件
    {
        "monkoose/neocodeium",
        event = "InsertEnter",
        config = function()
            local neocodeium = require("neocodeium")

            neocodeium.setup({
                silent = true,
                show_status = false,
                -- 核心过滤逻辑：当 blink.cmp 的选择菜单弹出时，自动隐藏 AI 虚影，避免覆盖
                filter = function()
                    local ok, cmp = pcall(require, "blink.cmp")
                    return not (ok and cmp.is_visible())
                end,
            })

            -- 安全映射快捷键 (使用 Alt 组合键，彻底解决 Tab 键覆盖问题)
            vim.keymap.set("i", "<A-f>", function()
                if neocodeium.visible() then neocodeium.accept() end
            end, { desc = "NeoCodeium: 采纳完整建议" })

            -- 如果你想继续用 <Tab> 采纳 AI 建议：
            --vim.keymap.set("i", "<Tab>", function()
            --    if neocodeium.visible() then
            --        neocodeium.accept()
            --    else
            --        -- 否则退回原生 Tab 键行为
            --        return "<Tab>"
            --    end
            --end, { expr = true, silent = true })

            vim.keymap.set("i", "<A-w>", neocodeium.accept_word, { desc = "NeoCodeium: 采纳单个单词" })
            vim.keymap.set("i", "<A-l>", neocodeium.accept_line, { desc = "NeoCodeium: 采纳整行" })
            vim.keymap.set("i", "<A-]>", neocodeium.cycle_or_complete, { desc = "NeoCodeium: 切换下一个方案" })
            vim.keymap.set("i", "<A-[>", function() neocodeium.cycle_or_complete(-1) end,
                { desc = "NeoCodeium: 切换上一个方案" })
            vim.keymap.set("i", "<A-c>", neocodeium.clear, { desc = "NeoCodeium: 清除当前提示" })
        end,
    },
}
