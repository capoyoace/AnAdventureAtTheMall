-- @ScriptType: Script
local Players = game:GetService("Players")

local tool = script.Parent

local character
local player

local swingTrack
local whackSound = tool.Handle.Whack
local swingSound = tool.Handle.Swang

local debounce = false
local isSwingin = false
local soundDebounce = false

tool.Equipped:Connect(function()
	character = tool.Parent
	player = Players:GetPlayerFromCharacter(character)
	
	swingTrack = character.Humanoid.Animator:LoadAnimation(script.Swang) :: AnimationTrack
end)

tool.Activated:Connect(function()
	if not debounce then
		debounce = true
		isSwingin = true
		
		swingTrack:Play()
		swingTrack:GetMarkerReachedSignal("Swang"):Connect(function()
			swingSound:Play()
		end)
		
		tool.Handle.Touched:Connect(function(touchThing)
			if touchThing.Parent ~= character and isSwingin and not soundDebounce then
				whackSound:Play()
				soundDebounce = true
			end
		end)
		
		swingTrack.Ended:Wait()
		isSwingin = false
		
		wait(1)
		debounce = false
		soundDebounce = false
	end
end)