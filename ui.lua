local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Stratxgy/PepsiUI/refs/heads/main/pepsi.lua"
))()

_G.GunModToggles = {
    FastFire = false,
    InfRange = false,
    NoSpread = false,
}

local Window = Library:CreateWindow({ Name = "PrimeHook" })

-- ===== GunMods Tab =====
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

-- ===== Misc Tab =====
local Misc = Window:CreateTab({ Name = "Misc" })
local MiscSection = Misc:CreateSection({ Name = "Visuals", Side = "Left" })

-- Chams colour state
local chamColor = Color3.fromRGB(0, 255, 0)

MiscSection:AddToggle({
    Name = "GunChams",
    Side = "Left",
    Callback = function()
        if _G.GunChams then
            _G.GunChams.Toggle()
            print("GunChams:", _G.GunChams.IsEnabled())
        else
            warn("GunChams module not loaded.")
        end
    end
})

MiscSection:AddSlider({
    Name = "R",
    Value = 0,
    Min = 0,
    Max = 255,
    Side = "Left",
    Callback = function(value)
        chamColor = Color3.fromRGB(value, chamColor.G * 255, chamColor.B * 255)
        if _G.GunChams then
            _G.GunChams.SetColor(chamColor)
        end
    end
})

MiscSection:AddSlider({
    Name = "G",
    Value = 255,
    Min = 0,
    Max = 255,
    Side = "Left",
    Callback = function(value)
        chamColor = Color3.fromRGB(chamColor.R * 255, value, chamColor.B * 255)
        if _G.GunChams then
            _G.GunChams.SetColor(chamColor)
        end
    end
})

MiscSection:AddSlider({
    Name = "B",
    Value = 0,
    Min = 0,
    Max = 255,
    Side = "Left",
    Callback = function(value)
        chamColor = Color3.fromRGB(chamColor.R * 255, chamColor.G * 255, value)
        if _G.GunChams then
            _G.GunChams.SetColor(chamColor)
        end
    end
})
