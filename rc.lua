-- rc.lua
-- ~~~~~~
-- "Lean, hungry, savage anti-everythings. A modest request."
--                                 -- Oliver Wendel Holmes
--
-- Features:
-- * Fallback to default config if there are errors.
-- * Submenu under awesome menu in the tasklist bar which shows all
--   subdirectories and files of the home dir.
-- * Run program, else raise-if-already-running, keybindings.
-- * Thinkpad x201 keybindings for the media, volume, and mute keys to control
--   mocp playback.
-- * naughty.notify() popup which displays all documented keybindings when
--   Mod4+F1 is pressed.
-- *
--
-- *

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")

-- Load Debian menu entries
--require("debian.menu")
--require("myplacesmenu")

-- User Libraries
require("helpers")
local keydoc = require("keydoc")

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
   -- Fall back to the default theme instead of barfing everywhere
   beautiful.init("/home/isis/.config/awesome/themes/default/theme.lua")
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.add_signal("debug::error",
                      function (err)
                         -- Make sure we don't go into an endless error loop
                         if in_error then return end
                         in_error = true

                         naughty.notify(
                            { preset = naughty.config.presets.critical,
                              title = "Uh-oh spaghettios!",
                              text = err })
                         in_error = false
                      end)
end

-- Theme
beautiful.init("/home/isis/.config/awesome/themes/isis/theme.lua")

-- Terminal emulator and editor
terminal = "urxvt"
editor = os.getenv("EDITOR") or "emacs"
editor_cmd = terminal .. " -e " .. editor .. " -nw"

-- Default modkey
--altkey = "Mod1"
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    awful.layout.suit.floating,           -- 1
    awful.layout.suit.tile,               -- 2
    awful.layout.suit.tile.left,          -- 3
    awful.layout.suit.tile.bottom,        -- 4
    -- awful.layout.suit.tile.top,        -- unused
    awful.layout.suit.fair,               -- 5
    -- awful.layout.suit.fair.horizontal, -- unused
    awful.layout.suit.spiral,             -- 6
    -- awful.layout.suit.spiral.dwindle,  -- unused
    -- awful.layout.suit.max,             -- unused
    -- awful.layout.suit.max.fullscreen,  -- unused
    awful.layout.suit.magnifier           -- 7
}

-- Tags

tags = {}
my_tags = { "☥", "☭", "♄", "☪", "☊", "⌬", "ℏ", "⚸", "ℵ" }

for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(my_tags, s, layouts[1])

    -- Unique backgrounds
    --wallpapers = {}
    --for i = i, 9 do
    --    wallpapers[i] = "awsetbg -a /home/isis/.config/awesome/themes/isis/backgrounds/tag" .. i .. ".jpg"
    --end
    --for id, tag in ipair(tags[s]) do
    --    tag:add_signal(
    --        "property::selected",
    --        function (tag)
    --            if not tag.selected then return end
    --            awful.util.spawn(wallpapers[id])
    --        end)
    --end
end

-- Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome", beautiful.info },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart awesome", awesome.restart },
   { "kill awesome", awesome.quit }
}

mymainmenu = awful.menu(
   { items = {
        { "open terminal", terminal, image(beautiful.pacman) },
        --{ "files", myplacesmenu.myplacesmenu()},
        --{ "debian", debian.menu.Debian_menu.Debian },
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "hibernate", terminal .. " -e sudo hibernate" },
        { "reboot", terminal .. " -e sudo shutdown -r -F now" },
        { "shutdown", terminal .. " -e sudo shutdown -h -P -F now" }
     }
  }
)

mylauncher = awful.widget.launcher(
   { image = image(beautiful.awesome_icon),
     menu = mymainmenu })

-- Widgets

require("obvious.clock")
timewidget = obvious.clock
timewidget.set_editor(editor_cmd)
timewidget.set_shortformat(" %A %d %B, %H:%M ")
timewidget.set_longformat(" %A %d %B, %H:%M ")
timewidget.set_shorttimer(15)
timewidget.set_longtimer(15)

--require("obvious.wlan")
--wlanwidget = obvious.wlan

--require("obvious.volume_alsa")
--volumewidget = obvious.volume_alsa(0, "Master")

-- require("obvious.net")
-- netwidget = obvious.net
-- netgraph = awful.widget.graph({ height = 15,
--                                 width = 50,
--                                 border_colour = "#000000",
--                                 gradient_colour = theme.fg_widget_value_important,
--                                 color = theme.fg_widget,
--                                 background_color = theme.bg_widget},
--                               netwidget.recv())

--require("obvious.cpu")

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a widget box for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({        }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({        }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({        }, 4, awful.tag.viewnext),
                    awful.button({        }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
                           if c == client.focus then
                              c.minimized = true
                           else
                              if not c:isvisible() then
                                 awful.tag.viewonly(c:tags()[1])
                              end
                              -- This will also un-minimize the client
                              client.focus = c
                              c:raise()
                           end
                        end),
   awful.button({ }, 3, function ()
                           if instance then
                              instance:hide()
                              instance = nil
                           else
                              instance = awful.menu.clients({ width=250 })
                           end
                        end),
   awful.button({ }, 4, function ()
                           awful.client.focus.byidx(1)
                           if client.focus then client.focus:raise() end
                        end),
   awful.button({ }, 5, function ()
                            awful.client.focus.byidx(-1)
                            if client.focus then client.focus:raise() end
                        end)
)

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt(
       { layout = awful.widget.layout.horizontal.leftright }
    )

    -- Create an imagebox widget which will contains an icon indicating
    -- which layout we're using
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(
       awful.util.table.join(
          awful.button({  }, 1,
                       function ()
                          awful.layout.inc(layouts, 1)
                       end),
          awful.button({  }, 3,
                       function ()
                          awful.layout.inc(layouts, -1)
                       end),
          awful.button({  }, 4,
                       function ()
                          awful.layout.inc(layouts, 1)
                       end),
          awful.button({  }, 5,
                       function ()
                          awful.layout.inc(layouts, -1)
                       end)
       )
    )

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(
       s, awful.widget.taglist.label.all, mytaglist.buttons
    )

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(
       function(c)
          -- remove tasklist icons without modifying the original
          -- /usr/share/awesome/libs/awful/widget/tasklist.lua
          local tmptask = { awful.widget.tasklist.label.currenttags(c, s) }
          return tmptask[1], tmptask[2], tmptask[3], nil
       end,
       mytasklist.buttons
    )

    -- Create the wibox
    mywibox[s] = awful.wibox(
       { position = "top", screen = s }
    )

    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
       {
          mylauncher,
          mytaglist[s],
          layout = awful.widget.layout.horizontal.leftright
       },
       mylayoutbox[s],
       --datewidget,
       timewidget(),
       --volumewidget(),
       --netgraph(),
       --wlanwidget(),
       s == 1 and mysystray or nil,
       mypromptbox[s],
       mytasklist[s],
       layout = awful.widget.layout.horizontal.rightleft
    }
end

-- MOUSE BINDINGS
root.buttons(awful.util.table.join(
    awful.button({        }, 3, function () mymainmenu:toggle() end),
    awful.button({        }, 4, awful.tag.viewnext),
    awful.button({        }, 5, awful.tag.viewprev) ) )

clientbuttons = awful.util.table.join(
    awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize) )


-- GLOBAL KEY BINDINGS: HELPER FUNCTIONS

function run_or_raise(cmd, properties)
   -- Spawns cmd if no client can be found matching properties. If such a
   -- client can be found, pop to first tag where it is visible, and give it
   -- focus @param cmd the command to execute @param properties a table of
   -- properties to match against clients

   local clients = client.get()
   local focused = awful.client.next(0)
   local findex = 0
   local matched_clients = {}
   local n = 0

   for i, c in pairs(clients) do
      -- make an array of matched clients
      if match(properties, c) then n = n + 1
         matched_clients[n] = c
         if c == focused then findex = n
         end
      end
   end

   if n > 0 then
      local c = matched_clients[1]

      -- if the focused window matched switch focus to next in list
      if 0 < findex and findex < n then c = matched_clients[findex+1] end

      local ctags = c:tags()

      -- ctags is empty, show client on current tag
      if table.getn(ctags) == 0 then
         local curtag = awful.tag.selected()
         awful.client.movetotag(curtag, c)

      -- Otherwise, pop to first tag client is visible on
      else awful.tag.viewonly(ctags[1])
      end

      -- And then focus the client
      client.focus = c
      c:raise()
      return
   end

   awful.util.spawn(cmd)
end


function match (table_one, table_two)
   -- Returns true if all pairs in table_one are present in table_two

   for k, v in pairs(table_one) do
      if table_two[k] ~= v and not table_two[k]:find(v) then return false end
   end

   return true
end

-- GLOBAL KEY BINDINGS

globalkeys = awful.util.table.join(

   -- HELP MENU
   keydoc.group("Help"),
   awful.key({ modkey,           }, "F1", keydoc.display,
             "This cruft"),

   -- SYSTEM FUNCTIONS
   keydoc.group("System tasks"),
   awful.key({ modkey,           }, "Return",
             function () awful.util.spawn(terminal) end,
             "Spawn a terminal"),
   -- We don't ever use them, and they're in the menu anyway
   -- awful.key({ modkey, "Shift"   }, "a",
   --           function () mymainmenu:show({keygrabber=true}) end,
   --           "Show Awesome menu"),
   -- awful.key({ modkey, "Shift"   }, "r", awesome.restart,
   --           "Restart awesome"),
   -- awful.key({ modkey, "Shift"   }, "q", awesome.quit,
   --           "Quit awesome"),
   -- awful.key({ modkey,           }, "z",
   --           function ()
   --              awful.prompt.run({ prompt = "Run Lua code: " },
   --              mypromptbox[mouse.screen].widget,
   --              awful.util.eval, nil,
   --              awful.util.getdir("cache") .. "/history_eval")
   --           end,
   --           "Enter a Lua Prompt"),

   -- SCREENLOCK, SLEEP, AND HIBERNATE
   awful.key({}, "#160",
             function () awful.util.spawn("xscreensaver-command -lock") end,
             "Lock screen"),
   -- That little crescent moon key
   awful.key({}, "#150",
             function () awful.util.spawn("sudo hibernate") end,
             "Hibernate"),

   -- RUN OR RAISE CLIENT PROCESSES
   -- to get a client's window properties, use xwininfo or xprop
   awful.key({ modkey,            }, "r",
             function () mypromptbox[mouse.screen]:run() end,
             "Run program"),
   awful.key({ modkey,            }, "e",
             function () run_or_raise("emacsclient -a emacs -n -c",
                                      { class = "Emacs" }) end,
             "Emacs"),
   awful.key({ modkey,            }, "f",
             function () run_or_raise("firefox",
                                      { class = "Firefox" }) end,
             "Firefox"),
   awful.key({ modkey,            }, "h",
             function () run_or_raise("urxvt -geometry 159x48+0-1",
                                      { name = "tmux" }) end,
             "Tmux"),
   awful.key({ modkey,            }, "t",
             function () run_or_raise("start-tor-browser",
                                      { class = "TorBrowser" }) end,
             "Tor Browser"),
   awful.key({ modkey,            }, "c",
             function () run_or_raise("pidgin",
                                      { class = "Pidgin" }) end,
             "Pidgin"),


   -- FOCUS
   keydoc.group("Changing Focus"),
   awful.key({ modkey,           }, "k",
             function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
             end,
             "Next task"),
   awful.key({ modkey,           }, "j",
             function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
             end,
             "Previous task"),
   awful.key({ modkey,           }, "u",
             awful.client.urgent.jumpto,
             "Jump to urgent task"),
   awful.key({ modkey,           }, "Tab",
             function ()
                awful.client.focus.history.previous()
                if client.focus then
                   client.focus:raise()
                end
             end,
             "Tab through recently viewed tasks"),
   awful.key({ modkey,           }, "Escape",
             awful.tag.history.restore,
             "Reset tasklist history"),
   awful.key({ modkey, "Control" }, "n",
             awful.client.restore,
             "Minimize / maximize task"),

   -- TAGS
   keydoc.group("Changing Tags"),
   awful.key({ modkey,           }, "Left",
             awful.tag.viewprev,
             "Move left"),
   awful.key({ modkey,           }, "Right",
             awful.tag.viewnext,
             "Move right"),


   -- PANE SIZES
   keydoc.group("Resizing Panes"),
   awful.key({ modkey,           }, "i",
             function ()
                awful.tag.incmwfact( 0.05)
             end,
             "Increase master pane"),
   awful.key({ modkey,           }, "o",
             function ()
                awful.tag.incmwfact(-0.05)
             end,
             "Decrease master pane"),
   awful.key({ modkey, "Control" }, "i",
            function ()
               awful.tag.incncol( 1)
            end),
   awful.key({ modkey, "Control" }, "o",
            function ()
               awful.tag.incncol(-1)
            end),
   awful.key({ modkey, "Shift"   }, "i",
             function ()
                awful.client.incwfact( 0.05)
             end,
             "Increase slave pane"),
   awful.key({ modkey, "Shift"   }, "o",
             function ()
                awful.client.incwfact(-0.05)
             end,
             "Decrease slave pane"),

   -- TASKLIST
   keydoc.group("Tasklist Manipulation"),
   awful.key({ modkey, "Shift"   }, "k",
             function ()
                awful.client.swap.byidx(  1)
             end,
             "Move focused pane up in the tasklist"),
   awful.key({ modkey, "Shift"   }, "j",
             function ()
                awful.client.swap.byidx( -1)
             end,
             "Move focused pane down in the tasklist"),

   -- DISPLAY AND LAYOUTS
   keydoc.group("Displays and Layout"),
   awful.key({ modkey,           }, "space",
             function ()
                awful.layout.inc(layouts,  1)
             end,
             "Next layout"),
   awful.key({ modkey, "Shift"   }, "space",
             function ()
                awful.layout.inc(layouts, -1)
             end,
             "Previous layout"),
   awful.key({ modkey,           }, "Up",
            function ()
               awful.screen.focus_relative( 1)
            end,
            "Change to next display"),
   awful.key({ modkey,            }, "Down",
            function ()
               awful.screen.focus_relative(-1)
            end,
            "Change to previous display"),

   -- VOLUME AND PLAYBACK (Thinkpad X201)
   -- To find the keycodes, use xev(8).
   keydoc.group("Volume and Music Controls"),
   awful.key({}, "#123",
             function ()
                awful.util.spawn("amixer -q -c 0 sset Master 2db+")
             end,
             "Volume up"),
   awful.key({}, "#122",
             function ()
                awful.util.spawn("amixer -q -c 0 sset Master 2db-")
             end,
             "Volume down"),
   awful.key({}, "#121",
             function ()
                awful.util.spawn("amixer -q -c 0 sset Master toggle")
             end,
             "Toggle mute"),
   awful.key({}, "#173", function () awful.util.spawn("mocp -r") end,
             "Previous song"),
   awful.key({}, "#171", function () awful.util.spawn("mocp -f") end,
             "Next song"),
   awful.key({}, "#172", function () awful.util.spawn("mocp -G") end,
             "Toggle playback"),
   awful.key({}, "#174", function () awful.util.spawn("mocp -s") end,
             "Stop playback")
)

-- CLIENT KEYBINDINGS

clientkeys = awful.util.table.join(
   -- Kill client
   awful.key({ modkey, }, "x", function (c) c:kill() end),
   -- Qu'est-que fuck?
   awful.key({ modkey, }, "s", awful.client.movetoscreen),
   awful.key({ modkey, }, "b",
             function (c)
                if   c.titlebar then awful.titlebar.remove(c)
                else awful.titlebar.add(c, { modkey = modkey })
                end
             end),
   -- The client currently has the input focus, so it cannot be
   -- minimized, since minimized clients can't have the focus.
   awful.key({ modkey,  }, "n", function (c) c.minimized = true end),
   awful.key({ modkey,  }, "m",
             function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
             end),
   awful.key({ modkey,  }, ",",
             function (c)
                c:swap(awful.client.getmaster())
             end),
   awful.key({ modkey,  }, ".",
             function (c)
                c.fullscreen = not c.fullscreen
             end),
   awful.key({ modkey,  }, "/", awful.client.floating.toggle)
   -- awful.key({ modkey,  }, "t",
   --          function (c) c.ontop = not c.ontop end),
   -- awful.key({ modkey,  }, "a", function (c) c:redraw() end),
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
   globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey            }, "#" .. i + 9,
                  function ()
                     local screen = mouse.screen
                     if tags[screen][i] then
                        awful.tag.viewonly(tags[screen][i])
                     end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                     local screen = mouse.screen
                     if tags[screen][i] then
                        awful.tag.viewtoggle(tags[screen][i])
                     end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                     if client.focus and tags[client.focus.screen][i] then
                        awful.client.movetotag(tags[client.focus.screen][i])
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                     if client.focus and tags[client.focus.screen][i] then
                        awful.client.toggletag(tags[client.focus.screen][i])
                     end
                  end)
     )
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false,
                     opacity = 0.8 } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true} },
    { rule = { class = "gimp" },
      properties = { floating = true,
                     opacity = 1.0 } },
    { rule = { class = "Firefox" },
      callback = awful.titlebar.add,
      properties = { tag = tags[1][2],
                     opacity = 1.0 } },
    { rule = { class = "URxvt" },
      properties = { opacity = 0.7 } },
    { rule = { class = "Chrome" },
      properties = { tag = tags[1][3],
                     opacity = 1.0 } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal(
    "manage", 
    function (c, startup)
        if awful.client.floating.get(c) then
            awful.titlebar.add(c, { modkey = modkey })
        else
            if c.titlebar then
                awful.titlebar.remove(c)
            end
        end

        -- Enable sloppy focus
        c:add_signal("mouse::enter", 
                     function(c)
                         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         and awful.client.focus.filter(c) then
                         client.focus = c
                     end
                 end)

        if not startup then
            -- Set the windows at the slave,
            -- i.e. put it at the end of others instead of setting it master.
            awful.client.setslave(c)
                      
            -- Put windows in a smart way, only if they don't set an initial position.
            if not c.size_hints.user_position and not c.size_hints.program_position then
                awful.placement.no_overlap(c)
                awful.placement.no_offscreen(c)
            end
        end
    end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

awful.util.spawn_with_shell("xcompmgr -cfF &")
require_safe("autorun")