-- =============================================================================
-- 文件位置: lua/core/lazy.lua
-- 说明: Lazy.nvim 插件管理器自动安装与全局面板 UI 配置
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- 如果本地不存在 lazy.nvim，则自动通过 git 克隆下载
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." }
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- 启动 Lazy 管理器配置
require("lazy").setup({
    -- 自动导入 lua/plugins/ 目录下的所有插件配置文件
    spec = { { import = "plugins" } },
    
    -- 当未配置色彩时备用的内置主题
    install = { colorscheme = { "tokyonight", "habamax" } },
    
    -- 插件更新自动检查 (静默模式，避免弹窗提示打扰)
    checker = { enabled = true, notify = false },
    
    -- 禁用 Neovim 部分原生无用脚本以压榨启动速度
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
    
    -- Lazy 弹窗管理界面外观样式
    ui = {
        size = { width = 0.8, height = 0.8 }, -- 面板占屏比例 80%
        border = "rounded",                   -- 优雅圆角边框
        title = " 󰂖 Lazy.nvim 插件管理器 ",
        title_pos = "center",
        icons = {
            cmd = " ", config = "⚙", event = " ", ft = "📂 ",
            init = "⚙ ", keys = "🗝 ", plugin = "🔌 ", runtime = "💻 ",
            require = "🌙 ", source = "📄 ", start = "🚀 ", task = "📌 ", lazy = "💤 ",
        },
    },
})

-- 快捷键：Normal 模式下按 <leader>l 调出 Lazy 管理面板
vim.keymap.set("n", "<leader>l", "<CMD>Lazy<CR>", { desc = "打开 Lazy.nvim 面面板" })
