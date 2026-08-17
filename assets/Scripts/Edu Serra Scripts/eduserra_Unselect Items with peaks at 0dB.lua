-- Name: Unselect selected items with peaks at 0dB
-- Date: 20 Jun 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.amaudio.co

-- This script unselects selected items in the Reaper DAW with peaks at 0dB.

-- Get the number of selected items
local num_items = reaper.CountSelectedMediaItems(0)

-- Create a temporary directory
local temp_dir = reaper.GetResourcePath() .. "/tmp"
reaper.RecursiveCreateDirectory(temp_dir, 0)

-- Iterate over all selected items
for i = 0, num_items - 1 do
  -- Get the item
  local item = reaper.GetSelectedMediaItem(0, i)
  
  -- Get the item's take
  local take = reaper.GetActiveTake(item)
  
  -- Check if the take is valid
  if take ~= nil then
    -- Create a temporary file name
    local temp_file = temp_dir .. "/peak_" .. tostring(i) .. ".wav"
    
    -- Render the take to a temporary file
    reaper.Main_OnCommand(40289, 0) -- Unselect all items
    reaper.SetMediaItemSelected(item, true)
    reaper.Main_SaveProject(0, false)
    reaper.RenderFileSection(temp_file, 0, 0, false)
    
    -- Open the temporary file
    local file = io.open(temp_file, "rb")
    
    -- Check if the file was opened successfully
    if file ~= nil then
      -- Read the file's RIFF header
      local riff_header = file:read(12)
      
      -- Check if the RIFF header is valid
      if riff_header ~= nil and string.sub(riff_header, 1, 4) == "RIFF" then
        -- Read the file's data chunk header
        local data_chunk_header = file:read(8)
        
        -- Check if the data chunk header is valid
        if data_chunk_header ~= nil and string.sub(data_chunk_header, 1, 4) == "data" then
          -- Get the data chunk size
          local data_chunk_size = string.unpack("<I4", string.sub(data_chunk_header, 5))
          
          -- Read the file's data chunk
          local data_chunk = file:read(data_chunk_size)
          
          -- Check if the data chunk was read successfully
          if data_chunk ~= nil then
            -- Initialize the maximum sample value
            local max_sample = 0
            
            -- Iterate over all samples in the data chunk
            for j = 1, data_chunk_size-1, 2 do
              -- Get the sample value
              local sample = string.unpack("<i2", string.sub(data_chunk, j))
              
              -- Update the maximum sample value
              max_sample = math.max(max_sample, math.abs(sample))
            end
            
            -- Calculate the peak value in dBFS
            local peak_dbfs = 20 * math.log(max_sample / 32768, 10)
            
            -- Check if the peak level is at 0dBFS
            if peak_dbfs == 0 then
              -- Unselect the item
              reaper.SetMediaItemSelected(item, false)
            end
            
            -- Select all items again
            for j = 0, num_items - 1 do
              local item = reaper.GetSelectedMediaItem(0, j)
              reaper.SetMediaItemSelected(item, true)
            end
            
          end -- if data_chunk ~= nil then...
        end -- if data_chunk_header ~= nil and...
      end -- if riff_header ~= nil and...
      
      -- Close the temporary file
      file:close()
      
      -- Delete the temporary file
      os.remove(temp_file)
    end -- if file ~= nil then...
    
  end -- if take ~= nil then...
end

-- Update the arrange view
reaper.UpdateArrange()

