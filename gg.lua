local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer

-- Networking
local Net
do
    local sm = ReplicatedStorage:WaitForChild("SharedModules", 10)
    local mod = sm and sm:FindFirstChild("Networking")
    if mod then
        local ok, m = pcall(require, mod)
        if ok then Net = m end
    end
end

if not Net then
    warn("Networking module not found!")
    return
end

local function fire(path, ...)
    local cur = Net
    for segment in string.gmatch(path, "[^.]+") do
        cur = cur[segment]
        if not cur then return false end
    end
    if cur and cur.Fire then
        pcall(function(...) cur:Fire(...) end, ...)
        return true
    end
    return false
end

local function getStealable()
    local fruits = {}
    for _, prompt in ipairs(CollectionService:GetTagged("StealPrompt")) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled and prompt:IsDescendantOf(Workspace) then
            local model = prompt.Parent
            while model and model ~= Workspace and not model:GetAttribute("PlantId") do
                model = model.Parent
            end
            if model and model:GetAttribute("PlantId") then
                local ok, pos = pcall(function() return model:GetPivot().Position end)
                if ok then
                    table.insert(fruits, {
                        owner = tonumber(model:GetAttribute("UserId")) or 0,
                        plantId = tostring(model:GetAttribute("PlantId")),
                        fruitId = tostring(model:GetAttribute("FruitId") or ""),
                        pos = pos,
                    })
                end
            end
        end
    end
    return fruits
end

local function getBase()
    local plotId = LocalPlayer:GetAttribute("PlotId")
    if not plotId then return nil end
    local plot = Workspace:FindFirstChild("Gardens") and Workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId))
    if not plot then return nil end
    for _, p in ipairs(CollectionService:GetTagged("GardenZone")) do
        if p:IsA("BasePart") and p:IsDescendantOf(plot) then
            return p.Position + Vector3.new(0, 5, 0)
        end
    end
    return nil
end

local function stealOne(fruit)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    pcall(function()
        hrp.CFrame = CFrame.new(fruit.pos + Vector3.new(0, 4, 0))
    end)
    task.wait(0.35)

    fire("Steal.BeginSteal", fruit.owner, fruit.plantId, fruit.fruitId)
    fire("Steal.CompleteSteal")

    local base = getBase()
    if base and hrp and hrp.Parent then
        pcall(function()
            hrp.CFrame = CFrame.new(base)
        end)
        task.wait(0.5)
    end
end

-- UI
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("StealHub")
if oldGui then oldGui:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "StealHub"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(240, 130)
frame.Position = UDim2.new(0.5, -120, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Active = true
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "AUTO STEAL"
title.TextColor3 = Color3.fromRGB(255, 85, 85)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.ZIndex = 11
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 50)
btn.Position = UDim2.new(0.1, 0, 0, 50)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
btn.Text = "OFF"
btn.TextColor3 = Color3.fromRGB(255, 100, 100)
btn.TextSize = 18
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.ZIndex = 11
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- Drag
local dragging, dragStart, startPos = false, nil, nil
frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle
local running = false

btn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.spawn(function()
            while running do
                local fruits = getStealable()
                if #fruits > 0 then
                    for _, fruit in ipairs(fruits) do
                        if not running then break end
                        pcall(stealOne, fruit)
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

print("Steal Hub loaded.")
