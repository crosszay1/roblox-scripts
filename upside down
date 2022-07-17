local lp = game:GetService("Players").LocalPlayer
local c = lp.Character
local hrp0 = c:FindFirstChild("HumanoidRootPart")
local hrp1 = hrp0:Clone()
c.Parent = nil
hrp0.Parent = hrp1
hrp0.RootJoint.Part0 = nil
hrp1.Parent = c
c.Parent = workspace
local h = game:GetService("RunService").Heartbeat
hrp0.Transparency = 0.5
while h:Wait() and c and c.Parent do
    hrp0.CFrame = hrp1.CFrame
    hrp0.Orientation += Vector3.new(0, 0, 180)
    hrp0.Position -= Vector3.new(0, 1, 0)
    hrp0.Velocity = hrp1.Velocity
end
