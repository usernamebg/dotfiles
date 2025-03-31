return {
	"folke/tokyonight.nvim",
	name = "tokyonight",
	config = function()
		require("tokyonight").setup({
			style = "night",
			transparent = true,
		})

		vim.cmd("colorscheme tokyonight")

		vim.api.nvim_set_hl(0, "Normal", { bg = "#000000", ctermbg = 0 })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000", ctermbg = 0 })
	end,
}
