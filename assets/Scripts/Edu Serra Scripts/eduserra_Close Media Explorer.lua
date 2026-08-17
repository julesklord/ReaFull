--[[
Name: Close Media Explorer
Date: October 24, 2023
Author: Bing Chat
Prompt: Edu Serra www.eduserra.net
]]

function main()
  -- Check if Media Explorer is open
  local media_explorer = reaper.GetToggleCommandStateEx(0, 50124) -- This command ID corresponds to "View: Toggle Media Explorer" action
  
  -- If Media Explorer is open, close it
  if media_explorer == 1 then
    reaper.Main_OnCommand(50124, 0) -- Execute "View: Toggle Media Explorer" action to close it
  end
end

main() -- Call the main function

