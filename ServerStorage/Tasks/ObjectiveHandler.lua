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
				v:FindFirstChild("ProximityPrompt").Enabled = true
				
				v.ProximityPrompt.Triggered:Connect(function()
					Completed += 1
					if Completed == Objective.Quantity then
						CompleteObjective:Fire(Number)
						v.ProximityPrompt.Enabled = false
					end
				end)
			end
		end
	elseif Objective.Type == "CollectItem" then
		for i, v in pairs(Mall:GetDescendants()) do
			if v:GetAttribute("ObjectiveNumber") == Number then
				local touchDebounce = false
				
				local touchFunction = function(hit)
					local player = Players:GetPlayerFromCharacter(hit.Parent)
					if player and not touchDebounce then
						touchDebounce = true
						Completed += 1
						if Completed == Objective.Quantity then
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
				
				if v:IsA("Model") then
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
	elseif Objective.Type == "AskAround" then
		local eligibleNPCs = {}
		
		for i, NPC in pairs(Mall.NPCs:GetChildren()) do
			if NPC:GetAttribute("NPCType") == "Shopper" then
				NPC:SetAttribute("InTheKnow", "Clueless")
				table.insert(eligibleNPCs, NPC)
			end
		end
		
		task.spawn(function()
			while true do
				local randomNPC
				while true do
					randomNPC = eligibleNPCs[math.random(1, #eligibleNPCs)]
					if randomNPC:GetAttribute("InTheKnow") == "Clueless" then
						break
					end
				end

				randomNPC:SetAttribute("InTheKnow", "Knowledgeable")

				task.wait(math.random(30, 120))
			end
		end)
		
		local connection = ObjectiveDialogue.Event:Connect(function(NPC)
			if NPC:GetAttribute("InTheKnow") == "Knowledgable" then
				CompleteObjective:Fire(Number)
			end
		end)
	else
		warn("Objective type "..Objective.Type.." not found. Did you spell it correctly or implement it?") --warns me if the objective type wasn't found so I know something ain't working properly...
	end
	
	for _, player in pairs(Players:GetPlayers()) do --informs all clients what to do
		UpdateObjective:FireClient(player, Objective, Number, 0) 
	end
end

return Objectives