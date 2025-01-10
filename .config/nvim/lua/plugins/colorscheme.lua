return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup()

			vim.cmd("colorscheme rose-pine")
			vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
		end,
	},
}
