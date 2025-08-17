-- neo-tree文件树
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
        window = {
            width = 20,
        },
    })
    vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "切换NeoTree" })
  end,
}
