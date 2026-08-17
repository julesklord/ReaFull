-- @description Close all floating ReaEQ FX windows
-- @version 1.0
-- @author Edu Serra www.amaudio.co
-- @changelog
--  + init

local r = reaper

r.Undo_BeginBlock()

-- Function to close ReaEQ windows on a track
local function closeReaEQWindows(track)
    -- Get the number of FX on the track
    local fx_count = r.TrackFX_GetCount(track)
    
    -- Iterate over each FX on the track
    for j = 0, fx_count - 1 do
        -- Get the name of the FX
        local retval, fx_name = r.TrackFX_GetFXName(track, j, "")
        
        -- Check if the FX is a ReaEQ and if its window is open
        if fx_name == "ReaEQ" and r.TrackFX_GetOpen(track, j) then
            -- Close the FX window
            r.TrackFX_Show(track, j, 2)
        end
    end
end

-- Get the master track and close its ReaEQ windows
local master_track = r.GetMasterTrack(0)
closeReaEQWindows(master_track)

-- Get the number of tracks in the project
local track_count = r.CountTracks(0)

-- Iterate over each track
for i = 0, track_count - 1 do
    local track = r.GetTrack(0, i)
    
    -- Close ReaEQ windows on the track
    closeReaEQWindows(track)
    
    -- Get the number of sends on the track
    local send_count = r.GetTrackNumSends(track, 0)
    
    -- Iterate over each send on the track
    for j = 0, send_count - 1 do
        -- Get the send track and close its ReaEQ windows
        local send_track = r.BR_GetMediaTrackSendInfo_Track(track, 0, j, 1)
        closeReaEQWindows(send_track)
    end
end

r.Undo_EndBlock('Close all floating ReaEQ FX windows', 2)

