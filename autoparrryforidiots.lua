local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Consts
local Player = Players.LocalPlayer
local Chance = 100
local Enabled = false
local Modes = {
	Toggle = 0,
	Hold = 1
}
local Mode = Modes.Hold
local Key = Enum.KeyCode.R
local Master = true

-- Util
local function UID()
	return HttpService:GenerateGUID(false)
end

local function stroke(t)
	local f = Instance.new("UIStroke")
	f.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	f.Color = Color3.fromRGB(91, 91, 91)
	f.Parent = t
end

-- UI 🤡


local UI = {}

function UI:new()
	local keyListening = false
	
	
	local Retarded = Instance.new("ScreenGui")	
	local Main = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local TitleBar = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Label = Instance.new("TextLabel")
	local UIPadding = Instance.new("UIPadding")
	local Desc = Instance.new("TextLabel")
	local UIPadding_2 = Instance.new("UIPadding")
	local Content = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local Title = Instance.new("TextLabel")
	local UIPadding_3 = Instance.new("UIPadding")
	local Options = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding_4 = Instance.new("UIPadding")
	local Toggle = Instance.new("TextButton")
	local Hold = Instance.new("TextButton")
	local Enabled = Instance.new("Frame")
	local Btn = Instance.new("TextButton")
	local UICorner_5 = Instance.new("UICorner")
	local Keybind = Instance.new("TextLabel")
	local UICorner_6 = Instance.new("UICorner")
	local Chance = Instance.new("TextLabel")
	local TextBox = Instance.new("TextBox")
	local UICorner_7 = Instance.new("UICorner")
	local DropShadowHolder = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")
	

	local Status = Instance.new("TextLabel")
	local StatusC = Instance.new("UIStroke")


	Status.Name = UID()
	Status.Parent = Retarded
	Status.AnchorPoint = Vector2.new(0.5, 0.5)
	Status.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Status.BackgroundTransparency = 1.000
	Status.Position = UDim2.new(0.5, 100, 0.5, 0)
	Status.Size = UDim2.new(0, 100, 0, 14)
	Status.Font = Enum.Font.Ubuntu
	Status.Text = "NOT PARRYING"
	Status.TextColor3 = Color3.fromRGB(255, 0, 0)
	Status.TextSize = 12.000
	Status.TextXAlignment = Enum.TextXAlignment.Left
	
	StatusC.Parent = Status
	StatusC.Color = Color3.fromRGB(0, 0, 0)
	
	local fns = {}
	
	fns.E = Enabled

	function fns:toggle(t : boolean)
		Enabled = t
		fns.E = t
		Status.Text = Enabled and "TRYING TO PARRY" or "NOT PARRYING"
		Status.TextColor3 = Enabled and Color3.fromRGB(255, 136, 0) or Color3.fromRGB(255, 0, 0)
	end
	
	
	UserInputService.InputBegan:Connect(function(k, a)
		if a then return end
		if k.KeyCode ~= Enum.KeyCode.Escape and k.UserInputType == Enum.UserInputType.Keyboard and keyListening then
			Key = k.KeyCode
			keyListening = false
			Keybind.Text = Key and tostring(Key.Name) or "[NONE]"
		end
	end)
	
	
	stroke(Main)
	stroke(TitleBar)
	stroke(Content)
	stroke(Options)
	stroke(Btn)
	stroke(Keybind)
	stroke(TextBox)

	Retarded.Name = UID()
	Retarded.Parent = RunService:IsStudio() and Player.PlayerGui or CoreGui

	Main.Name = UID()
	Main.Parent = Retarded
	Main.AnchorPoint = Vector2.new(1,1)
	Main.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	Main.Position = UDim2.new(1,-10,1,-10)
	Main.Size = UDim2.new(0, 222, 0, 227)

	UICorner.Parent = Main

	TitleBar.Name = UID()
	TitleBar.Parent = Main
	TitleBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	TitleBar.Size = UDim2.new(1, 0, 0, 40)

	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = TitleBar

	Label.Name = UID()
	Label.Parent = TitleBar
	Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1.000
	Label.Position = UDim2.new(0, 0, 0, -1)
	Label.Size = UDim2.new(1, 0, 0.5, 0)
	Label.Font = Enum.Font.Ubuntu
	Label.Text = "<b>Auto Parry for idiots</b>"
	Label.RichText = true
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 14.000
	Label.TextXAlignment = Enum.TextXAlignment.Left

	UIPadding.Parent = TitleBar
	UIPadding.PaddingBottom = UDim.new(0, 8)
	UIPadding.PaddingLeft = UDim.new(0, 8)
	UIPadding.PaddingRight = UDim.new(0, 8)
	UIPadding.PaddingTop = UDim.new(0, 8)

	Desc.Name = UID()
	Desc.Parent = TitleBar
	Desc.AnchorPoint = Vector2.new(0, 1)
	Desc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Desc.BackgroundTransparency = 1.000
	Desc.Position = UDim2.new(0, 0, 1, 2)
	Desc.Size = UDim2.new(1, 0, 0.5, 0)
	Desc.Font = Enum.Font.Ubuntu
	Desc.Text = "unable 🤡"
	Desc.TextColor3 = Color3.fromRGB(255, 255, 255)
	Desc.TextSize = 14.000
	Desc.TextXAlignment = Enum.TextXAlignment.Left

	UIPadding_2.Parent = Main
	UIPadding_2.PaddingBottom = UDim.new(0, 8)
	UIPadding_2.PaddingLeft = UDim.new(0, 8)
	UIPadding_2.PaddingRight = UDim.new(0, 8)
	UIPadding_2.PaddingTop = UDim.new(0, 8)

	Content.Name =UID()
	Content.Parent = Main
	Content.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
	Content.Position = UDim2.new(0, 0, 0, 48)
	Content.Size = UDim2.new(1, 0, 1, -48)

	UICorner_3.CornerRadius = UDim.new(0, 4)
	UICorner_3.Parent = Content

	Title.Name = UID()
	Title.Parent = Content
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Size = UDim2.new(1, 0, 0, 20)
	Title.Font = Enum.Font.Ubuntu
	Title.Text = "Auto Parry"
	Title.TextColor3 = Color3.fromRGB(197, 197, 197)
	Title.TextSize = 14.000

	UIPadding_3.Parent = Content
	UIPadding_3.PaddingBottom = UDim.new(0, 8)
	UIPadding_3.PaddingLeft = UDim.new(0, 8)
	UIPadding_3.PaddingRight = UDim.new(0, 8)
	UIPadding_3.PaddingTop = UDim.new(0, 8)

	Options.Name = UID()
	Options.Parent = Content
	Options.AnchorPoint = Vector2.new(0.5, 0)
	Options.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Options.Position = UDim2.new(0.5, 0, 0, 24)
	Options.Size = UDim2.new(0.699999988, 0, 0, 40)

	UICorner_4.CornerRadius = UDim.new(0, 4)
	UICorner_4.Parent = Options

	UIListLayout.Parent = Options
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UIPadding_4.Parent = Options
	UIPadding_4.PaddingBottom = UDim.new(0, 4)
	UIPadding_4.PaddingTop = UDim.new(0, 4)

	Toggle.Name = UID()
	Toggle.Parent = Options
	Toggle.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	Toggle.BorderSizePixel = 0
	Toggle.Size = UDim2.new(1, 0, 0, 16)
	Toggle.Font = Enum.Font.Ubuntu
	Toggle.Text = "Toggle"
	Toggle.TextColor3 = Color3.fromRGB(184, 184, 184)
	Toggle.TextSize = 12.000
	Toggle.MouseButton1Click:Connect(function()
		Hold.TextColor3 = Color3.fromRGB(184, 184, 184)
		Toggle.TextColor3 = Color3.fromRGB(255, 167, 15)
		Mode = Modes.Toggle
	end)

	Hold.Name = UID()
	Hold.Parent = Options
	Hold.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	Hold.BorderSizePixel = 0
	Hold.Size = UDim2.new(1, 0, 0, 16)
	Hold.Font = Enum.Font.Ubuntu
	Hold.Text = "Hold"
	Hold.TextColor3 = Color3.fromRGB(255, 167, 15)
	Hold.TextSize = 12.000
	Hold.MouseButton1Click:Connect(function()
		Hold.TextColor3 = Color3.fromRGB(255, 167, 15)
		Toggle.TextColor3 = Color3.fromRGB(184, 184, 184)
		Mode = Modes.Hold
	end)

	Enabled.Name = "Disabled"
	Enabled.Parent = Content
	Enabled.AnchorPoint = Vector2.new(0.5, 1)
	Enabled.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	Enabled.BackgroundTransparency = 1.000
	Enabled.Position = UDim2.new(0.5, 0, 1, 0)
	Enabled.Size = UDim2.new(0.649999976, 0, 0, 20)

	Btn.Name = UID()
	Btn.Parent = Enabled
	Btn.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	Btn.Size = UDim2.new(1, -48, 1, 0)
	Btn.Font = Enum.Font.Ubuntu
	Btn.Text = "Enabled"
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 12.000
	Btn.MouseButton1Click:Connect(function()
		Master = not Master
		Btn.Text = Master and "Enabled" or "Disabled"
	end)

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = Btn

	Keybind.Name = UID()
	Keybind.Parent = Enabled
	Keybind.AnchorPoint = Vector2.new(1, 0)
	Keybind.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	Keybind.ClipsDescendants = true
	Keybind.Position = UDim2.new(1, 0, 0, 0)
	Keybind.Size = UDim2.new(0, 40, 0, 20)
	Keybind.Font = Enum.Font.Ubuntu
	Keybind.Text = Key.Name
	Keybind.TextColor3 = Color3.fromRGB(220, 220, 220)
	Keybind.TextSize = 10.000
	Keybind.InputBegan:Connect(function(k)
		if k.UserInputType == Enum.UserInputType.MouseButton1 then
			Keybind.Text = "[NONE]"
			keyListening = true
		end
	end)

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = Keybind

	Chance.Name = UID()
	Chance.Parent = Content
	Chance.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Chance.BackgroundTransparency = 1.000
	Chance.Position = UDim2.new(0, 0, 0, 70)
	Chance.Size = UDim2.new(1, 0, 0, 12)
	Chance.Font = Enum.Font.Ubuntu
	Chance.Text = "Chance %"
	Chance.TextColor3 = Color3.fromRGB(197, 197, 197)
	Chance.TextSize = 12.000

	TextBox.Parent = Content
	TextBox.AnchorPoint = Vector2.new(0.5, 0)
	TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TextBox.Position = UDim2.new(0.5, 0, 0, 87)
	TextBox.Size = UDim2.new(0.5, 0, 0, 20)
	TextBox.Font = Enum.Font.Ubuntu
	TextBox.Text = "100"
	TextBox.PlaceholderText = "number pls :3"
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 12.000
	TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		if tonumber(TextBox.Text) then
			local v = math.clamp(tonumber(TextBox.Text), 0, 100)
			Chance = v
			TextBox.Text = v
		end
	end)
	TextBox.FocusLost:Connect(function()
		if TextBox.Text == "" then
			TextBox.Text = "100"
			Chance = 100
		end
	end)

	UICorner_7.CornerRadius = UDim.new(0, 4)
	UICorner_7.Parent = TextBox

	DropShadowHolder.Name = UID()
	DropShadowHolder.Parent = Main
	DropShadowHolder.BackgroundTransparency = 1.000
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder.ZIndex = 0

	DropShadow.Name = UID()
	DropShadow.Parent = DropShadowHolder
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 64, 1, 64)
	DropShadow.ZIndex = 0
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.500
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	
	local function drag()
		local dragging
		local dragInput
		local dragStart
		local startPos

		local function update(input)
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end

		Main.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = Main.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		Main.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end
	
	drag()
	
	
	return fns
end

local ui = UI:new()

-- actual bruh
local animationInfo = {}

function getInfo(id)
	local success, info = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(id)
	end)
	if success then
		return info
	end
	return {Name=''}
end

function block(player)
	if ui.E and Master then
		if Chance >= 100 then
		    print("hitting")
			keypress(0x46)
			wait()
			keyrelease(0x46)
		else
		    
			local t = math.random(1, 100)
			print("hitting with chance ", (100-Chance), t)
			if (100-Chance) <= t then
				keypress(0x46)
				wait()
				keyrelease(0x46)
			end
		end
	end
end

local AnimNames = {
	'Slash',
	'Swing',
	'Sword'
}

function playerAdded(v)
	local function charadded(char)
		local humanoid = char:WaitForChild("Humanoid", 5)
		if humanoid then
			humanoid.AnimationPlayed:Connect(function(track)
				local info = animationInfo[track.Animation.AnimationId]
				if not info then
					info = getInfo(tonumber(track.Animation.AnimationId:match("%d+")))
					animationInfo[track.Animation.AnimationId] = info
				end

				if (Player.Character and Player.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Head")) then
					local mag = (v.Character.Head.Position - Player.Character.Head.Position).Magnitude
					if mag < 20  then

						for _, animName in pairs(AnimNames) do
							if info.Name:match(animName) then
								pcall(block, v)
							end
						end

					end
				end
			end)
		end
	end

	if v.Character then
		charadded(v.Character)
	end
	v.CharacterAdded:Connect(charadded)
end

for i,v in pairs(Players:GetPlayers()) do
	if v ~= Player then
		playerAdded(v)
	end
end

UserInputService.InputBegan:Connect(function(a, b)
	if b then return end
	if a.KeyCode == Key then
		if Mode == Modes.Toggle then
			ui:toggle(not ui.E)
		else
			ui:toggle(true)
		end
	end
end)

UserInputService.InputEnded:Connect(function(a, b)
	if b then return end
	if a.KeyCode == Key then
		if Mode == Modes.Hold then
			ui:toggle(false)
		end
	end
end)

Players.PlayerAdded:Connect(playerAdded)