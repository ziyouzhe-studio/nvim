-- 加载核心配置（顺序不可变）
require("core.options")
require("core.keymaps")

-- 启动插件管理器（会自动安装插件）
require("core.lazy")

-- 设置主题（必须在插件加载后）
-- vim.cmd.colorscheme("onedark")
vim.cmd.colorscheme("catppuccin")
