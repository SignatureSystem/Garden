-- =============================================
-- Simplified WalkyHub - AUTO STEAL ONLY
-- One toggle UI + spam every second (day & night)
-- =============================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ================== STEAL LOGIC ==================

local function hrpNow()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function myBasePos()
    local plot = nil
    local id = LocalPlayer:GetAttribute("PlotId")
    if id then
        local gardens = Workspace:FindFirstChild("Gardens")
        plot = gardens and gardens:FindFirstChild("Plot" .. tostring(id))
    end
    if plot then
        for _, tag in ipairs({"GardenTotalArea", "GardenZone"}) do
            for _, p in ipairs(CollectionService:GetTagged(tag)) do
                if p:IsDescendantOf(plot) then
                    return p.Position - Vector3.new(0, p.Size.Y/2 - 5, 0)
                end
            end
        end
    end
    return nil
end

local function promptCarrier(prompt)
    local node = prompt.Parent
    while node and node ~= Workspace and not node:GetAttribute("PlantId") do
        node = node.Parent
    end
    return node and node:GetAttribute("PlantId") and node or prompt:FindFirstAncestorWhichIsA("Model")
end

local function stealable()
    local out = {}
    for _, pr in ipairs(CollectionService:GetTagged("StealPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled then
            local m = promptCarrier(pr)
            if m and m:GetAttribute("PlantId") then
                local pos = nil
                local pp = pr.Parent
                if pp and pp:IsA("BasePart") then
                    pos = pp.Position
                else
                    pcall(function() pos = m:GetPivot().Position end)
                end
                table.insert(out, {
                    owner = tonumber(m:GetAttribute("UserId")) or 0,
                    plantId = tostring(m:GetAttribute("PlantId")),
                    fruitId = tostring(m:GetAttribute("FruitId") or ""),
                    pos = pos,
                })
            end
        end
    end
    return out
end

local function doSteal()
    for _, f in ipairs(stealable()) do
        -- Teleport to fruit
        local hrp = hrpNow()
        if hrp and f.pos then
            pcall(function()
                hrp.CFrame = CFrame.new(f.pos + Vector3.new(0, 4, 0))
            end)
            task.wait(0.35)
        end

        -- Steal
        pcall(function() 
            ReplicatedStorage:WaitForChild("Networking", 5):FindFirstChild("Steal", 5):FindFirstChild("BeginSteal"):Fire(f.owner, f.plantId, f.fruitId)
            ReplicatedStorage:WaitForChild("Networking", 5):FindFirstChild("Steal", 5):FindFirstChild("CompleteSteal"):Fire()
        end)

        -- Return to base to bank
        hrp = hrpNow()
        local base = myBasePos()
        if hrp and base then
            pcall(function()
                hrp.CFrame = CFrame.new(base + Vector3.new(0, 4, 0))
            end)
        end

        task.wait(0.8) -- spam control
    end
end

-- ================== MINIMAL UI ==================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleStealHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 120)
Frame.Position = UDim2.new(0.5, -110, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Auto Steal"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.85, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.075, 0, 0.45, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 80, 80)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Parent = Frame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = ToggleButton

-- Draggable
local dragging, dragInput, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle Logic
local autoStealEnabled = false
local stealConnection = nil

ToggleButton.MouseButton1Click:Connect(function()
    autoStealEnabled = not autoStealEnabled
    
    if autoStealEnabled then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        ToggleButton.TextColor3 = Color3.new(1,1,1)
        
        stealConnection = RunService.Heartbeat:Connect(function()
            if autoStealEnabled then
                pcall(doSteal)
            end
        end)
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        ToggleButton.TextColor3 = Color3.fromRGB(255, 80, 80)
        
        if stealConnection then
            stealConnection:Disconnect()
            stealConnection = nil
        end
    end
end)

print("✅ Simplified Auto-Steal loaded | Toggle with the button")
