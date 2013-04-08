------------------------------------
--     "isis" awesome theme       --
--  @author Isis Agora Lovecruft  --
------------------------------------

--  Main
theme = {}
theme.dir = "/home/isis/\.config/awesome/themes/isis/"
theme.wallpaper_cmd = { "awsetbg -a -r /home/isis/\.config/awesome/themes/isis/backgrounds" }

--  Styles
theme.font      = "sans 10"

--  Colors
theme.isis_black         = "#000000"
theme.isis_gray06        = "#0b0b0b"
theme.isis_gray12        = "#111111"
theme.isis_gray14        = "#222222"
theme.isis_gray67        = "#aaaaaa"
theme.isis_white         = "#ffffff"
theme.isis_awesome_green = "#81df9a"
theme.isis_lighter_green = "#aef4ba"
 
-- theme.fg_normal = "#aaaaaa"
-- theme.fg_focus  = "#ffffff"
-- theme.fg_urgent = "#ffffff"
-- theme.bg_normal = "#222222"
-- theme.bg_focus  = "#0B0B0B"
-- theme.bg_urgent = "#aef4ba"

theme.fg_focus  = theme.isis_awesome_green
theme.bg_focus  = theme.isis_gray12
theme.fg_normal = theme.isis_gray67
theme.bg_normal = theme.isis_gray06
theme.fg_urgent = theme.isis_gray06
theme.bg_urgent = theme.isis_awesome_green

theme.border_width  = "1"
theme.border_normal = theme.isis_gray12
theme.border_focus  = theme.isis_awesome_green
theme.border_marked = theme.isis_lighter_green

--  Widgets
-- You can add as many variables as you wish and access them by using
-- beautiful.variable in your rc.lua.
theme.fg_widget                 = theme.isis_gray67
theme.bg_widget                 = theme.isis_gray06
theme.fg_widget_value           = theme.isis_gray67
theme.fg_widget_value_important = theme.isis_awesome_green
theme.fg_widget_clock           = theme.isis_gray67
theme.fg_center_widget          = theme.isis_gray67
theme.fg_end_widget             = theme.isis_grey67
theme.border_widget             = theme.isis_awesome_green

theme.info = theme.dir .. "icons/info.png"
theme.pacman = theme.dir .. "icons/pacman.png"

--  Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]

--  Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "190"

-------------
--  Icons  --
-------------
--  Taglist
theme.taglist_squares_sel   = theme.dir .. "taglist/squarefw.png"
theme.taglist_squares_unsel = theme.dir .. "taglist/squarez.png"
--theme.taglist_squares_resize = "false"

--  Misc
theme.awesome_icon           = theme.dir .. "icons/awesome-icon.png"
theme.menu_submenu_icon      = theme.dir .. "icons/submenu.png"
theme.tasklist_floating_icon = theme.dir .. "tasklist/floatingw.png"

--  Layout
theme.layout_tile       = theme.dir .. "layouts/tile.png"
theme.layout_tileleft   = theme.dir .. "layouts/tileleft.png"
theme.layout_tilebottom = theme.dir .. "layouts/tilebottom.png"
theme.layout_tiletop    = theme.dir .. "layouts/tiletop.png"
theme.layout_fairv      = theme.dir .. "layouts/fairv.png"
theme.layout_fairh      = theme.dir .. "layouts/fairh.png"
theme.layout_spiral     = theme.dir .. "layouts/spiral.png"
theme.layout_dwindle    = theme.dir .. "layouts/dwindle.png"
theme.layout_max        = theme.dir .. "layouts/max.png"
theme.layout_fullscreen = theme.dir .. "layouts/fullscreen.png"
theme.layout_magnifier  = theme.dir .. "layouts/magnifier.png"
theme.layout_floating   = theme.dir .. "layouts/floating.png"

--  Titlebar
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal

-- There are other variable sets overriding the default one when defined, the
-- sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]

theme.titlebar_close_button_focus  = theme.dir .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.dir .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.dir .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.dir .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.dir .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.dir .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.dir .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.dir .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "titlebar/maximized_normal_inactive.png"

return theme
