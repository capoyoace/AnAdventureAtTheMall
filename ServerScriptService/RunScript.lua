-- @ScriptType: Script
local ServerStorage = game:GetService("ServerStorage")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RequestHide = ReplicatedStorage.Remotes.ActivateHiding
local ActivateHiding = ServerStorage.Events.ActivateHiding

_G.PlayersData = { --sets up the server data
	RunInformation = {
		Objective = 0,
		Scenario = ""
	},
	Data = {}
}

local PlayerDataTemplate = {
	Class = "",
	StarterCash = 100,
	StarterItems = {},
	NPCRelationships = {}
}

local TheMall = workspace:WaitForChild("Mall")

local Scenarios = ServerStorage:WaitForChild("Scenarios")
local ShopTemplates = ServerStorage:WaitForChild("Shops")

local ServerInfoReceived = false
local PartySize = 0
local JoinedPlayers = 0

local ScenarioModule
local ObjectiveModule = require(ServerStorage.Tasks.ObjectiveHandler)

local CompleteObjective = ServerStorage.Events.CompleteObjective

local betajoindata = {
	TeleportData = {
		Scenario = "MunsterMinus",
		PartySize = 1
	}
}

local function Preload()
	local TemplateTable = ShopTemplates:GetChildren() --gets all of the shop templates as well as how many there are
	local NumberOfTemplates = #TemplateTable
	
	for i, v in pairs(TheMall.Shops:GetChildren()) do --loops through shop locations and places a random shop there
		local chance = math.random(1, NumberOfTemplates)
		local chosen = TemplateTable[chance][v:GetAttribute("Size")]:Clone()
		
		chosen.Parent = TheMall.Shops
		chosen:PivotTo(v.CFrame)
		chosen.Name = TemplateTable[chance].Name
		v:Destroy()
		table.remove(TemplateTable, chance) --removes the shop from the shops table to ensure that it only appears once
		
		NumberOfTemplates = #TemplateTable
	end
	
	game:SetAttribute("ScenarioStarted", false)
	
	print("loaded shops")
end

local function StartPrepPhase()
	ScenarioModule.Setup(TheMall)
	local Time = math.random(10, 10) --waits a random amount of time; this will actually be anywher from 3 (120) to 7 (420) minutes
	
	task.wait(Time)
	
	_G.PlayersData.RunInformation.Objective = 1
	game:SetAttribute("ScenarioStarted", true)
	print("objective started")
	ScenarioModule.Trigger(workspace.Mall)
	ObjectiveModule.StartObjective(1, ScenarioModule.ObjectivesList[1]) --kicks off the scenario
end

local function ForceShops(RequiredShopList) --if the scenario requires some shops to spawn with a guarantee, spawns those shops in place of currently spawned ones
	local SpawnedShops = TheMall.Shops:GetChildren()
	if TheMall.Shops:FindFirstChild("ShopLocation") then --buffers until all shops have been spawned in the prep phase (if necessary)
		while task.wait(0.5) do
			if not TheMall.Shops:FindFirstChild("ShopLocation") then
				SpawnedShops = TheMall.Shops:GetChildren()
				break
			end
		end
	end
	
	local function doThis(RandomShopToDestroy, i, v) --a function to replace an existing shop with a required one
		local newShop = ServerStorage.Shops:FindFirstChild(v..RandomShopToDestroy:GetAttribute("Size")):Clone()
		newShop:PivotTo(RandomShopToDestroy.PrimaryPart.CFrame)
		RandomShopToDestroy:Destroy()
		table.remove(SpawnedShops, i)
	end
	
	for i, v in RequiredShopList do
		local found = false
		for j, k in SpawnedShops do
			if k.Name:find(v) then
				found = true
				break
			end
		end
		
		if not found then --checks whether or not the shop actually exists
			local RandomShopToDestroy = SpawnedShops[math.random(1, #SpawnedShops)] --grabs random spawned shop
			if not table.find(RequiredShopList, v) then --makes sure the shop chosen isn't a required one
				doThis(RandomShopToDestroy, i, v)
			else
				while true do --chooses a shop that isn't required (if necessary)
					RandomShopToDestroy = SpawnedShops[math.random(1, #SpawnedShops)]
					if not table.find(RequiredShopList, v) then
						break
					end
					doThis(RandomShopToDestroy, i, v)
				end
			end
		end
	end
end

Preload()

Players.PlayerAdded:Connect(function(player)
	local joinData = betajoindata --player:GetJoinData()
	local teleportData = joinData.TeleportData
	
	if teleportData and not ServerInfoReceived then --if this is the first player, sets up the scenario and party size
		ServerInfoReceived = true
		local scenario = teleportData.Scenario
		local partySize = teleportData.PartySize
		
		ScenarioModule = require(Scenarios:FindFirstChild(scenario))
		PartySize = partySize
		
		if ScenarioModule.RequiredShops then
			task.spawn(function()
				ForceShops(ScenarioModule.RequiredShops)
			end)
		end
		
		_G.PlayersData.RunInformation.Scenario = scenario
	end
	
	local data
	_G.PlayersData.Data[player.Name] = PlayerDataTemplate
	
	player:SetAttribute("InDialogue", false)
	player:SetAttribute("Zone", "")
	
	--here we'll load in the player's class and starting items and such
	print(_G.PlayersData)
	
	JoinedPlayers += 1
	if JoinedPlayers == PartySize then --checks if all players have loaded in, and if so starts the preparation phase
		StartPrepPhase()
	end
end)

CompleteObjective.Event:Connect(function(Number) --handles when objectives are completed
	if Number == _G.PlayersData.RunInformation.Objective then --checks if the players have completed all objectives; if they haven't proceeds to next objective, otherwise tells them they won
		_G.PlayersData.RunInformation.Objective += 1
		if _G.PlayersData.RunInformation.Objective <= #ScenarioModule.ObjectivesList then
			ObjectiveModule.StartObjective(_G.PlayersData.RunInformation.Objective, ScenarioModule.ObjectivesList[_G.PlayersData.RunInformation.Objective])
		else
			print("Congratulations, you have won!!")
			TeleportService:TeleportAsync(107103583701575, Players:GetPlayers())
		end
	end
end)

for i, v in pairs(CollectionService:GetTagged("Elevator")) do --handles elevator movement
	v.Up.ClickDetector.MouseClick:Connect(function(player)
		player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, v:GetAttribute("TPDiff"), 0)
	end)
	
	v.Down.ClickDetector.MouseClick:Connect(function(player)
		player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -v:GetAttribute("TPDiff"), 0)
	end)
end

for i, v in pairs(CollectionService:GetTagged("LockedDoor")) do --handles locked doors
	v.ProximityPrompt.Triggered:Connect(function()
		local player = Players:GetPlayers()[1]
		if player:GetAttribute("Key") == v:GetAttribute("Key") or player:GetAttribute("Key") == "MasterKey" then --if the player has the specific key or the master key destroys the door cause why not
			local sound = script.Sound:Clone()
			sound.Parent = v
			v.CanCollide = false
			v.Transparency = 1
			v.SurfaceGui.Enabled = false
			sound:Play()
			sound.Ended:Wait()
			v:Destroy()
		else --if they don't laughs at them
			print("You don't have the key, sorry buddy :(")
			local sound = v.Sound
			sound:Play()
		end
	end)
end

for i, v in pairs(TheMall.Shops:GetChildren()) do --handles area zones
	for j, k in pairs(v:GetChildren()) do
		if k.Name == "AreaZone" then
			task.spawn(function()
				local LastCheckedPlayers = {}
				
				while task.wait(0.5) do --checks for players in the shop and updates their zone accordingly
					local parts = workspace:GetPartsInPart(k)
					local PossiblePlayers = {}

					for _, part in parts do --gets players from parts in the part, making sure not to duplicate them if they are already in the table
						local player = Players:GetPlayerFromCharacter(part.Parent)
						if player and not table.find(PossiblePlayers, player) then
							table.insert(PossiblePlayers, player)
							player:SetAttribute("Zone", v.Name)
						end
					end

					for _, player in LastCheckedPlayers do --checks if any player has left, updating their zone if so
						if not table.find(PossiblePlayers, player) then
							player:SetAttribute("Zone", "")
						end
					end

					LastCheckedPlayers = PossiblePlayers
				end
			end)
		end
	end
end

ActivateHiding.Event:Connect(function()
	for i, v in pairs(CollectionService:GetTagged("HidingPrompt")) do
		if not ServerStorage:IsAncestorOf(v) then
			v.Triggered:Connect(function(player)
				if not player:GetAttribute("Hiding") then
					player.Character:PivotTo(v.Parent.CFrame)
					player:SetAttribute("Hiding", v.Parent)
					RequestHide:FireClient(player)
				end
			end)
		end
	end
end)

RequestHide.OnServerEvent:Connect(function(player, hidingSpot, hidingOption)
	local character = player.Character
	
	character:PivotTo(hidingSpot.CFrame * CFrame.new(0, 5, 0))
	player:SetAttribute("Hiding", nil)
end)