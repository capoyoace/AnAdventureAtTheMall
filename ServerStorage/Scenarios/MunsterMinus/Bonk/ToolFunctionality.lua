-- @ScriptType: Script
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")

local hitMunster = ServerStorage.Tasks.NPCHandler.CustomizableEvent

local tool = script.Parent

local character
local player

local swingTrack
local whackSound = tool.Handle.Whack
local swingSound = tool.Handle.Swang

local debounce = false
local isSwingin = false
local soundDebounce = false
local eventDebounce = false

tool.Equipped:Connect(function()
	character = tool.Parent
	player = Players:GetPlayerFromCharacter(character)
	
	swingTrack = character.Humanoid.Animator:LoadAnimation(script.Swang) :: AnimationTrack
end)

local hitbox = Instance.new("Part")
hitbox.Size = Vector3.new(4, 5, 10)
hitbox.CanCollide = false
hitbox.Transparency = 0.9
hitbox.Massless = true

tool.Activated:Connect(function()
	if not debounce then
		debounce = true
		isSwingin = true
		
		swingTrack:Play()
		swingTrack:GetMarkerReachedSignal("Swang"):Connect(function()
			swingSound:Play()
		end)
		
		local newBox = hitbox:Clone()
		local newWeld = Instance.new("WeldConstraint", newBox)
		newWeld.Part0 = tool.Handle
		newBox.CFrame = character.PrimaryPart.CFrame * CFrame.new(0, 0, -6)
		newWeld.Part1 = newBox
		newBox.Parent = tool
		Debris:AddItem(newBox, 0.5)
		
		newBox.Touched:Connect(function(touchThing)
			if touchThing.Parent ~= character and isSwingin and not soundDebounce then
				whackSound:Play()
				soundDebounce = true
			end
			
			if touchThing.Parent.Name == "Munster" and not eventDebounce then
				print("glasp I've struck the munster!!!!")
				hitMunster:Fire("HitMunster", player)
				eventDebounce = true
				
				task.spawn(function()
					task.wait(10)
					eventDebounce = false
				end)
			end
		end)
		
		swingTrack.Ended:Wait()
		isSwingin = false
		
		wait(1)
		debounce = false
		soundDebounce = false
	end
end)