-- @ScriptType: LocalScript
local Munster = workspace:WaitForChild("Munster", 100)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Event = ReplicatedStorage.Remotes.MunsterHearing

if not Munster then
	print("that's sad")
else
	Munster:WaitForChild("HumanoidRootPart").ProximityPrompt.PromptShown:Connect(function()
		Event:FireServer()
	end)
end