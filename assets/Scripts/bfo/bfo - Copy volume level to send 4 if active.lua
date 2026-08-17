--EDIT THIS NUMBER

sendNumber = 4

------------------


selNum = reaper.CountSelectedTracks(0)

for i=0, selNum-1 do

    track = reaper.GetSelectedTrack(0,i)
    
    trackNumSends = reaper.GetTrackNumSends(track, 0)
    
    if sendNumber<=trackNumSends then 
    
         trackVol = reaper.GetMediaTrackInfo_Value(track, "D_VOL")
         
         _, sendMuted = reaper.GetTrackSendUIMute(track, sendNumber-1)
         
         if not sendMuted then     
            reaper.SetTrackSendInfo_Value(track, 0, sendNumber-1, "D_VOL", trackVol)        
         end --if not
         
    end --if sendNumber


end --for i

reaper.TrackList_AdjustWindows(false)
