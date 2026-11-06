-- @ScriptType: ModuleScript
local MallComps = {}

local TweenService = game:GetService("TweenService")

function MallComps.TargetLevel(level)
	if level == "Lower" then
		return "Upper", 1
	else
		return "Lower", -1
	end
end

MallComps.ElevatorOpen = function(elevator, level)
	if elevator:GetAttribute("Moving") == false and elevator:GetAttribute("Open") == false then
		if elevator:GetAttribute("Position") == level then
			elevator:SetAttribute("Open", true)
			local LDoor = elevator:FindFirstChild(level.."LDoor")
			local RDoor = elevator:FindFirstChild(level.."RDoor")

			local Info = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			TweenService:Create(LDoor, Info, {Size = LDoor:GetAttribute("ShrinkSize"), CFrame = LDoor:GetAttribute("ShrinkFrame")}):Play()
			TweenService:Create(RDoor, Info, {Size = RDoor:GetAttribute("ShrinkSize"), CFrame = RDoor:GetAttribute("ShrinkFrame")}):Play()

			task.wait(6)

			TweenService:Create(LDoor, Info, {Size = LDoor:GetAttribute("GrowSize"), CFrame = LDoor:GetAttribute("GrowFrame")}):Play()
			TweenService:Create(RDoor, Info, {Size = RDoor:GetAttribute("GrowSize"), CFrame = RDoor:GetAttribute("GrowFrame")}):Play()

			task.wait(3)
			elevator:SetAttribute("Open", false)

			if elevator:GetAttribute("Cue") ~= "" then
				MallComps.ElevatorLevelChange(elevator, level)
			end
		else
			MallComps.ElevatorLevelChange(elevator, MallComps.TargetLevel(level))
		end
	elseif elevator:GetAttribute("Cue") == "" then
		elevator:SetAttribute("Cue", level)
	end
end

MallComps.ElevatorLevelChange = function(elevator : Model, level)
	local targetLevel, cologne = MallComps.TargetLevel(level)
	local heightChange = elevator:GetAttribute("TotalHeight") * cologne
	local Info = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	
	local movingSection = elevator.MovingSection

	if elevator:GetAttribute("Cue") ~= "" then
		elevator:SetAttribute("Cue", "")
	end

	if elevator:GetAttribute("Moving") == false then
		if elevator:GetAttribute("Open") == true then
			elevator:GetAttributeChangedSignal("Open"):Wait()
		end

		elevator:SetAttribute("Moving", true)

		local tween = TweenService:Create(movingSection.PrimaryPart, Info, {CFrame = movingSection.PrimaryPart.CFrame * CFrame.new(0, heightChange, 0)})
		tween:Play()
		tween.Completed:Wait()

		elevator:SetAttribute("Moving", false)
		elevator:SetAttribute("Position", targetLevel)
		MallComps.ElevatorOpen(elevator, targetLevel)
	end
end

return MallComps
