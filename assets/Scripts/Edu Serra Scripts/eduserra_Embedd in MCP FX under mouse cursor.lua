-- Name: Embed MCP JSFX under mouse cursor
-- Date: 16 Jun 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.amaudio.co

-- This script embeds the JSFX plugin under the mouse cursor in the MCP when a keyboard shortcut is pressed

function main()
  -- Get the window and segment under the mouse cursor
  local window, segment, details = reaper.BR_GetMouseCursorContext()
  
  -- Check if the window is the MCP and the segment is the FX
  if window == "mcp" and segment == "fx" then
    -- Get the track under the mouse cursor
    local track = reaper.BR_GetMouseCursorContext_Track()
    
    -- Check if a track was found
    if track then
      -- Get the FX index under the mouse cursor
      local fxIndex = reaper.BR_GetMouseCursorContext_Envelope()
      
      -- Check if an FX was found
      if fxIndex then
        -- Get the FX name
        local _, fxName = reaper.TrackFX_GetFXName(track, fxIndex, "")
        
        -- Check if the FX is a JSFX plugin
        if fxName:match("^JS:") then
          -- Embed the FX in the MCP
          reaper.SNM_MoveOrRemoveTrackFX(track, fxIndex, 1)
        end
      end
    end
  end
end

-- Run the main function when a keyboard shortcut is pressed
reaper.defer(main)

