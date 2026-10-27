return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- Also replaces `vim.ui.select` (code action menus, etc.)
		picker = {
			ui_select = true,
			-- Show dotfiles and gitignored files in the explorer (toggle with H / I)
			sources = { explorer = { hidden = true, ignored = true } },
		},
		-- `nvim .` opens the explorer instead of netrw
		explorer = { replace_netrw = true },
		dashboard = {
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "recent_files", title = "Recent Files", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},
		indent = {},
		-- Highlight other references to the symbol under the cursor
		words = {},
		notifier = {},
	},
	keys = {
		{
			"<C-p>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find files",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live grep",
		},
		{
			"<C-n>",
			function()
				Snacks.explorer()
			end,
			desc = "File explorer",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>cs",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Document symbols",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git status (<Tab> stage, <C-r> revert)",
		},
		{
			"<C-/>",
			function()
				Snacks.terminal()
			end,
			mode = { "n", "t" },
			desc = "Toggle terminal",
		},
		-- Some terminals send <C-_> for <C-/>
		{
			"<C-_>",
			function()
				Snacks.terminal()
			end,
			mode = { "n", "t" },
			desc = "which_key_ignore",
		},
	},
}
