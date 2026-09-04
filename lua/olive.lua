local explorer = require("olive.explorer")

local M = {}

M.say_hello = function()
	print("Hello World!")
end
M.setup = function(opts)
	opts = opts or {}

	local keymap = opts.keymap or "<leader>hw"

	vim.keymap.set("n", keymap, M.say_hello, {
		desc = "Say hello from olive.nvim",
		silent = true,
	})

	vim.keymap.set("n", "<leader>he", M.toggle_explorer, {
		desc = "Toggle olive explorer",
		silent = true,
	})
end

M.toggle_explorer = explorer.toggle_explorer
M.open_explorer = explorer.open_explorer
M.close_explorer = explorer.close_explorer

return M
