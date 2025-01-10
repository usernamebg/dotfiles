local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- delete with x and don't copy
map("n", "x", '"_x')

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Select all
map("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
map("n", "<Leader>w", ":update<Return>", opts)
map("n", "<Leader>q", ":quit<Return>", opts)
map("n", "<Leader>Q", ":qa<Return>", opts)

-- Diagnostics
map("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

-- Move selected blocks
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")

-- paste over text and don't input in registery
map("x", "<leader>p", [["_dP]])

-- delete text and don't copy
map({ "n", "v" }, "<leader>d", [["_d]])

-- copy to clipboard and registery
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map("n", "<leader>e", ":Ex<CR>", opts)

map("n", "<leader>rn", ":%s/\\<<C-r><C-w>\\>/", {})
