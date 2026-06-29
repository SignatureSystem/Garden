local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // SETTINGS \\ --
local StealEnabled = false

-- // UI CREATION \\ --
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "StealInterface"

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 120, 0, 45)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "STEAL: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- Toggle Logic
ToggleButton.MouseButton1Click:Connect(function()
    StealEnabled = not StealEnabled
    if StealEnabled then
        ToggleButton.Text = "STEAL: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        ToggleButton.Text = "STEAL: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

-- // NETWORKING \\ --
local Net
local sm = ReplicatedStorage:WaitForChild("SharedModules", 15)
local mod = sm and sm:FindFirstChild("Networking")
if mod then 
    local ok, m = pcall(require, mod)
    if ok then Net = m end 
end

local function fire(path, ...)
    local cur = Net
    for part in string.gmatch(path, "[^.]+") do
        if type(cur) ~= "table" then return end
        cur = cur[part]
    end
    if cur and cur.Fire then
        return pcall(function() cur:Fire(...) end)
    end
end

-- // CORE LOGIC \\ --
local function getPlantModel(prompt)
    local node = prompt.Parent
    while node and node ~= workspace and node:GetAttribute("PlantId") == nil do 
        node = node.Parent 
    end
    return node
end

local function runStealCycle()
    if not StealEnabled then return end

    for _, pr in ipairs(CollectionService:GetTagged("StealPrompt")) do
        if not StealEnabled then break end
        
        if pr:IsA("ProximityPrompt") and pr.Enabled then
            local m = getPlantModel(pr)
            if m and m:GetAttribute("PlantId") then
                local owner = tonumber(m:GetAttribute("UserId"))
                
                if owner and owner ~= LocalPlayer.UserId then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- Identify position
                        local pos = pr.Parent:IsA("BasePart") and pr.Parent.Position or m:GetPivot().Position
                        
                        -- Teleport and Fire Steal
                        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                        task.wait(0.1) -- Small delay for server proximity sync
                        
                        fire("Steal.BeginSteal", owner, tostring(m:GetAttribute("PlantId")), tostring(m:GetAttribute("FruitId") or ""))
                        fire("Steal.CompleteSteal")
                        
                        task.wait(0.1) -- Delay between individual fruits
                    end
                end
            end
        end
    end
end

-- // MAIN LOOP \\ --
task.spawn(function()
    while true do
        if StealEnabled then
            pcall(runStealCycle)
        end
        task.wait(1) -- Spamming frequency
    end
end)
