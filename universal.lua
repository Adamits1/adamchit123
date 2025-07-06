local ValueText = "[ESP]:"
local Clock = os.clock()
local Decimals = 4

-- Load UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "Adamchit123",
    gamename = "Universal"
})

library:init()

local MainWindow = library.NewWindow({
    title = "Adamchit123 | Universal",
    size = UDim2.new(0, 510, 0.6, 6)
})

-- Tabs
local VisualsTab = MainWindow:AddTab("  Visuals  ")
local SettingsTab = library:CreateSettingsTab(MainWindow)


-- ESP Settings
local ESPSettings = {
    Enabled = false,
    BoxESP = false,
    NameESP = false,
    DistanceESP = false,
    HealthESP = false,
    TracerESP = false,
    HeldItemESP = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 0),
    TracerColor = Color3.fromRGB(255, 255, 255),
    HeldItemColor = Color3.fromRGB(255, 255, 255),
    Font = 2,
    TeamCheck = false
}

-- UI Controls
local Section = VisualsTab:AddSection("Player ESP", 1)
Section:AddToggle({text = "Enable ESP", callback = function(v) ESPSettings.Enabled = v end})
Section:AddToggle({text = "Box ESP", callback = function(v) ESPSettings.BoxESP = v end})
    :AddColor({text = "Box Color", color = ESPSettings.BoxColor, callback = function(c) ESPSettings.BoxColor = c end})
Section:AddToggle({text = "Name ESP", callback = function(v) ESPSettings.NameESP = v end})
    :AddColor({text = "Name Color", color = ESPSettings.NameColor, callback = function(c) ESPSettings.NameColor = c end})
Section:AddToggle({text = "Distance ESP", callback = function(v) ESPSettings.DistanceESP = v end})
    :AddColor({text = "Distance Color", color = ESPSettings.DistanceColor, callback = function(c) ESPSettings.DistanceColor = c end})
Section:AddToggle({text = "Visible ESP", callback = function(v) ESPSettings.VisibleESP = v end})
Section:AddToggle({text = "Health ESP", callback = function(v) ESPSettings.HealthESP = v end})
    :AddColor({text = "Health Color", color = ESPSettings.HealthColor, callback = function(c) ESPSettings.HealthColor = c end})
Section:AddToggle({text = "Tracer ESP", callback = function(v) ESPSettings.TracerESP = v end})
    :AddColor({text = "Tracer Color", color = ESPSettings.TracerColor, callback = function(c) ESPSettings.TracerColor = c end})
Section:AddToggle({text = "Held Item ESP", callback = function(v) ESPSettings.HeldItemESP = v end})
    :AddColor({text = "Held Item Color", color = ESPSettings.HeldItemColor, callback = function(c) ESPSettings.HeldItemColor = c end})

Section:AddToggle({
    text = "Team Check",
    state = ESPSettings.TeamCheck,
    callback = function(v) ESPSettings.TeamCheck = v end
})

local fontNames = {"UI", "System", "Plex", "Monospace", "Arial"}
Section:AddList({
    enabled = true,
    text = "ESP Font",
    values = fontNames,
    selected = fontNames[ESPSettings.Font + 1],
    callback = function(v)
        for i, name in ipairs(fontNames) do
            if name == v then ESPSettings.Font = i - 1 break end
        end
    end
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Remove ESP when player leaves
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- ESP Storage
local Drawings = {}

local function RemoveESP(player)
    if Drawings[player] then
        for _, obj in ipairs(Drawings[player]) do
            if obj then obj:Remove() end
        end
        Drawings[player] = nil
    end
end

local function GetCharacterBounds(character)
    local minVec, maxVec = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local cf = part.CFrame
            local size = part.Size / 2
            for x = -1, 1, 2 do
                for y = -1, 1, 2 do
                    for z = -1, 1, 2 do
                        local corner = cf.Position + (cf.RightVector * size.X * x) + (cf.UpVector * size.Y * y) + (cf.LookVector * size.Z * z)
                        minVec = Vector3.new(math.min(minVec.X, corner.X), math.min(minVec.Y, corner.Y), math.min(minVec.Z, corner.Z))
                        maxVec = Vector3.new(math.max(maxVec.X, corner.X), math.max(maxVec.Y, corner.Y), math.max(maxVec.Z, corner.Z))
                    end
                end
            end
        end
    end
    return minVec, maxVec
end

local function IsVisible(fromPos, toPos, ignoreList)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    local direction = toPos - fromPos
    local result = workspace:Raycast(fromPos, direction, raycastParams)
    if result then
        local hitPart = result.Instance
        return hitPart and hitPart:IsDescendantOf(ignoreList[1])
    else
        return true
    end
end

local function GetHeldItemName(character)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            return child.Name
        end
    end
    return "None"
end

local function DrawESP(player)
    if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then return RemoveESP(player) end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return RemoveESP(player) end

    local hrp = character.HumanoidRootPart
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return RemoveESP(player) end

    local minVec, maxVec = GetCharacterBounds(character)
    local corners = {
        Vector3.new(minVec.X, maxVec.Y, minVec.Z),
        Vector3.new(maxVec.X, maxVec.Y, maxVec.Z),
        Vector3.new(minVec.X, minVec.Y, minVec.Z),
        Vector3.new(maxVec.X, minVec.Y, maxVec.Z),
    }

    local screenPoints = {}
    for _, corner in ipairs(corners) do
        local screenPos, visible = Camera:WorldToViewportPoint(corner)
        if not visible then return RemoveESP(player) end
        table.insert(screenPoints, Vector2.new(screenPos.X, screenPos.Y))
    end

    local topLeft = Vector2.new(math.huge, math.huge)
    local bottomRight = Vector2.new(-math.huge, -math.huge)
    for _, point in ipairs(screenPoints) do
        topLeft = Vector2.new(math.min(topLeft.X, point.X), math.min(topLeft.Y, point.Y))
        bottomRight = Vector2.new(math.max(bottomRight.X, point.X), math.max(bottomRight.Y, point.Y))
    end

    local boxSize = bottomRight - topLeft
    local boxCenter = (topLeft + bottomRight) / 2

    RemoveESP(player)
    Drawings[player] = {}

    -- Box
    if ESPSettings.BoxESP then
        local box = Drawing.new("Square")
        box.Size = boxSize
        box.Position = topLeft
        box.Color = ESPSettings.BoxColor
        box.Thickness = 1
        box.Visible = true
        table.insert(Drawings[player], box)
    end

    -- Name
    if ESPSettings.NameESP then
        local name = Drawing.new("Text")
        name.Text = player.DisplayName
        name.Size = 14
        name.Center = true
        name.Outline = true
        name.Font = ESPSettings.Font
        name.Color = ESPSettings.NameColor
        name.Position = Vector2.new(boxCenter.X, topLeft.Y - 17)
        name.Visible = true
        table.insert(Drawings[player], name)
    end

    -- Held Item (always independent of name)
    if ESPSettings.HeldItemESP then
        local heldItemText = Drawing.new("Text")
        heldItemText.Text = GetHeldItemName(character)
        heldItemText.Size = 13
        heldItemText.Center = true
        heldItemText.Outline = true
        heldItemText.Font = ESPSettings.Font
        heldItemText.Color = ESPSettings.HeldItemColor
        heldItemText.Position = Vector2.new(boxCenter.X, bottomRight.Y + 32)
        heldItemText.Visible = true
        table.insert(Drawings[player], heldItemText)
    end

    -- Distance
    if ESPSettings.DistanceESP then
        local distance = Drawing.new("Text")
        distance.Text = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude) .. "m"
        distance.Size = 13
        distance.Center = true
        distance.Outline = true
        distance.Font = ESPSettings.Font
        distance.Color = ESPSettings.DistanceColor
        distance.Position = Vector2.new(boxCenter.X, bottomRight.Y + 5)
        distance.Visible = true
        table.insert(Drawings[player], distance)
    end

    -- Visibility
    if ESPSettings.VisibleESP then
        local visible = IsVisible(Camera.CFrame.Position, hrp.Position, {character})
        local visibility = Drawing.new("Text")
        visibility.Text = visible and "Visible" or "Not Visible"
        visibility.Size = 13
        visibility.Center = true
        visibility.Outline = true
        visibility.Font = ESPSettings.Font
        visibility.Color = visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        visibility.Position = Vector2.new(boxCenter.X, bottomRight.Y + 20)
        visibility.Visible = true
        table.insert(Drawings[player], visibility)
    end

    -- Health
    if ESPSettings.HealthESP then
        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        local bar = Drawing.new("Square")
        bar.Size = Vector2.new(3, boxSize.Y * hp)
        bar.Position = Vector2.new(topLeft.X - 6, bottomRight.Y - (boxSize.Y * hp))
        bar.Color = ESPSettings.HealthColor
        bar.Filled = true
        bar.Visible = true
        table.insert(Drawings[player], bar)
    end

    -- Tracer
    if ESPSettings.TracerESP then
        local tracer = Drawing.new("Line")
        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        tracer.To = boxCenter
        tracer.Color = ESPSettings.TracerColor
        tracer.Thickness = 1
        tracer.Visible = true
        table.insert(Drawings[player], tracer)
    end
end

RunService.RenderStepped:Connect(function()
    if ESPSettings.Enabled then
        local seenPlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                DrawESP(player)
                seenPlayers[player] = true
            end
        end

        -- Remove drawings for players no longer valid
        for player in pairs(Drawings) do
            if not seenPlayers[player] then
                RemoveESP(player)
            end
        end
    else
        for player in pairs(Drawings) do
            RemoveESP(player)
        end
    end
end)


local Time = string.format("%." .. tostring(Decimals) .. "f", os.clock() - Clock)
library:SendNotification("Adamchit123 Loaded in " .. Time .. "s", 6)
