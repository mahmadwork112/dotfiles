-----------------------
---- LOOK AND FEEL ----
-----------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 8,
		gaps_out = 10,

		border_size = 1,

		col = {
			active_border = "rgb(45403d)",
			inactive_border = "rgba(45403d99)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,
	},

	decoration = {
		rounding = 15,
		rounding_power = 1,

		-- Change transparency of focused and unfocused windows
		active_opacity = 0.9,
		inactive_opacity = 0.8,

		shadow = {
			enabled = true,
			range = 20,
			render_power = 3,
			color = 0xee121212,
		},

		blur = {
			enabled = true,
			size = 10,
			passes = true,
			vibrancy = 0.1696,
		},
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

-- custom bezier values
hl.curve("snappy", { type = "bezier", points = { { 0.1, 0.9 }, { 0.2, 1 } } })
hl.curve("crisp", { type = "bezier", points = { { 0.3, 0 }, { 0.15, 1 } } })
hl.curve("tightPop", { type = "bezier", points = { { 0.16, 1.02 }, { 0.3, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "crisp" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "crisp" })
hl.animation({ leaf = "windows", enabled = true, speed = 2.3, bezier = "crisp" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.3, bezier = "crisp" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.6, bezier = "crisp" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.6, bezier = "crisp" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.3, bezier = "crisp" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.6, bezier = "crisp" })
hl.animation({ leaf = "layers", enabled = true, speed = 2.3, bezier = "crisp" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.3, bezier = "crisp" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.6, bezier = "crisp" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.6, bezier = "crisp" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.3, bezier = "crisp" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.3, bezier = "crisp", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.3, bezier = "crisp", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.3, bezier = "crisp", style = "slide" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3, bezier = "crisp" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.3, bezier = "crisp", style = "slidevert" })
