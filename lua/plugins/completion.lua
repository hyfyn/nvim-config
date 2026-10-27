return {
	"saghen/blink.cmp",
	-- Release tags ship a prebuilt Rust fuzzy matcher
	version = "1.*",
	event = "InsertEnter",
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		-- <C-y> accept, <C-n>/<C-p> navigate, <C-space> open menu/docs, <Tab>/<S-Tab> jump snippet placeholders
		keymap = { preset = "default" },
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
