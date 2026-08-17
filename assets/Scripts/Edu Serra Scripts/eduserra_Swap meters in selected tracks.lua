--[[
Script Name: Remove PEAK FX in Selected Tracks
Description: This script removes all instances of the FX named "PEAK" in all selected tracks.
Author: Edu Serra
Version: ReArtist 1.2
]]

function main()
    local fxname = "PEAK"

    for i = 1, reaper.CountSelectedTracks(0) do
        local track = reaper.GetSelectedTrack(0, i - 1)

        -- Remove all instances of the FX named "PEAK"
        for fx = reaper.TrackFX_GetCount(track), 1, -1 do
            local retval, fxName = reaper.TrackFX_GetFXName(track, fx - 1, "")
            if fxName == fxname then
                reaper.TrackFX_Delete(track, fx - 1)
            end
        end
    end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Remove PEAK FX in Selected Tracks", -1)
