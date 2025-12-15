– STRANGER THINGS EPIC POWERS UI V2.0 - LOCAL SCRIPT
– Coloca este script en StarterPlayer > StarterPlayerScripts

local Players = game:GetService(“Players”)
local ReplicatedStorage = game:GetService(“ReplicatedStorage”)
local UserInputService = game:GetService(“UserInputService”)
local TweenService = game:GetService(“TweenService”)
local RunService = game:GetService(“RunService”)
local player = Players.LocalPlayer

– Esperar eventos
local powerEvents = ReplicatedStorage:WaitForChild(“PowerEvents”, 5)
if not powerEvents then
warn(“No se encontró PowerEvents”)
return
end

local telekinesisPower = powerEvents:WaitForChild(“TelekinesisPower”)
local explosionPower = powerEvents:WaitForChild(“ExplosionPower”)
local controlPower = powerEvents:WaitForChild(“ControlPower”)
local protectionPower = powerEvents:WaitForChild(“ProtectionPower”)
local healingPower = powerEvents:WaitForChild(“HealingPower”)
local superSpeedPower = powerEvents:WaitForChild(“SuperSpeedPower”)

– Configuración de cooldowns
local COOLDOWN_TIMES = {
Telekinesis = 15,
Explosion = 20,
Control = 25,
Protection = 60,
Healing = 18,
SuperSpeed = 12
}

local cooldowns = {
Telekinesis = 0,
Explosion = 0,
Control = 0,
Protection = 0,
Healing = 0,
SuperSpeed = 0
}

local powerButtons = {}

– ===== EFECTOS VISUALES EN PANTALLA =====

local function createScreenFlash(color, intensity)
local screenGui = player.PlayerGui:FindFirstChild(“PowerAbilityUI”)
if not screenGui then return end

```
local flash = Instance.new("Frame")
flash.Name = "ScreenFlash"
flash.Size = UDim2.new(1, 0, 1, 0)
flash.BackgroundColor3 = color
flash.BackgroundTransparency = 1 - intensity
flash.BorderSizePixel = 0
flash.ZIndex = 100
flash.Parent = screenGui

TweenService:Create(flash, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	BackgroundTransparency = 1
}):Play()

task.delay(0.3, function()
	flash:Destroy()
end)
```

end

local function createScreenVignette(color, duration)
local screenGui = player.PlayerGui:FindFirstChild(“PowerAbilityUI”)
if not screenGui then return end

```
local vignette = Instance.new("Frame")
vignette.Name = "Vignette"
vignette.Size = UDim2.new(1, 0, 1, 0)
vignette.BackgroundColor3 = color
vignette.BackgroundTransparency = 1
vignette.BorderSizePixel = 0
vignette.ZIndex = 50
vignette.Parent = screenGui

local gradient = Instance.new("UIGradient")
gradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.6, 0.95),
	NumberSequenceKeypoint.new(1, 0.3)
})
gradient.Parent = vignette

-- Pulso
task.spawn(function()
	for i = 1, math.floor(duration * 2) do
		if not vignette.Parent then break end
		TweenService:Create(vignette, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0.85
		}):Play()
		task.wait(0.4)
		TweenService:Create(vignette, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.4)
	end
	if vignette then vignette:Destroy() end
end)
```

end

local function createScreenDistortion()
local screenGui = player.PlayerGui:FindFirstChild(“PowerAbilityUI”)
if not screenGui then return end

```
-- Líneas de escaneo
for i = 1, 5 do
	task.spawn(function()
		task.wait(i * 0.1)
		local scanLine = Instance.new("Frame")
		scanLine.Size = UDim2.new(1, 0, 0, 2)
		scanLine.Position = UDim2.new(0, 0, 0, 0)
		scanLine.BackgroundColor3 = Color3.new(1, 1, 1)
		scanLine.BackgroundTransparency = 0.3
		scanLine.BorderSizePixel = 0
		scanLine.ZIndex = 60
		scanLine.Parent = screenGui
		
		TweenService:Create(scanLine, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {
			Position = UDim2.new(0, 0, 1, 0)
		}):Play()
		
		task.delay(0.6, function()
			scanLine:Destroy()
		end)
	end)
end
```

end

local function createPowerActivationEffect(powerName, color)
createScreenFlash(color, 0.4)
createScreenDistortion()

```
-- Partículas en los bordes de la pantalla
local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
if not screenGui then return end

for i = 1, 20 do
	task.spawn(function()
		task.wait(i * 0.03)
		local particle = Instance.new("Frame")
		particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
		particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
		particle.BackgroundColor3 = color
		particle.BorderSizePixel = 0
		particle.ZIndex = 70
		particle.Parent = screenGui
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = particle
		
		TweenService:Create(particle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0)
		}):Play()
		
		task.delay(0.8, function()
			particle:Destroy()
		end)
	end)
end
```

end

– ===== CREACIÓN DE UI ÉPICA =====

local function createPowerUI()
local screenGui = Instance.new(“ScreenGui”)
screenGui.Name = “PowerAbilityUI”
screenGui.Parent = player:WaitForChild(“PlayerGui”)
screenGui.DisplayOrder = 10
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

```
-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Size = UDim2.new(0, 470, 0, 95) -- 6 poderes
mainFrame.Position = UDim2.new(0.5, -235, 1, -125)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 100, 120)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

-- Brillo animado del borde
task.spawn(function()
	while mainFrame.Parent do
		TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Transparency = 0.2,
			Color = Color3.fromRGB(150, 150, 200)
		}):Play()
		task.wait(1.5)
		TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Transparency = 0.5,
			Color = Color3.fromRGB(100, 100, 120)
		}):Play()
		task.wait(1.5)
	end
end)

-- Layout
local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = mainFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = mainFrame

-- Información de los 6 poderes
local powerInfo = {
	{Name = "Telekinesis", Key = "Q", Color = Color3.fromRGB(138, 43, 226), Icon = "⚡", Desc = "TELEQUINESIS"},
	{Name = "Explosion", Key = "E", Color = Color3.fromRGB(195, 0, 0), Icon = "💥", Desc = "EXPLOSIÓN"},
	{Name = "Control", Key = "R", Color = Color3.fromRGB(255, 69, 0), Icon = "🧠", Desc = "CONTROL"},
	{Name = "Protection", Key = "T", Color = Color3.fromRGB(255, 10, 10), Icon = "🛡️", Desc = "PROTECCIÓN"},
	{Name = "Healing", Key = "F", Color = Color3.fromRGB(0, 255, 127), Icon = "💚", Desc = "CURACIÓN"},
	{Name = "SuperSpeed", Key = "G", Color = Color3.fromRGB(255, 215, 0), Icon = "⚡", Desc = "VELOCIDAD"}
}

for _, info in ipairs(powerInfo) do
	-- Contenedor
	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = info.Name .. "Container"
	buttonContainer.Size = UDim2.new(0, 68, 0, 68)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = mainFrame
	
	-- Botón principal
	local button = Instance.new("TextButton")
	button.Name = info.Name .. "Button"
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundColor3 = info.Color
	button.Text = ""
	button.AutoButtonColor = false
	button.ClipsDescendants = true
	button.BorderSizePixel = 0
	button.Parent = buttonContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Thickness = 2.5
	stroke.Transparency = 0.4
	stroke.Parent = button
	
	-- Gradiente
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, info.Color)
	})
	gradient.Rotation = 45
	gradient.Parent = button
	
	-- Icono
	local icon = Instance.new("TextLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.new(1, 0, 0.55, 0)
	icon.Position = UDim2.new(0, 0, 0, 0)
	icon.BackgroundTransparency = 1
	icon.Text = info.Icon
	icon.Font = Enum.Font.SourceSansBold
	icon.TextSize = 34
	icon.TextColor3 = Color3.new(1, 1, 1)
	icon.TextStrokeTransparency = 0
	icon.TextStrokeColor3 = Color3.new(0, 0, 0)
	icon.ZIndex = 2
	icon.Parent = button
	
	-- Overlay de cooldown
	local overlay = Instance.new("Frame")
	overlay.Name = "CooldownOverlay"
	overlay.BackgroundColor3 = Color3.new(0, 0, 0)
	overlay.BackgroundTransparency = 0.15
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Position = UDim2.new(0, 0, 0, 0)
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 3
	overlay.Parent = button
	
	local overlayCorner = Instance.new("UICorner")
	overlayCorner.CornerRadius = UDim.new(0, 12)
	overlayCorner.Parent = overlay
	
	-- Timer
	local timerText = Instance.new("TextLabel")
	timerText.Name = "TimerText"
	timerText.BackgroundTransparency = 1
	timerText.Text = ""
	timerText.Font = Enum.Font.SourceSansBold
	timerText.TextSize = 32
	timerText.TextColor3 = Color3.new(1, 1, 1)
	timerText.TextStrokeTransparency = 0
	timerText.ZIndex = 4
	timerText.Size = UDim2.new(1, 0, 1, 0)
	timerText.Parent = overlay
	
	-- Tecla
	local keyLabel = Instance.new("TextLabel")
	keyLabel.Name = "KeyLabel"
	keyLabel.Size = UDim2.new(0, 26, 0, 26)
	keyLabel.Position = UDim2.new(1, -30, 1, -30)
	keyLabel.BackgroundColor3 = Color3.new(0, 0, 0)
	keyLabel.BackgroundTransparency = 0.2
	keyLabel.Text = info.Key
	keyLabel.Font = Enum.Font.SourceSansBold
	keyLabel.TextSize = 18
	keyLabel.TextColor3 = Color3.new(1, 1, 1)
	keyLabel.ZIndex = 5
	keyLabel.BorderSizePixel = 0
	keyLabel.Parent = button
	
	local keyCorner = Instance.new("UICorner")
	keyCorner.CornerRadius = UDim.new(0, 5)
	keyCorner.Parent = keyLabel
	
	-- Nombre del poder
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
	nameLabel.Position = UDim2.new(0, 0, 0.65, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = info.Desc
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.TextSize = 9
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextStrokeTransparency = 0.3
	nameLabel.TextScaled = true
	nameLabel.ZIndex = 2
	nameLabel.Parent = button
	
	-- Efectos hover
	button.MouseEnter:Connect(function()
		TweenService:Create(buttonContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 73, 0, 73)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {
			Transparency = 0.1,
			Thickness = 3
		}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(buttonContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 68, 0, 68)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {
			Transparency = 0.4,
			Thickness = 2.5
		}):Play()
	end)
	
	powerButtons[info.Name] = {
		Button = button,
		Overlay = overlay,
		Timer = timerText,
		KeyCode = Enum.KeyCode[info.Key],
		Color = info.Color,
		Container = buttonContainer,
		Icon = icon
	}
end
```

end

– ===== LÓGICA DE COOLDOWN =====

local function startCooldown(powerName, duration)
local data = powerButtons[powerName]
if not data then return end

```
local overlay = data.Overlay
local timerText = data.Timer

overlay.Size = UDim2.new(1, 0, 1, 0)
timerText.Text = tostring(duration)

local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local tween = TweenService:Create(overlay, tweenInfo, {Size = UDim2.new(1, 0, 0, 0)})
tween:Play()

local startTime = tick()
local endTime = startTime + duration

local updateTimer = RunService.Heartbeat:Connect(function()
	local remaining = endTime - tick()
	
	if remaining <= 0.5 then
		timerText.Text = ""
		updateTimer:Disconnect()
		
		-- Animación de disponible
		local button = data.Button
		TweenService:Create(button, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 1, 10)
		}):Play()
		
		-- Efecto de brillo
		TweenService:Create(button, TweenInfo.new(0.3), {
			BackgroundColor3 = Color3.new(1, 1, 1)
		}):Play()
		task.wait(0.3)
		TweenService:Create(button, TweenInfo.new(0.3), {
			BackgroundColor3 = data.Color,
			Size = UDim2.new(1, 0, 1, 0)
		}):Play()
		return
	end
	
	timerText.Text = tostring(math.ceil(remaining))
end)
```

end

local function showFeedback(powerName, message, duration)
local data = powerButtons[powerName]
if not data then return end

```
local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
if not screenGui then return end

local feedback = Instance.new("Frame")
feedback.Name = "Feedback"
feedback.Size = UDim2.new(0, 240, 0, 50)
feedback.Position = UDim2.new(0.5, -120, 0.5, -25)
feedback.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
feedback.BackgroundTransparency = 0.2
feedback.BorderSizePixel = 0
feedback.ZIndex = 80
feedback.Parent = screenGui

local feedbackCorner = Instance.new("UICorner")
feedbackCorner.CornerRadius = UDim.new(0, 10)
feedbackCorner.Parent = feedback

local feedbackStroke = Instance.new("UIStroke")
feedbackStroke.Color = data.Color
feedbackStroke.Thickness = 3
feedbackStroke.Parent = feedback

local feedbackText = Instance.new("TextLabel")
feedbackText.Size = UDim2.new(1, 0, 1, 0)
feedbackText.BackgroundTransparency = 1
feedbackText.Text = message
feedbackText.Font = Enum.Font.SourceSansBold
feedbackText.TextSize = 22
feedbackText.TextColor3 = data.Color
feedbackText.TextStrokeTransparency = 0
feedbackText.Parent = feedback

-- Animación de entrada
feedback.Position = UDim2.new(0.5, -120, 0.5, -80)
TweenService:Create(feedback, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, -120, 0.5, -25)
}):Play()

task.delay(duration or 2, function()
	TweenService:Create(feedback, TweenInfo.new(0.3), {
		Position = UDim2.new(0.5, -120, 0.5, 20),
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(feedbackText, TweenInfo.new(0.3), {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	}):Play()
	TweenService:Create(feedbackStroke, TweenInfo.new(0.3), {
		Transparency = 1
	}):Play()
	task.wait(0.3)
	feedback:Destroy()
end)
```

end

– ===== SISTEMA DE TARGET =====

local function getTargetPlayer()
local mouse = player:GetMouse()
local mouseTarget = mouse.Target
local MAX_RANGE = 70

```
if mouseTarget then
	local character = mouseTarget:FindFirstAncestorOfClass("Model")
	if character and character:FindFirstChild("Humanoid") then
		local targetPlayer = Players:GetPlayerFromCharacter(character)
		if targetPlayer and targetPlayer ~= player then
			return targetPlayer
		end
	end
end

local playerCharacter = player.Character
if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
	local closestPlayer = nil
	local closestDistance = MAX_RANGE
	
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (playerCharacter.HumanoidRootPart.Position - 
				otherPlayer.Character.HumanoidRootPart.Position).Magnitude
			
			if distance < closestDistance then
				closestDistance = distance
				closestPlayer = otherPlayer
			end
		end
	end
	
	return closestPlayer
end

return nil
```

end

– ===== MANEJO DE PODERES =====

local function handlePowerUse(powerName, target)
local now = tick()

```
if cooldowns[powerName] > now then
	showFeedback(powerName, "⏱️ EN COOLDOWN", 1)
	return
end

local requiredCooldown = COOLDOWN_TIMES[powerName]
local targetRequired = (powerName == "Telekinesis" or powerName == "Explosion" or powerName == "Healing")

if targetRequired and not target then
	showFeedback(powerName, "⚠️ APUNTA A UN JUGADOR", 1.5)
	return
end

local success = false

if powerName == "Telekinesis" and target then
	telekinesisPower:FireServer(target)
	success = true
elseif powerName == "Explosion" and target then
	explosionPower:FireServer(target)
	success = true
elseif powerName == "Control" then
	controlPower:FireServer()
	success = true
elseif powerName == "Protection" then
	protectionPower:FireServer()
	success = true
elseif powerName == "Healing" and target then
	healingPower:FireServer(target)
	success = true
elseif powerName == "SuperSpeed" then
	superSpeedPower:FireServer()
	success = true
end

if success then
	cooldowns[powerName] = now + requiredCooldown
	startCooldown(powerName, requiredCooldown)
	createPowerActivationEffect(powerName, powerButtons[powerName].Color)
	
	-- Vignette según duración del poder
	if powerName == "Protection" then
		createScreenVignette(powerButtons[powerName].Color, 30)
	elseif powerName == "SuperSpeed" then
		createScreenVignette(powerButtons[powerName].Color, 6)
	elseif powerName == "Control" then
		createScreenVignette(powerButtons[powerName].Color, 10)
	end
end
```

end

local function handleKeyboardInput(input, gameProcessed)
if gameProcessed then return end

```
local key = input.KeyCode
local target = getTargetPlayer()

for powerName, data in pairs(powerButtons) do
	if key == data.KeyCode then
		handlePowerUse(powerName, target)
		break
	end
end
```

end

– ===== INICIALIZACIÓN =====

createPowerUI()

– Conectar clicks
for powerName, data in pairs(powerButtons) do
local needsTarget = (powerName == “Telekinesis” or powerName == “Explosion” or powerName == “Healing”)
data.Button.MouseButton1Click:Connect(function()
local target = needsTarget and getTargetPlayer()
handlePowerUse(powerName, target)
end)
end

UserInputService.InputBegan:Connect(handleKeyboardInput)

print(“✓ STRANGER THINGS EPIC POWERS UI V2.0 LOADED”)
print(“✓ Q = Telekinesis | E = Explosión | R = Control”)
print(“✓ T = Protección | F = Curación | G = Super Velocidad”)
