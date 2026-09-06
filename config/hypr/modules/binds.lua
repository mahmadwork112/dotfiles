---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "alacritty"
local fileManager = "nemo"
local menu = "./.config/rofi/app_launcher/launcher.sh"
local powermenu = "./.config/rofi/powermenu/powermenu.sh"
local wallpaper = "./.config/rofi/wallpaper_selector/wallpaper_selector.sh"
local lockscreen = "playerctl --all-players pause; hyprlock"
local emojiSelector = "/home/ahmad/.config/rofi/emoji_selector/emoji_selector.sh"
local browser = "/usr/bin/floorp"
-- local textEditor = terminal .. " --title zed-ide -e /home/ahmad/.local/bin/zed"
local textEditor = "codium"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Custom binds
--emacs
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(textEditor))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("qs ipc -c overview call overview toggle"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("mission-center"))
hl.bind(
	mainMod .. " + SHIFT + O",
	hl.dsp.exec_cmd("/home/ahmad/Downloads/AppImages/Obsidian-1.12.7.AppImage --no-sandbox")
)
hl.bind(
	"ALT + Tab",
	hl.dsp.exec_cmd("snappy-switcher next --workspace --mod alt"),
	{ description = "Snappy Switcher(Workspace)" }
)
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd(wallpaper))
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd(emojiSelector))
hl.bind("ALT + CTRL + S", hl.dsp.exec_cmd("sh -c 'pkill waybar; waybar & pkill swaync; swaync'"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd(lockscreen))
hl.bind(mainMod .. " + CTRL + X", hl.dsp.exec_cmd(powermenu))
-- full screen and maximize commands
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
-- mute the active window
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("qs -c muteWindow ipc call muteWindow toggle"))

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + W", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move focus with mainMod + hjkl (Vim keys)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move through existing workspaces with mainMod + SHIFT + H/L
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.focus({ workspace = "e-1" })) -- Move one workspace left
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.focus({ workspace = "e+1" })) -- Move one workspace right

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", function()
	hl.dispatch(hl.dsp.window.float({ action = "on" }))
	hl.dispatch(hl.dsp.window.resize({ x = 1800, y = 900, relative = false }))
	hl.dispatch(hl.dsp.window.move({ workspace = "special:magic", follow = false }))
end)

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

---------------------------
---- CURSOR ZOOM (ALT) ----
---------------------------

-- Alt + scroll to zoom the cursor viewport, Alt + middle-click to reset.
-- zoom_rigid is always derived from zoomFactor so it can never get out of
-- sync with the actual zoom level, regardless of which direction you
-- scrolled in from.
local zoomFactor = 1.0
local zoomStep = 0.5
local zoomMin = 1.0
local zoomMax = 4.0

local function setZoom(factor)
	zoomFactor = math.max(zoomMin, math.min(zoomMax, factor))
	hl.config({
		cursor = {
			zoom_factor = zoomFactor,
			zoom_rigid = zoomFactor > zoomMin,
		},
	})
end

hl.bind("ALT + mouse_down", function()
	setZoom(zoomFactor + zoomStep)
end)

hl.bind("ALT + mouse_up", function()
	setZoom(zoomFactor - zoomStep)
end)

hl.bind("ALT + mouse:274", function()
	setZoom(zoomMin)
end)

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = false }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = false }
)

--brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
