--[[
 * ReaScript Name: Dfk Custom Toolbar Utility
 * About: Script Workspace utility for creating custom toolbars.
 * Author: Dfk
 * Licence: GPL v3
 * REAPER: 6.25
 * Extensions: js_ReaScriptAPI v0.999 (version used in development)
 * Version: 1.05
 * Mod by Edu Serra
--]]
 
--[[
 * Changelog:
 * v0.5 (2020-04-03) 
  +(script release)
 * v0.6 (2020-04-03)
  +(complete overhaul)
 * v0.61 (2020-04-03)
  +(various stuff)
 * v.7 (2020-04-03)
  +.png images for buttons
 * v.8 (2020-04-03)
  +bugs
  +script can be "paused" to reduce cpu usage
  +toggle state
 * v.81 (2020-04-03)
  +bug
  +Added option to set background width and height, and autosize 
 * v.81a (2020-04-03)
  +quick-fix
 * v.81b (2020-04-03)
  +quick-fix
 * v.82 (2020-04-03)
  +tooltip captions after hovering for 3+ seconds
  +automatically bring keyboard focus to arrange view after button/menu activation
 * v.83 (2020-04-03)
  +run multiple instances of the script simultaneously by duplicating, renaming with a unique name, and loading into REAPER.
  +automatically bring keyboard focus to arrange view after button/menu activation (second attempt)
  +'Exit (save)' and 'Exit (discard changes)' added to main menu
  +'Escape' key no longer exits script
 * v.9
    +button folders (with v.9 you will want to install the script into its own designated folder)
  +menu setting to show/hide window titlebar
 * v.95
    +consolidate script files into a single ini file (pre v.95 generated multiple ini files)
  +ability to customize grid line thickness and color
  +tooltips for buttons
  +'exit' buttons may be moved now, and remeber their positions
  +regular buttons now have second, third, and fourth actions depending on their modifier (ex., shift, alt, ctrl, etc)
 * v.96
  +changed move window to shft+left-click (previously ctrl)
  +place tooltip timer in User Area of script (defaulted for 3 seconds)
  +added option to edit 'exit' button sizing (previously exit button could not be modified)
  +fixed bug where images would not be properly saved/loaded to buttons
  +improved how buttons move when snapping is enabled
 * v.97 
    +toggling a button's autosize setting no longer returns it to the size of a grid unit
  +User Area Tool_Tips works now
  +shift&right-click to move buttons
 * v.98 
  +Removed option to 'Exit and Discard Changes,' and removed 'autosize' from menu. (buttons can still be autosized from button edit menus)
  +Showing window titlebar after hiding it displays window 'X' button (https://forum.cockos.com/showpost.php?p=2420622&postcount=1533)
  +Cleaned up coding (potential performance increase) and increased script fail-safes
  +Fixed erratic placement of new buttons when snapping is enabled
 * v.98a
  +Worked on issue with titlebar flickering
  +Assigning new grid size now properly 'snaps' existing buttons
  +Support for .ico files for button images
 * v.99
  +Text is now enabled for buttons with images (can be disabled by setting transparency to 0)
  +Text color and alpha (transparency) can now be set for buttons
  +Buttons now remember their positions from between changing grid sizes
 * v.991
  +multi line text support for buttons (# separates lines)
 * v.992
  +Font size minimum now lower (5)
  +Text multi-line vertical spacing variable available in script User Area
  +Ini now saves in a more readable format
  +Delete button folders now reflects in ini file
 * v.993
  +Scrolling!
 * v.994  
  +Removed a few scrolling bugs
  +Option to hide vertical and horizontal scrollbars in the User Area
  +Ability to insert FX onto tracks by buttons actions ('FX' + fxname; FX ReaEq)
  +Autosizing works better with multi-line buttons now
 * v.994a
   +Reworked multi-line text positioning
  +Worked on scrollbar/button movement issues
 * v.995
  +Removed option to remove titlebar while docked (https://forum.cockos.com/showpost.php?p=2426741&postcount=244)
  +Background color now saves (https://forum.cockos.com/showpost.php?p=2426807&postcount=250)
  +Increased capability of internal folder deletion (ini)
  +Added User Area option to Not Duplicate FX
  +Added donate option to appease grandfougue
 * v.996
  +Added User Area option to disable mousewheel scrolling, invert mousewheels, and to add custom modifiers (shift, alt/opt, cmd/ctrl)
  +Added User Area option to snap buttons to their positions permanently
  +Now option in menu to duplicate last button created
  +Can now lock scrollbars by right-clicking
  +Marquee buttons (delete and move multiple buttons at once)
* v.997
  +Fixed bug with scrollbars
  +Fixed bug with menu buttons not working/positioning correctly
  +Button edit menu options now respect marquee selection
  +Added help documentation pertaining to adding JSFX (https://forum.cockos.com/showpost.php?p=2427960&postcount=322)
  +Background img, color, width/height now save per folder (instead of globally)
  +Now can scroll by clicking middle-mouse scrollwheel (and can disable in User Area)
  +Now new button creation will suggest last used width/height settings (if applicable)
 * v.998
  +Fixed issue with scrollbars visuals not updating correctly
  +Changed default grid line color to dope
  +When inserting FX, add new track if none selected
  +Tooltips now only popup for buttons created (https://forum.cockos.com/showpost.php?p=2428415&postcount=337)
  +Popup window!
 * v.998A
  +Bug invoked when enabling popup while script is docked  
 * v.999
  +Window can now be resized whether titlebar is showing or not
  +Fixed crash when using menu buttons and clicking off-menu
  +Grid size minimum decreased to 3
  +User Area: option to show/hide image button border outlines
  +User Area: Name variable for running multiple script instances simultaneously
  +Reworked multiline spacing (again) added another User Area option to adjust vertical
  +Large rework on popup feature
 * v1.01
  +New Feature: Button duplication by marquee
  +Feature previously called "Button Duplication" now called Button Matrix Duplication, and follows button selection
 * v1.02
  +New Feature: Un/lock scrolling from menu
  +New Feature: Un/lock window resizing
  +Removed script 'Pause' feature
  +User can now show/hide grid and enable/disable snap separately
  +Reorganized main action menu
 * v1.03
  +Fixed issue with image button outlines not showing
  +Separated button edit menu font color/font transparency items
  +New Button Customization item: New button text color default
  +Script now saves entirely to .ini
  +Moving buttons no longer scrolls when scrolling is disabled
  +Buttons now show actions states (only for 1st action slot)
  +Script now simply needs to be duplicated and loaded into REAPER to run multiple instances in REAPER
  +Removed crash when empty lines in .ini file
  +Load/save configuration options now in main menu
  +Window auto refocuses when mouse leaves script window (can be disabled in User Area)
 * v1.04
  +Can hide scrollbars from global options now (removed from User Area)
  +Fixed bug with scrollbars and popup window (aesthetic only)
  +Fixed problem with Load Configuration
 * v1.05
  +Vertical buttons! (only for standard and folder buttons, no menu buttons)
  +Fixed problem with font size not loading when loading configuration
  +Fixed problem with image buttons not colorizing their states
  +Buttons 'flash' when clicked (can be disabled by setting titled 'Babag' in User Area)
  
  
  
  Stuff to do/requests:
  +folder directory
  +add track template
  +grid aspect ratio
  +contextual toolbar settings (probably not .997)
  
  
These characters aren't allowed in user input
# : grayed out
! : checked
> : this menu item shows a submenu
< 
--]]

local VERSION = 1.05

function msg(param, clr) if clr then reaper.ClearConsole() end reaper.ShowConsoleMsg(tostring(param).."\n") end function up() reaper.UpdateTimeline() reaper.UpdateArrange() end 
function emsg(param) reaper.MB(param,"[error]",0) end function omsg(param, param2) reaper.MB(param,"["..param2.."]",0) end

--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA
--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA
--
-- window and grid
local Grid_Width                        = 355    -- 1980+: pixel width of toolbar grid/real estate. This is also the maximum window width
local Grid_Height                       = 1780    -- 1080+: pixel height of toolbar grid/real estate. This is also the maximum window height
local Window_Width_Minimum              = 355     -- 1+: minimum window width in pixels
local Window_Height_Minimum             = 750     -- 1+: minimum window height in pixels
local Reset_Window_Position             = false   -- true/false: if you ever 'lose' your window, change this variable to true
local Auto_Refocus                      = false    -- true/false: whether window focus goes back to main automatically when using script
local Refocus_to_Main                   = true   -- true/false: whether to refocus to main, or window under cursor if false
-- text, font, and menus
local Menu_Correction                   = 22.5    -- 22.5: adjust by small values to adjust the y-positioning of the Up-Menu
local Tool_Tips                         = false    -- true/false: whether or not 'tooltips' are enabled for the script
local Font_Type                         = "Arial" -- "Arial": "Times New Roman", "Helvetica" etc.
local Tooltip_Timer                     = 3       -- 1+: amount of seconds hovering over button before tooltip appears
local Text_Vertical_Spacing             = 0       -- -10+: vertical spacing in between multiple text lines in buttons
local Text_Vertical_Nudge               = 0       -- -10+: adjust where text begins vertically in a button (only adjust if needed) 
local Vertical_Text_Spacing             = 3      -- 0+: amount of spacing between vertical text
-- scrolling, mousewheel, and scrollbars
local Drag_Scroll_Speed                 = 7       -- 1+: the speed in which dragging a button near the confines of the window scrolls the window
local Marquee_Scroll_Speed              = 15      -- 1+: how fast the window scrolls when using the marquee feature
local Disable_Mousewheel_Scrolling      = true   -- true/false: whether or not mousewheel scrolling is disabled
local Disable_Middle_Mouse_Scrolling    = true   -- true/false: whether or not middle mousewheel scrolling is disabled
local Mousewheel_Scroll_Sensitivity     = .25     -- .1+: adjusts how sensitive mousewheel scrolling is (increase for more sensitivity)
local Vertical_Scroll_Modifier          = 0       -- choose a mousewheel modifier for vertical scrolling:   0=none, 4=control/cmd, 8=shift, 16=alt/opt 
local Horizontal_Scroll_Modifier        = 0       -- choose a mousewheel modifier for horizontal scrolling: 0=none, 4=control/cmd, 8=shift, 16=alt/opt 
local Invert_Vertical_Mousewheel        = false   -- true/false: whether to invert vertical scrolling mousewheel
local Invert_Horizontal_Mousewheel      = false   -- true/false: whether to invert horizontal scrolling mousewheel
-- colors and visuals
local Show_Image_Button_Outline         = false   -- true/false: whether to show/hide image button border outlines
local Babag                             = true    -- true/false: whether buttons 'flash' when clicked
-- miscellaneous
local Hiding_Window_Threshold           = 60      -- 1+: the number of pixels which triggers a 'hiding' window to show
local Hiding_Window_Movement_Speed      = 20      -- 1+: the speed at which the hiding window moves
local Do_Not_Duplicate_FX               = false    -- true/false: If true, when FX will only add to a track if non-existing. Otherwise the FX is floated 
local Snap_Buttons_Permanently          = true    -- true/false: if false, buttons will remember their unsnapped positions, otherwise snapped positions are permanent
--
--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA
--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA--USER--AREA

-- window vars
function getPath(str) return str:match("(.*[/\\])") end
local is_new_value,filename2,sectionID,cmdID,mode,resolution,val = reaper.get_action_context() 

local filename = getPath(filename2) local NAME = filename2:sub(filename:len()+1) if NAME:lower():find(".lua") then NAME=NAME:sub(1,NAME:len()-4)end 
--local filename = "C:/REAPER/Scripts/Dfk Custom Toolbar Utility (v1.05).lua" 
local NAME = filename2:sub(filename:len()+1) if NAME:lower():find(".lua") then NAME=NAME:sub(1,NAME:len()-4)end 

local V_NAME = NAME
local FOLDER, PFOLDER = "Main", "" --if reaper.HasExtState( V_NAME, "FOLDER") then FOLDER = reaper.GetExtState( V_NAME, "FOLDER") end

local _,_,display_w,display_h = reaper.my_getViewport(0, 0, 0, 0, 0, 0, 0, 0, true )
local window_name = V_NAME
local window = 0
local auto_window = nil
local show_title_bar = true 
local auto_refocus = 0

-- misc vars
local SC_H, SC_V = false, false -- show/hide scrollbars
local window_resizing = "L"
local hiding = "" local sliding = false local W_X, W_Y, W_W, W_H = 0,0,400,400
local default_col, background_col, default_col_text = 8355711, 0, 0
local NEW_folder, GUI_folder, LOAD_folder = true, true, true
local fontSize = 15 
local snap = true
local grid, grid_w, grid_h = 50, Grid_Width, Grid_Height local lineW = 2 local line_col = 16711680 local show_grid = "true"

local backgroundImage, bakw, bakh, BG_stretch = "", 0, 0, "Stretch"
local captioner = {} captioner[0] = Tooltip_Timer captioner[4] = 0 captioner[5] = 0
local counter = -1 
local SAVE = true
local quit = false
local scroll_timer = 0

local pos = 0

function get_iid() counter = counter + 1 return counter end

function replace_text(text, sub_, add) if not text then return text end
  local new = ""
    if text:find(sub_)
  then
    local a, b = text:find(sub_)
    new = text:sub(1, a-1)..add..text:sub(b+1)
  else
    new = nil
  end
  return new or text
end

function split(str, pat) if not str then return str end
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

if GUI_folder
then
--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES
--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES
--
local dClick_time           = 0    -- amount of time that left double-click action must be performed in, by user, in decimal seconds
local font_changes          = false  -- enabling multiple fonts/font changes can greatly increase draw times
local mouseCursor_changes   = false -- dis/en-able multiple mouse cursors in script
local view_zoom_sensitivity = .03   -- sets sensitivity of mousewheel view zoom
--local scroll_mCap         = 64    -- assigns mouse_cap for scrolling view
local set_caption_title     = true  -- determines whether or not object/button captions are displayed in the window title 
--local blur_behind_obj     = true  -- whether to blur behind an object rectangle or not
--
--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES
--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES--MASTER SCRIPT ADJUSTABLE VARIABLES

gui = {}

V_Z     = 1     -- view zoom: a multiplier
V_Z_min = .1    -- view zoom minimum
V_Z_max = 5     -- view zoom maximum

V_S     = .5    -- view scroll sensitivity: a multiplier
V_H     = 0     -- view horizontal scroll: addition/subtraction
V_V     = 0     -- view vertical scroll: addition/subtraction


local click_watch = 0 
local dClick_watch = 0

mouse_cursor = {idx = 1, str = "arrow"} hide = false
mx, my = gfx.mouse_x, gfx.mouse_y
mouseGrab_x, mouseGrab_y = nil, nil
hover = {}
click = ""

sel_o, sel_b, sel_m = nil, nil, nil

-- window vars
local Hreturn, Hleft, Htop, Hright, Hbottom = reaper.BR_Win32_GetWindowRect( reaper.GetMainHwnd() ) 
local return2, left, top, right, bottom 

function set_window_flags()
    if window_resizing ~= "L"
  then
      if show_title_bar == true
    then 
      reaper.JS_Window_SetStyle(window, "CAPTION,SYSMENU") 
    else 
      reaper.JS_Window_SetStyle(window, "POPUP")
    end
  else
      if show_title_bar == true
    then 
      reaper.JS_Window_SetStyle(window, "CAPTION,SYSMENU,SIZEBOX") 
    else 
      reaper.JS_Window_SetStyle(window, "POPUP,SIZEBOX")
    end
  end 
  -- update window
  local retval, left, top, right, bottom = reaper.JS_Window_GetRect( window ) local width, height = get_width(right, left), get_width(bottom, top)
  reaper.JS_Window_Resize( window, width, height+1 ) reaper.JS_Window_Resize( window, width, height+1 ) reaper.JS_Window_SetFocus( window ) reaper.JS_Window_Update( window ) 
end

function scrollbar_alphas(alpha)
  local temper = alpha if gui[2].obj[1].locked == true then temper = .5 end
  -- horizontal
  if SC_H == false then gui[2].obj[1].a = temper  gui[2].obj[1].button[1].a = temper end
  temper = alpha if gui[2].obj[2].locked == true then temper = .5 end
  -- vertical
  if SC_V == false then gui[2].obj[2].a = temper gui[2].obj[2].button[1].a = temper end
end

function get_width(bottom, top)
  if top < 0 and bottom > -1 then return (math.abs(bottom)+math.abs(top)) else return bottom-top end 
end local Hheight, Hwidth = get_width(Hbottom,Htop), get_width(Hright,Hleft) 

function set_window(wi, le, to, wi, he) --set_window( window, left, top, width, height)
  left, top, width, height = le, to, wi, he 
  right, bottom = left+width, top+height
  reaper.JS_Window_SetPosition( window, left, top, width, height)
end

function set_window_rect(wi, le, to, ri, bo, new_width) --set_window_rect( window, left, top, right, bottom)
  left, top, right, bottom = le, to, ri, bo 
  height, width = get_width(bottom,top), get_width(right,left)
  reaper.JS_Window_SetPosition( window, left, top, width, height)
end

function save_window() if sliding == true then return end
  return2, left, top, right, bottom = reaper.BR_Win32_GetWindowRect( window ) if not return2 then return end height, width = get_width(bottom,top), get_width(right,left) 
  W_X, W_Y, W_W, W_H = left, top, width, height
  --msg("SX: "..left) msg("SY: "..top) msg("SW: "..width) msg("SH: "..height)
  reaper.SetExtState( V_NAME, "W_X",  W_X, true )
  reaper.SetExtState( V_NAME, "W_Y",  W_Y, true )
  reaper.SetExtState( V_NAME, "W_W",  W_W, true )
  reaper.SetExtState( V_NAME, "W_H",  W_H, true )
end

function hide_window() mx, my = reaper.GetMousePosition() hide = false

  -- get window info
  return2, left, top, right, bottom = reaper.BR_Win32_GetWindowRect( window ) if not return2 then return end height, width = get_width(bottom,top), get_width(right,left)  
  -- enfore window maximums
  if width > grid_w and reaper.JS_Mouse_GetState(1) == 0 then set_window( window, left, top, grid_w, height)  end 
  if height > grid_h and reaper.JS_Mouse_GetState(1) == 0 then set_window( window, left, top, width, grid_h)  end
  -- if window is docked or popup is disabled, exit function
  if hiding == "" or math.floor(gfx.dock(-1)&1) ~= 0 then return end 

  -- get REAPER window
    --local display_x,display_y,display_w,display_h = reaper.my_getViewport(mx, my, mx+1,my+1, mx, my, mx+1,my+1, false )  
    --local return2, Rleft, Rtop, Rright, Rbottom = reaper.JS_Window_GetRect( reaper.GetMainHwnd() ) if not return2 then return end local Rheight, Rwidth = get_width(Rbottom,Rtop), get_width(Rright,Rleft) 
  local return2, Rleft, Rtop, Rright, Rbottom = reaper.BR_Win32_GetWindowRect( reaper.GetMainHwnd() ) if not return2 then return end local Rheight, Rwidth = get_width(Rbottom,Rtop), get_width(Rright,Rleft) 
  if Rleft < -30000 then Rleft, Rtop, Rright, Rbottom, Rheight, Rwidth = Hleft, Htop, Hright, Hbottom, Hheight, Hwidth return end
  if not Hreturn then Hleft, Htop, Hright, Hbottom, Hheight, Hwidth = Rleft, Rtop, Rright, Rbottom, Rheight, Rwidth Hreturn = true end  
  --check if REAPER window is moving
  local moving = false 
    if Hleft ~= Rleft and Hwidth == Rwidth and Hheight == Rheight or Htop ~= Rtop and Hwidth == Rwidth and Hheight == Rheight -- window is moving (any direction)
  then 
    set_window( window, left-(Hleft-Rleft), top-(Htop-Rtop), width, height) moving = true  
  end
  -- check if REAPER window is stretching
    if Hwidth ~= Rwidth -- window is stretching (x axis)
  then 
      if hiding == "Top" or hiding == "Bottom" 
    then 
      set_window( window, left + (Rleft-Hleft), top, width+(Rwidth-Hwidth), height) 
    end
    if hiding == "Left" then set_window( window, Rleft-width, top, width, height)  end 
    if hiding == "Right" then set_window( window, Rright, top, width, height)  end 
  end
    if Hheight ~= Rheight -- window is stretching (y axis)    
  then  
      if hiding == "Left" or hiding == "Right" 
    then 
      set_window( window, left, top + (Rtop-Htop), width, height+(Rheight-Hheight))  
    end
    if hiding == "Top" then set_window( window, left, Rtop-height, width, height)  end 
    if hiding == "Bottom" then set_window( window, left, Rbottom, width, height)  end 
  end

  -- Detect and perform hiding/showing
    if hiding == "Top"
  then
    -- if clicking, then perform no action
    if reaper.JS_Mouse_GetState(1) ~= 0 or reaper.JS_Mouse_GetState(2) ~= 0 or reaper.JS_Mouse_GetState(64) ~= 0 then goto skip end
    -- pin window to REAPER window 
    if top ~= Rtop then W_Y = Rtop set_window( window, left, W_Y, width, height) end 
    --check if window is outside of bounds and correct
    if width > Rwidth then W_W = Rwidth set_window( window, left, top, W_W, height) end 
    if left < Rleft then W_X = Rleft set_window( window, W_X, top, width, height) end
    if right > Rright then W_X = Rright-width set_window( window, W_X, top, width, height) end 
    -- check if toolbar is hiding
    if my > Rtop+Hiding_Window_Threshold and reaper.JS_Window_FromPoint( mx, my ) ~= window and reaper.JS_Window_FromPoint( mx, my ) ~= captioner[5] then hide = true end 
    if reaper.JS_Window_FromPoint( mx, my ) == captioner[5] then if mx < left or mx > right or my > bottom or my < top then hide = true end end 
    if my < Rtop then hide = true end 
    if mx < left or mx > right then hide = true end 
    -- perform action
      if hide == true -- hide toolbar
    then scrollbar_alphas(0)
      sliding = true local alpha = 0 
      if not Lheight then Lheight =0 end if Lheight ~= height then if height < 1 then height = 1 end alpha = height/W_H  end Lheight = height
      set_window( window, left, top, width, height-Hiding_Window_Movement_Speed ) reaper.JS_Window_SetOpacity( window, "ALPHA", alpha ) 
    else -- show toolbar
        if sliding == true
      then 
        if height > W_H then sliding = false set_window( window, left, top, width, W_H) save_window() update_scrollbar() scrollbar_alphas(1) else height = height+Hiding_Window_Movement_Speed end 
        local alpha = height/W_H if alpha > 1 then alpha = 1 end
        set_window( window, left, top, width, height ) reaper.JS_Window_SetOpacity( window, "ALPHA", alpha )
      end
    end
    ::skip::
    elseif hiding == "Right"
  then
    -- if clicking, then perform no action
    if reaper.JS_Mouse_GetState(1) ~= 0 or reaper.JS_Mouse_GetState(2) ~= 0 or reaper.JS_Mouse_GetState(64) ~= 0 then goto skip end
    -- pin window to REAPER window 
    if left ~= Rright-width then W_X = Rright-width set_window( window, W_X, top, width, height) end 
    --check if window is outside of bounds and correct
    if height > Rheight then W_H = Rheight set_window( window, left, top, width, W_H) end 
    if top < Rtop then W_Y = Rtop set_window( window, left, W_Y, width, height) end
    if bottom > Rbottom then W_Y = Rbottom-height set_window( window, left, W_Y, width, height) end 
    -- check if toolbar is hiding
    if mx < Rright-Hiding_Window_Threshold and reaper.JS_Window_FromPoint( mx, my ) ~= window and reaper.JS_Window_FromPoint( mx, my ) ~= captioner[5] then hide = true end 
    if reaper.JS_Window_FromPoint( mx, my ) == captioner[5] then if mx < left or mx > right or my > bottom or my < top then hide = true end end 
    if mx > Rright then hide = true end 
    if my < top or my > bottom then hide = true end 
    -- perform action
      if hide == true -- hide toolbar
    then scrollbar_alphas(0)
      sliding = true local alpha = 0 
      if not Lwidth then Lwidth =0 end if Lwidth ~= width then if width < 1 then width = 1 end alpha = width/W_W  end Lwidth = width
      set_window( window, left, top, width-Hiding_Window_Movement_Speed, height ) reaper.JS_Window_SetOpacity( window, "ALPHA", alpha ) 
    else -- show toolbar
        if sliding == true
      then  
        if width > W_W then sliding = false set_window( window, left, top, W_W, height) save_window() update_scrollbar() scrollbar_alphas(1) else width = width+Hiding_Window_Movement_Speed end 
        local alpha = width/W_W if alpha > 1 then alpha = 1 end
        set_window( window, left, top, width, height ) reaper.JS_Window_SetOpacity( window, "ALPHA", alpha )
        -- pin window to REAPER window 
        set_window( window, Rright-width, top, width, height) 
      end
    end
    ::skip::
    elseif hiding == "Bottom"
  then
    -- if clicking, then perform no action
    if reaper.JS_Mouse_GetState(1) ~= 0 or reaper.JS_Mouse_GetState(2) ~= 0 or reaper.JS_Mouse_GetState(64) ~= 0 then goto skip end
    -- pin window to REAPER window 
    if top ~= Rbottom-height then W_Y = Rbottom-height set_window( window, left, W_Y, width, height) end 
    --check if window is outside of bounds and correct
    if width > Rwidth then W_W = Rwidth set_window( window, left, top, W_W, height) end 
    if left < Rleft then W_X = Rleft set_window( window, W_X, top, width, height) end
    if right > Rright then W_X = Rright-width set_window( window, W_X, top, width, height) end 
    -- check if toolbar is hiding
    if my < Rbottom-Hiding_Window_Threshold and reaper.JS_Window_FromPoint( mx, my ) ~= window and reaper.JS_Window_FromPoint( mx, my ) ~= captioner[5] then hide = true end 
    if reaper.JS_Window_FromPoint( mx, my ) == captioner[5] then if mx < left or mx > right or my > bottom or my < top then hide = true end end 
    if my > Rbottom then hide = true end 
    if mx < left or mx > right then hide = true end 
    -- perform action
      if hide == true -- hide toolbar
    then scrollbar_alphas(0)
      sliding = true local alpha = 0 
      if not Lheight then Lheight =0 end if Lheight ~= height then if height < 1 then height = 1 end alpha = height/W_H  end Lheight = height
      set_window( window, left, top, width, height-Hiding_Window_Movement_Speed) reaper.JS_Window_SetOpacity( window, "ALPHA", alpha ) 
    else -- show toolbar
        if sliding == true
      then 
        if height >= W_H then sliding = false set_window( window, left, top, width, W_H) save_window() update_scrollbar() scrollbar_alphas(1) else height = height+Hiding_Window_Movement_Speed end 
        local alpha = height/W_H if alpha > 1 then alpha = 1 end
        set_window( window, left, top, width, height) reaper.JS_Window_SetOpacity( window, "ALPHA", alpha )
        -- pin window to REAPER window 
        set_window( window, left, Rbottom-height, width, height) 
      end
    end
    ::skip::
    elseif hiding == "Left"
  then
    -- if clicking, then perform no action
    if reaper.JS_Mouse_GetState(1) ~= 0 or reaper.JS_Mouse_GetState(2) ~= 0 or reaper.JS_Mouse_GetState(64) ~= 0 then goto skip end
    -- pin window to REAPER window 
    if left ~= Rleft then W_X = Rleft set_window( window, W_X, top, width, height)  end 
    --check if window is outside of bounds and correct
    if height > Rheight then W_H = Rheight set_window( window, left, top, width, W_H)  end 
    if top < Rtop then W_Y = Rtop set_window( window, left, W_Y, width, height)  end
    if bottom > Rbottom then W_Y = Rbottom-height set_window( window, left, W_Y, width, height)  end 
    -- check if toolbar is hiding
    if mx > Rleft+Hiding_Window_Threshold and reaper.JS_Window_FromPoint( mx, my ) ~= window and reaper.JS_Window_FromPoint( mx, my ) ~= captioner[5] then hide = true end 
    if reaper.JS_Window_FromPoint( mx, my ) == captioner[5] then if mx < left or mx > right or my > bottom or my < top then hide = true end end 
    if mx < Rleft then hide = true end 
    if my < top or my > bottom then hide = true end 
    -- perform action
      if hide == true -- hide toolbar
    then scrollbar_alphas(0)
      sliding = true local alpha = 0 
      if not Lwidth then Lwidth =0 end if Lwidth ~= width then if width < 1 then width = 1 end alpha = width/W_W  end Lwidth = width
      set_window( window, left, top, width-Hiding_Window_Movement_Speed, height ) reaper.JS_Window_SetOpacity( window, "ALPHA", alpha ) 
    else -- show toolbar
        if sliding == true
      then 
        if width >= W_W then sliding = false set_window( window, left, top, W_W, height) save_window() update_scrollbar() scrollbar_alphas(1) else width = width+Hiding_Window_Movement_Speed end 
        local alpha = width/W_W if alpha > 1 then alpha = 1 end
        set_window( window, left, top, width, height ) reaper.JS_Window_SetOpacity( window, "ALPHA", alpha ) 
      end
    end
    ::skip::
  end

  Hleft, Htop, Hright, Hbottom, Hheight, Hwidth = Rleft, Rtop, Rright, Rbottom, Rheight, Rwidth 
end

function update_marquee()
    for z = 1, #gui[1].obj[1].button 
  do 
    gui[1].obj[1].button[z].ol.r = 1 gui[1].obj[1].button[z].ol.g = 1 gui[1].obj[1].button[z].ol.b = 1 
      for y = 1, #gui[1].obj[1].sel 
    do
      if gui[1].obj[1].sel[y] == z then gui[1].obj[1].button[z].ol.r = 0 gui[1].obj[1].button[z].ol.g = 1 gui[1].obj[1].button[z].ol.b = 0 end  
    end
  end
end

function update_scrollbar()
  if SC_H == false then gui[2].obj[1].button[1].x = (gfx.w-50)*   ( V_H / ((grid_w)-(gfx.w/V_Z)) ) end
  if SC_V == false   then gui[2].obj[2].button[1].y = (gfx.h-70)*   ( V_V / ((grid_h)-(gfx.h/V_Z)) ) end
end

function autosize(button)
    if button.img ~= "" and reaper.file_exists( button.img )
  then
    button.w, button.h = gfx.getimgdim(button.iid) 
  else
      if not button.vt -- horizontal
    then
        if button.txt:find("#")
      then -- multi-line button
        local xm, ym = 0, 0
        local subber = button.txt local counter = 0
        while subber:find("#") do local a, b = gfx.measurestr(subber:sub(1, subber:find("#"))) subber = subber:sub(subber:find("#")+1) counter = counter + 1 if a > xm then xm = a end end 
        counter = counter + 1 local a, ym = gfx.measurestr(subber) if a > xm then xm = a end 
        ym = ((ym+Text_Vertical_Spacing)*counter)+4 xm = xm + 4
        button.w, button.h = xm, ym
      else -- single line button
        local xm, ym = gfx.measurestr(button.txt) xm = xm + 4 
        button.w, button.h = xm, ym
      end
    else -- vertical
      local tX, tY = 0,0
        for t = 1, button.txt:len()
      do
        local myw, myh = gfx.measurestr(button.txt:sub(t,t)) tY = tY + myh - Vertical_Text_Spacing if myw > tX then tX = myw end
      end
      button.w, button.h = tX + 2, tY + 2
    end
  end
end

function sort_obj_levels(tabel) 

  local dup = {}
  for a = 1, #tabel do dup[a] = tabel[a].level end 
  local indexes = {}

  for a = 1, #tabel do indexes[a] = a end 

  table.sort(indexes,function(a,b) return dup[a] < dup[b] end) 
  
  for a = 1, #tabel do dup[a] = tabel[a] end 
  
    for a = 1, #tabel
  do
    tabel[a] = dup[indexes[a]] 
  end
  
  return tabel

end

function view_zoom_and_mousewheel()
    if click == "" 
  then 
      if Disable_Mousewheel_Scrolling == false 
    then
      gfx.mouse_wheel = Mousewheel_Scroll_Sensitivity*gfx.mouse_wheel
      -- scroll horizontally
        if gfx.mouse_wheel ~= 0 and gui[2].obj[1].locked == false
      then
          if Horizontal_Scroll_Modifier == 0 and reaper.JS_Mouse_GetState(4) == 0 and reaper.JS_Mouse_GetState(8) == 0 and reaper.JS_Mouse_GetState(16) == 0
        then
          if Invert_Horizontal_Mousewheel == true then V_H = V_H + gfx.mouse_wheel else V_H = V_H - gfx.mouse_wheel end 
          elseif reaper.JS_Mouse_GetState(Horizontal_Scroll_Modifier) ~= 0
        then
          if Invert_Horizontal_Mousewheel == true then V_H = V_H + gfx.mouse_wheel else V_H = V_H - gfx.mouse_wheel end 
        end
        update_scrollbar()
      end
      
      -- scroll vertically
        if gfx.mouse_wheel ~= 0 and gui[2].obj[2].locked == false
      then
          if Vertical_Scroll_Modifier == 0 and reaper.JS_Mouse_GetState(4) == 0 and reaper.JS_Mouse_GetState(8) == 0 and reaper.JS_Mouse_GetState(16) == 0
        then
          if Invert_Horizontal_Mousewheel == true then V_V = V_V + gfx.mouse_wheel else V_V = V_V - gfx.mouse_wheel end  
          elseif reaper.JS_Mouse_GetState(Vertical_Scroll_Modifier) ~= 0
        then
          if Invert_Horizontal_Mousewheel == true then V_V = V_V + gfx.mouse_wheel else V_V = V_V - gfx.mouse_wheel end  
        end
        update_scrollbar()
      end
      
      if V_V < 0 then V_V = 0 end if V_V > (grid_h-gfx.h) then V_V = (grid_h-gfx.h) end
      if V_H < 0 then V_H = 0 end if V_H > (grid_w-gfx.w) then V_H = (grid_w-gfx.w) end
      
      if gfx.mouse_wheel ~= 0 then update_scrollbar() end
    end
    
  end 
  gfx.mouse_wheel = 0 
end

function fontFlags( str ) if str then local v = 0 for a = 1, str:len() do v = v * 256 + string.byte(str, a) end return v end end

function zoom_and_scroll( x, y, w, h, zoom, scroll, can_snap, fs )

    if snap and can_snap
  then
    x = math.floor(((x/grid)))*grid 
    y = math.floor(((y/grid)))*grid 
  end
  
    if scroll
  then 
    if x then x = x - V_H end
    if y then y = y - V_V end
  end
    if zoom 
  then
    if x then x = x * V_Z end
    if y then y = y * V_Z end
    if w then w = w * V_Z end
    if h then h = h * V_Z end
    if fs then fs = fs * V_Z end
  end

  return x, y, w, h, fs

end

function check_mouse() --if hiding ~= "" and hide == true then return end

  mx, my = gfx.mouse_x, gfx.mouse_y local mmx, mmy = reaper.GetMousePosition() if duplicator then return end -- set 'click' to check-mode

  -- check/set hover states
    if click == "" and not hover[3]
  then
  
    hover = {} local once = false -- clear hover state and 'once' detection variable
    --[0] 'gui'
    --[1] 'obj'
    --[2] 'button'
    --[3] 'clicked mouse_cap'
    --[4] 'clicked function index'
  
    for g = 1, #gui do local obj = gui[g].obj for o = 1, #obj do if obj[o].hc then obj[o].hc = 0 for b = 1, #obj[o].button do if obj[o].button[b].hc then obj[o].button[b].hc = 0 end end end end end -- clear object/button current hover states
  
      for g = #gui, 1, -1
    do local obj = gui[g].obj
        for o = #obj, 1, -1
      do if not obj[o] then goto skip_object1 end local ax, ay, aw, ah = zoom_and_scroll( obj[o].x, obj[o].y, obj[o].w, obj[o].h, obj[o].can_zoom, obj[o].can_scroll, obj[o].can_snap ) 
        -- check/set hover for buttons (button hover has priority over object hover)
          for b = #obj[o].button, 1, -1 
        do obj[o].button[b].hc = 0 -- reset hover
          local ax,ay,aw,ah = zoom_and_scroll( obj[o].x+obj[o].button[b].x, obj[o].y+obj[o].button[b].y,obj[o].button[b].w, obj[o].button[b].h, obj[o].button[b].can_zoom, obj[o].button[b].can_scroll, obj[o].button[b].can_snap ) 
            if mx > ax and mx < ax+aw and my > ay and my < ay+ah 
          then  
              if obj[o].button[b].act_off ~= 2
            then
                if set_caption_title == true -- set title and set hover  
              then 
                  if obj[o].button[b].caption == ""
                then
                  if reaper.JS_Window_GetTitle(window) ~= window_name then reaper.JS_Window_SetTitle( window, window_name ) end
                else 
                  if reaper.JS_Window_GetTitle(window) ~= window_name.." ("..obj[o].button[b].caption..")" then reaper.JS_Window_SetTitle( window, window_name.." ("..obj[o].button[b].caption..")" ) end
                end
              end  
                if Tool_Tips == true
              then
                  if captioner[1] == nil and captioner[2] == nil 
                then 
                  captioner[1] = mmx captioner[2] = mmy captioner[3] = reaper.time_precise() + captioner[0]
                else
                  if captioner[1] ~= mmx or captioner[2] ~= mmy then captioner[1] = nil captioner[2] = nil captioner[4] = 0 end 
                end
                  if captioner[1] and captioner[2] and captioner[3] and reaper.time_precise() > captioner[3] and captioner[4] == 0
                then captioner[4] = 1
                  reaper.TrackCtl_SetToolTip( obj[o].button[b].caption, mmx+12, mmy, 1 )
                  captioner[5] = reaper.JS_Window_Find( obj[o].button[b].caption, false ) 
                end
              end
              once = true for z = 1, #obj do if obj[z].hc then obj[z].hc = 0 for y = 1, #obj[z].button do if obj[z].button[y].hc then obj[z].button[y].hc = 0 end end end end 
              obj[o].button[b].hc = 1 hover[0] = g hover[1] = o hover[2] = b break
            end
          end
        end
        -- check/set hover for object (only if there is no button hovering)
          if mx > ax and mx < ax+aw and my > ay and my < ay+ah and once == false 
        then 
            if obj[o].act_off ~= 2
          then 
              if set_caption_title == true -- set title and set hover  
            then 
                if obj[o].caption == ""
              then
                if reaper.JS_Window_GetTitle(window) ~= window_name then reaper.JS_Window_SetTitle( window, window_name ) end
              else
                  if captioner[1] == nil and captioner[2] == nil 
                then 
                  captioner[1] = mmx captioner[2] = mmy captioner[3] = reaper.time_precise() + captioner[0]
                else
                  if captioner[1] ~= mmx or captioner[2] ~= mmy then captioner[1] = nil captioner[2] = nil end 
                end
                  if captioner[1] and captioner[2] and captioner[3] and reaper.time_precise() > captioner[3] 
                then
                  --reaper.TrackCtl_SetToolTip( obj[o].caption, mmx+12, mmy, 1 ) 
                end
                if reaper.JS_Window_GetTitle(window) ~= window_name.." ("..obj[o].caption..")" then reaper.JS_Window_SetTitle( window, window_name.." ("..obj[o].caption..")" ) end
              end
            end  
            once = true for z = 1, #obj do if obj[z].hc then obj[z].hc = 0 end end hover[0] = g obj[o].hc = 1 hover[1] = o                                                                   -- set hover
          end
        end
        if once == true then break end
        ::skip_object1::
      end
      if once == true then break end
    end
    
    if once == false and set_caption_title == true and window ~= 0 and reaper.JS_Window_GetTitle(window) ~= window_name then reaper.JS_Window_SetTitle( window, window_name ) end                                                                -- if no hover, set title to window_name
  end

  -- clicking + actions (hover[3] holds "clicked" mouse_cap, hover[4] holds "clicked" function index)
    if hover[1]
  then local o = hover[1] local b = hover[2] local m = 0 local obj = gui[hover[0]].obj
      if not hover[3]
    then
        if not b -- if object
      then
          for mc = 1, #obj[o].mouse
        do 
          if obj[o].act_off then break end           -- enforce act_off
          local mouse_cap = gfx.mouse_cap 
          if mouse_cap == obj[o].mouse[mc] then hover[3] = mouse_cap hover[4] = mc break end 
        end
      else        -- if object button
          for mc = 1, #obj[o].button[b].mouse
        do 
          if obj[o].button[b].act_off then break end -- enforce act_off
          local mouse_cap = gfx.mouse_cap 
          if mouse_cap == obj[o].button[b].mouse[mc] then hover[3] = mouse_cap hover[4] = mc break end 
        end
      end
    end
    
      if hover[3] and click ~= "done" 
    then m = hover[4]
        if gfx.mouse_cap == hover[3]
      then
    
          if not b -- if object is clicked (and not button)
        then
          ----------------------------------------
          if not sel_o then sel_o, sel_m = o, m mouseGrab_x, mouseGrab_y = mx, my end
          obj[o].hc = 2 -- set hover status
            if not obj[o].func[0] or m ~= 1
          then
              if click == "" -- if object has no dclick action
            then
              obj[o].func[m](obj[o],o) dClick_watch = 0 if not obj[o].hold[m] then click = "done" end 
            end
          end
            if obj[o].func[0] and click ~= "done" 
          then
              if click == "dclick"
            then
              sel_m = 0 obj[o].func[0](obj[o],o) click = "done" dClick_watch = -1
            elseif click == ""
            then
              dClick_watch = reaper.time_precise()+dClick_time  click = "delay"  
            end
              if obj[o].hold[m] and reaper.time_precise() > dClick_watch and click ~= "done"
            then
              obj[o].func[m](obj[o],o) click = "hold" dClick_watch = -1
            end
          end
            if obj[o].hold[m] and m ~= 1 and click ~= "done"
          then
            obj[o].func[m](obj[o],o) click = "hold"
          end
          if m ~= 1 or not obj[o].func[0] then dClick_watch = -1 end 
          ----------------------------------------
        else        -- if object button is clicked
          ----------------------------------------
          if not sel_o then sel_o, sel_b, sel_m = o, b, m mouseGrab_x, mouseGrab_y = mx, my end
          obj[o].button[b].hc = 2 -- set hover status
            if not obj[o].button[b].func[0] or m ~= 1
          then
              if click == "" -- if object button no dclick action
            then
              obj[o].button[b].func[m](obj[o].button[b],o,b) dClick_watch = 0 if not obj[o].button[b].hold[m] then click = "done" end 
            end
          end
            if obj[o].button[b].func[0] and click ~= "done" 
          then
              if click == "dclick"
            then
              sel_m = 0 obj[o].button[b].func[0](obj[o].button[b],o,b) click = "done" dClick_watch = -1
            elseif click == ""
            then
              dClick_watch = reaper.time_precise()+dClick_time  click = "delay"  
            end
              if obj[o].button[b].hold[m] and reaper.time_precise() > dClick_watch and click ~= "done"
            then
              obj[o].button[b].func[m](obj[o].button[b],o,b) click = "hold" dClick_watch = -1
            end
          end
            if obj[o].button[b].hold[m] and m ~= 1 and click ~= "done"
          then
            obj[o].button[b].func[m](obj[o].button[b],o,b) click = "hold"
          end
          if m ~= 1 or not obj[o].button[b].func[0] then dClick_watch = -1 end 
          ----------------------------------------
        end
        
      end -- if gfx.mouse_cap == hover[3]
      
    end -- if hover[3]
  
  end -- if hover[1]

  -- dClick_watch < reaper.time_precise()
  
    if hover[3] --(hover[3] holds "clicked" mouse_cap, hover[4] holds "clicked" function index)
  then
    -- check for m_rel
    local rel_check = false 
      if gui[hover[0]].obj[hover[1]].m_rel and not sel_b
    then
      if gui[hover[0]].obj[hover[1]].m_rel[hover[4]] then if gfx.mouse_cap&gui[hover[0]].obj[hover[1]].m_rel[hover[4]] ~= hover[3] then rel_check = true end end 
      elseif hover[2] and gui[hover[0]].obj[hover[1]].button[hover[2]].m_rel 
    then 
      if gui[hover[0]].obj[hover[1]].button[hover[2]].m_rel[hover[4]] then if gfx.mouse_cap&gui[hover[0]].obj[hover[1]].button[hover[2]].m_rel[hover[4]] ~= hover[3] then rel_check = true end end 
    end 
    -----------------
      
      if gfx.mouse_cap&hover[3] ~= hover[3] or rel_check == true
      --if gfx.mouse_cap ~= hover[3] or rel_check == true
    then 
        if dClick_watch < reaper.time_precise()
      then
          if sel_o
        then local obj = gui[hover[0]].obj
            if not sel_b -- if object was clicked
          then
            if dClick_watch ~= -1 then 
            obj[sel_o].func[sel_m](obj[sel_o],sel_o, nil, 1) end obj[sel_o].func[sel_m](obj[sel_o],sel_o, 1)
          else             -- if object button was clicked
            if dClick_watch ~= -1 then obj[sel_o].button[sel_b].func[sel_m](obj[sel_o].button[sel_b],sel_o, sel_b, nil, 1) end 
            obj[sel_o].button[sel_b].func[sel_m](obj[sel_o].button[sel_b],sel_o, sel_b, 1)
          end
        end
        dClick_watch = 0 hover = {} click = "" sel_o, sel_b, sel_m = nil, nil, nil
      else
        click = "dclick" 
      end
    end
  end


end -- end of check_mouse

function draw() 
    for g = 1, #gui
  do local obj = gui[g].obj
      for o = 1, #obj
    do local object = obj[o] if not object then goto skip_object end 
      -- draw objects
      gfx.set( object.r,object.g,object.b,object.a )
      if object.hc == 1 then     gfx.a = gfx.a - object.ha                                                             -- if mouse if hovering draw alpha 
      elseif object.hc == 2 then gfx.a = gfx.a - object.hca end                                                        -- if clicking draw alpha
      local xp, yp, wa, ha = zoom_and_scroll( object.x, object.y, object.w, object.h, object.can_zoom, object.can_scroll, object.can_snap )
      if object.blur_under then gfx.x, gfx.y = xp, yp gfx.blurto( xp+wa,yp+ha ) end                                    -- blur under                                                     
      gfx.rect( xp, yp, wa, ha, object.f )                                                                             -- draw rectangle *(see end of for loop)*
      -- draw statics
        for s = 1, #object.static 
      do local static = object.static[s] local xp, yp, wa, ha, fs = zoom_and_scroll( object.x+static.x, object.y+static.y, static.w, static.h, static.can_zoom, static.can_scroll, static.can_snap, static.fs ) 
        gfx.set( static.r,static.g,static.b,static.a ) 
          if static.type == "line"
        then 
          gfx.line(xp,yp,static.xx,static.yy,static.aa )                                                           -- draw line
          elseif static.type == "rect"
        then 
          gfx.rect( xp,yp,wa,ha,static.f )                                                                         -- draw rectangle
          gfx.set( static.ol.r,static.ol.g,static.ol.b,static.ol.a ) gfx.rect( xp,yp,wa,ha,0 )                     -- draw rectanle outline
          elseif static.type == "text"
        then
          if font_changes == true then gfx.setfont( 1,static.fo,fs,fontFlags(static.ff) ) end                      -- if font_changes = true then set font
          local subber = static.txt                                                                                -- resize title to fit button
            if gfx.measurestr( subber ) > wa 
          then                                         
            while gfx.measurestr( subber ) > wa do subber = string.sub(subber,1,string.len(subber)-1) if string.len(subber) == 0 then break end end 
            subber = string.sub(subber,1,string.len(subber)-3) subber = subber.."..."  
          end
          gfx.x, gfx.y = xp, yp gfx.drawstr( subber,static.th|static.tv,xp+wa,yp+ha )                              -- draw text
          elseif static.type == "circ"
        then
          gfx.circle( xp+static.rs,yp+static.rs,static.rs,static.f,static.aa )                                     -- draw circle
          gfx.set( static.ol.r,static.ol.g,static.ol.b,static.ol.a )
          gfx.circle( xp+static.rs,yp+static.rs,static.rs,0,static.aa )                                            -- draw circle outline
        end
      end -- for s 
      -- draw buttons
        for b = 1, #object.button
      do 
        --snap buttons permanently
          if Snap_Buttons_Permanently == true and snap == true and object.button[b].can_snap
        then
          object.button[b].x = math.floor(((object.button[b].x/grid)))*grid 
          object.button[b].y = math.floor(((object.button[b].y/grid)))*grid 
        end
        -- rectify positions per scroll and zoom
        local button = object.button[b] local xp, yp, wa, ha, fs = zoom_and_scroll( object.x+button.x, object.y+button.y, button.w, button.h, button.can_zoom, button.can_scroll, button.can_snap, button.fs ) 
        -- draw rect
        gfx.set( button.r,button.g,button.b,button.a ) 
        if button.hc == 1 then     gfx.a = gfx.a - button.ha                                                         -- if mouse if hovering draw alpha 
        elseif button.hc == 2 then gfx.a = gfx.a - button.hca end                                                    -- if clicking draw alpha
          if button.type == "rect"
        then 
          gfx.rect( xp,yp,wa,ha,button.f )                                                                         -- draw rectangle
          gfx.set( button.ol.r,button.ol.g,button.ol.b,button.ol.a ) gfx.rect( xp,yp,wa,ha,0 )                     -- draw rectangle outline
          if button.action and button.action[1] or Babag == true and button.hc == 2 then if Babag == true and button.hc == 2 or reaper.GetToggleCommandState(reaper.NamedCommandLookup(button.action[1])) == 1 then gfx.set( 0,1,0,.3 ) gfx.rect( xp,yp,wa,ha,button.f ) end end --show toolbar state
          elseif button.type == "circ"
        then
          xp, yp, wa, ha, fs = zoom_and_scroll( object.x+button.x+button.rs, object.y+button.y+button.rs, button.rs, button.h, button.can_zoom, button.can_scroll, button.can_snap, button.fs )
          gfx.circle( math.floor(xp),math.floor(yp),math.floor(wa),button.f,button.aa )                            -- draw circle
          gfx.set( button.ol.r,button.ol.g,button.ol.b,button.ol.a )
          gfx.circle( math.floor(xp),math.floor(yp),math.floor(wa),0,button.aa )                                   -- draw circle outline
          elseif button.type == "img"
        then 
          gfx.blit(button.iid,1,0,0,0,button.iw,button.ih,xp,yp,button.w,button.h)                                 -- draw image
          if Show_Image_Button_Outline == true or button.ol.r == 0 then gfx.set( button.ol.r,button.ol.g,button.ol.b,button.ol.a ) gfx.rect( xp,yp,wa,ha,0 ) end                     -- draw rectangle outline
          if button.action and button.action[1] or Babag == true and button.hc == 2 then if Babag == true and button.hc == 2 or reaper.GetToggleCommandState(reaper.NamedCommandLookup(button.action[1])) == 1 then gfx.set( 0,1,0,.2 ) gfx.rect( xp,yp,wa,ha,button.f ) end end --show toolbar state
        end
        -- draw text
          if button.txt ~= "" --and button.type ~= "img"
        then
            if not button.vt -- horizontal text
          then
            gfx.set( button.rt,button.gt,button.bt,button.at ) gfx.x, gfx.y = xp, yp
            if font_changes == true then gfx.setfont( 1,button.fo,fs,fontFlags(button.ff) ) end                      -- if font_changes = true then set font
            local subber = button.txt                                                                                -- resize title to fit button

            local texter = {} texter[0] = true local myw, myh = gfx.measurestr("Hello")
              while texter[0] == true
            do local tx = #texter+1 
                if subber:find("#")
              then
                texter[tx] = subber:sub(1, subber:find("#")-1) 
                subber = subber:sub(subber:find("#")+1)  
              else
                texter[tx] = subber texter[0] = false
              end
              -- trim text horizontally
                if gfx.measurestr( texter[tx] ) > wa 
              then                                         
                while gfx.measurestr( texter[tx] ) > wa do texter[tx] = string.sub(texter[tx],1,string.len(texter[tx])-1) if string.len(texter[tx]) == 0 then break end end 
                texter[tx] = string.sub(texter[tx],1,string.len(texter[tx])-3) texter[tx] = texter[tx].."..."  
              end
              -- trim text vertically
              if (myh + Text_Vertical_Spacing) * tx > ha then texter[tx] = nil end

            end
            
            -- draw text
            local slot = myh + Text_Vertical_Spacing
            local excess = ha-(slot*#texter) 
            gfx.y = yp + math.floor((excess/2)+.5) + Text_Vertical_Nudge 
              for dr = 1, #texter
            do
              local myw, _ = gfx.measurestr(texter[dr])
              gfx.x = xp+((wa/2)-(myw/2)) if dr > 1 then gfx.y = gfx.y + slot end 
              gfx.drawstr( texter[dr] )
            end

            gfx.x, gfx.y = xp, yp
          else -- vertical text
            gfx.set( button.rt,button.gt,button.bt,button.at ) gfx.x, gfx.y = xp, yp 
            local subb = "" local tY = 0
              for t = 1, button.txt:len()
            do
              if tY < ha then local myw, myh = gfx.measurestr(button.txt:sub(t,t)) tY = tY + myh - Vertical_Text_Spacing subb=subb..button.txt:sub(t,t) else break end
            end
            gfx.y = yp + (ha/2) - ((tY-Vertical_Text_Spacing)/2)
              for t = 1, subb:len()
            do
              local myw, myh = gfx.measurestr(subb:sub(t,t))
              gfx.x = xp+(wa/2)-(myw/2)
              gfx.drawstr(subb:sub(t,t))
              gfx.y = gfx.y + (tY-Vertical_Text_Spacing)/subb:len()
            end
          end
        end
        -- draw statics
          if button.static 
        then 
            for s = 1, #button.static 
          do local static = button.static[s] local xp, yp, wa, ha, fs = zoom_and_scroll( object.x+static.x, object.y+static.y, static.w, static.h, static.can_zoom, static.can_scroll, static.can_snap, static.fs ) 
            gfx.set( static.r,static.g,static.b,static.a ) 
              if static.type == "line"
            then 
              gfx.line(xp,yp,static.xx,static.yy,static.aa )                                                   -- draw line
              elseif static.type == "rect"
            then 
              gfx.rect( xp,yp,wa,ha,static.f )                                                                 -- draw rectangle
              gfx.set( static.ol.r,static.ol.g,static.ol.b,static.ol.a ) gfx.rect( xp,yp,wa,ha,0 )             -- draw rectanle outline
              elseif static.type == "text"
            then
              if font_changes == true then gfx.setfont( 1,static.fo,fs,fontFlags(static.ff) ) end              -- if font_changes = true then set font
              local subber = static.txt                                                                                -- resize title to fit button
                if gfx.measurestr( subber ) > wa 
              then                       
                while gfx.measurestr( subber ) > wa do subber = string.sub(subber,1,string.len(subber)-1) if string.len(subber) == 0 then break end end 
                subber = string.sub(subber,1,string.len(subber)-3) subber = subber.."..."  
              end 
              gfx.x, gfx.y = xp, yp gfx.drawstr( subber,static.th|static.tv,xp+wa,yp+ha )                      -- draw text
              elseif static.type == "circ"
            then
              gfx.circle( xp+static.rs,yp+static.rs,static.rs,static.f,static.aa )                             -- draw circle
              gfx.set( static.ol.r,static.ol.g,static.ol.b,static.ol.a )
              gfx.circle( xp+static.rs,yp+static.rs,static.rs,0,static.aa )                                    -- draw circle outline
            end
          end -- for s 
        end
      end -- for b
      gfx.set( object.ol.r,object.ol.g,object.ol.b,object.ol.a ) gfx.rect( xp, yp, wa, ha,0 )                          -- *draw rectangle outline*
      ::skip_object::
    end -- for o
  end -- for g

  if mouseCursor_changes == true then gfx.setcursor( mouse_cursor.idx, mouse_cursor.str ) end -- if multile mouse cursor are enabled in script, then set accordingly

end --draw()

end -- end of GUI folder

function new_button(id, x, y, w, h, r, g, b, img, iid, iw, ih, txt, name, action, typer, caption, folderid, prev_folderid) --DEFINE BUTTON
  local duplicate_button = #gui[1].obj[1].button+1
  gui[1].obj[1].button[duplicate_button] = {
  folderid   = folderid,                                         -- folder id
  prev_fold  = prev_folderid,                                    -- previous folder id
  img        = img,                                              -- button image directory
  id         = id,                                               -- type of button
  iid        = iid,                                              -- image source id
  action     = action,                                           -- action (table)
  name       = name,                                             -- name (table)
  caption    = caption,                                          -- caption display
  type       = typer,                                            -- draw type: "rect" or "circ"
  ol         = {r=1,g=1,b=1,a=1},                                -- rect: button's outline
  hc         = 0,                                                -- current hover alpha (default '0')
  ha         = .2,                                               -- hover alpha
  hca        = .3,                                               -- hover click alpha 
  r          = r,                                                -- r
  g          = g,                                                -- g
  b          = b,                                                -- b
  a          = 1,                                                -- a
  rt         = 0,                                                -- r     (text)
  gt         = 0,                                                 -- g     (text)
  bt         = 0,                                                -- b     (text)
  at         = 1,                                                -- alpha (text)
  x          = x,                                                -- x
  y          = y,                                                -- y
  w          = w,                                                -- w
  h          = h,                                                -- h
  iw         = iw,                                               -- image width
  ih         = ih,                                               -- image height
  f          = 1,                                                -- filled
  rs         = 10,                                               -- circle: radius
  aa         = true,                                             -- circle: antialias         
  txt        = txt,                                              -- text: "" disables text for button                                 
  th         = 1,                                                -- text 'h' flag
  tv         = 4,                                                -- text 'v' flag  
  fo         = "Roboto",                                          -- font settings will have no affect unless: font_changes = true
  fs         = fontSize,                                         -- font size
  ff         = nil,                                              -- font flags ("b", "i", "u" = bold, italic, underlined. Flags can be combined, or value can be nil)
  can_zoom   = false,                                            -- whether object rectangle zooms with global: font_changes must be true in order for font size to adjust
  can_scroll = true,                                             -- whether object rectangle scrolls with global  
  can_snap   = true,                                             -- whether object is capable of snapping 
  static     = {},                                               -- index of static graphics that object holds
  func       = 
    { -- functions receive object index and bool release ('r')
    -- always-run function
    [-1]      = function(self,g,o,b) end, 
    -- non-indexed function
    [0]      = function(self,o,b,r,d) if r then return else end end, 
    -- mouse_cap functions
    [1]      = 
    function(self,o,b,r,d) 
      local xx, yy = zoom_and_scroll( self.x, self.y)
        if r --and gfx.mouse_x > xx-V_H and gfx.mouse_x < xx+self.w-V_H and gfx.mouse_y > yy-V_V and gfx.mouse_y < yy+self.h-V_V
      then 
          if self.id > 1 
        then
            if self.id == 4
          then
            gui[1].obj[1].sel = {} update_marquee()
            save()
            gui = {}
            generate_framework()
            PFOLDER = self.prev_fold FOLDER = self.folderid
            load_buttons()
            --generate exit button
            local rrr, ggg, bbb = reaper.ColorFromNative(default_col) rrr, ggg, bbb = rrr/255, ggg/255, bbb/255
            local rrrr, gggg, bbbb = reaper.ColorFromNative(default_col_text) rrrr, gggg, bbbb = rrrr/255, gggg/255, bbbb/255
            local newit = true for go = 1, #gui[1].obj[1].button do if gui[1].obj[1].button[go].id == 5 then newit = false end end 
              if newit == true 
            then 
              new_button( 5, 0, 0, 50, 50, rrr, ggg, bbb, "", -1, -1, -1, "Exit Folder", "", "", "rect", "exit current folder (right-click for menu, shift+right-click to move)", FOLDER, PFOLDER)
              gui[1].obj[1].button[#gui[1].obj[1].button].rt, gui[1].obj[1].button[#gui[1].obj[1].button].gt, gui[1].obj[1].button[#gui[1].obj[1].button].bt = rrrr,gggg,bbbb            
            end
            --
            elseif self.id == 5
          then
            gui[1].obj[1].sel = {} update_marquee()
            save()
            gui = {}
            generate_framework()
            FOLDER = self.prev_fold PFOLDER = ""
              for fo = 1, #gui[1].obj[1].button
            do
              if gui[1].obj[1].button[fo].id == 5 then PFOLDER = gui[1].obj[1].button[fo].prev_fold break end 
            end    
            load_buttons()             

          else -- id is 2 or 3
            local falser = {} local temper = "" 
              for a = 1, 13 
            do falser[a] = 1
                if self.name[a] ~= "*" 
              then falser[a] = 0
                temper = temper..self.name[a] if a < #self.name then temper = temper.."|" end 
              end 
            end 
            if self.id == 2 then gfx.x, gfx.y = self.x-V_H, self.y-(#self.name*Menu_Correction)-V_V else gfx.x, gfx.y = self.x-V_H, self.y+self.h-V_V end local choice2 = gfx.showmenu(temper) if choice2 == 0 then return end 
            for f = 1, 13 do if falser[f] == 0 then break else choice2 = choice2 + 1 end end
              if self.action[choice2]:sub(1,2) == "FX"
            then
              -- change string appropriately
              local sub_action = self.action[choice2]:sub(4) if sub_action:find(": ") then sub_action = sub_action:gsub(": ", ":") end 
              -- add new track if none selected
              if reaper.CountSelectedTracks(0) < 1 then reaper.Main_OnCommand(40001, 0) end
              -- add fx
                for tr = 1, reaper.CountSelectedTracks(0)
              do local through = false
                  if Do_Not_Duplicate_FX == true
                then
                  local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1), sub_action, false, 0 )
                  if success ~= -1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) else through = true end 
                end
                  if Do_Not_Duplicate_FX == false or through == true
                then
                  local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1), sub_action, false, -1 )
                  if success ~= -1 and tr == 1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) end
                  if success == -1 then emsg("FX '"..sub_action.."' not found.") break end
                end
              end
              elseif self.action[choice2]:len() < 6 and type(self.action[choice2]) == 'number'
            then 
              reaper.Main_OnCommand( tonumber(self.action[choice2]), 0 ) 
            else 
              reaper.Main_OnCommand( reaper.NamedCommandLookup(self.action[choice2]), 0 )         
            end
          end
        else
            if self.action[1]:sub(1,2) == "FX"
          then
            -- change string appropriately
            local sub_action = self.action[1]:sub(4) if sub_action:find(": ") then sub_action = sub_action:gsub(": ", ":") end 
            -- add new track if none selected
            if reaper.CountSelectedTracks(0) < 1 then reaper.Main_OnCommand(40001, 0) end
            -- add fx
              for tr = 1, reaper.CountSelectedTracks(0)
            do local through = false
                if Do_Not_Duplicate_FX == true
              then
                local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1), sub_action, false, 0 )
                if success ~= -1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) else through = true end 
              end
                if Do_Not_Duplicate_FX == false or through == true
              then
                local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1), sub_action, false, -1 )
                if success ~= -1 and tr == 1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) end
                if success == -1 then emsg("FX '"..sub_action.."' not found.") break end
              end
            end
            elseif self.action[1]:len() < 6 and type(tonumber(self.action[1])) == 'number'
          then 
            reaper.Main_OnCommand( tonumber(self.action[1]), 0 )
          else 
            reaper.Main_OnCommand( reaper.NamedCommandLookup(self.action[1]), 0 )           
          end
        end
      end 
    end, 
    [2]      = 
    function(self,o,b,r,d) 
      local xx, yy = zoom_and_scroll( self.x, self.y)
        if r --and gfx.mouse_x > xx-V_H and gfx.mouse_x < xx+self.w-V_H and gfx.mouse_y > yy-V_V and gfx.mouse_y < yy+self.h-V_V
      then 
        gfx.x, gfx.y = gfx.mouse_x, gfx.mouse_y local choice = gfx.showmenu("Edit Button|Delete Button|Duplicate Button||Set Button Color|Set Button Text Color|Set Button Text Transparency||Set Button Image|"..
        "Clear Button Image")
          if choice == 1 -- EDIT BUTTON
        then  
            if self.id == 1 --BUTTON
          then
            local csv = self.txt.."~"..self.caption.."~"..tostring(math.floor(self.w)).."-"..tostring(math.floor(self.h)).." (or) 0=autosize button to its text/image" 
            for crab = 1, 4 do csv=csv.."~" if self.action[crab] ~= "*" then csv=csv..self.action[crab] end end 
            local uiret, uireturn = reaper.GetUserInputs( "[user input]", 7, "Button Name:,Tooltip Message:,Button Width-Height:,L-click Action:,L-click + Shift:,L-click + Ctrl/Cmd:,L-click + Alt/Opt:,extrawidth=400,separator=~", csv )
              if uiret
            then
              local util = {} util[0] = 0 while uireturn:find("~")
              do util[0] = util[0] + 1
                util[util[0]] = uireturn:sub(1, uireturn:find("~")-1) uireturn = uireturn:sub(uireturn:find("~")+1,uireturn:len())
              end util[#util+1] = uireturn
                if util[0] > 6 
              then
                emsg("Due to program limitations, '~' is an invalid character.")
              else 
                local HT = split(util[3], "-") HT[1], HT[2] = tonumber(HT[1]), tonumber(HT[2]) if type(HT[1]) ~= 'number' then HT[1] = grid end if type(HT[2]) ~= 'number' then HT[2] = grid end
                local action1 = {[1] = util[4],[2] = util[5],[3] = util[6],[4] = util[7]} for ac = 1, 4 do if action1[ac] == "" then action1[ac] = "*" end end 
                if util[3] == tostring(math.floor(self.w)).."-"..tostring(math.floor(self.h)).." (or) 0=autosize button to its text/image" then HT[1], HT[2] = self.w, self.h end
                self.w, self.h, self.txt, self.action, self.caption = HT[1], HT[2], tostring(util[1]), action1, tostring(util[2]) if util[3] == "0" then autosize(self) end 
              end
            end    
            
            elseif self.id > 1 and self.id < 4 --MENU BUTTON
          then
            local hat = "down" if self.id == 2 then hat = "up" end
            local input2, csv2 = "Button Name-up/down:,Tooltip Message:,Button Width-Height:,Menu Item Name-Action:", self.txt.."-"..hat.."~"..self.caption.."~"..tostring(math.floor(self.w)).."-"..tostring(math.floor(self.h)).." (or) 0=autosize button to its text/image"
              for a = 4, 16 
            do 
              input2 = input2..",Menu Item Name-Action:"
              csv2=csv2.."~" if self.name[a-3] ~= "*" then csv2=csv2..self.name[a-3] csv2=csv2.."-" if self.action[a-3] ~= "*" then csv2=csv2..self.action[a-3] end end
            end
            local uiret2, uireturn2 = reaper.GetUserInputs( "[user input]", 16, input2..",extrawidth=400,separator=~", csv2 )
              if uiret2
            then
              local util2 = {} util2[0] = 0 while uireturn2:find("~")
              do util2[0] = util2[0] + 1
                util2[util2[0]] = uireturn2:sub(1, uireturn2:find("~")-1) uireturn2 = uireturn2:sub(uireturn2:find("~")+1,uireturn2:len())
              end util2[#util2+1] = uireturn2
                if util2[0] > 15 
              then
                emsg("Due to program limitations, '~' is an invalid character.")
              else 
                 local HT2 = split(util2[3], "-") HT2[1], HT2[2] = tonumber(HT2[1]), tonumber(HT2[2]) if type(HT2[1]) ~= 'number' then HT2[1] = grid end if type(HT2[2]) ~= 'number' then HT2[2] = grid end
                local name2, action2 = {}, {} for ac = 1, 13 do local store = split(util2[ac+3], "-") name2[ac], action2[ac] = store[1], store[2] if name2[ac] == nil or name2[ac] == "" then name2[ac] = "*" end if action2[ac] == nil or action2[ac] == "" then action2[ac] = "*" end end
                local store = split(util2[1], "-") if store[2] ~= "up" then store[2] = 3 else store[2] = 2 end
                if util2[3] == tostring(math.floor(self.w)).."-"..tostring(math.floor(self.h)).." (or) 0=autosize button to its text/image" then HT2[1], HT2[2] = self.w, self.h end
                self.w, self.h, self.txt, self.name, self.action, self.caption = HT2[1], HT2[2], tostring(store[1]), name2, action2, tostring(util2[2]) if util2[3] == "0" then autosize(self) end
              end
            end  
            
            elseif self.id == 4 --BUTTON FOLDER
          then  
            local csv3 = self.txt.."~"..self.caption.."~"..tostring(math.floor(self.w)).."-"..tostring(math.floor(self.h)).." (or) 0=autosize button to its text/image"
            local uiret3, uireturn3 = reaper.GetUserInputs( "[user input]", 3, "Folder Name:,Tooltip Message:,Button Width-Height:,extrawidth=400,separator=~", csv3 )
              if uiret3
            then
              local util3 = {} util3[0] = 0 while uireturn3:find("~")
              do util3[0] = util3[0] + 1
                util3[util3[0]] = uireturn3:sub(1, uireturn3:find("~")-1) uireturn3 = uireturn3:sub(uireturn3:find("~")+1,uireturn3:len())
              end util3[#util3+1] = uireturn3
                if util3[0] > 2 
              then
                emsg("Due to program limitations, '~' is an invalid character.")
              else 
                local HT3 = split(util3[3], "-") HT3[1], HT3[2] = tonumber(HT3[1]), tonumber(HT3[2]) if type(HT3[1]) ~= 'number' then HT3[1] = grid end if type(HT3[2]) ~= 'number' then HT3[2] = grid end
                if util3[3] == tostring(math.floor(self.w)).."-"..tostring(math.floor(self.h)).." (or) 0=autosize button to its text/image" then HT3[1], HT3[2] = self.w, self.h end
                self.w, self.h, self.txt, self.caption = HT3[1], HT3[2], tostring(util3[1]), tostring(util3[2]) if util3[3] == "0" then autosize(self) end
              end
            end
            elseif self.id == 5 --EXIT FOLDER
          then
            local csv4 = tostring(math.floor(self.w)).."-"..tostring(math.floor(self.h)).." (or) 0=autosize button to its text/image"
            local uiret4, uireturn4 = reaper.GetUserInputs( "[user input]", 1, "Button Width-Height:,extrawidth=400,separator=~", csv4 )
              if uiret4
            then
                if uireturn4:find("~")
              then
                emsg("Due to program limitations, '~' is an invalid character.")
              else 
                local HT4 = split(uireturn4, "-") HT4[1], HT4[2] = tonumber(HT4[1]), tonumber(HT4[2]) if type(HT4[1]) ~= 'number' then HT4[1] = grid end if type(HT4[2]) ~= 'number' then HT4[2] = grid end
                if uireturn4 == tostring(math.floor(self.w)).."-"..tostring(math.floor(self.h)).." (or) 0=autosize button to its text/image" then HT4[1], HT4[2] = self.w, self.h end
                self.w, self.h = HT4[1], HT4[2] if uireturn4 == "0" then autosize(self) end
              end
            end
          end
          -- clear button marquee selection
          gui[1].obj[1].sel = {} update_marquee()
          elseif choice == 2 -- DELETE BUTTON
        then 
          local group = false
            for ch = 1, #gui[1].obj[1].sel
          do
            if gui[1].obj[1].sel[ch] == b then group = true break end 
          end
        
            if group == false 
          then
            if self.id == 5 then emsg("Exit buttons can not be deleted") return end 
            if self.id == 4 then delete_folder(self.folderid) end 
            table.remove(gui[1].obj[1].button, b)
            for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].sel[ch] == b then table.remove(gui[1].obj[1].sel[ch], ch) end end 
            for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].sel[ch] > b then gui[1].obj[1].sel[ch] = gui[1].obj[1].sel[ch] - 1 end end 
          else
              for gr = #gui[1].obj[1].sel, 1, -1
            do
              if gui[1].obj[1].button[gui[1].obj[1].sel[gr]].id == 5 then emsg("Exit buttons can not be deleted") return end
              if gui[1].obj[1].button[gui[1].obj[1].sel[gr]].id == 4 then delete_folder(gui[1].obj[1].button[gui[1].obj[1].sel[gr]].folderid) end
              table.remove(gui[1].obj[1].button, gui[1].obj[1].sel[gr])
            end
          end
          gui[1].obj[1].sel = {} update_marquee()
          elseif choice == 3 -- DUPLICATE BUTTONS
        then  
          -- reassign button marquee selection if applicable
          local group = false for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].sel[ch] == b then group = true break end end if group == false then gui[1].obj[1].sel = {} gui[1].obj[1].sel[1] = b update_marquee() end 
          -- remove exit buttons from selection, if existent
          for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].button[gui[1].obj[1].sel[ch]].id == 5 then table.remove(gui[1].obj[1].sel, ch ) end end update_marquee() if #gui[1].obj[1].sel < 1 then return end
          -- check for most upper-left button
          local upper_left = 0
            for gr = 1, #gui[1].obj[1].sel
          do local b = gui[1].obj[1].sel[gr]
              if upper_left == 0 or gui[1].obj[1].button[b].x < gui[1].obj[1].button[upper_left].x and gui[1].obj[1].button[b].y <= gui[1].obj[1].button[upper_left].y
            then
              upper_left = b
            end            
          end local xdeduct, ydeduct = gui[1].obj[1].button[upper_left].x, gui[1].obj[1].button[upper_left].y
          -- duplicate buttons
          duplicator = {}
            for gr = 1, #gui[1].obj[1].sel
          do local dp = gui[1].obj[1].sel[gr]
            -- give folders new GUIDs
            local new_folder = gui[1].obj[1].button[dp].folderid 
            if gui[1].obj[1].button[dp].id == 4 then local old_folder = new_folder new_folder = reaper.genGuid() duplicate_folder(old_folder, new_folder) end
            -- create new button
            new_button(gui[1].obj[1].button[dp].id, gui[1].obj[1].button[dp].x, gui[1].obj[1].button[dp].y, gui[1].obj[1].button[dp].w, gui[1].obj[1].button[dp].h, gui[1].obj[1].button[dp].r, gui[1].obj[1].button[dp].g, gui[1].obj[1].button[dp].b, gui[1].obj[1].button[dp].img, gui[1].obj[1].button[dp].iid, gui[1].obj[1].button[dp].iw, gui[1].obj[1].button[dp].ih, gui[1].obj[1].button[dp].txt, gui[1].obj[1].button[dp].name, gui[1].obj[1].button[dp].action, gui[1].obj[1].button[dp].type, gui[1].obj[1].button[dp].caption, new_folder, gui[1].obj[1].button[dp].prev_fold) 
            gui[1].obj[1].button[#gui[1].obj[1].button].x = gfx.mouse_x+V_H+gui[1].obj[1].button[dp].x-xdeduct gui[1].obj[1].button[#gui[1].obj[1].button].y = gfx.mouse_y+V_V+gui[1].obj[1].button[dp].y-ydeduct
            gui[1].obj[1].button[#gui[1].obj[1].button].rt, gui[1].obj[1].button[#gui[1].obj[1].button].gt, gui[1].obj[1].button[#gui[1].obj[1].button].bt = gui[1].obj[1].button[dp].rt,gui[1].obj[1].button[dp].gt,gui[1].obj[1].button[dp].bt
            if gui[1].obj[1].button[dp].vt then gui[1].obj[1].button[#gui[1].obj[1].button].vt = 1 end 
            if upper_left == dp then duplicator[0] = #gui[1].obj[1].button end 
            gui[1].obj[1].sel[gr] = #gui[1].obj[1].button
          end 
          update_marquee()
          elseif choice == 4 -- CHANGE BUTTON COLOR
        then
          -- reassign button selection if applicable
          local group = false for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].sel[ch] == b then group = true break end end if group == false then gui[1].obj[1].sel = {} gui[1].obj[1].sel[1] = b update_marquee() end 
          --perform action
          local retcol, colreturn = reaper.GR_SelectColor( reaper.JS_Window_GetFocus() )
            if retcol ~= 0 
          then 
              for ch = 1, #gui[1].obj[1].sel 
            do
              gui[1].obj[1].button[gui[1].obj[1].sel[ch]].r, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].g, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].b = reaper.ColorFromNative( colreturn ) gui[1].obj[1].button[gui[1].obj[1].sel[ch]].r, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].g, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].b = gui[1].obj[1].button[gui[1].obj[1].sel[ch]].r/255, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].g/255, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].b/255
            end
            gui[1].obj[1].sel = {} update_marquee()
          end 
          elseif choice == 5 -- CHANGE BUTTON TEXT COLOR
        then
          -- reassign button selection if applicable
          local group = false for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].sel[ch] == b then group = true break end end if group == false then gui[1].obj[1].sel = {} gui[1].obj[1].sel[1] = b update_marquee() end 
          --perform action
          local retcol, colreturn = reaper.GR_SelectColor( reaper.JS_Window_GetFocus() )
            if retcol ~= 0 
          then 
              for ch = 1, #gui[1].obj[1].sel 
            do
              gui[1].obj[1].button[gui[1].obj[1].sel[ch]].rt, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].gt, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].bt = reaper.ColorFromNative( colreturn ) gui[1].obj[1].button[gui[1].obj[1].sel[ch]].rt, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].gt, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].bt = gui[1].obj[1].button[gui[1].obj[1].sel[ch]].rt/255, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].gt/255, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].bt/255
            end
            gui[1].obj[1].sel = {} update_marquee()
          end
          elseif choice == 6 -- CHANGE BUTTON TEXT TRANSPARENCY
        then
          -- reassign button selection if applicable
          local group = false for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].sel[ch] == b then group = true break end end if group == false then gui[1].obj[1].sel = {} gui[1].obj[1].sel[1] = b update_marquee() end   
          --perform action          
          local colret, colreturn = reaper.GetUserInputs( "[user input]", 1, "Button Text Alpha:,extrawidth=400,separator=~", "0-1 (0=transparent, 1=opaque)" )
            if colret
          then colreturn = tonumber(colreturn) 
              if type(colreturn) ~= 'number'
            then
              emsg("Entry must be a number.")
            else 
              if colreturn > 1 then colreturn = 1 end if colreturn < 0 then colreturn = 0 end 
                for ch = 1, #gui[1].obj[1].sel 
              do
                gui[1].obj[1].button[gui[1].obj[1].sel[ch]].at = colreturn
              end
              gui[1].obj[1].sel = {} update_marquee()
            end
          end        
          elseif choice == 7 -- SET BUTTON IMAGE
        then
          -- reassign button selection if applicable
          local group = false for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].sel[ch] == b then group = true break end end if group == false then gui[1].obj[1].sel = {} gui[1].obj[1].sel[1] = b update_marquee() end 
          --perform action
          local retvald, temperest = reaper.JS_Dialog_BrowseForOpenFiles( "Browse for image", "", "", "Image files\0*.png;*.jpg;*.bmp;*.ico\0PNG files (.png)\0*.png\0JPG files (.jpg)\0*.jpg\0BMP files (.bmp)\0*.bmp\0ICO files (.ico)\0*.ico\0\0", false)
            if retvald > 0 
          then 
              if temperest:find("~")
            then
              emsg("Due to program limitations, '~' is an invalid character. Please rename the file.")
            else
              local new_id = get_iid() gfx.loadimg(new_id,temperest) 
                for ch = 1, #gui[1].obj[1].sel 
              do
                gui[1].obj[1].button[gui[1].obj[1].sel[ch]].iw, gui[1].obj[1].button[gui[1].obj[1].sel[ch]].ih = gfx.getimgdim(new_id) gui[1].obj[1].button[gui[1].obj[1].sel[ch]].img = temperest gui[1].obj[1].button[gui[1].obj[1].sel[ch]].iid = new_id gui[1].obj[1].button[gui[1].obj[1].sel[ch]].type = "img" 
              end
              gui[1].obj[1].sel = {} update_marquee()
            end
          end
          elseif choice == 8 -- CLEAR BUTTON IMAGE
        then
          -- reassign button selection if applicable
          local group = false for ch = 1, #gui[1].obj[1].sel do if gui[1].obj[1].sel[ch] == b then group = true break end end if group == false then gui[1].obj[1].sel = {} gui[1].obj[1].sel[1] = b update_marquee() end 
          --perform action
            for ch = 1, #gui[1].obj[1].sel 
          do
            gui[1].obj[1].button[gui[1].obj[1].sel[ch]].type = "rect" gui[1].obj[1].button[gui[1].obj[1].sel[ch]].img = ""
          end
          gui[1].obj[1].sel = {} update_marquee()
        end
      end
    end, 
    [3]      = 
    function(self,o,b,r,d) if r then return end
        if #gui[1].obj[1].sel > 0
      then
        gui[1].obj[1].sel[#gui[1].obj[1].sel+1] = b update_marquee()
      else
          if self.action[2]
        then
            if self.action[2]:sub(1,2) == "FX"
          then
            -- change string appropriately
            local sub_action = self.action[2]:sub(4) if sub_action:find(": ") then sub_action = sub_action:gsub(": ", ":") end 
            -- add new track if none selected
            if reaper.CountSelectedTracks(0) < 1 then reaper.Main_OnCommand(40001, 0) end
            -- add fx
              for tr = 1, reaper.CountSelectedTracks(0)
            do local through = false
                if Do_Not_Duplicate_FX == true
              then
                local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1),  sub_action, false, 0 )
                if success ~= -1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) else through = true end 
              end
                if Do_Not_Duplicate_FX == false or through == true
              then
                local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1),  sub_action, false, -1 )
                if success ~= -1 and tr == 1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) end
                if success == -1 then emsg("FX '".. sub_action.."' not found.") break end
              end
            end
            elseif self.action[2]:len() < 6 and type(tonumber(self.action[2])) == 'number'
          then 
            reaper.Main_OnCommand( tonumber(self.action[2]), 0 )
          else 
            reaper.Main_OnCommand( reaper.NamedCommandLookup(self.action[2]), 0 )             
          end
        end
      end
    end,  
    [4]      = 
    function(self,o,b,r,d) if r then return end
        if self.action[3]
      then
          if self.action[3]:sub(1,2) == "FX"
        then
          -- change string appropriately
          local sub_action = self.action[3]:sub(4) if sub_action:find(": ") then sub_action = sub_action:gsub(": ", ":") end 
          -- add new track if none selected
          if reaper.CountSelectedTracks(0) < 1 then reaper.Main_OnCommand(40001, 0) end
          -- add fx
            for tr = 1, reaper.CountSelectedTracks(0)
          do local through = false
              if Do_Not_Duplicate_FX == false
            then
              local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1),  sub_action, false, 0 )
              if success ~= -1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) else through = true end 
            end
              if Do_Not_Duplicate_FX == true or through == true
            then
              local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1),  sub_action, false, -1 )
              if success ~= -1 and tr == 1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) end
              if success == -1 then emsg("FX '".. sub_action.."' not found.") break end
            end
          end
          elseif self.action[3]:len() < 6 and type(tonumber(self.action[3])) == 'number'
        then 
          reaper.Main_OnCommand( tonumber(self.action[3]), 0 ) 
        else 
          reaper.Main_OnCommand( reaper.NamedCommandLookup(self.action[3]), 0 )           
        end
      end
    end,
    [5]      = 
    function(self,o,b,r,d) if r then return end
        if self.action[4]
      then
          if self.action[4]:sub(1,2) == "FX"
        then
          -- change string appropriately
          local sub_action = self.action[4]:sub(4) if sub_action:find(": ") then sub_action = sub_action:gsub(": ", ":") end 
          -- add new track if none selected
          if reaper.CountSelectedTracks(0) < 1 then reaper.Main_OnCommand(40001, 0) end
          -- add fx
            for tr = 1, reaper.CountSelectedTracks(0)
          do local through = false
              if Do_Not_Duplicate_FX == true
            then
              local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1),  sub_action, false, 0 )
              if success ~= -1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) else through = true end 
            end
              if Do_Not_Duplicate_FX == false or through == true
            then
              local success = reaper.TrackFX_AddByName( reaper.GetSelectedTrack(0,tr-1),  sub_action, false, -1 )
              if success ~= -1 and tr == 1 then reaper.TrackFX_SetOpen( reaper.GetSelectedTrack(0,tr-1), success, true ) end
              if success == -1 then emsg("FX '".. sub_action.."' not found.") break end
            end
          end
          elseif self.action[4]:len() < 6 and type(tonumber(self.action[4])) == 'number'
        then 
          reaper.Main_OnCommand( tonumber(self.action[4]), 0 ) 
        else 
          reaper.Main_OnCommand( reaper.NamedCommandLookup(self.action[4]), 0 )             
        end
      end
    end,
    [6]      = 
    function(self,o,b,r,d) if r then grabX, grabY = nil, nil return end
      tempX, tempY, dragging = gfx.mouse_x, gfx.mouse_y, false
        if not grabX 
      then 
        grabX, grabY, yes = tempX, tempY, false 
          for ch = 1, #gui[1].obj[1].sel 
        do 
            if gui[1].obj[1].sel[ch] == b 
          then 
            yes = true
          end 
        end
          if yes == false and not duplicator
        then 
          gui[1].obj[1].sel = {} gui[1].obj[1].sel[1] = b update_marquee() 
        end
      end

        if gui[2].obj[1].locked == false
      then
          if tempX < 20
        then
          V_H = V_H - Drag_Scroll_Speed dragging = true
        end
          if tempX > gfx.w-20
        then
          V_H = V_H + Drag_Scroll_Speed dragging = true
        end
      end
        if gui[2].obj[2].locked == false
      then
        if tempY < 20
      then
          V_V = V_V - Drag_Scroll_Speed dragging = true
        end
          if tempY > gfx.h-20
        then
          V_V = V_V + Drag_Scroll_Speed dragging = true
        end
      end
      
      if tempX < 0 then tempX = 0 end if tempX > gfx.w-20-self.w then tempX = gfx.w-20-self.w end if tempY < 0 then tempY = 0 end if tempY > gfx.h-20-self.h then tempY = gfx.h-20-self.h end tempX = tempX + V_H tempY = tempY + V_V
        
        if snap == true
      then
        tempX = math.floor((tempX/grid))*grid if tempX-V_H < 0 then tempX = tempX + grid end 
        tempY = math.floor((tempY/grid))*grid if tempY-V_V < 0 then tempY = tempY + grid end
      end 
      
        if dragging == true 
      then
        -- enforce min/max
        if V_V < 0 then V_V = 0 end if V_V > (grid_h-gfx.h) then V_V = (grid_h-gfx.h) end
        if V_H < 0 then V_H = 0 end if V_H > (grid_w-gfx.w) then V_H = (grid_w-gfx.w) end
        -- update scrollbar positions
        update_scrollbar()
      end
      
        for ch = 1, #gui[1].obj[1].sel 
      do
          if gui[1].obj[1].sel[ch] ~= b
        then
          gui[1].obj[1].button[gui[1].obj[1].sel[ch]].x = gui[1].obj[1].button[gui[1].obj[1].sel[ch]].x + (tempX-self.x)
          gui[1].obj[1].button[gui[1].obj[1].sel[ch]].y = gui[1].obj[1].button[gui[1].obj[1].sel[ch]].y + (tempY-self.y)
        end
      end
      
      self.x, self.y = tempX, tempY
      
      -- if just duplicated items
        if duplicator
      then
        if reaper.JS_Mouse_GetState(1) == 1 then duplicator[1] = 0 end
        if reaper.JS_Mouse_GetState(1) == 0 and duplicator[1] then duplicator = nil end
      end
      
    end,
    },
  mouse      =
    { -- index [1] must always be left-click
    [1]        = 1,                
    [2]        = 2,
    [3]        = 9,
    [4]        = 5,
    [5]        = 17,
    [6]        = 10
    },
  hold       = 
    {
    [1]        = false,
    [2]        = false,
    [3]        = false,
    [4]        = false,
    [5]        = false,
    [6]        = true
    }
  }
  return gui[1].obj[1].button[#gui[1].obj[1].button]
end

function generate_framework()
  gui[1] = {obj = {}} gui[2] = {obj = {}} gui[3] = {obj = {}}
    --MARQUEE SELECTOR--------------------------------------------------------------------
    gui[1].obj[2] = {
  id         = 1,                                                -- object classification (optional)
  caption    = "", -- caption display
  hc         = 0,                                                -- current hover alpha (default '0')
  ha         = .05,                                              -- hover alpha
  hca        = .1,                                               -- hover click alpha 
  ol         = {r=1,g=1,b=1,a=0},                               -- rect: object's outline
  r          = 0,                                               -- r
  g          = 1,                                                -- g
  b          = 0,                                               -- b
  a          = 0,                                               -- a
  f          = 0,                                                -- rect: filled  
  x          = 0,                                                -- x
  y          = 0,                                                -- y
  w          = 0,                                                -- w
  h          = 0,                                                -- h
  can_zoom   = false,                                             -- whether object rectangle zooms with global
  can_scroll = false,                                            -- whether object rectangle scrolls with global 
  act_off    = 2,                                                -- if 1, object action is disabled. if 2, disabled & mouse input is passed through 
  button     = {},                                               -- index of buttons that object holds
  static     = {},                                               -- index of static graphics that object holds
  func       = 
    { -- functions receive object index and bool release ('r')
    -- always-run function
    [-1]      = function(self,g,o) end, 
    -- non-indexed function
    [0]      = function(self,o,r,d) if r then msg("release") return else msg("Dclick") end end, 
    -- mouse_cap functions
    [1]      = function(self,o,r,d) if r then msg("release") return else msg("Lclick") end end, 
    [2]      = function(self,o,r,d) if r then msg("release") return else msg("Rclick") end end, 
    [3]      = function(self,o,r,d) if r then msg("release") return else msg("Mclick") end end, 
    },
  mouse      =
    { -- index [1] must always be left-click
    [1]        = 1,                
    [2]        = 2,
    [3]        = 18
    },
  hold       = 
    {
    [1]        = true,
    [2]        = false,
    [3]        = false
    }
  }

  local rr, gg, bb = reaper.ColorFromNative(background_col) rr,gg,bb=rr/255,gg/255,bb/255
  gui[1].obj[1] = {
  caption    = "left-drag to marquee, right-click for menu, shift+right-click to move window", -- caption display
  sel        = {},
  hc         = 0,                                                -- current hover alpha (default '0')
  ha         = 0,                                                -- hover alpha
  hca        = 0,                                                -- hover click alpha 
  ol         = {r=1,g=1,b=1,a=0},                                -- rect: object's outline
  r          = rr,                                               -- r
  g          = gg,                                               -- g
  b          = bb,                                               -- b
  a          = 0,                                                -- a
  f          = 1,                                                -- rect: filled  
  x          = 0,                                                -- x
  y          = 0,                                                -- y
  w          = 0,                                                -- w
  h          = 0,                                                -- h
  can_zoom   = false,                                            -- whether object rectangle zooms with global
  can_scroll = false,                                            -- whether object rectangle scrolls with global 
  button     = {},                                               -- index of buttons that object holds
  static     = {},                                               -- index of static graphics that object holds
  func       = 
    { -- functions receive object index and bool release ('r')
    -- always-run function
    [-1]      = function(self,g,o) end, 
    -- non-indexed function
    [0]      = function(self,o,r,d) if r then return else end end, 
    -- mouse_cap functions
    [1]      = function(self,o,r,d) --if r then return else end
    
    if not marquee_x then marquee_x, marquee_y = gfx.mouse_x, gfx.mouse_y end
    
    local dragging = false
    
      if gfx.mouse_x < 20 and gui[2].obj[1].locked == false
    then
      V_H = V_H - Marquee_Scroll_Speed dragging = true marquee_x = marquee_x + Marquee_Scroll_Speed
    end
      if gfx.mouse_x > gfx.w-20 and gui[2].obj[1].locked == false
    then
      V_H = V_H + Marquee_Scroll_Speed dragging = true marquee_x = marquee_x - Marquee_Scroll_Speed
    end
      if gfx.mouse_y < 20 and gui[2].obj[2].locked == false
    then
      V_V = V_V - Marquee_Scroll_Speed dragging = true marquee_y = marquee_y + Marquee_Scroll_Speed
    end
      if gfx.mouse_y > gfx.h-20 and gui[2].obj[2].locked == false
    then
      V_V = V_V + Marquee_Scroll_Speed dragging = true marquee_y = marquee_y - Marquee_Scroll_Speed
    end
      if dragging == true 
    then
      -- enforce min/max
      if V_V < 0 then marquee_y = marquee_y + V_V V_V = 0 end if V_V > (grid_h-gfx.h) then marquee_y = marquee_y + (V_V-(grid_h-gfx.h)) V_V = (grid_h-gfx.h) end
      if V_H < 0 then marquee_x = marquee_x + V_H V_H = 0 end if V_H > (grid_w-gfx.w) then marquee_x = marquee_x + (V_H-(grid_w-gfx.w)) V_H = (grid_w-gfx.w) end
      -- update scrollbar positions
      update_scrollbar()
    end
    
    local xx, yy, ww, hh = -1,-1,-1,-1
    if gfx.mouse_x > marquee_x then xx, ww = marquee_x, gfx.mouse_x-marquee_x else xx, ww = gfx.mouse_x, marquee_x-gfx.mouse_x end 
    if gfx.mouse_y > marquee_y then yy, hh = marquee_y, gfx.mouse_y-marquee_y else yy, hh = gfx.mouse_y, marquee_y-gfx.mouse_y end 
    gui[1].obj[2].a = 1
    gui[1].obj[2].x = xx
    gui[1].obj[2].y = yy
    gui[1].obj[2].w = ww
    gui[1].obj[2].h = hh

    -- release mouse: select all applicable items
      if r 
      then
      self.sel = {} 
        if marquee_x and marquee_y
      then xx = xx + V_H yy = yy + V_V
        -- select applicable items
          for z = 1, #gui[1].obj[1].button
        do
          if gui[1].obj[1].button[z].x < xx+ww and gui[1].obj[1].button[z].x+gui[1].obj[1].button[z].w > xx and gui[1].obj[1].button[z].y < yy+hh and gui[1].obj[1].button[z].y+gui[1].obj[1].button[z].h > yy then self.sel[#self.sel+1] = z end
        end
      end 
      gui[1].obj[2].a = 0 marquee_x, marquee_y = nil, nil return update_marquee()
      end  
    
    end, 
    [2]      = 
    function(self,o,r,d) 
        if r 
      then gfx.x, gfx.y = gfx.mouse_x, gfx.mouse_y
        
        -- set custom menu words
        local word, word2 = "Enable", "Show" if snap == true then word = "Disable" end if show_grid == "true" then word2 = "Hide" end  local greyitout = "" if backgroundImage == "" then greyitout = "#" end 
        local stretcher = "Don't Stretch" if BG_stretch == "Don't Stretch" then stretcher = "Stretch" end 
        local word3 = "Hide" if show_title_bar == false then word3 = "Show" end local greyitout3 = "#" if #gui[1].obj[1].sel == 1 then greyitout3 = "" end 
        local rrr, ggg, bbb = reaper.ColorFromNative(default_col) rrr, ggg, bbb = rrr/255, ggg/255, bbb/255
        local rrrr, gggg, bbbb = reaper.ColorFromNative(default_col_text) rrrr, gggg, bbbb = rrrr/255, gggg/255, bbbb/255
        local hdisable, htop, hright, hbottom, hleft = "Disable", "Top", "Right", "Bottom", "Left" 
        local scrollword = "Unl" if gui[2].obj[1].locked == false or gui[2].obj[2].locked == false then scrollword = "L" end local lockerR = "" if math.floor(gfx.dock(-1)&1) ~= 0 then lockerR = "#" end
        if hiding == "Right" then hright="!"..hright elseif hiding == "Bottom" then hbottom="!"..hbottom elseif hiding == "Top" then htop="!"..htop elseif hiding == "Left" then hleft="!"..hleft else hdisable="!"..hdisable end  
        local Hwo, Vwo = "Hide", "Hide" if SC_H == true then Hwo = "Show" end if SC_V == true then Vwo = "Show" end
         
        -- activate menu
        local choice = gfx.showmenu(">Create Button|New Button|New Vertical Button|New Menu Button|New Button Folder|New Vertical Button Folder||<"..greyitout3.."Duplicate Button and Multiply (select only 1 button)||>Customize This Folder|Set Folder Background Color|"..
        "Set Folder Background Image|"..greyitout.."Set Folder Background Image Width/Height|<"..stretcher.." Folder Background Image to Window||>Button Customizations|Set New Button Color Default|<Set New Button Text Color Default|"..
        ">Grid Customizations|"..word2.." Grid||Customize Grid Line Color|Customize Grid Line Spacing|<Customize Grid Line Thickness||>Global Options/Settings|"..word.." Snap to Grid|"..lockerR..word3.." Window Titlebar|"..
        Hwo.." Horizontal Scrollbar|"..Vwo.." Vertical Scrollbar|"..
        lockerR..window_resizing.."ock Window Resizing|".."Set Global Font Size ("..tostring(fontSize)..")|"..scrollword.."ock Scrolling||>Pop-up Window|"..hdisable.."|"..htop.."|"..hright.."|"..hbottom.."|<"..hleft..
        "|<||Load Configuration...|Save as...||Documentation|Donate||Exit Script")
        
          if choice == 1 -- NEW BUTTON
        then
          local last_used = tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" if last_used_width then last_used = last_used_width end 
          local csv = "New Button~right-click for menu, shift+right-click to move~"..last_used.."~(Examples) 40001 (or) _XENAKIOS_INSNEWTRACKTOP (or) FX VST3: CLA-3A" 
          local uiret, uireturn = reaper.GetUserInputs( "[user input]", 7, "Button Name:,Tooltip Message:,Button Width-Height:,L-click Action:,L-click + Shift:,L-click + Ctrl/Cmd:,L-click + Alt/Opt:,extrawidth=400,separator=~", csv )
            if uiret
          then
            local util = {} util[0] = 0 while uireturn:find("~")
            do util[0] = util[0] + 1
              util[util[0]] = uireturn:sub(1, uireturn:find("~")-1) uireturn = uireturn:sub(uireturn:find("~")+1,uireturn:len())
            end util[#util+1] = uireturn
              if util[0] > 6 
            then
              emsg("Due to program limitations, '~' is an invalid character.")
            else 
              last_used_width = util[3]
              local HT = split(util[3], "-") HT[1], HT[2] = tonumber(HT[1]), tonumber(HT[2]) if type(HT[1]) ~= 'number' then HT[1] = grid end if type(HT[2]) ~= 'number' then HT[2] = grid end
              local action1 = {[1] = util[4],[2] = util[5],[3] = util[6],[4] = util[7]} for ac = 1, 4 do if action1[ac] == "" then action1[ac] = "*" end end 
              new_button( 1, gfx.x+V_H, gfx.y+V_V, HT[1], HT[2], rrr, ggg, bbb, "", -1, -1, -1, tostring(util[1]), "", action1, "rect", tostring(util[2]), "") 
              gui[1].obj[1].button[#gui[1].obj[1].button].rt, gui[1].obj[1].button[#gui[1].obj[1].button].gt, gui[1].obj[1].button[#gui[1].obj[1].button].bt = rrrr,gggg,bbbb
              if util[3] == "0" or util[3] == tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" then autosize(gui[1].obj[1].button[#gui[1].obj[1].button]) end
            end
          end  
          elseif choice == 2 -- NEW VERTICAL BUTTON
        then
          local last_used = tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" if last_used_width then last_used = last_used_width end 
          local csv = "New Button~right-click for menu, shift+right-click to move~"..last_used.."~(Examples) 40001 (or) _XENAKIOS_INSNEWTRACKTOP (or) FX VST3: CLA-3A" 
          local uiret, uireturn = reaper.GetUserInputs( "[user input]", 7, "Button Name:,Tooltip Message:,Button Width-Height:,L-click Action:,L-click + Shift:,L-click + Ctrl/Cmd:,L-click + Alt/Opt:,extrawidth=400,separator=~", csv )
            if uiret
          then
            local util = {} util[0] = 0 while uireturn:find("~")
            do util[0] = util[0] + 1
              util[util[0]] = uireturn:sub(1, uireturn:find("~")-1) uireturn = uireturn:sub(uireturn:find("~")+1,uireturn:len())
            end util[#util+1] = uireturn
              if util[0] > 6 
            then
              emsg("Due to program limitations, '~' is an invalid character.")
            else 
              last_used_width = util[3]
              local HT = split(util[3], "-") HT[1], HT[2] = tonumber(HT[1]), tonumber(HT[2]) if type(HT[1]) ~= 'number' then HT[1] = grid end if type(HT[2]) ~= 'number' then HT[2] = grid end
              local action1 = {[1] = util[4],[2] = util[5],[3] = util[6],[4] = util[7]} for ac = 1, 4 do if action1[ac] == "" then action1[ac] = "*" end end 
              new_button( 1, gfx.x+V_H, gfx.y+V_V, HT[1], HT[2], rrr, ggg, bbb, "", -1, -1, -1, tostring(util[1]), "", action1, "rect", tostring(util[2]), "")
              gui[1].obj[1].button[#gui[1].obj[1].button].vt = 1              
              gui[1].obj[1].button[#gui[1].obj[1].button].rt, gui[1].obj[1].button[#gui[1].obj[1].button].gt, gui[1].obj[1].button[#gui[1].obj[1].button].bt = rrrr,gggg,bbbb
              if util[3] == "0" or util[3] == tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" then autosize(gui[1].obj[1].button[#gui[1].obj[1].button]) end
            end
          end            
          elseif choice == 3 --MENU BUTTON
        then
          local last_used = tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" if last_used_width then last_used = last_used_width end 
          local input2, csv2 = "Button Name-up/down:,Tooltip Message:,Button Width-Height:,Menu Item Name-Action:", "New Menu Button-up/down~right-click for menu, shift+right-click to move~"..last_used.."~(Example) Create new track-40001"
            for a = 4, 16 
          do 
            input2 = input2..",Menu Item Name-Action:"
          end
          local uiret2, uireturn2 = reaper.GetUserInputs( "[user input]", 16, input2..",extrawidth=400,separator=~", csv2 )
            if uiret2
          then
            local util2 = {} util2[0] = 0 while uireturn2:find("~")
            do util2[0] = util2[0] + 1
              util2[util2[0]] = uireturn2:sub(1, uireturn2:find("~")-1) uireturn2 = uireturn2:sub(uireturn2:find("~")+1,uireturn2:len())
            end util2[#util2+1] = uireturn2
              if util2[0] > 15 
            then
              emsg("Due to program limitations, '~' is an invalid character.")
            else 
              last_used_width = util2[3]
              local HT2 = split(util2[3], "-") HT2[1], HT2[2] = tonumber(HT2[1]), tonumber(HT2[2]) if type(HT2[1]) ~= 'number' then HT2[1] = grid end if type(HT2[2]) ~= 'number' then HT2[2] = grid end
              local name2, action2 = {}, {} for ac = 1, 13 do local store = split(util2[ac+3], "-") name2[ac], action2[ac] = store[1], store[2] if name2[ac] == nil or name2[ac] == "" then name2[ac] = "*" end if action2[ac] == nil or action2[ac] == "" then action2[ac] = "*" end end
              local store = split(util2[1], "-") if store[2] ~= "up" then store[2] = 3 else store[2] = 2 end
              new_button( store[2], gfx.x+V_H, gfx.y+V_V, HT2[1], HT2[2], rrr, ggg, bbb, "", -1, -1, -1, tostring(store[1]), name2, action2, "rect", tostring(util2[2]), "") 
              gui[1].obj[1].button[#gui[1].obj[1].button].rt, gui[1].obj[1].button[#gui[1].obj[1].button].gt, gui[1].obj[1].button[#gui[1].obj[1].button].bt = rrrr,gggg,bbbb
              if util2[3] == "0" or util2[3] == tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" then autosize(gui[1].obj[1].button[#gui[1].obj[1].button]) end
            end
          end  
          elseif choice == 4 --BUTTON FOLDER
        then    
          local last_used = tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" if last_used_width then last_used = last_used_width end 
          local uiret3, uireturn3 = reaper.GetUserInputs( "[user input]", 3, "Folder Name:,Tooltip Message:,Button Width-Height:,extrawidth=400,separator=~", "New Folder~right-click for menu, shift+right-click to move~"..last_used )
            if uiret3
          then
            local util3 = {} util3[0] = 0 while uireturn3:find("~")
            do util3[0] = util3[0] + 1
              util3[util3[0]] = uireturn3:sub(1, uireturn3:find("~")-1) uireturn3 = uireturn3:sub(uireturn3:find("~")+1,uireturn3:len())
            end util3[#util3+1] = uireturn3
              if util3[0] > 2 
            then
              emsg("Due to program limitations, '~' is an invalid character.")
            else
              last_used_width = util3[3]
              local HT3 = split(util3[3], "-") HT3[1], HT3[2] = tonumber(HT3[1]), tonumber(HT3[2]) if type(HT3[1]) ~= 'number' then HT3[1] = grid end if type(HT3[2]) ~= 'number' then HT3[2] = grid end
              new_button( 4, gfx.x+V_H, gfx.y+V_V, HT3[1], HT3[2], rrr, ggg, bbb, "", -1, -1, -1, tostring(util3[1]), "", "", "rect", tostring(util3[2]), reaper.genGuid(), FOLDER)
              gui[1].obj[1].button[#gui[1].obj[1].button].rt, gui[1].obj[1].button[#gui[1].obj[1].button].gt, gui[1].obj[1].button[#gui[1].obj[1].button].bt = rrrr,gggg,bbbb              
              if util3[3] == "0" or util3[3] == tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" then autosize(gui[1].obj[1].button[#gui[1].obj[1].button]) end
            end
          end
          elseif choice == 5 --VERTICAL BUTTON FOLDER
        then    
          local last_used = tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" if last_used_width then last_used = last_used_width end 
          local uiret3, uireturn3 = reaper.GetUserInputs( "[user input]", 3, "Folder Name:,Tooltip Message:,Button Width-Height:,extrawidth=400,separator=~", "New Folder~right-click for menu, shift+right-click to move~"..last_used )
            if uiret3
          then
            local util3 = {} util3[0] = 0 while uireturn3:find("~")
            do util3[0] = util3[0] + 1
              util3[util3[0]] = uireturn3:sub(1, uireturn3:find("~")-1) uireturn3 = uireturn3:sub(uireturn3:find("~")+1,uireturn3:len())
            end util3[#util3+1] = uireturn3
              if util3[0] > 2 
            then
              emsg("Due to program limitations, '~' is an invalid character.")
            else
              last_used_width = util3[3]
              local HT3 = split(util3[3], "-") HT3[1], HT3[2] = tonumber(HT3[1]), tonumber(HT3[2]) if type(HT3[1]) ~= 'number' then HT3[1] = grid end if type(HT3[2]) ~= 'number' then HT3[2] = grid end
              new_button( 4, gfx.x+V_H, gfx.y+V_V, HT3[1], HT3[2], rrr, ggg, bbb, "", -1, -1, -1, tostring(util3[1]), "", "", "rect", tostring(util3[2]), reaper.genGuid(), FOLDER)
              gui[1].obj[1].button[#gui[1].obj[1].button].vt = 1  
              gui[1].obj[1].button[#gui[1].obj[1].button].rt, gui[1].obj[1].button[#gui[1].obj[1].button].gt, gui[1].obj[1].button[#gui[1].obj[1].button].bt = rrrr,gggg,bbbb              
              if util3[3] == "0" or util3[3] == tostring(grid).."-"..tostring(grid).." (or) 0=autosize button to its text/image" then autosize(gui[1].obj[1].button[#gui[1].obj[1].button]) end
            end
          end
          elseif choice == 6 --BUTTON MATRIX DUPLICATION
        then
          local dp = gui[1].obj[1].sel[1]
          --if gui[1].obj[1].button[dp].id > 3 then emsg("Folders and exit buttons may not be duplicated.") return end 
          local uiret, uireturn = reaper.GetUserInputs( "[user input]", 4, "X-Axis Duplicates:,Y-Axis Duplicates,X-Axis Spacing:,Y-Axis Spacing:,extrawidth=400,separator=~", "5~5~"..math.floor(gui[1].obj[1].button[dp].w).."~"..math.floor(gui[1].obj[1].button[dp].h))
            if uiret
          then
            local util = {} util[0] = 0 while uireturn:find("~")
            do util[0] = util[0] + 1
              util[util[0]] = tonumber(uireturn:sub(1, uireturn:find("~")-1)) uireturn = uireturn:sub(uireturn:find("~")+1,uireturn:len()) 
              if type(util[util[0]]) ~= 'number' then util[0] = -1 break else if util[util[0]] < 1 then util[util[0]] = 1 end end
            end util[#util+1] = uireturn
              if util[0] == -1 
            then
              emsg("All inputs must be positive numbers.")
            else
              local dp = dp
                for xa = 1, util[1]
              do 
                  for ya = 1, util[2]
                do 
                    if xa ~= 1 or ya ~= 1
                  then 
                    -- give folders new GUIDs
                    local new_folder = gui[1].obj[1].button[dp].folderid 
                    if gui[1].obj[1].button[dp].id == 4 then local old_folder = new_folder new_folder = reaper.genGuid() duplicate_folder(old_folder, new_folder) end
                    -- create new button
                    new_button(gui[1].obj[1].button[dp].id, gui[1].obj[1].button[dp].x, gui[1].obj[1].button[dp].y, gui[1].obj[1].button[dp].w, gui[1].obj[1].button[dp].h, gui[1].obj[1].button[dp].r, gui[1].obj[1].button[dp].g, gui[1].obj[1].button[dp].b, gui[1].obj[1].button[dp].img, gui[1].obj[1].button[dp].iid, gui[1].obj[1].button[dp].iw, gui[1].obj[1].button[dp].ih, gui[1].obj[1].button[dp].txt, gui[1].obj[1].button[dp].name, gui[1].obj[1].button[dp].action, gui[1].obj[1].button[dp].type, gui[1].obj[1].button[dp].caption, new_folder, gui[1].obj[1].button[dp].prev_fold) 
                    gui[1].obj[1].button[#gui[1].obj[1].button].x = gui[1].obj[1].button[dp].x + ((xa-1)*util[3]) gui[1].obj[1].button[#gui[1].obj[1].button].y = gui[1].obj[1].button[dp].y + ((ya-1)*util[4])
                    gui[1].obj[1].button[#gui[1].obj[1].button].rt, gui[1].obj[1].button[#gui[1].obj[1].button].gt, gui[1].obj[1].button[#gui[1].obj[1].button].bt = gui[1].obj[1].button[dp].rt, gui[1].obj[1].button[dp].gt, gui[1].obj[1].button[dp].bt
                    if gui[1].obj[1].button[dp].vt then gui[1].obj[1].button[#gui[1].obj[1].button].vt = 1 end 
                  end
                end
              end
            end
          end
          elseif choice == 7 --SET FOLDER BACKGROUND COLOR
        then
          local retcolo, coloreturn = reaper.GR_SelectColor( reaper.JS_Window_GetFocus() )
            if retcolo 
          then 
            backgroundImage = "" gui[1].obj[1].r, gui[1].obj[1].g, gui[1].obj[1].b = reaper.ColorFromNative( coloreturn ) gui[1].obj[1].r, gui[1].obj[1].g, gui[1].obj[1].b = gui[1].obj[1].r/255, gui[1].obj[1].g/255, gui[1].obj[1].b/255 
            background_col = coloreturn
          end
          elseif choice == 8 --SET FOLDER BACKGROUND IMAGE
        then
          local retvald, temperest = reaper.JS_Dialog_BrowseForOpenFiles( "Browse for image", "", "", "Image files\0*.png;*.jpg;*.bmp\0PNG files (.png)\0*.png\0JPG files (.jpg)\0*.jpg\0BMP files (.bmp)\0*.bmp\0\0", false)
            if retvald > 0
          then backgroundImage = temperest 
            gfx.loadimg(1023,backgroundImage) bakw, bakh = gfx.getimgdim(1023) 
          end
          elseif choice == 9 --SET FOLDER BACKGROUND IMAGE WIDTH/HEIGHT
        then
          local add_info, add_info2 = "", "" if bakw ~= 0 and bakw ~= 0 then add_info, add_info2 = " (original width = "..tostring(bakw)..")", " (original height = "..tostring(bakh)..")" end 
          local tempWW, tempHH = tostring(gfx.w), tostring(gfx.h) if BG_W then tempWW = tostring(BG_W) end if BG_H then tempHH = tostring(BG_H) end
          local uiret8, uireturn8 = reaper.GetUserInputs( "[user input]", 2, "Background Image Width:,Background Image Height:,extrawidth=100", tempWW..add_info..","..tempHH..add_info2 )
            if uiret8
          then 
              if uireturn8:find(",")
            then
              uireturn8 = split(uireturn8, ",") uireturn8[1], uireturn8[2] = tonumber(uireturn8[1]), tonumber(uireturn8[2])
              if type(uireturn8[1]) == 'number' and type(uireturn8[2]) == 'number' then BG_W = uireturn8[1] BG_H = uireturn8[2] BG_stretch = "Don't Stretch" end 
            end
          end
          elseif choice == 10 -- SET FOLDER TO STRETCH BACKGROUND IMAGE TO WINDOW
        then
          if BG_stretch == "Stretch" then BG_stretch = "Don't Stretch" else BG_stretch = "Stretch" end 
          elseif choice == 11 --SET COLOR OF NEW BUTTONS
        then
          local retcol, colreturn = reaper.GR_SelectColor( reaper.JS_Window_GetFocus() ) if retcol ~= 0 then default_col = colreturn end
          elseif choice == 12 --SET COLOR OF NEW BUTTONS TEXT
        then
          local retcol, colreturn = reaper.GR_SelectColor( reaper.JS_Window_GetFocus() ) if retcol ~= 0 then default_col_text = colreturn end
          elseif choice == 13 --SHOW/HIDE GRID
        then
          if show_grid == "true" then show_grid = "false" else show_grid = "true" end
          elseif choice == 14 --CUSTOMIZE GRID COLOR
        then
          local retcol, colreturn = reaper.GR_SelectColor( reaper.JS_Window_GetFocus() ) if retcol ~= 0 then line_col = colreturn end
          elseif choice == 15 --CUSTOMIZE GRID SPACING
        then
          local uiret7, uireturn7 = reaper.GetUserInputs( "[user input]", 1, "Grid size-spacing:", tostring(grid) )
            if uiret7
          then 
            uireturn7 = tonumber(uireturn7) if type(uireturn7) == 'number' then if uireturn7 > 200 then uireturn7 = 200 end if uireturn7 < 3 then uireturn7 = 3 end grid = uireturn7 end 
          end
          elseif choice == 16 --CUSTOMIZE GRID LINE THICKNESS
        then
          local uiret7, uireturn7 = reaper.GetUserInputs( "[user input]", 1, "Grid line thickness (1-20):", tostring(lineW) )
            if uiret7
          then 
            uireturn7 = tonumber(uireturn7) if type(uireturn7) == 'number' then if uireturn7 > 20 then uireturn7 = 20 end if uireturn7 < 1 then uireturn7 = 1 end lineW = uireturn7 end 
          end
          elseif choice == 17 --ENABLE/DISABLE SNAP TO GRID
        then
          if snap == true then snap = false else snap = true end
          elseif choice == 18 -- SHOW/HIDE TITLEBAR
        then
            if show_title_bar == false
          then 
            show_title_bar = true set_window_flags()
          else 
            show_title_bar = false set_window_flags()
          end 
          elseif choice == 19 -- SHOW/HIDE HORIZONTAL SCROLLBAR
        then
          if SC_H == true then SC_H = false else SC_H = true end 
          elseif choice == 20 -- SHOW/HIDE VERTICAL SCROLLBAR
        then
          if SC_V == true then SC_V = false else SC_V = true end 
          elseif choice == 21 -- UN/LOCK WINDOW RESIZING
        then
            if window_resizing == "L"
          then
            window_resizing = "Unl" set_window_flags()
          else
            window_resizing = "L" set_window_flags()
          end 
          elseif choice == 22 --FONT SIZE
        then
          local uiret4, uireturn4 = reaper.GetUserInputs( "[user input]", 1, "Font size:", tostring(fontSize) )
            if uiret4
          then 
            uireturn4 = tonumber(uireturn4) if type(uireturn4) == 'number' then if uireturn4 > 50 then uireturn4 = 50 end if uireturn4 < 5 then uireturn4 = 5 end fontSize = uireturn4 end gfx.setfont( 1,Font_Type, fontSize )
          end
          elseif choice == 23 -- LOCK SCROLLING
        then
            if gui[2].obj[1].locked == false or gui[2].obj[2].locked == false
          then
            gui[2].obj[2].locked = true gui[2].obj[1].locked = true scrollbar_alphas(.5)
          else
            gui[2].obj[2].locked = false gui[2].obj[1].locked = false scrollbar_alphas(1)
          end
          elseif choice == 24 --POPUP WINDOW DISABLE
        then
          hiding = ""
          elseif choice == 25 --POPUP WINDOW TOP
        then
          hiding = "Top" 
          if math.floor(gfx.dock(-1)&1) ~= 0 then emsg("The popup window cannot take effect while the window is docked.") end         
          elseif choice == 26 --POPUP WINDOW RIGHT
        then
          hiding = "Right" 
          if math.floor(gfx.dock(-1)&1) ~= 0 then emsg("The popup window cannot take effect while the window is docked.") end   
          elseif choice == 27 --POPUP WINDOW BOTTOM
        then
          hiding = "Bottom"
          if math.floor(gfx.dock(-1)&1) ~= 0 then emsg("The popup window cannot take effect while the window is docked.") end   
          elseif choice == 28 --POPUP WINDOW LEFT
        then
          hiding = "Left"
          if math.floor(gfx.dock(-1)&1) ~= 0 then emsg("The popup window cannot take effect while the window is docked.") end 
          elseif choice == 29 --LOAD CONFIGURATION
        then
          local retvald, temperest = reaper.JS_Dialog_BrowseForOpenFiles( "Browse for .ini configuration to load", "", "", "Ini files\0*.ini\0INI files (.ini)\0*.ini\0\0", false)
            if retvald > 0
          then 
              if reaper.MB( "Loading a configuration will permanently overwrite your existing configuration. Would you like to continue?", "[info]", 1 ) == 1
            then
              gui = {}
              generate_framework()
              -- load new config
              FOLDER = "Main" overwrite(temperest) load_buttons() set_window_flags()
            end
          end
          elseif choice == 30 --SAVE AS
        then
          local uiret, uireturn = reaper.GetUserInputs( "[user input]", 1, "Save current configuration as: ,extrawidth=400,separator=~", V_NAME.." (2)" )
            if uiret
          then
            save(filename..uireturn..".ini")
              if  reaper.file_exists( filename..uireturn..".ini" ) == true 
            then 
              omsg("File successfully saved!", "info")
            else
              emsg("File not saved, error occurred.")
            end
          end
          elseif choice == 31 --DOCUMENTATION
        then 
          local tert = "NAMING BUTTONS\n\n"
          tert=tert.."Button can have multiple lines of text by using the hashtag/pound sign (#).\n\n          Example: First line#Second line\n\n"
          tert=tert.."BUTTON ACTIONS\n\nButton actions will insert track FX by entering the prefix 'FX' before typing a space and then the FX name.\n\n          Example: FX ReaEQ\n\n"
          tert=tert.."Also, FX may have prefixes to specify type: VST3:,VST2:,VST:,AU:,JS:, or DX:.\n\n          Example: FX VST3:FabFilter Pro-Q 3\n\n"
          omsg(tert, "Help")          
          elseif choice == 32 -- DONATE LINK 
        then
          local uiret2, uireturn2 = reaper.GetUserInputs( "[donate]", 1, "Donate link: ,extrawidth=400,separator=~", "https://www.paypal.com/donate?business=C85KZZBAZ5KR2&currency_code=USD" )
          elseif choice == 33 --EXIT SCRIPT AND SAVE
        then
          quit = true
        end
      end 
      
    end, 
    [3]      = function(self,o,r,d) if r then return end -- MOVE WINDOW
      if math.floor(gfx.dock(-1)&1) ~= 0 then return end 
      local mreturn, mleft, mtop, mright, mbottom = reaper.BR_Win32_GetWindowRect( window ) if not mreturn then return end 
      local mwidth, mheight = get_width(mright, mleft), get_width(mbottom, mtop)
      local mx, my = reaper.GetMousePosition()
      reaper.JS_Window_SetPosition( window, math.floor(mx-(mwidth/2)), math.floor(my-(mheight/2)), math.floor(mwidth), math.floor(mheight) )
    end,
    [4]      = function(self,o,r,d) -- MARQUEE SELECTION
    
    if not marquee_x then marquee_x, marquee_y = gfx.mouse_x, gfx.mouse_y end
    
    local dragging = false
    
      if gfx.mouse_x < 20
    then
      V_H = V_H - Marquee_Scroll_Speed dragging = true marquee_x = marquee_x + Marquee_Scroll_Speed
    end
      if gfx.mouse_x > gfx.w-20
    then
      V_H = V_H + Marquee_Scroll_Speed dragging = true marquee_x = marquee_x - Marquee_Scroll_Speed
    end
      if gfx.mouse_y < 20
    then
      V_V = V_V - Marquee_Scroll_Speed dragging = true marquee_y = marquee_y + Marquee_Scroll_Speed
    end
      if gfx.mouse_y > gfx.h-20
    then
      V_V = V_V + Marquee_Scroll_Speed dragging = true marquee_y = marquee_y - Marquee_Scroll_Speed
    end
      if dragging == true 
    then
      -- enforce min/max
      if V_V < 0 then marquee_y = marquee_y + V_V V_V = 0 end if V_V > (grid_h-gfx.h) then marquee_y = marquee_y + (V_V-(grid_h-gfx.h)) V_V = (grid_h-gfx.h) end
      if V_H < 0 then marquee_x = marquee_x + V_H V_H = 0 end if V_H > (grid_w-gfx.w) then marquee_x = marquee_x + (V_H-(grid_w-gfx.w)) V_H = (grid_w-gfx.w) end
      -- update scrollbar positions
      update_scrollbar()
    end
    
    local xx, yy, ww, hh = -1,-1,-1,-1
    if gfx.mouse_x > marquee_x then xx, ww = marquee_x, gfx.mouse_x-marquee_x else xx, ww = gfx.mouse_x, marquee_x-gfx.mouse_x end 
    if gfx.mouse_y > marquee_y then yy, hh = marquee_y, gfx.mouse_y-marquee_y else yy, hh = gfx.mouse_y, marquee_y-gfx.mouse_y end 
    gui[1].obj[2].a = 1
    gui[1].obj[2].x = xx
    gui[1].obj[2].y = yy
    gui[1].obj[2].w = ww
    gui[1].obj[2].h = hh

    -- release mouse: select all applicable items
      if r 
      then
      --self.sel = {}
        if marquee_x and marquee_y
      then xx = xx + V_H yy = yy + V_V  
          for z = 1, #gui[1].obj[1].button
        do
            if gui[1].obj[1].button[z].x < xx+ww and gui[1].obj[1].button[z].y < yy+hh and xx < gui[1].obj[1].button[z].x+gui[1].obj[1].button[z].w and yy < gui[1].obj[1].button[z].y+gui[1].obj[1].button[z].h 
          then
              local che = false for ch = 1, #gui[1].obj[1].sel
            do
              if gui[1].obj[1].sel[ch] == z then che = true end
            end
            if che == false then self.sel[#self.sel+1] = z end
          end
        end
      end
      gui[1].obj[2].a = 0 marquee_x, marquee_y = nil, nil return update_marquee()
      end  
    
    end, 
    [5] = function(self,o,r,d) -- MIDDLE WHEEL MOUSESCROLL
      if Disable_Middle_Mouse_Scrolling == true then return end 
      -- view scrolling
      if mouseGrab_y then scrollGrab_x, scrollGrab_y = mouseGrab_x, mouseGrab_y mouseGrab_x, mouseGrab_y = nil, nil end
      if gui[2].obj[2].locked == false then V_V = V_V + ((scrollGrab_y-my)/V_Z) end
      if gui[2].obj[1].locked == false then V_H = V_H + ((scrollGrab_x-mx)/V_Z) end
      scrollGrab_x, scrollGrab_y = mx, my
      -------------------------------------
      -- enforce min/max
      if gui[2].obj[2].locked == false then if V_V < 0 then V_V = 0 end if V_V > (grid_h-gfx.h) then V_V = (grid_h-gfx.h) end end
      if gui[2].obj[1].locked == false then if V_H < 0 then V_H = 0 end if V_H > (grid_w-gfx.w) then V_H = (grid_w-gfx.w) end end
      -- update scrollbar positions
      update_scrollbar()
    end,
    },
  mouse      =
    { -- index [1] must always be left-click
    [1]        = 1,                
    [2]        = 2,
    [3]        = 10,
    [4]        = 9,
    [5]        = 64
    },
  hold       = 
    {
    [1]        = true,
    [2]        = false,
    [3]        = true,
    [4]        = true,
    [5]        = true
    }
  } 
  
    -- HORIZONTAL SCROLL BAR
    local locker = false local captioner = "left-click to adjust horizontal scroll, right-click to lock scrollbar" local alph = .97
    if reaper.HasExtState( V_NAME, "SH_L" ) then if reaper.GetExtState( V_NAME, "SH_L" ) == "true" then locker = true captioner = "left-click to adjust horizontal scroll, right-click to unlock scrollbar" alph = .5 end end
    gui[2].obj[1] = {
    id         = 2,                                                 -- object classification
    level      = 1,
    caption    = captioner,  -- caption display
    hc         = 0,                                                 -- current hover alpha (default '0')
    ha         = .05,                                                -- hover alpha
    hca        = .1,                                                -- hover click alpha 
    ol         = {r=1,g=1,b=1,a=.2},                                -- rect: object's outline
    r          = .5,                                                -- rect: red
    g          = .5,                                                -- rect: green
    b          = .5,                                                -- rect: blue
    a          = alph,                                                -- rect: alpha
    f          = 1,                                                 -- rect: filled  
    x          = 0,                                                 -- x
    y          = -100,                                          -- y
    w          = gfx.w,                                             -- w
    h          = 20,                                                -- h
    locked     = locker, 
    can_zoom   = false,                                             -- whether object rectangle zooms with global
    can_scroll = false,                                             -- whether object rectangle scrolls with global     
    button     = {},                                                -- index of buttons that object holds
    static     = {},                                                -- index of static graphics that object holds
    func       = 
    { 
    -- non-indexed function
    --[0]      = function(o,r) if r then --[[msg("release")]] return end  end,                     -- functions receive object index
    -- mouse_cap functions
    [1]      = 
    function(self,o,r,d) local gmx = gfx.mouse_x if self.locked == true then return end
    
      if r
      then
      self.button[1].ol.a = 0
      return 
      end
    
      if gmx > gfx.w-25 then gmx = gfx.w-25 end if gmx < 25 then gmx = 25 end
      gmx = gmx - 25
      
      V_H = ((grid_w)-(gfx.w/V_Z))*(gmx/(gfx.w-50)) --V_H = V_H / V_Z
      
      self.button[1].ol.a = .2
      local ax = (gfx.w-50)*   ( V_H / ((grid_w)-(gfx.w/V_Z)) )
      self.button[1].x = ax
      
    end,                     -- functions receive object index
    [2]      = function(self,o,r) 
      if not r then --[[msg("release")]] return end  
      if self.locked == true then self.a = .97 self.locked = false self.caption = "left-click to adjust horizontal scroll, right-click to lock scrollbar" else self.a = .5 self.locked = true self.caption = "left-click to adjust horizontal scroll, right-click to unlock scrollbar" end 
    end,                     -- functions receive object index 
    [3]      = function(o,r) if r then --[[msg("release")]] return end  end                      -- functions receive object index
    },
    mouse      =
    { -- index [1] must always be left-click
    [1]        = 1,                
    [2]        = 2,
    [3]        = 64
    },
    hold       = 
    {
    [1]        = true,
    [2]        = false,
    [3]        = false
    }
    }
    gui[2].obj[1].button[1] = {
    id         = 1,                                                 -- button classification
    caption    = "",  -- caption display
    type       = "rect",                                            -- draw type: "rect" or "circ"
    ol         = {r=1,g=1,b=1,a=0},                                -- rect: button's outline
    hc         = 0,                                                 -- current hover alpha (default '0')
    ha         = .05,                                                -- hover alpha
    hca        = .1,                                                -- hover click alpha 
    r          = .1,                                                -- r     (rect)
    g          = .1,                                                -- g     (rect)
    b          = .1,                                                -- b     (rect)
    a          = 1,                                                 -- alpha (rect)
    rt         = .5,                                                -- r     (text)
    gt         = .5,                                                -- g     (text)
    bt         = .5,                                                -- b     (text)
    at         = .5,                                                -- alpha (text)
    x          = 0,                                                 -- x
    y          = 1,                                                 -- y
    w          = 50,                                                -- width
    h          = 18,                                                -- height
    f          = 1,                                                 -- filled
    rs         = 10,                                                -- circle: radius
    aa         = true,                                              -- circle: antialias         
    txt        = "",                                                -- text: "" disables text for button
    th         = 1,                                                 -- text 'h' flag
    tv         = 4,                                                 -- text 'v' flag  
    fo         = "Roboto",                                           -- font settings will have no affect unless: font_changes = true
    fs         = 12,                                                -- font size
    ff         = nil,                                               -- font flags ("b", "i", "u" = bold, italic, underlined. Flags can be combined, or value can be nil)
    can_zoom   = false,                                             -- whether object rectangle zooms with global: font_changes must be true in order for font size to adjust
    can_scroll = false,                                             -- whether object rectangle scrolls with global   
    act_off    = 2,  
    func       = 
    { 
    -- non-indexed function
    [0]        = function(o,b,r) if r then --[[msg("release")]] return end end,                 -- functions receive object and button index
    -- mouse_cap functions
    [1]        = function(o,b,r) if r then --[[msg("release")]] return end end,                 -- functions receive object and button index
    [2]        = function(o,b,r) if r then --[[msg("release")]] return end end,                 -- functions receive object and button index
    [3]        = function(o,b,r) if r then --[[msg("release")]] return end end                  -- functions receive object and button index
    },
    mouse      =
    {
    [1]        = 1,             -- index [1] must always be left click
    [2]        = 2,
    [3]        = 64
    },
    hold       = 
    {
    [1]        = true,
    [2]        = false,
    [3]        = false
    }
    }
    -- VERTICAL SCROLL BAR
    local locker = false local captioner = "left-click to adjust vertical scroll, right-click to lock scrollbar" local alph = .97
    if reaper.HasExtState( V_NAME, "SV_L" ) then if reaper.GetExtState( V_NAME, "SV_L" ) == "true" then locker = true captioner = "left-click to adjust vertical scroll, right-click to unlock scrollbar" alph = .5 end end
    gui[2].obj[2] = {
    id         = 2,                                                 -- object classification
    caption    = captioner,  -- caption display
    level = 2,
    hc         = 0,                                                 -- current hover alpha (default '0')
    ha         = .05,                                                -- hover alpha
    hca        = .1,                                                -- hover click alpha 
    ol         = {r=1,g=1,b=1,a=.2},                                -- rect: object's outline
    r          = .5,                                                -- rect: red
    g          = .5,                                                -- rect: green
    b          = .5,                                                -- rect: blue
    a          = alph,                                                -- rect: alpha
    f          = 1,                                                 -- rect: filled  
    x          = -100,                                                 -- x
    y          = 0,                                          -- y
    w          = 20,                                             -- w
    h          = gfx.h,                                                -- h
    locked     = locker, 
    can_zoom   = false,                                             -- whether object rectangle zooms with global
    can_scroll = false,                                             -- whether object rectangle scrolls with global     
    button     = {},                                                -- index of buttons that object holds
    static     = {},                                                -- index of static graphics that object holds
    func       = 
    { 
    -- non-indexed function
    --[0]      = function(o,r) if r then --[[msg("release")]] return end  end,                     -- functions receive object index
    -- mouse_cap functions
    [1]      = 
    function(self,o,r,d) local gmy = gfx.mouse_y if self.locked == true then return end 
    
      if r
      then
      self.button[1].ol.a = 0
      return
      end
    
      if gmy > gfx.h-45 then gmy = gfx.h-45 end if gmy < 25 then gmy = 25 end
      gmy = gmy - 25
      
      V_V = ((grid_h)-(gfx.h/V_Z))*(gmy/(gfx.h-70)) --V_V = V_V / V_Z
      
      self.button[1].ol.a = .2
      local ay = (gfx.h-70)*   ( V_V / ((grid_h)-(gfx.h/V_Z)) )
      self.button[1].y = ay
    
    end,                     -- functions receive object index
    [2]      = function(self,o,r) 
      if not r then --[[msg("release")]] return end  
      if self.locked == true then self.locked = false self.a = .97 self.caption = "left-click to adjust vertical scroll, right-click to lock scrollbar" else self.a = .5 self.locked = true self.caption = "left-click to adjust vertical scroll, right-click to unlock scrollbar" end 
    end,                     -- functions receive object index 
    [3]      = function(o,r) if r then --[[msg("release")]] return end  end                      -- functions receive object index
    },
    mouse      =
    { -- index [1] must always be left-click
    [1]        = 1,                
    [2]        = 2,
    [3]        = 64
    },
    hold       = 
    {
    [1]        = true,
    [2]        = false,
    [3]        = false
    }
    }
    gui[2].obj[2].button[1] = {
    id         = 1,                                                 -- button classification
    caption    = "",  -- caption display
    type       = "rect",                                            -- draw type: "rect" or "circ"
    ol         = {r=1,g=1,b=1,a=0},                                -- rect: button's outline
    hc         = 0,                                                 -- current hover alpha (default '0')
    ha         = .05,                                                -- hover alpha
    hca        = .1,                                                -- hover click alpha 
    r          = .1,                                                -- r     (rect)
    g          = .1,                                                -- g     (rect)
    b          = .1,                                                -- b     (rect)
    a          = 1,                                                 -- alpha (rect)
    rt         = .5,                                                -- r     (text)
    gt         = .5,                                                -- g     (text)
    bt         = .5,                                                -- b     (text)
    at         = .5,                                                -- alpha (text)
    x          = 0,                                                 -- x
    y          = 0,                                                 -- y
    w          = 18,                                                -- width
    h          = 50,                                                -- height
    f          = 1,                                                 -- filled
    rs         = 10,                                                -- circle: radius
    aa         = true,                                              -- circle: antialias         
    txt        = "",                                                -- text: "" disables text for button
    th         = 1,                                                 -- text 'h' flag
    tv         = 4,                                                 -- text 'v' flag  
    fo         = "Roboto",                                           -- font settings will have no affect unless: font_changes = true
    fs         = 12,                                                -- font size
    ff         = nil,                                               -- font flags ("b", "i", "u" = bold, italic, underlined. Flags can be combined, or value can be nil)
    can_zoom   = false,                                             -- whether object rectangle zooms with global: font_changes must be true in order for font size to adjust
    can_scroll = false,                                             -- whether object rectangle scrolls with global   
    act_off    = 2,  
    func       = 
    { 
    -- non-indexed function
    [0]        = function(o,b,r) if r then --[[msg("release")]] return end end,                 -- functions receive object and button index
    -- mouse_cap functions
    [1]        = function(o,b,r) if r then --[[msg("release")]] return end end,                                                          -- functions receive object and button index
    [2]        = function(o,b,r) if r then --[[msg("release")]] return end end,                 -- functions receive object and button index
    [3]        = function(o,b,r) if r then --[[msg("release")]] return end end                  -- functions receive object and button index
    },
    mouse      =
    {
    [1]        = 1,             -- index [1] must always be left click
    [2]        = 2,
    [3]        = 64
    },
    hold       = 
    {
    [1]        = true,
    [2]        = false,
    [3]        = false
    }
    }
    if SC_H == true then gui[2].obj[2].button[1].h = 70 end 
  
end generate_framework()

function get_folder_line(line, folder) local val = false
    for i = 3, line:len()
  do
    if line:sub(2,i) == folder then val = true break end
  end
  return val
end

function load_file(name)
  local loader = {}
    if  reaper.file_exists( name ) == true 
  then 
    local file = io.open(name, "r") 
      for line in file:lines() 
    do
      if line:find("~") then table.insert (loader, line) end
    end
    file:close()
  end 
  
  -- account for previous inis
    if loader[1]
  then
      if loader[1]:sub(1,5) == "~Main"
    then
      table.insert (loader, 1, "~GLOBALS~W_R:L~W_D:0.0~W_P:~snap:true~G_S:true~G_W:50~G_C:16711680~G_T:2~fontS:20~DCol:8355711~DTCol:0~W_T:true~SH_L:false~SV_L:false")
    end
  end
  
  return loader
end

function overwrite(filenamer)
  
  local loader = load_file(filenamer)

  if #loader < 3 then return end 
  
  local ld = split(loader[1], "~") if not ld then ld = {} end  
  -- process global strings
  if ld[2] then ld[2] = replace_text(ld[2], "W_R:", "")end                               
  if ld[3] then ld[3] = replace_text(ld[3], "W_D:", "")end                             
  if ld[4] then ld[4] = replace_text(ld[4], "W_P:", "")end                                
  if ld[5] then ld[5] = replace_text(ld[5], "snap:", "")end                                
  if ld[6] then ld[6] = replace_text(ld[6], "G_S:", "")end                                  
  if ld[7] then ld[7] = replace_text(ld[7], "G_W:", "")end                               
  if ld[8] then ld[8] = replace_text(ld[8], "G_C:", "")end                               
  if ld[9] then ld[9] = replace_text(ld[9], "G_T:", "")end                                
  if ld[10] then ld[10] = replace_text(ld[10], "fontS:", "")end                             
  if ld[11] then ld[11] = replace_text(ld[11], "DCol:", "")end                                
  if ld[12] then ld[12] = replace_text(ld[12], "DTCol:", "")end                                
  if ld[13] then ld[13] = replace_text(ld[13], "W_T:", "")end                               
  if ld[14] then ld[14] = replace_text(ld[14], "SH_L:", "")end                                 
  if ld[15] then ld[15] = replace_text(ld[15], "SV_L:", "")end
  if ld[16] then ld[16] = replace_text(ld[16], "SC_H:", "")end                                 
  if ld[17] then ld[17] = replace_text(ld[17], "SC_V:", "")end
  
  -- load globals
  if ld[2] then window_resizing = ld[2] end
  if ld[3] then d = ld[3] end
  if ld[4] then hiding = ld[4] end
  if ld[5] then snap            = ld[5] if snap == "true" then snap = true else snap = false end end
  if ld[6] then show_grid       = ld[6] end
  if ld[7] then grid            = tonumber(ld[7]) end
  if ld[8] then line_col        = tonumber(ld[8]) end
  if ld[9] then lineW           = tonumber(ld[9]) end
  if ld[10] then fontSize        = tonumber(ld[10]) end
  if ld[11] then default_col     = tonumber(ld[11]) end
  if ld[12] then default_col_text= tonumber(ld[12]) end
  if ld[13] then show_title_bar  = ld[13] if show_title_bar == "true" then show_title_bar = true else show_title_bar = false end end
  if ld[14] then gui[2].obj[1].locked = ld[14] if gui[2].obj[1].locked == "true" then gui[2].obj[1].locked = true else gui[2].obj[1].locked = false end end
  if ld[15] then gui[2].obj[2].locked = ld[15] if gui[2].obj[2].locked == "true" then gui[2].obj[2].locked = true else gui[2].obj[2].locked = false end end
  if ld[16] then SC_H = ld[16] if SC_H == "true" then SC_H = true else SC_H = false end end
  if ld[17] then SC_V = ld[17] if SC_V == "true" then SC_V = true else SC_V = false end end

  local file = io.open(filename..V_NAME..".ini", "w") 
    
    for d = 1, #loader
  do
    file:write(loader[d].."\n")
  end
  file:close() loader = nil
  
end

function save(filenamer)

  -- load ini
  local loader = load_file(filename..V_NAME..".ini") 
  
  -- save globals
  local template = filename..V_NAME..".ini" if filenamer then template = filenamer end
  local file = io.open(template, "w") local found_match, dead_zone, one_time = false, false, false if #loader < 1 then loader[1] = "" end
  local wd, wx, wy, ww, wh = gfx.dock( -1, 0, 0, 0, 0 )
  file:write("~GLOBALS")
  file:write("~W_R:"..window_resizing)  
  file:write("~W_D:"..wd)
  file:write("~W_P:"..hiding)
  file:write("~snap:"..tostring(snap))
  file:write("~G_S:"..show_grid)
  file:write("~G_W:"..tostring(grid))
  file:write("~G_C:"..tostring(line_col))
  file:write("~G_T:"..tostring(lineW))
  file:write("~fontS:"..tostring(fontSize))
  file:write("~DCol:"..tostring(default_col))
  file:write("~DTCol:"..tostring(default_col_text))
  file:write("~W_T:"..tostring(show_title_bar))
  file:write("~SH_L:"..tostring(gui[2].obj[1].locked))
  file:write("~SV_L:"..tostring(gui[2].obj[2].locked))
  file:write("~SC_H:"..tostring(SC_H))
  file:write("~SC_V:"..tostring(SC_V).."~\n")
  
  -- save buttons
  
  local iterate = #loader if iterate < 2 then iterate = 2 end
    for l = 2, iterate
  do
  
      if iterate ~= 2
    then
        if get_folder_line(loader[l],FOLDER) == true 
      then 
        found_match, dead_zone = true, true
      else
        if dead_zone == true and loader[l]:sub(1,1) == "~" then dead_zone = false end 
          if dead_zone == false and #loader > 1
        then
          --REWRITE FILE
          file:write(loader[l])   
          file:write("\n")
        end
      end
    end
    
    if found_match == false and l == #loader then found_match = true end
    
      if found_match == true and one_time == false or iterate == 2
    then one_time = true
      -- Write folder data
      file:write("~"..FOLDER)
      file:write("~VV:"..tostring(V_V))
      file:write("~VH:"..tostring(V_H))
      file:write("~BIMG:"..backgroundImage)
      if not BG_W then file:write("~BWID:") else file:write("~BWID:"..BG_W) end
      if not BG_H then file:write("~BHEI:") else file:write("~BHEI:"..BG_H) end
      file:write("~BSTR:"..BG_stretch)
      file:write("~BCOL:"..tostring(background_col).."~\n")

        for a = 1, #gui[1].obj[1].button
      do 
        --[[BUTTON ID]]       file:write(" ~ID: ") file:write(gui[1].obj[1].button[a].id) 
        --[[BUTTON X]]        file:write(" ~X: ") file:write(gui[1].obj[1].button[a].x) 
        --[[BUTTON Y]]        file:write(" ~Y: ") file:write(gui[1].obj[1].button[a].y) 
        --[[BUTTON W]]        file:write(" ~W: ") file:write(gui[1].obj[1].button[a].w) 
        --[[BUTTON H]]        file:write(" ~H: ") file:write(gui[1].obj[1].button[a].h) 
        --[[BUTTON COLOR]]    file:write(" ~B.COL: ") file:write(reaper.ColorToNative( (gui[1].obj[1].button[a].r*255), (gui[1].obj[1].button[a].g*255), (gui[1].obj[1].button[a].b*255) ) ) 
        --[[TEXT COLOR]]      file:write(" ~T.COL: ") file:write(reaper.ColorToNative( (gui[1].obj[1].button[a].rt*255), (gui[1].obj[1].button[a].gt*255), (gui[1].obj[1].button[a].bt*255) ) ) 
        --[[TEXT ALPHA]]      file:write(" ~A: ") file:write(gui[1].obj[1].button[a].at) 
        --[[BUTTON IMG]]      file:write(" ~IMG: ") file:write(gui[1].obj[1].button[a].img) 
        --[[BUTTON TXT]]      file:write(" ~TXT: ") file:write(gui[1].obj[1].button[a].txt) 
        --[[BUTTON CAPTION]]  file:write(" ~CAPTION: ") file:write(gui[1].obj[1].button[a].caption) 
          if gui[1].obj[1].button[a].id == 1
        then
          --[[BUTTON ACTION]] for p = 1, 4 do file:write(" ~AC. "..tostring(p)..": ") file:write(gui[1].obj[1].button[a].action[p]) end
          elseif gui[1].obj[1].button[a].id > 1 and gui[1].obj[1].button[a].id < 4
        then
          for p = 1, 13 do file:write(" ~AN. "..tostring(p)..": ") file:write(gui[1].obj[1].button[a].name[p]) end for p = 1, 13 do file:write(" ~AC. "..tostring(p)..": ") file:write(gui[1].obj[1].button[a].action[p]) end
          elseif gui[1].obj[1].button[a].id > 3
        then
          --[[BUTTON FOLDER]]  file:write(" ~B.FOLDER: ") file:write(gui[1].obj[1].button[a].folderid)
          --[[BUTTON PFOLDER]] file:write(" ~B.P.FOLDER: ") file:write(gui[1].obj[1].button[a].prev_fold)
        end
        if gui[1].obj[1].button[a].vt then --[[BUTTON VTEXT]] file:write(" ~T.V: ") file:write(gui[1].obj[1].button[a].vt) end
        file:write("\n")
      end
    end
    
  
  end
  
  file:close() loader = nil
  
end

function load_buttons(filenamer) counter = -1 

  -- set scrollbar
  update_scrollbar()
  -- load file into string
  local template = filename..V_NAME..".ini" if filenamer then template = filenamer end
  local loader = load_file(template)
  
    if filenamer
  then
      for d = 1, #loader 
    do
      
    end
  end

  -- process strings
    for r = 2, #loader
  do 
    loader[r] = replace_text(loader[r], " ~ID: ", "")
    loader[r] = replace_text(loader[r], " ~X: ", "~")
    loader[r] = replace_text(loader[r], " ~Y: ", "~")
    loader[r] = replace_text(loader[r], " ~W: ", "~")
    loader[r] = replace_text(loader[r], " ~H: ", "~")
    loader[r] = replace_text(loader[r], " ~B.COL: ", "~")
    loader[r] = replace_text(loader[r], " ~T.COL: ", "~")
    loader[r] = replace_text(loader[r], " ~A: ", "~")
    loader[r] = replace_text(loader[r], " ~IMG: ", "~")
    loader[r] = replace_text(loader[r], " ~TXT: ", "~")
    loader[r] = replace_text(loader[r], " ~CAPTION: ", "~")
      for n = 1, 14
    do
      loader[r] = replace_text(loader[r], " ~AN. "..tostring(n)..": ", "~")
      loader[r] = replace_text(loader[r], " ~AC. "..tostring(n)..": ", "~")
    end
    loader[r] = replace_text(loader[r], " ~B.FOLDER: ", "~")
    loader[r] = replace_text(loader[r], " ~B.P.FOLDER: ", "~")
    loader[r] = replace_text(loader[r], " ~T.V: ", "~")
  end

  -- create new buttons
  local begin = false
    for a = 2, #loader 
  do 
    local ld = split(loader[a], "~") 
    
    if loader[a]:sub(1,1) == "~" and begin == true then break end 

      if begin == true
    then 
      for z = 1, 8 do ld[z] = tonumber(ld[z]) end local ld_r, ld_g, ld_b = reaper.ColorFromNative(ld[6]) ld_r, ld_g, ld_b = ld_r/255, ld_g/255, ld_b/255 local ld_rt, ld_gt, ld_bt = reaper.ColorFromNative(ld[7]) ld_rt, ld_gt, ld_bt = ld_rt/255, ld_gt/255, ld_bt/255 
      local nid, iiw, iih, ttype = -1, -1, -1, "rect" if reaper.file_exists(ld[9]) == true then nid = get_iid() if gfx.loadimg(nid,ld[9]) ~= -1 then iiw, iih = gfx.getimgdim(nid) ttype = "img" end end 
            
        if tonumber(ld[1]) == 1 --BUTTON
      then 
        local ld_action = {} for z = 12, 15 do if ld[z] then ld_action[#ld_action+1] = ld[z] end end
        local shmutton = new_button( ld[1], ld[2], ld[3], ld[4], ld[5], ld_r, ld_g, ld_b, ld[9], nid, iiw, iih, ld[10], "", ld_action, ttype, ld[11]) 
        shmutton.rt, shmutton.gt, shmutton.bt, shmutton.at = ld_rt, ld_gt, ld_bt, ld[8] if ld[16] then shmutton.vt = 1 end 
        elseif tonumber(ld[1]) > 1 and tonumber(ld[1]) < 4 --MENU BUTTON
      then
        local ld_name = {} for z = 12, 24 do if ld[z] then ld_name[#ld_name+1] = ld[z] end end
        local ld_action = {} for z = 25, 37 do if ld[z] then ld_action[#ld_action+1] = ld[z] end end
        local shmutton = new_button( ld[1], ld[2], ld[3], ld[4], ld[5], ld_r, ld_g, ld_b, ld[9], nid, iiw, iih, ld[10], ld_name, ld_action, ttype, ld[11]) 
        shmutton.rt, shmutton.gt, shmutton.bt, shmutton.at = ld_rt, ld_gt, ld_bt, ld[8]      
        elseif tonumber(ld[1]) > 3 --FOLDER/EXIT BUTTON
      then
        local shmutton = new_button( ld[1], ld[2], ld[3], ld[4], ld[5], ld_r, ld_g, ld_b, ld[9], nid, iiw, iih, ld[10], "", "", ttype, ld[11], ld[12], ld[13]) 
        shmutton.rt, shmutton.gt, shmutton.bt, shmutton.at = ld_rt, ld_gt, ld_bt, ld[8] if ld[14] and tonumber(ld[1]) == 4 then shmutton.vt = 1 end 
      end
      
    end
    
    -- found folder! initiate load
      if ld[1] == FOLDER 
    then begin = true 
      -- process data
      for i = 1, 8 do if not ld[i] then ld[i] = "" end end 
      ld[2] = replace_text(ld[2], "VV:", "")
      ld[3] = replace_text(ld[3], "VH:", "")
      ld[4] = replace_text(ld[4], "BIMG:", "")
      ld[5] = replace_text(ld[5], "BWID:", "")
      ld[6] = replace_text(ld[6], "BHEI:", "")
      ld[7] = replace_text(ld[7], "BSTR:", "")
      ld[8] = replace_text(ld[8], "BCOL:", "")
      -- load folder settings
      if type(tonumber(ld[2])) == 'number' then V_V = tonumber(ld[2]) else V_V = 0 end
      if type(tonumber(ld[3])) == 'number' then V_H = tonumber(ld[3]) else V_H = 0 end
      backgroundImage = ld[4] if ld[4] ~= "" then gfx.loadimg(1023,backgroundImage) bakw, bakh = gfx.getimgdim(1023) end
      if type(tonumber(ld[5])) == 'number' then BG_W = tonumber(ld[5]) else BG_W = nil end
      if type(tonumber(ld[6])) == 'number' then BG_H = tonumber(ld[6]) else BG_H = nil end
      BG_stretch = ld[7]
      if type(tonumber(ld[8])) == 'number' then background_col = tonumber(ld[8]) else background_col = 0 end gui[1].obj[1].r, gui[1].obj[1].g, gui[1].obj[1].b = reaper.ColorFromNative(background_col) gui[1].obj[1].r, gui[1].obj[1].g, gui[1].obj[1].b = gui[1].obj[1].r/255, gui[1].obj[1].g/255, gui[1].obj[1].b/255
    end
  end 
  
  --if begin == false then FOLDER = "Main" load_buttons() end
  
  -- set global font
  gfx.setfont( 1,Font_Type, fontSize )
  
  loader = nil
end --load_buttons()

function delete_folder(del_folder)
 
  local loader2 = {}
  local loader = {}
  local sub_folders = {}

  -- load ini
  local loader = load_file(filename..V_NAME..".ini")

  local f_start = -1
    for fold = 2, #loader
  do  
      if f_start ~= -1 
    then
      if loader[fold]:sub(1,1) == "~" then f_start = -1 end
        if loader[fold]:find(" ~B.FOLDER: ") 
      then local a1, a2 = loader[fold]:find(" ~B.FOLDER: ") local b1, b2 = loader[fold]:find(" ~B.P.FOLDER: ") 
        if loader[fold]:sub(b2+1) == del_folder then sub_folders[#sub_folders+1] = loader[fold]:sub(a2+1, b1-1) end
      end 
    end
    if get_folder_line(loader[fold],del_folder) == true and loader[fold]:sub(1,1) == "~" then f_start = fold end 
    if f_start == -1 then loader2[#loader2+1] = loader[fold] end 
  end
  
  -- rewrite file
  local file = io.open(filename..V_NAME..".ini", "w")
  file:write(loader[1].."\n")
    for fol = 1, #loader2
  do
    file:write(loader2[fol].."\n")
  end file:close()
  
  -- delete subfolders as well
  for sf = 1, #sub_folders do delete_folder(sub_folders[sf]) end
  
end

function duplicate_folder(old_folder,new_folder)
  
 
  local loader2 = {}
  local loader = {}
  local sub_folders = {}
  
  -- load ini
  local loader = load_file(filename..V_NAME..".ini")

  local f_start = -1
    for fold = 2, #loader
  do  
      if f_start ~= -1 
    then
      if loader[fold]:sub(1,1) == "~" then f_start = -1 end
        if loader[fold]:find(" ~B.FOLDER: ") 
      then local a1, a2 = loader[fold]:find(" ~B.FOLDER: ") local b1, b2 = loader[fold]:find(" ~B.P.FOLDER: ") 
          if loader[fold]:sub(b2+1) == old_folder 
        then 
          sub_folders[#sub_folders+1] = loader[fold]:sub(a2+1, b1-1) 
        end
      end 
    end
    if get_folder_line(loader[fold],old_folder) == true and loader[fold]:sub(1,1) == "~" then f_start = fold end 
    if f_start ~= -1 and loader[fold]:sub(1,1) ~= "~" then loader2[#loader2+1] = loader[fold] end 
  end
  
  -- write existing lines
  local file = io.open(filename..V_NAME..".ini", "w")
    for fol = 1, #loader
  do
    file:write(loader[fol].."\n")
  end 
  
  -- write new lines
  file:write("~"..new_folder.."\n")
    for i = 1, #loader2
  do
    file:write(loader2[i].."\n") --msg(loader2[i])
  end
  
  file:close()
  
  -- duplicate subfolders
  for sf = 1, #sub_folders do duplicate_folder( sub_folders[sf],reaper.genGuid() ) msg(sub_folders[sf]) end
  
end

function pre_draw() 
  if hiding ~= "" and hide == true then return end
  -- draw background
    if backgroundImage ~= "" 
  then -- draw background image
    local tempW, tempH = bakw, bakh if BG_W then tempW = BG_W end if BG_H then tempH = BG_H end if BG_stretch == "Stretch" then tempW, tempH = gfx.w, gfx.h end
    gfx.x, gfx.y=0,0 gfx.blit(1023,1,0,0,0,bakw,bakh,0,0,tempW,tempH) 
  else -- draw background color
    gfx.set(gui[1].obj[1].r, gui[1].obj[1].g, gui[1].obj[1].b, 1) gfx.rect(0,0,gfx.w,gfx.h,1)
  end
  --^^^^^^^^^^^^^^^^
  -- draw grid
    if show_grid == "true"
  then
    local rrr9, ggg9, bbb9 = reaper.ColorFromNative(line_col) rrr9, ggg9, bbb9 = rrr9/255, ggg9/255, bbb9/255 gfx.set(rrr9,ggg9,bbb9, 1) --gfx.line(a*grid,0,a*grid,gfx.h,1 )
      for a = 0, math.ceil((grid_w/grid)) --VERTICAL
    do
      local xer = (a*grid)-(lineW/2) xer = xer - V_H xer = xer * V_Z local yer = 0 yer = yer - V_V yer = yer * V_Z
      gfx.rect(xer,yer,lineW,(grid_h*V_Z),1 )
    end
      for a = 0, math.ceil((grid_h/grid)) -- HORIZONAL
    do
      local xer = 0 xer = xer - V_H xer = xer * V_Z local yer = (a*grid)-(lineW/2) yer = yer - V_V yer = yer * V_Z
      gfx.rect(xer,yer,(grid_w*V_Z),lineW,1 )
    end
  end
  --^^^^^^^^
  gui[1].obj[1].w, gui[1].obj[1].h = gfx.w, gfx.h -- set GUI width/height
  check_mouse()
  draw() 
  -- horizontal scroll bar
  if SC_H == false then gui[2].obj[1].y = gfx.h-20 gui[2].obj[1].w = gfx.w else gui[2].obj[1].y = -300 end
  --vertical scroll bar
  if SC_V == false then gui[2].obj[2].x = gfx.w-20 gui[2].obj[2].h = gfx.h-20 if SC_H == true then gui[2].obj[2].h = gfx.h end else gui[2].obj[2].x = -300 end

end

function auto_window_focus() local Mx, My = reaper.GetMousePosition()

  if Auto_Refocus == false then return end

  local return2, left, top, right, bottom = reaper.BR_Win32_GetWindowRect( window ) if not return2 then return end 
  
  if reaper.JS_Window_GetFocus() == window then auto_refocus = 1 end
  
    if Mx < left or Mx > right or My < top or My > bottom 
  then 
      if auto_refocus == 1 
    then
        if Refocus_to_Main == true
      then
        reaper.JS_Window_SetFocus( reaper.GetMainHwnd() ) auto_refocus = 0 
      else 
        reaper.JS_Window_SetFocus( reaper.JS_Window_FromPoint( Mx, My ) ) auto_refocus = 0 
      end
    end
  end 

end

function init()
  local d = 0
  d, W_W, W_H, W_X, W_Y = 0,display_w/2,300,display_w/4,200
  
  -- load globals
  local loader = {}
    if  reaper.file_exists( filename..V_NAME..".ini" ) == true 
  then 
    local file = io.open(filename..V_NAME..".ini", "r") 
      for line in file:lines() 
    do
      table.insert (loader, line)
    end
    file:close()
  end 
  
  local ld = split(loader[1], "~") if not ld then ld = {} end loader = nil 
  -- process global strings
  if ld[2] then ld[2] = replace_text(ld[2], "W_R:", "")end                               
  if ld[3] then ld[3] = replace_text(ld[3], "W_D:", "")end                             
  if ld[4] then ld[4] = replace_text(ld[4], "W_P:", "")end                                
  if ld[5] then ld[5] = replace_text(ld[5], "snap:", "")end                                
  if ld[6] then ld[6] = replace_text(ld[6], "G_S:", "")end                                  
  if ld[7] then ld[7] = replace_text(ld[7], "G_W:", "")end                               
  if ld[8] then ld[8] = replace_text(ld[8], "G_C:", "")end                               
  if ld[9] then ld[9] = replace_text(ld[9], "G_T:", "")end                                
  if ld[10] then ld[10] = replace_text(ld[10], "fontS:", "")end                             
  if ld[11] then ld[11] = replace_text(ld[11], "DCol:", "")end                                
  if ld[12] then ld[12] = replace_text(ld[12], "DTCol:", "")end                                
  if ld[13] then ld[13] = replace_text(ld[13], "W_T:", "")end                               
  if ld[14] then ld[14] = replace_text(ld[14], "SH_L:", "")end                                 
  if ld[15] then ld[15] = replace_text(ld[15], "SV_L:", "")end
  if ld[16] then ld[16] = replace_text(ld[16], "SC_H:", "")end                                 
  if ld[17] then ld[17] = replace_text(ld[17], "SC_V:", "")end
  
  -- load globals
  if ld[2] then window_resizing = ld[2] end
  if ld[3] then d = ld[3] end
  if ld[4] then hiding = ld[4] end
  if ld[5] then snap            = ld[5] if snap == "true" then snap = true else snap = false end end
  if ld[6] then show_grid       = ld[6] end
  if ld[7] then grid            = tonumber(ld[7]) end
  if ld[8] then line_col        = tonumber(ld[8]) end
  if ld[9] then lineW           = tonumber(ld[9]) end
  if ld[10] then fontSize        = tonumber(ld[10]) end
  if ld[11] then default_col     = tonumber(ld[11]) end
  if ld[12] then default_col_text= tonumber(ld[12]) end
  if ld[13] then show_title_bar  = ld[13] if show_title_bar == "true" then show_title_bar = true else show_title_bar = false end end
  if ld[14] then gui[2].obj[1].locked = ld[14] if gui[2].obj[1].locked == "true" then gui[2].obj[1].locked = true else gui[2].obj[1].locked = false end end
  if ld[15] then gui[2].obj[2].locked = ld[15] if gui[2].obj[2].locked == "true" then gui[2].obj[2].locked = true else gui[2].obj[2].locked = false end end
  if ld[16] then SC_H = ld[16] if SC_H == "true" then SC_H = true else SC_H = false end end
  if ld[17] then SC_V = ld[17] if SC_V == "true" then SC_V = true else SC_V = false end end

  -- get x,y,w,h
    if Reset_Window_Position == false
  then
    if reaper.HasExtState( V_NAME, "W_W" ) then W_W = tonumber(reaper.GetExtState( V_NAME, "W_W" )) end if W_W < Window_Width_Minimum then W_W = Window_Width_Minimum end 
    if reaper.HasExtState( V_NAME, "W_H" ) then W_H = tonumber(reaper.GetExtState( V_NAME, "W_H" )) end if W_H < Window_Height_Minimum then W_H = Window_Height_Minimum end
    if reaper.HasExtState( V_NAME, "W_X" ) then W_X = tonumber(reaper.GetExtState( V_NAME, "W_X" )) end 
    if reaper.HasExtState( V_NAME, "W_Y" ) then W_Y = tonumber(reaper.GetExtState( V_NAME, "W_Y" )) end 
  end
  -- init GFX window
  gfx.init(V_NAME, W_W, W_H, d, W_X, W_Y ) 
  -- set scrollbar
  update_scrollbar()
  -- get window name
  window = reaper.JS_Window_Find( V_NAME, 1 ) reaper.JS_Window_SetPosition( window, math.floor(W_X), math.floor(W_Y), math.floor(W_W), math.floor(W_H) ) 
  -- set window flags
  set_window_flags()
  -- load buttons
  load_buttons()
  -- begin script main
  main()
end

--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~
function main() 

  hide_window()
  
  if duplicator then gui[1].obj[1].button[duplicator[0]].func[6](gui[1].obj[1].button[duplicator[0]],1,duplicator[0]) end 

  if scroll_timer < reaper.time_precise() then save_window() update_scrollbar() scroll_timer = reaper.time_precise() + .5 end
  
  view_zoom_and_mousewheel()
  
  pre_draw()
  
  auto_window_focus()
  
  if gfx.getchar() ~= -1 and quit == false then reaper.defer(main) end

end
--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~--~~

function delete_ext_states()
local del = VERSION
    while del > 1.02
  do  del = del - .01
    reaper.DeleteExtState( NAME.." v"..tostring(del), "W_W", 1 ) 
    reaper.DeleteExtState( NAME.." v"..tostring(del), "W_H", 1 ) 
    reaper.DeleteExtState( NAME.." v"..tostring(del), "W_X", 1 ) 
    reaper.DeleteExtState( NAME.." v"..tostring(del), "W_Y", 1 )
  end
end --delete_ext_states()

function exit_script()
    if SAVE == true
  then
    --local wd, wx, wy, ww, wh = gfx.dock( -1, 0, 0, 0, 0 )
    reaper.SetExtState( V_NAME, "FOLDER",  FOLDER, true )  
    save()
  end
end


reaper.atexit(exit_script)
init()














