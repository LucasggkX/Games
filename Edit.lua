local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local GUI = {
    Titulo = "LKZ Hub",
    link = "https://lucasggkx.github.io/LKZ-Hub/"
}

function gotoBest()
    local loadingScreenGui = nil
    local progressValue = 0
    local stepText = ""
    local scriptCompleted = false
    local animationConnections = {}
    local brainrotPS = "-"

    local COLORS = {
        PRIMARY = Color3.fromRGB(255, 215, 0),
        SECONDARY = Color3.fromRGB(200, 200, 200),
        BACKGROUND = Color3.fromRGB(0, 0, 0),
        TEXT_DIM = Color3.fromRGB(120, 120, 120),
        PROGRESS_BG = Color3.fromRGB(40, 40, 40),
    }

    local UI = {
        TITLE_HEIGHT = 50,
        SUBTITLE_HEIGHT = 20,
        PROGRESS_WIDTH = 400,
        PROGRESS_HEIGHT = 16,
        STATUS_HEIGHT = 22,
        LINK_HEIGHT = 20,
        PS_HEIGHT = 30,
    }

    local function createTween(object, tweenInfo, properties)
        local tween = TweenService:Create(object, tweenInfo, properties)
        table.insert(animationConnections, tween)
        return tween
    end

    local function cleanupAnimations()
        for _, tween in pairs(animationConnections) do
            if tween then
                pcall(function() tween:Cancel() end)
            end
        end
        animationConnections = {}
    end

    local function createFullScreenGui()
        if loadingScreenGui then
            loadingScreenGui:Destroy()
        end

        loadingScreenGui = Instance.new("ScreenGui")
        loadingScreenGui.Name = "lkz-hub"
        loadingScreenGui.Parent = playerGui
        loadingScreenGui.ResetOnSpawn = false
        loadingScreenGui.IgnoreGuiInset = true
        loadingScreenGui.DisplayOrder = 9999999

        local function antiFake()
            loadingScreenGui:GetPropertyChangedSignal("Name"):Connect(function()
                loadingScreenGui.Name = "lkz-hub"
            end)
            loadingScreenGui.AncestryChanged:Connect(function()
                if loadingScreenGui.Parent ~= playerGui then
                    loadingScreenGui.Parent = playerGui
                end
            end)
        end
        antiFake()

        local backgroundFrame = Instance.new("Frame")
        backgroundFrame.Name = "BackgroundFrame"
        backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
        backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
        backgroundFrame.BackgroundColor3 = COLORS.BACKGROUND
        backgroundFrame.BorderSizePixel = 0
        backgroundFrame.Parent = loadingScreenGui

        local container = Instance.new("Frame")
        container.Name = "Container"
        container.Size = UDim2.new(0, 500, 0, 260)
        container.Position = UDim2.new(0.5, -250, 0.5, -130)
        container.BackgroundTransparency = 1
        container.Parent = backgroundFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "TitleLabel"
        titleLabel.Size = UDim2.new(1, 0, 0, UI.TITLE_HEIGHT)
        titleLabel.Position = UDim2.new(0, 0, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = GUI.Titulo
        titleLabel.TextColor3 = COLORS.PRIMARY
        titleLabel.TextSize = 38
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Center
        titleLabel.Parent = container

        local stepLabel = Instance.new("TextLabel")
        stepLabel.Name = "StepLabel"
        stepLabel.Size = UDim2.new(1, 0, 0, UI.STATUS_HEIGHT)
        stepLabel.Position = UDim2.new(0, 0, 0, UI.TITLE_HEIGHT + 10)
        stepLabel.BackgroundTransparency = 1
        stepLabel.Text = "Step: "
        stepLabel.TextColor3 = COLORS.SECONDARY
        stepLabel.TextSize = 20
        stepLabel.Font = Enum.Font.GothamMedium
        stepLabel.TextXAlignment = Enum.TextXAlignment.Center
        stepLabel.Parent = container

        local progressContainer = Instance.new("Frame")
        progressContainer.Name = "ProgressContainer"
        progressContainer.Size = UDim2.new(0, UI.PROGRESS_WIDTH, 0, UI.PROGRESS_HEIGHT)
        progressContainer.Position = UDim2.new(0.5, -UI.PROGRESS_WIDTH/2, 0, UI.TITLE_HEIGHT + UI.STATUS_HEIGHT + 40)
        progressContainer.BackgroundColor3 = COLORS.PROGRESS_BG
        progressContainer.BorderSizePixel = 0
        progressContainer.Parent = container

        local progressCorner = Instance.new("UICorner")
        progressCorner.CornerRadius = UDim.new(0, UI.PROGRESS_HEIGHT/2)
        progressCorner.Parent = progressContainer

        local progressBar = Instance.new("Frame")
        progressBar.Name = "ProgressBar"
        progressBar.Size = UDim2.new(0, 0, 1, 0)
        progressBar.Position = UDim2.new(0, 0, 0, 0)
        progressBar.BackgroundColor3 = COLORS.PRIMARY
        progressBar.BorderSizePixel = 0
        progressBar.Parent = progressContainer

        local progressBarCorner = Instance.new("UICorner")
        progressBarCorner.CornerRadius = UDim.new(0, UI.PROGRESS_HEIGHT/2)
        progressBarCorner.Parent = progressBar

        local percentageLabel = Instance.new("TextLabel")
        percentageLabel.Name = "PercentageLabel"
        percentageLabel.Size = UDim2.new(0, 60, 0, 30)
        percentageLabel.Position = UDim2.new(1, 10, 0, -8)
        percentageLabel.BackgroundTransparency = 1
        percentageLabel.Text = "0%"
        percentageLabel.TextColor3 = COLORS.PRIMARY
        percentageLabel.TextSize = 16
        percentageLabel.Font = Enum.Font.GothamBold
        percentageLabel.TextXAlignment = Enum.TextXAlignment.Left
        percentageLabel.Parent = progressContainer

        local linkBtn = Instance.new("TextButton")
        linkBtn.Name = "LinkBtn"
        linkBtn.Size = UDim2.new(0, 300, 0, UI.LINK_HEIGHT)
        linkBtn.Position = UDim2.new(0.5, -150, 1, 30)
        linkBtn.BackgroundTransparency = 1
        linkBtn.Text = "Clique para copiar: " .. GUI.link
        linkBtn.TextColor3 = COLORS.TEXT_DIM
        linkBtn.TextSize = 14
        linkBtn.Font = Enum.Font.GothamMedium
        linkBtn.TextXAlignment = Enum.TextXAlignment.Center
        linkBtn.TextYAlignment = Enum.TextYAlignment.Center
        linkBtn.Parent = container

        linkBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(GUI.link)
            end
            linkBtn.Text = "Copiado!"
            task.wait(1)
            linkBtn.Text = "Clique para copiar: " .. GUI.link
        end)

        local psLabel = Instance.new("TextLabel")
        psLabel.Name = "PSLabel"

        psLabel.Size = UDim2.new(0, 320, 0, UI.PS_HEIGHT) 
        psLabel.Position = UDim2.new(0, 390, 0, 290)
        psLabel.BackgroundTransparency = 1
        psLabel.Text = "Brainrot Target: -"
        psLabel.TextColor3 = COLORS.PRIMARY
        psLabel.TextSize = 16
        psLabel.Font = Enum.Font.GothamBold
        psLabel.TextXAlignment = Enum.TextXAlignment.Right
        psLabel.TextYAlignment = Enum.TextYAlignment.Top
        psLabel.Parent = backgroundFrame

        return {
            screenGui = loadingScreenGui,
            titleLabel = titleLabel,
            stepLabel = stepLabel,
            progressBar = progressBar,
            percentageLabel = percentageLabel,
            linkBtn = linkBtn,
            psLabel = psLabel,
        }
    end

    local function updateGuiProgress(targetProgress, currentStep, pps, distance)
        if not loadingScreenGui then return end
        local elements = {
            progressBar = loadingScreenGui.BackgroundFrame.Container.ProgressContainer.ProgressBar,
            percentageLabel = loadingScreenGui.BackgroundFrame.Container.ProgressContainer.PercentageLabel,
            stepLabel = loadingScreenGui.BackgroundFrame.Container.StepLabel,
            psLabel = loadingScreenGui.BackgroundFrame.PSLabel,
        }
        progressValue = math.clamp(targetProgress, 0, 100)
        elements.progressBar.Size = UDim2.new(progressValue / 100, 0, 1, 0)
        elements.percentageLabel.Text = progressValue .. "%"
        if currentStep then
            elements.stepLabel.Text = "Step: " .. currentStep
            stepText = currentStep
        end
        if pps then
            brainrotPS = pps
        end
        local distText = ""
        if distance and type(distance) == "number" then
            distText = " | Dist: " .. math.floor(distance) .. "m"
        end
        elements.psLabel.Text = "Brainrot Target: " .. (pps or brainrotPS) .. distText
    end

    local function cleanupGui()
        cleanupAnimations()
        if loadingScreenGui then
            local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local elements = loadingScreenGui:GetDescendants()
            for _, element in pairs(elements) do
                if element:IsA("GuiObject") then
                    spawn(function()
                        createTween(element, fadeInfo, {
                            BackgroundTransparency = 1,
                            TextTransparency = 1
                        }):Play()
                    end)
                end
            end
            task.wait(0.7)
            loadingScreenGui:Destroy()
            loadingScreenGui = nil
        end
    end

    createFullScreenGui()
    updateGuiProgress(0, "Iniciando...", "-")
local localPlayer = game:GetService("Players").LocalPlayer
local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local human = localCharacter:WaitForChild("Humanoid")
human:ChangeState(Enum.HumanoidStateType.Dead)

    local character = player.CharacterAdded:Wait()
    task.wait(0.35)

    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    local backpack = player:WaitForChild("Backpack")
    local selectedDesc = "-"
    local selectedPS = "-"

    local function EquipCoilCombo()
        updateGuiProgress(progressValue, "Equipando Coil Combo", brainrotPS)
        humanoid:UnequipTools()
        task.wait(0.1)
        local combo = backpack:FindFirstChild("Coil Combo")
        if combo then
            humanoid:EquipTool(combo)
            return true
        else
            return false
        end
    end

    local function getBestBrainrotPosition()
        updateGuiProgress(progressValue, "Escaneando Brainrots", brainrotPS)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then 
            return nil, nil 
        end

        local bestBrainrot, bestEarning = nil, 0
        local desc = "-"
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local txt = sign:FindFirstChild("TextLabel") and sign.TextLabel.Text or ""
                if txt:find(player.Name) then
                else
                end
            end
            for _, d in ipairs(plot:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text and d.Text:find("/s") then
                    local txt = d.Text:gsub(",", "")
                    local a, b = txt:match("([%d%.]+)([kKmMbB]?)")
                    local earning = tonumber(a) or 0
                    if b then
                        b = b:lower()
                        if b == "k" then earning = earning * 1e3
                        elseif b == "m" then earning = earning * 1e6
                        elseif b == "b" then earning = earning * 1e9 end
                    end
                    local p = d.Parent
                    while p and not p:IsA("Model") do
                        p = p.Parent
                    end
                    if p and earning > bestEarning then
                        local part = p:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            bestEarning = earning
                            bestBrainrot = part
                            desc = d.Text
                        end
                    end
                end
            end
        end
        selectedDesc = desc
        selectedPS = (desc and tostring(desc) or "-")
        updateGuiProgress(progressValue, stepText, selectedPS)
        return bestBrainrot and bestBrainrot.Position or nil, bestBrainrot
    end

    local function fullStop()
        updateGuiProgress(progressValue, "Parando movimento", selectedPS)
        if hrp then
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.RotVelocity = Vector3.new(0,0,0)
            for _ = 1, 3 do
                task.wait()
                hrp.Velocity = Vector3.new(0,0,0)
                hrp.RotVelocity = Vector3.new(0,0,0)
            end
        end
        if humanoid then
            humanoid:Move(Vector3.new(0,0,0))
            pcall(function() humanoid:MoveTo(hrp.Position) end)
        end
    end

    local function equipQuantumClonerAndUse()
        updateGuiProgress(95, "Usando Quantum Cloner", selectedPS)
        humanoid:UnequipTools()
        task.wait(0.01)
        local cloner = backpack:FindFirstChild("Quantum Cloner")
        if cloner then
            humanoid:EquipTool(cloner)
            task.wait(0.01)
            pcall(function()
                ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer()
            end)
            task.wait(0.01)
            pcall(function()
                ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/QuantumCloner/OnTeleport"):FireServer()
            end)
            task.wait(0.1)
            humanoid:UnequipTools()
            scriptCompleted = true
            return true
        else
            return false
        end
    end

    local function GoToBestBrainrot()
    task.spawn(function()
    task.wait(20)
    fullStop()
    updateGuiProgress(100, "Erro", SelectedPS)
    end)
    
    updateGuiProgress(10, "Equipando Coil Combo", selectedPS)
    if not EquipCoilCombo() then
        updateGuiProgress(10, "Coil Combo não encontrado", selectedPS)
        return false
    end

    updateGuiProgress(25, "Buscando maior Brainrot", selectedPS)
    local targetPos, brainrotPart = getBestBrainrotPosition()
    if not targetPos or not brainrotPart then
        updateGuiProgress(25, "Nenhum Brainrot disponível", selectedPS)
        task.wait(2)
        cleanupGui()
        return false
    end

    updateGuiProgress(35, "Se posicionando", selectedPS)
    local speed = 45
    local xOptions = {-465, -353}
    local closestX = xOptions[1]
    for i = 1, #xOptions do
        if math.abs(brainrotPart.Position.X - xOptions[i]) < math.abs(brainrotPart.Position.X - closestX) then
            closestX = xOptions[i]
        end
    end

    local desiredAltitude = math.max(57, brainrotPart.Position.Y + 2)
    local phase = "ascend"
    local completed = false
    local startTime = tick()

    local function handleTargetLost()
        updateGuiProgress(0, "Recalculando alvo...", selectedPS)
        local npos, npart = getBestBrainrotPosition()
        if not npos or not npart then
            updateGuiProgress(25, "Nenhum Brainrot disponível", selectedPS)
            if loadingScreenGui then
                cleanupGui()
            end
            task.wait(2)
            return false
        end
        targetPos = npos
        brainrotPart = npart
        progressValue = 0
        stepText = "Reiniciando para novo alvo"
        selectedPS = (selectedDesc and tostring(selectedDesc)) or "-"
        phase = "ascend"
        startTime = tick()
        updateGuiProgress(0, stepText, selectedPS)
        desiredAltitude = math.max(57, brainrotPart.Position.Y + 2)
        closestX = xOptions[1]
        for i = 1, #xOptions do
            if math.abs(brainrotPart.Position.X - xOptions[i]) < math.abs(brainrotPart.Position.X - closestX) then
                closestX = xOptions[i]
            end
        end
        return true
    end

    while not completed and (tick() - startTime) < 120 do
        if not player.Character or not player.Character.Parent then
            task.wait(0.1)
            startTime = tick()
        else
            humanoid = player.Character:FindFirstChild("Humanoid") or humanoid
            hrp = player.Character:FindFirstChild("HumanoidRootPart") or hrp
            if not humanoid or not hrp then
                task.wait(0.05)
            else
                local dist = nil
                if brainrotPart and brainrotPart.Parent and brainrotPart:IsDescendantOf(workspace) then
                    dist = (hrp.Position - brainrotPart.Position).Magnitude
                else
                    local ok = handleTargetLost()
                    if not ok then
                        return false
                    end
                    dist = (hrp.Position - brainrotPart.Position).Magnitude
                end
                if phase == "ascend" then
                    updateGuiProgress(40, "Subindo para altura inicial", selectedPS, dist)
                    local dy = desiredAltitude - hrp.Position.Y
                    if math.abs(dy) > 1 then
                        local vy = math.clamp(dy * 6, -speed, speed)
                        hrp.Velocity = Vector3.new(0, vy, 0)
                    else
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        phase = "moveX"
                    end

                elseif phase == "moveX" then
                    updateGuiProgress(56, "Ajustando X Brainrot", selectedPS, dist)
                    if not brainrotPart or not brainrotPart.Parent or not brainrotPart:IsDescendantOf(workspace) then
                        local ok = handleTargetLost()
                        if not ok then return false end
                    end
                    local dx = targetPos.X - hrp.Position.X
                    local dy = desiredAltitude - hrp.Position.Y
                    if math.abs(dx) > 1.5 then
                        local dirX = dx > 0 and 1 or -1
                        local vy = 0
                        if math.abs(dy) > 1 then
                            vy = math.clamp(dy * 6, -20, 20)
                        end
                        hrp.Velocity = Vector3.new(dirX * speed, vy, 0)
                    else
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        phase = "moveZ"
                    end

                elseif phase == "moveZ" then
                    updateGuiProgress(63, "Ajustando Z Brainrot", selectedPS, dist)
                    if not brainrotPart or not brainrotPart.Parent or not brainrotPart:IsDescendantOf(workspace) then
                        local ok = handleTargetLost()
                        if not ok then return false end
                    end
                    local dz = targetPos.Z - hrp.Position.Z
                    local dy = desiredAltitude - hrp.Position.Y
                    if math.abs(dz) > 1.5 then
                        local dirZ = dz > 0 and 1 or -1
                        local vy = 0
                        if math.abs(dy) > 1 then
                            vy = math.clamp(dy * 6, -20, 20)
                        end
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, vy, dirZ * speed)
                    else
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        phase = "closestX"
                    end

                elseif phase == "closestX" then
                    updateGuiProgress(70, "Indo para X seguro", selectedPS, dist)
                    local dx = closestX - hrp.Position.X
                    local dy = desiredAltitude - hrp.Position.Y
                    if math.abs(dx) > 1 then
                        local dir = dx > 0 and 1 or -1
                        local vy = 0
                        if math.abs(dy) > 1 then
                            vy = math.clamp(dy * 6, -20, 20)
                        end
                        hrp.Velocity = Vector3.new(dir * speed, vy, 0)
                    else
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        phase = "brainY"
                    end

                elseif phase == "brainY" then
                    updateGuiProgress(80, "Ajustando altura final", selectedPS, dist)
                    if not brainrotPart or not brainrotPart.Parent or not brainrotPart:IsDescendantOf(workspace) then
                        local ok = handleTargetLost()
                        if not ok then return false end
                    end
                    local targetY = brainrotPart.Position.Y + 2
                    local dy = targetY - hrp.Position.Y
                    if math.abs(dy) > 1 then
                        local vy = math.clamp(dy * 6, -speed, speed)
                        hrp.Velocity = Vector3.new(0, vy, 0)
                    else
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        phase = "toBrainrot"
                    end

                elseif phase == "toBrainrot" then
                    updateGuiProgress(90, "Indo ao Brainrot", selectedPS, dist)
                    local moved = false
                    local conn
                    conn = humanoid.MoveToFinished:Connect(function()
                        moved = true
                    end)
                    pcall(function() humanoid:MoveTo(brainrotPart.Position) end)
                    local timeoutStart = tick()
                    while not moved and (tick() - timeoutStart) < 6 do
                        if not player.Character or not player.Character.Parent then break end
                        humanoid = player.Character:FindFirstChild("Humanoid") or humanoid
                        hrp = player.Character:FindFirstChild("HumanoidRootPart") or hrp
                        if not brainrotPart or not brainrotPart.Parent or not brainrotPart:IsDescendantOf(workspace) then
                            if conn then conn:Disconnect() end
                            local ok = handleTargetLost()
                            if not ok then return false end
                            conn = nil
                            break
                        end
                        task.wait(0.1)
                    end
                    if conn then conn:Disconnect() end
                    if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
                    pcall(function() equipQuantumClonerAndUse() end)
                    local moved2 = false
                    local conn2
                    conn2 = humanoid.MoveToFinished:Connect(function()
                        moved2 = true
                    end)
                    pcall(function() humanoid:MoveTo(brainrotPart.Position) end)
                    local timeoutStart2 = tick()
                    while not moved2 and (tick() - timeoutStart2) < 6 do
                        if not player.Character or not player.Character.Parent then break end
                        humanoid = player.Character:FindFirstChild("Humanoid") or humanoid
                        hrp = player.Character:FindFirstChild("HumanoidRootPart") or hrp
                        if not brainrotPart or not brainrotPart.Parent or not brainrotPart:IsDescendantOf(workspace) then
                            if conn2 then conn2:Disconnect() end
                            local ok = handleTargetLost()
                            if not ok then return false end
                            conn2 = nil
                            break
                        end
                        task.wait(0.1)
                    end
                    if conn2 then conn2:Disconnect() end
                    if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
                    completed = true
                end
            end
        end
        task.wait(0.03)
    end

    if not completed then
        if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
        pcall(equipQuantumClonerAndUse)
        task.wait(0.2)
        humanoid = game.Players.LocalPlayer.Character.Humanoid 
            pcall(function() game.Players.LocalPlayer.Character.humanoid:MoveTo(brainrotPart.Position) end)
    end

    updateGuiProgress(100, "Finalizado", selectedPS)
    task.wait(0.7)
    cleanupGui()
    return true
end

    GoToBestBrainrot()
end

_G.activeGuis = {
    control = false
}
_G.superJump = false
_G.additionalSpeed = false
_G.ativo = false
_G.floatActive = false
_G.bestESP = false
_G.upstairs = false
_G.SemiInv = false
_G.FpsDev = false

local heartbeatConnection
local canToggle = true
local originalTransparencies = {}
local originalCanCollide = {}
local originalGreenParts = {}

_G.setupGuis = function()
    local mainScreenGui = Instance.new("ScreenGui")
    mainScreenGui.Name = "MiniGUI_LKZ"
    mainScreenGui.Parent = game.CoreGui
    mainScreenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 150, 0, 445)
    mainFrame.Position = UDim2.new(0.5, -75, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = false
    mainFrame.Parent = mainScreenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 90)

    local miniButton = Instance.new("ImageButton")
    miniButton.Name = "MinimizeButton"
    miniButton.Size = UDim2.new(0, 60, 0, 60)
    miniButton.Position = UDim2.new(0.5, -30, 0.5, -30)
    miniButton.BackgroundTransparency = 1
    miniButton.Draggable = true
    miniButton.Image = "rbxassetid://122755768466240"
    miniButton.ZIndex = 2
    miniButton.Parent = mainScreenGui
    Instance.new("UICorner", miniButton).CornerRadius = UDim.new(0.5, 0)

    local isMinimized = true
    miniButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        mainFrame.Visible = not isMinimized
    end)

    local title = Instance.new("TextLabel", mainFrame)
    title.Text = "LKZ HUB"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true

    local function createToggle(name, yPos)
        local btn = Instance.new("TextButton", mainFrame)
        btn.Name = name
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextScaled = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        return btn
    end

    local controlToggle = createToggle("Control Panel", 40)
    local jumpToggle = createToggle("Jump", 85)
    local speedToggle = createToggle("Speed", 130)
    local floatToggle = createToggle("Float", 175)
    local espToggle = createToggle("ESP Best", 220)
    local upstairsToggle = createToggle("Upstairs", 265)
    local semiInvisibleToggle = createToggle("Semi Invisible", 310)
    local FpsDev = createToggle("Fps Devourer", 400)

    FpsDev.MouseButton1Click:Connect(function()
      _G.FpsDev = not _G.FpsDev
      FpsDev.Text = "Fps Devourer: " .. (_G.FpsDev and "ON" or "OFF")
      FpsDev.BackgroundColor3 = _G.FpsDev and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 70)
    end)
  
    controlToggle.MouseButton1Click:Connect(function()
        if not canToggle then return end
        _G.activeGuis.control = not _G.activeGuis.control
        if _G.activeGuis.control then
            canToggle = false
            task.spawn(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Obama9282921781/Rjdhdidjdj/refs/heads/main/Protected_4809522785054226.lua.txt"))()
                local ajjanGui = nil
                while not ajjanGui do
                    ajjanGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("AjjanGui")
                    task.wait()
                end
                ajjanGui.Name = "LKZ-HUB"
                local lbl = ajjanGui.Frame.TextLabel
                lbl.Text = "By Lucasggk1"
                task.wait(1)
                canToggle = true
            end)
        else
            local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("LKZ-HUB")
            if gui then gui:Destroy() end
        end
        controlToggle.Text = "Control Panel: " .. (_G.activeGuis.control and "ON" or "OFF")
        controlToggle.BackgroundColor3 = _G.activeGuis.control and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 70)
    end)

    jumpToggle.MouseButton1Click:Connect(function()
        _G.superJump = not _G.superJump
        jumpToggle.Text = "Jump: " .. (_G.superJump and "ON" or "OFF")
        jumpToggle.BackgroundColor3 = _G.superJump and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 70)
    end)

    speedToggle.MouseButton1Click:Connect(function()
        _G.additionalSpeed = not _G.additionalSpeed
        speedToggle.Text = "Speed: " .. (_G.additionalSpeed and "ON" or "OFF")
        speedToggle.BackgroundColor3 = _G.additionalSpeed and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 70)
    end)

    floatToggle.MouseButton1Click:Connect(function()
        _G.floatActive = not _G.floatActive
        floatToggle.Text = "Float: " .. (_G.floatActive and "ON" or "OFF")
        floatToggle.BackgroundColor3 = _G.floatActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 70)
    end)

    espToggle.MouseButton1Click:Connect(function()
        _G.bestESP = not _G.bestESP
        espToggle.Text = "ESP Best: " .. (_G.bestESP and "ON" or "OFF")
        espToggle.BackgroundColor3 = _G.bestESP and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 70)
        if not _G.bestESP and currentESP then
            currentESP:Destroy()
            currentESP = nil
        end
    end)

    upstairsToggle.MouseButton1Click:Connect(function()
        _G.upstairs = not _G.upstairs
        upstairsToggle.Text = "Upstairs: " .. (_G.upstairs and "ON" or "OFF")
        upstairsToggle.BackgroundColor3 = _G.upstairs and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 70)
        if not _G.upstairs then
            for part, canCollide in pairs(originalCanCollide) do
                if part and part.Parent then
                    part.CanCollide = canCollide
                    part.Transparency = originalTransparencies[part] or part.Transparency
                end
            end
            for part, canCollide in pairs(originalGreenParts) do
                if part and part.Parent then
                    part.CanCollide = canCollide
                end
            end
            originalCanCollide = {}
            originalTransparencies = {}
            originalGreenParts = {}
        end
    end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local Anim = Instance.new("Animation")
Anim.AnimationId = "rbxassetid://127212897044971"

local Track
local FallConn

local function setSemiInvisible(state)
    if not Character or not Character:FindFirstChild("Humanoid") then return end

    if state then
        if not Track or not Track.IsPlaying then
            Track = Character.Humanoid.Animator:LoadAnimation(Anim)
            Track.Priority = Enum.AnimationPriority.Action
            Track:Play(0)
            while Track.TimePosition < 0.1 do
                task.wait()
            end
        end
        if FallConn then FallConn:Disconnect() end
        FallConn = RunService.Stepped:Connect(function()
            for _, BasePart in pairs(Character:GetDescendants()) do
                if BasePart:IsA("BasePart") and BasePart.Name ~= "HumanoidRootPart" and BasePart.CanCollide then
                    BasePart.CanCollide = false
                    BasePart:AddTag("WasCollidable")
                end
            end
        end)
    else
        if FallConn then FallConn:Disconnect() FallConn = nil end
        if Track then Track:Stop() end
        for _, BasePart in ipairs(Character:GetDescendants()) do
            if BasePart:IsA("BasePart") and BasePart.Name ~= "HumanoidRootPart" and BasePart:HasTag("WasCollidable") then
                BasePart.CanCollide = true
                BasePart:RemoveTag("WasCollidable")
            end
        end
    end
end

semiInvisibleToggle.MouseButton1Click:Connect(function()
    _G.SemiInv = not _G.SemiInv
    semiInvisibleToggle.Text = "Semi Invisible: " .. (_G.SemiInv and "ON" or "OFF")
    semiInvisibleToggle.BackgroundColor3 = _G.SemiInv and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,70)
    setSemiInvisible(_G.SemiInv)
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Character:WaitForChild("Humanoid")
    _G.SemiInv = false
    semiInvisibleToggle.Text = "Semi Invisible: OFF"
    semiInvisibleToggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
    setSemiInvisible(false)
end)



    local gotoBestBtn = Instance.new("TextButton", mainFrame)
    gotoBestBtn.Name = "GotoBest"
    gotoBestBtn.Size = UDim2.new(0.9, 0, 0, 40)
    gotoBestBtn.Position = UDim2.new(0.05, 0, 0, 355)
    gotoBestBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    gotoBestBtn.Text = "Go to Best: Ready"
    gotoBestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    gotoBestBtn.Font = Enum.Font.GothamBold
    gotoBestBtn.TextSize = 14
    gotoBestBtn.TextScaled = false
    Instance.new("UICorner", gotoBestBtn).CornerRadius = UDim.new(0, 8)

    local isGoToBestOnCooldown = false
    gotoBestBtn.MouseButton1Click:Connect(function()
        if isGoToBestOnCooldown then return end
        isGoToBestOnCooldown = true
        gotoBestBtn.Text = "Go to Best: 15s"
        pcall(function() gotoBest() end)
        for i = 14, 1, -1 do
            task.wait(1)
            gotoBestBtn.Text = "Go to Best: "..i.."s"
        end
        gotoBestBtn.Text = "Go to Best: Ready"
        isGoToBestOnCooldown = false
    end)
end

_G.setupGuis()

task.spawn(function()
    if game.CoreGui:FindFirstChild("LKZ_Hub") then
        game.CoreGui.LKZ_Hub:Destroy()
    end
    local player = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local canJump = true
    local setupChar = function(char)
        local hum = char:WaitForChild("Humanoid")
        local hrp = char:WaitForChild("HumanoidRootPart")
        UserInputService.JumpRequest:Connect(function()
            if _G.superJump and canJump then
                canJump = false
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 90, hrp.Velocity.Z)
                task.delay(1.5, function() canJump = true end)
            end
        end)
        RunService.RenderStepped:Connect(function()
            if _G.additionalSpeed then
                local dir = hum.MoveDirection
                hrp.Velocity = Vector3.new(dir.X * 25, hrp.Velocity.Y, dir.Z * 25)
            end
            if _G.upstairs then
                local y = hrp.Position.Y
                local targetY
                if y >= -4 and y <= 11 then
                    targetY = 7
                elseif y >= 12 and y <= 28 then
                    targetY = 24
                elseif y > 28 then
                    hrp.Velocity = Vector3.new(0,0,0)
                    hum.JumpPower = 0
                    return
                end
                local remaining = targetY - y
                local velY = math.clamp(remaining * 5, 0, 40)
                local dir = hum.MoveDirection
                hrp.Velocity = Vector3.new(dir.X * 15, velY, dir.Z * 15)
                if y < targetY - 0.5 then
                    hum.JumpPower = 0
                else
                    hum.JumpPower = 0
                end
            else
                hum.JumpPower = 50
            end
        end)
    end
    if player.Character then setupChar(player.Character) end
    player.CharacterAdded:Connect(setupChar)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local backpack = player:WaitForChild("Backpack")
local hrp = character:WaitForChild("HumanoidRootPart")

task.spawn(function()
    while task.wait(0.1) do
        if not player.Character then
            player.CharacterAdded:Wait()
        else
            character = player.Character
            humanoid = character:WaitForChild("Humanoid")
            hrp = character:WaitForChild("HumanoidRootPart")
            backpack = player:WaitForChild("Backpack")
        end
    end
end)

local useRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem")

local targetSize = Vector3.new(0.6399999260902405,0.7299998998641968,0.4700000882148742)
local tol = 0.09

local function approx(a,b,t)
    return math.abs(a.X-b.X)<=t and math.abs(a.Y-b.Y)<=t and math.abs(a.Z-b.Z)<=t
end

local function findHandle()
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("BasePart") and v.Name == "Handle" and approx(v.Size, targetSize, tol) then
            return v
        end
    end
    return nil
end

local function equipBoogie()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name ~= "Boogie Bomb" then
            tool.Parent = backpack
        end
    end
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == "Boogie Bomb" then
            humanoid:EquipTool(tool)
            return tool
        end
    end
end

task.spawn(function()
    while task.wait() do
        if _G.floatActive then
            local handle = findHandle()
            if handle then
                handle.CanCollide = true
                handle.Anchored = true
                handle.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 4.35, hrp.Position.Z)
            else
                useRemote:FireServer()
                equipBoogie()
                useRemote:FireServer()
            end
        else
            task.wait(0.1)
        end
    end
end)

local LocalPlayer = game:GetService("Players").LocalPlayer
local function parseValue(str)
    str = str:gsub("%$", ""):gsub("/s", "")
    local num, suf = str:match("([%d%.]+)([MK]?)")
    num = tonumber(num) or 0
    if suf == "K" then num = num * 1000 elseif suf == "M" then num = num * 1000000 end
    return num
end

local currentESP = nil
task.spawn(function()
    while task.wait(0.3) do
        if _G.bestESP then
            local bestAnimal, bestValue = nil, -math.huge
            for _, plot in ipairs(workspace.Plots:GetChildren()) do
                local plotSign = plot:FindFirstChild("PlotSign")
                if plotSign then
                    local textLabel = plotSign:FindFirstChild("SurfaceGui") and plotSign.SurfaceGui:FindFirstChild("Frame") and plotSign.SurfaceGui.Frame:FindFirstChild("TextLabel")
                    if textLabel and textLabel.Text ~= "Empty Base" and not textLabel.Text:find(LocalPlayer.DisplayName) then
                        local animalPodiums = plot:FindFirstChild("AnimalPodiums")
                        if animalPodiums then
                            for _, podium in ipairs(animalPodiums:GetChildren()) do
                                local base = podium:FindFirstChild("Base")
                                local spawn = base and base:FindFirstChild("Spawn")
                                local attach = spawn and spawn:FindFirstChild("Attachment")
                                if attach then
                                    local overhead = attach:FindFirstChild("AnimalOverhead")
                                    if overhead then
                                        local stolen = overhead:FindFirstChild("Stolen")
                                        if not (stolen and (stolen.Text == "FUSING" or stolen.Text == "IN MACHINE" or stolen.Text == "CRAFTING")) then
                                            local gen = overhead:FindFirstChild("Generation")
                                            local rarity = overhead:FindFirstChild("Rarity")
                                            local name = overhead:FindFirstChild("DisplayName")
                                            if gen and rarity and name then
                                                local value = parseValue(gen.Text)
                                                if value > bestValue then
                                                    bestValue = value
                                                    bestAnimal = {attachment = attach, nome = name.Text, raridade = rarity.Text, porSegundo = gen.Text}
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if currentESP then currentESP:Destroy() currentESP = nil end
            if bestAnimal then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "BestAnimalESP"
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 180, 0, 36)
                billboard.StudsOffset = Vector3.new(0, 3.2, 0)
                billboard.Parent = bestAnimal.attachment
                local back = Instance.new("Frame")
                back.BackgroundTransparency = 0.18
                back.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
                back.Size = UDim2.new(1, 0, 1, 0)
                back.Parent = billboard
                local uicorner = Instance.new("UICorner")
                uicorner.CornerRadius = UDim.new(0, 10)
                uicorner.Parent = back
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.new(1, 1, 0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Text = string.format("%s | %s | %s", bestAnimal.nome, bestAnimal.raridade, bestAnimal.porSegundo)
                textLabel.Parent = back
                currentESP = billboard
            end
        else
            if currentESP then
                currentESP:Destroy()
                currentESP = nil
            end
        end
    end
end)

local originalNames = {
    ["LKZ-HUB"] = "LKZ-HUB",
    ["LKZ_Hub"] = "LKZ Hub",
    ["BestAnimalESP"] = "BestAnimalESP",
    ["Upstairs"] = "Upstairs"
}

task.spawn(function()
    while task.wait(0.01) do
        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LKZ-HUB") then
            local gui = game:GetService("Players").LocalPlayer.PlayerGui["LKZ-HUB"]
            local frame = gui:FindFirstChild("Frame")
            if frame then
                for _, obj in ipairs(frame:GetChildren()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        if originalNames[obj.Name] then
                            obj.Text = originalNames[obj.Name]
                        end
                    end
                end
            end
        end
        if game.CoreGui:FindFirstChild("LKZ_Hub") then
            game.CoreGui.LKZ_Hub.Name = originalNames["LKZ_Hub"]
        end
    end
end)

task.spawn(function()
    local plots = workspace:WaitForChild("Plots")
    while task.wait(0.05) do
        if _G.upstairs then
            for _, plot in ipairs(plots:GetChildren()) do
                local decorations = plot:FindFirstChild("Decorations")
                if decorations then
                    local children = decorations:GetChildren()
                    local specificIndexes = {27,31,32,33,34,35}
                    for _, index in ipairs(specificIndexes) do
                        local part = children[index]
                        if part and part:IsA("BasePart") and not originalCanCollide[part] then
                            originalCanCollide[part] = part.CanCollide
                            originalTransparencies[part] = part.Transparency
                            part.CanCollide = false
                            part.Transparency = 0.85
                            break
                        end
                    end
                end
                for _, part in ipairs(plot:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local col = part.Color
                        if math.floor(col.R*255) == 52 and math.floor(col.G*255) == 142 and math.floor(col.B*255) == 64 then
                            if not originalGreenParts[part] then
                                originalGreenParts[part] = {CanCollide = part.CanCollide, Transparency = part.Transparency}
                                part.CanCollide = false
                                part.Transparency = 1
                            end
                        end
                        if part.Size == Vector3.new(6,0.25,6) and not originalCanCollide[part] then
                            originalCanCollide[part] = part.CanCollide
                            originalTransparencies[part] = part.Transparency
                            part.CanCollide = false
                            part.Transparency = 0.85
                        end
                    end
                end
            end
        else
            for part, info in pairs(originalGreenParts) do
                if part and part.Parent then
                    part.CanCollide = info.CanCollide
                    part.Transparency = info.Transparency
                end
            end
            for part, canCollide in pairs(originalCanCollide) do
                if part and part.Parent then
                    part.CanCollide = canCollide
                    part.Transparency = originalTransparencies[part] or part.Transparency
                end
            end
            originalCanCollide = {}
            originalTransparencies = {}
            originalGreenParts = {}
        end
    end
end)

task.spawn(function()
    local Players = game:GetService("Players")
    while true do
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
        task.wait(0.2)
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

task.spawn(function()
    while true do
        if _G.FpsDev then
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            if character and backpack then
                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                local bat = backpack:FindFirstChild("Bat")
                local medusa = backpack:FindFirstChild("Medusa's Head")
                if humanoid and bat then
                    pcall(function() humanoid:EquipTool(bat) end)
                    task.wait(0.1)
                end
                if humanoid and medusa then
                    pcall(function() humanoid:EquipTool(medusa) end)
                    task.wait(0.1)
                    if humanoid then humanoid:UnequipTools() end
                end
            end
            task.wait(0.01)
        else
            task.wait(0.1)
        end
    end
end)
