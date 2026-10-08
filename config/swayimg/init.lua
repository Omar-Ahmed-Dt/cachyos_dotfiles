-- ~/.config/swayimg/init.lua
-- Swayimg Lua config — Everforest dark theme with vim-style keybindings

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------
swayimg.mode = "viewer"
swayimg.antialiasing = true
swayimg.decoration = false
swayimg.overlay = false
swayimg.dnd_button = "MouseMiddle"  -- free up MouseRight (default DND button) for mode switching

--------------------------------------------------------------------------------
-- Image list
--------------------------------------------------------------------------------
swayimg.imagelist.order = "mtime"
swayimg.imagelist.reverse = true
swayimg.imagelist.recursive = false
swayimg.imagelist.adjacent = false

--------------------------------------------------------------------------------
-- Font (Everforest)
--------------------------------------------------------------------------------
swayimg.text.font = "monospace"
swayimg.text.size = 13
swayimg.text.padding = 10
swayimg.text.color = 0xffd3c6aa        -- everforest fg
swayimg.text.background = 0xcc2d353b   -- everforest bg0 semi-transparent
swayimg.text.shadow = 0xff232a2e       -- everforest bg0_h
swayimg.text.timeout = 0.001           -- hidden by default; toggle with i
swayimg.text.status_timeout = 3

--------------------------------------------------------------------------------
-- Viewer mode
--------------------------------------------------------------------------------
swayimg.viewer.default_scale = "optimal"  -- 100% or less to fit window, never zooms in
swayimg.viewer.default_position = "center"
swayimg.viewer.drag_button = "MouseLeft"
swayimg.viewer.set_window_background(0xff2d353b)
swayimg.viewer.set_image_chessboard(20, 0xff343f44, 0xff475258)
swayimg.viewer.autocenter = true
swayimg.viewer.loop = false
swayimg.viewer.preload = 3
swayimg.viewer.history = 10
swayimg.viewer.text = {
  topleft = {
    "+{name}",
    "+{sizehr}",
    -- "+{frame.width}x{frame.height}",
  },
  topright = {
    "{list.index} of {list.total}",
  },
  bottomleft = {
    "{scale}",
  },
}

--------------------------------------------------------------------------------
-- Slideshow mode
--------------------------------------------------------------------------------
swayimg.slideshow.timeout = 5
swayimg.slideshow.default_scale = "fit"
swayimg.slideshow.default_position = "center"
swayimg.slideshow.set_window_background(0xff2d353b)
swayimg.slideshow.history = 0
swayimg.slideshow.text = {
  topright = {
    "{list.index} of {list.total}",
  },
}

--------------------------------------------------------------------------------
-- Gallery mode (Everforest)
--------------------------------------------------------------------------------
swayimg.gallery.aspect = "fill"
swayimg.gallery.thumb_size = 110
swayimg.gallery.padding_size = 8
swayimg.gallery.border_size = 3
swayimg.gallery.border_color = 0xffdbbc7f       -- everforest yellow
swayimg.gallery.selected_scale = 1.10
swayimg.gallery.selected_color = 0xff3d484d      -- everforest bg2
swayimg.gallery.unselected_color = 0xff343f44    -- everforest bg1
swayimg.gallery.window_color = 0xff2d353b        -- everforest bg0
swayimg.gallery.cache = 500
swayimg.gallery.preload = true
swayimg.gallery.pstore = true
swayimg.gallery.text = {
  topright = {
    "{list.index} of {list.total}",
  },
  bottomleft = {
    "{name}",
  },
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function viewer_step(dx, dy)
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(
    math.floor(pos.x + wnd.width * dx),
    math.floor(pos.y + wnd.height * dy)
  )
end

local function viewer_zoom(delta, at_mouse)
  local scale = swayimg.viewer.scale
  scale = scale + scale * delta
  if at_mouse then
    local m = swayimg.get_mouse_pos()
    swayimg.viewer.set_abs_scale(scale, m.x, m.y)
  else
    swayimg.viewer.set_abs_scale(scale)
  end
end

local function thumb_resize(delta)
  local cur = swayimg.gallery.thumb_size
  swayimg.gallery.thumb_size = cur + delta
end

local function toggle_info()
  if swayimg.text.visible then
    swayimg.text.timeout = 0.001
  else
    swayimg.text.timeout = 0
  end
end

-- Status text: quick auto-hiding feedback (e.g. "Path copied") vs. the
-- Shift-I help overlay, which must stay up until toggled off explicitly.
-- NOTE: swayimg.text.status = "" clears the message internally but does
-- NOT trigger a redraw, so the old text just lingers on screen. To hide
-- reliably we instead re-arm a normal (non-empty) status with a near-zero
-- timeout, which does redraw both when set and when its timer expires.
local STATUS_TIMEOUT = 3 -- seconds, matches text.status_timeout above
local help_visible = false

local function flash_status(msg)
  help_visible = false
  swayimg.text.status_timeout = STATUS_TIMEOUT
  swayimg.text.status = msg
end

local function hide_help()
  if help_visible then
    help_visible = false
    swayimg.text.status_timeout = 0.001 -- near-instant auto-hide, forces a redraw
    swayimg.text.status = " "
    swayimg.text.status_timeout = STATUS_TIMEOUT
  end
end

local function toggle_help(text)
  if help_visible then
    hide_help()
  else
    help_visible = true
    swayimg.text.status_timeout = 0 -- 0 = never auto-hide
    swayimg.text.status = text
  end
end

--------------------------------------------------------------------------------
-- Keybindings — Viewer (vim-style)
--------------------------------------------------------------------------------
-- Navigation (vdir_t: first, last, next, prev, next_dir, prev_dir, random)
swayimg.viewer.on_key("n",       function() swayimg.viewer.open("next")     end)
swayimg.viewer.on_key("p",       function() swayimg.viewer.open("prev")     end)
swayimg.viewer.on_key("Space",   function() swayimg.viewer.open("next")     end)
swayimg.viewer.on_key("g",       function() swayimg.viewer.open("first")    end)
swayimg.viewer.on_key("Shift-g", function() swayimg.viewer.open("last")     end)
swayimg.viewer.on_key("d",       function() swayimg.viewer.open("next_dir") end)
swayimg.viewer.on_key("Shift-d", function() swayimg.viewer.open("prev_dir") end)

-- Panning
swayimg.viewer.on_key("j",       function() viewer_step(0, -0.1)                   end)
swayimg.viewer.on_key("k",       function() viewer_step(0,  0.1)                   end)
swayimg.viewer.on_key("h",       function() viewer_step( 0.1, 0)                   end)
swayimg.viewer.on_key("l",       function() viewer_step(-0.1, 0)                   end)

-- Zoom
swayimg.viewer.on_key("equal",   function() viewer_zoom( 0.1, false)               end)
swayimg.viewer.on_key("plus",    function() viewer_zoom( 0.1, false)               end)
-- swayimg.viewer.on_key("minus",   function() viewer_zoom(-0.1, false)               end)
swayimg.viewer.on_key("0",       function() swayimg.viewer.set_fix_scale("optimal") end)

-- Rotate (rotation_t: 90, 180, 270)
swayimg.viewer.on_key("bracketright", function() swayimg.viewer.rotate(90)          end)
swayimg.viewer.on_key("bracketleft",  function() swayimg.viewer.rotate(270)         end)

-- Flip
swayimg.viewer.on_key("r",       function() swayimg.viewer.flip_horizontal()        end)
swayimg.viewer.on_key("Shift-r", function() swayimg.viewer.flip_vertical()          end)

-- Mode switching
swayimg.viewer.on_key("Return",  function() swayimg.mode = "gallery"             end)

-- Info, help & animation
swayimg.viewer.on_key("i",       function() toggle_info()                           end)
swayimg.viewer.on_key("Shift-i", function()
  toggle_help(
    "n/p: next/prev  h/l/j/k: pan  d/D: next/prev dir\n" ..
    "[/]: rotate  r/R: flip H/V  =/−: zoom  0: optimal\n" ..
    "Return/q: gallery  s: skip  Del: trash\n" ..
    "Shift-y: copy path  y: copy img  w: wallpaper"
  )
end)
-- swayimg.viewer.on_key("Shift-n", function() swayimg.viewer.next_frame()             end)
-- swayimg.viewer.on_key("Shift-p", function() swayimg.viewer.prev_frame()             end)

-- Skip (remove from list without deleting file)
swayimg.viewer.on_key("s", function()
  local image = swayimg.viewer.get_image()
  swayimg.imagelist.remove(image.path)
end)

-- Delete (trash-put + remove from list)
swayimg.viewer.on_key("Delete", function()
  local image = swayimg.viewer.get_image()
  os.execute("trash-put '" .. image.path .. "'")
  swayimg.imagelist.remove(image.path)
end)

-- Copy path to clipboard
swayimg.viewer.on_key("Shift-y", function()
  local image = swayimg.viewer.get_image()
  os.execute("wl-copy '" .. image.path .. "'")
  flash_status("Path copied")
end)

-- Copy image to clipboard
swayimg.viewer.on_key("y", function()
  local image = swayimg.viewer.get_image()
  os.execute("wl-copy -t image/png < '" .. image.path .. "'")
  flash_status("Image copied")
end)

-- Set wallpaper
swayimg.viewer.on_key("w", function()
  local image = swayimg.viewer.get_image()
  os.execute("/home/omar/scripts/set-wallpaper.sh '" .. image.path .. "' >/dev/null 2>&1")
  flash_status("Wallpaper set")
end)

-- Exit
swayimg.viewer.on_key("q", function() swayimg.mode = "gallery" end)
swayimg.viewer.on_key("Escape", function() hide_help() end)

-- Mouse — Viewer
swayimg.viewer.on_mouse("ScrollUp",        function() swayimg.viewer.open("prev") end)
swayimg.viewer.on_mouse("ScrollDown",      function() swayimg.viewer.open("next") end)
swayimg.viewer.on_mouse("ScrollLeft",      function() viewer_step( 0.05, 0)          end)
swayimg.viewer.on_mouse("ScrollRight",     function() viewer_step(-0.05, 0)          end)
swayimg.viewer.on_mouse("Ctrl-ScrollUp",   function() viewer_zoom( 0.1, true)        end)
swayimg.viewer.on_mouse("Ctrl-ScrollDown", function() viewer_zoom(-0.1, true)        end)
swayimg.viewer.on_mouse("MouseRight",      function() swayimg.mode = "gallery"    end)

--------------------------------------------------------------------------------
-- Keybindings — Slideshow
--------------------------------------------------------------------------------
swayimg.slideshow.on_key("h",       function() swayimg.slideshow.open("prev")  end)
swayimg.slideshow.on_key("l",       function() swayimg.slideshow.open("next")  end)
swayimg.slideshow.on_key("g",       function() swayimg.slideshow.open("first") end)
swayimg.slideshow.on_key("Shift-g", function() swayimg.slideshow.open("last")  end)
swayimg.slideshow.on_key("i",       function() toggle_info()                           end)
swayimg.slideshow.on_key("Return",  function() swayimg.mode = "viewer"              end)
swayimg.slideshow.on_key("Escape",  function() hide_help() end)
swayimg.slideshow.on_key("q",       function() swayimg.exit()                          end)

--------------------------------------------------------------------------------
-- Keybindings — Gallery (vim-style)
--------------------------------------------------------------------------------
-- Navigation (gdir_t: first, last, up, down, left, right, pgup, pgdown)
swayimg.gallery.on_key("h",       function() swayimg.gallery.select("left")   end)
swayimg.gallery.on_key("l",       function() swayimg.gallery.select("right")  end)
swayimg.gallery.on_key("k",       function() swayimg.gallery.select("up")     end)
swayimg.gallery.on_key("j",       function() swayimg.gallery.select("down")   end)
swayimg.gallery.on_key("g",       function() swayimg.gallery.select("first")  end)
swayimg.gallery.on_key("Shift-g", function() swayimg.gallery.select("last")   end)
swayimg.gallery.on_key("Prior",   function() swayimg.gallery.select("pgup")   end)
swayimg.gallery.on_key("Next",    function() swayimg.gallery.select("pgdown") end)
swayimg.gallery.on_key("Ctrl-u",  function() swayimg.gallery.select("pgup")   end)
swayimg.gallery.on_key("Ctrl-d",  function() swayimg.gallery.select("pgdown") end)

-- Open / mode switch
swayimg.gallery.on_key("Return",  function() swayimg.mode = "viewer"              end)
-- swayimg.gallery.on_key("Tab",     function() swayimg.mode = "viewer"              end)

-- Info, help & modes
swayimg.gallery.on_key("i",       function() toggle_info()                           end)
swayimg.gallery.on_key("Shift-i", function()
  toggle_help(
    "h/l/j/k: navigate  g/G: first/last  Ctrl-u/d: page\n" ..
    "Return: viewer  Shift-s: slideshow  a: antialiasing\n" ..
    "r: reload in viewer  s: skip  Del: trash  =/−: thumb size\n" ..
    "Shift-y: copy path  y: copy img  w: wallpaper  q: quit"
  )
end)
swayimg.gallery.on_key("Shift-s", function() swayimg.mode = "slideshow"           end)

-- Antialiasing toggle
local aa_enabled = true
swayimg.gallery.on_key("a", function()
  aa_enabled = not aa_enabled
  swayimg.antialiasing = aa_enabled
end)

-- Reload: must switch to viewer first since gallery can't call viewer.reload()
swayimg.gallery.on_key("r", function()
  swayimg.mode = "viewer"
  swayimg.viewer.reload()
end)

-- Skip (remove from list)
swayimg.gallery.on_key("s", function()
  local image = swayimg.gallery.get_image()
  swayimg.imagelist.remove(image.path)
end)

-- Thumbnail size
swayimg.gallery.on_key("equal",   function() thumb_resize( 20) end)
swayimg.gallery.on_key("plus",    function() thumb_resize( 20) end)
swayimg.gallery.on_key("minus",   function() thumb_resize(-20) end)

-- Delete (trash-put + remove from list)
swayimg.gallery.on_key("Delete", function()
  local image = swayimg.gallery.get_image()
  os.execute("trash-put '" .. image.path .. "'")
  swayimg.imagelist.remove(image.path)
end)

-- Copy path to clipboard
swayimg.gallery.on_key("Shift-y", function()
  local image = swayimg.gallery.get_image()
  os.execute("wl-copy '" .. image.path .. "'")
  flash_status("Path copied")
end)

-- Copy image to clipboard
swayimg.gallery.on_key("y", function()
  local image = swayimg.gallery.get_image()
  os.execute("wl-copy -t image/png < '" .. image.path .. "'")
  flash_status("Image copied")
end)

-- Set wallpaper
swayimg.gallery.on_key("w", function()
  local image = swayimg.gallery.get_image()
  os.execute("/home/omar/scripts/set-wallpaper.sh '" .. image.path .. "' >/dev/null 2>&1")
  flash_status("Wallpaper set")
end)

-- Exit
swayimg.gallery.on_key("q", function() swayimg.exit() end)
swayimg.gallery.on_key("Escape", function() hide_help() end)

-- Mouse — Gallery
swayimg.gallery.on_mouse("ScrollUp",        function() swayimg.gallery.select("up")   end)
swayimg.gallery.on_mouse("ScrollDown",      function() swayimg.gallery.select("down") end)
swayimg.gallery.on_mouse("Ctrl-ScrollUp",   function() thumb_resize( 10)                    end)
swayimg.gallery.on_mouse("Ctrl-ScrollDown", function() thumb_resize(-10)                    end)
swayimg.gallery.on_mouse("MouseLeft",       function() swayimg.mode = "viewer"            end)
