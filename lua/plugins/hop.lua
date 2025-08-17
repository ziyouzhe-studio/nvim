-- 快速跳转
return {
    "smoka7/hop.nvim",
    opts = {
        hint_opsition = 3
    },
    keys = {
        {"<leader>hp", ":HopWord<CR>", silent = true}
    }
}
