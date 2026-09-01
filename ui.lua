-- Load PepsiUI
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Stratxgy/PepsiUI/refs/heads/main/pepsi.lua"
))()

-- Shared state (accessible from gunmod.lua)
_G.GunModToggles = {
    FastFire = false,
    InfRange = false,
    NoSpread = false,
}

-- Create the window
local Window = Library:CreateWindow({
    Name = "PrimeHook",
})

local GunMods = Window:CreateTab({
    Name = "GunMods"
})

local Section = GunMods:CreateSection({
    Name = "Gun Mods",
    Side = "Left"
})

-- FastFire toggle
Section:AddToggle({
    Name = "FastFire",
    Side = "Left",
    Callback = function()
        _G.GunModToggles.FastFire = not _G.GunModToggles.FastFire
        print("FastFire:", _G.GunModToggles.FastFire)
    end
})

-- Inf Range toggle
Section:AddToggle({
    Name = "Inf Range",
    Side = "Left",
    Callback = function()
        _G.GunModToggles.InfRange = not _G.GunModToggles.InfRange
        print("Inf Range:", _G.GunModToggles.InfRange)
    end
})

-- NoSpread toggle
Section:AddToggle({
    Name = "NoSpread",
    Side = "Left",
    Callback = function()
        _G.GunModToggles.NoSpread = not _G.GunModToggles.NoSpread
        print("NoSpread:", _G.GunModToggles.NoSpread)
    end
})

-- Load the gun modifier logic (after UI is ready)
-- Make sure the path matches your repo's raw URL
loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/yourrepo/main/gunmod.lua"))()
