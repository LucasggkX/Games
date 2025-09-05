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


local itensEsp = {
    "Log", "Chair", "Biofuel", "Coal", "Fuel Canister", "Oil Barrel",
    "Revolver Ammo", "Rifle Ammo", "Shotgun Ammo", "Revolver", "Rifle", "Tactical Shotgun",
    "Cultist", "Crossbow Cultist", "Juggernaut Cultist", "Alien", "Elite Alien", "Wolf Corpse", "Alpha Wolf Corpse", "Bear Corpse",
    "Bolt", "Sheet Metal", "UFO Junk", "UFO Component", "Broken Fan", "Old Radio", "Broken Microwave", "Tyre", "Metal Chair", "Old Car Engine", "Washing Machine",
    "Cultist Experiment", "Cultist Prototype", "UFO Scrap"
}


local mobEsp = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Polar Bear", "Arctic Fox", "Cultist", "Crossbow Cultist", "Juggernaut Cultist", "Alien", "Alien Elite", "Mammoth"}


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
local EspTab    =    Window:AddTab({Title = "Esp",      Icon = "crosshair"})
local TPsTab    =    Window:AddTab({Title = "TPs",      Icon = "map"})
local Combat    =    Window:AddTab({Title = "Combat",   Icon = "swords"})
local Farm      =    Window:AddTab({Title = "Farm",     Icon = "farm"})

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

TPsTab:AddButton({
	Title = "Teleports to the campfire",
	Callback = function()
	    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 8, 0)
	end
})

TPsTab:AddButton({
	Title = "Teleport to anvil",
	Description = "You must have unlocked the area and spawned the structure.",
	Callback = function()
		local podiums = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Landmarks") and workspace.Map.Landmarks:FindFirstChild("ToolWorkshop") and workspace.Map.Landmarks.ToolWorkshop:FindFirstChild("Functional") and workspace.Map.Landmarks.ToolWorkshop.Functional:FindFirstChild("Podium")
		if podiums and #podiums:GetChildren() >= 3 then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = podiums:GetChildren()[3].CFrame + Vector3.new(0,30,0)
		end
	end
})

TPsTab:AddButton({
	Title = "Teleport to diamond castle",
	Description = "You must have unlocked the area and spawned the structure.",
	Callback = function()
		local exterior = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Landmarks") and workspace.Map.Landmarks:FindFirstChild("Stronghold") and workspace.Map.Landmarks.Stronghold:FindFirstChild("Building") and workspace.Map.Landmarks.Stronghold.Building:FindFirstChild("Exterior")
		if exterior and #exterior:GetChildren() >= 12 then
			local model = exterior:GetChildren()[12]:FindFirstChild("Model")
			if model and #model:GetChildren() >= 5 then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = model:GetChildren()[5].CFrame + Vector3.new(0,15,0)
			end
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
	"Cooked Morsel",
	"Cooked Steak",
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







function Aesp(obj, tipo)
	local parte = nil
	if obj:IsA("BasePart") then
		parte = obj
	elseif obj:IsA("Model") then
		parte = obj:FindFirstChildWhichIsA("BasePart")
	end
	if parte and not parte:FindFirstChild("ESPTexto") then
		local esp = Instance.new("BillboardGui")
		esp.Name = "ESPTexto"
		esp.Adornee = parte
		esp.Size = UDim2.new(0, 100, 0, 20)
		esp.StudsOffset = Vector3.new(0, 2, 0)
		esp.AlwaysOnTop = true
		local texto = Instance.new("TextLabel", esp)
		texto.Size = UDim2.new(1, 0, 1, 0)
		texto.BackgroundTransparency = 1
		texto.Text = obj.Name
		texto.TextColor3 = Color3.fromRGB(255, 255, 0)
		texto.TextStrokeTransparency = 0.2
		texto.TextScaled = true
		texto.Font = Enum.Font.SourceSansBold
		esp.Parent = parte
	end
end

function Desp(obj)
	local parte = nil
	if obj:IsA("BasePart") then
		parte = obj
	elseif obj:IsA("Model") then
		parte = obj:FindFirstChildWhichIsA("BasePart")
	end
	if parte then
		local gui = parte:FindFirstChild("ESPTexto")
		if gui then
			gui:Destroy()
		end
	end
end

local vde = {}
local vdm = {}

local espdownItems = EspTab:AddDropdown("a", {
   Title = "Select Items to ESP",
   Values = itensEsp,
   Multi = true,
   Default = {},
})

espdownItems:OnChanged(function(val)
	table.clear(vde)
	for i, state in next, val do
		if state then
			vde[#vde + 1] = i
		end
	end
end)

local espdownMobs = EspTab:AddDropdown("b", {
   Title = "Select Mobs to ESP",
   Values = mobEsp,
   Multi = true,
   Default = {},
})

espdownMobs:OnChanged(function(val)
	table.clear(vdm)
	for i, state in next, val do
		if state then
			vdm[#vdm + 1] = i
		end
	end
end)

_G.aae = false
EspTab:AddToggle("", {
    Title = "Enable ESP", 
    Description = "Shows ESP automatically based on dropdown",
    Default = false,
    Callback = function(a)
        _G.aae = a
    end
})

task.spawn(function()
	while true do
		if _G.aae then
			local itens = workspace:WaitForChild("Items")
			local mobs = workspace:WaitForChild("Characters")
			for _, obj in ipairs(itens:GetChildren()) do
				if table.find(vde, obj.Name) then
					Aesp(obj, "item")
				else
					Desp(obj)
				end
			end
			for _, mob in ipairs(mobs:GetChildren()) do
				if table.find(vdm, mob.Name) then
					Aesp(mob, "mob")
				else
					Desp(mob)
				end
			end
		else
			for _, obj in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
				Desp(obj)
			end
			for _, mob in ipairs(workspace:WaitForChild("Characters"):GetChildren()) do
				Desp(mob)
			end
		end
		task.wait(0.25)
	end
end)













function blm(nome, caminho, pos, extra)
	local p = game.Players.LocalPlayer
	if not pos then return end

	local x, y, z = string.match(pos, "([^,]+),%s*([^,]+),%s*([^,]+)")
	local destino = Vector3.new(tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0)

	for _, item in ipairs(workspace.Items:GetChildren()) do
		if item.Name == nome then
			local partes = string.split(caminho, ".")
			local obj = item
			for _, parte in ipairs(partes) do
				obj = obj:FindFirstChild(parte)
				if not obj then break end
			end
			if obj and obj:IsA("BasePart") then
				if (obj.Position - destino).Magnitude > (extra or 30) then
					obj.CFrame = CFrame.new(destino)
				end
			end
		end
	end
end

function blmMeat()
	blm("Steak", "Main", "-0, 6.5, 0", 0)
	blm("Morsel", "Meat", "-0, 6.5, 0", 0)
	task.wait(0.1)
	blm("Morsel", "Meat", "-0, 6.35, 0", 0)
end

survival:AddSection("Auto Cook meat")

local acm
local aguardando = false

acm = survival:AddButton({
    Title = "Cook Meat",
    Description = "After clicking, it cooks the meat ",
    Callback = function()
        if aguardando then return end
        aguardando = true

        blmMeat()

        local ini = os.time() + 5

        task.spawn(function()
            while os.time() < ini do
                local t = ini - os.time()
                acm:SetDesc("Wait: " .. t .. " seconds to use again")
                task.wait(0.1)
            end

            acm:SetDesc("After clicking, it cooks the meat and after 5 seconds teleports them to you")
            aguardando = false
        end)
    end
})

survival:AddParagraph({
	Title = "How to use?",
	Content = "The first time it will bug\nHow to fix it?\nWhen you click the button for the first time\ngo to the campfire and click on one of the meats\nAfter that they will drop and cook\nFrom this moment on it will no longer bug\nIf it happens again just repeat this process."
})

local AxeValidos = {
    ["Old Axe"] = true,
    ["Good Axe"] = true,
    ["Ice Axe"] = true,
    ["Admin Axe"] = true,
    ["Strong Axe"] = true
}

_G.FarmActive = false

Farm:AddToggle("", {
    Title = "Auto Farm Small Trees",
    Default = false,
    Callback = function(value)
        _G.FarmActive = value

        if value then
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local LocalPlayer = Players.LocalPlayer

            local function gerarID()
                return "2_" .. LocalPlayer.UserId
            end

            local function getArmaValida()
                local inv = LocalPlayer:FindFirstChild("Inventory")
                local char = workspace:FindFirstChild(LocalPlayer.Name)
                local equipado = char and char:GetAttribute("Equipped")
                if not equipado or not AxeValidos[equipado] then return nil end
                if inv then
                    local arma = inv:FindFirstChild(equipado)
                    if arma then
                        return arma
                    end
                end
                return nil
            end

            local function getSmallTreesMaisProximas(limite)
                local map = workspace:FindFirstChild("Map")
                if not map then return {} end

                local foliage = map:FindFirstChild("Foliage")
                local landmarks = map:FindFirstChild("Landmarks")
                local char = workspace:FindFirstChild(LocalPlayer.Name)
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return {} end

                local trees = {}

                local function coletarArvores(pasta)
                    if not pasta then return end
                    for _, arvore in pairs(pasta:GetChildren()) do
                        if arvore.Name == "Small Tree" then
                            local part = arvore:FindFirstChild("Part")
                            if part and part.Position then
                                local dist = (hrp.Position - part.Position).Magnitude
                                table.insert(trees, {arvore = arvore, dist = dist})
                            end
                        end
                    end
                end

                coletarArvores(foliage)
                coletarArvores(landmarks)

                table.sort(trees, function(a, b)
                    return (a.dist or math.huge) < (b.dist or math.huge)
                end)

                local resultado = {}
                for i = 1, math.min(limite, #trees) do
                    table.insert(resultado, trees[i].arvore)
                end

                return resultado
            end

            local function atacarSmallTrees()
                local trees = getSmallTreesMaisProximas(10)
                if #trees == 0 then return end

                local arma = getArmaValida()
                if not arma then return end

                local evento = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject")

                for _, tree in pairs(trees) do
                    local part = tree:FindFirstChild("Part")
                    if part then
                        task.spawn(function()
                            local args = {tree, arma, gerarID(), part.CFrame}
                            pcall(function()
                                evento:InvokeServer(unpack(args))
                            end)
                        end)
                    end
                end
            end

            task.spawn(function()
                while _G.FarmActive do
                    task.wait(0.1)
                    if LocalPlayer and LocalPlayer.Parent then
                        atacarSmallTrees()
                    end
                end
            end)
        end
    end
})
