-- Warns about a plugin pinned to a legacy branch/version.
-- Shows a loud warning if current nvim version no longer matches the pin target,
-- otherwise a quiet reminder in :messages.
return function(plugin_name, pinned_for, target_major, target_minor)
	local version = vim.version()
	local mismatch = (version.major ~= target_major) or (version.minor ~= target_minor)

	if mismatch then
		vim.api.nvim_echo({
			{ "[PIN MISMATCH] ", "ErrorMsg" },
			{
				plugin_name
					.. " pinned for nvim "
					.. target_major
					.. "."
					.. target_minor
					.. ", but running "
					.. version.major
					.. "."
					.. version.minor
					.. ". Update the pin.",
				"WarningMsg",
			},
		}, true, {})
	else
		vim.api.nvim_echo({
			{ "[PIN] ", "Comment" },
			{ plugin_name .. " pinned: " .. pinned_for, "Comment" },
		}, true, {})
	end
end
