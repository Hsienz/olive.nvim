local M = {}
local buf = nil
local win = nil
local BUF_NAME = "olive://explorer"

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = vim.api.nvim_create_augroup("OliveExplorerCleanup", { clear = true }),
	callback = function()
		local existing = vim.fn.bufnr(BUF_NAME)
		if existing ~= -1 then
			vim.api.nvim_buf_delete(existing, { force = true })
		end
	end,
})

M.open_explorer = function()
	local existing = vim.fn.bufnr(BUF_NAME)
	if existing ~= -1 then
		buf = existing
	else
		buf = vim.api.nvim_create_buf(true, true)
		vim.api.nvim_buf_set_name(buf, BUF_NAME)
	end

	local width = 50

	vim.cmd("topleft" .. width .. "vsplit")

	win = vim.api.nvim_get_current_win()

	vim.api.nvim_win_set_buf(win, buf)
end

M.close_explorer = function()
	if win == nil or not vim.api.nvim_win_is_valid(win) then
		return
	end

	vim.api.nvim_win_close(win, true)
	win = nil
end

M.toggle_explorer = function()
	if win == nil or not vim.api.nvim_win_is_valid(win) then
		M.open_explorer()
	else
		M.close_explorer()
	end
end

return M
