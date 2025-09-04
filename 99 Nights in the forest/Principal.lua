game:GetService("StarterGui"):SetCore("SendNotification", {Title="Script loading...", Text="Made by Lucas", Duration=5})

local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()
local Window = l:CreateWindow({
    Title = "",
    SubTitle = "",
    TabWidth = 0,
    Size = UDim2.fromOffset(0, 0),
    Acrylic = false,
    Theme = "Dark",
})
task.wait(0.1)

l:Destroy()

task.wait(0.1)
game:GetService("StarterGui"):SetCore("SendNotification", {Title="script loaded...", Text="Made by Lucas", Duration=5})

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local gameTitle = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local Window = Fluent:CreateWindow({
    Title = gameTitle .. " |",
    SubTitle = "Made by Lucas | in development",
    TabWidth = 180,
    Size = UDim2.fromOffset(600, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true,
    Keybind = Enum.KeyCode.LeftControl
})

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local decalId = "rbxassetid://122755768466240"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggableImageButtonGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local imageButton = Instance.new("ImageButton")
imageButton.Name = "DraggableButton"
imageButton.Image = decalId
imageButton.Size = UDim2.new(0, 65, 0, 65)
imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
imageButton.Position = UDim2.new(0, 100, 1, -400)
imageButton.BackgroundTransparency = 0
imageButton.AutoButtonColor = false
imageButton.Parent = screenGui

local dragging, dragInput, mousePos, buttonPos = false

imageButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging, mousePos, buttonPos = true, input.Position, imageButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

imageButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		imageButton.Position = UDim2.new(
			buttonPos.X.Scale, buttonPos.X.Offset + delta.X,
			buttonPos.Y.Scale, buttonPos.Y.Offset + delta.Y
		)
	end
end)

imageButton.MouseButton1Click:Connect(function()
	Window:Minimize()
end)

if _G.fluentLoopRunning then
    _G.fluentLoopRunning = _G.fluentLoopRunning + 1
else
    _G.fluentLoopRunning = 1
end
local runId = _G.fluentLoopRunning

task.spawn(function()
    while playerGui and playerGui:IsDescendantOf(game) do
        if _G.fluentLoopRunning ~= runId then break end
        task.wait(0.05)
    end
    if _G.fluentLoopRunning == runId then
        local drag = playerGui:FindFirstChild("DraggableImageButtonGui")
        if drag then drag.Enabled = true end
    end
end)

task.spawn(function()
    while true do
        if _G.fluentLoopRunning ~= runId then break end
        if not playerGui or not playerGui:IsDescendantOf(game) then
            local drag = playerGui:FindFirstChild("DraggableImageButtonGui")
            if drag then drag:Destroy() end
            break
        end
        local drag = playerGui:FindFirstChild("DraggableImageButtonGui")
        if drag then drag.Enabled = true end
        task.wait(0.025)
    end
    if _G.fluentLoopRunning == runId then
        local drag = playerGui:FindFirstChild("DraggableImageButtonGui")
        if drag then drag.Enabled = true end
    end
end)

--[[ ================= SCRIPT ================= ]]--

local armasValidas = {
    ["Old Axe"] = true,
    ["Good Axe"] = true,
    ["Ice Axe"] = true,
    ["Admin Axe"] = true,
    ["Strong Axe"] = true,
    ["Spear"] = true,
    ["Morningstar"] = true,
    ["Katana"] = true,
    ["Laser Sword"] = true,
    ["Ice Sword"] = true,
    ["Trident"] = true,
    ["Poison Spear"] = true
}

_G.WalkSpeedToggle = false
_G.WalkSpeed = 50
_G.nwsp = 20
_G.killaura = nil
_G.TPSActive = false
_G.InfJumpToggle = false
_G.SuperJumpToggle = false
_G.SuperJumpValue = 100

local PlayerTab =    Window:AddTab({Title = "Player",   Icon = "user"})
local survival  =    Window:AddTab({Title = "Survival", Icon = "heart"})
local EspTab    =    Window:AddTab({Title = "Esp",      Icon = "binoculars"})
local TPsTab    =    Window:AddTab({Title = "TPs",      Icon = "map"})
local Combat    =    Window:AddTab({Title = "Combat",   Icon = "swords"})

PlayerTab:AddSection("Speed settings")

local input
input = PlayerTab:AddInput("Input", {
    Title = "Set WalkSpeed",
    Description = "",
    Default = 50,
    Placeholder = "Set WalkSpeed 30~150",
    Numeric = true,
    Finished = true, 
    Callback = function(Value)
    local num = tonumber(Value)
    if not num then return end
    if num > 150 then
        input:SetValue(150)
        _G.WalkSpeed = 150
    elseif num < 30 then
        input:SetValue(30)
        _G.WalkSpeed = 30
    else
        _G.WalkSpeed = num
    end
end
})

PlayerTab:AddToggle("",{
    Title = "Activate WalkSpeed",
    Description = "activate WalkSpeed",
    Default = _G.WalkSpeedToggle,
    Callback = function(v)
        _G.WalkSpeedToggle = v
        if not v then
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = _G.nwsp
            end
        end
    end
})

PlayerTab:AddSection("Jump Settings")

PlayerTab:AddToggle("", {
    Title = "Infinite Jump",
    Description = "Toggle Infinite Jump On/Off",
    Default = _G.InfJumpToggle,
    Callback = function(v)
        _G.InfJumpToggle = v
    end
})
local superJumpInput
superJumpInput = PlayerTab:AddInput("", {
    Title = "Super Jump Power",
    Description = "Set your jump power (50~200)",
    Default = _G.SuperJumpValue,
    Placeholder = "Enter jump power",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if not num then return end
        if num < 50 then num = 50 superJumpInput:SetValue(50) end
        if num > 200 then num = 200 superJumpInput:SetValue(200) end
        _G.SuperJumpValue = num
    end
})

PlayerTab:AddToggle("", {
    Title = "Activate Super Jump",
    Description = "Toggle Super Jump On/Off",
    Default = _G.SuperJumpToggle,
    Callback = function(v)
        _G.SuperJumpToggle = v
    end
})

Combat:AddToggle("", {
Title = "Kill Aura (OP)",
Description = "Automatically attacks any NPC\nTo use: Hold a melee weapon in your hand\nIt attacks the nearest NPC",
Default = false,
Callback = function(value)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local evento = ReplicatedStorage.RemoteEvents:FindFirstChild("ToolDamageObject")
local caminho = workspace:FindFirstChild("Characters") or workspace

function getArmaValida()
    local inv = LocalPlayer:FindFirstChild("Inventory")
    local char = workspace[LocalPlayer.Name]
    local equipado = char and char:GetAttribute("Equipped")
    if not equipado or not armasValidas[equipado] then return nil end
    if inv then
        local arma = inv:FindFirstChild(equipado)
        if arma then
            return arma
        end
    end
    return nil
end

local function gerarID()    
	return "2_" .. LocalPlayer.UserId    
end    

local function getNPCsMaisProximos(character, targets, limite)    
	local hrp = character:FindFirstChild("HumanoidRootPart")    
	if not hrp then return {} end    

	local npcs = {}    

	for _, alvo in pairs(targets) do    
		if alvo ~= character then    
			local alvoRoot = alvo:FindFirstChild("HumanoidRootPart")    
			local humanoid = alvo:FindFirstChildWhichIsA("Humanoid")    
			if alvoRoot and humanoid and humanoid.Health > 0 then    
				local dist = (hrp.Position - alvoRoot.Position).Magnitude    
				table.insert(npcs, { alvo = alvo, dist = dist })    
			end    
		end    
	end    

	table.sort(npcs, function(a, b)    
		return a.dist < b.dist    
	end)    

	local resultado = {}    
	for i = 1, math.min(limite, #npcs) do    
		table.insert(resultado, npcs[i].alvo)    
	end    

	return resultado    
end    

if value then    
	_G.killaura = RunService.RenderStepped:Connect(function()    
		local char = workspace[Players.LocalPlayer.Name]
		local equipado = char and char:GetAttribute("Equipped")
		if not equipado or not armasValidas[equipado] then return end

		local arma = getArmaValida()    
		if not arma or not evento then return end    

		local c = LocalPlayer.Character    
		if not c then return end    

		local hrp = c:FindFirstChild("HumanoidRootPart")    
		if not hrp then return end    

		local alvos = getNPCsMaisProximos(c, caminho:GetChildren(), 15)    
		for _, alvo in pairs(alvos) do    
			evento:InvokeServer(alvo, arma, gerarID(), hrp.CFrame)    
		end    
	end)    
else    
	if _G.killaura then    
		_G.killaura:Disconnect()    
		_G.killaura = nil    
	end    
end

end

})

local txt = {}
for arma, _ in pairs(armasValidas) do
    table.insert(txt, arma)
end

local ft = table.concat(txt, "\n")

Combat:AddParagraph({
    Title = "Valid Weapons for Kill Aura",
    Content = ft
})

TPsTab:AddToggle("", {
    Title = "Teleport to Campfire at Night",
    Description = "Teleports automatically when the timer reaches 0:00",
    Default = _G.TPSActive,
    Callback = function(v)
        _G.TPSActive = v
        if v then
            task.spawn(function()
                while _G.TPSActive do
                    task.wait(0.25)
                    local player = game:GetService("Players").LocalPlayer
                    local gui = player.PlayerGui:FindFirstChild("Interface")
                    if gui and gui:FindFirstChild("TopRight") and gui.TopRight:FindFirstChild("Frame") and gui.TopRight.Frame:FindFirstChild("SunDial") and gui.TopRight.Frame.SunDial:FindFirstChild("RealTimer") then
                        if gui.TopRight.Frame.SunDial.RealTimer.Text == "0:00" then
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 8, 0)
                            end
                        end
                    end
                end
            end)
        end
    end
})



function wiki(nome)
    local c = 0
    for _, i in ipairs(workspace.Items:GetChildren()) do
        if i.Name == nome then
            c = c + 1
        end
    end
    return c
end

function ghn()
    return math.floor(game:GetService("Players").LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end

function feed(nome)
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name == nome then
            game:GetService("ReplicatedStorage").RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end

function notifeed(nome)
    Fluent:Notify({
        Title = "Auto feed pause",
        Content = "Sem '" .. nome .. "' Spawnado para consumo, Selecione outra comida por enquanto..",
        Duration = 3
    })
end

local vf, ife, tfe
local tf = false
local alimentos = {
    "Meat Sandwich?",
    "Hearty Stew",
    "Stew",
    "Chili",
    "Cake",
    "Ribs",
    "Steak",
    "Morsel",
    "Apple",
    "Berry",
    "Pumpkin",
    "Corn",
    "Carrot",
    "Shark",
    "Swordfish",
    "Eel",
    "Char",
    "Jellyfish",
    "Clownfish",
    "Salmon",
    "Mackerel"
}
local c = "Carrot"
vf = 75

survival:AddSection("Auto feed")
survival:AddDropdown("", {
    Title = "Escolha a comida",
    Description = "Selecione o alimento para auto feed",
    Values = alimentos,
    Multi = false,
    Default = c,
    Callback = function(value)
        c = value
    end
})

task.spawn(function()
    local a = survival:AddParagraph({ Title = "fome:", Content = ghn() })
    local b = survival:AddParagraph({ Title = "Comida selecionada:", Content = c })
    while true do
        task.wait(0.2)
        a:SetDesc(ghn() .. "%")
        b:SetDesc(c)
    end
end)

ife = survival:AddInput("", {
    Title = "Feed %",
    Description = "Quando fome atingir (X%) Comer",
    Default = vf,
    Placeholder = "",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        vf = tonumber(Value) or 75
        if vf < 0 then
            vf = 1
            ife:SetValue(vf)
        elseif vf > 100 then
            vf = 100
            ife:SetValue(vf)
        end
    end
})

tfe = survival:AddToggle("", {
    Title = "Ativar auto feed",
    Description = "Auto se explica",
    Default = false,
    Callback = function(v)
        tf = v
        if tf then
            task.spawn(function()
                while tf do
                    task.wait(0.075)
                    if wiki(c) == 0 then
                        tfe:SetValue(false)
                        notifeed(c)
                        break
                    end
                    if ghn() <= vf then
                        feed(c)
                    end
                end
            end)
        end
    end
})


task.spawn(function()
    while true do
        task.wait(0.025)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            if _G.WalkSpeedToggle then
                humanoid.WalkSpeed = _G.WalkSpeed
            end
            if _G.SuperJumpToggle then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = _G.SuperJumpValue
			else 
				humanoid.JumpPower = 50
            end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        if _G.InfJumpToggle then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)






local Camera = workspace.CurrentCamera

local function ESP(tipo, nome, ativar)
    local workspacePath
    if tipo == "Mob" then
        workspacePath = workspace:FindFirstChild("Characters")
    elseif tipo == "Item" then
        workspacePath = workspace:FindFirstChild("Items")
    else
        return
    end
    if not workspacePath then return end

    for _, obj in pairs(workspacePath:GetChildren()) do
        if obj.Name == nome then
            local espBox = obj:FindFirstChild("ESP_Box")
            local espLabel = obj:FindFirstChild("ESP_Label")

            if ativar then
                if not espBox then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESP_Box"
                    box.Adornee = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart") or obj
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = box.Adornee.Size
                    box.Color3 = tipo == "Mob" and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
                    box.Transparency = 0.5
                    box.Parent = obj
                end

                if not espLabel then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESP_Label"
                    billboard.Adornee = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart") or obj
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.Text = obj.Name
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextStrokeTransparency = 0
                    text.TextScaled = false
                    text.Font = Enum.Font.GothamBold
                    text.TextSize = 14
                    text.Parent = billboard

                    billboard.Parent = obj

                    task.spawn(function()
                        while text.Parent and obj.Parent do
                            local distance = (Camera.CFrame.Position - obj.Position).Magnitude
                            local scale = math.clamp(30 / distance, 0.5, 1.5)
                            text.TextSize = 14 * scale
                            task.wait(0.05)
                        end
                    end)
                end
            else
                if espBox then espBox:Destroy() end
                if espLabel then espLabel:Destroy() end
            end
        end
    end
end

local function RemoveAllESP()
    for _, pathName in ipairs({"Characters","Items"}) do
        local workspacePath = workspace:FindFirstChild(pathName)
        if workspacePath then
            for _, obj in ipairs(workspacePath:GetChildren()) do
                local espBox = obj:FindFirstChild("ESP_Box")
                local espLabel = obj:FindFirstChild("ESP_Label")
                if espBox then espBox:Destroy() end
                if espLabel then espLabel:Destroy() end
            end
        end
    end
end

local itensEsp = {"Log","Chair","Biofuel","Coal","Fuel Canister","Oil Barrel","Cultist Corpse","Crossbow Cultist Corpse","Juggernaut Cultist Corpse","Alien Corpse","Elite Alien Corpse","Wolf Corpse","Alpha Wolf Corpse","Bear Corpse"}
local mobEsp = {"Wolf","Alpha Wolf","Bear","Alpha Bear","Cultist","Crossbow Cultist","Juggernaut Cultist","Alien","Elite Alien","Arctic Fox","Polar Bear","Mammoth","Green Frog","Blue Frog","Frog King"}

local selectedItems = {}
local selectedMobs = {}

local itemDropdown = EspTab:AddDropdown("", {
    Title = "Select Item Esp",
    Description = "",
    Values = itensEsp,
    Multi = true,
    Default = {},
    Callback = function(v)
        selectedItems = v
    end
})

local mobDropdown = EspTab:AddDropdown("", {
    Title = "Select Mob Esp",
    Description = "",
    Values = mobEsp,
    Multi = true,
    Default = {},
    Callback = function(v)
        selectedMobs = v
    end
})

_G.Esptoggle = false
local espToggle = EspTab:AddToggle("", {
    Title = "Enable esp on selected Mobs/Items",
    Default = false,
    Callback = function(v)
        _G.Esptoggle = v
    end
})

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.Esptoggle then
            for _, itemName in ipairs(selectedItems) do
                ESP("Item", itemName, true)
            end
            for _, mobName in ipairs(selectedMobs) do
                ESP("Mob", mobName, true)
            end
        end
    end
end)

EspTab:AddButton({
    Title = "Remove ESPs",
    Callback = function()
        RemoveAllESP()
        selectedItems = {}
        selectedMobs = {}
        espToggle:SetValue(false)
    end
})
