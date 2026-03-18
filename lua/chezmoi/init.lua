local M = {}

local chezmoi_source_dir = io.popen("chezmoi source-path"):read("*a"):gsub("%s+", "")

local function get_dotfiles()
	local results = {}
	local handle =
		io.popen("find " .. chezmoi_source_dir .. ' -type f ! -path "*/.git/*" ! -name ".*" -o -name ".chezmoi*"')
	if handle then
		for line in handle:lines() do
			local relative_path = line:sub(#chezmoi_source_dir + 2):gsub("dot_", "."):gsub("%.tmpl$", "")
			table.insert(results, { full_path = line, display = relative_path })
		end
		handle:close()
	end
	return results
end

local function set_buffer_filetype(path)
	local filetype = vim.filetype.match({ filename = path })
	if filetype then
		vim.bo.filetype = filetype
	else
		vim.notify("Could not detect filetype for: " .. path)
	end
end

function M.dotfiles(opts)
	opts = opts or {}
	opts.live_dots = opts.live_dots or false

	local results = get_dotfiles()
	local items = {}

	for idx, entry in ipairs(results) do
		local file = entry.full_path
		if opts.live_dots then
			file = vim.fn.expand("$HOME") .. "/" .. entry.display
		end

		table.insert(items, {
			idx = idx,
			text = entry.display,
			file = file,
			source_path = entry.full_path,
			display_path = entry.display,
		})
	end

	local title = "Chezmoi Managed Dot Files"
	if opts.live_dots then
		title = "Live Chezmoi Managed Dot Files"
	end

	Snacks.picker({
		title = title,
		items = items,
		format = "file",
		preview = "file",
		confirm = function(picker, item)
			picker:close()
			if opts.live_dots then
				vim.cmd("edit " .. vim.fn.fnameescape(item.file))
			else
				vim.cmd("edit " .. vim.fn.fnameescape(item.source_path))
				set_buffer_filetype(item.display_path)
			end
		end,
	})
end

function M.setup()
	vim.api.nvim_create_user_command("ChezmoiAdd", function()
		local current_file = vim.fn.expand("%:p")
		vim.fn.system("chezmoi add " .. vim.fn.shellescape(current_file))
		vim.notify("Added to Chezmoi: " .. current_file)
	end, {})

	vim.api.nvim_create_user_command("ChezmoiReAdd", function()
		local current_file = vim.fn.expand("%:p")
		vim.fn.system("chezmoi re-add " .. vim.fn.shellescape(current_file))
		vim.notify("Re-Added to Chezmoi: " .. current_file)
	end, {})

	vim.api.nvim_create_user_command("ChezmoiForget", function()
		local current_file = vim.fn.expand("%:p")
		vim.fn.system("chezmoi forget --force " .. vim.fn.shellescape(current_file))
		vim.notify("Removing Chezmoi file: " .. current_file)
	end, {})

	vim.api.nvim_create_user_command("ChezmoiUpdate", function()
		vim.fn.system("chezmoi update")
		vim.notify("Pulling Chezmoi Latest Configuration!")
	end, {})

	vim.api.nvim_create_user_command("ChezmoiDotfiles", function(cmd_opts)
		local live = cmd_opts.args == "live"
		M.dotfiles({ live_dots = live })
	end, { nargs = "?" })
end

return M
