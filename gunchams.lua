-- ============================================
--  gunchams.lua – PrimeHook
--  Handles neon chams for weapons
-- ============================================

local function getPlayerWeapons()
    local player = game.Players.LocalPlayer
    local weapons = {}
    local weaponNames = {
        "Handcuffs", "M9", "Taser", "MP5", "Remington 870", "AK-47"
    }
    -- Backpack
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and table.find(weaponNames, tool.Name) then
            table.insert(weapons, tool)
        end
    end
    -- Equipped weapon
    local char = player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and table.find(weaponNames, tool.Name) then
                table.insert(weapons, tool)
            end
        end
    end
    return weapons
end

-- State
local originalProps = {}
local isEnabled = false
local currentColor = Color3.fromRGB(0, 255, 0)

local function applyChamsToModel(model, color)
    if originalProps[model] then return end
    local props = {}
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            props[part] = {
                Material = part.Material,
                BrickColor = part.BrickColor,
                Color = part.Color,
            }
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.new(color)
            part.Color = color
        end
    end
    originalProps[model] = props
end

local function removeChamsFromModel(model)
    local props = originalProps[model]
    if not props then return end
    for part, original in pairs(props) do
        if part and part.Parent then
            part.Material = original.Material
            part.BrickColor = original.BrickColor
            part.Color = original.Color
        end
    end
    originalProps[model] = nil
end

local function applyToAll()
    local weapons = getPlayerWeapons()
    for _, tool in ipairs(weapons) do
        applyChamsToModel(tool, currentColor)
    end
end

local function removeAll()
    for model, _ in pairs(originalProps) do
        removeChamsFromModel(model)
    end
end

-- Exposed API
_G.GunChams = {
    Enable = function()
        if isEnabled then return end
        isEnabled = true
        applyToAll()
    end,
    Disable = function()
        if not isEnabled then return end
        isEnabled = false
        removeAll()
    end,
    Toggle = function()
        if isEnabled then
            _G.GunChams.Disable()
        else
            _G.GunChams.Enable()
        end
    end,
    SetColor = function(color)
        currentColor = color
        if isEnabled then
            -- Update all existing chammed parts
            for model, props in pairs(originalProps) do
                for part, _ in pairs(props) do
                    if part and part.Parent then
                        part.BrickColor = BrickColor.new(color)
                        part.Color = color
                    end
                end
            end
        end
    end,
    IsEnabled = function()
        return isEnabled
    end
}

-- Listen for new weapons added
local player = game.Players.LocalPlayer
player.Backpack.ChildAdded:Connect(function(weapon)
    if isEnabled and weapon:IsA("Tool") and table.find({"Handcuffs","M9","Taser","MP5","Remington 870","AK-47"}, weapon.Name) then
        applyChamsToModel(weapon, currentColor)
    end
end)

print("[PrimeHook] GunChams loaded.")
