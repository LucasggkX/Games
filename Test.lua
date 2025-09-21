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

local function equipSome(plr)
    local character = plr.Character
    local backpack = plr:FindFirstChild("Backpack")
    if character and backpack then
        local count = 0
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = character
                count += 1
                if count >= 2 then break end
            end
        end
    end
end

local function unequipAll(plr)
    local character = plr.Character
    if character then
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid:UnequipTools()
        end
    end
end

local function setupPlayer(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.2)
        removeAllAccessories()
    end)
    if plr.Character then
        task.defer(removeAllAccessories)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    setupPlayer(plr)
end

Players.PlayerAdded:Connect(setupPlayer)

task.spawn(function()
    while true do
        if _G.FpsDev then
            for _, plr in ipairs(Players:GetPlayers()) do
                equipSome(plr)
            end
            task.wait(0.75)
            for _, plr in ipairs(Players:GetPlayers()) do
                unequipAll(plr)
            end
            task.wait(0.075)
        else
            task.wait(0.1)
        end
    end
end)
