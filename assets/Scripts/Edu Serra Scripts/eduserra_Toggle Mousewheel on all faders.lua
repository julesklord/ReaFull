-- @description Toggle "Ignore mousewheel on all faders" (No restart needed)
-- @version 1.2
-- @author Your Name
-- @about Instantly toggles mousewheel-fader interaction without restart

function main()
    -- Check for SWS extension (required for live updates)
    if not reaper.SNM_GetIntConfigVar then
        reaper.MB("SWS Extension required for live toggle", "Error", 0)
        return
    end

    -- Get current state using SWS
    local current_state = reaper.SNM_GetIntConfigVar("mousewheelignoresfaders", -1)
    
    -- Toggle the state
    local new_state = 1 - current_state
    reaper.SNM_SetIntConfigVar("mousewheelignoresfaders", new_state)
    
    -- Force UI update
    reaper.defer(function() end)
    
    -- Show floating notification
    reaper.ShowConsoleMsg("Mousewheel fader control: " .. 
        (new_state == 1 and "IGNORED" or "ACTIVE") .. "\n")
end

main()
