-- ============================================================================
-- FAST MINIMAL STATUSLINE
-- ============================================================================

-- ----------------------------------------------------------------------------
-- HIGHLIGHTS
-- ----------------------------------------------------------------------------

vim.api.nvim_set_hl(0, "StatusLineBold", {
  bold = true,
})

-- ----------------------------------------------------------------------------
-- FILETYPE ICONS
-- ----------------------------------------------------------------------------

local filetype_icons = {
  lua = " ",
  python = " ",
  javascript = " ",
  typescript = " ",
  javascriptreact = " ",
  typescriptreact = " ",
  html = " ",
  css = " ",
  scss = " ",
  json = " ",
  markdown = " ",
  vim = " ",
  sh = " ",
  bash = " ",
  zsh = " ",
  rust = " ",
  go = " ",
  c = " ",
  cpp = " ",
  java = " ",
  php = " ",
  ruby = " ",
  swift = " ",
  kotlin = "󱈙 ",
  dart = " ",
  elixir = " ",
  haskell = " ",
  sql = " ",
  yaml = "󰈙 ",
  toml = " ",
  xml = "󰗀 ",
  dockerfile = " ",
  gitcommit = " ",
  gitconfig = "󰊢 ",
  vue = "󰡄 ",
  svelte = " ",
  astro = " ",
}

-- ----------------------------------------------------------------------------
-- MODE
-- ----------------------------------------------------------------------------

local mode_map = {
  n = "  NORMAL",
  i = "  INSERT",
  v = "  VISUAL",
  V = "  V-LINE",
  ["\22"] = "  V-BLOCK",
  c = "  COMMAND",
  s = "  SELECT",
  S = "  S-LINE",
  ["\19"] = "  S-BLOCK",
  R = "  REPLACE",
  r = "  REPLACE",
  ["!"] = "  SHELL",
  t = "  TERMINAL",
}

local function mode_icon()
  return mode_map[vim.fn.mode()] or "  UNKNOWN"
end

-- ----------------------------------------------------------------------------
-- GIT BRANCH
-- ----------------------------------------------------------------------------

local git_cache = {
  branch = "",
  cwd = "",
  timestamp = 0,
}

local uv = vim.uv or vim.loop

local function git_branch()
  local now = uv.now()
  local cwd = vim.fn.expand("%:p:h")

  -- Refresh cache every 5 seconds OR when changing directory
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

  local head_path = git_dir .. "/HEAD"
  local head_file = io.open(head_path, "r")

  if not head_file then
    git_cache.branch = ""
    return ""
  end

  local head = head_file:read("*l")
  head_file:close()

  local branch = head and head:match("ref: refs/heads/(.+)")

  if branch then
    git_cache.branch = "  " .. branch .. " "
  else
    git_cache.branch = ""
  end

  return git_cache.branch
end

-- ----------------------------------------------------------------------------
-- FILETYPE
-- ----------------------------------------------------------------------------

local function file_type()
  local ft = vim.bo.filetype

  if ft == "" then
    return "  "
  end

  local icon = filetype_icons[ft] or " "

  return " " .. icon .. ft .. " "
end

-- ----------------------------------------------------------------------------
-- FILE SIZE
-- ----------------------------------------------------------------------------

local function file_size()
  local file = vim.fn.expand("%")

  if file == "" then
    return ""
  end

  local size = vim.fn.getfsize(file)

  if size < 0 then
    return ""
  end

  if size < 1024 then
    return string.format("  %dB ", size)
  end

  if size < 1024 * 1024 then
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
-- STATUSLINE
-- ----------------------------------------------------------------------------

local active_statusline = table.concat({
  "  ",
  "%#StatusLineBold#",
  "%{v:lua.mode_icon()}",
  "%#StatusLine#",
  "  ",
  "%f",
  " %h%m%r",
  "%{v:lua.git_branch()}",
  "",
  "%{v:lua.file_type()}",
  "",
  "%{v:lua.file_size()}",
  "%=",
  "  %l:%c ",
  "%P ",
})

local inactive_statusline = table.concat({
  "  ",
  "%f",
  " %h%m%r",
  "  ",
  "%{v:lua.file_type()}",
  "%=",
  " %l:%c ",
  "%P ",
})

-- ----------------------------------------------------------------------------
-- ACTIVE / INACTIVE WINDOW HANDLING
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

-- Set initial statusline
vim.o.statusline = active_statusline
