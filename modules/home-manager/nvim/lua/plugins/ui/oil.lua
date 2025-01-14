return {
	"stevearc/oil.nvim",
	opts = {
		keymaps = {
			["<C-s>"] = false,
			["q"] = { "actions.close", mode = "n" },
		},
	},
	keys = {
		{
			"<leader>o",
			function()
				require("oil").open_float()
			end,
			desc = "Open oil.nvim",
		},
	},
}
