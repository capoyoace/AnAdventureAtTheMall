-- @ScriptType: ModuleScript
local BlackoutMinus = {}

local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ObjectiveHandler = require(ServerStorage.Tasks.ObjectiveHandler)

local CutsceneManager = ServerStorage.Events.CutsceneManager

BlackoutMinus.ObjectivesList = { --List of scenario objectives
	[1] = {Type = "AskAround", DisplayInfo = "Figure out what's going on. Asking around will help."},
	[2] = {Type = "LocateArea", DisplayInfo = "Check all of the exits... maybe there's one that isn't completely locked down.", Quantity = 5, Objects = {}, AreaLocations = {
		[1] = {Loc = CFrame.new(-206, 9, 163) * CFrame.fromEulerAnglesYXZ(0, math.rad(90), 0), Radius = Vector3.new(62, 16, 10)},
		[2] = {Loc = CFrame.new(122, 9, 84) * CFrame.fromEulerAnglesYXZ(0, math.rad(180), 0), Radius = Vector3.new(20, 16, 10)},
		[3] = {Loc = CFrame.new(122, 9, 244) * CFrame.fromEulerAnglesYXZ(0, math.rad(180), 0), Radius = Vector3.new(20, 16, 10)},
		[4] = {Loc = CFrame.new(14, 9, 393) * CFrame.fromEulerAnglesYXZ(0, math.rad(90), 0), Radius = Vector3.new(18, 16, 10)},
		[5] = {Loc = CFrame.new(-206, 9, 393) * CFrame.fromEulerAnglesYXZ(0, math.rad(90), 0), Radius = Vector3.new(18, 16, 10)},
	}},
	[3] = {Type = "FindNPC", DisplayInfo = "Find a security guard. Ask him what's up with this.", Specifications = {"NPCType", "SecurityGuard"}, loc = "", Modifier = "loc"},
	[4] = {Type = "LocateArea", DisplayInfo = "Locate the backup generator... the guard said it could be at the %s.", Quantity = 1, Modifier = "loc", loc = "", Objects = {}, AreaLocations = {
		[1] = {}
	}},
	[5] = {Type = "UnlockDoor", DisplayInfo = "Find a way to get into the %s.", Quantity = 1, Modifier = "loc", loc = "", Key = "", KeyLoc = "NPC"},
	[6] = {Type = "ActivateItem", DisplayInfo = "Trigger the backup generator.", Quantity = 1, Objects = {}},
	[7] = {Type = "CollectItem", DisplayInfo = "Ask around to see if anyone has any %ss they'd be willing to spare.", Quantity = 3, Modifier = "Item", Item = "", ItemType = "NPC"},
	[8] = {Type = "ActivateItem", DisplayInfo = "Install the %ss and trigger the backup generator.", Quantity = 4, Modifier = "Item", Item = "", Objects = {}},
	[9] = {Type = "FindNPC", DisplayInfo = "Uh... was something supposed to happen? Check with the security guard.", Specifications = {"NPCType", "SecurityGuard"}},
	[10] = {Type = "UnlockDoor", DisplayInfo = "Check each shop drawer for the master key... this will probably take a while.", Quantity = 1, Key = "MasterKey", KeyLoc = "Pickup"},
	[11] = {Type = "CollectItem", DisplayInfo = "Alright... now it's time to scrounge around for some extra %ss. The guard said they'd be anywhere from in between the stairs to up on the roof. Find them.", Quantity = 0, Modifier = "Item", Item = "", ItemType = "Pickup", Objects = {
		
	}},
	[12] = {Type = "ActivateItem", DisplayInfo = "Finally! Now all we have to do is activate the rest of the generators!!!", Quantity = 0, Objects = {}}
}

BlackoutMinus.ObjectiveInformation = {
	["Locations"] = {
		["-142.0, 2.5, 100.0"] = {Loc = CFrame.new(-122.016, 4.5, 107.878) * CFrame.fromEulerAnglesYXZ(0, math.rad(118.965), 0), Radius = Vector3.new(3, 7, 5.825)},
		["2.0, 2.5, 452.0"] = {Loc = CFrame.new(-69.5, 5, 452), Radius = Vector3.new(3, 8, 8)},
		["-190.0, 2.5, 452.0"] = {Loc = CFrame.new(-122.5, 5, 452), Radius = Vector3.new(3, 8, 8)},
		["-12.0, 33.0, 108.2"] = {Loc = CFrame.new(-51.949, 35.501, 111.782) * CFrame.fromEulerAnglesYXZ(0, math.rad(73.294), 0), Radius = Vector3.new(3, 8, 7.946)},
		["-179.0, 66.5, 93.0"] = {Loc = CFrame.new(-160.704, 36.501, 114.619) * CFrame.fromEulerAnglesYXZ(0, math.rad(109.747), 0), Radius = Vector3.new(3, 10, 8)},
		["-179.0, 66.5, 438.0"] = {Loc = CFrame.new(-160.704, 36.501, 114.619) * CFrame.fromEulerAnglesYXZ(0, math.rad(109.747), 0), Radius = Vector3.new(3, 10, 8)}
	}
}

BlackoutMinus.RandomItemsThatStartTheGeneratorForSomeReason = {"Potato", "Wrench", "Cheeseburger", "Small Child", "DVD player", "dictionary", "algorithm", "volts of lightning", "exploding frog", "peanut", "hamberder"}

BlackoutMinus.Setup = function(Mall)
	local ScenarioFolder = Mall.Scenario
	local NPCFolder = Mall.NPCs
	
	local PossibleGeneratorLocs = {}
	local PossibleCollectLocs = {}
	local PossibleKeyLocs = {}
	
	for i, v in pairs(CollectionService:GetTagged("PossibleLocation")) do --gets the possible generator locations
		if v.Name == "PossibleGeneratorLocation" then
			table.insert(PossibleGeneratorLocs, v)
		elseif v.Name == "PossibleCollectItem" then
			if not v:IsDescendantOf(game:GetService("ServerStorage")) then
				table.insert(PossibleCollectLocs, v)
			end
		elseif v.Name == "PossibleKeyLocation" then
			if not v:IsDescendantOf(game:GetService("ServerStorage")) then
				table.insert(PossibleKeyLocs, v)
			end
		end
	end
	
	local totalGenerators = math.random(3, 5)
	BlackoutMinus.ObjectivesList[11].Quantity = totalGenerators * 3
	BlackoutMinus.ObjectivesList[12].Quantity = totalGenerators + totalGenerators * 3
	
	for i = 1, totalGenerators + 1, 1 do --for each generator required (generated randomly above), adds a generator at one of the possible locations
		local randomNum = math.random(1, #PossibleGeneratorLocs) --gets random location, adds a generator, moves it there, and destroys the already used location
		local index = math.random(1, randomNum)
		local randomLoc = PossibleGeneratorLocs[index]
		local newGenerator = script.ScenarioObjects.Generator:Clone()
		newGenerator.Parent = ScenarioFolder.Objectives
		newGenerator:PivotTo(randomLoc.CFrame)
		newGenerator:SetAttribute("loc", randomLoc:GetAttribute("loc"))
		table.remove(PossibleGeneratorLocs, index)
		
		if #BlackoutMinus.ObjectivesList[6].Objects > 0 then --checks if there has already been a first generator assinged; if so, adds it to the other generators, and if not makes it the first generator
			table.insert(BlackoutMinus.ObjectivesList[12].Objects, newGenerator)
			newGenerator:SetAttribute("ObjectiveNumber", 12)
			
			newGenerator.Structure.Middle.ProximityPrompt:SetAttribute("Objective", 12)
			newGenerator.Structure.Middle.ProximityPrompt:SetAttribute("Dependency", newGenerator.Structure.Insertus.ProximityPrompt)
			newGenerator.Structure.Insertus.ProximityPrompt:SetAttribute("Objective", 12)
			
			newGenerator.Structure.Middle.ProximityPrompt.Triggered:Connect(function()
				newGenerator.Structure.BrokenLight.Lightpart.Material = Enum.Material.Plastic
				newGenerator.Structure.BrokenLight.Lightpart.PointLight.Enabled = false
				newGenerator.Structure.FunctionLight.Lightpart.Material = Enum.Material.Neon
				newGenerator.Structure.FunctionLight.Lightpart.PointLight.Enabled = true
				newGenerator.Structure.Top.PowerOn:Play()
			end)
		else
			print(newGenerator.WorldPivot.Position)
			local str1 = string.format("%.1f", newGenerator.WorldPivot.Position.X)
			local str2 = string.format("%.1f", newGenerator.WorldPivot.Position.Y)
			local str3 = string.format("%.1f", newGenerator.WorldPivot.Position.Z)
			local str = str1..", "..str2..", "..str3
			print(str)
			
			table.insert(BlackoutMinus.ObjectivesList[6].Objects, newGenerator)
			BlackoutMinus.ObjectivesList[3].loc = newGenerator:GetAttribute("loc")
			BlackoutMinus.ObjectivesList[4].AreaLocations[1] = BlackoutMinus.ObjectiveInformation.Locations[str]
			BlackoutMinus.ObjectivesList[4].loc = newGenerator:GetAttribute("loc")
			BlackoutMinus.ObjectivesList[5].loc = newGenerator:GetAttribute("loc")
			
			if randomLoc:GetAttribute("loc") == "downstairs maintenance room" then --sets the key the player needs to find
				BlackoutMinus.ObjectivesList[5].Key = "MaintenanceKey"..tostring(randomLoc:GetAttribute("Identifier"))
			elseif randomLoc:GetAttribute("loc") == "upstairs maintenance room" then
				BlackoutMinus.ObjectivesList[5].Key = "MaintenanceKey4"
			else
				BlackoutMinus.ObjectivesList[5].Key = "RoofKey"
			end
			
			newGenerator:SetAttribute("ObjectiveNumber", 6)
			newGenerator.Structure.Middle.ProximityPrompt:SetAttribute("Objective", 6)
			newGenerator.Structure.Insertus.ProximityPrompt:SetAttribute("Objective", 8)
			
			newGenerator.Structure.Middle.ProximityPrompt.Triggered:Connect(function()
				if _G.PlayersData.RunInformation.Objective == 6 then
					newGenerator:SetAttribute("ObjectiveNumber", 8) --test this bad boy out dudeeee
					newGenerator.Structure.Middle.ProximityPrompt:SetAttribute("Objective", 8)
					newGenerator.Structure.Middle.ProximityPrompt:SetAttribute("Dependency", newGenerator.Structure.Insertus.ProximityPrompt)
					newGenerator.Structure.Middle.ProximityPrompt:SetAttribute("Uses", 1)
				elseif _G.PlayersData.RunInformation.Objective == 8 then
					newGenerator.Structure.BrokenLight.Lightpart.Material = Enum.Material.Plastic
					newGenerator.Structure.BrokenLight.Lightpart.PointLight.Enabled = false
					newGenerator.Structure.FunctionLight.Lightpart.Material = Enum.Material.Neon
					newGenerator.Structure.FunctionLight.Lightpart.PointLight.Enabled = true
					newGenerator.Structure.Top.PowerOn:Play()
				end
			end)
		end
		
		randomLoc:Destroy() --destroys this here so that information it possesses can be completely extracted
	end
	
	local randomKeyLoc = PossibleKeyLocs[math.random(1, #PossibleKeyLocs)]
	local newKey = script.ScenarioObjects.MasterKey:Clone()
	newKey.Parent = Mall.Scenario.Objectives
	newKey:PivotTo(randomKeyLoc.CFrame)
	
	BlackoutMinus.ObjectivesList[7].Item = BlackoutMinus.RandomItemsThatStartTheGeneratorForSomeReason[math.random(1, #BlackoutMinus.RandomItemsThatStartTheGeneratorForSomeReason)] --grabs a random item from the table
	BlackoutMinus.ObjectivesList[8].Item = BlackoutMinus.ObjectivesList[7].Item
	BlackoutMinus.ObjectivesList[11].Item = BlackoutMinus.ObjectivesList[7].Item
	
	for i = 1, BlackoutMinus.ObjectivesList[11].Quantity, 1 do
		local item = BlackoutMinus.ObjectivesList[7].Item

		local randomNum = math.random(1, #PossibleCollectLocs)
		local randomLoc = PossibleCollectLocs[randomNum]
		local newItem = script.ScenarioObjects.Items:FindFirstChild(item):Clone()
		newItem.Parent = ScenarioFolder.Objectives
		newItem:PivotTo(randomLoc.CFrame)
		newItem:SetAttribute("ObjectiveNumber", 11)
		randomLoc:Destroy()
		table.remove(PossibleCollectLocs, randomNum)
		table.insert(BlackoutMinus.ObjectivesList[11].Objects, newItem)
	end
	
	for _, v in pairs(PossibleGeneratorLocs) do --gets rid of the other location parts so the player doesn't just come across a box and get really confused
		v:Destroy()
	end
	
	for _, v in pairs(PossibleCollectLocs) do
		v:Destroy()
	end
	
	for _, v in pairs(PossibleKeyLocs) do
		v:Destroy()
	end
end

BlackoutMinus.Trigger = function(Mall) --makes lights turn out and doors slam and also centers players into the middle of the mall
	CutsceneManager:Fire({Camera = script.Cameras.BlackoutPerspective.CFrame})
	
	for _, player in Players:GetPlayers() do
		player.Character:PivotTo(CFrame.new(-97.9, 4.1, 164.6))
	end
	
	task.wait(1)
	
	local BlackoutSound = script.ScenarioObjects.BlackoutSound
	BlackoutSound.Parent = game:GetService("SoundService")
	BlackoutSound:Play()
	task.wait(0.5)
	
	for i, v in pairs(Mall.Structure.Lighting:GetChildren()) do
		v.SpotLight.Enabled = false
	end
	
	task.wait(3)
	
	CutsceneManager:Fire({Camera = script.Cameras.ExitShutPerspective.CFrame})
	
	task.wait(1)
	
	local DoorSlamSound = script.ScenarioObjects.DoorSound
	DoorSlamSound.Parent = game:GetService("SoundService")
	DoorSlamSound:Play()
	task.wait(0.5)
	
	for i, v in pairs(Mall.Structure.ExitBlocks:GetChildren()) do
		v.Transparency = 0
		v.CanCollide = true
	end
	
	task.wait(2)
	
	CutsceneManager:Fire({ResetEverything = "ResetEverything"})
end

return BlackoutMinus
