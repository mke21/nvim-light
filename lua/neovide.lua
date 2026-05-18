-- special settings for neovide
local function neovideScale(amount)
	local temp = vim.g.neovide_scale_factor + amount

	if temp < 0.5 then
		return
	end

	vim.g.neovide_scale_factor = temp
end


if vim.g.neovide then
	vim.go.guifont = "LigaSauceCodePro NF:h11"
--	vim.keymap.set('v', '<leader>c', '"+y') -- copy to clipboard in visual mode
--	vim.keymap.set('n', '<m-v>', '"+P') -- paste from clipboard in normal mode
--	vim.keymap.set('c', '<m-v>', '<C-r>+') -- paste from clipboard in command mode
--	vim.keymap.set('i', '<m-v>', '<ESC>l"+Pli') -- paste from clipboard in insert mode

  vim.keymap.set("n", "<C-=>", function()
	neovideScale(0.1)
  end)
  vim.keymap.set("n", "<C-->", function()
	neovideScale(-0.1)
  end)

end
