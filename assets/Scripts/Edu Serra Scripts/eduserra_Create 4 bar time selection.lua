-- Name: (Create a 4 bar time selection)
-- Date: (12/15/23)
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

function main()
    -- Get the current position of the edit cursor
    local cursor_pos = reaper.GetCursorPosition()

    -- Calculate the duration of 4 bars in seconds (4 * quarter notes per bar * seconds per quarter note)
    local duration = 4 * 4 * reaper.TimeMap2_QNToTime(0, 1)

    -- Set the time selection from the current cursor position to the end of the 4 bars
    reaper.GetSet_LoopTimeRange(true, false, cursor_pos, cursor_pos + duration, false)
end

main()

