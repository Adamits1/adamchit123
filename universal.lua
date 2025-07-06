local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "Adam Chit 123",
    gamename = "Universal"
})

library:init()

local Window = library.NewWindow({
    title = "Adam Chit 123 | Universal",
    size = UDim2.new(0, 700, 0.6, 6)
})

local Tab1 = Window:AddTab("  Main  ")
local Tab2 = Window:AddTab("  Movement  ")
local Tab3 = Window:AddTab("  Utility  ")
local SettingsTab = library:CreateSettingsTab(Window)

local CombatSection = Tab1:AddSection("Main", 1)
local MovementSection = Tab2:AddSection("Movement", 1)
local UtilitySection = Tab3:AddSection("Utility", 1)



-- Rainbow "123" texts setup
local showRainbow123 = false
local Drawing = Drawing

local cornerTexts = {}
local function createText()
    local t = Drawing.new("Text")
    t.Text = "Adam Poo"
    t.Size = 80
    t.Center = false
    t.Outline = true
    t.OutlineColor = Color3.new(0, 0, 0)
    t.Font = 3
    t.Visible = false
    return t
end

for i = 1, 4 do
    table.insert(cornerTexts, createText())
end

RunService.RenderStepped:Connect(function()
    local screenSize = workspace.CurrentCamera.ViewportSize
    cornerTexts[1].Position = Vector2.new(20, 20)
    cornerTexts[2].Position = Vector2.new(screenSize.X - 120, 20)
    cornerTexts[3].Position = Vector2.new(20, screenSize.Y - 100)
    cornerTexts[4].Position = Vector2.new(screenSize.X - 120, screenSize.Y - 100)

    if showRainbow123 then
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        for _, text in ipairs(cornerTexts) do
            text.Color = color
            text.Visible = true
        end
    else
        for _, text in ipairs(cornerTexts) do
            text.Visible = false
        end
    end
end)

CombatSection:AddToggle({
    enabled = true,
    text = "Adam Poo",
    flag = "adam_poo",
    tooltip = "Show rainbow adam poo in screen corners",
    callback = function(v)
        showRainbow123 = v
    end
})



-- No Ragdoll toggle
local noRagdollEnabled = false
UtilitySection:AddToggle({
    enabled = true,
    text = "No Ragdoll",
    flag = "no_ragdoll",
    tooltip = "Prevents ragdoll effects",
    callback = function(v)
        noRagdollEnabled = v
    end
})

RunService.Heartbeat:Connect(function()
    if noRagdollEnabled then
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            hum.PlatformStand = false
            if hum:GetState() == Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
            for _, v in pairs(hrp:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end)

-- Godmode (Evade) toggle
local godmodeEnabled = false
local godmodeCooldown = false

UtilitySection:AddToggle({
    enabled = true,
    text = "Godmode (Tp Away)",
    flag = "godmode_evade",
    tooltip = "Teleport away if enemy is close",
    callback = function(v)
        godmodeEnabled = v
    end
})

RunService.Heartbeat:Connect(function()
    if godmodeEnabled and not godmodeCooldown then
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    local dist = (hrp.Position - targetHrp.Position).Magnitude
                    if dist < 30 then
                        local direction = (hrp.Position - targetHrp.Position).Unit
                        hrp.CFrame = hrp.CFrame + direction * 40
                        library:SendNotification("Enemy too close! Evading...", 2)
                        godmodeCooldown = true
                        task.delay(0.01, function() godmodeCooldown = false end)
                        break
                    end
                end
            end
        end
    end
end)

-- Real Godmode toggle
local realGodmodeEnabled = false

UtilitySection:AddToggle({
    enabled = true,
    text = "Kill brick godmode",
    flag = "godmode_real",
    tooltip = "Disables damage from kill bricks",
    callback = function(v)
        realGodmodeEnabled = v
    end
})

local function updateKillbrickTouch()
    while true do
        task.wait(0.2) -- Adjust if needed
        if realGodmodeEnabled then
            local char = LocalPlayer.Character
            if not char then continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            -- Get all parts around the player
            local parts = workspace:GetPartBoundsInRadius(hrp.Position, 10)
            for _, part in ipairs(parts) do
                if part:IsA("BasePart") and part.CanTouch then
                    part.CanTouch = false
                end
            end
        end
    end
end

-- Start in a thread so it doesn't block anything else
task.spawn(updateKillbrickTouch)



-- Fly Variables & Functions
local flying = false
local flySpeed = 50
local flyMethod = "BodyVelocity"
local connectionFly
local bodyGyro, bodyVelocity

local function cleanupFly()
    if connectionFly then
        connectionFly:Disconnect()
        connectionFly = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

local function flyBodyVelocity(char, hrp, hum)
    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)

    connectionFly = RunService.Heartbeat:Connect(function()
        if not flying then return end
        local camCF = workspace.CurrentCamera.CFrame
        local moveVec = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= Vector3.new(0,1,0) end

        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * flySpeed
        end
        bodyVelocity.Velocity = moveVec
        bodyGyro.CFrame = camCF
    end)
end

local function flyCFrame(char, hrp, hum)
    connectionFly = RunService.Heartbeat:Connect(function(dt)
        if not flying then return end
        local camCF = workspace.CurrentCamera.CFrame
        local moveVec = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= Vector3.new(0,1,0) end

        if moveVec.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + moveVec.Unit * flySpeed * RunService.Heartbeat:Wait()
        end
    end)
end

local flyMethods = {
    BodyVelocity = flyBodyVelocity,
    CFrame = flyCFrame,
}

MovementSection:AddList({
    enabled = true,
    text = "Fly Method",
    flag = "fly_method",
    tooltip = "Select the fly method",
    values = {"BodyVelocity", "CFrame"},
    selected = "BodyVelocity",
    callback = function(v)
        flyMethod = v
        if flying then
            cleanupFly()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    flyMethods[flyMethod](char, hrp, hum)
                end
            end
        end
    end
})

MovementSection:AddSlider({
    enabled = true,
    text = "Fly Speed",
    flag = "fly_speed",
    tooltip = "Adjust fly speed",
    min = 10,
    max = 200,
    increment = 1,
    value = flySpeed,
    callback = function(v)
        flySpeed = v
    end
})

MovementSection:AddToggle({
    enabled = true,
    text = "Fly",
    flag = "fly_toggle",
    tooltip = "Toggle flying",
    callback = function(v)
        flying = v
        cleanupFly()
        if flying then
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    flyMethods[flyMethod](char, hrp, hum)
                end
            end
        end
    end
})

-- Freecam with normal rotation

local freecamEnabled = false
local freecamSpeed = 50
local freecamPos = nil
local freecamConnection = nil

local function enableFreecam()
    local cam = workspace.CurrentCamera
    freecamPos = cam.CFrame.Position
    freecamEnabled = true

    -- Let Roblox handle mouse rotation normally (don't lock mouse)
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true

    freecamConnection = RunService.RenderStepped:Connect(function(dt)
        if not freecamEnabled then return end
        local camCF = cam.CFrame
        local moveDir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end

        if moveDir.Magnitude > 0 then
            freecamPos = freecamPos + moveDir.Unit * freecamSpeed * dt
        end

        -- Only update position, keep camera rotation the same so mouse controls rotation
        cam.CFrame = CFrame.new(freecamPos) * CFrame.Angles(camCF:ToEulerAnglesYXZ())
    end)
end

local function disableFreecam()
    if freecamConnection then
        freecamConnection:Disconnect()
        freecamConnection = nil
    end
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    freecamEnabled = false
end

MovementSection:AddToggle({
    enabled = true,
    text = "Freecam",
    flag = "freecam_toggle",
    tooltip = "Toggle freecam",
    callback = function(v)
        if v then
            enableFreecam()
        else
            disableFreecam()
        end
    end
})

MovementSection:AddSlider({
    enabled = true,
    text = "Freecam Speed",
    flag = "freecam_speed",
    tooltip = "Adjust freecam speed",
    min = 10,
    max = 200,
    increment = 1,
    value = freecamSpeed,
    callback = function(v)
        freecamSpeed = v
    end
})

local originalWalkSpeed = nil
local speedBoostEnabled = false

local function applySpeedBoost()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if not originalWalkSpeed then
                originalWalkSpeed = hum.WalkSpeed -- Save once
            end
            if speedBoostEnabled then
                hum.WalkSpeed = 50 -- Boosted speed
            else
                hum.WalkSpeed = originalWalkSpeed or 16
            end
        end
    end
end

-- Continuously enforce speed while enabled
RunService.Heartbeat:Connect(function()
    if speedBoostEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= 50 then
                hum.WalkSpeed = 50
            end
        end
    else
        -- Optionally reset speed if toggled off while character exists
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and originalWalkSpeed and hum.WalkSpeed ~= originalWalkSpeed then
                hum.WalkSpeed = originalWalkSpeed
            end
        end
    end
end)

MovementSection:AddToggle({
    enabled = true,
    text = "Speed Boost",
    flag = "speed_boost",
    tooltip = "Boost walk speed to 50",
    callback = function(v)
        speedBoostEnabled = v
        applySpeedBoost()
    end
})

Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    originalWalkSpeed = nil
    applySpeedBoost()
end)

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
    originalWalkSpeed = nil
    applySpeedBoost()
end

--// Infinite Jump
local infiniteJump = false
UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)



MovementSection:AddToggle({
    enabled = true,
    text = "Infinite Jump",
    flag = "inf_jump",
    tooltip = "Jump infinitely",
    callback = function(v)
        infiniteJump = v
    end
})

--// Anti Stun Fix (basic version, may need tuning per-game)
local antiStunEnabled = false

UtilitySection:AddToggle({
    enabled = true,
    text = "Anti Stun",
    flag = "anti_stun",
    tooltip = "Removes stun effects (like from knockdowns)",
    callback = function(v)
        antiStunEnabled = v
    end
})

RunService.Heartbeat:Connect(function()
    if antiStunEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BoolValue") and v.Name:lower():find("stun") then
                    v:Destroy()
                elseif v:IsA("NumberValue") and v.Name:lower():find("stun") then
                    v.Value = 0
                end
            end
        end
    end
end)

--// Instant Interact
CombatSection:AddButton({
    enabled = true,
    text = "Instant Interact",
    flag = "instant_interact",
    tooltip = "Interact with hold prompts instantly",
    callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                if obj.MaxActivationDistance > 0 then
                    obj.HoldDuration = 0
                end
            end
        end
        library:SendNotification("Set all prompts to 0s hold", 3)
    end
})

--// UI Button Openers
local function safeOpen(guiName)
    local gui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName)
    if gui then gui.Enabled = true end
end

UtilitySection:AddButton({
    text = "Open CoinsShop",
    callback = function() safeOpen("CoinsShop") end
})

UtilitySection:AddButton({
    text = "Open Shop",
    callback = function() safeOpen("Shop") end
})

UtilitySection:AddButton({
    text = "Open RainbowSpinWheel",
    callback = function() safeOpen("RainbowSpinWheel") end
})

--// Set TopNotification text
task.spawn(function()
    local gui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TopNotification", 5)
    if gui and gui:FindFirstChildOfClass("TextLabel") then
        gui:FindFirstChildOfClass("TextLabel").Text = "adams on top kaka klavs"
    end
end)


local VisualsTab = Window:AddTab("  Visuals  ")


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


-- click to tp
local ClickToTP_Enabled = false

MovementSection:AddToggle({
    text = "Click to TP",
    state = false,
    flag = "ClickTP_Toggle",
    tooltip = "Teleports you to where you click in the world",
    callback = function(v)
        ClickToTP_Enabled = v
    end
})

-- Handle mouse click teleporting
local Mouse = LocalPlayer:GetMouse()

Mouse.Button1Down:Connect(function()
    if not ClickToTP_Enabled then return end

    local target = Mouse.Hit
    if target and target.Position then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Optional Y-offset to avoid falling through ground
            char:MoveTo(Vector3.new(target.Position.X, target.Position.Y + 3, target.Position.Z))
        end
    end
end)



-- Add Combat Tab
local CombatTab = Window:AddTab("  Combat  ")
local CombatSection = CombatTab:AddSection("Aimbot", 1)

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- Aimbot State
local AimbotActive = false
local AimbotHoldMode = false
local AimbotKey = Enum.KeyCode.Q
local Smoothness = 0
local TrackingPart = "Head"
local AimMode = "Camera" -- or "Mouse"
local HoldingKey = false

-- Input for Hold-to-Aim
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == AimbotKey and AimbotHoldMode then
        HoldingKey = true
    end
end)

UIS.InputEnded:Connect(function(input, processed)
    if not processed and input.KeyCode == AimbotKey and AimbotHoldMode then
        HoldingKey = false
    end
end)

-- Get closest player to screen center
local function getClosestTarget()
    local closest, closestDist = nil, math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(TrackingPart)
            if part then
                local screenPos, visible = Camera:WorldToViewportPoint(part.Position)
                if visible then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = part
                    end
                end
            end
        end
    end

    return closest
end

-- Mouse Aim Function
local function aimMouseAt(position)
    local screenPos = Camera:WorldToViewportPoint(position)
    local mouseLocation = UIS:GetMouseLocation()
    local delta = Vector2.new(screenPos.X, screenPos.Y) - mouseLocation
    mousemoverel(delta.X, delta.Y)
end

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    local shouldAim = AimbotHoldMode and HoldingKey or AimbotActive

    if shouldAim then
        local targetPart = getClosestTarget()
        if targetPart then
            local origin = Camera.CFrame.Position
            local direction = (targetPart.Position - origin).Unit

            if AimMode == "Camera" then
                local newDir = Camera.CFrame.LookVector:Lerp(direction, 1 - math.clamp(Smoothness, 0, 1))
                Camera.CFrame = CFrame.new(origin, origin + newDir)
            elseif AimMode == "Mouse" then
                aimMouseAt(targetPart.Position)
            end
        end
    end
end)

-- UI Controls
CombatSection:AddToggle({
    text = "Aimbot",
    state = false,
    flag = "Aimbot_Toggle",
    tooltip = "Enable or disable aimbot",
    callback = function(v)
        AimbotActive = v
    end
}):AddBind({
    text = "Aimbot Keybind",
    mode = "toggle",
    bind = "Q",
    flag = "Aimbot_Bind",
    callback = function()
        if not AimbotHoldMode then
            AimbotActive = not AimbotActive
        end
    end,
    keycallback = function(key)
        AimbotKey = key
    end
})

CombatSection:AddToggle({
    text = "Hold-to-Aim",
    state = false,
    flag = "Aimbot_HoldMode",
    tooltip = "Hold key instead of toggling",
    callback = function(v)
        AimbotHoldMode = v
        if AimbotHoldMode then AimbotActive = false end
    end
})

CombatSection:AddSlider({
    text = "Aimbot Smoothness",
    flag = "Aimbot_Smoothness",
    tooltip = "0 = snap, 1 = smooth",
    min = 0,
    max = 1,
    increment = 0.01,
    value = 0,
    callback = function(v)
        Smoothness = v
    end
})

CombatSection:AddList({
    text = "Tracking Bone",
    values = {"Head", "Neck", "UpperTorso"},
    selected = "Head",
    flag = "Aimbot_Part",
    tooltip = "Where to aim on the enemy",
    callback = function(v)
        TrackingPart = v
    end
})

CombatSection:AddList({
    text = "Aim Mode",
    values = {"Camera", "Mouse"},
    selected = "Camera",
    flag = "Aimbot_Mode",
    tooltip = "Camera lock or mouse movement",
    callback = function(v)
        AimMode = v
    end
})
