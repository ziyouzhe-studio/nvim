-- lua/keymaps/keymaps-yazi.lua

local yazi_keymap = {}

function yazi_keymap.setup()
    local map = vim.keymap.set
    local default_opts = {noremap = true, silent = true, desc = ""}

    -- 打开当前文件所在目录
    map(
        "n", "<leader>fo", "<cmd>Yazi<CR>",
        vim.tbl_extend("force",default_opts,{
        desc = "Open Yazi at current file",
        })
    )

    -- 在cwd打开
    map(
        "n", "<leader>fc", "<cmd>Yazi cwd<CR>",
        vim.tbl_extend("force", default_opts,{
            desc = "Open Yazi at working directory",
        })
    )

    -- 在项目根目录打开yazi (getcwd(-1, 0)更稳定)
    map(
        "n", "<leader>fR", 
        function()
            require("yazi").open(vim.fn.getcwd(-1, 0))
        end,vim.tbl_extend("force", default_opts,{
        desc = "Open Yazi at projects root",
        })
    )

    -- 恢复Yazi会话
    map(
        "n", "<leader>fr", "<cmd>Yazi toggle<CR>",
        vim.tbl_extend(
            "force", default_opts,{
                desc = "Resume last Yazi session",
            }
        )
    )
end

return yazi_keymap
