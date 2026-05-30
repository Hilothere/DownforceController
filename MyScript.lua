local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local correctKey = "Downforce1"
local keyLink = "https://link-target.net/5940158/LlAgZUJk6lHu"

-- KEY SYSTEM
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "DownforceKeySystem"
keyGui.ResetOnSpawn = false
keyGui.Parent = player:WaitForChild("PlayerGui")

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 330, 0, 210)
keyFrame.Position = UDim2.new(0.5, -165, 0.5, -105)
keyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = keyGui

Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Downforce Key System"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = keyFrame

local box = Instance.new("TextBox")
box.Size = UDim2.new(0.85, 0, 0, 38)
box.Position = UDim2.new(0.075, 0, 0, 65)
box.PlaceholderText = "Enter Key"
box.Text = ""
box.TextScaled = true
box.Font = Enum.Font.Gotham
box.Parent = keyFrame
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

local submit = Instance.new("TextButton")
submit.Size = UDim2.new(0.85, 0, 0, 38)
submit.Position = UDim2.new(0.075, 0, 0, 112)
submit.Text = "Submit Key"
submit.TextScaled = true
submit.Font = Enum.Font.GothamBold
submit.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
submit.TextColor3 = Color3.new(1, 1, 1)
submit.Parent = keyFrame
Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 8)

local getKey = Instance.new("TextButton")
getKey.Size = UDim2.new(0.85, 0, 0, 32)
getKey.Position = UDim2.new(0.075, 0, 0, 160)
getKey.Text = "Get Key"
getKey.TextScaled = true
getKey.Font = Enum.Font.Gotham
getKey.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
getKey.TextColor3 = Color3.new(1, 1, 1)
getKey.Parent = keyFrame
Instance.new("UICorner", getKey).CornerRadius = UDim.new(0, 8)

local unlocked = false

getKey.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(keyLink)
		getKey.Text = "Copied Link!"
	else
		box.Text = keyLink
		box:CaptureFocus()
		getKey.Text = "Copy Manually"
	end

	getKey.BackgroundColor3 = Color3.fromRGB(0, 200, 90)

	task.wait(1.5)

	getKey.Text = "Get Key"
	getKey.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
end)

submit.MouseButton1Click:Connect(function()
	if box.Text == correctKey then
		unlocked = true
		keyGui:Destroy()
	else
		box.Text = ""
		box.PlaceholderText = "Wrong Key!"
	end
end)

repeat task.wait() until unlocked

-- DOWNFORCE GUI
local downforceLevel = 0.1
local maxExtraGravity = 0.5

local gui = Instance.new("ScreenGui")
gui.Name = "DownforceSlider"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 330, 0, 120)
frame.Position = UDim2.new(0.5, -165, 0.75, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, -20, 0, 32)
mainTitle.Position = UDim2.new(0, 10, 0, 8)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "Downforce Control"
mainTitle.TextColor3 = Color3.new(1, 1, 1)
mainTitle.TextScaled = true
mainTitle.Font = Enum.Font.GothamBold
mainTitle.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 0, 25)
label.Position = UDim2.new(0, 10, 0, 43)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(190, 190, 200)
label.TextScaled = true
label.Font = Enum.Font.Gotham
label.Text = "Downforce: 0.1"
label.Parent = frame

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0.85, 0, 0, 10)
bar.Position = UDim2.new(0.075, 0, 0, 82)
bar.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
bar.BorderSizePixel = 0
bar.Parent = frame
Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.1, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
fill.BorderSizePixel = 0
fill.Parent = bar
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

local knob = Instance.new("TextButton")
knob.Size = UDim2.new(0, 24, 0, 24)
knob.Position = UDim2.new(0.1, -12, 0.5, -12)
knob.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
knob.Text = ""
knob.Parent = bar
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local draggingSlider = false
local draggingFrame = false
local dragStart
local startPos

local function updateSlider(x)
	local percent = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)

	knob.Position = UDim2.new(percent, -12, 0.5, -12)
	fill.Size = UDim2.new(percent, 0, 1, 0)

	downforceLevel = math.floor(percent * 10) / 10
	label.Text = "Downforce: " .. downforceLevel
end

knob.MouseButton1Down:Connect(function()
	draggingSlider = true
end)

bar.InputBegan:Connect(function(input)
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
