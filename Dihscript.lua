--[[
	DIH SCRIPT - Key Gate (Hub Theme)
	Key: DIHSCRIPT819273186481948100
]]

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local VALID_KEY = "DIHSCRIPT819273186481948100"
local KEY_FILE = "DihScriptKey.txt"
local GET_KEY_URL = "https://work.ink/32lJ/DIHSCRIPTS"
local DISCORD_URL = "https://discord.gg/PKaSBmk7q"

local C = {
	titleBar = Color3.fromRGB(161, 125, 170),
	track    = Color3.fromRGB(89, 89, 89),
	white    = Color3.new(1, 1, 1),
	gray     = Color3.fromRGB(192, 192, 192),
	black    = Color3.new(0, 0, 0),
	borderA  = Color3.fromRGB(179, 155, 186),
	borderB  = Color3.fromRGB(157, 155, 157),
	fill     = Color3.fromRGB(135, 80, 155),
	success  = Color3.fromRGB(50, 220, 130),
	danger   = Color3.fromRGB(255, 60, 60),
	discord  = Color3.fromRGB(114, 137, 218),
}

local WINDOW_GRADIENT = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(150, 110, 160)),
	ColorSequenceKeypoint.new(0.12, Color3.fromRGB(150, 110, 160)),
	ColorSequenceKeypoint.new(0.25, Color3.fromRGB(165, 132, 173)),
	ColorSequenceKeypoint.new(0.42, Color3.fromRGB(187, 162, 192)),
	ColorSequenceKeypoint.new(0.59, Color3.fromRGB(205, 188, 209)),
	ColorSequenceKeypoint.new(0.76, Color3.fromRGB(221, 210, 223)),
	ColorSequenceKeypoint.new(0.88, Color3.fromRGB(230, 223, 232)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(237, 232, 238)),
})

local FREDOKA = Font.fromEnum(Enum.Font.FredokaOne)
local LUCKY = Font.fromEnum(Enum.Font.LuckiestGuy)

local function KeyAlreadySaved()
	if not (isfile and readfile) then return false end
	local ok, data = pcall(function()
		if isfile(KEY_FILE) then return readfile(KEY_FILE) end
		return nil
	end)
	return ok and typeof(data) == "string" and data:gsub("%s+", "") == VALID_KEY
end

local function SaveKey()
	if writefile then
		pcall(writefile, KEY_FILE, VALID_KEY)
	end
end

local function OpenOrCopy(url)
	if setclipboard then pcall(setclipboard, url) end
	if typeof(open_url) == "function" then
		pcall(open_url, url)
	elseif typeof(openurl) == "function" then
		pcall(openurl, url)
	end
end

if not KeyAlreadySaved() then
	local KeyGui = Instance.new("ScreenGui")
	KeyGui.Name = "DihKeyGate"
	KeyGui.ResetOnSpawn = false
	KeyGui.IgnoreGuiInset = true
	KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	KeyGui.Parent = CoreGui

	-- dim background
	local Overlay = Instance.new("Frame")
	Overlay.Size = UDim2.fromScale(1, 1)
	Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
	Overlay.BackgroundTransparency = 0.4
	Overlay.BorderSizePixel = 0
	Overlay.Parent = KeyGui

	-- soft shadow rings
	local shadowHolder = Instance.new("Frame")
	shadowHolder.Size = UDim2.fromOffset(340, 300)
	shadowHolder.Position = UDim2.fromScale(0.5, 0.5)
	shadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	shadowHolder.BackgroundTransparency = 1
	shadowHolder.ZIndex = 0
	shadowHolder.Parent = KeyGui

	for i = 1, 6 do
		local grow = (i - 1) * 2
		local ring = Instance.new("Frame")
		ring.Position = UDim2.fromOffset(-grow, 3 - grow)
		ring.Size = UDim2.fromOffset(340 + grow * 2, 300 + grow * 2)
		ring.BackgroundTransparency = 1
		ring.BorderSizePixel = 0
		ring.Parent = shadowHolder
		Instance.new("UICorner", ring).CornerRadius = UDim.new(0, 22 + grow)
		local rs = Instance.new("UIStroke")
		rs.Thickness = 2
		rs.Color = C.black
		rs.Transparency = 0.82 + i * 0.025
		rs.Parent = ring
	end

	-- main card (same gradient as hub)
	local Card = Instance.new("Frame")
	Card.Size = UDim2.fromOffset(340, 300)
	Card.Position = UDim2.fromScale(0.5, 0.5)
	Card.AnchorPoint = Vector2.new(0.5, 0.5)
	Card.BackgroundColor3 = C.white
	Card.BackgroundTransparency = 0.12
	Card.BorderSizePixel = 0
	Card.ZIndex = 1
	Card.Parent = KeyGui
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 22)

	local winGrad = Instance.new("UIGradient")
	winGrad.Rotation = 90
	winGrad.Color = WINDOW_GRADIENT
	winGrad.Parent = Card

	local border = Instance.new("UIStroke")
	border.Thickness = 5
	border.Color = C.white
	border.Transparency = 0.08
	border.Parent = Card
	local borderGrad = Instance.new("UIGradient")
	borderGrad.Rotation = 90
	borderGrad.Color = ColorSequence.new(C.borderA, C.borderB)
	borderGrad.Parent = border

	-- title bar
	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, -24, 0, 44)
	titleBar.Position = UDim2.fromOffset(12, 10)
	titleBar.BackgroundColor3 = C.titleBar
	titleBar.BorderSizePixel = 0
	titleBar.Parent = Card
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.fromScale(1, 1)
	title.FontFace = LUCKY
	title.TextSize = 26
	title.Text = "DIH SCRIPT"
	title.TextColor3 = C.white
	title.Parent = titleBar
	local ts = Instance.new("UIStroke")
	ts.Thickness = 1.5
	ts.Color = C.black
	ts.Transparency = 0.35
	ts.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	ts.Parent = title

	local sub = Instance.new("TextLabel")
	sub.BackgroundTransparency = 1
	sub.Position = UDim2.fromOffset(0, 60)
	sub.Size = UDim2.new(1, 0, 0, 20)
	sub.FontFace = FREDOKA
	sub.TextSize = 16
	sub.Text = "Enter key to unlock"
	sub.TextColor3 = C.black
	sub.TextTransparency = 0.35
	sub.Parent = Card

	-- key input
	local BoxBg = Instance.new("Frame")
	BoxBg.Size = UDim2.new(1, -40, 0, 40)
	BoxBg.Position = UDim2.fromOffset(20, 90)
	BoxBg.BackgroundColor3 = C.black
	BoxBg.BackgroundTransparency = 0.75
	BoxBg.BorderSizePixel = 0
	BoxBg.Parent = Card
	Instance.new("UICorner", BoxBg).CornerRadius = UDim.new(0, 10)
	local boxStroke = Instance.new("UIStroke")
	boxStroke.Thickness = 1.5
	boxStroke.Color = C.black
	boxStroke.Transparency = 0.4
	boxStroke.Parent = BoxBg

	local KeyBox = Instance.new("TextBox")
	KeyBox.Size = UDim2.new(1, -16, 1, 0)
	KeyBox.Position = UDim2.fromOffset(8, 0)
	KeyBox.BackgroundTransparency = 1
	KeyBox.FontFace = FREDOKA
	KeyBox.TextSize = 18
	KeyBox.TextColor3 = C.white
	KeyBox.PlaceholderText = "Paste key..."
	KeyBox.PlaceholderColor3 = C.gray
	KeyBox.Text = ""
	KeyBox.ClearTextOnFocus = false
	KeyBox.TextXAlignment = Enum.TextXAlignment.Left
	KeyBox.Parent = BoxBg

	local StatusLbl = Instance.new("TextLabel")
	StatusLbl.BackgroundTransparency = 1
	StatusLbl.Position = UDim2.fromOffset(20, 134)
	StatusLbl.Size = UDim2.new(1, -40, 0, 18)
	StatusLbl.FontFace = FREDOKA
	StatusLbl.TextSize = 14
	StatusLbl.TextColor3 = C.black
	StatusLbl.TextTransparency = 0.4
	StatusLbl.Text = ""
	StatusLbl.Parent = Card

	local function MakeBtn(label, y, textColor, bgColor, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -40, 0, 36)
		btn.Position = UDim2.fromOffset(20, y)
		btn.BackgroundColor3 = bgColor
		btn.BackgroundTransparency = 0.15
		btn.AutoButtonColor = false
		btn.Text = label
		btn.FontFace = FREDOKA
		btn.TextSize = 18
		btn.TextColor3 = textColor
		btn.Parent = Card
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
		local bs = Instance.new("UIStroke")
		bs.Thickness = 1.5
		bs.Color = C.black
		bs.Transparency = 0.4
		bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		bs.Parent = btn

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {
				BackgroundTransparency = 0.05,
				Size = UDim2.new(1, -36, 0, 38),
				Position = UDim2.fromOffset(18, y - 1),
			}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {
				BackgroundTransparency = 0.15,
				Size = UDim2.new(1, -40, 0, 36),
				Position = UDim2.fromOffset(20, y),
			}):Play()
		end)
		btn.MouseButton1Click:Connect(function()
			local orig = btn.Size
			TweenService:Create(btn, TweenInfo.new(0.06), {
				Size = UDim2.new(1, -48, 0, 32),
			}):Play()
			task.delay(0.06, function()
				TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back), {
					Size = UDim2.new(1, -40, 0, 36),
				}):Play()
			end)
			callback()
		end)
		return btn
	end

	local unlockEvent = Instance.new("BindableEvent")

	MakeBtn("Unlock", 158, C.white, C.titleBar, function()
		local typed = (KeyBox.Text or ""):gsub("%s+", "")
		if typed == VALID_KEY then
			StatusLbl.TextColor3 = C.success
			StatusLbl.TextTransparency = 0
			StatusLbl.Text = "Key accepted!"
			SaveKey()
			task.wait(0.4)
			KeyGui:Destroy()
			unlockEvent:Fire()
		else
			StatusLbl.TextColor3 = C.danger
			StatusLbl.TextTransparency = 0
			StatusLbl.Text = "Invalid key"
			TweenService:Create(Card, TweenInfo.new(0.05), {
				Position = UDim2.new(0.5, 8, 0.5, 0),
			}):Play()
			task.wait(0.05)
			TweenService:Create(Card, TweenInfo.new(0.05), {
				Position = UDim2.new(0.5, -8, 0.5, 0),
			}):Play()
			task.wait(0.05)
			TweenService:Create(Card, TweenInfo.new(0.05), {
				Position = UDim2.fromScale(0.5, 0.5),
			}):Play()
		end
	end)

	MakeBtn("Get Key", 202, C.white, C.fill, function()
		OpenOrCopy(GET_KEY_URL)
		StatusLbl.TextColor3 = C.titleBar
		StatusLbl.TextTransparency = 0
		StatusLbl.Text = "Link copied!"
	end)

	MakeBtn("Join Discord", 246, C.white, C.discord, function()
		OpenOrCopy(DISCORD_URL)
		StatusLbl.TextColor3 = C.discord
		StatusLbl.TextTransparency = 0
		StatusLbl.Text = "Discord link copied!"
	end)

	unlockEvent.Event:Wait()
end

-- ========== PASTE YOUR FULL DIH HUB BELOW THIS LINE ==========

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local CONFIG_FILE = "DihScriptConfig.json"

------------------------------------------------------------------
-- STATE
------------------------------------------------------------------
local S = {
	AimEnabled = false,
	AimMode = "Hold",
	TargetPartName = "Head",
	FOV = 280,
	Smoothing = 0.15,
	MaxDistance = 800,
	TeamCheck = true,
	HoldKey = Enum.UserInputType.MouseButton2,

	PredictionEnabled = true,
	BasePrediction = 0.16,
	SpeedMultiplier = 0.05,
	MaxLeadDistance = 25,
	AutoPrediction = true,
	PredictionMinMult = 0.35,
	PredictionMaxMult = 1.55,

	ESPEnabled = false,
	ShowFOV = false,
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
	NoclipKey = Enum.KeyCode.C,
	BoxKey = Enum.KeyCode.B,
	SkeletonKey = Enum.KeyCode.K,
	HighlightKey = Enum.KeyCode.L,

	EnemyColor = Color3.fromRGB(255, 70, 70),
	TeamColor = Color3.fromRGB(70, 255, 140),

	_pendingToggles = nil,
}

local Settings = {}
local ToggleControls = {}
local ESPCache = {}
local HasDrawing = pcall(function() return Drawing and Drawing.new end)
local _saving = false

local function KeyNameToEnum(name)
	if typeof(name) ~= "string" then return nil end
	local ok, e = pcall(function() return Enum.KeyCode[name] end)
	return (ok and e) or nil
end

local function MapFOV(a) return math.floor(50 + a * 750 + 0.5) end
local function MapSmooth(a) return math.floor((0.03 + a * 0.97) * 100 + 0.5) / 100 end
local function MapPred(a) return math.floor((0.05 + a * 0.30) * 100 + 0.5) / 100 end
local function MapDist(a) return math.floor(100 + a * 1900 + 0.5) end
local function MapFly(a) return math.floor(10 + a * 190 + 0.5) end
local function MapWalk(a) return math.floor(16 + a * 184 + 0.5) end

------------------------------------------------------------------
-- CONFIG SAVE / LOAD
------------------------------------------------------------------
local function EnumToStr(e)
	if typeof(e) ~= "EnumItem" then
		return nil
	end
	-- tostring → "Enum.KeyCode.T"
	return tostring(e)
end

local function StrToEnum(str)
	if typeof(str) ~= "string" then
		return nil
	end

	-- accept "Enum.KeyCode.T" or "KeyCode.T"
	local typeName, itemName = string.match(str, "Enum%.(%w+)%.(%w+)$")
	if not typeName then
		typeName, itemName = string.match(str, "^(%w+)%.(%w+)$")
	end
	if not typeName or not itemName then
		return nil
	end

	local ok, enumType = pcall(function()
		return Enum[typeName]
	end)
	if not ok or enumType == nil then
		return nil
	end

	local ok2, item = pcall(function()
		return enumType[itemName]
	end)
	if ok2 and typeof(item) == "EnumItem" then
		return item
	end
	return nil
end

local function SerializeSettings()
	return {
		AimEnabled = S.AimEnabled,
		AimMode = S.AimMode,
		TargetPartName = S.TargetPartName,
		FOV = S.FOV,
		Smoothing = S.Smoothing,
		MaxDistance = S.MaxDistance,
		TeamCheck = S.TeamCheck,
		PredictionEnabled = S.PredictionEnabled,
		BasePrediction = S.BasePrediction,
		SpeedMultiplier = S.SpeedMultiplier,
		MaxLeadDistance = S.MaxLeadDistance,
		AutoPrediction = S.AutoPrediction,
		ESPEnabled = S.ESPEnabled,
		ShowFOV = S.ShowFOV,
		BoxESP = S.BoxESP,
		SkeletonESP = S.SkeletonESP,
		HighlightESP = S.HighlightESP,
		FlyEnabled = S.FlyEnabled,
		FlySpeed = S.FlySpeed,
		SpeedEnabled = S.SpeedEnabled,
		WalkSpeed = S.WalkSpeed,
		NoclipEnabled = S.NoclipEnabled,
		AimKey = EnumToStr(S.AimKey),
		ESPKey = EnumToStr(S.ESPKey),
		TeamKey = EnumToStr(S.TeamKey),
		FOVKey = EnumToStr(S.FOVKey),
		FlyKey = EnumToStr(S.FlyKey),
		SpeedKey = EnumToStr(S.SpeedKey),
		NoclipKey = EnumToStr(S.NoclipKey),
		BoxKey = EnumToStr(S.BoxKey),
		SkeletonKey = EnumToStr(S.SkeletonKey),
		HighlightKey = EnumToStr(S.HighlightKey),
	}
end

local function ApplyLoaded(data)
	if typeof(data) ~= "table" then return end
	if data.AimMode then S.AimMode = data.AimMode end
	if data.TargetPartName then S.TargetPartName = data.TargetPartName end
	if typeof(data.FOV) == "number" then S.FOV = data.FOV end
	if typeof(data.Smoothing) == "number" then S.Smoothing = data.Smoothing end
	if typeof(data.MaxDistance) == "number" then S.MaxDistance = data.MaxDistance end
	if typeof(data.TeamCheck) == "boolean" then S.TeamCheck = data.TeamCheck end
	if typeof(data.PredictionEnabled) == "boolean" then S.PredictionEnabled = data.PredictionEnabled end
	if typeof(data.BasePrediction) == "number" then S.BasePrediction = data.BasePrediction end
	if typeof(data.SpeedMultiplier) == "number" then S.SpeedMultiplier = data.SpeedMultiplier end
	if typeof(data.MaxLeadDistance) == "number" then S.MaxLeadDistance = data.MaxLeadDistance end
	if typeof(data.AutoPrediction) == "boolean" then S.AutoPrediction = data.AutoPrediction end
	if typeof(data.BoxESP) == "boolean" then S.BoxESP = data.BoxESP end
	if typeof(data.SkeletonESP) == "boolean" then S.SkeletonESP = data.SkeletonESP end
	if typeof(data.HighlightESP) == "boolean" then S.HighlightESP = data.HighlightESP end
	if typeof(data.ShowFOV) == "boolean" then S.ShowFOV = data.ShowFOV end
	if typeof(data.FlySpeed) == "number" then S.FlySpeed = data.FlySpeed end
	if typeof(data.WalkSpeed) == "number" then S.WalkSpeed = data.WalkSpeed end

	local keyMap = {
		AimKey = "AimKey", ESPKey = "ESPKey", TeamKey = "TeamKey", FOVKey = "FOVKey",
		FlyKey = "FlyKey", SpeedKey = "SpeedKey", NoclipKey = "NoclipKey",
		BoxKey = "BoxKey", SkeletonKey = "SkeletonKey", HighlightKey = "HighlightKey",
	}
	for jsonKey, sKey in pairs(keyMap) do
		local e = StrToEnum(data[jsonKey])
		if e then S[sKey] = e end
	end

	S._pendingToggles = {
		aimbot = data.AimEnabled,
		prediction = data.PredictionEnabled,
		teamCheck = data.TeamCheck,
		esp = data.ESPEnabled,
		boxEsp = data.BoxESP,
		skeletonEsp = data.SkeletonESP,
		highlightEsp = data.HighlightESP,
		fovCircle = data.ShowFOV,
		fly = data.FlyEnabled,
		speed = data.SpeedEnabled,
		noclip = data.NoclipEnabled,
	}
end

local function SaveConfig()
	if _saving or not writefile then return end
	_saving = true
	local ok, encoded = pcall(function()
		return HttpService:JSONEncode(SerializeSettings())
	end)
	if ok and encoded then
		pcall(writefile, CONFIG_FILE, encoded)
	end
	_saving = false
end

local function LoadConfig()
	if not (isfile and readfile) then return end
	local ok, raw = pcall(function()
		if isfile(CONFIG_FILE) then return readfile(CONFIG_FILE) end
		return nil
	end)
	if not ok or not raw then return end
	local ok2, data = pcall(function()
		return HttpService:JSONDecode(raw)
	end)
	if ok2 and data then ApplyLoaded(data) end
end

LoadConfig()

------------------------------------------------------------------
-- TEAM
------------------------------------------------------------------
local function isSameTeam(player)
	if not S.TeamCheck then return false end
	local my = LocalPlayer:GetAttribute("TeamID")
	local their = player:GetAttribute("TeamID")
	if typeof(my) ~= "string" or typeof(their) ~= "string" then return false end
	return my == their
end

------------------------------------------------------------------
-- PREDICTION
------------------------------------------------------------------
local function GetPredictedPosition(part)
	if not S.PredictionEnabled then return part.Position end
	local character = part.Parent
	if not character then return part.Position end
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return part.Position end
	local velocity = root.AssemblyLinearVelocity
	local speed = velocity.Magnitude
	if speed < 0.05 then return part.Position end
	local dynamicLead = math.clamp(speed * S.SpeedMultiplier, 0, S.MaxLeadDistance)
	local totalLead = S.BasePrediction + dynamicLead
	if S.AutoPrediction then
		local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if myRoot then
			local dist = (part.Position - myRoot.Position).Magnitude
			local t = math.clamp(dist / math.max(S.MaxDistance, 1), 0, 1)
			local mult = S.PredictionMinMult + (S.PredictionMaxMult - S.PredictionMinMult) * t
			totalLead = totalLead * mult
		end
	end
	return part.Position + velocity.Unit * totalLead
end

------------------------------------------------------------------
-- AIMBOT
------------------------------------------------------------------
local function GetClosestPlayer()
	local closest, shortest = nil, S.FOV
	local mouse = UIS:GetMouseLocation()
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	for _, v in ipairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character then
			local hum = v.Character:FindFirstChild("Humanoid")
			local part = v.Character:FindFirstChild(S.TargetPartName)
			if hum and hum.Health > 0 and part and not isSameTeam(v) then
				if myRoot and (part.Position - myRoot.Position).Magnitude > S.MaxDistance then
					continue
				end
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
-- ESP
------------------------------------------------------------------
local function GetPlayerColor(player)
	return isSameTeam(player) and S.TeamColor or S.EnemyColor
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
	if not (S.ESPEnabled and S.BoxESP) then box.Visible = false return end
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
	local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
	local any = false
	for _, c in ipairs(corners) do
		local sc, on = WorldToScreen(c)
		if on then
			any = true
			minX = math.min(minX, sc.X) minY = math.min(minY, sc.Y)
			maxX = math.max(maxX, sc.X) maxY = math.max(maxY, sc.Y)
		end
	end
	if any then
		box.Position = Vector2.new(minX, minY)
		box.Size = Vector2.new(math.max(maxX - minX, 1), math.max(maxY - minY, 1))
		box.Color = color
		box.Visible = true
	else
		box.Visible = false
	end
end

local function UpdateSkeletonESP(player, character, color)
	local cache = EnsureESPCache(player)
	if not cache or not cache.skeleton then return end
	if not (S.ESPEnabled and S.SkeletonESP) then
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
		if not char or not hum or hum.Health <= 0 or not S.ESPEnabled then
			ClearPlayerESP(player) continue
		end
		local color = GetPlayerColor(player)
		UpdateBoxESP(player, char, color)
		UpdateSkeletonESP(player, char, color)
	end
end

Players.PlayerRemoving:Connect(ClearPlayerESP)

local function ApplyHighlightAndHealth(player)
	local character = player.Character
	if not character then return end
	local hum = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 1)
	if not hum then return end
	local oldHL = character:FindFirstChild("Dih_ESP")
	if oldHL then oldHL:Destroy() end
	local oldHB = character:FindFirstChild("Dih_HealthBar")
	if oldHB then oldHB:Destroy() end
	if S.HighlightESP then
		local hl = Instance.new("Highlight")
		hl.Name = "Dih_ESP"
		hl.Adornee = character
		hl.FillTransparency = 0.55
		hl.OutlineTransparency = 0
		hl.Enabled = S.ESPEnabled
		hl.Parent = character
		local function updateColor()
			local c = isSameTeam(player) and S.TeamColor or S.EnemyColor
			hl.FillColor = c hl.OutlineColor = c
		end
		updateColor()
		player:GetAttributeChangedSignal("TeamID"):Connect(updateColor)
		LocalPlayer:GetAttributeChangedSignal("TeamID"):Connect(updateColor)
	end
	local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
	if not head then return end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Dih_HealthBar"
	billboard.Adornee = head
	billboard.Size = UDim2.fromOffset(86, 9)
	billboard.StudsOffset = Vector3.new(0, 2.7, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 250
	billboard.Enabled = S.ESPEnabled
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
	healthText.TextColor3 = Color3.new(1, 1, 1)
	healthText.TextStrokeTransparency = 0.6
	healthText.Parent = bg
	local function updateHealth()
		if not hum or not hum.Parent then return end
		local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
		fill.Size = UDim2.fromScale(pct, 1)
		if pct > 0.6 then fill.BackgroundColor3 = Color3.fromRGB(50, 255, 120)
		elseif pct > 0.3 then fill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
		else fill.BackgroundColor3 = Color3.fromRGB(255, 60, 60) end
		healthText.Text = math.floor(hum.Health + 0.5) .. "/" .. math.floor(hum.MaxHealth + 0.5)
	end
	updateHealth()
	hum.HealthChanged:Connect(updateHealth)
end

local function SetAllESP(state)
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			local hl = player.Character:FindFirstChild("Dih_ESP")
			local hb = player.Character:FindFirstChild("Dih_HealthBar")
			if hl then hl.Enabled = state and S.HighlightESP
			elseif state and S.HighlightESP then ApplyHighlightAndHealth(player) end
			if hb then hb.Enabled = state end
		end
	end
	if not state then
		for player in pairs(ESPCache) do ClearPlayerESP(player) end
	end
end

local function SetupPlayerFull(player)
	player.CharacterAdded:Connect(function()
		task.defer(ApplyHighlightAndHealth, player)
	end)
	if player.Character then task.defer(ApplyHighlightAndHealth, player) end
end
for _, p in ipairs(Players:GetPlayers()) do SetupPlayerFull(p) end
Players.PlayerAdded:Connect(SetupPlayerFull)

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
	FlyBV.Name = "DihFly"
	FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	FlyBV.Velocity = Vector3.zero
	FlyBV.Parent = hrp
end

local function UpdateFly()
	if not S.FlyEnabled or not FlyBV or not FlyBV.Parent then return end
	local cam = Camera.CFrame
	local move = Vector3.zero
	if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
		move -= Vector3.yAxis
	end
	FlyBV.Velocity = move.Magnitude > 0 and move.Unit * S.FlySpeed or Vector3.zero
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
		if not S.SpeedEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end
		hum.WalkSpeed = S.WalkSpeed
		local moveDir = hum.MoveDirection
		if moveDir.Magnitude > 0.05 then
			local y = hrp.AssemblyLinearVelocity.Y
			hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * S.WalkSpeed, y, moveDir.Z * S.WalkSpeed)
		end
	end)
end

local function ApplyWalkSpeed()
	if S.SpeedEnabled then StartSpeed() else StopSpeed() end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	local hum = char:WaitForChild("Humanoid", 3)
	if hum then DefaultWalkSpeed = hum.WalkSpeed end
	if S.FlyEnabled then StartFly() end
	if S.NoclipEnabled then SetNoclip(true) end
	if S.SpeedEnabled then StartSpeed() end
end)

------------------------------------------------------------------
-- FOV CIRCLE
------------------------------------------------------------------
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "DihFOV"
FOVGui.ResetOnSpawn = false
FOVGui.IgnoreGuiInset = true
FOVGui.Parent = CoreGui

local FOVCircle = Instance.new("Frame")
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = S.ShowFOV
FOVCircle.Parent = FOVGui
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(161, 125, 170)
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.3
FOVStroke.Parent = FOVCircle

------------------------------------------------------------------
-- onChanged
------------------------------------------------------------------
local function onChanged(name, value)
	if name == "aimbot" then
		S.AimEnabled = value
	elseif name == "aimMode" then
		S.AimMode = value
	elseif name == "targetPart" then
		S.TargetPartName = (value == "Torso") and "UpperTorso" or value
	elseif name == "prediction" then
		S.PredictionEnabled = value
	elseif name == "teamCheck" then
		S.TeamCheck = value
	elseif name == "fov" then
		S.FOV = MapFOV(value)
	elseif name == "smoothing" then
		S.Smoothing = MapSmooth(value)
	elseif name == "predictionStrength" then
		S.BasePrediction = MapPred(value)
	elseif name == "maxDistance" then
		S.MaxDistance = MapDist(value)
	elseif name == "fly" then
		S.FlyEnabled = value
		if value then StartFly() else StopFly() end
	elseif name == "speed" then
		S.SpeedEnabled = value
		ApplyWalkSpeed()
	elseif name == "noclip" then
		S.NoclipEnabled = value
		SetNoclip(value)
	elseif name == "flySpeed" then
		S.FlySpeed = MapFly(value)
	elseif name == "walkSpeed" then
		S.WalkSpeed = MapWalk(value)
		if S.SpeedEnabled then ApplyWalkSpeed() end
	elseif name == "esp" then
		S.ESPEnabled = value
		SetAllESP(value)
	elseif name == "boxEsp" then
		S.BoxESP = value
	elseif name == "skeletonEsp" then
		S.SkeletonESP = value
	elseif name == "highlightEsp" then
		S.HighlightESP = value
		SetAllESP(S.ESPEnabled)
	elseif name == "fovCircle" then
		S.ShowFOV = value
		FOVCircle.Visible = value
	elseif name == "aimbot_key" then
		local e = KeyNameToEnum(value) if e then S.AimKey = e end
	elseif name == "teamCheck_key" then
		local e = KeyNameToEnum(value) if e then S.TeamKey = e end
	elseif name == "fly_key" then
		local e = KeyNameToEnum(value) if e then S.FlyKey = e end
	elseif name == "speed_key" then
		local e = KeyNameToEnum(value) if e then S.SpeedKey = e end
	elseif name == "noclip_key" then
		local e = KeyNameToEnum(value) if e then S.NoclipKey = e end
	elseif name == "esp_key" then
		local e = KeyNameToEnum(value) if e then S.ESPKey = e end
	elseif name == "box_key" then
		local e = KeyNameToEnum(value) if e then S.BoxKey = e end
	elseif name == "skeleton_key" then
		local e = KeyNameToEnum(value) if e then S.SkeletonKey = e end
	elseif name == "highlight_key" then
		local e = KeyNameToEnum(value) if e then S.HighlightKey = e end
	elseif name == "fovCircle_key" then
		local e = KeyNameToEnum(value) if e then S.FOVKey = e end
	end
	SaveConfig()
end

------------------------------------------------------------------
-- UI
------------------------------------------------------------------
local C = {
	titleBar = Color3.fromRGB(161, 125, 170),
	track = Color3.fromRGB(89, 89, 89),
	trackOn = Color3.fromRGB(161, 125, 170),
	white = Color3.new(1, 1, 1),
	gray = Color3.fromRGB(192, 192, 192),
	black = Color3.new(0, 0, 0),
	borderA = Color3.fromRGB(179, 155, 186),
	borderB = Color3.fromRGB(157, 155, 157),
	fill = Color3.fromRGB(135, 80, 155),
	tabActive = Color3.fromRGB(161, 125, 170),
}

local WINDOW_GRADIENT = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(150, 110, 160)),
	ColorSequenceKeypoint.new(0.12, Color3.fromRGB(150, 110, 160)),
	ColorSequenceKeypoint.new(0.25, Color3.fromRGB(165, 132, 173)),
	ColorSequenceKeypoint.new(0.42, Color3.fromRGB(187, 162, 192)),
	ColorSequenceKeypoint.new(0.59, Color3.fromRGB(205, 188, 209)),
	ColorSequenceKeypoint.new(0.76, Color3.fromRGB(221, 210, 223)),
	ColorSequenceKeypoint.new(0.88, Color3.fromRGB(230, 223, 232)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(237, 232, 238)),
})

local FREDOKA = Font.fromEnum(Enum.Font.FredokaOne)
local LUCKY = Font.fromEnum(Enum.Font.LuckiestGuy)

local function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
	return c
end

local function stroke(p, t, col, tr)
	local s = Instance.new("UIStroke")
	s.Thickness = t
	s.Color = col
	s.Transparency = tr or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

local function frame(parent, x, y, w, h, color, transp, radius)
	local f = Instance.new("Frame")
	f.Position = UDim2.fromOffset(x, y)
	f.Size = UDim2.fromOffset(w, h)
	f.BackgroundColor3 = color
	f.BackgroundTransparency = transp or 0
	f.BorderSizePixel = 0
	f.Parent = parent
	if radius then corner(f, radius) end
	return f
end

local function text(parent, str, font, size, x, y, w, h, color, align, outline)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Text = str
	l.FontFace = font
	l.TextSize = size
	l.TextColor3 = color or C.white
	l.Position = UDim2.fromOffset(x, y)
	l.Size = UDim2.fromOffset(w, h)
	l.TextXAlignment = align or Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.Parent = parent
	if outline ~= false then
		local s = Instance.new("UIStroke")
		s.Thickness = 1.5
		s.Color = C.black
		s.Transparency = 0.35
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		s.Parent = l
	end
	return l
end

local gui = Instance.new("ScreenGui")
gui.Name = "DihMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

local WINDOW_TRANSPARENCY = 0.15
local shadowHolder = Instance.new("Frame")
shadowHolder.Size = UDim2.fromOffset(448, 593)
shadowHolder.Position = UDim2.new(0.5, -224, 0.5, -296)
shadowHolder.BackgroundTransparency = 1
shadowHolder.ZIndex = 0
shadowHolder.Parent = gui

for i = 1, 8 do
	local grow = (i - 1) * 2
	local ring = frame(shadowHolder, -grow, 4 - grow, 448 + grow * 2, 593 + grow * 2, C.black, 1, 26 + grow)
	stroke(ring, 2, C.black, 0.8 + i * 0.022)
end

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(448, 593)
main.Position = UDim2.new(0.5, -224, 0.5, -296)
main.BackgroundColor3 = C.white
main.BackgroundTransparency = WINDOW_TRANSPARENCY
main.BorderSizePixel = 0
main.ZIndex = 1
main.Parent = gui
corner(main, 26)

local winGrad = Instance.new("UIGradient")
winGrad.Rotation = 90
winGrad.Color = WINDOW_GRADIENT
winGrad.Parent = main

main:GetPropertyChangedSignal("Position"):Connect(function()
	shadowHolder.Position = main.Position
end)

local border = stroke(main, 6, C.white, WINDOW_TRANSPARENCY * 0.5)
local bgGrad = Instance.new("UIGradient")
bgGrad.Rotation = 90
bgGrad.Color = ColorSequence.new(C.borderA, C.borderB)
bgGrad.Parent = border

local titleBar = frame(main, 13, 7, 428, 51, C.titleBar, 0, 20)
text(titleBar, "DIH SCRIPT", LUCKY, 31, 14, 0, 250, 51)

local closeBg = frame(main, 387, 14, 42, 36, C.white, 0, 8)
local cg = Instance.new("UIGradient")
cg.Rotation = 90
cg.Color = ColorSequence.new(Color3.fromRGB(255, 22, 22), Color3.fromRGB(245, 162, 162))
cg.Parent = closeBg
stroke(closeBg, 2, C.black, 0)

local close = Instance.new("TextButton")
close.Position = UDim2.fromOffset(387, 14)
close.Size = UDim2.fromOffset(42, 36)
close.BackgroundTransparency = 1
close.AutoButtonColor = false
close.Text = "X"
close.FontFace = LUCKY
close.TextSize = 27
close.TextColor3 = C.white
close.Parent = main
local xs = Instance.new("UIStroke")
xs.Thickness = 2
xs.Color = C.black
xs.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
xs.Parent = close
Instance.new("UIPadding", close).PaddingTop = UDim.new(0, 6)

local OPEN_KEY = Enum.KeyCode.RightShift
close.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

-- Tabs
local pages = {}
local tabPills = {}
local tabButtons = {}
local activeTab = "COMBAT"
local VIEW_TOP = 125

local viewport = Instance.new("Frame")
viewport.Position = UDim2.fromOffset(0, VIEW_TOP)
viewport.Size = UDim2.fromOffset(448, 458)
viewport.BackgroundTransparency = 1
viewport.ClipsDescendants = true
viewport.Parent = main

local tabDefs = {
	{ "COMBAT", 13, 81, 92, 38, 16, 90, 35, 2.0 },
	{ "MOVEMENT", 125, 81, 92, 39, 14, 90, 35, -2.35 },
	{ "VISUALS", 230, 82, 105, 36, 16, 104, 34, -0.7 },
	{ "SETTINGS", 348, 79, 93, 42, 14, 88, 34, 4.6 },
}

local setScroll

local function setTabActive(name)
	for tabName, pill in pairs(tabPills) do
		local on = (tabName == name)
		TweenService:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = on and C.tabActive or C.white,
			BackgroundTransparency = on and 0.15 or 0.4,
		}):Play()
		local btn = tabButtons[tabName]
		if btn and on then
			local base = btn.Size
			TweenService:Create(btn, TweenInfo.new(0.08), {
				Size = UDim2.fromOffset(base.X.Offset * 1.06, base.Y.Offset * 1.08),
			}):Play()
			task.delay(0.08, function()
				TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = base,
				}):Play()
			end)
		end
	end
	activeTab = name
end

local function showPage(n)
	for k, p in pairs(pages) do p.Visible = (k == n) end
	setTabActive(n)
	if setScroll then setScroll(0, true) end
end

for _, d in ipairs(tabDefs) do
	local name, x, y, w, h, ts, pw, ph, rot = table.unpack(d)
	local pill = Instance.new("Frame")
	pill.AnchorPoint = Vector2.new(0.5, 0.5)
	pill.Position = UDim2.fromOffset(x + w / 2, y + h / 2)
	pill.Size = UDim2.fromOffset(pw, ph)
	pill.Rotation = rot
	pill.BackgroundColor3 = C.white
	pill.BackgroundTransparency = 0.4
	pill.BorderSizePixel = 0
	pill.Parent = main
	corner(pill, math.floor(ph / 2))
	local pg = Instance.new("UIGradient")
	pg.Rotation = 90
	pg.Color = ColorSequence.new(Color3.fromRGB(65, 65, 65), Color3.fromRGB(128, 128, 128))
	pg.Parent = pill
	stroke(pill, 1.5, C.black, 0.4)
	tabPills[name] = pill

	local b = Instance.new("TextButton")
	b.Position = UDim2.fromOffset(x, y)
	b.Size = UDim2.fromOffset(w, h)
	b.BackgroundTransparency = 1
	b.AutoButtonColor = false
	b.Text = name
	b.FontFace = FREDOKA
	b.TextSize = ts
	b.TextColor3 = C.white
	b.Parent = main
	local ts_ = Instance.new("UIStroke")
	ts_.Thickness = 1.2
	ts_.Color = C.black
	ts_.Transparency = 0.35
	ts_.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	ts_.Parent = b
	tabButtons[name] = b

	b.MouseEnter:Connect(function()
		if activeTab ~= name then
			TweenService:Create(pill, TweenInfo.new(0.12), { BackgroundTransparency = 0.25 }):Play()
		end
	end)
	b.MouseLeave:Connect(function()
		if activeTab ~= name then
			TweenService:Create(pill, TweenInfo.new(0.12), { BackgroundTransparency = 0.4 }):Play()
		end
	end)
	b.MouseButton1Click:Connect(function()
		local orig = pill.Size
		TweenService:Create(pill, TweenInfo.new(0.07), {
			Size = UDim2.fromOffset(orig.X.Offset * 0.92, orig.Y.Offset * 0.92),
		}):Play()
		task.delay(0.07, function()
			TweenService:Create(pill, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = orig,
			}):Play()
		end)
		showPage(name)
	end)

	local page = Instance.new("Frame")
	page.Size = UDim2.fromOffset(448, 700)
	page.BackgroundTransparency = 1
	page.Position = UDim2.fromOffset(0, -VIEW_TOP)
	page.Visible = false
	page.Parent = viewport
	pages[name] = page
end

-- Scroll
local TRACK_Y, TRACK_H, THUMB_H = 132, 450, 320
local MAX_SCROLL = 220
local scrollA = 0
local track = frame(main, 433, TRACK_Y, 8, TRACK_H, C.white, 1, 4)
local thumb = frame(main, 433, TRACK_Y, 8, THUMB_H, C.white, 0.5, 4)
local targetA, shownA = 0, 0

local function applyScroll(a)
	thumb.Position = UDim2.fromOffset(433, TRACK_Y + a * (TRACK_H - THUMB_H))
	for _, pg in pairs(pages) do
		pg.Position = UDim2.fromOffset(0, -VIEW_TOP - a * MAX_SCROLL)
	end
end

function setScroll(a, snap)
	scrollA = math.clamp(a, 0, 1)
	targetA = scrollA
	if snap then shownA = targetA applyScroll(shownA) end
end

RunService.RenderStepped:Connect(function(dt)
	if math.abs(targetA - shownA) < 0.0005 then
		if shownA ~= targetA then shownA = targetA applyScroll(shownA) end
		return
	end
	shownA += (targetA - shownA) * (1 - math.exp(-dt * 14))
	applyScroll(shownA)
end)

local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch
end

local function overMenu()
	if not gui.Enabled then return false end
	local m = UIS:GetMouseLocation()
	local p, sz = main.AbsolutePosition, main.AbsoluteSize
	return m.X >= p.X and m.X <= p.X + sz.X and m.Y >= p.Y and m.Y <= p.Y + sz.Y
end

local function pointerY(i)
	if i.UserInputType == Enum.UserInputType.Touch then return i.Position.Y end
	return UIS:GetMouseLocation().Y
end

local thumbDrag, thumbGrabY
thumb.InputBegan:Connect(function(i)
	if isPress(i) then
		thumbDrag = true
		thumbGrabY = pointerY(i) - thumb.AbsolutePosition.Y
	end
end)
track.InputBegan:Connect(function(i)
	if isPress(i) then
		local y = pointerY(i) - track.AbsolutePosition.Y - THUMB_H / 2
		setScroll(y / (TRACK_H - THUMB_H))
		thumbDrag = true
		thumbGrabY = THUMB_H / 2
	end
end)

UIS.InputChanged:Connect(function(i)
	if thumbDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local y = pointerY(i) - track.AbsolutePosition.Y - thumbGrabY
		setScroll(y / (TRACK_H - THUMB_H))
	elseif i.UserInputType == Enum.UserInputType.MouseWheel then
		if overMenu() then
			setScroll(scrollA - i.Position.Z * 25 / MAX_SCROLL)
		end
	end
end)
UIS.InputEnded:Connect(function(i)
	if isPress(i) then thumbDrag = false end
end)

ContextActionService:BindActionAtPriority("DihMenuWheelSink", function()
	return overMenu() and Enum.ContextActionResult.Sink or Enum.ContextActionResult.Pass
end, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseWheel)

------------------------------------------------------------------
-- COMPONENTS
------------------------------------------------------------------
local function toggle(page, key, x, y, w)
	Settings[key] = false
	local trackBtn = Instance.new("TextButton")
	trackBtn.Position = UDim2.fromOffset(x, y)
	trackBtn.Size = UDim2.fromOffset(w, 36)
	trackBtn.BackgroundColor3 = C.track
	trackBtn.Text = ""
	trackBtn.AutoButtonColor = false
	trackBtn.Parent = page
	corner(trackBtn, 18)
	local knob = frame(trackBtn, 0, 0, 36, 36, C.white, 0, 18)

	local function apply(state, fire)
		Settings[key] = state
		knob:TweenPosition(UDim2.fromOffset(state and (w - 36) or 0, 0), "Out", "Quad", 0.12, true)
		trackBtn.BackgroundColor3 = state and C.trackOn or C.track
		if fire then onChanged(key, state) end
	end

	trackBtn.MouseButton1Click:Connect(function()
		apply(not Settings[key], true)
	end)

	ToggleControls[key] = {
		set = function(state) apply(state, true) end,
		toggle = function() apply(not Settings[key], true) end,
	}
end

local function keyBox(page, key, x, y, defaultKey, transp)
	-- prefer saved enum name if available
	local savedName = defaultKey
	local map = {
		aimbot_key = S.AimKey, teamCheck_key = S.TeamKey, fly_key = S.FlyKey,
		speed_key = S.SpeedKey, noclip_key = S.NoclipKey, esp_key = S.ESPKey,
		box_key = S.BoxKey, skeleton_key = S.SkeletonKey, highlight_key = S.HighlightKey,
		fovCircle_key = S.FOVKey,
	}
	if map[key] and typeof(map[key]) == "EnumItem" then
		savedName = map[key].Name
	end
	Settings[key] = savedName
	local b = Instance.new("TextButton")
	b.Position = UDim2.fromOffset(x, y)
	b.Size = UDim2.fromOffset(76, 36)
	b.BackgroundColor3 = C.black
	b.BackgroundTransparency = transp or 0.8
	b.AutoButtonColor = false
	b.Text = savedName
	b.FontFace = FREDOKA
	b.TextSize = 33
	b.TextColor3 = C.white
	b.Parent = page
	corner(b, 5)
	local s = Instance.new("UIStroke")
	s.Thickness = 1.5
	s.Transparency = 0.35
	s.Color = C.black
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	s.Parent = b
	onChanged(key, savedName)
	b.MouseButton1Click:Connect(function()
		b.Text = "..."
		local conn
		conn = UIS.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Keyboard then
				Settings[key] = i.KeyCode.Name
				b.Text = i.KeyCode.Name
				onChanged(key, i.KeyCode.Name)
				conn:Disconnect()
			end
		end)
	end)
end

local function selector(page, key, x, y, options)
	local start = options[1]
	if key == "aimMode" and S.AimMode then start = S.AimMode end
	if key == "targetPart" then
		if S.TargetPartName == "UpperTorso" then start = "Torso"
		elseif S.TargetPartName then start = S.TargetPartName end
	end
	if not table.find(options, start) then start = options[1] end
	Settings[key] = start
	local b = Instance.new("TextButton")
	b.Position = UDim2.fromOffset(x, y)
	b.Size = UDim2.fromOffset(121, 36)
	b.BackgroundColor3 = C.black
	b.BackgroundTransparency = 0.8
	b.AutoButtonColor = false
	b.Text = start
	b.FontFace = FREDOKA
	b.TextSize = 28
	b.TextColor3 = C.white
	b.Parent = page
	corner(b, 5)
	local s = Instance.new("UIStroke")
	s.Thickness = 1.5
	s.Transparency = 0.35
	s.Color = C.black
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	s.Parent = b
	onChanged(key, start)
	b.MouseButton1Click:Connect(function()
		local i = table.find(options, Settings[key]) or 1
		Settings[key] = options[i % #options + 1]
		b.Text = Settings[key]
		onChanged(key, Settings[key])
	end)
end

local function slider(page, key, x, y, defaultA)
	defaultA = defaultA or 0.35
	-- restore from S if possible
	if key == "fov" then defaultA = math.clamp((S.FOV - 50) / 750, 0, 1)
	elseif key == "smoothing" then defaultA = math.clamp((S.Smoothing - 0.03) / 0.97, 0, 1)
	elseif key == "predictionStrength" then defaultA = math.clamp((S.BasePrediction - 0.05) / 0.30, 0, 1)
	elseif key == "maxDistance" then defaultA = math.clamp((S.MaxDistance - 100) / 1900, 0, 1)
	elseif key == "flySpeed" then defaultA = math.clamp((S.FlySpeed - 10) / 190, 0, 1)
	elseif key == "walkSpeed" then defaultA = math.clamp((S.WalkSpeed - 16) / 184, 0, 1)
	end
	Settings[key] = defaultA
	local bar = frame(page, x - 5, y - 4, 391, 10, C.track, 0, 5)
	local fill = frame(bar, 0, 0, 9, 10, C.fill, 0, 5)
	local knob = frame(bar, 0, 0, 27, 26, C.white, 0, 13)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(0, 9, 0.5, 0)
	local dragging = false
	local function setFromX(px)
		local a = math.clamp((px - bar.AbsolutePosition.X - 9) / math.max(bar.AbsoluteSize.X - 18, 1), 0, 1)
		local kx = 9 + a * (bar.AbsoluteSize.X - 18)
		knob.Position = UDim2.new(0, kx, 0.5, 0)
		fill.Size = UDim2.fromOffset(math.max(kx, 9), 10)
		Settings[key] = a
		onChanged(key, a)
	end
	task.defer(function()
		local a = defaultA
		if bar.AbsoluteSize.X > 0 then
			local kx = 9 + a * (bar.AbsoluteSize.X - 18)
			knob.Position = UDim2.new(0, kx, 0.5, 0)
			fill.Size = UDim2.fromOffset(math.max(kx, 9), 10)
		end
		onChanged(key, a)
	end)
	knob.InputBegan:Connect(function(i) if isPress(i) then dragging = true end end)
	bar.InputBegan:Connect(function(i) if isPress(i) then dragging = true setFromX(i.Position.X) end end)
	UIS.InputEnded:Connect(function(i) if isPress(i) then dragging = false end end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			setFromX(i.Position.X)
		end
	end)
end

local function lbl(page, str, x, y, w, size, color)
	text(page, str, FREDOKA, size, x, y, w, 30, color)
end

-- COMBAT
do
	local p = pages["COMBAT"]
	lbl(p, "aimbot", 21, 157, 160, 33)
	keyBox(p, "aimbot_key", 179, 153, "T")
	toggle(p, "aimbot", 320, 153, 75)
	lbl(p, "aim mode", 21, 210, 200, 33)
	selector(p, "aimMode", 280, 212, { "Hold", "Toggle" })
	lbl(p, "target part", 21, 265, 220, 33)
	selector(p, "targetPart", 279, 267, { "Head", "Torso", "HumanoidRootPart" })
	lbl(p, "prediction", 21, 319, 200, 28)
	toggle(p, "prediction", 319, 318, 81)
	lbl(p, "team check", 21, 375, 200, 28)
	keyBox(p, "teamCheck_key", 203, 374, "Y", 0.9)
	toggle(p, "teamCheck", 320, 374, 81)
	lbl(p, "fov", 21, 431, 200, 33, C.gray)
	slider(p, "fov", 20, 480, 0.30)
	lbl(p, "smoothing", 21, 502, 200, 33, C.gray)
	slider(p, "smoothing", 23, 556, 0.12)
	lbl(p, "prediction strength", 21, 578, 300, 28, C.gray)
	slider(p, "predictionStrength", 20, 622, 0.37)
	lbl(p, "max distance", 21, 644, 250, 28, C.gray)
	slider(p, "maxDistance", 20, 688, 0.37)
end

-- MOVEMENT
do
	local p = pages["MOVEMENT"]
	lbl(p, "Fly", 21, 157, 160, 33)
	keyBox(p, "fly_key", 179, 153, "F")
	toggle(p, "fly", 320, 153, 75)
	lbl(p, "Speed", 21, 217, 160, 33)
	keyBox(p, "speed_key", 179, 213, "V")
	toggle(p, "speed", 320, 213, 75)
	lbl(p, "Noclip", 21, 277, 160, 33)
	keyBox(p, "noclip_key", 179, 273, "C")
	toggle(p, "noclip", 320, 273, 75)
	lbl(p, "Fly speed", 26, 338, 200, 28, C.gray)
	slider(p, "flySpeed", 23, 387, 0.21)
	lbl(p, "Walk Speed", 21, 431, 200, 28, C.gray)
	slider(p, "walkSpeed", 20, 480, 0.18)
end

-- VISUALS
do
	local p = pages["VISUALS"]
	lbl(p, "Toggle ESP", 21, 157, 200, 33)
	keyBox(p, "esp_key", 215, 153, "R")
	toggle(p, "esp", 320, 153, 75)
	lbl(p, "Box ESP", 21, 210, 200, 33)
	keyBox(p, "box_key", 189, 206, "B")
	toggle(p, "boxEsp", 291, 206, 75)
	lbl(p, "Skeleton ESP", 21, 263, 220, 33)
	keyBox(p, "skeleton_key", 239, 262, "K")
	toggle(p, "skeletonEsp", 338, 259, 75)
	lbl(p, "Highlight ESP", 21, 316, 230, 33)
	keyBox(p, "highlight_key", 247, 312, "L")
	toggle(p, "highlightEsp", 348, 312, 75)
	lbl(p, "FOV Circle", 21, 369, 200, 33)
	keyBox(p, "fovCircle_key", 192, 365, "G")
	toggle(p, "fovCircle", 299, 365, 71)
end

-- SETTINGS
do
	local p = pages["SETTINGS"]
	lbl(p, "RightShift = Menu", 21, 157, 400, 28, C.gray)
	lbl(p, "Settings auto-save on change", 21, 200, 400, 24, C.gray)
	lbl(p, "File: DihScriptConfig.json", 21, 240, 400, 24, C.gray)
end

showPage("COMBAT")

-- Restore toggles from config
task.defer(function()
	local pending = S._pendingToggles
	if not pending then return end
	for key, state in pairs(pending) do
		if typeof(state) == "boolean" and ToggleControls[key] then
			ToggleControls[key].set(state)
		end
	end
	S._pendingToggles = nil
	SaveConfig()
end)

-- Drag
local dragStart, startPos
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragStart, startPos = i.Position, main.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragStart and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragStart = nil
	end
end)

------------------------------------------------------------------
-- KEYBINDS
------------------------------------------------------------------
local function flip(uiKey)
	if ToggleControls[uiKey] then ToggleControls[uiKey].toggle() end
end

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == OPEN_KEY or input.KeyCode == S.ToggleKey then
		gui.Enabled = not gui.Enabled
		return
	end
	if input.KeyCode == S.AimKey then flip("aimbot")
	elseif input.KeyCode == S.ESPKey then flip("esp")
	elseif input.KeyCode == S.FOVKey then flip("fovCircle")
	elseif input.KeyCode == S.FlyKey then flip("fly")
	elseif input.KeyCode == S.SpeedKey then flip("speed")
	elseif input.KeyCode == S.NoclipKey then flip("noclip")
	elseif input.KeyCode == S.TeamKey then flip("teamCheck")
	elseif input.KeyCode == S.BoxKey then flip("boxEsp")
	elseif input.KeyCode == S.SkeletonKey then flip("skeletonEsp")
	elseif input.KeyCode == S.HighlightKey then flip("highlightEsp")
	end
end)

------------------------------------------------------------------
-- LOOPS
------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	pcall(UpdateDrawingESP)
	UpdateFly()
	if S.ShowFOV then
		local mouse = UIS:GetMouseLocation()
		FOVCircle.Position = UDim2.fromOffset(mouse.X, mouse.Y)
		FOVCircle.Size = UDim2.fromOffset(S.FOV * 2, S.FOV * 2)
		FOVCircle.Visible = true
		FOVStroke.Transparency = S.AimEnabled and (0.1 + math.sin(os.clock() * 5) * 0.08) or 0.35
	else
		FOVCircle.Visible = false
	end
	if not S.AimEnabled then return end
	local shouldAim = true
	if S.AimMode == "Hold" then
		shouldAim = UIS:IsMouseButtonPressed(S.HoldKey)
	end
	if not shouldAim then return end
	local target = GetClosestPlayer()
	if not target or not target.Character then return end
	local part = target.Character:FindFirstChild(S.TargetPartName)
	if not part then return end
	local aimPos = GetPredictedPosition(part)
	local sp, onScreen = Camera:WorldToViewportPoint(aimPos)
	if not onScreen then return end
	local mouse = UIS:GetMouseLocation()
	local dx = sp.X - mouse.X
	local dy = sp.Y - mouse.Y
	if math.abs(dx) > 0.5 or math.abs(dy) > 0.5 then
		mousemoverel(dx * S.Smoothing, dy * S.Smoothing)
	end
end)

RunService.Heartbeat:Connect(function()
	if not S.ESPEnabled then return end
	for _, p in ipairs(Players:GetPlayers()) do
		local char = p.Character
		if char then
			local hl = char:FindFirstChild("Dih_ESP")
			local hb = char:FindFirstChild("Dih_HealthBar")
			local hum = char:FindFirstChildOfClass("Humanoid")
			local alive = hum and hum.Health > 0
			if hl then hl.Enabled = alive and S.HighlightESP end
			if hb then hb.Enabled = alive end
		end
	end
end)
