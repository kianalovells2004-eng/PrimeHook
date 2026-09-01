-- This script assumes _G.GunModToggles exists

-- -------- Attribute hook (unchanged) --------
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

-- -------- Bullet Tracer (remote hook) --------
local remote = game:GetService("ReplicatedStorage"):WaitForChild("GunRemotes"):WaitForChild("ShootEvent")

if remote then
    local originalFire = remote.FireServer
    remote.FireServer = function(self, data)
        -- Check if tracer is enabled
        if _G.GunModToggles and _G.GunModToggles.Tracer then
            -- Data structure: {{startVector, endVector, part}}
            if type(data) == "table" and #data >= 2 then
                local startPos = data[1]
                local endPos = data[2]

                if typeof(startPos) == "Vector3" and typeof(endPos) == "Vector3" then
                    -- Create a beam (part) between the two points
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(0.2, 0.2, (endPos - startPos).Magnitude)
                    part.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -(endPos - startPos).Magnitude / 2)
                    part.BrickColor = BrickColor.new("Bright violet") -- purple
                    part.Material = Enum.Material.Neon
                    part.Anchored = true
                    part.CanCollide = false
                    part.Transparency = 0

                    -- Tween fade out
                    local tweenInfo = TweenInfo.new(
                        0.4,                           -- duration
                        Enum.EasingStyle.Linear,
                        Enum.EasingDirection.InOut,
                        0,
                        false,
                        0
                    )
                    local tween = game:GetService("TweenService"):Create(
                        part,
                        tweenInfo,
                        { Transparency = 1 }
                    )
                    tween:Play()
                    tween.Completed:Wait()
                    part:Destroy()
                end
            end
        end

        -- Call the original FireServer
        return originalFire(self, data)
    end
else
    warn("ShootEvent remote not found – tracer disabled")
end
