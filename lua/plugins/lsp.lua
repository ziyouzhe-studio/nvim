-- =============================================================================
-- 文件位置: lua/plugins/lsp.lua
-- 说明: 核心 LSP、Mason 管理器、代码片段引擎与 Blink.cmp 自动补全
-- =============================================================================

return {
    -- -------------------------------------------------------------------------
    -- 1. LuaSnip 代码片段引擎
    -- -------------------------------------------------------------------------
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local ls = require("luasnip")
            ls.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true,
            })
            -- 加载常用的 VSCode 格式开源片段集
            require("luasnip.loaders.from_vscode").lazy_load()
            -- 加载本地 ~/.config/nvim/snippets 目录下的自定义片段
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" },
            })
        end,
    },

    -- -------------------------------------------------------------------------
    -- 2. Blink.cmp 补全引擎 (纯 Rust 原生极速匹配算法)
    -- -------------------------------------------------------------------------
    {
        "saghen/blink.cmp",
        lazy = false, -- 取消延迟加载，保证打开即用
        version = "v0.*",
        dependencies = {
            "rafamadriz/friendly-snippets",
            { "xzbdmw/colorful-menu.nvim", opts = {} },
            "L3MON4D3/LuaSnip",
        },
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "super-tab", -- 使用熟悉的 Super-Tab 按键绑定
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-l>"] = { function()
                    if require("luasnip").choice_active() then require("luasnip").change_choice(1) end
                end },
                ["<C-h>"] = { function()
                    if require("luasnip").choice_active() then require("luasnip").change_choice(-1) end
                end },
            },
            appearance = { nerd_font_variant = "mono" },
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    lsp = { score_offset = 100 },     -- 提升 LSP 源优先级
                    snippets = { score_offset = 80 }, -- 提升代码片段源优先级
                    buffer = {
                        score_offset = 20,
                        -- 性能关键点：仅对有效常规文件 Buffer 扫描，避免打字卡顿
                        opts = {
                            get_bufnrs = function()
                                return vim.tbl_filter(function(bufnr)
                                    return vim.bo[bufnr].buftype == ""
                                end, vim.api.nvim_list_bufs())
                            end,
                        },
                    },
                },
            },
            completion = {
                -- 0ms 瞬间显示详细函数文档浮窗
                documentation = { auto_show = true, auto_show_delay_ms = 0, window = { border = "rounded" } },
                ghost_text = { enabled = true },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
                                highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
                            },
                        },
                    },
                },
            },
            signature = { enabled = true, window = { border = "rounded" } },
            cmdline = { completion = { menu = { auto_show = true } } },
            fuzzy = { implementation = "prefer_rust_with_warning" }, -- 优先开启 Rust SIMD 原生匹配
        },
        opts_extend = { "sources.default" },
    },

    -- -------------------------------------------------------------------------
    -- 3. Nvim-lspconfig 与 Mason 自动化服务
    -- -------------------------------------------------------------------------
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            "SmiteshP/nvim-navic",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local navic = require("nvim-navic")

            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

            -- 通用 Attach 绑定逻辑
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)                   -- 跳转至定义
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)                  -- 跳转至声明
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                         -- 悬浮查看函数文档
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)               -- 跳转至接口实现
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)                   -- 查看代码引用列表
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)               -- 变量/函数批量重命名
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- 呼出代码修复建议
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)                 -- 跳至上一个诊断问题
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)                 -- 跳至下一个诊断问题

                -- 开启嵌入式参数名与类型提示 (Inlay Hints)
                if client.supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
                -- 绑定状态栏/顶栏面包屑
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end

            -- 全局诊断浮窗样式调整
            vim.diagnostic.config({
                virtual_text = { prefix = "●", spacing = 4, source = "if_many" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN]  = "󰀪 ",
                        [vim.diagnostic.severity.HINT]  = "󰌵 ",
                        [vim.diagnostic.severity.INFO]  = "󰋽 ",
                    },
                },
                float = { border = "rounded", source = "always", focusable = false },
                update_in_insert = false, -- 打字期间不刷新诊断结果，提升键盘打字速度
            })

            require("mason").setup({ ui = { border = "rounded" } })
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "ts_ls", "gopls", "clangd" },
                handlers = {
                    -- 默认服务端 Setup 闭包
                    function(server_name)
                        lspconfig[server_name].setup({ capabilities = capabilities, on_attach = on_attach })
                    end,
                    -- Lua 专属调优
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } }, -- 消除 Undefined global 'vim' 报错
                                    hint = { enable = true, paramName = "All", paramType = true },
                                    workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
                                    telemetry = { enable = false },
                                },
                            },
                        })
                    end,
                    -- C/C++ 专属调优 (多线程 CPU 并发索引)
                    ["clangd"] = function()
                        lspconfig.clangd.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            cmd = {
                                "clangd", "--background-index", "--clang-tidy",
                                "--header-insertion=iwyu", "--completion-style=detailed",
                                "--function-arg-placeholders", "--fallback-style=llvm",
                                "-j=12", "--pch-storage=memory", "--all-scopes-completion",
                            },
                        })
                    end,
                },
            })
        end,
    },
}
