local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function removeAllAccessories()
    local character = player.Character
    if not character then return end
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("LayeredClothing") or item:IsA("Shirt") or item:IsA("ShirtGraphic") or item:IsA("Pants") or item:IsA("BodyColors") or item:IsA("CharacterMesh") then
            pcall(function() item:Destroy() end)
        end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.2)
    removeAllAccessories()
end)

if player.Character then
    task.defer(removeAllAccessories)
end

local TOOL_NAME = "Bat"
local running = false

local function equip()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if not character or not backpack then return end
    local tool = backpack:FindFirstChild(TOOL_NAME)
    if tool then tool.Parent = character end
end

local function unequip()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoid:UnequipTools()
    end
end

_G.FpsDev = true

task.spawn(function()
    while true do
        if _G.FpsDev then
            equip()
            task.wait(0.05)
            unequip()
            task.wait(0.05)
        else
            task.wait(0.1)
        end
    end
end)

player.CharacterAdded:Connect(function()
    _G.FpsDev = false
    task.wait(0.2)
    removeAllAccessories()
end)
