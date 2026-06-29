local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Network
local Net
do
    local sm = ReplicatedStorage:WaitForChild("SharedModules", 15)
    local mod = sm and sm:FindFirstChild("Networking")
    if mod then local ok, m = pcall(require, mod); if ok then Net = m end end
end
if not Net then warn("Networking not found"); return end

local function fireFast(path, ...)
    local cur = Net
    for part in string.gmatch(path, "[^.]+") do
        if type(cur) ~= "table" then return false end
        cur = cur[part]
    end
    if not (cur and cur.Fire) then return false end
    pcall(function() cur:Fire(...) end)
end

-- State
local autoHarvest = false
local killed = false

-- Harvest logic
local function promptCarrier(prompt)
    local node = prompt.Parent
    while node and node ~= workspace and node:GetAttribute("PlantId") == nil do
        node = node.Parent
    end
    if node and node:GetAttribute("PlantId") ~= nil then return node end
    return prompt:FindFirstAncestorWhichIsA("Model")
end

local function stepHarvest()
    for _, pr in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled and pr:IsDescendantOf(workspace) then
            local m = promptCarrier(pr)
            local pid = m and m:GetAttribute("PlantId")
            if pid then
                local uid = tonumber(m:GetAttribute("UserId"))
                if uid == nil or uid == LocalPlayer.UserId then
                    pcall(function()
                        fireFast("Garden.CollectFruit",
                            tostring(pid),
                            tostring(m:GetAttribute("FruitId") or ""))
                    end)
                end
            end
        end
    end
end

-- Harvest loop
task.spawn(function()
    while not killed do
        if autoHarvest then
            pcall(stepHarvest)
            task.wait(0.05)
        else
            task.wait(0.3)
        end
    end
end)

-- Simple UI
local oldGui = PlayerGui:FindFirstChild("HarvestUI")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "HarvestUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(200, 70)
frame.Position = UDim2.new(0.5, -100, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(18, 21, 29)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 28)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Harvest"
titleLabel.TextColor3 = Color3.fromRGB(200, 210, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 0, 30)
btn.Position = UDim2.fromOffset(10, 32)
btn.BackgroundColor3 = Color3.fromRGB(60, 65, 90)
btn.TextColor3 = Color3.fromRGB(220, 220, 255)
btn.Font = Enum.Font.GothamSemibold
btn.TextSize = 13
btn.Text = "OFF"
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
    autoHarvest = not autoHarvest
    if autoHarvest then
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(95, 105, 255)
    else
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(60, 65, 90)
    end
end)

print("[AutoHarvest] Loaded. Click the button to toggle.")
