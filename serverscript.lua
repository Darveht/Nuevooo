– STRANGER THINGS EPIC POWERS SYSTEM V2.0 - SERVER SCRIPT
– Coloca este script en ServerScriptService

local Players = game:GetService(“Players”)
local ReplicatedStorage = game:GetService(“ReplicatedStorage”)
local TweenService = game:GetService(“TweenService”)
local Debris = game:GetService(“Debris”)
local RunService = game:GetService(“RunService”)

– Crear RemoteEvents
local powerEvents = Instance.new(“Folder”)
powerEvents.Name = “PowerEvents”
powerEvents.Parent = ReplicatedStorage

local telekinesisPower = Instance.new(“RemoteEvent”)
telekinesisPower.Name = “TelekinesisPower”
telekinesisPower.Parent = powerEvents

local explosionPower = Instance.new(“RemoteEvent”)
explosionPower.Name = “ExplosionPower”
explosionPower.Parent = powerEvents

local controlPower = Instance.new(“RemoteEvent”)
controlPower.Name = “ControlPower”
controlPower.Parent = powerEvents

local protectionPower = Instance.new(“RemoteEvent”)
protectionPower.Name = “ProtectionPower”
protectionPower.Parent = powerEvents

local healingPower = Instance.new(“RemoteEvent”)
healingPower.Name = “HealingPower”
healingPower.Parent = powerEvents

local superSpeedPower = Instance.new(“RemoteEvent”)
superSpeedPower.Name = “SuperSpeedPower”
superSpeedPower.Parent = powerEvents

– Configuración de Poderes
local POWER_CONFIG = {
Telekinesis = {
Cooldown = 15,
Duration = 8,
Range = 50,
Color = Color3.fromRGB(138, 43, 226),
Sound = “rbxassetid://5153438710”
},
Explosion = {
Cooldown = 20,
Range = 60,
Force = 5000,
Color = Color3.fromRGB(195, 0, 0),
Sound = “rbxassetid://9114397505”
},
Control = {
Cooldown = 25,
Duration = 10,
Range = 45,
Color = Color3.fromRGB(255, 69, 0),
Sound = “rbxassetid://9125516670”
},
Protection = {
Cooldown = 60,
Duration = 30,
Color = Color3.fromRGB(255, 10, 10),
Sound = “rbxassetid://814168787”
},
Healing = {
Cooldown = 18,
Range = 40,
HealAmount = 50,
Color = Color3.fromRGB(0, 255, 127),
Sound = “rbxassetid://5153438710”
},
SuperSpeed = {
Cooldown = 12,
Duration = 6,
SpeedMultiplier = 3,
Color = Color3.fromRGB(255, 215, 0),
Sound = “rbxassetid://1841354093”
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

– ===== SISTEMA DE EFECTOS VISUALES MEJORADOS =====

local function createHandAnimation(character, powerType, color)
local rightArm = character:FindFirstChild(“Right Arm”) or character:FindFirstChild(“RightHand”)
local leftArm = character:FindFirstChild(“Left Arm”) or character:FindFirstChild(“LeftHand”)

```
if not rightArm or not leftArm then return end

local effects = {}

-- Partículas en las manos
for _, arm in ipairs({rightArm, leftArm}) do
	local handParticle = Instance.new("ParticleEmitter")
	handParticle.Parent = arm
	handParticle.Texture = "rbxassetid://6101261905"
	handParticle.Color = ColorSequence.new(color)
	handParticle.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(0.5, 2),
		NumberSequenceKeypoint.new(1, 0.1)
	})
	handParticle.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	handParticle.Lifetime = NumberRange.new(0.5, 1.5)
	handParticle.Rate = 100
	handParticle.Speed = NumberRange.new(3, 8)
	handParticle.SpreadAngle = Vector2.new(180, 180)
	handParticle.Rotation = NumberRange.new(0, 360)
	handParticle.RotSpeed = NumberRange.new(-200, 200)
	handParticle.LightEmission = 1
	
	-- Luz en manos
	local handLight = Instance.new("PointLight")
	handLight.Color = color
	handLight.Brightness = 3
	handLight.Range = 15
	handLight.Parent = arm
	
	table.insert(effects, handParticle)
	table.insert(effects, handLight)
end

return effects
```

end

local function createEpicParticleSystem(parent, color, intensity)
local effects = {}

```
-- Capa 1: Energía brillante
local energy = Instance.new("ParticleEmitter")
energy.Parent = parent
energy.Texture = "rbxassetid://6101261905"
energy.Color = ColorSequence.new(color)
energy.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.3),
	NumberSequenceKeypoint.new(0.5, 3 * intensity),
	NumberSequenceKeypoint.new(1, 0.1)
})
energy.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.5, 0.2),
	NumberSequenceKeypoint.new(1, 1)
})
energy.Lifetime = NumberRange.new(1, 2.5)
energy.Rate = 80 * intensity
energy.Speed = NumberRange.new(5, 12)
energy.SpreadAngle = Vector2.new(180, 180)
energy.Rotation = NumberRange.new(0, 360)
energy.RotSpeed = NumberRange.new(-200, 200)
energy.LightEmission = 1
table.insert(effects, energy)

-- Capa 2: Humo oscuro
local smoke = Instance.new("ParticleEmitter")
smoke.Parent = parent
smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
smoke.Color = ColorSequence.new(Color3.fromRGB(20, 20, 30), color * 0.5)
smoke.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 2),
	NumberSequenceKeypoint.new(1, 5 * intensity)
})
smoke.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.5),
	NumberSequenceKeypoint.new(1, 1)
})
smoke.Lifetime = NumberRange.new(2, 3)
smoke.Rate = 40 * intensity
smoke.Speed = NumberRange.new(2, 6)
smoke.SpreadAngle = Vector2.new(180, 180)
smoke.Rotation = NumberRange.new(0, 360)
smoke.RotSpeed = NumberRange.new(-100, 100)
table.insert(effects, smoke)

-- Capa 3: Chispas eléctricas
local sparks = Instance.new("ParticleEmitter")
sparks.Parent = parent
sparks.Texture = "rbxassetid://6101261905"
sparks.Color = ColorSequence.new(Color3.new(1, 1, 1), color)
sparks.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.8),
	NumberSequenceKeypoint.new(1, 0)
})
sparks.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(1, 1)
})
sparks.Lifetime = NumberRange.new(0.2, 0.6)
sparks.Rate = 60 * intensity
sparks.Speed = NumberRange.new(12, 25)
sparks.SpreadAngle = Vector2.new(180, 180)
sparks.LightEmission = 1
table.insert(effects, sparks)

return effects
```

end

local function createNoseBleed(character)
local head = character:FindFirstChild(“Head”)
if not head then return end

```
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
blood.Lifetime = NumberRange.new(0.8, 1.5)
blood.Rate = 12
blood.Speed = NumberRange.new(1, 3)
blood.SpreadAngle = Vector2.new(15, 15)
blood.EmissionDirection = Enum.NormalId.Bottom
blood.Acceleration = Vector3.new(0, -12, 0)

return blood
```

end

local function createEpicBeam(att0, att1, color)
local mainBeam = Instance.new(“Beam”)
mainBeam.Attachment0 = att0
mainBeam.Attachment1 = att1
mainBeam.Color = ColorSequence.new(color)
mainBeam.Width0 = 2.5
mainBeam.Width1 = 2.5
mainBeam.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0),
NumberSequenceKeypoint.new(0.5, 0.2),
NumberSequenceKeypoint.new(1, 0)
})
mainBeam.FaceCamera = true
mainBeam.LightEmission = 1
mainBeam.Texture = “rbxassetid://6101261905”
mainBeam.TextureMode = Enum.TextureMode.Wrap
mainBeam.TextureSpeed = 4
mainBeam.TextureLength = 2
mainBeam.Parent = att0.Parent

```
local outerBeam = Instance.new("Beam")
outerBeam.Attachment0 = att0
outerBeam.Attachment1 = att1
outerBeam.Color = ColorSequence.new(color)
outerBeam.Width0 = 4
outerBeam.Width1 = 4
outerBeam.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.6),
	NumberSequenceKeypoint.new(0.5, 0.8),
	NumberSequenceKeypoint.new(1, 0.6)
})
outerBeam.FaceCamera = true
outerBeam.LightEmission = 0.7
outerBeam.Texture = "rbxasset://textures/particles/smoke_main.dds"
outerBeam.TextureMode = Enum.TextureMode.Wrap
outerBeam.TextureSpeed = -2
outerBeam.Parent = att0.Parent

return {mainBeam, outerBeam}
```

end

– ===== PODER 1: TELEKINESIS =====

local function useTelekinesis(player, targetPlayer)
local character = player.Character
local targetCharacter = targetPlayer.Character

```
if not character or not targetCharacter then return end
if not checkAndSetCooldown(player.UserId, "Telekinesis", POWER_CONFIG.Telekinesis.Cooldown) then return end

local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
if distance > POWER_CONFIG.Telekinesis.Range then return end

local config = POWER_CONFIG.Telekinesis

-- Animación de manos
local handEffects = createHandAnimation(character, "telekinesis", config.Color)

-- Efectos en cabezas
local userEffects = createEpicParticleSystem(character.Head, config.Color, 1)
local targetEffects = createEpicParticleSystem(targetCharacter.Head, config.Color, 1.2)

-- Sangre de nariz
local noseBleed = createNoseBleed(character)

-- Luz dramática
local userLight = Instance.new("PointLight")
userLight.Color = config.Color
userLight.Brightness = 8
userLight.Range = 30
userLight.Shadows = true
userLight.Parent = character.Head

-- Beam de conexión
local att0 = Instance.new("Attachment", character.Head)
local att1 = Instance.new("Attachment", targetCharacter.Head)
local beams = createEpicBeam(att0, att1, config.Color)

-- Sonido
local sound = Instance.new("Sound")
sound.SoundId = config.Sound
sound.Volume = 1.5
sound.Parent = character.Head
sound:Play()

-- Onda de choque inicial
local shockwave = Instance.new("Part")
shockwave.Shape = Enum.PartType.Cylinder
shockwave.Size = Vector3.new(0.5, 1, 1)
shockwave.Material = Enum.Material.Neon
shockwave.Color = config.Color
shockwave.Anchored = true
shockwave.CanCollide = false
shockwave.CFrame = CFrame.new(character.Head.Position) * CFrame.Angles(0, 0, math.rad(90))
shockwave.Transparency = 0.3
shockwave.Parent = workspace

TweenService:Create(shockwave, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = Vector3.new(0.5, 35, 35),
	Transparency = 1
}):Play()
Debris:AddItem(shockwave, 0.6)

-- Control del objetivo
local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
if targetHumanoid then
	local originalWalkSpeed = targetHumanoid.WalkSpeed
	targetHumanoid.WalkSpeed = 0
	targetHumanoid.JumpPower = 0
	
	local bodyPosition = Instance.new("BodyPosition")
	bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
	bodyPosition.Position = targetCharacter.HumanoidRootPart.Position + Vector3.new(0, 6, 0)
	bodyPosition.D = 1200
	bodyPosition.Parent = targetCharacter.HumanoidRootPart
	
	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
	bodyGyro.D = 1200
	bodyGyro.Parent = targetCharacter.HumanoidRootPart
	
	-- Rotación épica
	task.spawn(function()
		local time = 0
		while time < config.Duration and bodyGyro.Parent do
			time = time + 0.05
			bodyGyro.CFrame = CFrame.Angles(
				math.sin(time * 3) * 0.5,
				time * 4,
				math.cos(time * 3) * 0.5
			)
			task.wait(0.05)
		end
	end)
	
	task.wait(config.Duration)
	
	targetHumanoid.WalkSpeed = originalWalkSpeed
	targetHumanoid.JumpPower = 50
	if bodyPosition then bodyPosition:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
end

-- Limpieza
task.wait(1)
for _, effect in ipairs(handEffects) do effect:Destroy() end
for _, effect in ipairs(userEffects) do effect:Destroy() end
for _, effect in ipairs(targetEffects) do effect:Destroy() end
for _, beam in ipairs(beams) do beam:Destroy() end
if noseBleed then noseBleed:Destroy() end
if userLight then userLight:Destroy() end
if att0 then att0:Destroy() end
if att1 then att1:Destroy() end
```

end

– ===== PODER 2: EXPLOSIÓN PSÍQUICA =====

local function useExplosion(player, targetPlayer)
local character = player.Character
local targetCharacter = targetPlayer.Character

```
if not character or not targetCharacter then return end
if not checkAndSetCooldown(player.UserId, "Explosion", POWER_CONFIG.Explosion.Cooldown) then return end

local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
if distance > POWER_CONFIG.Explosion.Range then return end

local config = POWER_CONFIG.Explosion

-- Animación de manos
local handEffects = createHandAnimation(character, "explosion", config.Color)

-- Efectos en usuario
local userEffects = createEpicParticleSystem(character.Head, config.Color, 1.5)
local noseBleed = createNoseBleed(character)

-- Esfera de carga
local chargeSphere = Instance.new("Part")
chargeSphere.Shape = Enum.PartType.Ball
chargeSphere.Size = Vector3.new(2, 2, 2)
chargeSphere.Position = targetCharacter.HumanoidRootPart.Position
chargeSphere.Anchored = true
chargeSphere.CanCollide = false
chargeSphere.Material = Enum.Material.Neon
chargeSphere.Color = config.Color
chargeSphere.Transparency = 0.2
chargeSphere.Parent = workspace

-- Luz pulsante
local chargeLight = Instance.new("PointLight")
chargeLight.Color = config.Color
chargeLight.Brightness = 12
chargeLight.Range = 35
chargeLight.Shadows = true
chargeLight.Parent = chargeSphere

-- Partículas de carga
local chargeEffects = createEpicParticleSystem(chargeSphere, config.Color, 2)

-- Sonido de carga
local chargeSound = Instance.new("Sound")
chargeSound.SoundId = "rbxassetid://9125516670"
chargeSound.Volume = 1.2
chargeSound.Parent = chargeSphere
chargeSound:Play()

-- Animación de carga
TweenService:Create(chargeSphere, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
	Size = Vector3.new(10, 10, 10),
	Transparency = 0
}):Play()

task.wait(1.5)

-- ¡EXPLOSIÓN!
local explosionSound = Instance.new("Sound")
explosionSound.SoundId = config.Sound
explosionSound.Volume = 2.5
explosionSound.Parent = chargeSphere
explosionSound:Play()

-- Múltiples ondas de choque
for i = 1, 6 do
	task.spawn(function()
		task.wait(i * 0.08)
		local wave = Instance.new("Part")
		wave.Shape = Enum.PartType.Ball
		wave.Size = Vector3.new(1, 1, 1)
		wave.Position = chargeSphere.Position
		wave.Anchored = true
		wave.CanCollide = false
		wave.Material = Enum.Material.Neon
		wave.Color = config.Color
		wave.Transparency = 0.3 + (i * 0.08)
		wave.Parent = workspace
		
		TweenService:Create(wave, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = Vector3.new(50, 50, 50),
			Transparency = 1
		}):Play()
		Debris:AddItem(wave, 0.9)
	end)
end

-- Explosión real
local explosion = Instance.new("Explosion")
explosion.Position = targetCharacter.HumanoidRootPart.Position
explosion.BlastPressure = config.Force
explosion.BlastRadius = 25
explosion.ExplosionType = Enum.ExplosionType.Craters
explosion.Parent = workspace

-- Daño
local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
if targetHumanoid then
	targetHumanoid:TakeDamage(50)
end

-- Limpieza
task.wait(2)
for _, effect in ipairs(handEffects) do effect:Destroy() end
for _, effect in ipairs(userEffects) do effect:Destroy() end
for _, effect in ipairs(chargeEffects) do effect:Destroy() end
if noseBleed then noseBleed:Destroy() end
chargeSphere:Destroy()
```

end

– ===== PODER 3: CONTROL MENTAL (CON FLASHES ÉPICOS) =====

local function createBrainAnimation(position, color)
– Cerebro giratorio épico
local brain = Instance.new(“Part”)
brain.Shape = Enum.PartType.Ball
brain.Size = Vector3.new(4, 4, 4)
brain.Position = position + Vector3.new(0, 15, 0)
brain.Anchored = true
brain.CanCollide = false
brain.Material = Enum.Material.Neon
brain.Color = color
brain.Transparency = 0.2
brain.Parent = workspace

```
-- Luz del cerebro
local brainLight = Instance.new("PointLight")
brainLight.Color = color
brainLight.Brightness = 15
brainLight.Range = 50
brainLight.Shadows = true
brainLight.Parent = brain

-- Partículas del cerebro
local brainEffects = createEpicParticleSystem(brain, color, 3)

-- Anillos orbitales
local rings = {}
for i = 1, 3 do
	local ring = Instance.new("Part")
	ring.Shape = Enum.PartType.Cylinder
	ring.Size = Vector3.new(0.3, 8 + i * 2, 8 + i * 2)
	ring.Position = brain.Position
	ring.Anchored = true
	ring.CanCollide = false
	ring.Material = Enum.Material.Neon
	ring.Color = color
	ring.Transparency = 0.5
	ring.Parent = workspace
	table.insert(rings, ring)
end

-- Animación de rotación
task.spawn(function()
	local time = 0
	while brain.Parent do
		time = time + 0.03
		brain.CFrame = CFrame.new(brain.Position) * CFrame.Angles(0, time * 3, time * 2)
		
		for i, ring in ipairs(rings) do
			ring.CFrame = CFrame.new(brain.Position) * 
				CFrame.Angles(math.rad(90 * i), time * (2 + i), 0)
		end
		
		task.wait(0.03)
	end
end)

-- Pulso
task.spawn(function()
	while brain.Parent do
		TweenService:Create(brain, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Size = Vector3.new(4.5, 4.5, 4.5),
			Transparency = 0
		}):Play()
		task.wait(0.5)
		TweenService:Create(brain, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Size = Vector3.new(4, 4, 4),
			Transparency = 0.2
		}):Play()
		task.wait(0.5)
	end
end)

return brain, rings, brainEffects
```

end

local function useControl(player)
local character = player.Character
if not character then return end
if not checkAndSetCooldown(player.UserId, “Control”, POWER_CONFIG.Control.Cooldown) then return end

```
local config = POWER_CONFIG.Control

-- Animación de manos
local handEffects = createHandAnimation(character, "control", config.Color)

-- Efectos en usuario
local userEffects = createEpicParticleSystem(character.Head, config.Color, 2)
local noseBleed = createNoseBleed(character)

-- CEREBRO ÉPICO FLOTANTE
local brain, rings, brainEffects = createBrainAnimation(character.HumanoidRootPart.Position, config.Color)

-- Sonido
local sound = Instance.new("Sound")
sound.SoundId = config.Sound
sound.Volume = 2
sound.Looped = true
sound.Parent = brain
sound:Play()

-- Zona de control con capas
local zones = {}
for i = 1, 4 do
	local zone = Instance.new("Part")
	zone.Shape = Enum.PartType.Cylinder
	zone.Size = Vector3.new(1, config.Range * 2 * (1 + i * 0.15), config.Range * 2 * (1 + i * 0.15))
	zone.Position = character.HumanoidRootPart.Position
	zone.Rotation = Vector3.new(0, 0, 90)
	zone.Anchored = true
	zone.CanCollide = false
	zone.Material = Enum.Material.ForceField
	zone.Color = config.Color
	zone.Transparency = 0.6 + (i * 0.08)
	zone.Parent = workspace
	
	-- Rotación
	task.spawn(function()
		while zone.Parent do
			zone.Rotation = zone.Rotation + Vector3.new(0, 2.5 * i, 0)
			task.wait(0.03)
		end
	end)
	
	table.insert(zones, zone)
end

-- Control de jugadores
local controlledPlayers = {}
local duration = config.Duration
local startTime = tick()

local controlLoop = RunService.Heartbeat:Connect(function()
	if tick() - startTime > duration then
		controlLoop:Disconnect()
		return
	end
	
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local otherCharacter = otherPlayer.Character
			if otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart") then
				local dist = (character.HumanoidRootPart.Position - otherCharacter.HumanoidRootPart.Position).Magnitude
				
				if dist <= config.Range and not controlledPlayers[otherPlayer.UserId] then
					controlledPlayers[otherPlayer.UserId] = true
					
					-- Efectos en víctima
					local victimEffects = createEpicParticleSystem(otherCharacter.Head, config.Color, 1.5)
					
					-- FLASHES DE MEMORIA (Stranger Things style)
					for i = 1, 8 do
						task.spawn(function()
							task.wait(i * 0.3)
							local flash = Instance.new("Part")
							flash.Size = Vector3.new(0.1, 0.1, 0.1)
							flash.Position = otherCharacter.Head.Position + Vector3.new(
								math.random(-3, 3),
								math.random(1, 4),
								math.random(-3, 3)
							)
							flash.Anchored = true
							flash.CanCollide = false
							flash.Material = Enum.Material.Neon
							flash.Color = config.Color
							flash.Shape = Enum.PartType.Ball
							flash.Parent = workspace
							
							TweenService:Create(flash, TweenInfo.new(0.4, Enum.EasingStyle.Flash), {
								Size = Vector3.new(3, 3, 3),
								Transparency = 1
							}):Play()
							
							Debris:AddItem(flash, 0.4)
						end)
					end
					
					-- Control de movimiento
					local bodyPosition = Instance.new("BodyPosition")
					bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
					bodyPosition.D = 1000
					bodyPosition.Parent = otherCharacter.HumanoidRootPart
					
					local bodyGyro = Instance.new("BodyGyro")
					bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
					bodyGyro.D = 1000
					bodyGyro.Parent = otherCharacter.HumanoidRootPart
					
					-- Trail de energía
					local trail = Instance.new("Trail")
					local att0 = Instance.new("Attachment", otherCharacter.HumanoidRootPart)
					local att1 = Instance.new("Attachment", otherCharacter.HumanoidRootPart)
					att1.Position = Vector3.new(0, 3, 0)
					trail.Attachment0 = att0
					trail.Attachment1 = att1
					trail.Color = ColorSequence.new(config.Color)
					trail.Transparency = NumberSequence.new(0.3, 1)
					trail.Lifetime = 1.5
					trail.LightEmission = 1
					trail.Parent = otherCharacter.HumanoidRootPart
					
					-- Movimiento orbital
					local angle = math.random() * math.pi * 2
					local floatConnection = RunService.Heartbeat:Connect(function(dt)
						if otherCharacter and otherCharacter.Parent and bodyPosition and bodyPosition.Parent then
							angle = angle + dt * 2.5
							local height = math.sin(angle * 3) * 4 + 12
							local radius = 18 + math.cos(angle * 1.5) * 6
							bodyPosition.Position = character.HumanoidRootPart.Position + 
								Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
							bodyGyro.CFrame = CFrame.Angles(
								math.sin(angle * 2) * 0.6,
								angle * 3.5,
								math.cos(angle * 2) * 0.6
							)
						else
							floatConnection:Disconnect()
						end
					end)
					
					task.delay(duration - (tick() - startTime), function()
						floatConnection:Disconnect()
						if bodyPosition then bodyPosition:Destroy() end
						if bodyGyro then bodyGyro:Destroy() end
						for _, effect in ipairs(victimEffects) do effect:Destroy() end
						if trail then trail:Destroy() end
						if att0 then att0:Destroy() end
						if att1 then att1:Destroy() end
					end)
				end
			end
		end
	end
end)

-- Limpieza
task.wait(duration)
sound:Stop()

for _, zone in ipairs(zones) do zone:Destroy() end
for _, ring in ipairs(rings) do ring:Destroy() end
for _, effect in ipairs(handEffects) do effect:Destroy() end
for _, effect in ipairs(userEffects) do effect:Destroy() end
for _, effect in ipairs(brainEffects) do effect:Destroy() end
if noseBleed then noseBleed:Destroy() end
brain:Destroy()
```

end

– ===== PODER 4: PROTECCIÓN =====

local function useProtection(player)
local character = player.Character
if not character or not character:FindFirstChild(“Humanoid”) then return end
if not checkAndSetCooldown(player.UserId, “Protection”, POWER_CONFIG.Protection.Cooldown) then return end

```
local config = POWER_CONFIG.Protection

-- Animación de manos
local handEffects = createHandAnimation(character, "protection", config.Color)

-- Efectos en usuario
local userEffects = createEpicParticleSystem(character.Head, config.Color, 1.2)
local noseBleed = createNoseBleed(character)

-- Sonido
local sound = Instance.new("Sound")
sound.SoundId = config.Sound
sound.Volume = 1.8
sound.Looped = true
sound.Parent = character.Head
sound:Play()

-- Escudo principal
local shield = Instance.new("Part")
shield.Shape = Enum.PartType.Ball
shield.Size = Vector3.new(13, 13, 13)
shield.Position = character.HumanoidRootPart.Position
shield.Anchored = true
shield.CanCollide = false
shield.Material = Enum.Material.ForceField
shield.Color = config.Color
shield.Transparency = 0.25
shield.Parent = workspace

-- Capas del escudo
local outerShield = Instance.new("Part")
outerShield.Shape = Enum.PartType.Ball
outerShield.Size = Vector3.new(15, 15, 15)
outerShield.Position = character.HumanoidRootPart.Position
outerShield.Anchored = true
outerShield.CanCollide = false
outerShield.Material = Enum.Material.Neon
outerShield.Color = config.Color
outerShield.Transparency = 0.5
outerShield.Parent = workspace

-- Luz intensa
local shieldLight = Instance.new("PointLight")
shieldLight.Color = config.Color
shieldLight.Brightness = 18
shieldLight.Range = 45
shieldLight.Shadows = true
shieldLight.Parent = shield

-- Partículas hexagonales
local shieldEffects = createEpicParticleSystem(shield, config.Color, 2)

-- Animación de rotación
task.spawn(function()
	while shield.Parent do
		shield.CFrame = shield.CFrame * CFrame.Angles(0, math.rad(2.5), 0)
		outerShield.CFrame = outerShield.CFrame * CFrame.Angles(0, math.rad(-3.5), math.rad(1))
		task.wait(0.03)
	end
end)

-- Pulso continuo
TweenService:Create(shield, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	Transparency = 0.1,
	Size = Vector3.new(14, 14, 14)
}):Play()

TweenService:Create(outerShield, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	Transparency = 0.3,
	Size = Vector3.new(16.5, 16.5, 16.5)
}):Play()

-- Seguir al jugador
local connection = RunService.Heartbeat:Connect(function()
	if character and character.Parent and shield and shield.Parent then
		shield.Position = character.HumanoidRootPart.Position
		outerShield.Position = character.HumanoidRootPart.Position
	else
		connection:Disconnect()
	end
end)

-- ForceField
local forceField = Instance.new("ForceField")
forceField.Visible = false
forceField.Parent = character

-- Rayos de defensa al recibir daño
local rayCount = 0
local damageConnection = character.Humanoid.HealthChanged:Connect(function(health)
	if health < character.Humanoid.MaxHealth and rayCount < 30 then
		rayCount = rayCount + 1
		
		local ray = Instance.new("Part")
		ray.Size = Vector3.new(0.4, 0.4, math.random(6, 12))
		ray.Material = Enum.Material.Neon
		ray.Color = config.Color
		ray.Anchored = true
		ray.CanCollide = false
		ray.CFrame = CFrame.new(shield.Position) * 
			CFrame.Angles(math.random(-180, 180), math.random(-180, 180), 0) * 
			CFrame.new(0, 0, -7)
		ray.Parent = workspace
		
		TweenService:Create(ray, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 1,
			Size = Vector3.new(0.4, 0.4, ray.Size.Z * 2.5)
		}):Play()
		
		Debris:AddItem(ray, 0.25)
	end
end)

-- Duración
task.wait(config.Duration)

-- Detener efectos
sound:Stop()
damageConnection:Disconnect()
connection:Disconnect()
if forceField then forceField:Destroy() end

-- Desvanecimiento épico
TweenService:Create(shield, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Transparency = 1,
	Size = Vector3.new(25, 25, 25)
}):Play()

TweenService:Create(outerShield, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Transparency = 1,
	Size = Vector3.new(28, 28, 28)
}):Play()

for _, effect in ipairs(shieldEffects) do
	effect.Enabled = false
end

task.delay(1.8, function()
	if shield then shield:Destroy() end
	if outerShield then outerShield:Destroy() end
end)

for _, effect in ipairs(handEffects) do effect:Destroy() end
for _, effect in ipairs(userEffects) do effect:Destroy() end
if noseBleed then noseBleed:Destroy() end
```

end

– ===== PODER 5: CURACIÓN =====

local function useHealing(player, targetPlayer)
local character = player.Character
local targetCharacter = targetPlayer.Character

```
if not character or not targetCharacter then return end
if not checkAndSetCooldown(player.UserId, "Healing", POWER_CONFIG.Healing.Cooldown) then return end

local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
if distance > POWER_CONFIG.Healing.Range then return end

local config = POWER_CONFIG.Healing
local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
if not targetHumanoid or targetHumanoid.Health >= targetHumanoid.MaxHealth then return end

-- Animación de manos
local handEffects = createHandAnimation(character, "healing", config.Color)

-- Efectos
local healerEffects = createEpicParticleSystem(character.Head, config.Color, 1)
local targetEffects = createEpicParticleSystem(targetCharacter.Head, config.Color, 1.5)

-- Beam de curación
local att0 = Instance.new("Attachment", character.Head)
local att1 = Instance.new("Attachment", targetCharacter.Head)
local beams = createEpicBeam(att0, att1, config.Color)

-- Sonido
local sound = Instance.new("Sound")
sound.SoundId = config.Sound
sound.Volume = 1.5
sound.Parent = targetCharacter.Head
sound:Play()

-- Aura de curación
local healAura = Instance.new("Part")
healAura.Shape = Enum.PartType.Ball
healAura.Size = Vector3.new(9, 9, 9)
healAura.Position = targetCharacter.HumanoidRootPart.Position
healAura.Anchored = true
healAura.CanCollide = false
healAura.Material = Enum.Material.ForceField
healAura.Color = config.Color
healAura.Transparency = 0.4
healAura.Parent = workspace

local healLight = Instance.new("PointLight")
healLight.Color = config.Color
healLight.Brightness = 12
healLight.Range = 28
healLight.Parent = healAura

local auraEffects = createEpicParticleSystem(healAura, config.Color, 2)

-- Símbolos de curación flotantes
for i = 1, 8 do
	task.spawn(function()
		task.wait(i * 0.15)
		local symbol = Instance.new("Part")
		symbol.Shape = Enum.PartType.Block
		symbol.Size = Vector3.new(1.2, 3.5, 0.4)
		symbol.Position = targetCharacter.HumanoidRootPart.Position + Vector3.new(
			math.random(-4, 4),
			math.random(0, 2),
			math.random(-4, 4)
		)
		symbol.Material = Enum.Material.Neon
		symbol.Color = config.Color
		symbol.Anchored = true
		symbol.CanCollide = false
		symbol.Parent = workspace
		
		local symbol2 = symbol:Clone()
		symbol2.Size = Vector3.new(3.5, 1.2, 0.4)
		symbol2.Position = symbol.Position
		symbol2.Parent = workspace
		
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

-- Seguir objetivo
local connection = RunService.Heartbeat:Connect(function()
	if targetCharacter and targetCharacter.Parent and healAura and healAura.Parent then
		healAura.Position = targetCharacter.HumanoidRootPart.Position
	else
		connection:Disconnect()
	end
end)

-- Curación progresiva
local healDuration = 2.5
local healPerTick = config.HealAmount / (healDuration * 10)
local healTime = 0

local healConnection = RunService.Heartbeat:Connect(function(dt)
	healTime = healTime + dt
	if healTime >= healDuration or targetHumanoid.Health >= targetHumanoid.MaxHealth then
		healConnection:Disconnect()
		return
	end
	targetHumanoid.Health = math.min(targetHumanoid.Health + healPerTick, targetHumanoid.MaxHealth)
end)

-- Números de curación
local billboardGui = Instance.new("BillboardGui")
billboardGui.Size = UDim2.new(0, 120, 0, 60)
billboardGui.StudsOffset = Vector3.new(0, 4, 0)
billboardGui.AlwaysOnTop = true
billboardGui.Parent = targetCharacter.HumanoidRootPart

local healText = Instance.new("TextLabel")
healText.Size = UDim2.new(1, 0, 1, 0)
healText.BackgroundTransparency = 1
healText.Text = "+ " .. tostring(config.HealAmount) .. " HP"
healText.Font = Enum.Font.SourceSansBold
healText.TextSize = 36
healText.TextColor3 = config.Color
healText.TextStrokeTransparency = 0
healText.Parent = billboardGui

TweenService:Create(billboardGui, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
	StudsOffset = Vector3.new(0, 8, 0)
}):Play()
TweenService:Create(healText, TweenInfo.new(2.5), {
	TextTransparency = 1,
	TextStrokeTransparency = 1
}):Play()

Debris:AddItem(billboardGui, 2.5)

-- Limpieza
task.wait(healDuration)
connection:Disconnect()

TweenService:Create(healAura, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Transparency = 1,
	Size = Vector3.new(18, 18, 18)
}):Play()

for _, effect in ipairs(auraEffects) do
	effect.Enabled = false
end

task.delay(1.2, function()
	if healAura then healAura:Destroy() end
end)

for _, effect in ipairs(handEffects) do effect:Destroy() end
for _, effect in ipairs(healerEffects) do effect:Destroy() end
for _, effect in ipairs(targetEffects) do effect:Destroy() end
for _, beam in ipairs(beams) do beam:Destroy() end
if att0 then att0:Destroy() end
if att1 then att1:Destroy() end
```

end

– ===== PODER 6: SUPER VELOCIDAD (NUEVO) =====

local function useSuperSpeed(player)
local character = player.Character
if not character or not character:FindFirstChild(“Humanoid”) then return end
if not checkAndSetCooldown(player.UserId, “SuperSpeed”, POWER_CONFIG.SuperSpeed.Cooldown) then return end

```
local config = POWER_CONFIG.SuperSpeed
local humanoid = character.Humanoid

-- Guardar velocidad original
local originalSpeed = humanoid.WalkSpeed

-- Efectos en pies
local leftLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftFoot")
local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightFoot")

local legEffects = {}
if leftLeg and rightLeg then
	for _, leg in ipairs({leftLeg, rightLeg}) do
		local effects = createEpicParticleSystem(leg, config.Color, 2)
		for _, effect in ipairs(effects) do
			table.insert(legEffects, effect)
		end
	end
end

-- Efectos en cuerpo
local bodyEffects = createEpicParticleSystem(character.HumanoidRootPart, config.Color, 1.5)

-- Aura de velocidad
local speedAura = Instance.new("Part")
speedAura.Shape = Enum.PartType.Ball
speedAura.Size = Vector3.new(6, 6, 6)
speedAura.Anchored = true
speedAura.CanCollide = false
speedAura.Material = Enum.Material.Neon
speedAura.Color = config.Color
speedAura.Transparency = 0.6
speedAura.Parent = workspace

-- Luz
local speedLight = Instance.new("PointLight")
speedLight.Color = config.Color
speedLight.Brightness = 10
speedLight.Range = 25
speedLight.Parent = speedAura

-- Sonido
local sound = Instance.new("Sound")
sound.SoundId = config.Sound
sound.Volume = 1.8
sound.Looped = true
sound.Pitch = 1.3
sound.Parent = character.HumanoidRootPart
sound:Play()

-- Trail épico
local trail = Instance.new("Trail")
local att0 = Instance.new("Attachment", character.HumanoidRootPart)
local att1 = Instance.new("Attachment", character.HumanoidRootPart)
att0.Position = Vector3.new(-1, 0, 0)
att1.Position = Vector3.new(1, 0, 0)
trail.Attachment0 = att0
trail.Attachment1 = att1
trail.Color = ColorSequence.new(config.Color, Color3.new(1, 1, 1))
trail.Transparency = NumberSequence.new(0.2, 1)
trail.Lifetime = 1
trail.LightEmission = 1
trail.TextureMode = Enum.TextureMode.Stretch
trail.Parent = character.HumanoidRootPart

-- AUMENTAR VELOCIDAD
humanoid.WalkSpeed = originalSpeed * config.SpeedMultiplier

-- Efecto de afterimages (rastros del jugador)
local afterimageConnection
afterimageConnection = RunService.Heartbeat:Connect(function()
	if math.random() > 0.7 then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				local clone = part:Clone()
				clone.Anchored = true
				clone.CanCollide = false
				clone.Transparency = 0.7
				clone.Color = config.Color
				clone.Material = Enum.Material.Neon
				clone:ClearAllChildren()
				clone.Parent = workspace
				
				TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 1
				}):Play()
				
				Debris:AddItem(clone, 0.5)
			end
		end
	end
end)

-- Seguir al jugador con el aura
local auraConnection = RunService.Heartbeat:Connect(function()
	if character and character.Parent and speedAura and speedAura.Parent then
		speedAura.Position = character.HumanoidRootPart.Position
	else
		auraConnection:Disconnect()
	end
end)

-- Rayos de velocidad al moverse
local lastPosition = character.HumanoidRootPart.Position
local speedLineConnection = RunService.Heartbeat:Connect(function()
	local currentPosition = character.HumanoidRootPart.Position
	local velocity = (currentPosition - lastPosition).Magnitude
	
	if velocity > 2 then
		for i = 1, 3 do
			local line = Instance.new("Part")
			line.Size = Vector3.new(0.2, 0.2, velocity * 2)
			line.Material = Enum.Material.Neon
			line.Color = config.Color
			line.Anchored = true
			line.CanCollide = false
			line.CFrame = CFrame.new(lastPosition, currentPosition) * 
				CFrame.new(math.random(-2, 2), math.random(-2, 2), -velocity) *
				CFrame.Angles(math.rad(math.random(-30, 30)), 0, 0)
			line.Transparency = 0.3
			line.Parent = workspace
			
			TweenService:Create(line, TweenInfo.new(0.3), {
				Transparency = 1
			}):Play()
			
			Debris:AddItem(line, 0.3)
		end
	end
	
	lastPosition = currentPosition
end)

-- Duración
task.wait(config.Duration)

-- Restaurar velocidad
humanoid.WalkSpeed = originalSpeed

-- Detener efectos
sound:Stop()
afterimageConnection:Disconnect()
auraConnection:Disconnect()
speedLineConnection:Disconnect()

-- Desvanecimiento
TweenService:Create(speedAura, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Transparency = 1,
	Size = Vector3.new(12, 12, 12)
}):Play()

task.delay(0.8, function()
	if speedAura then speedAura:Destroy() end
end)

for _, effect in ipairs(legEffects) do effect:Destroy() end
for _, effect in ipairs(bodyEffects) do effect:Destroy() end
if trail then trail:Destroy() end
if att0 then att0:Destroy() end
if att1 then att1:Destroy() end
```

end

– ===== CONECTAR EVENTOS =====

telekinesisPower.OnServerEvent:Connect(function(player, targetPlayer)
if targetPlayer and targetPlayer:IsA(“Player”) then
useTelekinesis(player, targetPlayer)
end
end)

explosionPower.OnServerEvent:Connect(function(player, targetPlayer)
if targetPlayer and targetPlayer:IsA(“Player”) then
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
if targetPlayer and targetPlayer:IsA(“Player”) then
useHealing(player, targetPlayer)
end
end)

superSpeedPower.OnServerEvent:Connect(function(player)
useSuperSpeed(player)
end)

print(“✓ STRANGER THINGS EPIC POWERS V2.0 LOADED”)
print(“✓ 6 PODERES CON ANIMACIONES ÉPICAS”)
print(“✓ Telekinesis | Explosión | Control Mental | Protección | Curación | Super Velocidad”)
