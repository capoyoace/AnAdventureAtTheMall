-- @ScriptType: LocalScript
local player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RequestRejoin = ReplicatedStorage.Remotes.RequestRejoin

local id = 99296934928794

script.Parent.MouseButton1Up:Connect(function()
	RequestRejoin:FireServer("kick")
end)