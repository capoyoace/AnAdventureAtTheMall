-- @ScriptType: ModuleScript
local BlackoutMinus = {}

local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local ObjectiveHandler = require(ServerStorage.Tasks.ObjectiveHandler)

BlackoutMinus.ObjectivesList = { --List of scenario objectives
	[1] = {Type = "AskAround", DisplayInfo = "Figure out what's going on. Asking around will help."},
	[2] = {Type = "LocateArea", DisplayInfo = "Check all of the exits... maybe there's one that isn't completely locked down.", Quantity = 5, Objects = {}},
	[3] = {Type = "FindNPC", DisplayInfo = "Find a security guard. Ask him what's up with this."},
	[4] = {Type = "LocateArea", DisplayInfo = "Locate the backup generator... the guard said it could be at %s.", Quantity = 1, Modifier = "loc", Objects = {}},
	[5] = {Type = "LocateArea", DisplayInfo = "Find a way to get into %s.", Quantity = 1, Modifier = "loc", Objects = {}},
	[6] = {Type = "ActivateItem", DisplayInfo = "Trigger the backup generator.", Quantity = 1, Objects = {}},
	[7] = {Type = "CollectItem", DisplayInfo = "Ask around to see if anyone has any %s they'd be willing to spare.", Quantity = 3, Modifier = "item"},
	[8] = {Type = "ActivateItem", DisplayInfo = "Install the %ss and trigger the backup generator.", Quantity = 4, Modifier = "item", Objects = {}},
	[9] = {Type = "ActivateItem", DisplayInfo = "There's more generators??? Well, at least you know where they are... activate them.", Quantity = math.random(3, 5), Objects = {}}
}

BlackoutMinus.Setup = function(Mall)
	local ScenarioFolder = Mall.Scenario
	local NPCFolder = Mall.NPCs
	
	local PossibleGeneratorLocs = {}
	
	for i, v in pairs(CollectionService:GetTagged("PossibleLocation")) do --gets the possible generator locations
		if v.Name == "PossibleGeneratorLocation" then
			table.insert(PossibleGeneratorLocs, v)
		end
	end
	
	for i = 1, BlackoutMinus.ObjectivesList[9].Quantity + 1, 1 do --for each generator required (generated randomly above), adds a generator at one of the possible locations
		local randomNum = math.random(1, #PossibleGeneratorLocs) --gets random location, adds a generator, moves it there, and destroys the already used location
		local randomLoc = PossibleGeneratorLocs[math.random(1, randomNum)]
		local newGenerator = script.Generator:Clone()
		newGenerator.Parent = ScenarioFolder.Objectives
		newGenerator:PivotTo(randomLoc.CFrame)
		randomLoc:Destroy()
		table.remove(PossibleGeneratorLocs, randomNum)
		
		if #BlackoutMinus.ObjectivesList[6].Objects > 0 then --checks if there has already been a first generator assinged; if so, adds it to the other generators, and if not makes it the first generator
			table.insert(BlackoutMinus.ObjectivesList[9].Objects, newGenerator)
		else
			table.insert(BlackoutMinus.ObjectivesList[6].Objects, newGenerator)
		end
	end
	
	for i, v in pairs(PossibleGeneratorLocs) do --gets rid of the other location parts so the player doesn't just come across a box and get really confused
		v:Destroy()
	end
end

return BlackoutMinus
