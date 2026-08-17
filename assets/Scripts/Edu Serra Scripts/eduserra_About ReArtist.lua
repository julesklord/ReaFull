--[[
Name: Show popup window About ReArtist
Date: 1 Feb 2024
Author: Bing Chat
Indication: Edu Serra www.eduserra.net
]]

-- Define the message to display in the popup window
local message = "ReArtist Pro\n\nDate: 03/01/2025\n\nHello, I'm Edu Serra, I hope this configuration will be very helpful in your productions and through it you can exploit Reaper to the fullest.\n\nReArtist would not have been possible without the contribution of the programmers who permanently support the growth of ReaPack, SWS Extensions and JSFX Plugins, providing help to the community through the Official Forum. A big thank you to them.\n\nReArtist Pro is FREE, I depend on the support that users can give me through donations and/or the purchase of my courses, only in this way I will be able to cover the maintenance costs of the website and the time I dedicate to keep ReArtist Pro up to date.\n\nAny contribution you can make will be very helpful.\n\nClick on \"DONATION\" in this menu to go to the donations section of my website.\n\nEnjoy ReArtist: “All the good things about Reaper”."

-- Show the popup window with the message
reaper.ShowMessageBox(message, "About ReArtist", 0)

