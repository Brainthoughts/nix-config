return {
	"mfussenegger/nvim-jdtls",
	opts = {
		cmd = {
			vim.fn.exepath("jdtls"),
			"--jvm-arg=-javaagent:" .. vim.fn.expand("~/.config/nvim/extra/lombok/share/java/lombok.jar"),
		},
	},
}
