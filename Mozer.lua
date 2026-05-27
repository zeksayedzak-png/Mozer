-- ================================================
-- 🎯 MOZER - FIXED MOBILE UI
-- ⚡ METHOD 1 & 6 | PRECISION | ZERO NOISE
-- 📱 FULL TOUCH INTERFACE | BLACK BACKGROUND
-- ================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local plr = Players.LocalPlayer
local gameId = game.PlaceId
local playerGui = plr:WaitForChild("PlayerGui")

-- ================================================
-- 📊 المتغيرات العامة
-- ================================================
local REAL_GAMEPASSES = {}
local SELECTED_ID = nil
local SELECTED_NAME = nil
local TARGET_REMOTES = {}
local isMinimized = false
local mainFrame = nil
local dragData = { dragging = false, startPos = nil, startMousePos = nil }

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
-- 🌈 شاشة الترحيب (سوداء بالكامل، بدون شفافية)
-- ================================================
local function showWelcomeScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MozerWelcome"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- خلفية سوداء بالكامل (بدون شفافية)
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0  -- صفر شفافية = أسود كامل
    background.Parent = screenGui
    
    -- نص Mozer (أصغر حجماً)
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
    
    -- نص Welcome
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
        for i = 1, 30 do
            task.wait(0.1)
            if i % 3 == 0 then
                updateRainbow(mozerText)
                updateRainbow(welcomeText)
            end
        end
    end)
    
    -- اختفاء بعد 3 ثواني
    task.wait(3)
    TweenService:Create(background, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mozerText, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(welcomeText, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    task.wait(0.3)
    screenGui:Destroy()
    createMainUI()
end

-- ================================================
-- 📊 جلب Gamepasses الحقيقية
-- ================================================
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
        print("✅ Loaded " .. #REAL_GAMEPASSES .. " Gamepasses")
        return true
    else
        print("❌ Failed to load Gamepasses")
        return false
    end
end

-- ================================================
-- 🔍 تحليل الـ Remotes
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
    print("🔍 Found " .. #TARGET_REMOTES .. " purchase Remotes")
    return #TARGET_REMOTES
end

-- ================================================
-- ⚔️ METHOD 1
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
-- ⚔️ METHOD 6
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
-- 🎨 إنشاء الواجهة الرئيسية (سوداء بالكامل)
-- ================================================
local function createMainUI()
    print("🎨 Creating Main UI...")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MozerUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- المربع الرئيسي (أسود)
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- أسود
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- زوايا ناعمة
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    -- شريط العنوان (أسود غامق)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = titleBar
    
    -- نص "Be Mozer"
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Be Mozer"
    titleText.TextSize = 22
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Parent = titleBar
    
    -- زر X
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 2)
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
    contentFrame.Size = UDim2.new(1, -20, 1, -65)
    contentFrame.Position = UDim2.new(0, 10, 0, 55)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- زر التصغير (دائرة M)
    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 70, 0, 70)
    miniBtn.Position = UDim2.new(0.5, -35, 0.5, -35)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.Text = "M"
    miniBtn.TextSize = 40
    miniBtn.TextColor3 = rainbowColors[1]
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.Visible = false
    miniBtn.Parent = screenGui
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(1, 0)
    miniCorner.Parent = miniBtn
    
    -- تأثير قوس قزح على M
    task.spawn(function()
        while true do
            task.wait(0.2)
            if miniBtn.Visible then
                updateRainbow(miniBtn)
            end
        end
    end)
    
    -- ============================================
    -- تبويبات
    -- ============================================
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 45)
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
    gamepassContent.Size = UDim2.new(1, 0, 1, -55)
    gamepassContent.Position = UDim2.new(0, 0, 0, 55)
    gamepassContent.BackgroundTransparency = 1
    gamepassContent.Parent = contentFrame
    
    -- محتوى Buy Tab
    local buyContent = Instance.new("Frame")
    buyContent.Size = UDim2.new(1, 0, 1, -55)
    buyContent.Position = UDim2.new(0, 0, 0, 55)
    buyContent.BackgroundTransparency = 1
    buyContent.Visible = false
    buyContent.Parent = contentFrame
    
    -- ============================================
    -- صفحة Gamepass
    -- ============================================
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.9, 0, 0, 55)
    dropdownBtn.Position = UDim2.new(0.05, 0, 0.08, 0)
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
    dropdownList.Size = UDim2.new(0.9, 0, 0, 250)
    dropdownList.Position = UDim2.new(0.05, 0, 0.28, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ScrollBarThickness = 4
    dropdownList.Parent = gamepassContent
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 12)
    listCorner.Parent = dropdownList
    
    local selectBtn = Instance.new("TextButton")
    selectBtn.Size = UDim2.new(0.9, 0, 0, 50)
    selectBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
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
    method1Btn.Size = UDim2.new(0.9, 0, 0, 70)
    method1Btn.Position = UDim2.new(0.05, 0, 0.12, 0)
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
    method6Btn.Size = UDim2.new(0.9, 0, 0, 70)
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
    -- الوظائف
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
    
    local function refreshDropdown()
        for _, child in pairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local layout = dropdownList:FindFirstChildWhichIsA("UIListLayout")
        if not layout then
            layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 2)
            layout.Parent = dropdownList
        end
        
        for i, gp in ipairs(REAL_GAMEPASSES) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 45)
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
    
    selectBtn.MouseButton1Click:Connect(function()
        if SELECTED_ID then
            dropdownBtn.Text = "✅ " .. SELECTED_NAME .. " [SELECTED]"
            task.delay(1, function()
                if dropdownBtn.Text ~= "📦 Loading Gamepasses..." then
                    -- keep the text
                end
            end)
        end
    end)
    
    method1Btn.MouseButton1Click:Connect(function()
        if SELECTED_ID then
            Method1_ClientBypass()
            method1Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.delay(1, function() method1Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40) end)
        end
    end)
    
    method6Btn.MouseButton1Click:Connect(function()
        if SELECTED_ID then
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
    
    -- السحب
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragData.dragging = true
            dragData.startPos = mainFrame.Position
            dragData.startMousePos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end
    
    local function drag(input)
        if dragData.dragging then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragData.startMousePos
            local newX = math.clamp(dragData.startPos.X.Offset + delta.X, -200, UDim.new(1, 0).X.Offset - 200)
            local newY = math.clamp(dragData.startPos.Y.Offset + delta.Y, -100, UDim.new(1, 0).Y.Offset - 100)
            mainFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end
    
    local function stopDrag()
        dragData.dragging = false
    end
    
    titleBar.InputBegan:Connect(startDrag)
    titleBar.InputChanged:Connect(drag)
    titleBar.InputEnded:Connect(stopDrag)
    
    -- تحميل البيانات
    FetchGamepasses()
    task.wait(1)
    refreshDropdown()
    if #REAL_GAMEPASSES > 0 then
        dropdownBtn.Text = "📦 Select Gamepass (" .. #REAL_GAMEPASSES .. " available)"
    else
        dropdownBtn.Text = "⚠️ No Gamepasses Found"
    end
    AnalyzePurchaseRemotes()
    
    print("✅ MOZER UI Ready")
end

-- ================================================
-- 🚀 بدء التشغيل
-- ================================================
showWelcomeScreen()
