-- ====================================================================
-- STRANGER THINGS EPIC POWERS UI - ENHANCED EDITION
-- Script Local - Interfaz Visual Profesional
-- Coloca este script en StarterPlayer > StarterPlayerScripts
-- ====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Esperar eventos
local powerEvents = ReplicatedStorage:WaitForChild("PowerEvents", 10)
if not powerEvents then
	warn("⚠️ No se encontró PowerEvents")
	return
end

local telekinesisPower = powerEvents:WaitForChild("TelekinesisPower", 5)
local explosionPower = powerEvents:WaitForChild("ExplosionPower", 5)
local controlPower = powerEvents:WaitForChild("ControlPower", 5)
local protectionPower = powerEvents:WaitForChild("ProtectionPower", 5)
local healingPower = powerEvents:WaitForChild("HealingPower", 5)

-- Configuración
local COOLDOWN_TIMES = {
	Telekinesis = 15,
	Explosion = 20,
	Control = 25,
	Protection = 60,
	Healing = 18
}

local cooldowns = {
	Telekinesis = 0,
	Explosion = 0,
	Control = 0,
	Protection = 0,
	Healing = 0
}

local powerButtons = {}

-- ====================================================================
-- EFECTOS VISUALES ÉPICOS EN PANTALLA - MEJORADOS
-- ====================================================================

local function createEnhancedVignette(color, intensity)
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	local vignette = Instance.new("Frame")
	vignette.Name = "Vignette"
	vignette.Size = UDim2.new(1, 0, 1, 0)
	vignette.Position = UDim2.new(0, 0, 0, 0)
	vignette.BackgroundColor3 = color
	vignette.BackgroundTransparency = 1
	vignette.BorderSizePixel = 0
	vignette.ZIndex = 5
	vignette.Parent = screenGui
	
	-- Gradiente radial mejorado
	local gradient = Instance.new("UIGradient")
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.4, 0.95),
		NumberSequenceKeypoint.new(0.7, 0.85),
		NumberSequenceKeypoint.new(1, 0)
	})
	gradient.Rotation = 0
	gradient.Parent = vignette
	
	-- Animación de pulso múltiple
	task.spawn(function()
		for i = 1, 4 do
			TweenService:Create(vignette, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 0.6 + (intensity or 0)
			}):Play()
			task.wait(0.25)
			TweenService:Create(vignette, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 1
			}):Play()
			task.wait(0.25)
		end
		vignette:Destroy()
	end)
	
	return vignette
end

local function createScreenDistortion()
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	local distortion = Instance.new("Frame")
	distortion.Name = "Distortion"
	distortion.Size = UDim2.new(1, 20, 1, 20)
	distortion.Position = UDim2.new(0, -10, 0, -10)
	distortion.BackgroundTransparency = 1
	distortion.ZIndex = 6
	distortion.Parent = screenGui
	
	-- Múltiples líneas de escaneo
	for i = 1, 3 do
		task.spawn(function()
			task.wait(i * 0.15)
			local scanLine = Instance.new("Frame")
			scanLine.Size = UDim2.new(1, 0, 0, 2 + i)
			scanLine.Position = UDim2.new(0, 0, math.random(0, 100) / 100, 0)
			scanLine.BackgroundColor3 = Color3.new(1, 1, 1)
			scanLine.BackgroundTransparency = 0.4
			scanLine.BorderSizePixel = 0
			scanLine.ZIndex = 7
			scanLine.Parent = distortion
			
			local gradient = Instance.new("UIGradient")
			gradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(1, 1)
			})
			gradient.Rotation = 90
			gradient.Parent = scanLine
			
			TweenService:Create(scanLine, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {
				Position = UDim2.new(0, 0, 1, 0)
			}):Play()
		end)
	end
	
	task.delay(0.6, function()
		distortion:Destroy()
	end)
end

local function createChromaberration(color, duration)
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	-- Efecto de aberración cromática
	local aberration = Instance.new("Frame")
	aberration.Name = "ChromaAberration"
	aberration.Size = UDim2.new(1, 4, 1, 4)
	aberration.Position = UDim2.new(0, -2, 0, -2)
	aberration.BackgroundTransparency = 1
	aberration.ZIndex = 8
	aberration.Parent = screenGui
	
	for i = 1, 3 do
		local layer = Instance.new("Frame")
		layer.Size = UDim2.new(1, 0, 1, 0)
		layer.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 0, 0) or (i == 2 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 255))
		layer.BackgroundTransparency = 0.95
		layer.BorderSizePixel = 0
		layer.Parent = aberration
		
		task.spawn(function()
			local offset = (i - 2) * 0.002
			TweenService:Create(layer, TweenInfo.new(duration or 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(offset, 0, 0, 0)
			}):Play()
		end)
	end
	
	task.delay(duration or 0.5, function()
		aberration:Destroy()
	end)
end

local function createPowerActivationEffect(powerName, color)
	-- Viñeta mejorada
	createEnhancedVignette(color, 0.1)
	
	-- Distorsión de pantalla
	createScreenDistortion()
	
	-- Aberración cromática
	createChromaberration(color, 0.4)
	
	-- Flash rápido con gradiente
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	local flash = Instance.new("Frame")
	flash.Name = "Flash"
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.Position = UDim2.new(0, 0, 0, 0)
	flash.BackgroundColor3 = color
	flash.BackgroundTransparency = 0.2
	flash.BorderSizePixel = 0
	flash.ZIndex = 10
	flash.Parent = screenGui
	
	local gradient = Instance.new("UIGradient")
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(0.5, 0.5),
		NumberSequenceKeypoint.new(1, 0.2)
	})
	gradient.Rotation = 45
	gradient.Parent = flash
	
	TweenService:Create(flash, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	}):Play()
	
	task.delay(0.3, function()
		flash:Destroy()
	end)
	
	-- Ondas expansivas en los bordes
	for i = 1, 4 do
		task.spawn(function()
			task.wait(i * 0.05)
			local wave = Instance.new("Frame")
			wave.Size = UDim2.new(0, 0, 0, 0)
			wave.Position = UDim2.new(0.5, 0, 0.5, 0)
			wave.AnchorPoint = Vector2.new(0.5, 0.5)
			wave.BackgroundTransparency = 0.5
			wave.BackgroundColor3 = color
			wave.BorderSizePixel = 0
			wave.ZIndex = 9
			wave.Parent = screenGui
			
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = wave
			
			TweenService:Create(wave, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(2, 0, 2, 0),
				BackgroundTransparency = 1
			}):Play()
			
			task.delay(0.6, function()
				wave:Destroy()
			end)
		end)
	end
end

-- ====================================================================
-- CREACIÓN DE UI MEJORADA CON DISEÑO PROFESIONAL
-- ====================================================================

local function createPowerUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PowerAbilityUI"
	screenGui.Parent = player:WaitForChild("PlayerGui")
	screenGui.DisplayOrder = 10
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	
	-- Frame principal con efecto de cristal esmerilado
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	mainFrame.BackgroundTransparency = 0.25
	mainFrame.Size = UDim2.new(0, 410, 0, 100)
	mainFrame.Position = UDim2.new(0.5, -205, 1, -130)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	-- Esquinas redondeadas
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 15)
	mainCorner.Parent = mainFrame
	
	-- Borde brillante animado
	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(255, 255, 255)
	mainStroke.Thickness = 2.5
	mainStroke.Transparency = 0.65
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainStroke.Parent = mainFrame
	
	-- Gradiente de fondo
	local bgGradient = Instance.new("UIGradient")
	bgGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
	})
	bgGradient.Rotation = 90
	bgGradient.Parent = mainFrame
	
	-- Efecto de brillo animado en el borde
	task.spawn(function()
		while mainFrame.Parent do
			TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Transparency = 0.35
			}):Play()
			task.wait(1.5)
			TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Transparency = 0.65
			}):Play()
			task.wait(1.5)
		end
	end)
	
	-- Layout
	local listLayout = Instance.new("UIListLayout")
	listLayout.Name = "ButtonLayout"
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	listLayout.Padding = UDim.new(0, 10)
	listLayout.Parent = mainFrame
	
	-- Padding interno
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 12)
	padding.PaddingBottom = UDim.new(0, 12)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = mainFrame
	
	-- Información de poderes
	local powerInfo = {
		{Name = "Telekinesis", Key = "Q", Color = Color3.fromRGB(138, 43, 226), Icon = "⚡", Desc = "MENTAL"},
		{Name = "Explosion", Key = "E", Color = Color3.fromRGB(195, 0, 0), Icon = "💥", Desc = "BLAST"},
		{Name = "Control", Key = "R", Color = Color3.fromRGB(255, 69, 0), Icon = "🌀", Desc = "MIND"},
		{Name = "Protection", Key = "T", Color = Color3.fromRGB(255, 10, 10), Icon = "🛡️", Desc = "SHIELD"},
		{Name = "Healing", Key = "F", Color = Color3.fromRGB(0, 255, 127), Icon = "💚", Desc = "HEAL"}
	}
	
	for _, info in ipairs(powerInfo) do
		-- Contenedor del botón
		local buttonContainer = Instance.new("Frame")
		buttonContainer.Name = info.Name .. "Container"
		buttonContainer.Size = UDim2.new(0, 72, 0, 72)
		buttonContainer.BackgroundTransparency = 1
		buttonContainer.Parent = mainFrame
		
		-- Botón principal con efecto de profundidad
		local button = Instance.new("TextButton")
		button.Name = info.Name .. "Button"
		button.Size = UDim2.new(1, 0, 1, 0)
		button.BackgroundColor3 = info.Color
		button.Text = ""
		button.Parent = buttonContainer
		button.AutoButtonColor = false
		button.ClipsDescendants = true
		button.BorderSizePixel = 0
		
		-- Esquinas
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = button
		
		-- Borde del botón con color del poder
		local stroke = Instance.new("UIStroke")
		stroke.Color = info.Color
		stroke.Thickness = 2.5
		stroke.Transparency = 0.4
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = button
		
		-- Gradiente mejorado con efecto metálico
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(
				math.clamp(info.Color.R * 255 * 1.3, 0, 255),
				math.clamp(info.Color.G * 255 * 1.3, 0, 255),
				math.clamp(info.Color.B * 255 * 1.3, 0, 255)
			)),
			ColorSequenceKeypoint.new(0.5, info.Color),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(
				info.Color.R * 255 * 0.7,
				info.Color.G * 255 * 0.7,
				info.Color.B * 255 * 0.7
			))
		})
		gradient.Rotation = 135
		gradient.Parent = button
		
		-- Brillo interior animado
		local shine = Instance.new("Frame")
		shine.Name = "Shine"
		shine.Size = UDim2.new(0, 40, 1, 0)
		shine.Position = UDim2.new(-0.5, 0, 0, 0)
		shine.BackgroundColor3 = Color3.new(1, 1, 1)
		shine.BackgroundTransparency = 0.7
		shine.BorderSizePixel = 0
		shine.Rotation = 20
		shine.ZIndex = 2
		shine.Parent = button
		
		local shineGradient = Instance.new("UIGradient")
		shineGradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0.3),
			NumberSequenceKeypoint.new(1, 1)
		})
		shineGradient.Parent = shine
		
		-- Animación de brillo ocasional
		task.spawn(function()
			while button.Parent do
				task.wait(math.random(3, 6))
				TweenService:Create(shine, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					Position = UDim2.new(1.5, 0, 0, 0)
				}):Play()
				task.wait(1)
				shine.Position = UDim2.new(-0.5, 0, 0, 0)
			end
		end)
		
		-- Icono/Emoji con sombra
		local iconShadow = Instance.new("TextLabel")
		iconShadow.Name = "IconShadow"
		iconShadow.Size = UDim2.new(1, 0, 0.55, 0)
		iconShadow.Position = UDim2.new(0, 2, 0, 2)
		iconShadow.BackgroundTransparency = 1
		iconShadow.Text = info.Icon
		iconShadow.Font = Enum.Font.SourceSansBold
		iconShadow.TextSize = 34
		iconShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
		iconShadow.TextTransparency = 0.5
		iconShadow.ZIndex = 2
		iconShadow.Parent = button
		
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
		icon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		icon.ZIndex = 3
		icon.Parent = button
		
		-- Overlay de cooldown mejorado
		local overlay = Instance.new("Frame")
		overlay.Name = "CooldownOverlay"
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 0.15
		overlay.Size = UDim2.new(1, 0, 1, 0)
		overlay.Position = UDim2.new(0, 0, 0, 0)
		overlay.BorderSizePixel = 0
		overlay.ZIndex = 4
		overlay.Parent = button
		
		local overlayCorner = Instance.new("UICorner")
		overlayCorner.CornerRadius = UDim.new(0, 12)
		overlayCorner.Parent = overlay
		
		-- Gradiente en overlay
		local overlayGradient = Instance.new("UIGradient")
		overlayGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
		})
		overlayGradient.Rotation = 90
		overlayGradient.Parent = overlay
		
		-- Timer text mejorado
		local timerText = Instance.new("TextLabel")
		timerText.Name = "TimerText"
		timerText.BackgroundTransparency = 1
		timerText.Text = ""
		timerText.Font = Enum.Font.SourceSansBold
		timerText.TextSize = 32
		timerText.TextColor3 = Color3.new(1, 1, 1)
		timerText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		timerText.TextStrokeTransparency = 0
		timerText.ZIndex = 5
		timerText.Size = UDim2.new(1, 0, 1, 0)
		timerText.Parent = overlay
		
		-- Barra de progreso circular (decorativa)
		local progressCircle = Instance.new("ImageLabel")
		progressCircle.Name = "ProgressCircle"
		progressCircle.Size = UDim2.new(0.9, 0, 0.9, 0)
		progressCircle.Position = UDim2.new(0.05, 0, 0.05, 0)
		progressCircle.BackgroundTransparency = 1
		progressCircle.Image = "rbxassetid://6101261905"
		progressCircle.ImageColor3 = info.Color
		progressCircle.ImageTransparency = 0.7
		progressCircle.ZIndex = 4
		progressCircle.Visible = false
		progressCircle.Parent = button
		
		-- Tecla (abajo a la derecha) mejorada
		local keyLabel = Instance.new("TextLabel")
		keyLabel.Name = "KeyLabel"
		keyLabel.Size = UDim2.new(0, 26, 0, 26)
		keyLabel.Position = UDim2.new(1, -30, 1, -30)
		keyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		keyLabel.BackgroundTransparency = 0.25
		keyLabel.Text = info.Key
		keyLabel.Font = Enum.Font.SourceSansBold
		keyLabel.TextSize = 16
		keyLabel.TextColor3 = Color3.new(1, 1, 1)
		keyLabel.ZIndex = 6
		keyLabel.BorderSizePixel = 0
		keyLabel.Parent = button
		
		local keyCorner = Instance.new("UICorner")
		keyCorner.CornerRadius = UDim.new(0, 5)
		keyCorner.Parent = keyLabel
		
		local keyStroke = Instance.new("UIStroke")
		keyStroke.Color = info.Color
		keyStroke.Thickness = 1.5
		keyStroke.Transparency = 0.5
		keyStroke.Parent = keyLabel
		
		-- Nombre del poder (abajo) mejorado
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "NameLabel"
		nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
		nameLabel.Position = UDim2.new(0, 0, 0.65, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = info.Desc
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.TextSize = 11
		nameLabel.TextColor3 = Color3.new(1, 1, 1)
		nameLabel.TextStrokeTransparency = 0.3
		nameLabel.TextScaled = false
		nameLabel.ZIndex = 3
		nameLabel.Parent = button
		
		-- Efecto hover mejorado
		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 1, 6)
			}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.2), {
				Transparency = 0.1,
				Thickness = 3
			}):Play()
			TweenService:Create(icon, TweenInfo.new(0.2), {
				TextSize = 38
			}):Play()
			
			-- Partículas en hover
			for i = 1, 3 do
				task.spawn(function()
					local particle = Instance.new("Frame")
					particle.Size = UDim2.new(0, 4, 0, 4)
					particle.Position = UDim2.new(math.random(20, 80) / 100, 0, math.random(20, 80) / 100, 0)
					particle.BackgroundColor3 = info.Color
					particle.BorderSizePixel = 0
					particle.ZIndex = 2
					particle.Parent = button
					
					local particleCorner = Instance.new("UICorner")
					particleCorner.CornerRadius = UDim.new(1, 0)
					particleCorner.Parent = particle
					
					TweenService:Create(particle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(math.random(-20, 120) / 100, 0, math.random(-20, 120) / 100, 0),
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 8, 0, 8)
					}):Play()
					
					task.delay(0.8, function()
						particle:Destroy()
					end)
				end)
			end
		end)
		
		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 1, 0)
			}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.2), {
				Transparency = 0.4,
				Thickness = 2.5
			}):Play()
			TweenService:Create(icon, TweenInfo.new(0.2), {
				TextSize = 34
			}):Play()
		end)
		
		-- Efecto de click
		button.MouseButton1Down:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.1), {
				Size = UDim2.new(0.95, 0, 0.95, 0)
			}):Play()
		end)
		
		button.MouseButton1Up:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.1), {
				Size = UDim2.new(1, 0, 1, 0)
			}):Play()
		end)
		
		powerButtons[info.Name] = {
			Button = button,
			Overlay = overlay,
			Timer = timerText,
			Progress = progressCircle,
			KeyCode = Enum.KeyCode[info.Key],
			Color = info.Color,
			Container = buttonContainer,
			Icon = icon,
			Stroke = stroke
		}
	end
end

-- ====================================================================
-- LÓGICA DE COOLDOWN MEJORADA
-- ====================================================================

local function startCooldown(powerName, duration)
	local data = powerButtons[powerName]
	if not data then return end
	
	local overlay = data.Overlay
	local timerText = data.Timer
	local progressCircle = data.Progress
	
	-- Mostrar overlay completo
	overlay.Size = UDim2.new(1, 0, 1, 0)
	timerText.Text = tostring(duration)
	progressCircle.Visible = true
	
	-- Tween de reducción suave
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local properties = {Size = UDim2.new(1, 0, 0, 0)}
	
	local cooldownTween = TweenService:Create(overlay, tweenInfo, properties)
	cooldownTween:Play()
	
	-- Animación del círculo de progreso
	task.spawn(function()
		local startTime = tick()
		while tick() - startTime < duration do
			local progress = (tick() - startTime) / duration
			progressCircle.Rotation = progress * 360
			task.wait(0.05)
		end
	end)
	
	-- Actualizar timer
	local startTime = tick()
	local endTime = startTime + duration
	
	local updateTimer
	updateTimer = RunService.Heartbeat:Connect(function()
		local remaining = endTime - tick()
		
		if remaining <= 0.5 then
			timerText.Text = ""
			progressCircle.Visible = false
			updateTimer:Disconnect()
			
			-- Efecto de disponible épico
			local button = data.Button
			local icon = data.Icon
			local stroke = data.Stroke
			
			-- Pulso de disponibilidad
			for i = 1, 2 do
				task.spawn(function()
					TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 1, 10)
					}):Play()
					TweenService:Create(stroke, TweenInfo.new(0.2), {
						Transparency = 0,
						Thickness = 4
					}):Play()
					TweenService:Create(icon, TweenInfo.new(0.2), {
						TextSize = 40
					}):Play()
					task.wait(0.2)
					TweenService:Create(button, TweenInfo.new(0.15), {
						Size = UDim2.new(1, 0, 1, 0)
					}):Play()
					TweenService:Create(stroke, TweenInfo.new(0.15), {
						Transparency = 0.4,
						Thickness = 2.5
					}):Play()
					TweenService:Create(icon, TweenInfo.new(0.15), {
						TextSize = 34
					}):Play()
					task.wait(0.3)
				end)
			end
			
			-- Partículas de celebración
			for i = 1, 8 do
				task.spawn(function()
					task.wait(i * 0.05)
					local particle = Instance.new("Frame")
					particle.Size = UDim2.new(0, 6, 0, 6)
					particle.Position = UDim2.new(0.5, 0, 0.5, 0)
					particle.AnchorPoint = Vector2.new(0.5, 0.5)
					particle.BackgroundColor3 = data.Color
					particle.BorderSizePixel = 0
					particle.ZIndex = 7
					particle.Parent = button
					
					local corner = Instance.new("UICorner")
					corner.CornerRadius = UDim.new(1, 0)
					corner.Parent = particle
					
					local angle = (i / 8) * math.pi * 2
					local distance = 60
					TweenService:Create(particle, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(0.5, math.cos(angle) * distance, 0.5, math.sin(angle) * distance),
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 12, 0, 12)
					}):Play()
					
					task.delay(0.6, function()
						particle:Destroy()
					end)
				end)
			end
			
			return
		end
		
		-- Actualizar texto con efecto de parpadeo en los últimos 3 segundos
		if remaining <= 3 then
			local pulse = math.sin(tick() * 10) * 0.5 + 0.5
			timerText.TextColor3 = Color3.new(1, pulse, pulse)
			timerText.TextSize = 32 + pulse * 4
		end
		
		timerText.Text = tostring(math.ceil(remaining))
	end)
end

local function showFeedback(powerName, message, duration, isError)
	local data = powerButtons[powerName]
	if not data then return end
	
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	local feedback = Instance.new("Frame")
	feedback.Name = "Feedback"
	feedback.Size = UDim2.new(0, 240, 0, 50)
	feedback.Position = UDim2.new(0.5, -120, 0.4, -25)
	feedback.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	feedback.BackgroundTransparency = 0.2
	feedback.BorderSizePixel = 0
	feedback.ZIndex = 25
	feedback.Parent = screenGui
	
	local feedbackCorner = Instance.new("UICorner")
	feedbackCorner.CornerRadius = UDim.new(0, 10)
	feedbackCorner.Parent = feedback
	
	local feedbackStroke = Instance.new("UIStroke")
	feedbackStroke.Color = isError and Color3.fromRGB(255, 50, 50) or data.Color
	feedbackStroke.Thickness = 2
	feedbackStroke.Transparency = 0.3
	feedbackStroke.Parent = feedback
	
	local feedbackGradient = Instance.new("UIGradient")
	feedbackGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
	})
	feedbackGradient.Rotation = 45
	feedbackGradient.Parent = feedback
	
	local feedbackText = Instance.new("TextLabel")
	feedbackText.Size = UDim2.new(1, -20, 1, 0)
	feedbackText.Position = UDim2.new(0, 10, 0, 0)
	feedbackText.BackgroundTransparency = 1
	feedbackText.Text = message
	feedbackText.Font = Enum.Font.SourceSansBold
	feedbackText.TextSize = 20
	feedbackText.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or data.Color
	feedbackText.TextStrokeTransparency = 0
	feedbackText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	feedbackText.TextXAlignment = Enum.TextXAlignment.Center
	feedbackText.ZIndex = 26
	feedbackText.Parent = feedback
	
	-- Animación de entrada
	feedback.Position = UDim2.new(0.5, -120, 0.3, -25)
	feedback.BackgroundTransparency = 1
	feedbackText.TextTransparency = 1
	feedbackText.TextStrokeTransparency = 1
	feedbackStroke.Transparency = 1
	
	TweenService:Create(feedback, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -120, 0.4, -25),
		BackgroundTransparency = 0.2
	}):Play()
	TweenService:Create(feedbackText, TweenInfo.new(0.3), {
		TextTransparency = 0,
		TextStrokeTransparency = 0
	}):Play()
	TweenService:Create(feedbackStroke, TweenInfo.new(0.3), {
		Transparency = 0.3
	}):Play()
	
	-- Pulso de borde
	task.spawn(function()
		for i = 1, 3 do
			TweenService:Create(feedbackStroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Thickness = 3
			}):Play()
			task.wait(0.3)
			TweenService:Create(feedbackStroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Thickness = 2
			}):Play()
			task.wait(0.3)
		end
	end)
	
	task.delay(duration or 2, function()
		TweenService:Create(feedback, TweenInfo.new(0.4), {
			Position = UDim2.new(0.5, -120, 0.3, -25),
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(feedbackText, TweenInfo.new(0.4), {
			TextTransparency = 1,
			TextStrokeTransparency = 1
		}):Play()
		TweenService:Create(feedbackStroke, TweenInfo.new(0.4), {
			Transparency = 1
		}):Play()
		task.wait(0.4)
		feedback:Destroy()
	end)
end

-- ====================================================================
-- SISTEMA DE TARGET
-- ====================================================================

local function getTargetPlayer()
	local mouse = player:GetMouse()
	local mouseTarget = mouse.Target
	local targetPlayer = nil
	local MAX_TARGET_RANGE = 70
	
	if mouseTarget then
		local character = mouseTarget:FindFirstAncestorOfClass("Model")
		if character and character:FindFirstChild("Humanoid") then
			targetPlayer = Players:GetPlayerFromCharacter(character)
		end
	end
	
	if targetPlayer and targetPlayer ~= player then
		return targetPlayer
	end
	
	local playerCharacter = player.Character
	if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
		local closestPlayer = nil
		local closestDistance = MAX_TARGET_RANGE
		
		for _, otherPlayer in pairs(Players:GetPlayers()) do
			if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local distance = (playerCharacter.HumanoidRootPart.Position - 
					otherPlayer.Character.HumanoidRootPart.Position).Magnitude
				
				if distance < closestDistance and distance < MAX_TARGET_RANGE then
					closestDistance = distance
					closestPlayer = otherPlayer
				end
			end
		end
		
		return closestPlayer
	end
	
	return nil
end

-- ====================================================================
-- MANEJO DE PODERES
-- ====================================================================

local function handlePowerUse(powerName, target)
	local now = tick()
	
	if cooldowns[powerName] > now then
		showFeedback(powerName, "⏱️ COOLDOWN: " .. math.ceil(cooldowns[powerName] - now) .. "s", 1.5, true)
		return
	end
	
	local requiredCooldown = COOLDOWN_TIMES[powerName]
	local targetRequired = (powerName == "Telekinesis" or powerName == "Explosion" or powerName == "Healing")
	
	if targetRequired and not target then
		showFeedback(powerName, "⚠️ OBJETIVO NO ENCONTRADO", 1.5, true)
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
	end
	
	if success then
		cooldowns[powerName] = now + requiredCooldown
		startCooldown(powerName, requiredCooldown)
		createPowerActivationEffect(powerName, powerButtons[powerName].Color)
		showFeedback(powerName, "✓ " .. powerName:upper() .. " ACTIVADO", 1.5, false)
	end
end

local function handleKeyboardInput(input, gameProcessed)
	if gameProcessed then return end
	
	local key = input.KeyCode
	local target = getTargetPlayer()
	
	if key == powerButtons.Telekinesis.KeyCode then
		handlePowerUse("Telekinesis", target)
	elseif key == powerButtons.Explosion.KeyCode then
		handlePowerUse("Explosion", target)
	elseif key == powerButtons.Control.KeyCode then
		handlePowerUse("Control")
	elseif key == powerButtons.Protection.KeyCode then
		handlePowerUse("Protection")
	elseif key == powerButtons.Healing.KeyCode then
		handlePowerUse("Healing", target)
	end
end

local function handleButtonClick(powerName, targetRequired)
	local target = targetRequired and getTargetPlayer()
	handlePowerUse(powerName, target)
end

-- ====================================================================
-- INICIALIZACIÓN
-- ====================================================================

createPowerUI()

-- Conectar eventos de botones
powerButtons.Telekinesis.Button.MouseButton1Click:Connect(function()
	handleButtonClick("Telekinesis", true)
end)

powerButtons.Explosion.Button.MouseButton1Click:Connect(function()
	handleButtonClick("Explosion", true)
end)

powerButtons.Control.Button.MouseButton1Click:Connect(function()
	handleButtonClick("Control", false)
end)

powerButtons.Protection.Button.MouseButton1Click:Connect(function()
	handleButtonClick("Protection", false)
end)

powerButtons.Healing.Button.MouseButton1Click:Connect(function()
	handleButtonClick("Healing", true)
end)

UserInputService.InputBegan:Connect(handleKeyboardInput)

print("✅ STRANGER THINGS EPIC POWERS UI - ENHANCED EDITION LOADED")
print("✅ Interfaz visual profesional implementada")
print("✅ Efectos de pantalla cinemáticos mejorados")
print("✅ Animaciones fluidas y responsivas")
print("✅ Sistema de feedback avanzado")
print("✅ Q = Telekinesis | E = Explosion | R = Control | T = Protection | F = Healing")
