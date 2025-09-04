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
    SubTitle = "Made by Lucas",
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
_G.nwsp = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed
_G.killaura = nil
_G.TPSActive = false

local PlayerTab = Window:AddTab({Title = "Player", Icon = "user"})
local TPsTab = Window:AddTab({Title = "TPs", Icon = "map"})
local Combat = Window:AddTab({ Title = "Combat", Icon = "" })

local input
input = PlayerTab:AddInput("Input", {
    Title = "Set WalkSpeed",
    Description = "",
    Default = "",
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

task.spawn(function()
    while true do
        task.wait(0.025)
        if _G.WalkSpeedToggle then
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = _G.WalkSpeed
            end
        end
    end
end)

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
