return {
	"saghen/blink.cmp",
	-- Release tags ship a prebuilt Rust fuzzy matcher
	version = "1.*",
	event = "InsertEnter",
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		-- <Tab> accept (or jump to next snippet placeholder), <S-Tab> previous placeholder,
		-- <C-j>/<C-k> navigate, <C-e> close, <C-space> open menu/docs
		keymap = {
			preset = "super-tab",
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
		},
		completion = {
			documentation = { auto_show = true },
		},
		signature = { enabled = true },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}
