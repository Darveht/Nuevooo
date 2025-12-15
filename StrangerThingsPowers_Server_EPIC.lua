-- ════════════════════════════════════════════════════════════════════════════
-- STRANGER THINGS EPIC POWERS SYSTEM - SERVER SCRIPT (VERSIÓN ULTRA ÉPICA)
-- Coloca este script en ServerScriptService
-- ════════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

-- ════════════════════════════════════════════════════════════════════════════
-- CREAR REMOTE EVENTS
-- ════════════════════════════════════════════════════════════════════════════

local powerEvents = Instance.new("Folder")
powerEvents.Name = "PowerEvents"
powerEvents.Parent = ReplicatedStorage

local telekinesisPower = Instance.new("RemoteEvent")
telekinesisPower.Name = "TelekinesisPower"
telekinesisPower.Parent = powerEvents

local explosionPower = Instance.new("RemoteEvent")
explosionPower.Name = "ExplosionPower"
explosionPower.Parent = powerEvents

local controlPower = Instance.new("RemoteEvent")
controlPower.Name = "ControlPower"
controlPower.Parent = powerEvents

local protectionPower = Instance.new("RemoteEvent")
protectionPower.Name = "ProtectionPower"
protectionPower.Parent = powerEvents

local healingPower = Instance.new("RemoteEvent")
healingPower.Name = "HealingPower"
healingPower.Parent = powerEvents

-- ════════════════════════════════════════════════════════════════════════════
-- CONFIGURACIÓN ÉPICA
-- ════════════════════════════════════════════════════════════════════════════

local POWER_CONFIG = {
	Telekinesis = {
		Cooldown = 15,
		Duration = 8,
		Range = 50,
		Color = Color3.fromRGB(138, 43, 226),
		ActivationSound = "rbxassetid://9116931944",
		LoopSound = "rbxassetid://9125516670",
		ImpactSound = "rbxassetid://9114221327"
	},
	Explosion = {
		Cooldown = 20,
		Range = 60,
		Force = 5000,
		Damage = 50,
		Color = Color3.fromRGB(195, 0, 0),
		ActivationSound = "rbxassetid://2621689551",
		ExplosionSound = "rbxassetid://9114397505",
		ChargeSound = "rbxassetid://9116931944"
	},
	Control = {
		Cooldown = 25,
		Duration = 10,
		Range = 45,
		Color = Color3.fromRGB(255, 69, 0),
		ActivationSound = "rbxassetid://9116931944",
		LoopSound = "rbxassetid://9125516670"
	},
	Protection = {
		Cooldown = 60,
		Duration = 30,
		Color = Color3.fromRGB(255, 10, 10),
		ActivationSound = "rbxassetid://814168787",
		LoopSound = "rbxassetid://9125516670",
		HitSound = "rbxassetid://9114221327"
	},
	Healing = {
		Cooldown = 18,
		Range = 40,
		HealAmount = 50,
		Duration = 2,
		Color = Color3.fromRGB(0, 255, 127),
		ActivationSound = "rbxassetid://5153438710",
		LoopSound = "rbxassetid://9125516670",
		CompleteSound = "rbxassetid://6026984224"
	}
}

local playerCooldowns = {}

-- ════════════════════════════════════════════════════════════════════════════
-- SISTEMA DE COOLDOWN
-- ════════════════════════════════════════════════════════════════════════════

local function checkAndSetCooldown(userId, powerName, requiredCooldown)
	if not playerCooldowns[userId] then
		playerCooldowns[userId] = {}
	end
	
	local now = tick()
	if playerCooldowns[userId][powerName] and now - playerCooldowns[userId][powerName] < requiredCooldown then
		return false
	end
	
	playerCooldowns[userId][powerName] = now
	return true
end

-- ════════════════════════════════════════════════════════════════════════════
-- SISTEMA DE SONIDO MEJORADO
-- ════════════════════════════════════════════════════════════════════════════

local function createPowerSounds(parent, config)
	local sounds = {}
	
	-- Sonido de activación
	local activationSound = Instance.new("Sound")
	activationSound.Name = "ActivationSound"
	activationSound.SoundId = config.ActivationSound
	activationSound.Volume = 1.5
	activationSound.Parent = parent
	activationSound:Play()
	table.insert(sounds, activationSound)
	
	-- Sonido de loop
	if config.LoopSound then
		local loopSound = Instance.new("Sound")
		loopSound.Name = "LoopSound"
		loopSound.SoundId = config.LoopSound
		loopSound.Volume = 0.8
		loopSound.Looped = true
		loopSound.Parent = parent
		
		task.delay(0.3, function()
			if loopSound and loopSound.Parent then
				loopSound:Play()
			end
		end)
		
		table.insert(sounds, loopSound)
	end
	
	return sounds
end

local function stopPowerSounds(sounds)
	for _, sound in ipairs(sounds) do
		if sound and sound.Parent then
			if sound.Looped then
				sound:Stop()
			end
			Debris:AddItem(sound, 1)
		end
	end
end

-- ════════════════════════════════════════════════════════════════════════════
-- EFECTOS VISUALES ÉPICOS - PARTÍCULAS AVANZADAS
-- ════════════════════════════════════════════════════════════════════════════

local function createEpicParticles(parent, color, intensity)
	local effects = {}
	intensity = intensity or 1
	
	-- ═══ CAPA 1: NÚCLEO BRILLANTE ═══
	local core = Instance.new("ParticleEmitter")
	core.Name = "CoreParticles"
	core.Parent = parent
	core.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	core.Color = ColorSequence.new(color, Color3.new(1, 1, 1))
	core.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.3, 3 * intensity),
		NumberSequenceKeypoint.new(1, 0)
	})
	core.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.7, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	core.Lifetime = NumberRange.new(0.8, 1.5)
	core.Rate = 120 * intensity
	core.Speed = NumberRange.new(10, 20)
	core.SpreadAngle = Vector2.new(180, 180)
	core.Rotation = NumberRange.new(0, 360)
	core.RotSpeed = NumberRange.new(-300, 300)
	core.LightEmission = 1
	core.LightInfluence = 0
	core.Enabled = true
	table.insert(effects, core)
	
	-- ═══ CAPA 2: ENERGÍA RADIANTE ═══
	local energy = Instance.new("ParticleEmitter")
	energy.Name = "EnergyParticles"
	energy.Parent = parent
	energy.Texture = "rbxassetid://6101261905"
	energy.Color = ColorSequence.new(color)
	energy.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1 * intensity),
		NumberSequenceKeypoint.new(0.5, 4 * intensity),
		NumberSequenceKeypoint.new(1, 0.5 * intensity)
	})
	energy.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(0.5, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	energy.Lifetime = NumberRange.new(1, 2)
	energy.Rate = 80 * intensity
	energy.Speed = NumberRange.new(5, 15)
	energy.SpreadAngle = Vector2.new(180, 180)
	energy.Rotation = NumberRange.new(0, 360)
	energy.RotSpeed = NumberRange.new(-200, 200)
	energy.LightEmission = 0.9
	energy.Enabled = true
	table.insert(effects, energy)
	
	-- ═══ CAPA 3: NIEBLA OSCURA ═══
	local smoke = Instance.new("ParticleEmitter")
	smoke.Name = "SmokeParticles"
	smoke.Parent = parent
	smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
	smoke.Color = ColorSequence.new(Color3.fromRGB(20, 20, 20), color * 0.3)
	smoke.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 2 * intensity),
		NumberSequenceKeypoint.new(1, 6 * intensity)
	})
	smoke.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	smoke.Lifetime = NumberRange.new(2, 3.5)
	smoke.Rate = 40 * intensity
	smoke.Speed = NumberRange.new(3, 8)
	smoke.SpreadAngle = Vector2.new(180, 180)
	smoke.Rotation = NumberRange.new(0, 360)
	smoke.RotSpeed = NumberRange.new(-100, 100)
	smoke.Enabled = true
	table.insert(effects, smoke)
	
	-- ═══ CAPA 4: CHISPAS ELÉCTRICAS ═══
	local sparks = Instance.new("ParticleEmitter")
	sparks.Name = "SparkParticles"
	sparks.Parent = parent
	sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	sparks.Color = ColorSequence.new(Color3.new(1, 1, 1), color)
	sparks.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(1, 0)
	})
	sparks.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	sparks.Lifetime = NumberRange.new(0.2, 0.6)
	sparks.Rate = 100 * intensity
	sparks.Speed = NumberRange.new(20, 40)
	sparks.SpreadAngle = Vector2.new(180, 180)
	sparks.Acceleration = Vector3.new(0, -20, 0)
	sparks.LightEmission = 1
	sparks.Enabled = true
	table.insert(effects, sparks)
	
	return effects
end

-- ════════════════════════════════════════════════════════════════════════════
-- EFECTOS DE RAYOS ÉPICOS (BEAMS)
-- ════════════════════════════════════════════════════════════════════════════

local function createEpicBeam(attachment0, attachment1, color)
	local beams = {}
	
	-- ═══ RAYO PRINCIPAL ═══
	local mainBeam = Instance.new("Beam")
	mainBeam.Name = "MainBeam"
	mainBeam.Attachment0 = attachment0
	mainBeam.Attachment1 = attachment1
	mainBeam.Color = ColorSequence.new(color)
	mainBeam.Width0 = 3
	mainBeam.Width1 = 3
	mainBeam.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0.2),
		NumberSequenceKeypoint.new(1, 0)
	})
	mainBeam.FaceCamera = true
	mainBeam.LightEmission = 1
	mainBeam.LightInfluence = 0
	mainBeam.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	mainBeam.TextureMode = Enum.TextureMode.Wrap
	mainBeam.TextureSpeed = 5
	mainBeam.TextureLength = 1
	mainBeam.Parent = attachment0.Parent
	table.insert(beams, mainBeam)
	
	-- ═══ RAYO SECUNDARIO (MÁS ANCHO) ═══
	local outerBeam = Instance.new("Beam")
	outerBeam.Name = "OuterBeam"
	outerBeam.Attachment0 = attachment0
	outerBeam.Attachment1 = attachment1
	outerBeam.Color = ColorSequence.new(color, Color3.new(1, 1, 1))
	outerBeam.Width0 = 5
	outerBeam.Width1 = 5
	outerBeam.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.6),
		NumberSequenceKeypoint.new(0.5, 0.8),
		NumberSequenceKeypoint.new(1, 0.6)
	})
	outerBeam.FaceCamera = true
	outerBeam.LightEmission = 0.8
	outerBeam.Texture = "rbxassetid://6101261905"
	outerBeam.TextureMode = Enum.TextureMode.Wrap
	outerBeam.TextureSpeed = -3
	outerBeam.Parent = attachment0.Parent
	table.insert(beams, outerBeam)
	
	-- ═══ RAYO DISTORSIONADO ═══
	local distortBeam = Instance.new("Beam")
	distortBeam.Name = "DistortBeam"
	distortBeam.Attachment0 = attachment0
	distortBeam.Attachment1 = attachment1
	distortBeam.Color = ColorSequence.new(Color3.new(1, 1, 1))
	distortBeam.Width0 = 7
	distortBeam.Width1 = 7
	distortBeam.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.85),
		NumberSequenceKeypoint.new(1, 0.85)
	})
	distortBeam.FaceCamera = true
	distortBeam.LightEmission = 0.5
	distortBeam.Texture = "rbxasset://textures/particles/smoke_main.dds"
	distortBeam.TextureMode = Enum.TextureMode.Static
	distortBeam.Parent = attachment0.Parent
	table.insert(beams, distortBeam)
	
	return beams
end

-- ════════════════════════════════════════════════════════════════════════════
-- EFECTO DE SANGRADO NASAL (CUANDO SE USA EL PODER)
-- ════════════════════════════════════════════════════════════════════════════

local function createNoseBleed(character)
	local head = character:FindFirstChild("Head")
	if not head then return nil end
	
	local blood = Instance.new("ParticleEmitter")
	blood.Name = "NoseBleed"
	blood.Parent = head
	blood.Texture = "rbxasset://textures/particles/smoke_main.dds"
	blood.Color = ColorSequence.new(Color3.fromRGB(139, 0, 0))
	blood.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.15),
		NumberSequenceKeypoint.new(1, 0.4)
	})
	blood.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	blood.Lifetime = NumberRange.new(1, 2)
	blood.Rate = 20
	blood.Speed = NumberRange.new(1, 5)
	blood.SpreadAngle = Vector2.new(15, 15)
	blood.EmissionDirection = Enum.NormalId.Bottom
	blood.Acceleration = Vector3.new(0, -15, 0)
	blood.Enabled = true
	
	return blood
end

-- ════════════════════════════════════════════════════════════════════════════
-- LUZ PSICOKINÉTICA (EFECTO EN CABEZA)
-- ════════════════════════════════════════════════════════════════════════════

local function createPsychicLight(character, color)
	local head = character:FindFirstChild("Head")
	if not head then return nil end
	
	-- Luz principal
	local light = Instance.new("PointLight")
	light.Name = "PsychicLight"
	light.Parent = head
	light.Color = color
	light.Brightness = 8
	light.Range = 30
	light.Shadows = true
	
	-- Animación de pulso
	task.spawn(function()
		local time = 0
		while light and light.Parent do
			time = time + 0.05
			light.Brightness = 8 + math.sin(time * 10) * 3
			light.Range = 30 + math.sin(time * 8) * 5
			task.wait(0.05)
		end
	end)
	
	return light
end

-- ════════════════════════════════════════════════════════════════════════════
-- ONDAS DE CHOQUE
-- ════════════════════════════════════════════════════════════════════════════

local function createShockwave(position, color, size, duration)
	local shockwave = Instance.new("Part")
	shockwave.Shape = Enum.PartType.Cylinder
	shockwave.Size = Vector3.new(0.5, size, size)
	shockwave.Position = position
	shockwave.Anchored = true
	shockwave.CanCollide = false
	shockwave.Material = Enum.Material.Neon
	shockwave.Color = color
	shockwave.Transparency = 0.3
	shockwave.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	shockwave.Parent = workspace
	
	TweenService:Create(shockwave, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(0.5, size * 5, size * 5),
		Transparency = 1
	}):Play()
	
	Debris:AddItem(shockwave, duration)
end

-- ════════════════════════════════════════════════════════════════════════════
-- PODER 1: TELEKINESIS ÉPICA
-- ════════════════════════════════════════════════════════════════════════════

local function useTelekinesis(player, targetPlayer)
	local character = player.Character
	local targetCharacter = targetPlayer.Character
	
	if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
	if not checkAndSetCooldown(player.UserId, "Telekinesis", POWER_CONFIG.Telekinesis.Cooldown) then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
	if not hrp or not targetHRP then return end
	
	local distance = (hrp.Position - targetHRP.Position).Magnitude
	if distance > POWER_CONFIG.Telekinesis.Range then return end
	
	local config = POWER_CONFIG.Telekinesis
	
	-- ═══ EFECTOS EN USUARIO ═══
	local userEffects = createEpicParticles(character.Head, config.Color, 1.5)
	local noseBleed = createNoseBleed(character)
	local userLight = createPsychicLight(character, config.Color)
	local sounds = createPowerSounds(character.Head, config)
	
	-- ═══ EFECTOS EN OBJETIVO ═══
	local targetEffects = createEpicParticles(targetCharacter.Head, config.Color, 1.2)
	local targetLight = createPsychicLight(targetCharacter, config.Color)
	
	-- ═══ RAYOS DE CONEXIÓN ═══
	local att0 = Instance.new("Attachment", character.Head)
	local att1 = Instance.new("Attachment", targetCharacter.Head)
	local beams = createEpicBeam(att0, att1, config.Color)
	
	-- ═══ ONDAS DE CHOQUE INICIALES ═══
	for i = 1, 3 do
		task.delay(i * 0.15, function()
			createShockwave(hrp.Position, config.Color, 5, 0.6)
			createShockwave(targetHRP.Position, config.Color, 4, 0.5)
		end)
	end
	
	-- ═══ AURA ALREDEDOR DEL OBJETIVO ═══
	local aura = Instance.new("Part")
	aura.Shape = Enum.PartType.Ball
	aura.Size = Vector3.new(8, 8, 8)
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.ForceField
	aura.Color = config.Color
	aura.Transparency = 0.7
	aura.Parent = workspace
	
	local auraConnection
	auraConnection = RunService.Heartbeat:Connect(function()
		if targetHRP and targetHRP.Parent then
			aura.CFrame = targetHRP.CFrame
		else
			auraConnection:Disconnect()
		end
	end)
	
	-- ═══ CONTROL TELEKINÉTICO ═══
	local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
	if targetHumanoid then
		targetHumanoid.WalkSpeed = 0
		targetHumanoid.JumpPower = 0
		
		local bodyPosition = Instance.new("BodyPosition")
		bodyPosition.Name = "TelekinesisFloat"
		bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
		bodyPosition.Position = targetHRP.Position + Vector3.new(0, 8, 0)
		bodyPosition.D = 1200
		bodyPosition.P = 10000
		bodyPosition.Parent = targetHRP
		
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.Name = "TelekinesisGyro"
		bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
		bodyGyro.D = 1000
		bodyGyro.P = 5000
		bodyGyro.Parent = targetHRP
		
		-- Animación de levitación y rotación
		task.spawn(function()
			local time = 0
			while time < config.Duration and bodyGyro.Parent do
				time = time + 0.05
				local height = 8 + math.sin(time * 3) * 2
				bodyPosition.Position = hrp.Position + Vector3.new(0, height, 0) + hrp.CFrame.LookVector * 10
				bodyGyro.CFrame = CFrame.Angles(
					math.sin(time * 2) * 0.5,
					time * 4,
					math.cos(time * 2) * 0.5
				)
				task.wait(0.05)
			end
		end)
		
		-- Restaurar después de la duración
		task.delay(config.Duration, function()
			targetHumanoid.WalkSpeed = 16
			targetHumanoid.JumpPower = 50
			if bodyPosition then bodyPosition:Destroy() end
			if bodyGyro then bodyGyro:Destroy() end
		end)
	end
	
	-- ═══ LIMPIEZA ═══
	task.delay(config.Duration, function()
		auraConnection:Disconnect()
		aura:Destroy()
		stopPowerSounds(sounds)
		
		for _, effect in ipairs(userEffects) do effect:Destroy() end
		for _, effect in ipairs(targetEffects) do effect:Destroy() end
		for _, beam in ipairs(beams) do beam:Destroy() end
		if noseBleed then noseBleed:Destroy() end
		if userLight then userLight:Destroy() end
		if targetLight then targetLight:Destroy() end
		if att0 then att0:Destroy() end
		if att1 then att1:Destroy() end
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- PODER 2: EXPLOSIÓN PSÍQUICA DEVASTADORA
-- ════════════════════════════════════════════════════════════════════════════

local function useExplosion(player, targetPlayer)
	local character = player.Character
	local targetCharacter = targetPlayer.Character
	
	if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
	if not checkAndSetCooldown(player.UserId, "Explosion", POWER_CONFIG.Explosion.Cooldown) then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
	if not hrp or not targetHRP then return end
	
	local distance = (hrp.Position - targetHRP.Position).Magnitude
	if distance > POWER_CONFIG.Explosion.Range then return end
	
	local config = POWER_CONFIG.Explosion
	
	-- ═══ EFECTOS EN USUARIO ═══
	local userEffects = createEpicParticles(character.Head, config.Color, 2)
	local noseBleed = createNoseBleed(character)
	local userLight = createPsychicLight(character, config.Color)
	local sounds = createPowerSounds(character.Head, config)
	
	-- ═══ ESFERA DE CARGA ÉPICA ═══
	local chargeSphere = Instance.new("Part")
	chargeSphere.Shape = Enum.PartType.Ball
	chargeSphere.Size = Vector3.new(1, 1, 1)
	chargeSphere.Position = targetHRP.Position
	chargeSphere.Anchored = true
	chargeSphere.CanCollide = false
	chargeSphere.Material = Enum.Material.Neon
	chargeSphere.Color = config.Color
	chargeSphere.Transparency = 0.1
	chargeSphere.Parent = workspace
	
	-- Luz pulsante
	local chargeLight = Instance.new("PointLight")
	chargeLight.Color = config.Color
	chargeLight.Brightness = 15
	chargeLight.Range = 40
	chargeLight.Shadows = true
	chargeLight.Parent = chargeSphere
	
	-- Partículas de carga
	local chargeParticles = createEpicParticles(chargeSphere, config.Color, 2.5)
	
	-- Animación de carga con sonido
	local chargeSound = Instance.new("Sound")
	chargeSound.SoundId = config.ChargeSound
	chargeSound.Volume = 1.5
	chargeSound.Parent = chargeSphere
	chargeSound:Play()
	
	TweenService:Create(chargeSphere, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = Vector3.new(10, 10, 10),
		Transparency = 0
	}):Play()
	
	TweenService:Create(chargeLight, TweenInfo.new(1.5), {
		Brightness = 25,
		Range = 60
	}):Play()
	
	task.wait(1.5)
	
	-- ═══ ¡EXPLOSIÓN ÉPICA! ═══
	for _, particle in ipairs(chargeParticles) do
		particle.Enabled = false
	end
	
	local explosionSound = Instance.new("Sound")
	explosionSound.SoundId = config.ExplosionSound
	explosionSound.Volume = 3
	explosionSound.Parent = chargeSphere
	explosionSound:Play()
	
	-- Múltiples ondas de choque
	for i = 1, 8 do
		task.spawn(function()
			task.wait(i * 0.08)
			createShockwave(targetHRP.Position, config.Color, 10 + i * 2, 1)
			
			-- Anillo de energía
			local ring = Instance.new("Part")
			ring.Shape = Enum.PartType.Cylinder
			ring.Size = Vector3.new(1, 1, 1)
			ring.Position = targetHRP.Position
			ring.Anchored = true
			ring.CanCollide = false
			ring.Material = Enum.Material.Neon
			ring.Color = config.Color
			ring.Transparency = 0.3
			ring.CFrame = CFrame.new(targetHRP.Position) * CFrame.Angles(0, 0, math.rad(90))
			ring.Parent = workspace
			
			TweenService:Create(ring, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = Vector3.new(1, 50 + i * 5, 50 + i * 5),
				Transparency = 1
			}):Play()
			
			Debris:AddItem(ring, 0.8)
		end)
	end
	
	-- Esfera de explosión
	local explosionSphere = Instance.new("Part")
	explosionSphere.Shape = Enum.PartType.Ball
	explosionSphere.Size = Vector3.new(1, 1, 1)
	explosionSphere.Position = targetHRP.Position
	explosionSphere.Anchored = true
	explosionSphere.CanCollide = false
	explosionSphere.Material = Enum.Material.Neon
	explosionSphere.Color = config.Color
	explosionSphere.Transparency = 0
	explosionSphere.Parent = workspace
	
	TweenService:Create(explosionSphere, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(60, 60, 60),
		Transparency = 1
	}):Play()
	
	Debris:AddItem(explosionSphere, 0.5)
	
	-- Explosión real
	local explosion = Instance.new("Explosion")
	explosion.Position = targetHRP.Position
	explosion.BlastPressure = config.Force
	explosion.BlastRadius = 25
	explosion.ExplosionType = Enum.ExplosionType.Craters
	explosion.Parent = workspace
	
	-- Daño
	local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
	if targetHumanoid then
		targetHumanoid:TakeDamage(config.Damage)
	end
	
	-- ═══ LIMPIEZA ═══
	stopPowerSounds(sounds)
	task.delay(2, function()
		for _, effect in ipairs(userEffects) do effect:Destroy() end
		for _, effect in ipairs(chargeParticles) do effect:Destroy() end
		if noseBleed then noseBleed:Destroy() end
		if userLight then userLight:Destroy() end
		chargeSphere:Destroy()
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- PODER 3: CONTROL MENTAL MASIVO
-- ════════════════════════════════════════════════════════════════════════════

local function useControl(player)
	local character = player.Character
	if not character then return end
	if not checkAndSetCooldown(player.UserId, "Control", POWER_CONFIG.Control.Cooldown) then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local config = POWER_CONFIG.Control
	
	-- ═══ EFECTOS EN USUARIO ═══
	local userEffects = createEpicParticles(character.Head, config.Color, 2.5)
	local noseBleed = createNoseBleed(character)
	local userLight = createPsychicLight(character, config.Color)
	local sounds = createPowerSounds(character.Head, config)
	
	-- ═══ ZONA DE CONTROL CON MÚLTIPLES CAPAS ═══
	local zones = {}
	for i = 1, 4 do
		local zone = Instance.new("Part")
		zone.Shape = Enum.PartType.Cylinder
		zone.Size = Vector3.new(1, config.Range * 2 * (1 + i * 0.15), config.Range * 2 * (1 + i * 0.15))
		zone.Position = hrp.Position
		zone.Rotation = Vector3.new(0, 0, 90)
		zone.Anchored = true
		zone.CanCollide = false
		zone.Material = Enum.Material.ForceField
		zone.Color = config.Color
		zone.Transparency = 0.5 + (i * 0.08)
		zone.Parent = workspace
		
		-- Luz
		local zoneLight = Instance.new("PointLight")
		zoneLight.Color = config.Color
		zoneLight.Brightness = 8 - i
		zoneLight.Range = config.Range + i * 5
		zoneLight.Parent = zone
		
		-- Partículas
		local zoneParticles = createEpicParticles(zone, config.Color, 0.5)
		
		-- Animación de rotación
		task.spawn(function()
			local angle = 0
			while zone.Parent do
				angle = angle + (2 * i * 0.05)
				zone.Rotation = Vector3.new(0, angle, 90)
				task.wait(0.03)
			end
		end)
		
		-- Pulso
		TweenService:Create(zone, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Transparency = 0.3 + (i * 0.08)
		}):Play()
		
		table.insert(zones, {Part = zone, Particles = zoneParticles, Light = zoneLight})
	end
	
	-- ═══ CONTROL DE JUGADORES ═══
	local controlledPlayers = {}
	local duration = config.Duration
	local startTime = tick()
	
	local controlConnection
	controlConnection = RunService.Heartbeat:Connect(function()
		if tick() - startTime > duration then
			controlConnection:Disconnect()
			return
		end
		
		-- Actualizar posición de las zonas
		for _, zoneData in ipairs(zones) do
			zoneData.Part.Position = hrp.Position
		end
		
		-- Controlar jugadores en rango
		for _, otherPlayer in pairs(Players:GetPlayers()) do
			if otherPlayer ~= player and otherPlayer.Character then
				local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
				if otherHRP then
					local dist = (hrp.Position - otherHRP.Position).Magnitude
					
					if dist <= config.Range and not controlledPlayers[otherPlayer.UserId] then
						controlledPlayers[otherPlayer.UserId] = true
						
						local otherCharacter = otherPlayer.Character
						local bodyPosition = Instance.new("BodyPosition")
						bodyPosition.Name = "ControlFloat"
						bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
						bodyPosition.D = 1200
						bodyPosition.P = 8000
						bodyPosition.Parent = otherHRP
						
						local bodyGyro = Instance.new("BodyGyro")
						bodyGyro.Name = "ControlGyro"
						bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
						bodyGyro.D = 1000
						bodyGyro.Parent = otherHRP
						
						-- Efectos en controlado
						local ctrlEffects = createEpicParticles(otherCharacter.Head, config.Color, 1)
						local ctrlLight = createPsychicLight(otherCharacter, config.Color)
						
						-- Trail
						local trail = Instance.new("Trail")
						local att0 = Instance.new("Attachment", otherHRP)
						local att1 = Instance.new("Attachment", otherHRP)
						att1.Position = Vector3.new(0, 3, 0)
						trail.Attachment0 = att0
						trail.Attachment1 = att1
						trail.Color = ColorSequence.new(config.Color)
						trail.Transparency = NumberSequence.new(0.4, 1)
						trail.Lifetime = 1.5
						trail.LightEmission = 1
						trail.Parent = otherHRP
						
						-- Movimiento orbital
						local angle = math.random() * math.pi * 2
						local floatConnection
						floatConnection = RunService.Heartbeat:Connect(function(dt)
							if otherCharacter and otherCharacter.Parent and bodyPosition and bodyPosition.Parent then
								angle = angle + dt * 2.5
								local height = math.sin(angle * 3) * 4 + 12
								local radius = 18 + math.cos(angle * 1.5) * 7
								bodyPosition.Position = hrp.Position + 
									Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
								bodyGyro.CFrame = CFrame.Angles(
									math.sin(angle * 2) * 0.7,
									angle * 4,
									math.cos(angle * 2) * 0.7
								)
							else
								floatConnection:Disconnect()
							end
						end)
						
						-- Limpieza individual
						task.delay(duration - (tick() - startTime), function()
							floatConnection:Disconnect()
							if bodyPosition then bodyPosition:Destroy() end
							if bodyGyro then bodyGyro:Destroy() end
							for _, effect in ipairs(ctrlEffects) do effect:Destroy() end
							if ctrlLight then ctrlLight:Destroy() end
							if trail then trail:Destroy() end
							if att0 then att0:Destroy() end
							if att1 then att1:Destroy() end
						end)
					end
				end
			end
		end
	end)
	
	-- ═══ LIMPIEZA ═══
	task.delay(duration, function()
		stopPowerSounds(sounds)
		
		for _, zoneData in ipairs(zones) do
			zoneData.Part:Destroy()
			for _, particle in ipairs(zoneData.Particles) do
				particle:Destroy()
			end
			zoneData.Light:Destroy()
		end
		
		for _, effect in ipairs(userEffects) do effect:Destroy() end
		if noseBleed then noseBleed:Destroy() end
		if userLight then userLight:Destroy() end
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- PODER 4: PROTECCIÓN IMPENETRABLE
-- ════════════════════════════════════════════════════════════════════════════

local function useProtection(player)
	local character = player.Character
	if not character or not character:FindFirstChild("Humanoid") then return end
	if not checkAndSetCooldown(player.UserId, "Protection", POWER_CONFIG.Protection.Cooldown) then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local config = POWER_CONFIG.Protection
	
	-- ═══ EFECTOS EN USUARIO ═══
	local userEffects = createEpicParticles(character.Head, config.Color, 1.8)
	local noseBleed = createNoseBleed(character)
	local userLight = createPsychicLight(character, config.Color)
	local sounds = createPowerSounds(character.Head, config)
	
	-- ═══ ESCUDO MULTICAPA ═══
	local shields = {}
	
	-- Escudo interior
	local innerShield = Instance.new("Part")
	innerShield.Shape = Enum.PartType.Ball
	innerShield.Size = Vector3.new(10, 10, 10)
	innerShield.Anchored = true
	innerShield.CanCollide = false
	innerShield.Material = Enum.Material.ForceField
	innerShield.Color = config.Color
	innerShield.Transparency = 0.2
	innerShield.Parent = workspace
	table.insert(shields, innerShield)
	
	-- Escudo medio
	local midShield = Instance.new("Part")
	midShield.Shape = Enum.PartType.Ball
	midShield.Size = Vector3.new(12, 12, 12)
	midShield.Anchored = true
	midShield.CanCollide = false
	midShield.Material = Enum.Material.Neon
	midShield.Color = config.Color
	midShield.Transparency = 0.5
	midShield.Parent = workspace
	table.insert(shields, midShield)
	
	-- Escudo exterior
	local outerShield = Instance.new("Part")
	outerShield.Shape = Enum.PartType.Ball
	outerShield.Size = Vector3.new(14, 14, 14)
	outerShield.Anchored = true
	outerShield.CanCollide = false
	outerShield.Material = Enum.Material.Glass
	outerShield.Color = config.Color
	outerShield.Transparency = 0.7
	outerShield.Parent = workspace
	table.insert(shields, outerShield)
	
	-- Luces
	local shieldLight = Instance.new("PointLight")
	shieldLight.Color = config.Color
	shieldLight.Brightness = 20
	shieldLight.Range = 50
	shieldLight.Shadows = true
	shieldLight.Parent = innerShield
	
	-- Partículas hexagonales
	local hexParticles = createEpicParticles(innerShield, config.Color, 1.5)
	
	-- ═══ ANIMACIONES ═══
	-- Rotación
	task.spawn(function()
		local angles = {0, 0, 0}
		while innerShield.Parent do
			angles[1] = angles[1] + 0.02
			angles[2] = angles[2] + 0.03
			angles[3] = angles[3] + 0.01
			
			innerShield.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(angles[1], angles[2], angles[3])
			midShield.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(-angles[2], angles[1], -angles[3])
			outerShield.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(angles[3], -angles[1], angles[2])
			
			task.wait(0.03)
		end
	end)
	
	-- Pulso
	TweenService:Create(innerShield, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Transparency = 0.05,
		Size = Vector3.new(11, 11, 11)
	}):Play()
	
	TweenService:Create(midShield, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Transparency = 0.3,
		Size = Vector3.new(13, 13, 13)
	}):Play()
	
	TweenService:Create(outerShield, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Transparency = 0.5,
		Size = Vector3.new(15, 15, 15)
	}):Play()
	
	-- ═══ INVULNERABILIDAD ═══
	local forceField = Instance.new("ForceField")
	forceField.Visible = false
	forceField.Parent = character
	
	-- Efecto de rayos defensivos al recibir daño
	local rayCount = 0
	local damageConnection
	damageConnection = character.Humanoid.HealthChanged:Connect(function(health)
		if health < character.Humanoid.MaxHealth and rayCount < 30 then
			rayCount = rayCount + 1
			
			-- Sonido de impacto
			local hitSound = Instance.new("Sound")
			hitSound.SoundId = config.HitSound
			hitSound.Volume = 0.8
			hitSound.Parent = innerShield
			hitSound:Play()
			Debris:AddItem(hitSound, 2)
			
			-- Rayo defensivo
			for i = 1, 5 do
				local ray = Instance.new("Part")
				ray.Size = Vector3.new(0.5, 0.5, math.random(8, 15))
				ray.Material = Enum.Material.Neon
				ray.Color = config.Color
				ray.Anchored = true
				ray.CanCollide = false
				ray.CFrame = CFrame.new(innerShield.Position) * 
					CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), 0) * 
					CFrame.new(0, 0, -8)
				ray.Parent = workspace
				
				TweenService:Create(ray, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 1,
					Size = Vector3.new(0.5, 0.5, ray.Size.Z * 2)
				}):Play()
				
				Debris:AddItem(ray, 0.3)
			end
			
			-- Flash del escudo
			TweenService:Create(innerShield, TweenInfo.new(0.1), {Transparency = 0}):Play()
			task.wait(0.1)
			TweenService:Create(innerShield, TweenInfo.new(0.3), {Transparency = 0.2}):Play()
		end
	end)
	
	-- ═══ LIMPIEZA ═══
	task.delay(config.Duration, function()
		damageConnection:Disconnect()
		stopPowerSounds(sounds)
		if forceField then forceField:Destroy() end
		
		-- Desvanecimiento épico
		for _, shield in ipairs(shields) do
			TweenService:Create(shield, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 1,
				Size = shield.Size * 1.5
			}):Play()
		end
		
		for _, particle in ipairs(hexParticles) do
			particle.Enabled = false
		end
		
		task.wait(2)
		for _, shield in ipairs(shields) do shield:Destroy() end
		for _, particle in ipairs(hexParticles) do particle:Destroy() end
		for _, effect in ipairs(userEffects) do effect:Destroy() end
		if noseBleed then noseBleed:Destroy() end
		if userLight then userLight:Destroy() end
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- PODER 5: CURACIÓN DIVINA
-- ════════════════════════════════════════════════════════════════════════════

local function useHealing(player, targetPlayer)
	local character = player.Character
	local targetCharacter = targetPlayer.Character
	
	if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
	if not checkAndSetCooldown(player.UserId, "Healing", POWER_CONFIG.Healing.Cooldown) then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
	if not hrp or not targetHRP then return end
	
	local distance = (hrp.Position - targetHRP.Position).Magnitude
	if distance > POWER_CONFIG.Healing.Range then return end
	
	local config = POWER_CONFIG.Healing
	
	local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
	if not targetHumanoid then return end
	
	-- Verificar si necesita curación
	if targetHumanoid.Health >= targetHumanoid.MaxHealth then return end
	
	-- ═══ EFECTOS EN SANADOR ═══
	local healerEffects = createEpicParticles(character.Head, config.Color, 1.5)
	local healerLight = createPsychicLight(character, config.Color)
	local sounds = createPowerSounds(character.Head, config)
	
	-- ═══ EFECTOS EN OBJETIVO ═══
	local targetEffects = createEpicParticles(targetCharacter.Head, config.Color, 1.8)
	local targetLight = createPsychicLight(targetCharacter, config.Color)
	
	-- ═══ RAYO DE CURACIÓN ═══
	local att0 = Instance.new("Attachment", character.Head)
	local att1 = Instance.new("Attachment", targetCharacter.Head)
	local beams = createEpicBeam(att0, att1, config.Color)
	
	-- ═══ ONDAS DE CURACIÓN ═══
	for i = 1, 5 do
		task.spawn(function()
			task.wait(i * 0.2)
			createShockwave(targetHRP.Position, config.Color, 4, 0.8)
		end)
	end
	
	-- ═══ AURA DE CURACIÓN ═══
	local healAura = Instance.new("Part")
	healAura.Shape = Enum.PartType.Ball
	healAura.Size = Vector3.new(10, 10, 10)
	healAura.Anchored = true
	healAura.CanCollide = false
	healAura.Material = Enum.Material.ForceField
	healAura.Color = config.Color
	healAura.Transparency = 0.4
	healAura.Parent = workspace
	
	-- Luz de curación
	local healLight = Instance.new("PointLight")
	healLight.Color = config.Color
	healLight.Brightness = 15
	healLight.Range = 35
	healLight.Parent = healAura
	
	-- Partículas ascendentes
	local healParticles = createEpicParticles(healAura, config.Color, 2)
	
	-- Símbolos de cruz flotantes
	for i = 1, 8 do
		task.spawn(function()
			task.wait(i * 0.1)
			
			local symbol = Instance.new("Part")
			symbol.Shape = Enum.PartType.Block
			symbol.Size = Vector3.new(1, 4, 0.3)
			symbol.Position = targetHRP.Position + Vector3.new(
				math.random(-4, 4),
				math.random(-1, 2),
				math.random(-4, 4)
			)
			symbol.Material = Enum.Material.Neon
			symbol.Color = config.Color
			symbol.Anchored = true
			symbol.CanCollide = false
			symbol.Parent = workspace
			
			local symbol2 = symbol:Clone()
			symbol2.Size = Vector3.new(4, 1, 0.3)
			symbol2.Position = symbol.Position
			symbol2.Parent = workspace
			
			-- Animación ascendente
			TweenService:Create(symbol, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Position = symbol.Position + Vector3.new(0, 10, 0),
				Transparency = 1
			}):Play()
			TweenService:Create(symbol2, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Position = symbol2.Position + Vector3.new(0, 10, 0),
				Transparency = 1
			}):Play()
			
			Debris:AddItem(symbol, 2.5)
			Debris:AddItem(symbol2, 2.5)
		end)
	end
	
	-- Seguir al objetivo
	local auraConnection
	auraConnection = RunService.Heartbeat:Connect(function()
		if targetHRP and targetHRP.Parent then
			healAura.CFrame = targetHRP.CFrame
		else
			auraConnection:Disconnect()
		end
	end)
	
	-- ═══ CURACIÓN PROGRESIVA ═══
	local healDuration = config.Duration
	local healPerTick = config.HealAmount / (healDuration * 20)
	local healTime = 0
	
	local healConnection
	healConnection = RunService.Heartbeat:Connect(function(dt)
		healTime = healTime + dt
		
		if healTime >= healDuration or targetHumanoid.Health >= targetHumanoid.MaxHealth then
			healConnection:Disconnect()
			return
		end
		
		targetHumanoid.Health = math.min(targetHumanoid.Health + healPerTick, targetHumanoid.MaxHealth)
	end)
	
	-- ═══ NÚMEROS DE CURACIÓN ═══
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 150, 0, 60)
	billboardGui.StudsOffset = Vector3.new(0, 4, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = targetHRP
	
	local healText = Instance.new("TextLabel")
	healText.Size = UDim2.new(1, 0, 1, 0)
	healText.BackgroundTransparency = 1
	healText.Text = "+ " .. tostring(config.HealAmount) .. " ❤️"
	healText.Font = Enum.Font.SourceSansBold
	healText.TextSize = 36
	healText.TextColor3 = config.Color
	healText.TextStrokeTransparency = 0
	healText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	healText.Parent = billboardGui
	
	-- Animación del texto
	TweenService:Create(billboardGui, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		StudsOffset = Vector3.new(0, 8, 0)
	}):Play()
	TweenService:Create(healText, TweenInfo.new(2.5), {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	}):Play()
	
	Debris:AddItem(billboardGui, 2.5)
	
	-- ═══ LIMPIEZA ═══
	task.delay(healDuration, function()
		auraConnection:Disconnect()
		stopPowerSounds(sounds)
		
		-- Sonido de completado
		local completeSound = Instance.new("Sound")
		completeSound.SoundId = config.CompleteSound
		completeSound.Volume = 1
		completeSound.Parent = healAura
		completeSound:Play()
		
		-- Desvanecimiento
		TweenService:Create(healAura, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 1,
			Size = Vector3.new(20, 20, 20)
		}):Play()
		
		for _, particle in ipairs(healParticles) do
			particle.Enabled = false
		end
		
		task.wait(1.5)
		healAura:Destroy()
		for _, particle in ipairs(healParticles) do particle:Destroy() end
		for _, effect in ipairs(healerEffects) do effect:Destroy() end
		for _, effect in ipairs(targetEffects) do effect:Destroy() end
		for _, beam in ipairs(beams) do beam:Destroy() end
		if healerLight then healerLight:Destroy() end
		if targetLight then targetLight:Destroy() end
		if att0 then att0:Destroy() end
		if att1 then att1:Destroy() end
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- CONECTAR EVENTOS
-- ════════════════════════════════════════════════════════════════════════════

telekinesisPower.OnServerEvent:Connect(function(player, targetPlayer)
	if targetPlayer and targetPlayer:IsA("Player") then
		useTelekinesis(player, targetPlayer)
	end
end)

explosionPower.OnServerEvent:Connect(function(player, targetPlayer)
	if targetPlayer and targetPlayer:IsA("Player") then
		useExplosion(player, targetPlayer)
	end
end)

controlPower.OnServerEvent:Connect(function(player)
	useControl(player)
end)

protectionPower.OnServerEvent:Connect(function(player)
	useProtection(player)
end)

healingPower.OnServerEvent:Connect(function(player, targetPlayer)
	if targetPlayer and targetPlayer:IsA("Player") then
		useHealing(player, targetPlayer)
	end
end)

-- ════════════════════════════════════════════════════════════════════════════
print("✨ ═══════════════════════════════════════════════════════════════ ✨")
print("✨   STRANGER THINGS EPIC POWERS SYSTEM - CARGADO CON ÉXITO      ✨")
print("✨ ═══════════════════════════════════════════════════════════════ ✨")
print("⚡ Telekinesis (Q) | 💥 Explosión (E) | 🌀 Control (R)")
print("🛡️ Protección (T) | 💚 Curación (F)")
print("✨ Efectos visuales épicos mejorados al máximo nivel profesional ✨")
print("✨ ═══════════════════════════════════════════════════════════════ ✨")
