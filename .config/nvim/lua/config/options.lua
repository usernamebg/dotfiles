local o = vim.opt

vim.g.mapleader = " "
vim.scriptencoding = "utf-8"

o.clipboard = "unnamedplus"
o.encoding = "utf-8"
o.fileencoding = "utf-8"
-- Sets the character encoding to UTF-8 for scripts and files
o.number = true
o.title = true
o.showcmd = true
o.cmdheight = 0
o.laststatus = 0
o.scrolloff = 10
o.smarttab = true
o.breakindent = true
o.shiftwidth = 2
o.tabstop = 2
o.wrap = false
o.autoindent = true
o.smartindent = true
o.hlsearch = false 
o.cursorline = true
o.expandtab = true
o.inccommand = "split"
o.ignorecase = true
o.backspace = { "start", "eol", "indent" }
o.path:append({ "**" })
o.wildignore:append({ "*/node_modules/*", "**/__pycache__/*" })
-- Window Management
o.splitbelow = true
o.splitright = true
o.splitkeep = "cursor"
o.mouse = ""
-- Add asterisks in block comments
o.formatoptions:append({ "r" })
-- folds
o.foldenable = true
o.foldmethod = "manual"
o.foldlevel = 99
-- undotree and backups
o.swapfile = false
o.backup = false
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true
o.hlsearch = false
o.incsearch = true
o.termguicolors = true
-- o.scrolloff = 10  -- Removed duplicate
o.signcolumn = "yes"
o.isfname:append("@-@")
