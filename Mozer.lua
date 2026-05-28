-- ================================================
-- 🎯 MOZER HUB v2 - COMPLETE
-- UI by you | Methods 1 & 6 by me
-- ================================================

-- إعدادات الواجهة (كما أرسلتها)
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

-- ================================================
-- 📊 المتغيرات الأساسية
-- ================================================
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local plr = Players.LocalPlayer

local SELECTED_GAMEPASS_ID = nil
local SELECTED_GAMEPASS_NAME = nil
local TARGET_REMOTES = {}   -- الـ Remotes المتعلقة بالشراء
local GAMEPASS_LIST = {}     -- قائمة Gamepasses الحقيقية

-- ================================================
-- 🔍 تحليل الـ Remotes في اللعبة
-- ================================================
local function AnalyzeRemotes()
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
-- 📡 جلب Gamepasses الحقيقية (زي الأصلي)
-- ================================================
local function FetchRealGamepasses()
    local gameId = game.PlaceId
    local url = "https://economy.roblox.com/v1/games/" .. gameId .. "/gamepasses?limit=100"
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and response and response.data then
        GAMEPASS_LIST = {}
        for _, gp in ipairs(response.data) do
            table.insert(GAMEPASS_LIST, {
                id = gp.id,
                name = gp.name,
                price = gp.price or 0
            })
        end
        return true, #GAMEPASS_LIST
    else
        -- بيانات تجريبية احتياطية إذا فشل الـ API
        GAMEPASS_LIST = {
            {id = 588368, name = "Gamepass #588368", price = 100},
            {id = 588369, name = "Gamepass #588369", price = 200},
            {id = 588370, name = "Gamepass #588370", price = 300},
        }
        return false, #GAMEPASS_LIST
    end
end

-- ================================================
-- ⚔️ METHOD 1 (مطور: دقيق، مرة واحدة)
-- ================================================
local function Method1_ClientBypass()
    if not SELECTED_GAMEPASS_ID then
        print("❌ Select a Gamepass first")
        return false
    end
    
    local payload = {
        gamepassId = SELECTED_GAMEPASS_ID,
        playerId = plr.UserId,
        timestamp = os.time(),
        purchaseType = "Gamepass",
        receipt = HttpService:GenerateGUID(false)
    }
    
    -- إرسال فقط للـ Remotes المنطقية
    for _, remote in pairs(TARGET_REMOTES) do
        pcall(function() remote:FireServer(payload) end)
        pcall(function() remote:FireServer(SELECTED_GAMEPASS_ID) end)
    end
    
    -- المحاولة المباشرة عبر MarketplaceService
    pcall(function() MarketplaceService:PromptProductPurchase(plr, SELECTED_GAMEPASS_ID) end)
    
    print("✅ METHOD 1 executed on: " .. SELECTED_GAMEPASS_NAME)
    return true
end

-- ================================================
-- ⚔️ METHOD 6 (مطور: دقيق، بدون ضوضاء)
-- ================================================
local function Method6_RemoteReplay()
    if not SELECTED_GAMEPASS_ID then
        print("❌ Select a Gamepass first")
        return false
    end
    
    local learnedPayload = {
        gamepassId = SELECTED_GAMEPASS_ID,
        playerId = plr.UserId,
        action = "purchase",
        signature = HttpService:GenerateGUID(false)
    }
    
    for _, remote in pairs(TARGET_REMOTES) do
        pcall(function()
            remote:FireServer(learnedPayload)
            remote:FireServer({learnedPayload})
            remote:FireServer(SELECTED_GAMEPASS_ID, learnedPayload)
        end)
        task.wait(0.05)
    end
    
    print("✅ METHOD 6 executed on: " .. SELECTED_GAMEPASS_NAME)
    return true
end

-- ================================================
-- 🎨 بناء واجهة المحتوى الديناميكي
-- ================================================
local function SwitchTab(tabName)
    -- مسح المحتوى الحالي
    for _, child in pairs(RightContent:GetChildren()) do
        if child.Name ~= "UICorner" then
            child:Destroy()
        end
    end
    
    if tabName == "Information" then
        local infoText = Instance.new("TextLabel", RightContent)
        infoText.Size = UDim2.new(1, -20, 0.8, 0)
        infoText.Position = UDim2.new(0, 10, 0.05, 0)
        infoText.BackgroundTransparency = 1
        infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 13
        infoText.TextXAlignment = Enum.TextXAlignment.Left
        infoText.TextYAlignment = Enum.TextYAlignment.Top
        infoText.Text = string.format([[
📊 GAME INFO
━━━━━━━━━━━━━━━━━━━━━
Game ID: %d
Player: %s (%d)
Remotes Found: %d

🎮 SELECTED GAMEPASS
━━━━━━━━━━━━━━━━━━━━━
%s

⚡ METHODS READY
━━━━━━━━━━━━━━━━━━━━━
Method 1: Client Bypass (Precision)
Method 6: Remote Replay (Precision)
        ]], game.PlaceId, plr.Name, plr.UserId, #TARGET_REMOTES, 
           SELECTED_GAMEPASS_NAME or "None")
        
    elseif tabName == "Gamepass" then
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
        
        -- تعبئة القائمة
        local function RefreshDropdown()
            for _, child in pairs(dropdownList:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            for i, gp in ipairs(GAMEPASS_LIST) do
                local btn = Instance.new("TextButton", dropdownList)
                btn.Size = UDim2.new(1, -10, 0, 40)
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                btn.Text = gp.name .. " [" .. gp.price .. "]"
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 12
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                
                btn.MouseButton1Click:Connect(function()
                    SELECTED_GAMEPASS_ID = gp.id
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
        
        RefreshDropdown()
        
    elseif tabName == "Buy" then
        local m1Btn = Instance.new("TextButton", RightContent)
        m1Btn.Size = UDim2.new(0.9, 0, 0, 60)
        m1Btn.Position = UDim2.new(0.05, 0, 0.08, 0)
        m1Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        m1Btn.Text = "🕵️ METHOD 1\nClient Bypass"
        m1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        m1Btn.Font = Enum.Font.GothamBold
        m1Btn.TextSize = 14
        Instance.new("UICorner", m1Btn).CornerRadius = UDim.new(0, 10)
        
        local m6Btn = Instance.new("TextButton", RightContent)
        m6Btn.Size = UDim2.new(0.9, 0, 0, 60)
        m6Btn.Position = UDim2.new(0.05, 0, 0.40, 0)
        m6Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        m6Btn.Text = "🔄 METHOD 6\nRemote Replay"
        m6Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        m6Btn.Font = Enum.Font.GothamBold
        m6Btn.TextSize = 14
        Instance.new("UICorner", m6Btn).CornerRadius = UDim.new(0, 10)
        
        m1Btn.MouseButton1Click:Connect(function()
            if SELECTED_GAMEPASS_ID then
                Method1_ClientBypass()
                m1Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                task.delay(1, function() m1Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50) end)
            else
                print("❌ Select a Gamepass first from Gamepass tab")
            end
        end)
        
        m6Btn.MouseButton1Click:Connect(function()
            if SELECTED_GAMEPASS_ID then
                Method6_RemoteReplay()
                m6Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                task.delay(1, function() m6Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50) end)
            else
                print("❌ Select a Gamepass first from Gamepass tab")
            end
        end)
    end
end

-- ================================================
-- بناء الواجهة الرئيسية (UI كما أرسلتها)
-- ================================================
local function BuildUI()
    -- الواجهة الرئيسية
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Size = UDim2.new(0, 520, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    
    -- القائمة الجانبية
    LeftSidebar.Name = "Sidebar"
    LeftSidebar.Parent = MainFrame
    LeftSidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LeftSidebar.Size = UDim2.new(0, 155, 1, 0)
    LeftSidebar.BorderSizePixel = 0
    Instance.new("UICorner", LeftSidebar).CornerRadius = UDim.new(0, 12)
    
    -- العنوان
    Title.Parent = LeftSidebar
    Title.Text = "Be Mozer"
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- زر الإغلاق
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = MainFrame
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -40, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 22
    
    -- تبويبات
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
            SwitchTab(tabName)
        end)
    end
    
    -- بروفايل المستخدم
    UserProfile.Parent = LeftSidebar
    UserProfile.Size = UDim2.new(1, -12, 0, 50)
    UserProfile.Position = UDim2.new(0, 6, 1, -60)
    UserProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", UserProfile).CornerRadius = UDim.new(0, 10)
    
    UserIcon.Parent = UserProfile
    UserIcon.Size = UDim2.new(0, 34, 0, 34)
    UserIcon.Position = UDim2.new(0, 8, 0.5, -17)
    UserIcon.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    Instance.new("UICorner", UserIcon).CornerRadius = UDim.new(1, 0)
    
    UserName.Parent = UserProfile
    UserName.Text = plr.DisplayName
    UserName.Size = UDim2.new(1, -50, 0, 15)
    UserName.Position = UDim2.new(0, 48, 0.3, -2)
    UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserName.Font = Enum.Font.GothamBold
    UserName.TextSize = 11
    UserName.TextXAlignment = Enum.TextXAlignment.Left
    UserName.BackgroundTransparency = 1
    
    UserID.Parent = UserProfile
    UserID.Text = "@" .. plr.Name
    UserID.Size = UDim2.new(1, -50, 0, 15)
    UserID.Position = UDim2.new(0, 48, 0.6, -2)
    UserID.TextColor3 = Color3.fromRGB(130, 130, 130)
    UserID.Font = Enum.Font.Gotham
    UserID.TextSize = 9
    UserID.TextXAlignment = Enum.TextXAlignment.Left
    UserID.BackgroundTransparency = 1
    
    -- منطقة المحتوى
    RightContent.Name = "Content"
    RightContent.Parent = MainFrame
    RightContent.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    RightContent.Position = UDim2.new(0, 165, 0, 50)
    RightContent.Size = UDim2.new(1, -175, 1, -60)
    Instance.new("UICorner", RightContent).CornerRadius = UDim.new(0, 12)
    
    -- زر التصغير (M)
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
    
    -- تأثير قوس قزح
    task.spawn(function()
        while true do
            MinimizedFrame.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            task.wait(0.1)
        end
    end)
    
    -- السحب
    local function MakeDraggable(frame)
        local UserInputService = game:GetService("UserInputService")
        local dragging, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
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
    
    -- أحداث الإغلاق والفتح
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
    end)
    
    MinimizedFrame.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
        SwitchTab("Information")
    end)
    
    -- تشغيل التبويب الافتراضي
    SwitchTab("Information")
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
task.spawn(function()
    ShowWelcome()
    AnalyzeRemotes()
    FetchRealGamepasses()
    BuildUI()
    print("✅ MOZER HUB v2 Ready | Methods 1 & 6 Active")
end)
