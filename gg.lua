-- =============================================
-- SIMPLIFIED AUTO STEAL ONLY (Fixed)
-- Spams the real Steal.BeginSteal + CompleteSteal
-- =============================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer

-- ================== NETWORKING (Core from original) ==================
local Net
do
    local sm = ReplicatedStorage:WaitForChild("SharedModules", 8)
    local mod = sm and sm:FindFirstChild("Networking")
    if mod then
        local ok, m = pcall(require, mod)
        if ok then Net = m end
    end
end

if not Net then
    warn("[StealHub] Networking module not found!")
    return
end

local function action(path)
    local cur = Net
    for part in string.gmatch(path, "[^.]+") do
        if type(cur) ~= "table" then return nil end
        cur = cur[part]
    end
    return cur
end

local function fire(path, ...)
    local a = action(path)
    if not (a and a.Fire) then 
        warn("[Steal] No action:", path)
        return false 
    end
    local args = table.pack(...)
    local ok = pcall(function()
        a:Fire(table.unpack(args, 1, args.n))
    end)
    return ok
end

-- ================== STEAL CORE ==================
local function hrpNow()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function myBasePos()
    local id = LocalPlayer:GetAttribute("PlotId")
    if not id then return nil end
    local gardens = Workspace:FindFirstChild("Gardens")
    local plot = gardens and gardens:FindFirstChild("Plot" .. tostring(id))
    if not plot then return nil end

    for _, tag in ipairs({"GardenTotalArea", "GardenZone"}) do
        for _, p in ipairs(CollectionService:GetTagged(tag)) do
            if p:IsA("BasePart") and p:IsDescendantOf(plot) then
                return p.Position - Vector3.new(0, p.Size.Y/2 - 5, 0)
            end
        end
    end
    return nil
end

local function promptCarrier(prompt)
    local node = prompt.Parent
    while node and node ~= Workspace do
        if node:GetAttribute("PlantId") then return node end
        node = node.Parent
    end
    return prompt:FindFirstAncestorWhichIsA("Model")
end

local function getStealable()
    local out = {}
    for _, pr in ipairs(CollectionService:GetTagged("StealPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled then
            local carrier = promptCarrier(pr)
            if carrier and carrier:GetAttribute("PlantId") then
                local pos = nil
                pcall(function() pos = carrier:GetPivot().Position end)
                table.insert(out, {
                    owner = tonumber(carrier:GetAttribute("UserId")) or 0,
                    plantId = tostring(carrier:GetAttribute("PlantId")),
                    fruitId = tostring(carrier:GetAttribute("FruitId") or ""),
                    pos = pos
                })
            end
        end
    end
    return out
end

local function performSteal()
    for _, fruit in ipairs(getStealable()) do
        -- Teleport close to fruit (server checks proximity)
        local hrp = hrpNow()
        if hrp and fruit.pos then
            pcall(function()
                hrp.CFrame = CFrame.new(fruit.pos + Vector3.new(0, 5, 0))
            end)
            task.wait(0.4)
        end

        -- ACTUAL STEAL (this is what triggers the in-game steal button logic)
        fire("Steal.BeginSteal", fruit.owner, fruit.plantId, fruit.fruitId)
        fire("Steal.CompleteSteal")

        -- Return to base to bank the stolen fruit
        hrp = hrpNow()
        local base = myBasePos()
        if hrp and base then
            pcall(function()
                hrp.CFrame = CFrame.new(base + Vector3.new(0, 5, 0))
            end)
        end

        task.wait(0.75) -- Adjust if needed
    end
end

-- ================== MINIMAL UI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealOnlyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 140)
Main.Position = UDim2.new(0.5, -120, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "AUTO STEAL"
Title.TextColor3 = Color3.fromRGB(255, 90, 90)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0.8, 0, 0, 55)
Toggle.Position = UDim2.new(0.1, 0, 0.45, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Toggle.Text = "OFF"
Toggle.TextColor3 = Color3.fromRGB(255, 100, 100)
Toggle.TextSize = 18
Toggle.Font = Enum.Font.GothamSemibold
Toggle.Parent = Main

Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 12)

-- Draggable
local dragging = false
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local startPos = Main.Position
        local startMouse = inp.Position

        local conn
        conn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local delta = input.Position - startMouse
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        UserInputService.InputEnded:Connect(function() 
            dragging = false
            conn:Disconnect()
        end)
    end
end)

-- Toggle Logic
local enabled = false
local loopConn = nil

Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        Toggle.Text = "ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(70, 180, 90)
        Toggle.TextColor3 = Color3.new(1,1,1)

        loopConn = RunService.Heartbeat:Connect(function()
            if enabled then
                pcall(performSteal)
            end
        end)
    else
        Toggle.Text = "OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Toggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        if loopConn then loopConn:Disconnect() end
    end
end)

print("✅ Auto Steal Hub Loaded - Click ON to spam steal every second")
