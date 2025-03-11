return {
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		config = function()
			require("tokyonight").setup({
				style = "night", -- Options: storm, night, moon, day
				transparent = true, -- This prevents the theme from setting a background color
			})

			vim.cmd("colorscheme tokyonight")

			-- Force black background
			vim.api.nvim_set_hl(0, "Normal", { bg = "#000000", ctermbg = 0 })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000", ctermbg = 0 })
		end,
	},
}
