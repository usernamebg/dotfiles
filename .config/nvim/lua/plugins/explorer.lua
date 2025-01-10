return {
	-- Vim Vinegar plugin, which enhances Netrw
	{
		"tpope/vim-vinegar",
		event = "VeryLazy", -- Loads lazily to improve performance
	},

	-- Vim Sensible, which includes better defaults
	{
		"tpope/vim-sensible",
		event = "VeryLazy", -- Loads when necessary
	},
}
