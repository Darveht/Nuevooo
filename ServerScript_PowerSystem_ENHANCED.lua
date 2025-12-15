-- ====================================================================
-- STRANGER THINGS EPIC POWERS SYSTEM - ENHANCED EDITION
-- Script del Servidor - Efectos Visuales Profesionales
-- Coloca este script en ServerScriptService
-- ====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

-- Crear RemoteEvents
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

-- Configuración
local POWER_CONFIG = {
	Telekinesis = {
		Cooldown = 15,
		Duration = 8,
		Range = 50,
		Color = Color3.fromRGB(138, 43, 226),
		ActivationSound = "rbxassetid://6936421966",
		LoopSound = "rbxassetid://9125516670"
	},
	Explosion = {
		Cooldown = 20,
		Range = 60,
		Force = 5000,
		Color = Color3.fromRGB(195, 0, 0),
		ActivationSound = "rbxassetid://2621689551",
		LoopSound = "rbxassetid://9125516670"
	},
	Control = {
		Cooldown = 25,
		Duration = 10,
		Range = 45,
		Color = Color3.fromRGB(255, 69, 0),
		ActivationSound = "rbxassetid://5153438710",
		LoopSound = "rbxassetid://9125516670"
	},
	Protection = {
		Cooldown = 60,
		Duration = 30,
		Color = Color3.fromRGB(255, 10, 10),
		ActivationSound = "rbxassetid://814168787",
		LoopSound = "rbxassetid://9125516670"
	},
	Healing = {
		Cooldown = 18,
		Range = 40,
		HealAmount = 50,
		Color = Color3.fromRGB(0, 255, 127),
		ActivationSound = "rbxassetid://5153438710",
		LoopSound = "rbxassetid://9125516670"
	}
}

local playerCooldowns = {}

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

-- ====================================================================
-- SISTEMA DE SONIDO MEJORADO
-- ====================================================================

local function createPowerSounds(parent, config)
	local activationSound = Instance.new("Sound")
	activationSound.Name = "ActivationSound"
	activationSound.SoundId = config.ActivationSound
	activationSound.Volume = 1.5
	activationSound.RollOffMaxDistance = 200
	activationSound.RollOffMinDistance = 10
	activationSound.Parent = parent
	activationSound:Play()
	
	local loopSound = Instance.new("Sound")
	loopSound.Name = "LoopSound"
	loopSound.SoundId = config.LoopSound
	loopSound.Volume = 1
	loopSound.Looped = true
	loopSound.RollOffMaxDistance = 150
	loopSound.RollOffMinDistance = 10
	loopSound.Parent = parent
	
	task.delay(0.3, function()
		if loopSound and loopSound.Parent then
			loopSound:Play()
		end
	end)
	
	return activationSound, loopSound
end

-- ====================================================================
-- SISTEMA DE PARTÍCULAS PROFESIONAL - MEJORADO
-- ====================================================================

local function createEnhancedParticleLayer(parent, config)
	local particle = Instance.new("ParticleEmitter")
	particle.Parent = parent
	
	-- Configuración base
	particle.Texture = config.Texture or "rbxassetid://6101261905"
	particle.Color = config.Color or ColorSequence.new(Color3.new(1, 1, 1))
	particle.Size = config.Size or NumberSequence.new(1)
	particle.Transparency = config.Transparency or NumberSequence.new(0, 1)
	particle.Lifetime = config.Lifetime or NumberRange.new(1, 2)
	particle.Rate = config.Rate or 50
	particle.Speed = config.Speed or NumberRange.new(5, 10)
	particle.SpreadAngle = config.SpreadAngle or Vector2.new(180, 180)
	particle.Rotation = config.Rotation or NumberRange.new(0, 360)
	particle.RotSpeed = config.RotSpeed or NumberRange.new(-100, 100)
	particle.Acceleration = config.Acceleration or Vector3.new(0, 0, 0)
	particle.Drag = config.Drag or 0
	particle.VelocityInheritance = config.VelocityInheritance or 0
	particle.EmissionDirection = config.EmissionDirection or Enum.NormalId.Top
	particle.Enabled = true
	
	-- Propiedades avanzadas
	particle.LightEmission = config.LightEmission or 1
	particle.LightInfluence = config.LightInfluence or 0
	particle.ZOffset = config.ZOffset or 0
	particle.LockedToPart = config.LockedToPart or false
	
	return particle
end

local function createTelekinesisParticles(parent, color)
	local effects = {}
	
	-- Capa 1: Energía central brillante con brillo pulsante
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.3, color),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(color.R * 50, color.G * 50, color.B * 50))
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.2, 3),
			NumberSequenceKeypoint.new(0.5, 2.5),
			NumberSequenceKeypoint.new(1, 0)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.3),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(1.5, 2.5),
		Rate = 120,
		Speed = NumberRange.new(10, 18),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 1,
		ZOffset = 0.5
	}))
	
	-- Capa 2: Partículas energéticas rápidas
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new(color),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(0.5, 1.5),
			NumberSequenceKeypoint.new(1, 0.2)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.7, 0.3),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(0.8, 1.5),
		Rate = 80,
		Speed = NumberRange.new(15, 25),
		SpreadAngle = Vector2.new(180, 180),
		Drag = 3,
		LightEmission = 1
	}))
	
	-- Capa 3: Humo etéreo con movimiento lento
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxasset://textures/particles/smoke_main.dds",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, color),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(color.R * 100, color.G * 100, color.B * 100))
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 2),
			NumberSequenceKeypoint.new(0.5, 4),
			NumberSequenceKeypoint.new(1, 6)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.7),
			NumberSequenceKeypoint.new(0.5, 0.8),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(2, 3.5),
		Rate = 50,
		Speed = NumberRange.new(3, 8),
		SpreadAngle = Vector2.new(180, 180),
		Drag = 5,
		LightEmission = 0.5,
		RotSpeed = NumberRange.new(-50, 50)
	}))
	
	-- Capa 4: Chispas eléctricas dinámicas
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, color),
			ColorSequenceKeypoint.new(1, color)
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.8),
			NumberSequenceKeypoint.new(0.3, 0.4),
			NumberSequenceKeypoint.new(1, 0)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.8, 0.5),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(0.3, 0.9),
		Rate = 100,
		Speed = NumberRange.new(20, 35),
		SpreadAngle = Vector2.new(180, 180),
		Drag = 8,
		LightEmission = 1
	}))
	
	-- Capa 5: Anillos de energía pulsantes
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new(color),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.1, 4),
			NumberSequenceKeypoint.new(1, 5)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(0.5, 0.6),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(1.2, 1.8),
		Rate = 30,
		Speed = NumberRange.new(0, 2),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 0.8,
		LockedToPart = true
	}))
	
	return effects
end

local function createExplosionParticles(parent, color)
	local effects = {}
	
	-- Capa 1: Núcleo de energía explosiva
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.4, color),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(color.R * 30, color.G * 30, color.B * 30))
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.1, 5),
			NumberSequenceKeypoint.new(0.3, 4),
			NumberSequenceKeypoint.new(1, 0)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.5, 0.3),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(1.5, 2.5),
		Rate = 150,
		Speed = NumberRange.new(15, 30),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 1,
		Drag = 5
	}))
	
	-- Capa 2: Fragmentos ardientes
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 100)),
			ColorSequenceKeypoint.new(0.5, color),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.5),
			NumberSequenceKeypoint.new(0.5, 1),
			NumberSequenceKeypoint.new(1, 0.3)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.7, 0.5),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(1, 2),
		Rate = 100,
		Speed = NumberRange.new(25, 45),
		SpreadAngle = Vector2.new(180, 180),
		Acceleration = Vector3.new(0, -20, 0),
		Drag = 3,
		LightEmission = 0.8
	}))
	
	-- Capa 3: Humo denso post-explosión
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxasset://textures/particles/smoke_main.dds",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 100)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 50)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 3),
			NumberSequenceKeypoint.new(0.5, 8),
			NumberSequenceKeypoint.new(1, 12)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(0.5, 0.7),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(3, 5),
		Rate = 60,
		Speed = NumberRange.new(10, 20),
		SpreadAngle = Vector2.new(180, 180),
		Drag = 8,
		LightEmission = 0,
		RotSpeed = NumberRange.new(-30, 30)
	}))
	
	-- Capa 4: Ondas de choque visuales
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new(color),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.05, 8),
			NumberSequenceKeypoint.new(1, 10)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.3),
			NumberSequenceKeypoint.new(0.3, 0.7),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(0.8, 1.2),
		Rate = 40,
		Speed = NumberRange.new(0, 5),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 0.9,
		LockedToPart = true
	}))
	
	return effects
end

local function createHealingParticles(parent, color)
	local effects = {}
	
	-- Capa 1: Luz divina ascendente
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, color),
			ColorSequenceKeypoint.new(1, color)
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(0.5, 2),
			NumberSequenceKeypoint.new(1, 3)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(0.7, 0.5),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(2, 3.5),
		Rate = 80,
		Speed = NumberRange.new(8, 15),
		SpreadAngle = Vector2.new(30, 30),
		EmissionDirection = Enum.NormalId.Top,
		LightEmission = 1,
		Drag = 2
	}))
	
	-- Capa 2: Partículas brillantes suaves
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new(color),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 1.5),
			NumberSequenceKeypoint.new(1, 0.5)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.5, 0.3),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(1.5, 2.5),
		Rate = 60,
		Speed = NumberRange.new(5, 12),
		SpreadAngle = Vector2.new(40, 40),
		EmissionDirection = Enum.NormalId.Top,
		LightEmission = 0.9,
		Drag = 4,
		RotSpeed = NumberRange.new(-100, 100)
	}))
	
	-- Capa 3: Niebla curativa etérea
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxasset://textures/particles/smoke_main.dds",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, color),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(color.R * 150, color.G * 150, color.B * 150))
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.5),
			NumberSequenceKeypoint.new(0.5, 3),
			NumberSequenceKeypoint.new(1, 4.5)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.6),
			NumberSequenceKeypoint.new(0.5, 0.75),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(2.5, 4),
		Rate = 40,
		Speed = NumberRange.new(2, 6),
		SpreadAngle = Vector2.new(50, 50),
		EmissionDirection = Enum.NormalId.Top,
		LightEmission = 0.6,
		Drag = 6,
		RotSpeed = NumberRange.new(-40, 40)
	}))
	
	-- Capa 4: Destellos de energía curativa
	table.insert(effects, createEnhancedParticleLayer(parent, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, color)
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.3),
			NumberSequenceKeypoint.new(0.5, 0.6),
			NumberSequenceKeypoint.new(1, 0)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(0.5, 1.2),
		Rate = 90,
		Speed = NumberRange.new(10, 18),
		SpreadAngle = Vector2.new(60, 60),
		EmissionDirection = Enum.NormalId.Top,
		LightEmission = 1,
		Drag = 5
	}))
	
	return effects
end

-- ====================================================================
-- SISTEMA DE BEAMS MEJORADO
-- ====================================================================

local function createAdvancedBeam(attachment0, attachment1, color, beamType)
	local effects = {}
	
	-- Beam principal con textura animada
	local mainBeam = Instance.new("Beam")
	mainBeam.Name = "MainBeam"
	mainBeam.Attachment0 = attachment0
	mainBeam.Attachment1 = attachment1
	mainBeam.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.5, color),
		ColorSequenceKeypoint.new(1, color)
	})
	mainBeam.Width0 = 2.5
	mainBeam.Width1 = 2.5
	mainBeam.Transparency = NumberSequence.new({
		ColorSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(1, 0.2)
	})
	mainBeam.FaceCamera = true
	mainBeam.LightEmission = 1
	mainBeam.LightInfluence = 0
	mainBeam.Texture = "rbxassetid://6101261905"
	mainBeam.TextureMode = Enum.TextureMode.Wrap
	mainBeam.TextureSpeed = 4
	mainBeam.TextureLength = 2
	mainBeam.CurveSize0 = 0
	mainBeam.CurveSize1 = 0
	mainBeam.Parent = attachment0.Parent
	table.insert(effects, mainBeam)
	
	-- Beam secundario exterior
	local outerBeam = Instance.new("Beam")
	outerBeam.Name = "OuterBeam"
	outerBeam.Attachment0 = attachment0
	outerBeam.Attachment1 = attachment1
	outerBeam.Color = ColorSequence.new(color)
	outerBeam.Width0 = 4
	outerBeam.Width1 = 4
	outerBeam.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.6),
		NumberSequenceKeypoint.new(0.5, 0.4),
		NumberSequenceKeypoint.new(1, 0.6)
	})
	outerBeam.FaceCamera = true
	outerBeam.LightEmission = 0.7
	outerBeam.Texture = "rbxasset://textures/particles/smoke_main.dds"
	outerBeam.TextureMode = Enum.TextureMode.Wrap
	outerBeam.TextureSpeed = -2
	outerBeam.TextureLength = 3
	outerBeam.Parent = attachment0.Parent
	table.insert(effects, outerBeam)
	
	-- Beam pulsante interior
	local pulseBeam = Instance.new("Beam")
	pulseBeam.Name = "PulseBeam"
	pulseBeam.Attachment0 = attachment0
	pulseBeam.Attachment1 = attachment1
	pulseBeam.Color = ColorSequence.new(Color3.new(1, 1, 1))
	pulseBeam.Width0 = 1
	pulseBeam.Width1 = 1
	pulseBeam.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(0.5, 0.3),
		NumberSequenceKeypoint.new(1, 0.5)
	})
	pulseBeam.FaceCamera = true
	pulseBeam.LightEmission = 1
	pulseBeam.Texture = "rbxassetid://6101261905"
	pulseBeam.TextureMode = Enum.TextureMode.Wrap
	pulseBeam.TextureSpeed = 6
	pulseBeam.TextureLength = 1
	pulseBeam.Parent = attachment0.Parent
	table.insert(effects, pulseBeam)
	
	-- Animación de pulso en los beams
	task.spawn(function()
		while pulseBeam.Parent do
			TweenService:Create(pulseBeam, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Width0 = 1.5,
				Width1 = 1.5
			}):Play()
			task.wait(0.5)
			TweenService:Create(pulseBeam, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Width0 = 1,
				Width1 = 1
			}):Play()
			task.wait(0.5)
		end
	end)
	
	return effects
end

-- ====================================================================
-- EFECTOS ADICIONALES MEJORADOS
-- ====================================================================

local function createNoseBleed(character)
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	-- Partículas de sangre más realistas
	local blood = Instance.new("ParticleEmitter")
	blood.Name = "NoseBleed"
	blood.Parent = head
	blood.Texture = "rbxasset://textures/particles/smoke_main.dds"
	blood.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 0))
	})
	blood.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.15),
		NumberSequenceKeypoint.new(0.5, 0.4),
		NumberSequenceKeypoint.new(1, 0.6)
	})
	blood.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.7, 0.3),
		NumberSequenceKeypoint.new(1, 1)
	})
	blood.Lifetime = NumberRange.new(1.5, 2.5)
	blood.Rate = 20
	blood.Speed = NumberRange.new(2, 6)
	blood.SpreadAngle = Vector2.new(15, 15)
	blood.EmissionDirection = Enum.NormalId.Bottom
	blood.Acceleration = Vector3.new(0, -15, 0)
	blood.Drag = 3
	blood.Enabled = true
	blood.LightEmission = 0
	
	return blood
end

local function createAdvancedLight(character, color, intensity)
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	-- Luz principal más intensa
	local light = Instance.new("PointLight")
	light.Name = "PowerLight"
	light.Parent = head
	light.Color = color
	light.Brightness = intensity or 8
	light.Range = 30
	light.Shadows = true
	
	-- Animación de pulso avanzada
	task.spawn(function()
		local time = 0
		while light and light.Parent do
			time = time + 0.05
			local pulse = math.sin(time * 5) * 0.5 + 0.5
			light.Brightness = (intensity or 8) + pulse * 4
			light.Range = 30 + pulse * 10
			task.wait(0.05)
		end
	end)
	
	return light
end

local function createDistortionSphere(position, color, maxSize, duration)
	local sphere = Instance.new("Part")
	sphere.Shape = Enum.PartType.Ball
	sphere.Size = Vector3.new(1, 1, 1)
	sphere.Position = position
	sphere.Anchored = true
	sphere.CanCollide = false
	sphere.Material = Enum.Material.ForceField
	sphere.Color = color
	sphere.Transparency = 0.7
	sphere.Parent = workspace
	
	-- Luz de la esfera
	local light = Instance.new("PointLight")
	light.Color = color
	light.Brightness = 10
	light.Range = maxSize
	light.Parent = sphere
	
	-- Animación de expansión con distorsión
	local expandTween = TweenService:Create(sphere, 
		TweenInfo.new(duration * 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
		{
			Size = Vector3.new(maxSize, maxSize, maxSize),
			Transparency = 0.3
		}
	)
	expandTween:Play()
	
	-- Pulso secundario
	task.delay(duration * 0.3, function()
		TweenService:Create(sphere, 
			TweenInfo.new(duration * 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
			{
				Transparency = 0.1,
				Size = Vector3.new(maxSize * 1.1, maxSize * 1.1, maxSize * 1.1)
			}
		):Play()
	end)
	
	-- Desvanecimiento final
	task.delay(duration * 0.7, function()
		TweenService:Create(sphere, 
			TweenInfo.new(duration * 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
			{
				Size = Vector3.new(maxSize * 1.5, maxSize * 1.5, maxSize * 1.5),
				Transparency = 1
			}
		):Play()
		
		TweenService:Create(light, 
			TweenInfo.new(duration * 0.3), 
			{Brightness = 0}
		):Play()
	end)
	
	Debris:AddItem(sphere, duration)
	return sphere
end

local function createShockwaveRing(position, color, maxSize, duration)
	local ring = Instance.new("Part")
	ring.Shape = Enum.PartType.Cylinder
	ring.Size = Vector3.new(0.5, 1, 1)
	ring.Material = Enum.Material.Neon
	ring.Color = color
	ring.Anchored = true
	ring.CanCollide = false
	ring.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	ring.Transparency = 0.2
	ring.Parent = workspace
	
	TweenService:Create(ring, 
		TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
		{
			Size = Vector3.new(0.5, maxSize, maxSize),
			Transparency = 1
		}
	):Play()
	
	Debris:AddItem(ring, duration)
	return ring
end

-- ====================================================================
-- PODER 1: TELEKINESIS ÉPICA MEJORADA
-- ====================================================================

local function useTelekinesis(player, targetPlayer)
	local character = player.Character
	local targetCharacter = targetPlayer.Character
	
	if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
	if not checkAndSetCooldown(player.UserId, "Telekinesis", POWER_CONFIG.Telekinesis.Cooldown) then return end
	
	local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
	if distance > POWER_CONFIG.Telekinesis.Range then return end
	
	local config = POWER_CONFIG.Telekinesis
	
	-- Efectos mejorados en usuario
	local userEffects = createTelekinesisParticles(character.Head, config.Color)
	local noseBleed = createNoseBleed(character)
	local userLight = createAdvancedLight(character, config.Color, 10)
	
	-- Efectos mejorados en objetivo
	local targetEffects = createTelekinesisParticles(targetCharacter.Head, config.Color)
	local targetLight = createAdvancedLight(targetCharacter, config.Color, 8)
	
	-- Beams de conexión mejorados
	local att0 = Instance.new("Attachment", character.Head)
	local att1 = Instance.new("Attachment", targetCharacter.Head)
	local beams = createAdvancedBeam(att0, att1, config.Color, "telekinesis")
	
	-- Sonidos
	local activationSound, loopSound = createPowerSounds(character.Head, config)
	
	-- Múltiples ondas de choque al inicio
	for i = 1, 4 do
		task.delay(i * 0.15, function()
			createShockwaveRing(character.HumanoidRootPart.Position, config.Color, 35 + i * 5, 0.8)
		end)
	end
	
	-- Esfera de distorsión alrededor del objetivo
	createDistortionSphere(targetCharacter.HumanoidRootPart.Position, config.Color, 12, config.Duration)
	
	-- Lógica de control mejorada
	local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
	if targetHumanoid then
		targetHumanoid.WalkSpeed = 0
		targetHumanoid.JumpPower = 0
		
		local bodyPosition = Instance.new("BodyPosition")
		bodyPosition.Name = "TelekinesisFloat"
		bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
		bodyPosition.Position = targetCharacter.HumanoidRootPart.Position + Vector3.new(0, 8, 0)
		bodyPosition.D = 1500
		bodyPosition.P = 10000
		bodyPosition.Parent = targetCharacter.HumanoidRootPart
		
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
		bodyGyro.D = 1500
		bodyGyro.P = 10000
		bodyGyro.Parent = targetCharacter.HumanoidRootPart
		
		-- Rotación más suave y dramática
		task.spawn(function()
			local time = 0
			while time < config.Duration and bodyGyro.Parent do
				time = time + 0.03
				local rotX = math.sin(time * 2) * 0.8
				local rotY = time * 2.5
				local rotZ = math.cos(time * 2) * 0.8
				bodyGyro.CFrame = CFrame.Angles(rotX, rotY, rotZ)
				
				-- Movimiento oscilante en altura
				local heightOffset = math.sin(time * 3) * 2
				bodyPosition.Position = targetCharacter.HumanoidRootPart.Position + Vector3.new(0, 8 + heightOffset, 0)
				
				task.wait(0.03)
			end
		end)
		
		-- Trail de energía
		local trail = Instance.new("Trail")
		local trailAtt0 = Instance.new("Attachment", targetCharacter.HumanoidRootPart)
		local trailAtt1 = Instance.new("Attachment", targetCharacter.HumanoidRootPart)
		trailAtt1.Position = Vector3.new(0, 3, 0)
		trail.Attachment0 = trailAtt0
		trail.Attachment1 = trailAtt1
		trail.Color = ColorSequence.new(config.Color)
		trail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.3),
			NumberSequenceKeypoint.new(1, 1)
		})
		trail.Lifetime = 1.5
		trail.LightEmission = 1
		trail.Parent = targetCharacter.HumanoidRootPart
		
		task.wait(config.Duration)
		
		targetHumanoid.WalkSpeed = 16
		targetHumanoid.JumpPower = 50
		if bodyPosition then bodyPosition:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
		if trail then trail:Destroy() end
		if trailAtt0 then trailAtt0:Destroy() end
		if trailAtt1 then trailAtt1:Destroy() end
	end
	
	-- Detener sonidos
	if loopSound then loopSound:Stop() task.delay(0.5, function() if loopSound then loopSound:Destroy() end end) end
	
	-- Limpieza
	task.wait(1)
	for _, effect in ipairs(userEffects) do if effect then effect:Destroy() end end
	for _, effect in ipairs(targetEffects) do if effect then effect:Destroy() end end
	for _, beam in ipairs(beams) do if beam then beam:Destroy() end end
	if noseBleed then noseBleed:Destroy() end
	if userLight then userLight:Destroy() end
	if targetLight then targetLight:Destroy() end
	if att0 then att0:Destroy() end
	if att1 then att1:Destroy() end
end

-- ====================================================================
-- PODER 2: EXPLOSIÓN PSÍQUICA DEVASTADORA MEJORADA
-- ====================================================================

local function useExplosion(player, targetPlayer)
	local character = player.Character
	local targetCharacter = targetPlayer.Character
	
	if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
	if not checkAndSetCooldown(player.UserId, "Explosion", POWER_CONFIG.Explosion.Cooldown) then return end
	
	local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
	if distance > POWER_CONFIG.Explosion.Range then return end
	
	local config = POWER_CONFIG.Explosion
	
	-- Efectos en usuario
	local userEffects = createExplosionParticles(character.Head, config.Color)
	local noseBleed = createNoseBleed(character)
	local userLight = createAdvancedLight(character, config.Color, 12)
	
	-- Sonidos
	local activationSound, loopSound = createPowerSounds(character.Head, config)
	
	-- Esfera de carga más elaborada
	local chargeSphere = Instance.new("Part")
	chargeSphere.Shape = Enum.PartType.Ball
	chargeSphere.Size = Vector3.new(2, 2, 2)
	chargeSphere.Position = targetCharacter.HumanoidRootPart.Position
	chargeSphere.Anchored = true
	chargeSphere.CanCollide = false
	chargeSphere.Material = Enum.Material.Neon
	chargeSphere.Color = config.Color
	chargeSphere.Transparency = 0.3
	chargeSphere.Parent = workspace
	
	-- Luz pulsante intensa
	local chargeLight = Instance.new("PointLight")
	chargeLight.Color = config.Color
	chargeLight.Brightness = 15
	chargeLight.Range = 40
	chargeLight.Shadows = true
	chargeLight.Parent = chargeSphere
	
	-- Partículas de carga convergentes
	local chargeParticles = createEnhancedParticleLayer(chargeSphere, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, config.Color)
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 2),
			NumberSequenceKeypoint.new(1, 0)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 0.5)
		}),
		Lifetime = NumberRange.new(0.8, 1.2),
		Rate = 150,
		Speed = NumberRange.new(-30, -10),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 1
	})
	
	-- Anillos de energía pulsantes durante la carga
	local rings = {}
	for i = 1, 5 do
		task.delay(i * 0.25, function()
			local ring = Instance.new("Part")
			ring.Shape = Enum.PartType.Cylinder
			ring.Size = Vector3.new(0.3, 1, 1)
			ring.Position = chargeSphere.Position
			ring.Rotation = Vector3.new(0, 0, 90)
			ring.Anchored = true
			ring.CanCollide = false
			ring.Material = Enum.Material.Neon
			ring.Color = config.Color
			ring.Transparency = 0.2
			ring.Parent = workspace
			
			TweenService:Create(ring, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = Vector3.new(0.3, 25, 25),
				Transparency = 1
			}):Play()
			
			Debris:AddItem(ring, 0.5)
			table.insert(rings, ring)
		end)
	end
	
	-- Carga dramática con expansión
	TweenService:Create(chargeSphere, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = Vector3.new(10, 10, 10),
		Transparency = 0
	}):Play()
	
	-- Pulso de luz
	task.spawn(function()
		local time = 0
		while time < 1.5 do
			time = time + 0.05
			local pulse = math.sin(time * 20) * 0.5 + 0.5
			chargeLight.Brightness = 15 + pulse * 10
			chargeLight.Range = 40 + pulse * 15
			task.wait(0.05)
		end
	end)
	
	task.wait(1.5)
	
	chargeParticles.Enabled = false
	
	-- ¡EXPLOSIÓN ÉPICA!
	local explosionSound = Instance.new("Sound")
	explosionSound.SoundId = "rbxassetid://9114397505"
	explosionSound.Volume = 2
	explosionSound.RollOffMaxDistance = 300
	explosionSound.Parent = chargeSphere
	explosionSound:Play()
	
	-- Flash cegador
	local flash = Instance.new("Part")
	flash.Shape = Enum.PartType.Ball
	flash.Size = Vector3.new(50, 50, 50)
	flash.Position = chargeSphere.Position
	flash.Anchored = true
	flash.CanCollide = false
	flash.Material = Enum.Material.Neon
	flash.Color = Color3.new(1, 1, 1)
	flash.Transparency = 0
	flash.Parent = workspace
	
	local flashLight = Instance.new("PointLight")
	flashLight.Color = Color3.new(1, 1, 1)
	flashLight.Brightness = 50
	flashLight.Range = 100
	flashLight.Parent = flash
	
	TweenService:Create(flash, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(80, 80, 80)
	}):Play()
	Debris:AddItem(flash, 0.2)
	
	-- Múltiples ondas de choque superpuestas
	for i = 1, 8 do
		task.spawn(function()
			task.wait(i * 0.08)
			local wave = Instance.new("Part")
			wave.Shape = Enum.PartType.Ball
			wave.Size = Vector3.new(2, 2, 2)
			wave.Position = chargeSphere.Position
			wave.Anchored = true
			wave.CanCollide = false
			wave.Material = Enum.Material.Neon
			wave.Color = i % 2 == 0 and config.Color or Color3.new(1, 1, 1)
			wave.Transparency = 0.2 + (i * 0.05)
			wave.Parent = workspace
			
			TweenService:Create(wave, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = Vector3.new(50 + i * 5, 50 + i * 5, 50 + i * 5),
				Transparency = 1
			}):Play()
			Debris:AddItem(wave, 1)
		end)
	end
	
	-- Anillos expansivos horizontales
	for i = 1, 6 do
		task.delay(i * 0.1, function()
			createShockwaveRing(chargeSphere.Position, config.Color, 60, 1.2)
		end)
	end
	
	-- Explosión real
	local explosion = Instance.new("Explosion")
	explosion.Position = targetCharacter.HumanoidRootPart.Position
	explosion.BlastPressure = config.Force
	explosion.BlastRadius = 25
	explosion.ExplosionType = Enum.ExplosionType.Craters
	explosion.Parent = workspace
	
	-- Partículas de explosión prolongadas
	local explosionParticles = createExplosionParticles(chargeSphere, config.Color)
	task.delay(3, function()
		for _, particle in ipairs(explosionParticles) do
			if particle then particle.Enabled = false end
		end
		task.wait(2)
		for _, particle in ipairs(explosionParticles) do
			if particle then particle:Destroy() end
		end
	end)
	
	-- Daño
	local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
	if targetHumanoid then
		targetHumanoid:TakeDamage(50)
	end
	
	-- Detener sonidos
	if loopSound then loopSound:Stop() task.delay(0.5, function() if loopSound then loopSound:Destroy() end end) end
	
	-- Limpieza
	task.wait(2)
	for _, effect in ipairs(userEffects) do if effect then effect:Destroy() end end
	if noseBleed then noseBleed:Destroy() end
	if userLight then userLight:Destroy() end
	if chargeSphere then chargeSphere:Destroy() end
end

-- ====================================================================
-- PODER 3: CONTROL MENTAL MASIVO MEJORADO
-- ====================================================================

local function useControl(player)
	local character = player.Character
	if not character then return end
	if not checkAndSetCooldown(player.UserId, "Control", POWER_CONFIG.Control.Cooldown) then return end
	
	local config = POWER_CONFIG.Control
	
	-- Efectos en usuario
	local userEffects = createTelekinesisParticles(character.Head, config.Color)
	local noseBleed = createNoseBleed(character)
	local userLight = createAdvancedLight(character, config.Color, 15)
	
	-- Sonidos
	local activationSound, loopSound = createPowerSounds(character.Head, config)
	
	-- Zona de control épica con múltiples capas rotatorias
	local layers = {}
	for i = 1, 4 do
		local zone = Instance.new("Part")
		zone.Shape = Enum.PartType.Cylinder
		zone.Size = Vector3.new(1.5, config.Range * 2 * (1 + i * 0.15), config.Range * 2 * (1 + i * 0.15))
		zone.Position = character.HumanoidRootPart.Position
		zone.Rotation = Vector3.new(0, 0, 90)
		zone.Anchored = true
		zone.CanCollide = false
		zone.Material = Enum.Material.ForceField
		zone.Color = config.Color
		zone.Transparency = 0.4 + (i * 0.08)
		zone.Parent = workspace
		
		-- Luz por capa
		local zoneLight = Instance.new("PointLight")
		zoneLight.Color = config.Color
		zoneLight.Brightness = 8 - i
		zoneLight.Range = config.Range * (1 + i * 0.2)
		zoneLight.Parent = zone
		
		-- Partículas orbitales
		local orbitalParticles = createEnhancedParticleLayer(zone, {
			Texture = "rbxassetid://6101261905",
			Color = ColorSequence.new(config.Color),
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1.5),
				NumberSequenceKeypoint.new(1, 0.5)
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.3),
				NumberSequenceKeypoint.new(1, 1)
			}),
			Lifetime = NumberRange.new(2, 3),
			Rate = 40,
			Speed = NumberRange.new(10, 15),
			SpreadAngle = Vector2.new(10, 10),
			LightEmission = 0.9,
			LockedToPart = false
		})
		
		-- Animación de rotación diferenciada
		local rotationSpeed = 2 * i
		local direction = i % 2 == 0 and 1 or -1
		task.spawn(function()
			while zone.Parent do
				zone.Rotation = zone.Rotation + Vector3.new(0, rotationSpeed * direction, 0)
				task.wait(0.03)
			end
		end)
		
		-- Pulso de escala
		TweenService:Create(zone, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Transparency = 0.2 + (i * 0.08),
			Size = Vector3.new(1.5, zone.Size.Y * 1.1, zone.Size.Z * 1.1)
		}):Play()
		
		table.insert(layers, zone)
	end
	
	-- Líneas de energía conectando al usuario con la zona
	local energyLines = {}
	for i = 1, 8 do
		local angle = (i / 8) * math.pi * 2
		local att0 = Instance.new("Attachment", character.HumanoidRootPart)
		local att1 = Instance.new("Attachment")
		att1.Parent = workspace.Terrain
		att1.WorldPosition = character.HumanoidRootPart.Position + Vector3.new(
			math.cos(angle) * config.Range,
			0,
			math.sin(angle) * config.Range
		)
		
		local beam = createAdvancedBeam(att0, att1, config.Color, "control")
		for _, b in ipairs(beam) do
			table.insert(energyLines, b)
		end
		table.insert(energyLines, att0)
		table.insert(energyLines, att1)
	end
	
	-- Lógica de control
	local controlledPlayers = {}
	local duration = config.Duration
	local startTime = tick()
	
	local controlLoop
	controlLoop = RunService.Heartbeat:Connect(function()
		if tick() - startTime > duration then
			controlLoop:Disconnect()
			return
		end
		
		for _, otherPlayer in pairs(Players:GetPlayers()) do
			if otherPlayer ~= player then
				local otherCharacter = otherPlayer.Character
				if otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart") then
					local dist = (character.HumanoidRootPart.Position - otherCharacter.HumanoidRootPart.Position).Magnitude
					
					if dist <= config.Range then
						if not controlledPlayers[otherPlayer.UserId] then
							controlledPlayers[otherPlayer.UserId] = true
							
							local bodyPosition = Instance.new("BodyPosition")
							bodyPosition.Name = "ControlFloat"
							bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
							bodyPosition.D = 1500
							bodyPosition.P = 10000
							bodyPosition.Parent = otherCharacter.HumanoidRootPart
							
							local bodyGyro = Instance.new("BodyGyro")
							bodyGyro.Name = "ControlGyro"
							bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
							bodyGyro.D = 1500
							bodyGyro.P = 10000
							bodyGyro.Parent = otherCharacter.HumanoidRootPart
							
							local ctrlEffects = createTelekinesisParticles(otherCharacter.Head, config.Color)
							local ctrlLight = createAdvancedLight(otherCharacter, config.Color, 8)
							
							-- Trail mejorado
							local trail = Instance.new("Trail")
							local att0 = Instance.new("Attachment", otherCharacter.HumanoidRootPart)
							local att1 = Instance.new("Attachment", otherCharacter.HumanoidRootPart)
							att1.Position = Vector3.new(0, 3, 0)
							trail.Attachment0 = att0
							trail.Attachment1 = att1
							trail.Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
								ColorSequenceKeypoint.new(0.5, config.Color),
								ColorSequenceKeypoint.new(1, config.Color)
							})
							trail.Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 0.3),
								NumberSequenceKeypoint.new(1, 1)
							})
							trail.Lifetime = 2
							trail.LightEmission = 1
							trail.Parent = otherCharacter.HumanoidRootPart
							
							-- Movimiento orbital mejorado
							local angle = math.random() * math.pi * 2
							local orbitRadius = 20
							local floatConnection
							floatConnection = RunService.Heartbeat:Connect(function(dt)
								if otherCharacter and otherCharacter.Parent and bodyPosition and bodyPosition.Parent then
									angle = angle + dt * 1.5
									local height = math.sin(angle * 4) * 4 + 12
									local radius = orbitRadius + math.cos(angle * 2) * 5
									bodyPosition.Position = character.HumanoidRootPart.Position + 
										Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
									bodyGyro.CFrame = CFrame.Angles(
										math.sin(angle * 3) * 0.6,
										angle * 2.5,
										math.cos(angle * 3) * 0.6
									)
								else
									floatConnection:Disconnect()
								end
							end)
							
							task.delay(duration - (tick() - startTime), function()
								floatConnection:Disconnect()
								if bodyPosition then bodyPosition:Destroy() end
								if bodyGyro then bodyGyro:Destroy() end
								for _, effect in ipairs(ctrlEffects) do if effect then effect:Destroy() end end
								if ctrlLight then ctrlLight:Destroy() end
								if trail then trail:Destroy() end
								if att0 then att0:Destroy() end
								if att1 then att1:Destroy() end
							end)
						end
					end
				end
			end
		end
	end)
	
	-- Detener sonidos
	task.delay(duration, function()
		if loopSound then loopSound:Stop() task.delay(0.5, function() if loopSound then loopSound:Destroy() end end) end
	end)
	
	-- Limpieza
	task.wait(duration)
	for _, zone in ipairs(layers) do if zone then zone:Destroy() end end
	for _, effect in ipairs(userEffects) do if effect then effect:Destroy() end end
	for _, item in ipairs(energyLines) do if item then item:Destroy() end end
	if noseBleed then noseBleed:Destroy() end
	if userLight then userLight:Destroy() end
end

-- ====================================================================
-- PODER 4: PROTECCIÓN IMPENETRABLE MEJORADA
-- ====================================================================

local function useProtection(player)
	local character = player.Character
	if not character or not character:FindFirstChild("Humanoid") then return end
	if not checkAndSetCooldown(player.UserId, "Protection", POWER_CONFIG.Protection.Cooldown) then return end
	
	local config = POWER_CONFIG.Protection
	
	-- Efectos de usuario
	local userEffects = createTelekinesisParticles(character.Head, config.Color)
	local noseBleed = createNoseBleed(character)
	local userLight = createAdvancedLight(character, config.Color, 18)
	
	-- Sonidos
	local activationSound, loopSound = createPowerSounds(character.Head, config)
	
	-- Sistema de escudo multicapa
	local shields = {}
	
	-- Capa 1: Escudo interno sólido
	local innerShield = Instance.new("Part")
	innerShield.Shape = Enum.PartType.Ball
	innerShield.Size = Vector3.new(11, 11, 11)
	innerShield.Position = character.HumanoidRootPart.Position
	innerShield.Anchored = true
	innerShield.CanCollide = false
	innerShield.Material = Enum.Material.ForceField
	innerShield.Color = config.Color
	innerShield.Transparency = 0.25
	innerShield.Parent = workspace
	table.insert(shields, innerShield)
	
	-- Capa 2: Escudo medio energético
	local middleShield = Instance.new("Part")
	middleShield.Shape = Enum.PartType.Ball
	middleShield.Size = Vector3.new(13, 13, 13)
	middleShield.Position = character.HumanoidRootPart.Position
	middleShield.Anchored = true
	middleShield.CanCollide = false
	middleShield.Material = Enum.Material.Neon
	middleShield.Color = config.Color
	middleShield.Transparency = 0.5
	middleShield.Parent = workspace
	table.insert(shields, middleShield)
	
	-- Capa 3: Escudo exterior brillante
	local outerShield = Instance.new("Part")
	outerShield.Shape = Enum.PartType.Ball
	outerShield.Size = Vector3.new(15, 15, 15)
	outerShield.Position = character.HumanoidRootPart.Position
	outerShield.Anchored = true
	outerShield.CanCollide = false
	outerShield.Material = Enum.Material.Neon
	outerShield.Color = Color3.new(1, 1, 1)
	outerShield.Transparency = 0.7
	outerShield.Parent = workspace
	table.insert(shields, outerShield)
	
	-- Sistema de luces
	local shieldLight = Instance.new("PointLight")
	shieldLight.Color = config.Color
	shieldLight.Brightness = 20
	shieldLight.Range = 50
	shieldLight.Shadows = true
	shieldLight.Parent = innerShield
	
	-- Partículas hexagonales avanzadas
	local hexParticles = createEnhancedParticleLayer(innerShield, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, config.Color),
			ColorSequenceKeypoint.new(1, config.Color)
		}),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 2),
			NumberSequenceKeypoint.new(0.5, 3),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(0.5, 0.4),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(2, 3.5),
		Rate = 70,
		Speed = NumberRange.new(3, 8),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 1,
		RotSpeed = NumberRange.new(-100, 100)
	})
	
	-- Partículas de energía exterior
	local energyParticles = createEnhancedParticleLayer(outerShield, {
		Texture = "rbxassetid://6101261905",
		Color = ColorSequence.new(config.Color),
		Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(0.5, 1.5),
			NumberSequenceKeypoint.new(1, 0)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Lifetime = NumberRange.new(1, 2),
		Rate = 80,
		Speed = NumberRange.new(5, 12),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 1,
		Drag = 3
	})
	
	-- Animación de rotación compleja
	task.spawn(function()
		local time = 0
		while innerShield.Parent do
			time = time + 0.03
			innerShield.CFrame = innerShield.CFrame * CFrame.Angles(0, math.rad(2), math.rad(1))
			middleShield.CFrame = middleShield.CFrame * CFrame.Angles(math.rad(1), math.rad(-3), 0)
			outerShield.CFrame = outerShield.CFrame * CFrame.Angles(math.rad(-1), math.rad(1.5), math.rad(-2))
			
			-- Pulso de luz
			local pulse = math.sin(time * 5) * 0.5 + 0.5
			shieldLight.Brightness = 20 + pulse * 8
			shieldLight.Range = 50 + pulse * 15
			
			task.wait(0.03)
		end
	end)
	
	-- Pulsos de tamaño
	TweenService:Create(innerShield, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Transparency = 0.15,
		Size = Vector3.new(12, 12, 12)
	}):Play()
	
	TweenService:Create(middleShield, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Transparency = 0.35,
		Size = Vector3.new(14, 14, 14)
	}):Play()
	
	TweenService:Create(outerShield, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Transparency = 0.5,
		Size = Vector3.new(16, 16, 16)
	}):Play()
	
	-- Mover escudos con el jugador
	local connection
	connection = RunService.Heartbeat:Connect(function()
		if character and character.Parent and innerShield and innerShield.Parent then
			local pos = character.HumanoidRootPart.Position
			innerShield.Position = pos
			middleShield.Position = pos
			outerShield.Position = pos
		else
			connection:Disconnect()
		end
	end)
	
	-- ForceField
	local forceField = Instance.new("ForceField")
	forceField.Visible = false
	forceField.Parent = character
	
	-- Efecto de impacto cuando recibe daño
	local rayCount = 0
	local damageConnection
	damageConnection = character.Humanoid.HealthChanged:Connect(function(health)
		if health < character.Humanoid.MaxHealth and rayCount < 25 then
			rayCount = rayCount + 1
			
			-- Múltiples rayos de defensa
			for i = 1, 3 do
				task.spawn(function()
					local ray = Instance.new("Part")
					ray.Size = Vector3.new(0.4, 0.4, math.random(8, 15))
					ray.Material = Enum.Material.Neon
					ray.Color = i == 1 and Color3.new(1, 1, 1) or config.Color
					ray.Anchored = true
					ray.CanCollide = false
					ray.CFrame = CFrame.new(innerShield.Position) * 
						CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), 0) * 
						CFrame.new(0, 0, -8)
					ray.Parent = workspace
					
					TweenService:Create(ray, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 1,
						Size = Vector3.new(0.4, 0.4, ray.Size.Z * 1.5)
					}):Play()
					
					Debris:AddItem(ray, 0.3)
				end)
			end
			
			-- Onda de choque al recibir impacto
			createShockwaveRing(innerShield.Position, config.Color, 20, 0.4)
		end
	end)
	
	-- Duración
	task.wait(config.Duration)
	
	-- Detener sonidos
	if loopSound then loopSound:Stop() task.delay(0.5, function() if loopSound then loopSound:Destroy() end end) end
	
	-- Limpieza
	damageConnection:Disconnect()
	connection:Disconnect()
	if forceField then forceField:Destroy() end
	
	-- Desvanecimiento épico con múltiples ondas
	for i = 1, 5 do
		task.delay(i * 0.1, function()
			createShockwaveRing(innerShield.Position, config.Color, 25 + i * 5, 1)
		end)
	end
	
	local fadeTween1 = TweenService:Create(innerShield, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(25, 25, 25)
	})
	fadeTween1:Play()
	
	TweenService:Create(middleShield, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(27, 27, 27)
	}):Play()
	
	TweenService:Create(outerShield, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(30, 30, 30)
	}):Play()
	
	hexParticles.Enabled = false
	energyParticles.Enabled = false
	
	task.delay(2, function()
		for _, shield in ipairs(shields) do
			if shield then shield:Destroy() end
		end
	end)
	
	for _, effect in ipairs(userEffects) do if effect then effect:Destroy() end end
	if noseBleed then noseBleed:Destroy() end
	if userLight then userLight:Destroy() end
end

-- ====================================================================
-- PODER 5: CURACIÓN DIVINA MEJORADA
-- ====================================================================

local function useHealing(player, targetPlayer)
	local character = player.Character
	local targetCharacter = targetPlayer.Character
	
	if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
	if not checkAndSetCooldown(player.UserId, "Healing", POWER_CONFIG.Healing.Cooldown) then return end
	
	local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
	if distance > POWER_CONFIG.Healing.Range then return end
	
	local config = POWER_CONFIG.Healing
	
	local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
	if not targetHumanoid or targetHumanoid.Health >= targetHumanoid.MaxHealth then return end
	
	-- Efectos en sanador
	local healerEffects = createHealingParticles(character.Head, config.Color)
	local healerLight = createAdvancedLight(character, config.Color, 12)
	
	-- Sonidos
	local activationSound, loopSound = createPowerSounds(character.Head, config)
	
	-- Efectos en objetivo
	local targetEffects = createHealingParticles(targetCharacter.Head, config.Color)
	local targetLight = createAdvancedLight(targetCharacter, config.Color, 10)
	
	-- Beam de curación mejorado
	local att0 = Instance.new("Attachment", character.Head)
	local att1 = Instance.new("Attachment", targetCharacter.Head)
	local beams = createAdvancedBeam(att0, att1, config.Color, "healing")
	
	-- Múltiples ondas de curación
	for i = 1, 5 do
		task.spawn(function()
			task.wait(i * 0.2)
			local wave = Instance.new("Part")
			wave.Shape = Enum.PartType.Ball
			wave.Size = Vector3.new(1, 1, 1)
			wave.Position = targetCharacter.HumanoidRootPart.Position
			wave.Anchored = true
			wave.CanCollide = false
			wave.Material = Enum.Material.Neon
			wave.Color = i % 2 == 0 and config.Color or Color3.new(1, 1, 1)
			wave.Transparency = 0.2
			wave.Parent = workspace
			
			TweenService:Create(wave, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = Vector3.new(18, 18, 18),
				Transparency = 1
			}):Play()
			Debris:AddItem(wave, 1)
		end)
	end
	
	-- Aura de curación multicapa
	local healAuras = {}
	for i = 1, 3 do
		local healAura = Instance.new("Part")
		healAura.Shape = Enum.PartType.Ball
		healAura.Size = Vector3.new(7 + i * 1.5, 7 + i * 1.5, 7 + i * 1.5)
		healAura.Position = targetCharacter.HumanoidRootPart.Position
		healAura.Anchored = true
		healAura.CanCollide = false
		healAura.Material = i == 1 and Enum.Material.ForceField or Enum.Material.Neon
		healAura.Color = config.Color
		healAura.Transparency = 0.4 + (i * 0.1)
		healAura.Parent = workspace
		table.insert(healAuras, healAura)
		
		-- Rotación
		task.spawn(function()
			local rotSpeed = i * 1.5
			while healAura.Parent do
				healAura.CFrame = healAura.CFrame * CFrame.Angles(0, math.rad(rotSpeed), math.rad(rotSpeed * 0.5))
				task.wait(0.03)
			end
		end)
		
		-- Pulso
		TweenService:Create(healAura, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Transparency = 0.3 + (i * 0.08),
			Size = Vector3.new(8 + i * 1.5, 8 + i * 1.5, 8 + i * 1.5)
		}):Play()
	end
	
	-- Luz principal
	local healLight = Instance.new("PointLight")
	healLight.Color = config.Color
	healLight.Brightness = 15
	healLight.Range = 30
	healLight.Parent = healAuras[1]
	
	-- Partículas ascendentes avanzadas
	local healParticles = createHealingParticles(healAuras[1], config.Color)
	
	-- Símbolos de cruz/más flotantes mejorados
	for i = 1, 8 do
		task.spawn(function()
			task.wait(i * 0.08)
			local symbolPos = targetCharacter.HumanoidRootPart.Position + Vector3.new(
				math.random(-4, 4),
				math.random(0, 3),
				math.random(-4, 4)
			)
			
			local symbol = Instance.new("Part")
			symbol.Shape = Enum.PartType.Block
			symbol.Size = Vector3.new(1.2, 3.5, 0.4)
			symbol.Position = symbolPos
			symbol.Material = Enum.Material.Neon
			symbol.Color = config.Color
			symbol.Anchored = true
			symbol.CanCollide = false
			symbol.Parent = workspace
			
			local symbol2 = symbol:Clone()
			symbol2.Size = Vector3.new(3.5, 1.2, 0.4)
			symbol2.Position = symbolPos
			symbol2.Parent = workspace
			
			-- Glow
			local glow = Instance.new("PointLight")
			glow.Color = config.Color
			glow.Brightness = 5
			glow.Range = 8
			glow.Parent = symbol
			
			-- Animación ascendente
			TweenService:Create(symbol, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Position = symbolPos + Vector3.new(0, 10, 0),
				Transparency = 1,
				Size = Vector3.new(0.6, 1.8, 0.2)
			}):Play()
			TweenService:Create(symbol2, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Position = symbolPos + Vector3.new(0, 10, 0),
				Transparency = 1,
				Size = Vector3.new(1.8, 0.6, 0.2)
			}):Play()
			
			Debris:AddItem(symbol, 2.5)
			Debris:AddItem(symbol2, 2.5)
		end)
	end
	
	-- Mover auras con el objetivo
	local connection
	connection = RunService.Heartbeat:Connect(function()
		if targetCharacter and targetCharacter.Parent then
			for _, aura in ipairs(healAuras) do
				if aura and aura.Parent then
					aura.Position = targetCharacter.HumanoidRootPart.Position
				end
			end
		else
			connection:Disconnect()
		end
	end)
	
	-- Curación progresiva
	local healDuration = 2.5
	local healPerTick = config.HealAmount / (healDuration * 30)
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
	
	-- Texto de curación mejorado
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 120, 0, 60)
	billboardGui.StudsOffset = Vector3.new(0, 4, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = targetCharacter.HumanoidRootPart
	
	local healText = Instance.new("TextLabel")
	healText.Size = UDim2.new(1, 0, 1, 0)
	healText.BackgroundTransparency = 1
	healText.Text = "+ " .. tostring(config.HealAmount)
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
	
	-- Duración
	task.wait(healDuration)
	
	connection:Disconnect()
	
	-- Detener sonidos
	if loopSound then loopSound:Stop() task.delay(0.5, function() if loopSound then loopSound:Destroy() end end) end
	
	-- Desvanecimiento de auras
	for _, aura in ipairs(healAuras) do
		if aura then
			TweenService:Create(aura, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 1,
				Size = aura.Size * 1.8
			}):Play()
		end
	end
	
	for _, particle in ipairs(healParticles) do
		if particle then particle.Enabled = false end
	end
	
	task.delay(1.5, function()
		for _, aura in ipairs(healAuras) do
			if aura then aura:Destroy() end
		end
	end)
	
	-- Limpieza
	for _, effect in ipairs(healerEffects) do if effect then effect:Destroy() end end
	for _, effect in ipairs(targetEffects) do if effect then effect:Destroy() end end
	for _, beam in ipairs(beams) do if beam then beam:Destroy() end end
	if healerLight then healerLight:Destroy() end
	if targetLight then targetLight:Destroy() end
	if att0 then att0:Destroy() end
	if att1 then att1:Destroy() end
end

-- ====================================================================
-- CONECTAR EVENTOS
-- ====================================================================

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

print("✅ STRANGER THINGS EPIC POWERS SYSTEM - ENHANCED EDITION LOADED")
print("✅ Efectos visuales profesionales implementados")
print("✅ Sistema de partículas multicapa avanzado")
print("✅ Animaciones cinemáticas mejoradas")
print("✅ Iluminación dinámica profesional")
print("✅ 5 Poderes: Telekinesis (Q) | Explosión (E) | Control (R) | Protección (T) | Curación (F)")
