-- ============================================================================
-- FAST MINIMAL STATUSLINE (UNOKAI / MONOKAI STYLE DYNAMIC)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- HIGHLIGHTS HELPERS
-- ----------------------------------------------------------------------------

local function get_hl(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  return {
    fg = hl.fg,
    bg = hl.bg,
  }
end

local function hl_color(hl)
  if not hl or not hl.fg then return "#000000" end
  return string.format("#%06x", hl.fg)
end

-- base theme colors (from your colorscheme: unokai / monokai)
local Normal = get_hl("Normal")
local Status = get_hl("StatusLine")
local Comment = get_hl("Comment")


-- ----------------------------------------------------------------------------
-- MODE HELPERS
-- ----------------------------------------------------------------------------


local function mode_icon()
  local mode = vim.fn.mode()
  current_mode_color = "#a6e22e"

  return ({
    n = "  NORMAL",
    i = "  INSERT",
    v = "  VISUAL",
    V = "  V-LINE",
    ["\22"] = "  V-BLOCK",
    c = "  COMMAND",
    R = "  REPLACE",
    t = "  TERMINAL",
  })[mode] or "  UNKNOWN"
end

-- ----------------------------------------------------------------------------
-- GIT BRANCH (dynamic styling)
-- ----------------------------------------------------------------------------

local git_cache = { branch = "", cwd = "", timestamp = 0 }
local uv = vim.uv or vim.loop

local function git_branch()
  local now = uv.now()
  local cwd = vim.fn.expand("%:p:h")

  if now - git_cache.timestamp < 5000 and cwd == git_cache.cwd then
    return git_cache.branch
  end

  git_cache.timestamp = now
  git_cache.cwd = cwd

  local git_dir = vim.fn.finddir(".git", cwd .. ";")

  if git_dir == "" then
    git_cache.branch = ""
    return ""
  end

  local head_file = io.open(git_dir .. "/HEAD", "r")
  if not head_file then return "" end

  local head = head_file:read("*l")
  head_file:close()

  local branch = head and head:match("ref: refs/heads/(.+)")
  if not branch then return "" end


  git_cache.branch = "  " .. branch .. " "
  return git_cache.branch
end

-- ----------------------------------------------------------------------------
-- FILETYPE ICONS
-- ----------------------------------------------------------------------------

local filetype_icons = {
  lua = " ",
  python = " ",
  javascript = " ",
  typescript = " ",
  html = " ",
  css = " ",
  json = " ",
  markdown = " ",
  rust = " ",
  go = " ",
  c = " ",
  cpp = " ",
  java = " ",
  yaml = "󰈙 ",
  dockerfile = " ",
}

local function file_type()
  local ft = vim.bo.filetype
  if ft == "" then return "  " end
  return " " .. (filetype_icons[ft] or " ") .. ft .. " "
end

-- ----------------------------------------------------------------------------
-- FILE SIZE
-- ----------------------------------------------------------------------------

local function file_size()
  local file = vim.fn.expand("%")
  if file == "" then return "" end

  local size = vim.fn.getfsize(file)
  if size < 0 then return "" end

  if size < 1024 then
    return string.format("  %dB ", size)
  elseif size < 1024 * 1024 then
    return string.format("  %.1fK ", size / 1024)
  end

  return string.format("  %.1fM ", size / 1024 / 1024)
end

-- ----------------------------------------------------------------------------
-- GLOBALS
-- ----------------------------------------------------------------------------

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

-- ----------------------------------------------------------------------------
-- DYNAMIC HIGHLIGHTS
-- ----------------------------------------------------------------------------

local function update_highlights()
  local bg = hl_color(Normal)
  local status_bg = hl_color(Status)

  vim.api.nvim_set_hl(0, "SLMode", {
    fg = "#1e1e1e",
    bg = "#a6e22e",
    bold = true,
  })

  vim.api.nvim_set_hl(0, "SLFile", {
    fg = Normal.fg and string.format("#%06x", Normal.fg) or "#ffffff",
    bg = status_bg,
  })

  vim.api.nvim_set_hl(0, "SLGit", {
    fg = "#a6e22e", -- 🔥 dynamic git color = mode color
    bg = status_bg,
  })

  vim.api.nvim_set_hl(0, "SLDim", {
    fg = Comment.fg and string.format("#%06x", Comment.fg) or "#888888",
    bg = status_bg,
  })

  -- powerline separators that blend
  vim.api.nvim_set_hl(0, "SLSep1", {
    fg = current_mode_color,
    bg = status_bg,
  })

  vim.api.nvim_set_hl(0, "SLSep2", {
    fg = status_bg,
    bg = status_bg,
  })
end

-- update on mode change
vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter", "WinEnter", "ColorScheme" }, {
  callback = function()
    update_highlights()
  end,
})

-- ----------------------------------------------------------------------------
-- STATUSLINE (ACTIVE)
-- ----------------------------------------------------------------------------

local active_statusline = table.concat({
  " ",

  "%#SLMode#",
  "%{v:lua.mode_icon()} ",

  "%#SLSep1#",

  "%#SLFile#",
  " %f %h%m%r ",

  "%#SLSep1#",

  "%#SLGit#",
  "%{v:lua.git_branch()}",

  -- 🔥 FILETYPE + FILE SIZE (terug toegevoegd)
  "%#SLFile#",
  "  %{v:lua.file_type()}",
  " %{v:lua.file_size()} ",

  "%#SLDim#",
  "%=",

  "%#SLDim#",
  "  %l:%c %P ",
})

-- ----------------------------------------------------------------------------
-- STATUSLINE (INACTIVE)
-- ----------------------------------------------------------------------------

local inactive_statusline = table.concat({
  " ",
  "%f %h%m%r",
  " %=",
  " %l:%c %P ",
})

-- ----------------------------------------------------------------------------
-- AUTOCMDS
-- ----------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.opt_local.statusline = active_statusline
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.opt_local.statusline = inactive_statusline
  end,
})

-- initial
vim.o.statusline = active_statusline
update_highlights()
