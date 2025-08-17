-- icons
return {
    {
        "echasnovski/mini.nvim",
        version = false, -- 最新开发版
        config = function()
            -- 配置mini.nvim模块
            require("mini.files").setup()
        end
    },
}
