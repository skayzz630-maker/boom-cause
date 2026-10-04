--[[
	DIH SCRIPT – MM2 (Fixed Fling System with Smart Target Waiting, Fly, ESP, Coin Farm, & Gun Auto-Take)
]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui           = game:GetService("CoreGui")
local UIS               = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

------------------------------------------------------------------
-- CONFIG
------------------------------------------------------------------
local ROLE_COLORS = {
	Innocent = Color3.fromRGB(80, 255, 80),
	Sheriff  = Color3.fromRGB(50, 140, 255),
	Murderer = Color3.fromRGB(255, 50, 50),
	Hero     = Color3.fromRGB(255, 210, 50),
	Unknown  = Color3.fromRGB(170, 170, 170),
}
local GUN_COLOR = Color3.fromRGB(50, 140, 255)

local CFG = {
	Enabled = true,
	maxDistance = 1500,
	gunMaxDistance = 2000,
	showBox = true,
	showLabel = true,
	showRole = true,
	showDistance = true,
	showHighlight = true,
	showSkeleton = true,
	show3DBody = true,
	showGunESP = true,
	autoTakeGun = false,
	autoTakeDelay = 0.15,
	autoFarmCoins = false,
	coinFarmDelay = 0.45,
	coinFarmSpeed = 28,
	coinFarmPause = 0.8,
	boxThickness = 1.5,
	skeletonThickness = 1.2,
	font = 2,
	fontSize = 16,
	skipLocal = true,
	rolePollRate = 0.6,
	highlightFillTrans = 0.55,
	highlightOutlineTrans = 0,
	FlyEnabled = false,
	FlySpeed = 50,
	SpeedEnabled = false,
	WalkSpeed = 50,
	NoclipEnabled = false,
	WalkFlingEnabled = false,
	FlingMurder = false,
	FlingSheriff = false,
}

local roleCache, lastRolePoll = {}, 0
local espMap, gunEspMap, cachedGuns = {}, {}, {}
local lastGunScan, GUN_SCAN_RATE = 0, 1.0
local autoTakeBusy, lastAutoTake, AUTO_TAKE_COOLDOWN = false, 0, 3
local handledGunDrops = {}
local coinFarmBusy = false
local FlyBV, FlyBG, FlyAnimTrack = nil, nil, nil
local NoclipConnection, SpeedConnection, WalkFlingConnection = nil, nil, nil
local DefaultWalkSpeed = 16

------------------------------------------------------------------
-- ROLE DETECTION
------------------------------------------------------------------
local function hasTool(player, toolName)
	local char = player.Character
	if char and char:FindFirstChild(toolName) then return true end
	local bp = player:FindFirstChild("Backpack")
	if bp and bp:FindFirstChild(toolName) then return true end
	return false
end

local function pollRolesFromServer()
	local ok, data = pcall(function()
		local rf = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
		if rf and rf:IsA("RemoteFunction") then return rf:InvokeServer() end
		return nil
	end)
	if not ok or type(data) ~= "table" then return false end
	for name, info in pairs(data) do
		local plr = Players:FindFirstChild(name)
		if plr and type(info) == "table" then
			local role = info.Role
			if type(role) == "string" and role ~= "" then
				roleCache[plr] = (info.Killed or info.Dead) and "Unknown" or role
			end
		end
	end
	return true
end

local function detectRole(player)
	if hasTool(player, "Knife") then 
		roleCache[player] = "Murderer" 
		return "Murderer" 
	end
	if hasTool(player, "Gun") then 
		roleCache[player] = "Sheriff" 
		return "Sheriff" 
	end
	if roleCache[player] and roleCache[player] ~= "Unknown" then 
		return roleCache[player] 
	end
	return "Innocent"
end

local function roleColor(role)
	return ROLE_COLORS[role] or ROLE_COLORS.Unknown
end

------------------------------------------------------------------
-- FLY
------------------------------------------------------------------
local function StopFlyAnim()
	if FlyAnimTrack then
		pcall(function() FlyAnimTrack:Stop(0.2) end)
		FlyAnimTrack = nil
	end
end

local function StartFlyAnim()
	StopFlyAnim()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://507767968"
	local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
	if ok and track then
		track.Looped = true
		track.Priority = Enum.AnimationPriority.Action
		track:Play(0.25)
		FlyAnimTrack = track
	end
end

local function StopFly()
	if FlyBV then FlyBV:Destroy() FlyBV = nil end
	if FlyBG then FlyBG:Destroy() FlyBG = nil end
	StopFlyAnim()
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = false
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
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
	FlyBV.P = 1250
	FlyBV.Velocity = Vector3.zero
	FlyBV.Parent = hrp
	FlyBG = Instance.new("BodyGyro")
	FlyBG.Name = "DihFlyGyro"
	FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	FlyBG.P = 3000
	FlyBG.D = 500
	FlyBG.CFrame = hrp.CFrame
	FlyBG.Parent = hrp
	StartFlyAnim()
end

local function UpdateFly()
	if not CFG.FlyEnabled then return end
	if coinFarmBusy then return end
	if not FlyBV or not FlyBV.Parent then
		if CFG.FlyEnabled then StartFly() end
		return
	end
	local cam = workspace.CurrentCamera
	if not cam then return end
	local camCF = cam.CFrame
	local move = Vector3.zero
	if UIS:IsKeyDown(Enum.KeyCode.W) then move += camCF.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then move -= camCF.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then move -= camCF.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then move += camCF.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
		move -= Vector3.yAxis
	end
	if move.Magnitude > 0 then
		FlyBV.Velocity = move.Unit * CFG.FlySpeed
	else
		FlyBV.Velocity = Vector3.new(0, 0.5, 0)
	end
	if FlyBG and FlyBG.Parent then
		local look = camCF.LookVector
		local flat = Vector3.new(look.X, 0, look.Z)
		if flat.Magnitude > 0.05 then
			FlyBG.CFrame = CFrame.lookAt(Vector3.zero, flat)
		else
			FlyBG.CFrame = CFrame.lookAt(Vector3.zero, look)
		end
	end
end

------------------------------------------------------------------
-- NOCLIP / SPEED / WALKFLING
------------------------------------------------------------------
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
		if not CFG.SpeedEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end
		hum.WalkSpeed = CFG.WalkSpeed
		local moveDir = hum.MoveDirection
		if moveDir.Magnitude > 0.05 then
			local y = hrp.AssemblyLinearVelocity.Y
			hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * CFG.WalkSpeed, y, moveDir.Z * CFG.WalkSpeed)
		end
	end)
end

local function ApplyWalkSpeed()
	if CFG.SpeedEnabled then StartSpeed() else StopSpeed() end
end

------------------------------------------------------------------
-- WALKFLING & ROBUST TARGET FLING SYSTEM (VOL + FLING + RETP)
------------------------------------------------------------------
local walkflinging = false
local targetFlingActive = false
local WalkFlingJumpConn = nil
local WalkFlingDiedConn = nil
local ToggleControls_Ref = {}

local function StopWalkFling()
	walkflinging = false
	if WalkFlingJumpConn then WalkFlingJumpConn:Disconnect() WalkFlingJumpConn = nil end
	if WalkFlingDiedConn then WalkFlingDiedConn:Disconnect() WalkFlingDiedConn = nil end
	local Character = LocalPlayer.Character
	if Character then
		local Root = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Root then Root.CanCollide = true end
		if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
	end
end

local function StartWalkFling()
	StopWalkFling()
	local Character = LocalPlayer.Character
	if not Character then return end
	local Root = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Root or not Humanoid then return end

	walkflinging = true
	WalkFlingDiedConn = Humanoid.Died:Connect(function() walkflinging = false end)
	WalkFlingJumpConn = UIS.JumpRequest:Connect(function()
		if walkflinging then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
	end)

	Root.CanCollide = false
	Humanoid:ChangeState(11)

	task.spawn(function()
		repeat 
			RunService.Heartbeat:Wait()
			if not Root or not Root.Parent then break end
			if not targetFlingActive then
				local vel = Root.Velocity
				Root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
				RunService.RenderStepped:Wait()
				if not targetFlingActive then
					Root.Velocity = vel
					RunService.Stepped:Wait()
					Root.Velocity = vel + Vector3.new(0, 0.1, 0)
				end
			end
		until walkflinging == false or CFG.WalkFlingEnabled == false
	end)
end

-- [ROBUST FIX] Fonction Fling Cible avec recherche intelligente et attente active
local function runTargetFling(targetRole)
	if targetFlingActive then return end
	targetFlingActive = true

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum or hum.Health <= 0 then 
		targetFlingActive = false
		return 
	end

	-- Recherche active de la cible (attend jusqu'à 6 secondes si le rôle n'est pas encore visible)
	local targetHrp = nil
	local searchStart = tick()
	while not targetHrp and (tick() - searchStart < 6) do
		pollRolesFromServer()
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local role = detectRole(player)
				if role == targetRole then
					local targetChar = player.Character
					local tHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
					local tHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
					if tHrp and tHum and tHum.Health > 0 then
						targetHrp = tHrp
						break
					end
				end
			end
		end
		if not targetHrp then
			task.wait(0.3)
			-- Vérifier si l'utilisateur a désactivé le bouton pendant l'attente
			local activeFlag = (targetRole == "Murderer" and CFG.FlingMurder) or (targetRole == "Sheriff" and CFG.FlingSheriff)
			if not activeFlag then break end
		end
	end

	-- Si aucune cible n'est trouvée après le délai, on annule proprement sans bloquer
	if not targetHrp then
		targetFlingActive = false
		CFG.FlingMurder = false
		CFG.FlingSheriff = false
		if ToggleControls_Ref["flingMurder"] then ToggleControls_Ref["flingMurder"].set(false) end
		if ToggleControls_Ref["flingSheriff"] then ToggleControls_Ref["flingSheriff"].set(false) end
		return
	end

	-- Sauvegarde de la position d'origine pour le Retp ultérieur
	local originalPos = hrp.CFrame
	hum.PlatformStand = true

	-- Désactivation temporaire des collisions du personnage local
	local colliders = {}
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			colliders[part] = part.CanCollide
			part.CanCollide = false
		end
	end
	hrp.CanCollide = true

	-- Étape 1 : Vol fluide vers la direction du joueur cible
	local approachConnection
	approachConnection = RunService.Heartbeat:Connect(function()
		if not hrp or not hrp.Parent or not targetHrp or not targetHrp.Parent then return end
		local targetPos = targetHrp.Position
		local direction = (targetPos - hrp.Position)
		if direction.Magnitude > 3 then
			hrp.AssemblyLinearVelocity = direction.Unit * 200
			hrp.CFrame = CFrame.lookAt(hrp.Position, targetPos)
		else
			hrp.AssemblyLinearVelocity = Vector3.zero
		end
	end)

	task.wait(0.8) -- Durée du vol d'approche
	if approachConnection then approachConnection:Disconnect() end

	-- Étape 2 : Exécution du Fling intense et agressif au contact de la cible
	local flingConnection
	flingConnection = RunService.Heartbeat:Connect(function()
		if not hrp or not hrp.Parent or not targetHrp or not targetHrp.Parent or hum.Health <= 0 then return end
		local tPos = targetHrp.Position
		hrp.CFrame = CFrame.new(tPos + Vector3.new(0, 0.2, 0)) * CFrame.Angles(math.random(), math.random(), math.random())
		hrp.AssemblyLinearVelocity = Vector3.new(math.random(-3000, 3000), 75000, math.random(-3000, 3000))
		hrp.AssemblyAngularVelocity = Vector3.new(75000, 75000, 75000)
	end)

	task.wait(0.9) -- Durée du fling
	if flingConnection then flingConnection:Disconnect() end

	-- Étape 3 : Téléportation de retour (Retp) à la position initiale
	local currentChar = LocalPlayer.Character
	local currentHrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
	local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
	
	if currentHrp then
		currentHrp.Anchored = true
		currentHrp.AssemblyLinearVelocity = Vector3.zero
		currentHrp.AssemblyAngularVelocity = Vector3.zero
		currentHrp.CFrame = originalPos
		
		task.wait(0.05)
		
		currentHrp.Anchored = false
		currentHrp.AssemblyLinearVelocity = Vector3.zero
		currentHrp.AssemblyAngularVelocity = Vector3.zero
	end
	
	if currentHum then
		currentHum.PlatformStand = false
		currentHum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	-- Restauration des collisions d'origine
	if currentChar then
		for _, part in ipairs(currentChar:GetDescendants()) do
			if part:IsA("BasePart") and colliders[part] ~= nil then
				part.CanCollide = colliders[part]
			end
		end
	end

	CFG.FlingMurder = false
	CFG.FlingSheriff = false
	if ToggleControls_Ref["flingMurder"] then ToggleControls_Ref["flingMurder"].set(false) end
	if ToggleControls_Ref["flingSheriff"] then ToggleControls_Ref["flingSheriff"].set(false) end
	targetFlingActive = false
end

task.spawn(function()
	while true do
		task.wait(0.2)
		if CFG.FlingMurder then
			pcall(function() runTargetFling("Murderer") end)
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.2)
		if CFG.FlingSheriff then
			pcall(function() runTargetFling("Sheriff") end)
		end
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	local hum = char:WaitForChild("Humanoid", 3)
	if hum then DefaultWalkSpeed = hum.WalkSpeed end
	if CFG.FlyEnabled then StartFly() end
	if CFG.NoclipEnabled then SetNoclip(true) end
	if CFG.SpeedEnabled then StartSpeed() end
	if CFG.WalkFlingEnabled then StartWalkFling() end
end)

------------------------------------------------------------------
-- DRAWING & ESP
------------------------------------------------------------------
local function worldToScreen(worldPos)
	if not Camera then return nil end
	local v, onScreen = Camera:WorldToViewportPoint(worldPos)
	if not onScreen or v.Z <= 0 then return nil end
	return Vector2.new(v.X, v.Y)
end

local SKELETON_R15 = {
	{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
	{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
	{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
	{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
	{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local SKELETON_R6 = {
	{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"},
}
local BODY_PARTS = {
	"Head","HumanoidRootPart","UpperTorso","LowerTorso","Torso",
	"LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm",
	"LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg",
	"Left Arm","Right Arm","Left Leg","Right Leg",
}
local BOX3D_EDGES = {
	{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8},
}

local function createESP()
	local e = {}
	e.box = Drawing.new("Square")
	e.box.Thickness = CFG.boxThickness
	e.box.Filled = false
	e.box.Visible = false
	e.nameTag = Drawing.new("Text")
	e.nameTag.Font = CFG.font
	e.nameTag.Size = CFG.fontSize
	e.nameTag.Center = true
	e.nameTag.Outline = true
	e.nameTag.OutlineColor = Color3.new(0,0,0)
	e.nameTag.Visible = false
	e.roleTag = Drawing.new("Text")
	e.roleTag.Font = CFG.font
	e.roleTag.Size = CFG.fontSize - 2
	e.roleTag.Center = true
	e.roleTag.Outline = true
	e.roleTag.OutlineColor = Color3.new(0,0,0)
	e.roleTag.Visible = false
	e.distTag = Drawing.new("Text")
	e.distTag.Font = CFG.font
	e.distTag.Size = CFG.fontSize - 4
	e.distTag.Center = true
	e.distTag.Outline = true
	e.distTag.OutlineColor = Color3.new(0,0,0)
	e.distTag.Visible = false
	e.skeleton = {}
	for i = 1, 15 do
		local ln = Drawing.new("Line")
		ln.Thickness = CFG.skeletonThickness
		ln.Visible = false
		e.skeleton[i] = ln
	end
	e.body3d = {}
	for i = 1, 12 do
		local ln = Drawing.new("Line")
		ln.Thickness = 1.4
		ln.Visible = false
		e.body3d[i] = ln
	end
	e.highlight = Instance.new("Highlight")
	e.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	e.highlight.FillTransparency = CFG.highlightFillTrans
	e.highlight.OutlineTransparency = CFG.highlightOutlineTrans
	e.highlight.Enabled = false
	e.highlight.Parent = CoreGui
	return e
end

local function removeESP(entry)
	if not entry then return end
	pcall(function() entry.box:Remove() end)
	pcall(function() entry.nameTag:Remove() end)
	pcall(function() entry.roleTag:Remove() end)
	pcall(function() entry.distTag:Remove() end)
	if entry.skeleton then for _, ln in ipairs(entry.skeleton) do pcall(function() ln:Remove() end) end end
	if entry.body3d then for _, ln in ipairs(entry.body3d) do pcall(function() ln:Remove() end) end end
	if entry.highlight then pcall(function() entry.highlight:Destroy() end) end
end

local function hideEntry(entry)
	if not entry then return end
	if entry.box then entry.box.Visible = false end
	if entry.nameTag then entry.nameTag.Visible = false end
	if entry.roleTag then entry.roleTag.Visible = false end
	if entry.distTag then entry.distTag.Visible = false end
	if entry.highlight then entry.highlight.Enabled = false end
	if entry.skeleton then for _, ln in ipairs(entry.skeleton) do ln.Visible = false end end
	if entry.body3d then for _, ln in ipairs(entry.body3d) do ln.Visible = false end end
end

local function clearAllESP()
	for player, entry in pairs(espMap) do
		removeESP(entry)
		espMap[player] = nil
	end
end

local function getBodyScreenBox(char)
	local minX, minY = math.huge, math.huge
	local maxX, maxY = -math.huge, -math.huge
	local any = false
	for _, name in ipairs(BODY_PARTS) do
		local part = char:FindFirstChild(name)
		if part and part:IsA("BasePart") then
			local sc = worldToScreen(part.Position)
			if sc then
				any = true
				minX = math.min(minX, sc.X)
				minY = math.min(minY, sc.Y)
				maxX = math.max(maxX, sc.X)
				maxY = math.max(maxY, sc.Y)
			end
		end
	end
	if not any then return nil end
	local pad = 6
	minX -= pad; minY -= pad; maxX += pad; maxY += pad
	return Vector2.new(minX, minY), Vector2.new(math.clamp(maxX-minX,8,220), math.clamp(maxY-minY,12,320))
end

local function getBodyWorldCorners(char)
	local minV = Vector3.new(math.huge, math.huge, math.huge)
	local maxV = Vector3.new(-math.huge, -math.huge, -math.huge)
	local any = false
	for _, name in ipairs(BODY_PARTS) do
		local part = char:FindFirstChild(name)
		if part and part:IsA("BasePart") then
			any = true
			local cf, size = part.CFrame, part.Size
			local half = size * 0.5
			for _, ox in ipairs({-1,1}) do
				for _, oy in ipairs({-1,1}) do
					for _, oz in ipairs({-1,1}) do
						local w = (cf * CFrame.new(half.X*ox, half.Y*oy, half.Z*oz)).Position
						minV = Vector3.new(math.min(minV.X,w.X), math.min(minV.Y,w.Y), math.min(minV.Z,w.Z))
						maxV = Vector3.new(math.max(maxV.X,w.X), math.max(maxV.Y,w.Y), math.max(maxV.Z,w.Z))
					end
				end
			end
		end
	end
	if not any then return nil end
	return {
		Vector3.new(minV.X,minV.Y,minV.Z), Vector3.new(maxV.X,minV.Y,minV.Z),
		Vector3.new(maxV.X,minV.Y,maxV.Z), Vector3.new(minV.X,minV.Y,maxV.Z),
		Vector3.new(minV.X,maxV.Y,minV.Z), Vector3.new(maxV.X,maxV.Y,minV.Z),
		Vector3.new(maxV.X,maxV.Y,maxV.Z), Vector3.new(minV.X,maxV.Y,maxV.Z),
	}
end

local function update3DBody(entry, char, col)
	if not CFG.show3DBody or not entry.body3d then
		if entry.body3d then for _, ln in ipairs(entry.body3d) do ln.Visible = false end end
		return
	end
	local corners = getBodyWorldCorners(char)
	if not corners then
		for _, ln in ipairs(entry.body3d) do ln.Visible = false end
		return
	end
	local screens, anyOn = {}, false
	for i, w in ipairs(corners) do
		local sc = worldToScreen(w)
		screens[i] = sc
		if sc then anyOn = true end
	end
	if not anyOn then
		for _, ln in ipairs(entry.body3d) do ln.Visible = false end
		return
	end
	for i, edge in ipairs(BOX3D_EDGES) do
		local ln = entry.body3d[i]
		local a, b = screens[edge[1]], screens[edge[2]]
		if a and b and ln then
			ln.From = a; ln.To = b; ln.Color = col; ln.Visible = true
		elseif ln then ln.Visible = false end
	end
end

------------------------------------------------------------------
-- AUTO TAKE GUN & COIN FARM
------------------------------------------------------------------
local function canTakeGun()
	if detectRole(LocalPlayer) == "Murderer" then return false end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end
	if hasTool(LocalPlayer, "Gun") then return false end
	return true
end

local function tryAutoTakeGun(gun)
	if not CFG.autoTakeGun or autoTakeBusy then return end
	if tick() - lastAutoTake < AUTO_TAKE_COOLDOWN then return end
	if handledGunDrops[gun] then return end
	if not gun or not gun.Parent or gun.Name ~= "GunDrop" then return end
	if not canTakeGun() then return end
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	handledGunDrops[gun] = true
	autoTakeBusy = true
	lastAutoTake = tick()
	local returnCF = hrp.CFrame
	hrp.CFrame = CFrame.new(gun.Position + Vector3.new(0, 3, 0))
	task.wait(CFG.autoTakeDelay or 0.15)
	local char2 = LocalPlayer.Character
	local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
	local hum2 = char2 and char2:FindFirstChildOfClass("Humanoid")
	if hrp2 and hum2 and hum2.Health > 0 then hrp2.CFrame = returnCF end
	autoTakeBusy = false
end

local function createGunESP()
	local e = {}
	e.box = Drawing.new("Square")
	e.box.Thickness = 1.5
	e.box.Filled = false
	e.box.Color = GUN_COLOR
	e.box.Visible = false
	e.label = Drawing.new("Text")
	e.label.Font = CFG.font
	e.label.Size = CFG.fontSize
	e.label.Center = true
	e.label.Outline = true
	e.label.OutlineColor = Color3.new(0,0,0)
	e.label.Color = GUN_COLOR
	e.label.Text = "[GUN]"
	e.label.Visible = false
	e.dist = Drawing.new("Text")
	e.dist.Font = CFG.font
	e.dist.Size = CFG.fontSize - 3
	e.dist.Center = true
	e.dist.Outline = true
	e.dist.OutlineColor = Color3.new(0,0,0)
	e.dist.Color = GUN_COLOR
	e.dist.Visible = false
	return e
end

local function removeGunESP(entry)
	if not entry then return end
	pcall(function() entry.box:Remove() end)
	pcall(function() entry.label:Remove() end)
	pcall(function() entry.dist:Remove() end)
end

local function hideGunESP(entry)
	if not entry then return end
	if entry.box then entry.box.Visible = false end
	if entry.label then entry.label.Visible = false end
	if entry.dist then entry.dist.Visible = false end
end

local function isGunDrop(obj)
	return obj and obj:IsA("BasePart") and obj.Name == "GunDrop"
end

local function onGunDropFound(gun)
	if not isGunDrop(gun) then return end
	cachedGuns[gun] = true
	if CFG.autoTakeGun then task.defer(tryAutoTakeGun, gun) end
end

local function scanForGuns()
	table.clear(cachedGuns)
	for _, child in ipairs(workspace:GetChildren()) do
		if isGunDrop(child) then onGunDropFound(child) end
		if child:IsA("Model") or child:IsA("Folder") then
			local drop = child:FindFirstChild("GunDrop")
			if isGunDrop(drop) then onGunDropFound(drop) end
			for _, sub in ipairs(child:GetChildren()) do
				if isGunDrop(sub) then onGunDropFound(sub)
				elseif sub:IsA("Model") or sub:IsA("Folder") then
					local drop2 = sub:FindFirstChild("GunDrop")
					if isGunDrop(drop2) then onGunDropFound(drop2) end
				end
			end
		end
	end
end

local hookedContainers = {}
local function hookContainer(container)
	if not container or hookedContainers[container] then return end
	hookedContainers[container] = true
	container.ChildAdded:Connect(function(child)
		task.defer(function()
			if isGunDrop(child) then onGunDropFound(child)
			elseif child:IsA("Model") or child:IsA("Folder") then
				hookContainer(child)
				local drop = child:FindFirstChild("GunDrop")
				if isGunDrop(drop) then onGunDropFound(drop) end
			end
		end)
	end)
	container.ChildRemoved:Connect(function(child)
		if isGunDrop(child) then
			cachedGuns[child] = nil
			handledGunDrops[child] = nil
			if gunEspMap[child] then removeGunESP(gunEspMap[child]) gunEspMap[child] = nil end
		end
	end)
end

hookContainer(workspace)
for _, child in ipairs(workspace:GetChildren()) do
	if child:IsA("Model") or child:IsA("Folder") then hookContainer(child) end
end
workspace.ChildAdded:Connect(function(child)
	if child:IsA("Model") or child:IsA("Folder") then
		hookContainer(child)
		task.defer(scanForGuns)
	elseif isGunDrop(child) then onGunDropFound(child) end
end)
task.defer(scanForGuns)

local function renderGunESP()
	if not CFG.Enabled or not CFG.showGunESP then
		for _, entry in pairs(gunEspMap) do hideGunESP(entry) end
		return
	end
	if tick() - lastGunScan >= GUN_SCAN_RATE then
		lastGunScan = tick()
		scanForGuns()
	end
	Camera = workspace.CurrentCamera
	if not Camera then return end
	local camPos = Camera.CFrame.Position
	local active = {}
	for gun in pairs(cachedGuns) do
		if not gun.Parent then cachedGuns[gun] = nil continue end
		active[gun] = true
		local pos = gun.Position
		local dist = (pos - camPos).Magnitude
		if dist > CFG.gunMaxDistance then
			if gunEspMap[gun] then hideGunESP(gunEspMap[gun]) end
			continue
		end
		local sc = worldToScreen(pos)
		if not sc then
			if gunEspMap[gun] then hideGunESP(gunEspMap[gun]) end
			continue
		end
		local entry = gunEspMap[gun]
		if not entry then entry = createGunESP() gunEspMap[gun] = entry end
		local size = 28
		entry.box.Position = Vector2.new(sc.X - size/2, sc.Y - size/2)
		entry.box.Size = Vector2.new(size, size)
		entry.box.Visible = true
		entry.label.Text = "[GUN]"
		entry.label.Position = Vector2.new(sc.X, sc.Y - 22)
		entry.label.Visible = true
		entry.dist.Text = math.floor(dist) .. "m"
		entry.dist.Position = Vector2.new(sc.X, sc.Y + 18)
		entry.dist.Visible = true
	end
	for gun, entry in pairs(gunEspMap) do
		if not active[gun] then removeGunESP(entry) gunEspMap[gun] = nil end
	end
end

------------------------------------------------------------------
-- AUTO FARM COINS
------------------------------------------------------------------
local function isCoin(obj)
	return obj and obj:IsA("BasePart") and obj.Name == "Coin_Server"
end

local function findCoinContainer()
	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name == "CoinContainer" then return child end
		if child:IsA("Model") or child:IsA("Folder") then
			local cc = child:FindFirstChild("CoinContainer")
			if cc then return cc end
			for _, sub in ipairs(child:GetChildren()) do
				if sub:IsA("Model") or sub:IsA("Folder") then
					local cc2 = sub:FindFirstChild("CoinContainer")
					if cc2 then return cc2 end
				end
			end
		end
	end
	return nil
end

local function moveToward(hrp, targetPos, speed, timeout)
	local start = tick()
	timeout = timeout or 15
	while tick() - start < timeout do
		if not CFG.autoFarmCoins then return false end
		if not hrp or not hrp.Parent then return false end
		local delta = targetPos - hrp.Position
		local dist = delta.Magnitude
		if dist < 5 then
			if FlyBV and FlyBV.Parent then FlyBV.Velocity = Vector3.zero end
			return true
		end
		local dir = delta.Unit
		local useSpeed = speed
		if dist < 20 then
			useSpeed = math.max(12, speed * 0.45)
		end
		if FlyBV and FlyBV.Parent then
			FlyBV.Velocity = dir * useSpeed
		else
			hrp.AssemblyLinearVelocity = dir * useSpeed
		end
		local flat = Vector3.new(dir.X, 0, dir.Z)
		if flat.Magnitude > 0.05 then
			hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat)
		end
		task.wait(0.05)
	end
	return false
end

local function farmCoinsOnce()
	if coinFarmBusy or not CFG.autoFarmCoins then return end
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum or hum.Health <= 0 then return end

	local container = findCoinContainer()
	if not container then return end

	local list = {}
	for _, obj in ipairs(container:GetDescendants()) do
		if isCoin(obj) then table.insert(list, obj) end
	end
	if #list == 0 then return end

	table.sort(list, function(a, b)
		return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
	end)

	local maxPerCycle = math.min(#list, 4)
	local batch = {}
	for i = 1, maxPerCycle do batch[i] = list[i] end

	coinFarmBusy = true
	local wasFlying = CFG.FlyEnabled
	if not wasFlying then CFG.FlyEnabled = true StartFly() end
	local wasNoclip = CFG.NoclipEnabled
	if not wasNoclip then CFG.NoclipEnabled = true SetNoclip(true) end

	local farmSpeed = CFG.coinFarmSpeed or 28

	for _, coin in ipairs(batch) do
		if not CFG.autoFarmCoins then break end
		if not coin.Parent then continue end
		char = LocalPlayer.Character
		hrp = char and char:FindFirstChild("HumanoidRootPart")
		hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum or hum.Health <= 0 then break end

		moveToward(hrp, coin.Position + Vector3.new(0, 2, 0), farmSpeed, 18)
		task.wait(CFG.coinFarmDelay or 0.45)
		if FlyBV and FlyBV.Parent then FlyBV.Velocity = Vector3.new(0, 0.3, 0) end
		task.wait(CFG.coinFarmPause or 0.8)
	end

	if FlyBV and FlyBV.Parent then FlyBV.Velocity = Vector3.zero end

	if not wasFlying then CFG.FlyEnabled = false StopFly() end
	if not wasNoclip then CFG.NoclipEnabled = false SetNoclip(false) end
	coinFarmBusy = false
end

task.spawn(function()
	while true do
		task.wait(2.5)
		if CFG.autoFarmCoins and not coinFarmBusy then
			pcall(farmCoinsOnce)
		end
	end
end)

------------------------------------------------------------------
-- PLAYER RENDER
------------------------------------------------------------------
local function render()
	if not CFG.Enabled then
		for _, entry in pairs(espMap) do hideEntry(entry) end
		return
	end
	Camera = workspace.CurrentCamera
	if not Camera then return end
	if tick() - lastRolePoll > CFG.rolePollRate then
		lastRolePoll = tick()
		pollRolesFromServer()
	end
	local camPos = Camera.CFrame.Position
	local activeSet = {}
	for _, player in ipairs(Players:GetPlayers()) do
		activeSet[player] = true
		if CFG.skipLocal and player == LocalPlayer then continue end
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not char or not hum or hum.Health <= 0 then
			if espMap[player] then removeESP(espMap[player]) espMap[player] = nil end
			continue
		end
		local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
		if not hrp then continue end
		local dist = (hrp.Position - camPos).Magnitude
		if dist > CFG.maxDistance then
			if espMap[player] then hideEntry(espMap[player]) end
			continue
		end
		local role = detectRole(player)
		local col = roleColor(role)
		local entry = espMap[player]
		if not entry then entry = createESP() espMap[player] = entry end

		if CFG.showHighlight then
			entry.highlight.Adornee = char
			entry.highlight.FillColor = col
			entry.highlight.OutlineColor = col
			entry.highlight.Enabled = true
		else entry.highlight.Enabled = false end

		local boxPos, boxSize = getBodyScreenBox(char)
		if not boxPos then
			if entry.box then entry.box.Visible = false end
			if entry.nameTag then entry.nameTag.Visible = false end
			if entry.roleTag then entry.roleTag.Visible = false end
			if entry.distTag then entry.distTag.Visible = false end
			if entry.skeleton then for _, ln in ipairs(entry.skeleton) do ln.Visible = false end end
			if entry.body3d then for _, ln in ipairs(entry.body3d) do ln.Visible = false end end
			continue
		end

		entry.box.Position = boxPos
		entry.box.Size = boxSize
		entry.box.Color = col
		entry.box.Visible = CFG.showBox

		local head = char:FindFirstChild("Head")
		local headScreen = head and worldToScreen(head.Position + Vector3.new(0, 0.6, 0))
			or Vector2.new(boxPos.X + boxSize.X/2, boxPos.Y - 8)

		if CFG.showLabel then
			entry.nameTag.Text = player.Name
			entry.nameTag.Color = col
			entry.nameTag.Position = headScreen
			entry.nameTag.Size = CFG.fontSize
			entry.nameTag.Visible = true
		else entry.nameTag.Visible = false end

		if CFG.showRole then
			entry.roleTag.Text = "[" .. role .. "]"
			entry.roleTag.Color = col
			entry.roleTag.Position = headScreen + Vector2.new(0, CFG.fontSize + 2)
			entry.roleTag.Size = CFG.fontSize - 2
			entry.roleTag.Visible = true
		else entry.roleTag.Visible = false end

		if CFG.showDistance then
			entry.distTag.Text = math.floor(dist) .. "m"
			entry.distTag.Color = col
			entry.distTag.Position = headScreen - Vector2.new(0, CFG.fontSize + 4)
			entry.distTag.Size = CFG.fontSize - 4
			entry.distTag.Visible = true
		else entry.distTag.Visible = false end

		if CFG.showSkeleton then
			local connections = (char:FindFirstChild("Torso") and not char:FindFirstChild("UpperTorso")) and SKELETON_R6 or SKELETON_R15
			local lineIdx = 1
			for _, pair in ipairs(connections) do
				local partA, partB = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
				local ln = entry.skeleton[lineIdx]
				if partA and partB and ln then
					local pA, pB = worldToScreen(partA.Position), worldToScreen(partB.Position)
					if pA and pB then ln.From = pA ln.To = pB ln.Color = col ln.Visible = true
					else ln.Visible = false end
				elseif ln then ln.Visible = false end
				lineIdx += 1
			end
			for i = lineIdx, #entry.skeleton do entry.skeleton[i].Visible = false end
		else
			for _, ln in ipairs(entry.skeleton) do ln.Visible = false end
		end
		update3DBody(entry, char, col)
	end
	for player, entry in pairs(espMap) do
		if not activeSet[player] then
			removeESP(entry)
			espMap[player] = nil
			roleCache[player] = nil
		end
	end
end

Players.PlayerRemoving:Connect(function(player)
	removeESP(espMap[player])
	espMap[player] = nil
	roleCache[player] = nil
end)

pcall(function()
	local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
	if remotes then
		local gameplay = remotes:FindFirstChild("Gameplay")
		if gameplay then
			local roundEnd = gameplay:FindFirstChild("RoundEndFade") or gameplay:FindFirstChild("VictoryScreen")
			if roundEnd then
				roundEnd.OnClientEvent:Connect(function()
					table.clear(roleCache)
					table.clear(handledGunDrops)
				end)
			end
		end
	end
end)

task.spawn(function()
	task.wait(1)
	pollRolesFromServer()
end)

RunService.RenderStepped:Connect(function()
	render()
	renderGunESP()
	UpdateFly()
end)

------------------------------------------------------------------
-- HUB UI SETUP
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
	ColorSequenceKeypoint.new(0.25, Color3.fromRGB(165, 132, 173)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(205, 188, 209)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(221, 210, 223)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(237, 232, 238)),
})

local FREDOKA = Font.fromEnum(Enum.Font.FredokaOne)
local LUCKY = Font.fromEnum(Enum.Font.LuckiestGuy)
local OPEN_KEY = Enum.KeyCode.RightShift
local Settings = {}
local ToggleControls = {}
ToggleControls_Ref = ToggleControls

local S = {
	ESPKey = Enum.KeyCode.R,
	BoxKey = Enum.KeyCode.B,
	SkeletonKey = Enum.KeyCode.K,
	HighlightKey = Enum.KeyCode.L,
	LabelKey = Enum.KeyCode.N,
	RoleKey = Enum.KeyCode.M,
	DistKey = Enum.KeyCode.J,
	Body3DKey = Enum.KeyCode.U,
	GunKey = Enum.KeyCode.P,
	AutoTakeKey = Enum.KeyCode.G,
	FlyKey = Enum.KeyCode.F,
	SpeedKey = Enum.KeyCode.V,
	NoclipKey = Enum.KeyCode.C,
	CoinFarmKey = Enum.KeyCode.H,
	WalkFlingKey = Enum.KeyCode.Y,
	FlingMurderKey = Enum.KeyCode.T,
	FlingSheriffKey = Enum.KeyCode.X,
}

local function MapFly(a) return math.floor(10 + a * 190 + 0.5) end
local function MapWalk(a) return math.floor(16 + a * 184 + 0.5) end

local function onChanged(name, value)
	if name == "esp" then
		CFG.Enabled = value
		if not value then
			clearAllESP()
			for g, e in pairs(gunEspMap) do removeGunESP(e) gunEspMap[g] = nil end
		end
	elseif name == "boxEsp" then CFG.showBox = value
	elseif name == "skeletonEsp" then CFG.showSkeleton = value
	elseif name == "highlightEsp" then CFG.showHighlight = value
	elseif name == "labelEsp" then CFG.showLabel = value
	elseif name == "roleEsp" then CFG.showRole = value
	elseif name == "distanceEsp" then CFG.showDistance = value
	elseif name == "body3dEsp" then CFG.show3DBody = value
	elseif name == "gunEsp" then
		CFG.showGunESP = value
		if not value then
			for g, e in pairs(gunEspMap) do removeGunESP(e) gunEspMap[g] = nil end
		end
	elseif name == "autoTakeGun" then CFG.autoTakeGun = value
	elseif name == "autoFarmCoins" then CFG.autoFarmCoins = value
	elseif name == "flingMurder" then CFG.FlingMurder = value 
	elseif name == "flingSheriff" then CFG.FlingSheriff = value 
	elseif name == "maxDistance" then CFG.maxDistance = math.floor(200 + value * 2800 + 0.5)
	elseif name == "fly" then
		CFG.FlyEnabled = value
		if value then StartFly() else StopFly() end
	elseif name == "speed" then
		CFG.SpeedEnabled = value
		ApplyWalkSpeed()
	elseif name == "noclip" then
		CFG.NoclipEnabled = value
		SetNoclip(value)
	elseif name == "walkFling" then
		CFG.WalkFlingEnabled = value
		if value then StartWalkFling() else StopWalkFling() end
	elseif name == "flySpeed" then CFG.FlySpeed = MapFly(value)
	elseif name == "walkSpeed" then
		CFG.WalkSpeed = MapWalk(value)
		if CFG.SpeedEnabled then ApplyWalkSpeed() end
	end
end

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

local function text(parent, str, font, size, x, y, w, h, color)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Text = str
	l.FontFace = font
	l.TextSize = size
	l.TextColor3 = color or C.white
	l.Position = UDim2.fromOffset(x, y)
	l.Size = UDim2.fromOffset(w, h)
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.Parent = parent
	local s = Instance.new("UIStroke")
	s.Thickness = 1.5
	s.Color = C.black
	s.Transparency = 0.35
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	s.Parent = l
	return l
end

local function lbl(page, str, x, y, w, h, color)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Text = str
	l.FontFace = FREDOKA
	l.TextSize = h - 8
	l.TextColor3 = color or C.white
	l.Position = UDim2.fromOffset(x, y)
	l.Size = UDim2.fromOffset(w, h)
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.Parent = page
	local s = Instance.new("UIStroke")
	s.Thickness = 1.5
	s.Color = C.black
	s.Transparency = 0.35
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	s.Parent = l
	return l
end

local gui = Instance.new("ScreenGui")
gui.Name = "DihMM2Menu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

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
main.BackgroundTransparency = 0.15
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

local border = stroke(main, 6, C.white, 0.08)
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
xs.Transparency = 0
xs.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
xs.Parent = close
Instance.new("UIPadding", close).PaddingTop = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui.Enabled = false end)

local pages, tabPills = {}, {}
local activeTab = "INNOCENT"
local VIEW_TOP = 125

local viewport = Instance.new("Frame")
viewport.Position = UDim2.fromOffset(0, VIEW_TOP)
viewport.Size = UDim2.fromOffset(448, 458)
viewport.BackgroundTransparency = 1
viewport.ClipsDescendants = true
viewport.Parent = main

local tabDefs = {
	{ "INNOCENT", 10,  81, 100, 38, 13, 98,  35, 1.5 },
	{ "MURDER",   114, 81, 100, 38, 13, 98,  35, -1.0 },
	{ "SHERIFF",  218, 81, 100, 38, 13, 98,  35, 1.0 },
	{ "EVERYONE", 322, 81, 115, 38, 11, 112, 35, -1.2 },
}

local setScroll
local function setTabActive(name)
	for tabName, pill in pairs(tabPills) do
		local on = (tabName == name)
		TweenService:Create(pill, TweenInfo.new(0.18), {
			BackgroundColor3 = on and C.tabActive or C.white,
			BackgroundTransparency = on and 0.15 or 0.4,
		}):Play()
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
	pill.Position = UDim2.fromOffset(x + w/2, y + h/2)
	pill.Size = UDim2.fromOffset(pw, ph)
	pill.Rotation = rot
	pill.BackgroundColor3 = C.white
	pill.BackgroundTransparency = 0.4
	pill.BorderSizePixel = 0
	pill.Parent = main
	corner(pill, math.floor(ph/2))
	local pg = Instance.new("UIGradient")
	pg.Rotation = 90
	pg.Color = ColorSequence.new(Color3.fromRGB(65,65,65), Color3.fromRGB(128,128,128))
	pg.Parent = pill
	stroke(pill, 1.5, C.black, 0.4)
	tabPills[name] = pill

	local b = Instance.new("TextButton")
	b.Position = UDim2.fromOffset(x, y)
	b.Size = UDim2.fromOffset(w, h)
	b.BackgroundTransparency = 1
	b.Text = name
	b.FontFace = FREDOKA
	b.TextSize = ts
	b.TextColor3 = C.white
	b.Parent = main
	b.MouseButton1Click:Connect(function()
		local orig = pill.Size
		TweenService:Create(pill, TweenInfo.new(0.07), {
			Size = UDim2.fromOffset(orig.X.Offset * 0.92, orig.Y.Offset * 0.92),
		}):Play()
		task.delay(0.07, function()
			TweenService:Create(pill, TweenInfo.new(0.14, Enum.EasingStyle.Back), { Size = orig }):Play()
		end)
		showPage(name)
	end)

	local page = Instance.new("Frame")
	page.Size = UDim2.fromOffset(448, 1000)
	page.BackgroundTransparency = 1
	page.Position = UDim2.fromOffset(0, -VIEW_TOP)
	page.Visible = false
	page.Parent = viewport
	pages[name] = page
end

local TRACK_Y, TRACK_H, THUMB_H = 132, 450, 240
local MAX_SCROLL = 450
local scrollA, targetA, shownA = 0, 0, 0
local track = frame(main, 433, TRACK_Y, 8, TRACK_H, C.white, 1, 4)
local thumb = frame(main, 433, TRACK_Y, 8, THUMB_H, C.white, 0.5, 4)

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
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function overMenu()
	if not gui.Enabled then return false end
	local m = UIS:GetMouseLocation()
	local p, sz = main.AbsolutePosition, main.AbsoluteSize
	return m.X >= p.X and m.X <= p.X + sz.X and m.Y >= p.Y and m.Y <= p.Y + sz.Y
end

UIS.InputChanged:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseWheel and overMenu() then
		setScroll(scrollA - i.Position.Z * 25 / MAX_SCROLL)
	end
end)

ContextActionService:BindActionAtPriority("DihMM2Wheel", function()
	return overMenu() and Enum.ContextActionResult.Sink or Enum.ContextActionResult.Pass
end, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseWheel)

local function toggle(page, key, x, y, w, defaultOn)
	Settings[key] = defaultOn == true
	local trackBtn = Instance.new("TextButton")
	trackBtn.Position = UDim2.fromOffset(x, y)
	trackBtn.Size = UDim2.fromOffset(w, 36)
	trackBtn.BackgroundColor3 = Settings[key] and C.trackOn or C.track
	trackBtn.Text = ""
	trackBtn.AutoButtonColor = false
	trackBtn.Parent = page
	corner(trackBtn, 18)
	local knob = frame(trackBtn, Settings[key] and (w - 36) or 0, 0, 36, 36, C.white, 0, 18)
	local function apply(state, fire)
		Settings[key] = state
		knob:TweenPosition(UDim2.fromOffset(state and (w - 36) or 0, 0), "Out", "Quad", 0.12, true)
		trackBtn.BackgroundColor3 = state and C.trackOn or C.track
		if fire then onChanged(key, state) end
	end
	trackBtn.MouseButton1Click:Connect(function() apply(not Settings[key], true) end)
	ToggleControls[key] = {
		set = function(state) apply(state, true) end,
		toggle = function() apply(not Settings[key], true) end,
	}
	if defaultOn then onChanged(key, true) end
end

local function keyBox(page, key, x, y, defaultKey)
	Settings[key] = defaultKey
	local b = Instance.new("TextButton")
	b.Position = UDim2.fromOffset(x, y)
	b.Size = UDim2.fromOffset(76, 36)
	b.BackgroundColor3 = C.black
	b.BackgroundTransparency = 0.8
	b.AutoButtonColor = false
	b.Text = defaultKey
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
	b.MouseButton1Click:Connect(function()
		b.Text = "..."
		local conn
		conn = UIS.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Keyboard then
				Settings[key] = i.KeyCode.Name
				b.Text = i.KeyCode.Name
				conn:Disconnect()
			end
		end)
	end)
end

local function slider(page, key, x, y, defaultA)
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
		if bar.AbsoluteSize.X > 0 then
			local kx = 9 + defaultA * (bar.AbsoluteSize.X - 18)
			knob.Position = UDim2.new(0, kx, 0.5, 0)
			fill.Size = UDim2.fromOffset(math.max(kx, 9), 10)
		end
		onChanged(key, defaultA)
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

-- INNOCENT TAB
do
	local p = pages["INNOCENT"]
	lbl(p, "Auto Farm Coins", 21, 157, 240, 33)
	keyBox(p, "coinFarm_key", 240, 153, "H")
	toggle(p, "autoFarmCoins", 330, 153, 75, false)

	lbl(p, "Auto Take Gun", 21, 215, 240, 33)
	keyBox(p, "autoTake_key", 240, 211, "G")
	toggle(p, "autoTakeGun", 330, 211, 75, false)
end

-- MURDER TAB
do
	local p = pages["MURDER"]
	lbl(p, "Fling Murderer", 21, 157, 240, 33)
	keyBox(p, "flingMurder_key", 240, 153, "T")
	toggle(p, "flingMurder", 330, 153, 75, false)

	lbl(p, "Fling Sheriff", 21, 215, 240, 33)
	keyBox(p, "flingSheriff_key", 240, 211, "X")
	toggle(p, "flingSheriff", 330, 211, 75, false)
end

-- SHERIFF TAB
do
	local p = pages["SHERIFF"]
	lbl(p, "RightShift = Menu", 21, 157, 400, 28, C.gray)
	lbl(p, "Coins: slow fly, 4 per cycle", 21, 200, 400, 22, C.gray)
	lbl(p, "Walk Fling: Velocity Based", 21, 240, 400, 22, C.gray)
	lbl(p, "Fly: WASD + Space/Ctrl", 21, 280, 400, 22, C.gray)
	lbl(p, "Murderer red · Sheriff blue · Innocent green", 21, 320, 400, 20, C.gray)
end

-- EVERYONE TAB
do
	local p = pages["EVERYONE"]
	lbl(p, "Toggle ESP", 21, 157, 200, 33)
	keyBox(p, "esp_key", 215, 153, "R")
	toggle(p, "esp", 320, 153, 75, true)

	lbl(p, "Box ESP", 21, 210, 200, 33)
	keyBox(p, "box_key", 189, 206, "B")
	toggle(p, "boxEsp", 291, 206, 75, true)

	lbl(p, "Skeleton ESP", 21, 263, 220, 33)
	keyBox(p, "skeleton_key", 239, 262, "K")
	toggle(p, "skeletonEsp", 338, 259, 75, true)

	lbl(p, "Highlight ESP", 21, 316, 230, 33)
	keyBox(p, "highlight_key", 247, 312, "L")
	toggle(p, "highlightEsp", 348, 312, 75, true)

	lbl(p, "Name Label", 21, 369, 200, 33)
	keyBox(p, "label_key", 200, 365, "N")
	toggle(p, "labelEsp", 300, 365, 75, true)

	lbl(p, "Role Tag", 21, 422, 200, 33)
	keyBox(p, "role_key", 180, 418, "M")
	toggle(p, "roleEsp", 280, 418, 75, true)

	lbl(p, "Distance", 21, 475, 200, 33)
	keyBox(p, "distance_key", 180, 471, "J")
	toggle(p, "distanceEsp", 280, 471, 75, true)

	lbl(p, "3D Body ESP", 21, 528, 220, 33)
	keyBox(p, "body3d_key", 230, 524, "U")
	toggle(p, "body3dEsp", 330, 524, 75, true)

	lbl(p, "Gun Drop ESP", 21, 581, 220, 33)
	keyBox(p, "gun_key", 230, 577, "P")
	toggle(p, "gunEsp", 330, 577, 75, true)

	lbl(p, "Fly", 21, 640, 160, 33)
	keyBox(p, "fly_key", 179, 636, "F")
	toggle(p, "fly", 320, 636, 75, false)

	lbl(p, "Speed", 21, 700, 160, 33)
	keyBox(p, "speed_key", 179, 696, "V")
	toggle(p, "speed", 320, 696, 75, false)

	lbl(p, "Noclip", 21, 760, 160, 33)
	keyBox(p, "noclip_key", 179, 756, "C")
	toggle(p, "noclip", 320, 756, 75, false)

	lbl(p, "Walk Fling", 21, 820, 200, 33)
	keyBox(p, "walkFling_key", 200, 816, "Y")
	toggle(p, "walkFling", 320, 816, 75, false)

	lbl(p, "max distance", 21, 885, 250, 28, C.gray)
	slider(p, "maxDistance", 20, 930, math.clamp((CFG.maxDistance - 200) / 2800, 0, 1))

	lbl(p, "Fly speed", 21, 980, 200, 28, C.gray)
	slider(p, "flySpeed", 20, 1025, math.clamp((CFG.FlySpeed - 10) / 190, 0, 1))

	lbl(p, "Walk Speed", 21, 1075, 200, 28, C.gray)
	slider(p, "walkSpeed", 20, 1120, math.clamp((CFG.WalkSpeed - 16) / 184, 0, 1))
end

showPage("INNOCENT")

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

local function flip(uiKey)
	if ToggleControls[uiKey] then ToggleControls[uiKey].toggle() end
end

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == OPEN_KEY then
		gui.Enabled = not gui.Enabled
		return
	end
	if input.KeyCode == S.ESPKey then flip("esp")
	elseif input.KeyCode == S.BoxKey then flip("boxEsp")
	elseif input.KeyCode == S.SkeletonKey then flip("skeletonEsp")
	elseif input.KeyCode == S.HighlightKey then flip("highlightEsp")
	elseif input.KeyCode == S.LabelKey then flip("labelEsp")
	elseif input.KeyCode == S.RoleKey then flip("roleEsp")
	elseif input.KeyCode == S.DistKey then flip("distanceEsp")
	elseif input.KeyCode == S.Body3DKey then flip("body3dEsp")
	elseif input.KeyCode == S.GunKey then flip("gunEsp")
	elseif input.KeyCode == S.AutoTakeKey then flip("autoTakeGun")
	elseif input.KeyCode == S.FlyKey then flip("fly")
	elseif input.KeyCode == S.SpeedKey then flip("speed")
	elseif input.KeyCode == S.NoclipKey then flip("noclip")
	elseif input.KeyCode == S.WalkFlingKey then flip("walkFling")
	elseif input.KeyCode == S.FlingMurderKey then flip("flingMurder")
	elseif input.KeyCode == S.FlingSheriffKey then flip("flingSheriff")
	end
end)
