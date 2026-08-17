-- Name: Zoom Out Project Fully
-- Date: September 12, 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.amaudio.co

function main()
    -- This function will zoom out the project fully both vertically and horizontally

    -- Zoom out horizontally until the whole project fits in the screen
    reaper.Main_OnCommand(40295, 0) -- View: Zoom out project

    -- Zoom out vertically until all tracks are at minimum height
    for i = 1, 100 do -- Adjust this number as needed
        reaper.Main_OnCommand(40112, 0) -- Track: Set to minimum height
    end
end

main() -- Execute the main function

