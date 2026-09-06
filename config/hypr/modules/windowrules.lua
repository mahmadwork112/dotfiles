--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.layer_rule({
	name = "rofi-popup",
	match = { namespace = "rofi" },
	animation = "slide bottom",
	dim_around = true,
})

hl.layer_rule({
	name = "notification-animations",
	match = { namespace = "swaync-control-center" },
	animation = "slide top",
})

hl.layer_rule({
	name = "workspace-overview",
	match = { namespace = "quickshell:overview" },
	animation = "slide top",
	dim_around = true,
})

hl.layer_rule({
	name = "brightness-and-sound-osd",
	match = { namespace = "quickshell-osd" },
	blur = true,
})

hl.window_rule({
	name = "bluepala",
	match = { title = "^Bluetooth Manager$" },
	float = true,
	size = "800 500",
})

hl.window_rule({
	name = "netpala",
	match = { title = "^Network Manager$" },
	float = true,
	size = "800 500",
})

hl.window_rule({
	name = "alacritty-normal-float",
	match = {
		class = "^Alacritty$",
		title = "negative:^(Bluetooth Manager|Network Manager)$",
	},
	float = true,
	size = "800 500",
})

hl.window_rule({
	name = "alacritty-nvim-maximized",
	match = {
		class = "^Alacritty$",
		title = "^nvim-ide$",
	},
	float = true,
	size = "1910 1040",
})
