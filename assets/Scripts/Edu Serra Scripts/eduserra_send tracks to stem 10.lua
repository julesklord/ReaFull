-- Name: Create post fader send from selected tracks to STEM 10 and disable master send
-- Date: 30-10-2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

function main()
    -- Get the number of selected tracks
    local count = reaper.CountSelectedTracks(0)
    
    -- If no tracks are selected, exit the script
    if count == 0 then
        return
    end
    
    -- Find the track named "STEM 10"
    local stem_track = nil
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        if track_name == "STEM 10" then
            stem_track = track
            break
        end
    end
    
    -- If "STEM 10" does not exist, show an error message and exit the script
    if not stem_track then
        reaper.ShowMessageBox("STEM 10 is missing", "Error", 0)
        return
    end
    
    -- Loop over all selected tracks
    for i = 0, count - 1 do
        -- Get the current selected track
        local track = reaper.GetSelectedTrack(0, i)
        
        -- Disable master send for the current track
        reaper.SetMediaTrackInfo_Value(track, "B_MAINSEND", 0)
        
        -- Create a post-fader send from the current track to "STEM 10"
        local send_index = reaper.CreateTrackSend(track, stem_track)
        
        -- Set the send to be post-fader (mode 3)
        reaper.BR_GetSetTrackSendInfo(track, 0, send_index, "I_SENDMODE", true, 0)
    end
    
    -- Update the arrangement (UI) to reflect the changes
    reaper.UpdateArrange()
end

main()

