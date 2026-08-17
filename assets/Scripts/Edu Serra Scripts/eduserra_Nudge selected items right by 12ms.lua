-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- Get the current project
local project = reaper.GetProjectStateChangeCount(0)

-- Get the selected items
local itemCount = reaper.CountSelectedMediaItems(project)
for i = 0, itemCount - 1 do
    local item = reaper.GetSelectedMediaItem(project, i)
    local position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    reaper.SetMediaItemInfo_Value(item, "D_POSITION", position + 0.012)
end

-- Update the arrange view
reaper.UpdateArrange()

