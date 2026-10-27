return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Project-local binary, fall back to PATH
		local function local_bin(name, root)
			local bin = root .. "/node_modules/.bin/" .. name
			return vim.fn.executable(bin) == 1 and bin or name
		end

		vim.lsp.config("oxlint", {
			root_markers = { ".oxlintrc.json" },
			workspace_required = true,
			cmd = function(dispatchers, config)
				return vim.lsp.rpc.start(
					{ local_bin("oxlint", config.root_dir), "--lsp" },
					dispatchers,
					{ cwd = config.root_dir }
				)
			end,
		})
		vim.lsp.config("stylelint_lsp", {
			root_markers = { ".stylelintrc.json" },
			workspace_required = true,
			filetypes = { "css", "scss" },
			settings = {
				stylelintplus = {
					validateOnType = true,
					autoFixOnSave = true,
				},
			},
		})
		vim.lsp.enable({ "oxlint", "stylelint_lsp" })

		-- Apply oxlint auto-fixes on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
			callback = function()
				vim.lsp.buf.code_action({
					context = { only = { "source.fixAll" }, diagnostics = {} },
					apply = true,
				})
			end,
		})
	end,
}
