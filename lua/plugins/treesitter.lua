return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- The `main` branch only installs parsers; it no longer turns highlighting on
			require("nvim-treesitter").install({
				"bash",
				"css",
				"go",
				"gomod",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"scss",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			})
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					-- No-op for filetypes without an installed parser
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
}
