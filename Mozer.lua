-- ================================================
-- 🎯 MOZER - INFO DISPLAY + PRECISION METHODS
-- ⚡ Shows Gamepasses & Remotes | Method 1 & 6
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
local gameId = game.PlaceId

print("🎯 MOZER - Loading with Info Display...")

-- ================================================
-- 📊 المتغيرات
-- ================================================
local REAL_GAMEPASSES = {}      -- من API الحقيقي
local SELECTED_ID = nil
local SELECTED_NAME = nil
local TARGET_REMOTES = {}       -- الـ Remotes اللي تخص الشراء
local ALL_REMOTES = {}          -- جميع الـ Remotes في اللعبة

-- ================================================
-- 📡 جلب Gamepasses الحقيقية من API
-- ================================================
local function FetchRealGamepasses()
    local url = "https://economy.roblox.com/v1/games/" .. gameId .. "/gamepasses?limit=100"
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and response and response.data then
        REAL_GAMEPASSES = {}
        for _, gp in ipairs(response.data) do
            table.insert(REAL_GAMEPASSES, {
                id = gp.id,
                name = gp.name,
                price = gp.price or 0,
                image = gp.imageUrl or ""
            })
        end
        return true, "✅ Loaded " .. #REAL_GAMEPASSES .. " Gamepasses"
    else
        -- إذا فشل، نعرض رسالة خطأ
        return false, "❌ Failed to load Gamepasses from API"
    end
end

-- ================================================
-- 🔍 تحليل جميع الـ Remotes في اللعبة
-- ================================================
local function AnalyzeAllRemotes()
    ALL_REMOTES = {}
    TARGET_REMOTES = {}
    
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            local fullName = obj:GetFullName()
            
            -- تخزين جميع الـ Remotes
            table.insert(ALL_REMOTES, {
                name = obj.Name,
                className = obj.ClassName,
                path = fullName
            })
            
            -- تخزين الـ Remotes المتعلقة بالشراء بشكل خاص
            if name:find("purchase") or name:find("buy") or name:find("gamepass") or name:find("pass") or name:find("shop") or name:find("product") then
                table.insert(TARGET_REMOTES, obj)
            end
        end
    end
    
    return #TARGET_REMOTES, #ALL_REMOTES
end

-- ================================================
-- ⚔️ METHOD 1 (دقيق)
-- ================================================
local function Method1_ClientBypass()
    if not SELECTED_ID then 
        Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2 })
        return false 
    end
    
    local payload = {
        gamepassId = SELECTED_ID,
        playerId = plr.UserId,
        timestamp = os.time(),
        purchaseType = "Gamepass",
        receipt = HttpService:GenerateGUID(false)
    }
    
    -- إرسال فقط للـ Remotes المنطقية (مرة واحدة)
    for _, remote in pairs(TARGET_REMOTES) do
        pcall(function() remote:FireServer(payload) end)
        pcall(function() remote:FireServer(SELECTED_ID) end)
    end
    
    -- محاولة مباشرة
    pcall(function() MarketplaceService:PromptProductPurchase(plr, SELECTED_ID) end)
    
    return true
end

-- ================================================
-- ⚔️ METHOD 6 (دقيق)
-- ================================================
local function Method6_RemoteReplay()
    if not SELECTED_ID then 
        Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2 })
        return false 
    end
    
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
-- 🎨 RAYFIELD UI (مع معلومات إضافية)
-- ================================================
local Window = Rayfield:CreateWindow({
    Name = "MOZER | Info Display",
    LoadingTitle = "MOZER - Information Mode",
    LoadingSubtitle = "Analyzing Game...",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- ================================================
-- 📋 TAB 1: INFORMATION (معلومات اللعبة)
-- ================================================
local InfoTab = Window:CreateTab("📊 Info", 4483362458)

-- معلومات عامة
InfoTab:CreateParagraph({
    Title = "🎮 Game Information",
    Content = "Game ID: " .. gameId .. "\nPlayer: " .. plr.Name .. "\nStatus: Analyzing..."
})

-- معلومات Gamepasses
local GamepassInfo = InfoTab:CreateParagraph({
    Title = "📦 REAL GAMEPASSES (from Roblox API)",
    Content = "Loading..."
})

-- معلومات Remotes
local RemotesInfo = InfoTab:CreateParagraph({
    Title = "🔌 REMOTES ANALYSIS",
    Content = "Loading..."
})

-- قائمة مفصلة بالـ Remotes
local RemoteList = InfoTab:CreateParagraph({
    Title = "📋 Purchase-Related Remotes",
    Content = "Loading..."
})

-- زر التحديث
InfoTab:CreateButton({
    Name = "🔄 Refresh Information",
    Callback = function()
        Rayfield:Notify({ Title = "Refreshing", Content = "Loading game data...", Duration = 1 })
        
        -- جلب Gamepasses
        local success, msg = FetchRealGamepasses()
        if success then
            local gpText = ""
            for i, gp in ipairs(REAL_GAMEPASSES) do
                gpText = gpText .. i .. ". " .. gp.name .. " [" .. gp.price .. " Robux]\n"
            end
            if gpText == "" then gpText = "No Gamepasses found in this game" end
            GamepassInfo:Set(gpText)
        else
            GamepassInfo:Set(msg)
        end
        
        -- تحليل Remotes
        local targetCount, allCount = AnalyzeAllRemotes()
        RemotesInfo:Set("Total Remotes in game: " .. allCount .. "\nPurchase-related Remotes: " .. targetCount)
        
        -- قائمة الـ Remotes التفصيلية
        local remoteText = ""
        for i, remote in ipairs(TARGET_REMOTES) do
            remoteText = remoteText .. i .. ". " .. remote.Name .. " (" .. remote.ClassName .. ")\n"
        end
        if remoteText == "" then remoteText = "No purchase-related Remotes found" end
        RemoteList:Set(remoteText)
        
        Rayfield:Notify({ Title = "Done", Content = "Game data loaded", Duration = 1 })
    end,
})

-- ================================================
-- 📋 TAB 2: GAMEPASS (اختيار الـ Gamepass)
-- ================================================
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
            local displayName = gp.name .. " [" .. gp.price .. "]"
            if displayName == selectedName then
                SELECTED_ID = gp.id
                SELECTED_NAME = gp.name
                Rayfield:Notify({ Title = "🎯 Target Locked", Content = gp.name, Duration = 2 })
                break
            end
        end
    end,
})

GamepassTab:CreateButton({
    Name = "📡 Fetch Real Gamepasses",
    Callback = function()
        Rayfield:Notify({ Title = "Loading", Content = "Fetching from Roblox API...", Duration = 1 })
        local success, msg = FetchRealGamepasses()
        if success then
            local options = {}
            for _, gp in ipairs(REAL_GAMEPASSES) do
                table.insert(options, gp.name .. " [" .. gp.price .. "]")
            end
            if #options > 0 then
                GamepassDropdown:Refresh(options)
                Rayfield:Notify({ Title = "✅ Loaded", Content = #REAL_GAMEPASSES .. " Gamepasses found", Duration = 2 })
            else
                GamepassDropdown:Refresh({"No Gamepasses Found"})
                Rayfield:Notify({ Title = "⚠️", Content = "No Gamepasses in this game", Duration = 2 })
            end
        else
            GamepassDropdown:Refresh({"API Error - Check console"})
            Rayfield:Notify({ Title = "❌ Error", Content = "Failed to fetch Gamepasses", Duration = 2 })
        end
    end,
})

-- ================================================
-- 💰 TAB 3: ATTACK (Method 1 & 6)
-- ================================================
local AttackTab = Window:CreateTab("⚔️ Attack", 4483362458)

AttackTab:CreateParagraph({
    Title = "🎯 Current Target",
    Content = "No Gamepass Selected"
})

AttackTab:CreateButton({
    Name = "🕵️ METHOD 1 | Client Bypass (Precision)",
    Callback = function()
        if not SELECTED_ID then
            Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2 })
            return
        end
        Method1_ClientBypass()
        Rayfield:Notify({ Title = "✅ METHOD 1", Content = "Executed on: " .. SELECTED_NAME, Duration = 3 })
    end,
})

AttackTab:CreateButton({
    Name = "🔄 METHOD 6 | Remote Replay (Precision)",
    Callback = function()
        if not SELECTED_ID then
            Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2 })
            return
        end
        Method6_RemoteReplay()
        Rayfield:Notify({ Title = "✅ METHOD 6", Content = "Executed on: " .. SELECTED_NAME, Duration = 3 })
    end,
})

AttackTab:CreateParagraph({
    Title = "⚡ Precision Mode Features",
    Content = "• One shot only\n• No spam | No noise\n• Targets only purchase Remotes\n• Real Gamepass data from API"
})

-- ================================================
-- 📋 TAB 4: HELP (شرح)
-- ================================================
local HelpTab = Window:CreateTab("❓ Help", 4483362458)

HelpTab:CreateParagraph({
    Title = "How to Use",
    Content = [[
1. Go to INFO tab → Click "Refresh Information"
   - Shows real Gamepasses from Roblox API
   - Shows all Remotes in the game

2. Go to GAMEPASS tab → Click "Fetch Real Gamepasses"
   - Select your target from the dropdown

3. Go to ATTACK tab → Click METHOD 1 or METHOD 6

4. Watch the notifications for results
    ]]
})

HelpTab:CreateParagraph({
    Title = "What makes this different?",
    Content = [[
✅ Shows REAL Gamepass names and prices
✅ Shows ALL Remotes in the game
✅ Shows purchase-related Remotes only
✅ Method 1: One shot, targeted, no noise
✅ Method 6: Analyzes Remotes before sending
    ]]
})

-- ================================================
-- 🚀 التشغيل التلقائي لجلب المعلومات
-- ================================================
task.spawn(function()
    -- تحليل الـ Remotes أولاً
    local targetCount, allCount = AnalyzeAllRemotes()
    RemotesInfo:Set("Total Remotes in game: " .. allCount .. "\nPurchase-related Remotes: " .. targetCount)
    
    -- جلب Gamepasses
    local success, msg = FetchRealGamepasses()
    if success then
        local gpText = ""
        for i, gp in ipairs(REAL_GAMEPASSES) do
            gpText = gpText .. i .. ". " .. gp.name .. " [" .. gp.price .. " Robux]\n"
            if i >= 20 then 
                gpText = gpText .. "... and " .. (#REAL_GAMEPASSES - 20) .. " more"
                break
            end
        end
        if gpText == "" then gpText = "No Gamepasses found in this game" end
        GamepassInfo:Set(gpText)
        
        -- تجهيز القائمة المنسدلة
        local options = {}
        for _, gp in ipairs(REAL_GAMEPASSES) do
            table.insert(options, gp.name .. " [" .. gp.price .. "]")
        end
        if #options > 0 then
            GamepassDropdown:Refresh(options)
        end
    else
        GamepassInfo:Set(msg)
    end
    
    -- قائمة الـ Remotes
    local remoteText = ""
    for i, remote in ipairs(TARGET_REMOTES) do
        remoteText = remoteText .. i .. ". " .. remote.Name .. " (" .. remote.ClassName .. ")\n"
        if i >= 15 then
            remoteText = remoteText .. "... and " .. (#TARGET_REMOTES - 15) .. " more"
            break
        end
    end
    if remoteText == "" then remoteText = "No purchase-related Remotes found" end
    RemoteList:Set(remoteText)
    
    print("\n" .. string.rep("=", 50))
    print("🔥 MOZER - Ready")
    print("📊 " .. #REAL_GAMEPASSES .. " Gamepasses found")
    print("🔌 " .. #TARGET_REMOTES .. " purchase Remotes found")
    print(string.rep("=", 50))
end)

print("✅ MOZER Loaded - Check the INFO tab to understand the game")
