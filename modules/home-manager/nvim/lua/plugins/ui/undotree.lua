return {
	"mbbill/undotree",
	keys = {
		{
			"<leader>U",
			function()
				vim.cmd.UndotreeToggle()
				vim.cmd.UndotreeFocus()
			end,
			desc = "Undo tree",
		},
	},
}
