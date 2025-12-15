-- ════════════════════════════════════════════════════════════════════════════
-- STRANGER THINGS EPIC POWERS UI - LOCAL SCRIPT (VERSIÓN ULTRA ÉPICA)
-- Coloca este script en StarterPlayer > StarterPlayerScripts
-- ════════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════════════════════
-- ESPERAR EVENTOS
-- ════════════════════════════════════════════════════════════════════════════

local powerEvents = ReplicatedStorage:WaitForChild("PowerEvents", 10)
if not powerEvents then
	warn("❌ No se encontró PowerEvents")
	return
end

local telekinesisPower = powerEvents:WaitForChild("TelekinesisPower", 5)
local explosionPower = powerEvents:WaitForChild("ExplosionPower", 5)
local controlPower = powerEvents:WaitForChild("ControlPower", 5)
local protectionPower = powerEvents:WaitForChild("ProtectionPower", 5)
local healingPower = powerEvents:WaitForChild("HealingPower", 5)

-- ════════════════════════════════════════════════════════════════════════════
-- CONFIGURACIÓN
-- ════════════════════════════════════════════════════════════════════════════

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

-- ════════════════════════════════════════════════════════════════════════════
-- EFECTOS VISUALES EN PANTALLA (ÉPICOS)
-- ════════════════════════════════════════════════════════════════════════════

local function createScreenVignette(color)
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	local vignette = Instance.new("Frame")
	vignette.Name = "Vignette"
	vignette.Size = UDim2.new(1, 0, 1, 0)
	vignette.Position = UDim2.new(0, 0, 0, 0)
	vignette.BackgroundColor3 = color
	vignette.BackgroundTransparency = 1
	vignette.BorderSizePixel = 0
	vignette.ZIndex = 8
	vignette.Parent = screenGui
	
	-- Gradiente radial épico
	local gradient = Instance.new("UIGradient")
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.4, 0.95),
		NumberSequenceKeypoint.new(0.7, 0.7),
		NumberSequenceKeypoint.new(1, 0)
	})
	gradient.Rotation = 0
	gradient.Parent = vignette
	
	-- Animación de pulso épica
	task.spawn(function()
		for i = 1, 4 do
			TweenService:Create(vignette, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 0.65
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
	distortion.Size = UDim2.new(1, 40, 1, 40)
	distortion.Position = UDim2.new(0, -20, 0, -20)
	distortion.BackgroundTransparency = 1
	distortion.ZIndex = 9
	distortion.Parent = screenGui
	
	-- Múltiples líneas de escaneo
	for i = 1, 3 do
		task.spawn(function()
			task.wait(i * 0.1)
			local scanLine = Instance.new("Frame")
			scanLine.Size = UDim2.new(1, 0, 0, 4)
			scanLine.Position = UDim2.new(0, 0, 0, 0)
			scanLine.BackgroundColor3 = Color3.new(1, 1, 1)
			scanLine.BackgroundTransparency = 0.3
			scanLine.BorderSizePixel = 0
			scanLine.Parent = distortion
			
			-- Gradiente para el escaneo
			local gradient = Instance.new("UIGradient")
			gradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(1, 1)
			})
			gradient.Parent = scanLine
			
			TweenService:Create(scanLine, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {
				Position = UDim2.new(0, 0, 1, 0)
			}):Play()
		end)
	end
	
	task.delay(0.7, function()
		distortion:Destroy()
	end)
end

local function createScreenFlash(color)
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	local flash = Instance.new("Frame")
	flash.Name = "Flash"
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.Position = UDim2.new(0, 0, 0, 0)
	flash.BackgroundColor3 = color
	flash.BackgroundTransparency = 0.2
	flash.BorderSizePixel = 0
	flash.ZIndex = 15
	flash.Parent = screenGui
	
	TweenService:Create(flash, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	}):Play()
	
	task.delay(0.3, function()
		flash:Destroy()
	end)
end

local function createPowerActivationEffect(powerName, color)
	createScreenVignette(color)
	createScreenDistortion()
	createScreenFlash(color)
	
	-- Efecto de partículas en los bordes de la pantalla
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	for i = 1, 20 do
		task.spawn(function()
			local particle = Instance.new("Frame")
			particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
			particle.Position = UDim2.new(
				math.random(0, 1),
				math.random(-50, 50),
				math.random(0, 1),
				math.random(-50, 50)
			)
			particle.BackgroundColor3 = color
			particle.BackgroundTransparency = 0
			particle.BorderSizePixel = 0
			particle.ZIndex = 10
			particle.Parent = screenGui
			
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = particle
			
			-- Animación hacia el centro
			local centerPos = UDim2.new(0.5, 0, 0.5, 0)
			TweenService:Create(particle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = centerPos,
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			}):Play()
			
			task.delay(0.8, function()
				particle:Destroy()
			end)
		end)
	end
end

-- ════════════════════════════════════════════════════════════════════════════
-- CREACIÓN DE UI MEJORADA Y ÉPICA
-- ════════════════════════════════════════════════════════════════════════════

local function createPowerUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PowerAbilityUI"
	screenGui.Parent = player:WaitForChild("PlayerGui")
	screenGui.DisplayOrder = 10
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	
	-- ═══ FRAME PRINCIPAL CON DISEÑO FUTURISTA ═══
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	mainFrame.BackgroundTransparency = 0.2
	mainFrame.Size = UDim2.new(0, 410, 0, 95)
	mainFrame.Position = UDim2.new(0.5, -205, 1, -125)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	-- Esquinas redondeadas
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 15)
	mainCorner.Parent = mainFrame
	
	-- Borde brillante animado
	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(100, 200, 255)
	mainStroke.Thickness = 3
	mainStroke.Transparency = 0.5
	mainStroke.Parent = mainFrame
	
	-- Gradiente de fondo
	local bgGradient = Instance.new("UIGradient")
	bgGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
	})
	bgGradient.Rotation = 90
	bgGradient.Parent = mainFrame
	
	-- Animación del borde
	task.spawn(function()
		while mainFrame.Parent do
			TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Transparency = 0.2,
				Color = Color3.fromRGB(150, 220, 255)
			}):Play()
			task.wait(1.5)
			TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Transparency = 0.5,
				Color = Color3.fromRGB(100, 200, 255)
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
	
	-- ═══ INFORMACIÓN DE PODERES ═══
	local powerInfo = {
		{Name = "Telekinesis", Key = "Q", Color = Color3.fromRGB(138, 43, 226), Icon = "⚡", Description = "TELEQUINESIS"},
		{Name = "Explosion", Key = "E", Color = Color3.fromRGB(195, 0, 0), Icon = "💥", Description = "EXPLOSIÓN"},
		{Name = "Control", Key = "R", Color = Color3.fromRGB(255, 69, 0), Icon = "🌀", Description = "CONTROL"},
		{Name = "Protection", Key = "T", Color = Color3.fromRGB(255, 10, 10), Icon = "🛡️", Description = "PROTECCIÓN"},
		{Name = "Healing", Key = "F", Color = Color3.fromRGB(0, 255, 127), Icon = "💚", Description = "CURACIÓN"}
	}
	
	for index, info in ipairs(powerInfo) do
		-- ═══ CONTENEDOR DEL BOTÓN ═══
		local buttonContainer = Instance.new("Frame")
		buttonContainer.Name = info.Name .. "Container"
		buttonContainer.Size = UDim2.new(0, 72, 0, 72)
		buttonContainer.BackgroundTransparency = 1
		buttonContainer.Parent = mainFrame
		
		-- ═══ BOTÓN PRINCIPAL ═══
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
		
		-- Borde del botón
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Thickness = 2.5
		stroke.Transparency = 0.4
		stroke.Parent = button
		
		-- Gradiente dinámico
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, info.Color),
			ColorSequenceKeypoint.new(1, info.Color * 0.7)
		})
		gradient.Rotation = 135
		gradient.Parent = button
		
		-- Animación del gradiente
		task.spawn(function()
			while button.Parent do
				TweenService:Create(gradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					Rotation = 225
				}):Play()
				task.wait(2)
				TweenService:Create(gradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					Rotation = 135
				}):Play()
				task.wait(2)
			end
		end)
		
		-- ═══ ICONO/EMOJI ═══
		local icon = Instance.new("TextLabel")
		icon.Name = "Icon"
		icon.Size = UDim2.new(1, 0, 0.55, 0)
		icon.Position = UDim2.new(0, 0, 0, 0)
		icon.BackgroundTransparency = 1
		icon.Text = info.Icon
		icon.Font = Enum.Font.SourceSansBold
		icon.TextSize = 36
		icon.TextColor3 = Color3.new(1, 1, 1)
		icon.TextStrokeTransparency = 0
		icon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		icon.ZIndex = 3
		icon.Parent = button
		
		-- ═══ OVERLAY DE COOLDOWN ═══
		local overlay = Instance.new("Frame")
		overlay.Name = "CooldownOverlay"
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 0.15
		overlay.Size = UDim2.new(1, 0, 0, 0)
		overlay.Position = UDim2.new(0, 0, 1, 0)
		overlay.AnchorPoint = Vector2.new(0, 1)
		overlay.BorderSizePixel = 0
		overlay.ZIndex = 4
		overlay.Parent = button
		
		-- Corner para overlay
		local overlayCorner = Instance.new("UICorner")
		overlayCorner.CornerRadius = UDim.new(0, 12)
		overlayCorner.Parent = overlay
		
		-- Timer text
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
		timerText.Parent = button
		
		-- ═══ TECLA (ESQUINA INFERIOR DERECHA) ═══
		local keyLabel = Instance.new("TextLabel")
		keyLabel.Name = "KeyLabel"
		keyLabel.Size = UDim2.new(0, 26, 0, 26)
		keyLabel.Position = UDim2.new(1, -30, 1, -30)
		keyLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
		keyLabel.BackgroundTransparency = 0.2
		keyLabel.Text = info.Key
		keyLabel.Font = Enum.Font.SourceSansBold
		keyLabel.TextSize = 18
		keyLabel.TextColor3 = Color3.new(1, 1, 1)
		keyLabel.ZIndex = 6
		keyLabel.BorderSizePixel = 0
		keyLabel.Parent = button
		
		local keyCorner = Instance.new("UICorner")
		keyCorner.CornerRadius = UDim.new(0, 6)
		keyCorner.Parent = keyLabel
		
		local keyStroke = Instance.new("UIStroke")
		keyStroke.Color = info.Color
		keyStroke.Thickness = 1.5
		keyStroke.Transparency = 0.5
		keyStroke.Parent = keyLabel
		
		-- ═══ NOMBRE DEL PODER (ABAJO) ═══
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "NameLabel"
		nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
		nameLabel.Position = UDim2.new(0, 0, 0.65, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = info.Description
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.TextSize = 9
		nameLabel.TextColor3 = Color3.new(1, 1, 1)
		nameLabel.TextStrokeTransparency = 0.3
		nameLabel.TextScaled = true
		nameLabel.ZIndex = 3
		nameLabel.Parent = button
		
		-- ═══ EFECTOS HOVER ═══
		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 1, 6),
				BackgroundColor3 = info.Color * 1.2
			}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.2), {
				Transparency = 0.1,
				Thickness = 3
			}):Play()
			TweenService:Create(icon, TweenInfo.new(0.2), {
				TextSize = 40
			}):Play()
		end)
		
		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = info.Color
			}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.2), {
				Transparency = 0.4,
				Thickness = 2.5
			}):Play()
			TweenService:Create(icon, TweenInfo.new(0.2), {
				TextSize = 36
			}):Play()
		end)
		
		-- ═══ EFECTO DE BRILLO AL ACTIVAR ═══
		local function createActivationGlow()
			local glow = Instance.new("Frame")
			glow.Size = UDim2.new(1, 0, 1, 0)
			glow.Position = UDim2.new(0, 0, 0, 0)
			glow.BackgroundColor3 = Color3.new(1, 1, 1)
			glow.BackgroundTransparency = 0
			glow.BorderSizePixel = 0
			glow.ZIndex = 2
			glow.Parent = button
			
			local glowCorner = Instance.new("UICorner")
			glowCorner.CornerRadius = UDim.new(0, 12)
			glowCorner.Parent = glow
			
			TweenService:Create(glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1
			}):Play()
			
			task.delay(0.4, function()
				glow:Destroy()
			end)
		end
		
		-- Guardar referencias
		powerButtons[info.Name] = {
			Button = button,
			Overlay = overlay,
			Timer = timerText,
			KeyCode = Enum.KeyCode[info.Key],
			Color = info.Color,
			Container = buttonContainer,
			CreateGlow = createActivationGlow
		}
	end
end

-- ════════════════════════════════════════════════════════════════════════════
-- SISTEMA DE COOLDOWN ÉPICO
-- ════════════════════════════════════════════════════════════════════════════

local function startCooldown(powerName, duration)
	local data = powerButtons[powerName]
	if not data then return end
	
	local overlay = data.Overlay
	local timerText = data.Timer
	
	-- Mostrar overlay completo
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Position = UDim2.new(0, 0, 0, 0)
	timerText.Text = tostring(duration)
	
	-- Tween de reducción desde abajo hacia arriba
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local properties = {Size = UDim2.new(1, 0, 0, 0)}
	
	local cooldownTween = TweenService:Create(overlay, tweenInfo, properties)
	cooldownTween:Play()
	
	-- Actualizar timer con efecto de escala
	local startTime = tick()
	local endTime = startTime + duration
	local lastSecond = duration
	
	local updateTimer
	updateTimer = RunService.Heartbeat:Connect(function()
		local remaining = endTime - tick()
		
		if remaining <= 0.1 then
			timerText.Text = ""
			updateTimer:Disconnect()
			
			-- ═══ EFECTO DE DISPONIBLE ═══
			local button = data.Button
			data.CreateGlow()
			
			-- Animación elástica
			TweenService:Create(button, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 1, 10)
			}):Play()
			
			task.wait(0.5)
			
			TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
				Size = UDim2.new(1, 0, 1, 0)
			}):Play()
			
			-- Partículas de disponibilidad
			for i = 1, 15 do
				task.spawn(function()
					local particle = Instance.new("Frame")
					particle.Size = UDim2.new(0, 4, 0, 4)
					particle.Position = UDim2.new(0.5, 0, 0.5, 0)
					particle.BackgroundColor3 = data.Color
					particle.BorderSizePixel = 0
					particle.ZIndex = 10
					particle.Parent = button
					
					local particleCorner = Instance.new("UICorner")
					particleCorner.CornerRadius = UDim.new(1, 0)
					particleCorner.Parent = particle
					
					local angle = (i / 15) * math.pi * 2
					local distance = math.random(30, 60)
					
					TweenService:Create(particle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(
							0.5, math.cos(angle) * distance,
							0.5, math.sin(angle) * distance
						),
						BackgroundTransparency = 1
					}):Play()
					
					task.delay(0.8, function()
						particle:Destroy()
					end)
				end)
			end
			
			return
		end
		
		local currentSecond = math.ceil(remaining)
		if currentSecond ~= lastSecond then
			lastSecond = currentSecond
			-- Efecto de pulso en el número
			TweenService:Create(timerText, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextSize = 38
			}):Play()
			task.wait(0.15)
			TweenService:Create(timerText, TweenInfo.new(0.15), {
				TextSize = 32
			}):Play()
		end
		
		timerText.Text = tostring(currentSecond)
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- SISTEMA DE FEEDBACK
-- ════════════════════════════════════════════════════════════════════════════

local function showFeedback(powerName, message, duration)
	local data = powerButtons[powerName]
	if not data then return end
	
	local screenGui = player.PlayerGui:FindFirstChild("PowerAbilityUI")
	if not screenGui then return end
	
	local feedback = Instance.new("Frame")
	feedback.Name = "Feedback"
	feedback.Size = UDim2.new(0, 250, 0, 50)
	feedback.Position = UDim2.new(0.5, -125, 0.4, 0)
	feedback.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	feedback.BackgroundTransparency = 0.15
	feedback.ZIndex = 25
	feedback.BorderSizePixel = 0
	feedback.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = feedback
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = data.Color
	stroke.Thickness = 2.5
	stroke.Transparency = 0.3
	stroke.Parent = feedback
	
	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, -20, 1, -10)
	text.Position = UDim2.new(0, 10, 0, 5)
	text.BackgroundTransparency = 1
	text.Text = message
	text.Font = Enum.Font.SourceSansBold
	text.TextSize = 20
	text.TextColor3 = data.Color
	text.TextStrokeTransparency = 0
	text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	text.ZIndex = 26
	text.Parent = feedback
	
	-- Animación de entrada
	feedback.Position = UDim2.new(0.5, -125, 0.3, 0)
	TweenService:Create(feedback, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -125, 0.4, 0)
	}):Play()
	
	-- Animación de salida
	task.delay(duration or 2, function()
		TweenService:Create(feedback, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -125, 0.3, 0),
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(text, TweenInfo.new(0.4), {
			TextTransparency = 1,
			TextStrokeTransparency = 1
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.4), {
			Transparency = 1
		}):Play()
		
		task.wait(0.4)
		feedback:Destroy()
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- SISTEMA DE TARGET
-- ════════════════════════════════════════════════════════════════════════════

local function getTargetPlayer()
	local mouse = player:GetMouse()
	local mouseTarget = mouse.Target
	local targetPlayer = nil
	local MAX_TARGET_RANGE = 70
	
	-- Intentar obtener jugador desde el mouse
	if mouseTarget then
		local character = mouseTarget:FindFirstAncestorOfClass("Model")
		if character and character:FindFirstChild("Humanoid") then
			targetPlayer = Players:GetPlayerFromCharacter(character)
		end
	end
	
	if targetPlayer and targetPlayer ~= player then
		return targetPlayer
	end
	
	-- Si no hay target del mouse, buscar el jugador más cercano
	local playerCharacter = player.Character
	if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
		local closestPlayer = nil
		local closestDistance = MAX_TARGET_RANGE
		
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
end

-- ════════════════════════════════════════════════════════════════════════════
-- MANEJO DE PODERES
-- ════════════════════════════════════════════════════════════════════════════

local function handlePowerUse(powerName, target)
	local now = tick()
	
	if cooldowns[powerName] > now then
		local remaining = math.ceil(cooldowns[powerName] - now)
		showFeedback(powerName, "⏱️ COOLDOWN: " .. remaining .. "s", 1.5)
		return
	end
	
	local requiredCooldown = COOLDOWN_TIMES[powerName]
	local targetRequired = (powerName == "Telekinesis" or powerName == "Explosion" or powerName == "Healing")
	
	if targetRequired and not target then
		showFeedback(powerName, "⚠️ APUNTA A UN JUGADOR", 2)
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
		powerButtons[powerName].CreateGlow()
		showFeedback(powerName, "✨ PODER ACTIVADO", 1)
	end
end

-- ════════════════════════════════════════════════════════════════════════════
-- INPUT HANDLING
-- ════════════════════════════════════════════════════════════════════════════

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

-- ════════════════════════════════════════════════════════════════════════════
-- INICIALIZACIÓN
-- ════════════════════════════════════════════════════════════════════════════

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

-- Conectar input del teclado
UserInputService.InputBegan:Connect(handleKeyboardInput)

-- ════════════════════════════════════════════════════════════════════════════
print("✨ ═══════════════════════════════════════════════════════════════ ✨")
print("✨   STRANGER THINGS EPIC UI SYSTEM - CARGADO CON ÉXITO          ✨")
print("✨ ═══════════════════════════════════════════════════════════════ ✨")
print("⚡ Q = Telekinesis | 💥 E = Explosión | 🌀 R = Control")
print("🛡️ T = Protección | 💚 F = Curación")
print("✨ Interfaz épica con efectos visuales profesionales             ✨")
print("✨ ═══════════════════════════════════════════════════════════════ ✨")
