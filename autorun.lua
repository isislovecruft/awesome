--run_once("redshift", "-o -l 0:0 -b 0.5 -t 6500:6500") -- brightness
--run_once("ibus-daemon", "--xim") -- ibus

-- Fake the WM name to trick Java (from suckless.org) 
--
-- This works because the JVM contains a hard-coded list of known
-- non-re-parenting window managers. For maximum irony, many users prefer to
-- impersonate "LG3D," the non-re-parenting window manager written by Sun, in
-- Java.
run_once("wmname", "LG3D")

-- Turn the screensaver off
--run_once("xset", "s off")

-- Start autocutsel so that we have a $CLIPBOARD:
run_once("autocutsel", "-fork &")
run_once("autocutsel", "-selection PRIMARY -fork &")

-- Start bitcoin daemon
run_once("urxvt", "-e /usr/bin/sudo -i -u bitcoin -- /usr/bin/bitcoind -d -conf=/home/bitcoin/.bitcoin/bitcoin.conf")

-- Start the touchpad disabling daemon
run_once("syndaemon", "-k -d -p /tmp/syndaemon.pid &")

-- Start various programs:
-- Tag ☥:
run_once("conky")

-- Tag ☭:
run_once("firefox")
run_once("urxvt", "-C -geometry 159x48+0-1")

-- Tag ☪:
run_once("chrome")

-- Tag ⚸:
run_once("urxvt", "-name music -title music -geometry 159x48+0-1 -e mocp")

-- Tag ℵ:
run_once("urxvt", "-name wicd-curses -e wicd-curses")
run_once("urxvt", "-name arm -title arm -e /usr/bin/arm")

