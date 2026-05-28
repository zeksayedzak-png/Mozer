-- ================================================
-- 🎮 MOZER HUB v2 - ORIGINAL SCRIPT + NEW UI
-- ⚡ 7 STEALTH EXPLOIT METHODS (UNMODIFIED)
-- ================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local plr = Players.LocalPlayer

-- ================================================
-- 📊 المتغيرات الأصلية
-- ================================================
local GAMEPASS_LIST = {}
local SELECTED_GAMEPASS = nil
local SELECTED_GAMEPASS_NAME = "None"
local ATTACK_HISTORY = {}

-- ================================================
-- 🛡️ PROTECTION (زي الأصلي)
-- ================================================
task.spawn(function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService.Teleport = function() return false end

    _G.RobloxSecurity = { Scan = function() return {threats = 0, status = "clean"} end }
    _G.AntiExploit = { active = false }
    _G.CheatDetector = { Scan = function() return {cheats = 0} end }
end)

-- ================================================
-- 🎯 GAMEPASS DATABASE (زي الأصلي)
-- ================================================
local function LOAD_GAMEPASSES()
    GAMEPASS_LIST = {}
    local ids = {588368, 588369, 588370, 588371, 588372, 588373, 588374, 588375, 588376, 588377, 588378, 588379, 588380, 588381, 588382, 588383, 588384, 588385, 588386, 588387, 1000001, 1000002, 1000003, 1000004, 1000005}
    for _, id in ipairs(ids) do
        table.insert(GAMEPASS_LIST, { id = id, name = "Gamepass #" .. id })
    end
    return GAMEPASS_LIST
end

-- ================================================
-- ⚔️ ARSENAL: 7 EXPLOIT METHODS (الأصلية)
-- ================================================
local ARSENAL = {
    Method1_ClientBypass = function(id)
        local payload = { gamepassId = id, playerId = plr.UserId, timestamp = os.time(), purchaseType = "Gamepass" }
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                pcall(function() remote:FireServer(payload) end)
            end
        end
        return true
    end,

    Method2_PromptFlood = function(id)
        for i = 1, 50 do
            task.spawn(function()
                pcall(function() MarketplaceService:PromptProductPurchase(plr, id) end)
            end)
        end
        return true
    end,

    Method3_ReceiptForgery = function(id)
        local fakeReceipt = {
            ReceiptId = "RBLX_" .. os.time() .. "_" .. math.random(100000, 999999),
            ProductId = id, PlayerId = plr.UserId, Amount = 0, Currency = "ROBUX",
            Status = "Completed", PurchaseDate = DateTime.now():ToIsoDate(),
            Signature = HttpService:GenerateGUID(false)
        }
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and remote.Name:lower():find("receipt") then
                pcall(function() remote:FireServer(fakeReceipt) end)
            end
        end
        pcall(function()
            DataStoreService:GetDataStore("Purchases"):SetAsync("rcpt_" .. plr.UserId .. "_" .. id, fakeReceipt)
        end)
        return true
    end,

    Method4_MemoryInjection = function(id)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then
                pcall(function()
                    local fakeData = Instance.new("Folder")
                    fakeData.Name = "Purchase_" .. id
                    fakeData.Parent = player
                    task.wait(0.1)
                    fakeData:Destroy()
                end)
            end
        end
        return true
    end,

    Method5_DataStoreOverload = function(id)
        local stores = {"GamepassOwnership", "PlayerPurchases", "UserData", "Inventory", "ProductData"}
        for _, storeName in ipairs(stores) do
            pcall(function()
                local store = DataStoreService:GetDataStore(storeName)
                store:SetAsync("owned_" .. plr.UserId .. "_" .. id, {owned = true, time = os.time()})
            end)
        end
        return true
    end,

    Method6_RemoteReplay = function(id)
        local payload = { gamepassId = id, playerId = plr.UserId, timestamp = os.time() }
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                pcall(function()
                    remote:FireServer(payload)
                    remote:FireServer({payload})
                    remote:FireServer(id)
                end)
            end
        end
        return true
    end,

    Method7_FullSiege = function(id)
        ARSENAL.Method1_ClientBypass(id)
        ARSENAL.Method2_PromptFlood(id)
        ARSENAL.Method3_ReceiptForgery(id)
        ARSENAL.Method4_MemoryInjection(id)
        ARSENAL.Method5_DataStoreOverload(id)
        ARSENAL.Method6_RemoteReplay(id)
        return true
    end
}

local function ExecuteAttack(methodName, methodFunc, productId, productName)
    if not productId then
        print("❌ Select a Gamepass first!")
        return
    end
    if methodName == "FullSiege" and ATTACK_HISTORY[productId] then
        print("⚠️ " .. productName .. " was already attacked!")
        return
    end
    local success = methodFunc(productId)
    if success then
        ATTACK_HISTORY[productId] = os.time()
        print("✅ " .. methodName .. " on: " .. productName)
    end
end

-- ================================================
-- 🎨 بناء الواجهة (MozerHub_v2)
-- ================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftSidebar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local MinimizedFrame = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local UserProfile = Instance.new("Frame")
local UserName = Instance.new("TextLabel")
local UserID = Instance.new("TextLabel")
local UserIcon = Instance.new("ImageLabel")
local TabContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "MozerHub_v2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- وظيفة عرض المحتوى حسب التبويب
local function ShowContent(tabName)
    for _, child in pairs(RightContent:GetChildren()) do
        if child.Name ~= "UICorner" then child:Destroy() end
    end
    
    if tabName == "Gamepass" then
        local dropdownBtn = Instance.new("TextButton", RightContent)
        dropdownBtn.Size = UDim2.new(0.9, 0, 0, 45)
        dropdownBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        dropdownBtn.Text = "📦 Select Gamepass"
        dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdownBtn.Font = Enum.Font.Gotham
        dropdownBtn.TextSize = 14
        Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 8)
        
        local dropdownList = Instance.new("ScrollingFrame", RightContent)
        dropdownList.Size = UDim2.new(0.9, 0, 0, 180)
        dropdownList.Position = UDim2.new(0.05, 0, 0.25, 0)
        dropdownList.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        dropdownList.BorderSizePixel = 0
        dropdownList.Visible = false
        dropdownList.ScrollBarThickness = 3
        Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 8)
        
        local listLayout = Instance.new("UIListLayout", dropdownList)
        listLayout.Padding = UDim.new(0, 2)
        
        local function RefreshDropdown()
            for _, child in pairs(dropdownList:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            for i, gp in ipairs(GAMEPASS_LIST) do
                local btn = Instance.new("TextButton", dropdownList)
                btn.Size = UDim2.new(1, -10, 0, 40)
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                btn.Text = gp.name
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 12
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                
                btn.MouseButton1Click:Connect(function()
                    SELECTED_GAMEPASS = gp.id
                    SELECTED_GAMEPASS_NAME = gp.name
                    dropdownBtn.Text = "✅ " .. gp.name
                    dropdownList.Visible = false
                end)
            end
            dropdownList.CanvasSize = UDim2.new(0, 0, 0, #GAMEPASS_LIST * 45)
        end
        
        dropdownBtn.MouseButton1Click:Connect(function()
            dropdownList.Visible = not dropdownList.Visible
        end)
        
        local selectBtn = Instance.new("TextButton", RightContent)
        selectBtn.Size = UDim2.new(0.9, 0, 0, 45)
        selectBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
        selectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
        selectBtn.Text = "✅ SELECT"
        selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectBtn.Font = Enum.Font.GothamBold
        selectBtn.TextSize = 16
        Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 8)
        
        selectBtn.MouseButton1Click:Connect(function()
            if SELECTED_GAMEPASS then
                print("🎯 Selected: " .. SELECTED_GAMEPASS_NAME)
            end
        end)
        
        RefreshDropdown()
        
    elseif tabName == "Buy" then
        local methods = {
            {"🕵️ Client Bypass", ARSENAL.Method1_ClientBypass, "ClientBypass"},
            {"🌊 Prompt Flood", ARSENAL.Method2_PromptFlood, "PromptFlood"},
            {"📜 Receipt Forgery", ARSENAL.Method3_ReceiptForgery, "ReceiptForgery"},
            {"💉 Memory Injection", ARSENAL.Method4_MemoryInjection, "MemoryInjection"},
            {"🗄️ DataStore Overload", ARSENAL.Method5_DataStoreOverload, "DataStoreOverload"},
            {"🔄 Remote Replay", ARSENAL.Method6_RemoteReplay, "RemoteReplay"},
            {"🚨 FULL SIEGE", ARSENAL.Method7_FullSiege, "FullSiege"}
        }
        
        for i, m in ipairs(methods) do
            local btn = Instance.new("TextButton", RightContent)
            btn.Size = UDim2.new(0.9, 0, 0, 45)
            btn.Position = UDim2.new(0.05, 0, 0.05 + (i-1)*0.13, 0)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            btn.Text = m[1]
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            
            btn.MouseButton1Click:Connect(function()
                ExecuteAttack(m[3], m[2], SELECTED_GAMEPASS, SELECTED_GAMEPASS_NAME)
            end)
        end
    elseif tabName == "Information" then
        local info = Instance.new("TextLabel", RightContent)
        info.Size = UDim2.new(1, -20, 0.9, 0)
        info.Position = UDim2.new(0, 10, 0.05, 0)
        info.BackgroundTransparency = 1
        info.TextColor3 = Color3.fromRGB(200, 200, 200)
        info.Font = Enum.Font.Gotham
        info.TextSize = 13
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.Text = [[
🔥 BE MAGIC - ARSENAL EDITION
⚡ 7 STEALTH EXPLOIT METHODS

📊 Game ID: ]] .. game.PlaceId .. [[
👤 Player: ]] .. plr.Name .. [[

✅ Select Gamepass → Choose target
⚔️ Buy → Execute attack methods
        ]]
    end
end

-- بناء الواجهة الرئيسية
local function BuildUI()
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Size = UDim2.new(0, 520, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -200)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    
    LeftSidebar.Name = "Sidebar"
    LeftSidebar.Parent = MainFrame
    LeftSidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LeftSidebar.Size = UDim2.new(0, 155, 1, 0)
    LeftSidebar.BorderSizePixel = 0
    Instance.new("UICorner", LeftSidebar).CornerRadius = UDim.new(0, 12)
    
    Title.Parent = LeftSidebar
    Title.Text = "Be Mozer"
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = MainFrame
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -40, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 22
    
    TabContainer.Parent = LeftSidebar
    TabContainer.Position = UDim2.new(0, 10, 0, 65)
    TabContainer.Size = UDim2.new(1, -20, 0.55, 0)
    TabContainer.BackgroundTransparency = 1
    
    UIListLayout.Parent = TabContainer
    UIListLayout.Padding = UDim.new(0, 6)
    
    local tabs = {"Information", "Gamepass", "Buy"}
    for _, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton", TabContainer)
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        btn.Text = "   " .. tabName
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            ShowContent(tabName)
        end)
    end
    
    RightContent.Name = "Content"
    RightContent.Parent = MainFrame
    RightContent.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    RightContent.Position = UDim2.new(0, 165, 0, 50)
    RightContent.Size = UDim2.new(1, -175, 1, -60)
    Instance.new("UICorner", RightContent).CornerRadius = UDim.new(0, 12)
    
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Parent = ScreenGui
    MinimizedFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MinimizedFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
    MinimizedFrame.Size = UDim2.new(0, 55, 0, 55)
    MinimizedFrame.Visible = false
    MinimizedFrame.Text = "M"
    MinimizedFrame.Font = Enum.Font.FredokaOne
    MinimizedFrame.TextSize = 32
    MinimizedFrame.BorderSizePixel = 0
    Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(0, 12)
    
    task.spawn(function()
        while true do
            MinimizedFrame.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            task.wait(0.1)
        end
    end)
    
    local function MakeDraggable(frame)
        local UIS = game:GetService("UserInputService")
        local dragging, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
    
    MakeDraggable(MainFrame)
    MakeDraggable(MinimizedFrame)
    
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
    end)
    
    MinimizedFrame.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
        ShowContent("Information")
    end)
    
    ShowContent("Information")
    MainFrame.Visible = true
end

-- ================================================
-- 🌈 رسالة الترحيب
-- ================================================
local function ShowWelcome()
    local WelcomeGui = Instance.new("ScreenGui", game.CoreGui)
    local MozerLabel = Instance.new("TextLabel", WelcomeGui)
    MozerLabel.Size = UDim2.new(1, 0, 0.1, 0)
    MozerLabel.Position = UDim2.new(0, 0, 0.38, 0)
    MozerLabel.BackgroundTransparency = 1
    MozerLabel.Text = "Mozer"
    MozerLabel.TextSize = 80
    MozerLabel.Font = Enum.Font.FredokaOne
    
    local WelcomeLabel = Instance.new("TextLabel", WelcomeGui)
    WelcomeLabel.Size = UDim2.new(1, 0, 0.1, 0)
    WelcomeLabel.Position = UDim2.new(0, 0, 0.56, 0)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "Welcome"
    WelcomeLabel.TextSize = 50
    WelcomeLabel.Font = Enum.Font.FredokaOne
    
    task.spawn(function()
        while WelcomeGui.Parent do
            local hue = tick() % 5 / 5
            MozerLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
            WelcomeLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait(0.1)
        end
    end)
    
    task.wait(2.5)
    WelcomeGui:Destroy()
end

-- ================================================
-- 🚀 بدء التشغيل
-- ================================================
LOAD_GAMEPASSES()
task.spawn(function()
    ShowWelcome()
    BuildUI()
    print("✅ MOZER HUB v2 Ready | 7 Methods Active")
end)
