-- ~/.config/swayimg/init.lua
-- Swayimg Lua config — Gruvbox dark theme with vim-style keybindings

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------
swayimg.set_mode("viewer")
swayimg.enable_antialiasing(true)
swayimg.enable_decoration(false)
swayimg.enable_overlay(false)

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
swayimg.text.set_timeout(0)               -- always show
swayimg.text.set_status_timeout(3)

--------------------------------------------------------------------------------
-- Viewer mode
--------------------------------------------------------------------------------
swayimg.viewer.set_default_scale("fit")  -- scales down to fit the whole image in window
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
  "+{frame.width}x{frame.height}",
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

--------------------------------------------------------------------------------
-- Keybindings — Viewer (vim-style)
--------------------------------------------------------------------------------
-- Navigation (vdir_t: first, last, next, prev, next_dir, prev_dir, random)
swayimg.viewer.on_key("h",       function() swayimg.viewer.switch_image("prev")     end)
swayimg.viewer.on_key("l",       function() swayimg.viewer.switch_image("next")     end)
swayimg.viewer.on_key("Space",   function() swayimg.viewer.switch_image("next")     end)
swayimg.viewer.on_key("g",       function() swayimg.viewer.switch_image("first")    end)
swayimg.viewer.on_key("Shift-g", function() swayimg.viewer.switch_image("last")     end)
swayimg.viewer.on_key("d",       function() swayimg.viewer.switch_image("next_dir") end)
swayimg.viewer.on_key("Shift-d", function() swayimg.viewer.switch_image("prev_dir") end)

-- Panning
swayimg.viewer.on_key("j",       function() viewer_step(0, -0.1)                   end)
swayimg.viewer.on_key("k",       function() viewer_step(0,  0.1)                   end)

-- Zoom
swayimg.viewer.on_key("equal",   function() viewer_zoom( 0.1, false)               end)
swayimg.viewer.on_key("plus",    function() viewer_zoom( 0.1, false)               end)
swayimg.viewer.on_key("minus",   function() viewer_zoom(-0.1, false)               end)
swayimg.viewer.on_key("0",       function() swayimg.viewer.set_fix_scale("optimal") end)

-- Rotate (rotation_t: 90, 180, 270)
swayimg.viewer.on_key("bracketright", function() swayimg.viewer.rotate(90)          end)
swayimg.viewer.on_key("bracketleft",  function() swayimg.viewer.rotate(270)         end)

-- Mode switching
swayimg.viewer.on_key("Return",  function() swayimg.set_mode("gallery")             end)

-- Info & animation
swayimg.viewer.on_key("i",       function() toggle_info()                           end)
swayimg.viewer.on_key("n",       function() swayimg.viewer.next_frame()             end)

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
swayimg.viewer.on_key("y", function()
  local image = swayimg.viewer.get_image()
  os.execute("wl-copy '" .. image.path .. "'")
  swayimg.text.set_status("Path copied")
end)

-- Copy image to clipboard
swayimg.viewer.on_key("Shift-y", function()
  local image = swayimg.viewer.get_image()
  os.execute("wl-copy -t image/png < '" .. image.path .. "'")
  swayimg.text.set_status("Image copied")
end)

-- Set wallpaper
swayimg.viewer.on_key("w", function()
  local image = swayimg.viewer.get_image()
  os.execute("/home/omar/scripts/set-wallpaper.sh '" .. image.path .. "' >/dev/null 2>&1")
  swayimg.text.set_status("Wallpaper set")
end)

-- Exit
swayimg.viewer.on_key("q", function() swayimg.exit() end)

-- Mouse — Viewer
swayimg.viewer.on_mouse("ScrollUp",        function() viewer_step(0,  0.05)          end)
swayimg.viewer.on_mouse("ScrollDown",      function() viewer_step(0, -0.05)          end)
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
swayimg.slideshow.on_key("Escape",  function() swayimg.set_mode("viewer")              end)
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
swayimg.gallery.on_key("Tab",     function() swayimg.set_mode("viewer")              end)

-- Info & modes
swayimg.gallery.on_key("i",       function() toggle_info()                           end)
swayimg.gallery.on_key("s",       function() swayimg.set_mode("slideshow")           end)

-- Skip (remove from list)
swayimg.gallery.on_key("c", function()
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
swayimg.gallery.on_key("y", function()
  local image = swayimg.gallery.get_image()
  os.execute("wl-copy '" .. image.path .. "'")
  swayimg.text.set_status("Path copied")
end)

-- Copy image to clipboard
swayimg.gallery.on_key("Shift-y", function()
  local image = swayimg.gallery.get_image()
  os.execute("wl-copy -t image/png < '" .. image.path .. "'")
  swayimg.text.set_status("Image copied")
end)

-- Set wallpaper
swayimg.gallery.on_key("w", function()
  local image = swayimg.gallery.get_image()
  os.execute("/home/omar/scripts/set-wallpaper.sh '" .. image.path .. "' >/dev/null 2>&1")
  swayimg.text.set_status("Wallpaper set")
end)

-- Exit
swayimg.gallery.on_key("q", function() swayimg.exit() end)

-- Mouse — Gallery
swayimg.gallery.on_mouse("ScrollUp",        function() swayimg.gallery.switch_image("up")   end)
swayimg.gallery.on_mouse("ScrollDown",      function() swayimg.gallery.switch_image("down") end)
swayimg.gallery.on_mouse("Ctrl-ScrollUp",   function() thumb_resize( 10)                    end)
swayimg.gallery.on_mouse("Ctrl-ScrollDown", function() thumb_resize(-10)                    end)
swayimg.gallery.on_mouse("MouseLeft",       function() swayimg.set_mode("viewer")            end)
