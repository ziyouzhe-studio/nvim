return {
  -- =============================================================
  -- 1. blink.cmp: 极速补全引擎 (集成图标与 Super-Tab)
  -- =============================================================
  {
    'saghen/blink.cmp',
    version = '*',
    dependencies = 'rafamadriz/friendly-snippets',
    opts = {
      -- 响应你的需求：使用 Tab 补全，Shift-Tab 反选
      keymap = { preset = 'super-tab' },

      appearance = {
        nerd_font_variant = 'mono',
        -- 补全菜单中的图标映射
        kind_icons = {
          Text = '󰉿', Method = '󰊕', Function = '󰊕', Constructor = '',
          Field = '󰜢', Variable = '󰀫', Class = '󰠱', Interface = '',
          Module = '', Property = '󰜢', Unit = '󰑭', Value = '󰎟',
          Enum = '', Keyword = '󰌋', Snippet = '', Color = '󰏘',
          File = '󰈙', Reference = '󰈇', Folder = '󰉋', EnumMember = '',
          Constant = '󰏿', Struct = '󰙅', Event = '', Operator = '󰆕',
          TypeParameter = '󰅲',
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      completion = {
        menu = {
          border = 'rounded',
          draw = {
            columns = { { "kind_icon", "kind", gap = 1 }, { "label", "label_description", gap = 1 } },
          },
        },
        documentation = { window = { border = 'rounded' } },
      }
    },
  },

  -- =============================================================
  -- 2. nvim-lspconfig: LSP 核心配置 (解决报错与警告)
  -- =============================================================
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- 通用快捷键绑定
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      end

      -- 【修复图2警告】：改用 0.10+ 推荐的新 API 设置行号栏图标
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN]  = "󰀪 ",
            [vim.diagnostic.severity.HINT]  = "󰌵 ",
            [vim.diagnostic.severity.INFO]  = "󰋽 ",
          },
        },
        float = { border = 'rounded' },
      })

      -- 初始化 Mason
      require("mason").setup({ ui = { border = "rounded" } })

      -- 【核心修复图1报错】：直接在 setup 的 handlers 中初始化所有 LSP
      -- 这种方式不再需要单独调用 setup_handlers，能有效避免 nil 错误
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ts_ls", "gopls", "clangd"},
        handlers = {
          -- 默认处理器：自动为 ensure_installed 中的服务器配置 capabilities 和 on_attach
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,

          -- Lua 特殊配置
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                Lua = { diagnostics = { globals = { "vim" } } }
              }
            })
          end,
        },
      })
    end,
  },
}
