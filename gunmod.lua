-- ============================================
--  gunmod.lua – PrimeHook
--  Only attribute modifications (FastFire, Inf Range, NoSpread)
-- ============================================

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

print("✅ GunMod loaded – FastFire, Inf Range, NoSpread enabled.")
