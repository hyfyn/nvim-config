return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-mini/mini.icons" },
		event = "VeryLazy",
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				-- Keep tabs from sitting on top of the snacks explorer sidebar
				offsets = {
					{
						filetype = "snacks_layout_box",
						text = "File Explorer",
						highlight = "Directory",
						separator = true,
					},
				},
			},
		},
		keys = {
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
			{ "<leader>bl", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
			{ "<leader>bh", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
			{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
			{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
			{ "<leader>bd", "<cmd>bdelete<cr>", desc = "Close buffer" },
		},
	},
}
