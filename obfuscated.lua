local _0x669C = game:GetService(string.char(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101))
local _0x8FC7 = game:GetService(string.char(82,117,110,83,101,114,118,105,99,101))
local _0x89CA = game:GetService(string.char(80,108,97,121,101,114,115))
local _0x8E12 = game:GetService(string.char(84,119,101,101,110,83,101,114,118,105,99,101))
local _0xB0F0 = game:GetService(string.char(67,111,114,101,71,117,105))
local _0x46D6 = _0x89CA.LocalPlayer
local _0x81BE = workspace.CurrentCamera
local _0x29C8 = nil
local _0x286F = {}
local _0x7EA6 = {}
local _0x41BA = pcall(function() return Drawing and Drawing.new end)local _0xC917 = {
AimEnabled = false,
TargetPartName =string.char(72,101,97,100),
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
}local _0xEC5E = {
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
}local function _0x6F8D(player)
if not _0xC917.TeamCheck then return false end
local _0xE1F1 = _0x46D6:GetAttribute(string.char(84,101,97,109,73,68))
local _0x85CE = player:GetAttribute(string.char(84,101,97,109,73,68))
if typeof(_0xE1F1) ~=string.char(115,116,114,105,110,103)or typeof(_0x85CE) ~=string.char(115,116,114,105,110,103)then return false end
return _0xE1F1 == _0x85CE
end
  local function _0x6DD1(_0x3C03)
if not _0xC917.PredictionEnabled then
return _0x3C03.Position
end
local _0x2613 = _0x3C03.Parent
if not _0x2613 then return _0x3C03.Position end
local _0x6FB4 = _0x2613:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
if not _0x6FB4 then return _0x3C03.Position endlocal _0xDC54 = _0x6FB4.AssemblyLinearVelocity
return _0x3C03.Position + (_0xDC54 * _0xC917.PredictionStrength)
endlocal function _0x35C7(player)
return _0x6F8D(player) and _0xC917.TeamColor or _0xC917.EnemyColor
end
local function _0x979A(player)
local _0x943D = _0x7EA6[player]
if not _0x943D then return end
if _0x943D.box then pcall(function() _0x943D.box:Remove() end) end
if _0x943D.skeleton then
for _, _0x1348 in pairs(_0x943D.skeleton) do pcall(function() _0x1348:Remove() end) end
end
_0x7EA6[player] = nil
end
local function _0xAB99()
local _0xE2CE = Drawing.new(string.char(83,113,117,97,114,101))
_0xE2CE.Thickness = 1.5
_0xE2CE.Filled = false
_0xE2CE.Visible = false
_0xE2CE.ZIndex = 2
return _0xE2CE
end
local function _0x1677()
local _0x1348 = Drawing.new(string.char(76,105,110,101))
_0x1348.Thickness = 1.5
_0x1348.Visible = false
_0x1348.ZIndex = 2
return _0x1348
end
local _0x07E8 = {
{string.char(72,101,97,100),string.char(85,112,112,101,114,84,111,114,115,111)},{string.char(85,112,112,101,114,84,111,114,115,111),string.char(76,111,119,101,114,84,111,114,115,111)},
{string.char(85,112,112,101,114,84,111,114,115,111),string.char(76,101,102,116,85,112,112,101,114,65,114,109)},{string.char(76,101,102,116,85,112,112,101,114,65,114,109),string.char(76,101,102,116,76,111,119,101,114,65,114,109)},{string.char(76,101,102,116,76,111,119,101,114,65,114,109),string.char(76,101,102,116,72,97,110,100)},
{string.char(85,112,112,101,114,84,111,114,115,111),string.char(82,105,103,104,116,85,112,112,101,114,65,114,109)},{string.char(82,105,103,104,116,85,112,112,101,114,65,114,109),string.char(82,105,103,104,116,76,111,119,101,114,65,114,109)},{string.char(82,105,103,104,116,76,111,119,101,114,65,114,109),string.char(82,105,103,104,116,72,97,110,100)},
{string.char(76,111,119,101,114,84,111,114,115,111),string.char(76,101,102,116,85,112,112,101,114,76,101,103)},{string.char(76,101,102,116,85,112,112,101,114,76,101,103),string.char(76,101,102,116,76,111,119,101,114,76,101,103)},{string.char(76,101,102,116,76,111,119,101,114,76,101,103),string.char(76,101,102,116,70,111,111,116)},
{string.char(76,111,119,101,114,84,111,114,115,111),string.char(82,105,103,104,116,85,112,112,101,114,76,101,103)},{string.char(82,105,103,104,116,85,112,112,101,114,76,101,103),string.char(82,105,103,104,116,76,111,119,101,114,76,101,103)},{string.char(82,105,103,104,116,76,111,119,101,114,76,101,103),string.char(82,105,103,104,116,70,111,111,116)},
{string.char(72,101,97,100),string.char(84,111,114,115,111)},{string.char(84,111,114,115,111),string.char(76,101,102,116,32,65,114,109)},{string.char(84,111,114,115,111),string.char(82,105,103,104,116,32,65,114,109)},{string.char(84,111,114,115,111),string.char(76,101,102,116,32,76,101,103)},{string.char(84,111,114,115,111),string.char(82,105,103,104,116,32,76,101,103)},
}
local function _0xE29B(player)
if _0x7EA6[player] then return _0x7EA6[player] end
if not _0x41BA then return nil end
local _0x943D = { _0xE2CE = _0xAB99(), skeleton = {} }
for i = 1, #_0x07E8 do _0x943D.skeleton[i] = _0x1677() end
_0x7EA6[player] = _0x943D
return _0x943D
end
local function _0x867B(_0x5C0D)
local _0x99F1, _0xDAE2 = _0x81BE:WorldToViewportPoint(_0x5C0D)
return Vector2.new(_0x99F1.X, _0x99F1.Y), _0xDAE2
end
local function _0x4FC7(player, _0x2613, _0xA9C1)
local _0x943D = _0xE29B(player)
if not _0x943D or not _0x943D.box then return end
local _0xE2CE = _0x943D.box
if not (_0xC917.ESPEnabled and _0xC917.BoxESP) then _0xE2CE.Visible = false return end
local _0x08A5, _0xBE99, _0xD7AA = pcall(function() return _0x2613:GetBoundingBox() end)
if not _0x08A5 or not _0xBE99 then _0xE2CE.Visible = false return end
local _0x72F3 = {
(_0xBE99 * CFrame.new( _0xD7AA.X/2, _0xD7AA.Y/2, _0xD7AA.Z/2)).Position,
(_0xBE99 * CFrame.new(-_0xD7AA.X/2, _0xD7AA.Y/2, _0xD7AA.Z/2)).Position,
(_0xBE99 * CFrame.new( _0xD7AA.X/2, -_0xD7AA.Y/2, _0xD7AA.Z/2)).Position,
(_0xBE99 * CFrame.new(-_0xD7AA.X/2, -_0xD7AA.Y/2, _0xD7AA.Z/2)).Position,
(_0xBE99 * CFrame.new( _0xD7AA.X/2, _0xD7AA.Y/2, -_0xD7AA.Z/2)).Position,
(_0xBE99 * CFrame.new(-_0xD7AA.X/2, _0xD7AA.Y/2, -_0xD7AA.Z/2)).Position,
(_0xBE99 * CFrame.new( _0xD7AA.X/2, -_0xD7AA.Y/2, -_0xD7AA.Z/2)).Position,
(_0xBE99 * CFrame.new(-_0xD7AA.X/2, -_0xD7AA.Y/2, -_0xD7AA.Z/2)).Position,
}
local _0xF4B0, _0xA157 = math.huge, math.huge
local _0x14A1, _0xE061 = -math.huge, -math.huge
local _0x86BB = false
for _, _0x1E3C in ipairs(_0x72F3) do
local _0x7B52, _0x8B27 = _0x867B(_0x1E3C)
if _0x8B27 then
_0x86BB = true
_0xF4B0 = math.min(_0xF4B0, _0x7B52.X) _0xA157 = math.min(_0xA157, _0x7B52.Y)
_0x14A1 = math.max(_0x14A1, _0x7B52.X) _0xE061 = math.max(_0xE061, _0x7B52.Y)
end
end
if _0x86BB then
_0xE2CE.Position = Vector2.new(_0xF4B0, _0xA157)
_0xE2CE.Size = Vector2.new(math.max(_0x14A1-_0xF4B0,1), math.max(_0xE061-_0xA157,1))
_0xE2CE.Color = _0xA9C1
_0xE2CE.Visible = true
else
_0xE2CE.Visible = false
end
end
local function _0xBD57(player, _0x2613, _0xA9C1)
local _0x943D = _0xE29B(player)
if not _0x943D or not _0x943D.skeleton then return end
if not (_0xC917.ESPEnabled and _0xC917.SkeletonESP) then
for _, l in pairs(_0x943D.skeleton) do if l then l.Visible = false end end
return
end
for i, conn in ipairs(_0x07E8) do
local _0x1348 = _0x943D.skeleton[i]
if not _0x1348 then continue end
local _0x79F7 = _0x2613:FindFirstChild(conn[1])
local _0xC685 = _0x2613:FindFirstChild(conn[2])
if _0x79F7 and _0xC685 then
local _0xF6B4, _0x1FA1 = _0x867B(_0x79F7.Position)
local _0x0D13, _0x517B = _0x867B(_0xC685.Position)
if _0x1FA1 and _0x517B then
_0x1348.From = _0xF6B4 _0x1348.To = _0x0D13 _0x1348.Color = _0xA9C1 _0x1348.Visible = true
else _0x1348.Visible = false end
else _0x1348.Visible = false end
end
end
local function _0xF51D()
if not _0x41BA then return end
for _, player in ipairs(_0x89CA:GetPlayers()) do
if player == _0x46D6 then _0x979A(player) continue end
local _0x90A2 = player.Character
local _0x4124 = _0x90A2 and _0x90A2:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
if not _0x90A2 or not _0x4124 or _0x4124.Health <= 0 or not _0xC917.ESPEnabled then
_0x979A(player) continue
end
local _0xA9C1 = _0x35C7(player)
_0x4FC7(player, _0x90A2, _0xA9C1)
_0xBD57(player, _0x90A2, _0xA9C1)
end
end
_0x89CA.PlayerRemoving:Connect(_0x979A)local function _0x42A5(player)
local _0x2613 = player.Character
if not _0x2613 then return end
local _0x4124 = _0x2613:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100)) or _0x2613:WaitForChild(string.char(72,117,109,97,110,111,105,100), 1)
if not _0x4124 then return end
local _0x0792 = _0x2613:FindFirstChild(string.char(66,111,111,109,67,97,117,115,101,95,69,83,80))
if _0x0792 then _0x0792:Destroy() end
local _0x1BF1 = _0x2613:FindFirstChild(string.char(66,111,111,109,67,97,117,115,101,95,72,101,97,108,116,104,66,97,114))
if _0x1BF1 then _0x1BF1:Destroy() end
if _0xC917.HighlightESP then
local _0x1DBE = Instance.new(string.char(72,105,103,104,108,105,103,104,116))
_0x1DBE.Name =string.char(66,111,111,109,67,97,117,115,101,95,69,83,80)_0x1DBE.Adornee = _0x2613
_0x1DBE.FillTransparency = 0.55
_0x1DBE.OutlineTransparency = 0
_0x1DBE.Enabled = _0xC917.ESPEnabled
_0x1DBE.Parent = _0x2613
local function _0xFC41()
local _0x1E3C = _0x6F8D(player) and _0xC917.TeamColor or _0xC917.EnemyColor
_0x1DBE.FillColor = _0x1E3C _0x1DBE.OutlineColor = _0x1E3C
end
_0xFC41()
player:GetAttributeChangedSignal(string.char(84,101,97,109,73,68)):Connect(_0xFC41)
_0x46D6:GetAttributeChangedSignal(string.char(84,101,97,109,73,68)):Connect(_0xFC41)
end
local _0xCD4C = _0x2613:FindFirstChild(string.char(72,101,97,100)) or _0x2613:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
if not _0xCD4C then return end
local _0x8416 = Instance.new(string.char(66,105,108,108,98,111,97,114,100,71,117,105))
_0x8416.Name =string.char(66,111,111,109,67,97,117,115,101,95,72,101,97,108,116,104,66,97,114)_0x8416.Adornee = _0xCD4C
_0x8416.Size = UDim2.fromOffset(86, 9)
_0x8416.StudsOffset = Vector3.new(0, 2.7, 0)
_0x8416.AlwaysOnTop = true
_0x8416.MaxDistance = 250
_0x8416.Enabled = _0xC917.ESPEnabled
_0x8416.Parent = _0x2613
local _0x3986 = Instance.new(string.char(70,114,97,109,101))
_0x3986.Size = UDim2.fromScale(1, 1)
_0x3986.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
_0x3986.BorderSizePixel = 0
_0x3986.Parent = _0x8416
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x3986).CornerRadius = UDim.new(1, 0)
local _0x1571 = Instance.new(string.char(70,114,97,109,101))
_0x1571.Name =string.char(70,105,108,108)_0x1571.Size = UDim2.fromScale(1, 1)
_0x1571.BackgroundColor3 = Color3.fromRGB(50, 255, 120)
_0x1571.BorderSizePixel = 0
_0x1571.Parent = _0x3986
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x1571).CornerRadius = UDim.new(1, 0)
local _0x86F5 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x86F5.Size = UDim2.fromScale(1, 1)
_0x86F5.BackgroundTransparency = 1
_0x86F5.Font = Enum.Font.GothamBold
_0x86F5.TextSize = 8
_0x86F5.TextColor3 = Color3.new(1,1,1)
_0x86F5.TextStrokeTransparency = 0.6
_0x86F5.Parent = _0x3986
local function _0xE4BE()
if not _0x4124 or not _0x4124.Parent then return end
local _0x8A6E = math.clamp(_0x4124.Health / math.max(_0x4124.MaxHealth, 1), 0, 1)
_0x1571.Size = UDim2.fromScale(_0x8A6E, 1)
if _0x8A6E > 0.6 then _0x1571.BackgroundColor3 = Color3.fromRGB(50, 255, 120)
elseif _0x8A6E > 0.3 then _0x1571.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
else _0x1571.BackgroundColor3 = Color3.fromRGB(255, 60, 60) end
_0x86F5.Text = math.floor(_0x4124.Health+0.5) ..string.char(47).. math.floor(_0x4124.MaxHealth+0.5)
end
_0xE4BE()
_0x4124.HealthChanged:Connect(_0xE4BE)
end
local function _0x41FC(_0x42BF)
for _, player in ipairs(_0x89CA:GetPlayers()) do
if player.Character then
local _0x1DBE = player.Character:FindFirstChild(string.char(66,111,111,109,67,97,117,115,101,95,69,83,80))
local _0x7272 = player.Character:FindFirstChild(string.char(66,111,111,109,67,97,117,115,101,95,72,101,97,108,116,104,66,97,114))
if _0x1DBE then _0x1DBE.Enabled = _0x42BF and _0xC917.HighlightESP
elseif _0x42BF and _0xC917.HighlightESP then _0x42A5(player) end
if _0x7272 then _0x7272.Enabled = _0x42BF end
end
end
if not _0x42BF then
for player in pairs(_0x7EA6) do _0x979A(player) end
end
end
local function _0x81E2(player)
player.CharacterAdded:Connect(function() task.defer(_0x42A5, player) end)
if player.Character then task.defer(_0x42A5, player) end
end
for _, p in ipairs(_0x89CA:GetPlayers()) do _0x81E2(p) end
_0x89CA.PlayerAdded:Connect(_0x81E2)local function _0x1DC4()
local _0x0529, _0x8EAA = nil, _0xC917.FOV
local _0xBD62 = _0x669C:GetMouseLocation()
local _0x420A = _0x46D6.Character and _0x46D6.Character:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
for _, v in ipairs(_0x89CA:GetPlayers()) do
if v ~= _0x46D6 and v.Character then
local _0x4124 = v.Character:FindFirstChild(string.char(72,117,109,97,110,111,105,100))
local _0x3C03 = v.Character:FindFirstChild(_0xC917.TargetPartName)
if _0x4124 and _0x4124.Health > 0 and _0x3C03 and not _0x6F8D(v) then
if _0x420A then
if (_0x3C03.Position - _0x420A.Position).Magnitude > _0xC917.MaxDistance then continue end
endlocal _0xE725 = _0x6DD1(_0x3C03)
local _0x5C0D, _0xDAE2 = _0x81BE:WorldToViewportPoint(_0xE725)
if _0xDAE2 then
local _0xB0F4 = (Vector2.new(_0x5C0D.X, _0x5C0D.Y) - _0xBD62).Magnitude
if _0xB0F4 < _0x8EAA then
_0x0529 = v
_0x8EAA = _0xB0F4
end
end
end
end
end
return _0x0529
endlocal _0x245A, _0x1C7C, _0x35E4 = nil, nil, nil
local _0xCFC4 = 16
local function _0xB998()
if _0x245A then _0x245A:Destroy() _0x245A = nil end
local _0x90A2 = _0x46D6.Character
if _0x90A2 then
local _0x4124 = _0x90A2:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
if _0x4124 then _0x4124.PlatformStand = false end
end
end
local function _0x38FE()
_0xB998()
local _0x90A2 = _0x46D6.Character
if not _0x90A2 then return end
local _0xDA6B = _0x90A2:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
local _0x4124 = _0x90A2:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
if not _0xDA6B or not _0x4124 then return end
_0x4124.PlatformStand = true
_0x245A = Instance.new(string.char(66,111,100,121,86,101,108,111,99,105,116,121))
_0x245A.Name =string.char(66,111,111,109,67,97,117,115,101,70,108,121)_0x245A.MaxForce = Vector3.new(9e9, 9e9, 9e9)
_0x245A.Velocity = Vector3.zero
_0x245A.Parent = _0xDA6B
end
local function _0x46AC()
if not _0xC917.FlyEnabled or not _0x245A or not _0x245A.Parent then return end
local _0x9302 = _0x81BE.CFrame
local _0xBA0B = Vector3.zero
if _0x669C:IsKeyDown(Enum.KeyCode.W) then _0xBA0B += _0x9302.LookVector end
if _0x669C:IsKeyDown(Enum.KeyCode.S) then _0xBA0B -= _0x9302.LookVector end
if _0x669C:IsKeyDown(Enum.KeyCode.A) then _0xBA0B -= _0x9302.RightVector end
if _0x669C:IsKeyDown(Enum.KeyCode.D) then _0xBA0B += _0x9302.RightVector end
if _0x669C:IsKeyDown(Enum.KeyCode.Space) then _0xBA0B += Vector3.yAxis end
if _0x669C:IsKeyDown(Enum.KeyCode.LeftControl) or _0x669C:IsKeyDown(Enum.KeyCode.LeftShift) then
_0xBA0B -= Vector3.yAxis
end
_0x245A.Velocity = _0xBA0B.Magnitude > 0 and _0xBA0B.Unit * _0xC917.FlySpeed or Vector3.zero
end
local function _0x926F(_0x42BF)
if _0x1C7C then _0x1C7C:Disconnect() _0x1C7C = nil end
if _0x42BF then
_0x1C7C = _0x8FC7.Stepped:Connect(function()
local _0x90A2 = _0x46D6.Character
if not _0x90A2 then return end
for _, p in ipairs(_0x90A2:GetDescendants()) do
if p:IsA(string.char(66,97,115,101,80,97,114,116)) then p.CanCollide = false end
end
end)
end
end
local function _0xF3AE()
if _0x35E4 then _0x35E4:Disconnect() _0x35E4 = nil end
local _0x90A2 = _0x46D6.Character
if _0x90A2 then
local _0x4124 = _0x90A2:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
if _0x4124 then _0x4124.WalkSpeed = _0xCFC4 end
end
end
local function _0xB6CA()
_0xF3AE()
_0x35E4 = _0x8FC7.Heartbeat:Connect(function()
if not _0xC917.SpeedEnabled then return end
local _0x90A2 = _0x46D6.Character
if not _0x90A2 then return end
local _0x4124 = _0x90A2:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
local _0xDA6B = _0x90A2:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
if not _0x4124 or not _0xDA6B then return end
_0x4124.WalkSpeed = _0xC917.WalkSpeed
local _0x3D5C = _0x4124.MoveDirection
if _0x3D5C.Magnitude > 0.05 then
local _0xCDAA = _0xDA6B.AssemblyLinearVelocity.Y
_0xDA6B.AssemblyLinearVelocity = Vector3.new(
_0x3D5C.X * _0xC917.WalkSpeed,
_0xCDAA,
_0x3D5C.Z * _0xC917.WalkSpeed
)
end
end)
end
local function _0x6D60()
if _0xC917.SpeedEnabled then _0xB6CA() else _0xF3AE() end
end
_0x46D6.CharacterAdded:Connect(function(_0x90A2)
task.wait(0.5)
local _0x4124 = _0x90A2:WaitForChild(string.char(72,117,109,97,110,111,105,100), 3)
if _0x4124 then _0xCFC4 = _0x4124.WalkSpeed end
if _0xC917.FlyEnabled then _0x38FE() end
if _0xC917.NoclipEnabled then _0x926F(true) end
if _0xC917.SpeedEnabled then _0xB6CA() end
end)local _0x0DE6 = Instance.new(string.char(83,99,114,101,101,110,71,117,105))
_0x0DE6.Name =string.char(66,111,111,109,67,97,117,115,101,84,111,97,115,116,115)_0x0DE6.Parent = _0xB0F0
_0x0DE6.ResetOnSpawn = false
local _0x6D2A = 0
local function _0xCD56(text, _0xA9C1, force)
if not force and (os.clock() - _0x6D2A) < 0.35 then return end
_0x6D2A = os.clock()
_0xA9C1 = _0xA9C1 or _0xEC5E.Accent
local _0x5AD1 = Instance.new(string.char(70,114,97,109,101))
_0x5AD1.Size = UDim2.fromOffset(240, 36)
_0x5AD1.Position = UDim2.new(0.5, -120, 1, 30)
_0x5AD1.BackgroundColor3 = _0xEC5E.Bg2
_0x5AD1.BorderSizePixel = 0
_0x5AD1.Parent = _0x0DE6
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x5AD1).CornerRadius = UDim.new(0, 10)
local _0x642F = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0x642F.Color = _0xA9C1
_0x642F.Thickness = 1.2
_0x642F.Parent = _0x5AD1
local _0xEE2E = Instance.new(string.char(70,114,97,109,101))
_0xEE2E.Size = UDim2.new(0, 3, 1, -8)
_0xEE2E.Position = UDim2.fromOffset(6, 4)
_0xEE2E.BackgroundColor3 = _0xA9C1
_0xEE2E.BorderSizePixel = 0
_0xEE2E.Parent = _0x5AD1
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xEE2E).CornerRadius = UDim.new(1, 0)
local _0xE696 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE696.Size = UDim2.new(1, -20, 1, 0)
_0xE696.Position = UDim2.fromOffset(16, 0)
_0xE696.BackgroundTransparency = 1
_0xE696.Font = Enum.Font.GothamMedium
_0xE696.TextSize = 13
_0xE696.TextColor3 = _0xEC5E.Text
_0xE696.TextXAlignment = Enum.TextXAlignment.Left
_0xE696.Text = text
_0xE696.Parent = _0x5AD1
_0x8E12:Create(_0x5AD1, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
Position = UDim2.new(0.5, -120, 1, -50)
}):Play()
task.delay(1.6, function()
local _0x6F7F = _0x8E12:Create(_0x5AD1, TweenInfo.new(0.25), {
Position = UDim2.new(0.5, -120, 1, 30),
BackgroundTransparency = 1
})
_0x6F7F:Play()
_0x6F7F.Completed:Wait()
_0x5AD1:Destroy()
end)
endlocal _0xA1F3 = Instance.new(string.char(83,99,114,101,101,110,71,117,105))
_0xA1F3.Name =string.char(66,111,111,109,67,97,117,115,101,70,79,86)_0xA1F3.Parent = _0xB0F0
_0xA1F3.ResetOnSpawn = false
_0xA1F3.IgnoreGuiInset = true
local _0x6B65 = Instance.new(string.char(70,114,97,109,101))
_0x6B65.Name =string.char(70,79,86,67,105,114,99,108,101)_0x6B65.AnchorPoint = Vector2.new(0.5, 0.5)
_0x6B65.BackgroundTransparency = 1
_0x6B65.BorderSizePixel = 0
_0x6B65.Visible = _0xC917.ShowFOV
_0x6B65.Parent = _0xA1F3
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x6B65).CornerRadius = UDim.new(1, 0)
local _0x0ADD = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0x0ADD.Color = _0xEC5E.Accent
_0x0ADD.Thickness = 1.5
_0x0ADD.Transparency = 0.3
_0x0ADD.Parent = _0x6B65local _0x8679 = Instance.new(string.char(83,99,114,101,101,110,71,117,105))
_0x8679.Name =string.char(66,111,111,109,67,97,117,115,101,72,117,98)_0x8679.Parent = _0xB0F0
_0x8679.ResetOnSpawn = false
_0x8679.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local _0x2163 = Instance.new(string.char(70,114,97,109,101))
_0x2163.Name =string.char(77,97,105,110)_0x2163.Size = UDim2.fromOffset(340, 460)
_0x2163.Position = UDim2.fromScale(0.5, 0.5)
_0x2163.AnchorPoint = Vector2.new(0.5, 0.5)
_0x2163.BackgroundColor3 = _0xEC5E.Bg
_0x2163.BorderSizePixel = 0
_0x2163.Active = true
_0x2163.Draggable = true
_0x2163.Parent = _0x8679
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x2163).CornerRadius = UDim.new(0, 14)
local _0xBA89 = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xBA89.Color = _0xEC5E.Stroke
_0xBA89.Thickness = 1.2
_0xBA89.Parent = _0x2163
local _0xC6AD = Instance.new(string.char(70,114,97,109,101))
_0xC6AD.Size = UDim2.new(1, 0, 0, 2)
_0xC6AD.BackgroundColor3 = _0xEC5E.Accent
_0xC6AD.BorderSizePixel = 0
_0xC6AD.Parent = _0x2163
local _0x49B7 = Instance.new(string.char(70,114,97,109,101))
_0x49B7.Size = UDim2.new(1, 0, 0, 48)
_0x49B7.BackgroundColor3 = _0xEC5E.Bg2
_0x49B7.BorderSizePixel = 0
_0x49B7.Parent = _0x2163
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x49B7).CornerRadius = UDim.new(0, 14)
local _0xEA45 = Instance.new(string.char(70,114,97,109,101))
_0xEA45.Size = UDim2.new(1, 0, 0, 14)
_0xEA45.Position = UDim2.new(0, 0, 1, -14)
_0xEA45.BackgroundColor3 = _0xEC5E.Bg2
_0xEA45.BorderSizePixel = 0
_0xEA45.Parent = _0x49B7
local _0x8C62 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x8C62.BackgroundTransparency = 1
_0x8C62.Position = UDim2.fromOffset(16, 8)
_0x8C62.Size = UDim2.new(1, -60, 0, 20)
_0x8C62.Font = Enum.Font.GothamBold
_0x8C62.Text =string.char(66,79,79,77,32,67,65,85,83,69)_0x8C62.TextColor3 = _0xEC5E.Text
_0x8C62.TextSize = 17
_0x8C62.TextXAlignment = Enum.TextXAlignment.Left
_0x8C62.Parent = _0x49B7
local _0x1E8B = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x1E8B.BackgroundTransparency = 1
_0x1E8B.Position = UDim2.fromOffset(16, 27)
_0x1E8B.Size = UDim2.new(1, -60, 0, 14)
_0x1E8B.Font = Enum.Font.Gotham
_0x1E8B.Text =string.char(86,50,50,46,50,32,32,226,128,162,32,32,80,114,101,100,105,99,116,105,111,110)_0x1E8B.TextColor3 = _0xEC5E.Accent
_0x1E8B.TextSize = 11
_0x1E8B.TextXAlignment = Enum.TextXAlignment.Left
_0x1E8B.Parent = _0x49B7
local _0xC0D6 = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xC0D6.Size = UDim2.fromOffset(26, 26)
_0xC0D6.Position = UDim2.new(1, -36, 0.5, -13)
_0xC0D6.BackgroundColor3 = _0xEC5E.Bg3
_0xC0D6.Text =string.char(195,151)_0xC0D6.Font = Enum.Font.GothamBold
_0xC0D6.TextSize = 16
_0xC0D6.TextColor3 = _0xEC5E.TextDim
_0xC0D6.AutoButtonColor = false
_0xC0D6.Parent = _0x49B7
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xC0D6).CornerRadius = UDim.new(0, 7)
_0xC0D6.MouseEnter:Connect(function()
_0x8E12:Create(_0xC0D6, TweenInfo.new(0.15), {BackgroundColor3 = _0xEC5E.Danger, TextColor3 = Color3.new(1,1,1)}):Play()
end)
_0xC0D6.MouseLeave:Connect(function()
_0x8E12:Create(_0xC0D6, TweenInfo.new(0.15), {BackgroundColor3 = _0xEC5E.Bg3, TextColor3 = _0xEC5E.TextDim}):Play()
end)
_0xC0D6.MouseButton1Click:Connect(function()
_0x8679.Enabled = false
end)
local _0x0366 = Instance.new(string.char(70,114,97,109,101))
_0x0366.Size = UDim2.new(1, -24, 0, 28)
_0x0366.Position = UDim2.fromOffset(12, 54)
_0x0366.BackgroundColor3 = _0xEC5E.Bg2
_0x0366.BorderSizePixel = 0
_0x0366.Parent = _0x2163
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x0366).CornerRadius = UDim.new(0, 8)
local _0xB963 = Instance.new(string.char(70,114,97,109,101))
_0xB963.Size = UDim2.fromOffset(8, 8)
_0xB963.Position = UDim2.fromOffset(10, 10)
_0xB963.BackgroundColor3 = _0xEC5E.Danger
_0xB963.BorderSizePixel = 0
_0xB963.Parent = _0x0366
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xB963).CornerRadius = UDim.new(1, 0)
local _0x81AF = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x81AF.BackgroundTransparency = 1
_0x81AF.Position = UDim2.fromOffset(26, 0)
_0x81AF.Size = UDim2.new(1, -34, 1, 0)
_0x81AF.Font = Enum.Font.GothamMedium
_0x81AF.Text =string.char(73,110,97,99,116,105,118,101)_0x81AF.TextColor3 = _0xEC5E.TextDim
_0x81AF.TextSize = 12
_0x81AF.TextXAlignment = Enum.TextXAlignment.Left
_0x81AF.Parent = _0x0366
local _0xD938 = Instance.new(string.char(70,114,97,109,101))
_0xD938.Size = UDim2.new(1, -24, 0, 32)
_0xD938.Position = UDim2.fromOffset(12, 90)
_0xD938.BackgroundColor3 = _0xEC5E.Bg2
_0xD938.BorderSizePixel = 0
_0xD938.Parent = _0x2163
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xD938).CornerRadius = UDim.new(0, 8)
local _0xE585 = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE585.FillDirection = Enum.FillDirection.Horizontal
_0xE585.HorizontalAlignment = Enum.HorizontalAlignment.Center
_0xE585.VerticalAlignment = Enum.VerticalAlignment.Center
_0xE585.Padding = UDim.new(0, 4)
_0xE585.Parent = _0xD938
local _0xA3A3 = Instance.new(string.char(70,114,97,109,101))
_0xA3A3.Name =string.char(67,111,110,116,101,110,116)_0xA3A3.Size = UDim2.new(1, -24, 1, -150)
_0xA3A3.Position = UDim2.fromOffset(12, 130)
_0xA3A3.BackgroundTransparency = 1
_0xA3A3.Parent = _0x2163
local _0xD306 = {}
local function _0x5D7B(name)
local _0x7320 = Instance.new(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
_0x7320.Name = name
_0x7320.Size = UDim2.fromScale(1, 1)
_0x7320.BackgroundTransparency = 1
_0x7320.BorderSizePixel = 0
_0x7320.ScrollBarThickness = 3
_0x7320.ScrollBarImageColor3 = _0xEC5E.Accent
_0x7320.CanvasSize = UDim2.fromOffset(0, 0)
_0x7320.Visible = false
_0x7320.Parent = _0xA3A3
local _0x629A = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0x629A.Padding = UDim.new(0, 6)
_0x629A.SortOrder = Enum.SortOrder.LayoutOrder
_0x629A.Parent = _0x7320
_0x629A:GetPropertyChangedSignal(string.char(65,98,115,111,108,117,116,101,67,111,110,116,101,110,116,83,105,122,101)):Connect(function()
_0x7320.CanvasSize = UDim2.fromOffset(0, _0x629A.AbsoluteContentSize.Y + 8)
end)
_0xD306[name] = _0x7320
return _0x7320
end
local _0x121D = _0x5D7B(string.char(67,111,109,98,97,116))
local _0xEC65 = _0x5D7B(string.char(86,105,115,117,97,108,115))
local _0x4CEF = _0x5D7B(string.char(77,111,118,101,109,101,110,116))
local _0xF7C4 = _0x5D7B(string.char(83,101,116,116,105,110,103,115))
local function _0x19E8(name)
for _0x0F29, _0x7320 in pairs(_0xD306) do _0x7320.Visible = (_0x0F29 == name) end
for _, _0x4F23 in ipairs(_0xD938:GetChildren()) do
if _0x4F23:IsA(string.char(84,101,120,116,66,117,116,116,111,110)) then
local _0x9773 = _0x4F23.Name == name
_0x8E12:Create(_0x4F23, TweenInfo.new(0.2), {
BackgroundColor3 = _0x9773 and _0xEC5E.Accent or _0xEC5E.Bg3,
TextColor3 = _0x9773 and Color3.new(1,1,1) or _0xEC5E.TextDim
}):Play()
end
end
end
local function _0x102D(name, order)
local _0x4F23 = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0x4F23.Name = name
_0x4F23.Size = UDim2.fromOffset(72, 24)
_0x4F23.BackgroundColor3 = _0xEC5E.Bg3
_0x4F23.Text = name
_0x4F23.Font = Enum.Font.GothamMedium
_0x4F23.TextSize = 11
_0x4F23.TextColor3 = _0xEC5E.TextDim
_0x4F23.AutoButtonColor = false
_0x4F23.LayoutOrder = order
_0x4F23.Parent = _0xD938
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x4F23).CornerRadius = UDim.new(0, 6)
_0x4F23.MouseButton1Click:Connect(function() _0x19E8(name) end)
end
_0x102D(string.char(67,111,109,98,97,116), 1)
_0x102D(string.char(86,105,115,117,97,108,115), 2)
_0x102D(string.char(77,111,118,101,109,101,110,116), 3)
_0x102D(string.char(83,101,116,116,105,110,103,115), 4)local function _0xC7EA(parent, name, bindId, default, callback)
local _0xF69D = Instance.new(string.char(70,114,97,109,101))
_0xF69D.Size = UDim2.new(1, 0, 0, 38)
_0xF69D.BackgroundColor3 = _0xEC5E.Bg2
_0xF69D.BorderSizePixel = 0
_0xF69D.Parent = parent
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xF69D).CornerRadius = UDim.new(0, 9)
local _0xC859 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xC859.BackgroundTransparency = 1
_0xC859.Position = UDim2.fromOffset(12, 0)
_0xC859.Size = UDim2.new(0.45, 0, 1, 0)
_0xC859.Font = Enum.Font.GothamMedium
_0xC859.Text = name
_0xC859.TextColor3 = _0xEC5E.Text
_0xC859.TextSize = 13
_0xC859.TextXAlignment = Enum.TextXAlignment.Left
_0xC859.Parent = _0xF69D
local _0xFA0D = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xFA0D.Size = UDim2.fromOffset(48, 20)
_0xFA0D.Position = UDim2.new(0.52, 0, 0.5, -10)
_0xFA0D.BackgroundColor3 = _0xEC5E.Bg3
_0xFA0D.Text =""_0xFA0D.AutoButtonColor = false
_0xFA0D.ZIndex = 5
_0xFA0D.Parent = _0xF69D
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xFA0D).CornerRadius = UDim.new(0, 5)
local _0x407C = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x407C.Size = UDim2.fromScale(1, 1)
_0x407C.BackgroundTransparency = 1
_0x407C.Font = Enum.Font.GothamBold
_0x407C.TextSize = 10
_0x407C.TextColor3 = _0xEC5E.TextDim
_0x407C.Text =string.char(226,128,148)_0x407C.Parent = _0xFA0D
_0x286F[bindId] = _0x407C
_0xFA0D.MouseButton1Click:Connect(function()
if _0x29C8 then return end
_0x29C8 = bindId
_0x407C.Text =string.char(46,46,46)_0x407C.TextColor3 = _0xEC5E.Warning
_0xCD56(string.char(80,114,101,115,115,32,107,101,121,32,102,111,114,32).. name, _0xEC5E.Warning, true)
end)
local _0x2656 = Instance.new(string.char(70,114,97,109,101))
_0x2656.Size = UDim2.fromOffset(40, 20)
_0x2656.Position = UDim2.new(1, -52, 0.5, -10)
_0x2656.BackgroundColor3 = _0xEC5E.Bg4
_0x2656.BorderSizePixel = 0
_0x2656.Parent = _0xF69D
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x2656).CornerRadius = UDim.new(1, 0)
local _0xC15D = Instance.new(string.char(70,114,97,109,101))
_0xC15D.Size = UDim2.fromOffset(16, 16)
_0xC15D.Position = UDim2.fromOffset(2, 2)
_0xC15D.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
_0xC15D.BorderSizePixel = 0
_0xC15D.Parent = _0x2656
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xC15D).CornerRadius = UDim.new(1, 0)
local _0x42BF = default
local function _0xD1F9()
_0x8E12:Create(_0x2656, TweenInfo.new(0.2), {
BackgroundColor3 = _0x42BF and _0xEC5E.Accent or _0xEC5E.Bg4
}):Play()
_0x8E12:Create(_0xC15D, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
Position = _0x42BF and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2),
BackgroundColor3 = _0x42BF and Color3.new(1,1,1) or Color3.fromRGB(180,180,190)
}):Play()
end
_0xD1F9()
local _0x9942 = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0x9942.Size = UDim2.fromScale(1, 1)
_0x9942.BackgroundTransparency = 1
_0x9942.Text =""_0x9942.ZIndex = 2
_0x9942.Parent = _0xF69D
_0x9942.MouseButton1Click:Connect(function()
if _0x29C8 then return end
_0x42BF = not _0x42BF
_0xD1F9()
callback(_0x42BF)
end)
return {
Toggle = function()
_0x42BF = not _0x42BF
_0xD1F9()
callback(_0x42BF)
end
}
end
local function _0x9B7F(parent, name, min, max, default, isFloat, callback)
local _0xF69D = Instance.new(string.char(70,114,97,109,101))
_0xF69D.Size = UDim2.new(1, 0, 0, 42)
_0xF69D.BackgroundColor3 = _0xEC5E.Bg2
_0xF69D.BorderSizePixel = 0
_0xF69D.Parent = parent
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xF69D).CornerRadius = UDim.new(0, 9)
local _0xC859 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xC859.BackgroundTransparency = 1
_0xC859.Position = UDim2.fromOffset(12, 4)
_0xC859.Size = UDim2.new(0.6, 0, 0, 14)
_0xC859.Font = Enum.Font.GothamMedium
_0xC859.Text = name
_0xC859.TextColor3 = _0xEC5E.TextDim
_0xC859.TextSize = 11
_0xC859.TextXAlignment = Enum.TextXAlignment.Left
_0xC859.Parent = _0xF69D
local _0x8D37 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x8D37.BackgroundTransparency = 1
_0x8D37.Position = UDim2.new(0.6, 0, 0, 4)
_0x8D37.Size = UDim2.new(0.4, -12, 0, 14)
_0x8D37.Font = Enum.Font.GothamBold
_0x8D37.TextColor3 = _0xEC5E.Accent
_0x8D37.TextSize = 11
_0x8D37.TextXAlignment = Enum.TextXAlignment.Right
_0x8D37.Parent = _0xF69D
local _0xCB1A = Instance.new(string.char(70,114,97,109,101))
_0xCB1A.Size = UDim2.new(1, -24, 0, 6)
_0xCB1A.Position = UDim2.fromOffset(12, 28)
_0xCB1A.BackgroundColor3 = _0xEC5E.Bg4
_0xCB1A.BorderSizePixel = 0
_0xCB1A.Parent = _0xF69D
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xCB1A).CornerRadius = UDim.new(1, 0)
local _0x1571 = Instance.new(string.char(70,114,97,109,101))
_0x1571.Size = UDim2.new(0, 0, 1, 0)
_0x1571.BackgroundColor3 = _0xEC5E.Accent
_0x1571.BorderSizePixel = 0
_0x1571.Parent = _0xCB1A
Instance.new(string.char(85,73,67,111,114,110,101,114), _0x1571).CornerRadius = UDim.new(1, 0)
local _0xC15D = Instance.new(string.char(70,114,97,109,101))
_0xC15D.Size = UDim2.fromOffset(14, 14)
_0xC15D.AnchorPoint = Vector2.new(0.5, 0.5)
_0xC15D.Position = UDim2.new(0, 0, 0.5, 0)
_0xC15D.BackgroundColor3 = Color3.new(1,1,1)
_0xC15D.BorderSizePixel = 0
_0xC15D.ZIndex = 3
_0xC15D.Parent = _0xCB1A
Instance.new(string.char(85,73,67,111,114,110,101,114), _0xC15D).CornerRadius = UDim.new(1, 0)
local _0x218C = default
local _0x2DBB = false
local function _0x2B67()
local _0x8A6E = math.clamp((_0x218C - min) / (max - min), 0, 1)
_0x1571.Size = UDim2.new(_0x8A6E, 0, 1, 0)
_0xC15D.Position = UDim2.new(_0x8A6E, 0, 0.5, 0)
_0x8D37.Text = isFloat and string.format(string.char(37,46,50,102), _0x218C) or tostring(math.floor(_0x218C + 0.5))
end
local function _0xF4DA(x)
local _0xFCEB = _0xCB1A.AbsolutePosition.X
local _0xCC58 = _0xCB1A.AbsoluteSize.X
local _0x8A6E = math.clamp((x - _0xFCEB) / _0xCC58, 0, 1)
_0x218C = min + (max - min) * _0x8A6E
if not isFloat then _0x218C = math.floor(_0x218C + 0.5)
else _0x218C = math.floor(_0x218C * 100 + 0.5) / 100 end
_0x2B67()
callback(_0x218C)
end
local function _0x00FD(input)
_0x2DBB = true
_0x2163.Draggable = false
_0xF4DA(input.Position.X)
end
local function _0xCE1C()
if _0x2DBB then _0x2DBB = false _0x2163.Draggable = true end
end
_0xCB1A.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then _0x00FD(input) end
end)
_0xC15D.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then _0x00FD(input) end
end)
_0x669C.InputChanged:Connect(function(input)
if _0x2DBB and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
_0xF4DA(input.Position.X)
end
end)
_0x669C.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then _0xCE1C() end
end)
_0x2B67()
endlocal _0x62F0 = _0xC7EA(_0x121D,string.char(65,105,109,98,111,116),string.char(65,105,109), false, function(_0x8B27)
_0xC917.AimEnabled = _0x8B27
_0x81AF.Text = _0x8B27 andstring.char(65,99,116,105,118,101)orstring.char(73,110,97,99,116,105,118,101)_0x81AF.TextColor3 = _0x8B27 and _0xEC5E.Success or _0xEC5E.TextDim
_0x8E12:Create(_0xB963, TweenInfo.new(0.25), {
BackgroundColor3 = _0x8B27 and _0xEC5E.Success or _0xEC5E.Danger
}):Play()
_0xCD56(_0x8B27 andstring.char(65,105,109,98,111,116,32,79,110)orstring.char(65,105,109,98,111,116,32,79,102,102), _0x8B27 and _0xEC5E.Success or _0xEC5E.TextDim, true)
end)
_0xC7EA(_0x121D,string.char(80,114,101,100,105,99,116,105,111,110),string.char(80,114,101,100), true, function(_0x8B27)
_0xC917.PredictionEnabled = _0x8B27
_0xCD56(_0x8B27 andstring.char(80,114,101,100,105,99,116,105,111,110,32,79,110)orstring.char(80,114,101,100,105,99,116,105,111,110,32,79,102,102), nil, true)
end)
_0xC7EA(_0x121D,string.char(84,101,97,109,32,67,104,101,99,107),string.char(84,101,97,109), true, function(_0x8B27)
_0xC917.TeamCheck = _0x8B27
end)
_0x9B7F(_0x121D,string.char(70,79,86), 50, 800, _0xC917.FOV, false, function(v) _0xC917.FOV = v end)
_0x9B7F(_0x121D,string.char(83,109,111,111,116,104,105,110,103), 0.03, 1.00, _0xC917.Smoothing, true, function(v) _0xC917.Smoothing = v end)
_0x9B7F(_0x121D,string.char(80,114,101,100,105,99,116,105,111,110), 0.05, 0.35, _0xC917.PredictionStrength, true, function(v)
_0xC917.PredictionStrength = v
end)
_0x9B7F(_0x121D,string.char(77,97,120,32,68,105,115,116,97,110,99,101), 100, 2000, _0xC917.MaxDistance, false, function(v) _0xC917.MaxDistance = v end)
local _0x27CF = _0xC7EA(_0xEC65,string.char(69,83,80,32,77,97,115,116,101,114),string.char(69,83,80), false, function(_0x8B27)
_0xC917.ESPEnabled = _0x8B27
_0x41FC(_0x8B27)
_0xCD56(_0x8B27 andstring.char(69,83,80,32,79,110)orstring.char(69,83,80,32,79,102,102), _0x8B27 and _0xEC5E.Success or _0xEC5E.TextDim, true)
end)
_0xC7EA(_0xEC65,string.char(66,111,120,32,69,83,80),string.char(66,111,120), false, function(_0x8B27)
_0xC917.BoxESP = _0x8B27
if not _0x41BA then _0xCD56(string.char(68,114,97,119,105,110,103,32,110,111,116,32,102,111,117,110,100), _0xEC5E.Danger, true) end
end)
_0xC7EA(_0xEC65,string.char(83,107,101,108,101,116,111,110,32,69,83,80),string.char(83,107,101,108,101,116,111,110), false, function(_0x8B27)
_0xC917.SkeletonESP = _0x8B27
if not _0x41BA then _0xCD56(string.char(68,114,97,119,105,110,103,32,110,111,116,32,102,111,117,110,100), _0xEC5E.Danger, true) end
end)
_0xC7EA(_0xEC65,string.char(72,105,103,104,108,105,103,104,116,32,69,83,80),string.char(72,105,103,104,108,105,103,104,116), true, function(_0x8B27)
_0xC917.HighlightESP = _0x8B27
_0x41FC(_0xC917.ESPEnabled)
end)
local _0x6628 = _0xC7EA(_0xEC65,string.char(70,79,86,32,67,105,114,99,108,101),string.char(70,79,86), true, function(_0x8B27)
_0xC917.ShowFOV = _0x8B27
_0x6B65.Visible = _0x8B27
end)
local _0xA95B = _0xC7EA(_0x4CEF,string.char(70,108,121),string.char(70,108,121), false, function(_0x8B27)
_0xC917.FlyEnabled = _0x8B27
if _0x8B27 then _0x38FE() else _0xB998() end
_0xCD56(_0x8B27 andstring.char(70,108,121,32,79,110)orstring.char(70,108,121,32,79,102,102), _0x8B27 and _0xEC5E.Success or _0xEC5E.TextDim, true)
end)
local _0xA759 = _0xC7EA(_0x4CEF,string.char(83,112,101,101,100),string.char(83,112,101,101,100), false, function(_0x8B27)
_0xC917.SpeedEnabled = _0x8B27
_0x6D60()
_0xCD56(_0x8B27 andstring.char(83,112,101,101,100,32,79,110)orstring.char(83,112,101,101,100,32,79,102,102), _0x8B27 and _0xEC5E.Success or _0xEC5E.TextDim, true)
end)
local _0x5314 = _0xC7EA(_0x4CEF,string.char(78,111,99,108,105,112),string.char(78,111,99,108,105,112), false, function(_0x8B27)
_0xC917.NoclipEnabled = _0x8B27
_0x926F(_0x8B27)
_0xCD56(_0x8B27 andstring.char(78,111,99,108,105,112,32,79,110)orstring.char(78,111,99,108,105,112,32,79,102,102), _0x8B27 and _0xEC5E.Success or _0xEC5E.TextDim, true)
end)
_0x9B7F(_0x4CEF,string.char(70,108,121,32,83,112,101,101,100), 10, 200, _0xC917.FlySpeed, false, function(v) _0xC917.FlySpeed = v end)
_0x9B7F(_0x4CEF,string.char(87,97,108,107,32,83,112,101,101,100), 16, 200, _0xC917.WalkSpeed, false, function(v)
_0xC917.WalkSpeed = v
if _0xC917.SpeedEnabled then _0x6D60() end
end)
local _0x601B = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x601B.Size = UDim2.new(1, 0, 0, 60)
_0x601B.BackgroundTransparency = 1
_0x601B.Font = Enum.Font.Gotham
_0x601B.TextSize = 12
_0x601B.TextColor3 = _0xEC5E.TextDim
_0x601B.Text =string.char(80,114,101,100,105,99,116,105,111,110,32,97,105,109,115,32,97,104,101,97,100,32,111,102,32,109,111,118,105,110,103,32,116,97,114,103,101,116,115,46,10,83,119,101,101,116,32,115,112,111,116,58,32,48,46,49,50,32,226,128,147,32,48,46,50,48,10,82,105,103,104,116,83,104,105,102,116,32,61,32,77,101,110,117)_0x601B.TextWrapped = true
_0x601B.Parent = _0xF7C4
local _0x5CD2 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x5CD2.BackgroundTransparency = 1
_0x5CD2.Position = UDim2.new(0, 0, 1, -24)
_0x5CD2.Size = UDim2.new(1, 0, 0, 18)
_0x5CD2.Font = Enum.Font.Gotham
_0x5CD2.TextSize = 10
_0x5CD2.TextColor3 = Color3.fromRGB(90, 90, 105)
_0x5CD2.Parent = _0x2163
_0x286F.Footer = _0x5CD2
local function _0xDABE(kc)
if not kc then returnstring.char(63)end
local _0x0F29 = kc.Name
local _0x5290 = {RightShift=string.char(82,83,104,105,102,116),LeftShift=string.char(76,83,104,105,102,116),RightControl=string.char(82,67,116,114,108),LeftControl=string.char(76,67,116,114,108)}
return _0x5290[_0x0F29] or _0x0F29
end
local function _0x4BDC()
if _0x286F.Aim then _0x286F.Aim.Text = _0xDABE(_0xC917.AimKey) end
if _0x286F.ESP then _0x286F.ESP.Text = _0xDABE(_0xC917.ESPKey) end
if _0x286F.FOV then _0x286F.FOV.Text = _0xDABE(_0xC917.FOVKey) end
if _0x286F.Fly then _0x286F.Fly.Text = _0xDABE(_0xC917.FlyKey) end
if _0x286F.Speed then _0x286F.Speed.Text = _0xDABE(_0xC917.SpeedKey) end
if _0x286F.Noclip then _0x286F.Noclip.Text = _0xDABE(_0xC917.NoclipKey) end
if _0x286F.Footer then
_0x286F.Footer.Text = _0xDABE(_0xC917.ToggleKey) ..string.char(32,32,77,101,110,117)end
end
_0x4BDC()
_0x19E8(string.char(67,111,109,98,97,116))_0x669C.InputBegan:Connect(function(input)
if _0x29C8 and input.KeyCode == Enum.KeyCode.Escape then
_0x29C8 = nil
_0x4BDC()
_0xCD56(string.char(67,97,110,99,101,108,108,101,100), _0xEC5E.TextDim, true)
return
end
if _0x29C8 then
if input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.Escape then
if _0x29C8 ==string.char(65,105,109)then _0xC917.AimKey = input.KeyCode
elseif _0x29C8 ==string.char(69,83,80)then _0xC917.ESPKey = input.KeyCode
elseif _0x29C8 ==string.char(70,79,86)then _0xC917.FOVKey = input.KeyCode
elseif _0x29C8 ==string.char(70,108,121)then _0xC917.FlyKey = input.KeyCode
elseif _0x29C8 ==string.char(83,112,101,101,100)then _0xC917.SpeedKey = input.KeyCode
elseif _0x29C8 ==string.char(78,111,99,108,105,112)then _0xC917.NoclipKey = input.KeyCode
elseif _0x29C8 ==string.char(84,101,97,109)then _0xC917.TeamKey = input.KeyCode
end
_0x29C8 = nil
_0x4BDC()
_0xCD56(string.char(66,111,117,110,100,32,116,111,32).. _0xDABE(input.KeyCode), _0xEC5E.Success, true)
end
return
end
if input.KeyCode == _0xC917.ToggleKey then
_0x8679.Enabled = not _0x8679.Enabled
elseif input.KeyCode == _0xC917.AimKey then _0x62F0.Toggle()
elseif input.KeyCode == _0xC917.ESPKey then _0x27CF.Toggle()
elseif input.KeyCode == _0xC917.FOVKey then _0x6628.Toggle()
elseif input.KeyCode == _0xC917.FlyKey then _0xA95B.Toggle()
elseif input.KeyCode == _0xC917.SpeedKey then _0xA759.Toggle()
elseif input.KeyCode == _0xC917.NoclipKey then _0x5314.Toggle()
end
end)_0x8FC7.RenderStepped:Connect(function()
pcall(_0xF51D)
_0x46AC()
if _0xC917.ShowFOV then
local _0xBD62 = _0x669C:GetMouseLocation()
_0x6B65.Position = UDim2.fromOffset(_0xBD62.X, _0xBD62.Y)
_0x6B65.Size = UDim2.fromOffset(_0xC917.FOV * 2, _0xC917.FOV * 2)
_0x6B65.Visible = true
_0x0ADD.Transparency = _0xC917.AimEnabled and (0.1 + math.sin(os.clock()*5)*0.08) or 0.35
else
_0x6B65.Visible = false
end
if not _0xC917.AimEnabled then return end
if not _0x669C:IsMouseButtonPressed(_0xC917.HoldKey) then return end
local _0xAFAE = _0x1DC4()
if not _0xAFAE or not _0xAFAE.Character then return end
local _0x3C03 = _0xAFAE.Character:FindFirstChild(_0xC917.TargetPartName)
if not _0x3C03 then return endlocal _0xE725 = _0x6DD1(_0x3C03)
local _0x554B, _0xDAE2 = _0x81BE:WorldToViewportPoint(_0xE725)
if not _0xDAE2 then return end
local _0xBD62 = _0x669C:GetMouseLocation()
local _0xFF87 = _0x554B.X - _0xBD62.X
local _0x7E2D = _0x554B.Y - _0xBD62.Y
if math.abs(_0xFF87) > 0.5 or math.abs(_0x7E2D) > 0.5 then
mousemoverel(_0xFF87 * _0xC917.Smoothing, _0x7E2D * _0xC917.Smoothing)
end
end)
_0x8FC7.Heartbeat:Connect(function()
if not _0xC917.ESPEnabled then return end
for _, p in ipairs(_0x89CA:GetPlayers()) do
local _0x90A2 = p.Character
if _0x90A2 then
local _0x1DBE = _0x90A2:FindFirstChild(string.char(66,111,111,109,67,97,117,115,101,95,69,83,80))
local _0x7272 = _0x90A2:FindFirstChild(string.char(66,111,111,109,67,97,117,115,101,95,72,101,97,108,116,104,66,97,114))
local _0x4124 = _0x90A2:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
local _0xE2EC = _0x4124 and _0x4124.Health > 0
if _0x1DBE then _0x1DBE.Enabled = _0xE2EC and _0xC917.HighlightESP end
if _0x7272 then _0x7272.Enabled = _0xE2EC end
end
end
end)
_0xCD56(string.char(66,79,79,77,32,67,65,85,83,69,32,86,50,50,46,50,32,82,101,97,100,121), _0xEC5E.Accent, true)
