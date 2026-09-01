local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Stratxgy/PepsiUI/refs/heads/main/pepsi.lua"
))()

_G.GunModToggles = {
    FastFire = false,
    InfRange = false,
    NoSpread = false,
}

local Window = Library:CreateWindow({ Name = "PrimeHook" })
local GunMods = Window:CreateTab({ Name = "GunMods" })
local Section = GunMods:CreateSection({ Name = "Gun Mods", Side = "Left" })

Section:AddToggle({
    Name = "FastFire",
    Side = "Left",
    Callback = function()
        _G.GunModToggles.FastFire = not _G.GunModToggles.FastFire
        print("FastFire:", _G.GunModToggles.FastFire)
    end
})

Section:AddToggle({
    Name = "Inf Range",
    Side = "Left",
    Callback = function()
        _G.GunModToggles.InfRange = not _G.GunModToggles.InfRange
        print("Inf Range:", _G.GunModToggles.InfRange)
    end
})

Section:AddToggle({
    Name = "NoSpread",
    Side = "Left",
    Callback = function()
        _G.GunModToggles.NoSpread = not _G.GunModToggles.NoSpread
        print("NoSpread:", _G.GunModToggles.NoSpread)
    end
})
