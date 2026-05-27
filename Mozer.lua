-- ================================================
-- 🎯 MOZER - FAST MOBILE UI
-- ⚡ METHOD 1 & 6 | DRAGGABLE | FAST LOAD
-- ================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local plr = Players.LocalPlayer
local gameId = game.PlaceId

-- ================================================
-- 📊 المتغيرات
-- ================================================
local REAL_GAMEPASSES = {}
local SELECTED_ID = nil
local SELECTED_NAME = nil
local TARGET_REMOTES = {}
local isMinimized = false
local mainFrame = nil
local dragging = false
local dragStart = nil
local frameStart = nil

-- ================================================
-- 🌈 ألوان قوس قزح
-- ================================================
local rainbowColors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(75, 0, 130),
    Color3.fromRGB(148, 0, 255)
}
local rainbowIndex = 1

local function updateRainbow(guiObject)
    rainbowIndex = rainbowIndex % #rainbowColors + 1
    if guiObject and guiObject.Parent then
        guiObject.TextColor3 = rainbowColors[rainbowIndex]
    end
end

-- ================================================
-- 📊 جلب Gamepasses (سريع + بدون تأخير)
-- ================================================
local function FetchGamepasses()
    -- مجرد محاكاة سريعة، البيانات الحقيقية تجلب في الخلفية
    REAL_GAMEPASSES = {}
    
    -- جلب حقيقي من API (يعمل في الخلفية بدون تعليق الواجهة)
    task.spawn(function()
        local url = "https://economy.roblox.com/v1/games/" .. gameId .. "/gamepasses?limit=50"
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if success and response and response.data then
            for _, gp in ipairs(response.data) do
                table.insert(REAL_GAMEPASSES, {id = gp.id, name = gp.name, price = gp.price or 0})
            end
            -- تحديث الواجهة بعد التحميل
            if dropdownBtn then
                dropdownBtn.Text = "📦 " .. #REAL_GAMEPASSES .. " Gamepasses available"
                refreshDropdown()
            end
        else
            if dropdownBtn then
                dropdownBtn.Text = "⚠️ No Gamepasses found"
            end
        end
    end)
    
    -- نضيف بعض البيانات الوهمية عشان الواجهة ما تظهر فاضية
    table.insert(REAL_GAMEPASSES, {id = 0, name = "Loading...", price = 0})
    return true
end

-- ================================================
-- 🔍 تحليل الـ Remotes (سريع)
-- ================================================
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
-- ⚔️ METHOD 1
-- ================================================
local function Method1_ClientBypass()
    if not SELECTED_ID or SELECTED_ID == 0 then return false end
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
-- ⚔️ METHOD 6
-- ================================================
local function Method6_RemoteReplay()
    if not SELECTED_ID or SELECTED_ID == 0 then return false end
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
-- 🎨 إنشاء الواجهة الرئيسية (مستطيل + قابل للسحب)
-- ================================================
local dropdownBtn = nil

local function createMainUI()
    local playerGui = plr:FindFirstChild("PlayerGui")
    if not playerGui then
        playerGui = Instance.new("PlayerGui")
        playerGui.Parent = plr
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MozerUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- المربع الرئيسي (مستطيل - width أكبر من height)
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 520)  -- مستطيل: عرض 400، ارتفاع 520
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -260)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    -- شريط العنوان (قابل للسحب من هنا)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = titleBar
    
    -- أيقونة سحب (三条 خط)
    local dragIcon = Instance.new("TextLabel")
    dragIcon.Size = UDim2.new(0, 40, 1, 0)
    dragIcon.Position = UDim2.new(0, 10, 0, 0)
    dragIcon.BackgroundTransparency = 1
    dragIcon.Text = "☰"
    dragIcon.TextSize = 25
    dragIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
    dragIcon.Font = Enum.Font.Gotham
    dragIcon.Parent = titleBar
    
    -- نص Be Mozer
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Position = UDim2.new(0, 55, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Be Mozer"
    titleText.TextSize = 22
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Parent = titleBar
    
    -- زر X
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 45, 0, 45)
    closeBtn.Position = UDim2.new(1, -55, 0, 2)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 24
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeBtn
    
    -- منطقة المحتوى
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- زر التصغير (دائرة M)
    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 80, 0, 80)
    miniBtn.Position = UDim2.new(0.5, -40, 0.5, -40)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.Text = "M"
    miniBtn.TextSize = 45
    miniBtn.TextColor3 = rainbowColors[1]
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.Visible = false
    miniBtn.Parent = screenGui
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(1, 0)
    miniCorner.Parent = miniBtn
    
    -- تأثير قوس قزح على M
    task.spawn(function()
        while task.wait(0.2) do
            if miniBtn and miniBtn.Visible then
                updateRainbow(miniBtn)
            end
        end
    end)
    
    -- ============================================
    -- تبويبات
    -- ============================================
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 50)
    tabFrame.Position = UDim2.new(0, 0, 0, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = contentFrame
    
    local gamepassTabBtn = Instance.new("TextButton")
    gamepassTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
    gamepassTabBtn.Position = UDim2.new(0, 0, 0, 0)
    gamepassTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    gamepassTabBtn.Text = "Gamepass"
    gamepassTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    gamepassTabBtn.Font = Enum.Font.GothamBold
    gamepassTabBtn.TextSize = 18
    gamepassTabBtn.Parent = tabFrame
    
    local buyTabBtn = Instance.new("TextButton")
    buyTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
    buyTabBtn.Position = UDim2.new(0.5, 5, 0, 0)
    buyTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    buyTabBtn.Text = "Buy"
    buyTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyTabBtn.Font = Enum.Font.GothamBold
    buyTabBtn.TextSize = 18
    buyTabBtn.Parent = tabFrame
    
    local tabCorner1 = Instance.new("UICorner")
    tabCorner1.CornerRadius = UDim.new(0, 12)
    tabCorner1.Parent = gamepassTabBtn
    
    local tabCorner2 = Instance.new("UICorner")
    tabCorner2.CornerRadius = UDim.new(0, 12)
    tabCorner2.Parent = buyTabBtn
    
    -- محتوى Gamepass Tab
    local gamepassContent = Instance.new("Frame")
    gamepassContent.Size = UDim2.new(1, 0, 1, -60)
    gamepassContent.Position = UDim2.new(0, 0, 0, 60)
    gamepassContent.BackgroundTransparency = 1
    gamepassContent.Parent = contentFrame
    
    -- محتوى Buy Tab
    local buyContent = Instance.new("Frame")
    buyContent.Size = UDim2.new(1, 0, 1, -60)
    buyContent.Position = UDim2.new(0, 0, 0, 60)
    buyContent.BackgroundTransparency = 1
    buyContent.Visible = false
    buyContent.Parent = contentFrame
    
    -- ============================================
    -- صفحة Gamepass
    -- ============================================
    dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.9, 0, 0, 55)
    dropdownBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    dropdownBtn.Text = "📦 Loading Gamepasses..."
    dropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 14
    dropdownBtn.Parent = gamepassContent
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 12)
    dropdownCorner.Parent = dropdownBtn
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(0.9, 0, 0, 280)
    dropdownList.Position = UDim2.new(0.05, 0, 0.22, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ScrollBarThickness = 4
    dropdownList.Parent = gamepassContent
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 12)
    listCorner.Parent = dropdownList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 3)
    listLayout.Parent = dropdownList
    
    -- زر Select
    local selectBtn = Instance.new("TextButton")
    selectBtn.Size = UDim2.new(0.9, 0, 0, 50)
    selectBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
    selectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
    selectBtn.Text = "✅ SELECT"
    selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectBtn.Font = Enum.Font.GothamBold
    selectBtn.TextSize = 18
    selectBtn.Parent = gamepassContent
    
    local selectCorner = Instance.new("UICorner")
    selectCorner.CornerRadius = UDim.new(0, 12)
    selectCorner.Parent = selectBtn
    
    -- ============================================
    -- صفحة Buy
    -- ============================================
    local method1Btn = Instance.new("TextButton")
    method1Btn.Size = UDim2.new(0.9, 0, 0, 80)
    method1Btn.Position = UDim2.new(0.05, 0, 0.1, 0)
    method1Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    method1Btn.Text = "🕵️ METHOD 1\nClient Bypass"
    method1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    method1Btn.Font = Enum.Font.GothamBold
    method1Btn.TextSize = 16
    method1Btn.Parent = buyContent
    
    local method1Corner = Instance.new("UICorner")
    method1Corner.CornerRadius = UDim.new(0, 12)
    method1Corner.Parent = method1Btn
    
    local method6Btn = Instance.new("TextButton")
    method6Btn.Size = UDim2.new(0.9, 0, 0, 80)
    method6Btn.Position = UDim2.new(0.05, 0, 0.45, 0)
    method6Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    method6Btn.Text = "🔄 METHOD 6\nRemote Replay"
    method6Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    method6Btn.Font = Enum.Font.GothamBold
    method6Btn.TextSize = 16
    method6Btn.Parent = buyContent
    
    local method6Corner = Instance.new("UICorner")
    method6Corner.CornerRadius = UDim.new(0, 12)
    method6Corner.Parent = method6Btn
    
    -- ============================================
    -- الأحداث
    -- ============================================
    gamepassTabBtn.MouseButton1Click:Connect(function()
        gamepassTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        buyTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        gamepassContent.Visible = true
        buyContent.Visible = false
    end)
    
    buyTabBtn.MouseButton1Click:Connect(function()
        gamepassTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        buyTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        gamepassContent.Visible = false
        buyContent.Visible = true
    end)
    
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    function refreshDropdown()
        for _, child in pairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for i, gp in ipairs(REAL_GAMEPASSES) do
            if gp.id ~= 0 then  -- نتخطى الـ Loading الوهمي
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 50)
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                btn.Text = gp.name .. " [" .. gp.price .. "]"
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 13
                btn.Parent = dropdownList
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    SELECTED_ID = gp.id
                    SELECTED_NAME = gp.name
                    dropdownBtn.Text = "✅ " .. gp.name .. " [" .. gp.price .. "]"
                    dropdownList.Visible = false
                end)
            end
        end
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, #REAL_GAMEPASSES * 55)
    end
    
    selectBtn.MouseButton1Click:Connect(function()
        if SELECTED_ID and SELECTED_ID ~= 0 then
            selectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.delay(0.5, function() selectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 180) end)
        end
    end)
    
    method1Btn.MouseButton1Click:Connect(function()
        if SELECTED_ID and SELECTED_ID ~= 0 then
            Method1_ClientBypass()
            method1Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.delay(1, function() method1Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40) end)
        end
    end)
    
    method6Btn.MouseButton1Click:Connect(function()
        if SELECTED_ID and SELECTED_ID ~= 0 then
            Method6_RemoteReplay()
            method6Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.delay(1, function() method6Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40) end)
        end
    end)
    
    -- تصغير وتكبير
    closeBtn.MouseButton1Click:Connect(function()
        isMinimized = true
        mainFrame.Visible = false
        miniBtn.Visible = true
    end)
    
    miniBtn.MouseButton1Click:Connect(function()
        isMinimized = false
        mainFrame.Visible = true
        miniBtn.Visible = false
    end)
    
    -- ============================================
    -- نظام السحب (يعمل باللمس)
    -- ============================================
    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            frameStart = mainFrame.Position
        end
    end
    
    local function onDragMove(input)
        if dragging then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            local newX = frameStart.X.Offset + delta.X
            local newY = frameStart.Y.Offset + delta.Y
            mainFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end
    
    local function onDragEnd()
        dragging = false
    end
    
    -- السحب من شريط العنوان أو الأيقونة
    titleBar.InputBegan:Connect(onDragStart)
    titleBar.InputChanged:Connect(onDragMove)
    titleBar.InputEnded:Connect(onDragEnd)
    dragIcon.InputBegan:Connect(onDragStart)
    dragIcon.InputChanged:Connect(onDragMove)
    dragIcon.InputEnded:Connect(onDragEnd)
    
    -- تحليل الـ Remotes
    AnalyzePurchaseRemotes()
    
    -- جلب Gamepasses
    FetchGamepasses()
    
    print("✅ MOZER UI Ready")
end

-- ================================================
-- 🌈 شاشة الترحيب
-- ================================================
local function showWelcomeScreen()
    local playerGui = plr:FindFirstChild("PlayerGui")
    if not playerGui then
        playerGui = Instance.new("PlayerGui")
        playerGui.Parent = plr
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MozerWelcome"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0
    background.Parent = screenGui
    
    local mozerText = Instance.new("TextLabel")
    mozerText.Size = UDim2.new(1, 0, 0.3, 0)
    mozerText.Position = UDim2.new(0, 0, 0.3, 0)
    mozerText.BackgroundTransparency = 1
    mozerText.Text = "MOZER"
    mozerText.TextSize = 50
    mozerText.TextScaled = true
    mozerText.Font = Enum.Font.GothamBold
    mozerText.TextColor3 = rainbowColors[1]
    mozerText.Parent = background
    
    local welcomeText = Instance.new("TextLabel")
    welcomeText.Size = UDim2.new(1, 0, 0.15, 0)
    welcomeText.Position = UDim2.new(0, 0, 0.55, 0)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Text = "welcome"
    welcomeText.TextSize = 35
    welcomeText.TextScaled = true
    welcomeText.Font = Enum.Font.Gotham
    welcomeText.TextColor3 = rainbowColors[4]
    welcomeText.Parent = background
    
    -- تأثير قوس قزح
    task.spawn(function()
        for i = 1, 25 do
            task.wait(0.12)
            if i % 3 == 0 then
                updateRainbow(mozerText)
                updateRainbow(welcomeText)
            end
        end
    end)
    
    task.wait(3)
    
    TweenService:Create(background, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mozerText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(welcomeText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    task.wait(0.3)
    screenGui:Destroy()
    
    createMainUI()
end

-- ================================================
-- 🚀 التشغيل
-- ================================================
showWelcomeScreen()
