vim.g.mapleader = " "
vim.opt.clipboard ="unnamedplus"

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
-- Sets the character encoding to UTF-8 for scripts and files

vim.opt.number = true
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
vim.opt.scrolloff = 10
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false

vim.opt.autoindent = true
vim.opt.smartindent = true


vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true

vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*", "**/__pycache__/*" })

-- Window Management
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

-- folds
vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 99

-- undotree and backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
