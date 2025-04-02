local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.maplocalleader = " " 

-- Don't hate me for this
map("i", "<C-c>", "<Esc>", opts)

-- delete with x and don't copy
map("n", "x", '"_x', opts)

-- Move selected blocks
map("v", "J", ":m '>+1<cr>gv=gv", opts)
map("v", "K", ":m '<-2<cr>gv=gv", opts)

-- paste over text and don't input in registery
map("x", "<leader>p", [["_dP]], opts)

-- delete text and don't copy
map({ "n", "v" }, "<leader>d", [["_d]], opts)

-- copy to clipboard and registery
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })
map("n", "<leader>rn", ":%s/\\<<C-r><C-w>\\>/", {})

-- Navigate splits with Ctrl+h/j/k/l
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

map('n', '<leader><space>x', '<cmd>sourcr %<CR>')
map('n', '<leader>x', ':.lua<CR>')
map('v', '<leader>x', ':lua<CR>')
