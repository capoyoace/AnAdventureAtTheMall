-- @ScriptType: LocalScript
local player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Start = ReplicatedStorage.Remotes.StartRound

local ObjectiveUI = script.Parent.Parent.ObjectiveDisplay

local BlackoutButton = script.Parent.BlackoutMinus
local MunsterButton = script.Parent.MunsterMinus

local SpeedOption = script.Parent.SpeedOption
local InvulnerableOption = MunsterButton.InvulnerableOption

player.CharacterAppearanceLoaded:Connect(function(character)
	character.PrimaryPart.Anchored = true
end)

script.Parent.Enabled = true

SpeedOption.MouseButton1Up:Connect(function()
	SpeedOption:SetAttribute("Enabled", not SpeedOption:GetAttribute("Enabled"))
	if SpeedOption:GetAttribute("Enabled") == true then
		SpeedOption.Text = "✓"
	else
		SpeedOption.Text = "X"
	end
end)

InvulnerableOption.MouseButton1Up:Connect(function()
	InvulnerableOption:SetAttribute("Enabled", not InvulnerableOption:GetAttribute("Enabled"))
	if InvulnerableOption:GetAttribute("Enabled") == true then
		InvulnerableOption.Text = "✓"
	else
		InvulnerableOption.Text = "X"
	end
end)

BlackoutButton.MouseButton1Up:Connect(function()
	ObjectiveUI.Enabled = true
	Start:FireServer("BlackoutMinus", SpeedOption:GetAttribute("Enabled"))
	player.Character.PrimaryPart.Anchored = false
	script.Parent:Destroy()
end)

MunsterButton.MouseButton1Up:Connect(function()
	ObjectiveUI.Enabled = true
	Start:FireServer("MunsterMinus", SpeedOption:GetAttribute("Enabled"), InvulnerableOption:GetAttribute("Enabled"))
	player.Character.PrimaryPart.Anchored = false
	script.Parent:Destroy()
end)