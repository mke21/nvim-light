-- ============================================================================
-- STATUSLINE v3 (lualine-grade, stable, cached, zero flicker)
-- ============================================================================

local uv = vim.uv or vim.loop

-- ----------------------------------------------------------------------------
-- STATE + CACHE
-- ----------------------------------------------------------------------------

local S = {
  mode = "n",
  cache = {},
}

local function now()
  return uv.hrtime() / 1e6
end

local function cache_get(key)
  local c = S.cache[key]
  if c and c.t > now() then
    return c.v
  end
end

local function cache_set(key, val, ttl)
  S.cache[key] = {
    v = val,
    t = now() + (ttl or 2000),
  }
end

-- ----------------------------------------------------------------------------
-- MODE HELPERS
-- ----------------------------------------------------------------------------

local function mode()
  return vim.fn.mode()
end

local function mode_label(m)
  return ({
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    R = "REPLACE",
    t = "TERMINAL",
    s = "SELECT",
    S = "S-LINE",
  })[m] or "UNKNOWN"
end

local function mode_color(m)
  return ({
    n = "#a6e22e",
    i = "#66d9ef",
    v = "#fd971f",
    V = "#fd971f",
    ["\22"] = "#fd971f",
    c = "#ae81ff",
    R = "#f92672",
    t = "#66d9ef",
    s = "#fd971f",
    S = "#fd971f",
  })[m] or "#a6e22e"
end

-- ----------------------------------------------------------------------------
-- GIT (cached, no IO spam)
-- ----------------------------------------------------------------------------

local function git_branch()
  local cwd = vim.fn.getcwd()
  local key = "git:" .. cwd

  local cached = cache_get(key)
  if cached then return cached end

  local git_dir = vim.fn.finddir(".git", cwd .. ";")
  if git_dir == "" then
    cache_set(key, "", 5000)
    return ""
  end

  local head_file = io.open(git_dir .. "/HEAD", "r")
  if not head_file then return "" end

  local head = head_file:read("*l")
  head_file:close()

  local branch = head and head:match("ref: refs/heads/(.+)") or ""

  local out = branch ~= "" and ("  " .. branch .. " ") or ""
  cache_set(key, out, 3000)

  return out
end

-- ----------------------------------------------------------------------------
-- FILE INFO
-- ----------------------------------------------------------------------------

local file_icons = {
  lua = "", python = "", javascript = "",
  typescript = "", html = "", css = "",
  json = "", markdown = "", rust = "",
  go = "", c = "", cpp = "",
  java = "", yaml = "󰈙", dockerfile = "",
}

local function filetype()
  local ft = vim.bo.filetype
  return ft == "" and "" or (file_icons[ft] or "") .. " " .. ft
end

local function filesize()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then return "" end

  local key = "size:" .. file
  local cached = cache_get(key)
  if cached then return cached end

  local size = vim.fn.getfsize(file)
  if size < 0 then return "" end

  local out
  if size < 1024 then
    out = string.format("%dB", size)
  elseif size < 1024 * 1024 then
    out = string.format("%.1fK", size / 1024)
  else
    out = string.format("%.1fM", size / 1024 / 1024)
  end

  cache_set(key, out, 3000)
  return out
end

-- ----------------------------------------------------------------------------
-- GLOBAL EXPORTS
-- ----------------------------------------------------------------------------

_G.git_branch = git_branch
_G.filetype = filetype
_G.filesize = filesize

-- ----------------------------------------------------------------------------
-- HIGHLIGHTS (mode-driven, stable)
-- ----------------------------------------------------------------------------

local function update()
  S.mode = mode()

  local status_bg = "#1e1e1e"
  local mcol = mode_color(S.mode)

  vim.api.nvim_set_hl(0, "SLMode", {
    fg = status_bg,
    bg = mcol,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "SLSep1", {
    fg = mcol,
    bg = status_bg,
  })

  vim.api.nvim_set_hl(0, "SLFile", {
    fg = "#ffffff",
    bg = status_bg,
  })

  vim.api.nvim_set_hl(0, "SLGit", {
    fg = "#a6e22e",
    bg = status_bg,
  })

  vim.api.nvim_set_hl(0, "SLDim", {
    fg = "#777777",
    bg = status_bg,
  })

  vim.cmd("redrawstatus")
end

-- ----------------------------------------------------------------------------
-- DEBOUNCED AUTOCMD (zero flicker)
-- ----------------------------------------------------------------------------

local timer = uv.new_timer()

local function schedule()
  if timer:is_active() then
    timer:stop()
  end

  timer:start(30, 0, vim.schedule_wrap(update))
end

vim.api.nvim_create_autocmd(
  { "ModeChanged", "BufEnter", "WinEnter", "ColorScheme" },
  { callback = schedule }
)

-- initial
update()

-- ----------------------------------------------------------------------------
-- STATUSLINE RENDER (lualine-style pure function)
-- ----------------------------------------------------------------------------

function _G.stl()
  return table.concat({
    " ",

    "%#SLMode#",
    " " .. mode_label(S.mode) .. " ",

    "%#SLSep1#%*",

    "%#SLFile#",
    " %f %h%m%r ",

    "%#SLSep1#%*",

    "%#SLGit#",
    git_branch(),

    " %#SLFile# ",
    filetype(),

    " ",
    filesize(),
    " ",

    "%#SLDim#",
    "%=",

    "%#SLDim#",
    "  %l:%c %P ",
  })
end

vim.o.statusline = "%!v:lua.stl()"
