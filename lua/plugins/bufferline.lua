return {
    "akinsho/bufferline.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons" -- bufferline icons
    },
    opts = {},
    lazy = false,
    keys = {
        {"<leader>bh", ":BufferLineCyclePrev<CR>", silent = true},
        {"<leader>bl", ":BufferLineCycleNext<CR>", silent = true},
        {"<leader>bp", ":BufferLineCyclePick<CR>", silent = true},
        {"<leader>bd", ":bdelete<CR>", silent = true},
    }
}
