-- ~/.config/swayimg/init.lua
-- Swayimg Lua config — Gruvbox dark theme with vim-style keybindings

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------
swayimg.set_mode("viewer")
swayimg.enable_antialiasing(true)
swayimg.enable_decoration(false)
swayimg.enable_overlay(false)
swayimg.set_dnd_button("MouseMiddle")  -- free up MouseRight (default DND button) for mode switching

--------------------------------------------------------------------------------
-- Image list
--------------------------------------------------------------------------------
swayimg.imagelist.set_order("mtime")
swayimg.imagelist.enable_reverse(true)
swayimg.imagelist.enable_recursive(false)
swayimg.imagelist.enable_adjacent(false)

--------------------------------------------------------------------------------
-- Font (Gruvbox)
--------------------------------------------------------------------------------
swayimg.text.set_font("monospace")
swayimg.text.set_size(13)
swayimg.text.set_padding(10)
swayimg.text.set_foreground(0xffebdbb2)   -- gruvbox fg
swayimg.text.set_background(0xcc282828)   -- gruvbox bg0 semi-transparent
swayimg.text.set_shadow(0xff1d2021)       -- gruvbox bg0_h
swayimg.text.set_timeout(0.001)           -- hidden by default; toggle with i
swayimg.text.set_status_timeout(3)

--------------------------------------------------------------------------------
-- Viewer mode
--------------------------------------------------------------------------------
swayimg.viewer.set_default_scale("optimal")  -- 100% or less to fit window, never zooms in
swayimg.viewer.set_default_position("center")
swayimg.viewer.set_drag_button("MouseLeft")
swayimg.viewer.set_window_background(0xff282828)
swayimg.viewer.set_image_chessboard(20, 0xff333333, 0xff4c4c4c)
swayimg.viewer.enable_centering(true)
swayimg.viewer.enable_loop(false)
swayimg.viewer.limit_preload(3)
swayimg.viewer.limit_history(10)
swayimg.viewer.set_text("topleft", {
  "+{name}",
  "+{sizehr}",
  -- "+{frame.width}x{frame.height}",
})
swayimg.viewer.set_text("topright", {
  "{list.index} of {list.total}",
})
swayimg.viewer.set_text("bottomleft", {
  "{scale}",
})

--------------------------------------------------------------------------------
-- Slideshow mode
--------------------------------------------------------------------------------
swayimg.slideshow.set_timeout(5)
swayimg.slideshow.set_default_scale("fit")
swayimg.slideshow.set_default_position("center")
swayimg.slideshow.set_window_background(0xff282828)
swayimg.slideshow.limit_history(0)
swayimg.slideshow.set_text("topright", {
  "{list.index} of {list.total}",
})

--------------------------------------------------------------------------------
-- Gallery mode (Gruvbox)
--------------------------------------------------------------------------------
swayimg.gallery.set_aspect("fill")
swayimg.gallery.set_thumb_size(110)
swayimg.gallery.set_padding_size(8)
swayimg.gallery.set_border_size(2)
swayimg.gallery.set_border_color(0xfffabd2f)       -- gruvbox yellow
swayimg.gallery.set_selected_scale(1.10)
swayimg.gallery.set_selected_color(0xff504945)      -- gruvbox bg2
swayimg.gallery.set_unselected_color(0xff3c3836)    -- gruvbox bg1
swayimg.gallery.set_window_color(0xff282828)        -- gruvbox bg0
swayimg.gallery.limit_cache(500)
swayimg.gallery.enable_preload(true)
swayimg.gallery.enable_pstore(true)
swayimg.gallery.set_text("topright", {
  "{list.index} of {list.total}",
})
swayimg.gallery.set_text("bottomleft", {
  "{name}",
})

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
  local scale = swayimg.viewer.get_scale()
  scale = scale + scale * delta
  if at_mouse then
    local m = swayimg.get_mouse_pos()
    swayimg.viewer.set_abs_scale(scale, m.x, m.y)
  else
    swayimg.viewer.set_abs_scale(scale)
  end
end

local function thumb_resize(delta)
  local cur = swayimg.gallery.get_thumb_size()
  swayimg.gallery.set_thumb_size(cur + delta)
end

local function toggle_info()
  if swayimg.text.visible() then
    swayimg.text.set_timeout(0.001)
  else
    swayimg.text.set_timeout(0)
  end
end

-- Status text: quick auto-hiding feedback (e.g. "Path copied") vs. the
-- Shift-I help overlay, which must stay up until toggled off explicitly.
-- NOTE: swayimg.text.set_status("") clears the message internally but does
-- NOT trigger a redraw, so the old text just lingers on screen. To hide
-- reliably we instead re-arm a normal (non-empty) status with a near-zero
-- timeout, which does redraw both when set and when its timer expires.
local STATUS_TIMEOUT = 3 -- seconds, matches set_status_timeout() below
local help_visible = false

local function flash_status(msg)
  help_visible = false
  swayimg.text.set_status_timeout(STATUS_TIMEOUT)
  swayimg.text.set_status(msg)
end

local function hide_help()
  if help_visible then
    help_visible = false
    swayimg.text.set_status_timeout(0.001) -- near-instant auto-hide, forces a redraw
    swayimg.text.set_status(" ")
    swayimg.text.set_status_timeout(STATUS_TIMEOUT)
  end
end

local function toggle_help(text)
  if help_visible then
    hide_help()
  else
    help_visible = true
    swayimg.text.set_status_timeout(0) -- 0 = never auto-hide
    swayimg.text.set_status(text)
  end
end

--------------------------------------------------------------------------------
-- Keybindings — Viewer (vim-style)
--------------------------------------------------------------------------------
-- Navigation (vdir_t: first, last, next, prev, next_dir, prev_dir, random)
swayimg.viewer.on_key("n",       function() swayimg.viewer.switch_image("next")     end)
swayimg.viewer.on_key("p",       function() swayimg.viewer.switch_image("prev")     end)
swayimg.viewer.on_key("Space",   function() swayimg.viewer.switch_image("next")     end)
swayimg.viewer.on_key("g",       function() swayimg.viewer.switch_image("first")    end)
swayimg.viewer.on_key("Shift-g", function() swayimg.viewer.switch_image("last")     end)
swayimg.viewer.on_key("d",       function() swayimg.viewer.switch_image("next_dir") end)
swayimg.viewer.on_key("Shift-d", function() swayimg.viewer.switch_image("prev_dir") end)

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
swayimg.viewer.on_key("Return",  function() swayimg.set_mode("gallery")             end)

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
swayimg.viewer.on_key("q", function() swayimg.set_mode("gallery") end)
swayimg.viewer.on_key("Escape", function() hide_help() end)

-- Mouse — Viewer
swayimg.viewer.on_mouse("ScrollUp",        function() swayimg.viewer.switch_image("prev") end)
swayimg.viewer.on_mouse("ScrollDown",      function() swayimg.viewer.switch_image("next") end)
swayimg.viewer.on_mouse("ScrollLeft",      function() viewer_step( 0.05, 0)          end)
swayimg.viewer.on_mouse("ScrollRight",     function() viewer_step(-0.05, 0)          end)
swayimg.viewer.on_mouse("Ctrl-ScrollUp",   function() viewer_zoom( 0.1, true)        end)
swayimg.viewer.on_mouse("Ctrl-ScrollDown", function() viewer_zoom(-0.1, true)        end)
swayimg.viewer.on_mouse("MouseRight",      function() swayimg.set_mode("gallery")    end)

--------------------------------------------------------------------------------
-- Keybindings — Slideshow
--------------------------------------------------------------------------------
swayimg.slideshow.on_key("h",       function() swayimg.slideshow.switch_image("prev")  end)
swayimg.slideshow.on_key("l",       function() swayimg.slideshow.switch_image("next")  end)
swayimg.slideshow.on_key("g",       function() swayimg.slideshow.switch_image("first") end)
swayimg.slideshow.on_key("Shift-g", function() swayimg.slideshow.switch_image("last")  end)
swayimg.slideshow.on_key("i",       function() toggle_info()                           end)
swayimg.slideshow.on_key("Return",  function() swayimg.set_mode("viewer")              end)
swayimg.slideshow.on_key("Escape",  function() hide_help() end)
swayimg.slideshow.on_key("q",       function() swayimg.exit()                          end)

--------------------------------------------------------------------------------
-- Keybindings — Gallery (vim-style)
--------------------------------------------------------------------------------
-- Navigation (gdir_t: first, last, up, down, left, right, pgup, pgdown)
swayimg.gallery.on_key("h",       function() swayimg.gallery.switch_image("left")   end)
swayimg.gallery.on_key("l",       function() swayimg.gallery.switch_image("right")  end)
swayimg.gallery.on_key("k",       function() swayimg.gallery.switch_image("up")     end)
swayimg.gallery.on_key("j",       function() swayimg.gallery.switch_image("down")   end)
swayimg.gallery.on_key("g",       function() swayimg.gallery.switch_image("first")  end)
swayimg.gallery.on_key("Shift-g", function() swayimg.gallery.switch_image("last")   end)
swayimg.gallery.on_key("Prior",   function() swayimg.gallery.switch_image("pgup")   end)
swayimg.gallery.on_key("Next",    function() swayimg.gallery.switch_image("pgdown") end)
swayimg.gallery.on_key("Ctrl-u",  function() swayimg.gallery.switch_image("pgup")   end)
swayimg.gallery.on_key("Ctrl-d",  function() swayimg.gallery.switch_image("pgdown") end)

-- Open / mode switch
swayimg.gallery.on_key("Return",  function() swayimg.set_mode("viewer")              end)
-- swayimg.gallery.on_key("Tab",     function() swayimg.set_mode("viewer")              end)

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
swayimg.gallery.on_key("Shift-s", function() swayimg.set_mode("slideshow")           end)

-- Antialiasing toggle
local aa_enabled = true
swayimg.gallery.on_key("a", function()
  aa_enabled = not aa_enabled
  swayimg.enable_antialiasing(aa_enabled)
end)

-- Reload: must switch to viewer first since gallery can't call viewer.reload()
swayimg.gallery.on_key("r", function()
  swayimg.set_mode("viewer")
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
swayimg.gallery.on_mouse("ScrollUp",        function() swayimg.gallery.switch_image("up")   end)
swayimg.gallery.on_mouse("ScrollDown",      function() swayimg.gallery.switch_image("down") end)
swayimg.gallery.on_mouse("Ctrl-ScrollUp",   function() thumb_resize( 10)                    end)
swayimg.gallery.on_mouse("Ctrl-ScrollDown", function() thumb_resize(-10)                    end)
swayimg.gallery.on_mouse("MouseLeft",       function() swayimg.set_mode("viewer")            end)
