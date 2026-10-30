-- @ScriptType: ModuleScript
local Objectives = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local UpdateObjective = ReplicatedStorage.Remotes.UpdateObjective
local CompleteObjective = ServerStorage.Events.CompleteObjective
local ObjectiveDialogue = ServerStorage.Events.ObjectiveDialogue

local Mall = workspace.Mall

for i, v in pairs(workspace:GetChildren()) do
	if v.Name:find("Shop") then
		for j, k in pairs(v:GetChildren()) do
			for r, m in pairs(k:GetChildren()) do
				if m.Name == "AreaZone" then
					m.Transparency = 1
				end
			end
		end
	end
end

Objectives.StartObjective = function(Number, Objective)
	local Completed = 0
	
	--Figures out what the objective is asking for--
	if Objective.Type == "ActivateItem" then --If the objective wants you to activate an item makes sure that item can be activated
		local Prompts = CollectionService:GetTagged("Prompts")
		local connections = {}
		
		for _, Prompt in Prompts do
			print(Number)
			if Prompt:GetAttribute("Objective") == Number then
				if not Prompt:GetAttribute("Dependency") then
					Prompt.Enabled = true
				end

				local connection = Prompt.Triggered:Connect(function() --creates a connection for each prompt
					warn("Triggered!!!!")
					Completed += 1
					if Completed == Objective.Quantity then --once you reach the requirement, tells the other script and disconnects all other prompt connections
						CompleteObjective:Fire(Number)

						for i, v in connections do
							v:Disconnect()
						end
						table.clear(connections)
					else
						for _, plr in Players:GetPlayers() do
							UpdateObjective:FireClient(plr, Objective, Number, Completed)
						end
					end

					Prompt:SetAttribute("Uses", Prompt:GetAttribute("Uses") - 1)
					if Prompt:GetAttribute("Uses") <= 0 then
						Prompt.Enabled = false

						for i, v in Prompts do
							local dependency = v:GetAttribute("Dependency")
							if dependency and dependency:Get() == Prompt then
								print("found dependent prompt")
								v.Enabled = true
							end
						end
					end
				end)

				table.insert(connections, connection)
			end
		end
	elseif Objective.Type == "CollectItem" then --if the objective needs you to collect an item handles that process
		if Objective.ItemType == "Pickup" then
			for i, v in pairs(Mall:GetDescendants()) do
				if v:GetAttribute("ObjectiveNumber") == Number then
					if Objective.ItemType == "Pickup" then
						local touchDebounce = false --a touch debounce so one item doesn't increase your goal by like 80

						local touchFunction = function(hit) --whenever you touch one of the items you need increases your count by 1 and destroys the item
							local player = Players:GetPlayerFromCharacter(hit.Parent)
							if player and not touchDebounce then
								touchDebounce = true
								Completed += 1
								if Completed == Objective.Quantity then --depending on how many items the player has, either updates the objective or the count
									CompleteObjective:Fire(Number)
								else
									for _, plr in Players:GetPlayers() do
										UpdateObjective:FireClient(plr, Objective, Number, Completed)
									end
								end

								v:Destroy()

								wait(0.5)
								touchDebounce = true
							end
						end

						if v:IsA("Model") then --deals with models vs just regular old parts
							v.PrimaryPart.Touched:Connect(function(hit)
								touchFunction(hit)
							end)
						else
							v.Touched:Connect(function(hit)
								touchFunction(hit)
							end)
						end
					end
				end
			end
		elseif Objective.ItemType == "NPC" then
			print("This exists")
			local EligibleNPCS = Mall.NPCs:GetChildren() --gets all eligible NPCs which so happens to be all of them
			print(#EligibleNPCS)

			for i = 1, Objective.Quantity, 1 do --cycles through the eligible NPCs and randomly distributes the item among them
				local randomIndex = math.random(1, #EligibleNPCS)
				local randomNPC = EligibleNPCS[randomIndex]
				print(randomNPC.Name)
				randomNPC:AddTag(Objective.Item)
				table.remove(EligibleNPCS, randomIndex)
			end

			connection = ObjectiveDialogue.Event:Connect(function(NPC) --when a player successfully gets an item from an NPC, adds that to their total
				if NPC:HasTag(Objective.Item) then
					NPC:RemoveTag(Objective.Item)
					Completed += 1
					if Completed >= Objective.Quantity then
						CompleteObjective:Fire(Number)
						connection:Disconnect()
					else
						for _, plr in Players:GetPlayers() do
							UpdateObjective:FireClient(plr, Objective, Number, Completed)
						end
					end
				end
			end)
		end
	elseif Objective.Type == "AskAround" then --if you need information from an NPC handles that
		local eligibleNPCs = {}
		local objectiveWon = false
		
		for i, NPC in pairs(Mall.NPCs:GetChildren()) do --gets all of the NPCs and makes them clueless lol
			if NPC:GetAttribute("NPCType") == "Shopper" then
				NPC:SetAttribute("InTheKnow", "Clueless")
				table.insert(eligibleNPCs, NPC)
			end
		end
		
		task.spawn(function()
			while not objectiveWon do --gets a random clueless NPC
				local randomNum = math.random(1, #eligibleNPCs)
				local randomNPC = eligibleNPCs[randomNum]
				randomNPC:SetAttribute("InTheKnow", "Knowledgeable") --blesses the clueless NPC with knowledge
				table.remove(eligibleNPCs, randomNum)
				
				if #eligibleNPCs <= 0 then break end --once all of the NPCs are knowledgeable, quits out of this function

				task.wait(math.random(30, 120)) --slowly waits to make more NPCs knowledgeable
			end
		end)
		
		connection = ObjectiveDialogue.Event:Connect(function(NPC) --once the player receives the knowledge, updates the objective
			if NPC:GetAttribute("InTheKnow") == "Knowledgeable" then
				
				for i, v in Mall.NPCs:GetChildren() do --resets all of the NPCs knowledge status
					if v:GetAttribute("InTheKnow") then
						v:SetAttribute("InTheKnow", nil)
					end
				end
				
				CompleteObjective:Fire(Number)
				print(Number)
				connection:Disconnect()
				objectiveWon = true
			end
		end)
	elseif Objective.Type == "LocateArea" then --if the player needs to find a certain area handles that
		for i, v in Objective.AreaLocations do --makes a part for each area the player needs to find
			local newRadius = Instance.new("Part", Mall.Scenario.Objectives)
			newRadius.CFrame = v.Loc
			newRadius.Size = v.Radius
			newRadius.Anchored = true
			newRadius.CanCollide = false
			newRadius.Transparency = 1
			Objective.Objects[i] = newRadius
		end
		
		for i, v in Objective.Objects do
			local debounce = false --makes sure that when the player finds one area they don't find them all
			
			v.Touched:Connect(function(hit) --whenever an area is found updates the count and, once they've found them all, updates the objective
				if Players:GetPlayerFromCharacter(hit.Parent) and debounce == false then
					debounce = true
					v:Destroy()
					table.remove(Objective.Objects, i)
					Completed += 1
					if Completed >= Objective.Quantity then
						CompleteObjective:Fire(Number)
					else
						for _, plr in Players:GetPlayers() do
							UpdateObjective:FireClient(plr, Objective, Number, Completed)
						end
					end
					task.wait(0.5)
					debounce = true
				end
			end)
		end
	elseif Objective.Type == "FindNPC" then --if the player needs to find a certain NPC handles that
		local Specs = Objective.Specifications
		if Specs[1] == "SpecificNPC" then --Tags the NPC in question
			--find the specific NPC here
		elseif Specs[1] == "NPCType" then
			local EligibleNPCs = {}
			
			for i, v in Mall.NPCs:GetChildren() do
				if v:GetAttribute("NPCType") == Specs[2] or Specs[2] == "Any" then
					table.insert(EligibleNPCs, v)
				end
			end
			
			local randomNPC = EligibleNPCs[math.random(1, #EligibleNPCs)]
			randomNPC:AddTag("NPCToFind")
		end
		
		connection = ObjectiveDialogue.Event:Connect(function(NPC) --once they find that NPC updates the objective
			if NPC:HasTag("NPCToFind") then
				NPC:RemoveTag("NPCToFind")
				CompleteObjective:Fire(Number)
				connection:Disconnect()
			end
		end)
	elseif Objective.Type == "UnlockDoor" then --if the player needs to unlock a door handles that
		if Objective.KeyLoc == "NPC" then --checks what method they need to get the key
			local EligibleNPCs = {}
			
			for i, v in Mall.NPCs:GetChildren() do
				if v:GetAttribute("NPCType") ~= "SecurityGuard" then
					table.insert(EligibleNPCs, v)
				end
			end
			
			local randomNPC = EligibleNPCs[math.random(1, #EligibleNPCs)]
			randomNPC:AddTag("HasKey") --gifts a random NPC the key
			
			connection = ObjectiveDialogue.Event:Connect(function(NPC)
				if NPC:HasTag("HasKey") then --once the player robs that NPC of the key updates the objective
					NPC:RemoveTag("HasKey")
					
					for _, player in Players:GetPlayers() do
						player:SetAttribute("Key", Objective.Key)
					end
					
					CompleteObjective:Fire(Number)
					connection:Disconnect()
				end
			end)
		elseif Objective.KeyLoc == "Pickup" then
			local KeyObject = Mall.Scenario.Objectives:FindFirstChild(Objective.Key) :: Model --gets the key object
			
			KeyObject.PrimaryPart.Touched:Connect(function(hit) --checks when the key is touched by the player and awards them it
				if Players:GetPlayerFromCharacter(hit.Parent) then
					for _, player in Players:GetPlayers() do
						player:SetAttribute("Key", Objective.Key)
						KeyObject:Destroy()
						CompleteObjective:Fire(Number)
					end
				end
			end)
		end
	else
		warn("Objective type "..Objective.Type.." not found. Did you spell it correctly or implement it?") --warns me if the objective type wasn't found so I know something ain't working properly...
	end
	
	for _, player in pairs(Players:GetPlayers()) do --informs all clients what to do
		UpdateObjective:FireClient(player, Objective, Number, 0) 
	end
end

return Objectives