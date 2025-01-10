return {
	"olexsmir/gopher.nvim",
	ft = "go", -- Only load for Go files
	config = function(_, opts)
		require("gopher").setup(opts)
	end,
	build = function()
		vim.cmd([[silent! GoInstallDeps]])
	end,

	dependencies = {
		"fatih/vim-go",
		"nvim-treesitter/nvim-treesitter",
	},
}
