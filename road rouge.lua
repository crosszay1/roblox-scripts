--[[ These are the hats needed for this script:
https://web.roblox.com/catalog/5410674378/METAL-x-LIGHTSEER-77
https://web.roblox.com/catalog/4466171123/Back-Attack-Missile-Launcher
https://web.roblox.com/catalog/5063566353/Atomic-Prussian-Bike
]]--
game.Players:Chat("-gh 5063566353,4466171123")
wait(0.5)


--reanimate by MyWorld#4430 discord.gg/pYVHtSJmEY
local Vector3_101 = Vector3.new(1, 0, 1)
local netless_Y = Vector3.new(0, 25.1, 0)
local function getNetlessVelocity(realPartVelocity) --edit this if you have a better netless method
    local netlessVelocity = realPartVelocity * Vector3_101
    local mag = netlessVelocity.Magnitude
    if mag > 0.1 then
        netlessVelocity *= 100 / mag
    end
    netlessVelocity += netless_Y
    return netlessVelocity
end
local simradius = "shp" --simulation radius (net bypass) method
--"shp" - sethiddenproperty
--"ssr" - setsimulationradius
--false - disable
local antiragdoll = true --removes hingeConstraints and ballSocketConstraints from your character
local newanimate = true --disables the animate script and enables after reanimation
local discharscripts = true --disables all localScripts parented to your character before reanimation
local R15toR6 = true --tries to convert your character to r6 if its r15
local addtools = false --puts all tools from backpack to character and lets you hold them after reanimation
local hedafterneck = true --disable aligns for head and enable after neck is removed
local loadtime = game:GetService("Players").RespawnTime + 0.5 --anti respawn delay
local method = 3 --reanimation method
--methods:
--0 - breakJoints (takes [loadtime] seconds to laod)
--1 - limbs
--2 - limbs + anti respawn
--3 - limbs + breakJoints after [loadtime] seconds
--4 - remove humanoid + breakJoints
--5 - remove humanoid + limbs
local alignmode = 2 --AlignPosition mode
--modes:
--1 - AlignPosition rigidity enabled true
--2 - 2 AlignPositions rigidity enabled both true and false
--3 - AlignPosition rigidity enabled false

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local stepped = rs.Stepped
local heartbeat = rs.Heartbeat
local renderstepped = rs.RenderStepped
local sg = game:GetService("StarterGui")
local ws = game:GetService("Workspace")
local cf = CFrame.new
local v3 = Vector3.new
local v3_0 = v3(0, 0, 0)
local inf = math.huge

local c = lp.Character

if not (c and c.Parent) then
	return
end

c.Destroying:Connect(function()
	c = nil
end)

local function gp(parent, name, className)
	if typeof(parent) == "Instance" then
		for i, v in pairs(parent:GetChildren()) do
			if (v.Name == name) and v:IsA(className) then
				return v
			end
		end
	end
	return nil
end

local function align(Part0, Part1)
	Part0.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.0001, 0.0001, 0.0001, 0.0001)

	local att0 = Instance.new("Attachment", Part0)
	att0.Orientation = v3_0
	att0.Position = v3_0
	att0.Name = "att0_" .. Part0.Name
	local att1 = Instance.new("Attachment", Part1)
	att1.Orientation = v3_0
	att1.Position = v3_0
	att1.Name = "att1_" .. Part1.Name

	if (alignmode == 1) or (alignmode == 2) then
		local ape = Instance.new("AlignPosition", att0)
		ape.ApplyAtCenterOfMass = false
		ape.MaxForce = inf
		ape.MaxVelocity = inf
		ape.ReactionForceEnabled = false
		ape.Responsiveness = 200
		ape.Attachment1 = att1
		ape.Attachment0 = att0
		ape.Name = "AlignPositionRtrue"
		ape.RigidityEnabled = true
	end

	if (alignmode == 2) or (alignmode == 3) then
		local apd = Instance.new("AlignPosition", att0)
		apd.ApplyAtCenterOfMass = false
		apd.MaxForce = inf
		apd.MaxVelocity = inf
		apd.ReactionForceEnabled = false
		apd.Responsiveness = 200
		apd.Attachment1 = att1
		apd.Attachment0 = att0
		apd.Name = "AlignPositionRfalse"
		apd.RigidityEnabled = false
	end

	local ao = Instance.new("AlignOrientation", att0)
	ao.MaxAngularVelocity = inf
	ao.MaxTorque = inf
	ao.PrimaryAxisOnly = false
	ao.ReactionTorqueEnabled = false
	ao.Responsiveness = 200
	ao.Attachment1 = att1
	ao.Attachment0 = att0
	ao.RigidityEnabled = false

	if type(getNetlessVelocity) == "function" then
	    local realVelocity = v3_0
        local steppedcon = stepped:Connect(function()
            Part0.Velocity = realVelocity
        end)
        local heartbeatcon = heartbeat:Connect(function()
            realVelocity = Part0.Velocity
            Part0.Velocity = getNetlessVelocity(realVelocity)
        end)
        Part0.Destroying:Connect(function()
            Part0 = nil
            steppedcon:Disconnect()
            heartbeatcon:Disconnect()
        end)
    end
end

local function respawnrequest()
	local ccfr = ws.CurrentCamera.CFrame
	local c = lp.Character
	lp.Character = nil
	lp.Character = c
	local con = nil
	con = ws.CurrentCamera.Changed:Connect(function(prop)
	    if (prop ~= "Parent") and (prop ~= "CFrame") then
	        return
	    end
	    ws.CurrentCamera.CFrame = ccfr
	    con:Disconnect()
    end)
end

local destroyhum = (method == 4) or (method == 5)
local breakjoints = (method == 0) or (method == 4)
local antirespawn = (method == 0) or (method == 2) or (method == 3)

addtools = addtools and gp(lp, "Backpack", "Backpack")

local fenv = getfenv()
if simradius == "shp" then
	local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
	if shp then
		spawn(function()
			while c and heartbeat:Wait() do
				shp(lp, "SimulationRadius", inf)
			end
		end)
	end
elseif simradius == "ssr" then
	local ssr = fenv.setsimulationradius or fenv.set_simulation_radius or fenv.set_sim_radius or fenv.setsimradius or fenv.set_simulation_rad or fenv.setsimulationrad
	if ssr then
		spawn(function()
			while c and heartbeat:Wait() do
				ssr(inf)
			end
		end)
	end
end

antiragdoll = antiragdoll and function(v)
	if v:IsA("HingeConstraint") or v:IsA("BallSocketConstraint") then
		v.Parent = nil
	end
end

if antiragdoll then
	for i, v in pairs(c:GetDescendants()) do
		antiragdoll(v)
	end
	c.DescendantAdded:Connect(antiragdoll)
end

if antirespawn then
	respawnrequest()
end

if method == 0 then
	wait(loadtime)
	if not c then
		return
	end
end

if discharscripts then
	for i, v in pairs(c:GetChildren()) do
		if v:IsA("LocalScript") then
			v.Disabled = true
		end
	end
elseif newanimate then
	local animate = gp(c, "Animate", "LocalScript")
	if animate and (not animate.Disabled) then
		animate.Disabled = true
	else
		newanimate = false
	end
end

local hum = c:FindFirstChildOfClass("Humanoid")
if hum then
	for i, v in pairs(hum:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end

if addtools then
	for i, v in pairs(addtools:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = c
		end
	end
end

pcall(function()
	settings().Physics.AllowSleep = false
	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
end)

local OLDscripts = {}

for i, v in pairs(c:GetDescendants()) do
	if v.ClassName == "Script" then
		table.insert(OLDscripts, v)
	end
end

local scriptNames = {}

for i, v in pairs(c:GetDescendants()) do
	if v:IsA("BasePart") then
		local newName = tostring(i)
		local exists = true
		while exists do
			exists = false
			for i, v in pairs(OLDscripts) do
				if v.Name == newName then
					exists = true
				end
			end
			if exists then
				newName = newName .. "_"    
			end
		end
		table.insert(scriptNames, newName)
		Instance.new("Script", v).Name = newName
	end
end

c.Archivable = true
local cl = c:Clone()
for i, v in pairs(cl:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Transparency = 1
		v.Anchored = false
	end
end

local model = Instance.new("Model", c)
model.Name = model.ClassName

model.Destroying:Connect(function()
	model = nil
end)

for i, v in pairs(c:GetChildren()) do
	if v ~= model then
		if destroyhum and v:IsA("Humanoid") then
			v:Destroy()
		else
			if addtools and v:IsA("Tool") then
				for i1, v1 in pairs(v:GetDescendants()) do
					if v1 and v1.Parent and v1:IsA("BasePart") then
						local bv = Instance.new("BodyVelocity", v1)
						bv.Velocity = v3_0
						bv.MaxForce = v3(1000, 1000, 1000)
						bv.P = 1250
						bv.Name = "bv_" .. v.Name
					end
				end
			end
			v.Parent = model
		end
	end
end
local head = gp(model, "Head", "BasePart")
local torso = gp(model, "Torso", "BasePart") or gp(model, "UpperTorso", "BasePart")
if breakjoints then
	model:BreakJoints()
else
	if head and torso then
		for i, v in pairs(model:GetDescendants()) do
			if v:IsA("Weld") or v:IsA("Snap") or v:IsA("Glue") or v:IsA("Motor") or v:IsA("Motor6D") then
				local save = false
				if (v.Part0 == torso) and (v.Part1 == head) then
					save = true
				end
				if (v.Part0 == head) and (v.Part1 == torso) then
					save = true
				end
				if save then
					if hedafterneck then
						hedafterneck = v
					end
				else
					v:Destroy()
				end
			end
		end
	end
	if method == 3 then
		spawn(function()
			wait(loadtime)
			if model then
				model:BreakJoints()
			end
		end)
	end
end

cl.Parent = c
for i, v in pairs(cl:GetChildren()) do
	v.Parent = c
end
cl:Destroy()

local modelDes = {}
for i, v in pairs(model:GetDescendants()) do
	if v:IsA("BasePart") then
		i = tostring(i)
		v.Destroying:Connect(function()
			modelDes[i] = nil
		end)
		modelDes[i] = v
	end
end
local modelcolcon = nil
local function modelcolf()
	if model then
		for i, v in pairs(modelDes) do
			v.CanCollide = false
		end
	else
		modelcolcon:Disconnect()
	end
end
modelcolcon = stepped:Connect(modelcolf)
modelcolf()

for i, scr in pairs(model:GetDescendants()) do
	if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
		local Part0 = scr.Parent
		if Part0:IsA("BasePart") then
			for i1, scr1 in pairs(c:GetDescendants()) do
				if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
					local Part1 = scr1.Parent
					if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
						align(Part0, Part1)
						break
					end
				end
			end
		end
	end
end

if (typeof(hedafterneck) == "Instance") and head then
	local aligns = {}
	local con = nil
	con = hedafterneck.Changed:Connect(function(prop)
	    if (prop == "Parent") and not hedafterneck.Parent then
	        con:Disconnect()
    		for i, v in pairs(aligns) do
    			v.Enabled = true
    		end
		end
	end)
	for i, v in pairs(head:GetDescendants()) do
		if v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
			i = tostring(i)
			aligns[i] = v
			v.Destroying:Connect(function()
			    aligns[i] = nil
			end)
			v.Enabled = false
		end
	end
end

for i, v in pairs(c:GetDescendants()) do
	if v and v.Parent then
		if v.ClassName == "Script" then
			if table.find(scriptNames, v.Name) then
				v:Destroy()
			end
		elseif not v:IsDescendantOf(model) then
			if v:IsA("Decal") then
				v.Transparency = 1
			elseif v:IsA("ForceField") then
				v.Visible = false
			elseif v:IsA("Sound") then
				v.Playing = false
			elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false
			end
		end
	end
end

if newanimate then
	local animate = gp(c, "Animate", "LocalScript")
	if animate then
		animate.Disabled = false
	end
end

if addtools then
	for i, v in pairs(c:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = addtools
		end
	end
end

local hum0 = model:FindFirstChildOfClass("Humanoid")
if hum0 then
    hum0.Destroying:Connect(function()
        hum0 = nil
    end)
end

local hum1 = c:FindFirstChildOfClass("Humanoid")
if hum1 then
    hum1.Destroying:Connect(function()
        hum1 = nil
    end)
end

if hum1 then
	ws.CurrentCamera.CameraSubject = hum1
	local camSubCon = nil
	local function camSubFunc()
		camSubCon:Disconnect()
		if c and hum1 then
			ws.CurrentCamera.CameraSubject = hum1
		end
	end
	camSubCon = renderstepped:Connect(camSubFunc)
	if hum0 then
		hum0.Changed:Connect(function(prop)
			if hum1 and (prop == "Jump") then
				hum1.Jump = hum0.Jump
			end
		end)
	else
		respawnrequest()
	end
end

local rb = Instance.new("BindableEvent", c)
rb.Event:Connect(function()
	rb:Destroy()
	sg:SetCore("ResetButtonCallback", true)
	if destroyhum then
		c:BreakJoints()
		return
	end
	if hum0 and (hum0.Health > 0) then
		model:BreakJoints()
		hum0.Health = 0
	end
	if antirespawn then
	    respawnrequest()
	end
end)
sg:SetCore("ResetButtonCallback", rb)

spawn(function()
	while c do
		if hum0 and hum1 then
			hum1.Jump = hum0.Jump
		end
		wait()
	end
	sg:SetCore("ResetButtonCallback", true)
end)

R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
if R15toR6 then
    local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
	if part then
	    local cfr = part.CFrame
		local R6parts = { 
			head = {
				Name = "Head",
				Size = v3(2, 1, 1),
				R15 = {
					Head = 0
				}
			},
			torso = {
				Name = "Torso",
				Size = v3(2, 2, 1),
				R15 = {
					UpperTorso = 0.2,
					LowerTorso = -0.8
				}
			},
			root = {
				Name = "HumanoidRootPart",
				Size = v3(2, 2, 1),
				R15 = {
					HumanoidRootPart = 0
				}
			},
			leftArm = {
				Name = "Left Arm",
				Size = v3(1, 2, 1),
				R15 = {
					LeftHand = -0.85,
					LeftLowerArm = -0.2,
					LeftUpperArm = 0.4
				}
			},
			rightArm = {
				Name = "Right Arm",
				Size = v3(1, 2, 1),
				R15 = {
					RightHand = -0.85,
					RightLowerArm = -0.2,
					RightUpperArm = 0.4
				}
			},
			leftLeg = {
				Name = "Left Leg",
				Size = v3(1, 2, 1),
				R15 = {
					LeftFoot = -0.85,
					LeftLowerLeg = -0.15,
					LeftUpperLeg = 0.6
				}
			},
			rightLeg = {
				Name = "Right Leg",
				Size = v3(1, 2, 1),
				R15 = {
					RightFoot = -0.85,
					RightLowerLeg = -0.15,
					RightUpperLeg = 0.6
				}
			}
		}
		for i, v in pairs(c:GetChildren()) do
			if v:IsA("BasePart") then
				for i1, v1 in pairs(v:GetChildren()) do
					if v1:IsA("Motor6D") then
						v1.Part0 = nil
					end
				end
			end
		end
		part.Archivable = true
		for i, v in pairs(R6parts) do
			local part = part:Clone()
			part:ClearAllChildren()
			part.Name = v.Name
			part.Size = v.Size
			part.CFrame = cfr
			part.Anchored = false
			part.Transparency = 1
			part.CanCollide = false
			for i1, v1 in pairs(v.R15) do
				local R15part = gp(c, i1, "BasePart")
				local att = gp(R15part, "att1_" .. i1, "Attachment")
				if R15part then
					local weld = Instance.new("Weld", R15part)
					weld.Name = "Weld_" .. i1
					weld.Part0 = part
					weld.Part1 = R15part
					weld.C0 = cf(0, v1, 0)
					weld.C1 = cf(0, 0, 0)
					R15part.Massless = true
					R15part.Name = "R15_" .. i1
					R15part.Parent = part
					if att then
						att.Parent = part
						att.Position = v3(0, v1, 0)
					end
				end
			end
			part.Parent = c
			R6parts[i] = part
		end
		local R6joints = {
			neck = {
				Parent = R6parts.torso,
				Name = "Neck",
				Part0 = R6parts.torso,
				Part1 = R6parts.head,
				C0 = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				C1 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
			},
			rootJoint = {
				Parent = R6parts.root,
				Name = "RootJoint" ,
				Part0 = R6parts.root,
				Part1 = R6parts.torso,
				C0 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				C1 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
			},
			rightShoulder = {
				Parent = R6parts.torso,
				Name = "Right Shoulder",
				Part0 = R6parts.torso,
				Part1 = R6parts.rightArm,
				C0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				C1 = cf(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			},
			leftShoulder = {
				Parent = R6parts.torso,
				Name = "Left Shoulder",
				Part0 = R6parts.torso,
				Part1 = R6parts.leftArm,
				C0 = cf(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = cf(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			},
			rightHip = {
				Parent = R6parts.torso,
				Name = "Right Hip",
				Part0 = R6parts.torso,
				Part1 = R6parts.rightLeg,
				C0 = cf(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				C1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			},
			leftHip = {
				Parent = R6parts.torso,
				Name = "Left Hip" ,
				Part0 = R6parts.torso,
				Part1 = R6parts.leftLeg,
				C0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			}
		}
		for i, v in pairs(R6joints) do
			local joint = Instance.new("Motor6D")
			for prop, val in pairs(v) do
				joint[prop] = val
			end
			R6joints[i] = joint
		end
		hum1.RigType = Enum.HumanoidRigType.R6
		hum1.HipHeight = 0
	end
end

local c = game.Players.LocalPlayer.Character
local function gp(parent, name, className)
    local ret = nil
    if parent then
        for i, v in pairs(parent:GetChildren()) do
            if (v.Name == name) and v:IsA(className) then
                ret = v
            end
        end
    end
    return ret
end

local power = 9e9
local partName = "HumanoidRootPart"

local function gp(parent, name, className)
    local ret = nil
    if parent then
        for i, v in pairs(parent:GetChildren()) do
            if (v.Name == name) and v:IsA(className) then
                ret = v
            end
        end
    end
    return ret
end

local lp = game:GetService("Players").LocalPlayer

local m = lp:GetMouse()
local p = false
m.Button1Down:Connect(function()
    p = true
end)
m.Button1Up:Connect(function()
    p = false
end)
local c = lp.Character
if not (c and c.Parent) then
    print("character not found")
    return
end
local hrp = gp(gp(c, "Model", "Model"), partName, "BasePart")
if not hrp then
    print("part not found")
    return
end
local a = {}
for i, v in pairs(hrp:GetDescendants()) do
    if v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
        table.insert(a, v)
    end
end
if hrp.Transparency > 0.5 then
    hrp.Transparency = 0.5
end
local bp = Instance.new("BodyPosition", hrp)
bp.P = 300000000000
bp.D = 5000000
bp.Name = "flingPos"
game:GetService("RunService").Stepped:Connect(function()
    if hrp and hrp.Parent and bp and bp.Parent then
        if p and m.Target then
            for i, v in pairs(a) do
                v.Enabled = false 
            end
            bp.Position = m.Hit.Position
            hrp.RotVelocity = Vector3.new(power, power, power)
            bp.Parent = hrp
        else
            for i, v in pairs(a) do
                v.Enabled = true 
            end
            if bp.Parent == hrp then
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
            bp.Parent = c
        end
    end
end)

--//====================================================\\--
--||                       BASIS
--\\====================================================//--

local script = game:GetObjects("rbxassetid://9532774501")[1]

local MODULE = script
local PLAYER = game.Players.LocalPlayer
local CHARACTER = PLAYER.Character
local HUM = CHARACTER.Humanoid
local REMOTE = MODULE.Event

local m = game.Players.LocalPlayer:GetMouse()
Player = game:GetService("Players").LocalPlayer
Mouse = Player:GetMouse()
local ROOT = HUM.Torso
local HEAD = CHARACTER.Head
local TORSO = CHARACTER.Torso
local RIGHTARM = CHARACTER["Right Arm"]
local LEFTARM = CHARACTER["Left Arm"]
local RIGHTLEG = CHARACTER["Right Leg"]
local LEFTLEG = CHARACTER["Left Leg"]
local ROOTJOINT = ROOT["RootJoint"]
local NECK = TORSO["Neck"]
local MOTOR = MODULE.Motor
MOTOR.Parent = CHARACTER
local SMG = MODULE.Uzi

local att = gp(gp(gp(c, "METALXLIGHTSEER77Accessory", "Accessory"), "Handle", "BasePart"), "att1_Handle", "Attachment")
att.Parent = SMG
att.Position = Vector3.new(0, 0.2, 0)
att.Orientation = Vector3.new(0, 90, -35)

SMG.Parent = CHARACTER
local RIGHTSHOULDER = TORSO["Right Shoulder"]
local LEFTSHOULDER = TORSO["Left Shoulder"]
local RIGHTHIP = TORSO["Right Hip"]
local LEFTHIP = TORSO["Left Hip"]
local MOUSEPOS = m.hit.p
local MOUSEHIT = nil



IT = Instance.new
CF = CFrame.new
VT = Vector3.new
RAD = math.rad
C3 = Color3.new
UD2 = UDim2.new
BRICKC = BrickColor.new
ANGLES = CFrame.Angles
EULER = CFrame.fromEulerAnglesXYZ
COS = math.cos
ACOS = math.acos
SIN = math.sin
ASIN = math.asin
ABS = math.abs
MRANDOM = math.random
FLOOR = math.floor

--//====================================================\\--
--||                       FE CODE
--\\====================================================//--
--nyoom

--//====================================================\\--
--||                  BACKGROUND VALUES
--\\====================================================//--

local ANIM_SPEED = 3
local MOUSE = PLAYER:GetMouse()
local FRAME_SPEED = 1 / 60 -- (1 / 30) OR (1 / 60)
local CHANGE = 2 / ANIM_SPEED
local DAMAGEMULTIPLIER = 1
local ANIM = "Idle"
local KEYHOLD = false
local MOUSEHOLD = false
local SINE = 0
local ATTACKING = false
local Debris = game:GetService("Debris")
local Effects = IT("Folder",CHARACTER)
Effects.Name = "FXFolder"
ROOTJOINT.C1 = CF(0,0,0)
NECK.C1 = CF(0,0,0)
RIGHTSHOULDER.C1 = CF(0,0,0)
LEFTSHOULDER.C1 = CF(0,0,0)
RIGHTHIP.C1 = CF(0,0,0)
LEFTHIP.C1 = CF(0,0,0)
local USEDEFAULTANIMATIONS = true

--//====================================================\\--
--||                     HEARTBEAT
--\\====================================================//--

ArtificialHB = Instance.new("BindableEvent", script)
ArtificialHB.Name = "ArtificialHB"

script:WaitForChild("ArtificialHB")

frame = FRAME_SPEED
tf = 0
allowframeloss = false
tossremainder = false
lastframe = tick()
script.ArtificialHB:Fire()

game:GetService("RunService").Heartbeat:connect(function(s, p)
	tf = tf + s
	if tf >= frame then
		if allowframeloss then
			ArtificialHB:Fire()
			lastframe = tick()
		else
			for i = 1, math.floor(tf / frame) do
				ArtificialHB:Fire()
			end
			lastframe = tick()
		end
		if tossremainder then
			tf = 0
		else
			tf = tf - frame * math.floor(tf / frame)
		end
	end
end)

function PositiveAngle(NUMBER)
	if NUMBER >= 0 then
		NUMBER = 0
	end
	return NUMBER
end

function NegativeAngle(NUMBER)
	if NUMBER <= 0 then
		NUMBER = 0
	end
	return NUMBER
end

function Swait(NUMBER)
	if NUMBER == 0 or NUMBER == nil then
		ArtificialHB.Event:wait()
	else
		for i = 1, NUMBER do
			ArtificialHB.Event:wait()
		end
	end
end

--//====================================================\\--
--||                       CLERP
--\\====================================================//--

function QuaternionFromCFrame(cf)
	local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
	local trace = m00 + m11 + m22
	if trace > 0 then 
		local s = math.sqrt(1 + trace)
		local recip = 0.5 / s
		return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
	else
		local i = 0
		if m11 > m00 then
			i = 1
		end
		if m22 > (i == 0 and m00 or m11) then
			i = 2
		end
		if i == 0 then
			local s = math.sqrt(m00 - m11 - m22 + 1)
			local recip = 0.5 / s
			return 0.5 * s, (m10 + m01) * recip, (m20 + m02) * recip, (m21 - m12) * recip
		elseif i == 1 then
			local s = math.sqrt(m11 - m22 - m00 + 1)
			local recip = 0.5 / s
			return (m01 + m10) * recip, 0.5 * s, (m21 + m12) * recip, (m02 - m20) * recip
		elseif i == 2 then
			local s = math.sqrt(m22 - m00 - m11 + 1)
			local recip = 0.5 / s return (m02 + m20) * recip, (m12 + m21) * recip, 0.5 * s, (m10 - m01) * recip
		end
	end
end
 
function QuaternionToCFrame(px, py, pz, x, y, z, w)
	local xs, ys, zs = x + x, y + y, z + z
	local wx, wy, wz = w * xs, w * ys, w * zs
	local xx = x * xs
	local xy = x * ys
	local xz = x * zs
	local yy = y * ys
	local yz = y * zs
	local zz = z * zs
	return CFrame.new(px, py, pz, 1 - (yy + zz), xy - wz, xz + wy, xy + wz, 1 - (xx + zz), yz - wx, xz - wy, yz + wx, 1 - (xx + yy))
end
 
function QuaternionSlerp(a, b, t)
	local cosTheta = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
	local startInterp, finishInterp;
	if cosTheta >= 0.0001 then
		if (1 - cosTheta) > 0.0001 then
			local theta = ACOS(cosTheta)
			local invSinTheta = 1 / SIN(theta)
			startInterp = SIN((1 - t) * theta) * invSinTheta
			finishInterp = SIN(t * theta) * invSinTheta
		else
			startInterp = 1 - t
			finishInterp = t
		end
	else
		if (1 + cosTheta) > 0.0001 then
			local theta = ACOS(-cosTheta)
			local invSinTheta = 1 / SIN(theta)
			startInterp = SIN((t - 1) * theta) * invSinTheta
			finishInterp = SIN(t * theta) * invSinTheta
		else
			startInterp = t - 1
			finishInterp = t
		end
	end
	return a[1] * startInterp + b[1] * finishInterp, a[2] * startInterp + b[2] * finishInterp, a[3] * startInterp + b[3] * finishInterp, a[4] * startInterp + b[4] * finishInterp
end

function Clerp(a, b, t)
	local qa = {QuaternionFromCFrame(a)}
	local qb = {QuaternionFromCFrame(b)}
	local ax, ay, az = a.x, a.y, a.z
	local bx, by, bz = b.x, b.y, b.z
	local _t = 1 - t
	return QuaternionToCFrame(_t * ax + t * bx, _t * ay + t * by, _t * az + t * bz, QuaternionSlerp(qa, qb, t))
end

--//====================================================\\--
--||                     FUNCTIONS
--\\====================================================//--

function WeldParts(A,B)
	local WLD = IT("ManualWeld")
	WLD.Part0 = A
	WLD.Part1 = B
	WLD.C1 = B.CFrame:inverse() * A.CFrame
	WLD.Parent = A
	return WLD
end

--NewSound({ID = 0,PARENT = ROOT,VOLUME = 0.5,PITCH = 1,LOOP = false,MAXDISTANCE = 1000,EMITTERSIZE = 10,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
function NewSound(TABLE)
	local ID = "rbxassetid://"..(TABLE.ID or 0)
	local PARENT = (TABLE.PARENT or ROOT)
	local VOLUME = (TABLE.VOLUME or 0.5)
	local PITCH = (TABLE.PITCH or 1)
	local LOOP = (TABLE.LOOP or false)
	local MAXDISTANCE = (TABLE.MAXDISTANCE or 100)
	local EMITTERSIZE = (TABLE.EMITTERSIZE or 10)
	local PLAYING = (TABLE.PLAYING or true)
	local PLAYONREMOVE = (TABLE.PLAYONREMOVE or false)
	local DOESDEBRIS = (TABLE.DOESDEBRIS or true)
	if ID ~= "rbxassetid://0" then
		local SOUND = IT("Sound",PARENT)
		SOUND.SoundId = ID
		SOUND.Volume = VOLUME
		SOUND.Pitch = PITCH
		SOUND.Looped = LOOP
		SOUND.MaxDistance = MAXDISTANCE
		SOUND.EmitterSize = EMITTERSIZE
		SOUND.PlayOnRemove = PLAYONREMOVE
		if DOESDEBRIS == true and PLAYING == true and LOOP == false then
			Debris:AddItem(SOUND,SOUND.TimeLength+5)
		end
		if PLAYING == true then
			SOUND:Play()
		end
		return SOUND
	end
end

function OofOuchBlood(LOCATION,TO,AMOUNT)
	local P = CreatePart(3, Effects, "Granite", 0, 1, BRICKC("Pearl"), "Blood", VT(0,0,0), true)
	P.CFrame = CF(LOCATION,TO)
	local BLOOD = MODULE.Blood:Clone()
	BLOOD.Parent = P
	BLOOD:Emit(AMOUNT)
	Debris:AddItem(P,2)
end

function AttachmentCFrame(A)
	return A.Parent.CFrame*CF(A.Position)
end

function CastProperRay(StartPos, EndPos, Distance, Ignore)
	local DIRECTION = CF(StartPos,EndPos).lookVector
	return Raycast(StartPos, DIRECTION, Distance, Ignore)
end

function ManSlaughter(MAN)
	if MAN then
		local ROOT = MAN:FindFirstChild("HumanoidRootPart")
		if ROOT then
			ROOT:Remove()
		end
		local MANHUM = MAN:FindFirstChildOfClass("Humanoid")
		if MANHUM then
			MANHUM.BreakJointsOnDeath = false
			MANHUM.Health = 0
		end
		if MAN:FindFirstChild("R6Ragdoll") == nil and MAN:FindFirstChild("R15Ragdoll") == nil then
			if MAN:FindFirstChild("UpperTorso") then
				local SCRIPT = script.R15Ragdoll:Clone()
				SCRIPT.Parent = MAN
				SCRIPT.Disabled = false
			else
				local SCRIPT = script.R6Ragdoll:Clone()
				SCRIPT.Parent = MAN
				SCRIPT.Disabled = false
			end
			local TORSO = MAN:FindFirstChild("Torso") or MAN:FindFirstChild("UpperTorso")
			if TORSO then
				NewSound({ID = 146594648,PARENT = TORSO,VOLUME = 1,PITCH = MRANDOM(8,12)/10,LOOP = false,MAXDISTANCE = 75,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			end
		end
		MAN:BreakJoints()
		if MAN:FindFirstChild("Slaughtered") == nil then
			local MARK = IT("Folder",MAN)
			MARK.Name = "Slaughtered"
		else
			if MAN:FindFirstChild("Slaughtered") then
				local TORSO = MAN:FindFirstChild("Torso") or MAN:FindFirstChild("UpperTorso")
				if TORSO then
					TORSO.RotVelocity = VT(0,MRANDOM(-25,25),0)
				end
			end
		end
	end
end

function ApplyDamageTo(HUM,DAMAGE)
	if HUM.Health >= 0 then
		HUM.Health = HUM.Health 
		if HUM.Health <= 0 then
			--ManSlaughter(HUM.Parent)
		end
	end
end

function AreaOfEffect(AREA,RANGE,MIN,MAX,RETURN)
	local HIT = {}
	for index, CHILD in pairs(workspace:GetChildren()) do
		if CHILD:FindFirstChildOfClass("Humanoid") and CHILD ~= CHARACTER then
			local HUMAN = CHILD:FindFirstChildOfClass("Humanoid")
			local ROOT = HUMAN.Torso
			if ROOT then
				if (ROOT.Position - AREA).Magnitude <= RANGE then
					if RETURN == true then
						table.insert(HIT,{CHILD,HUMAN,ROOT})
					else
					--	ApplyDamageTo(HUMAN,MRANDOM(MIN,MAX))
					end
				end
			end
		end
	end
	if RETURN == true then
		return HIT
	end
end

function CreateMesh(MESH, PARENT, MESHTYPE, MESHID, TEXTUREID, SCALE, OFFSET)
	local NEWMESH = IT(MESH)
	if MESH == "SpecialMesh" then
		NEWMESH.MeshType = MESHTYPE
		if MESHID ~= "nil" and MESHID ~= "" then
			NEWMESH.MeshId = "http://www.roblox.com/asset/?id="..MESHID
		end
		if TEXTUREID ~= "nil" and TEXTUREID ~= "" then
			NEWMESH.TextureId = "http://www.roblox.com/asset/?id="..TEXTUREID
		end
	end
	NEWMESH.Offset = OFFSET or VT(0, 0, 0)
	NEWMESH.Scale = SCALE
	NEWMESH.Parent = PARENT
	return NEWMESH
end

function CreatePart(FORMFACTOR, PARENT, MATERIAL, REFLECTANCE, TRANSPARENCY, BRICKCOLOR, NAME, SIZE, ANCHOR)
	local NEWPART = IT("Part")
	NEWPART.formFactor = FORMFACTOR
	NEWPART.Reflectance = REFLECTANCE
	NEWPART.Transparency = TRANSPARENCY
	NEWPART.CanCollide = false
	NEWPART.Locked = true
	NEWPART.Anchored = true
	if ANCHOR == false then
		NEWPART.Anchored = false
	end
	NEWPART.BrickColor = BRICKC(tostring(BRICKCOLOR))
	NEWPART.Name = NAME
	NEWPART.Size = SIZE
	NEWPART.Position = ROOT.Position
	NEWPART.Material = MATERIAL
	NEWPART:BreakJoints()
	NEWPART.Parent = PARENT
	return NEWPART
end

function Raycast(POSITION, DIRECTION, RANGE, TABLE)
	local TABLE = ((type(TABLE) == "table" and TABLE) or {TABLE})
	return game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(POSITION, DIRECTION * RANGE), TABLE)
end

function CameraShake(AREA,RANGE,SHAKE,TIMER)
	for index, CHILD in pairs(workspace:GetChildren()) do
		if CHILD:FindFirstChildOfClass("Humanoid") then
			local HUMAN = CHILD:FindFirstChildOfClass("Humanoid")
			local ROOT = HUMAN.Torso
			if ROOT and game.Players:GetPlayerFromCharacter(CHILD) then
				if (ROOT.Position - AREA).Magnitude <= RANGE then
					if CHILD:FindFirstChild("CamShake") then
						Debris:AddItem(CHILD:FindFirstChild("CamShake"),0.05)
					end
					local CAMSHAKE = script.CamShake:Clone()
					CAMSHAKE.Parent = CHILD
					local TIMER_V = IT("NumberValue",CAMSHAKE)
					TIMER_V.Name = "Timer"
					TIMER_V.Value = TIMER
					local SHAKE_V = IT("NumberValue",CAMSHAKE)
					SHAKE_V.Name = "Shake"
					SHAKE_V.Value = SHAKE
					CAMSHAKE.Disabled = false
					Debris:AddItem(CAMSHAKE,15)
				end
			end
		end
	end
end

--//====================================================\\--
--||                     CHARACTER
--\\====================================================//--

local DIED = false
local TRACKS = {{2598781800,1.75},{373410757,2},{327466331,2.7},{193170682,2.2},{2496169936,2.5},{1703313447,2.3},{2884982022,4.25},{3397313642,3},{601814175,2.2}}
local TRACK = 1
local MOLOTOVPROP = MODULE.Molotov
MOLOTOVPROP.Parent = nil
local MISILEPROP = MODULE.Missile
MISILEPROP.Parent = nil
local BULLETPROP = MODULE.Bullet
BULLETPROP.Parent = nil
local FRONTWHEEL = MODULE.FrontWheel
local BACKWHEEL = MODULE.BackWheel
local FRONTC1 = FRONTWHEEL.CFrame:inverse() * MOTOR.CFrame
local BACKC1 = BACKWHEEL.CFrame:inverse() * MOTOR.CFrame
local BACKUPWHEEL = FRONTWHEEL:Clone()
BACKUPWHEEL.Parent = nil
BACKUPWHEEL.CanCollide = true
BACKUPWHEEL.Anchored = false
local WHEELS = {{FRONTWHEEL,FRONTC1},{BACKWHEEL,BACKC1}}
local WHEELJOINTS = {}
local MOTORMODEL = IT("Model",CHARACTER)
MOTORMODEL.Name = "MotorThings"
for i = 1, #WHEELS do
	WHEELS[i][1].Anchored = false
	WHEELS[i][1].Parent = MOTORMODEL
	local JOINT = IT("Motor6D")
	JOINT.Parent = MOTOR
	JOINT.C1 = WHEELS[i][2]
	JOINT.Part0 = MOTOR
	JOINT.Part1 = WHEELS[i][1]
	JOINT.Parent = WHEELS[i][1]
	table.insert(WHEELJOINTS,JOINT)
end
MOTOR.Anchored = false
MOTOR.Parent = MOTORMODEL

for _,v in pairs(MOTORMODEL:GetChildren()) do
	if v:IsA("BasePart") then
		v.Transparency = 1
	end
end

SMG.Anchored = false
local MOTORWELD = IT("Motor6D")
MOTORWELD.Part0 = TORSO
MOTORWELD.Part1 = MOTOR
MOTORWELD.Name = "MotorJoint"
MOTORWELD.Parent = TORSO
local SMGGRIP = IT("Motor6D")
SMGGRIP.Part0 = RIGHTARM
SMGGRIP.Part1 = SMG
SMGGRIP.Name = "SmgGrip"
SMGGRIP.Parent = RIGHTARM
local SMGTIGHTGRIP = IT("Motor6D")
SMGTIGHTGRIP.Part0 = RIGHTARM
SMGTIGHTGRIP.Part1 = SMG
SMGTIGHTGRIP.Name = "SmgGrip"
SMGTIGHTGRIP.C0 = CF(0,-1.1,-0.5)*ANGLES(RAD(90),RAD(0),RAD(-180))*ANGLES(RAD(0),RAD(0),RAD(0))
local MOTORHUM = NewSound({ID = 122292723,PARENT = ROOT,VOLUME = 1.5,PITCH = 1,LOOP = true,MAXDISTANCE = 125,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
MOTORHUM.Name = "MOTORHUM"
local JOINT1 = IT("Attachment",TORSO)
local JOINT2 = IT("Attachment",RIGHTARM)
JOINT1.Position = VT(1.575,0.8,0)
JOINT2.Position = VT(0,1,0)
local SHOULDER = IT("BallSocketConstraint",TORSO)
SHOULDER.Attachment0 = JOINT1
SHOULDER.Attachment1 = JOINT2
SHOULDER.Radius = 0.05
local MOTORHITBOX = CreatePart(3,MOTORMODEL,"Neon",0,1,"Grey","Hitbox",MOTOR.Size*1.5,false)
MOTORHITBOX.Massless = true
MOTORHITBOX.CFrame = MOTOR.CFrame
WeldParts(MOTOR,MOTORHITBOX)
local MOTORHIT = MOTORHITBOX.Touched:Connect(function(HIT)
	if HUM.WalkSpeed > 80 then
		if HIT.Parent:FindFirstChildOfClass("Humanoid") and HIT.Parent ~= CHARACTER then
			if HIT.Parent:FindFirstChildOfClass("Humanoid").Health > 0 and HIT.Parent:FindFirstChild("Roadrogue") == nil then
				CameraShake(HIT.Position,25,5,55)
				local BV = IT("BodyVelocity")
				BV.MaxForce = BV.MaxForce * 500
				BV.Velocity = CF(ROOT.Position-VT(0,2,0),HIT.Position+VT(0,1,0)).lookVector*(HUM.WalkSpeed/2)
				BV.Parent = HIT
				Debris:AddItem(BV,0.5)
				OofOuchBlood(HIT.Position,ROOT.Position,150)
				----ManSlaughter(HIT.Parent)
				NewSound({ID = 314390675,PARENT = ROOT,VOLUME = 5,PITCH = MRANDOM(8,12)/12,LOOP = false,MAXDISTANCE = 125,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			end
		end
	end
end)
local BOOST = false
local BAZOOKA = MODULE.Bazooka

local att = gp(gp(gp(c, "Back Attack Missle Launcher", "Accessory"), "Handle", "BasePart"), "att1_Handle", "Attachment")
att.Parent = BAZOOKA
att.Position = Vector3.new(0, 0, 0)
att.Orientation = Vector3.new(0, 90, -40)

BAZOOKA.Transparency = 1

BAZOOKA.Parent = CHARACTER
BAZOOKA.Anchored = false
local BAZOOKAWELD = IT("Motor6D")
BAZOOKAWELD.Part0 = TORSO
BAZOOKAWELD.Part1 = BAZOOKA
BAZOOKAWELD.Parent = TORSO
local BC0 = CF(0,0,0.75)*ANGLES(RAD(90),RAD(-40),RAD(90))*ANGLES(RAD(0),RAD(0),RAD(0))
BAZOOKAWELD.C0 = BC0
for _, c in pairs(CHARACTER:GetDescendants()) do
	if c:IsA("BasePart") then
		c.Locked = true
		c.Anchored = false
	end
end
local GUI = MODULE.ControlsGUI
GUI.Parent = PLAYER.PlayerGui
GUI.ToggleButton.MouseButton1Click:Connect(function()
	if GUI.ToggleButton.Controls.Visible == false then
		GUI.ToggleButton.Controls.Visible = true
	elseif GUI.ToggleButton.Controls.Visible == true then
		GUI.ToggleButton.Controls.Visible = false
	end
end)
local MARKME = IT("Beam",CHARACTER)
MARKME.Name = "Roadrogue"
local LOCKEDSPEED = 150
local HASBAZOOKAEQUIPPED = false

--//====================================================\\--
--||                     ABILITIES
--\\====================================================//--

function Fire()
	local DROPSOUNDS = {3182143803,3182144291,3182144511}
	ATTACKING = true
	RIGHTSHOULDER.Parent = nil
	SMGGRIP.Parent = nil
	SMGTIGHTGRIP.Parent = RIGHTARM
	local DETECTKILL = function(HIT,POS,FORCE)
		if HIT.Parent:FindFirstChildOfClass("Humanoid") then
			if HIT.Parent:FindFirstChildOfClass("Humanoid").Health > 0 then
				local BV = IT("BodyVelocity")
				BV.MaxForce = BV.MaxForce * 500
				BV.Velocity = CF(ROOT.Position,HIT.Position+VT(0,5,0)).lookVector*(FORCE or 25)
				BV.Parent = HIT
				Debris:AddItem(BV,0.2)
				OofOuchBlood(POS,ROOT.Position,150)
			else
				OofOuchBlood(POS,ROOT.Position,2)
			end
			----ManSlaughter(HIT.Parent)
			NewSound({ID = 1489924400,PARENT = HIT,VOLUME = 1,PITCH = MRANDOM(9,11)/10,LOOP = false,MAXDISTANCE = 75,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
		elseif HIT.Parent.Parent:FindFirstChildOfClass("Humanoid") then
			if HIT.Parent.Parent:FindFirstChildOfClass("Humanoid").Health > 0 then
				if HIT.Parent.Parent:FindFirstChildOfClass("Humanoid").Torso then
					local BV = IT("BodyVelocity")
					BV.MaxForce = BV.MaxForce * 500
					BV.Velocity = CF(ROOT.Position,HIT.Position+VT(0,5,0)).lookVector*(FORCE or 25)
					BV.Parent = HIT.Parent.Parent:FindFirstChildOfClass("Humanoid").Torso
					Debris:AddItem(BV,0.2)
				end
				OofOuchBlood(POS,ROOT.Position,150)
			else
				OofOuchBlood(POS,ROOT.Position,2)
			end
			--ManSlaughter(HIT.Parent.Parent)
			NewSound({ID = 1489924400,PARENT = HIT,VOLUME = 1,PITCH = MRANDOM(9,11)/10,LOOP = false,MAXDISTANCE = 75,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
		else
			--Debree({Delay = 1.5,Variant = "Loose",Location = POS,Color = HIT.Color,Size = 0.2,Distance = 1,Material = HIT.Material,Scatter = 60,Amount = 1,DebreeCount = 4})
		end
	end
	local DOFIRE = 0
	local GYRO = IT("BodyGyro")
	GYRO.D = 20
	GYRO.P = 500
	GYRO.MaxTorque = VT(4000000,4000000,4000000)
	GYRO.CFrame = CF(RIGHTARM.CFrame*CF(0,0.8,0).p,m.hit.p)*ANGLES(RAD(90),RAD(45),0)
	GYRO.Parent = RIGHTARM
	repeat
		Swait()
		DOFIRE = DOFIRE + 1
		if DOFIRE > 4 then
			DOFIRE = 0
			local PROP = BULLETPROP:Clone()
			PROP.Anchored = false
			PROP.Parent = workspace
			PROP.CFrame = SMG.CFrame*ANGLES(RAD(90),0,0)
			local BV = IT("BodyVelocity")
			BV.MaxForce = BV.MaxForce * 500
			BV.Velocity = CF(SMG.Position,SMG.CFrame*CF(-1,0,0).p).lookVector*45
			BV.Parent = PROP
			Debris:AddItem(BV,0.1)
			Debris:AddItem(PROP,1)
			NewSound({ID = DROPSOUNDS[MRANDOM(1,#DROPSOUNDS)],PARENT = PROP,VOLUME = 0.35,PITCH = MRANDOM(9,11)/10,LOOP = false,MAXDISTANCE = 65,EMITTERSIZE = 10,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			local HIT,POS = CastProperRay(AttachmentCFrame(SMG.Nuzzle).p,m.hit.p,1000,CHARACTER)
			local DISTANCE = (POS - AttachmentCFrame(SMG.Nuzzle).p).Magnitude
			if HIT then
				DETECTKILL(HIT,POS,12)
			end
			SMG.Nuzzle.Flash:Emit(10)
			NewSound({ID = 1583819337,PARENT = SMG,VOLUME = 0.45,PITCH = MRANDOM(9,11)/7.5,LOOP = false,MAXDISTANCE = 125,EMITTERSIZE = 10,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
		end
		GYRO.CFrame = CF(RIGHTARM.CFrame*CF(0,0.8,0).p,m.hit.p)*ANGLES(RAD(90),RAD(45),0)
	until MOUSEHOLD == false
	wait(0.1)
	GYRO:Remove()
	RIGHTSHOULDER.Parent = TORSO
	SMGGRIP.Parent = RIGHTARM
	SMGTIGHTGRIP.Parent = nil
	ATTACKING = false
end
function Boost()
	if HUM.WalkSpeed > 10 then
		BOOST = true
		USEDEFAULTANIMATIONS = false
		HUM.WalkSpeed = LOCKEDSPEED*2
		MOTOR.RightPipe.Fire.Enabled = true	
		MOTOR.LeftPipe.Fire.Enabled = true
		NewSound({ID = 142472270,PARENT = MOTOR,VOLUME = 10,PITCH = 1,LOOP = false,MAXDISTANCE = 125,EMITTERSIZE = 10,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
		for i=0, 4, 0.1 / ANIM_SPEED do
			Swait()
			local SPINVELOCITY = -ROOT.RotVelocity.Y/12.5
			ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,1.4,1.5)*ANGLES(RAD(35),RAD(0)-SPINVELOCITY/6,RAD(0)-SPINVELOCITY/2)*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
			NECK.C0 = Clerp(NECK.C0,CF(0,1.45,-0.3)*ANGLES(RAD(-30),RAD(0)-SPINVELOCITY/2,RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
			MOTORWELD.C0 = Clerp(MOTORWELD.C0,CF(0,-1.7,-0.5)*ANGLES(RAD(0),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
			RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.3,0.5,-0.3)*ANGLES(RAD(110),RAD(15),RAD(15))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
			SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0.2,-1.1,-0.4)*ANGLES(RAD(90),RAD(0),RAD(-160))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
			LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.4,-0.1)*ANGLES(RAD(64.6),RAD(-5),RAD(-5))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
			RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.7,-1.4,0.1)*ANGLES(RAD(-50),RAD(0),RAD(10))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
			LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.7,-1.4,0.1)*ANGLES(RAD(-50),RAD(0),RAD(-10))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
			if ROOT.Velocity.Magnitude <= 0.5 then
				break
			--[[else
				local HIT,POS = Raycast(ROOT.CFrame*CF(0,0,-3).p,ROOT.CFrame.lookVector,2.5,CHARACTER)
				if HIT then
					if HIT.Anchored == true then
						HUM.WalkSpeed = 0
						HUM.JumpPower = 0
						ROOT.CFrame = CF(VT(POS.X,ROOT.Position.Y,POS.Z),ROOT.Position)*ANGLES(0,RAD(180),0)*CF(0,0,2.2)
						ROOT.Anchored = true
						local VROT = NewSound({ID = 122292723,PARENT = ROOT,VOLUME = 1.5,PITCH = 3,LOOP = true,MAXDISTANCE = 125,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
						for i = 1, 200 do
							Swait()
							ROOT.CFrame = ROOT.CFrame * CF(0,1.5,0)
							ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,1.4,1.5)*ANGLES(RAD(90),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),2.5 / ANIM_SPEED)
							NECK.C0 = Clerp(NECK.C0,CF(0,1.45,-0.3)*ANGLES(RAD(-30),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
							MOTORWELD.C0 = Clerp(MOTORWELD.C0,CF(0,-1.7,-0.5)*ANGLES(RAD(0),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
							RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.3,0.5,-0.3)*ANGLES(RAD(110),RAD(15),RAD(15))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
							SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0.2,-1.1,-0.4)*ANGLES(RAD(90),RAD(0),RAD(-160))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
							LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.4,-0.1)*ANGLES(RAD(64.6),RAD(-5),RAD(-5))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
							RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.7,-1.4,0.1)*ANGLES(RAD(-50),RAD(0),RAD(10))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
							LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.7,-1.4,0.1)*ANGLES(RAD(-50),RAD(0),RAD(-10))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
							local HIT,POS = Raycast(ROOT.Position+VT(0,3,0),ROOT.CFrame.lookVector,2.5,CHARACTER)
							if HIT == nil then
								break
							end
						end
						VROT:Remove()
						ROOT.Anchored = false
						HUM.JumpPower = 85
						break
					end
				end]]
			end
		end
		MOTOR.RightPipe.Fire.Enabled = false	
		MOTOR.LeftPipe.Fire.Enabled = false
		USEDEFAULTANIMATIONS = true
		BOOST = false
	end
end
function Molotov()
	if ATTACKING == false then
		ATTACKING = true		
		USEDEFAULTANIMATIONS = false
		NewSound({ID = 2764683507,PARENT = ROOT,VOLUME = 5,PITCH = 1,LOOP = false,MAXDISTANCE = 125,EMITTERSIZE = 35,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
		for i=0, 0.1, 0.1 / ANIM_SPEED do
			Swait()
			ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,1.3,-0.5)*ANGLES(RAD(-20),RAD(10),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			NECK.C0 = Clerp(NECK.C0,CF(0,1.5,0.1)*ANGLES(RAD(15.2),RAD(-9.7),RAD(2.6))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			MOTORWELD.C0 = Clerp(MOTORWELD.C0,CF(0.1,-2.5,-0.4)*ANGLES(RAD(20.3),RAD(-9.4),RAD(3.5))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.5,1.1,-0.7)*ANGLES(RAD(119.3),RAD(6.7),RAD(13.4))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0.6,-1.1,-0.5)*ANGLES(RAD(90),RAD(0),RAD(-155))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.2,-0.1)*ANGLES(RAD(30.4),RAD(-8.6),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.8,-2,-0.2)*ANGLES(RAD(-20.9),RAD(-5.1),RAD(11.1))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.7,-2,-0.2)*ANGLES(RAD(-29.6),RAD(-3.7),RAD(-8.6))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
		end
		local MOLOTOV = MOLOTOVPROP:Clone()
		MOLOTOV.CanCollide = false
		MOLOTOV.Parent = Effects
		MOLOTOV.CFrame = CF(RIGHTARM.Position,m.hit.p)*ANGLES(RAD(45),0,0)
		MOLOTOV.Anchored = false
		local IMPACT = false
		local FORCE = 15 + (MOLOTOV.Position-m.hit.p).Magnitude
		if FORCE > 300 then
			FORCE = 300
		end
		local BV = IT("BodyVelocity")
		BV.MaxForce = BV.MaxForce * 500
		BV.Velocity = CF(MOLOTOV.Position,m.hit.p+VT(0,6,0)).lookVector*FORCE
		BV.Parent = MOLOTOV
		Debris:AddItem(BV,0.05)
		MOLOTOV.RotVelocity = VT(MRANDOM(-5,5),MRANDOM(-5,5),MRANDOM(-5,5))
		wait(0.1)
		MOLOTOV.CanCollide = true
		local BOOM = function(CHECKMODEL)
			if IMPACT == false then
				IMPACT = true
				local FLOOR,POS = Raycast(MOLOTOV.Position+VT(0,5,0),CF(VT(0,0,0),VT(0,-1,0)).lookVector,12,{CHARACTER,CHECKMODEL})
				if FLOOR then
					CameraShake(POS,35,5,6)
					for i = 1, MRANDOM(3,5) do
						coroutine.resume(coroutine.create(function()
							local FIRE = CreatePart(3,Effects,"Neon",0,1,"Grey","Fire",VT(10,2,10),true)
							FIRE.CFrame = CF(POS)*ANGLES(0,RAD(MRANDOM(0,359)),0)*CF(0,0,(i-1)*5)
							NewSound({ID = 3303579709,PARENT = FIRE,VOLUME = 6,PITCH = MRANDOM(8,12)/10,LOOP = false,MAXDISTANCE = 125,EMITTERSIZE = 35,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
							local BURN = script.AoEFire:Clone()
							BURN.Parent = FIRE
							BURN.Enabled = true
							local TOUCH = FIRE.Touched:Connect(function(HIT)
								if HIT.Parent:FindFirstChildOfClass("Humanoid") and HIT.Parent ~= CHARACTER and HIT.Parent:FindFirstChild("Roadrogue") == nil then
									if HIT.Parent:FindFirstChildOfClass("Humanoid").Health > 0 then
										NewSound({ID = 3303579709,PARENT = HIT,VOLUME = 3,PITCH = 1,LOOP = false,MAXDISTANCE = 125,EMITTERSIZE = 35,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
										for index, CHILD in pairs(HIT.Parent:GetChildren()) do
											if CHILD:IsA("BasePart") and CHILD:FindFirstChild("Fire") == nil then
												local FIRE = script.Fire:Clone()
												FIRE.Parent = CHILD
												FIRE.Enabled = true
											end
										end
									end
									----ManSlaughter(HIT.Parent)
								end
							end)
							wait(MRANDOM(90,175)/10)
							BURN.Enabled = false
							TOUCH:Disconnect()
							Debris:AddItem(FIRE,3)
						end))
					end
				end
				MOLOTOV.Transparency = 1
				MOLOTOV.Anchored = true
				MOLOTOV.CanCollide = false
				MOLOTOV.Head.Fire.Enabled = false
				Debris:AddItem(MOLOTOV,5)
				NewSound({ID = 156444949,PARENT = MOLOTOV,VOLUME = 7.5,PITCH = 1,LOOP = false,MAXDISTANCE = 125,EMITTERSIZE = 35,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			end
		end
		local HIT = MOLOTOV.Touched:Connect(function(PART)
			if PART.Anchored == true then
				local CHECKMODEL = nil
				if PART.Parent ~= workspace and PART.Anchored == false then
					CHECKMODEL = PART.Parent
				end
				BOOM(CHECKMODEL)
			end
		end)
		for i=0, 0.3, 0.1 / ANIM_SPEED do
			Swait()
			ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,1.3,-0.5)*ANGLES(RAD(-20),RAD(10),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			NECK.C0 = Clerp(NECK.C0,CF(0,1.5,0.1)*ANGLES(RAD(15.2),RAD(-9.7),RAD(2.6))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			MOTORWELD.C0 = Clerp(MOTORWELD.C0,CF(0.1,-2.5,-0.4)*ANGLES(RAD(20.3),RAD(-9.4),RAD(3.5))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.5,1.1,-0.7)*ANGLES(RAD(119.3),RAD(6.7),RAD(13.4))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0.6,-1.1,-0.5)*ANGLES(RAD(90),RAD(0),RAD(-155))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.2,-0.1)*ANGLES(RAD(30.4),RAD(-8.6),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.8,-2,-0.2)*ANGLES(RAD(-20.9),RAD(-5.1),RAD(11.1))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
			LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.7,-2,-0.2)*ANGLES(RAD(-29.6),RAD(-3.7),RAD(-8.6))*ANGLES(RAD(0),RAD(0),RAD(0)),2.25 / ANIM_SPEED)
		end
		USEDEFAULTANIMATIONS = true
		ATTACKING = false
	end
end
function LooseBike()
	if ROOT.Velocity.Magnitude <= 1 then
		USEDEFAULTANIMATIONS = false
		ATTACKING = true
		BOOST = true
		HUM.WalkSpeed = 0
		HUM.JumpPower = 0
		for i = 1, 60 do
			Swait()
			ROOT.CFrame = ROOT.CFrame*ANGLES(0,RAD(-i/2),0)
			ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0.2,-0.6,0.5)*ANGLES(RAD(-3.5),RAD(3.5),RAD(-44.9))*ANGLES(RAD(0),RAD(0),RAD(0)),2 / ANIM_SPEED)
			NECK.C0 = Clerp(NECK.C0,CF(0,1.5,0)*ANGLES(RAD(5),RAD(45),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),2 / ANIM_SPEED)
			MOTORWELD.C0 = Clerp(MOTORWELD.C0,CF(0,-1.7,-0.6)*ANGLES(RAD(5),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),2 / ANIM_SPEED)
			RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.5,0.8,-0.2)*ANGLES(RAD(95),RAD(50),RAD(60))*ANGLES(RAD(0),RAD(0),RAD(0)),2 / ANIM_SPEED)
			SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0,-1.1,-0.5)*ANGLES(RAD(90),RAD(0),RAD(180))*ANGLES(RAD(0),RAD(0),RAD(0)),2 / ANIM_SPEED)
			LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.4,0)*ANGLES(RAD(60),RAD(-10),RAD(-5))*ANGLES(RAD(0),RAD(0),RAD(0)),2 / ANIM_SPEED)
			RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.7,-1.6,-0.3)*ANGLES(RAD(-20),RAD(0),RAD(10))*ANGLES(RAD(0),RAD(0),RAD(0)),2 / ANIM_SPEED)
			LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.7,-1.6,-0.3)*ANGLES(RAD(-20),RAD(0),RAD(-10))*ANGLES(RAD(0),RAD(0),RAD(0)),2 / ANIM_SPEED)
		end
		ROOT.CFrame = CF(ROOT.Position,VT(m.hit.p.X,ROOT.Position.Y,m.hit.p.Z))
		coroutine.resume(coroutine.create(function()
			local FAKEMOTOR = MOTOR:Clone()
			FAKEMOTOR.ManualWeld:Remove()
			FAKEMOTOR.CFrame = CF(MOTOR.Position,VT(m.hit.p.X,MOTOR.Position.Y+0.5,m.hit.p.Z))
			FAKEMOTOR.Anchored = true
			local DIDHIT = false
			FAKEMOTOR.RightPipe.Fire.Enabled = true
			FAKEMOTOR.LeftPipe.Fire.Enabled = true
			FAKEMOTOR.Dust.Dust.Enabled = true
			FAKEMOTOR.Parent = Effects
			local VROT = NewSound({ID = 122292723,PARENT = FAKEMOTOR,VOLUME = 1.5,PITCH = 3,LOOP = true,MAXDISTANCE = 125,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			NewSound({ID = 142472270,PARENT = FAKEMOTOR,VOLUME = 10,PITCH = 1,LOOP = false,MAXDISTANCE = 125,EMITTERSIZE = 35,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			for i = 1, 200 do
				Swait()
				local FLOOR,POS = Raycast(FAKEMOTOR.Position,CF(VT(0,0,0),VT(0,-1,0)).lookVector,5.5,CHARACTER)
				if FLOOR then
					FAKEMOTOR.CFrame = CF(FAKEMOTOR.Position.X,POS.Y+FAKEMOTOR.Size.Y/2,FAKEMOTOR.Position.Z)*ANGLES(0,RAD(FAKEMOTOR.Orientation.Y),0) * CF(0,0,-2.5)
					local HIT = Raycast(FAKEMOTOR.Position,FAKEMOTOR.CFrame.lookVector,2.6,CHARACTER)
					if HIT then
						DIDHIT = true
						break
					end
				else
					break
				end
			end
			VROT:Remove()
			if DIDHIT == true then
				FAKEMOTOR.Core.Core.Size = NumberSequence.new(10,25)
				FAKEMOTOR.Core.Dust:Emit(200)
				FAKEMOTOR.Core.Black:Emit(15)
				FAKEMOTOR.Core.Core:Emit(100)
				for index, CHILD in pairs(FAKEMOTOR:GetChildren()) do
					if CHILD.Name ~= "Core" then
						CHILD:Remove()
					end
				end
				local B = IT("Explosion")
				B.BlastPressure = 0
				B.BlastRadius = 50
				B.Parent = workspace
				B.Position = FAKEMOTOR.Position
				B.Hit:Connect(function(PART)
					if PART.Parent:FindFirstChildOfClass("Humanoid") == nil and PART.Parent.Parent:FindFirstChildOfClass("Humanoid") == nil then
						if PART.Anchored == false then
							PART:BreakJoints()
							local BV = IT("BodyVelocity")
							BV.MaxForce = BV.MaxForce * 500
							BV.Velocity = CF(FAKEMOTOR.Position,PART.Position+VT(0,5,0)).lookVector*MRANDOM(35,75)
							BV.Parent = PART
							Debris:AddItem(BV,0.5)
							if MRANDOM(1,3) == 1 then
								local FIRE = script.Fire:Clone()
								FIRE.Parent = PART
								FIRE.Enabled = true
							end
						end
					end
				end)
				CameraShake(FAKEMOTOR.Position,150,10,75)
				local VICTIMS = AreaOfEffect(FAKEMOTOR.Position,65,0,0,true)
				if #VICTIMS > 0 then
					for E = 1, #VICTIMS do
						local VROOT = VICTIMS[E][1]:FindFirstChild("Torso") or VICTIMS[E][1]:FindFirstChild("LowerTorso")
						if VROOT then
							local BV = IT("BodyVelocity")
							BV.MaxForce = BV.MaxForce * 500
							BV.Velocity = CF(FAKEMOTOR.Position,VROOT.Position+VT(0,5,0)).lookVector*MRANDOM(35,75)
							BV.Parent = VROOT
							Debris:AddItem(BV,0.5)
						end
						--ManSlaughter(VICTIMS[E][1])
						for index, CHILD in pairs(VICTIMS[E][1]:GetChildren()) do
							if CHILD:IsA("BasePart") and MRANDOM(1,3) == 1 then
								local FIRE = script.Fire:Clone()
								FIRE.Parent = CHILD
								FIRE.Enabled = true
							end
						end
					end
				end
				NewSound({ID = 243702774,PARENT = FAKEMOTOR,VOLUME = 7.5,PITCH = 1.5,LOOP = false,MAXDISTANCE = 550,EMITTERSIZE = 75,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
				FAKEMOTOR.Transparency = 1
				for i = 1, 2 do
					local WHEEL = BACKUPWHEEL:Clone()
					WHEEL.Parent = workspace
					WHEEL.CFrame = FAKEMOTOR.CFrame*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))
					WHEEL.RotVelocity = VT(MRANDOM(-5,5),MRANDOM(-5,5),MRANDOM(-5,5))
					local BV = IT("BodyVelocity")
					BV.MaxForce = BV.MaxForce * 500
					BV.Velocity = WHEEL.CFrame.lookVector*85
					BV.Parent = WHEEL
					Debris:AddItem(BV,0.12)
					Debris:AddItem(WHEEL,15)
				end
				Debris:AddItem(FAKEMOTOR,7.1)
			else
				FAKEMOTOR.CanCollide = true
				FAKEMOTOR.Parent = workspace
				FAKEMOTOR.Anchored = false
				FAKEMOTOR.Dust.Dust.Enabled = false
				FAKEMOTOR.RightPipe.Fire.Enabled = false
				FAKEMOTOR.LeftPipe.Fire.Enabled = false
				Debris:AddItem(FAKEMOTOR,15)
			end
		end))
		MOTOR.Transparency = 1
		FRONTWHEEL.Transparency = 1
		BACKWHEEL.Transparency = 1		
		for i=0, 0.4, 0.1 / ANIM_SPEED do
			Swait()
			ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,1.8,0.5)*ANGLES(RAD(10),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			NECK.C0 = Clerp(NECK.C0,CF(0,1.4,-0.4)*ANGLES(RAD(-25),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.4,-0.2,0.2)*ANGLES(RAD(20),RAD(-20),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0,-1.1,-0.5)*ANGLES(RAD(90),RAD(0),RAD(180))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.2,0)*ANGLES(RAD(-0.3),RAD(-2.6),RAD(-14.8))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.5,-1.5,-0.1)*ANGLES(RAD(-45),RAD(-5),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.5,-1.8,0.2)*ANGLES(RAD(-15),RAD(5),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
		end
		ATTACKING = false
		for i=0, 2, 0.1 / ANIM_SPEED do
			Swait()
			ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,-1,0.6)*ANGLES(RAD(-5),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1.35 / ANIM_SPEED)
			NECK.C0 = Clerp(NECK.C0,CF(0,1.5,0)*ANGLES(RAD(5),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1.35 / ANIM_SPEED)
			RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.5,-0.1,0)*ANGLES(RAD(24.9),RAD(1.7),RAD(4.7))*ANGLES(RAD(0),RAD(0),RAD(0)),1.35 / ANIM_SPEED)
			SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0,-1.1,-0.5)*ANGLES(RAD(90),RAD(0),RAD(-180))*ANGLES(RAD(0),RAD(0),RAD(0)),1.35 / ANIM_SPEED)
			LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-0.4,0.4,-1)*ANGLES(RAD(80.9),RAD(5.7),RAD(48.4))*ANGLES(RAD(0),RAD(0),RAD(0)),1.35 / ANIM_SPEED)
			RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.5,-0.9,-1.1)*ANGLES(RAD(-10),RAD(-10),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1.35 / ANIM_SPEED)
			LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.5,-1.5,0)*ANGLES(RAD(-60),RAD(10),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1.35 / ANIM_SPEED)
		end
		coroutine.resume(coroutine.create(function()
			for i = 1, 10 do
				Swait()
				MOTOR.Transparency = MOTOR.Transparency - 1/10
			end
			MOTOR.Transparency = 0
			FRONTWHEEL.Transparency = 0
			BACKWHEEL.Transparency = 0
		end))
		for i=0, 0.25, 0.1 / ANIM_SPEED do
			Swait()
			ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,1.8,0.5)*ANGLES(RAD(10),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			NECK.C0 = Clerp(NECK.C0,CF(0,1.4,-0.4)*ANGLES(RAD(-25),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.4,-0.2,0.2)*ANGLES(RAD(20),RAD(-20),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0,-1.1,-0.5)*ANGLES(RAD(90),RAD(0),RAD(180))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.2,0)*ANGLES(RAD(-0.3),RAD(-2.6),RAD(-14.8))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.5,-1.5,-0.1)*ANGLES(RAD(-45),RAD(-5),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
			LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.5,-1.8,0.2)*ANGLES(RAD(-15),RAD(5),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1 / ANIM_SPEED)
		end
		BOOST = false
		USEDEFAULTANIMATIONS = true
		HUM.WalkSpeed = 5
		HUM.JumpPower = 85
	end
end

function GrabBazooka()
	if HASBAZOOKAEQUIPPED == false then
		local ONCOOLDOWN = false
		NewSound({ID = 171140306,PARENT = ROOT,VOLUME = 1,PITCH = MRANDOM(9,11)/15,LOOP = false,MAXDISTANCE = 75,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
		HASBAZOOKAEQUIPPED = true
		BAZOOKAWELD.Part0 = RIGHTARM
		BAZOOKAWELD.C0 = CF(-0.4,-0.9,-0.7)*ANGLES(RAD(-88.7),RAD(4.8),RAD(-15.1))*ANGLES(RAD(0),RAD(0),RAD(0))
		local Fire = function()
			local LOCKONTOPART = nil
			if MOUSEHIT then
				local HUM = MOUSEHIT.Parent:FindFirstChildOfClass("Humanoid") or MOUSEHIT.Parent.Parent:FindFirstChildOfClass("Humanoid")
				if HUM then
					if HUM.Health > 0 and HUM.Torso then
						LOCKONTOPART = HUM.Torso
					end
				end
			end
			local GOTO = m.hit.p
			local ROCKET = MISILEPROP:Clone()
			ROCKET.Parent = Effects
			ROCKET.CFrame = CF(BAZOOKA.CFrame*CF(0,0,-2).p,GOTO)
			NewSound({ID = 440145223,PARENT = BAZOOKA,VOLUME = 5,PITCH = MRANDOM(9,11)/10,LOOP = false,MAXDISTANCE = 80,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			NewSound({ID = 440145223,PARENT = ROCKET,VOLUME = 5,PITCH = MRANDOM(9,11)/10,LOOP = false,MAXDISTANCE = 80,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			for i = 1, 200 do
				Swait()
				local HIT,POS = Raycast(ROCKET.Position,ROCKET.CFrame.lookVector,4,CHARACTER)
				if HIT then
					ROCKET.CFrame = CF(POS)
					break
				end
				if LOCKONTOPART then
					ROCKET.CFrame = Clerp(ROCKET.CFrame,CF(ROCKET.Position,LOCKONTOPART.Position),0.2)*CF(0,0,-2.25)
				else
					ROCKET.CFrame = ROCKET.CFrame*CF(0,0,-3)
				end
			end
			ROCKET.Transparency = 1
			ROCKET.Hind:Remove()
			ROCKET.CFrame = CF(ROCKET.Position)
			ROCKET.Size = VT(0,0,0)
			NewSound({ID = 142070127,PARENT = ROCKET,VOLUME = 7,PITCH = MRANDOM(8,12)/10,LOOP = false,MAXDISTANCE = 300,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
			local B = IT("Explosion")
			B.BlastPressure = 0
			B.BlastRadius = 15
			B.Position = ROCKET.Position
			B.Parent = workspace
			B.Hit:Connect(function(PART)
			if PART.Parent:FindFirstChildOfClass("Humanoid") == nil and PART.Parent.Parent:FindFirstChildOfClass("Humanoid") == nil then
					if PART.Anchored == false then
						PART:BreakJoints()
						local BV = IT("BodyVelocity")
						BV.MaxForce = BV.MaxForce * 500
						BV.Velocity = CF(ROCKET.Position,PART.Position+VT(0,5,0)).lookVector*MRANDOM(35,75)
						BV.Parent = PART
						Debris:AddItem(BV,0.5)
						if MRANDOM(1,3) == 1 then
							local FIRE = script.Fire:Clone()
							FIRE.Parent = PART
							FIRE.Enabled = true
						end
					end
				end
			end)
			CameraShake(ROCKET.Position,55,2,7)
			local VICTIMS = AreaOfEffect(ROCKET.Position,25,0,0,true)
			if #VICTIMS > 0 then
				for E = 1, #VICTIMS do
					local VROOT = VICTIMS[E][1]:FindFirstChild("Torso") or VICTIMS[E][1]:FindFirstChild("LowerTorso")
					if VROOT then
						local BV = IT("BodyVelocity")
						BV.MaxForce = BV.MaxForce * 500
						BV.Velocity = CF(ROCKET.Position,VROOT.Position+VT(0,5,0)).lookVector*MRANDOM(35,75)
						BV.Parent = VROOT
						Debris:AddItem(BV,0.5)
					end
					--ManSlaughter(VICTIMS[E][1])
					for index, CHILD in pairs(VICTIMS[E][1]:GetChildren()) do
						if CHILD:IsA("BasePart") and MRANDOM(1,3) == 1 then
							local FIRE = script.Fire:Clone()
							FIRE.Parent = CHILD
							FIRE.Enabled = true
						end
					end
				end
			end
			AreaOfEffect(ROCKET.Position,35,200,false)
			Debris:AddItem(ROCKET,2)
		end
		wait(0.5)
game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(KeyPressed)
 if KeyPressed == "v" and ATTACKING == false and USEDEFAULTANIMATIONS == true and HASBAZOOKAEQUIPPED == true then
					wait(0.1)
					NewSound({ID = 171140306,PARENT = ROOT,VOLUME = 1,PITCH = MRANDOM(9,11)/15,LOOP = false,MAXDISTANCE = 75,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
					HASBAZOOKAEQUIPPED = false
					BAZOOKAWELD.Part0 = TORSO
					BAZOOKAWELD.C0 = BC0

end
end)

game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function(KeyPressed)
	if ATTACKING == false then
	if HASBAZOOKAEQUIPPED == true and ONCOOLDOWN == false then
					ONCOOLDOWN = true
					RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.5,0.4,0.7)*ANGLES(RAD(90),RAD(15),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),2.5 / ANIM_SPEED)
					LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(0.5,0.3,-0.9)*ANGLES(RAD(91.4),RAD(-16.9),RAD(19.9))*ANGLES(RAD(0),RAD(0),RAD(0)),2.5 / ANIM_SPEED)
					coroutine.resume(coroutine.create(function()
						wait(0.25)
						ONCOOLDOWN = false
					end))
					Fire()
				end
			end
		end)
	end
end

--//====================================================\\--
--||                       WRAP
--\\====================================================//--

game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function(KeyPressed)
	if ATTACKING == false then
	if HASBAZOOKAEQUIPPED == false then
	MOUSEHOLD = true
	Fire()
end
end
end)

game.Players.LocalPlayer:GetMouse().Button1Up:Connect(function(KeyPressed)
	MOUSEHOLD = false
end)

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(KeyPressed)
 if KeyPressed == "z" and ATTACKING == false and HASBAZOOKAEQUIPPED == false then
	Boost()
end
end)

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(KeyPressed)
 if KeyPressed == "x" and ATTACKING == false and HASBAZOOKAEQUIPPED == false then
	Molotov()
end
end)

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(KeyPressed)
 if KeyPressed == "c" and ATTACKING == false and HASBAZOOKAEQUIPPED == false then
	LooseBike()
end
end)

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(KeyPressed)
 if KeyPressed == "v" and ATTACKING == false and USEDEFAULTANIMATIONS == true and HASBAZOOKAEQUIPPED == false then
	GrabBazooka()
end
end)

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(KeyPressed)
 if KeyPressed == "e" then
				if ROOT:FindFirstChild("BGM_MUSIC") then
					ROOT:FindFirstChild("BGM_MUSIC"):Remove()
				else
					local M = NewSound({ID = TRACKS[TRACK][1],PARENT = ROOT,VOLUME = TRACKS[TRACK][2],PITCH = 1,LOOP = true,MAXDISTANCE = 300,EMITTERSIZE = 300,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
					M.Name = "BGM_MUSIC"
				end
end
end)

--==============================================

local M = NewSound({ID = 2598781800,PARENT = ROOT,VOLUME = 2.75,PITCH = 1,LOOP = true,MAXDISTANCE = 300,EMITTERSIZE = 300,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
M.Name = "BGM_MUSIC"

HUM.Died:Connect(function()
	if MOTOR.Transparency == 0 then
		MOTORMODEL:BreakJoints()
		MOTOR.Anchored = true
		MOTOR.Transparency = 1
		MOTOR.CanCollide = false
		MOTOR.Core.Core.Size = NumberSequence.new(10,25)
		MOTOR.Core.Dust:Emit(200)
		MOTOR.Core.Black:Emit(15)
		MOTOR.Core.Core:Emit(100)
		for index, CHILD in pairs(MOTOR:GetChildren()) do
			if CHILD.Name ~= "Core" then
				CHILD:Remove()
			end
		end
		local B = IT("Explosion")
		B.BlastPressure = 0
		B.BlastRadius = 50
		B.Parent = workspace
		B.Position = MOTOR.Position
		B.Hit:Connect(function(PART)
			if PART.Parent:FindFirstChildOfClass("Humanoid") == nil and PART.Parent.Parent:FindFirstChildOfClass("Humanoid") == nil then
				if PART.Anchored == false then
					PART:BreakJoints()
					local BV = IT("BodyVelocity")
					BV.MaxForce = BV.MaxForce * 500
					BV.Velocity = CF(MOTOR.Position,PART.Position+VT(0,5,0)).lookVector*MRANDOM(35,75)
					BV.Parent = PART
					Debris:AddItem(BV,0.5)
					if MRANDOM(1,3) == 1 then
						local FIRE = script.Fire:Clone()
						FIRE.Parent = PART
						FIRE.Enabled = true
					end
				end
			end
		end)
		CameraShake(MOTOR.Position,150,10,75)
		local VICTIMS = AreaOfEffect(MOTOR.Position,65,0,0,true)
		if #VICTIMS > 0 then
			for E = 1, #VICTIMS do
				local VROOT = VICTIMS[E][1]:FindFirstChild("Torso") or VICTIMS[E][1]:FindFirstChild("LowerTorso")
				if VROOT then
					local BV = IT("BodyVelocity")
					BV.MaxForce = BV.MaxForce * 500
					BV.Velocity = CF(MOTOR.Position,VROOT.Position+VT(0,5,0)).lookVector*MRANDOM(35,75)
					BV.Parent = VROOT
					Debris:AddItem(BV,0.5)
				end
				--ManSlaughter(VICTIMS[E][1])
				for index, CHILD in pairs(VICTIMS[E][1]:GetChildren()) do
					if CHILD:IsA("BasePart") and MRANDOM(1,3) == 1 then
						local FIRE = script.Fire:Clone()
						FIRE.Parent = CHILD
						FIRE.Enabled = true
					end
				end
			end
		end
		NewSound({ID = 243702774,PARENT = MOTOR,VOLUME = 7.5,PITCH = 1.5,LOOP = false,MAXDISTANCE = 550,EMITTERSIZE = 75,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
		MOTOR.Transparency = 1
	else
		MOTOR:Remove()
	end
	DIED = true
	--ManSlaughter(CHARACTER)
	MOTOR.CanCollide = true
	MOTORHITBOX:Remove()
end)
HUM.HealthChanged:Connect(function()
	if DIED == false then
		HUM.PlatformStand = false
		HUM.MaxHealth = 3000
		HUM.Health = 3000
		HUM.Name = PLAYER.UserId
	end
end)
HUM.PlatformStand = false
HUM.MaxHealth = 3000
HUM.Health = 3000
HUM.Name = PLAYER.UserId
script.Parent = PLAYER.Backpack
HUM.WalkSpeed = 5
HUM.JumpPower = 85
while true do
	Swait()
	SINE = SINE + CHANGE
	if CHARACTER:FindFirstChild("Animate") then
		CHARACTER:FindFirstChild("Animate"):Destroy()
	end
	if CHARACTER:FindFirstChild("Sound") then
		CHARACTER:FindFirstChild("Sound"):Destroy()
	end
	for _,v in next, HUM:GetPlayingAnimationTracks() do
		v:Stop();
	end
	local TORSOVELOCITY = (ROOT.Velocity * VT(1, 0, 1)).magnitude
	local TORSOVERTICALVELOCITY = ROOT.Velocity.y
	local HITFLOOR = Raycast(ROOT.Position, (CF(ROOT.Position, ROOT.Position + VT(0, -1, 0))).lookVector, 4+HUM.HipHeight, CHARACTER)
	local WALKSPEEDVALUE = 4 / (HUM.WalkSpeed / 16)
	if ROOT:FindFirstChild("MOTORHUM") == nil then
		MOTORHUM = NewSound({ID = 122292723,PARENT = ROOT,VOLUME = 1.5,PITCH = 1,LOOP = true,MAXDISTANCE = 125,EMITTERSIZE = 15,PLAYING = true,PLAYONREMOVE = false,DOESDEBRIS = true})
		MOTORHUM.Name = "MOTORHUM"
	else
		if ROOT:FindFirstChild("MOTORHUM").Playing == false then
			ROOT:FindFirstChild("MOTORHUM").Playing = true
		end
	end
	local SPINVELOCITY = -ROOT.RotVelocity.Y/12.5
	if HASBAZOOKAEQUIPPED == true then
		RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.5,0.4,0.3)*ANGLES(RAD(90),RAD(15),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
		SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0,-1.1,0.2)*ANGLES(RAD(10),RAD(0),RAD(-180))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
		LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(0.5,0.3,-1.3)*ANGLES(RAD(91.4),RAD(-16.9),RAD(19.9))*ANGLES(RAD(0),RAD(0),RAD(0)),0.5 / ANIM_SPEED)
	end
	if TORSOVELOCITY > 0.5 then
		ANIM = "Drive"
	else
		ANIM = "Idle"
	end
	if HITFLOOR then
		if TORSOVELOCITY < 1 and HITFLOOR ~= nil then
			MOTOR.Dust.Dust.Enabled = false
			if USEDEFAULTANIMATIONS == true then
				ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(-0.6,0.2,0.6)*ANGLES(RAD(0),RAD(15),RAD(10))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
				NECK.C0 = Clerp(NECK.C0,CF(0,1.5,0)*ANGLES(RAD(0),RAD(-15),RAD(-5))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
				MOTORWELD.C0 = Clerp(MOTORWELD.C0,CF(0.5,-1.5,-0.5)*ANGLES(RAD(-2.7),RAD(-14.8),RAD(-5.3))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
				if HASBAZOOKAEQUIPPED == false then
					RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.4,0.3,0.4)*ANGLES(RAD(31.3),RAD(-39.9),RAD(55.5))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
					SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(-0.1,-1.1,-0.4)*ANGLES(RAD(98.3),RAD(-4.8),RAD(-168.1))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
					LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.3,-0.65)*ANGLES(RAD(89.9),RAD(-4.8),RAD(15))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
				end
				RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(1.2,-1.6,0.1)*ANGLES(RAD(-14.6),RAD(-11.9),RAD(-14.6))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
				LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.7,-2.2,0)*ANGLES(RAD(3.7),RAD(-1.1),RAD(-14.5))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
			end
		elseif TORSOVELOCITY > 1 and HITFLOOR ~= nil then
			MOTOR.Dust.Dust.Enabled = true
			if USEDEFAULTANIMATIONS == true then
				ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,0.5,0.5)*ANGLES(RAD(-15),RAD(0)-SPINVELOCITY/6,RAD(0)-SPINVELOCITY/2)*ANGLES(RAD(0),RAD(0),RAD(0)),0.4 / ANIM_SPEED)
				NECK.C0 = Clerp(NECK.C0,CF(0,1.425,0.1)*ANGLES(RAD(15),RAD(0)-SPINVELOCITY/2,RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),0.4 / ANIM_SPEED)
				MOTORWELD.C0 = Clerp(MOTORWELD.C0,CF(0,-1.5,-0.9)*ANGLES(RAD(15),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),0.4 / ANIM_SPEED)
				if HASBAZOOKAEQUIPPED == false then
					RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.7,0.1,-0.1)*ANGLES(RAD(47.7),RAD(-32.8),RAD(49.9))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
					SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0,-1.1,-0.5)*ANGLES(RAD(90),RAD(0),RAD(-180))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
					LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.5,0.3,0)*ANGLES(RAD(89.9),RAD(-4.8),RAD(-1.3))*ANGLES(RAD(0),RAD(0),RAD(0)),0.4 / ANIM_SPEED)
				end
				RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.7,-1.5,-0.6)*ANGLES(RAD(-15),RAD(0),RAD(10))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
				LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.7,-1.5,-0.6)*ANGLES(RAD(-15),RAD(0),RAD(-10))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
			end
		end
	else
		MOTOR.Dust.Dust.Enabled = false
		if USEDEFAULTANIMATIONS == true then
			ROOTJOINT.C0 = Clerp(ROOTJOINT.C0,CF(0,0.5,0.6)*ANGLES(RAD(10.2),RAD(9.8),RAD(-1.8))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
			NECK.C0 = Clerp(NECK.C0,CF(0,1.5,-0.3)*ANGLES(RAD(-15.1),RAD(-10),RAD(-0.9))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
			MOTORWELD.C0 = Clerp(MOTORWELD.C0,CF(0.1,-1.5,-0.3)*ANGLES(RAD(0.2),RAD(-9.8),RAD(1.8))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
			if HASBAZOOKAEQUIPPED == false then
				RIGHTSHOULDER.C0 = Clerp(RIGHTSHOULDER.C0,CF(1.3,0.4,-0.2)*ANGLES(RAD(146),RAD(32.6),RAD(13.5))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
				SMGGRIP.C0 = Clerp(SMGGRIP.C0,CF(0,-0.9,-0.4)*ANGLES(RAD(103.5),RAD(6.2),RAD(-178.6))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
				LEFTSHOULDER.C0 = Clerp(LEFTSHOULDER.C0,CF(-1.4,0.3,0)*ANGLES(RAD(75),RAD(0),RAD(0))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
			end
			RIGHTHIP.C0 = Clerp(RIGHTHIP.C0,CF(0.8,-1.6,0.1)*ANGLES(RAD(-40.2),RAD(-16.1),RAD(8))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
			LEFTHIP.C0 = Clerp(LEFTHIP.C0,CF(-0.8,-1.6,0)*ANGLES(RAD(-33.9),RAD(-1.7),RAD(-17.1))*ANGLES(RAD(0),RAD(0),RAD(0)),1.2 / ANIM_SPEED)
		end
	end
	for i = 1, #WHEELJOINTS do
		WHEELJOINTS[i].C1 = ANGLES(RAD((HUM.WalkSpeed-5)),0,0) * WHEELJOINTS[i].C1
	end
	if LOCKEDSPEED == 75 then
		MOTOR.Safelock.Light.Enabled = true
	else
		MOTOR.Safelock.Light.Enabled = false
	end
	if BOOST == false then
		if ANIM == "Drive" then
			if HUM.WalkSpeed < LOCKEDSPEED then
				HUM.WalkSpeed = HUM.WalkSpeed + 0.75
			else
				HUM.WalkSpeed = LOCKEDSPEED
			end
		else
			if HUM.WalkSpeed > 5 then
				HUM.WalkSpeed = HUM.WalkSpeed - 3.75
			else
				HUM.WalkSpeed = 5
			end
		end
	end
	MOTORHUM.Pitch = HUM.WalkSpeed/10
	if MOTORHUM.Pitch > 3.25 then
		MOTORHUM.Pitch = 3.25
	end
	HUM.Sit = false
	HUM.PlatformStand = false
end
