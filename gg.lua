-- =============================================
-- AUTO STEAL ONLY v3 - More Aggressive + Debug
-- =============================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer

-- Networking
local Net
do
    local sm = ReplicatedStorage:WaitForChild("SharedModules", 10)
    local mod = sm and sm:FindFirstChild("Networking")
    if mod then
        local success, module = pcall(require, mod)
        if success then Net = module end
    end
end

if not Net then
    warn("❌ Networking module not found!")
    return
end

local function fire(path, ...)
    local cur = Net
    for segment in string.gmatch(path, "[^.]+") do
        cur = cur[segment]
        if not cur then return false end
    end
    if cur and cur.Fire then
        local success, err = pcall(function(...)
            cur:Fire(...)
        end, ...)
        if not success then warn("Fire failed:", path, err) end
        return success
    end
    return false
end

-- Get stealable fruits
local function getStealable()
    local fruits = {}
    for _, prompt in ipairs(CollectionService:GetTagged("StealPrompt")) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local model = prompt:FindFirstAncestorWhichIsA("Model") or prompt.Parent
            while model and not model:GetAttribute("PlantId") do
                model = model.Parent
            end
            if model and model:GetAttribute("PlantId") then
                local pos = model:GetPivot().Position
                table.insert(fruits, {
                    owner = tonumber(model:GetAttribute("UserId")) or 0,
                    plantId = tostring(model:GetAttribute("PlantId")),
                    fruitId = tostring(model:GetAttribute("FruitId") or ""),
                    pos = pos,
                    prompt = prompt
                })
            end
        end
    end
    return fruits
end

local function stealOne(fruit)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Teleport very close
    pcall(function()
        hrp.CFrame = CFrame.new(fruit.pos + Vector3.new(0, 4, 0))
    end)
    task.wait(0.3)

    -- Fire steal
    local s1 = fire("Steal.BeginSteal", fruit.owner, fruit.plantId, fruit.fruitId)
    local s2 = fire("Steal.CompleteSteal")

    print("🔥 Steal attempt:", s1 and s2 and "SUCCESS" or "FAILED", fruit.plantId)

    -- Return to base
    local base = nil
    local plotId = LocalPlayer:GetAttribute("PlotId")
    if plotId then
        local plot = Workspace.Gardens and Workspace.Gardens:FindFirstChild("Plot"..plotId)
        if plot then
            for _, p in ipairs(CollectionService:GetTagged("GardenZone")) do
                if p:IsDescendantOf(plot) then base = p.Position end
            end
        end
    end

    if base and hrp then
        pcall(function()
            hrp.CFrame = CFrame.new(base + Vector3.new(0, 5, 0))
        end)
    end
end

-- ================== UI ==================
local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "StealHub"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0.5, -130, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "AUTO STEAL"
title.TextColor3 = Color3.fromRGB(255, 85, 85)
title.TextSize = 22
title.Font = Enum.Font.GothamBold

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.8,0,0,60)
btn.Position = UDim2.new(0.1,0,0.45,0)
btn.BackgroundColor3 = Color3.fromRGB(50,50,60)
btn.Text = "OFF"
btn.TextColor3 = Color3.fromRGB(255,100,100)
btn.TextSize = 20
btn.Font = Enum.Font.GothamBold
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

-- Draggable
frame.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local start = frame.Position
        local mouseStart = i.Position
        local conn = UserInputService.InputChanged:Connect(function(m)
            if m.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = m.Position - mouseStart
                frame.Position = UDim2.new(start.X.Scale, start.X.Offset + delta.X, start.Y.Scale, start.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function() conn:Disconnect() end)
    end
end)

-- Toggle
local running = false
local connection

btn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        btn.Text = "ON - SPAMMING"
        btn.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
        connection = RunService.Heartbeat:Connect(function()
            if running then
                for _, fruit in ipairs(getStealable()) do
                    pcall(stealOne, fruit)
                    task.wait(0.6)
                end
            end
        end)
    else
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(50,50,60)
        if connection then connection:Disconnect() end
    end
end)

print("🚀 Steal Hub v3 Loaded - Turn ON and stand near stealable fruits")
