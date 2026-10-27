return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = { "lua_ls", "gopls", "stylua" },
		-- ts_ls can't drive TypeScript 7 (no tsserver.js); the native `tsc` server replaces it
		automatic_enable = { exclude = { "ts_ls" } },
	},
	config = function(_, opts)
		-- gopls only sends inlay hints for the kinds explicitly turned on
		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})
		require("mason-lspconfig").setup(opts)
		-- Resolved from the project's node_modules/.bin, so not managed by Mason
		vim.lsp.enable("tsc")
	end,
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		{ "neovim/nvim-lspconfig", lazy = false },
	},
}
