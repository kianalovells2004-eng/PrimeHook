-- ═══════════════════════════════════════════
--  PrimeHook Loader v1.0
-- ═══════════════════════════════════════════

print("🚀 PrimeHook Loader v1.0")
print("🔗 Fetching modules from GitHub...")

-- ═══ CONFIGURATION ═══
-- 🔴 CHANGE THIS to your actual GitHub repo raw URL
local BASE_URL = "https://raw.githubusercontent.com/kianalovells2004-eng/PrimeHook/main/"
-- ═════════════════════

local modules = {
    { name = "UI",         file = "ui.lua" },
    { name = "GunMod",     file = "gunmod.lua" },
}

local function loadModule(name, url)
    print("📥 Loading " .. name .. " from " .. url .. "...")

    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("❌ Failed to fetch " .. name .. ": " .. tostring(result))
        return false
    end

    local func, compileErr = loadstring(result)
    if not func then
        warn("❌ Failed to compile " .. name .. ": " .. tostring(compileErr))
        return false
    end

    local execSuccess, execErr = pcall(func)
    if not execSuccess then
        warn("❌ Failed to execute " .. name .. ": " .. tostring(execErr))
        return false
    end

    print("✅ " .. name .. " loaded successfully!")
    return true
end

-- Load modules in order (UI first, then GunMod)
local allLoaded = true
for _, mod in ipairs(modules) do
    local url = BASE_URL .. mod.file
    local ok = loadModule(mod.name, url)
    if not ok then
        allLoaded = false
        warn("⚠️ Stopping loader due to failure in " .. mod.name)
        break
    end
end

if allLoaded then
    print("🎯 PrimeHook fully loaded! Enjoy.")
else
    warn("🛑 PrimeHook failed to load completely. Check the errors above.")
end
