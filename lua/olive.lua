local M = {}

function M.say_hello()
	print("Hello World!")
end
function M.setup(opts)
	opts = opts or {}

	local keymap = opts.keymap or "<leader>hw"

	vim.keymap.set("n", keymap, M.say_hello, {
		desc = "Say hello from olive.nvim",
		silent = true,
	})
end

return M
