-- @ScriptType: ModuleScript
local MunsterMinus = {}

local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ObjectiveService = require(ServerStorage.Tasks.ObjectiveHandler)
local NPCHandler = require(ServerStorage.Tasks.NPCHandler)

local ActivateHiding = ServerStorage.Events.ActivateHiding
local StopLounging = ServerStorage.Events.CancelLounge
local CutsceneManager = ServerStorage.Events.CutsceneManager

MunsterMinus.ObjectivesList = { --List of scenario objectives. Note the decimals; if you fail one objective, it adds a decimal place to the next one.
	[1] = {Type = "AskAround", DisplayInfo = "Check if everyone is okay.", AskType = "InformationBased", Quantity = 3, Completed = 0},
	[2] = {Type = "FindNPC", DisplayInfo = "Figure out some sort of game plan with the security officer in the %s.", Modifier = "loc", loc = "", Specifications = {"NPCType", "SecurityGuard"}},
	[3] = {Type = "LocateArea", DisplayInfo = "Head to the armory... quietly.", Quantity = 1, Objects = {}, Followers = {}, AreaLocations = {
		[1] = {}
	}},
	[4] = {Type = "CollectItem", DisplayInfo = "Talk to the shopkeeper. See if you can borrow something.", Item = "", ItemType = "NPC"},
	[5] = {Type = "DefeatEnemies", DisplayInfo = "Take out the munster.", Quantity = 1, Enemies = {}},
	[6] = {Type = "EscapeNotice", DisplayInfo = "RUN!!!!"},
	[7] = {Type = "FindNPC", DisplayInfo = "Well, that sure didn't do jack squat. Figure something else out.", Specifications = {"NPCType", "SecurityGuard"}},
	[8] = {Type = "LocateArea", DisplayInfo = "Head to the apothecary... even more quietly. That thing's angry now.", Quantity = 1, AreaLocations = {
		[1] ={}
	}},
	[9] = {Type = "CollectItem", DisplayInfo = "Bargain with this shopkeeper. They may be a bit... tougher.", Item = "", ItemType = "NPC"},
	[10.1] = {Type = "DefeatEnemies", DisplayInfo = "This should deal with the monster. Stun it, then take it out.", Quantity = 1, Enemies = {}},
	[10.2] = {Type = "ActivateItem", DisplayInfo = "Looks like the shopkeeper has to go... create a distraction.", Quantity = 1},
	[11.2] = {Type = "CollectItem", DisplayInfo = "Quick, steal the potion!!!", Quantity = 1, Item = ""},
	[12.2] = {Type = "DefeatEnemies", DisplayInfo = "Whew, that was close... now this should deal with the monster. Stun it, then take it out.", Quantity = 1, Enemies = {}}
}

MunsterMinus.RequiredShops = {"Armory", "Apothecary"} --An array of shops required for the scenario. The game will always spawn these first before randomizing shops.

MunsterMinus.SurvivorPositions = {
	["S"] = {},
	["M"] = {},
	["L"] = {},
	["XL"] = {}
}

MunsterMinus.Setup = function(Mall)
	local ScenarioFolder = Mall.Scenario
	local NPCs = Mall.NPCs
	
	local PossibleHidingSpots = {}
	
	for i, v in pairs(CollectionService:GetTagged("PossibleLocation")) do --gets things needed for the tables
		if v.Name == "PossibleHidingSpot" then
			table.insert(PossibleHidingSpots, v)
		end
	end
	
	for i = 1, math.random(4, 8), 1 do --spawn 4-8 randomly placed hiding spots
		local randomIndex = math.random(1, #PossibleHidingSpots)
		local randomHidingSpot = PossibleHidingSpots[randomIndex]
		
		local randomHidingAppearance = script.PossibleHidingSpotVariants:GetChildren()[math.random(1, #script.PossibleHidingSpotVariants:GetChildren())]:Clone()
		
		local newHidingLocation = script.HidingSpot:Clone()
		newHidingLocation.Parent = Mall.Scenario.SpecialStuff
		randomHidingAppearance.Parent = newHidingLocation
		newHidingLocation.ProximityPrompt.ObjectText = randomHidingAppearance.Name
		newHidingLocation.Position = randomHidingSpot.Position
		randomHidingSpot:Destroy()
		table.remove(PossibleHidingSpots, randomIndex)
	end
	
	ActivateHiding:Fire()
	
	for i, v in pairs(PossibleHidingSpots) do
		v:Destroy()
	end
end

MunsterMinus.Trigger = function(Mall)
	local NewMunster = script.Munster:Clone() --puts the munster into the world
	NewMunster.Parent = Mall.Scenario.Enemies
	
	local randomShop = Mall.Shops[Mall.Shops:GetChildren()[math.random(1, #Mall.Shops:GetChildren())].Name] --gets two random shops
	local anotherRandomShop = Mall.Shops[Mall.Shops:GetChildren()[math.random(1, #Mall.Shops:GetChildren())].Name]
	
	if anotherRandomShop == randomShop then --makes sure the two random shops aren't each other
		while anotherRandomShop == randomShop do
			anotherRandomShop = Mall.Shops[Mall.Shops:GetChildren()[math.random(1, #Mall.Shops:GetChildren())].Name]
			if anotherRandomShop ~= randomShop then
				break
			end
		end
	end
	
	local survivingNPCs = {} --picks out 3 lucky NPCs
	local totalSurvivors = 3
	local securityGuard
	for i, v in pairs(Mall.NPCs:GetChildren()) do
		if v:GetAttribute("NPCType") ~= "SecurityGuard" then
			table.insert(survivingNPCs, v)
			if #survivingNPCs >= totalSurvivors then
				break
			end
		else
			securityGuard = v
		end
	end
	
	for i, v in pairs(Mall.NPCs:GetChildren()) do --kills the rest
		if not table.find(survivingNPCs, v) then
			if v:GetAttribute("NPCType") ~= "SecurityGuard" then
				v:Destroy()
			end
		end
	end
	
	local possiblePositions = {} --gets survivor locations
	for i, v in pairs(randomShop:GetChildren()) do
		if v.Name == "SurvivorPosition" then
			table.insert(possiblePositions, v)
		end
	end
	
	for i, v in survivingNPCs do --puts the survivors in the first random shop
		local randomIndex = math.random(1, #possiblePositions)
		local randomPosition = possiblePositions[randomIndex]
		v:PivotTo(randomPosition.CFrame)
		v.HumanoidRootPart.Anchored = true
		randomPosition:Destroy()
		table.remove(possiblePositions, randomIndex)
	end
	
	for i, v in possiblePositions do --gets rid of the other position
		v:Destroy()
		table.remove(possiblePositions, i)
	end
	
	for i, v in pairs(anotherRandomShop:GetChildren()) do
		if v.Name == "SurvivorPosition" then
			table.insert(possiblePositions, v)
		end
	end
	
	local randomIndex = math.random(1, #possiblePositions) --gets a position for the security guard to be
	local randomLocation = possiblePositions[randomIndex]
	
	MunsterMinus.ObjectivesList[2].loc = randomLocation.Parent.Name --updates the objective list based on this location and adds the security guard into the third objective
	MunsterMinus.ObjectivesList[3].Followers[1] = securityGuard
	
	securityGuard:PivotTo(randomLocation.CFrame) --slaps the security guard where he belongs
	securityGuard.HumanoidRootPart.Anchored = true
	randomLocation:Destroy()
	table.remove(possiblePositions, randomIndex)
	
	for i, v in possiblePositions do --gets rid of the other positions
		v:Destroy()
	end
	
	local armory = Mall.Shops:FindFirstChild("Armory")
	MunsterMinus.ObjectivesList[3].AreaLocations[1] = {Loc = armory.AreaZone.CFrame, Radius = armory.AreaZone.Size}
	
	StopLounging:Fire() --freezes all NPCs
	
	for _, player in Players:GetPlayers() do --puts the player in the first random shop
		player.Character:PivotTo(randomShop.PrimaryPart.CFrame * CFrame.new(0, 3.5, 0))
	end
	
	for i, v in pairs(Mall.Scenario.SpecialStuff:GetChildren()) do
		if v.Name == "HidingSpot" then
			v.ProximityPrompt.Enabled = true
		end
	end
	
	CutsceneManager:Fire({Camera = script.Cameras.MunsterPerspective.CFrame}) --makes the camera look at the stairs and the munster walks, faces the camera, and makes a funny noise
	
	NPCHandler.MoveToPoint(NewMunster, Vector3.new(101.1, 1.5, 163.9))
	
	NewMunster.Humanoid.RootPart.CFrame = CFrame.new(NewMunster.Humanoid.RootPart.Position, Vector3.new(script.Cameras.MunsterPerspective.Position.X, NewMunster.Humanoid.RootPart.Position.Y, script.Cameras.MunsterPerspective.Position.Z))
	
	NewMunster.Head.Roar:Play()
	
	wait(4)
	
	CutsceneManager:Fire({ResetEverything = 0}) --puts the camera back to normal
	
	task.spawn(function() --makes munster move around scarily. This is wrapped in a task.spawn so that the RunScript knows this function is done
		NPCHandler.MunsterAI(NewMunster)
	end)
end

return MunsterMinus