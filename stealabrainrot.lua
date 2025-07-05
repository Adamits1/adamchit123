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
local Tab4 = Window:AddTab("  Visuals  ")
local SettingsTab = library:CreateSettingsTab(Window)

local CombatSection = Tab1:AddSection("Main", 1)
local MovementSection = Tab2:AddSection("Movement", 1)
local UtilitySection = Tab3:AddSection("Utility", 1)
local VisualsSection = Tab4:AddSection("Visuals", 1)



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
                        task.delay(0.01, function() godmodeCooldown = false end)
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

--// Simple Box ESP and Name ESP
local espEnabled = false
local nameEspEnabled = false
local boxColor = Color3.fromRGB(255, 0, 0)
local nameColor = Color3.fromRGB(0, 255, 0)
local espObjects = {}

local function clearEsp()
    for _, v in pairs(espObjects) do
        if v and v.Remove then v:Remove() end
    end
    espObjects = {}
end

RunService.RenderStepped:Connect(function()
    if not (espEnabled or nameEspEnabled) then
        clearEsp()
        return
    end

    clearEsp()

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                if boxColor and espEnabled then
                    local box = Drawing.new("Square")
                    box.Size = Vector2.new(50, 100)
                    box.Position = Vector2.new(screenPos.X - 25, screenPos.Y - 50)
                    box.Color = boxColor
                    box.Thickness = 2
                    box.Visible = true
                    table.insert(espObjects, box)
                end

                if nameColor and nameEspEnabled then
                    local nameText = Drawing.new("Text")
                    nameText.Text = plr.Name
                    nameText.Position = Vector2.new(screenPos.X - (#plr.Name * 3), screenPos.Y - 60)
                    nameText.Color = nameColor
                    nameText.Size = 16
                    nameText.Center = false
                    nameText.Outline = true
                    nameText.Visible = true
                    table.insert(espObjects, nameText)
                end
            end
        end
    end
end)

VisualsSection:AddToggle({
    text = "Box ESP",
    flag = "esp_box",
    tooltip = "Enable Box ESP",
    callback = function(v) espEnabled = v end
}):AddColor({
    text = "ESP Box Color",
    color = boxColor,
    flag = "esp_box_color",
    callback = function(v) boxColor = v end
})

VisualsSection:AddToggle({
    text = "Name ESP",
    flag = "esp_name",
    tooltip = "Enable Name ESP",
    callback = function(v) nameEspEnabled = v end
}):AddColor({
    text = "ESP Name Color",
    color = nameColor,
    flag = "esp_name_color",
    callback = function(v) nameColor = v end
})



local FunnyTab = Window:AddTab("  Funny  ")
local FunnySection = FunnyTab:AddSection("Funny Features", 1)

-- 1. Penis feature: Draw silly text on screen corners
local penisTexts = {}
local function createPenisText()
    local t = Drawing.new("Text")
    t.Text = "( ͡° ͜ʖ ͡°) 🍆"
    t.Size = 40
    t.Center = false
    t.Outline = true
    t.OutlineColor = Color3.new(0, 0, 0)
    t.Font = 3
    t.Visible = false
    return t
end

for i = 1, 4 do
    table.insert(penisTexts, createPenisText())
end

local showPenis = false
RunService.RenderStepped:Connect(function()
    local screenSize = workspace.CurrentCamera.ViewportSize
    penisTexts[1].Position = Vector2.new(40, 40)
    penisTexts[2].Position = Vector2.new(screenSize.X - 140, 40)
    penisTexts[3].Position = Vector2.new(40, screenSize.Y - 140)
    penisTexts[4].Position = Vector2.new(screenSize.X - 140, screenSize.Y - 140)

    for _, text in ipairs(penisTexts) do
        text.Visible = showPenis
        if showPenis then
            text.Color = Color3.fromHSV(math.random(), 1, 1)
        end
    end
end)

FunnySection:AddToggle({
    enabled = true,
    text = "Show Penis (🍆) Text",
    flag = "funny_penis",
    tooltip = "Show silly penis emoji texts in corners",
    callback = function(v)
        showPenis = v
    end
})

-- 2. Spam silly chat messages
FunnySection:AddButton({
    enabled = true,
    text = "Spam Funny Chat",
    flag = "funny_chat_spam",
    tooltip = "Spam funny messages in chat",
    callback = function()
        local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chat and chat:FindFirstChild("SayMessageRequest") then
            for i = 1, 20 do
                task.delay(i * 0.3, function()
                    chat.SayMessageRequest:FireServer("I am a funny bot 🤖😂", "All")
                end)
            end
            library:SendNotification("Spam started!", 3)
        else
            library:SendNotification("Chat service not found", 3)
        end
    end
})

-- 3. Silly rainbow text on screen
local rainbowFunnyText = Drawing.new("Text")
rainbowFunnyText.Text = "FUNNY MODE ACTIVATED"
rainbowFunnyText.Size = 50
rainbowFunnyText.Position = Vector2.new(300, 100)
rainbowFunnyText.Center = true
rainbowFunnyText.Outline = true
rainbowFunnyText.OutlineColor = Color3.new(0,0,0)
rainbowFunnyText.Visible = false

local showRainbowFunny = false
FunnySection:AddToggle({
    enabled = true,
    text = "Show Rainbow Funny Text",
    flag = "funny_rainbow_text",
    tooltip = "Shows a rainbow funny message on screen",
    callback = function(v)
        showRainbowFunny = v
        rainbowFunnyText.Visible = v
    end
})

RunService.RenderStepped:Connect(function()
    if showRainbowFunny then
        local hue = tick() % 5 / 5
        rainbowFunnyText.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- 4. Random silly sound effect (play a silly sound near player)
FunnySection:AddButton({
    enabled = true,
    text = "Play Silly Sound",
    flag = "funny_sound",
    tooltip = "Play a funny sound near you",
    callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://5419095697" -- funny cartoon boing sound
        sound.Volume = 5
        sound.Parent = hrp
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end
})

-- 5. Change all players' names to "FunnyGuy"
FunnySection:AddButton({
    enabled = true,
    text = "Rename Everyone to NIGGER",
    flag = "funny_rename",
    tooltip = "Change all visible players' names",
    callback = function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.DisplayName = "NIGGER"
                end
            end
        end
        library:SendNotification("Everyone renamed to NIGGER!", 3)
    end
})

-- 6. Spin local player’s character like a tornado (also spins while walking, 10x faster, walk straight)
local spinning = false
local spinConnection = nil
FunnySection:AddToggle({
    enabled = true,
    text = "Spin Character",
    flag = "funny_spin",
    tooltip = "Spin your character endlessly and when walking (10x faster)",
    callback = function(v)
        spinning = v
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end

        if spinning then
            spinConnection = RunService.Heartbeat:Connect(function(dt)
                -- Spin 10x faster (3600 deg per sec)
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(3600) * dt, 0)
                -- If walking, apply spinning effect but still move forward straight
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local forward = hrp.CFrame.LookVector
                    hum:Move(forward, false) -- walk straight forward while spinning
                end
            end)
        end
    end
})

-- 7. Upside-down walk (crab walk becomes upside-down walk)
local crabWalkEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Upside Down Walk",
    flag = "funny_crab_walk",
    tooltip = "Flip your character upside down while walking",
    callback = function(v)
        crabWalkEnabled = v
    end
})

RunService.Heartbeat:Connect(function(dt)
    if crabWalkEnabled then
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            hum.WalkSpeed = 16
            local moveDir = hum.MoveDirection
            -- Move normally but flip upside down
            hum:Move(moveDir, false)
            -- Flip character upside down by rotating 180 degrees on X axis
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(math.rad(180), hrp.Orientation.Y, hrp.Orientation.Z)
        end
    end
end)

-- 8. Change chat text color to rainbow (notify only)
FunnySection:AddButton({
    enabled = true,
    text = "Rainbow Chat Text (Notify)",
    flag = "funny_chat_rainbow",
    tooltip = "Notify chat rainbow feature (manual)",
    callback = function()
        library:SendNotification("Rainbow chat text would be cool, but depends on game chat system!", 5)
    end
})

-- 9. Randomly jump with silly sound
local sillyJumpEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Silly Jump",
    flag = "funny_silly_jump",
    tooltip = "Randomly jump with funny sound",
    callback = function(v)
        sillyJumpEnabled = v
    end
})

task.spawn(function()
    while true do
        task.wait(3)
        if sillyJumpEnabled then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    local sound = Instance.new("Sound", hrp)
                    sound.SoundId = "rbxassetid://138186576"
                    sound.Volume = 5
                    sound:Play()
                    sound.Ended:Connect(function() sound:Destroy() end)
                end
            end
        end
    end
end)

-- 10. Make local player invisible temporarily (funny ghost mode)
local invisibleEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Ghost Mode (Invisible)",
    flag = "funny_ghost_mode",
    tooltip = "Make your character invisible temporarily",
    callback = function(v)
        invisibleEnabled = v
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if v then
                    part.Transparency = 1
                else
                    part.Transparency = 0
                end
            end
        end
    end
})

-- 11. Infinite Jump
local infiniteJumpEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Infinite Jump",
    flag = "funny_infinite_jump",
    tooltip = "Allows jumping infinitely",
    callback = function(v)
        infiniteJumpEnabled = v
    end
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- 12. Annoying fart sound every 10 seconds
local fartEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Annoying Fart Sounds",
    flag = "funny_fart",
    tooltip = "Plays annoying fart sounds repeatedly",
    callback = function(v)
        fartEnabled = v
    end
})

task.spawn(function()
    while true do
        task.wait(10)
        if fartEnabled then
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local sound = Instance.new("Sound", hrp)
                    sound.SoundId = "rbxassetid://8430024127"
                    sound.Volume = 8
                    sound:Play()
                    sound.Ended:Connect(function() sound:Destroy() end)
                end
            end
        end
    end
end)

-- 13. Make character dance randomly
local danceEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Random Dance",
    flag = "funny_dance",
    tooltip = "Makes your character dance randomly",
    callback = function(v)
        danceEnabled = v
    end
})

task.spawn(function()
    while true do
        task.wait(5)
        if danceEnabled then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:LoadAnimation(Instance.new("Animation", hum) { AnimationId = "rbxassetid://507771019" }):Play()
                end
            end
        end
    end
end)

-- 14. Make your character extremely tall (like a giant)
local giantEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Giant Mode",
    flag = "funny_giant",
    tooltip = "Make your character extremely tall",
    callback = function(v)
        giantEnabled = v
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = v and part.Size * 6 or part.Size / 6
            end
        end
    end
})

-- 15. Make your character tiny (tiny mode)
local tinyEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Tiny Mode",
    flag = "funny_tiny",
    tooltip = "Make your character tiny",
    callback = function(v)
        tinyEnabled = v
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = v and part.Size / 3 or part.Size * 3
            end
        end
    end
})

-- 16. Randomly change walk speed
local randomSpeedEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Random Walk Speed",
    flag = "funny_random_speed",
    tooltip = "Randomly changes your walk speed",
    callback = function(v)
        randomSpeedEnabled = v
    end
})

task.spawn(function()
    while true do
        task.wait(2)
        if randomSpeedEnabled then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = math.random(8, 100)
                end
            end
        end
    end
end)

-- 17. Rainbow character colors cycling
local rainbowCharEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Rainbow Character",
    flag = "funny_rainbow_char",
    tooltip = "Makes your character cycle through rainbow colors",
    callback = function(v)
        rainbowCharEnabled = v
    end
})

task.spawn(function()
    while true do
        task.wait(0.1)
        if rainbowCharEnabled then
            local char = LocalPlayer.Character
            if char then
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 1, 1)
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = color
                    elseif part:IsA("Decal") then
                        part.Color3 = color
                    end
                end
            end
        end
    end
end)

-- 18. Annoying blinking screen effect
local blinkEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Annoying Blink Screen",
    flag = "funny_blink_screen",
    tooltip = "Makes screen blink annoyingly",
    callback = function(v)
        blinkEnabled = v
    end
})

local blinkGui = Instance.new("ScreenGui", game.CoreGui)
blinkGui.IgnoreGuiInset = true
local blinkFrame = Instance.new("Frame", blinkGui)
blinkFrame.Size = UDim2.new(1, 0, 1, 0)
blinkFrame.BackgroundColor3 = Color3.new(1, 1, 1)
blinkFrame.BackgroundTransparency = 1

task.spawn(function()
    while true do
        task.wait(0.3)
        if blinkEnabled then
            blinkFrame.BackgroundTransparency = 0
            task.wait(0.1)
            blinkFrame.BackgroundTransparency = 1
        else
            blinkFrame.BackgroundTransparency = 1
        end
    end
end)

-- 19. Make local player’s footsteps play silly sound
local footstepEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Silly Footsteps Sound",
    flag = "funny_footsteps",
    tooltip = "Play silly footsteps sounds when moving",
    callback = function(v)
        footstepEnabled = v
    end
})

local lastPos = nil
task.spawn(function()
    while true do
        task.wait(0.5)
        if footstepEnabled then
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if lastPos then
                        if (hrp.Position - lastPos).Magnitude > 0.5 then
                            local sound = Instance.new("Sound", hrp)
                            sound.SoundId = "rbxassetid://8430024127"
                            sound.Volume = 8
                            sound:Play()
                            sound.Ended:Connect(function() sound:Destroy() end)
                        end
                    end
                    lastPos = hrp.Position
                end
            end
        end
    end
end)

-- 20. Make local player’s head bob uncontrollably while walking
local headBobEnabled = false
FunnySection:AddToggle({
    enabled = true,
    text = "Crazy Head Bob",
    flag = "funny_head_bob",
    tooltip = "Make your head bob uncontrollably while walking",
    callback = function(v)
        headBobEnabled = v
    end
})

RunService.Heartbeat:Connect(function(dt)
    if headBobEnabled then
        local char = LocalPlayer.Character
        if char then
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if head and hum then
                local freq = 100
                local amp = 0.2
                if hum.MoveDirection.Magnitude > 0 then
                    local offset = math.sin(tick() * freq) * amp
                    head.CFrame = head.CFrame * CFrame.new(0, offset * dt * 10, 0)
                end
            end
        end
    end
end)

