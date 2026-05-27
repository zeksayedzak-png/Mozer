-- ================================================
-- 🎯 MOZER - RAYFIELD MOBILE EDITION
-- ⚡ METHOD 1 & 6 | PRECISION | ZERO NOISE
-- 📱 OPTIMIZED FOR TOUCH (Delta Executor)
-- ================================================

-- تحميل Rayfield (آخر نسخة متوافقة مع المحمول)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local plr = Players.LocalPlayer
local gameId = game.PlaceId

print("🎯 Loading MOZER - Rayfield Mobile Edition...")

-- ================================================
-- 📊 REAL GAMEPASS DATABASE
-- ================================================
local REAL_GAMEPASSES = {}
local SELECTED_ID = nil
local SELECTED_NAME = nil

local function FetchGamepasses()
    local url = "https://economy.roblox.com/v1/games/" .. gameId .. "/gamepasses?limit=100"
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if success and response and response.data then
        REAL_GAMEPASSES = {}
        for _, gp in ipairs(response.data) do
            table.insert(REAL_GAMEPASSES, {id = gp.id, name = gp.name, price = gp.price or 0})
        end
        return true
    end
    return false
end

-- ================================================
-- 🔍 REMOTE ANALYZER (لـ Method 6)
-- ================================================
local TARGET_REMOTES = {}

local function AnalyzePurchaseRemotes()
    TARGET_REMOTES = {}
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            if name:find("purchase") or name:find("buy") or name:find("gamepass") or name:find("pass") or name:find("shop") or name:find("product") then
                table.insert(TARGET_REMOTES, obj)
            end
        end
    end
    return #TARGET_REMOTES
end

-- ================================================
-- ⚔️ METHOD 1: Client Bypass (مرة واحدة، دقيق)
-- ================================================
local function Method1_ClientBypass()
    if not SELECTED_ID then return false end
    
    local payload = {
        gamepassId = SELECTED_ID,
        playerId = plr.UserId,
        timestamp = os.time(),
        purchaseType = "Gamepass",
        receipt = HttpService:GenerateGUID(false)
    }
    
    for _, remote in pairs(TARGET_REMOTES) do
        pcall(function() remote:FireServer(payload) end)
        pcall(function() remote:FireServer(SELECTED_ID) end)
    end
    
    pcall(function() MarketplaceService:PromptProductPurchase(plr, SELECTED_ID) end)
    return true
end

-- ================================================
-- ⚔️ METHOD 6: Remote Replay (مطور)
-- ================================================
local function Method6_RemoteReplay()
    if not SELECTED_ID then return false end
    
    local learnedPayload = {
        gamepassId = SELECTED_ID,
        playerId = plr.UserId,
        action = "purchase",
        version = "2.0",
        signature = HttpService:GenerateGUID(false)
    }
    
    for _, remote in pairs(TARGET_REMOTES) do
        pcall(function()
            remote:FireServer(learnedPayload)
            remote:FireServer({learnedPayload})
            remote:FireServer(SELECTED_ID, learnedPayload)
        end)
        task.wait(0.05)
    end
    return true
end

-- ================================================
-- 🎨 RAYFIELD UI (لللمس على الهاتف)
-- ================================================
local Window = Rayfield:CreateWindow({
    Name = "Mozer | Delta Arsenal",
    LoadingTitle = "MOZER - PRECISION EDITION",
    LoadingSubtitle = "Method 1 & 6 | Zero Noise",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

-- 📋 TAB: GAMEPASS
local GamepassTab = Window:CreateTab("🎮 Gamepass", 4483362458)

local GamepassDropdown = GamepassTab:CreateDropdown({
    Name = "Select Real Gamepass",
    Options = {"Loading..."},
    CurrentOption = {"Loading..."},
    MultipleOptions = false,
    Flag = "GamepassDropdown",
    Callback = function(Option)
        local selectedName = Option[1]
        for _, gp in ipairs(REAL_GAMEPASSES) do
            local displayName = gp.name .. " [" .. gp.price .. " Robux]"
            if displayName == selectedName then
                SELECTED_ID = gp.id
                SELECTED_NAME = gp.name
                Rayfield:Notify({
                    Title = "🎯 Target Locked",
                    Content = gp.name,
                    Duration = 2
                })
                break
            end
        end
    end,
})

GamepassTab:CreateButton({
    Name = "🔄 Refresh Gamepasses",
    Callback = function()
        Rayfield:Notify({Title = "Fetching", Content = "Loading from Roblox API...", Duration = 1})
        FetchGamepasses()
        local options = {}
        for _, gp in ipairs(REAL_GAMEPASSES) do
            table.insert(options, gp.name .. " [" .. gp.price .. " Robux]")
        end
        GamepassDropdown:Refresh(options)
        Rayfield:Notify({Title = "✅ Loaded", Content = #REAL_GAMEPASSES .. " Gamepasses found", Duration = 2})
    end,
})

-- 💥 TAB: ATTACK METHODS
local AttackTab = Window:CreateTab("⚔️ Attack", 4483362458)

AttackTab:CreateParagraph({
    Title = "Current Target",
    Content = "No Gamepass Selected"
})

AttackTab:CreateButton({
    Name = "🕵️ METHOD 1 | Client Bypass",
    Callback = function()
        if not SELECTED_ID then
            Rayfield:Notify({Title = "❌ Error", Content = "Select a Gamepass first!", Duration = 2})
            return
        end
        Method1_ClientBypass()
        Rayfield:Notify({Title = "✅ METHOD 1", Content = "Executed on: " .. SELECTED_NAME, Duration = 3})
    end,
})

AttackTab:CreateButton({
    Name = "🔄 METHOD 6 | Remote Replay",
    Callback = function()
        if not SELECTED_ID then
            Rayfield:Notify({Title = "❌ Error", Content = "Select a Gamepass first!", Duration = 2})
            return
        end
        Method6_RemoteReplay()
        Rayfield:Notify({Title = "✅ METHOD 6", Content = "Executed on: " .. SELECTED_NAME, Duration = 3})
    end,
})

AttackTab:CreateParagraph({
    Title = "⚡ Precision Mode",
    Content = "• One shot only\n• No spam | No noise\n• Real Gamepass data"
})

-- ℹ️ INFO TAB
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)

InfoTab:CreateParagraph({
    Title = "Mozer - Delta Arsenal",
    Content = "Version: 2.0\nMethods: 1 & 6\nMode: Precision\nNoise: Zero\nOptimized for: Mobile + Delta"
})

-- ================================================
-- 🚀 STARTUP
-- ================================================
FetchGamepasses()
task.wait(1)

local options = {}
for _, gp in ipairs(REAL_GAMEPASSES) do
    table.insert(options, gp.name .. " [" .. gp.price .. " Robux]")
end
if #options > 0 then
    GamepassDropdown:Refresh(options)
else
    GamepassDropdown:Refresh({"No Gamepasses Found"})
end

AnalyzePurchaseRemotes()

print("✅ MOZER - Rayfield Mobile Edition Ready")
print("⚡ Methods 1 & 6 | Zero Noise | Precision Mode")
