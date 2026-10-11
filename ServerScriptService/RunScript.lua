-- @ScriptType: Script
local ServerStorage = game:GetService("ServerStorage")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

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
		Scenario = "BlackoutMinus",
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
	ObjectiveModule.StartObjective(1, ScenarioModule.ObjectivesList[1]) --kicks off the scenario
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
		
		_G.PlayersData.RunInformation.Scenario = scenario
	end
	
	local data
	_G.PlayersData.Data[player.Name] = PlayerDataTemplate
	
	player:SetAttribute("InDialogue", false)
	
	--here we'll load in the player's class and starting items and such
	print(_G.PlayersData)
	
	JoinedPlayers += 1
	if JoinedPlayers == PartySize then --checks if all players have loaded in, and if so starts the preparation phase
		StartPrepPhase()
	end
end)

CompleteObjective.Event:Connect(function(Number)
	if Number == _G.PlayersData.RunInformation.Objective then
		_G.PlayersData.RunInformation.Objective += 1
		if _G.PlayersData.RunInformation.Objective <= #ScenarioModule.ObjectivesList then
			ObjectiveModule.StartObjective(_G.PlayersData.RunInformation.Objective, ScenarioModule.ObjectivesList[_G.PlayersData.RunInformation.Objective])
		else
			print("Congradulations, you have won!!")
			TeleportService:TeleportAsync(107103583701575, Players:GetPlayers())
		end
	end
end)

for i, v in pairs(CollectionService:GetTagged("Elevator")) do
	v.Up.ClickDetector.MouseClick:Connect(function(player)
		player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, v:GetAttribute("TPDiff"), 0)
	end)
	
	v.Down.ClickDetector.MouseClick:Connect(function(player)
		player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -v:GetAttribute("TPDiff"), 0)
	end)
end