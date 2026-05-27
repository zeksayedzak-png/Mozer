-- ================================================
-- 🎯 MOZER LITE - يعمل فوراً
-- ⚡ METHOD 1 & 6 | بدون شاشة ترحيب
-- ================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- ================================================
-- المتغيرات
-- ================================================
local SELECTED_ID = nil
local SELECTED_NAME = nil
local TARGET_REMOTES = {}
local mainFrame = nil
local dragging = false
local dragStart = nil
local frameStart = nil

-- قائمة Gamepasses
local GAMEPASS_LIST = {
    {id = 588368, name = "Gamepass #588368"},
    {id = 588369, name = "Gamepass #588369"},
    {id = 588370, name = "Gamepass #588370"},
    {id = 588371, name = "Gamepass #588371"},
    {id = 588372, name = "Gamepass #588372"},
    {id = 588373, name = "Gamepass #588373"},
    {id = 588374, name = "Gamepass #588374"},
    {id = 588375, name = "Gamepass #588375"},
}

-- ================================================
-- تحليل الـ Remotes
-- ================================================
local function AnalyzeRemotes()
    TARGET_REMOTES = {}
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            if name:find("purchase") or name:find("buy") or name:find("gamepass") then
                table.insert(TARGET_REMOTES, obj)
            end
        end
    end
end

-- ================================================
-- METHOD 1
-- ================================================
local function Method1()
    if not SELECTED_ID then return end
    local payload = {
        gamepassId = SELECTED_ID,
        playerId = plr.UserId,
        timestamp = os.time(),
    }
    for _, remote in pairs(TARGET_REMOTES) do
        pcall(function() remote:FireServer(payload) end)
        pcall(function() remote:FireServer(SELECTED_ID) end)
    end
    pcall(function() MarketplaceService:PromptProductPurchase(plr, SELECTED_ID) end)
end

-- ================================================
-- METHOD 6
-- ================================================
local function Method6()
    if not SELECTED_ID then return end
    local payload = {
        gamepassId = SELECTED_ID,
        playerId = plr.UserId,
        action = "purchase",
    }
    for _, remote in pairs(TARGET_REMOTES) do
        pcall(function()
            remote:FireServer(payload)
            remote:FireServer({payload})
            remote:FireServer(SELECTED_ID)
        end)
        task.wait(0.05)
    end
end

-- ================================================
-- إنشاء الواجهة (بدون شاشة ترحيب)
-- ================================================
local function CreateUI()
    -- التأكد من وجود PlayerGui
    local playerGui = plr:FindFirstChild("PlayerGui")
    if not playerGui then
        playerGui = Instance.new("PlayerGui")
        playerGui.Parent = plr
    end
    
    -- حذف أي واجهة قديمة
    local oldGui = playerGui:FindFirstChild("MozerUI")
    if oldGui then oldGui:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MozerUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- الإطار الرئيسي
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- شريط العنوان (للسحب)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    -- عنوان
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Be Mozer"
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = titleBar
    
    -- زر X
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 30)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    -- تبويبات
    local tabGamepass = Instance.new("TextButton")
    tabGamepass.Size = UDim2.new(0.5, -5, 0, 35)
    tabGamepass.Position = UDim2.new(0, 10, 0, 50)
    tabGamepass.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabGamepass.Text = "Gamepass"
    tabGamepass.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabGamepass.Font = Enum.Font.GothamBold
    tabGamepass.Parent = mainFrame
    
    local tabBuy = Instance.new("TextButton")
    tabBuy.Size = UDim2.new(0.5, -5, 0, 35)
    tabBuy.Position = UDim2.new(0.5, 5, 0, 50)
    tabBuy.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    tabBuy.Text = "Buy"
    tabBuy.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBuy.Font = Enum.Font.GothamBold
    tabBuy.Parent = mainFrame
    
    -- محتوى Gamepass
    local gamepassFrame = Instance.new("Frame")
    gamepassFrame.Size = UDim2.new(1, -20, 1, -100)
    gamepassFrame.Position = UDim2.new(0, 10, 0, 95)
    gamepassFrame.BackgroundTransparency = 1
    gamepassFrame.Parent = mainFrame
    
    -- زر اختيار Gamepass
    local selectBtn = Instance.new("TextButton")
    selectBtn.Size = UDim2.new(1, 0, 0, 45)
    selectBtn.Position = UDim2.new(0, 0, 0, 0)
    selectBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    selectBtn.Text = "▶ Select Gamepass"
    selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectBtn.Font = Enum.Font.Gotham
    selectBtn.TextSize = 14
    selectBtn.Parent = gamepassFrame
    
    local selectCorner = Instance.new("UICorner")
    selectCorner.CornerRadius = UDim.new(0, 8)
    selectCorner.Parent = selectBtn
    
    -- القائمة
    local dropdown = Instance.new("ScrollingFrame")
    dropdown.Size = UDim2.new(1, 0, 0, 150)
    dropdown.Position = UDim2.new(0, 0, 0, 55)
    dropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    dropdown.BorderSizePixel = 0
    dropdown.Visible = false
    dropdown.ScrollBarThickness = 3
    dropdown.Parent = gamepassFrame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 8)
    dropdownCorner.Parent = dropdown
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.Parent = dropdown
    
    -- محتوى Buy
    local buyFrame = Instance.new("Frame")
    buyFrame.Size = UDim2.new(1, -20, 1, -100)
    buyFrame.Position = UDim2.new(0, 10, 0, 95)
    buyFrame.BackgroundTransparency = 1
    buyFrame.Visible = false
    buyFrame.Parent = mainFrame
    
    -- زر Method 1
    local m1Btn = Instance.new("TextButton")
    m1Btn.Size = UDim2.new(1, 0, 0, 60)
    m1Btn.Position = UDim2.new(0, 0, 0, 0)
    m1Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    m1Btn.Text = "⚡ METHOD 1\nClient Bypass"
    m1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    m1Btn.Font = Enum.Font.GothamBold
    m1Btn.TextSize = 14
    m1Btn.Parent = buyFrame
    
    local m1Corner = Instance.new("UICorner")
    m1Corner.CornerRadius = UDim.new(0, 10)
    m1Corner.Parent = m1Btn
    
    -- زر Method 6
    local m6Btn = Instance.new("TextButton")
    m6Btn.Size = UDim2.new(1, 0, 0, 60)
    m6Btn.Position = UDim2.new(0, 0, 0, 75)
    m6Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    m6Btn.Text = "🔄 METHOD 6\nRemote Replay"
    m6Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    m6Btn.Font = Enum.Font.GothamBold
    m6Btn.TextSize = 14
    m6Btn.Parent = buyFrame
    
    local m6Corner = Instance.new("UICorner")
    m6Corner.CornerRadius = UDim.new(0, 10)
    m6Corner.Parent = m6Btn
    
    -- زر دائرة M (للتصغير)
    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 60, 0, 60)
    miniBtn.Position = UDim2.new(0.5, -30, 0.5, -30)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.Text = "M"
    miniBtn.TextSize = 30
    miniBtn.TextColor3 = Color3.fromRGB(255, 100, 0)
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.Visible = false
    miniBtn.Parent = screenGui
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(1, 0)
    miniCorner.Parent = miniBtn
    
    -- ============================================
    -- تعبئة القائمة
    -- ============================================
    for i, gp in ipairs(GAMEPASS_LIST) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.Text = gp.name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = dropdown
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            SELECTED_ID = gp.id
            SELECTED_NAME = gp.name
            selectBtn.Text = "✅ " .. gp.name
            dropdown.Visible = false
        end)
    end
    
    dropdown.CanvasSize = UDim2.new(0, 0, 0, #GAMEPASS_LIST * 40)
    
    -- ============================================
    -- الأحداث
    -- ============================================
    selectBtn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
    
    tabGamepass.MouseButton1Click:Connect(function()
        tabGamepass.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        tabBuy.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        gamepassFrame.Visible = true
        buyFrame.Visible = false
    end)
    
    tabBuy.MouseButton1Click:Connect(function()
        tabGamepass.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        tabBuy.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        gamepassFrame.Visible = false
        buyFrame.Visible = true
    end)
    
    m1Btn.MouseButton1Click:Connect(function()
        if SELECTED_ID then
            Method1()
            m1Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.delay(0.5, function() m1Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50) end)
        end
    end)
    
    m6Btn.MouseButton1Click:Connect(function()
        if SELECTED_ID then
            Method6()
            m6Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.delay(0.5, function() m6Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50) end)
        end
    end)
    
    -- تصغير
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        miniBtn.Visible = true
    end)
    
    miniBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        miniBtn.Visible = false
    end)
    
    -- ============================================
    -- السحب بالإصبع
    -- ============================================
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            frameStart = mainFrame.Position
        end
    end
    
    local function onDrag(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            mainFrame.Position = UDim2.new(0, frameStart.X.Offset + delta.X, 0, frameStart.Y.Offset + delta.Y)
        end
    end
    
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end
    
    titleBar.InputBegan:Connect(startDrag)
    titleBar.InputChanged:Connect(onDrag)
    titleBar.InputEnded:Connect(endDrag)
    
    -- ================================================
    -- تشغيل
    -- ================================================
    AnalyzeRemotes()
    print("✅ MOZER Ready - Select Gamepass then Attack")
end

-- ================================================
-- بدء التشغيل
-- ================================================
CreateUI()
