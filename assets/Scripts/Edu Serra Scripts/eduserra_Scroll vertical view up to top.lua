-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- Check if js_ReaScriptAPI extension is installed
if not reaper.JS_Window_Find then
  reaper.MB("js_ReaScriptAPI extension is required for this script.", "Error", 0)
  return
end

-- Get the main window and arrange view
local main_window = reaper.GetMainHwnd()
local arrange_view = reaper.JS_Window_FindChildByID(main_window, 1000)

-- Scroll the arrange view to the top
reaper.JS_Window_SetScrollPos(arrange_view, "v", 0)

