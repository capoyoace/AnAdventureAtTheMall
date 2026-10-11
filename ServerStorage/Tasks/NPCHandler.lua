-- @ScriptType: ModuleScript
local NPCHandler = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")

local ObjectiveDialogue = ServerStorage.Events.ObjectiveDialogue

local Response = script.Response

NPCHandler.Talk = function(player : Player, NPC, bondLevel) --Handles talking to NPCs
	local NPCType = NPC:GetAttribute("NPCType") --Variables
	local DialogueBreed = NPC:GetAttribute("DialogueBreed")
	local NPCDialogue
	
	local RunData = _G.PlayersData.RunInformation
	local CurrentObjective = require(ServerStorage.Scenarios:FindFirstChild(RunData.Scenario)).ObjectivesList[RunData.Objective]
	
	if game:GetAttribute("ScenarioStarted") == false then --gets dialogue based on whether or not the scenario has started or not
		NPCDialogue = require(ReplicatedStorage.NPCDialogue:FindFirstChild(NPCType.."Dialogue")).PreScenario[DialogueBreed]
	else
		if CurrentObjective.Type == "AskAround" then
			NPCDialogue = require(ReplicatedStorage.NPCDialogue:FindFirstChild(NPCType.."Dialogue"))[RunData.Scenario][DialogueBreed][RunData.Objective][NPC:GetAttribute("InTheKnow")]
			if bondLevel == "Unbonded" then
				bondLevel = 0
				print("Bond level changed for the purpose of the objective.")
			end
		else
			NPCDialogue = require(ReplicatedStorage.NPCDialogue:FindFirstChild(NPCType.."Dialogue"))[RunData.Scenario][DialogueBreed][RunData.Objective]
		end
	end
	
	local PlayerGui = player.PlayerGui
	local DialogueUI = PlayerGui.NPCDialogue
	local ResponseUI = script.Response
	
	local Current = 0
	local DialogueBlock
	
	if game:GetAttribute("ScenarioStarted") == false then --checks which dialogue block the script should pull from
		if bondLevel == "Unbondable" then --these are the settings during the pre-scenario
			DialogueBlock = NPCDialogue
		elseif bondLevel == "Unbonded" then
			DialogueBlock = NPCDialogue.Unbonded
		else
			DialogueBlock = NPCDialogue.Bonded[bondLevel]
		end
	else --these are the settings during the scenario
		DialogueBlock = NPCDialogue[bondLevel]
	end
	
	DialogueUI.Enabled = true --displays dialogue UI
	player:SetAttribute("InDialogue", true)
	NPC:SetAttribute("InDialogue", true)
	
	local NPCRoot = NPC.HumanoidRootPart
	local playerRoot = player.Character.HumanoidRootPart
	
	NPCRoot.Anchored = true --freezes the NPC in place and makes it and the player turn towards each other
	local NPCstraight = Vector3.new(playerRoot.Position.X, NPCRoot.Position.Y, playerRoot.Position.Z)
	local playerStraight = Vector3.new(NPCRoot.Position.X, playerRoot.Position.Y, NPCRoot.Position.Z)
	NPCRoot.CFrame = CFrame.new(NPCRoot.Position, NPCstraight)
	playerRoot.CFrame = CFrame.new(playerRoot.Position, playerStraight)
	
	local function Proceed() --Function to advance dialogue
		Current += 1
		if DialogueBlock[Current].Type == "Respond" then --Checks what type the dialogue is
			local Responses = DialogueBlock[Current].Responses --Gets the responses
			DialogueUI.Responses.Visible = true
			DialogueUI.NextButton.Visible = false
			
			DialogueUI.Speech.Text = DialogueBlock[Current].Speech
			
			for i, v in Responses do
				local ResponseClone = ResponseUI:Clone() --Makes a response button for each response
				ResponseClone.Text = v
				ResponseClone.Parent = DialogueUI.Responses
				ResponseClone.Visible = true
				
				ResponseClone.MouseButton1Up:Connect(function()
					for i, v in DialogueUI.Responses:GetChildren() do --when the response button is clicked, deletes all of the buttons and hides response UI
						if v:IsA("TextButton") then
							v:Destroy()
						end
					end
					DialogueUI.Responses.Visible = false
					DialogueUI.NextButton.Visible = true
					
					local NextDialogue = Current - 1
					while true do --checks which dialogue should be displayed next, depending on the response chosen
						NextDialogue += 1
						if DialogueBlock[NextDialogue].Index == i then
							Current = NextDialogue - 1
							break
						end
					end
					
					Proceed() --advances dialogue
				end)
			end
		elseif DialogueBlock[Current].Type == "Next" then
			DialogueUI.Speech.Text = DialogueBlock[Current].Speech --simply displays the next speech content if there are no responses available
		else
			local Consequence = DialogueBlock[Current].Consequence --if the dialogue has come to a close, calculates the consequence in relationship from that conversation
			if game:GetAttribute("ScenarioStarted") == false then --makes sure that the scenario isn't going on before changing bond level; once the scenario starts, you can't bond with NPCs
				if bondLevel ~= "Unbondable" then
					if bondLevel ~= "Unbonded" then
						bondLevel += Consequence
						_G.PlayersData.Data[player.Name].NPCRelationships[NPC.Name] = bondLevel
					else
						_G.PlayersData.Data[player.Name].NPCRelationships[NPC.Name] = Consequence --if they haven't bonded before this, sets their initial bond level
					end
				end
			end
			
			if NPC:GetAttribute("InTheKnow") == "Knowledgable" then --if the player just received objective information lets the handler know
				ObjectiveDialogue:Fire(NPC)
			end
			
			DialogueUI.Enabled = false --disables everything and sets up for the next interaction
			player:SetAttribute("InDialogue", false)
			NPC:SetAttribute("InDialogue", false)
			NPC.HumanoidRootPart.Anchored = false
			connection:Disconnect()
			NPCRoot:SetNetworkOwner(nil) --double checks that the NPC's network owner is the server not the player
			wait(2)
			NPC.Torso.ProximityPrompt.Enabled = true
		end
	end
	
	connection = DialogueUI.NextButton.MouseButton1Up:Connect(Proceed)
	Proceed()
end

NPCHandler.Lounge = function(NPC) --Handles NPC moving around the mall
	local Mall = workspace.Mall
	local Paths = Mall.Paths
	
	local upCost = 1
	local downCost = 1
	if NPC.Humanoid.RootPart.Position.Y > 15 then --makes sure the NPC avoids using improper escalators depending on which floor its on
		upCost = 10
	else
		downCost = 10
	end
	
	local GigaPath = PathfindingService:CreatePath({AgentCanJump = false, AgentRadius = 3, Costs = {Up = upCost, Down = downCost}})
	
	local Humanoid = NPC.Humanoid :: Humanoid
	
	local function pickPath() --picks a random path from the paths folder
		local randomPath = Paths:GetChildren()[math.random(1, #Paths:GetChildren())]
		return randomPath
	end
	
	local function walkPath()
		local path = pickPath() --gets random path
		
		for i = 1, #path:GetChildren(), 1 do --loops through the waypoints in the path, making sure the NPC reaches the waypoint after the default 8 seconds ends
			local WayPoint = path:FindFirstChild("Point"..tostring(i))
			
			local success, Error = pcall(function()
				GigaPath:ComputeAsync(Humanoid.RootPart.Position, WayPoint.Position)
			end)
			
			if success then
				for potato, waypoint in pairs(GigaPath:GetWaypoints()) do
					local part = Instance.new("Part", workspace)
					part.Name = potato
					part.Size = Vector3.new(1, 1, 1)
					part.Transparency = 0.5
					part.CanCollide = false
					part.Anchored = true
					part.Position = waypoint.Position
				end
				
				for potato, waypoint in pairs(GigaPath:GetWaypoints()) do
					Humanoid:MoveTo(waypoint.Position)
					Humanoid.MoveToFinished:Wait()
					workspace:FindFirstChild(potato):Destroy()
					if NPC:GetAttribute("InDialogue") == true then --checks if the NPC is in dialogue or not
						while NPC:GetAttribute("InDialogue") == true do
							task.wait()
						end
						print("you've stopped yapping, congratulations!!!")
					end
				end
			else
				warn(Error)
			end
			
			print("proceeding")
		end
	end
	
	while true do
		walkPath()
	end
end

return NPCHandler
