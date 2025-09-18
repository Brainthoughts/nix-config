return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								diagnosticMode = "workspace", -- analyze all files in workspace
							},
						},
					},
				},
			},
		},
	},
}
