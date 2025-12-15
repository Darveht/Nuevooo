local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StrangerBloxIntro"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

-- Variables
local currentMusic = nil
local skipEnabled = false

-- Traducciones
local translations = {
	storyText = "ホーキンスの町に再び闇が訪れた。ヴェクナが戻り、現実と裏側の世界の境界が崩壊しつつある。時間は残されていない…",
	playButton = "プレイ",
	loadingText = "読み込み中…",
	skipText = "Skip"
}

-- ===========================
-- SISTEMA DE MÚSICA
-- ===========================
local function playMusic(soundId, volume)
	if currentMusic then
		currentMusic:Stop()
		currentMusic:Destroy()
	end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. soundId
	sound.Volume = volume or 0.5
	sound.Looped = true
	sound.Parent = screenGui
	sound:Play()

	currentMusic = sound
	return sound
end

local function stopMusicWithFade(sound, fadeTime)
	if not sound then return end

	local fadeTween = TweenService:Create(
		sound,
		TweenInfo.new(fadeTime or 1, Enum.EasingStyle.Linear),
		{Volume = 0}
	)
	fadeTween:Play()
	fadeTween.Completed:Wait()

	sound:Stop()
	sound:Destroy()
end

-- ===========================
-- EFECTOS VISUALES AVANZADOS
-- ===========================

-- Efecto de partículas flotantes (como polvo/ceniza)
local function createParticleEffect(parent)
	local particleContainer = Instance.new("Frame")
	particleContainer.Size = UDim2.new(1, 0, 1, 0)
	particleContainer.BackgroundTransparency = 1
	particleContainer.Parent = parent

	for i = 1, 30 do
		local particle = Instance.new("Frame")
		particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
		particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
		particle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		particle.BackgroundTransparency = math.random(40, 80) / 100
		particle.BorderSizePixel = 0
		particle.Parent = particleContainer

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = particle

		-- Animación flotante
		task.spawn(function()
			while particle.Parent do
				local randomX = math.random(-50, 50) / 1000
				local randomY = math.random(-100, 0) / 1000
				local duration = math.random(30, 60) / 10

				TweenService:Create(particle, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
					Position = particle.Position + UDim2.new(randomX, 0, randomY, 0)
				}):Play()

				task.wait(duration)
			end
		end)
	end

	return particleContainer
end

-- Efecto de luces parpadeantes (como las luces de la serie)
local function createFlickeringLights(parent)
	local lightOverlay = Instance.new("Frame")
	lightOverlay.Size = UDim2.new(1, 0, 1, 0)
	lightOverlay.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	lightOverlay.BackgroundTransparency = 0.95
	lightOverlay.BorderSizePixel = 0
	lightOverlay.Parent = parent

	task.spawn(function()
		while lightOverlay.Parent do
			-- Parpadeo aleatorio
			lightOverlay.BackgroundTransparency = math.random(85, 100) / 100
			task.wait(math.random(5, 20) / 100)
		end
	end)

	return lightOverlay
end

-- Efecto de glitch avanzado
local function createAdvancedGlitch(textLabel, intense)
	local originalPos = textLabel.Position
	local originalColor = textLabel.TextColor3

	task.spawn(function()
		while textLabel.Parent do
			if intense then
				-- Glitch intenso
				textLabel.Position = originalPos + UDim2.new(
					math.random(-20, 20) / 1000,
					0,
					math.random(-20, 20) / 1000,
					0
				)
				textLabel.TextColor3 = Color3.fromRGB(
					math.random(200, 255),
					math.random(0, 100),
					math.random(0, 100)
				)
				textLabel.TextStrokeTransparency = math.random(0, 100) / 100
				task.wait(0.03)
			else
				-- Glitch suave
				task.wait(math.random(10, 30) / 10)
				textLabel.TextStrokeTransparency = math.random(30, 70) / 100
				task.wait(0.05)
				textLabel.TextStrokeTransparency = 0
			end
		end
	end)
end

-- Efecto de viñeta (oscurecimiento en bordes)
local function createVignette(parent)
	local vignette = Instance.new("ImageLabel")
	vignette.Size = UDim2.new(1, 0, 1, 0)
	vignette.BackgroundTransparency = 1
	vignette.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
	vignette.ImageTransparency = 0.3
	vignette.ScaleType = Enum.ScaleType.Slice
	vignette.Parent = parent

	-- Crear efecto de viñeta con gradiente
	local topGradient = Instance.new("Frame")
	topGradient.Size = UDim2.new(1, 0, 0.3, 0)
	topGradient.Position = UDim2.new(0, 0, 0, 0)
	topGradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	topGradient.BorderSizePixel = 0
	topGradient.Parent = vignette

	local topGrad = Instance.new("UIGradient")
	topGrad.Rotation = 90
	topGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	topGrad.Parent = topGradient

	local bottomGradient = topGradient:Clone()
	bottomGradient.Position = UDim2.new(0, 0, 0.7, 0)
	bottomGradient.Parent = vignette
	bottomGradient.UIGradient.Rotation = 270

	return vignette
end

-- Efecto de escaneo/líneas (como interferencia TV)
local function createScanlines(parent)
	local scanlineContainer = Instance.new("Frame")
	scanlineContainer.Size = UDim2.new(1, 0, 1, 0)
	scanlineContainer.BackgroundTransparency = 1
	scanlineContainer.Parent = parent

	for i = 1, 50 do
		local line = Instance.new("Frame")
		line.Size = UDim2.new(1, 0, 0, 2)
		line.Position = UDim2.new(0, 0, i / 50, 0)
		line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		line.BackgroundTransparency = 0.9
		line.BorderSizePixel = 0
		line.Parent = scanlineContainer
	end

	return scanlineContainer
end

-- Efecto de texto con sombra roja brillante (estilo ST)
local function styleStrangerThingsText(textLabel, glowing)
	textLabel.Font = Enum.Font.Creepster
	textLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

	if glowing then
		-- Crear efecto de brillo
		local glow1 = textLabel:Clone()
		glow1.TextTransparency = 0.6
		glow1.TextStrokeTransparency = 1
		glow1.Size = textLabel.Size + UDim2.new(0, 4, 0, 4)
		glow1.Position = textLabel.Position - UDim2.new(0, 2, 0, 2)
		glow1.ZIndex = textLabel.ZIndex - 1
		glow1.Parent = textLabel.Parent

		local glow2 = glow1:Clone()
		glow2.Size = textLabel.Size + UDim2.new(0, 8, 0, 8)
		glow2.Position = textLabel.Position - UDim2.new(0, 4, 0, 4)
		glow2.TextTransparency = 0.8
		glow2.ZIndex = textLabel.ZIndex - 2
		glow2.Parent = textLabel.Parent
	end
end

-- ===========================
-- PANTALLA NEGRA INICIAL
-- ===========================
local blackScreen = Instance.new("Frame")
blackScreen.Size = UDim2.new(1, 0, 1, 0)
blackScreen.Position = UDim2.new(0, 0, 0, 0)
blackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blackScreen.BorderSizePixel = 0
blackScreen.ZIndex = 1
blackScreen.Parent = screenGui

-- ===========================
-- PANTALLA DE HISTORIA
-- ===========================
local function showStory()
	local storyFrame = Instance.new("Frame")
	storyFrame.Size = UDim2.new(1, 0, 1, 0)
	storyFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
	storyFrame.BorderSizePixel = 0
	storyFrame.Parent = screenGui

	-- Efectos de fondo
	createVignette(storyFrame)
	local particles = createParticleEffect(storyFrame)
	local scanlines = createScanlines(storyFrame)
	createFlickeringLights(storyFrame)

	-- Texto de historia
	local storyText = Instance.new("TextLabel")
	storyText.Size = UDim2.new(0.8, 0, 0.4, 0)
	storyText.Position = UDim2.new(0.1, 0, 0.3, 0)
	storyText.BackgroundTransparency = 1
	storyText.Font = Enum.Font.Creepster
	storyText.TextSize = 32
	storyText.TextColor3 = Color3.fromRGB(220, 80, 80)
	storyText.TextStrokeTransparency = 0
	storyText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	storyText.TextWrapped = true
	storyText.TextTransparency = 1
	storyText.Text = translations.storyText
	storyText.TextYAlignment = Enum.TextYAlignment.Center
	storyText.Parent = storyFrame

	-- Animación de aparición
	local fadeIn = TweenService:Create(storyText, TweenInfo.new(2.5, Enum.EasingStyle.Sine), {TextTransparency = 0})
	fadeIn:Play()

	createAdvancedGlitch(storyText, false)

	task.wait(6)

	-- Animación de salida
	local fadeOut = TweenService:Create(storyText, TweenInfo.new(1.5), {TextTransparency = 1})
	fadeOut:Play()
	fadeOut.Completed:Wait()

	storyFrame:Destroy()
end

-- ===========================
-- LOGO STRANGER BLOX (ESTILO ST)
-- ===========================
local function showStrangerBloxLogo()
	local logoFrame = Instance.new("Frame")
	logoFrame.Size = UDim2.new(1, 0, 1, 0)
	logoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	logoFrame.BorderSizePixel = 0
	logoFrame.Parent = screenGui

	-- Efectos de fondo
	createVignette(logoFrame)
	createFlickeringLights(logoFrame)

	-- Contenedor de letras
	local letterContainer = Instance.new("Frame")
	letterContainer.Size = UDim2.new(0.9, 0, 0.3, 0)
	letterContainer.Position = UDim2.new(0.05, 0, 0.35, 0)
	letterContainer.BackgroundTransparency = 1
	letterContainer.Parent = logoFrame

	local letters = {"S", "T", "R", "A", "N", "G", "E", "R", " ", "B", "L", "O", "X"}
	local letterFrames = {}

	for i, letter in ipairs(letters) do
		local letterLabel = Instance.new("TextLabel")
		letterLabel.Size = UDim2.new(1/#letters, 0, 1, 0)
		letterLabel.Position = UDim2.new((i-1)/#letters, 0, 0, 0)
		letterLabel.BackgroundTransparency = 1
		letterLabel.Font = Enum.Font.Creepster
		letterLabel.TextSize = 70
		letterLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
		letterLabel.TextStrokeTransparency = 0
		letterLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		letterLabel.Text = letter
		letterLabel.TextTransparency = 1
		letterLabel.TextScaled = false
		letterLabel.Parent = letterContainer

		table.insert(letterFrames, letterLabel)

		-- Animación de aparición letra por letra
		task.spawn(function()
			task.wait(i * 0.15)

			-- Flash de luz
			local flash = Instance.new("Frame")
			flash.Size = UDim2.new(0.05, 0, 0.8, 0)
			flash.Position = UDim2.new((i-1)/#letters + 0.02, 0, 0.1, 0)
			flash.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
			flash.BorderSizePixel = 0
			flash.Parent = letterContainer

			TweenService:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			task.wait(0.3)
			flash:Destroy()

			-- Aparecer letra
			TweenService:Create(letterLabel, TweenInfo.new(0.4, Enum.EasingStyle.Bounce), {
				TextTransparency = 0,
				TextSize = 70
			}):Play()
		end)
	end

	task.wait(3)

	-- Efecto de parpadeo final (como las luces de la serie)
	for i = 1, 5 do
		for _, letter in ipairs(letterFrames) do
			letter.TextTransparency = 0.7
			letter.TextStrokeTransparency = 0.7
		end
		task.wait(0.08)
		for _, letter in ipairs(letterFrames) do
			letter.TextTransparency = 0
			letter.TextStrokeTransparency = 0
		end
		task.wait(0.12)
	end

	task.wait(1.5)

	-- Fade out
	for _, letter in ipairs(letterFrames) do
		TweenService:Create(letter, TweenInfo.new(1.2), {TextTransparency = 1}):Play()
	end

	task.wait(1.5)
	logoFrame:Destroy()
end

-- ===========================
-- CRÉDITOS
-- ===========================
local function showCredit(text, duration)
	local creditFrame = Instance.new("Frame")
	creditFrame.Size = UDim2.new(1, 0, 1, 0)
	creditFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	creditFrame.BorderSizePixel = 0
	creditFrame.Parent = screenGui

	createVignette(creditFrame)
	createFlickeringLights(creditFrame)

	local creditText = Instance.new("TextLabel")
	creditText.Size = UDim2.new(0.8, 0, 0.3, 0)
	creditText.Position = UDim2.new(0.1, 0, 0.35, 0)
	creditText.BackgroundTransparency = 1
	creditText.Font = Enum.Font.Creepster
	creditText.TextSize = 36
	creditText.TextColor3 = Color3.fromRGB(240, 240, 240)
	creditText.TextStrokeTransparency = 0.3
	creditText.TextStrokeColor3 = Color3.fromRGB(150, 0, 0)
	creditText.TextWrapped = true
	creditText.Text = text
	creditText.TextTransparency = 1
	creditText.Parent = creditFrame

	TweenService:Create(creditText, TweenInfo.new(1), {TextTransparency = 0}):Play()
	task.wait(duration or 2.5)
	TweenService:Create(creditText, TweenInfo.new(1), {TextTransparency = 1}):Play()
	task.wait(1)

	creditFrame:Destroy()
end

-- ===========================
-- GLITCH ÉPICO DE VECNA
-- ===========================
local function showEpicGlitch()
	local glitchFrame = Instance.new("Frame")
	glitchFrame.Size = UDim2.new(1, 0, 1, 0)
	glitchFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	glitchFrame.BorderSizePixel = 0
	glitchFrame.Parent = screenGui

	createVignette(glitchFrame)
	local particles = createParticleEffect(glitchFrame)

	-- Texto principal
	local mainText = Instance.new("TextLabel")
	mainText.Size = UDim2.new(0.8, 0, 0.4, 0)
	mainText.Position = UDim2.new(0.1, 0, 0.3, 0)
	mainText.BackgroundTransparency = 1
	mainText.Font = Enum.Font.Creepster
	mainText.TextSize = 140
	mainText.TextColor3 = Color3.fromRGB(255, 0, 0)
	mainText.TextStrokeTransparency = 0
	mainText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	mainText.Text = "ヴェクナ"
	mainText.TextTransparency = 1
	mainText.TextScaled = true
	mainText.Parent = glitchFrame

	-- Aparecer con glitch intenso
	TweenService:Create(mainText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	createAdvancedGlitch(mainText, true)

	-- Efecto de pantalla roja parpadeante
	task.spawn(function()
		for i = 1, 40 do
			glitchFrame.BackgroundColor3 = Color3.fromRGB(
				math.random(0, 50),
				0,
				0
			)
			task.wait(0.05)
		end
	end)

	task.wait(2.5)

	-- Desaparecer
	TweenService:Create(mainText, TweenInfo.new(1), {TextTransparency = 1}):Play()
	TweenService:Create(glitchFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
	task.wait(1)
	glitchFrame:Destroy()
end

-- ===========================
-- MENÚ PRINCIPAL
-- ===========================
local function showMainMenu()
	local menuFrame = Instance.new("Frame")
	menuFrame.Size = UDim2.new(1, 0, 1, 0)
	menuFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 5)
	menuFrame.BorderSizePixel = 0
	menuFrame.Parent = screenGui

	-- Efectos de fondo
	createVignette(menuFrame)
	createParticleEffect(menuFrame)
	createScanlines(menuFrame)
	createFlickeringLights(menuFrame)

	-- Título
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.8, 0, 0.25, 0)
	titleLabel.Position = UDim2.new(0.1, 0, 0.15, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Creepster
	titleLabel.TextSize = 80
	titleLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
	titleLabel.TextStrokeTransparency = 0
	titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	titleLabel.Text = "STRANGER BLOX"
	titleLabel.TextScaled = true
	titleLabel.Parent = menuFrame

	styleStrangerThingsText(titleLabel, true)
	createAdvancedGlitch(titleLabel, false)

	-- Botón de jugar
	local playButton = Instance.new("TextButton")
	playButton.Size = UDim2.new(0.35, 0, 0.12, 0)
	playButton.Position = UDim2.new(0.325, 0, 0.55, 0)
	playButton.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
	playButton.Font = Enum.Font.Creepster
	playButton.TextSize = 48
	playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	playButton.Text = translations.playButton
	playButton.TextScaled = true
	playButton.BorderSizePixel = 0
	playButton.Parent = menuFrame

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0.15, 0)
	buttonCorner.Parent = playButton

	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = Color3.fromRGB(255, 100, 100)
	buttonStroke.Thickness = 4
	buttonStroke.Parent = playButton

	-- Efecto hover
	playButton.MouseEnter:Connect(function()
		TweenService:Create(playButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(180, 40, 40),
			Size = UDim2.new(0.37, 0, 0.13, 0)
		}):Play()
	end)

	playButton.MouseLeave:Connect(function()
		TweenService:Create(playButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(120, 20, 20),
			Size = UDim2.new(0.35, 0, 0.12, 0)
		}):Play()
	end)

	playButton.MouseButton1Click:Connect(function()
		stopMusicWithFade(currentMusic, 1)
		menuFrame:Destroy()
		showLoadingScreen()
	end)
end

-- ===========================
-- PANTALLA DE CARGA
-- ===========================
function showLoadingScreen()
	playMusic("127899975684445", 0.4)

	local loadingFrame = Instance.new("Frame")
	loadingFrame.Size = UDim2.new(1, 0, 1, 0)
	loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	loadingFrame.BorderSizePixel = 0
	loadingFrame.Parent = screenGui

	createVignette(loadingFrame)
	createParticleEffect(loadingFrame)
	createFlickeringLights(loadingFrame)

	local loadingText = Instance.new("TextLabel")
	loadingText.Size = UDim2.new(0.8, 0, 0.15, 0)
	loadingText.Position = UDim2.new(0.1, 0, 0.25, 0)
	loadingText.BackgroundTransparency = 1
	loadingText.Font = Enum.Font.Creepster
	loadingText.TextSize = 42
	loadingText.TextColor3 = Color3.fromRGB(220, 60, 60)
	loadingText.Text = translations.loadingText
	loadingText.TextScaled = true
	loadingText.Parent = loadingFrame

	createAdvancedGlitch(loadingText, false)

	-- Barra de carga con estilo ST
	local barContainer = Instance.new("Frame")
	barContainer.Size = UDim2.new(0.7, 0, 0.06, 0)
	barContainer.Position = UDim2.new(0.15, 0, 0.55, 0)
	barContainer.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
	barContainer.BorderSizePixel = 0
	barContainer.Parent = loadingFrame

	local barStroke = Instance.new("UIStroke")
	barStroke.Color = Color3.fromRGB(150, 50, 50)
	barStroke.Thickness = 3
	barStroke.Parent = barContainer

	Instance.new("UICorner", barContainer).CornerRadius = UDim.new(0.3, 0)

	local progressBar = Instance.new("Frame")
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	progressBar.BorderSizePixel = 0
	progressBar.Parent = barContainer

	Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0.3, 0)

	-- Efecto de brillo en la barra
	local barGlow = Instance.new("Frame")
	barGlow.Size = UDim2.new(1, 0, 1, 0)
	barGlow.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
	barGlow.BackgroundTransparency = 0.7
	barGlow.BorderSizePixel = 0
	barGlow.Parent = progressBar

	Instance.new("UICorner", barGlow).CornerRadius = UDim.new(0.3, 0)

	-- Animación de carga
	local fillTween = TweenService:Create(
		progressBar,
		TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		{Size = UDim2.new(1, 0, 1, 0)}
	)
	fillTween:Play()
	fillTween.Completed:Wait()

	task.wait(0.5)
	stopMusicWithFade(currentMusic, 1)

	TweenService:Create(loadingFrame, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()
	task.wait(1.5)

	playMusic("4940109913", 0.3)
	screenGui:Destroy()
end

-- ===========================
-- BOTÓN SKIP
-- ===========================
local function createSkipButton(skipCallback)
	local skipButton = Instance.new("TextButton")
	skipButton.Name = "SkipButton"
	skipButton.Size = UDim2.new(0.14, 0, 0.07, 0)
	skipButton.Position = UDim2.new(0.84, 0, 0.91, 0)
	skipButton.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
	skipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	skipButton.Text = translations.skipText
	skipButton.TextScaled = true
	skipButton.Font = Enum.Font.Creepster
	skipButton.BorderSizePixel = 0
	skipButton.Visible = false
	skipButton.ZIndex = 100
	skipButton.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = skipButton

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(200, 50, 50)
	stroke.Thickness = 2
	stroke.Parent = skipButton

	-- Mostrar después de 3 segundos
	task.delay(3, function()
		if skipButton and skipButton.Parent then
			skipButton.Visible = true
			TweenService:Create(skipButton, TweenInfo.new(0.5), {
				BackgroundColor3 = Color3.fromRGB(100, 25, 25)
			}):Play()
		end
	end)

	-- Hover effect
	skipButton.MouseEnter:Connect(function()
		TweenService:Create(skipButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(150, 40, 40),
			Size = UDim2.new(0.15, 0, 0.075, 0)
		}):Play()
	end)

	skipButton.MouseLeave:Connect(function()
		TweenService:Create(skipButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(100, 25, 25),
			Size = UDim2.new(0.14, 0, 0.07, 0)
		}):Play()
	end)

	skipButton.MouseButton1Click:Connect(function()
		skipCallback()
	end)

	return skipButton
end

-- ===========================
-- SALTAR AL MENÚ
-- ===========================
local function skipToMenu()
	stopMusicWithFade(currentMusic, 0.4)

	for _, obj in ipairs(screenGui:GetChildren()) do
		if obj.Name ~= "SkipButton" then
			obj:Destroy()
		end
	end

	-- Recrear pantalla negra
	blackScreen = Instance.new("Frame")
	blackScreen.Size = UDim2.new(1, 0, 1, 0)
	blackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackScreen.BorderSizePixel = 0
	blackScreen.Parent = screenGui

	task.wait(0.3)

	playMusic("140513914361719", 0.4)
	showMainMenu()
end

-- ===========================
-- SECUENCIA DE INTRO COMPLETA
-- ===========================
local function playIntroSequence()
	local skipButton = createSkipButton(skipToMenu)

	playMusic("140513914361719", 0.4)
	task.wait(1.5)

	-- Fade out de pantalla negra
	TweenService:Create(blackScreen, TweenInfo.new(2), {BackgroundTransparency = 1}):Play()
	task.wait(2)

	showStory()
	task.wait(1)

	showStrangerBloxLogo()
	task.wait(0.5)

	showCredit("デザイナー\nx_darekk", 2.8)
	showCredit("音楽\nRoblox Corporation", 2.8)
	showCredit("オリジナルストーリー\nダファー兄弟", 2.8)
	task.wait(0.8)

	showEpicGlitch()
	task.wait(1)

	showMainMenu()

	if skipButton then
		skipButton:Destroy()
	end
end

-- ===========================
-- INICIAR INTRO
-- ===========================
playIntroSequence()
