-- =============================================================================
-- 文件位置: lua/plugins/colorscheme.lua
-- 说明: 主题管理与每日自动跨天随机主题切换器，并提供手动交互式挑选菜单
-- =============================================================================

local M = {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = { styles = { sidebars = "transparent", floats = "transparent" } },
    },
    {
        "Ferouk/bearded-nvim",
        name = "bearded",
        priority = 1000,
        config = function()
            require("bearded").setup({ flavor = "arc" })
        end,
    },
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({ style = "deep" })
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({ flavour = "macchiato" })
        end,
    },
    { "ellisonleao/gruvbox.nvim", lazy = false, opts = {} },
    { "craftzdog/solarized-osaka.nvim", lazy = false, opts = { transparent = true } },
}

-- 可供随机与手动切换的主题清单
local available_themes = {
    "tokyonight",
    "bearded",
    "onedark",
    "catppuccin",
    "gruvbox",
    "solarized-osaka",
}

-- 本地状态持久化文件保存路径 (~/.local/state/nvim/theme_switch_info.json)
local state_file = vim.fn.stdpath("state") .. "/theme_switch_info.json"

-- 读取保存的状态 JSON 数据
local function read_state()
    local f = io.open(state_file, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return vim.json.decode(content)
end

-- 将当前使用的日期和主题持久化存储到 JSON
local function save_state(date_str, theme_name)
    local f = io.open(state_file, "w")
    if f then
        f:write(vim.json.encode({ last_date = date_str, theme = theme_name }))
        f:close()
    end
end

-- 从可用主题池中挑选一个与当前不同的新主题
local function pick_random_theme(current_theme)
    math.randomseed(os.time())
    local candidates = {}
    for _, t in ipairs(available_themes) do
        if t ~= current_theme then table.insert(candidates, t) end
    end
    return candidates[math.random(#candidates)]
end

-- -----------------------------------------------------------------------------
-- 核心逻辑 1：检测是否跨天并自动应用主题
-- -----------------------------------------------------------------------------
local function check_and_apply_theme()
    local today = os.date("%Y-%m-%d")
    local state = read_state()
    local active_theme = ""

    -- 若无记录或检测到是新的一天，则随机抽取新主题
    if not state or state.last_date ~= today then
        local old_theme = state and state.theme or ""
        active_theme = pick_random_theme(old_theme)
        save_state(today, active_theme)
    else
        -- 否则在同一天内固定使用保存好的主题
        active_theme = state.theme
    end

    pcall(vim.cmd.colorscheme, active_theme)
end

-- -----------------------------------------------------------------------------
-- 核心逻辑 2：手动弹窗选择喜欢的配色，并固定为当天的主题
-- -----------------------------------------------------------------------------
function M.select_theme_menu()
    local current_state = read_state()
    local current_theme = current_state and current_state.theme or ""

    vim.ui.select(available_themes, {
        prompt = "🎨 选择你喜欢的主题配色 (当前: " .. current_theme .. "):",
        format_item = function(item)
            if item == current_theme then
                return " " .. item .. " (当前激活)"
            end
            return "  " .. item
        end,
    }, function(selected)
        if selected then
            -- 1. 立即切换应用新主题
            local ok, err = pcall(vim.cmd.colorscheme, selected)
            if ok then
                -- 2. 将手动选好的主题存入状态文件，覆盖今天的主题记录
                local today = os.date("%Y-%m-%d")
                save_state(today, selected)
                vim.notify("󰄬 主题已成功切换并锁定为: " .. selected, vim.log.levels.INFO, { title = "主题管理器" })
            else
                vim.notify("❌ 切换主题失败: " .. tostring(err), vim.log.levels.ERROR, { title = "主题管理器" })
            end
        end
    end)
end

-- -----------------------------------------------------------------------------
-- 启动入口与定时器绑定
-- -----------------------------------------------------------------------------
function M.setup_auto_switch()
    -- 1. Neovim 启动时立即检测并应用
    check_and_apply_theme()

    -- 2. 绑定手动挑选主题的快捷键：<leader>th (Theme Select)
    vim.keymap.set("n", "<leader>th", function()
        M.select_theme_menu()
    end, { desc = "🎨 弹窗挑选并锁定当前配色" })

    -- 3. 开启后台异步 Loop 定时器，每隔 30 分钟轮询一次（防跨凌晨 0 点）
    local timer = (vim.uv or vim.loop).new_timer()
    local check_interval = 30 * 60 * 1000
    timer:start(check_interval, check_interval, vim.schedule_wrap(check_and_apply_theme))
end

return M
