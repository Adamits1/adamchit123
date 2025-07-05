local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "Adam Chit 123",
    gamename = "Steal a Brainrot"
})

library:init()

local Window = library.NewWindow({
    title = "Adam Chit 123 | Steal a Brainrot",
    size = UDim2.new(0, 510, 0.6, 6)
})

local Tab1 = Window:AddTab("  Main  ")
local Tab2 = Window:AddTab("  Movement  ")
local Tab3 = Window:AddTab("  Utility  ")
local SettingsTab = library:CreateSettingsTab(Window)

local CombatSection = Tab1:AddSection("Combat Hacks", 1)
local MovementSection = Tab2:AddSection("Movement Hacks", 1)
local UtilitySection = Tab3:AddSection("Utility Hacks", 1)

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

CombatSection:AddButton({
    enabled = true,
    text = "Hack the Server",
    flag = "hack_server_btn",
    tooltip = "Spam colored dots",
    confirm = false,
    callback = function()
        library:SendNotification("Hacking server...", 2)
        for i = 1, 50 do
            task.delay(i * 0.05, function()
                local dot = Drawing.new("Text")
                dot.Text = "adams on top klavs kaka"
                dot.Size = 20
                dot.Color = Color3.fromHSV(math.random(), 1, 1)
                dot.Position = Vector2.new(math.random(0, 800), math.random(0, 600))
                dot.Visible = true
                task.delay(0.5, function() dot:Remove() end)
            end)
        end
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
    text = "Godmode (Evade)",
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
                        task.delay(2, function() godmodeCooldown = false end)
                        break
                    end
                end
            end
        end
    end
end)

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


