local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- STRANGER BLOX - ULTRA CINEMATIC INTRO
-- Estilo: Stranger Things + Upside Down
-- ==========================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StrangerBloxCinematic"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

-- Variables globales
local currentMusic = nil
local skipEnabled = false
local activeAnimations = {}

-- Traducciones
local translations = {
	storyText = "ホーキンスの町に再び闇が訪れた。ヴェクナが戻り、現実と裏側の世界の境界が崩壊しつつある。時間は残されていない…",
	playButton = "▶ PLAY GAME",
	loadingText = "ENTERING THE UPSIDE DOWN...",
	skipText = "⏭ SKIP",
	pressPlay = "PRESS TO ENTER",
	warning = "WARNING: VECNA IS NEAR"
}

-- ==========================================
-- SISTEMA DE MÚSICA AVANZADO
-- ==========================================
local function playMusic(soundId, volume, fadeIn)
	if currentMusic then
		currentMusic:Stop()
		currentMusic:Destroy()
	end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. soundId
	sound.Volume = fadeIn and 0 or (volume or 0.5)
	sound.Looped = true
	sound.Parent = screenGui
	sound:Play()

	if fadeIn then
		TweenService:Create(sound, TweenInfo.new(fadeIn), {Volume = volume or 0.5}):Play()
	end

	currentMusic = sound
	return sound
end

local function stopMusicWithFade(sound, fadeTime)
	if not sound then return end
	local fadeTween = TweenService:Create(sound, TweenInfo.new(fadeTime or 1), {Volume = 0})
	fadeTween:Play()
	fadeTween.Completed:Wait()
	sound:Stop()
	sound:Destroy()
end

-- ==========================================
-- EFECTOS VISUALES ULTRA AVANZADOS
-- ==========================================

-- Sistema de partículas del Upside Down (ceniza flotante)
local function createUpsideDownParticles(parent, count)
	local particleContainer = Instance.new("Frame")
	particleContainer.Name = "UpsideDownParticles"
	particleContainer.Size = UDim2.new(1, 0, 1, 0)
	particleContainer.BackgroundTransparency = 1
	particleContainer.Parent = parent

	for i = 1, count or 80 do
		local particle = Instance.new("Frame")
		particle.Size = UDim2.new(0, math.random(1, 5), 0, math.random(1, 5))
		particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
		particle.BackgroundColor3 = Color3.fromRGB(
			math.random(180, 255),
			math.random(80, 120),
			math.random(80, 120)
		)
		particle.BackgroundTransparency = math.random(30, 70) / 100
		particle.BorderSizePixel = 0
		particle.ZIndex = 2
		particle.Parent = particleContainer

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = particle

		-- Rotación aleatoria
		particle.Rotation = math.random(0, 360)

		-- Animación compleja de flotación
		task.spawn(function()
			while particle.Parent do
				local randomX = math.random(-100, 100) / 1000
				local randomY = math.random(-150, 50) / 1000
				local duration = math.random(40, 80) / 10
				local randomRot = math.random(-180, 180)

				local tween1 = TweenService:Create(particle, TweenInfo.new(duration, Enum.EasingStyle.Sine), {
					Position = particle.Position + UDim2.new(randomX, 0, randomY, 0),
					Rotation = particle.Rotation + randomRot,
					BackgroundTransparency = math.random(20, 90) / 100
				})
				tween1:Play()
				task.wait(duration)
			end
		end)
	end

	return particleContainer
end

-- Efecto de relámpagos del Upside Down
local function createLightningEffect(parent)
	local lightning = Instance.new("Frame")
	lightning.Name = "Lightning"
	lightning.Size = UDim2.new(1, 0, 1, 0)
	lightning.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	lightning.BackgroundTransparency = 1
	lightning.BorderSizePixel = 0
	lightning.ZIndex = 50
	lightning.Parent = parent

	task.spawn(function()
		while lightning.Parent do
			task.wait(math.random(30, 80) / 10)
			
			-- Flash de relámpago
			lightning.BackgroundTransparency = math.random(30, 60) / 100
			task.wait(0.05)
			lightning.BackgroundTransparency = 1
			task.wait(0.08)
			lightning.BackgroundTransparency = math.random(40, 70) / 100
			task.wait(0.03)
			lightning.BackgroundTransparency = 1
		end
	end)

	return lightning
end

-- Portal dimensional animado
local function createDimensionalPortal(parent, centerPos)
	local portalContainer = Instance.new("Frame")
	portalContainer.Name = "DimensionalPortal"
	portalContainer.Size = UDim2.new(0, 400, 0, 400)
	portalContainer.Position = centerPos or UDim2.new(0.5, -200, 0.5, -200)
	portalContainer.BackgroundTransparency = 1
	portalContainer.ZIndex = 5
	portalContainer.Parent = parent

	-- Crear múltiples anillos giratorios
	for ring = 1, 5 do
		local ringFrame = Instance.new("Frame")
		ringFrame.Size = UDim2.new(0, 300 + ring * 20, 0, 300 + ring * 20)
		ringFrame.Position = UDim2.new(0.5, -(150 + ring * 10), 0.5, -(150 + ring * 10))
		ringFrame.BackgroundTransparency = 1
		ringFrame.ZIndex = 5 + ring
		ringFrame.Parent = portalContainer

		local ringCircle = Instance.new("Frame")
		ringCircle.Size = UDim2.new(1, 0, 1, 0)
		ringCircle.Position = UDim2.new(0, 0, 0, 0)
		ringCircle.BackgroundTransparency = 1
		ringCircle.BorderSizePixel = 0
		ringCircle.Parent = ringFrame

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 50 + ring * 20, 50 + ring * 20)
		stroke.Thickness = 3 - (ring * 0.3)
		stroke.Transparency = 0.3 + (ring * 0.1)
		stroke.Parent = ringCircle

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = ringCircle

		-- Rotación continua
		task.spawn(function()
			local rotationSpeed = 2 + ring * 0.5
			while ringFrame.Parent do
				ringFrame.Rotation = ringFrame.Rotation + rotationSpeed
				task.wait(0.03)
			end
		end)

		-- Pulsación de tamaño
		task.spawn(function()
			while ringFrame.Parent do
				TweenService:Create(stroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					Transparency = 0.1 + (ring * 0.05)
				}):Play()
				task.wait(2)
				TweenService:Create(stroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					Transparency = 0.6 + (ring * 0.1)
				}):Play()
				task.wait(2)
			end
		end)
	end

	-- Centro del portal
	local portalCore = Instance.new("Frame")
	portalCore.Size = UDim2.new(0, 200, 0, 200)
	portalCore.Position = UDim2.new(0.5, -100, 0.5, -100)
	portalCore.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
	portalCore.BackgroundTransparency = 0.3
	portalCore.BorderSizePixel = 0
	portalCore.ZIndex = 4
	portalCore.Parent = portalContainer

	local coreCorner = Instance.new("UICorner")
	coreCorner.CornerRadius = UDim.new(1, 0)
	coreCorner.Parent = portalCore

	local coreGradient = Instance.new("UIGradient")
	coreGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 10, 10)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
	})
	coreGradient.Parent = portalCore

	-- Pulsación del núcleo
	task.spawn(function()
		while portalCore.Parent do
			TweenService:Create(portalCore, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
				Size = UDim2.new(0, 220, 0, 220),
				Position = UDim2.new(0.5, -110, 0.5, -110),
				BackgroundTransparency = 0.1
			}):Play()
			task.wait(1.5)
			TweenService:Create(portalCore, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
				Size = UDim2.new(0, 200, 0, 200),
				Position = UDim2.new(0.5, -100, 0.5, -100),
				BackgroundTransparency = 0.4
			}):Play()
			task.wait(1.5)
		end
	end)

	return portalContainer
end

-- Tentáculos del Upside Down (vines)
local function createUpsideDownVines(parent)
	local vineContainer = Instance.new("Frame")
	vineContainer.Name = "Vines"
	vineContainer.Size = UDim2.new(1, 0, 1, 0)
	vineContainer.BackgroundTransparency = 1
	vineContainer.ZIndex = 3
	vineContainer.Parent = parent

	local vinePositions = {
		{UDim2.new(0, 0, 0, 0), UDim2.new(0.3, 0, 0.8, 0)},
		{UDim2.new(1, 0, 0, 0), UDim2.new(0.7, 0, 0.9, 0)},
		{UDim2.new(0, 0, 0.5, 0), UDim2.new(0.2, 0, 1, 0)},
		{UDim2.new(1, 0, 0.3, 0), UDim2.new(0.85, 0, 0.8, 0)},
	}

	for i, positions in ipairs(vinePositions) do
		local vine = Instance.new("Frame")
		vine.Size = UDim2.new(0, 30, 0, 0)
		vine.Position = positions[1]
		vine.BackgroundColor3 = Color3.fromRGB(40, 60, 40)
		vine.BorderSizePixel = 0
		vine.ZIndex = 3
		vine.Parent = vineContainer

		local vineGradient = Instance.new("UIGradient")
		vineGradient.Rotation = 90
		vineGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 100, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 30, 20))
		})
		vineGradient.Parent = vine

		-- Animación de crecimiento
		task.spawn(function()
			task.wait(i * 0.3)
			local targetHeight = math.random(200, 500)
			TweenService:Create(vine, TweenInfo.new(2, Enum.EasingStyle.Sine), {
				Size = UDim2.new(0, 30, 0, targetHeight)
			}):Play()
		end)

		-- Animación de ondulación
		task.spawn(function()
			task.wait(2 + i * 0.3)
			while vine.Parent do
				TweenService:Create(vine, TweenInfo.new(3, Enum.EasingStyle.Sine), {
					Rotation = math.random(-5, 5),
					Size = vine.Size + UDim2.new(0, math.random(-5, 5), 0, math.random(-10, 10))
				}):Play()
				task.wait(3)
			end
		end)
	end

	return vineContainer
end

-- Efecto de distorsión espacial
local function createSpatialDistortion(parent)
	local distortionContainer = Instance.new("Frame")
	distortionContainer.Size = UDim2.new(1, 0, 1, 0)
	distortionContainer.BackgroundTransparency = 1
	distortionContainer.ZIndex = 10
	distortionContainer.Parent = parent

	for i = 1, 20 do
		local distortionLine = Instance.new("Frame")
		distortionLine.Size = UDim2.new(1, 0, 0, 2)
		distortionLine.Position = UDim2.new(0, 0, math.random() / 1, 0)
		distortionLine.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		distortionLine.BackgroundTransparency = 0.8
		distortionLine.BorderSizePixel = 0
		distortionLine.Parent = distortionContainer

		task.spawn(function()
			while distortionLine.Parent do
				distortionLine.Position = UDim2.new(math.random(-10, 10) / 100, 0, distortionLine.Position.Y.Scale, 0)
				distortionLine.BackgroundTransparency = math.random(70, 95) / 100
				task.wait(0.05)
			end
		end)
	end

	return distortionContainer
end

-- Viñeta cinematográfica ultra
local function createCinematicVignette(parent, intensity)
	local vignette = Instance.new("Frame")
	vignette.Name = "CinematicVignette"
	vignette.Size = UDim2.new(1, 0, 1, 0)
	vignette.BackgroundTransparency = 1
	vignette.BorderSizePixel = 0
	vignette.ZIndex = 20
	vignette.Parent = parent

	-- Gradiente superior
	local topGrad = Instance.new("Frame")
	topGrad.Size = UDim2.new(1, 0, 0.4, 0)
	topGrad.Position = UDim2.new(0, 0, 0, 0)
	topGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	topGrad.BorderSizePixel = 0
	topGrad.Parent = vignette

	local topGradient = Instance.new("UIGradient")
	topGradient.Rotation = 90
	topGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, intensity or 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	topGradient.Parent = topGrad

	-- Gradiente inferior
	local bottomGrad = Instance.new("Frame")
	bottomGrad.Size = UDim2.new(1, 0, 0.4, 0)
	bottomGrad.Position = UDim2.new(0, 0, 0.6, 0)
	bottomGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bottomGrad.BorderSizePixel = 0
	bottomGrad.Parent = vignette

	local bottomGradient = Instance.new("UIGradient")
	bottomGradient.Rotation = 270
	bottomGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, intensity or 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	bottomGradient.Parent = bottomGrad

	-- Gradiente izquierdo
	local leftGrad = Instance.new("Frame")
	leftGrad.Size = UDim2.new(0.3, 0, 1, 0)
	leftGrad.Position = UDim2.new(0, 0, 0, 0)
	leftGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	leftGrad.BorderSizePixel = 0
	leftGrad.Parent = vignette

	local leftGradient = Instance.new("UIGradient")
	leftGradient.Rotation = 0
	leftGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, intensity or 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	leftGradient.Parent = leftGrad

	-- Gradiente derecho
	local rightGrad = Instance.new("Frame")
	rightGrad.Size = UDim2.new(0.3, 0, 1, 0)
	rightGrad.Position = UDim2.new(0.7, 0, 0, 0)
	rightGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	rightGrad.BorderSizePixel = 0
	rightGrad.Parent = vignette

	local rightGradient = Instance.new("UIGradient")
	rightGradient.Rotation = 180
	rightGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, intensity or 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	rightGradient.Parent = rightGrad

	return vignette
end

-- Glitch cromático RGB
local function createChromaticGlitch(textLabel)
	local redClone = textLabel:Clone()
	redClone.TextColor3 = Color3.fromRGB(255, 0, 0)
	redClone.TextStrokeTransparency = 1
	redClone.ZIndex = textLabel.ZIndex - 1
	redClone.Parent = textLabel.Parent

	local blueClone = textLabel:Clone()
	blueClone.TextColor3 = Color3.fromRGB(0, 100, 255)
	blueClone.TextStrokeTransparency = 1
	blueClone.ZIndex = textLabel.ZIndex - 2
	blueClone.Parent = textLabel.Parent

	task.spawn(function()
		while textLabel.Parent do
			task.wait(math.random(10, 30) / 10)
			
			-- Glitch
			redClone.Position = textLabel.Position + UDim2.new(0, math.random(-5, 5), 0, math.random(-3, 3))
			blueClone.Position = textLabel.Position + UDim2.new(0, math.random(-5, 5), 0, math.random(-3, 3))
			
			task.wait(0.05)
			
			redClone.Position = textLabel.Position
			blueClone.Position = textLabel.Position
		end
	end)

	return {redClone, blueClone}
end

-- ==========================================
-- PANTALLA DE CARGA CON UPSIDE DOWN
-- ==========================================
local function showUpsideDownTransition()
	local transitionFrame = Instance.new("Frame")
	transitionFrame.Size = UDim2.new(1, 0, 1, 0)
	transitionFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
	transitionFrame.BorderSizePixel = 0
	transitionFrame.Parent = screenGui

	-- Efectos de fondo
	createCinematicVignette(transitionFrame, 0.2)
	createUpsideDownParticles(transitionFrame, 100)
	createLightningEffect(transitionFrame)
	createUpsideDownVines(transitionFrame)

	-- Portal dimensional
	local portal = createDimensionalPortal(transitionFrame, UDim2.new(0.5, -200, 0.5, -200))

	-- Texto
	local warningText = Instance.new("TextLabel")
	warningText.Size = UDim2.new(0.8, 0, 0.15, 0)
	warningText.Position = UDim2.new(0.1, 0, 0.15, 0)
	warningText.BackgroundTransparency = 1
	warningText.Font = Enum.Font.Creepster
	warningText.TextSize = 48
	warningText.TextColor3 = Color3.fromRGB(255, 50, 50)
	warningText.TextStrokeTransparency = 0
	warningText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	warningText.Text = translations.warning
	warningText.TextTransparency = 1
	warningText.TextScaled = true
	warningText.ZIndex = 25
	warningText.Parent = transitionFrame

	createChromaticGlitch(warningText)

	-- Animación de aparición
	TweenService:Create(warningText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()

	-- Efecto de parpadeo
	task.spawn(function()
		for i = 1, 8 do
			task.wait(0.3)
			warningText.TextTransparency = 0.7
			task.wait(0.2)
			warningText.TextTransparency = 0
		end
	end)

	task.wait(4)

	-- Zoom del portal
	TweenService:Create(portal, TweenInfo.new(2, Enum.EasingStyle.Sine), {
		Size = UDim2.new(0, 2000, 0, 2000),
		Position = UDim2.new(0.5, -1000, 0.5, -1000)
	}):Play()

	task.wait(1)

	TweenService:Create(transitionFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
	task.wait(1)

	transitionFrame:Destroy()
end

-- ==========================================
-- HISTORIA CINEMATOGRÁFICA
-- ==========================================
local function showCinematicStory()
	local storyFrame = Instance.new("Frame")
	storyFrame.Size = UDim2.new(1, 0, 1, 0)
	storyFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
	storyFrame.BorderSizePixel = 0
	storyFrame.Parent = screenGui

	createCinematicVignette(storyFrame, 0.3)
	createUpsideDownParticles(storyFrame, 60)
	createLightningEffect(storyFrame)
	createSpatialDistortion(storyFrame)

	local storyText = Instance.new("TextLabel")
	storyText.Size = UDim2.new(0.85, 0, 0.5, 0)
	storyText.Position = UDim2.new(0.075, 0, 0.25, 0)
	storyText.BackgroundTransparency = 1
	storyText.Font = Enum.Font.Creepster
	storyText.TextSize = 36
	storyText.TextColor3 = Color3.fromRGB(240, 100, 100)
	storyText.TextStrokeTransparency = 0
	storyText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	storyText.TextWrapped = true
	storyText.TextTransparency = 1
	storyText.Text = translations.storyText
	storyText.TextYAlignment = Enum.TextYAlignment.Center
	storyText.TextScaled = true
	storyText.ZIndex = 25
	storyText.Parent = storyFrame

	createChromaticGlitch(storyText)

	TweenService:Create(storyText, TweenInfo.new(3, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()

	task.wait(7)

	TweenService:Create(storyText, TweenInfo.new(2), {TextTransparency = 1}):Play()
	task.wait(2)

	storyFrame:Destroy()
end

-- ==========================================
-- LOGO STRANGER BLOX ÉPICO
-- ==========================================
local function showEpicStrangerBloxLogo()
	local logoFrame = Instance.new("Frame")
	logoFrame.Size = UDim2.new(1, 0, 1, 0)
	logoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	logoFrame.BorderSizePixel = 0
	logoFrame.Parent = screenGui

	createCinematicVignette(logoFrame, 0.1)
	createLightningEffect(logoFrame)

	-- Contenedor principal del logo
	local logoContainer = Instance.new("Frame")
	logoContainer.Size = UDim2.new(0.95, 0, 0.35, 0)
	logoContainer.Position = UDim2.new(0.025, 0, 0.325, 0)
	logoContainer.BackgroundTransparency = 1
	logoContainer.ZIndex = 15
	logoContainer.Parent = logoFrame

	local letters = {"S", "T", "R", "A", "N", "G", "E", "R", " ", "B", "L", "O", "X"}
	local letterFrames = {}
	local letterEffects = {}

	for i, letter in ipairs(letters) do
		-- Frame contenedor de cada letra
		local letterContainer = Instance.new("Frame")
		letterContainer.Size = UDim2.new(1/#letters, 0, 1, 0)
		letterContainer.Position = UDim2.new((i-1)/#letters, 0, 0, 0)
		letterContainer.BackgroundTransparency = 1
		letterContainer.ZIndex = 15
		letterContainer.Parent = logoContainer

		-- Letra principal
		local letterLabel = Instance.new("TextLabel")
		letterLabel.Size = UDim2.new(1, 0, 1, 0)
		letterLabel.BackgroundTransparency = 1
		letterLabel.Font = Enum.Font.Creepster
		letterLabel.TextSize = 90
		letterLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
		letterLabel.TextStrokeTransparency = 0
		letterLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		letterLabel.Text = letter
		letterLabel.TextTransparency = 1
		letterLabel.TextScaled = true
		letterLabel.ZIndex = 16
		letterLabel.Parent = letterContainer

		-- Resplandor 1
		local glow1 = letterLabel:Clone()
		glow1.TextTransparency = 0.5
		glow1.TextStrokeTransparency = 1
		glow1.Size = UDim2.new(1.05, 0, 1.05, 0)
		glow1.Position = UDim2.new(-0.025, 0, -0.025, 0)
		glow1.ZIndex = 15
		glow1.TextColor3 = Color3.fromRGB(255, 100, 100)
		glow1.Parent = letterContainer

		-- Resplandor 2
		local glow2 = letterLabel:Clone()
		glow2.TextTransparency = 0.7
		glow2.TextStrokeTransparency = 1
		glow2.Size = UDim2.new(1.1, 0, 1.1, 0)
		glow2.Position = UDim2.new(-0.05, 0, -0.05, 0)
		glow2.ZIndex = 14
		glow2.TextColor3 = Color3.fromRGB(255, 150, 150)
		glow2.Parent = letterContainer

		table.insert(letterFrames, letterLabel)
		table.insert(letterEffects, {glow1, glow2})

		-- Animación de aparición con electricidad
		task.spawn(function()
			task.wait(i * 0.18)

			-- Flash eléctrico
			local electricFlash = Instance.new("Frame")
			electricFlash.Size = UDim2.new(0.08, 0, 1.2, 0)
			electricFlash.Position = UDim2.new((i-1)/#letters + 0.02, 0, -0.1, 0)
			electricFlash.BackgroundColor3 = Color3.fromRGB(255, 255, 200)
			electricFlash.BorderSizePixel = 0
			electricFlash.ZIndex = 30
			electricFlash.Parent = logoContainer

			local flashGradient = Instance.new("UIGradient")
			flashGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(1, 1)
			})
			flashGradient.Parent = electricFlash

			TweenService:Create(electricFlash, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
			task.wait(0.4)
			electricFlash:Destroy()

			-- Aparecer letra con bounce
			TweenService:Create(letterLabel, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {
				TextTransparency = 0
			}):Play()
			TweenService:Create(glow1, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {
				TextTransparency = 0.5
			}):Play()
			TweenService:Create(glow2, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {
				TextTransparency = 0.7
			}):Play()
		end)
	end

	task.wait(4)

	-- Efecto de parpadeo de luces tipo Stranger Things
	for flash = 1, 6 do
		for _, letter in ipairs(letterFrames) do
			letter.TextTransparency = 0.8
			letter.TextStrokeTransparency = 0.8
		end
		for _, effects in ipairs(letterEffects) do
			effects[1].TextTransparency = 0.9
			effects[2].TextTransparency = 0.95
		end
		task.wait(0.1)

		for _, letter in ipairs(letterFrames) do
			letter.TextTransparency = 0
			letter.TextStrokeTransparency = 0
		end
		for _, effects in ipairs(letterEffects) do
			effects[1].TextTransparency = 0.5
			effects[2].TextTransparency = 0.7
		end
		task.wait(0.15)
	end

	task.wait(2)

	-- Desaparición con zoom
	for i, letter in ipairs(letterFrames) do
		task.spawn(function()
			TweenService:Create(letter, TweenInfo.new(1.5), {
				TextTransparency = 1,
				Size = letter.Size * 1.5
			}):Play()
		end)
		for _, effect in ipairs(letterEffects[i]) do
			TweenService:Create(effect, TweenInfo.new(1.5), {TextTransparency = 1}):Play()
		end
	end

	task.wait(2)
	logoFrame:Destroy()
end

-- ==========================================
-- CRÉDITOS CINEMATOGRÁFICOS
-- ==========================================
local function showCinematicCredit(text, duration)
	local creditFrame = Instance.new("Frame")
	creditFrame.Size = UDim2.new(1, 0, 1, 0)
	creditFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	creditFrame.BorderSizePixel = 0
	creditFrame.Parent = screenGui

	createCinematicVignette(creditFrame, 0.3)
	createLightningEffect(creditFrame)
	createUpsideDownParticles(creditFrame, 40)

	local creditText = Instance.new("TextLabel")
	creditText.Size = UDim2.new(0.8, 0, 0.4, 0)
	creditText.Position = UDim2.new(0.1, 0, 0.3, 0)
	creditText.BackgroundTransparency = 1
	creditText.Font = Enum.Font.Creepster
	creditText.TextSize = 42
	creditText.TextColor3 = Color3.fromRGB(255, 255, 255)
	creditText.TextStrokeTransparency = 0.2
	creditText.TextStrokeColor3 = Color3.fromRGB(200, 50, 50)
	creditText.TextWrapped = true
	creditText.Text = text
	creditText.TextTransparency = 1
	creditText.TextScaled = true
	creditText.ZIndex = 25
	creditText.Parent = creditFrame

	TweenService:Create(creditText, TweenInfo.new(1.2), {TextTransparency = 0}):Play()
	task.wait(duration or 3)
	TweenService:Create(creditText, TweenInfo.new(1.2), {TextTransparency = 1}):Play()
	task.wait(1.2)

	creditFrame:Destroy()
end

-- ==========================================
-- VECNA GLITCH ULTRA ÉPICO
-- ==========================================
local function showVecnaGlitchSequence()
	local glitchFrame = Instance.new("Frame")
	glitchFrame.Size = UDim2.new(1, 0, 1, 0)
	glitchFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	glitchFrame.BorderSizePixel = 0
	glitchFrame.Parent = screenGui

	createCinematicVignette(glitchFrame, 0.1)
	createUpsideDownParticles(glitchFrame, 120)
	createLightningEffect(glitchFrame)
	local portal = createDimensionalPortal(glitchFrame, UDim2.new(0.5, -300, 0.5, -300))
	portal.Size = UDim2.new(0, 600, 0, 600)
	portal.Position = UDim2.new(0.5, -300, 0.5, -300)

	-- Texto VECNA
	local vecnaText = Instance.new("TextLabel")
	vecnaText.Size = UDim2.new(0.9, 0, 0.5, 0)
	vecnaText.Position = UDim2.new(0.05, 0, 0.25, 0)
	vecnaText.BackgroundTransparency = 1
	vecnaText.Font = Enum.Font.Creepster
	vecnaText.TextSize = 180
	vecnaText.TextColor3 = Color3.fromRGB(255, 0, 0)
	vecnaText.TextStrokeTransparency = 0
	vecnaText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	vecnaText.Text = "ヴェクナ"
	vecnaText.TextTransparency = 1
	vecnaText.TextScaled = true
	vecnaText.ZIndex = 30
	vecnaText.Parent = glitchFrame

	local chromaticClones = createChromaticGlitch(vecnaText)

	TweenService:Create(vecnaText, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

	-- Glitch extremo
	task.spawn(function()
		for i = 1, 60 do
			vecnaText.Position = UDim2.new(
				0.05 + math.random(-30, 30) / 1000,
				0,
				0.25 + math.random(-30, 30) / 1000,
				0
			)
			vecnaText.Rotation = math.random(-3, 3)
			glitchFrame.BackgroundColor3 = Color3.fromRGB(
				math.random(0, 100),
				0,
				0
			)
			task.wait(0.04)
		end
	end)

	task.wait(3)

	-- Desaparición
	TweenService:Create(vecnaText, TweenInfo.new(1.5), {TextTransparency = 1}):Play()
	for _, clone in ipairs(chromaticClones) do
		TweenService:Create(clone, TweenInfo.new(1.5), {TextTransparency = 1}):Play()
	end
	TweenService:Create(glitchFrame, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()

	task.wait(2)
	glitchFrame:Destroy()
end

-- ==========================================
-- MENÚ PRINCIPAL ÉPICO
-- ==========================================
local function showMainMenu()
	local menuFrame = Instance.new("Frame")
	menuFrame.Size = UDim2.new(1, 0, 1, 0)
	menuFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 5)
	menuFrame.BorderSizePixel = 0
	menuFrame.Parent = screenGui

	createCinematicVignette(menuFrame, 0.2)
	createUpsideDownParticles(menuFrame, 70)
	createLightningEffect(menuFrame)
	createUpsideDownVines(menuFrame)

	-- Portal de fondo
	local bgPortal = createDimensionalPortal(menuFrame, UDim2.new(0.5, -250, 0.5, -250))
	bgPortal.Size = UDim2.new(0, 500, 0, 500)
	bgPortal.Position = UDim2.new(0.5, -250, 0.5, -250)

	-- Título del juego
	local titleContainer = Instance.new("Frame")
	titleContainer.Size = UDim2.new(0.9, 0, 0.3, 0)
	titleContainer.Position = UDim2.new(0.05, 0, 0.12, 0)
	titleContainer.BackgroundTransparency = 1
	titleContainer.ZIndex = 20
	titleContainer.Parent = menuFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Creepster
	titleLabel.TextSize = 95
	titleLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
	titleLabel.TextStrokeTransparency = 0
	titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	titleLabel.Text = "STRANGER BLOX"
	titleLabel.TextScaled = true
	titleLabel.ZIndex = 21
	titleLabel.Parent = titleContainer

	-- Glows del título
	for glowLevel = 1, 3 do
		local glow = titleLabel:Clone()
		glow.TextTransparency = 0.3 + (glowLevel * 0.2)
		glow.TextStrokeTransparency = 1
		glow.Size = UDim2.new(1 + (glowLevel * 0.02), 0, 1 + (glowLevel * 0.02), 0)
		glow.Position = UDim2.new(-(glowLevel * 0.01), 0, -(glowLevel * 0.01), 0)
		glow.ZIndex = 20 - glowLevel
		glow.TextColor3 = Color3.fromRGB(255, 100 - (glowLevel * 20), 100 - (glowLevel * 20))
		glow.Parent = titleContainer
	end

	createChromaticGlitch(titleLabel)

	-- Botón PLAY épico
	local playButtonContainer = Instance.new("Frame")
	playButtonContainer.Size = UDim2.new(0.45, 0, 0.14, 0)
	playButtonContainer.Position = UDim2.new(0.275, 0, 0.58, 0)
	playButtonContainer.BackgroundTransparency = 1
	playButtonContainer.ZIndex = 25
	playButtonContainer.Parent = menuFrame

	local playButton = Instance.new("TextButton")
	playButton.Size = UDim2.new(1, 0, 1, 0)
	playButton.BackgroundColor3 = Color3.fromRGB(100, 15, 15)
	playButton.Font = Enum.Font.Creepster
	playButton.TextSize = 52
	playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	playButton.Text = translations.playButton
	playButton.TextScaled = true
	playButton.BorderSizePixel = 0
	playButton.ZIndex = 26
	playButton.Parent = playButtonContainer

	local playCorner = Instance.new("UICorner")
	playCorner.CornerRadius = UDim.new(0.12, 0)
	playCorner.Parent = playButton

	local playStroke = Instance.new("UIStroke")
	playStroke.Color = Color3.fromRGB(255, 80, 80)
	playStroke.Thickness = 5
	playStroke.Parent = playButton

	-- Gradiente en el botón
	local playGradient = Instance.new("UIGradient")
	playGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 20, 20)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 15, 15)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 10, 10))
	})
	playGradient.Rotation = 90
	playGradient.Parent = playButton

	-- Efecto de pulso en el botón
	task.spawn(function()
		while playButton.Parent do
			TweenService:Create(playStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
				Thickness = 7,
				Color = Color3.fromRGB(255, 120, 120)
			}):Play()
			task.wait(1.5)
			TweenService:Create(playStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
				Thickness = 5,
				Color = Color3.fromRGB(255, 80, 80)
			}):Play()
			task.wait(1.5)
		end
	end)

	-- Hover effect
	playButton.MouseEnter:Connect(function()
		TweenService:Create(playButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(1.08, 0, 1.08, 0),
			Position = UDim2.new(-0.04, 0, -0.04, 0)
		}):Play()
		TweenService:Create(playButton, TweenInfo.new(0.3), {
			BackgroundColor3 = Color3.fromRGB(150, 30, 30)
		}):Play()
		TweenService:Create(playStroke, TweenInfo.new(0.3), {
			Thickness = 8,
			Color = Color3.fromRGB(255, 150, 150)
		}):Play()
	end)

	playButton.MouseLeave:Connect(function()
		TweenService:Create(playButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()
		TweenService:Create(playButton, TweenInfo.new(0.3), {
			BackgroundColor3 = Color3.fromRGB(100, 15, 15)
		}):Play()
	end)

	playButton.MouseButton1Click:Connect(function()
		-- Efecto de click
		TweenService:Create(playButton, TweenInfo.new(0.1), {
			Size = UDim2.new(0.95, 0, 0.95, 0),
			Position = UDim2.new(0.025, 0, 0.025, 0)
		}):Play()
		task.wait(0.1)

		stopMusicWithFade(currentMusic, 1.5)
		menuFrame:Destroy()
		showLoadingScreen()
	end)

	-- Texto decorativo
	local pressText = Instance.new("TextLabel")
	pressText.Size = UDim2.new(0.6, 0, 0.08, 0)
	pressText.Position = UDim2.new(0.2, 0, 0.75, 0)
	pressText.BackgroundTransparency = 1
	pressText.Font = Enum.Font.Creepster
	pressText.TextSize = 28
	pressText.TextColor3 = Color3.fromRGB(200, 100, 100)
	pressText.TextStrokeTransparency = 0.3
	pressText.Text = translations.pressPlay
	pressText.TextScaled = true
	pressText.ZIndex = 25
	pressText.Parent = menuFrame

	-- Parpadeo del texto
	task.spawn(function()
		while pressText.Parent do
			TweenService:Create(pressText, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
				TextTransparency = 0.6
			}):Play()
			task.wait(1.2)
			TweenService:Create(pressText, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
				TextTransparency = 0
			}):Play()
			task.wait(1.2)
		end
	end)
end

-- ==========================================
-- PANTALLA DE CARGA FINAL
-- ==========================================
function showLoadingScreen()
	playMusic("127899975684445", 0.4, 1)

	local loadingFrame = Instance.new("Frame")
	loadingFrame.Size = UDim2.new(1, 0, 1, 0)
	loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	loadingFrame.BorderSizePixel = 0
	loadingFrame.Parent = screenGui

	createCinematicVignette(loadingFrame, 0.2)
	createUpsideDownParticles(loadingFrame, 90)
	createLightningEffect(loadingFrame)

	-- Portal de carga
	local loadingPortal = createDimensionalPortal(loadingFrame, UDim2.new(0.5, -150, 0.5, -150))
	loadingPortal.Size = UDim2.new(0, 300, 0, 300)
	loadingPortal.Position = UDim2.new(0.5, -150, 0.5, -150)

	local loadingText = Instance.new("TextLabel")
	loadingText.Size = UDim2.new(0.8, 0, 0.18, 0)
	loadingText.Position = UDim2.new(0.1, 0, 0.22, 0)
	loadingText.BackgroundTransparency = 1
	loadingText.Font = Enum.Font.Creepster
	loadingText.TextSize = 48
	loadingText.TextColor3 = Color3.fromRGB(240, 80, 80)
	loadingText.Text = translations.loadingText
	loadingText.TextScaled = true
	loadingText.ZIndex = 25
	loadingText.Parent = loadingFrame

	createChromaticGlitch(loadingText)

	-- Barra de carga épica
	local barContainer = Instance.new("Frame")
	barContainer.Size = UDim2.new(0.75, 0, 0.08, 0)
	barContainer.Position = UDim2.new(0.125, 0, 0.68, 0)
	barContainer.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
	barContainer.BorderSizePixel = 0
	barContainer.ZIndex = 23
	barContainer.Parent = loadingFrame

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0.25, 0)
	barCorner.Parent = barContainer

	local barStroke = Instance.new("UIStroke")
	barStroke.Color = Color3.fromRGB(200, 60, 60)
	barStroke.Thickness = 4
	barStroke.Parent = barContainer

	local progressBar = Instance.new("Frame")
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	progressBar.BorderSizePixel = 0
	progressBar.ZIndex = 24
	progressBar.Parent = barContainer

	local progressCorner = Instance.new("UICorner")
	progressCorner.CornerRadius = UDim.new(0.25, 0)
	progressCorner.Parent = progressBar

	-- Gradiente de la barra
	local barGradient = Instance.new("UIGradient")
	barGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 50, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 30, 30))
	})
	barGradient.Parent = progressBar

	-- Efecto de brillo en la barra
	local barGlow = Instance.new("Frame")
	barGlow.Size = UDim2.new(1, 0, 1, 0)
	barGlow.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
	barGlow.BackgroundTransparency = 0.6
	barGlow.BorderSizePixel = 0
	barGlow.ZIndex = 25
	barGlow.Parent = progressBar

	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = UDim.new(0.25, 0)
	glowCorner.Parent = barGlow

	-- Animación de carga
	local fillTween = TweenService:Create(
		progressBar,
		TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		{Size = UDim2.new(1, 0, 1, 0)}
	)
	fillTween:Play()

	-- Porcentaje
	local percentText = Instance.new("TextLabel")
	percentText.Size = UDim2.new(0.3, 0, 0.06, 0)
	percentText.Position = UDim2.new(0.35, 0, 0.78, 0)
	percentText.BackgroundTransparency = 1
	percentText.Font = Enum.Font.Creepster
	percentText.TextSize = 32
	percentText.TextColor3 = Color3.fromRGB(255, 150, 150)
	percentText.Text = "0%"
	percentText.TextScaled = true
	percentText.ZIndex = 26
	percentText.Parent = loadingFrame

	-- Actualizar porcentaje
	task.spawn(function()
		for i = 0, 100, 2 do
			percentText.Text = i .. "%"
			task.wait(0.12)
		end
	end)

	fillTween.Completed:Wait()

	task.wait(0.8)
	stopMusicWithFade(currentMusic, 1.5)

	TweenService:Create(loadingFrame, TweenInfo.new(2), {BackgroundTransparency = 1}):Play()
	task.wait(2)

	playMusic("4940109913", 0.3, 1)
	screenGui:Destroy()
end

-- ==========================================
-- BOTÓN SKIP ULTRA DISEÑADO
-- ==========================================
local function createEpicSkipButton(skipCallback)
	local skipContainer = Instance.new("Frame")
	skipContainer.Name = "SkipContainer"
	skipContainer.Size = UDim2.new(0.16, 0, 0.085, 0)
	skipContainer.Position = UDim2.new(0.82, 0, 0.90, 0)
	skipContainer.BackgroundTransparency = 1
	skipContainer.Visible = false
	skipContainer.ZIndex = 100
	skipContainer.Parent = screenGui

	local skipButton = Instance.new("TextButton")
	skipButton.Size = UDim2.new(1, 0, 1, 0)
	skipButton.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
	skipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	skipButton.Text = translations.skipText
	skipButton.TextScaled = true
	skipButton.Font = Enum.Font.Creepster
	skipButton.TextSize = 36
	skipButton.BorderSizePixel = 0
	skipButton.ZIndex = 101
	skipButton.Parent = skipContainer

	local skipCorner = Instance.new("UICorner")
	skipCorner.CornerRadius = UDim.new(0.18, 0)
	skipCorner.Parent = skipButton

	local skipStroke = Instance.new("UIStroke")
	skipStroke.Color = Color3.fromRGB(200, 50, 50)
	skipStroke.Thickness = 3
	skipStroke.Parent = skipButton

	local skipGradient = Instance.new("UIGradient")
	skipGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 15, 15)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 10, 10)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 5, 5))
	})
	skipGradient.Rotation = 90
	skipGradient.Parent = skipButton

	-- Efecto de pulso
	task.spawn(function()
		while skipButton.Parent do
			TweenService:Create(skipStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
				Thickness = 5,
				Color = Color3.fromRGB(255, 100, 100)
			}):Play()
			task.wait(1.2)
			TweenService:Create(skipStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
				Thickness = 3,
				Color = Color3.fromRGB(200, 50, 50)
			}):Play()
			task.wait(1.2)
		end
	end)

	-- Mostrar con animación después de 3 segundos
	task.delay(3, function()
		if skipContainer and skipContainer.Parent then
			skipContainer.Visible = true
			skipContainer.Size = UDim2.new(0, 0, 0, 0)
			skipContainer.Position = UDim2.new(0.9, 0, 0.93, 0)

			TweenService:Create(skipContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
				Size = UDim2.new(0.16, 0, 0.085, 0),
				Position = UDim2.new(0.82, 0, 0.90, 0)
			}):Play()
		end
	end)

	-- Hover effects
	skipButton.MouseEnter:Connect(function()
		TweenService:Create(skipButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(1.12, 0, 1.12, 0),
			Position = UDim2.new(-0.06, 0, -0.06, 0),
			BackgroundColor3 = Color3.fromRGB(120, 25, 25)
		}):Play()
		TweenService:Create(skipStroke, TweenInfo.new(0.3), {
			Thickness = 6,
			Color = Color3.fromRGB(255, 150, 150)
		}):Play()
	end)

	skipButton.MouseLeave:Connect(function()
		TweenService:Create(skipButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(60, 10, 10)
		}):Play()
	end)

	skipButton.MouseButton1Click:Connect(function()
		-- Efecto de click
		TweenService:Create(skipButton, TweenInfo.new(0.1), {
			Size = UDim2.new(0.9, 0, 0.9, 0),
			Position = UDim2.new(0.05, 0, 0.05, 0)
		}):Play()
		task.wait(0.1)

		skipCallback()
	end)

	return skipContainer
end

-- ==========================================
-- SALTAR AL MENÚ
-- ==========================================
local function skipToMenu()
	stopMusicWithFade(currentMusic, 0.5)

	for _, obj in ipairs(screenGui:GetChildren()) do
		if obj.Name ~= "SkipContainer" then
			obj:Destroy()
		end
	end

	local blackTransition = Instance.new("Frame")
	blackTransition.Size = UDim2.new(1, 0, 1, 0)
	blackTransition.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackTransition.BorderSizePixel = 0
	blackTransition.Parent = screenGui

	task.wait(0.5)

	playMusic("140513914361719", 0.4, 1)
	showMainMenu()

	local skipButton = screenGui:FindFirstChild("SkipContainer")
	if skipButton then
		skipButton:Destroy()
	end
end

-- ==========================================
-- SECUENCIA COMPLETA DE INTRO
-- ==========================================
local function playCompleteIntro()
	local skipButton = createEpicSkipButton(skipToMenu)

	playMusic("140513914361719", 0.35, 2)
	task.wait(2)

	-- Pantalla negra inicial
	local blackScreen = Instance.new("Frame")
	blackScreen.Size = UDim2.new(1, 0, 1, 0)
	blackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackScreen.BorderSizePixel = 0
	blackScreen.Parent = screenGui

	TweenService:Create(blackScreen, TweenInfo.new(2.5), {BackgroundTransparency = 1}):Play()
	task.wait(2.5)
	blackScreen:Destroy()

	-- Historia
	showCinematicStory()
	task.wait(1)

	-- Logo épico
	showEpicStrangerBloxLogo()
	task.wait(0.8)

	-- Créditos
	showCinematicCredit("デザイナー\nx_darekk", 3)
	showCinematicCredit("音楽\nRoblox Corporation", 3)
	showCinematicCredit("オリジナルストーリー\nダファー兄弟", 3)
	task.wait(1)

	-- Transición Upside Down
	showUpsideDownTransition()
	task.wait(0.5)

	-- Vecna glitch
	showVecnaGlitchSequence()
	task.wait(1)

	-- Menú principal
	showMainMenu()

	if skipButton then
		skipButton:Destroy()
	end
end

-- ==========================================
-- INICIAR INTRO
-- ==========================================
playCompleteIntro()
