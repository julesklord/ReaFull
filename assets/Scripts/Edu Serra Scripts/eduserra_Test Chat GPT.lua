-- Reascript to close the FX Browser Window

-- Get the FX Browser Window
local fx_browser = reaper.JS_Window_Find("FX Browser", true)

-- Check if the FX Browser Window exists
if fx_browser then
  -- Close the FX Browser Window
  reaper.JS_Window_Destroy(fx_browser)
end

