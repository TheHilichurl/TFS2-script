-- =================== Hilichurl HUB ===================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30,25,25)
MainFrame.Position = UDim2.new(0.05,0,0.3,0)
MainFrame.Size = UDim2.new(0,250,0,40)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,5)

-- Title
local HubTitle = Instance.new("TextButton")
HubTitle.Parent = MainFrame
HubTitle.BackgroundColor3 = Color3.fromRGB(60,50,50)
HubTitle.Size = UDim2.new(1,0,0,40)
HubTitle.Font = Enum.Font.SourceSansBold
HubTitle.Text = "Hilichurl HUB"
HubTitle.TextColor3 = Color3.fromRGB(255,170,80)
HubTitle.TextScaled = true
HubTitle.BorderSizePixel = 0
Instance.new("UICorner",HubTitle).CornerRadius = UDim.new(0,5)

-- ScrollingFrame for menu
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(40,35,35)
ContentFrame.Position = UDim2.new(0,0,0,40)
ContentFrame.Size = UDim2.new(1,0,0,400)
ContentFrame.CanvasSize = UDim2.new(0,0,0,1200)
ContentFrame.ScrollBarThickness = 4
ContentFrame.Visible = false
ContentFrame.BorderSizePixel = 0
Instance.new("UICorner",ContentFrame).CornerRadius = UDim.new(0,5)

-- UI Helpers
local function createBtn(text, posY)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentFrame
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    btn.Size = UDim2.new(1,-16,0,28)
    btn.Position = UDim2.new(0,8,0,posY)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Visible = false
    btn.BorderSizePixel = 0
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,5)
    return btn
end

local function createToggle(text, posY, default)
    local frame = Instance.new("Frame")
    frame.Parent = ContentFrame
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0,8,0,posY)
    frame.Size = UDim2.new(1,-16,0,28)
    frame.Visible = false

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7,0,1,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Position = UDim2.new(0.7,5,0,0)
    toggleBtn.Size = UDim2.new(0.3,-5,1,0)
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = default and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
    toggleBtn.TextScaled = true
    toggleBtn.BorderSizePixel = 0
    Instance.new("UICorner",toggleBtn).CornerRadius = UDim.new(0,5)
    
    return frame, toggleBtn
end

local function createLabeledBox(labelText, default, posY)
    local frame = Instance.new("Frame")
    frame.Parent = ContentFrame
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0,8,0,posY)
    frame.Size = UDim2.new(1,-16,0,24)
    frame.Visible = false

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5,0,1,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.TextScaled = true

    local tb = Instance.new("TextBox")
    tb.Parent = frame
    tb.Position = UDim2.new(0.5,5,0,0)
    tb.Size = UDim2.new(0.5,-5,1,0)
    tb.BackgroundColor3 = Color3.fromRGB(100,100,100)
    tb.Font = Enum.Font.SourceSans
    tb.Text = tostring(default)
    tb.TextColor3 = Color3.fromRGB(255,255,255)
    tb.TextScaled = true
    tb.BorderSizePixel = 0
    Instance.new("UICorner",tb).CornerRadius = UDim.new(0,5)

    return frame, tb
end

local function createDropdown(labelText, options, default, posY)
    local frame = Instance.new("Frame")
    frame.Parent = ContentFrame
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0,8,0,posY)
    frame.Size = UDim2.new(1,-16,0,28)
    frame.Visible = false

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5,0,1,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Parent = frame
    dropdownBtn.Position = UDim2.new(0.5,5,0,0)
    dropdownBtn.Size = UDim2.new(0.5,-5,1,0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
    dropdownBtn.Font = Enum.Font.SourceSans
    dropdownBtn.Text = default
    dropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
    dropdownBtn.TextScaled = true
    dropdownBtn.BorderSizePixel = 0
    Instance.new("UICorner",dropdownBtn).CornerRadius = UDim.new(0,5)

    -- Dropdown menu
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Parent = ContentFrame
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(80,80,80)
    dropdownFrame.Position = UDim2.new(0,8,0,posY + 30)
    dropdownFrame.Size = UDim2.new(1,-16,0,0)
    dropdownFrame.Visible = false
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.ClipsDescendants = true
    Instance.new("UICorner",dropdownFrame).CornerRadius = UDim.new(0,5)

    local layout = Instance.new("UIListLayout", dropdownFrame)
    layout.Padding = UDim.new(0,2)

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Parent = dropdownFrame
        optionBtn.Size = UDim2.new(1,0,0,25)
        optionBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        optionBtn.Font = Enum.Font.SourceSans
        optionBtn.Text = option
        optionBtn.TextColor3 = Color3.fromRGB(255,255,255)
        optionBtn.TextScaled = true
        optionBtn.BorderSizePixel = 0
        Instance.new("UICorner",optionBtn).CornerRadius = UDim.new(0,3)
        
        optionBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            dropdownFrame.Visible = false
            dropdownFrame.Size = UDim2.new(1,-16,0,0)
        end)
    end

    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
        if dropdownFrame.Visible then
            dropdownFrame.Size = UDim2.new(1,-16,0,#options * 27)
        else
            dropdownFrame.Size = UDim2.new(1,-16,0,0)
        end
    end)

    return frame, dropdownBtn, dropdownFrame
end

local function createSectionLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Parent = ContentFrame
    label.Size = UDim2.new(1,-16,0,20)
    label.Position = UDim2.new(0,8,0,posY)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,170,80)
    label.TextScaled = true
    label.Visible = false
    return label
end

-- =================== BUTTONS AND CONTROLS ===================

-- Main Buttons
local ToggleAimbotBtn    = createBtn("Aimbot OFF",8)
local ToggleShootBtn     = createBtn("Auto Shoot OFF",40)
local ToggleMoveBtn      = createBtn("Auto Move OFF",72)
local ToggleNoclipBtn    = createBtn("Noclip OFF",104)
local ToggleMidMapBtn    = createBtn("Mid Map OFF",136)
local ToggleAutoReadyBtn = createBtn("Auto Ready OFF",168)

-- Combat Section
local CombatLabel                      = createSectionLabel("=== COMBAT ===", 200)
local SpeedFrame, SpeedTextBox         = createLabeledBox("Speed:",14,220)
local AttackSpdFrame, AttackSpdBox     = createLabeledBox("Atk Speed:",0.05,250)
local ShootRangeFrame, ShootRangeTextBox = createLabeledBox("Shoot Range:",200,280)

-- Auto Move Settings
local MoveSettingsLabel              = createSectionLabel("=== AUTO MOVE ===", 320)
local FlySpeedFrame, FlySpeedTextBox = createLabeledBox("Fly Speed:",30000,340)
local DistanceFrame, DistanceTextBox = createLabeledBox("Distance:",2,370)

-- Toggle Settings
local LockTargetFrame, LockTargetToggle = createToggle("Lock Target", 400, true)
local AttackPosFrame, AttackPosDropdown, AttackPosMenu = createDropdown("Attack Position", {"Above", "Behind", "Front"}, "Above", 430)

-- Priority Targets Section
local PriorityLabel = createSectionLabel("=== PRIORITY TARGETS ===", 470)
local WraithFrame, WraithToggle = createToggle("Wraith", 490, true)
local HunterFrame, HunterToggle = createToggle("Hunter", 520, true)
local LurkerFrame, LurkerToggle = createToggle("Lurker", 550, true)
local BossFrame, BossToggle = createToggle("Boss", 580, true)
local ClosestFrame, ClosestToggle = createToggle("Closest to Mid", 610, true)

-- Mid Map Section
local MidMapLabel = createSectionLabel("=== MID MAP ===", 650)
local MidMapFrame, MidMapXBox       = createLabeledBox("Mid X:",0,670)
local MidMapYFrame, MidMapYBox      = createLabeledBox("Mid Y:",-6,700)
local MidMapZFrame, MidMapZBox      = createLabeledBox("Mid Z:",-350,730)

-- Weapon Menu
local WeaponMenuFrame = Instance.new("Frame")
WeaponMenuFrame.Parent = ContentFrame
WeaponMenuFrame.Position = UDim2.new(0,8,0,760)
WeaponMenuFrame.Size = UDim2.new(1,-16,0,120)
WeaponMenuFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
WeaponMenuFrame.Visible = false
WeaponMenuFrame.BorderSizePixel = 0
Instance.new("UICorner",WeaponMenuFrame).CornerRadius = UDim.new(0,5)

local WeaponMenuLabel = Instance.new("TextLabel")
WeaponMenuLabel.Parent = WeaponMenuFrame
WeaponMenuLabel.Size = UDim2.new(1,0,0,24)
WeaponMenuLabel.Position = UDim2.new(0,0,0,0)
WeaponMenuLabel.BackgroundTransparency = 1
WeaponMenuLabel.Font = Enum.Font.SourceSansBold
WeaponMenuLabel.Text = "Weapon Select"
WeaponMenuLabel.TextColor3 = Color3.fromRGB(255,180,120)
WeaponMenuLabel.TextScaled = true

local WeaponListScroll = Instance.new("ScrollingFrame")
WeaponListScroll.Parent = WeaponMenuFrame
WeaponListScroll.Position = UDim2.new(0,0,0,24)
WeaponListScroll.Size = UDim2.new(1,0,1,-24)
WeaponListScroll.ScrollBarThickness = 4
WeaponListScroll.CanvasSize = UDim2.new(0,0,0,100)
WeaponListScroll.BackgroundTransparency = 1
WeaponListScroll.BorderSizePixel = 0

-- ================= Global Variables =================
_G.aimbot = false
_G.autoshoot = false
_G.automove = false
_G.noclip = false
_G.autoready = false

-- CFrameFly variables
local flyEnabled = false
local flyConnection = nil
local currentFlyTarget = nil
local flySpeed = 30000
local attackDistance = 2

-- Lock Target
local lockTargetEnabled = true
local currentLockedTarget = nil
local targetCheckConnection = nil

-- Attack Position
local attackPosition = "Above"

-- Priority target settings
local priorityTargets = {
    Wraith = true,
    Hunter = true,
    Lurker = true,
    Boss = true,
    Closest = true
}

-- Stable movement
local lastTargetPos = nil
local positionStabilized = false
local STABILIZATION_THRESHOLD = 2

local midMapEnabled = false
local expanded = false

local baseSpeed = 14
local attackDelay = 0.05
local shootRange = 200

local midMapPos = Vector3.new(0, -6, -350)

local selectedWeapon = nil

-- Noclip Variables
local noclipEnabled = false
local originalCollisions = {}
local noclipLoop = nil

-- ================= LOCK TARGET SYSTEM =================

local function isTargetValid(target)
    if not target or not target.Parent then
        return false
    end
    
    local zombie = target:FindFirstChild("Zombie")
    if not zombie then
        return false
    end
    
    if zombie.Health <= 0 then
        return false
    end
    
    return true
end

local function startTargetCheck()
    if targetCheckConnection then
        targetCheckConnection:Disconnect()
    end
    
    targetCheckConnection = RunService.Heartbeat:Connect(function()
        if not lockTargetEnabled or not currentLockedTarget then
            return
        end
        
        if not isTargetValid(currentLockedTarget) then
            currentLockedTarget = nil
            lastTargetPos = nil
            positionStabilized = false
        end
    end)
end

local function lockCurrentTarget(target)
    if not lockTargetEnabled then
        return
    end
    
    currentLockedTarget = target
    lastTargetPos = nil
    positionStabilized = false
    startTargetCheck()
end

-- ================= ATTACK POSITION SYSTEM =================

local function calculateAttackPosition(target)
    if not target or not target:FindFirstChild("Head") then return nil end
    
    local enemyHead = target.Head
    local enemyPos = enemyHead.Position
    
    if attackPosition == "Behind" then
        -- Behind
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("Head") then
            return nil
        end
        
        local playerPos = localPlayer.Character.Head.Position
        local toPlayer = (playerPos - enemyPos).Unit
        
        -- Backward direction is opposite to the direction to the player
        local behindDirection = -toPlayer * attackDistance
        local behindPosition = enemyPos + behindDirection
        
        -- Distance
        return Vector3.new(behindPosition.X, enemyPos.Y, behindPosition.Z)
        
    elseif attackPosition == "Front" then
        -- Front
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("Head") then
            return nil
        end
        
        local playerPos = localPlayer.Character.Head.Position
        local toPlayer = (playerPos - enemyPos).Unit
        
        -- Front direction is towards the player
        local frontDirection = toPlayer * attackDistance
        local frontPosition = enemyPos + frontDirection
        
        -- 
        return Vector3.new(frontPosition.X, enemyPos.Y, frontPosition.Z)
    else
        -- Default Above
        return Vector3.new(enemyPos.X, enemyPos.Y + attackDistance, enemyPos.Z)
    end
end

-- ================= MOVEMENT SYSTEM =================

local function startCFrameFly(targetPosition)
    if not localPlayer.Character then return false end
    
    local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
    local head = localPlayer.Character:FindFirstChild("Head")
    
    if not humanoid or not head then return false end
    
    -- Store original states
    local originalPlatformStand = humanoid.PlatformStand
    local originalHeadAnchored = head.Anchored
    
    -- Enable fly state
    humanoid.PlatformStand = true
    head.Anchored = true
    flyEnabled = true
    currentFlyTarget = targetPosition
    
    -- Clean previous connection
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    local lastStablePosition = head.Position
    
    flyConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not flyEnabled or not localPlayer.Character or not currentFlyTarget then
            return
        end
        
        local currentHumanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local currentHead = localPlayer.Character:FindFirstChild("Head")
        
        if not currentHumanoid or not currentHead then
            return
        end
        
        local currentPos = currentHead.Position
        local targetPos = currentFlyTarget
        local direction = (targetPos - currentPos)
        local distance = direction.Magnitude
        
        -- Position stabilization
        if distance < STABILIZATION_THRESHOLD then
            if not positionStabilized then
                positionStabilized = true
                lastStablePosition = currentPos
            end
            return
        else
            positionStabilized = false
        end
        
        
        local moveDirection = direction.Unit * math.min(flySpeed * deltaTime, distance)
        
        
        local headCFrame = currentHead.CFrame
        local camera = workspace.CurrentCamera
        local cameraCFrame = camera.CFrame
        
    
        local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
        
        
        cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
        local cameraPosition = cameraCFrame.Position
        local headPosition = headCFrame.Position
        
     
        local lookCFrame = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z))
        local objectSpaceVelocity = lookCFrame:VectorToObjectSpace(moveDirection)
        
       
        local newCFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
        
        currentHead.CFrame = newCFrame
    end)
    
    return true
end

local function stopCFrameFly()
    flyEnabled = false
    currentFlyTarget = nil
    lastTargetPos = nil
    positionStabilized = false
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    -- Restore original states
    if localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local head = localPlayer.Character:FindFirstChild("Head")
        
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        if head then
            head.Anchored = false
        end
    end
end

-- ================= TARGET PRIORITY SYSTEM =================

local function getTargetPriority(zombieName)
    local nameLower = string.lower(zombieName)
    
    if priorityTargets.Wraith and string.find(nameLower, "wraith") then
        return 5
    elseif priorityTargets.Hunter and string.find(nameLower, "hunter") then
        return 4
    elseif priorityTargets.Lurker and string.find(nameLower, "lurker") then
        return 3
    elseif priorityTargets.Boss and string.find(nameLower, "boss") then
        return 2
    else
        return 1
    end
end

local function findPriorityZombie()
    
    if lockTargetEnabled and currentLockedTarget and isTargetValid(currentLockedTarget) then
        local distance = (currentLockedTarget.Head.Position - localPlayer.Character.Head.Position).Magnitude
        return currentLockedTarget, distance
    end
    
    local bestTarget = nil
    local bestPriority = -1
    local bestDistance = math.huge
    
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("Head") then 
        return nil, math.huge 
    end
    
   
    local allZombies = {}
    for _, zombie in pairs(workspace.Zombies:GetChildren()) do
        if zombie and zombie:FindFirstChild("Head") and zombie:FindFirstChild("Zombie") and zombie.Zombie.Health > 0 then
            table.insert(allZombies, zombie)
        end
    end
    
    -- Priority enemy (Wraith, Hunter, Lurker, Boss)
    for _, zombie in pairs(allZombies) do
        local priority = getTargetPriority(zombie.Name)
        
        
        if priority > bestPriority then
            bestTarget = zombie
            bestPriority = priority
        
        elseif priority == bestPriority and bestTarget then
            local currentDistance = (zombie.Head.Position - localPlayer.Character.Head.Position).Magnitude
            local bestTargetDistance = (bestTarget.Head.Position - localPlayer.Character.Head.Position).Magnitude
            if currentDistance < bestTargetDistance then
                bestTarget = zombie
            end
        end
    end
    
    
    if not bestTarget and priorityTargets.Closest then
        local closestDistanceToMid = math.huge
        local closestTargetToMid = nil
        
        for _, zombie in pairs(allZombies) do
            local distanceToMid = (zombie.Head.Position - midMapPos).Magnitude
            
            if distanceToMid < closestDistanceToMid then
                closestDistanceToMid = distanceToMid
                closestTargetToMid = zombie
            end
        end
        
        if closestTargetToMid then
            bestTarget = closestTargetToMid
        end
    end
    
    
    if bestTarget and lockTargetEnabled then
        lockCurrentTarget(bestTarget)
    else
        currentLockedTarget = nil
    end
    
    local finalDistance = bestTarget and (bestTarget.Head.Position - localPlayer.Character.Head.Position).Magnitude or math.huge
    return bestTarget, finalDistance
end

-- ================= BUTTON EVENTS =================

ToggleAimbotBtn.MouseButton1Click:Connect(function()
    _G.aimbot = not _G.aimbot
    ToggleAimbotBtn.Text = _G.aimbot and "Aimbot ON" or "Aimbot OFF"
    ToggleAimbotBtn.BackgroundColor3 = _G.aimbot and Color3.fromRGB(100,180,100) or Color3.fromRGB(80,80,80)
end)

ToggleShootBtn.MouseButton1Click:Connect(function()
    _G.autoshoot = not _G.autoshoot
    ToggleShootBtn.Text = _G.autoshoot and "Auto Shoot ON" or "Auto Shoot OFF"
    ToggleShootBtn.BackgroundColor3 = _G.autoshoot and Color3.fromRGB(100,180,100) or Color3.fromRGB(80,80,80)
end)

ToggleMoveBtn.MouseButton1Click:Connect(function()
    _G.automove = not _G.automove
    ToggleMoveBtn.Text = _G.automove and "Auto Move ON" or "Auto Move OFF"
    ToggleMoveBtn.BackgroundColor3 = _G.automove and Color3.fromRGB(100,180,100) or Color3.fromRGB(80,80,80)
    
    
    if _G.automove then
        
        local target, _ = findPriorityZombie()
        if target then
            local attackPos = calculateAttackPosition(target)
            if attackPos then
                startCFrameFly(attackPos)
            end
        end
    else
        
        stopCFrameFly()
    end
end)

ToggleMidMapBtn.MouseButton1Click:Connect(function()
    midMapEnabled = not midMapEnabled
    ToggleMidMapBtn.Text = midMapEnabled and "Mid Map ON" or "Mid Map OFF"
    ToggleMidMapBtn.BackgroundColor3 = midMapEnabled and Color3.fromRGB(100,180,100) or Color3.fromRGB(80,80,80)
end)

ToggleAutoReadyBtn.MouseButton1Click:Connect(function()
    _G.autoready = not _G.autoready
    ToggleAutoReadyBtn.Text = _G.autoready and "Auto Ready ON" or "Auto Ready OFF"
    ToggleAutoReadyBtn.BackgroundColor3 = _G.autoready and Color3.fromRGB(100,180,100) or Color3.fromRGB(80,80,80)
end)

ToggleNoclipBtn.MouseButton1Click:Connect(function()
    _G.noclip = not _G.noclip
    ToggleNoclipBtn.Text = _G.noclip and "Noclip ON" or "Noclip OFF"
    ToggleNoclipBtn.BackgroundColor3 = _G.noclip and Color3.fromRGB(100,180,100) or Color3.fromRGB(80,80,80)
    
    if _G.noclip then
        enableNoclip()
    else
        disableNoclip()
    end
end)

-- Toggle Events
LockTargetToggle.MouseButton1Click:Connect(function()
    lockTargetEnabled = not lockTargetEnabled
    LockTargetToggle.Text = lockTargetEnabled and "ON" or "OFF"
    LockTargetToggle.TextColor3 = lockTargetEnabled and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
    
    if not lockTargetEnabled then
        currentLockedTarget = nil
        if targetCheckConnection then
            targetCheckConnection:Disconnect()
            targetCheckConnection = nil
        end
    end
end)

WraithToggle.MouseButton1Click:Connect(function()
    priorityTargets.Wraith = not priorityTargets.Wraith
    WraithToggle.Text = priorityTargets.Wraith and "ON" or "OFF"
    WraithToggle.TextColor3 = priorityTargets.Wraith and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
end)

HunterToggle.MouseButton1Click:Connect(function()
    priorityTargets.Hunter = not priorityTargets.Hunter
    HunterToggle.Text = priorityTargets.Hunter and "ON" or "OFF"
    HunterToggle.TextColor3 = priorityTargets.Hunter and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
end)

LurkerToggle.MouseButton1Click:Connect(function()
    priorityTargets.Lurker = not priorityTargets.Lurker
    LurkerToggle.Text = priorityTargets.Lurker and "ON" or "OFF"
    LurkerToggle.TextColor3 = priorityTargets.Lurker and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
end)

BossToggle.MouseButton1Click:Connect(function()
    priorityTargets.Boss = not priorityTargets.Boss
    BossToggle.Text = priorityTargets.Boss and "ON" or "OFF"
    BossToggle.TextColor3 = priorityTargets.Boss and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
end)

ClosestToggle.MouseButton1Click:Connect(function()
    priorityTargets.Closest = not priorityTargets.Closest
    ClosestToggle.Text = priorityTargets.Closest and "ON" or "OFF"
    ClosestToggle.TextColor3 = priorityTargets.Closest and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
end)

-- Dropdown Events
AttackPosDropdown.MouseButton1Click:Connect(function()
    
end)

-- TextBox Events
SpeedTextBox.FocusLost:Connect(function()
    local v = tonumber(SpeedTextBox.Text)
    if v then baseSpeed = v end
    SpeedTextBox.Text = tostring(baseSpeed)
end)

AttackSpdBox.FocusLost:Connect(function()
    local v = tonumber(AttackSpdBox.Text)
    if v then attackDelay = v end
    AttackSpdBox.Text = tostring(attackDelay)
end)

ShootRangeTextBox.FocusLost:Connect(function()
    local v = tonumber(ShootRangeTextBox.Text)
    if v and v > 0 then
        shootRange = v
        ShootRangeTextBox.Text = tostring(shootRange)
    else
        ShootRangeTextBox.Text = tostring(shootRange)
    end
end)

FlySpeedTextBox.FocusLost:Connect(function()
    local v = tonumber(FlySpeedTextBox.Text)
    if v and v > 0 then
        flySpeed = v
        FlySpeedTextBox.Text = tostring(flySpeed)
    else
        FlySpeedTextBox.Text = tostring(flySpeed)
    end
end)

DistanceTextBox.FocusLost:Connect(function()
    local v = tonumber(DistanceTextBox.Text)
    if v and v >= 0 then
        attackDistance = v
        DistanceTextBox.Text = tostring(attackDistance)
    else
        DistanceTextBox.Text = tostring(attackDistance)
    end
end)

MidMapXBox.FocusLost:Connect(function()
    local v = tonumber(MidMapXBox.Text)
    if v then midMapPos = Vector3.new(v, midMapPos.Y, midMapPos.Z) end
    MidMapXBox.Text = tostring(midMapPos.X)
end)

MidMapYBox.FocusLost:Connect(function()
    local v = tonumber(MidMapYBox.Text)
    if v then midMapPos = Vector3.new(midMapPos.X, v, midMapPos.Z) end
    MidMapYBox.Text = tostring(midMapPos.Y)
end)

MidMapZBox.FocusLost:Connect(function()
    local v = tonumber(MidMapZBox.Text)
    if v then midMapPos = Vector3.new(midMapPos.X, midMapPos.Y, v) end
    MidMapZBox.Text = tostring(midMapPos.Z)
end)

-- Weapon Menu
function refreshWeaponMenu()
    WeaponListScroll:ClearAllChildren()
    local weapons = {}
    for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(weapons, tool.Name)
        end
    end
    for i, weaponName in pairs(weapons) do
        local btn = Instance.new("TextButton")
        btn.Parent = WeaponListScroll
        btn.Size = UDim2.new(1,0,0,28)
        btn.Position = UDim2.new(0,0,0,(i-1)*30)
        btn.Text = weaponName
        btn.Font = Enum.Font.SourceSans
        btn.TextScaled = true
        btn.BackgroundColor3 = (selectedWeapon == weaponName) and Color3.fromRGB(120,200,100) or Color3.fromRGB(90,90,120)
        btn.BorderSizePixel = 0
        Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
        btn.MouseButton1Click:Connect(function()
            selectedWeapon = weaponName
            refreshWeaponMenu()
        end)
    end
    WeaponListScroll.CanvasSize = UDim2.new(0,0,0,#weapons*30)
end

-- Toggle Menu
HubTitle.MouseButton1Click:Connect(function()
    expanded = not expanded
    ContentFrame.Visible = expanded
    WeaponMenuFrame.Visible = expanded
    if expanded then
        refreshWeaponMenu()
        MainFrame.Size = UDim2.new(0,250,0,900)
        
        -- Show all elements
        ToggleAimbotBtn.Visible = true
        ToggleShootBtn.Visible = true
        ToggleMoveBtn.Visible = true
        ToggleNoclipBtn.Visible = true
        ToggleMidMapBtn.Visible = true
        ToggleAutoReadyBtn.Visible = true
        
        CombatLabel.Visible = true
        SpeedFrame.Visible = true
        AttackSpdFrame.Visible = true
        ShootRangeFrame.Visible = true
        
        MoveSettingsLabel.Visible = true
        FlySpeedFrame.Visible = true
        DistanceFrame.Visible = true
        LockTargetFrame.Visible = true
        AttackPosFrame.Visible = true
        
        PriorityLabel.Visible = true
        WraithFrame.Visible = true
        HunterFrame.Visible = true
        LurkerFrame.Visible = true
        BossFrame.Visible = true
        ClosestFrame.Visible = true
        
        MidMapLabel.Visible = true
        MidMapFrame.Visible = true
        MidMapYFrame.Visible = true
        MidMapZFrame.Visible = true
    else
        MainFrame.Size = UDim2.new(0,250,0,40)
        
        -- Hide all elements
        ToggleAimbotBtn.Visible = false
        ToggleShootBtn.Visible = false
        ToggleMoveBtn.Visible = false
        ToggleNoclipBtn.Visible = false
        ToggleMidMapBtn.Visible = false
        ToggleAutoReadyBtn.Visible = false
        
        CombatLabel.Visible = false
        SpeedFrame.Visible = false
        AttackSpdFrame.Visible = false
        ShootRangeFrame.Visible = false
        
        MoveSettingsLabel.Visible = false
        FlySpeedFrame.Visible = false
        DistanceFrame.Visible = false
        LockTargetFrame.Visible = false
        AttackPosFrame.Visible = false
        AttackPosMenu.Visible = false
        
        PriorityLabel.Visible = false
        WraithFrame.Visible = false
        HunterFrame.Visible = false
        LurkerFrame.Visible = false
        BossFrame.Visible = false
        ClosestFrame.Visible = false
        
        MidMapLabel.Visible = false
        MidMapFrame.Visible = false
        MidMapYFrame.Visible = false
        MidMapZFrame.Visible = false
    end
end)

-- Drag Menu
local dragging, dragStart, startPos
HubTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ================= Game Logic =================

local function zombiesAlive()
    for _, v in pairs(workspace.Zombies:GetChildren()) do
        if v and v:FindFirstChild("Zombie") and v.Zombie.Health > 0 then return true end
    end
    return false
end

local function isPlayerAlive()
    return localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character.Humanoid.Health > 0
end

local function moveToPosition(targetPos)
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") or not localPlayer.Character:FindFirstChild("Humanoid") then
        return false
    end
    local humanoid = localPlayer.Character.Humanoid
    local currentPos = localPlayer.Character.HumanoidRootPart.Position
    
    local distance = (targetPos - currentPos).Magnitude
    humanoid.WalkSpeed = baseSpeed
    if distance > 2 then
        humanoid:MoveTo(targetPos)
        return false
    end
    return true
end

local lastClickTime = 0

local function equipWeaponIfSelected()
    if not selectedWeapon then return end
    local backpack = localPlayer.Backpack
    local character = localPlayer.Character
    if character then
        local currentWeapon = nil
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                currentWeapon = tool.Name
                break
            end
        end
        if currentWeapon ~= selectedWeapon then
            local foundTool = backpack:FindFirstChild(selectedWeapon)
            if foundTool then
                foundTool.Parent = character
            end
        end
    end
end

local function autoShoot(target, dist)
    equipWeaponIfSelected()
    if not target or not target:FindFirstChild("Head") then return end
    local distance = dist or ((target.Head.Position - localPlayer.Character.Head.Position).Magnitude)
    if distance <= shootRange then
        local currentTime = tick()
        if currentTime - lastClickTime >= attackDelay then
            lastClickTime = currentTime
            if UserInputService.TouchEnabled then
                local screenSize = camera.ViewportSize
                local shootButtonPos = Vector2.new(screenSize.X * 0.85, screenSize.Y * 0.75)
                VirtualInputManager:SendMouseButtonEvent(shootButtonPos.X, shootButtonPos.Y, 0, true, game, 1)
                task.wait(0.06)
                VirtualInputManager:SendMouseButtonEvent(shootButtonPos.X, shootButtonPos.Y, 0, false, game, 1)
            else
                mouse1press()
                task.wait(0.05)
                mouse1release()
            end
        end
    end
end

-- ================= NOCLIP SYSTEM =================
local function enableNoclip()
    if not localPlayer.Character or zombiesAlive() then return end
    
    originalCollisions = {}
    for _, part in pairs(localPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollisions[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    noclipEnabled = true
    
    if noclipLoop then
        noclipLoop:Disconnect()
    end
    
    noclipLoop = RunService.Stepped:Connect(function()
        if not _G.noclip or zombiesAlive() or not localPlayer.Character then
            disableNoclip()
            return
        end
        
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    noclipEnabled = false
    
    if noclipLoop then
        noclipLoop:Disconnect()
        noclipLoop = nil
    end
    
    if localPlayer.Character then
        for part, canCollide in pairs(originalCollisions) do
            if part and part.Parent then
                part.CanCollide = canCollide
            end
        end
    end
    originalCollisions = {}
end

local function updateNoclip()
    local hasZombies = zombiesAlive()
    
    if _G.noclip and not hasZombies then
        if not noclipEnabled then
            enableNoclip()
        end
    else
        if noclipEnabled then
            disableNoclip()
        end
    end
end

RunService.Stepped:Connect(updateNoclip)

-- ================= Auto Ready Logic =================
local lastNoZombieTime = 0
local lastReadyClickTime = 0
local zombieTimerRunning = false
local autoReadyDelay = 15

local function autoReadyLogic()
    while task.wait(1) do
        if not _G.autoready then
            lastNoZombieTime = 0
            zombieTimerRunning = false
        else
            if not zombiesAlive() then
                if not zombieTimerRunning then
                    zombieTimerRunning = true
                    lastNoZombieTime = tick()
                end
                if tick() - lastNoZombieTime >= autoReadyDelay then
                    if tick() - lastReadyClickTime >= autoReadyDelay then
                        lastReadyClickTime = tick()
                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local root = localPlayer.Character.HumanoidRootPart
                            local thirdPersonOffset = root.CFrame * CFrame.new(0, 5, 10)
                            camera.CameraType = Enum.CameraType.Scriptable
                            camera.CFrame = thirdPersonOffset * CFrame.Angles(math.rad(-15), 0, 0)
                        end
                        task.wait(0.5)
                        local screenSize = camera.ViewportSize
                        local readyPos = Vector2.new(screenSize.X * 0.65, screenSize.Y * 0.06)
                        VirtualInputManager:SendMouseButtonEvent(readyPos.X, readyPos.Y, 0, true, game, 1)
                        task.wait(0.1)
                        VirtualInputManager:SendMouseButtonEvent(readyPos.X, readyPos.Y, 0, false, game, 1)
                        task.wait(0.5)
                        camera.CameraType = Enum.CameraType.Custom
                    end
                end
            else
                lastNoZombieTime = 0
                zombieTimerRunning = false
            end
        end
    end
end

-- ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
    -- Mid Map Logic
    if midMapEnabled and not zombiesAlive() and isPlayerAlive() then
        moveToPosition(midMapPos)
    end
    
    local target, dist = findPriorityZombie()
    
    if target then
        -- Aimbot
        if _G.aimbot then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Head.Position)
        end
        
        
        if _G.automove then
            local attackPos = calculateAttackPosition(target)
            
            if attackPos then
                
                if not lastTargetPos or (attackPos - lastTargetPos).Magnitude > 5 then
                    lastTargetPos = attackPos
                    
                    if not flyEnabled then
                        startCFrameFly(attackPos)
                    else
                        currentFlyTarget = attackPos
                    end
                end
            end
        end
        
        -- Auto Shoot
        if _G.autoshoot and dist <= shootRange then
            autoShoot(target, dist)
        end
    end
end)

coroutine.wrap(autoReadyLogic)()

-- Cleanup when character changes
localPlayer.CharacterAdded:Connect(function(character)
    stopCFrameFly()
    flyEnabled = false
    currentFlyTarget = nil
    
    currentLockedTarget = nil
    lastTargetPos = nil
    positionStabilized = false
    if targetCheckConnection then
        targetCheckConnection:Disconnect()
        targetCheckConnection = nil
    end
    
    disableNoclip()
    noclipEnabled = false
    originalCollisions = {}
    
    task.wait(1)
    if _G.noclip and not zombiesAlive() then
        enableNoclip()
    end
end)

localPlayer.CharacterRemoving:Connect(function()
    stopCFrameFly()
    disableNoclip()
    
    if targetCheckConnection then
        targetCheckConnection:Disconnect()
        targetCheckConnection = nil
    end
    currentLockedTarget = nil
end)
