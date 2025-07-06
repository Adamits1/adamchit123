-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AdamChit123Menu"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded edges
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Title label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Adam Chit 123"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Credit label
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -25)
credit.BackgroundTransparency = 1
credit.Text = "Made by Adams Lusins"
credit.Font = Enum.Font.Gotham
credit.TextSize = 14
credit.TextColor3 = Color3.fromRGB(160, 160, 160)
credit.Parent = frame

-- UI Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 12)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = frame

-- Padding for content layout
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 50)
padding.PaddingBottom = UDim.new(0, 40)
padding.Parent = frame

-- Button creation function
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 280, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 20

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    -- Hover effect
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Buttons
local brainrotBtn = createButton("Steal a Brainrot", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Adamits1/adamchit123/main/stealabrainrotstart.lua"))()
end)

local inkGameBtn = createButton("Ink Game", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Adamits1/adamchit123/main/inkgame.lua"))()
end)

-- Parent the buttons
brainrotBtn.Parent = frame
inkGameBtn.Parent = frame
