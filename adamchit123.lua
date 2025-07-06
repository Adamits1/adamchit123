-- Services
local TweenService = game:GetService("TweenService")

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
frame.BackgroundTransparency = 1
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded corners
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Adam Chit 123"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Credit
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -25)
credit.BackgroundTransparency = 1
credit.Text = "Made by Adams Lusins"
credit.Font = Enum.Font.Gotham
credit.TextSize = 14
credit.TextColor3 = Color3.fromRGB(160, 160, 160)
credit.Parent = frame

-- Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 12)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = frame

-- Padding
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 50)
padding.PaddingBottom = UDim.new(0, 40)
padding.Parent = frame

-- Button creator
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

    -- Hover animation
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        -- Close animation
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            gui:Destroy()
            callback()
        end)
    end)

    return button
end

-- Buttons
local brainrotBtn = createButton("Steal a Brainrot", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Adamits1/adamchit123/main/stealabrainrotstart.lua"))()
end)

local inkGameBtn = createButton("Ink Game", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Adamits1/adamchit123/main/inkgame.lua"))()
end)

local universalBtn = createButton("Universal", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Adamits1/adamchit123/main/universal.lua"))()
end)

-- Parent the buttons to frame
brainrotBtn.Parent = frame
inkGameBtn.Parent = frame
universalBtn.Parent = frame

-- Open animation
TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 350, 0, 250),
    BackgroundTransparency = 0
}):Play()
