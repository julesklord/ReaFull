-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- Define the path to the file you want to open
local filePath = "K:\\AAA AI Videos\\ReArtist15OFF Promo.mp4"

-- Define the command to open the file based on the operating system
local OS = reaper.GetOS()
local openCmd
if OS:match("Win") then
  openCmd = 'start ""'
elseif OS:match("OSX") then
  openCmd = 'open ""'
else
  openCmd = 'xdg-open'
end

-- Open the file using the defined command
os.execute(openCmd .. ' "' .. filePath .. '"')

