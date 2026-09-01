vim.filetype.add({
	extension = {
		jinja = "htmldjango",
		jinja2 = "htmldjango",
		j2 = "htmldjango",
	},
})

return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				html = {
					filetypes = { "jinja", "htmldjango", "html" },
				},
				jinja_lsp = {
					filetypes = { "jinja", "htmldjango", "rust", "python" },
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				htmldjango = { "djlint" },
				jinja = { "djlint" },
				html = { "djlint" },
			},
			formatters = {
				djlint = {
					prepend_args = {
						"--indent",
						"2",
						"--profile",
						"jinja",
					},
				},
			},
		},
	},
}
