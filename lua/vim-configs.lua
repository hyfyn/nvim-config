vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")

-- Yank/paste use the system clipboard
vim.opt.clipboard = "unnamedplus"
-- Keep undo history across restarts
vim.opt.undofile = true

-- Inline parameter/type hints from LSP servers that support them
vim.lsp.inlay_hint.enable()

-- Show diagnostic messages inline (off by default since Neovim 0.11)
vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
})

-- Reload buffers changed outside Neovim (e.g. by Claude)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
	command = "silent! checktime",
})
