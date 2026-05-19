-- Clean undo history
vim.api.nvim_create_user_command("UndoClean", function(opts)
  local undodir = vim.opt.undodir:get()[1]

  if vim.fn.isdirectory(undodir) == 0 then
    print("Undo directory bestaat niet: " .. undodir)
    return
  end

  -- aantal dagen (default 30, override mogelijk)
  local days = tonumber(opts.args) or 30
  local cutoff = os.time() - (days * 24 * 60 * 60)

  local deleted = 0

  local files = vim.fn.glob(undodir .. "/*", false, true)
  for _, file in ipairs(files) do
    local stat = vim.loop.fs_stat(file)
    if stat and stat.mtime.sec < cutoff then
      os.remove(file)
      deleted = deleted + 1
    end
  end

  print("UndoClean: " .. deleted .. " bestanden verwijderd (ouder dan " .. days .. " dagen)")
end, {
  nargs = "?"
})

local function auto_clean()

  local stamp = vim.fn.stdpath("data") .. "/undo_clean_last"

  local now = os.time()
  local last = 0  -- ✅ default

  -- ✅ eerst checken of file bestaat
  if vim.loop.fs_stat(stamp) then
    local ok, data = pcall(vim.fn.readfile, stamp)
    if ok and data[1] then
      last = tonumber(data[1]) or 0
    end
  end

  -- alleen runnen als >24 uur geleden
  if now - last < 86400 then
    return
  end

  vim.cmd("UndoClean 30")
  vim.fn.writefile({ tostring(now) }, stamp)
end

auto_clean()
