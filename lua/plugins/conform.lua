return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "never" })
			end,
			mode = { "n", "v" },
			desc = "Format file or selection",
		},
	},
	opts = function()
		local util = require("conform.util")
		-- JS/TS: run whichever formatter the project is configured for, in order
		-- of preference. Each one only runs if its config file exists in the
		-- project, and conform's built-in definitions already prefer the binary
		-- in the project's node_modules/.bin over anything global.
		-- Prettier resolves config plugins from cwd, and conform defaults cwd to
		-- the config file's dir. When .prettierrc sits above node_modules (repo
		-- root config + ui/node_modules), plugins fail to load, so run prettier
		-- from the nearest dir containing node_modules instead.
		local node_modules_root = util.root_file({ "node_modules" })

		local js = { "biome", "prettierd", "prettier", "jq", stop_after_first = true }

		return {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = js,
				javascriptreact = js,
				typescript = js,
				typescriptreact = js,
				json = js,
				jsonc = js,
				css = js,
				scss = js,
				html = js,
				markdown = js,
				yaml = js,
			},

			formatters = {
				biome = {
					condition = function(_, ctx)
						return util.root_file({ "biome.json", "biome.jsonc" })(_, ctx) ~= nil
					end,
				},
				prettierd = {
					condition = function(_, ctx)
						return util.root_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yaml",
							".prettierrc.yml",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.mjs",
							".prettierrc.toml",
							"prettier.config.js",
							"prettier.config.cjs",
							"prettier.config.mjs",
						})(_, ctx) ~= nil
					end,
					cwd = node_modules_root,
				},
				prettier = {
					condition = function(_, ctx)
						return util.root_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yaml",
							".prettierrc.yml",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.mjs",
							".prettierrc.toml",
							"prettier.config.js",
							"prettier.config.cjs",
							"prettier.config.mjs",
						})(_, ctx) ~= nil
					end,
					cwd = node_modules_root,
				},
			},

			-- Only format when a project formatter matched. `lsp_format = "never"`
			-- stops ts_ls from applying its own style in projects with no formatter.
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "never",
			},
		}
	end,
}
