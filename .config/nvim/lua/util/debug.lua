-- ~/.config/nvim/lua/util/debug.lua

local M = {}

function M.dump(...)
	local args = { ... }
	for i, v in ipairs(args) do
		vim.print(i, v)
	end
end

return M
