-- @ScriptType: Script
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")

local NPCHandler = require(ServerStorage.Tasks.NPCHandler)

local Mall = game.Workspace.Mall
local NPCs = Mall.NPCs

local FreezePlayer = ReplicatedStorage.Remotes.FreezePlayer

local NPCFolder = ServerStorage.NPCs

local ShopperCount = 10

PhysicsService:RegisterCollisionGroup("NPCs") --sets the NPCs so they can't collide with one another
PhysicsService:CollisionGroupSetCollidable("NPCs", "NPCs", false)

local Shoppers = NPCFolder.Shopper:GetChildren()
for i = 0, ShopperCount, 1 do --randomly spawns the specified amount of NPCs into the mall
	local randomIndex = math.random(1, #Shoppers)
	local randomShopper = Shoppers[randomIndex]
	
	local rootPos = Mall.Paths["Path"..math.random(1, #Mall.Paths:GetChildren())]
	local position = rootPos["Point"..math.random(1, #rootPos:GetChildren())]
	
	randomShopper.Parent = NPCs
	randomShopper:PivotTo(position.CFrame)
	table.remove(Shoppers, randomIndex)
end

task.wait(0.5)

for i, v in NPCs:GetChildren() do
	local NPC = v
	local root = NPC.Humanoid.RootPart :: BasePart
	
	for _, part in ipairs(NPC:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CollisionGroup = "NPCs"
		end
	end
	
	root:SetNetworkOwner(nil) --makes sure the NPC isn't moving all glitchy by setting its network owner to the server
	
	if NPC:GetAttribute("Behavior") == "Lounging" then --if the NPC is supposed to lounge, triggers that behavior
		task.spawn(function()
			NPCHandler.Lounge(NPC)
		end)
	end
	
	NPC.Torso.ProximityPrompt.Triggered:Connect(function(player) --handles speaking with the NPC
		if player:GetAttribute("InDialogue") == false then
			local playerData = _G.PlayersData.Data[player.Name].NPCRelationships

			NPC.Torso.ProximityPrompt.Enabled = false --makes sure nobody else can start a conversation with this guy too

			local bondLevel

			if NPC:GetAttribute("NPCType") == "SecurityGuard" then --sets the bond level of the NPC
				bondLevel = "Unbondable"
			elseif not playerData[NPC.Name] then
				playerData[NPC.Name] = 0
				bondLevel = "Unbonded"
			else
				bondLevel = playerData[NPC.Name]
			end

			NPCHandler.Talk(player, NPC, bondLevel) --uses the NPC module to handle dialogue
		end
	end)
end