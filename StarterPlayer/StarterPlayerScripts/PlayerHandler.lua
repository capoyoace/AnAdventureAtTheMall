-- @ScriptType: LocalScript
local player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local InputService = game:GetService("UserInputService")

local FreezeAction = "Freeze"

local PlayerGui = player.PlayerGui

local UpdateObjective = ReplicatedStorage.Remotes.UpdateObjective
local FreezePlayer = ReplicatedStorage.Remotes.FreezePlayer

local ObjectiveDisplay = PlayerGui:WaitForChild("ObjectiveDisplay")

local function Freeze(yes) --un/freezes the player
	if yes then
		ContextActionService:BindAction(
			FreezeAction,
			function() return Enum.ContextActionResult.Sink end,
			false,
			unpack(Enum.PlayerActions:GetEnumItems())
		)
	else
		ContextActionService:UnbindAction(FreezeAction)
	end
end

UpdateObjective.OnClientEvent:Connect(function(Objective, Number, Completed) --when the objective is updated, displays the info to the player
	ObjectiveDisplay.Counter.Visible = false
	
	if Objective.Modifier then
		ObjectiveDisplay.ObjectiveText.Text = string.format(Objective.DisplayInfo, Objective[Objective.Modifier])
	else
		ObjectiveDisplay.ObjectiveText.Text = Objective.DisplayInfo
	end
	
	if Objective.Quantity and Objective.Quantity > 1 then
		ObjectiveDisplay.Counter.Text = "("..tostring(Completed).."/"..tostring(Objective.Quantity)..")"
		ObjectiveDisplay.Counter.Visible = true
	end
end)

FreezePlayer.OnClientEvent:Connect(function(yes) --un/freezes the player when told to
	Freeze(yes)
end)

player:GetAttributeChangedSignal("InDialogue"):Connect(function() --un/freezes the player when their dialogue state changes
	if player:GetAttribute("InDialogue") then
		Freeze(true)
	else
		Freeze(false)
	end
end)

InputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.LeftControl then
		player.Character.Humanoid.WalkSpeed = 100
	end
end)

InputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.LeftControl then
		player.Character.Humanoid.WalkSpeed = 30
	end
end)