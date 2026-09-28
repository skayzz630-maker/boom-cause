--[[
	BOOM CAUSE V22.2 - PREDICTION EDITION
	Velocity-based prediction aimbot
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ListeningFor = nil
local KeyLabels = {}
local ESPCache = {}
local HasDrawing = pcall(function() return Drawing and Drawing.new end)

------------------------------------------------------------------
-- SETTINGS
------------------------------------------------------------------
local Settings = {
	AimEnabled = false,
	TargetPartName = "Head",
	FOV = 280,
	Smoothing = 0.15,
	MaxDistance = 800,
	TeamCheck = true,
	HoldKey = Enum.UserInputType.MouseButton2,

	-- Prediction
	PredictionEnabled = true,
	PredictionStrength = 0.16,

	ESPEnabled = false,
	ShowFOV = true,
	BoxESP = false,
	SkeletonESP = false,
	HighlightESP = true,

	FlyEnabled = false,
	FlySpeed = 50,
	SpeedEnabled = false,
	WalkSpeed = 50,
	NoclipEnabled = false,

		ToggleKey = Enum.KeyCode.RightShift,
	AimKey = Enum.KeyCode.T,
	ESPKey = Enum.KeyCode.R,
	TeamKey = Enum.KeyCode.Y,      
	FOVKey = Enum.KeyCode.G,
	FlyKey = Enum.KeyCode.F,
	SpeedKey = Enum.KeyCode.V,
	NoclipKey = Enum.KeyCode.H,

	EnemyColor = Color3.fromRGB(255, 70, 70),
	TeamColor = Color3.fromRGB(70, 255, 140),
}

------------------------------------------------------------------
-- THEME
------------------------------------------------------------------
local Theme = {
	Accent     = Color3.fromRGB(0, 180, 255),
	Bg         = Color3.fromRGB(12, 12, 16),
	Bg2        = Color3.fromRGB(18, 18, 24),
	Bg3        = Color3.fromRGB(26, 26, 34),
	Bg4        = Color3.fromRGB(34, 34, 44),
	Text       = Color3.fromRGB(240, 240, 245),
	TextDim    = Color3.fromRGB(140, 140, 155),
	Success    = Color3.fromRGB(50, 220, 130),
	Danger     = Color3.fromRGB(240, 70, 70),
	Warning    = Color3.fromRGB(255, 190, 60),
	Stroke     = Color3.fromRGB(45, 48, 60),
}

------------------------------------------------------------------
-- TEAM CHECK
------------------------------------------------------------------
local function isSameTeam(player)
	if not Settings.TeamCheck then return false end
	local my = LocalPlayer:GetAttribute("TeamID")
	local their = player:GetAttribute("TeamID")
	if typeof(my) ~= "string" or typeof(their) ~= "string" then return false end
	return my == their
end

------------------------------------------------------------------
-- PREDICTION
------------------------------------------------------------------
local function GetPredictedPosition(part)
	if not Settings.PredictionEnabled then
		return part.Position
	end

	local character = part.Parent
	if not character then return part.Position end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return part.Position end

	-- Modern velocity (more accurate than .Velocity)
	local velocity = root.AssemblyLinearVelocity
	return part.Position + (velocity * Settings.PredictionStrength)
end

------------------------------------------------------------------
-- DRAWING ESP
------------------------------------------------------------------
local function GetPlayerColor(player)
	return isSameTeam(player) and Settings.TeamColor or Settings.EnemyColor
end

local function ClearPlayerESP(player)
	local cache = ESPCache[player]
	if not cache then return end
	if cache.box then pcall(function() cache.box:Remove() end) end
	if cache.skeleton then
		for _, line in pairs(cache.skeleton) do pcall(function() line:Remove() end) end
	end
	ESPCache[player] = nil
end

local function CreateBox()
	local box = Drawing.new("Square")
	box.Thickness = 1.5
	box.Filled = false
	box.Visible = false
	box.ZIndex = 2
	return box
end

local function CreateLine()
	local line = Drawing.new("Line")
	line.Thickness = 1.5
	line.Visible = false
	line.ZIndex = 2
	return line
end

local SkeletonConnections = {
	{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
	{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
	{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
	{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
	{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
	{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"},
}

local function EnsureESPCache(player)
	if ESPCache[player] then return ESPCache[player] end
	if not HasDrawing then return nil end
	local cache = { box = CreateBox(), skeleton = {} }
	for i = 1, #SkeletonConnections do cache.skeleton[i] = CreateLine() end
	ESPCache[player] = cache
	return cache
end

local function WorldToScreen(pos)
	local screen, onScreen = Camera:WorldToViewportPoint(pos)
	return Vector2.new(screen.X, screen.Y), onScreen
end

local function UpdateBoxESP(player, character, color)
	local cache = EnsureESPCache(player)
	if not cache or not cache.box then return end
	local box = cache.box
	if not (Settings.ESPEnabled and Settings.BoxESP) then box.Visible = false return end

	local ok, cf, size = pcall(function() return character:GetBoundingBox() end)
	if not ok or not cf then box.Visible = false return end

	local corners = {
		(cf * CFrame.new( size.X/2,  size.Y/2,  size.Z/2)).Position,
		(cf * CFrame.new(-size.X/2,  size.Y/2,  size.Z/2)).Position,
		(cf * CFrame.new( size.X/2, -size.Y/2,  size.Z/2)).Position,
		(cf * CFrame.new(-size.X/2, -size.Y/2,  size.Z/2)).Position,
		(cf * CFrame.new( size.X/2,  size.Y/2, -size.Z/2)).Position,
		(cf * CFrame.new(-size.X/2,  size.Y/2, -size.Z/2)).Position,
		(cf * CFrame.new( size.X/2, -size.Y/2, -size.Z/2)).Position,
		(cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position,
	}

	local minX, minY = math.huge, math.huge
	local maxX, maxY = -math.huge, -math.huge
	local any = false
	for _, c in ipairs(corners) do
		local s, on = WorldToScreen(c)
		if on then
			any = true
			minX = math.min(minX, s.X) minY = math.min(minY, s.Y)
			maxX = math.max(maxX, s.X) maxY = math.max(maxY, s.Y)
		end
	end
	if any then
		box.Position = Vector2.new(minX, minY)
		box.Size = Vector2.new(math.max(maxX-minX,1), math.max(maxY-minY,1))
		box.Color = color
		box.Visible = true
	else
		box.Visible = false
	end
end

local function UpdateSkeletonESP(player, character, color)
	local cache = EnsureESPCache(player)
	if not cache or not cache.skeleton then return end
	if not (Settings.ESPEnabled and Settings.SkeletonESP) then
		for _, l in pairs(cache.skeleton) do if l then l.Visible = false end end
		return
	end
	for i, conn in ipairs(SkeletonConnections) do
		local line = cache.skeleton[i]
		if not line then continue end
		local p1 = character:FindFirstChild(conn[1])
		local p2 = character:FindFirstChild(conn[2])
		if p1 and p2 then
			local s1, on1 = WorldToScreen(p1.Position)
			local s2, on2 = WorldToScreen(p2.Position)
			if on1 and on2 then
				line.From = s1 line.To = s2 line.Color = color line.Visible = true
			else line.Visible = false end
		else line.Visible = false end
	end
end

local function UpdateDrawingESP()
	if not HasDrawing then return end
	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then ClearPlayerESP(player) continue end
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not char or not hum or hum.Health <= 0 or not Settings.ESPEnabled then
			ClearPlayerESP(player) continue
		end
		local color = GetPlayerColor(player)
		UpdateBoxESP(player, char, color)
		UpdateSkeletonESP(player, char, color)
	end
end

Players.PlayerRemoving:Connect(ClearPlayerESP)

------------------------------------------------------------------
-- HIGHLIGHT + HEALTH BAR
------------------------------------------------------------------
local function ApplyHighlightAndHealth(player)
	local character = player.Character
	if not character then return end
	local hum = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 1)
	if not hum then return end

	local oldHL = character:FindFirstChild("BoomCause_ESP")
	if oldHL then oldHL:Destroy() end
	local oldHB = character:FindFirstChild("BoomCause_HealthBar")
	if oldHB then oldHB:Destroy() end

	if Settings.HighlightESP then
		local hl = Instance.new("Highlight")
		hl.Name = "BoomCause_ESP"
		hl.Adornee = character
		hl.FillTransparency = 0.55
		hl.OutlineTransparency = 0
		hl.Enabled = Settings.ESPEnabled
		hl.Parent = character
		local function updateColor()
			local c = isSameTeam(player) and Settings.TeamColor or Settings.EnemyColor
			hl.FillColor = c hl.OutlineColor = c
		end
		updateColor()
		player:GetAttributeChangedSignal("TeamID"):Connect(updateColor)
		LocalPlayer:GetAttributeChangedSignal("TeamID"):Connect(updateColor)
	end

	local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
	if not head then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "BoomCause_HealthBar"
	billboard.Adornee = head
	billboard.Size = UDim2.fromOffset(86, 9)
	billboard.StudsOffset = Vector3.new(0, 2.7, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 250
	billboard.Enabled = Settings.ESPEnabled
	billboard.Parent = character

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	bg.BorderSizePixel = 0
	bg.Parent = billboard
	Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(1, 1)
	fill.BackgroundColor3 = Color3.fromRGB(50, 255, 120)
	fill.BorderSizePixel = 0
	fill.Parent = bg
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local healthText = Instance.new("TextLabel")
	healthText.Size = UDim2.fromScale(1, 1)
	healthText.BackgroundTransparency = 1
	healthText.Font = Enum.Font.GothamBold
	healthText.TextSize = 8
	healthText.TextColor3 = Color3.new(1,1,1)
	healthText.TextStrokeTransparency = 0.6
	healthText.Parent = bg

	local function updateHealth()
		if not hum or not hum.Parent then return end
		local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
		fill.Size = UDim2.fromScale(pct, 1)
		if pct > 0.6 then fill.BackgroundColor3 = Color3.fromRGB(50, 255, 120)
		elseif pct > 0.3 then fill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
		else fill.BackgroundColor3 = Color3.fromRGB(255, 60, 60) end
		healthText.Text = math.floor(hum.Health+0.5) .. "/" .. math.floor(hum.MaxHealth+0.5)
	end
	updateHealth()
	hum.HealthChanged:Connect(updateHealth)
end

local function SetAllESP(state)
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			local hl = player.Character:FindFirstChild("BoomCause_ESP")
			local hb = player.Character:FindFirstChild("BoomCause_HealthBar")
			if hl then hl.Enabled = state and Settings.HighlightESP
			elseif state and Settings.HighlightESP then ApplyHighlightAndHealth(player) end
			if hb then hb.Enabled = state end
		end
	end
	if not state then
		for player in pairs(ESPCache) do ClearPlayerESP(player) end
	end
end

local function SetupPlayerFull(player)
	player.CharacterAdded:Connect(function() task.defer(ApplyHighlightAndHealth, player) end)
	if player.Character then task.defer(ApplyHighlightAndHealth, player) end
end
for _, p in ipairs(Players:GetPlayers()) do SetupPlayerFull(p) end
Players.PlayerAdded:Connect(SetupPlayerFull)

------------------------------------------------------------------
-- AIMBOT + PREDICTION
------------------------------------------------------------------
local function GetClosestPlayer()
	local closest, shortest = nil, Settings.FOV
	local mouse = UserInputService:GetMouseLocation()
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	for _, v in ipairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character then
			local hum = v.Character:FindFirstChild("Humanoid")
			local part = v.Character:FindFirstChild(Settings.TargetPartName)
			if hum and hum.Health > 0 and part and not isSameTeam(v) then
				if myRoot then
					if (part.Position - myRoot.Position).Magnitude > Settings.MaxDistance then continue end
				end

				-- Use predicted position for FOV check
				local aimPos = GetPredictedPosition(part)
				local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
				if onScreen then
					local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
					if dist < shortest then
						closest = v
						shortest = dist
					end
				end
			end
		end
	end
	return closest
end

------------------------------------------------------------------
-- MOVEMENT
------------------------------------------------------------------
local FlyBV, NoclipConnection, SpeedConnection = nil, nil, nil
local DefaultWalkSpeed = 16

local function StopFly()
	if FlyBV then FlyBV:Destroy() FlyBV = nil end
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
	end
end

local function StartFly()
	StopFly()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end
	hum.PlatformStand = true
	FlyBV = Instance.new("BodyVelocity")
	FlyBV.Name = "BoomCauseFly"
	FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	FlyBV.Velocity = Vector3.zero
	FlyBV.Parent = hrp
end

local function UpdateFly()
	if not Settings.FlyEnabled or not FlyBV or not FlyBV.Parent then return end
	local cam = Camera.CFrame
	local move = Vector3.zero
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
		move -= Vector3.yAxis
	end
	FlyBV.Velocity = move.Magnitude > 0 and move.Unit * Settings.FlySpeed or Vector3.zero
end

local function SetNoclip(state)
	if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
	if state then
		NoclipConnection = RunService.Stepped:Connect(function()
			local char = LocalPlayer.Character
			if not char then return end
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = false end
			end
		end)
	end
end

local function StopSpeed()
	if SpeedConnection then SpeedConnection:Disconnect() SpeedConnection = nil end
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = DefaultWalkSpeed end
	end
end

local function StartSpeed()
	StopSpeed()
	SpeedConnection = RunService.Heartbeat:Connect(function()
		if not Settings.SpeedEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end

		hum.WalkSpeed = Settings.WalkSpeed
		local moveDir = hum.MoveDirection
		if moveDir.Magnitude > 0.05 then
			local y = hrp.AssemblyLinearVelocity.Y
			hrp.AssemblyLinearVelocity = Vector3.new(
				moveDir.X * Settings.WalkSpeed,
				y,
				moveDir.Z * Settings.WalkSpeed
			)
		end
	end)
end

local function ApplyWalkSpeed()
	if Settings.SpeedEnabled then StartSpeed() else StopSpeed() end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	local hum = char:WaitForChild("Humanoid", 3)
	if hum then DefaultWalkSpeed = hum.WalkSpeed end
	if Settings.FlyEnabled then StartFly() end
	if Settings.NoclipEnabled then SetNoclip(true) end
	if Settings.SpeedEnabled then StartSpeed() end
end)

------------------------------------------------------------------
-- TOAST
------------------------------------------------------------------
local ToastGui = Instance.new("ScreenGui")
ToastGui.Name = "BoomCauseToasts"
ToastGui.Parent = CoreGui
ToastGui.ResetOnSpawn = false

local lastNotify = 0
local function Notify(text, color, force)
	if not force and (os.clock() - lastNotify) < 0.35 then return end
	lastNotify = os.clock()
	color = color or Theme.Accent

	local toast = Instance.new("Frame")
	toast.Size = UDim2.fromOffset(240, 36)
	toast.Position = UDim2.new(0.5, -120, 1, 30)
	toast.BackgroundColor3 = Theme.Bg2
	toast.BorderSizePixel = 0
	toast.Parent = ToastGui
	Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = 1.2
	stroke.Parent = toast

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 3, 1, -8)
	bar.Position = UDim2.fromOffset(6, 4)
	bar.BackgroundColor3 = color
	bar.BorderSizePixel = 0
	bar.Parent = toast
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -20, 1, 0)
	lbl.Position = UDim2.fromOffset(16, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 13
	lbl.TextColor3 = Theme.Text
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Text = text
	lbl.Parent = toast

	TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
		Position = UDim2.new(0.5, -120, 1, -50)
	}):Play()

	task.delay(1.6, function()
		local t = TweenService:Create(toast, TweenInfo.new(0.25), {
			Position = UDim2.new(0.5, -120, 1, 30),
			BackgroundTransparency = 1
		})
		t:Play()
		t.Completed:Wait()
		toast:Destroy()
	end)
end

------------------------------------------------------------------
-- FOV CIRCLE
------------------------------------------------------------------
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "BoomCauseFOV"
FOVGui.Parent = CoreGui
FOVGui.ResetOnSpawn = false
FOVGui.IgnoreGuiInset = true

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = Settings.ShowFOV
FOVCircle.Parent = FOVGui
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Theme.Accent
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.3
FOVStroke.Parent = FOVCircle

------------------------------------------------------------------
-- MAIN HUB
------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoomCauseHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(340, 460)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Stroke
MainStroke.Thickness = 1.2
MainStroke.Parent = Main

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.BackgroundColor3 = Theme.Accent
TopLine.BorderSizePixel = 0
TopLine.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Theme.Bg2
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 14)
HeaderFix.Position = UDim2.new(0, 0, 1, -14)
HeaderFix.BackgroundColor3 = Theme.Bg2
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(16, 8)
Title.Size = UDim2.new(1, -60, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "BOOM CAUSE"
Title.TextColor3 = Theme.Text
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.BackgroundTransparency = 1
Sub.Position = UDim2.fromOffset(16, 27)
Sub.Size = UDim2.new(1, -60, 0, 14)
Sub.Font = Enum.Font.Gotham
Sub.Text = "V22.2  •  Prediction"
Sub.TextColor3 = Theme.Accent
Sub.TextSize = 11
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = Theme.Bg3
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Theme.TextDim
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)

CloseBtn.MouseEnter:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Danger, TextColor3 = Color3.new(1,1,1)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Bg3, TextColor3 = Theme.TextDim}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -24, 0, 28)
StatusBar.Position = UDim2.fromOffset(12, 54)
StatusBar.BackgroundColor3 = Theme.Bg2
StatusBar.BorderSizePixel = 0
StatusBar.Parent = Main
Instance.new("UICorner", StatusBar).CornerRadius = UDim.new(0, 8)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.fromOffset(8, 8)
StatusDot.Position = UDim2.fromOffset(10, 10)
StatusDot.BackgroundColor3 = Theme.Danger
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusBar
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusText = Instance.new("TextLabel")
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.fromOffset(26, 0)
StatusText.Size = UDim2.new(1, -34, 1, 0)
StatusText.Font = Enum.Font.GothamMedium
StatusText.Text = "Inactive"
StatusText.TextColor3 = Theme.TextDim
StatusText.TextSize = 12
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBar

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 0, 32)
TabBar.Position = UDim2.fromOffset(12, 90)
TabBar.BackgroundColor3 = Theme.Bg2
TabBar.BorderSizePixel = 0
TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabBar

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -24, 1, -150)
Content.Position = UDim2.fromOffset(12, 130)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Pages = {}
local function CreatePage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Theme.Accent
	page.CanvasSize = UDim2.fromOffset(0, 0)
	page.Visible = false
	page.Parent = Content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
	end)
	Pages[name] = page
	return page
end

local CombatPage = CreatePage("Combat")
local VisualsPage = CreatePage("Visuals")
local MovementPage = CreatePage("Movement")
local SettingsPage = CreatePage("Settings")

local function SwitchTab(name)
	for n, page in pairs(Pages) do page.Visible = (n == name) end
	for _, btn in ipairs(TabBar:GetChildren()) do
		if btn:IsA("TextButton") then
			local active = btn.Name == name
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundColor3 = active and Theme.Accent or Theme.Bg3,
				TextColor3 = active and Color3.new(1,1,1) or Theme.TextDim
			}):Play()
		end
	end
end

local function CreateTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.fromOffset(72, 24)
	btn.BackgroundColor3 = Theme.Bg3
	btn.Text = name
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 11
	btn.TextColor3 = Theme.TextDim
	btn.AutoButtonColor = false
	btn.LayoutOrder = order
	btn.Parent = TabBar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
end

CreateTabButton("Combat", 1)
CreateTabButton("Visuals", 2)
CreateTabButton("Movement", 3)
CreateTabButton("Settings", 4)

------------------------------------------------------------------
-- UI COMPONENTS
------------------------------------------------------------------
local function CreateToggle(parent, name, bindId, default, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 38)
	row.BackgroundColor3 = Theme.Bg2
	row.BorderSizePixel = 0
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)

	local nameLbl = Instance.new("TextLabel")
	nameLbl.BackgroundTransparency = 1
	nameLbl.Position = UDim2.fromOffset(12, 0)
	nameLbl.Size = UDim2.new(0.45, 0, 1, 0)
	nameLbl.Font = Enum.Font.GothamMedium
	nameLbl.Text = name
	nameLbl.TextColor3 = Theme.Text
	nameLbl.TextSize = 13
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.Parent = row

	local keyChip = Instance.new("TextButton")
	keyChip.Size = UDim2.fromOffset(48, 20)
	keyChip.Position = UDim2.new(0.52, 0, 0.5, -10)
	keyChip.BackgroundColor3 = Theme.Bg3
	keyChip.Text = ""
	keyChip.AutoButtonColor = false
	keyChip.ZIndex = 5
	keyChip.Parent = row
	Instance.new("UICorner", keyChip).CornerRadius = UDim.new(0, 5)

	local keyLbl = Instance.new("TextLabel")
	keyLbl.Size = UDim2.fromScale(1, 1)
	keyLbl.BackgroundTransparency = 1
	keyLbl.Font = Enum.Font.GothamBold
	keyLbl.TextSize = 10
	keyLbl.TextColor3 = Theme.TextDim
	keyLbl.Text = "—"
	keyLbl.Parent = keyChip
	KeyLabels[bindId] = keyLbl

	keyChip.MouseButton1Click:Connect(function()
		if ListeningFor then return end
		ListeningFor = bindId
		keyLbl.Text = "..."
		keyLbl.TextColor3 = Theme.Warning
		Notify("Press key for " .. name, Theme.Warning, true)
	end)

	local switch = Instance.new("Frame")
	switch.Size = UDim2.fromOffset(40, 20)
	switch.Position = UDim2.new(1, -52, 0.5, -10)
	switch.BackgroundColor3 = Theme.Bg4
	switch.BorderSizePixel = 0
	switch.Parent = row
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = UDim2.fromOffset(2, 2)
	knob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
	knob.BorderSizePixel = 0
	knob.Parent = switch
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local state = default
	local function paint()
		TweenService:Create(switch, TweenInfo.new(0.2), {
			BackgroundColor3 = state and Theme.Accent or Theme.Bg4
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Position = state and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2),
			BackgroundColor3 = state and Color3.new(1,1,1) or Color3.fromRGB(180,180,190)
		}):Play()
	end
	paint()

	local hit = Instance.new("TextButton")
	hit.Size = UDim2.fromScale(1, 1)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.ZIndex = 2
	hit.Parent = row
	hit.MouseButton1Click:Connect(function()
		if ListeningFor then return end
		state = not state
		paint()
		callback(state)
	end)

	return {
		Toggle = function()
			state = not state
			paint()
			callback(state)
		end
	}
end

local function CreateSlider(parent, name, min, max, default, isFloat, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 42)
	row.BackgroundColor3 = Theme.Bg2
	row.BorderSizePixel = 0
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)

	local nameLbl = Instance.new("TextLabel")
	nameLbl.BackgroundTransparency = 1
	nameLbl.Position = UDim2.fromOffset(12, 4)
	nameLbl.Size = UDim2.new(0.6, 0, 0, 14)
	nameLbl.Font = Enum.Font.GothamMedium
	nameLbl.Text = name
	nameLbl.TextColor3 = Theme.TextDim
	nameLbl.TextSize = 11
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.Parent = row

	local valueLbl = Instance.new("TextLabel")
	valueLbl.BackgroundTransparency = 1
	valueLbl.Position = UDim2.new(0.6, 0, 0, 4)
	valueLbl.Size = UDim2.new(0.4, -12, 0, 14)
	valueLbl.Font = Enum.Font.GothamBold
	valueLbl.TextColor3 = Theme.Accent
	valueLbl.TextSize = 11
	valueLbl.TextXAlignment = Enum.TextXAlignment.Right
	valueLbl.Parent = row

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -24, 0, 6)
	track.Position = UDim2.fromOffset(12, 28)
	track.BackgroundColor3 = Theme.Bg4
	track.BorderSizePixel = 0
	track.Parent = row
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Accent
	fill.BorderSizePixel = 0
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(14, 14)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(0, 0, 0.5, 0)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	knob.BorderSizePixel = 0
	knob.ZIndex = 3
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local value = default
	local dragging = false

	local function updateVisual()
		local pct = math.clamp((value - min) / (max - min), 0, 1)
		fill.Size = UDim2.new(pct, 0, 1, 0)
		knob.Position = UDim2.new(pct, 0, 0.5, 0)
		valueLbl.Text = isFloat and string.format("%.2f", value) or tostring(math.floor(value + 0.5))
	end

	local function setFromX(x)
		local absPos = track.AbsolutePosition.X
		local absSize = track.AbsoluteSize.X
		local pct = math.clamp((x - absPos) / absSize, 0, 1)
		value = min + (max - min) * pct
		if not isFloat then value = math.floor(value + 0.5)
		else value = math.floor(value * 100 + 0.5) / 100 end
		updateVisual()
		callback(value)
	end

	local function beginDrag(input)
		dragging = true
		Main.Draggable = false
		setFromX(input.Position.X)
	end
	local function endDrag()
		if dragging then dragging = false Main.Draggable = true end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then beginDrag(input) end
	end)
	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then beginDrag(input) end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then endDrag() end
	end)

	updateVisual()
end

------------------------------------------------------------------
-- BUILD PAGES
------------------------------------------------------------------
local AimToggle = CreateToggle(CombatPage, "Aimbot", "Aim", false, function(on)
	Settings.AimEnabled = on
	StatusText.Text = on and "Active" or "Inactive"
	StatusText.TextColor3 = on and Theme.Success or Theme.TextDim
	TweenService:Create(StatusDot, TweenInfo.new(0.25), {
		BackgroundColor3 = on and Theme.Success or Theme.Danger
	}):Play()
	Notify(on and "Aimbot On" or "Aimbot Off", on and Theme.Success or Theme.TextDim, true)
end)

CreateToggle(CombatPage, "Prediction", "Pred", true, function(on)
	Settings.PredictionEnabled = on
	Notify(on and "Prediction On" or "Prediction Off", nil, true)
end)

CreateToggle(CombatPage, "Team Check", "Team", true, function(on)
	Settings.TeamCheck = on
end)

CreateSlider(CombatPage, "FOV", 50, 800, Settings.FOV, false, function(v) Settings.FOV = v end)
CreateSlider(CombatPage, "Smoothing", 0.03, 1.00, Settings.Smoothing, true, function(v) Settings.Smoothing = v end)
CreateSlider(CombatPage, "Prediction", 0.05, 0.35, Settings.PredictionStrength, true, function(v)
	Settings.PredictionStrength = v
end)
CreateSlider(CombatPage, "Max Distance", 100, 2000, Settings.MaxDistance, false, function(v) Settings.MaxDistance = v end)

local ESPToggle = CreateToggle(VisualsPage, "ESP Master", "ESP", false, function(on)
	Settings.ESPEnabled = on
	SetAllESP(on)
	Notify(on and "ESP On" or "ESP Off", on and Theme.Success or Theme.TextDim, true)
end)

CreateToggle(VisualsPage, "Box ESP", "Box", false, function(on)
	Settings.BoxESP = on
	if not HasDrawing then Notify("Drawing not found", Theme.Danger, true) end
end)

CreateToggle(VisualsPage, "Skeleton ESP", "Skeleton", false, function(on)
	Settings.SkeletonESP = on
	if not HasDrawing then Notify("Drawing not found", Theme.Danger, true) end
end)

CreateToggle(VisualsPage, "Highlight ESP", "Highlight", true, function(on)
	Settings.HighlightESP = on
	SetAllESP(Settings.ESPEnabled)
end)

local FOVToggle = CreateToggle(VisualsPage, "FOV Circle", "FOV", true, function(on)
	Settings.ShowFOV = on
	FOVCircle.Visible = on
end)

local FlyToggle = CreateToggle(MovementPage, "Fly", "Fly", false, function(on)
	Settings.FlyEnabled = on
	if on then StartFly() else StopFly() end
	Notify(on and "Fly On" or "Fly Off", on and Theme.Success or Theme.TextDim, true)
end)

local SpeedToggle = CreateToggle(MovementPage, "Speed", "Speed", false, function(on)
	Settings.SpeedEnabled = on
	ApplyWalkSpeed()
	Notify(on and "Speed On" or "Speed Off", on and Theme.Success or Theme.TextDim, true)
end)

local NoclipToggle = CreateToggle(MovementPage, "Noclip", "Noclip", false, function(on)
	Settings.NoclipEnabled = on
	SetNoclip(on)
	Notify(on and "Noclip On" or "Noclip Off", on and Theme.Success or Theme.TextDim, true)
end)

CreateSlider(MovementPage, "Fly Speed", 10, 200, Settings.FlySpeed, false, function(v) Settings.FlySpeed = v end)
CreateSlider(MovementPage, "Walk Speed", 16, 200, Settings.WalkSpeed, false, function(v)
	Settings.WalkSpeed = v
	if Settings.SpeedEnabled then ApplyWalkSpeed() end
end)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, 0, 0, 60)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.TextColor3 = Theme.TextDim
info.Text = "Prediction aims ahead of moving targets.\nSweet spot: 0.12 – 0.20\nRightShift = Menu"
info.TextWrapped = true
info.Parent = SettingsPage

local Footer = Instance.new("TextLabel")
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -24)
Footer.Size = UDim2.new(1, 0, 0, 18)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.TextColor3 = Color3.fromRGB(90, 90, 105)
Footer.Parent = Main
KeyLabels.Footer = Footer

local function GetKeyName(kc)
	if not kc then return "?" end
	local n = kc.Name
	local map = {RightShift="RShift",LeftShift="LShift",RightControl="RCtrl",LeftControl="LCtrl"}
	return map[n] or n
end

local function RefreshKeyLabels()
	if KeyLabels.Aim then KeyLabels.Aim.Text = GetKeyName(Settings.AimKey) end
	if KeyLabels.ESP then KeyLabels.ESP.Text = GetKeyName(Settings.ESPKey) end
	if KeyLabels.FOV then KeyLabels.FOV.Text = GetKeyName(Settings.FOVKey) end
	if KeyLabels.Fly then KeyLabels.Fly.Text = GetKeyName(Settings.FlyKey) end
	if KeyLabels.Speed then KeyLabels.Speed.Text = GetKeyName(Settings.SpeedKey) end
	if KeyLabels.Noclip then KeyLabels.Noclip.Text = GetKeyName(Settings.NoclipKey) end
	if KeyLabels.Footer then
		KeyLabels.Footer.Text = GetKeyName(Settings.ToggleKey) .. "  Menu"
	end
end
RefreshKeyLabels()
SwitchTab("Combat")

------------------------------------------------------------------
-- INPUT
------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input)
	if ListeningFor and input.KeyCode == Enum.KeyCode.Escape then
		ListeningFor = nil
		RefreshKeyLabels()
		Notify("Cancelled", Theme.TextDim, true)
		return
	end

	if ListeningFor then
		if input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.Escape then
			if ListeningFor == "Aim" then Settings.AimKey = input.KeyCode
			elseif ListeningFor == "ESP" then Settings.ESPKey = input.KeyCode
			elseif ListeningFor == "FOV" then Settings.FOVKey = input.KeyCode
			elseif ListeningFor == "Fly" then Settings.FlyKey = input.KeyCode
			elseif ListeningFor == "Speed" then Settings.SpeedKey = input.KeyCode
			elseif ListeningFor == "Noclip" then Settings.NoclipKey = input.KeyCode
			elseif ListeningFor == "Team" then Settings.TeamKey = input.KeyCode
			end
			ListeningFor = nil
			RefreshKeyLabels()
			Notify("Bound to " .. GetKeyName(input.KeyCode), Theme.Success, true)
		end
		return
	end

	if input.KeyCode == Settings.ToggleKey then
		ScreenGui.Enabled = not ScreenGui.Enabled
	elseif input.KeyCode == Settings.AimKey then AimToggle.Toggle()
	elseif input.KeyCode == Settings.ESPKey then ESPToggle.Toggle()
	elseif input.KeyCode == Settings.FOVKey then FOVToggle.Toggle()
	elseif input.KeyCode == Settings.FlyKey then FlyToggle.Toggle()
	elseif input.KeyCode == Settings.SpeedKey then SpeedToggle.Toggle()
	elseif input.KeyCode == Settings.NoclipKey then NoclipToggle.Toggle()
	end
end)

------------------------------------------------------------------
-- LOOPS (Prediction Aimbot)
------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	pcall(UpdateDrawingESP)
	UpdateFly()

	if Settings.ShowFOV then
		local mouse = UserInputService:GetMouseLocation()
		FOVCircle.Position = UDim2.fromOffset(mouse.X, mouse.Y)
		FOVCircle.Size = UDim2.fromOffset(Settings.FOV * 2, Settings.FOV * 2)
		FOVCircle.Visible = true
		FOVStroke.Transparency = Settings.AimEnabled and (0.1 + math.sin(os.clock()*5)*0.08) or 0.35
	else
		FOVCircle.Visible = false
	end

	if not Settings.AimEnabled then return end
	if not UserInputService:IsMouseButtonPressed(Settings.HoldKey) then return end

	local target = GetClosestPlayer()
	if not target or not target.Character then return end

	local part = target.Character:FindFirstChild(Settings.TargetPartName)
	if not part then return end

	-- Aim at predicted position
	local aimPos = GetPredictedPosition(part)
	local sp, onScreen = Camera:WorldToViewportPoint(aimPos)
	if not onScreen then return end

	local mouse = UserInputService:GetMouseLocation()
	local dx = sp.X - mouse.X
	local dy = sp.Y - mouse.Y

	if math.abs(dx) > 0.5 or math.abs(dy) > 0.5 then
		mousemoverel(dx * Settings.Smoothing, dy * Settings.Smoothing)
	end
end)

RunService.Heartbeat:Connect(function()
	if not Settings.ESPEnabled then return end
	for _, p in ipairs(Players:GetPlayers()) do
		local char = p.Character
		if char then
			local hl = char:FindFirstChild("BoomCause_ESP")
			local hb = char:FindFirstChild("BoomCause_HealthBar")
			local hum = char:FindFirstChildOfClass("Humanoid")
			local alive = hum and hum.Health > 0
			if hl then hl.Enabled = alive and Settings.HighlightESP end
			if hb then hb.Enabled = alive end
		end
	end
end)

Notify("BOOM CAUSE V22.2 Ready", Theme.Accent, true)
