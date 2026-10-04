local _0x79A1 = game:GetService("Players")
local _0xFF34 = game:GetService("RunService")
local _0xFAA5 = game:GetService("ReplicatedStorage")
local _0xADC5 = game:GetService("CoreGui")
local _0xE91C = game:GetService("UserInputService")
local _0x8979 = game:GetService("TweenService")
local _0xB57B = game:GetService("ContextActionService")
local _0xB745 = _0x79A1.LocalPlayer
local _0x3F26 = workspace.CurrentCameralocal _0xD5D2 = {
Innocent = Color3.fromRGB(80, 255, 80),
Sheriff = Color3.fromRGB(50, 140, 255),
Murderer = Color3.fromRGB(255, 50, 50),
Hero = Color3.fromRGB(255, 210, 50),
Unknown = Color3.fromRGB(170, 170, 170),
}
local _0x2606 = Color3.fromRGB(50, 140, 255)
local _0x4511 = {
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
coinFarmDelay = 0.45,coinFarmSpeed = 28,coinFarmPause = 0.8,boxThickness = 1.5,
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
}
local _0xC069, _0xB04B = {}, 0
local _0x830D, _0x8B71, _0x29F7 = {}, {}, {}
local _0x6C12, _0x7B25 = 0, 1.0
local _0xD2E2, _0xC9FB, _0x92FB = false, 0, 3
local _0xC98A = {}
local _0x56BC = false
local _0xBC9B, _0x9E64, _0x688E = nil, nil, nil
local _0x7AFF, _0x5D45, _0x1A0E = nil, nil, nil
local _0x2A76 = 16local function _0xFF27(player, toolName)
local _0xDB3B = player.Character
if _0xDB3B and _0xDB3B:FindFirstChild(toolName) then return true end
local _0x7642 = player:FindFirstChild("Backpack")
if _0x7642 and _0x7642:FindFirstChild(toolName) then return true end
return false
end
local function _0x540C()
local _0x0498, _0x2958 = pcall(function()
local _0x20BE = _0xFAA5:FindFirstChild("GetPlayerData", true)
if _0x20BE and _0x20BE:IsA("RemoteFunction") then return _0x20BE:InvokeServer() end
return nil
end)
if not _0x0498 or type(_0x2958) ~="table"then return false end
for _0x10B3, info in pairs(_0x2958) do
local _0x788A = _0x79A1:FindFirstChild(_0x10B3)
if _0x788A and type(info) =="table"then
local _0x5CCB = info.Role
if type(_0x5CCB) =="string"and _0x5CCB ~=""then
_0xC069[_0x788A] = (info.Killed or info.Dead) and"Unknown"or _0x5CCB
end
end
end
return true
end
local function _0xCE98(player)
if _0xC069[player] then return _0xC069[player] end
if _0xFF27(player,"Knife") then _0xC069[player] ="Murderer"return"Murderer"end
if _0xFF27(player,"Gun") then _0xC069[player] ="Sheriff"return"Sheriff"end
return"Innocent"end
local function _0xDA36(_0x5CCB)
return _0xD5D2[_0x5CCB] or _0xD5D2.Unknown
endlocal function _0xCC7B()
if _0x688E then
pcall(function() _0x688E:Stop(0.2) end)
_0x688E = nil
end
end
local function _0xA451()
_0xCC7B()
local _0xDB3B = _0xB745.Character
if not _0xDB3B then return end
local _0x4B9E = _0xDB3B:FindFirstChildOfClass("Humanoid")
if not _0x4B9E then return end
local _0x1AA2 = _0x4B9E:FindFirstChildOfClass("Animator")
if not _0x1AA2 then
_0x1AA2 = Instance.new("Animator")
_0x1AA2.Parent = _0x4B9E
end
local _0x64A2 = Instance.new("Animation")
_0x64A2.AnimationId ="rbxassetid://507767968"local _0x0498, _0x766D = pcall(function() return _0x1AA2:LoadAnimation(_0x64A2) end)
if _0x0498 and _0x766D then
_0x766D.Looped = true
_0x766D.Priority = Enum.AnimationPriority.Action
_0x766D:Play(0.25)
_0x688E = _0x766D
end
end
local function _0x5E1D()
if _0xBC9B then _0xBC9B:Destroy() _0xBC9B = nil end
if _0x9E64 then _0x9E64:Destroy() _0x9E64 = nil end
_0xCC7B()
local _0xDB3B = _0xB745.Character
if _0xDB3B then
local _0x4B9E = _0xDB3B:FindFirstChildOfClass("Humanoid")
if _0x4B9E then
_0x4B9E.PlatformStand = false
_0x4B9E:ChangeState(Enum.HumanoidStateType.GettingUp)
end
end
end
local function _0xB242()
_0x5E1D()
local _0xDB3B = _0xB745.Character
if not _0xDB3B then return end
local _0xE49C = _0xDB3B:FindFirstChild("HumanoidRootPart")
local _0x4B9E = _0xDB3B:FindFirstChildOfClass("Humanoid")
if not _0xE49C or not _0x4B9E then return end
_0x4B9E.PlatformStand = true
_0xBC9B = Instance.new("BodyVelocity")
_0xBC9B.Name ="DihFly"_0xBC9B.MaxForce = Vector3.new(9e9, 9e9, 9e9)
_0xBC9B.P = 1250
_0xBC9B.Velocity = Vector3.zero
_0xBC9B.Parent = _0xE49C
_0x9E64 = Instance.new("BodyGyro")
_0x9E64.Name ="DihFlyGyro"_0x9E64.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
_0x9E64.P = 3000
_0x9E64.D = 500
_0x9E64.CFrame = _0xE49C.CFrame
_0x9E64.Parent = _0xE49C
_0xA451()
end
local function _0x093B()
if not _0x4511.FlyEnabled then return end
if _0x56BC then return end
if not _0xBC9B or not _0xBC9B.Parent then
if _0x4511.FlyEnabled then _0xB242() end
return
end
local _0x4A7E = workspace.CurrentCamera
if not _0x4A7E then return end
local _0x8419 = _0x4A7E.CFrame
local _0x468D = Vector3.zero
if _0xE91C:IsKeyDown(Enum.KeyCode.W) then _0x468D += _0x8419.LookVector end
if _0xE91C:IsKeyDown(Enum.KeyCode.S) then _0x468D -= _0x8419.LookVector end
if _0xE91C:IsKeyDown(Enum.KeyCode.A) then _0x468D -= _0x8419.RightVector end
if _0xE91C:IsKeyDown(Enum.KeyCode.D) then _0x468D += _0x8419.RightVector end
if _0xE91C:IsKeyDown(Enum.KeyCode.Space) then _0x468D += Vector3.yAxis end
if _0xE91C:IsKeyDown(Enum.KeyCode.LeftControl) or _0xE91C:IsKeyDown(Enum.KeyCode.LeftShift) then
_0x468D -= Vector3.yAxis
end
if _0x468D.Magnitude > 0 then
_0xBC9B.Velocity = _0x468D.Unit * _0x4511.FlySpeed
else
_0xBC9B.Velocity = Vector3.new(0, 0.5, 0)
end
if _0x9E64 and _0x9E64.Parent then
local _0xB605 = _0x8419.LookVector
local _0xE16D = Vector3.new(_0xB605.X, 0, _0xB605.Z)
if _0xE16D.Magnitude > 0.05 then
_0x9E64.CFrame = CFrame.lookAt(Vector3.zero, _0xE16D)
else
_0x9E64.CFrame = CFrame.lookAt(Vector3.zero, _0xB605)
end
end
endlocal function _0xD3B0(state)
if _0x7AFF then _0x7AFF:Disconnect() _0x7AFF = nil end
if state then
_0x7AFF = _0xFF34.Stepped:Connect(function()
local _0xDB3B = _0xB745.Character
if not _0xDB3B then return end
for _, _0x5319 in ipairs(_0xDB3B:GetDescendants()) do
if _0x5319:IsA("BasePart") then _0x5319.CanCollide = false end
end
end)
end
end
local function _0x3C9D()
if _0x5D45 then _0x5D45:Disconnect() _0x5D45 = nil end
local _0xDB3B = _0xB745.Character
if _0xDB3B then
local _0x4B9E = _0xDB3B:FindFirstChildOfClass("Humanoid")
if _0x4B9E then _0x4B9E.WalkSpeed = _0x2A76 end
end
end
local function _0x7287()
_0x3C9D()
_0x5D45 = _0xFF34.Heartbeat:Connect(function()
if not _0x4511.SpeedEnabled then return end
local _0xDB3B = _0xB745.Character
if not _0xDB3B then return end
local _0x4B9E = _0xDB3B:FindFirstChildOfClass("Humanoid")
local _0xE49C = _0xDB3B:FindFirstChild("HumanoidRootPart")
if not _0x4B9E or not _0xE49C then return end
_0x4B9E.WalkSpeed = _0x4511.WalkSpeed
local _0xC505 = _0x4B9E.MoveDirection
if _0xC505.Magnitude > 0.05 then
local _0x1653 = _0xE49C.AssemblyLinearVelocity.Y
_0xE49C.AssemblyLinearVelocity = Vector3.new(_0xC505.X * _0x4511.WalkSpeed, _0x1653, _0xC505.Z * _0x4511.WalkSpeed)
end
end)
end
local function _0x3C57()
if _0x4511.SpeedEnabled then _0x7287() else _0x3C9D() end
endlocal _0x1A0E = nil
local _0xDB64 = {}
local _0xE342 = {}
local function _0xDB76()
if _0x1A0E then
_0x1A0E:Disconnect()
_0x1A0E = nil
end
for _, _0x1FD8 in pairs(_0xDB64) do
pcall(function() _0x1FD8:Disconnect() end)
end
table.clear(_0xDB64)
table.clear(_0xE342)
local _0xDB3B = _0xB745.Character
local _0xE49C = _0xDB3B and _0xDB3B:FindFirstChild("HumanoidRootPart")
if _0xE49C then
_0xE49C.AssemblyAngularVelocity = Vector3.zero
end
end
local function _0x1937(_0xA927, myHRP)
if not _0xA927 or not _0xA927.Parent then return end
local _0x788A = _0x79A1:GetPlayerFromCharacter(_0xA927.Parent)
if not _0x788A or _0x788A == _0xB745 then return end
if _0xE342[_0x788A] and tick() - _0xE342[_0x788A] < 0.35 then return end
_0xE342[_0x788A] = tick()local _0xC4D9 = (_0xA927.Position - myHRP.Position)
if _0xC4D9.Magnitude < 0.1 then
_0xC4D9 = myHRP.CFrame.LookVector
else
_0xC4D9 = _0xC4D9.Unit
endpcall(function()
_0xA927.AssemblyLinearVelocity = _0xC4D9 * 120 + Vector3.new(0, 90, 0)
_0xA927.AssemblyAngularVelocity = Vector3.new(
math.random(-1, 1) * 80,
math.random(-1, 1) * 80,
math.random(-1, 1) * 80
)
end)pcall(function()
myHRP.AssemblyAngularVelocity = Vector3.new(0, 2e4, 0)
end)
task.delay(0.08, function()
if myHRP and myHRP.Parent then
myHRP.AssemblyAngularVelocity = Vector3.zero
end
end)
end
local function _0x05FF(_0xDB3B)
for _, _0x1FD8 in pairs(_0xDB64) do
pcall(function() _0x1FD8:Disconnect() end)
end
table.clear(_0xDB64)
local _0xE49C = _0xDB3B:FindFirstChild("HumanoidRootPart")
if not _0xE49C then return end
local function _0xD021(hit)
if not _0x4511.WalkFlingEnabled then return end
if not hit or not hit.Parent then return end
local _0x9E05 = hit.Parent
if not _0x9E05:FindFirstChildOfClass("Humanoid") then
_0x9E05 = hit.Parent.Parent
end
if not _0x9E05 then return end
local _0xA927 = _0x9E05:FindFirstChild("HumanoidRootPart")
local _0x50E9 = _0x9E05:FindFirstChildOfClass("Humanoid")
if not _0xA927 or not _0x50E9 or _0x50E9.Health <= 0 then return end
if _0x9E05 == _0xDB3B then return end
_0x1937(_0xA927, _0xE49C)
endfor _, _0x10B3 in ipairs({"HumanoidRootPart","UpperTorso","Torso","Head","Left Arm","Right Arm","Left Leg","Right Leg","LeftUpperArm","RightUpperArm","LeftUpperLeg","RightUpperLeg"}) do
local _0xA7D1 = _0xDB3B:FindFirstChild(_0x10B3)
if _0xA7D1 and _0xA7D1:IsA("BasePart") then
_0xDB64[_0x10B3] = _0xA7D1.Touched:Connect(_0xD021)
end
end
end
local function _0x6A63()
_0xDB76()
local _0xDB3B = _0xB745.Character
if _0xDB3B then
_0x05FF(_0xDB3B)
end_0x1A0E = _0xFF34.Heartbeat:Connect(function()
if not _0x4511.WalkFlingEnabled then return end
local _0x4C20 = _0xB745.Character
local _0xE49C = _0x4C20 and _0x4C20:FindFirstChild("HumanoidRootPart")
if _0xE49C and _0xE49C.AssemblyAngularVelocity.Magnitude > 1e3 thenend
end)
end
_0xB745.CharacterAdded:Connect(function(_0xDB3B)
task.wait(0.5)
local _0x4B9E = _0xDB3B:WaitForChild("Humanoid", 3)
if _0x4B9E then _0x2A76 = _0x4B9E.WalkSpeed end
if _0x4511.FlyEnabled then _0xB242() end
if _0x4511.NoclipEnabled then _0xD3B0(true) end
if _0x4511.SpeedEnabled then _0x7287() end
if _0x4511.WalkFlingEnabled then _0x6A63() end
end)local function _0x9A52(worldPos)
if not _0x3F26 then return nil end
local _0x0FF1, _0xB637 = _0x3F26:WorldToViewportPoint(worldPos)
if not _0xB637 or _0x0FF1.Z <= 0 then return nil end
return Vector2.new(_0x0FF1.X, _0x0FF1.Y)
end
local _0x4D74 = {
{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local _0x2802 = {
{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"},
}
local _0x53F7 = {"Head","HumanoidRootPart","UpperTorso","LowerTorso","Torso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","Left Arm","Right Arm","Left Leg","Right Leg",
}
local _0x4F24 = {
{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8},
}
local function _0x90E8()
local _0xCF9A = {}
_0xCF9A.box = Drawing.new("Square")
_0xCF9A.box.Thickness = _0x4511.boxThickness
_0xCF9A.box.Filled = false
_0xCF9A.box.Visible = false
_0xCF9A.nameTag = Drawing.new("Text")
_0xCF9A.nameTag.Font = _0x4511.font
_0xCF9A.nameTag.Size = _0x4511.fontSize
_0xCF9A.nameTag.Center = true
_0xCF9A.nameTag.Outline = true
_0xCF9A.nameTag.OutlineColor = Color3.new(0,0,0)
_0xCF9A.nameTag.Visible = false
_0xCF9A.roleTag = Drawing.new("Text")
_0xCF9A.roleTag.Font = _0x4511.font
_0xCF9A.roleTag.Size = _0x4511.fontSize - 2
_0xCF9A.roleTag.Center = true
_0xCF9A.roleTag.Outline = true
_0xCF9A.roleTag.OutlineColor = Color3.new(0,0,0)
_0xCF9A.roleTag.Visible = false
_0xCF9A.distTag = Drawing.new("Text")
_0xCF9A.distTag.Font = _0x4511.font
_0xCF9A.distTag.Size = _0x4511.fontSize - 4
_0xCF9A.distTag.Center = true
_0xCF9A.distTag.Outline = true
_0xCF9A.distTag.OutlineColor = Color3.new(0,0,0)
_0xCF9A.distTag.Visible = false
_0xCF9A.skeleton = {}
for i = 1, 15 do
local _0x2E6F = Drawing.new("Line")
_0x2E6F.Thickness = _0x4511.skeletonThickness
_0x2E6F.Visible = false
_0xCF9A.skeleton[i] = _0x2E6F
end
_0xCF9A.body3d = {}
for i = 1, 12 do
local _0x2E6F = Drawing.new("Line")
_0x2E6F.Thickness = 1.4
_0x2E6F.Visible = false
_0xCF9A.body3d[i] = _0x2E6F
end
_0xCF9A.highlight = Instance.new("Highlight")
_0xCF9A.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
_0xCF9A.highlight.FillTransparency = _0x4511.highlightFillTrans
_0xCF9A.highlight.OutlineTransparency = _0x4511.highlightOutlineTrans
_0xCF9A.highlight.Enabled = false
_0xCF9A.highlight.Parent = _0xADC5
return _0xCF9A
end
local function _0xBA6A(_0xBA3E)
if not _0xBA3E then return end
pcall(function() _0xBA3E.box:Remove() end)
pcall(function() _0xBA3E.nameTag:Remove() end)
pcall(function() _0xBA3E.roleTag:Remove() end)
pcall(function() _0xBA3E.distTag:Remove() end)
if _0xBA3E.skeleton then for _, _0x2E6F in ipairs(_0xBA3E.skeleton) do pcall(function() _0x2E6F:Remove() end) end end
if _0xBA3E.body3d then for _, _0x2E6F in ipairs(_0xBA3E.body3d) do pcall(function() _0x2E6F:Remove() end) end end
if _0xBA3E.highlight then pcall(function() _0xBA3E.highlight:Destroy() end) end
end
local function _0x2856(_0xBA3E)
if not _0xBA3E then return end
if _0xBA3E.box then _0xBA3E.box.Visible = false end
if _0xBA3E.nameTag then _0xBA3E.nameTag.Visible = false end
if _0xBA3E.roleTag then _0xBA3E.roleTag.Visible = false end
if _0xBA3E.distTag then _0xBA3E.distTag.Visible = false end
if _0xBA3E.highlight then _0xBA3E.highlight.Enabled = false end
if _0xBA3E.skeleton then for _, _0x2E6F in ipairs(_0xBA3E.skeleton) do _0x2E6F.Visible = false end end
if _0xBA3E.body3d then for _, _0x2E6F in ipairs(_0xBA3E.body3d) do _0x2E6F.Visible = false end end
end
local function _0x81E3()
for player, _0xBA3E in pairs(_0x830D) do
_0xBA6A(_0xBA3E)
_0x830D[player] = nil
end
end
local function _0x1C40(_0xDB3B)
local _0xC301, _0xC340 = math.huge, math.huge
local _0x346D, _0x6471 = -math.huge, -math.huge
local _0x58DE = false
for _, _0x10B3 in ipairs(_0x53F7) do
local _0xA7D1 = _0xDB3B:FindFirstChild(_0x10B3)
if _0xA7D1 and _0xA7D1:IsA("BasePart") then
local _0x135F = _0x9A52(_0xA7D1.Position)
if _0x135F then
_0x58DE = true
_0xC301 = math.min(_0xC301, _0x135F.X)
_0xC340 = math.min(_0xC340, _0x135F.Y)
_0x346D = math.max(_0x346D, _0x135F.X)
_0x6471 = math.max(_0x6471, _0x135F.Y)
end
end
end
if not _0x58DE then return nil end
local _0x10AD = 6
_0xC301 -= _0x10AD; _0xC340 -= _0x10AD; _0x346D += _0x10AD; _0x6471 += _0x10AD
return Vector2.new(_0xC301, _0xC340), Vector2.new(math.clamp(_0x346D-_0xC301,8,220), math.clamp(_0x6471-_0xC340,12,320))
end
local function _0x5C38(_0xDB3B)
local _0x1B42 = Vector3.new(math.huge, math.huge, math.huge)
local _0x0742 = Vector3.new(-math.huge, -math.huge, -math.huge)
local _0x58DE = false
for _, _0x10B3 in ipairs(_0x53F7) do
local _0xA7D1 = _0xDB3B:FindFirstChild(_0x10B3)
if _0xA7D1 and _0xA7D1:IsA("BasePart") then
_0x58DE = true
local _0xCEB3, _0xABF1 = _0xA7D1.CFrame, _0xA7D1.Size
local _0x6B39 = _0xABF1 * 0.5
for _, ox in ipairs({-1,1}) do
for _, oy in ipairs({-1,1}) do
for _, oz in ipairs({-1,1}) do
local _0x2838 = (_0xCEB3 * CFrame.new(_0x6B39.X*ox, _0x6B39.Y*oy, _0x6B39.Z*oz)).Position
_0x1B42 = Vector3.new(math.min(_0x1B42.X,_0x2838.X), math.min(_0x1B42.Y,_0x2838.Y), math.min(_0x1B42.Z,_0x2838.Z))
_0x0742 = Vector3.new(math.max(_0x0742.X,_0x2838.X), math.max(_0x0742.Y,_0x2838.Y), math.max(_0x0742.Z,_0x2838.Z))
end
end
end
end
end
if not _0x58DE then return nil end
return {
Vector3.new(_0x1B42.X,_0x1B42.Y,_0x1B42.Z), Vector3.new(_0x0742.X,_0x1B42.Y,_0x1B42.Z),
Vector3.new(_0x0742.X,_0x1B42.Y,_0x0742.Z), Vector3.new(_0x1B42.X,_0x1B42.Y,_0x0742.Z),
Vector3.new(_0x1B42.X,_0x0742.Y,_0x1B42.Z), Vector3.new(_0x0742.X,_0x0742.Y,_0x1B42.Z),
Vector3.new(_0x0742.X,_0x0742.Y,_0x0742.Z), Vector3.new(_0x1B42.X,_0x0742.Y,_0x0742.Z),
}
end
local function _0xEE0E(_0xBA3E, _0xDB3B, _0xF5CB)
if not _0x4511.show3DBody or not _0xBA3E.body3d then
if _0xBA3E.body3d then for _, _0x2E6F in ipairs(_0xBA3E.body3d) do _0x2E6F.Visible = false end end
return
end
local _0x79A4 = _0x5C38(_0xDB3B)
if not _0x79A4 then
for _, _0x2E6F in ipairs(_0xBA3E.body3d) do _0x2E6F.Visible = false end
return
end
local _0x9A0F, _0xA81B = {}, false
for i, _0x2838 in ipairs(_0x79A4) do
local _0x135F = _0x9A52(_0x2838)
_0x9A0F[i] = _0x135F
if _0x135F then _0xA81B = true end
end
if not _0xA81B then
for _, _0x2E6F in ipairs(_0xBA3E.body3d) do _0x2E6F.Visible = false end
return
end
for i, edge in ipairs(_0x4F24) do
local _0x2E6F = _0xBA3E.body3d[i]
local _0x89CB, _0x9AB0 = _0x9A0F[edge[1]], _0x9A0F[edge[2]]
if _0x89CB and _0x9AB0 and _0x2E6F then
_0x2E6F.From = _0x89CB; _0x2E6F.To = _0x9AB0; _0x2E6F.Color = _0xF5CB; _0x2E6F.Visible = true
elseif _0x2E6F then _0x2E6F.Visible = false end
end
endlocal function _0x348A()
if _0xCE98(_0xB745) =="Murderer"then return false end
local _0xDB3B = _0xB745.Character
local _0x4B9E = _0xDB3B and _0xDB3B:FindFirstChildOfClass("Humanoid")
if not _0x4B9E or _0x4B9E.Health <= 0 then return false end
if _0xFF27(_0xB745,"Gun") then return false end
return true
end
local function _0x112A(gun)
if not _0x4511.autoTakeGun or _0xD2E2 then return end
if tick() - _0xC9FB < _0x92FB then return end
if _0xC98A[gun] then return end
if not gun or not gun.Parent or gun.Name ~="GunDrop"then return end
if not _0x348A() then return end
local _0xDB3B = _0xB745.Character
local _0xE49C = _0xDB3B and _0xDB3B:FindFirstChild("HumanoidRootPart")
if not _0xE49C then return end
_0xC98A[gun] = true
_0xD2E2 = true
_0xC9FB = tick()
local _0xD91D = _0xE49C.CFrame
_0xE49C.CFrame = CFrame.new(gun.Position + Vector3.new(0, 3, 0))
task.wait(_0x4511.autoTakeDelay or 0.15)
local _0xA396 = _0xB745.Character
local _0x5DDA = _0xA396 and _0xA396:FindFirstChild("HumanoidRootPart")
local _0x3CF1 = _0xA396 and _0xA396:FindFirstChildOfClass("Humanoid")
if _0x5DDA and _0x3CF1 and _0x3CF1.Health > 0 then _0x5DDA.CFrame = _0xD91D end
_0xD2E2 = false
endlocal function _0xA19C()
local _0xCF9A = {}
_0xCF9A.box = Drawing.new("Square")
_0xCF9A.box.Thickness = 1.5
_0xCF9A.box.Filled = false
_0xCF9A.box.Color = _0x2606
_0xCF9A.box.Visible = false
_0xCF9A.label = Drawing.new("Text")
_0xCF9A.label.Font = _0x4511.font
_0xCF9A.label.Size = _0x4511.fontSize
_0xCF9A.label.Center = true
_0xCF9A.label.Outline = true
_0xCF9A.label.OutlineColor = Color3.new(0,0,0)
_0xCF9A.label.Color = _0x2606
_0xCF9A.label.Text ="[GUN]"_0xCF9A.label.Visible = false
_0xCF9A.dist = Drawing.new("Text")
_0xCF9A.dist.Font = _0x4511.font
_0xCF9A.dist.Size = _0x4511.fontSize - 3
_0xCF9A.dist.Center = true
_0xCF9A.dist.Outline = true
_0xCF9A.dist.OutlineColor = Color3.new(0,0,0)
_0xCF9A.dist.Color = _0x2606
_0xCF9A.dist.Visible = false
return _0xCF9A
end
local function _0xABE0(_0xBA3E)
if not _0xBA3E then return end
pcall(function() _0xBA3E.box:Remove() end)
pcall(function() _0xBA3E.label:Remove() end)
pcall(function() _0xBA3E.dist:Remove() end)
end
local function _0xB2ED(_0xBA3E)
if not _0xBA3E then return end
if _0xBA3E.box then _0xBA3E.box.Visible = false end
if _0xBA3E.label then _0xBA3E.label.Visible = false end
if _0xBA3E.dist then _0xBA3E.dist.Visible = false end
end
local function _0xDD8B(obj)
return obj and obj:IsA("BasePart") and obj.Name =="GunDrop"end
local function _0x36B8(gun)
if not _0xDD8B(gun) then return end
_0x29F7[gun] = true
if _0x4511.autoTakeGun then task.defer(_0x112A, gun) end
end
local function _0x2315()
table.clear(_0x29F7)
for _, child in ipairs(workspace:GetChildren()) do
if _0xDD8B(child) then _0x36B8(child) end
if child:IsA("Model") or child:IsA("Folder") then
local _0xC770 = child:FindFirstChild("GunDrop")
if _0xDD8B(_0xC770) then _0x36B8(_0xC770) end
for _, sub in ipairs(child:GetChildren()) do
if _0xDD8B(sub) then _0x36B8(sub)
elseif sub:IsA("Model") or sub:IsA("Folder") then
local _0x7DE7 = sub:FindFirstChild("GunDrop")
if _0xDD8B(_0x7DE7) then _0x36B8(_0x7DE7) end
end
end
end
end
end
local _0xDA11 = {}
local function _0xDD39(_0xD2ED)
if not _0xD2ED or _0xDA11[_0xD2ED] then return end
_0xDA11[_0xD2ED] = true
_0xD2ED.ChildAdded:Connect(function(child)
task.defer(function()
if _0xDD8B(child) then _0x36B8(child)
elseif child:IsA("Model") or child:IsA("Folder") then
_0xDD39(child)
local _0xC770 = child:FindFirstChild("GunDrop")
if _0xDD8B(_0xC770) then _0x36B8(_0xC770) end
end
end)
end)
_0xD2ED.ChildRemoved:Connect(function(child)
if _0xDD8B(child) then
_0x29F7[child] = nil
_0xC98A[child] = nil
if _0x8B71[child] then _0xABE0(_0x8B71[child]) _0x8B71[child] = nil end
end
end)
end
_0xDD39(workspace)
for _, child in ipairs(workspace:GetChildren()) do
if child:IsA("Model") or child:IsA("Folder") then _0xDD39(child) end
end
workspace.ChildAdded:Connect(function(child)
if child:IsA("Model") or child:IsA("Folder") then
_0xDD39(child)
task.defer(_0x2315)
elseif _0xDD8B(child) then _0x36B8(child) end
end)
task.defer(_0x2315)
local function _0xFC57()
if not _0x4511.Enabled or not _0x4511.showGunESP then
for _, _0xBA3E in pairs(_0x8B71) do _0xB2ED(_0xBA3E) end
return
end
if tick() - _0x6C12 >= _0x7B25 then
_0x6C12 = tick()
_0x2315()
end
_0x3F26 = workspace.CurrentCamera
if not _0x3F26 then return end
local _0x6700 = _0x3F26.CFrame.Position
local _0xF354 = {}
for gun in pairs(_0x29F7) do
if not gun.Parent then _0x29F7[gun] = nil continue end
_0xF354[gun] = true
local _0xB53A = gun.Position
local _0xDB44 = (_0xB53A - _0x6700).Magnitude
if _0xDB44 > _0x4511.gunMaxDistance then
if _0x8B71[gun] then _0xB2ED(_0x8B71[gun]) end
continue
end
local _0x135F = _0x9A52(_0xB53A)
if not _0x135F then
if _0x8B71[gun] then _0xB2ED(_0x8B71[gun]) end
continue
end
local _0xBA3E = _0x8B71[gun]
if not _0xBA3E then _0xBA3E = _0xA19C() _0x8B71[gun] = _0xBA3E end
local _0xABF1 = 28
_0xBA3E.box.Position = Vector2.new(_0x135F.X - _0xABF1/2, _0x135F.Y - _0xABF1/2)
_0xBA3E.box.Size = Vector2.new(_0xABF1, _0xABF1)
_0xBA3E.box.Visible = true
_0xBA3E.label.Text ="[GUN]"_0xBA3E.label.Position = Vector2.new(_0x135F.X, _0x135F.Y - 22)
_0xBA3E.label.Visible = true
_0xBA3E.dist.Text = math.floor(_0xDB44) .."m"_0xBA3E.dist.Position = Vector2.new(_0x135F.X, _0x135F.Y + 18)
_0xBA3E.dist.Visible = true
end
for gun, _0xBA3E in pairs(_0x8B71) do
if not _0xF354[gun] then _0xABE0(_0xBA3E) _0x8B71[gun] = nil end
end
endlocal function _0x3FDA(obj)
return obj and obj:IsA("BasePart") and obj.Name =="Coin_Server"end
local function _0xF15D()
for _, child in ipairs(workspace:GetChildren()) do
if child.Name =="CoinContainer"then return child end
if child:IsA("Model") or child:IsA("Folder") then
local _0x41DB = child:FindFirstChild("CoinContainer")
if _0x41DB then return _0x41DB end
for _, sub in ipairs(child:GetChildren()) do
if sub:IsA("Model") or sub:IsA("Folder") then
local _0x985C = sub:FindFirstChild("CoinContainer")
if _0x985C then return _0x985C end
end
end
end
end
return nil
end
local function _0x201A(_0xE49C, targetPos, speed, timeout)
local _0x9F41 = tick()
timeout = timeout or 15
while tick() - _0x9F41 < timeout do
if not _0x4511.autoFarmCoins then return false end
if not _0xE49C or not _0xE49C.Parent then return false end
local _0x0F67 = targetPos - _0xE49C.Position
local _0xDB44 = _0x0F67.Magnitude
if _0xDB44 < 5 then
if _0xBC9B and _0xBC9B.Parent then _0xBC9B.Velocity = Vector3.zero end
return true
end
local _0xC4D9 = _0x0F67.Unitlocal _0x1C74 = speed
if _0xDB44 < 20 then
_0x1C74 = math.max(12, speed * 0.45)
end
if _0xBC9B and _0xBC9B.Parent then
_0xBC9B.Velocity = _0xC4D9 * _0x1C74
else
_0xE49C.AssemblyLinearVelocity = _0xC4D9 * _0x1C74
end
local _0xE16D = Vector3.new(_0xC4D9.X, 0, _0xC4D9.Z)
if _0xE16D.Magnitude > 0.05 then
_0xE49C.CFrame = CFrame.lookAt(_0xE49C.Position, _0xE49C.Position + _0xE16D)
end
task.wait(0.05)
end
return false
end
local function _0x0318()
if _0x56BC or not _0x4511.autoFarmCoins then return end
local _0xDB3B = _0xB745.Character
local _0xE49C = _0xDB3B and _0xDB3B:FindFirstChild("HumanoidRootPart")
local _0x4B9E = _0xDB3B and _0xDB3B:FindFirstChildOfClass("Humanoid")
if not _0xE49C or not _0x4B9E or _0x4B9E.Health <= 0 then return end
local _0xD2ED = _0xF15D()
if not _0xD2ED then return end
local _0x7249 = {}
for _, obj in ipairs(_0xD2ED:GetDescendants()) do
if _0x3FDA(obj) then table.insert(_0x7249, obj) end
end
if #_0x7249 == 0 then return end
table.sort(_0x7249, function(_0x89CB, _0x9AB0)
return (_0x89CB.Position - _0xE49C.Position).Magnitude < (_0x9AB0.Position - _0xE49C.Position).Magnitude
end)local _0xA343 = math.min(#_0x7249, 4)
local _0xEB9B = {}
for i = 1, _0xA343 do
_0xEB9B[i] = _0x7249[i]
end
_0x56BC = true
local _0xB913 = _0x4511.FlyEnabled
if not _0xB913 then
_0x4511.FlyEnabled = true
_0xB242()
end
local _0xF44B = _0x4511.NoclipEnabled
if not _0xF44B then
_0x4511.NoclipEnabled = true
_0xD3B0(true)
end
local _0x8097 = _0x4511.coinFarmSpeed or 28
for _, coin in ipairs(_0xEB9B) do
if not _0x4511.autoFarmCoins then break end
if not coin.Parent then continue end
_0xDB3B = _0xB745.Character
_0xE49C = _0xDB3B and _0xDB3B:FindFirstChild("HumanoidRootPart")
_0x4B9E = _0xDB3B and _0xDB3B:FindFirstChildOfClass("Humanoid")
if not _0xE49C or not _0x4B9E or _0x4B9E.Health <= 0 then break end
_0x201A(_0xE49C, coin.Position + Vector3.new(0, 2, 0), _0x8097, 18)task.wait(_0x4511.coinFarmDelay or 0.45)if _0xBC9B and _0xBC9B.Parent then _0xBC9B.Velocity = Vector3.new(0, 0.3, 0) end
task.wait(_0x4511.coinFarmPause or 0.8)
end
if _0xBC9B and _0xBC9B.Parent then _0xBC9B.Velocity = Vector3.zero end
if not _0xB913 then
_0x4511.FlyEnabled = false
_0x5E1D()
end
if not _0xF44B then
_0x4511.NoclipEnabled = false
_0xD3B0(false)
end
_0x56BC = false
end
task.spawn(function()
while true dotask.wait(2.5)
if _0x4511.autoFarmCoins and not _0x56BC then
pcall(_0x0318)
end
end
end)local function _0x7BB5()
if not _0x4511.Enabled then
for _, _0xBA3E in pairs(_0x830D) do _0x2856(_0xBA3E) end
return
end
_0x3F26 = workspace.CurrentCamera
if not _0x3F26 then return end
if tick() - _0xB04B > _0x4511.rolePollRate then
_0xB04B = tick()
_0x540C()
end
local _0x6700 = _0x3F26.CFrame.Position
local _0xAAD8 = {}
for _, player in ipairs(_0x79A1:GetPlayers()) do
_0xAAD8[player] = true
if _0x4511.skipLocal and player == _0xB745 then continue end
local _0xDB3B = player.Character
local _0x4B9E = _0xDB3B and _0xDB3B:FindFirstChildOfClass("Humanoid")
if not _0xDB3B or not _0x4B9E or _0x4B9E.Health <= 0 then
if _0x830D[player] then _0xBA6A(_0x830D[player]) _0x830D[player] = nil end
continue
end
local _0xE49C = _0xDB3B:FindFirstChild("HumanoidRootPart") or _0xDB3B:FindFirstChild("Torso") or _0xDB3B:FindFirstChild("UpperTorso")
if not _0xE49C then continue end
local _0xDB44 = (_0xE49C.Position - _0x6700).Magnitude
if _0xDB44 > _0x4511.maxDistance then
if _0x830D[player] then _0x2856(_0x830D[player]) end
continue
end
local _0x5CCB = _0xCE98(player)
if _0x5CCB =="Innocent"or _0x5CCB =="Unknown"then
if _0xFF27(player,"Knife") then _0x5CCB ="Murderer"_0xC069[player] = _0x5CCB
elseif _0xFF27(player,"Gun") then _0x5CCB ="Sheriff"_0xC069[player] = _0x5CCB end
end
local _0xF5CB = _0xDA36(_0x5CCB)
local _0xBA3E = _0x830D[player]
if not _0xBA3E then _0xBA3E = _0x90E8() _0x830D[player] = _0xBA3E end
if _0x4511.showHighlight then
_0xBA3E.highlight.Adornee = _0xDB3B
_0xBA3E.highlight.FillColor = _0xF5CB
_0xBA3E.highlight.OutlineColor = _0xF5CB
_0xBA3E.highlight.Enabled = true
else _0xBA3E.highlight.Enabled = false end
local _0xE71D, _0xF654 = _0x1C40(_0xDB3B)
if not _0xE71D then
if _0xBA3E.box then _0xBA3E.box.Visible = false end
if _0xBA3E.nameTag then _0xBA3E.nameTag.Visible = false end
if _0xBA3E.roleTag then _0xBA3E.roleTag.Visible = false end
if _0xBA3E.distTag then _0xBA3E.distTag.Visible = false end
if _0xBA3E.skeleton then for _, _0x2E6F in ipairs(_0xBA3E.skeleton) do _0x2E6F.Visible = false end end
if _0xBA3E.body3d then for _, _0x2E6F in ipairs(_0xBA3E.body3d) do _0x2E6F.Visible = false end end
continue
end
_0xBA3E.box.Position = _0xE71D
_0xBA3E.box.Size = _0xF654
_0xBA3E.box.Color = _0xF5CB
_0xBA3E.box.Visible = _0x4511.showBox
local _0x2CCC = _0xDB3B:FindFirstChild("Head")
local _0xB661 = _0x2CCC and _0x9A52(_0x2CCC.Position + Vector3.new(0, 0.6, 0))
or Vector2.new(_0xE71D.X + _0xF654.X/2, _0xE71D.Y - 8)
if _0x4511.showLabel then
_0xBA3E.nameTag.Text = player.Name
_0xBA3E.nameTag.Color = _0xF5CB
_0xBA3E.nameTag.Position = _0xB661
_0xBA3E.nameTag.Size = _0x4511.fontSize
_0xBA3E.nameTag.Visible = true
else _0xBA3E.nameTag.Visible = false end
if _0x4511.showRole then
_0xBA3E.roleTag.Text ="[".. _0x5CCB .."]"_0xBA3E.roleTag.Color = _0xF5CB
_0xBA3E.roleTag.Position = _0xB661 + Vector2.new(0, _0x4511.fontSize + 2)
_0xBA3E.roleTag.Size = _0x4511.fontSize - 2
_0xBA3E.roleTag.Visible = true
else _0xBA3E.roleTag.Visible = false end
if _0x4511.showDistance then
_0xBA3E.distTag.Text = math.floor(_0xDB44) .."m"_0xBA3E.distTag.Color = _0xF5CB
_0xBA3E.distTag.Position = _0xB661 - Vector2.new(0, _0x4511.fontSize + 4)
_0xBA3E.distTag.Size = _0x4511.fontSize - 4
_0xBA3E.distTag.Visible = true
else _0xBA3E.distTag.Visible = false end
if _0x4511.showSkeleton then
local _0x8931 = (_0xDB3B:FindFirstChild("Torso") and not _0xDB3B:FindFirstChild("UpperTorso")) and _0x2802 or _0x4D74
local _0x5C3C = 1
for _, pair in ipairs(_0x8931) do
local _0x83EB, _0x41BA = _0xDB3B:FindFirstChild(pair[1]), _0xDB3B:FindFirstChild(pair[2])
local _0x2E6F = _0xBA3E.skeleton[_0x5C3C]
if _0x83EB and _0x41BA and _0x2E6F then
local _0x2327, _0xCBF2 = _0x9A52(_0x83EB.Position), _0x9A52(_0x41BA.Position)
if _0x2327 and _0xCBF2 then _0x2E6F.From = _0x2327 _0x2E6F.To = _0xCBF2 _0x2E6F.Color = _0xF5CB _0x2E6F.Visible = true
else _0x2E6F.Visible = false end
elseif _0x2E6F then _0x2E6F.Visible = false end
_0x5C3C += 1
end
for i = _0x5C3C, #_0xBA3E.skeleton do _0xBA3E.skeleton[i].Visible = false end
else
for _, _0x2E6F in ipairs(_0xBA3E.skeleton) do _0x2E6F.Visible = false end
end
_0xEE0E(_0xBA3E, _0xDB3B, _0xF5CB)
end
for player, _0xBA3E in pairs(_0x830D) do
if not _0xAAD8[player] then
_0xBA6A(_0xBA3E)
_0x830D[player] = nil
_0xC069[player] = nil
end
end
end
_0x79A1.PlayerRemoving:Connect(function(player)
_0xBA6A(_0x830D[player])
_0x830D[player] = nil
_0xC069[player] = nil
end)
pcall(function()
local _0x4F06 = _0xFAA5:WaitForChild("Remotes", 5)
if _0x4F06 then
local _0xDFEC = _0x4F06:FindFirstChild("Gameplay")
if _0xDFEC then
local _0x3FCC = _0xDFEC:FindFirstChild("RoundEndFade") or _0xDFEC:FindFirstChild("VictoryScreen")
if _0x3FCC then
_0x3FCC.OnClientEvent:Connect(function()
table.clear(_0xC069)
table.clear(_0xC98A)
end)
end
end
end
end)
pcall(function()
local _0x0731 = _0xFAA5:FindFirstChild("UpdatePlayerData")
if _0x0731 then
_0x0731.OnClientEvent:Connect(function(_0x2958)
if type(_0x2958) ~="table"then return end
for _0x10B3, info in pairs(_0x2958) do
local _0x788A = _0x79A1:FindFirstChild(_0x10B3)
if _0x788A and type(info) =="table"and info.Role then _0xC069[_0x788A] = info.Role end
end
end)
end
end)
pcall(function()
local _0x4287 = _0xFAA5:FindFirstChild("Fade")
if _0x4287 then
_0x4287.OnClientEvent:Connect(function(_0x2958)
if type(_0x2958) ~="table"then return end
for _0x10B3, info in pairs(_0x2958) do
local _0x788A = _0x79A1:FindFirstChild(_0x10B3)
if _0x788A and type(info) =="table"and info.Role then _0xC069[_0x788A] = info.Role end
end
end)
end
end)
task.spawn(function()
task.wait(1)
_0x540C()
end)
_0xFF34.RenderStepped:Connect(function()
_0x7BB5()
_0xFC57()
_0x093B()
end)local _0xC758 = {
_0xBC2A = Color3.fromRGB(161, 125, 170),
_0x766D = Color3.fromRGB(89, 89, 89),
trackOn = Color3.fromRGB(161, 125, 170),
white = Color3.new(1, 1, 1),
gray = Color3.fromRGB(192, 192, 192),
black = Color3.new(0, 0, 0),
borderA = Color3.fromRGB(179, 155, 186),
borderB = Color3.fromRGB(157, 155, 157),
_0xCC27 = Color3.fromRGB(135, 80, 155),
tabActive = Color3.fromRGB(161, 125, 170),
}
local _0xC4E4 = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, Color3.fromRGB(150, 110, 160)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(165, 132, 173)),
ColorSequenceKeypoint.new(0.50, Color3.fromRGB(205, 188, 209)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(221, 210, 223)),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(237, 232, 238)),
})
local _0xF2B0 = Font.fromEnum(Enum.Font.FredokaOne)
local _0xD326 = Font.fromEnum(Enum.Font.LuckiestGuy)
local _0x0852 = Enum.KeyCode.RightShift
local _0xA47C, _0x79CB = {}, {}
local _0x18DC = {
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
}
local function _0x4541(_0x10B3)
if typeof(_0x10B3) ~="string"then return nil end
local _0x0498, _0xCF9A = pcall(function() return Enum.KeyCode[_0x10B3] end)
return (_0x0498 and _0xCF9A) or nil
end
local function _0xA535(_0x89CB) return math.floor(10 + _0x89CB * 190 + 0.5) end
local function _0x890C(_0x89CB) return math.floor(16 + _0x89CB * 184 + 0.5) end
local function _0xB4D9(_0x10B3, value)
if _0x10B3 =="esp"then
_0x4511.Enabled = value
if not value then
_0x81E3()
for g, _0xCF9A in pairs(_0x8B71) do _0xABE0(_0xCF9A) _0x8B71[g] = nil end
end
elseif _0x10B3 =="boxEsp"then _0x4511.showBox = value
elseif _0x10B3 =="skeletonEsp"then _0x4511.showSkeleton = value
elseif _0x10B3 =="highlightEsp"then _0x4511.showHighlight = value
elseif _0x10B3 =="labelEsp"then _0x4511.showLabel = value
elseif _0x10B3 =="roleEsp"then _0x4511.showRole = value
elseif _0x10B3 =="distanceEsp"then _0x4511.showDistance = value
elseif _0x10B3 =="body3dEsp"then _0x4511.show3DBody = value
elseif _0x10B3 =="gunEsp"then
_0x4511.showGunESP = value
if not value then
for g, _0xCF9A in pairs(_0x8B71) do _0xABE0(_0xCF9A) _0x8B71[g] = nil end
end
elseif _0x10B3 =="autoTakeGun"then _0x4511.autoTakeGun = value
elseif _0x10B3 =="autoFarmCoins"then _0x4511.autoFarmCoins = value
elseif _0x10B3 =="maxDistance"then _0x4511.maxDistance = math.floor(200 + value * 2800 + 0.5)
elseif _0x10B3 =="fly"then
_0x4511.FlyEnabled = value
if value then _0xB242() else _0x5E1D() end
elseif _0x10B3 =="speed"then
_0x4511.SpeedEnabled = value
_0x3C57()
elseif _0x10B3 =="noclip"then
_0x4511.NoclipEnabled = value
_0xD3B0(value)
elseif _0x10B3 =="walkFling"then
_0x4511.WalkFlingEnabled = value
if value then _0x6A63() else _0xDB76() end
elseif _0x10B3 =="flySpeed"then _0x4511.FlySpeed = _0xA535(value)
elseif _0x10B3 =="walkSpeed"then
_0x4511.WalkSpeed = _0x890C(value)
if _0x4511.SpeedEnabled then _0x3C57() end
elseif _0x10B3 =="esp_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.ESPKey = _0xCF9A end
elseif _0x10B3 =="box_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.BoxKey = _0xCF9A end
elseif _0x10B3 =="skeleton_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.SkeletonKey = _0xCF9A end
elseif _0x10B3 =="highlight_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.HighlightKey = _0xCF9A end
elseif _0x10B3 =="label_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.LabelKey = _0xCF9A end
elseif _0x10B3 =="role_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.RoleKey = _0xCF9A end
elseif _0x10B3 =="distance_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.DistKey = _0xCF9A end
elseif _0x10B3 =="body3d_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.Body3DKey = _0xCF9A end
elseif _0x10B3 =="gun_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.GunKey = _0xCF9A end
elseif _0x10B3 =="autoTake_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.AutoTakeKey = _0xCF9A end
elseif _0x10B3 =="fly_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.FlyKey = _0xCF9A end
elseif _0x10B3 =="speed_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.SpeedKey = _0xCF9A end
elseif _0x10B3 =="noclip_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.NoclipKey = _0xCF9A end
elseif _0x10B3 =="coinFarm_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.CoinFarmKey = _0xCF9A end
elseif _0x10B3 =="walkFling_key"then local _0xCF9A = _0x4541(value) if _0xCF9A then _0x18DC.WalkFlingKey = _0xCF9A end
end
end
local function _0xCB3B(_0x5319, r)
local _0x4C20 = Instance.new("UICorner")
_0x4C20.CornerRadius = UDim.new(0, r)
_0x4C20.Parent = _0x5319
return _0x4C20
end
local function _0x2FFD(_0x5319, t, _0xF5CB, tr)
local _0x9CD6 = Instance.new("UIStroke")
_0x9CD6.Thickness = t
_0x9CD6.Color = _0xF5CB
_0x9CD6.Transparency = tr or 0
_0x9CD6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0x9CD6.Parent = _0x5319
return _0x9CD6
end
local function _0x2393(parent, _0x124B, _0x1653, _0x2838, _0xEE5D, color, transp, radius)
local _0x43A8 = Instance.new("Frame")
_0x43A8.Position = UDim2.fromOffset(_0x124B, _0x1653)
_0x43A8.Size = UDim2.fromOffset(_0x2838, _0xEE5D)
_0x43A8.BackgroundColor3 = color
_0x43A8.BackgroundTransparency = transp or 0
_0x43A8.BorderSizePixel = 0
_0x43A8.Parent = parent
if radius then _0xCB3B(_0x43A8, radius) end
return _0x43A8
end
local function _0xFA5B(parent, str, font, _0xABF1, _0x124B, _0x1653, _0x2838, _0xEE5D, color)
local _0xC15C = Instance.new("TextLabel")
_0xC15C.BackgroundTransparency = 1
_0xC15C.Text = str
_0xC15C.FontFace = font
_0xC15C.TextSize = _0xABF1
_0xC15C.TextColor3 = color or _0xC758.white
_0xC15C.Position = UDim2.fromOffset(_0x124B, _0x1653)
_0xC15C.Size = UDim2.fromOffset(_0x2838, _0xEE5D)
_0xC15C.TextXAlignment = Enum.TextXAlignment.Left
_0xC15C.TextYAlignment = Enum.TextYAlignment.Center
_0xC15C.Parent = parent
local _0x9CD6 = Instance.new("UIStroke")
_0x9CD6.Thickness = 1.5
_0x9CD6.Color = _0xC758.black
_0x9CD6.Transparency = 0.35
_0x9CD6.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
_0x9CD6.Parent = _0xC15C
return _0xC15C
end
local _0x682E = Instance.new("ScreenGui")
_0x682E.Name ="DihMM2Menu"_0x682E.ResetOnSpawn = false
_0x682E.IgnoreGuiInset = true
_0x682E.Parent = _0xADC5
local _0x7807 = Instance.new("Frame")
_0x7807.Size = UDim2.fromOffset(448, 593)
_0x7807.Position = UDim2.new(0.5, -224, 0.5, -296)
_0x7807.BackgroundTransparency = 1
_0x7807.ZIndex = 0
_0x7807.Parent = _0x682E
for i = 1, 8 do
local _0xD002 = (i - 1) * 2
local _0x3666 = _0x2393(_0x7807, -_0xD002, 4 - _0xD002, 448 + _0xD002 * 2, 593 + _0xD002 * 2, _0xC758.black, 1, 26 + _0xD002)
_0x2FFD(_0x3666, 2, _0xC758.black, 0.8 + i * 0.022)
end
local _0xAE05 = Instance.new("Frame")
_0xAE05.Size = UDim2.fromOffset(448, 593)
_0xAE05.Position = UDim2.new(0.5, -224, 0.5, -296)
_0xAE05.BackgroundColor3 = _0xC758.white
_0xAE05.BackgroundTransparency = 0.15
_0xAE05.BorderSizePixel = 0
_0xAE05.ZIndex = 1
_0xAE05.Parent = _0x682E
_0xCB3B(_0xAE05, 26)
local _0x34AE = Instance.new("UIGradient")
_0x34AE.Rotation = 90
_0x34AE.Color = _0xC4E4
_0x34AE.Parent = _0xAE05
_0xAE05:GetPropertyChangedSignal("Position"):Connect(function()
_0x7807.Position = _0xAE05.Position
end)
local _0x0191 = _0x2FFD(_0xAE05, 6, _0xC758.white, 0.08)
local _0x8486 = Instance.new("UIGradient")
_0x8486.Rotation = 90
_0x8486.Color = ColorSequence.new(_0xC758.borderA, _0xC758.borderB)
_0x8486.Parent = _0x0191
local _0xBC2A = _0x2393(_0xAE05, 13, 7, 428, 51, _0xC758.titleBar, 0, 20)
_0xFA5B(_0xBC2A,"DIH SCRIPT", _0xD326, 31, 14, 0, 250, 51)
local _0xDAD4 = _0x2393(_0xAE05, 387, 14, 42, 36, _0xC758.white, 0, 8)
local _0xD3CE = Instance.new("UIGradient")
_0xD3CE.Rotation = 90
_0xD3CE.Color = ColorSequence.new(Color3.fromRGB(255, 22, 22), Color3.fromRGB(245, 162, 162))
_0xD3CE.Parent = _0xDAD4
_0x2FFD(_0xDAD4, 2, _0xC758.black, 0)
local _0x4F87 = Instance.new("TextButton")
_0x4F87.Position = UDim2.fromOffset(387, 14)
_0x4F87.Size = UDim2.fromOffset(42, 36)
_0x4F87.BackgroundTransparency = 1
_0x4F87.AutoButtonColor = false
_0x4F87.Text ="X"_0x4F87.FontFace = _0xD326
_0x4F87.TextSize = 27
_0x4F87.TextColor3 = _0xC758.white
_0x4F87.Parent = _0xAE05
local _0xD0A9 = Instance.new("UIStroke")
_0xD0A9.Thickness = 2
_0xD0A9.Color = _0xC758.black
_0xD0A9.Transparency = 0
_0xD0A9.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
_0xD0A9.Parent = _0x4F87
Instance.new("UIPadding", _0x4F87).PaddingTop = UDim.new(0, 6)
_0x4F87.MouseButton1Click:Connect(function() _0x682E.Enabled = false end)
local _0xA9FD, _0x9A15 = {}, {}
local _0xD904 ="VISUALS"local _0x1E07 = 125
local _0xFB17 = Instance.new("Frame")
_0xFB17.Position = UDim2.fromOffset(0, _0x1E07)
_0xFB17.Size = UDim2.fromOffset(448, 458)
_0xFB17.BackgroundTransparency = 1
_0xFB17.ClipsDescendants = true
_0xFB17.Parent = _0xAE05
local _0xF09E = {
{"VISUALS", 13, 81, 100, 38, 15, 98, 35, 2.0 },
{"MOVEMENT", 120, 81, 105, 38, 14, 100, 35, -1.5 },
{"SETTINGS", 235, 81, 93, 38, 14, 88, 35, 1.2 },
}
local _0xD868
local function _0xACD0(_0x10B3)
for tabName, _0x67C3 in pairs(_0x9A15) do
local _0x7357 = (tabName == _0x10B3)
_0x8979:Create(_0x67C3, TweenInfo.new(0.18), {
BackgroundColor3 = _0x7357 and _0xC758.tabActive or _0xC758.white,
BackgroundTransparency = _0x7357 and 0.15 or 0.4,
}):Play()
end
_0xD904 = _0x10B3
end
local function _0xCF8E(n)
for k, _0x5319 in pairs(_0xA9FD) do _0x5319.Visible = (k == n) end
_0xACD0(n)
if _0xD868 then _0xD868(0, true) end
end
for _, _0xBCAA in ipairs(_0xF09E) do
local _0x10B3, _0x124B, _0x1653, _0x2838, _0xEE5D, _0x8197, _0x44CF, _0x085B, _0x8B17 = table.unpack(_0xBCAA)
local _0x67C3 = Instance.new("Frame")
_0x67C3.AnchorPoint = Vector2.new(0.5, 0.5)
_0x67C3.Position = UDim2.fromOffset(_0x124B + _0x2838/2, _0x1653 + _0xEE5D/2)
_0x67C3.Size = UDim2.fromOffset(_0x44CF, _0x085B)
_0x67C3.Rotation = _0x8B17
_0x67C3.BackgroundColor3 = _0xC758.white
_0x67C3.BackgroundTransparency = 0.4
_0x67C3.BorderSizePixel = 0
_0x67C3.Parent = _0xAE05
_0xCB3B(_0x67C3, math.floor(_0x085B/2))
local _0x0884 = Instance.new("UIGradient")
_0x0884.Rotation = 90
_0x0884.Color = ColorSequence.new(Color3.fromRGB(65,65,65), Color3.fromRGB(128,128,128))
_0x0884.Parent = _0x67C3
_0x2FFD(_0x67C3, 1.5, _0xC758.black, 0.4)
_0x9A15[_0x10B3] = _0x67C3
local _0x9AB0 = Instance.new("TextButton")
_0x9AB0.Position = UDim2.fromOffset(_0x124B, _0x1653)
_0x9AB0.Size = UDim2.fromOffset(_0x2838, _0xEE5D)
_0x9AB0.BackgroundTransparency = 1
_0x9AB0.Text = _0x10B3
_0x9AB0.FontFace = _0xF2B0
_0x9AB0.TextSize = _0x8197
_0x9AB0.TextColor3 = _0xC758.white
_0x9AB0.Parent = _0xAE05
_0x9AB0.MouseButton1Click:Connect(function()
local _0xCF58 = _0x67C3.Size
_0x8979:Create(_0x67C3, TweenInfo.new(0.07), {
Size = UDim2.fromOffset(_0xCF58.X.Offset * 0.92, _0xCF58.Y.Offset * 0.92),
}):Play()
task.delay(0.07, function()
_0x8979:Create(_0x67C3, TweenInfo.new(0.14, Enum.EasingStyle.Back), { Size = _0xCF58 }):Play()
end)
_0xCF8E(_0x10B3)
end)
local _0x6F58 = Instance.new("Frame")
_0x6F58.Size = UDim2.fromOffset(448, 1000)
_0x6F58.BackgroundTransparency = 1
_0x6F58.Position = UDim2.fromOffset(0, -_0x1E07)
_0x6F58.Visible = false
_0x6F58.Parent = _0xFB17
_0xA9FD[_0x10B3] = _0x6F58
end
local _0xBF2B, _0xB6C6, _0x2C8A = 132, 450, 240
local _0xA238 = 450
local _0xD067, _0xF6D9, _0x3C07 = 0, 0, 0
local _0x766D = _0x2393(_0xAE05, 433, _0xBF2B, 8, _0xB6C6, _0xC758.white, 1, 4)
local _0x2B38 = _0x2393(_0xAE05, 433, _0xBF2B, 8, _0x2C8A, _0xC758.white, 0.5, 4)
local function _0xF673(_0x89CB)
_0x2B38.Position = UDim2.fromOffset(433, _0xBF2B + _0x89CB * (_0xB6C6 - _0x2C8A))
for _, _0x0884 in pairs(_0xA9FD) do
_0x0884.Position = UDim2.fromOffset(0, -_0x1E07 - _0x89CB * _0xA238)
end
end
function _0xD868(_0x89CB, snap)
_0xD067 = math.clamp(_0x89CB, 0, 1)
_0xF6D9 = _0xD067
if snap then _0x3C07 = _0xF6D9 _0xF673(_0x3C07) end
end
_0xFF34.RenderStepped:Connect(function(dt)
if math.abs(_0xF6D9 - _0x3C07) < 0.0005 then
if _0x3C07 ~= _0xF6D9 then _0x3C07 = _0xF6D9 _0xF673(_0x3C07) end
return
end
_0x3C07 += (_0xF6D9 - _0x3C07) * (1 - math.exp(-dt * 14))
_0xF673(_0x3C07)
end)
local function _0xF3C9(i)
return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function _0xDADD()
if not _0x682E.Enabled then return false end
local _0x2722 = _0xE91C:GetMouseLocation()
local _0x5319, _0x93B6 = _0xAE05.AbsolutePosition, _0xAE05.AbsoluteSize
return _0x2722.X >= _0x5319.X and _0x2722.X <= _0x5319.X + _0x93B6.X and _0x2722.Y >= _0x5319.Y and _0x2722.Y <= _0x5319.Y + _0x93B6.Y
end
_0xE91C.InputChanged:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseWheel and _0xDADD() then
_0xD868(_0xD067 - i.Position.Z * 25 / _0xA238)
end
end)
_0xB57B:BindActionAtPriority("DihMM2Wheel", function()
return _0xDADD() and Enum.ContextActionResult.Sink or Enum.ContextActionResult.Pass
end, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseWheel)
local function _0xA3CF(_0x6F58, key, _0x124B, _0x1653, _0x2838, defaultOn)
_0xA47C[key] = defaultOn == true
local _0x0975 = Instance.new("TextButton")
_0x0975.Position = UDim2.fromOffset(_0x124B, _0x1653)
_0x0975.Size = UDim2.fromOffset(_0x2838, 36)
_0x0975.BackgroundColor3 = _0xA47C[key] and _0xC758.trackOn or _0xC758.track
_0x0975.Text =""_0x0975.AutoButtonColor = false
_0x0975.Parent = _0x6F58
_0xCB3B(_0x0975, 18)
local _0x1280 = _0x2393(_0x0975, _0xA47C[key] and (_0x2838 - 36) or 0, 0, 36, 36, _0xC758.white, 0, 18)
local function _0x18BB(state, fire)
_0xA47C[key] = state
_0x1280:TweenPosition(UDim2.fromOffset(state and (_0x2838 - 36) or 0, 0),"Out","Quad", 0.12, true)
_0x0975.BackgroundColor3 = state and _0xC758.trackOn or _0xC758.track
if fire then _0xB4D9(key, state) end
end
_0x0975.MouseButton1Click:Connect(function() _0x18BB(not _0xA47C[key], true) end)
_0x79CB[key] = {
set = function(state) _0x18BB(state, true) end,
_0xA3CF = function() _0x18BB(not _0xA47C[key], true) end,
}
if defaultOn then _0xB4D9(key, true) end
end
local function _0x3F0F(_0x6F58, key, _0x124B, _0x1653, defaultKey)
_0xA47C[key] = defaultKey
local _0x9AB0 = Instance.new("TextButton")
_0x9AB0.Position = UDim2.fromOffset(_0x124B, _0x1653)
_0x9AB0.Size = UDim2.fromOffset(76, 36)
_0x9AB0.BackgroundColor3 = _0xC758.black
_0x9AB0.BackgroundTransparency = 0.8
_0x9AB0.AutoButtonColor = false
_0x9AB0.Text = defaultKey
_0x9AB0.FontFace = _0xF2B0
_0x9AB0.TextSize = 28
_0x9AB0.TextColor3 = _0xC758.white
_0x9AB0.Parent = _0x6F58
_0xCB3B(_0x9AB0, 5)
local _0x9CD6 = Instance.new("UIStroke")
_0x9CD6.Thickness = 1.5
_0x9CD6.Transparency = 0.35
_0x9CD6.Color = _0xC758.black
_0x9CD6.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
_0x9CD6.Parent = _0x9AB0
_0xB4D9(key, defaultKey)
_0x9AB0.MouseButton1Click:Connect(function()
_0x9AB0.Text ="..."local _0x1FD8
_0x1FD8 = _0xE91C.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.Keyboard then
_0xA47C[key] = i.KeyCode.Name
_0x9AB0.Text = i.KeyCode.Name
_0xB4D9(key, i.KeyCode.Name)
_0x1FD8:Disconnect()
end
end)
end)
end
local function _0x8877(_0x6F58, key, _0x124B, _0x1653, defaultA)
_0xA47C[key] = defaultA
local _0xA11C = _0x2393(_0x6F58, _0x124B - 5, _0x1653 - 4, 391, 10, _0xC758.track, 0, 5)
local _0xCC27 = _0x2393(_0xA11C, 0, 0, 9, 10, _0xC758.fill, 0, 5)
local _0x1280 = _0x2393(_0xA11C, 0, 0, 27, 26, _0xC758.white, 0, 13)
_0x1280.AnchorPoint = Vector2.new(0.5, 0.5)
_0x1280.Position = UDim2.new(0, 9, 0.5, 0)
local _0x15B3 = false
local function _0x69A3(px)
local _0x89CB = math.clamp((px - _0xA11C.AbsolutePosition.X - 9) / math.max(_0xA11C.AbsoluteSize.X - 18, 1), 0, 1)
local _0xF763 = 9 + _0x89CB * (_0xA11C.AbsoluteSize.X - 18)
_0x1280.Position = UDim2.new(0, _0xF763, 0.5, 0)
_0xCC27.Size = UDim2.fromOffset(math.max(_0xF763, 9), 10)
_0xA47C[key] = _0x89CB
_0xB4D9(key, _0x89CB)
end
task.defer(function()
if _0xA11C.AbsoluteSize.X > 0 then
local _0xF763 = 9 + defaultA * (_0xA11C.AbsoluteSize.X - 18)
_0x1280.Position = UDim2.new(0, _0xF763, 0.5, 0)
_0xCC27.Size = UDim2.fromOffset(math.max(_0xF763, 9), 10)
end
_0xB4D9(key, defaultA)
end)
_0x1280.InputBegan:Connect(function(i) if _0xF3C9(i) then _0x15B3 = true end end)
_0xA11C.InputBegan:Connect(function(i) if _0xF3C9(i) then _0x15B3 = true _0x69A3(i.Position.X) end end)
_0xE91C.InputEnded:Connect(function(i) if _0xF3C9(i) then _0x15B3 = false end end)
_0xE91C.InputChanged:Connect(function(i)
if _0x15B3 and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
_0x69A3(i.Position.X)
end
end)
end
local function _0x1C27(_0x6F58, str, _0x124B, _0x1653, _0x2838, _0xABF1, color)
_0xFA5B(_0x6F58, str, _0xF2B0, _0xABF1, _0x124B, _0x1653, _0x2838, 30, color)
end
do
local _0x5319 = _0xA9FD["VISUALS"]
_0x1C27(_0x5319,"Toggle ESP", 21, 157, 200, 33)
_0x3F0F(_0x5319,"esp_key", 215, 153,"R")
_0xA3CF(_0x5319,"esp", 320, 153, 75, true)
_0x1C27(_0x5319,"Box ESP", 21, 210, 200, 33)
_0x3F0F(_0x5319,"box_key", 189, 206,"B")
_0xA3CF(_0x5319,"boxEsp", 291, 206, 75, true)
_0x1C27(_0x5319,"Skeleton ESP", 21, 263, 220, 33)
_0x3F0F(_0x5319,"skeleton_key", 239, 262,"K")
_0xA3CF(_0x5319,"skeletonEsp", 338, 259, 75, true)
_0x1C27(_0x5319,"Highlight ESP", 21, 316, 230, 33)
_0x3F0F(_0x5319,"highlight_key", 247, 312,"L")
_0xA3CF(_0x5319,"highlightEsp", 348, 312, 75, true)
_0x1C27(_0x5319,"Name Label", 21, 369, 200, 33)
_0x3F0F(_0x5319,"label_key", 200, 365,"N")
_0xA3CF(_0x5319,"labelEsp", 300, 365, 75, true)
_0x1C27(_0x5319,"Role Tag", 21, 422, 200, 33)
_0x3F0F(_0x5319,"role_key", 180, 418,"M")
_0xA3CF(_0x5319,"roleEsp", 280, 418, 75, true)
_0x1C27(_0x5319,"Distance", 21, 475, 200, 33)
_0x3F0F(_0x5319,"distance_key", 180, 471,"J")
_0xA3CF(_0x5319,"distanceEsp", 280, 471, 75, true)
_0x1C27(_0x5319,"3D Body ESP", 21, 528, 220, 33)
_0x3F0F(_0x5319,"body3d_key", 230, 524,"U")
_0xA3CF(_0x5319,"body3dEsp", 330, 524, 75, true)
_0x1C27(_0x5319,"Gun Drop ESP", 21, 581, 220, 33)
_0x3F0F(_0x5319,"gun_key", 230, 577,"P")
_0xA3CF(_0x5319,"gunEsp", 330, 577, 75, true)
_0x1C27(_0x5319,"Auto Take Gun", 21, 634, 250, 33)
_0x3F0F(_0x5319,"autoTake_key", 250, 630,"G")
_0xA3CF(_0x5319,"autoTakeGun", 340, 630, 75, false)
_0x1C27(_0x5319,"max distance", 21, 690, 250, 28, _0xC758.gray)
_0x8877(_0x5319,"maxDistance", 20, 735, math.clamp((_0x4511.maxDistance - 200) / 2800, 0, 1))
end
do
local _0x5319 = _0xA9FD["MOVEMENT"]
_0x1C27(_0x5319,"Fly", 21, 157, 160, 33)
_0x3F0F(_0x5319,"fly_key", 179, 153,"F")
_0xA3CF(_0x5319,"fly", 320, 153, 75, false)
_0x1C27(_0x5319,"Speed", 21, 217, 160, 33)
_0x3F0F(_0x5319,"speed_key", 179, 213,"V")
_0xA3CF(_0x5319,"speed", 320, 213, 75, false)
_0x1C27(_0x5319,"Noclip", 21, 277, 160, 33)
_0x3F0F(_0x5319,"noclip_key", 179, 273,"C")
_0xA3CF(_0x5319,"noclip", 320, 273, 75, false)
_0x1C27(_0x5319,"Walk Fling", 21, 337, 200, 33)
_0x3F0F(_0x5319,"walkFling_key", 200, 333,"Y")
_0xA3CF(_0x5319,"walkFling", 320, 333, 75, false)
_0x1C27(_0x5319,"Auto Farm Coins", 21, 397, 250, 33)
_0x3F0F(_0x5319,"coinFarm_key", 250, 393,"H")
_0xA3CF(_0x5319,"autoFarmCoins", 340, 393, 75, false)
_0x1C27(_0x5319,"Fly speed", 26, 458, 200, 28, _0xC758.gray)
_0x8877(_0x5319,"flySpeed", 23, 507, math.clamp((_0x4511.FlySpeed - 10) / 190, 0, 1))
_0x1C27(_0x5319,"Walk Speed", 21, 551, 200, 28, _0xC758.gray)
_0x8877(_0x5319,"walkSpeed", 20, 600, math.clamp((_0x4511.WalkSpeed - 16) / 184, 0, 1))
end
do
local _0x5319 = _0xA9FD["SETTINGS"]
_0x1C27(_0x5319,"RightShift = Menu", 21, 157, 400, 28, _0xC758.gray)
_0x1C27(_0x5319,"Coins: slow fly, 4 per cycle", 21, 200, 400, 22, _0xC758.gray)
_0x1C27(_0x5319,"Walk Fling: spin while walking", 21, 240, 400, 22, _0xC758.gray)
_0x1C27(_0x5319,"Fly: WASD + Space/Ctrl", 21, 280, 400, 22, _0xC758.gray)
_0x1C27(_0x5319,"Murderer red · Sheriff blue · Innocent green", 21, 320, 400, 20, _0xC758.gray)
end
_0xCF8E("VISUALS")
local _0x3295, _0xA871
_0xBC2A.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
_0x3295, _0xA871 = i.Position, _0xAE05.Position
end
end)
_0xE91C.InputChanged:Connect(function(i)
if _0x3295 and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
local _0xBCAA = i.Position - _0x3295
_0xAE05.Position = UDim2.new(_0xA871.X.Scale, _0xA871.X.Offset + _0xBCAA.X, _0xA871.Y.Scale, _0xA871.Y.Offset + _0xBCAA.Y)
end
end)
_0xE91C.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
_0x3295 = nil
end
end)
local function _0x079C(uiKey)
if _0x79CB[uiKey] then _0x79CB[uiKey].toggle() end
end
_0xE91C.InputBegan:Connect(function(input, processed)
if processed then return end
if input.KeyCode == _0x0852 then
_0x682E.Enabled = not _0x682E.Enabled
return
end
if input.KeyCode == _0x18DC.ESPKey then _0x079C("esp")
elseif input.KeyCode == _0x18DC.BoxKey then _0x079C("boxEsp")
elseif input.KeyCode == _0x18DC.SkeletonKey then _0x079C("skeletonEsp")
elseif input.KeyCode == _0x18DC.HighlightKey then _0x079C("highlightEsp")
elseif input.KeyCode == _0x18DC.LabelKey then _0x079C("labelEsp")
elseif input.KeyCode == _0x18DC.RoleKey then _0x079C("roleEsp")
elseif input.KeyCode == _0x18DC.DistKey then _0x079C("distanceEsp")
elseif input.KeyCode == _0x18DC.Body3DKey then _0x079C("body3dEsp")
elseif input.KeyCode == _0x18DC.GunKey then _0x079C("gunEsp")
elseif input.KeyCode == _0x18DC.AutoTakeKey then _0x079C("autoTakeGun")
elseif input.KeyCode == _0x18DC.FlyKey then _0x079C("fly")
elseif input.KeyCode == _0x18DC.SpeedKey then _0x079C("speed")
elseif input.KeyCode == _0x18DC.NoclipKey then _0x079C("noclip")
elseif input.KeyCode == _0x18DC.CoinFarmKey then _0x079C("autoFarmCoins")
elseif input.KeyCode == _0x18DC.WalkFlingKey then _0x079C("walkFling")
end
end)
