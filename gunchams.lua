-- gunchams.lua – applies neon glow to specific weapon mesh parts
local chamsEnabled = false
local chamColor = Color3.fromRGB(0, 255, 0)  -- default green
local originalProps = {}  -- part -> {Material, BrickColor, Color}

-- Mapping weapon names to their mesh part paths inside workspace.yearningfortears
local meshPaths = {
    ["Remington 870"] = "Meshes/r870_2",
    ["M9"] = "Meshes/M9_3",
    ["MP5"] = "GunMesh",
    ["AK-47"] = "Meshes/AK47_7"
}

-- Helper: get the actual part from the path
local function getMeshPart(weaponName)
    local weapon = workspace:FindFirstChild("yearningfortears") and workspace.yearningfortears:FindFirstChild(weaponName)
    if not weapon then return nil end
    local path = meshPaths[weaponName]
    if not path then return nil end

    local current = weapon
    for partName in path:gmatch("[^/]+") do
        current = current:FindFirstChild(partName)
        if not current then return nil end
    end
    if current:IsA("BasePart") then
        return current
    end
    return nil
end

-- Apply neon to all parts
local function applyChams()
    for weaponName, _ in pairs(meshPaths) do
        local part = getMeshPart(weaponName)
        if part then
            -- Save original if not already saved
            if not originalProps[part] then
                originalProps[part] = {
                    Material = part.Material,
                    BrickColor = part.BrickColor,
                    Color = part.Color,
                }
            end
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.new(chamColor)
            part.Color = chamColor
        end
    end
end

-- Revert all parts
local function removeChams()
    for part, props in pairs(originalProps) do
        if part and part.Parent then
            part.Material = props.Material
            part.BrickColor = props.BrickColor
            part.Color = props.Color
        end
    end
    originalProps = {}
end

-- Update color of already chammed parts
local function updateChamsColor(color)
    chamColor = color
    if chamsEnabled then
        for part, _ in pairs(originalProps) do
            if part and part.Parent then
                part.BrickColor = BrickColor.new(color)
                part.Color = color
            end
        end
    end
end

-- Toggle on/off
local function toggleChams(enable)
    chamsEnabled = enable
    if enable then
        applyChams()
    else
        removeChams()
    end
end

-- Expose functions globally for UI to call
_G.GunChams = {
    toggle = toggleChams,
    setColor = updateChamsColor,
    isEnabled = function() return chamsEnabled end,
}

print("[GunChams] Loaded successfully.")
