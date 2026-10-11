-- @ScriptType: LocalScript
local player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local FreezeAction = "Freeze"

local PlayerGui = player.PlayerGui

local UpdateObjective = ReplicatedStorage.Remotes.UpdateObjective
local FreezePlayer = ReplicatedStorage.Remotes.FreezePlayer

local ObjectiveDisplay = PlayerGui:WaitForChild("ObjectiveDisplay")

local function Freeze(yes)
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
	ObjectiveDisplay.ObjectiveText.Text = Objective.DisplayInfo
	
	if Objective.Quantity and Objective.Quantity > 1 then
		ObjectiveDisplay.Counter.Text = "("..tostring(Completed).."/"..tostring(Objective.Quantity)..")"
		ObjectiveDisplay.Counter.Visible = true
	end
end)

FreezePlayer.OnClientEvent:Connect(function(yes)
	Freeze(yes)
end)

player:GetAttributeChangedSignal("InDialogue"):Connect(function()
	if player:GetAttribute("InDialogue") then
		Freeze(true)
	else
		Freeze(false)
	end
end)