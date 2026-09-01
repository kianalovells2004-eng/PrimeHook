-- This script assumes _G.GunModToggles exists

-- ---------- 1. Attribute hook (unchanged) ----------
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

-- ---------- 2. Intercept the game's GunTracers module ----------
local replicatedStorage = game:GetService("ReplicatedStorage")
local gunTracersModule = replicatedStorage:FindFirstChild("SharedModules") and replicatedStorage.SharedModules:FindFirstChild("GunTracers")

if gunTracersModule then
    -- Store original functions
    local originalCreateBullet = gunTracersModule.createBullet
    local originalCreateTaser = gunTracersModule.createTaser
    local originalCreateSniper = gunTracersModule.createSniper

    -- Helper: create a beam with custom color and fade
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
        part.BrickColor = BrickColor.new(color)  -- you can also pass a Color3

        -- Add a light (optional)
        local light = Instance.new("SurfaceLight", part)
        light.Color = color
        light.Range = 7
        light.Face = "Bottom"
        light.Brightness = 5
        light.Angle = 180

        -- Fade out
        local tweenService = game:GetService("TweenService")
        local fadeTween = tweenService:Create(part, TweenInfo.new(fadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Transparency = 1 })
        local lightTween = tweenService:Create(light, TweenInfo.new(fadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Brightness = 0 })
        fadeTween:Play()
        lightTween:Play()

        -- Clean up after fade
        game:GetService("Debris"):AddItem(part, fadeDuration + 0.2)
        part.Parent = workspace.CurrentCamera
    end

    -- Override createBullet (the most common)
    gunTracersModule.createBullet = function(p1, p2)
        local toggles = _G.GunModToggles or {}
        if toggles.RgbTracer then
            -- Random RGB color
            local color = Color3.new(math.random(), math.random(), math.random())
            createCustomBeam(p1, p2, color, 1.0, 0.2)  -- slow fade over 1s, thicker
        else
            -- Call original
            originalCreateBullet(p1, p2)
        end
    end

    -- Override createTaser (cyan taser)
    gunTracersModule.createTaser = function(p1, p2)
        local toggles = _G.GunModToggles or {}
        if toggles.RgbTracer then
            local color = Color3.new(math.random(), math.random(), math.random())
            createCustomBeam(p1, p2, color, 1.5, 0.25)  -- even slower fade
        else
            originalCreateTaser(p1, p2)
        end
    end

    -- Override createSniper (grey sniper)
    gunTracersModule.createSniper = function(p1, p2)
        local toggles = _G.GunModToggles or {}
        if toggles.RgbTracer then
            local color = Color3.new(math.random(), math.random(), math.random())
            createCustomBeam(p1, p2, color, 2.0, 0.15)  -- long fade
        else
            originalCreateSniper(p1, p2)
        end
    end

    print("✅ RGB Tracer override installed!")
else
    warn("❌ GunTracers module not found – RGB tracers won't work.")
end

-- (Optional: keep your original ShootEvent hook if you still want it for something else)
-- Your old tracer hook can stay or be removed – it won't interfere.
