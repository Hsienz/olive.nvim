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

local function list_cwd()
	local entries = {}
	local fs = vim.uv.fs_scandir(vim.fn.getcwd())
	if fs then
		while true do
			local name, ftype = vim.uv.fs_scandir_next(fs)
			if not name then
				break
			end
			table.insert(entries, { name = name, type = ftype })
		end
	end

	table.sort(entries, function(a, b)
		if a.type ~= b.type then
			return a.type == "directory"
		end
		return a.name:lower() < b.name:lower()
	end)

	return entries
end

local function render(target_buf)
	local lines = {}
	for _, entry in ipairs(list_cwd()) do
		table.insert(lines, entry.name .. (entry.type == "directory" and "/" or ""))
	end

	vim.api.nvim_buf_set_lines(target_buf, 0, -1, false, lines)
	vim.bo[target_buf].modified = false
end

M.open_explorer = function()
	local existing = vim.fn.bufnr(BUF_NAME)
	if existing ~= -1 then
		buf = existing
	else
		buf = vim.api.nvim_create_buf(true, true)
		vim.api.nvim_buf_set_name(buf, BUF_NAME)
		vim.bo[buf].buftype = "acwrite"

		vim.api.nvim_create_autocmd("BufWriteCmd", {
			buffer = buf,
			callback = function()
				-- TODO: diff buffer lines against list_cwd() and apply
				-- the resulting create/rename/delete operations to disk.
				vim.bo[buf].modified = false
			end,
		})
		vim.keymap.set("n", "q", M.close_explorer, { buffer = buf, silent = true, nowait = true })
	end

	render(buf)

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
