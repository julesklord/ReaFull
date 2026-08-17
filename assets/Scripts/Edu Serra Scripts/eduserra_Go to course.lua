--[[
Name: Show About ReArtist popup window with button
Date: 02 Jun 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Define the message to display in the window
local message = "Hi, I’m Edu Serra. My main goal with ReArtist is to provide the users with a Reaper environment that allows them to access advanced tools easily and with a pleasant and organized graphical interface. ReArtist makes extensive use of Reapack scripts, custom actions and SWS Extensions, along with a redesigned Reaper Theme, Toolbar Icons, Track Icons and new graphic user interface for some of the wonderful JSFX plugins by Tukan Studios.\n\nReArtist is bundled with a Reaper Course that will instruct you on how to get the most out of the configuration in recording, editing, mixing and mastering scenarios.\n\nReArtist would not have been possible without the contributions of the programmers who permanently support the growth of ReaPack, SWS Extensions and JSFX Plugins, providing help to the community through the Official Forum.\n\nThanks for your support and enjoy ReArtist: “All the good things about Reaper but easier”."

-- Define the URL to open when the button is clicked
local url = "https://www.amaudio.co/"

-- Initialize the gfx library
gfx.init("About ReArtist", 400, 300)

-- Draw the message in the window
gfx.x = 10
gfx.y = 10
gfx.drawstr(message)

-- Draw the "Go to course" button
local buttonWidth = 100
local buttonHeight = 30
local buttonX = (gfx.w - buttonWidth) / 2
local buttonY = gfx.h - buttonHeight - 10
gfx.rect(buttonX, buttonY, buttonWidth, buttonHeight)
gfx.x = buttonX + 10
gfx.y = buttonY + 8
gfx.drawstr("Go to course")

-- Check if the user clicks on the "Go to course" button
function onClick()
    local mouseX, mouseY = gfx.mouse_x, gfx.mouse_y
    if mouseX >= buttonX and mouseX <= (buttonX + buttonWidth) and mouseY >= buttonY and mouseY <= (buttonY + buttonHeight) then
        -- Open the URL when the button is clicked
        reaper.CF_ShellExecute(url)
    end
end

-- Run the main loop
function main()
    -- Check for user input
    if gfx.getchar() ~= -1 then
        onClick()
        gfx.update()
        reaper.defer(main)
    else
        gfx.quit()
    end
end

main()

