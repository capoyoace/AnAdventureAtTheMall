-- @ScriptType: ModuleScript
local Objectives = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UpdateObjective = ReplicatedStorage.Remotes.UpdateObjective
local CompleteObjective = ServerStorage.Events.CompleteObjective
local ObjectiveDialogue = ServerStorage.Events.ObjectiveDialogue

local Mall = workspace.Mall

Objectives.StartObjective = function(Number, Objective)
	local Completed = 0
	
	--Figures out what the objective is asking for--
	if Objective.Type == "ActivateItem" then --If the objective wants you to activate an item makes sure that item can be activated
		for i, v in pairs(Mall:GetDescendants()) do
			if v:GetAttribute("ObjectiveNumber") == Number then
				local Prompt = v:FindFirstChild("ProximityPrompt", true)
				Prompt.Enabled = true
				
				Prompt.Triggered:Connect(function()
					Completed += 1
					if Completed == Objective.Quantity then
						CompleteObjective:Fire(Number)
						Prompt.Enabled = false
					end
				end)
			end
		end
	elseif Objective.Type == "CollectItem" then --if the objective needs you to collect an item handles that process
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
				elseif Objective.ItemType == "NPC" then
					local EligibleNPCS = Mall.NPCs:GetChildren()
					
					for i = 1, Objective.Quantity, 1 do
						local randomNPC = EligibleNPCS[math.random(1, #EligibleNPCS)]
						randomNPC:AddTag(Objective.Item)
					end
					
					local connection = ObjectiveDialogue.Event:Connect(function(NPC)
						if NPC:HasTag(Objective.Item) then
							NPC:RemoveTag(Objective.Item)
							Completed += 1
							if Completed >= Objective.Quantity then
								CompleteObjective:Fire(Number)
							else
								for _, plr in Players:GetPlayers() do
									UpdateObjective:FireClient(plr, Objective, Number, Completed)
								end
							end
						end
					end)
				end
			end
		end
	elseif Objective.Type == "AskAround" then --if you need information from an NPC handles that
		local eligibleNPCs = {}
		
		for i, NPC in pairs(Mall.NPCs:GetChildren()) do --gets all of the NPCs and makes them clueless lol
			if NPC:GetAttribute("NPCType") == "Shopper" then
				NPC:SetAttribute("InTheKnow", "Clueless")
				table.insert(eligibleNPCs, NPC)
			end
		end
		
		task.spawn(function()
			while true do --gets a random clueless NPC
				local randomNum = math.random(1, #eligibleNPCs)
				local randomNPC = eligibleNPCs[randomNum]
				randomNPC:SetAttribute("InTheKnow", "Knowledgeable") --blesses the clueless NPC with knowledge
				table.remove(eligibleNPCs, randomNum)
				
				if #eligibleNPCs <= 0 then break end --once all of the NPCs are knowledgeable, quits out of this function

				task.wait(math.random(30, 120)) --slowly waits to make more NPCs knowledgeable
			end
		end)
		
		local connection = ObjectiveDialogue.Event:Connect(function(NPC) --once the player receives the knowledge, updates the objective
			if NPC:GetAttribute("InTheKnow") == "Knowledgeable" then
				CompleteObjective:Fire(Number)
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
				if v:GetAttribute("NPCType") == Specs[2] then
					table.insert(EligibleNPCs, v)
				end
			end
			
			local randomNPC = EligibleNPCs[math.random(1, #EligibleNPCs)]
			randomNPC:AddTag("NPCToFind")
		end
		
		local connection = ObjectiveDialogue.Event:Connect(function(NPC) --once they find that NPC updates the objective
			if NPC:HasTag("NPCToFind") then
				NPC:RemoveTag("NPCToFind")
				CompleteObjective:Fire(Number)
			end
		end)
	elseif Objective.Type == "UnlockDoor" then --if the player needs to unlock a door handles that
		if Objective.KeyLoc == "NPC" then
			local EligibleNPCs = {}
			
			for i, v in Mall.NPCs:GetChildren() do
				if v:GetAttribute("NPCType") ~= "SecurityGuard" then
					table.insert(EligibleNPCs, v)
				end
			end
			
			local randomNPC = EligibleNPCs[math.random(1, #EligibleNPCs)]
			randomNPC:AddTag("HasKey") --gifts a random NPC the key
			
			local connection = ObjectiveDialogue.Event:Connect(function(NPC)
				if NPC:HasTag("HasKey") then --once the player robs that NPC of the key updates the objective
					NPC:RemoveTag("HasKey")
					
					for _, player in Players:GetPlayers() do
						player:SetAttribute("Key", Objective.Key)
					end
					
					CompleteObjective:Fire(Number)
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