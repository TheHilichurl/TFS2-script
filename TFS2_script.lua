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
ContentFrame.CanvasSize = UDim2.new(0,0,0,1500)
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
local MoveSettingsLabel              = createSectionLabel("=== AUTO MOVE ===", 310)
local DistanceFrame, DistanceTextBox = createLabeledBox("Distance:",2,330)

-- Toggle Settings
local AttackPosFrame, AttackPosDropdown, AttackPosMenu = createDropdown("Attack Position", {"Above", "Behind", "Front"}, "Above", 360)

-- Priority Targets Section
local PriorityLabel = createSectionLabel("=== PRIORITY TARGETS ===", 400)
local SniperFrame, SniperToggle = createToggle("Sniper Zombie", 420, true)
local WraithFrame, WraithToggle = createToggle("Wraith", 450, true)
local HunterFrame, HunterToggle = createToggle("Hunter", 480, true)
local LurkerFrame, LurkerToggle = createToggle("Lurker", 510, true)
local BerserkerFrame, BerserkerToggle = createToggle("Berserker", 540, true)
local BossFrame, BossToggle = createToggle("Boss", 570, true)

-- Mid Map Section
local MidMapLabel = createSectionLabel("=== MID MAP ===", 600)
local MidMapFrame, MidMapXBox       = createLabeledBox("Mid X:",0,620)
local MidMapYFrame, MidMapYBox      = createLabeledBox("Mid Y:",6,650)
local MidMapZFrame, MidMapZBox      = createLabeledBox("Mid Z:",-350,680)

-- Single Weapon Section
local SingleWeaponLabel = createSectionLabel("=== SINGLE WEAPON ===", 720)
local SingleWeaponFrame = Instance.new("Frame")
SingleWeaponFrame.Parent = ContentFrame
SingleWeaponFrame.Position = UDim2.new(0,8,0,740)
SingleWeaponFrame.Size = UDim2.new(1,-16,0,120)
SingleWeaponFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SingleWeaponFrame.Visible = false
SingleWeaponFrame.BorderSizePixel = 0
Instance.new("UICorner",SingleWeaponFrame).CornerRadius = UDim.new(0,5)

local SingleWeaponMenuLabel = Instance.new("TextLabel")
SingleWeaponMenuLabel.Parent = SingleWeaponFrame
SingleWeaponMenuLabel.Size = UDim2.new(1,0,0,24)
SingleWeaponMenuLabel.Position = UDim2.new(0,0,0,0)
SingleWeaponMenuLabel.BackgroundTransparency = 1
SingleWeaponMenuLabel.Font = Enum.Font.SourceSansBold
SingleWeaponMenuLabel.Text = "Single Weapon Select"
SingleWeaponMenuLabel.TextColor3 = Color3.fromRGB(255,180,120)
SingleWeaponMenuLabel.TextScaled = true

local SingleWeaponListScroll = Instance.new("ScrollingFrame")
SingleWeaponListScroll.Parent = SingleWeaponFrame
SingleWeaponListScroll.Position = UDim2.new(0,0,0,24)
SingleWeaponListScroll.Size = UDim2.new(1,0,1,-24)
SingleWeaponListScroll.ScrollBarThickness = 4
SingleWeaponListScroll.CanvasSize = UDim2.new(0,0,0,100)
SingleWeaponListScroll.BackgroundTransparency = 1
SingleWeaponListScroll.BorderSizePixel = 0

-- Multiple Weapon Section
local MultipleWeaponLabel = createSectionLabel("=== MULTIPLE WEAPON ===", 870)
local MultipleWeaponToggleFrame, MultipleWeaponToggleBtn = createToggle("Multiple Weapon Mode", 890, false)

local MultipleWeaponFrame = Instance.new("Frame")
MultipleWeaponFrame.Parent = ContentFrame
MultipleWeaponFrame.Position = UDim2.new(0,8,0,920)
MultipleWeaponFrame.Size = UDim2.new(1,-16,0,150)
MultipleWeaponFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MultipleWeaponFrame.Visible = false
MultipleWeaponFrame.BorderSizePixel = 0
Instance.new("UICorner",MultipleWeaponFrame).CornerRadius = UDim.new(0,5)

local MultipleWeaponMenuLabel = Instance.new("TextLabel")
MultipleWeaponMenuLabel.Parent = MultipleWeaponFrame
MultipleWeaponMenuLabel.Size = UDim2.new(1,0,0,24)
MultipleWeaponMenuLabel.Position = UDim2.new(0,0,0,0)
MultipleWeaponMenuLabel.BackgroundTransparency = 1
MultipleWeaponMenuLabel.Font = Enum.Font.SourceSansBold
MultipleWeaponMenuLabel.Text = "Multiple Weapon Select"
MultipleWeaponMenuLabel.TextColor3 = Color3.fromRGB(255,180,120)
MultipleWeaponMenuLabel.TextScaled = true

local MultipleWeaponListScroll = Instance.new("ScrollingFrame")
MultipleWeaponListScroll.Parent = MultipleWeaponFrame
MultipleWeaponListScroll.Position = UDim2.new(0,0,0,24)
MultipleWeaponListScroll.Size = UDim2.new(1,0,1,-24)
MultipleWeaponListScroll.ScrollBarThickness = 4
MultipleWeaponListScroll.CanvasSize = UDim2.new(0,0,0,100)
MultipleWeaponListScroll.BackgroundTransparency = 1
MultipleWeaponListScroll.BorderSizePixel = 0

-- Auto Weapon Switch Section
local WeaponSwitchLabel = createSectionLabel("=== AUTO WEAPON SWITCH ===", 1080)
local WeaponSwitchDelayFrame, WeaponSwitchDelayBox = createLabeledBox("Switch Delay (s):", 1, 1100)

-- Multiple Weapon Note
local MultipleWeaponNote = Instance.new("TextLabel")
MultipleWeaponNote.Parent = ContentFrame
MultipleWeaponNote.Size = UDim2.new(1,-16,0,40)
MultipleWeaponNote.Position = UDim2.new(0,8,0,1130)
MultipleWeaponNote.BackgroundTransparency = 1
MultipleWeaponNote.Font = Enum.Font.SourceSans
MultipleWeaponNote.Text = "Only turn on when you use laser or energy weapon and equipping Reverse Cooling perk. If you use normal weapon, just change the switch delay time higher than reload time."
MultipleWeaponNote.TextColor3 = Color3.fromRGB(255,100,100)
MultipleWeaponNote.TextScaled = true
MultipleWeaponNote.TextWrapped = true
MultipleWeaponNote.Visible = false

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
local flySpeed = math.huge
local attackDistance = 2

-- Lock Target (always enabled)
local currentLockedTarget = nil
local targetCheckConnection = nil

-- Attack Position
local attackPosition = "Above"

-- Priority target settings
local priorityTargets = {
    Sniper = true,
    Wraith = true,
    Hunter = true,
    Lurker = true,
    Berserker = true,
    Boss = true
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

local midMapPos = Vector3.new(0, 6, -350)

-- Weapon System Variables
local selectedSingleWeapon = nil
local selectedMultipleWeapons = {} -- Table to store multiple selected weapons
local multipleWeaponMode = false
local currentWeaponIndex = 1
local weaponSwitchDelay = 1
local lastWeaponSwitchTime = 0
local isSwitchingWeapon = false

-- Noclip Variables
local noclipEnabled = false
local noclipConnection = nil

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
        if not currentLockedTarget then
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
        
        return Vector3.new(frontPosition.X, enemyPos.Y, frontPosition.Z)
    else
        -- Above
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

-- ================= WEAPON SYSTEM =================

local function equipSingleWeapon()
    if not selectedSingleWeapon then return end
    
    local character = localPlayer.Character
    if character then
        -- Check if the correct weapon is already equipped
        local currentWeapon = nil
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                currentWeapon = tool
                break
            end
        end
        
        -- Only switch weapons if the current weapon is not the selected one
        if not currentWeapon or currentWeapon.Name ~= selectedSingleWeapon then
            -- Unequip all weapons first
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = localPlayer.Backpack
                end
            end
            
            -- Equip selected weapon
            local foundTool = localPlayer.Backpack:FindFirstChild(selectedSingleWeapon)
            if foundTool then
                foundTool.Parent = character
            end
        end
    end
end

local function switchToNextWeapon()
    if #selectedMultipleWeapons == 0 or isSwitchingWeapon then
        return
    end
    
    isSwitchingWeapon = true
    
    -- Unequip all weapons first
    local character = localPlayer.Character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = localPlayer.Backpack
            end
        end
        
        -- Equip next weapon
        currentWeaponIndex = currentWeaponIndex + 1
        if currentWeaponIndex > #selectedMultipleWeapons then
            currentWeaponIndex = 1
        end
        
        local nextWeaponName = selectedMultipleWeapons[currentWeaponIndex]
        local foundTool = localPlayer.Backpack:FindFirstChild(nextWeaponName)
        if foundTool then
            foundTool.Parent = character
        end
    end
    
    isSwitchingWeapon = false
end

local function autoWeaponSwitch()
    if not multipleWeaponMode or #selectedMultipleWeapons <= 1 then
        return -- No need to switch if not in multiple mode or 1 or fewer weapons selected
    end
    
    local currentTime = tick()
    if currentTime - lastWeaponSwitchTime >= weaponSwitchDelay then
        switchToNextWeapon()
        lastWeaponSwitchTime = currentTime
    end
end

local function equipWeaponIfNeeded()
    if multipleWeaponMode then
        if #selectedMultipleWeapons > 0 then
            autoWeaponSwitch()
        end
    else
        -- Always ensure the selected single weapon is equipped during combat
        if selectedSingleWeapon and (_G.autoshoot or _G.automove) then
            equipSingleWeapon()
        end
    end
end

-- ================= TARGET PRIORITY SYSTEM =================

local function getTargetPriority(zombieName)
    local nameLower = string.lower(zombieName)
    
    if priorityTargets.Sniper and string.find(nameLower, "sniper") then
        return 7
    elseif priorityTargets.Wraith and string.find(nameLower, "wraith") then
        return 6
    elseif priorityTargets.Hunter and string.find(nameLower, "hunter") then
        return 5
    elseif priorityTargets.Lurker and string.find(nameLower, "lurker") then
        return 4
    elseif priorityTargets.Berserker and string.find(nameLower, "berserker") then
        return 3
    elseif priorityTargets.Boss and string.find(nameLower, "boss") then
        return 2
    else
        return 1
    end
end

local function findPriorityZombie()
    if currentLockedTarget and isTargetValid(currentLockedTarget) then
        local distance = (currentLockedTarget.Head.Position - localPlayer.Character.Head.Position).Magnitude
        return currentLockedTarget, distance
    end
    
    local bestTarget = nil
    local bestPriority = -1
    local bestDistanceToMid = math.huge
    
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("Head") then 
        return nil, math.huge 
    end
    
    local allZombies = {}
    for _, zombie in pairs(workspace.Zombies:GetChildren()) do
        if zombie and zombie:FindFirstChild("Head") and zombie:FindFirstChild("Zombie") and zombie.Zombie.Health > 0 then
            table.insert(allZombies, zombie)
        end
    end
    
    -- First pass: find priority targets based on distance to mid point
    for _, zombie in pairs(allZombies) do
        local priority = getTargetPriority(zombie.Name)
        local distanceToMid = (zombie.Head.Position - midMapPos).Magnitude
        
        if priority > 1 then -- This is a priority target
            if priority > bestPriority then
                bestTarget = zombie
                bestPriority = priority
                bestDistanceToMid = distanceToMid
            elseif priority == bestPriority then
                -- If same priority, choose the one closer to mid
                if distanceToMid < bestDistanceToMid then
                    bestTarget = zombie
                    bestDistanceToMid = distanceToMid
                end
            end
        end
    end
    
    -- If no priority target found, find the closest zombie to mid point
    if not bestTarget then
        bestDistanceToMid = math.huge
        for _, zombie in pairs(allZombies) do
            local distanceToMid = (zombie.Head.Position - midMapPos).Magnitude
            if distanceToMid < bestDistanceToMid then
                bestDistanceToMid = distanceToMid
                bestTarget = zombie
            end
        end
    end
    
    if bestTarget then
        lockCurrentTarget(bestTarget)
    else
        currentLockedTarget = nil
    end
    
    local finalDistance = bestTarget and (bestTarget.Head.Position - localPlayer.Character.Head.Position).Magnitude or math.huge
    return bestTarget, finalDistance
end

-- ================= NOCLIP SYSTEM =================
local function enableNoclip()
    if not localPlayer.Character then return end
    
    noclipEnabled = true
    
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    
    noclipConnection = RunService.Stepped:Connect(function()
        if not _G.noclip or not localPlayer.Character then
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
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
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
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
SniperToggle.MouseButton1Click:Connect(function()
    priorityTargets.Sniper = not priorityTargets.Sniper
    SniperToggle.Text = priorityTargets.Sniper and "ON" or "OFF"
    SniperToggle.TextColor3 = priorityTargets.Sniper and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
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

BerserkerToggle.MouseButton1Click:Connect(function()
    priorityTargets.Berserker = not priorityTargets.Berserker
    BerserkerToggle.Text = priorityTargets.Berserker and "ON" or "OFF"
    BerserkerToggle.TextColor3 = priorityTargets.Berserker and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
end)

BossToggle.MouseButton1Click:Connect(function()
    priorityTargets.Boss = not priorityTargets.Boss
    BossToggle.Text = priorityTargets.Boss and "ON" or "OFF"
    BossToggle.TextColor3 = priorityTargets.Boss and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
end)

MultipleWeaponToggleBtn.MouseButton1Click:Connect(function()
    multipleWeaponMode = not multipleWeaponMode
    MultipleWeaponToggleBtn.Text = multipleWeaponMode and "ON" or "OFF"
    MultipleWeaponToggleBtn.TextColor3 = multipleWeaponMode and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
    
    -- Reset weapon state when switching modes
    currentWeaponIndex = 1
    lastWeaponSwitchTime = 0
    isSwitchingWeapon = false
    
    -- Equip appropriate weapon based on mode
    if multipleWeaponMode and #selectedMultipleWeapons > 0 then
        switchToNextWeapon()
    elseif not multipleWeaponMode and selectedSingleWeapon then
        equipSingleWeapon()
    end
end)

-- Dropdown Events
AttackPosDropdown.MouseButton1Click:Connect(function()
    attackPosition = AttackPosDropdown.Text
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

WeaponSwitchDelayBox.FocusLost:Connect(function()
    local v = tonumber(WeaponSwitchDelayBox.Text)
    if v and v > 0 then
        weaponSwitchDelay = v
        WeaponSwitchDelayBox.Text = tostring(weaponSwitchDelay)
    else
        WeaponSwitchDelayBox.Text = tostring(weaponSwitchDelay)
    end
end)

-- Weapon Menu Functions
function refreshSingleWeaponMenu()
    SingleWeaponListScroll:ClearAllChildren()
    local weapons = {}
    for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(weapons, tool.Name)
        end
    end
    
    for i, weaponName in pairs(weapons) do
        local btn = Instance.new("TextButton")
        btn.Parent = SingleWeaponListScroll
        btn.Size = UDim2.new(1,0,0,28)
        btn.Position = UDim2.new(0,0,0,(i-1)*30)
        btn.Text = weaponName
        btn.Font = Enum.Font.SourceSans
        btn.TextScaled = true
        
        -- Check if weapon is selected
        local isSelected = (selectedSingleWeapon == weaponName)
        
        btn.BackgroundColor3 = isSelected and Color3.fromRGB(120,200,100) or Color3.fromRGB(90,90,120)
        btn.BorderSizePixel = 0
        Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
        
        btn.MouseButton1Click:Connect(function()
            -- Single selection - only one weapon can be selected
            selectedSingleWeapon = weaponName
            refreshSingleWeaponMenu()
            
            -- Equip the weapon immediately if not in multiple mode
            if not multipleWeaponMode then
                equipSingleWeapon()
            end
        end)
    end
    SingleWeaponListScroll.CanvasSize = UDim2.new(0,0,0,#weapons*30)
end

function refreshMultipleWeaponMenu()
    MultipleWeaponListScroll:ClearAllChildren()
    local weapons = {}
    for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(weapons, tool.Name)
        end
    end
    
    for i, weaponName in pairs(weapons) do
        local btn = Instance.new("TextButton")
        btn.Parent = MultipleWeaponListScroll
        btn.Size = UDim2.new(1,0,0,28)
        btn.Position = UDim2.new(0,0,0,(i-1)*30)
        btn.Text = weaponName
        btn.Font = Enum.Font.SourceSans
        btn.TextScaled = true
        
        -- Check if weapon is selected
        local isSelected = false
        for _, selectedWeapon in ipairs(selectedMultipleWeapons) do
            if selectedWeapon == weaponName then
                isSelected = true
                break
            end
        end
        
        btn.BackgroundColor3 = isSelected and Color3.fromRGB(120,200,100) or Color3.fromRGB(90,90,120)
        btn.BorderSizePixel = 0
        Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
        
        btn.MouseButton1Click:Connect(function()
            -- Toggle weapon selection for multiple weapons
            local foundIndex = nil
            for index, selectedWeapon in ipairs(selectedMultipleWeapons) do
                if selectedWeapon == weaponName then
                    foundIndex = index
                    break
                end
            end
            
            if foundIndex then
                table.remove(selectedMultipleWeapons, foundIndex)
            else
                table.insert(selectedMultipleWeapons, weaponName)
            end
            
            -- Reset current weapon index when selection changes
            if #selectedMultipleWeapons > 0 then
                currentWeaponIndex = 1
                
                -- Equip first weapon immediately if in multiple mode
                if multipleWeaponMode then
                    switchToNextWeapon()
                end
            else
                currentWeaponIndex = 0
            end
            
            refreshMultipleWeaponMenu()
        end)
    end
    MultipleWeaponListScroll.CanvasSize = UDim2.new(0,0,0,#weapons*30)
end

-- Toggle Menu
HubTitle.MouseButton1Click:Connect(function()
    expanded = not expanded
    ContentFrame.Visible = expanded
    SingleWeaponFrame.Visible = expanded
    MultipleWeaponFrame.Visible = expanded
    if expanded then
        refreshSingleWeaponMenu()
        refreshMultipleWeaponMenu()
        MainFrame.Size = UDim2.new(0,250,0,1200)
        
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
        DistanceFrame.Visible = true
        AttackPosFrame.Visible = true
        
        PriorityLabel.Visible = true
        SniperFrame.Visible = true
        WraithFrame.Visible = true
        HunterFrame.Visible = true
        LurkerFrame.Visible = true
        BerserkerFrame.Visible = true
        BossFrame.Visible = true
        
        MidMapLabel.Visible = true
        MidMapFrame.Visible = true
        MidMapYFrame.Visible = true
        MidMapZFrame.Visible = true
        
        SingleWeaponLabel.Visible = true
        SingleWeaponFrame.Visible = true
        
        MultipleWeaponLabel.Visible = true
        MultipleWeaponToggleFrame.Visible = true
        MultipleWeaponFrame.Visible = true
        
        WeaponSwitchLabel.Visible = true
        WeaponSwitchDelayFrame.Visible = true
        
        MultipleWeaponNote.Visible = true
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
        DistanceFrame.Visible = false
        AttackPosFrame.Visible = false
        AttackPosMenu.Visible = false
        
        PriorityLabel.Visible = false
        SniperFrame.Visible = false
        WraithFrame.Visible = false
        HunterFrame.Visible = false
        LurkerFrame.Visible = false
        BerserkerFrame.Visible = false
        BossFrame.Visible = false
        
        MidMapLabel.Visible = false
        MidMapFrame.Visible = false
        MidMapYFrame.Visible = false
        MidMapZFrame.Visible = false
        
        SingleWeaponLabel.Visible = false
        SingleWeaponFrame.Visible = false
        
        MultipleWeaponLabel.Visible = false
        MultipleWeaponToggleFrame.Visible = false
        MultipleWeaponFrame.Visible = false
        
        WeaponSwitchLabel.Visible = false
        WeaponSwitchDelayFrame.Visible = false
        
        MultipleWeaponNote.Visible = false
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

local function autoShoot(target, dist)
    if not target or not target:FindFirstChild("Head") then return end
    
    -- Ensure correct weapon is equipped before shooting
    equipWeaponIfNeeded()
    
    -- Auto weapon switching (only in multiple weapon mode)
    if multipleWeaponMode and #selectedMultipleWeapons > 1 and _G.autoshoot then
        autoWeaponSwitch()
    end
    
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

-- ================= Auto Ready Logic =================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteFunctions = ReplicatedStorage:WaitForChild("RemoteFunctions")
local voteSkip = remoteFunctions:WaitForChild("VoteSkip")

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
						pcall(function()
							voteSkip:InvokeServer()
						end)
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
        -- Ensure correct weapon is equipped before combat actions
        equipWeaponIfNeeded()
        
        -- Aimbot
        if _G.aimbot then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Head.Position)
        end
        
        -- Auto Move
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
    
    -- Reset weapon switching
    currentWeaponIndex = 1
    lastWeaponSwitchTime = 0
    isSwitchingWeapon = false
    
    task.wait(1)
    if _G.noclip then
        enableNoclip()
    end
    
    -- Re-equip selected weapons based on mode
    task.wait(2) -- Wait for character to fully load
    if multipleWeaponMode and #selectedMultipleWeapons > 0 then
        switchToNextWeapon()
    elseif not multipleWeaponMode and selectedSingleWeapon then
        equipSingleWeapon()
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
