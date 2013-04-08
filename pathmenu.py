#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
 pathmenu.py
 -----------
 Create a menu entry for files and directories in the user's $HOME dir. When
 selected, menu entried are opened with their associated default mime
 program.

 @authors: Isis Agora Lovecruft <isis@patternsinthevoid.net> 
           There were other authors; this was taken from the internet
           somewhere...
 @license: WTFPL
 @version: 0.0.1

"""

import os

path = os.getenv("HOME")
editor = os.getenv("EDITOR")
audioplayer = 'mocp -a'
imageviewer = 'feh -.'
terminal = 'urxvt -c'
browser = os.getenv("BROWSER")
menufile = '.config/awesome/my-places-menu.lua'
filetosave = os.path.join(path, menufile)

def test_file_type(file_end):
    if file_end == 'iso':
        return 'wodim'
    elif file_end == 'txt':
        return editor
    elif file_end == 'bak':
        return editor
    elif file_end == "backup":
        return editor
    elif file_end == "gz" \
            or file_end == "xz" \
            or file_end == "zip" \
            or file_end == "z":
        return 'mc'
    elif file_end == "mp3" \
            or file_end == "flac" \
            or file_end == "wav" \
            or file_end == "wma":
        return audioplayer
    elif file_end == 'mp4' \
            or file_end == 'mpeg' \
            or file_end == 'webm' \
            or file_end == 'avi' \
            or file_end == 'ogg' \
            or file_end == 'ogv' \
            or file_end == 'mkv':
        return audioplayer
    elif file_end == 'xml' \
            or file_end == 'html' \
            or file_end == 'htm' \
            or file_end == 'xhtml':
        return browser
    elif file_end == 'py' \
            or file_end == 'cpp' \
            or file_end == 'c' \
            or file_end == 'sh' \
            or file_end == 'txt' \
            or file_end == 'h' \
            or file_end == 'org' \
            or file_end == 'gpg':
        return editor
    elif file_end == 'out' \
            or file_end == 'class' \
            or file_end == 'pyo':
        return terminal
    elif file_end == 'jpg' \
            or file_end == 'png' \
            or file_end == 'gif' \
            or file_end == 'jpeg':
        return imageviewer
    else: return editor

def recursion(path, count):
    likels = os.listdir(path)
    newstuff = 'myplacesmenu[%d] = {\n' % (count)
    output = ''
    count = count * 100
    othercount = count
    type_of_file = ''
    depth_into_string = 0
    for directories in likels:
        if os.path.isdir(path + directories) and not (directories[0] == '.'):
            newstuff += '{[====[' + directories[:12] \
                + ']====], myplacesmenu[%d]},\n' % (count)
            count = count + 1
        elif not (directories[0] == '.'):
            depth_into_string = 0
            type_of_file = ''
            for character in reversed(directories):
                if character == '.':
                    type_of_file = directories[-depth_into_string:]
                    break
                elif depth_into_string >= 6:
                    break
                depth_into_string = depth_into_string + 1
            newstuff += '{[====[' + directories[:12] \
                + ']====], [====[' + test_file_type(type_of_file) \
                + " '" + path + directories + "']====] },\n"
    newstuff += "{'open here', " "'mc ' .. [====['" \
        + path  + "']====]}\n }\n\n"
        
    #recursive call to search directories inside current path
    count = othercount
    for directories in likels:
        if os.path.isdir(path + directories) and not (directories[0] == '.'):
            newstuff = recursion(path + directories + '/', count) + newstuff
            count = count + 1

    return newstuff

if __name__ == '__main__':
    #also specifies starting directory
    print "Writing lua menu generator to: %s" % str(filetosave)
    with open(filetosave, 'w') as fh:
        fh.write('module("myplacesmenu")\n\nmyplacesmenu = {}\n'
                 + recursion(path, 1)
                 + '\npassed = myplacesmenu[1]\nfunction myplacesmenu() return passed end')
