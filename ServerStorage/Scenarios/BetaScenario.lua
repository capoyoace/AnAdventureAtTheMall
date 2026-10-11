-- @ScriptType: ModuleScript
local BetaScenario = {}

local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local ObjectiveHandler = require(ServerStorage.Tasks.ObjectiveHandler)

local ObjectiveObjects = script.ScenarioObjects

BetaScenario.ObjectivesList = { --a list of the scenario's objectives
	[1] = {Type = "ActivateItem", DisplayInfo = "Activate the purple part.", Quantity = 1, Objects = {}},
	[2] = {Type = "CollectItem", DisplayInfo = "Collect 5 spaghettis.", Quantity = 5, Objects = {}}
}

BetaScenario.Setup = function(Mall)
	local ScenarioFolder = Mall.Scenario
	
	local PossibleActivators = {}
	local PossibleCollectors = {}
	
	for _, v in pairs(CollectionService:GetTagged("PossibleLocation")) do --gets the possible locations for everything
		if v.Name == "PossibleActivateItem" and v:IsDescendantOf(workspace) then
			table.insert(PossibleActivators, v)
		elseif v.Name == "PossibleCollectItem" and v:IsDescendantOf(workspace) then
			table.insert(PossibleCollectors, v)
		end
	end
	
	local randomActivator = PossibleActivators[math.random(1, #PossibleActivators)] --Puts the purple part in the mall
	ObjectiveObjects.PurplePart:PivotTo(randomActivator:GetPivot())
	ObjectiveObjects.PurplePart.Parent = ScenarioFolder.Objectives
	table.insert(BetaScenario.ObjectivesList[1].Objects, ScenarioFolder.Objectives.PurplePart)
	
	for i = 1, 5, 1 do --Puts all of the spaghettis in the mall
		local randomCollector = PossibleCollectors[math.random(1, #PossibleCollectors)]
		local newSpaghetti = ObjectiveObjects.Spaghetti:Clone()
		newSpaghetti:PivotTo(randomCollector:GetPivot())
		newSpaghetti.Parent = ScenarioFolder.Objectives
		table.remove(PossibleCollectors, table.find(PossibleCollectors, randomCollector))
		randomCollector:Destroy()
		table.insert(BetaScenario.ObjectivesList[2].Objects, newSpaghetti)
	end

	for _, v in pairs(PossibleActivators) do --cleans up the rest of the possible locations
		v:Destroy()
	end
	
	for _, v in pairs(PossibleCollectors) do
		v:Destroy()
	end
end

return BetaScenario
