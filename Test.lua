local player = game:GetService("Players").LocalPlayer
_G.FpsDev = true

task.spawn(function()
    while _G.FpsDev do
        local character = player.Character
        local backpack = player:FindFirstChild("Backpack")
        local tools = {}
        if character and backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(tools, tool)
                end
            end
            local randomTool = tools[math.random(1, #tools)]
            randomTool.Parent = character
            task.wait(0.035)
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
        task.wait(0.015)
    end
end)
