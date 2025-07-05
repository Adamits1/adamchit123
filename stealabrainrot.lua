-- Adam Chit 123 UI Script

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

-- Adam Poo: Shows rainbow 123 on screen
local showRainbow123 = false
CombatSection:AddToggle({
    text = "Adam Poo",
    state = false,
    callback = function(v)
        showRainbow123 = v
    end
})

-- Helper to create enhanced text with stronger outline
local function createText()
    local text = Drawing.new("Text")
    text.Text = "Adam Poo"
    text.Size = 80 -- Bigger size
    text.Center = false
    text.Outline = true
    text.OutlineColor = Color3.new(0, 0, 0) -- Optional: make outline more visible
    text.Font = 3 -- 1=UI, 2=System, 3=Plex (bold/modern)
    text.Visible = false
    return text
end

-- Create 4 text objects for each corner
local cornerTexts = {}
for _ = 1, 4 do
    table.insert(cornerTexts, createText())
end

RunService.RenderStepped:Connect(function()
    local screenSize = Workspace.CurrentCamera.ViewportSize

    -- Set corner positions (adjusted for bigger text)
    cornerTexts[1].Position = Vector2.new(20, 20) -- Top Left
    cornerTexts[2].Position = Vector2.new(screenSize.X - 320, 20) -- Top Right
    cornerTexts[3].Position = Vector2.new(20, screenSize.Y - 100) -- Bottom Left
    cornerTexts[4].Position = Vector2.new(screenSize.X - 320, screenSize.Y - 100) -- Bottom Right

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

-- Hack the server (visual effect)
CombatSection:AddButton({
    text = "Hack the Server",
    callback = function()
        library:SendNotification("Hacking server...", 2)
        for i = 1, 50 do
            task.delay(i * 0.05, function()
                local dot = Drawing.new("Text")
                dot.Text = "●"
                dot.Size = 20
                dot.Color = Color3.fromHSV(math.random(), 1, 1)
                dot.Position = Vector2.new(math.random(0, 800), math.random(0, 600))
                dot.Visible = true
                task.delay(0.5, function() dot:Remove() end)
            end)
        end
    end
})

-- Anti Ragdoll
local noRagdollEnabled = false
UtilitySection:AddToggle({
    text = "No Ragdoll",
    state = false,
    callback = function(v)
        noRagdollEnabled = v
    end
})

RunService.Heartbeat:Connect(function()
    if noRagdollEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            hum.PlatformStand = false
            if hum:GetState() == Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
            for _, v in ipairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end)

-- Godmode (Evade)
local godmodeEnabled = false
UtilitySection:AddToggle({
    text = "Godmode (Evade)",
    state = false,
    callback = function(v)
        godmodeEnabled = v
    end
})

RunService.Heartbeat:Connect(function()
    if not godmodeEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < 15 then
                local escapeDirection = (root.Position - player.Character.HumanoidRootPart.Position).Unit
                root.CFrame = root.CFrame + escapeDirection * 20
                library:SendNotification("Enemy too close. Evading...", 2)
                break
            end
        end
    end
end)

-- Fly
local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

MovementSection:AddToggle({
    text = "Fly",
    state = false,
    callback = function(state)
        flying = state
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        if flying then
            bodyGyro = Instance.new("BodyGyro", hrp)
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.P = 9e4
            bodyVelocity = Instance.new("BodyVelocity", hrp)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

            coroutine.wrap(function()
                while flying and char and hrp and hum and hum.Health > 0 do
                    local cf = workspace.CurrentCamera.CFrame
                    local moveVec = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += cf.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= cf.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= cf.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += cf.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= Vector3.new(0, 1, 0) end
                    bodyVelocity.Velocity = moveVec.Unit * flySpeed
                    bodyGyro.CFrame = cf
                    task.wait()
                end
            end)()
        else
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
        end
    end
})

-- Freecam
local freecamEnabled = false
local freecamCamera
MovementSection:AddToggle({
    text = "Freecam",
    state = false,
    callback = function(v)
        freecamEnabled = v
        if v then
            freecamCamera = Instance.new("Camera")
            freecamCamera.CameraType = Enum.CameraType.Scriptable
            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            freecamCamera.CFrame = workspace.CurrentCamera.CFrame
            workspace.CurrentCamera.CameraSubject = nil

            local speed = 0.5
            RunService.RenderStepped:Connect(function()
                if not freecamEnabled then return end
                local input = Vector3.zero
                local cam = freecamCamera
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then input += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then input -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then input -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then input += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then input += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then input -= Vector3.new(0, 1, 0) end
                cam.CFrame = cam.CFrame + input.Unit * speed
                workspace.CurrentCamera.CFrame = cam.CFrame
            end)
        else
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})
