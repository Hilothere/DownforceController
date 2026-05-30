local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local downforceLevel = 0.1
local maxExtraGravity = 0.5

local gui = Instance.new("ScreenGui")
gui.Name = "WeakDownforceSlider"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 330, 0, 120)
frame.Position = UDim2.new(0.5, -165, 0.75, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 90, 110)
stroke.Thickness = 1.5
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 32)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Downforce Control"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 0, 25)
label.Position = UDim2.new(0, 10, 0, 43)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(190, 190, 200)
label.TextScaled = true
label.Font = Enum.Font.Gotham
label.Text = "Downforce: 0.1"
label.Parent = frame

local barBack = Instance.new("Frame")
barBack.Size = UDim2.new(0.85, 0, 0, 10)
barBack.Position = UDim2.new(0.075, 0, 0, 82)
barBack.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
barBack.BorderSizePixel = 0
barBack.Parent = frame

local barBackCorner = Instance.new("UICorner")
barBackCorner.CornerRadius = UDim.new(1, 0)
barBackCorner.Parent = barBack

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.1, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
fill.BorderSizePixel = 0
fill.Parent = barBack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = fill

local knob = Instance.new("TextButton")
knob.Size = UDim2.new(0, 24, 0, 24)
knob.Position = UDim2.new(0.1, -12, 0.5, -12)
knob.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
knob.Text = ""
knob.AutoButtonColor = false
knob.Parent = barBack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = knob

local draggingSlider = false
local draggingFrame = false
local dragStart
local startPos

local function updateSlider(x)
	local percent = math.clamp((x - barBack.AbsolutePosition.X) / barBack.AbsoluteSize.X, 0, 1)

	knob.Position = UDim2.new(percent, -12, 0.5, -12)
	fill.Size = UDim2.new(percent, 0, 1, 0)

	downforceLevel = math.floor(percent * 10) / 10
	label.Text = "Downforce: " .. downforceLevel
end

knob.MouseButton1Down:Connect(function()
	draggingSlider = true
end)

barBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = true
		updateSlider(input.Position.X)
	end
end)

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingFrame = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = false
		draggingFrame = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if draggingSlider then
			updateSlider(input.Position.X)
		elseif draggingFrame then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end
end)

local currentForce
local currentAttachment
local currentRoot

local function getCarRoot()
	local char = player.Character
	if not char then return nil end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return nil end

	local seat = humanoid.SeatPart
	if not seat then return nil end

	local car = seat:FindFirstAncestorOfClass("Model")
	if not car then return seat end

	return car.PrimaryPart or seat
end

RunService.Heartbeat:Connect(function()
	local root = getCarRoot()

	if root ~= currentRoot then
		if currentForce then currentForce:Destroy() end
		if currentAttachment then currentAttachment:Destroy() end

		currentRoot = root

		if root then
			currentAttachment = Instance.new("Attachment")
			currentAttachment.Parent = root

			currentForce = Instance.new("VectorForce")
			currentForce.Attachment0 = currentAttachment
			currentForce.RelativeTo = Enum.ActuatorRelativeTo.World
			currentForce.ApplyAtCenterOfMass = true
			currentForce.Parent = root
		end
	end

	if currentForce and currentRoot then
		local mass = currentRoot.AssemblyMass
		local gravity = workspace.Gravity
		local force = mass * gravity * downforceLevel * maxExtraGravity

		currentForce.Force = Vector3.new(0, -force, 0)
	end
end)
