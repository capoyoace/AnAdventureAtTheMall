-- @ScriptType: Script
--Note that only the automated tasks run through the command bar are located here. No actual game code is here. --

for i, v in game:GetService("ServerStorage").Shops:GetChildren() do --made a blocking part to close down random shops
	for j, k in v:GetChildren() do
		for l, m in k:GetChildren() do
			if m.Name == "UpperFrontWall" then
				local newBlockage = m:Clone()
				newBlockage.Name = "TemporaryBlockingThing"
				newBlockage.Parent = k
				newBlockage.Position = Vector3.new(newBlockage.Position.X, 9, newBlockage.Position.Z)
				newBlockage.Size = Vector3.new(newBlockage.Size.X, 16, newBlockage.Size.Z)
				newBlockage.Transparency = 1
				newBlockage.CanCollide = false
			end
		end
	end
end


local templates = {} --put a bunch of set survivor positions in each shop
for i, v in pairs(workspace:GetChildren()) do
	if v:FindFirstChild("SurvivorPosition") then
		table.insert(templates, v)
	end
end

for i, v in pairs(game:GetService("ServerStorage").Shops:GetChildren()) do
	for j, k in pairs(v:GetChildren()) do
		local specificTemplate

		for l, m in templates do
			if m.Name == k.Name then
				specificTemplate = m:Clone()
				break
			end
		end

		specificTemplate:PivotTo(k.PrimaryPart.CFrame * CFrame.fromEulerAnglesYXZ(0, math.rad(45), 0) * CFrame.new(0, 3.5, 0))
		for l, m in specificTemplate:GetChildren() do
			m.Parent = k
		end
		specificTemplate:Destroy()
	end
end


for i, v in pairs(game:GetService("ServerStorage").Shops:GetDescendants()) do --forgot to make all those positions transparent and non-collidable and stay put oopsies D:
	if v.Name == "SurvivorPosition" then
		v.Transparency = 1
		v.CanCollide = false
		v.Anchored = true
	end
end

for i, v in pairs(workspace.Mall.Structure.SpecialThings.EscalatorPair2.DownEscalator.Structure:GetChildren()) do
	if v.Name == "Railing" then
		v.Size = Vector3.new(v.Size.X, v.Size.Y + 2, v.Size.Z)
	end
end

for i, v in pairs(workspace.Mall.Structure.SpecialThings:GetDescendants()) do
	if v.Name == "Railing" then
		local newPathfindingThing = Instance.new("PathfindingModifier", v)
		newPathfindingThing.Label = "DONTGOHERE"
	end
end

local TweenService = game:GetService("TweenService") --go ahead and continue to make this new spicy elevator work :DDDDD
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
TweenService:Create(workspace.Mall.Structure.SpecialThings.Elevator2.RDoor, tweenInfo, {Size = Vector3.new(3, 10.4, 0.5), CFrame = CFrame.new(254.5, 6.2, 172.25)}):Play()
TweenService:Create(workspace.Mall.Structure.SpecialThings.Elevator2.LDoor, tweenInfo, {Size = Vector3.new(3, 10.4, 0.5), CFrame = CFrame.new(254.5, 6.2, 156.15)}):Play()

task.wait(5)

TweenService:Create(workspace.Mall.Structure.SpecialThings.Elevator2.RDoor, tweenInfo, {Size = Vector3.new(3, 10.4, 8.3), CFrame = CFrame.new(254.5, 6.2, 168.35)}):Play()
TweenService:Create(workspace.Mall.Structure.SpecialThings.Elevator2.LDoor, tweenInfo, {Size = Vector3.new(3, 10.4, 8.3), CFrame = CFrame.new(254.5, 6.2, 160.05)}):Play()