local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Stratxgy/PepsiUI/refs/heads/main/pepsi.lua"
))()

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

Section:AddSlider({
    Name = "Range",
    Value = 0,
    Min = 0,
    Max = 999999,
    Callback = function(value)
        print("Range:", value)
    end
})

Section:AddSlider({
    Name = "Spread",
    Value = 0,
    Min = 0,
    Max = 999999,
    Callback = function(value)
        print("Spread:", value)
    end
})

Section:AddSlider({
    Name = "Accurate Range",
    Value = 0,
    Min = 0,
    Max = 999999,
    Callback = function(value)
        print("AccurateRange:", value)
    end
})

Section:AddSlider({
    Name = "Spread Radius",
    Value = 0,
    Min = 0,
    Max = 999999,
    Callback = function(value)
        print("SpreadRadius:", value)
    end
})

Section:AddSlider({
    Name = "Fire Rate",
    Value = 0,
    Min = 0,
    Max = 999999,
    Callback = function(value)
        print("FireRate:", value)
    end
})
