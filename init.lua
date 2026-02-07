require("core.options")
require("core.keymaps")
require("core.lazy")

-- 主题颜色
vim.cmd("colorscheme catppuccin")

-- 设置背景透明
vim.cmd("autocmd VimEnter * hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("autocmd VimEnter * hi VertSplit guibg=NONE ctermbg=NONE")
vim.cmd("autocmd VimEnter * hi StatusLine guibg=NONE ctermbg=NONE")
vim.cmd("autocmd VimEnter * hi TabLine guibg=NONE ctermbg=NONE")
vim.cmd("autocmd VimEnter * hi Pmenu guibg=NONE ctermbg=NONE")

-- 让 LSP 浮窗带边框
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 }, -- 虚拟文本显示
  update_in_insert = false, -- 插入模式下不更新，避免视觉干扰
  float = { border = "rounded", source = "always" },
})
