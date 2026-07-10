require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})

require("relative-motions"):setup({
	show_numbers = "relative",
	show_motion = true,
	enter_mode = "first",
})

require("full-border"):setup()

require("git"):setup({
	-- Order of Git status signs in the linemode
	order = 1500,
})

-- Show the hovered file's user and group in the right side of the status bar.
Status:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	local hovered = cx.active.current.hovered

	if hovered == nil then
		return ui.Line({})
	end

	local user = ya.user_name(hovered.cha.uid)
		or tostring(hovered.cha.uid)

	local group = ya.group_name(hovered.cha.gid)
		or tostring(hovered.cha.gid)

	return ui.Line({
		ui.Span(user):fg("magenta"),
		ui.Span(":"),
		ui.Span(group):fg("magenta"),
		ui.Span(" "),
	})
end, 500, Status.RIGHT)

-- Show username and hostname on the left side of the header.
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	local username = ya.user_name() or "unknown"
	local hostname = ya.host_name() or "unknown"

	return ui.Line({
		ui.Span(username .. "@" .. hostname .. " "):fg("blue"),
	})
end, 500, Header.LEFT)

-- Show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
