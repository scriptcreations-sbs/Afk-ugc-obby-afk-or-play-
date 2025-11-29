-- ======================================================
--   ACTIVAR SOLO EN TU JUEGO (80692223709267)
-- ======================================================
if game.PlaceId ~= 80692223709267 then
    warn("SCRIPT DESACTIVADO - No estás en el juego correcto.")
    return
end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- =========================
-- GUI PRINCIPAL
-- =========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoObbyGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 260)
Frame.Position = UDim2.new(0.5, -125, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45,45,45)
Title.Text = "AUTO OBBY + FREE COIL"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

local DelayLabel = Instance.new("TextLabel", Frame)
DelayLabel.Position = UDim2.new(0,10,0,40)
DelayLabel.Size = UDim2.new(0, 100, 0, 30)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Delay:"
DelayLabel.TextColor3 = Color3.fromRGB(255,255,255)
DelayLabel.Font = Enum.Font.SourceSansBold
DelayLabel.TextSize = 18

local DelayBox = Instance.new("TextBox", Frame)
DelayBox.Position = UDim2.new(0, 120, 0, 40)
DelayBox.Size = UDim2.new(0,100,0,30)
DelayBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
DelayBox.Text = "0.2"
DelayBox.TextColor3 = Color3.fromRGB(255,255,255)
DelayBox.TextSize = 18

local StartButton = Instance.new("TextButton", Frame)
StartButton.Position = UDim2.new(0,15,0,80)
StartButton.Size = UDim2.new(0,215,0,40)
StartButton.BackgroundColor3 = Color3.fromRGB(0,120,0)
StartButton.Text = "Comenzar AUTO OBBY"
StartButton.TextColor3 = Color3.fromRGB(255,255,255)
StartButton.Font = Enum.Font.SourceSansBold
StartButton.TextSize = 18

local SpeedButton = Instance.new("TextButton", Frame)
SpeedButton.Position = UDim2.new(0,15,0,130)
SpeedButton.Size = UDim2.new(0,215,0,40)
SpeedButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
SpeedButton.TextColor3 = Color3.fromRGB(255,255,255)
SpeedButton.Font = Enum.Font.SourceSansBold
SpeedButton.TextSize = 18
SpeedButton.Text = "Velocidad: Normal"

local FreeCoilButton = Instance.new("TextButton", Frame)
FreeCoilButton.Position = UDim2.new(0,15,0,180)
FreeCoilButton.Size = UDim2.new(0,215,0,40)
FreeCoilButton.BackgroundColor3 = Color3.fromRGB(90,0,120)
FreeCoilButton.TextColor3 = Color3.fromRGB(255,255,255)
FreeCoilButton.Font = Enum.Font.SourceSansBold
FreeCoilButton.TextSize = 18
FreeCoilButton.Text = "Free Coil"

local ytText = Instance.new("TextButton", Frame)
ytText.Position = UDim2.new(0, 15, 0, 230)
ytText.Size = UDim2.new(0, 215, 0, 25)
ytText.BackgroundColor3 = Color3.fromRGB(20,20,20)
ytText.TextColor3 = Color3.fromRGB(255,255,255)
ytText.Font = Enum.Font.GothamBold
ytText.TextSize = 14
ytText.Text = "YOUTUBE: @SEBAS_SCRIPT"

ytText.MouseButton1Click:Connect(function()
    setclipboard("https://youtube.com/@sebas_script?si=GRYs7SUmlJNE5sfn")
end)

-- =========================
-- AUTO OBBY
-- =========================
local char
local humRoot
local running = false
local lastCheckpoint = 1

local speedModes = {
    {name = "Lento",  stepsMult = 3.5},
    {name = "Normal", stepsMult = 2},
    {name = "Rápido", stepsMult = 1.3},
    {name = "Ultra",  stepsMult = 0.9},
    {name = "Hiper",  stepsMult = 0.5},
    {name = "OP",     stepsMult = 0.25}
}
local currentSpeedIndex = 2

local function getRoot()
    char = player.Character or player.CharacterAdded:Wait()
    humRoot = char:WaitForChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.HealthChanged:Connect(function()
            hum.Health = hum.MaxHealth
        end)
    end
end

getRoot()
player.CharacterAdded:Connect(function()
    task.wait(1)
    getRoot()
    if running then
        local cp = workspace:FindFirstChild(tostring(lastCheckpoint), true)
        if cp then humRoot.CFrame = cp.CFrame + Vector3.new(0,3,0) end
    end
end)

local function getCheckpoint(num)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == tostring(num) then
            return obj
        end
    end
    return nil
end

local function moveOP(destination)
    if not humRoot then return end
    local startPos = humRoot.Position
    local target = destination.Position + Vector3.new(0,2,0)
    local distance = (target - startPos).Magnitude
    local mode = speedModes[currentSpeedIndex]
    local steps = math.clamp(math.floor(distance * mode.stepsMult), 60, 450)

    for i = 1, steps do
        if not running then return end
        humRoot.CFrame = CFrame.new(startPos:Lerp(target, i/steps))
        task.wait(0.015)
    end
end

local function detectCurrentCheckpoint()
    local closest, dist = nil, math.huge
    for _, cp in ipairs(workspace:GetDescendants()) do
        if cp:IsA("BasePart") and tonumber(cp.Name) then
            local d = (humRoot.Position - cp.Position).Magnitude
            if d < dist then
                dist = d
                closest = tonumber(cp.Name)
            end
        end
    end
    return closest or lastCheckpoint
end

SpeedButton.MouseButton1Click:Connect(function()
    currentSpeedIndex += 1
    if currentSpeedIndex > #speedModes then currentSpeedIndex = 1 end
    SpeedButton.Text = "Velocidad: " .. speedModes[currentSpeedIndex].name
end)

StartButton.MouseButton1Click:Connect(function()
    if running then return end
    running = true
    local delay = tonumber(DelayBox.Text) or 0.2
    lastCheckpoint = detectCurrentCheckpoint()

    for stage = lastCheckpoint, 251 do
        if not running then break end
        if stage == 100 then moveOP({Position = Vector3.new(-515,155,692)}); lastCheckpoint = 101 end
        if stage == 243 then moveOP({Position = Vector3.new(1762,775,45)}); lastCheckpoint = 244 end
        local cp = getCheckpoint(stage)
        if cp then
            moveOP(cp)
            lastCheckpoint = stage
        end
        task.wait(delay)
    end
    running = false
end)

-- Anti-AFK
task.spawn(function()
    while task.wait(60 * 18.5) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.new(0,1,0)
            task.wait(0.2)
            hrp.CFrame = hrp.CFrame * CFrame.new(0,-1,0)
        end
    end
end)

-- =========================
-- FREE COIL PERMANENTE POR BOTÓN
-- =========================
local toolsList = {"SpeedCoil","GravityCoil","RegenCoil","FusionCoil"}
local savedTools = {}

local function removeEffects(tool)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    hum.WalkSpeed = 16
    hum.JumpPower = 50
    hum.UseJumpPower = true
    local disconnectEvent = tool:FindFirstChild("DisconnectConnection")
    if disconnectEvent then disconnectEvent:Fire(); disconnectEvent:Destroy() end
end

local function applyEffect(tool)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if tool.Name == "SpeedCoil" then
        hum.WalkSpeed = 25
    elseif tool.Name == "GravityCoil" then
        hum.UseJumpPower = true
        hum.JumpPower = 100

        local connection
        connection = RunService.Stepped:Connect(function()
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                local vel = hrp.Velocity
                if vel.Y < 0 then hrp.Velocity = Vector3.new(vel.X, vel.Y*0.9, vel.Z) end
            end
        end)

        local bind = Instance.new("BindableEvent")
        bind.Name = "DisconnectConnection"
        bind.Parent = tool
        bind.Event:Connect(function() connection:Disconnect() end)
    end
end

local function giveTool(toolName)
    local backpack = player:WaitForChild("Backpack")
    local source = ReplicatedStorage:FindFirstChild("TemporaryToolFolder") or ReplicatedStorage:FindFirstChild("Tools")
    if not source then return end
    local tool = source:FindFirstChild(toolName)
    if not tool then return end

    local function spawnTool()
        if savedTools[toolName] then
            local clone = savedTools[toolName]
            if clone.Parent ~= backpack then
                clone.Parent = backpack
            end
            return
        end

        local clone = tool:Clone()
        clone.Parent = backpack
        savedTools[toolName] = clone

        clone.Equipped:Connect(function() applyEffect(clone) end)
        clone.Unequipped:Connect(function() removeEffects(clone) end)
        clone.AncestryChanged:Connect(function(_, parent)
            if not parent then task.wait(0.1); spawnTool() end
        end)
    end

    spawnTool()
end

local function giveAllTools()
    for _, name in ipairs(toolsList) do giveTool(name) end
end

FreeCoilButton.MouseButton1Click:Connect(giveAllTools)

-- Mantener coils al respawnear
player.CharacterAdded:Connect(function()
    task.wait(1)
    giveAllTools()
end)
