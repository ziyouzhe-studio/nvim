-- 代码小地图
return {
  "gorbit99/codewindow.nvim",
  config = function()
    local codewindow = require("codewindow")
    codewindow.setup({
      auto_enable = true,
      width = 12,
      use_lsp = true, -- 支持 diagnostics 显示
    })
    codewindow.apply_default_keybinds()
  end,
  keys = {
    { "<leader>mo", function()
        local cw = require("codewindow")
        if cw.is_minimap_open() then
          cw.close_minimap()
        else
          cw.open_minimap()
        end
      end, desc = "Toggle Minimap" },
  },
}

