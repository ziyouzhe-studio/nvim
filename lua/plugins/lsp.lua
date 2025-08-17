-- 语言服务器和代码补全提示
return {
    {
        -- LSP管理器
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "lua-language-server"
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed)do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },

    -- LSP Blink 补全插件
    "neovim/nvim-lspconfig",
    dependencies = {"saghen/blink.cmp"},
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local lspconfig = require("lspconfig")
        lspconfig["lua_ls"].setup({capabilities = capabilities})
    end,
    
    -- LSP增强插件
    "nvimdev/lspsaga.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lspsaga").setup({})
        require("options.lspsaga-keymap").setup() -- 绑定快捷键
    end,
}
