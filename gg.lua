-- USED AI TO MAKE IT BETTER
-- CREDITS TO CLAUE & SOMEONES SRC
-- USED AI TO MAKE IT WORK BETTER DO NOT HATE
-- YALL CAN TAKE THE SRC AND MAKE IT BETTER



local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local sharedEnv = type(getgenv) == "function" and getgenv() or _G
sharedEnv.WalkyUISession = (sharedEnv.WalkyUISession or 0) + 1
local SCRIPT_SESSION = sharedEnv.WalkyUISession

local function isSessionActive()
	return sharedEnv.WalkyUISession == SCRIPT_SESSION
end

local KrassUI = {}

local DEFAULT_THEME = {
	Background = Color3.fromRGB(9, 11, 16),
	Panel = Color3.fromRGB(18, 21, 29),
	Panel2 = Color3.fromRGB(25, 29, 39),
	Panel3 = Color3.fromRGB(34, 39, 52),
	Text = Color3.fromRGB(245, 248, 252),
	Muted = Color3.fromRGB(145, 154, 170),
	Accent = Color3.fromRGB(145, 160, 255),
	Accent2 = Color3.fromRGB(95, 105, 255),
	Danger = Color3.fromRGB(255, 75, 95),
	Stroke = Color3.fromRGB(57, 65, 82),
	DarkText = Color3.fromRGB(5, 10, 13),
	Shadow = Color3.fromRGB(0, 0, 0),
}

local THEME_PRESETS = {
	Black = {
		Background = Color3.fromRGB(8, 9, 13),
		Panel = Color3.fromRGB(17, 19, 26),
		Panel2 = Color3.fromRGB(24, 27, 36),
		Panel3 = Color3.fromRGB(34, 38, 50),
		Text = Color3.fromRGB(244, 246, 250),
		Muted = Color3.fromRGB(145, 153, 166),
		Accent = Color3.fromRGB(145, 160, 255),
		Accent2 = Color3.fromRGB(95, 105, 255),
		Danger = Color3.fromRGB(255, 75, 95),
		Stroke = Color3.fromRGB(58, 64, 80),
		DarkText = Color3.fromRGB(5, 7, 10),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Pink = {
		Background = Color3.fromRGB(18, 10, 18),
		Panel = Color3.fromRGB(29, 17, 31),
		Panel2 = Color3.fromRGB(42, 24, 45),
		Panel3 = Color3.fromRGB(57, 31, 61),
		Text = Color3.fromRGB(255, 244, 252),
		Muted = Color3.fromRGB(211, 162, 199),
		Accent = Color3.fromRGB(255, 95, 190),
		Accent2 = Color3.fromRGB(195, 80, 255),
		Danger = Color3.fromRGB(255, 77, 119),
		Stroke = Color3.fromRGB(90, 52, 91),
		DarkText = Color3.fromRGB(24, 5, 18),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Red = {
		Background = Color3.fromRGB(18, 9, 10),
		Panel = Color3.fromRGB(31, 17, 18),
		Panel2 = Color3.fromRGB(43, 23, 25),
		Panel3 = Color3.fromRGB(61, 31, 34),
		Text = Color3.fromRGB(255, 245, 245),
		Muted = Color3.fromRGB(216, 157, 159),
		Accent = Color3.fromRGB(255, 70, 82),
		Accent2 = Color3.fromRGB(255, 135, 68),
		Danger = Color3.fromRGB(255, 58, 72),
		Stroke = Color3.fromRGB(93, 50, 53),
		DarkText = Color3.fromRGB(25, 4, 6),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	White = {
		Background = Color3.fromRGB(242, 244, 248),
		Panel = Color3.fromRGB(255, 255, 255),
		Panel2 = Color3.fromRGB(232, 236, 244),
		Panel3 = Color3.fromRGB(216, 222, 234),
		Text = Color3.fromRGB(22, 26, 34),
		Muted = Color3.fromRGB(94, 105, 123),
		Accent = Color3.fromRGB(75, 95, 245),
		Accent2 = Color3.fromRGB(150, 85, 255),
		Danger = Color3.fromRGB(230, 55, 73),
		Stroke = Color3.fromRGB(190, 198, 214),
		DarkText = Color3.fromRGB(255, 255, 255),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
}

KrassUI.Themes = THEME_PRESETS

local function mergeTheme(overrides)
	local theme = {}
	for key, value in pairs(DEFAULT_THEME) do
		theme[key] = value
	end
	for key, value in pairs(overrides or {}) do
		theme[key] = value
	end
	return theme
end

local function new(className, props, children)
	local instance = Instance.new(className)
	for key, value in pairs(props or {}) do
		instance[key] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = instance
	end
	return instance
end

local function tween(instance, goal, time, style, direction)
	local info = TweenInfo.new(
		time or 0.18,
		style or Enum.EasingStyle.Quint,
		direction or Enum.EasingDirection.Out
	)
	local active = TweenService:Create(instance, info, goal)
	active:Play()
	return active
end

local function corner(radius)
	return new("UICorner", {
		CornerRadius = UDim.new(0, radius),
	})
end

local function stroke(color, thickness, transparency)
	return new("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
	})
end

local function padding(value)
	return new("UIPadding", {
		PaddingBottom = UDim.new(0, value),
		PaddingLeft = UDim.new(0, value),
		PaddingRight = UDim.new(0, value),
		PaddingTop = UDim.new(0, value),
	})
end

local function list(spacing)
	return new("UIListLayout", {
		Padding = UDim.new(0, spacing),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
end

local function makeLabel(parent, text, size, color, bold)
	return new("TextLabel", {
		BackgroundTransparency = 1,
		Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
		Parent = parent,
		Text = text,
		TextColor3 = color,
		TextSize = size,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	})
end

local function makeButton(parent, text, color, textColor)
	return new("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Font = Enum.Font.GothamSemibold,
		Parent = parent,
		Text = text or "",
		TextColor3 = textColor,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Center,
	})
end

local function gradient(parent, colorA, colorB, rotation)
	local item = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, colorA),
			ColorSequenceKeypoint.new(1, colorB),
		}),
		Rotation = rotation or 0,
		Parent = parent,
	})
	return item
end

local function animateGradient(item, speed)
	task.spawn(function()
		while item.Parent do
			item.Rotation = 0
			tween(item, { Rotation = 360 }, speed or 5, Enum.EasingStyle.Linear)
			task.wait(speed or 5)
		end
	end)
end

local function ripple(button, x, y, color)
	x = x or (button.AbsolutePosition.X + button.AbsoluteSize.X / 2)
	y = y or (button.AbsolutePosition.Y + button.AbsoluteSize.Y / 2)
	local localX = x - button.AbsolutePosition.X
	local localY = y - button.AbsolutePosition.Y
	local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.8

	local circle = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color,
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Parent = button,
		Position = UDim2.fromOffset(localX, localY),
		Size = UDim2.fromOffset(0, 0),
		ZIndex = button.ZIndex + 8,
	})
	corner(999).Parent = circle

	tween(circle, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(maxSize, maxSize),
	}, 0.42, Enum.EasingStyle.Quint).Completed:Once(function()
		circle:Destroy()
	end)
end

local function pressable(hit, visual, border, theme, callback)
	local normal = visual.BackgroundColor3
	local hover = theme.Panel3
	local visualScale = visual:FindFirstChildOfClass("UIScale")

	hit.MouseEnter:Connect(function()
		tween(visual, { BackgroundColor3 = hover }, 0.15)
		if border then
			tween(border, {
				Color = theme.Accent,
				Transparency = 0.25,
			}, 0.15)
		end
	end)

	hit.MouseLeave:Connect(function()
		tween(visual, { BackgroundColor3 = normal }, 0.15)
		if visualScale then
			tween(visualScale, { Scale = 1 }, 0.18, Enum.EasingStyle.Back)
		end
		if border then
			tween(border, {
				Color = theme.Stroke,
				Transparency = 0.45,
			}, 0.15)
		end
	end)

	hit.MouseButton1Down:Connect(function(x, y)
		if visualScale then
			tween(visualScale, { Scale = 0.985 }, 0.08, Enum.EasingStyle.Quad)
		end
		ripple(hit, x, y, theme.Accent)
	end)

	hit.MouseButton1Up:Connect(function()
		if visualScale then
			tween(visualScale, { Scale = 1 }, 0.24, Enum.EasingStyle.Back)
		end
	end)

	hit.MouseButton1Click:Connect(function()
		if callback then
			task.spawn(callback)
		end
	end)
end

local function makeDraggable(frame, handle, tracker)
	local dragging = false
	local dragStart = nil
	local startPos = nil

	local function connect(signal, callback)
		if tracker and tracker._connect then
			return tracker:_connect(signal, callback)
		end
		return signal:Connect(callback)
	end

	connect(handle.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end)

	connect(UserInputService.InputChanged, function(input)
		if not dragging or not dragStart or not startPos then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end)
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local Control = {}
Control.__index = Control

function Window:_connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(self.Connections, connection)
	return connection
end

function KrassUI.new(config)
	config = config or {}
	local selectedTheme = nil
	if type(config.Theme) == "string" then
		selectedTheme = THEME_PRESETS[config.Theme]
	elseif type(config.ThemeName) == "string" then
		selectedTheme = THEME_PRESETS[config.ThemeName]
	end
	local theme = mergeTheme(selectedTheme or (type(config.Theme) == "table" and config.Theme or nil))
	theme.Accent = config.Accent or theme.Accent
	theme.Accent2 = config.Accent2 or theme.Accent2

	local guiName = config.GuiName or "WalkyUI_Tycoon"
	local oldGui = PlayerGui:FindFirstChild(guiName)
	if oldGui and config.ClearOld ~= false then
		oldGui:Destroy()
	end
	local oldBlur = Lighting:FindFirstChild(guiName .. "_Blur")
	if oldBlur and config.ClearOld ~= false then
		oldBlur:Destroy()
	end

	local gui = new("ScreenGui", {
		DisplayOrder = config.DisplayOrder or 999,
		IgnoreGuiInset = true,
		Name = guiName,
		Parent = PlayerGui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})

	local blur = nil
	local blurTarget = config.BlurSize or 12
	if config.Blur ~= false then
		blur = Lighting:FindFirstChild(guiName .. "_Blur")
		if not blur then
			blur = new("BlurEffect", {
				Name = guiName .. "_Blur",
				Size = 0,
				Parent = Lighting,
			})
		end
	end

	local baseSize = config.Size or UDim2.fromOffset(690, 450)
	local holder = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = gui,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = baseSize,
	})

	local scale = new("UIScale", {
		Parent = holder,
		Scale = 0.84,
	})

	local shadow = new("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageColor3 = theme.Shadow or Color3.fromRGB(0, 0, 0),
		ImageTransparency = 1,
		Parent = holder,
		Position = UDim2.fromOffset(-48, -48),
		ScaleType = Enum.ScaleType.Slice,
		Size = UDim2.new(1, 96, 1, 96),
		SliceCenter = Rect.new(10, 10, 118, 118),
		Visible = false,
		ZIndex = 0,
	})

	local root = new("Frame", {
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = holder,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
	})
	corner(12).Parent = root
	local rootStroke = stroke(theme.Stroke, 1, 0.12)
	rootStroke.Parent = root

	local accentRail = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = root,
		Size = UDim2.new(1, 0, 0, 3),
		ZIndex = 4,
	})
	local railGradient = gradient(accentRail, theme.Accent, theme.Accent2, 0)
	animateGradient(railGradient, 4)

	local shine = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Parent = root,
		Position = UDim2.new(-0.35, 0, 0, 0),
		Rotation = 16,
		Size = UDim2.new(0.18, 0, 1.35, 0),
		ZIndex = 6,
	})
	gradient(shine, Color3.fromRGB(255, 255, 255), theme.Accent, 90)
	task.spawn(function()
		while shine.Parent do
			shine.Position = UDim2.new(-0.35, 0, -0.18, 0)
			shine.BackgroundTransparency = 0.92
			tween(shine, {
				BackgroundTransparency = 1,
				Position = UDim2.new(1.18, 0, -0.18, 0),
			}, 1.15, Enum.EasingStyle.Quint)
			task.wait(4.4)
		end
	end)

	local topbar = new("Frame", {
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Parent = root,
		Position = UDim2.fromOffset(0, 3),
		Size = UDim2.new(1, 0, 0, 54),
		ZIndex = 3,
	})

	local title = makeLabel(topbar, config.Name or "Krass Tycoon Hub", 17, theme.Text, true)
	title.Position = UDim2.fromOffset(18, 7)
	title.Size = UDim2.new(1, -160, 0, 24)
	title.ZIndex = 4

	local subtitle = makeLabel(topbar, config.Subtitle or "TYCOON AUTOFARM", 11, theme.Muted, false)
	subtitle.Position = UDim2.fromOffset(18, 29)
	subtitle.Size = UDim2.new(1, -160, 0, 18)
	subtitle.ZIndex = 4

	local close = makeButton(topbar, "X", theme.Panel2, theme.Muted)
	close.Position = UDim2.new(1, -44, 0, 11)
	close.Size = UDim2.fromOffset(32, 32)
	close.ZIndex = 5
	corner(8).Parent = close

	local minimize = makeButton(topbar, "-", theme.Panel2, theme.Muted)
	minimize.Position = UDim2.new(1, -82, 0, 11)
	minimize.Size = UDim2.fromOffset(32, 32)
	minimize.ZIndex = 5
	corner(8).Parent = minimize

	local sidebar = new("Frame", {
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Parent = root,
		Position = UDim2.fromOffset(0, 57),
		Size = UDim2.new(0, 166, 1, -57),
		ZIndex = 3,
	})
	padding(12).Parent = sidebar
	list(8).Parent = sidebar

	local pageHolder = new("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = root,
		Position = UDim2.fromOffset(166, 57),
		Size = UDim2.new(1, -166, 1, -57),
		ZIndex = 3,
	})

	local toastHolder = new("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Parent = gui,
		Position = UDim2.new(1, -18, 0, 18),
		Size = UDim2.fromOffset(320, 330),
		ZIndex = 50,
	})
	list(9).Parent = toastHolder

	local openButton = new("ImageButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		AutoButtonColor = false,
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Image = "",
		Parent = gui,
		Position = UDim2.new(1, -14, 0.5, 0),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromOffset(58, 58),
		Visible = false,
		ZIndex = 61,
	})
	corner(999).Parent = openButton
	local openButtonStroke = stroke(theme.Accent, 2, 0.05)
	openButtonStroke.Parent = openButton
	local openButtonScale = new("UIScale", {
		Parent = openButton,
		Scale = 0.72,
	})
	local openButtonFallback = makeLabel(openButton, "K", 22, theme.Text, true)
	openButtonFallback.Size = UDim2.fromScale(1, 1)
	openButtonFallback.TextXAlignment = Enum.TextXAlignment.Center
	openButtonFallback.ZIndex = 62
	local openButtonGloss = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Parent = openButton,
		Position = UDim2.fromScale(-0.15, -0.1),
		Rotation = 18,
		Size = UDim2.fromScale(0.28, 1.25),
		ZIndex = 63,
	})
	gradient(openButtonGloss, Color3.fromRGB(255, 255, 255), theme.Accent, 90)

	local self = setmetatable({
		Blur = blur,
		BlurTarget = blurTarget,
		Gui = gui,
		Holder = holder,
		Root = root,
		RootStroke = rootStroke,
		Scale = scale,
		Shadow = shadow,
		Topbar = topbar,
		Title = title,
		Subtitle = subtitle,
		CloseButton = close,
		MinimizeButton = minimize,
		Sidebar = sidebar,
		PageHolder = pageHolder,
		BaseSize = baseSize,
		OpenButton = openButton,
		OpenButtonScale = openButtonScale,
		OpenButtonStroke = openButtonStroke,
		OpenButtonFallback = openButtonFallback,
		OpenButtonGloss = openButtonGloss,
		ToastHolder = toastHolder,
		Theme = theme,
		Tabs = {},
		CurrentTab = nil,
		IsCompact = false,
		SidebarWidth = 166,
		TabButtonHeight = 40,
		TabTextSize = 13,
		ToggleKey = config.ToggleKey or Enum.KeyCode.LeftShift,
		Visible = true,
		AnimationToken = 0,
		Connections = {},
		OnClose = config.OnClose,
	}, Window)

	makeDraggable(holder, topbar, self)

	self:_connect(close.MouseEnter, function()
		tween(close, { BackgroundColor3 = theme.Danger, TextColor3 = Color3.new(1, 1, 1) }, 0.14)
	end)
	self:_connect(close.MouseLeave, function()
		tween(close, { BackgroundColor3 = theme.Panel2, TextColor3 = theme.Muted }, 0.14)
	end)
	self:_connect(close.MouseButton1Click, function()
		if self.OnClose then
			pcall(self.OnClose)
		end
		self:Destroy()
	end)

	self:_connect(minimize.MouseEnter, function()
		tween(minimize, { BackgroundColor3 = theme.Panel3, TextColor3 = theme.Text }, 0.14)
	end)
	self:_connect(minimize.MouseLeave, function()
		tween(minimize, { BackgroundColor3 = theme.Panel2, TextColor3 = theme.Muted }, 0.14)
	end)
	self:_connect(minimize.MouseButton1Click, function()
		self:SetVisible(false)
	end)

	self:_connect(openButton.MouseEnter, function()
		tween(openButton, { BackgroundColor3 = theme.Panel3 }, 0.14)
		tween(openButtonScale, { Scale = 1.06 }, 0.2, Enum.EasingStyle.Back)
		tween(openButtonStroke, { Transparency = 0, Thickness = 3 }, 0.14)
	end)
	self:_connect(openButton.MouseLeave, function()
		tween(openButton, { BackgroundColor3 = theme.Panel }, 0.14)
		tween(openButtonScale, { Scale = 1 }, 0.18, Enum.EasingStyle.Back)
		tween(openButtonStroke, { Transparency = 0.05, Thickness = 2 }, 0.14)
	end)
	self:_connect(openButton.MouseButton1Down, function()
		tween(openButtonScale, { Scale = 0.92 }, 0.08, Enum.EasingStyle.Quad)
	end)
	self:_connect(openButton.MouseButton1Up, function()
		tween(openButtonScale, { Scale = 1 }, 0.2, Enum.EasingStyle.Back)
	end)
	self:_connect(openButton.MouseButton1Click, function()
		self:SetVisible(true)
	end)

	holder.Visible = true
	holder.Position = UDim2.fromScale(0.5, 0.5)
	root.Rotation = -4
	root.BackgroundTransparency = 0.16
	rootStroke.Transparency = 0.85
	tween(root, { BackgroundTransparency = 0, Rotation = 0 }, 0.46, Enum.EasingStyle.Back)
	tween(rootStroke, { Transparency = 0.12, Color = theme.Accent }, 0.22, Enum.EasingStyle.Quint).Completed:Once(function()
		if rootStroke.Parent then
			tween(rootStroke, { Color = theme.Stroke }, 0.32, Enum.EasingStyle.Quint)
		end
	end)
	tween(scale, { Scale = 1 }, 0.5, Enum.EasingStyle.Back)
	tween(shadow, { ImageTransparency = 1 }, 0.18, Enum.EasingStyle.Quint)
	if blur then
		tween(blur, { Size = blurTarget }, 0.28, Enum.EasingStyle.Quint)
	end

	return self
end

function Window:GetViewportSize()
	local camera = Workspace.CurrentCamera
	if camera and camera.ViewportSize.X > 0 and camera.ViewportSize.Y > 0 then
		return camera.ViewportSize
	end
	if self.Gui and self.Gui.AbsoluteSize.X > 0 and self.Gui.AbsoluteSize.Y > 0 then
		return self.Gui.AbsoluteSize
	end
	return Vector2.new(1280, 720)
end

function Window:ApplyResponsiveLayout(skipAnimation)
	local viewport = self:GetViewportSize()
	local isTouch = UserInputService.TouchEnabled
	local compact = viewport.X < 760 or viewport.Y < 540 or (isTouch and viewport.X < 930)
	local sideWidth = compact and 118 or 166
	local windowWidth = compact and math.min(690, math.max(290, viewport.X - 22)) or self.BaseSize.X.Offset
	local windowHeight = compact and math.min(520, math.max(340, viewport.Y - 72)) or self.BaseSize.Y.Offset
	local topbarHeight = compact and 52 or 54
	local contentTop = topbarHeight + 3
	local sidebarPadding = compact and 8 or 12
	local tabHeight = compact and 36 or 40
	local tabTextSize = compact and 11 or 13
	local pagePadding = compact and 9 or 14
	local titleSize = compact and 15 or 17
	local subtitleSize = compact and 10 or 11

	self.IsCompact = compact
	self.SidebarWidth = sideWidth
	self.TabButtonHeight = tabHeight
	self.TabTextSize = tabTextSize

	local function applyOrTween(instance, goal, time)
		if skipAnimation then
			for key, value in pairs(goal) do
				instance[key] = value
			end
		else
			tween(instance, goal, time or 0.18)
		end
	end

	applyOrTween(self.Holder, {
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(windowWidth, windowHeight),
	}, 0.2)
	self.Topbar.Size = UDim2.new(1, 0, 0, topbarHeight)
	self.Title.Position = UDim2.fromOffset(compact and 12 or 18, compact and 6 or 7)
	self.Title.Size = UDim2.new(1, compact and -112 or -160, 0, 23)
	self.Title.TextSize = titleSize
	self.Subtitle.Position = UDim2.fromOffset(compact and 12 or 18, compact and 28 or 29)
	self.Subtitle.Size = UDim2.new(1, compact and -112 or -160, 0, 18)
	self.Subtitle.TextSize = subtitleSize

	local buttonSize = compact and 34 or 32
	local buttonTop = compact and 9 or 11
	self.CloseButton.Position = UDim2.new(1, compact and -42 or -44, 0, buttonTop)
	self.CloseButton.Size = UDim2.fromOffset(buttonSize, buttonSize)
	self.MinimizeButton.Position = UDim2.new(1, compact and -82 or -82, 0, buttonTop)
	self.MinimizeButton.Size = UDim2.fromOffset(buttonSize, buttonSize)

	self.Sidebar.Position = UDim2.fromOffset(0, contentTop)
	self.Sidebar.Size = UDim2.new(0, sideWidth, 1, -contentTop)
	local sidebarPad = self.Sidebar:FindFirstChildOfClass("UIPadding")
	if sidebarPad then
		sidebarPad.PaddingBottom = UDim.new(0, sidebarPadding)
		sidebarPad.PaddingLeft = UDim.new(0, sidebarPadding)
		sidebarPad.PaddingRight = UDim.new(0, sidebarPadding)
		sidebarPad.PaddingTop = UDim.new(0, sidebarPadding)
	end
	local sidebarList = self.Sidebar:FindFirstChildOfClass("UIListLayout")
	if sidebarList then
		sidebarList.Padding = UDim.new(0, compact and 6 or 8)
	end

	self.PageHolder.Position = UDim2.fromOffset(sideWidth, contentTop)
	self.PageHolder.Size = UDim2.new(1, -sideWidth, 1, -contentTop)

	for _, tab in ipairs(self.Tabs or {}) do
		tab.Button.Size = UDim2.new(1, 0, 0, tabHeight)
		tab.Label.Position = UDim2.fromOffset(compact and 9 or 14, 0)
		tab.Label.Size = UDim2.new(1, compact and -14 or -24, 1, 0)
		tab.Label.TextSize = tabTextSize
		tab.Page.Position = UDim2.fromOffset(0, 0)
		tab.Page.Size = UDim2.fromScale(1, 1)
		tab.Page.ScrollBarThickness = compact and 4 or 3
		local pad = tab.Page:FindFirstChildOfClass("UIPadding")
		if pad then
			pad.PaddingBottom = UDim.new(0, pagePadding)
			pad.PaddingLeft = UDim.new(0, pagePadding)
			pad.PaddingRight = UDim.new(0, pagePadding)
			pad.PaddingTop = UDim.new(0, pagePadding)
		end
	end

	self.OpenButton.Size = UDim2.fromOffset(compact and 64 or 58, compact and 64 or 58)
	self.OpenButton.Position = UDim2.new(1, compact and -10 or -14, 0.5, 0)
	self.OpenButtonFallback.TextSize = compact and 24 or 22
	self.ToastHolder.Position = UDim2.new(1, compact and -10 or -18, 0, compact and 10 or 18)
	self.ToastHolder.Size = UDim2.fromOffset(math.max(240, math.min(320, viewport.X - 20)), 330)
end

function Window:SetVisible(visible)
	self.AnimationToken = (self.AnimationToken or 0) + 1
	local token = self.AnimationToken
	self.Visible = visible

	if visible then
		self.Holder.Visible = true
		if self.OpenButton then
			tween(self.OpenButtonScale, { Scale = 0.72 }, 0.14, Enum.EasingStyle.Quad)
			tween(self.OpenButton, { ImageTransparency = 1, BackgroundTransparency = 1 }, 0.14, Enum.EasingStyle.Quad).Completed:Once(function()
				if token == self.AnimationToken and self.Visible then
					self.OpenButton.Visible = false
					self.OpenButton.BackgroundTransparency = 0
					self.OpenButton.ImageTransparency = 0
				end
			end)
		end
		self.PageHolder.Visible = false
		if self.CurrentTab then
			self.CurrentTab.Page.Visible = true
		end
		self.Scale.Scale = 0.78
		self.Root.Rotation = -4
		self.Root.BackgroundTransparency = 0.16
		self.RootStroke.Transparency = 0.85
		tween(self.Root, { BackgroundTransparency = 0, Rotation = 0 }, 0.4, Enum.EasingStyle.Back)
		tween(self.RootStroke, { Transparency = 0.12, Color = self.Theme.Accent }, 0.2, Enum.EasingStyle.Quint).Completed:Once(function()
			if self.Visible and self.RootStroke.Parent then
				tween(self.RootStroke, { Color = self.Theme.Stroke }, 0.3, Enum.EasingStyle.Quint)
			end
		end)
		tween(self.Scale, { Scale = 1 }, 0.46, Enum.EasingStyle.Back)
		tween(self.Shadow, { ImageTransparency = 1 }, 0.16, Enum.EasingStyle.Quint)
		if self.Blur then
			tween(self.Blur, { Size = self.BlurTarget }, 0.24, Enum.EasingStyle.Quint)
		end
		task.delay(0.24, function()
			if token == self.AnimationToken and self.Visible then
				self.PageHolder.Visible = true
			end
		end)
	else
		self.PageHolder.Visible = false
		tween(self.Root, { BackgroundTransparency = 0.18, Rotation = 4 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		tween(self.RootStroke, { Transparency = 0.8 }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		tween(self.Scale, { Scale = 0.76 }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		tween(self.Shadow, { ImageTransparency = 1 }, 0.16, Enum.EasingStyle.Quad)
		if self.Blur then
			tween(self.Blur, { Size = 0 }, 0.16, Enum.EasingStyle.Quad)
		end
		task.delay(0.21, function()
			if token == self.AnimationToken and not self.Visible then
				self.Holder.Visible = false
				self.Root.Rotation = 0
				self.Root.BackgroundTransparency = 0
				self.RootStroke.Color = self.Theme.Stroke
				self.RootStroke.Transparency = 0.12
				self.Scale.Scale = 1
				self.PageHolder.Visible = true
				if self.OpenButton then
					self.OpenButton.Visible = true
					self.OpenButton.ImageTransparency = 1
					self.OpenButton.BackgroundTransparency = 1
					self.OpenButtonScale.Scale = 0.72
					tween(self.OpenButton, { ImageTransparency = 0, BackgroundTransparency = 0 }, 0.2, Enum.EasingStyle.Quint)
					tween(self.OpenButtonScale, { Scale = 1 }, 0.32, Enum.EasingStyle.Back)
				end
			end
		end)
	end
end

function Window:Destroy()
	for _, connection in ipairs(self.Connections or {}) do
		pcall(function()
			connection:Disconnect()
		end)
	end
	self.Connections = {}
	if self.Blur then
		self.Blur:Destroy()
	end
	self.Gui:Destroy()
end

function Window:Notify(titleText, bodyText, duration)
	local theme = self.Theme
	local lifetime = duration or 3

	local toast = new("Frame", {
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.ToastHolder,
		Size = UDim2.fromOffset(320, bodyText and 82 or 58),
		ZIndex = 51,
	})
	corner(10).Parent = toast
	stroke(theme.Stroke, 1, 0.2).Parent = toast

	local scale = new("UIScale", {
		Parent = toast,
		Scale = 0.86,
	})

	local accent = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = toast,
		Size = UDim2.new(0, 4, 1, 0),
		ZIndex = 52,
	})
	gradient(accent, theme.Accent, theme.Accent2, 90)

	local title = makeLabel(toast, titleText, 14, theme.Text, true)
	title.Position = UDim2.fromOffset(16, 8)
	title.Size = UDim2.new(1, -30, 0, 24)
	title.ZIndex = 53

	if bodyText then
		local body = makeLabel(toast, bodyText, 12, theme.Muted, false)
		body.Position = UDim2.fromOffset(16, 34)
		body.Size = UDim2.new(1, -30, 0, 34)
		body.TextWrapped = true
		body.TextYAlignment = Enum.TextYAlignment.Top
		body.ZIndex = 53
	end

	local progress = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = toast,
		Position = UDim2.new(0, 0, 1, -3),
		Size = UDim2.new(1, 0, 0, 3),
		ZIndex = 52,
	})
	gradient(progress, theme.Accent, theme.Accent2, 0)

	tween(scale, { Scale = 1 }, 0.32, Enum.EasingStyle.Back)
	tween(progress, { Size = UDim2.new(0, 0, 0, 3) }, lifetime, Enum.EasingStyle.Linear)

	task.delay(lifetime, function()
		if not toast.Parent then
			return
		end
		tween(scale, { Scale = 0.86 }, 0.18, Enum.EasingStyle.Quad)
		tween(toast, { BackgroundTransparency = 1 }, 0.18).Completed:Once(function()
			toast:Destroy()
		end)
	end)
end

function Window:Tab(name)
	local theme = self.Theme

	local page = new("ScrollingFrame", {
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		ClipsDescendants = true,
		Parent = self.PageHolder,
		Position = UDim2.fromOffset(0, 0),
		ScrollBarImageColor3 = theme.Accent,
		ScrollBarThickness = 3,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 4,
	})
	padding(14).Parent = page
	list(12).Parent = page
	local pageScale = new("UIScale", {
		Parent = page,
		Scale = 1,
	})

	local button = makeButton(self.Sidebar, "", theme.Panel2, theme.Muted)
	button.Size = UDim2.new(1, 0, 0, 40)
	button.Text = ""
	button.ZIndex = 5
	corner(9).Parent = button
	local buttonStroke = stroke(theme.Stroke, 1, 0.5)
	buttonStroke.Parent = button
	local buttonScale = new("UIScale", {
		Parent = button,
		Scale = 1,
	})

	local activeRail = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = button,
		Position = UDim2.fromOffset(0, 20),
		Size = UDim2.fromOffset(3, 0),
		Visible = true,
		ZIndex = 6,
	})
	corner(4).Parent = activeRail
	gradient(activeRail, theme.Accent, theme.Accent2, 90)

	local text = makeLabel(button, name, 13, theme.Muted, true)
	text.Position = UDim2.fromOffset(14, 0)
	text.Size = UDim2.new(1, -24, 1, 0)
	text.ZIndex = 6

	local tab = setmetatable({
		Button = button,
		ButtonScale = buttonScale,
		ButtonStroke = buttonStroke,
		Label = text,
		Name = name,
		Page = page,
		PageScale = pageScale,
		Rail = activeRail,
		Sections = {},
		Window = self,
	}, Tab)

	table.insert(self.Tabs, tab)
	self:ApplyResponsiveLayout(true)

	button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	button.MouseEnter:Connect(function()
		if self.CurrentTab ~= tab then
			tween(button, { BackgroundColor3 = theme.Panel3 }, 0.14)
			tween(buttonStroke, { Transparency = 0.25 }, 0.14)
		end
	end)

	button.MouseLeave:Connect(function()
		if self.CurrentTab ~= tab then
			tween(button, { BackgroundColor3 = theme.Panel2 }, 0.14)
			tween(buttonStroke, { Transparency = 0.5 }, 0.14)
		end
	end)

	if not self.CurrentTab then
		self:SelectTab(tab)
	end

	return tab
end

function Window:SelectTab(tab)
	local theme = self.Theme

	for _, item in ipairs(self.Tabs) do
		local active = item == tab
		item.Page.Visible = active
		tween(item.Button, {
			BackgroundColor3 = active and theme.Accent or theme.Panel2,
		}, active and 0.2 or 0.16, Enum.EasingStyle.Quint)
		tween(item.ButtonScale, {
			Scale = active and 1.025 or 1,
		}, active and 0.28 or 0.16, active and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
		tween(item.ButtonStroke, {
			Color = active and theme.Accent or theme.Stroke,
			Transparency = active and 0.1 or 0.5,
		}, 0.18, Enum.EasingStyle.Quint)
		tween(item.Label, {
			TextColor3 = active and theme.DarkText or theme.Muted,
		}, 0.18, Enum.EasingStyle.Quint)
		tween(item.Rail, {
			BackgroundTransparency = active and 0 or 1,
			Position = active and UDim2.fromOffset(0, 9) or UDim2.fromOffset(0, 20),
			Size = active and UDim2.fromOffset(3, 22) or UDim2.fromOffset(3, 0),
		}, active and 0.26 or 0.14, Enum.EasingStyle.Quint)
	end

	tab.Page.CanvasPosition = Vector2.new(0, 0)
	local startOffset = self.IsCompact and 8 or 18
	tab.Page.Position = UDim2.fromOffset(startOffset, 0)
	tab.Page.Size = UDim2.new(1, -startOffset, 1, 0)
	tab.PageScale.Scale = 0.985
	tween(tab.Page, {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1),
	}, 0.32, Enum.EasingStyle.Quint)
	tween(tab.PageScale, {
		Scale = 1,
	}, 0.34, Enum.EasingStyle.Back)

	self.CurrentTab = tab
end

function Tab:Section(titleText)
	local theme = self.Window.Theme

	local frame = new("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.Page,
		Size = UDim2.new(1, 0, 0, 0),
		ZIndex = 4,
	})
	corner(10).Parent = frame
	stroke(theme.Stroke, 1, 0.25).Parent = frame
	padding(12).Parent = frame
	list(10).Parent = frame

	local header = new("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 24),
		ZIndex = 5,
	})

	local accent = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = header,
		Position = UDim2.fromOffset(0, 7),
		Size = UDim2.fromOffset(4, 12),
		ZIndex = 6,
	})
	corner(4).Parent = accent
	gradient(accent, theme.Accent, theme.Accent2, 90)

	local title = makeLabel(header, titleText, 14, theme.Text, true)
	title.Position = UDim2.fromOffset(12, 0)
	title.Size = UDim2.new(1, -12, 1, 0)
	title.ZIndex = 6

	local content = new("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 0),
		ZIndex = 5,
	})
	list(8).Parent = content

	local section = setmetatable({
		Content = content,
		Count = 0,
		Frame = frame,
		Window = self.Window,
	}, Section)

	table.insert(self.Sections, section)
	return section
end

function Section:_baseRow(height)
	local theme = self.Window.Theme
	self.Count = self.Count + 1

	local row = new("Frame", {
		BackgroundColor3 = theme.Panel2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.Content,
		Size = UDim2.new(1, 0, 0, height or 44),
		ZIndex = 6,
	})
	corner(9).Parent = row

	local rowStroke = stroke(theme.Stroke, 1, 1)
	rowStroke.Parent = row

	local rowScale = new("UIScale", {
		Parent = row,
		Scale = 0.96,
	})

	task.delay(self.Count * 0.025, function()
		if not row.Parent then
			return
		end
		tween(row, { BackgroundTransparency = 0 }, 0.18)
		tween(rowStroke, { Transparency = 0.45 }, 0.18)
		tween(rowScale, { Scale = 1 }, 0.36, Enum.EasingStyle.Back)
	end)

	return row, rowStroke
end

function Section:Label(text)
	local theme = self.Window.Theme
	local row = self:_baseRow(36)
	local label = makeLabel(row, text, 12, theme.Muted, false)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -24, 1, 0)
	label.ZIndex = 7
	return setmetatable({
		Instance = row,
		Label = label,
		Set = function(nextText, color)
			label.Text = nextText
			if color then
				label.TextColor3 = color
			end
		end,
	}, Control)
end

function Section:Button(text, callback)
	local theme = self.Window.Theme
	local row, rowStroke = self:_baseRow(44)

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -44, 1, 0)
	label.ZIndex = 7

	local arrow = makeLabel(row, ">", 15, theme.Muted, true)
	arrow.Position = UDim2.new(1, -32, 0, 0)
	arrow.Size = UDim2.fromOffset(20, 44)
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.ZIndex = 7

	local hit = makeButton(row, "", theme.Panel2, theme.Text)
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.fromScale(1, 1)
	hit.ZIndex = 8

	pressable(hit, row, rowStroke, theme, function()
		tween(arrow, { Position = UDim2.new(1, -26, 0, 0), TextColor3 = theme.Accent }, 0.08)
		task.delay(0.08, function()
			if arrow.Parent then
				tween(arrow, { Position = UDim2.new(1, -32, 0, 0), TextColor3 = theme.Muted }, 0.2)
			end
		end)
		if callback then
			callback()
		end
	end)

	return setmetatable({ Instance = row }, Control)
end

function Section:Toggle(text, default, callback)
	local theme = self.Window.Theme
	local enabled = default == true
	local row, rowStroke = self:_baseRow(46)

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -82, 1, 0)
	label.ZIndex = 7

	local switch = new("Frame", {
		BackgroundColor3 = enabled and theme.Accent or theme.Panel3,
		BorderSizePixel = 0,
		Parent = row,
		Position = UDim2.new(1, -58, 0.5, -12),
		Size = UDim2.fromOffset(46, 24),
		ZIndex = 7,
	})
	corner(999).Parent = switch
	local switchGradient = gradient(switch, theme.Accent, theme.Accent2, 0)
	switchGradient.Enabled = enabled

	local knob = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = switch,
		Position = enabled and UDim2.new(1, -21, 0, 3) or UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(18, 18),
		ZIndex = 8,
	})
	corner(999).Parent = knob

	local hit = makeButton(row, "", theme.Panel2, theme.Text)
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.fromScale(1, 1)
	hit.ZIndex = 9

	local function set(value, fire)
		enabled = value
		tween(switch, {
			BackgroundColor3 = enabled and theme.Accent or theme.Panel3,
		}, 0.16)
		switchGradient.Enabled = enabled
		tween(knob, {
			Position = enabled and UDim2.new(1, -21, 0, 3) or UDim2.fromOffset(3, 3),
		}, 0.25, Enum.EasingStyle.Back)
		tween(rowStroke, {
			Color = enabled and theme.Accent or theme.Stroke,
			Transparency = enabled and 0.18 or 0.45,
		}, 0.18)
		if callback and fire ~= false then
			task.spawn(callback, enabled)
		end
	end

	pressable(hit, row, rowStroke, theme, function()
		set(not enabled)
	end)

	if callback then
		task.spawn(callback, enabled)
	end

	return setmetatable({
		Instance = row,
		Get = function()
			return enabled
		end,
		Set = set,
	}, Control)
end

function Control:Destroy()
	if self.Instance then
		self.Instance:Destroy()
	end
end

function Section:Textbox(text, placeholder, callback)
	local theme = self.Window.Theme
	local row, rowStroke = self:_baseRow(46)

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -82, 1, 0)
	label.ZIndex = 7

	local textbox = new("TextBox", {
		BackgroundColor3 = theme.Panel3,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		PlaceholderColor3 = theme.Muted,
		PlaceholderText = placeholder or "",
		Parent = row,
		Position = UDim2.new(1, -78, 0.5, -15),
		Size = UDim2.fromOffset(66, 30),
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 13,
		ZIndex = 8,
	})
	corner(8).Parent = textbox
	stroke(theme.Stroke, 1, 0.4).Parent = textbox

	textbox.FocusLost:Connect(function(enterPressed)
		if callback then
			task.spawn(callback, textbox.Text, enterPressed)
		end
	end)

	return setmetatable({
		Instance = row,
		Get = function()
			return textbox.Text
		end,
		Set = function(text)
			textbox.Text = text
		end,
	}, Control)
end

function Section:Slider(text, default, min, max, callback)
	local theme = self.Window.Theme
	local value = default or min
	local precision = 0
	local step = (max - min) / 100
	
	-- Auto-detect precision from default value
	if type(default) == "number" then
		local str = tostring(default)
		if str:find("%.") then
			precision = #str:split("%.") - 1
		end
	end
	
	local row, rowStroke = self:_baseRow(46)

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -82, 1, 0)
	label.ZIndex = 7

	local valueLabel = makeLabel(row, tostring(value), 13, theme.Accent, true)
	valueLabel.Position = UDim2.new(1, -58, 0.5, -10)
	valueLabel.Size = UDim2.fromOffset(46, 20)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Center
	valueLabel.ZIndex = 7

	local sliderFrame = new("Frame", {
		BackgroundColor3 = theme.Panel3,
		BorderSizePixel = 0,
		Parent = row,
		Position = UDim2.fromOffset(12, 32),
		Size = UDim2.new(1, -24, 0, 6),
		ZIndex = 7,
	})
	corner(3).Parent = sliderFrame

	local fill = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = sliderFrame,
		Size = UDim2.fromScale((value - min) / (max - min), 1),
		ZIndex = 8,
	})
	corner(3).Parent = fill
	gradient(fill, theme.Accent, theme.Accent2, 0)

	local knob = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = sliderFrame,
		Position = UDim2.fromScale((value - min) / (max - min), 0.5),
		Size = UDim2.fromOffset(14, 14),
		ZIndex = 9,
	})
	corner(999).Parent = knob

	local hit = makeButton(row, "", theme.Panel2, theme.Text)
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.fromScale(1, 1)
	hit.ZIndex = 10

	local function formatValue(v)
		if precision > 0 then
			return string.format("%." .. precision .. "f", v)
		end
		return tostring(math.floor(v))
	end

	local function setValue(newValue, fire)
		value = math.clamp(newValue, min, max)
		local ratio = (value - min) / (max - min)
		valueLabel.Text = formatValue(value)
		fill.Size = UDim2.fromScale(ratio, 1)
		knob.Position = UDim2.fromScale(ratio, 0.5)
		if callback and fire ~= false then
			task.spawn(callback, value)
		end
	end

	local function getValueFromMouse()
		local mousePos = UserInputService:GetMouseLocation()
		local sliderPos = sliderFrame.AbsolutePosition
		local sliderSize = sliderFrame.AbsoluteSize
		local ratio = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
		return min + ratio * (max - min)
	end

	local dragging = false
	local dragConnection = nil
	local upConnection = nil
	local leaveConnection = nil

	hit.MouseButton1Down:Connect(function()
		dragging = true
		setValue(getValueFromMouse(), false)
		
		dragConnection = UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				setValue(getValueFromMouse(), false)
			end
		end)
		
		upConnection = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if dragging then
					dragging = false
					setValue(getValueFromMouse(), true)
					if dragConnection then dragConnection:Disconnect() end
					if upConnection then upConnection:Disconnect() end
					if leaveConnection then leaveConnection:Disconnect() end
				end
			end
		end)
	end)

	-- Click to jump to position
	hit.MouseButton1Click:Connect(function()
		if not dragging then
			setValue(getValueFromMouse(), true)
		end
	end)

	if callback then
		task.spawn(callback, value)
	end

	return setmetatable({
		Instance = row,
		Get = function()
			return value
		end,
		Set = function(v, fire)
			setValue(v, fire)
		end,
	}, Control)
end

function Section:Dropdown(text, options, default, callback)
	local theme = self.Window.Theme
	local compact = self.Window.IsCompact
	local selected = (type(default) == "string" and default ~= "") and default or options[1] or ""
	local open = false
	local row, rowStroke = self:_baseRow(46)
	row.ClipsDescendants = true

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = compact and UDim2.fromOffset(12, 3) or UDim2.fromOffset(12, 0)
	label.Size = compact and UDim2.new(1, -52, 0, 20) or UDim2.new(1, -210, 0, 46)
	label.TextSize = compact and 12 or 13
	label.ZIndex = 7

	local selectedLabel = makeLabel(row, selected, 12, theme.Muted, true)
	selectedLabel.Position = compact and UDim2.fromOffset(12, 22) or UDim2.new(1, -176, 0, 0)
	selectedLabel.Size = compact and UDim2.new(1, -52, 0, 22) or UDim2.fromOffset(132, 46)
	selectedLabel.TextXAlignment = compact and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
	selectedLabel.ZIndex = 7

	local arrow = makeLabel(row, ">", 15, theme.Muted, true)
	arrow.Position = UDim2.new(1, -32, 0, 0)
	arrow.Size = UDim2.fromOffset(20, 46)
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.ZIndex = 7

	local holder = new("Frame", {
		BackgroundTransparency = 1,
		Parent = row,
		Position = UDim2.fromOffset(8, 48),
		Size = UDim2.new(1, -16, 0, math.max(1, #options) * 34),
		ZIndex = 7,
	})
	list(6).Parent = holder

	local function choose(option, fire)
		selected = option
		selectedLabel.Text = option
		if callback and fire ~= false then
			task.spawn(callback, selected)
		end
	end

	for _, option in ipairs(options) do
		local optionButton = makeButton(holder, option, theme.Panel3, theme.Text)
		optionButton.Size = UDim2.new(1, 0, 0, 30)
		optionButton.TextXAlignment = Enum.TextXAlignment.Left
		optionButton.ZIndex = 8
		corner(8).Parent = optionButton
		padding(10).Parent = optionButton

		optionButton.MouseEnter:Connect(function()
			tween(optionButton, { BackgroundColor3 = theme.Accent, TextColor3 = theme.DarkText }, 0.12)
		end)
		optionButton.MouseLeave:Connect(function()
			tween(optionButton, { BackgroundColor3 = theme.Panel3, TextColor3 = theme.Text }, 0.12)
		end)
		optionButton.MouseButton1Down:Connect(function(x, y)
			ripple(optionButton, x, y, Color3.fromRGB(255, 255, 255))
		end)
		optionButton.MouseButton1Click:Connect(function()
			choose(option)
			open = false
			tween(row, { Size = UDim2.new(1, 0, 0, 46) }, 0.2)
			tween(arrow, { Rotation = 0 }, 0.2)
		end)
	end

	local hit = makeButton(row, "", theme.Panel2, theme.Text)
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.new(1, 0, 0, 46)
	hit.ZIndex = 9

	pressable(hit, row, rowStroke, theme, function()
		open = not open
		local targetHeight = open and (54 + math.max(1, #options) * 36) or 46
		tween(row, { Size = UDim2.new(1, 0, 0, targetHeight) }, 0.22, Enum.EasingStyle.Quint)
		tween(arrow, { Rotation = open and 90 or 0 }, 0.22)
	end)

	if callback and selected ~= "" then
		task.spawn(callback, selected)
	end

	return setmetatable({
		Instance = row,
		Get = function()
			return selected
		end,
		Set = choose,
	}, Control)
end

pcall(function()
    local prev = getgenv and getgenv().WalkyGAG2
    if prev then
        if prev.S then prev.S.killed = true end
        if prev.unload then pcall(prev.unload) end
    end
end)

pcall(function()
    if setthreadidentity then setthreadidentity(8) end
    if syn and syn.set_thread_identity then syn.set_thread_identity(8) end
end)

-- block ALL Robux purchase prompts so no farm action can pop a real-money dialog
pcall(function()
    local nc = newcclosure or function(f) return f end
    local oldNc
    local function blocker(self, ...)
        local m = getnamecallmethod and getnamecallmethod()
        if type(m) == "string" and string.sub(m, 1, 6) == "Prompt" and string.find(m, "Purchase") then return end
        return oldNc(self, ...)
    end
    if hookmetamethod then
        oldNc = hookmetamethod(game, "__namecall", nc(blocker))
    elseif getrawmetatable and setreadonly then
        local mt = getrawmetatable(game); oldNc = mt.__namecall
        setreadonly(mt, false); mt.__namecall = nc(blocker); setreadonly(mt, true)
    end
end)

-- // ============================================================ \\ --
-- //                       NETWORK / DATA                         \\ --
-- // ============================================================ \\ --
local Net
do
    local sm = ReplicatedStorage:WaitForChild("SharedModules", 15)
    local mod = sm and sm:FindFirstChild("Networking")
    if mod then local ok, m = pcall(require, mod); if ok then Net = m end end
end
if not Net then
    warn("[WalkyHub] Networking module not found — wrong game?")
    return
end

-- light global pacer + jitter (precautionary; GAG2 has no proven AC vector yet)
local _rl = { w = 0, c = 0, cap = 60 }
local function pace()
    local now = os.clock()
    if now - _rl.w >= 1 then _rl.w = now; _rl.c = 0 end
    if _rl.c >= _rl.cap then task.wait(0.05); return pace() end
    _rl.c = _rl.c + 1
end
local function jitter(a, b) a = a or 0.05; b = b or 0.12; return a + math.random() * (b - a) end

local function action(path)
    local cur = Net
    for part in string.gmatch(path, "[^.]+") do
        if type(cur) ~= "table" then return nil end
        cur = cur[part]
    end
    return cur
end
local function fire(path, ...)            -- fire-and-forget OR returns value (both via :Fire)
    local a = action(path)
    if not (a and a.Fire) then return false, "no action: " .. path end
    pace()
    local args = table.pack(...)
    local ok, res = pcall(function() return a:Fire(table.unpack(args, 1, args.n)) end)
    if not ok then return false, res end
    return true, res
end
-- NO pacer: for the high-volume harvest/sell hot path (the 60/s pacer throttled it to ~0).
local function fireFast(path, ...)
    local a = action(path)
    if not (a and a.Fire) then return false, "no action: " .. path end
    local args = table.pack(...)
    local ok, res = pcall(function() return a:Fire(table.unpack(args, 1, args.n)) end)
    if not ok then return false, res end
    return true, res
end
-- Retry wrapper for critical operations
local function fireWithRetry(path, maxRetries, ...)
    maxRetries = maxRetries or 3
    for i = 1, maxRetries do
        local ok, res = fire(path, ...)
        if ok then return true, res end
        if i < maxRetries then task.wait(0.1 * i) end
    end
    return false, "max retries exceeded"
end

-- local-player replica (Sheckles / Tokens / Inventory / PurchasedThisRestock / OwnedExpansions)
local _replica
local function replica()
    if _replica then return _replica end
    local ok, psc = pcall(function() return require(ReplicatedStorage.ClientModules.PlayerStateClient) end)
    if ok and psc and psc.WaitForLocalReplica then
        local ok2, r = pcall(function() return psc:WaitForLocalReplica(30) end)
        if ok2 and r then _replica = r end
    end
    return _replica
end
local function pdata() local r = replica(); return (r and r.Data) or {} end
local function getSheckles() return tonumber(pdata().Sheckles) or 0 end
local function getTokens()   return tonumber(pdata().Tokens) or 0 end
local function inv(category) local i = pdata().Inventory; return (i and i[category]) or {} end
local function fmt(n)
    n = tonumber(n) or 0
    if n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n/1e3)
    else return tostring(math.floor(n)) end
end
-- extract a usable item "name" + count from an inventory entry (shape varies: count-by-name or uuid->record)
local function invNames(category)
    local out = {}                       -- { name = totalCount }
    for k, v in pairs(inv(category)) do
        local name, count
        if type(v) == "table" then
            name = v.Name or v.ItemName or v.Type or (type(k) == "string" and not v.Name and k) or tostring(k)
            count = tonumber(v.Count) or tonumber(v.Amount) or 1
        elseif type(v) == "number" then
            name, count = tostring(k), v
        else
            name, count = tostring(k), 1
        end
        if name then out[name] = (out[name] or 0) + (count or 1) end
    end
    return out
end

-- // ============================================================ \\ --
-- //                         CATALOGS                             \\ --
-- // ============================================================ \\ --
local function seedCatalog()
    local out = {}
    local ok, data = pcall(function() return require(ReplicatedStorage.SharedModules.SeedData) end)
    if ok and type(data) == "table" then
        for _, e in pairs(data) do
            if type(e) == "table" and e.SeedName and e.RestockShop ~= false and e.PurchasePrice then
                out[#out + 1] = { name = e.SeedName, price = tonumber(e.PurchasePrice) or 0, rarity = e.Rarity or "" }
            end
        end
    end
    table.sort(out, function(a, b) return a.price < b.price end)
    if #out == 0 then
        for _, n in ipairs({ "Carrot","Strawberry","Blueberry","Tulip","Tomato","Apple","Bamboo","Corn",
            "Cactus","Pineapple","Mushroom","Green Bean","Banana","Grape","Coconut","Mango","Dragon Fruit",
            "Acorn","Cherry","Sunflower","Venus Fly Trap","Pomegranate","Poison Apple","Moon Bloom",
            "Dragon's Breath","Ghost Pepper","Poison Ivy" }) do out[#out + 1] = { name = n, price = 0, rarity = "" } end
    end
    return out
end
local function gearCatalog()
    local out, seen = {}, {}
    local ok, data = pcall(function() return require(ReplicatedStorage.SharedModules.GearShopData) end)
    if ok and data and type(data.Data) == "table" then
        for _, e in pairs(data.Data) do
            if type(e) == "table" and e.ItemName and not e.RobuxOnly then
                if not seen[e.ItemName] then seen[e.ItemName] = true; out[#out + 1] = e.ItemName end
            end
        end
    end
    if #out == 0 then  -- fall back to live stock items
        local ok2, items = pcall(function() return ReplicatedStorage.StockValues.GearShop.Items end)
        if ok2 and items then for _, c in ipairs(items:GetChildren()) do out[#out + 1] = c.Name end end
    end
    table.sort(out)
    return out
end
local CATALOG = seedCatalog()
local SEED_NAMES = {} ; for _, s in ipairs(CATALOG) do SEED_NAMES[#SEED_NAMES + 1] = s.name end
local GEAR_NAMES = gearCatalog()

local function stockOf(shop, name)
    local ok, items = pcall(function() return ReplicatedStorage.StockValues[shop].Items end)
    if not ok or not items then return nil end
    local v = items:FindFirstChild(name)
    return v and tonumber(v.Value) or 0
end

-- // ============================================================ \\ --
-- //                  PLOT / TOOLS / WORLD STATE                  \\ --
-- // ============================================================ \\ --
local function myPlot()
    local id = LocalPlayer:GetAttribute("PlotId")
    local gardens = Workspace:FindFirstChild("Gardens")
    if not (id and gardens) then return nil end
    return gardens:FindFirstChild("Plot" .. tostring(id))
end
local function myPlotId() return LocalPlayer:GetAttribute("PlotId") end
local function humanoid() local c = LocalPlayer.Character; return c and c:FindFirstChildOfClass("Humanoid") end

-- tools in Backpack+Character carrying attribute `attr` (optionally matching a name)
local function toolsByAttr(attr, wantName)
    local out = {}
    local function scan(c)
        if not c then return end
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") and t:GetAttribute(attr) ~= nil then
                if (not wantName) or t:GetAttribute(attr) == wantName or t.Name == wantName then out[#out + 1] = t end
            end
        end
    end
    scan(LocalPlayer:FindFirstChild("Backpack")); scan(LocalPlayer.Character)
    return out
end
local function heldToolByAttr(attr)
    local c = LocalPlayer.Character
    local t = c and c:FindFirstChildWhichIsA("Tool")
    if t and t:GetAttribute(attr) ~= nil then return t end
    return nil
end
local function equipByAttr(attr, wantName)
    local t = heldToolByAttr(attr)
    if t and ((not wantName) or t:GetAttribute(attr) == wantName) then return t end
    local tools = toolsByAttr(attr, wantName)
    if #tools == 0 then return nil end
    t = tools[1]
    local hum = humanoid(); if not hum then return nil end
    local ok = pcall(function() hum:EquipTool(t) end)
    if not ok then return nil end
    task.wait(0.22)
    return heldToolByAttr(attr)
end

-- PlantArea parts inside MY plot
local function myPlantAreas()
    local out, plot = {}, myPlot()
    if not plot then return out end
    for _, p in ipairs(CollectionService:GetTagged("PlantArea")) do
        if p:IsA("BasePart") and p:IsDescendantOf(plot) then out[#out + 1] = p end
    end
    return out
end
-- a grid of world positions over my PlantArea, raycast-confirmed onto the surface
local function plantGrid(spacing)
    local pts, areas = {}, myPlantAreas()
    if #areas == 0 then return pts end
    spacing = math.max(2, spacing or 4)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = areas
    for _, area in ipairs(areas) do
        local ok, cf, size = pcall(function() return area.CFrame, area.Size end)
        if not ok then 
            -- skip this area if error
        else
            local topY = (cf * CFrame.new(0, size.Y/2, 0)).Position.Y
            for dx = -size.X/2 + spacing/2, size.X/2 - spacing/2, spacing do
                for dz = -size.Z/2 + spacing/2, size.Z/2 - spacing/2, spacing do
                    local w = (cf * CFrame.new(dx, 0, dz)).Position
                    local hit = Workspace:Raycast(Vector3.new(w.X, topY + 10, w.Z), Vector3.new(0, -40, 0), params)
                    if hit then pts[#pts + 1] = hit.Position end
                end
            end
        end
    end
    return pts
end
local function existingPlantPositions()
    local out, plot = {}, myPlot()
    local plants = plot and plot:FindFirstChild("Plants")
    if not plants then return out end
    for _, m in ipairs(plants:GetChildren()) do
        local ok, pivot = pcall(function() return m:GetPivot().Position end)
        if ok then out[#out + 1] = pivot end
    end
    return out
end

-- carrier model that holds PlantId/FruitId/UserId for a given prompt
local function promptCarrier(prompt)
    local node = prompt.Parent
    while node and node ~= Workspace and node:GetAttribute("PlantId") == nil do node = node.Parent end
    if node and node:GetAttribute("PlantId") ~= nil then return node end
    return prompt:FindFirstAncestorWhichIsA("Model")
end
local function ripeHarvests()       -- own ripe fruit (tag "HarvestPrompt")
    local out = {}
    for _, pr in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled and pr:IsDescendantOf(Workspace) then
            local m = promptCarrier(pr)
            local pid = m and m:GetAttribute("PlantId")
            if pid then
                local uid = tonumber(m:GetAttribute("UserId"))
                if uid == nil or uid == LocalPlayer.UserId then
                    out[#out + 1] = { plantId = tostring(pid), fruitId = tostring(m:GetAttribute("FruitId") or "") }
                end
            end
        end
    end
    return out
end
local function stealable()
    local out = {}
    for _, pr in ipairs(CollectionService:GetTagged("StealPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled and pr:IsDescendantOf(Workspace) then
            local m = promptCarrier(pr)
            local pid = m and m:GetAttribute("PlantId")
            if pid then
                local pos
                local pp = pr.Parent
                if pp and pp:IsA("BasePart") then pos = pp.Position
                elseif m then local ok, pv = pcall(function() return m:GetPivot().Position end); if ok then pos = pv end end
                out[#out + 1] = {
                    owner = tonumber(m:GetAttribute("UserId")) or 0,
                    plantId = tostring(pid),
                    fruitId = tostring(m:GetAttribute("FruitId") or ""),
                    pos = pos,
                }
            end
        end
    end
    -- fallback: scan nearby prompts during day
    local hrp = hrpNow()
    if hrp then
        for _, pr in ipairs(Workspace:GetDescendants()) do
            if pr:IsA("ProximityPrompt") and pr.Enabled and pr.ActionText and
               string.find(string.lower(pr.ActionText), "steal") then
                local part = pr.Parent
                if part and part:IsA("BasePart") then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < 20 then
                        local m = promptCarrier(pr)
                        local pid = m and m:GetAttribute("PlantId")
                        if pid then
                            out[#out+1] = {
                                owner = tonumber(m:GetAttribute("UserId")) or 0,
                                plantId = tostring(pid),
                                fruitId = tostring(m:GetAttribute("FruitId") or ""),
                                pos = part.Position,
                            }
                        end
                    end
                end
            end
        end
    end
    return out
end
   
local function isNight()
    local n = ReplicatedStorage:FindFirstChild("Night")
    return n and n.Value == true
end
-- world wild pets you walk up to and buy/tame: Map.WildPetRef parts carry PetName/Price/OwnerUserId
local function wildPets()
    local out = {}
    local map = Workspace:FindFirstChild("Map")
    local ref = map and map:FindFirstChild("WildPetRef")
    if ref then for _, p in ipairs(ref:GetChildren()) do
        if p:IsA("BasePart") then
            out[#out + 1] = {
                part = p, name = p:GetAttribute("PetName"),
                price = tonumber(p:GetAttribute("Price")) or 0,
                owner = tonumber(p:GetAttribute("OwnerUserId")) or 0,
                pos = p.Position,
            }
        end
    end end
    return out
end
-- teleport char to a world position, run fn, restore original CFrame
local function atPosition(pos, fn)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local saved = hrp.CFrame
    pcall(function() hrp.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0)) end)
    task.wait(0.45)
    local ok = pcall(fn)
    task.wait(0.15)
    if hrp and hrp.Parent then pcall(function() hrp.CFrame = saved end) end
    return ok
end
-- own-garden anchor: standing inside it sets IsInOwnGarden -> the server banks carried stolen fruit
local function myBasePos()
    local plot = myPlot(); if not plot then return nil end
    for _, tag in ipairs({ "GardenTotalArea", "GardenZone" }) do
        for _, p in ipairs(CollectionService:GetTagged(tag)) do
            if p:IsA("BasePart") and p:IsDescendantOf(plot) then
                return Vector3.new(p.Position.X, p.Position.Y - p.Size.Y / 2 + 5, p.Position.Z)
            end
        end
    end
    local sp = plot:FindFirstChild("SpawnPoint")
    if sp and sp:IsA("BasePart") then return sp.Position end
    local ok, piv = pcall(function() return plot:GetPivot().Position end)
    return ok and piv or nil
end

-- // ============================================================ \\ --
-- //                          STATE                              \\ --
-- // ============================================================ \\ --
local S = {
    -- master
    autoFarm = false,
    -- buy / plant / harvest / sell
    autoBuy = false, buySeeds = {}, buyInterval = 5, buyPerTick = 8,
    autoPlant = false, plantSpacing = 4, plantSeed = "Best owned",
    autoHarvest = false, harvestInterval = 2, harvestDelay = 0.01,
    autoSell = false, sellInterval = 15,
    autoExpand = false, autoPot = false, autoDaily = false,
    -- boosts
    autoSprinkler = false, sprinklerInterval = 30,
    autoWater = false, waterInterval = 8,
    autoSkill = false, skillStats = {},          -- {"BaseSpeed"=true,...}
    -- pets
    autoEquipPets = false, autoPetSlot = false,
    autoBuyPets = false, maxPetPrice = 25000, petTeleport = true, petBuyInterval = 5,
    sellPets = {}, autoSellPets = false,
    -- eggs / crates / packs
    autoEgg = false, autoCrate = false, autoPack = false, openInterval = 4,
    -- shop
    autoGear = false, gearBuy = {}, gearInterval = 10,
    -- steal
    autoSteal = false, stealTeleport = true, stealReturnBase = true, stealDelay = 2.05,
    -- misc
    autoMail = false, autoAcceptGift = false, autoHop = false, hopInterval = 0,
    codeText = "", autoCodes = false, antiAfk = true,
    -- perf / webhook
    fpsBoost = false,
    webhookEnabled = false, webhookUrl = "", webhookInterval = 300,
    killed = false,
}
local Stats = { bought = 0, planted = 0, harvested = 0, sold = 0, earned = 0,
    sprinklers = 0, watered = 0, tamed = 0, opened = 0, stolen = 0, codes = 0, startAt = os.clock() }

local _due = {}
local function due(key, period)
    local now = os.clock()
    if not _due[key] or now - _due[key] >= period then _due[key] = now; return true end
    return false
end
-- passive background loop bound to a getter
local function loopOn(getOn, period, body)
    task.spawn(function()
        while not S.killed do
            if getOn() then
                pcall(body)
                local p = (type(period) == "function") and period() or period
                local e = 0; while e < p and getOn() and not S.killed do task.wait(0.4); e += 0.4 end
            else task.wait(0.4) end
        end
    end)
end
local function picked(t) for _ in pairs(t) do return true end return false end
local function pickMulti(sel, into)
    for k in pairs(into) do into[k] = nil end
    if type(sel) == "table" then for k, v in pairs(sel) do
        if v == true then into[k] = true elseif type(v) == "string" then into[v] = true end
    end end
end

-- // ============================================================ \\ --
-- //                     CORE FARM (master loop)                 \\ --
-- // ============================================================ \\ --
local function stepBuy()
    if not due("buy", S.buyInterval) then return end
    if not picked(S.buySeeds) then return end
    for _, s in ipairs(CATALOG) do
        if not (S.autoFarm or S.autoBuy) then break end
        if S.buySeeds[s.name] then
            local stock, bought = stockOf("SeedShop", s.name), 0
            while bought < S.buyPerTick do
                if stock ~= nil and stock <= 0 then break end
                if s.price > 0 and getSheckles() < s.price then break end
                local ok = fire("SeedShop.PurchaseSeed", s.name)
                if not ok then break end
                Stats.bought += 1; bought += 1
                if stock ~= nil then stock -= 1 end
                task.wait(jitter(0.1, 0.22))
            end
        end
    end
end

local function pickPlantTool()
    if S.plantSeed ~= "Best owned" and S.plantSeed ~= "" then
        local t = toolsByAttr("SeedTool", S.plantSeed)[1]
        if t then return t end
    end
    -- best owned = rarest/most expensive seed we hold
    local best, bestPrice
    for _, t in ipairs(toolsByAttr("SeedTool")) do
        local nm = t:GetAttribute("SeedTool")
        local price = 0
        for _, s in ipairs(CATALOG) do if s.name == nm then price = s.price; break end end
        if not bestPrice or price > bestPrice then best, bestPrice = t, price end
    end
    return best or toolsByAttr("SeedTool")[1]
end

local function stepPlant()
    local grid = plantGrid(S.plantSpacing)
    if #grid == 0 then return end
    local tool = pickPlantTool(); if not tool then return end
    local hum = humanoid(); if not hum then return end
    if heldToolByAttr("SeedTool") ~= tool then 
        pcall(function() hum:EquipTool(tool) end)
        task.wait(0.22) 
    end
    tool = heldToolByAttr("SeedTool"); if not tool then return end
    local seedAttr = tool:GetAttribute("SeedTool")
    if not seedAttr then return end
    local occupied = existingPlantPositions()
    for _, pos in ipairs(grid) do
        if not (S.autoFarm or S.autoPlant) then break end
        local clear = true
        for _, op in ipairs(occupied) do
            if (Vector2.new(pos.X, pos.Z) - Vector2.new(op.X, op.Z)).Magnitude < 1 then clear = false; break end
        end
        if clear then
            if not heldToolByAttr("SeedTool") then
                local nx = pickPlantTool(); if not nx then return end
                pcall(function() hum:EquipTool(nx) end)
                task.wait(0.2)
                tool = heldToolByAttr("SeedTool"); if not tool then return end
                seedAttr = tool:GetAttribute("SeedTool")
                if not seedAttr then return end
            end
            pcall(function() fire("Plant.PlantSeed", pos, seedAttr, tool) end)
            Stats.planted += 1; occupied[#occupied + 1] = pos
            task.wait(jitter(0.08, 0.16))   -- > the game's 0.05s client gate
        end
    end
end

local function maxFruitCap() return tonumber(LocalPlayer:GetAttribute("MaxFruitCapacity")) or 100 end
local function fruitCount()  return tonumber(LocalPlayer:GetAttribute("FruitCount")) or 0 end
local function sellAllNow()
    local ok, res = fireFast("NPCS.SellAll")
    if ok and type(res) == "table" and res.Success then
        local n = tonumber(res.SoldCount) or 0
        Stats.sold += n; Stats.earned += tonumber(res.SellPrice) or 0
        return n
    end
    return 0
end

-- THROUGHPUT FIX: inventory caps at MaxFruitCapacity (100) and the server only accepts
-- ~20-25 collects/sec. So harvest in a tight cycle and SELL THE MOMENT the pack is full —
-- never idle holding a full inventory. Firing faster than the server's rate just gets
-- dropped (delay=0 collected LESS), so harvestDelay paces each collect.
local function stepHarvest()
    local sell = (S.autoFarm or S.autoSell)
    local list = ripeHarvests()
    if #list == 0 then
        if sell and fruitCount() > 0 then 
            pcall(sellAllNow)
        end
        return
    end
    local cap = maxFruitCap()
    local d = S.harvestDelay or 0
    -- fire a fresh batch of collects (the firing time lets the async collects materialize
    -- into the pack), stop if the pack is genuinely full, then sell the whole batch at once.
    for _, h in ipairs(list) do
        if not (S.autoFarm or S.autoHarvest) then break end
        if fruitCount() >= cap - 1 then break end
        pcall(function() fireFast("Garden.CollectFruit", h.plantId, h.fruitId) end)
        Stats.harvested += 1
        if d > 0 then task.wait(d) end
    end
    if sell then pcall(sellAllNow) end
end

local function stepSell()       -- sell-only mode (when Auto-Harvest is off)
    if not due("sell", S.sellInterval) then return end
    local n = sellAllNow()
    if n > 0 then warn("[Sold] " .. n .. " items") end
end

local function stepExpand()
    if not due("expand", 12) then return end
    fire("Actions.ExpandGarden")        -- server/client-gates affordability itself
end
local function stepDaily()
    if not due("daily", 60) then return end
    fire("NPCS.CheckDailyDeal"); task.wait(0.3); fire("NPCS.UseDailyDealAll")
end

task.spawn(function()
    while not S.killed do
        if S.autoFarm or S.autoBuy     then pcall(stepBuy) end
        if S.autoFarm or S.autoPlant   then pcall(stepPlant) end
        if S.autoFarm or S.autoExpand  then pcall(stepExpand) end
        if S.autoFarm or S.autoDaily   then pcall(stepDaily) end
        task.wait(0.55)
    end
end)

-- dedicated harvest+sell loop: tight cycle so a big backlog drains at the server's max
-- collect rate (never blocked behind buy/plant/expand on the slow master loop).
task.spawn(function()
    while not S.killed do
        if S.autoFarm or S.autoHarvest then
            pcall(stepHarvest)
            task.wait(0.05)
        elseif S.autoSell then
            pcall(stepSell)
            task.wait(0.3)
        else
            task.wait(0.4)
        end
    end
end)

-- // ============================================================ \\ --
-- //                       BOOSTS (passive)                      \\ --
-- // ============================================================ \\ --
-- Auto-Sprinkler: place every owned sprinkler tool, spread across the plot
loopOn(function() return S.autoSprinkler end, function() return S.sprinklerInterval end, function()
    local pid = myPlotId(); if not pid then return end
    local placed = existingPlantPositions()  -- avoid clustering
    for _, t in ipairs(toolsByAttr("Sprinkler")) do
        if not S.autoSprinkler then break end
        local hum = humanoid(); if not hum then break end
        pcall(function() hum:EquipTool(t) end)
        task.wait(0.22)
        t = heldToolByAttr("Sprinkler"); if not t then break end
        local grid = plantGrid(8)
        for _, pos in ipairs(grid) do
            local far = true
            for _, op in ipairs(placed) do if (pos - op).Magnitude < 12 then far = false; break end end
            if far then
                fire("Place.PlaceSprinkler", pos, t:GetAttribute("Sprinkler"), t, pid)
                Stats.sprinklers += 1; placed[#placed + 1] = pos; task.wait(0.3)
                break
            end
        end
    end
    pcall(function() humanoid():UnequipTools() end)
end)

-- Auto-Water: use watering can over planted crops
loopOn(function() return S.autoWater end, function() return S.waterInterval end, function()
    local t = equipByAttr("WateringCan"); if not t then return end
    local name = t:GetAttribute("WateringCan")
    for _, pos in ipairs(existingPlantPositions()) do
        if not S.autoWater then break end
        fire("WateringCan.UseWateringCan", pos - Vector3.new(0, 0.3, 0), name, t)
        Stats.watered += 1; task.wait(jitter(0.15, 0.3))
    end
end)

-- Auto-Skill: keep spending skill points into the selected stats
loopOn(function() return S.autoSkill end, 6, function()
    if not picked(S.skillStats) then return end
    for stat in pairs(S.skillStats) do
        if not S.autoSkill then break end
        fire("SkillPoints.SpendSkillPoint", stat); task.wait(0.25)
    end
end)

-- // ============================================================ \\ --
-- //                          PETS                               \\ --
-- // ============================================================ \\ --
local function ownedPetNames()
    local names, seen = {}, {}
    for nm in pairs(invNames("Pets")) do if not seen[nm] then seen[nm] = true; names[#names + 1] = nm end end
    for _, t in ipairs(toolsByAttr("PetId")) do
        local nm = t:GetAttribute("PetName") or t.Name
        if nm and not seen[nm] then seen[nm] = true; names[#names + 1] = nm end
    end
    table.sort(names); return names
end
local function equippedPetCount()
    local ok, list = fire("Pets.GetEquippedPets")
    if ok and type(list) == "table" then
        local n = 0; for _ in pairs(list) do n += 1 end; return n
    end
    return 0
end
loopOn(function() return S.autoEquipPets end, 12, function()
    local cap = tonumber(LocalPlayer:GetAttribute("MaxEquippedPets")) or 3
    local have = equippedPetCount()
    if have >= cap then return end
    for _, nm in ipairs(ownedPetNames()) do
        if not S.autoEquipPets or have >= cap then break end
        fire("Pets.RequestEquipByName", nm); have += 1; task.wait(0.3)
    end
end)
loopOn(function() return S.autoPetSlot end, 20, function()
    fire("Pets.RequestPurchasePetSlot")
end)
-- Auto-Buy world pets: walk up (teleport) to each affordable unowned wild pet and buy it.
-- Buying == Pets.WildPetTame:Fire(refPart); server charges Price and REQUIRES proximity.
loopOn(function() return S.autoBuyPets end, function() return S.petBuyInterval end, function()
    for _, w in ipairs(wildPets()) do
        if not S.autoBuyPets then break end
        if w.owner == 0 and w.price > 0 and w.price <= S.maxPetPrice and getSheckles() >= w.price then
            if S.petTeleport and w.pos then
                atPosition(w.pos, function() fire("Pets.WildPetTame", w.part) end)
            else
                fire("Pets.WildPetTame", w.part)
            end
            Stats.tamed += 1
            task.wait(jitter(0.3, 0.6))
        end
    end
end)
loopOn(function() return S.autoSellPets end, 4, function()
    if not picked(S.sellPets) then return end
    for _, t in ipairs(toolsByAttr("PetId")) do
        if not S.autoSellPets then break end
        local nm = t:GetAttribute("PetName") or t.Name
        if S.sellPets[nm] then
            local hum = humanoid()
            if hum then pcall(function() hum:EquipTool(t) end); task.wait(0.25) end
            fire("NPCS.SellPet", t:GetAttribute("PetId")); task.wait(0.3)
        end
    end
end)

-- // ============================================================ \\ --
-- //                  EGGS / CRATES / SEED PACKS                 \\ --
-- // ============================================================ \\ --
local function openAll(category, path)
    for nm, count in pairs(invNames(category)) do
        if S.killed then break end
        for _ = 1, math.min(count, 25) do
            local ok, res = fire(path, nm)
            if not ok then break end
            if type(res) == "table" and res.Success == false then break end
            Stats.opened += 1; task.wait(jitter(0.25, 0.5))
        end
    end
end
loopOn(function() return S.autoEgg  end, function() return S.openInterval end, function() openAll("Eggs", "Egg.OpenEgg") end)
loopOn(function() return S.autoCrate end, function() return S.openInterval end, function() openAll("Crates", "Crate.OpenCrate") end)
loopOn(function() return S.autoPack  end, function() return S.openInterval end, function() openAll("SeedPacks", "SeedPack.OpenSeedPack") end)

-- // ============================================================ \\ --
-- //                      SHOP (gear)                            \\ --
-- // ============================================================ \\ --
loopOn(function() return S.autoGear end, function() return S.gearInterval end, function()
    if not picked(S.gearBuy) then return end
    for name in pairs(S.gearBuy) do
        if not S.autoGear then break end
        local stock = stockOf("GearShop", name)
        if stock == nil or stock > 0 then
            fire("GearShop.PurchaseGear", name); task.wait(jitter(0.2, 0.4))
        end
    end
end)

-- // ============================================================ \\ --
-- //                     STEAL (PvP, night)                      \\ --
-- // ============================================================ \\ --
-- Instant steal: for HoldDuration==0 prompts the game fires BeginSteal+CompleteSteal
-- back-to-back (no hold). Server-side steal is proximity-gated like the prompt, so
-- teleport to the fruit unless disabled.
local function hrpNow() local c = LocalPlayer.Character; return c and c:FindFirstChild("HumanoidRootPart") end
loopOn(function() return S.autoSteal end, 0.05, function()
   
    for _, f in ipairs(stealable()) do
        if not (S.autoSteal and isNight()) then break end
        -- 1) go to the fruit (proximity is server-gated) and steal it
        if S.stealTeleport and f.pos then
            local hrp = hrpNow(); if hrp then pcall(function() hrp.CFrame = CFrame.new(f.pos + Vector3.new(0, 4, 0)) end); task.wait(0.4) end
        end
       local hrp = hrpNow()
local dist = (hrp and f.pos) and (hrp.Position - f.pos).Magnitude or 999
if dist < 15 then
    for _ = 1, 5 do
        fire("Steal.BeginSteal", f.owner, f.plantId, f.fruitId)
        fire("Steal.CompleteSteal")
        task.wait(0.05)
    end
end
        Stats.stolen += 1
        -- 2) carry it home: standing in own garden zone banks it (CarryingStolenFruit clears)
       
        if (S.stealDelay or 0) > 0 then task.wait(S.stealDelay) end
    end
end)

-- // ============================================================ \\ --
-- //                  MISC (mail / gifts / hop / codes)          \\ --
-- // ============================================================ \\ --
loopOn(function() return S.autoMail end, 30, function()
    local ok, box = fire("Mailbox.OpenInbox")
    if ok and type(box) == "table" then
        local mb = box.Mailbox or box.Inbox or box
        for id, entry in pairs(mb) do
            if not S.autoMail then break end
            if type(entry) == "table" and (entry.Claimed == true or entry.IsClaimed == true) then
                -- skip already claimed
            else
                fire("Mailbox.Claim", id); task.wait(0.3)
            end
        end
    end
end)
-- accept incoming gifts automatically
pcall(function()
    local g = action("Gifting.Prompted")
    if g and g.OnClientEvent then
        g.OnClientEvent:Connect(function(fromPlayer)
            if S.autoAcceptGift and fromPlayer then pcall(function() fire("Gifting.Response", fromPlayer, true) end) end
        end)
    end
end)
-- server hop when enabled (RequestHop asks the server to migrate the player)
loopOn(function() return S.autoHop end, function() return math.max(60, S.hopInterval) end, function()
    if S.hopInterval > 0 then fire("AntiAfk.RequestHop") end
end)
-- Anti-AFK: defeat the idle kick via VirtualUser input on Idled (default on)
if VirtualUser then
    LocalPlayer.Idled:Connect(function()
        if S.killed or not S.antiAfk then return end
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
    end)
end
-- codes
local CODE_LIST = {}                  -- add known GAG2 codes here
local triedCodes = {}
local function redeemCodes(list)
    local n = 0
    for _, code in ipairs(list) do
        if code ~= "" and not triedCodes[code] then
            local ok, res = fire("Settings.SubmitCode", code)
            triedCodes[code] = true
            if ok and res == true then n += 1; Stats.codes += 1 end
            task.wait(0.4)
        end
    end
    return n
end
loopOn(function() return S.autoCodes end, 120, function() redeemCodes(CODE_LIST) end)

-- // ============================================================ \\ --
-- //                       PERFORMANCE                           \\ --
-- // ============================================================ \\ --
local _fpsApplied = false
local function applyFpsBoost(on)
    if on and not _fpsApplied then
        _fpsApplied = true
        pcall(function()
            Lighting.GlobalShadows = false; Lighting.FogEnd = 1e6
            for _, e in ipairs(Lighting:GetChildren()) do
                if e:IsA("BloomEffect") or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("BlurEffect") then e.Enabled = false end
            end
            if sethiddenproperty then pcall(sethiddenproperty, Lighting, "Technology", 1) end
            settings().Rendering.QualityLevel = 1
        end)
        task.spawn(function()
            for _, d in ipairs(Workspace:GetDescendants()) do
                if not S.fpsBoost then break end
                if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then d.Enabled = false
                elseif d:IsA("Texture") or d:IsA("Decal") then pcall(function() d.Transparency = 1 end) end
            end
        end)
    end
end

-- // ============================================================ \\ --
-- //                    WEBHOOK REPORTING                        \\ --
-- // ============================================================ \\ --
local httpRequest = (syn and syn.request) or http_request or request or (http and http.request)
local function hms(sec)
    sec = math.floor(sec); local h = sec//3600; local m = (sec%3600)//60
    if h > 0 then return string.format("%dh %dm", h, m) end
    if m > 0 then return string.format("%dm %ds", m, sec%60) end
    return sec .. "s"
end
local function sendWebhook(isTest)
    if not httpRequest then warn("[Webhook] Executor exposes no HTTP request fn"); return false end
    if not string.match(S.webhookUrl or "", "^https?://") then warn("[Webhook] Set a valid webhook URL"); return false end
    local payload = { username = "Grow a Garden 2", embeds = { {
        title = "🌱 Farm Report — " .. LocalPlayer.Name, color = 5763719,
        fields = {
            { name = "💰 Sheckles", value = fmt(getSheckles()), inline = true },
            { name = "🪙 Tokens",   value = fmt(getTokens()),   inline = true },
            { name = "🌾 Plot",     value = tostring((myPlot() and myPlot().Name) or "?"), inline = true },
            { name = "📊 Session",  value = string.format("bought %d · planted %d · harvested %d · sold %d (+%s)",
                Stats.bought, Stats.planted, Stats.harvested, Stats.sold, fmt(Stats.earned)), inline = false },
            { name = "✨ Extras",   value = string.format("sprinklers %d · watered %d · tamed %d · opened %d · stolen %d",
                Stats.sprinklers, Stats.watered, Stats.tamed, Stats.opened, Stats.stolen), inline = false },
            { name = "⏱️ Uptime",   value = hms(os.clock() - Stats.startAt), inline = true },
        }, footer = { text = "WalkyHub · GAG2" },
    } } }
    local ok, res = pcall(function()
        return httpRequest({ Url = S.webhookUrl, Method = "POST",
            Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(payload) })
    end)
    local code = ok and res and (res.StatusCode or res.Status or res.status_code)
    local good = ok and (code == nil or code == 200 or code == 204)
    if isTest then warn("[Webhook] " .. (good and "Test sent ✅" or ("Failed (" .. tostring(code) .. ")"))) end
    return good
end
loopOn(function() return S.webhookEnabled end, function() return S.webhookInterval end, function() sendWebhook(false) end)

-- // ============================================================ \\ --
-- //                            UI                               \\ --
-- // ============================================================ \\ --
-- Create UI with KrassUI
local ui = KrassUI.new({
    Name = "Grow a Garden 2",
    Subtitle = "WalkyHub | Full Auto",
    Theme = "Black",
    Accent = Color3.fromRGB(145, 160, 255),
    Accent2 = Color3.fromRGB(95, 105, 255),
    Size = UDim2.fromOffset(860, 620),
    ToggleKey = Enum.KeyCode.LeftControl,
})

local farmTab = ui:Tab("Farm")
local boostsTab = ui:Tab("Boosts")
local petsTab = ui:Tab("Pets")
local openTab = ui:Tab("Eggs & Crates")
local shopTab = ui:Tab("Shop")
local stealTab = ui:Tab("Steal")
local miscTab = ui:Tab("Misc")
local settingsTab = ui:Tab("Settings")

-- ---- FARM ----
local secStatus = farmTab:Section("Status")
local plotLabel = secStatus:Label("Plot: …")
local cashLabel = secStatus:Label("Sheckles: …")
local statLabel = secStatus:Label("—")

local secMaster = farmTab:Section("Auto-Farm (master)")
secMaster:Toggle("Auto-Farm (buy+plant+harvest+sell+expand)", false, function(v) S.autoFarm = v end)
secMaster:Toggle("Auto-Expand garden", false, function(v) S.autoExpand = v end)
secMaster:Toggle("Auto-Daily deals", false, function(v) S.autoDaily = v end)

local secBuy = farmTab:Section("Buy seeds")
secBuy:Dropdown("Seeds to buy", SEED_NAMES, {}, function(sel) pickMulti(sel, S.buySeeds) end)
secBuy:Toggle("Auto-Buy selected", false, function(v) S.autoBuy = v end)
secBuy:Slider("Buy interval (s)", 5, 1, 30, function(v) S.buyInterval = v end)
secBuy:Slider("Max buys / seed / pass", 8, 1, 50, function(v) S.buyPerTick = v end)

local secPlant = farmTab:Section("Plant / Harvest / Sell")
local plantOpts = { "Best owned" }; for _, n in ipairs(SEED_NAMES) do plantOpts[#plantOpts + 1] = n end
secPlant:Dropdown("Seed to plant", plantOpts, "Best owned", function(v) S.plantSeed = v end)
secPlant:Toggle("Auto-Plant (fill plot)", false, function(v) S.autoPlant = v end)
secPlant:Slider("Plant spacing (studs)", 4, 2, 10, function(v) S.plantSpacing = v end)
secPlant:Toggle("Auto-Harvest ripe fruit", false, function(v) S.autoHarvest = v end)
secPlant:Slider("Harvest pace (s/fruit · 0.02≈max)", 0.01, 0, 0.2, function(v) S.harvestDelay = v end)
secPlant:Toggle("Auto-Sell (auto-sells when pack full)", false, function(v) S.autoSell = v end)
secPlant:Slider("Sell interval (s, sell-only mode)", 15, 3, 120, function(v) S.sellInterval = v end)
secPlant:Toggle("Auto-Pot grown plants", false, function(v) S.autoPot = v end)

-- ---- BOOSTS ----
local secSpr = boostsTab:Section("Sprinklers & Water")
secSpr:Toggle("Auto-place Sprinklers", false, function(v) S.autoSprinkler = v end)
secSpr:Slider("Sprinkler interval (s)", 30, 10, 120, function(v) S.sprinklerInterval = v end)
secSpr:Toggle("Auto-Watering Can", false, function(v) S.autoWater = v end)
secSpr:Slider("Water interval (s)", 8, 2, 60, function(v) S.waterInterval = v end)

local secSkill = boostsTab:Section("Skill points")
secSkill:Dropdown("Stats to level", { "BaseSpeed", "BaseJump", "ShovelPower", "MaxBackpack" }, {}, function(sel) pickMulti(sel, S.skillStats) end)
secSkill:Toggle("Auto-Spend skill points", false, function(v) S.autoSkill = v end)

-- ---- PETS ----
local secPet = petsTab:Section("Pets")
secPet:Toggle("Auto-Equip pets (to slot cap)", false, function(v) S.autoEquipPets = v end)
secPet:Toggle("Auto-Buy pet slots", false, function(v) S.autoPetSlot = v end)
secPet:Toggle("Auto-Buy world pets (walk up & buy)", false, function(v) S.autoBuyPets = v end)
secPet:Slider("Max pet price (Sheckles)", 25000, 1000, 1000000, function(v) S.maxPetPrice = v end)
secPet:Toggle("Teleport to pet (needed to buy)", true, function(v) S.petTeleport = v end)
secPet:Slider("Pet buy interval (s)", 5, 2, 60, function(v) S.petBuyInterval = v end)

local secPetSell = petsTab:Section("Sell pets")
secPetSell:Dropdown("Pets to sell", ownedPetNames(), {}, function(sel) pickMulti(sel, S.sellPets) end)
secPetSell:Toggle("Auto-Sell selected pets", false, function(v) S.autoSellPets = v end)

-- ---- EGGS & CRATES ----
local secOpen = openTab:Section("Auto-Open")
secOpen:Toggle("Auto-Open Eggs", false, function(v) S.autoEgg = v end)
secOpen:Toggle("Auto-Open Crates", false, function(v) S.autoCrate = v end)
secOpen:Toggle("Auto-Open Seed Packs", false, function(v) S.autoPack = v end)
secOpen:Slider("Open interval (s)", 4, 1, 30, function(v) S.openInterval = v end)
local secOpenInfo = openTab:Section("Info")
secOpenInfo:Label("Opens everything you own in each")
secOpenInfo:Label("category. Confirm is automatic.")

-- ---- SHOP ----
local secShop = shopTab:Section("Gear shop")
secShop:Dropdown("Gear to buy", GEAR_NAMES, {}, function(sel) pickMulti(sel, S.gearBuy) end)
secShop:Toggle("Auto-Buy selected gear", false, function(v) S.autoGear = v end)
secShop:Slider("Gear buy interval (s)", 10, 2, 60, function(v) S.gearInterval = v end)

-- ---- STEAL ----
local secSteal = stealTab:Section("Auto-Steal (night only)")
secSteal:Toggle("Auto-Steal others' ripe fruit", false, function(v) S.autoSteal = v end)
secSteal:Toggle("Teleport to fruit (needed to steal)", true, function(v) S.stealTeleport = v end)
secSteal:Button("Teleport to my base now", function()
    local base = myBasePos()
    local hrp = hrpNow()
    if base and hrp then
        for i = 1, 5 do
            pcall(function() hrp.CFrame = CFrame.new(base + Vector3.new(0, 4, 0)) end)
            task.wait(0.1)
        end
    end
end)
secSteal:Slider("Steal speed (delay/fruit, 0=instant)", 1, 0, 60, function(v) S.stealDelay = v end)
local secStealInfo = stealTab:Section("Info")
secStealInfo:Label("Night-only · TP to fruit, steal,")
secStealInfo:Label("then TP home to bank each one.")

-- ---- MISC ----
local secMail = miscTab:Section("Mail & Gifts")
secMail:Toggle("Auto-Claim mailbox", false, function(v) S.autoMail = v end)
secMail:Toggle("Auto-Accept gifts", false, function(v) S.autoAcceptGift = v end)

local secHop = miscTab:Section("Session")
secHop:Toggle("Anti-AFK (never idle-kicked)", true, function(v) S.antiAfk = v end)
secHop:Toggle("Auto server-hop", false, function(v) S.autoHop = v end)
secHop:Slider("Hop every (min, 0=off)", 0, 0, 120, function(v) S.hopInterval = v * 60 end)

local secCode = miscTab:Section("Codes")
secCode:Textbox("Redeem a code", "enter code", function(text)
    if text and text ~= "" then
        local ok, res = fire("Settings.SubmitCode", text)
        warn("[Code] " .. ((ok and res == true) and ("Redeemed: " .. text) or ("Invalid: " .. text)))
    end
end)
secCode:Toggle("Auto-redeem code list", false, function(v) S.autoCodes = v end)

-- ---- SETTINGS ----
local secPerf = settingsTab:Section("Performance & Interface")
secPerf:Toggle("FPS Boost (low graphics)", false, function(v) S.fpsBoost = v; applyFpsBoost(v) end)
secPerf:Button("Unload hub (stops everything)", function() S.killed = true; pcall(function() ui:Destroy() end) end)

local secWeb = settingsTab:Section("Discord Webhook")
secWeb:Textbox("Webhook URL", "https://discord.com/api/webhooks/...", function(t) S.webhookUrl = t or "" end)
secWeb:Toggle("Enable reports", false, function(v) S.webhookEnabled = v end)
secWeb:Slider("Report interval (min)", 5, 1, 60, function(v) S.webhookInterval = v * 60 end)
secWeb:Button("Send test report", function() task.spawn(function() sendWebhook(true) end) end)

local secInfo = settingsTab:Section("Info")
secInfo:Label("Grow a Garden 2 · WalkyHub")
secInfo:Label("Hotkey: Left Ctrl toggles UI")

-- Auto-Pot loop (own grown plants flagged via prompt tag is rare; pot all listed plants)
loopOn(function() return S.autoPot end, 10, function()
    local plot = myPlot(); local plants = plot and plot:FindFirstChild("Plants")
    if not plants then return end
    for _, m in ipairs(plants:GetChildren()) do
        if not S.autoPot then break end
        local pid = m:GetAttribute("PlantId") or m.Name
        if pid then fire("Garden.PotPlant", tostring(pid)); task.wait(0.3) end
    end
end)

-- live status
task.spawn(function()
    while not S.killed do
        local p = myPlot()
        pcall(function() plotLabel:Set("Plot: " .. (p and p.Name or "?")) end)
        pcall(function() cashLabel:Set(string.format("Sheckles: %s · Tokens: %s", fmt(getSheckles()), fmt(getTokens()))) end)
        pcall(function() statLabel:Set(string.format("bought %d · planted %d · harvested %d · sold %d (+%s)",
            Stats.bought, Stats.planted, Stats.harvested, Stats.sold, fmt(Stats.earned))) end)
        task.wait(2)
    end
end)

pcall(function()
    if getgenv then getgenv().WalkyGAG2 = {
        S = S, Stats = Stats, Net = Net, fire = fire, action = action,
        catalog = CATALOG, gearNames = GEAR_NAMES, myPlot = myPlot, replica = replica,
        ripeHarvests = ripeHarvests, stealable = stealable, wildPets = wildPets,
        toolsByAttr = toolsByAttr, plantGrid = plantGrid, ownedPetNames = ownedPetNames, myBasePos = myBasePos,
        stepHarvest = stepHarvest, fireFast = fireFast, fruitCount = fruitCount, sellAllNow = sellAllNow, maxFruitCap = maxFruitCap,
        unload = function() S.killed = true; pcall(function() ui:Destroy() end) end,
    } end
end)

warn("[WalkyHub] GAG2 full-auto loaded · " .. #SEED_NAMES .. " seeds · " .. #GEAR_NAMES .. " gear")
print("[WalkyHub] Grow a Garden 2 full-auto loaded.")
