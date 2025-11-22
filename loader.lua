-- === ADVANCED PLOT UNIQUE ITEM SCANNER ===
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- CHANGE THIS if needed:
local PLotsFolderName = "Plots"  -- <-- Palitan kung iba ang folder name

local PlotsFolder = workspace:FindFirstChild(PLotsFolderName)
if not PlotsFolder then
    warn("❌ Plots folder not found. Palitan mo ang PLotsFolderName.")
    return
end

-- Find which plot you are standing on
local function findMyPlot()
    for _, plot in ipairs(PlotsFolder:GetChildren()) do
        if plot:IsA("Model") then
            local primary = plot.PrimaryPart or plot:FindFirstChildWhichIsA("BasePart")
            if primary then
                local distance = (primary.Position - root.Position).Magnitude
                if distance < 80 then
                    return plot
                end
            end
        end
    end
    return nil
end

local myPlot = findMyPlot()
if not myPlot then
    warn("❌ Hindi kita makita sa kahit anong plot. Tumayo sa loob ng plot mo at i-run ulit.")
    return
end

print("====== ADVANCED PLOT SCANNER ======")
print("📌 Your Plot: ", myPlot.Name)
print("Scanning...\n")

-- Count items inside one plot
local function countItemsInPlot(plot)
    local counts = {}
    for _, item in ipairs(plot:GetDescendants()) do
        if item.Name and item.Name ~= "" then
            counts[item.Name] = (counts[item.Name] or 0) + 1
        end
    end
    return counts
end

-- Get counts for your plot
local myCounts = countItemsInPlot(myPlot)

-- Scan all other plots
local otherPlots = {}
for _, plot in ipairs(PlotsFolder:GetChildren()) do
    if plot ~= myPlot and plot:IsA("Model") then
        otherPlots[plot.Name] = countItemsInPlot(plot)
    end
end

print("=== YOUR UNIQUE ITEMS (count=1) ===")
for name, count in pairs(myCounts) do
    if count == 1 then
        print("⭐ UNIQUE:", name)
    end
end

print("\n=== ITEMS OTHER PLOTS HAVE BUT YOU DON'T ===")
local missing = {}
for plotName, counts in pairs(otherPlots) do
    for name, count in pairs(counts) do
        if not myCounts[name] then
            missing[name] = true
        end
    end
end

for name in pairs(missing) do
    print("❗ Wala ka nito:", name)
end

print("\n=== ITEMS THAT ONLY YOU HAVE (super unique) ===")
local onlyYours = {}

for name, _ in pairs(myCounts) do
    local foundInOthers = false
    for _, counts in pairs(otherPlots) do
        if counts[name] then
            foundInOthers = true
            break
        end
    end
    if not foundInOthers then
        onlyYours[name] = true
    end
end

for name in pairs(onlyYours) do
    print("🟦 Only you have:", name)
end

print("\n=== PER-PLOT UNIQUE ITEMS ===")
for plotName, counts in pairs(otherPlots) do
    print("\nPlot:", plotName)
    for name, count in pairs(counts) do
        if count == 1 then
            print(" 🔶 Unique in this plot:", name)
        end
    end
end

print("\n✅ Done scanning all plots.")
print("=====================================")
