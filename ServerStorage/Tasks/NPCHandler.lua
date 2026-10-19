-- @ScriptType: ModuleScript
local NPCHandler = {}

local ServerStorage = game:GetService("ServerStorage") --TEST THIS STUFF PLEASE IT IS IN DIRE NEED OF TESTING
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
		if bondLevel == "Unbonded" then
			bondLevel = 0
			print("Bond level changed for the purpose of the objective.")
		end
		
		if CurrentObjective.Type == "AskAround" then
			NPCDialogue = require(ReplicatedStorage.NPCDialogue:FindFirstChild(NPCType.."Dialogue"))[RunData.Scenario][DialogueBreed][RunData.Objective][NPC:GetAttribute("InTheKnow")]
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
		if CurrentObjective.Type == "CollectItem" then
			if NPCType ~= "SecurityGuard" then
				--seems unfinished
			else
				DialogueBlock = NPCDialogue
			end
		elseif CurrentObjective.Type == "UnlockDoor" and CurrentObjective.KeyLoc == "NPC" then
			if NPCType ~= "SecurityGuard" then
				if NPC:HasTag("HasKey") then
					DialogueBlock = NPCDialogue.HasKey[bondLevel]
				else
					DialogueBlock = NPCDialogue.Else[bondLevel]
				end
			else
				DialogueBlock = NPCDialogue
			end
		elseif CurrentObjective.Type == "CollectItem" and CurrentObjective.ItemType == "NPC" then
			if NPCType ~= "SecurityGuard" then
				if NPC:HasTag(CurrentObjective.Item) then
					DialogueBlock = NPCDialogue.HasItem[bondLevel]
				else
					DialogueBlock = NPCDialogue.Else[bondLevel]
				end
			else
				if NPC:HasTag(CurrentObjective.Item) then
					DialogueBlock = NPCDialogue.HasItem
				else
					DialogueBlock = NPCDialogue.Else
				end
			end
		else
			if NPCType ~= "SecurityGuard" then
				DialogueBlock = NPCDialogue[bondLevel]
			else
				DialogueBlock = NPCDialogue
			end
		end
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
			
			if DialogueBlock[Current].Modifier then --if there is a string modifier, modifies the speech dialogue accordingly
				print("modifying string")
				local Speech = DialogueBlock[Current].Speech
				Speech = string.format(Speech, CurrentObjective[CurrentObjective.Modifier])
				DialogueUI.Speech.Text = Speech
			else
				DialogueUI.Speech.Text = DialogueBlock[Current].Speech
			end
			
			for i, v in Responses do
				local ResponseClone = ResponseUI:Clone() --Makes a response button for each response
				
				local content
				if DialogueBlock[Current].Modifier then --checks to makes sure the modifier isn't modifying the reseponse, but if it is modifies stuff cause yeah man
					content = string.format(v, CurrentObjective[CurrentObjective.Modifier])
				else
					content = v
				end
				
				ResponseClone.Text = content
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
		elseif DialogueBlock[Current].Type == "Next" then --simply displays the next speech content if there are no responses available
			if DialogueBlock[Current].Modifier then --if there is a string modifier, modifies the speech dialogue accordingly
				print("modifying string")
				local Speech = DialogueBlock[Current].Speech
				local Speech = DialogueBlock[Current].Speech
				Speech = string.format(Speech, CurrentObjective[CurrentObjective.Modifier])
				DialogueUI.Speech.Text = Speech
			else
				DialogueUI.Speech.Text = DialogueBlock[Current].Speech
			end
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
			
			if NPC:GetAttribute("InTheKnow") == "Knowledgeable" then --if the player just received objective information lets the handler know
				print("you found out information!!! Fire!!!")
				ObjectiveDialogue:Fire(NPC)
			elseif NPC:HasTag("NPCToFind") then
				print("you've just received critical information!!! Fire!!!")
				ObjectiveDialogue:Fire(NPC)
			elseif NPC:HasTag("HasKey") then
				if Consequence == 1 then
					print("you just got the key!!! great job buster!!!")
					ObjectiveDialogue:Fire(NPC)
				elseif Consequence == 0 then
					print("you'll have to try harder than that bucko")
				else
					print("looks like you just lost all hope of getting the key. When I'm not lazy I'll kick you from the game.")
				end
			elseif CurrentObjective.Item and NPC:HasTag(CurrentObjective.Item) then
				print("you just got another item!!!")
				ObjectiveDialogue:Fire(NPC)
			end
			
			DialogueUI.Enabled = false --disables everything and sets up for the next interaction
			player:SetAttribute("InDialogue", false)
			NPC:SetAttribute("InDialogue", false)
			NPC.HumanoidRootPart.Anchored = false
			connection:Disconnect()
			NPCRoot:SetNetworkOwner(nil) --double checks that the NPC's network owner is the server not the player
			Current = 0
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
				for _, waypoint in pairs(GigaPath:GetWaypoints()) do
					Humanoid:MoveTo(waypoint.Position)
					Humanoid.MoveToFinished:Wait()
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
