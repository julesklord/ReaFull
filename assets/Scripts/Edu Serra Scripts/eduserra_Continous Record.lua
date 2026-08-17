function continuous_record()
    reaper.Main_OnCommand(1013, 0) -- Transport: Record
    reaper.defer(continuous_record) -- Continue running this function
end

function stop_record()
    reaper.Main_OnCommand(1016, 0) -- Transport: Stop
end

reaper.atexit(stop_record)
continuous_record()
 
