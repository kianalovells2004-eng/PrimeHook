-- =============================================
--  PrimeHook Loader
-- =============================================

print("[PrimeHook] Loader started.")

local BASE_URL = "https://raw.githubusercontent.com/kianalovells2004-eng/PrimeHook/main/"

local modules = {
    { name = "UI",       file = "ui.lua" },
    { name = "GunChams", file = "gunchams.lua" },
    { name = "GunMod",   file = "gunmod.lua" },
}

local function loadModule(name, url)
    print("[PrimeHook] Loading " .. name .. " from " .. url)

    local success, result = pcall(game.HttpGet, game, url .. "?t=" .. tick())

    if not success then
        warn("[PrimeHook] Failed to fetch " .. name .. ": " .. tostring(result))
        return false
    end

    local func, err = loadstring(result)
    if not func then
        warn("[PrimeHook] Failed to compile " .. name .. ": " .. tostring(err))
        return false
    end

    local ok, execErr = pcall(func)
    if not ok then
        warn("[PrimeHook] Failed to execute " .. name .. ": " .. tostring(execErr))
        return false
    end

    print("[PrimeHook] " .. name .. " loaded successfully.")
    return true
end

local allLoaded = true
for _, mod in ipairs(modules) do
    local url = BASE_URL .. mod.file
    local ok = loadModule(mod.name, url)
    if not ok then
        allLoaded = false
        warn("[PrimeHook] " .. mod.name .. " failed to load – continuing anyway.")
    end
end

if allLoaded then
    print("[PrimeHook] All modules loaded successfully.")
else
    print("[PrimeHook] Some modules failed – but others may still work.")
end
