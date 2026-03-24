-- create window
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ViloniX/AppleLibrary/refs/heads/main/AppleLibrary.lua"))()
local Win = Lib:CreateWindow("Window Name")

-- Create a tab
local MyTab = Win:CreateTab("TabName")

-- Create a button
MyTab:CreateButton("ButtonText", function()
    -- your function
end)

-- Create a toggle
MyTab:CreateToggle("ToggleText", function(state)
    -- on start state = false
end)
