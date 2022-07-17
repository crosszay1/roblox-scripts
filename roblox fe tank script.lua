--[[FE Tank Hats:
https://www.roblox.com/catalog/4504231783/Elemental-Crystal-Golem-Shoulder-Rock
https://www.roblox.com/catalog/4735116238/DESERT-TONK
]]--
for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
if v:IsA("BasePart") then 
game:GetService("RunService").Heartbeat:connect(function()
pcall(function()
v.Velocity = Vector3.new(0,-30,0)
sethiddenproperty(game.Players.LocalPlayer,"MaximumSimulationRadius",math.huge)
sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",999999)
end)
end)
end
end

local plr = game.Players.LocalPlayer
local char = plr.Character
local ct = {}
local te = table.insert
local srv = game:GetService('RunService')
local jitter = Vector3.new(0,0,30)
local cam = workspace.CurrentCamera
local m = plr:GetMouse()
char.Archivable = true

local tonk = char:Clone()
tonk.Parent = char
tonk.Name = 'Tonk'

for i,v in next, tonk:GetDescendants() do if v:IsA('BasePart') or v:IsA('Decal') then v.Transparency = 1 end end

char.Humanoid:ChangeState(16) -- Limbs collider
char.HumanoidRootPart:Destroy()

function Align(part, parent, p, r) -- Align function by me ofc ;)
Instance.new("Attachment",part)
Instance.new("AlignPosition",part)
Instance.new("AlignOrientation",part)
Instance.new("Attachment",parent)
part.Attachment.Name = part.Name
parent.Attachment.Name = part.Name
part.AlignPosition.Attachment0 = part[part.Name]
part.AlignOrientation.Attachment0 = part[part.Name]
part.AlignPosition.Attachment1 = parent[part.Name]
part.AlignOrientation.Attachment1 = parent[part.Name]
parent[part.Name].Position = p or Vector3.new()
part[part.Name].Orientation = r or Vector3.new()
part.AlignPosition.MaxForce = 999999999
part.AlignPosition.MaxVelocity = math.huge
part.AlignPosition.ReactionForceEnabled = false
part.AlignPosition.Responsiveness = math.huge
part.AlignOrientation.Responsiveness = math.huge
part.AlignPosition.RigidityEnabled = false
part.AlignOrientation.MaxTorque = 999999999
end

function nomesh(p) -- Remove Mesh function by me ofc ;)
for i,v in pairs(char[p].Handle:GetDescendants()) do
if v:IsA('Mesh') or v:IsA('SpecialMesh') then
v:Remove()
end
end
end

function noclip() -- noclip function by me ofc ;)
for i,v in next, char:GetDescendants() do
if v:IsA('BasePart') then
te(ct,srv.Stepped:Connect(function()
v.CanCollide = false
end))
end
end
for i,v in next, tonk:GetDescendants() do
if v:IsA('BasePart') then
te(ct,srv.Stepped:Connect(function()
v.CanCollide = false
end))
end
end
end

function bjs(p)
p:BreakJoints()
end

function boop(p)
p:Remove()
end

function flinger(p,power)
flingo=Instance.new('BodyAngularVelocity',p)
flingo.AngularVelocity=Vector3.new(power,power,power)
flingo.MaxTorque=Vector3.new(1000*10,0,1000*10)
end

for i,v in next, tonk:GetDescendants() do if v:IsA('Accessory') then boop(v) end end

noclip()

bjs(char['New Tonk'].Handle)
bjs(char['RockAccessory'].Handle)
bjs(char['Right Arm'])
flinger(char['Right Arm'],5000*10)
nomesh('RockAccessory')

shootpart=Instance.new('Part',tonk)
shootpart.Name='Shoot Part'
shootpart.CanCollide = false
shootpart.Anchored=true
shootpart.Size=Vector3.new(1,1,1)
shootpart.Transparency = 0.5
shootpart.BrickColor = BrickColor.new(Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255)))
shootpart.CFrame=char.Torso.CFrame

anchor=Instance.new('Part',tonk)
anchor.Name='Anchor'
anchor.CanCollide = false
anchor.Anchored=true
anchor.Size=Vector3.new(1,1,1)
anchor.Transparency = 1
anchor.BrickColor = BrickColor.new(Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255)))
anchor.CFrame=char.Torso.CFrame

Align(char['RockAccessory'].Handle,shootpart)
Align(char['New Tonk'].Handle,tonk.Torso,Vector3.new(0,-1.2,0))
Align(char.Torso,anchor)

local shoot=false
root=tonk.HumanoidRootPart
te(ct,srv.Heartbeat:Connect(function()
srv.RenderStepped:Wait()
pcall(function()
if shoot then
shootpart.CFrame = CFrame.new(m.Hit.p)
char['RockAccessory'].Handle.CFrame = shootpart.CFrame
char['Right Arm'].Position = shootpart.Position
tonk.HumanoidRootPart.CFrame = CFrame.new(root.CFrame.p,Vector3.new(m.Hit.p.x,root.Position.y,m.Hit.p.z))
elseif not shoot then
shootpart.CFrame=char['New Tonk'].Handle.CFrame
char['Right Arm'].Position = shootpart.Position
char['RockAccessory'].Handle.CFrame = char['New Tonk'].Handle.CFrame*CFrame.new(0,1,0)
end
end)
end))

plr.Character=tonk
cam.CameraSubject=tonk

local hold=false
function shootem()
repeat
srv.RenderStepped:wait()
shoot=true
wait(.1)
shoot=false
until hold==false
end
te(ct,m.Button1Down:Connect(function()
hold=true
shootem()
end))

te(ct,m.Button1Up:Connect(function()
hold=false
end))

te(ct,tonk.Humanoid.Died:Connect(function()
for i,v in pairs(ct) do v:Disconnect() end
tonk:Destroy()
plr.Character = char
char:BreakJoints()
--char.Humanoid:Destroy()
end))