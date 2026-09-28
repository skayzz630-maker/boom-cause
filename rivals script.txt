local _0x653D = game:GetService("UserInputService")
local _0xEEF5 = game:GetService("RunService")
local _0x091D = game:GetService("Players")
local _0xA5B9 = game:GetService("TweenService")
local _0x4EB0 = game:GetService("CoreGui")
local _0x6EEA = _0x091D.LocalPlayer
local _0xD10B = workspace.CurrentCamera
local _0x4FE5 = nil
local _0x8669 = {}
local _0x11E3 = {}
local _0xFD06 = pcall(function() return Drawing and Drawing.new end)local _0x3F0A = {
AimEnabled = false,
TargetPartName ="Head",
FOV = 280,
Smoothing = 0.15,
MaxDistance = 800,
TeamCheck = true,
HoldKey = Enum.UserInputType.MouseButton2,PredictionEnabled = true,
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
}local _0x3024 = {
Accent = Color3.fromRGB(0, 180, 255),
Bg = Color3.fromRGB(12, 12, 16),
Bg2 = Color3.fromRGB(18, 18, 24),
Bg3 = Color3.fromRGB(26, 26, 34),
Bg4 = Color3.fromRGB(34, 34, 44),
Text = Color3.fromRGB(240, 240, 245),
TextDim = Color3.fromRGB(140, 140, 155),
Success = Color3.fromRGB(50, 220, 130),
Danger = Color3.fromRGB(240, 70, 70),
Warning = Color3.fromRGB(255, 190, 60),
Stroke = Color3.fromRGB(45, 48, 60),
}local function _0xAAE0(player)
if not _0x3F0A.TeamCheck then return false end
local _0xE094 = _0x6EEA:GetAttribute("TeamID")
local _0xA1D9 = player:GetAttribute("TeamID")
if typeof(_0xE094) ~="string"or typeof(_0xA1D9) ~="string"then return false end
return _0xE094 == _0xA1D9
endlocal function _0xDE1E(_0x8D22)
if not _0x3F0A.PredictionEnabled then
return _0x8D22.Position
end
local _0x0125 = _0x8D22.Parent
if not _0x0125 then return _0x8D22.Position end
local _0xF968 = _0x0125:FindFirstChild("HumanoidRootPart")
if not _0xF968 then return _0x8D22.Position endlocal _0x9F09 = _0xF968.AssemblyLinearVelocity
return _0x8D22.Position + (_0x9F09 * _0x3F0A.PredictionStrength)
endlocal function _0xE55E(player)
return _0xAAE0(player) and _0x3F0A.TeamColor or _0x3F0A.EnemyColor
end
local function _0xEBAC(player)
local _0x4B70 = _0x11E3[player]
if not _0x4B70 then return end
if _0x4B70.box then pcall(function() _0x4B70.box:Remove() end) end
if _0x4B70.skeleton then
for _, _0x2756 in pairs(_0x4B70.skeleton) do pcall(function() _0x2756:Remove() end) end
end
_0x11E3[player] = nil
end
local function _0x2F81()
local _0x52C8 = Drawing.new("Square")
_0x52C8.Thickness = 1.5
_0x52C8.Filled = false
_0x52C8.Visible = false
_0x52C8.ZIndex = 2
return _0x52C8
end
local function _0xC141()
local _0x2756 = Drawing.new("Line")
_0x2756.Thickness = 1.5
_0x2756.Visible = false
_0x2756.ZIndex = 2
return _0x2756
end
local _0x6ABB = {
{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"},
}
local function _0x834B(player)
if _0x11E3[player] then return _0x11E3[player] end
if not _0xFD06 then return nil end
local _0x4B70 = { _0x52C8 = _0x2F81(), skeleton = {} }
for i = 1, #_0x6ABB do _0x4B70.skeleton[i] = _0xC141() end
_0x11E3[player] = _0x4B70
return _0x4B70
end
local function _0x3381(_0x4D6E)
local _0xB3D5, _0xF6D8 = _0xD10B:WorldToViewportPoint(_0x4D6E)
return Vector2.new(_0xB3D5.X, _0xB3D5.Y), _0xF6D8
end
local function _0x787C(player, _0x0125, _0x381F)
local _0x4B70 = _0x834B(player)
if not _0x4B70 or not _0x4B70.box then return end
local _0x52C8 = _0x4B70.box
if not (_0x3F0A.ESPEnabled and _0x3F0A.BoxESP) then _0x52C8.Visible = false return end
local _0x026C, _0x8BE0, _0x766F = pcall(function() return _0x0125:GetBoundingBox() end)
if not _0x026C or not _0x8BE0 then _0x52C8.Visible = false return end
local _0x46A8 = {
(_0x8BE0 * CFrame.new( _0x766F.X/2, _0x766F.Y/2, _0x766F.Z/2)).Position,
(_0x8BE0 * CFrame.new(-_0x766F.X/2, _0x766F.Y/2, _0x766F.Z/2)).Position,
(_0x8BE0 * CFrame.new( _0x766F.X/2, -_0x766F.Y/2, _0x766F.Z/2)).Position,
(_0x8BE0 * CFrame.new(-_0x766F.X/2, -_0x766F.Y/2, _0x766F.Z/2)).Position,
(_0x8BE0 * CFrame.new( _0x766F.X/2, _0x766F.Y/2, -_0x766F.Z/2)).Position,
(_0x8BE0 * CFrame.new(-_0x766F.X/2, _0x766F.Y/2, -_0x766F.Z/2)).Position,
(_0x8BE0 * CFrame.new( _0x766F.X/2, -_0x766F.Y/2, -_0x766F.Z/2)).Position,
(_0x8BE0 * CFrame.new(-_0x766F.X/2, -_0x766F.Y/2, -_0x766F.Z/2)).Position,
}
local _0x26B6, _0xCEAD = math.huge, math.huge
local _0x3FCF, _0x9030 = -math.huge, -math.huge
local _0x7BDB = false
for _, _0xF50D in ipairs(_0x46A8) do
local _0x5E82, _0xDDC2 = _0x3381(_0xF50D)
if _0xDDC2 then
_0x7BDB = true
_0x26B6 = math.min(_0x26B6, _0x5E82.X) _0xCEAD = math.min(_0xCEAD, _0x5E82.Y)
_0x3FCF = math.max(_0x3FCF, _0x5E82.X) _0x9030 = math.max(_0x9030, _0x5E82.Y)
end
end
if _0x7BDB then
_0x52C8.Position = Vector2.new(_0x26B6, _0xCEAD)
_0x52C8.Size = Vector2.new(math.max(_0x3FCF-_0x26B6,1), math.max(_0x9030-_0xCEAD,1))
_0x52C8.Color = _0x381F
_0x52C8.Visible = true
else
_0x52C8.Visible = false
end
end
local function _0x520B(player, _0x0125, _0x381F)
local _0x4B70 = _0x834B(player)
if not _0x4B70 or not _0x4B70.skeleton then return end
if not (_0x3F0A.ESPEnabled and _0x3F0A.SkeletonESP) then
for _, l in pairs(_0x4B70.skeleton) do if l then l.Visible = false end end
return
end
for i, conn in ipairs(_0x6ABB) do
local _0x2756 = _0x4B70.skeleton[i]
if not _0x2756 then continue end
local _0xE69D = _0x0125:FindFirstChild(conn[1])
local _0xBFD4 = _0x0125:FindFirstChild(conn[2])
if _0xE69D and _0xBFD4 then
local _0x7604, _0x7FA2 = _0x3381(_0xE69D.Position)
local _0xCC0C, _0xD4BD = _0x3381(_0xBFD4.Position)
if _0x7FA2 and _0xD4BD then
_0x2756.From = _0x7604 _0x2756.To = _0xCC0C _0x2756.Color = _0x381F _0x2756.Visible = true
else _0x2756.Visible = false end
else _0x2756.Visible = false end
end
end
local function _0x33B1()
if not _0xFD06 then return end
for _, player in ipairs(_0x091D:GetPlayers()) do
if player == _0x6EEA then _0xEBAC(player) continue end
local _0x2047 = player.Character
local _0xD99B = _0x2047 and _0x2047:FindFirstChildOfClass("Humanoid")
if not _0x2047 or not _0xD99B or _0xD99B.Health <= 0 or not _0x3F0A.ESPEnabled then
_0xEBAC(player) continue
end
local _0x381F = _0xE55E(player)
_0x787C(player, _0x2047, _0x381F)
_0x520B(player, _0x2047, _0x381F)
end
end
_0x091D.PlayerRemoving:Connect(_0xEBAC)local function _0xDEBA(player)
local _0x0125 = player.Character
if not _0x0125 then return end
local _0xD99B = _0x0125:FindFirstChildOfClass("Humanoid") or _0x0125:WaitForChild("Humanoid", 1)
if not _0xD99B then return end
local _0xC065 = _0x0125:FindFirstChild("BoomCause_ESP")
if _0xC065 then _0xC065:Destroy() end
local _0xECA3 = _0x0125:FindFirstChild("BoomCause_HealthBar")
if _0xECA3 then _0xECA3:Destroy() end
if _0x3F0A.HighlightESP then
local _0xDD1C = Instance.new("Highlight")
_0xDD1C.Name ="BoomCause_ESP"_0xDD1C.Adornee = _0x0125
_0xDD1C.FillTransparency = 0.55
_0xDD1C.OutlineTransparency = 0
_0xDD1C.Enabled = _0x3F0A.ESPEnabled
_0xDD1C.Parent = _0x0125
local function _0x6A16()
local _0xF50D = _0xAAE0(player) and _0x3F0A.TeamColor or _0x3F0A.EnemyColor
_0xDD1C.FillColor = _0xF50D _0xDD1C.OutlineColor = _0xF50D
end
_0x6A16()
player:GetAttributeChangedSignal("TeamID"):Connect(_0x6A16)
_0x6EEA:GetAttributeChangedSignal("TeamID"):Connect(_0x6A16)
end
local _0x1648 = _0x0125:FindFirstChild("Head") or _0x0125:FindFirstChild("HumanoidRootPart")
if not _0x1648 then return end
local _0xF02C = Instance.new("BillboardGui")
_0xF02C.Name ="BoomCause_HealthBar"_0xF02C.Adornee = _0x1648
_0xF02C.Size = UDim2.fromOffset(86, 9)
_0xF02C.StudsOffset = Vector3.new(0, 2.7, 0)
_0xF02C.AlwaysOnTop = true
_0xF02C.MaxDistance = 250
_0xF02C.Enabled = _0x3F0A.ESPEnabled
_0xF02C.Parent = _0x0125
local _0xA9E6 = Instance.new("Frame")
_0xA9E6.Size = UDim2.fromScale(1, 1)
_0xA9E6.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
_0xA9E6.BorderSizePixel = 0
_0xA9E6.Parent = _0xF02C
Instance.new("UICorner", _0xA9E6).CornerRadius = UDim.new(1, 0)
local _0x3CD4 = Instance.new("Frame")
_0x3CD4.Name ="Fill"_0x3CD4.Size = UDim2.fromScale(1, 1)
_0x3CD4.BackgroundColor3 = Color3.fromRGB(50, 255, 120)
_0x3CD4.BorderSizePixel = 0
_0x3CD4.Parent = _0xA9E6
Instance.new("UICorner", _0x3CD4).CornerRadius = UDim.new(1, 0)
local _0x0CB7 = Instance.new("TextLabel")
_0x0CB7.Size = UDim2.fromScale(1, 1)
_0x0CB7.BackgroundTransparency = 1
_0x0CB7.Font = Enum.Font.GothamBold
_0x0CB7.TextSize = 8
_0x0CB7.TextColor3 = Color3.new(1,1,1)
_0x0CB7.TextStrokeTransparency = 0.6
_0x0CB7.Parent = _0xA9E6
local function _0x799E()
if not _0xD99B or not _0xD99B.Parent then return end
local _0xFB9F = math.clamp(_0xD99B.Health / math.max(_0xD99B.MaxHealth, 1), 0, 1)
_0x3CD4.Size = UDim2.fromScale(_0xFB9F, 1)
if _0xFB9F > 0.6 then _0x3CD4.BackgroundColor3 = Color3.fromRGB(50, 255, 120)
elseif _0xFB9F > 0.3 then _0x3CD4.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
else _0x3CD4.BackgroundColor3 = Color3.fromRGB(255, 60, 60) end
_0x0CB7.Text = math.floor(_0xD99B.Health+0.5) .."/".. math.floor(_0xD99B.MaxHealth+0.5)
end
_0x799E()
_0xD99B.HealthChanged:Connect(_0x799E)
end
local function _0x86A9(_0x6203)
for _, player in ipairs(_0x091D:GetPlayers()) do
if player.Character then
local _0xDD1C = player.Character:FindFirstChild("BoomCause_ESP")
local _0xE120 = player.Character:FindFirstChild("BoomCause_HealthBar")
if _0xDD1C then _0xDD1C.Enabled = _0x6203 and _0x3F0A.HighlightESP
elseif _0x6203 and _0x3F0A.HighlightESP then _0xDEBA(player) end
if _0xE120 then _0xE120.Enabled = _0x6203 end
end
end
if not _0x6203 then
for player in pairs(_0x11E3) do _0xEBAC(player) end
end
end
local function _0x124C(player)
player.CharacterAdded:Connect(function() task.defer(_0xDEBA, player) end)
if player.Character then task.defer(_0xDEBA, player) end
end
for _, p in ipairs(_0x091D:GetPlayers()) do _0x124C(p) end
_0x091D.PlayerAdded:Connect(_0x124C)local function _0xD6A9()
local _0xE92F, _0xA212 = nil, _0x3F0A.FOV
local _0x679D = _0x653D:GetMouseLocation()
local _0xB599 = _0x6EEA.Character and _0x6EEA.Character:FindFirstChild("HumanoidRootPart")
for _, v in ipairs(_0x091D:GetPlayers()) do
if v ~= _0x6EEA and v.Character then
local _0xD99B = v.Character:FindFirstChild("Humanoid")
local _0x8D22 = v.Character:FindFirstChild(_0x3F0A.TargetPartName)
if _0xD99B and _0xD99B.Health > 0 and _0x8D22 and not _0xAAE0(v) then
if _0xB599 then
if (_0x8D22.Position - _0xB599.Position).Magnitude > _0x3F0A.MaxDistance then continue end
endlocal _0x98D4 = _0xDE1E(_0x8D22)
local _0x4D6E, _0xF6D8 = _0xD10B:WorldToViewportPoint(_0x98D4)
if _0xF6D8 then
local _0xB366 = (Vector2.new(_0x4D6E.X, _0x4D6E.Y) - _0x679D).Magnitude
if _0xB366 < _0xA212 then
_0xE92F = v
_0xA212 = _0xB366
end
end
end
end
end
return _0xE92F
endlocal _0xC2C9, _0x5534, _0xDA19 = nil, nil, nil
local _0xE26D = 16
local function _0x2106()
if _0xC2C9 then _0xC2C9:Destroy() _0xC2C9 = nil end
local _0x2047 = _0x6EEA.Character
if _0x2047 then
local _0xD99B = _0x2047:FindFirstChildOfClass("Humanoid")
if _0xD99B then _0xD99B.PlatformStand = false end
end
end
local function _0x19BF()
_0x2106()
local _0x2047 = _0x6EEA.Character
if not _0x2047 then return end
local _0x24C6 = _0x2047:FindFirstChild("HumanoidRootPart")
local _0xD99B = _0x2047:FindFirstChildOfClass("Humanoid")
if not _0x24C6 or not _0xD99B then return end
_0xD99B.PlatformStand = true
_0xC2C9 = Instance.new("BodyVelocity")
_0xC2C9.Name ="BoomCauseFly"_0xC2C9.MaxForce = Vector3.new(9e9, 9e9, 9e9)
_0xC2C9.Velocity = Vector3.zero
_0xC2C9.Parent = _0x24C6
end
local function _0xB823()
if not _0x3F0A.FlyEnabled or not _0xC2C9 or not _0xC2C9.Parent then return end
local _0x1B3B = _0xD10B.CFrame
local _0x7F40 = Vector3.zero
if _0x653D:IsKeyDown(Enum.KeyCode.W) then _0x7F40 += _0x1B3B.LookVector end
if _0x653D:IsKeyDown(Enum.KeyCode.S) then _0x7F40 -= _0x1B3B.LookVector end
if _0x653D:IsKeyDown(Enum.KeyCode.A) then _0x7F40 -= _0x1B3B.RightVector end
if _0x653D:IsKeyDown(Enum.KeyCode.D) then _0x7F40 += _0x1B3B.RightVector end
if _0x653D:IsKeyDown(Enum.KeyCode.Space) then _0x7F40 += Vector3.yAxis end
if _0x653D:IsKeyDown(Enum.KeyCode.LeftControl) or _0x653D:IsKeyDown(Enum.KeyCode.LeftShift) then
_0x7F40 -= Vector3.yAxis
end
_0xC2C9.Velocity = _0x7F40.Magnitude > 0 and _0x7F40.Unit * _0x3F0A.FlySpeed or Vector3.zero
end
local function _0x7819(_0x6203)
if _0x5534 then _0x5534:Disconnect() _0x5534 = nil end
if _0x6203 then
_0x5534 = _0xEEF5.Stepped:Connect(function()
local _0x2047 = _0x6EEA.Character
if not _0x2047 then return end
for _, p in ipairs(_0x2047:GetDescendants()) do
if p:IsA("BasePart") then p.CanCollide = false end
end
end)
end
end
local function _0xEC02()
if _0xDA19 then _0xDA19:Disconnect() _0xDA19 = nil end
local _0x2047 = _0x6EEA.Character
if _0x2047 then
local _0xD99B = _0x2047:FindFirstChildOfClass("Humanoid")
if _0xD99B then _0xD99B.WalkSpeed = _0xE26D end
end
end
local function _0xD839()
_0xEC02()
_0xDA19 = _0xEEF5.Heartbeat:Connect(function()
if not _0x3F0A.SpeedEnabled then return end
local _0x2047 = _0x6EEA.Character
if not _0x2047 then return end
local _0xD99B = _0x2047:FindFirstChildOfClass("Humanoid")
local _0x24C6 = _0x2047:FindFirstChild("HumanoidRootPart")
if not _0xD99B or not _0x24C6 then return end
_0xD99B.WalkSpeed = _0x3F0A.WalkSpeed
local _0x3642 = _0xD99B.MoveDirection
if _0x3642.Magnitude > 0.05 then
local _0x729B = _0x24C6.AssemblyLinearVelocity.Y
_0x24C6.AssemblyLinearVelocity = Vector3.new(
_0x3642.X * _0x3F0A.WalkSpeed,
_0x729B,
_0x3642.Z * _0x3F0A.WalkSpeed
)
end
end)
end
local function _0x0368()
if _0x3F0A.SpeedEnabled then _0xD839() else _0xEC02() end
end
_0x6EEA.CharacterAdded:Connect(function(_0x2047)
task.wait(0.5)
local _0xD99B = _0x2047:WaitForChild("Humanoid", 3)
if _0xD99B then _0xE26D = _0xD99B.WalkSpeed end
if _0x3F0A.FlyEnabled then _0x19BF() end
if _0x3F0A.NoclipEnabled then _0x7819(true) end
if _0x3F0A.SpeedEnabled then _0xD839() end
end)local _0xF32C = Instance.new("ScreenGui")
_0xF32C.Name ="BoomCauseToasts"_0xF32C.Parent = _0x4EB0
_0xF32C.ResetOnSpawn = false
local _0x7282 = 0
local function _0xA752(text, _0x381F, force)
if not force and (os.clock() - _0x7282) < 0.35 then return end
_0x7282 = os.clock()
_0x381F = _0x381F or _0x3024.Accent
local _0xD1CB = Instance.new("Frame")
_0xD1CB.Size = UDim2.fromOffset(240, 36)
_0xD1CB.Position = UDim2.new(0.5, -120, 1, 30)
_0xD1CB.BackgroundColor3 = _0x3024.Bg2
_0xD1CB.BorderSizePixel = 0
_0xD1CB.Parent = _0xF32C
Instance.new("UICorner", _0xD1CB).CornerRadius = UDim.new(0, 10)
local _0xBC76 = Instance.new("UIStroke")
_0xBC76.Color = _0x381F
_0xBC76.Thickness = 1.2
_0xBC76.Parent = _0xD1CB
local _0x61B7 = Instance.new("Frame")
_0x61B7.Size = UDim2.new(0, 3, 1, -8)
_0x61B7.Position = UDim2.fromOffset(6, 4)
_0x61B7.BackgroundColor3 = _0x381F
_0x61B7.BorderSizePixel = 0
_0x61B7.Parent = _0xD1CB
Instance.new("UICorner", _0x61B7).CornerRadius = UDim.new(1, 0)
local _0x24B5 = Instance.new("TextLabel")
_0x24B5.Size = UDim2.new(1, -20, 1, 0)
_0x24B5.Position = UDim2.fromOffset(16, 0)
_0x24B5.BackgroundTransparency = 1
_0x24B5.Font = Enum.Font.GothamMedium
_0x24B5.TextSize = 13
_0x24B5.TextColor3 = _0x3024.Text
_0x24B5.TextXAlignment = Enum.TextXAlignment.Left
_0x24B5.Text = text
_0x24B5.Parent = _0xD1CB
_0xA5B9:Create(_0xD1CB, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
Position = UDim2.new(0.5, -120, 1, -50)
}):Play()
task.delay(1.6, function()
local _0x6892 = _0xA5B9:Create(_0xD1CB, TweenInfo.new(0.25), {
Position = UDim2.new(0.5, -120, 1, 30),
BackgroundTransparency = 1
})
_0x6892:Play()
_0x6892.Completed:Wait()
_0xD1CB:Destroy()
end)
endlocal _0xEA2F = Instance.new("ScreenGui")
_0xEA2F.Name ="BoomCauseFOV"_0xEA2F.Parent = _0x4EB0
_0xEA2F.ResetOnSpawn = false
_0xEA2F.IgnoreGuiInset = true
local _0xFC60 = Instance.new("Frame")
_0xFC60.Name ="FOVCircle"_0xFC60.AnchorPoint = Vector2.new(0.5, 0.5)
_0xFC60.BackgroundTransparency = 1
_0xFC60.BorderSizePixel = 0
_0xFC60.Visible = _0x3F0A.ShowFOV
_0xFC60.Parent = _0xEA2F
Instance.new("UICorner", _0xFC60).CornerRadius = UDim.new(1, 0)
local _0x6D61 = Instance.new("UIStroke")
_0x6D61.Color = _0x3024.Accent
_0x6D61.Thickness = 1.5
_0x6D61.Transparency = 0.3
_0x6D61.Parent = _0xFC60local _0x0F00 = Instance.new("ScreenGui")
_0x0F00.Name ="BoomCauseHub"_0x0F00.Parent = _0x4EB0
_0x0F00.ResetOnSpawn = false
_0x0F00.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local _0x6E78 = Instance.new("Frame")
_0x6E78.Name ="Main"_0x6E78.Size = UDim2.fromOffset(340, 460)
_0x6E78.Position = UDim2.fromScale(0.5, 0.5)
_0x6E78.AnchorPoint = Vector2.new(0.5, 0.5)
_0x6E78.BackgroundColor3 = _0x3024.Bg
_0x6E78.BorderSizePixel = 0
_0x6E78.Active = true
_0x6E78.Draggable = true
_0x6E78.Parent = _0x0F00
Instance.new("UICorner", _0x6E78).CornerRadius = UDim.new(0, 14)
local _0xF4DA = Instance.new("UIStroke")
_0xF4DA.Color = _0x3024.Stroke
_0xF4DA.Thickness = 1.2
_0xF4DA.Parent = _0x6E78
local _0xD389 = Instance.new("Frame")
_0xD389.Size = UDim2.new(1, 0, 0, 2)
_0xD389.BackgroundColor3 = _0x3024.Accent
_0xD389.BorderSizePixel = 0
_0xD389.Parent = _0x6E78
local _0x7ABF = Instance.new("Frame")
_0x7ABF.Size = UDim2.new(1, 0, 0, 48)
_0x7ABF.BackgroundColor3 = _0x3024.Bg2
_0x7ABF.BorderSizePixel = 0
_0x7ABF.Parent = _0x6E78
Instance.new("UICorner", _0x7ABF).CornerRadius = UDim.new(0, 14)
local _0xD5A9 = Instance.new("Frame")
_0xD5A9.Size = UDim2.new(1, 0, 0, 14)
_0xD5A9.Position = UDim2.new(0, 0, 1, -14)
_0xD5A9.BackgroundColor3 = _0x3024.Bg2
_0xD5A9.BorderSizePixel = 0
_0xD5A9.Parent = _0x7ABF
local _0x2418 = Instance.new("TextLabel")
_0x2418.BackgroundTransparency = 1
_0x2418.Position = UDim2.fromOffset(16, 8)
_0x2418.Size = UDim2.new(1, -60, 0, 20)
_0x2418.Font = Enum.Font.GothamBold
_0x2418.Text ="BOOM CAUSE"_0x2418.TextColor3 = _0x3024.Text
_0x2418.TextSize = 17
_0x2418.TextXAlignment = Enum.TextXAlignment.Left
_0x2418.Parent = _0x7ABF
local _0xAD03 = Instance.new("TextLabel")
_0xAD03.BackgroundTransparency = 1
_0xAD03.Position = UDim2.fromOffset(16, 27)
_0xAD03.Size = UDim2.new(1, -60, 0, 14)
_0xAD03.Font = Enum.Font.Gotham
_0xAD03.Text ="V22.2  •  Prediction"_0xAD03.TextColor3 = _0x3024.Accent
_0xAD03.TextSize = 11
_0xAD03.TextXAlignment = Enum.TextXAlignment.Left
_0xAD03.Parent = _0x7ABF
local _0x13D8 = Instance.new("TextButton")
_0x13D8.Size = UDim2.fromOffset(26, 26)
_0x13D8.Position = UDim2.new(1, -36, 0.5, -13)
_0x13D8.BackgroundColor3 = _0x3024.Bg3
_0x13D8.Text ="×"_0x13D8.Font = Enum.Font.GothamBold
_0x13D8.TextSize = 16
_0x13D8.TextColor3 = _0x3024.TextDim
_0x13D8.AutoButtonColor = false
_0x13D8.Parent = _0x7ABF
Instance.new("UICorner", _0x13D8).CornerRadius = UDim.new(0, 7)
_0x13D8.MouseEnter:Connect(function()
_0xA5B9:Create(_0x13D8, TweenInfo.new(0.15), {BackgroundColor3 = _0x3024.Danger, TextColor3 = Color3.new(1,1,1)}):Play()
end)
_0x13D8.MouseLeave:Connect(function()
_0xA5B9:Create(_0x13D8, TweenInfo.new(0.15), {BackgroundColor3 = _0x3024.Bg3, TextColor3 = _0x3024.TextDim}):Play()
end)
_0x13D8.MouseButton1Click:Connect(function()
_0x0F00.Enabled = false
end)
local _0xFBB9 = Instance.new("Frame")
_0xFBB9.Size = UDim2.new(1, -24, 0, 28)
_0xFBB9.Position = UDim2.fromOffset(12, 54)
_0xFBB9.BackgroundColor3 = _0x3024.Bg2
_0xFBB9.BorderSizePixel = 0
_0xFBB9.Parent = _0x6E78
Instance.new("UICorner", _0xFBB9).CornerRadius = UDim.new(0, 8)
local _0x00FC = Instance.new("Frame")
_0x00FC.Size = UDim2.fromOffset(8, 8)
_0x00FC.Position = UDim2.fromOffset(10, 10)
_0x00FC.BackgroundColor3 = _0x3024.Danger
_0x00FC.BorderSizePixel = 0
_0x00FC.Parent = _0xFBB9
Instance.new("UICorner", _0x00FC).CornerRadius = UDim.new(1, 0)
local _0x9E14 = Instance.new("TextLabel")
_0x9E14.BackgroundTransparency = 1
_0x9E14.Position = UDim2.fromOffset(26, 0)
_0x9E14.Size = UDim2.new(1, -34, 1, 0)
_0x9E14.Font = Enum.Font.GothamMedium
_0x9E14.Text ="Inactive"_0x9E14.TextColor3 = _0x3024.TextDim
_0x9E14.TextSize = 12
_0x9E14.TextXAlignment = Enum.TextXAlignment.Left
_0x9E14.Parent = _0xFBB9
local _0xA791 = Instance.new("Frame")
_0xA791.Size = UDim2.new(1, -24, 0, 32)
_0xA791.Position = UDim2.fromOffset(12, 90)
_0xA791.BackgroundColor3 = _0x3024.Bg2
_0xA791.BorderSizePixel = 0
_0xA791.Parent = _0x6E78
Instance.new("UICorner", _0xA791).CornerRadius = UDim.new(0, 8)
local _0xD1FE = Instance.new("UIListLayout")
_0xD1FE.FillDirection = Enum.FillDirection.Horizontal
_0xD1FE.HorizontalAlignment = Enum.HorizontalAlignment.Center
_0xD1FE.VerticalAlignment = Enum.VerticalAlignment.Center
_0xD1FE.Padding = UDim.new(0, 4)
_0xD1FE.Parent = _0xA791
local _0x9C30 = Instance.new("Frame")
_0x9C30.Name ="Content"_0x9C30.Size = UDim2.new(1, -24, 1, -150)
_0x9C30.Position = UDim2.fromOffset(12, 130)
_0x9C30.BackgroundTransparency = 1
_0x9C30.Parent = _0x6E78
local _0xFE16 = {}
local function _0x429E(name)
local _0xD66C = Instance.new("ScrollingFrame")
_0xD66C.Name = name
_0xD66C.Size = UDim2.fromScale(1, 1)
_0xD66C.BackgroundTransparency = 1
_0xD66C.BorderSizePixel = 0
_0xD66C.ScrollBarThickness = 3
_0xD66C.ScrollBarImageColor3 = _0x3024.Accent
_0xD66C.CanvasSize = UDim2.fromOffset(0, 0)
_0xD66C.Visible = false
_0xD66C.Parent = _0x9C30
local _0xBA20 = Instance.new("UIListLayout")
_0xBA20.Padding = UDim.new(0, 6)
_0xBA20.SortOrder = Enum.SortOrder.LayoutOrder
_0xBA20.Parent = _0xD66C
_0xBA20:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
_0xD66C.CanvasSize = UDim2.fromOffset(0, _0xBA20.AbsoluteContentSize.Y + 8)
end)
_0xFE16[name] = _0xD66C
return _0xD66C
end
local _0x1044 = _0x429E("Combat")
local _0x04DC = _0x429E("Visuals")
local _0xCB07 = _0x429E("Movement")
local _0xBEEC = _0x429E("Settings")
local function _0x7123(name)
for _0x6E17, _0xD66C in pairs(_0xFE16) do _0xD66C.Visible = (_0x6E17 == name) end
for _, _0x64CE in ipairs(_0xA791:GetChildren()) do
if _0x64CE:IsA("TextButton") then
local _0xE923 = _0x64CE.Name == name
_0xA5B9:Create(_0x64CE, TweenInfo.new(0.2), {
BackgroundColor3 = _0xE923 and _0x3024.Accent or _0x3024.Bg3,
TextColor3 = _0xE923 and Color3.new(1,1,1) or _0x3024.TextDim
}):Play()
end
end
end
local function _0x35BA(name, order)
local _0x64CE = Instance.new("TextButton")
_0x64CE.Name = name
_0x64CE.Size = UDim2.fromOffset(72, 24)
_0x64CE.BackgroundColor3 = _0x3024.Bg3
_0x64CE.Text = name
_0x64CE.Font = Enum.Font.GothamMedium
_0x64CE.TextSize = 11
_0x64CE.TextColor3 = _0x3024.TextDim
_0x64CE.AutoButtonColor = false
_0x64CE.LayoutOrder = order
_0x64CE.Parent = _0xA791
Instance.new("UICorner", _0x64CE).CornerRadius = UDim.new(0, 6)
_0x64CE.MouseButton1Click:Connect(function() _0x7123(name) end)
end
_0x35BA("Combat", 1)
_0x35BA("Visuals", 2)
_0x35BA("Movement", 3)
_0x35BA("Settings", 4)local function _0x0DEE(parent, name, bindId, default, callback)
local _0x6BC8 = Instance.new("Frame")
_0x6BC8.Size = UDim2.new(1, 0, 0, 38)
_0x6BC8.BackgroundColor3 = _0x3024.Bg2
_0x6BC8.BorderSizePixel = 0
_0x6BC8.Parent = parent
Instance.new("UICorner", _0x6BC8).CornerRadius = UDim.new(0, 9)
local _0xBDD2 = Instance.new("TextLabel")
_0xBDD2.BackgroundTransparency = 1
_0xBDD2.Position = UDim2.fromOffset(12, 0)
_0xBDD2.Size = UDim2.new(0.45, 0, 1, 0)
_0xBDD2.Font = Enum.Font.GothamMedium
_0xBDD2.Text = name
_0xBDD2.TextColor3 = _0x3024.Text
_0xBDD2.TextSize = 13
_0xBDD2.TextXAlignment = Enum.TextXAlignment.Left
_0xBDD2.Parent = _0x6BC8
local _0xAB31 = Instance.new("TextButton")
_0xAB31.Size = UDim2.fromOffset(48, 20)
_0xAB31.Position = UDim2.new(0.52, 0, 0.5, -10)
_0xAB31.BackgroundColor3 = _0x3024.Bg3
_0xAB31.Text =""_0xAB31.AutoButtonColor = false
_0xAB31.ZIndex = 5
_0xAB31.Parent = _0x6BC8
Instance.new("UICorner", _0xAB31).CornerRadius = UDim.new(0, 5)
local _0x851D = Instance.new("TextLabel")
_0x851D.Size = UDim2.fromScale(1, 1)
_0x851D.BackgroundTransparency = 1
_0x851D.Font = Enum.Font.GothamBold
_0x851D.TextSize = 10
_0x851D.TextColor3 = _0x3024.TextDim
_0x851D.Text ="—"_0x851D.Parent = _0xAB31
_0x8669[bindId] = _0x851D
_0xAB31.MouseButton1Click:Connect(function()
if _0x4FE5 then return end
_0x4FE5 = bindId
_0x851D.Text ="..."_0x851D.TextColor3 = _0x3024.Warning
_0xA752("Press key for ".. name, _0x3024.Warning, true)
end)
local _0xF624 = Instance.new("Frame")
_0xF624.Size = UDim2.fromOffset(40, 20)
_0xF624.Position = UDim2.new(1, -52, 0.5, -10)
_0xF624.BackgroundColor3 = _0x3024.Bg4
_0xF624.BorderSizePixel = 0
_0xF624.Parent = _0x6BC8
Instance.new("UICorner", _0xF624).CornerRadius = UDim.new(1, 0)
local _0x5D59 = Instance.new("Frame")
_0x5D59.Size = UDim2.fromOffset(16, 16)
_0x5D59.Position = UDim2.fromOffset(2, 2)
_0x5D59.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
_0x5D59.BorderSizePixel = 0
_0x5D59.Parent = _0xF624
Instance.new("UICorner", _0x5D59).CornerRadius = UDim.new(1, 0)
local _0x6203 = default
local function _0xB75A()
_0xA5B9:Create(_0xF624, TweenInfo.new(0.2), {
BackgroundColor3 = _0x6203 and _0x3024.Accent or _0x3024.Bg4
}):Play()
_0xA5B9:Create(_0x5D59, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
Position = _0x6203 and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2),
BackgroundColor3 = _0x6203 and Color3.new(1,1,1) or Color3.fromRGB(180,180,190)
}):Play()
end
_0xB75A()
local _0x8696 = Instance.new("TextButton")
_0x8696.Size = UDim2.fromScale(1, 1)
_0x8696.BackgroundTransparency = 1
_0x8696.Text =""_0x8696.ZIndex = 2
_0x8696.Parent = _0x6BC8
_0x8696.MouseButton1Click:Connect(function()
if _0x4FE5 then return end
_0x6203 = not _0x6203
_0xB75A()
callback(_0x6203)
end)
return {
Toggle = function()
_0x6203 = not _0x6203
_0xB75A()
callback(_0x6203)
end
}
end
local function _0x729D(parent, name, min, max, default, isFloat, callback)
local _0x6BC8 = Instance.new("Frame")
_0x6BC8.Size = UDim2.new(1, 0, 0, 42)
_0x6BC8.BackgroundColor3 = _0x3024.Bg2
_0x6BC8.BorderSizePixel = 0
_0x6BC8.Parent = parent
Instance.new("UICorner", _0x6BC8).CornerRadius = UDim.new(0, 9)
local _0xBDD2 = Instance.new("TextLabel")
_0xBDD2.BackgroundTransparency = 1
_0xBDD2.Position = UDim2.fromOffset(12, 4)
_0xBDD2.Size = UDim2.new(0.6, 0, 0, 14)
_0xBDD2.Font = Enum.Font.GothamMedium
_0xBDD2.Text = name
_0xBDD2.TextColor3 = _0x3024.TextDim
_0xBDD2.TextSize = 11
_0xBDD2.TextXAlignment = Enum.TextXAlignment.Left
_0xBDD2.Parent = _0x6BC8
local _0x87F1 = Instance.new("TextLabel")
_0x87F1.BackgroundTransparency = 1
_0x87F1.Position = UDim2.new(0.6, 0, 0, 4)
_0x87F1.Size = UDim2.new(0.4, -12, 0, 14)
_0x87F1.Font = Enum.Font.GothamBold
_0x87F1.TextColor3 = _0x3024.Accent
_0x87F1.TextSize = 11
_0x87F1.TextXAlignment = Enum.TextXAlignment.Right
_0x87F1.Parent = _0x6BC8
local _0xDD23 = Instance.new("Frame")
_0xDD23.Size = UDim2.new(1, -24, 0, 6)
_0xDD23.Position = UDim2.fromOffset(12, 28)
_0xDD23.BackgroundColor3 = _0x3024.Bg4
_0xDD23.BorderSizePixel = 0
_0xDD23.Parent = _0x6BC8
Instance.new("UICorner", _0xDD23).CornerRadius = UDim.new(1, 0)
local _0x3CD4 = Instance.new("Frame")
_0x3CD4.Size = UDim2.new(0, 0, 1, 0)
_0x3CD4.BackgroundColor3 = _0x3024.Accent
_0x3CD4.BorderSizePixel = 0
_0x3CD4.Parent = _0xDD23
Instance.new("UICorner", _0x3CD4).CornerRadius = UDim.new(1, 0)
local _0x5D59 = Instance.new("Frame")
_0x5D59.Size = UDim2.fromOffset(14, 14)
_0x5D59.AnchorPoint = Vector2.new(0.5, 0.5)
_0x5D59.Position = UDim2.new(0, 0, 0.5, 0)
_0x5D59.BackgroundColor3 = Color3.new(1,1,1)
_0x5D59.BorderSizePixel = 0
_0x5D59.ZIndex = 3
_0x5D59.Parent = _0xDD23
Instance.new("UICorner", _0x5D59).CornerRadius = UDim.new(1, 0)
local _0x7D15 = default
local _0x77EB = false
local function _0x3E3B()
local _0xFB9F = math.clamp((_0x7D15 - min) / (max - min), 0, 1)
_0x3CD4.Size = UDim2.new(_0xFB9F, 0, 1, 0)
_0x5D59.Position = UDim2.new(_0xFB9F, 0, 0.5, 0)
_0x87F1.Text = isFloat and string.format("%.2f", _0x7D15) or tostring(math.floor(_0x7D15 + 0.5))
end
local function _0x8343(x)
local _0x1C7F = _0xDD23.AbsolutePosition.X
local _0xB29D = _0xDD23.AbsoluteSize.X
local _0xFB9F = math.clamp((x - _0x1C7F) / _0xB29D, 0, 1)
_0x7D15 = min + (max - min) * _0xFB9F
if not isFloat then _0x7D15 = math.floor(_0x7D15 + 0.5)
else _0x7D15 = math.floor(_0x7D15 * 100 + 0.5) / 100 end
_0x3E3B()
callback(_0x7D15)
end
local function _0xA9E4(input)
_0x77EB = true
_0x6E78.Draggable = false
_0x8343(input.Position.X)
end
local function _0x115E()
if _0x77EB then _0x77EB = false _0x6E78.Draggable = true end
end
_0xDD23.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then _0xA9E4(input) end
end)
_0x5D59.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then _0xA9E4(input) end
end)
_0x653D.InputChanged:Connect(function(input)
if _0x77EB and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
_0x8343(input.Position.X)
end
end)
_0x653D.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then _0x115E() end
end)
_0x3E3B()
endlocal _0x0DEA = _0x0DEE(_0x1044,"Aimbot","Aim", false, function(_0xDDC2)
_0x3F0A.AimEnabled = _0xDDC2
_0x9E14.Text = _0xDDC2 and"Active"or"Inactive"_0x9E14.TextColor3 = _0xDDC2 and _0x3024.Success or _0x3024.TextDim
_0xA5B9:Create(_0x00FC, TweenInfo.new(0.25), {
BackgroundColor3 = _0xDDC2 and _0x3024.Success or _0x3024.Danger
}):Play()
_0xA752(_0xDDC2 and"Aimbot On"or"Aimbot Off", _0xDDC2 and _0x3024.Success or _0x3024.TextDim, true)
end)
_0x0DEE(_0x1044,"Prediction","Pred", true, function(_0xDDC2)
_0x3F0A.PredictionEnabled = _0xDDC2
_0xA752(_0xDDC2 and"Prediction On"or"Prediction Off", nil, true)
end)
_0x0DEE(_0x1044,"Team Check","Team", true, function(_0xDDC2)
_0x3F0A.TeamCheck = _0xDDC2
end)
_0x729D(_0x1044,"FOV", 50, 800, _0x3F0A.FOV, false, function(v) _0x3F0A.FOV = v end)
_0x729D(_0x1044,"Smoothing", 0.03, 1.00, _0x3F0A.Smoothing, true, function(v) _0x3F0A.Smoothing = v end)
_0x729D(_0x1044,"Prediction", 0.05, 0.35, _0x3F0A.PredictionStrength, true, function(v)
_0x3F0A.PredictionStrength = v
end)
_0x729D(_0x1044,"Max Distance", 100, 2000, _0x3F0A.MaxDistance, false, function(v) _0x3F0A.MaxDistance = v end)
local _0xEB4B = _0x0DEE(_0x04DC,"ESP Master","ESP", false, function(_0xDDC2)
_0x3F0A.ESPEnabled = _0xDDC2
_0x86A9(_0xDDC2)
_0xA752(_0xDDC2 and"ESP On"or"ESP Off", _0xDDC2 and _0x3024.Success or _0x3024.TextDim, true)
end)
_0x0DEE(_0x04DC,"Box ESP","Box", false, function(_0xDDC2)
_0x3F0A.BoxESP = _0xDDC2
if not _0xFD06 then _0xA752("Drawing not found", _0x3024.Danger, true) end
end)
_0x0DEE(_0x04DC,"Skeleton ESP","Skeleton", false, function(_0xDDC2)
_0x3F0A.SkeletonESP = _0xDDC2
if not _0xFD06 then _0xA752("Drawing not found", _0x3024.Danger, true) end
end)
_0x0DEE(_0x04DC,"Highlight ESP","Highlight", true, function(_0xDDC2)
_0x3F0A.HighlightESP = _0xDDC2
_0x86A9(_0x3F0A.ESPEnabled)
end)
local _0x71B6 = _0x0DEE(_0x04DC,"FOV Circle","FOV", true, function(_0xDDC2)
_0x3F0A.ShowFOV = _0xDDC2
_0xFC60.Visible = _0xDDC2
end)
local _0x592B = _0x0DEE(_0xCB07,"Fly","Fly", false, function(_0xDDC2)
_0x3F0A.FlyEnabled = _0xDDC2
if _0xDDC2 then _0x19BF() else _0x2106() end
_0xA752(_0xDDC2 and"Fly On"or"Fly Off", _0xDDC2 and _0x3024.Success or _0x3024.TextDim, true)
end)
local _0xA318 = _0x0DEE(_0xCB07,"Speed","Speed", false, function(_0xDDC2)
_0x3F0A.SpeedEnabled = _0xDDC2
_0x0368()
_0xA752(_0xDDC2 and"Speed On"or"Speed Off", _0xDDC2 and _0x3024.Success or _0x3024.TextDim, true)
end)
local _0x683A = _0x0DEE(_0xCB07,"Noclip","Noclip", false, function(_0xDDC2)
_0x3F0A.NoclipEnabled = _0xDDC2
_0x7819(_0xDDC2)
_0xA752(_0xDDC2 and"Noclip On"or"Noclip Off", _0xDDC2 and _0x3024.Success or _0x3024.TextDim, true)
end)
_0x729D(_0xCB07,"Fly Speed", 10, 200, _0x3F0A.FlySpeed, false, function(v) _0x3F0A.FlySpeed = v end)
_0x729D(_0xCB07,"Walk Speed", 16, 200, _0x3F0A.WalkSpeed, false, function(v)
_0x3F0A.WalkSpeed = v
if _0x3F0A.SpeedEnabled then _0x0368() end
end)
local _0x914D = Instance.new("TextLabel")
_0x914D.Size = UDim2.new(1, 0, 0, 60)
_0x914D.BackgroundTransparency = 1
_0x914D.Font = Enum.Font.Gotham
_0x914D.TextSize = 12
_0x914D.TextColor3 = _0x3024.TextDim
_0x914D.Text ="Prediction aims ahead of moving targets.\nSweet spot: 0.12 – 0.20\nRightShift = Menu"_0x914D.TextWrapped = true
_0x914D.Parent = _0xBEEC
local _0x5CDC = Instance.new("TextLabel")
_0x5CDC.BackgroundTransparency = 1
_0x5CDC.Position = UDim2.new(0, 0, 1, -24)
_0x5CDC.Size = UDim2.new(1, 0, 0, 18)
_0x5CDC.Font = Enum.Font.Gotham
_0x5CDC.TextSize = 10
_0x5CDC.TextColor3 = Color3.fromRGB(90, 90, 105)
_0x5CDC.Parent = _0x6E78
_0x8669.Footer = _0x5CDC
local function _0x42F3(kc)
if not kc then return"?"end
local _0x6E17 = kc.Name
local _0x9E1C = {RightShift="RShift",LeftShift="LShift",RightControl="RCtrl",LeftControl="LCtrl"}
return _0x9E1C[_0x6E17] or _0x6E17
end
local function _0x128D()
if _0x8669.Aim then _0x8669.Aim.Text = _0x42F3(_0x3F0A.AimKey) end
if _0x8669.ESP then _0x8669.ESP.Text = _0x42F3(_0x3F0A.ESPKey) end
if _0x8669.FOV then _0x8669.FOV.Text = _0x42F3(_0x3F0A.FOVKey) end
if _0x8669.Fly then _0x8669.Fly.Text = _0x42F3(_0x3F0A.FlyKey) end
if _0x8669.Speed then _0x8669.Speed.Text = _0x42F3(_0x3F0A.SpeedKey) end
if _0x8669.Noclip then _0x8669.Noclip.Text = _0x42F3(_0x3F0A.NoclipKey) end
if _0x8669.Footer then
_0x8669.Footer.Text = _0x42F3(_0x3F0A.ToggleKey) .."  Menu"end
end
_0x128D()
_0x7123("Combat")_0x653D.InputBegan:Connect(function(input)
if _0x4FE5 and input.KeyCode == Enum.KeyCode.Escape then
_0x4FE5 = nil
_0x128D()
_0xA752("Cancelled", _0x3024.TextDim, true)
return
end
if _0x4FE5 then
if input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.Escape then
if _0x4FE5 =="Aim"then _0x3F0A.AimKey = input.KeyCode
elseif _0x4FE5 =="ESP"then _0x3F0A.ESPKey = input.KeyCode
elseif _0x4FE5 =="FOV"then _0x3F0A.FOVKey = input.KeyCode
elseif _0x4FE5 =="Fly"then _0x3F0A.FlyKey = input.KeyCode
elseif _0x4FE5 =="Speed"then _0x3F0A.SpeedKey = input.KeyCode
elseif _0x4FE5 =="Noclip"then _0x3F0A.NoclipKey = input.KeyCode
elseif _0x4FE5 =="Team"then _0x3F0A.TeamKey = input.KeyCode
end
_0x4FE5 = nil
_0x128D()
_0xA752("Bound to ".. _0x42F3(input.KeyCode), _0x3024.Success, true)
end
return
end
if input.KeyCode == _0x3F0A.ToggleKey then
_0x0F00.Enabled = not _0x0F00.Enabled
elseif input.KeyCode == _0x3F0A.AimKey then _0x0DEA.Toggle()
elseif input.KeyCode == _0x3F0A.ESPKey then _0xEB4B.Toggle()
elseif input.KeyCode == _0x3F0A.FOVKey then _0x71B6.Toggle()
elseif input.KeyCode == _0x3F0A.FlyKey then _0x592B.Toggle()
elseif input.KeyCode == _0x3F0A.SpeedKey then _0xA318.Toggle()
elseif input.KeyCode == _0x3F0A.NoclipKey then _0x683A.Toggle()
end
end)_0xEEF5.RenderStepped:Connect(function()
pcall(_0x33B1)
_0xB823()
if _0x3F0A.ShowFOV then
local _0x679D = _0x653D:GetMouseLocation()
_0xFC60.Position = UDim2.fromOffset(_0x679D.X, _0x679D.Y)
_0xFC60.Size = UDim2.fromOffset(_0x3F0A.FOV * 2, _0x3F0A.FOV * 2)
_0xFC60.Visible = true
_0x6D61.Transparency = _0x3F0A.AimEnabled and (0.1 + math.sin(os.clock()*5)*0.08) or 0.35
else
_0xFC60.Visible = false
end
if not _0x3F0A.AimEnabled then return end
if not _0x653D:IsMouseButtonPressed(_0x3F0A.HoldKey) then return end
local _0xBC9E = _0xD6A9()
if not _0xBC9E or not _0xBC9E.Character then return end
local _0x8D22 = _0xBC9E.Character:FindFirstChild(_0x3F0A.TargetPartName)
if not _0x8D22 then return endlocal _0x98D4 = _0xDE1E(_0x8D22)
local _0xED5F, _0xF6D8 = _0xD10B:WorldToViewportPoint(_0x98D4)
if not _0xF6D8 then return end
local _0x679D = _0x653D:GetMouseLocation()
local _0x6300 = _0xED5F.X - _0x679D.X
local _0x3C18 = _0xED5F.Y - _0x679D.Y
if math.abs(_0x6300) > 0.5 or math.abs(_0x3C18) > 0.5 then
mousemoverel(_0x6300 * _0x3F0A.Smoothing, _0x3C18 * _0x3F0A.Smoothing)
end
end)
_0xEEF5.Heartbeat:Connect(function()
if not _0x3F0A.ESPEnabled then return end
for _, p in ipairs(_0x091D:GetPlayers()) do
local _0x2047 = p.Character
if _0x2047 then
local _0xDD1C = _0x2047:FindFirstChild("BoomCause_ESP")
local _0xE120 = _0x2047:FindFirstChild("BoomCause_HealthBar")
local _0xD99B = _0x2047:FindFirstChildOfClass("Humanoid")
local _0x2697 = _0xD99B and _0xD99B.Health > 0
if _0xDD1C then _0xDD1C.Enabled = _0x2697 and _0x3F0A.HighlightESP end
if _0xE120 then _0xE120.Enabled = _0x2697 end
end
end
end)
_0xA752("BOOM CAUSE V22.2 Ready", _0x3024.Accent, true)
