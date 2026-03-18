local health = {}

function health.check()
	vim.health.start("Chezmoi")
	if vim.fn.executable("chezmoi") == 1 then
		vim.health.ok("Chezmoi is installed:\n\n" .. vim.fn.system("chezmoi --version"))
	else
		vim.health.error("Chezmoi is not installed!!")
	end

	local has_snacks, _ = pcall(require, "snacks")
	if has_snacks then
		vim.health.ok("snacks.nvim is installed")
	else
		vim.health.error("snacks.nvim is not installed (required for picker)")
	end
end

return health
