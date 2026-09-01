-- ============================================
--  gunmod.lua – PrimeHook
--  Overrides GunTracers module – RGB with slow fade
-- ============================================

-- ---------- 1. Attribute hook (FastFire, Inf Range, NoSpread) ----------
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "GetAttributes" then
        local result = oldNamecall(self, unpack(args))

        if typeof(result) == "table" then
            local toggles = _G.GunModToggles or {}

            if toggles.FastFire then
                result.AutoFire = true
                result.FireRate = 0.05
            end

            if toggles.InfRange then
                result.Range = 9999999999
                result.AccurateRange = 9999999999
            end

            if toggles.NoSpread then
                result.Spread = 0
                result.SpreadRadius = 0
            end
        end
        return result
    end

    return oldNamecall(self, ...)
end))

-- ---------- 2. Override GunTracers module (RGB + slow fade) ----------
local replicatedStorage = game:GetService("ReplicatedStorage")
local gunTracersModule = replicatedStorage:FindFirstChild("SharedModules") and replicatedStorage.SharedModules:FindFirstChild("GunTracers")

if gunTracersModule then
    -- Save originals
    local originalCreateBullet = gunTracersModule.createBullet
    local originalCreateTaser  = gunTracersModule.createTaser
    local originalCreateSniper = gunTracersModule.createSniper

    -- Helper: create beam with custom colour & fade
    local function createCustomBeam(startPos, endPos, color, fadeDuration, size)
        local part = Instance.new("Part")
        part.Name = "RayPart"
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.Transparency = 0.3
        part.formFactor = Enum.FormFactor.Custom
        part.Size = Vector3.new(size, size, (startPos - endPos).Magnitude)
        part.CFrame = CFrame.lookAt((startPos + endPos) / 2, endPos) * CFrame.new(0, 0, -(startPos - endPos).Magnitude / 2)
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.BrickColor = BrickColor.new(color)  -- accepts Color3

        -- Glow light
        local light = Instance.new("SurfaceLight", part)
        light.Color = color
        light.Range = 7
        light.Face = "Bottom"
        light.Brightness = 5
        light.Angle = 180

        -- Fade out slowly
        local tweenService = game:GetService("TweenService")
        local fadeTween = tweenService:Create(part, TweenInfo.new(fadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Transparency = 1 })
        local lightTween = tweenService:Create(light, TweenInfo.new(fadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Brightness = 0 })
        fadeTween:Play()
        lightTween:Play()

        game:GetService("Debris"):AddItem(part, fadeDuration + 0.2)
        part.Parent = workspace.CurrentCamera   -- exactly where the game puts it
    end

    -- Override createBullet
    gunTracersModule.createBullet = function(p1, p2)
        local toggles = _G.GunModToggles or {}
        if toggles.RgbTracer then
            local randomColor = Color3.new(math.random(), math.random(), math.random())
            createCustomBeam(p1, p2, randomColor, 2.0, 0.2)   -- 2 sec fade
        else
            originalCreateBullet(p1, p2)
        end
    end

    -- Override createTaser
    gunTracersModule.createTaser = function(p1, p2)
        local toggles = _G.GunModToggles or {}
        if toggles.RgbTracer then
            local randomColor = Color3.new(math.random(), math.random(), math.random())
            createCustomBeam(p1, p2, randomColor, 2.5, 0.25)  -- 2.5 sec fade
        else
            originalCreateTaser(p1, p2)
        end
    end

    -- Override createSniper
    gunTracersModule.createSniper = function(p1, p2)
        local toggles = _G.GunModToggles or {}
        if toggles.RgbTracer then
            local randomColor = Color3.new(math.random(), math.random(), math.random())
            createCustomBeam(p1, p2, randomColor, 3.0, 0.15)  -- 3 sec fade
        else
            originalCreateSniper(p1, p2)
        end
    end

    print("✅ RGB Tracer override installed – slow fade enabled!")
else
    warn("❌ GunTracers module not found – RGB tracers won't work.")
end
