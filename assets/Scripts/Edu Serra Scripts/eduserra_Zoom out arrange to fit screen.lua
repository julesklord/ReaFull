-- Name: Zoom out arrange to fit screen
-- Date: (put here todays date)
-- Author: Archie
-- Mod by Edu Serra


-- ARRANGE SECTION
local INDENT_END = 30 -- Adjust this value to set the end indent as per your convenience
local INDENT_START = 10 -- Adjust this value to set the start indent as per your convenience
local OFF_TIME_SELECTION = 0 -- Set to 0 to zoom by time selection if installed, set to 1 to ignore time selection

-- Load the Arc module
local function MODULE(file)
    local E,A=pcall(dofile,file)
    if not(E) then
        reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*/\\')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))
        return
    end
    if not A.VersArcFun("2.8.5",file,'') then
        A=nil
        return
    end
    return A
end

local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'))
if not Arc then return end

-- Function to set the arrange view in Reaper
local function Set_ArrangeView(proj,start_View,end_View)
    reaper.PreventUIRefresh(498712)
    reaper.GetSet_ArrangeView2(proj,1,0,0,0,1000)
    reaper.GetSet_ArrangeView2(proj,1,0,0,1000,2000)
    reaper.GetSet_ArrangeView2(proj,1,0,0,start_View,end_View)
    reaper.PreventUIRefresh(-498712)
end

-- Function to arrange the view in Reaper based on time selection or project length
local function Arrange()
    local startTime,endTime
    local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,1,0,0,0)
    local startTimeSel, endTimeSel = reaper.GetSet_LoopTimeRange(0,0,0,0,0)

    if startLoop == endLoop then
        startTime = startTimeSel
        endTime = endTimeSel
    else
        startTime = startLoop
        endTime = endLoop
    end

    local ProjectLength = reaper.GetProjectLength(0)

    if OFF_TIME_SELECTION == 1 then startTime = endTime end

    if startTime == endTime then startTime = 0 endTime = ProjectLength end

    Set_ArrangeView(0,startTime,endTime)
    
    local Pix = reaper.GetHZoomLevel()*(endTime-startTime) -- Length of project or selected time in pixels

    local ProjectLength2 = (Pix+(INDENT_END))/reaper.GetHZoomLevel() -- Length of project or selected time in seconds + INDENT_END pixels
    local X = ProjectLength2-(endTime-startTime)
    local END = endTime + X

    local ProjectLength2 = (Pix+(INDENT_START))/reaper.GetHZoomLevel() -- Length of project or selected time in seconds + INDENT_START pixels
    local X = ProjectLength2-(endTime-startTime)
    
    START = startTime - X
    
    if START < 0 then START = 0 end
    
    Set_ArrangeView(0,START,END)

    reaper.UpdateTimeline()
end

Arrange()
reaper.UpdateArrange()
Arc.no_undo()

