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