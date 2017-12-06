---------------------------------------------------------------------------
--- Querying current GTK+ 3 theme via GtkStyleContext.
--
-- @author Yauheni Kirylau &lt;yawghen@gmail.com&gt;
-- @copyright 2016-2017 Yauheni Kirylau
-- @module beautiful.gtk
---------------------------------------------------------------------------
local gears_debug = require("gears.debug")
local unpack = unpack or table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)

local gtk = {
  cached_theme_variables = nil
}


local function convert_gtk_color_to_hex(gtk_color)
  local rgb = gtk_color:to_string()
  local m = rgb:gmatch("[0-9]+")
  return m and (
    "#" .. string.format("%2.2x", m()) .. string.format("%2.2x", m()) .. string.format("%2.2x", m())
  )
end


local function lookup_gtk_color_to_hex(_style_context, color_name)
  local color = _style_context:lookup_color(color_name)
  if not color then
      return nil
  end
  local result = convert_gtk_color_to_hex(color)
  --color:free()
  return result
end

local function get_gtk_color_property_to_hex(_style_context, property_name, state)
    local property = _style_context:get_property(property_name, state)
    if not property then
      return nil
    end
    local result = convert_gtk_color_to_hex(property.value)
    property:unset()
    return result
end


--- Get GTK+3 theme variables from GtkStyleContext
-- @treturn table subj
function gtk.get_theme_variables()
  if gtk.cached_theme_variables then
    return gtk.cached_theme_variables
  end

  local result = {}
  local lgi = require('lgi')
  local Gtk = lgi.Gtk
  local window
  pcall(function()
    window = Gtk.Window{
      --on_destroy = Gtk.main_quit,
    }
  end)
  if not window then
    gears_debug.print_warning("Seems like GTK+3 is not installed or theme is not set correctly.")
    return nil
  end
  --window:set_override_redirect(true)
  local style_context = window:get_style_context()

  local font = style_context:get_font(Gtk.StateFlags.NORMAL)
  --result.font_family = font:get_family()
  --result.font_size = font:get_size()/1024
  result.font = font:to_string()
  for result_key, style_context_property in pairs({
    bg_color="background-color",
    fg_color="color",
  }) do
    result[result_key] = get_gtk_color_property_to_hex(
        style_context, style_context_property, Gtk.StateFlags.NORMAL
    )
  end

  local entry = Gtk.Entry()
  local entry_style_context = entry:get_style_context()
  for result_key, style_context_property in pairs({
    base_color="background-color",
    text_color="color",
  }) do
    result[result_key] = get_gtk_color_property_to_hex(
        entry_style_context, style_context_property, Gtk.StateFlags.NORMAL
    )
  end
  entry:destroy()

  local toggle_button = Gtk.ToggleButton()
  toggle_button:set_active()
  local toggle_button_style_context = toggle_button:get_style_context()
  for result_key, style_context_property in pairs({
    selected_bg_color="background-color",
    selected_fg_color="color",
  }) do
    result[result_key] = get_gtk_color_property_to_hex(
        toggle_button_style_context, style_context_property, Gtk.StateFlags.ACTIVE
    )
  end
  toggle_button:destroy()

  local button = Gtk.Button()
  local button_style_context = button:get_style_context()
  for result_key, style_context_property in pairs({
    border_radius="border-radius",
    border_width="border-top-width",
  }) do
    local property = button_style_context:get_property(style_context_property, Gtk.StateFlags.NORMAL)
    result[result_key] = property.value
    property:unset()
  end
  for result_key, style_context_property in pairs({
    button_bg_color="background-color",
    button_fg_color="color",
  }) do
    result[result_key] = get_gtk_color_property_to_hex(
        button_style_context, style_context_property, Gtk.StateFlags.NORMAL
    )
  end
  button:destroy()

  for _, color_data in ipairs({
    {"bg_color", "theme_bg_color"},
    {"fg_color", "theme_fg_color"},
    {"base_color", "theme_base_color"},
    {"text_color", "theme_text_color"},
    {"selected_bg_color", "theme_selected_bg_color"},
    {"selected_fg_color", "theme_selected_fg_color"},
    --
    {"tooltip_bg_color", "theme_tooltip_bg_color", "bg_color"},
    {"tooltip_fg_color", "theme_tooltip_fg_color", "fg_color"},
    {"osd_bg_color", "osd_bg", "tooltip_bg_color"},
    {"osd_fg_color", "osd_fg", "tooltip_fg_color"},
    {"osd_border_color", "osd_borders_color", "osd_fg_color"},
    {"menubar_bg_color", "menubar_bg_color", "bg_color"},
    {"menubar_fg_color", "menubar_fg_color", "fg_color"},
    --
    {"button_bg_color", "button_bg_color", "bg_color"},
    {"button_fg_color", "button_fg_color", "fg_color"},
    {"header_button_bg_color", "header_button_bg_color", "menubar_bg_color"},
    {"header_button_fg_color", "header_button_fg_color", "menubar_fg_color"},
    --
    {"wm_bg_color", "wm_bg", "menubar_bg_color"},
    {"wm_border_focused_color", "wm_border_focused", "selected_bg_color"},
    {"wm_title_focused_color", "wm_title_focused", "menubar_bg_color"},
    {"wm_icons_focused_color", "wm_icons_focused", "menubar_fg_color"},
    {"wm_border_unfocused_color", "wm_border_unfocused", "wm_bg_color"},
    {"wm_title_unfocused_color", "wm_title_unfocused", "menubar_bg_color"},
    {"wm_icons_unfocused_color", "wm_icons_unfocused", "menubar_fg_color"},
  }) do
    local result_key, style_context_key, fallback_key = unpack(color_data)
    result[result_key] = lookup_gtk_color_to_hex(style_context, style_context_key) or
      (result[result_key] ~= "#000000" and result[result_key] or result[fallback_key] or result[result_key])
    if not result[result_key] then
        gears_debug.print_warning("Can't read color '" .. style_context_key .. "' from GTK+3 theme.")
    end
  end

  window:destroy()
  gtk.cached_theme_variables = result
  return result
end


return gtk
