return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								-- diagnosticMode = "workspace", -- analyze all files in workspace
							},
						},
					},
				},
			},
		},
	},
	{
		"mfussenegger/nvim-dap-python",
		keys = {
			{
				"<leader>dPt",
				function()
					require("dap-python").test_method()
				end,
				desc = "Debug Method",
				ft = "python",
			},
			{
				"<leader>dPc",
				function()
					require("dap-python").test_class()
				end,
				desc = "Debug Class",
				ft = "python",
			},
		},
		config = function()
			require("dap-python").setup("debugpy-adapter")
		end,
	},
}
