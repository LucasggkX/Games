local Players = game:GetService("Players")
_G.FpsDev = true

local function removeAllAccessories()
    for _, plr in ipairs(Players:GetPlayers()) do
        local character = plr.Character
        if character then
            for _, item in ipairs(character:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("LayeredClothing") or item:IsA("Shirt") or item:IsA("ShirtGraphic") or item:IsA("Pants") or item:IsA("BodyColors") or item:IsA("CharacterMesh") then
                    pcall(function() item:Destroy() end)
                end
            end
        end
    end
end

local function equip(plr)
    local character = plr.Character
    local backpack = plr:FindFirstChild("Backpack")
    if character and backpack then
        local tool = backpack:FindFirstChild("Bat")
        if tool then tool.Parent = character end
    end
end

local function unequip(plr)
    local character = plr.Character
    if character then
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid:UnequipTools()
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.2)
        removeAllAccessories()
    end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function()
        task.wait(0.2)
        removeAllAccessories()
    end)
end

task.spawn(function()
    while true do
        if _G.FpsDev then
            for _, plr in ipairs(Players:GetPlayers()) do
                equip(plr)
            end
            task.wait(0.05)
            for _, plr in ipairs(Players:GetPlayers()) do
                unequip(plr)
            end
            task.wait(0.05)
        else
            task.wait(0.1)
        end
    end
end)
