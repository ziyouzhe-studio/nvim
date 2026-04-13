return {
    -- 补全引擎 (blink.cmp)
    {
        "saghen/blink.cmp",
        event = { "BufReadPost", "BufNewFile"},
        version = "1.*",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "xzbdmw/colorful-menu.nvim", opts = {},
            "L3MON4D3/LuaSnip", version = "v2.*",
        },
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "super-tab",
                ['<C-u>'] = {'scroll_documentation_up', 'fallback'},
                ['<C-d>'] = {'scroll_documentation_down', 'fallback'},
                -- 进阶：在LuaSnip的ChoiceNote(多选节点)间切换
                ['<C-l>'] = { function ()
                    if require("luasnip").choice_active() then
                        require("luasnip").change_choice(1)
                    end
                end},
                ['<C-h>'] = { function ()
                    if require("luasnip").choice_active() then
                        require("luasnip").change_choice(-1)
                    end
                end},
            },
            appearance = {
                nerd_font_variant = "mono",
                kind_icons = {
                    Text = "󰉿", Method = "󰊕", Function = "󰊕", Constructor = "",
                    Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
                    Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎟",
                    Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
                    File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
                    Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕", TypeParameter = "󰅲"
                }
            },
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    snippets = { score_offset = 1000 },
                },
            },
            completion = {
                -- menu = { border = "rounded" },
                menu = {
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").
                                    blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").
                                    blink_components_highlight(ctx)
                                end,
                            }
                        },
                    },
                },
                documentation = { window = { border = "rounded" } }
            },
            signature = {
                enabled = true,
            },
            cmdline = {
                completion = {
                    menu = {
                        auto_show = true,
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },

    -- LSP 核心
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp", "SmiteshP/nvim-navic"},
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local navic = require("nvim-navic")

            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                -- 关键：附加 navic 到当前 LSP 客户端
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end

            -- 诊断图标
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN]  = "󰀪 ",
                        [vim.diagnostic.severity.HINT]  = "󰌵 ",
                        [vim.diagnostic.severity.INFO]  = "󰋽 "
                    }
                },
                float = { border = "rounded" }
            })

            require("mason").setup({ ui = { border = "rounded" } })
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "ts_ls", "gopls", "clangd" },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({ capabilities = capabilities, on_attach = on_attach })
                    end,
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = { Lua = { diagnostics = { globals = { "vim" } } } }
                        })
                    end
                }
            })
        end
    },

    -- 代码片段引擎
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- 推荐版本号
        build = "make install_jsregexp", -- 可选，支持正则表达式
        dependencies = {
            "rafamadriz/friendly-snippets", -- 包含大量VScode风格代码片段
        },
        config = function ()
           local ls = require("luasnip")
           -- 自动加载扩展片段(从friendly-snipppets加载)
           ls.config.set_config({
               history = true, -- 退出插入模式后仍然保留跳转历史
               updateevents = "TextChanged, TextChangedI", -- 文本改变时更新
               enable_autosnippets = true, -- 开启自动触发片段
           })

           -- 包含大量VScode风格代码片段(friendly-snippets)
           require("luasnip.loaders.from_vscode").lazy_load()
           -- 进阶：加载自定义片段(需在nvim配置目录下创建snippets文件夹)
           require("luasnip.loaders.from_vscode").lazy_load({
               paths = { vim.fn.stdpath("config").. "/snippets" }
           })

           -- 可以在这里通过Lua自定义一些快捷键片段
           ls.add_snippets("all", {
               -- 示例：输入currtime展开为当前时间
               ls.snippet("currtime", {
                   ls.function_node(function() return os.date("%H:%M:%S") 
                   end)
               }),
           })
        end,
    },
}
