-- ===========================================
-- 🔪 MOZER - SURGICAL EDITION (FULL)
-- ⚡ تحليل + اختيار + تنفيذ جراحي
-- 📱 واجهة مصغرة + سحب باللمس + صفحتين
-- ===========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- ===========================================
-- المتغيرات الرئيسية
-- ===========================================
local allRemotes = {}
local selectedRemote = nil
local selectedRemoteName = nil
local selectedRemotePath = nil
local mainFrame = nil
local isMinimized = false
local miniBtn = nil

-- ===========================================
-- 1. تحليل اللعبة وجلب كل الـ Remotes
-- ===========================================
local function fetchAllRemotes()
    allRemotes = {}
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(allRemotes, {
                name = obj.Name,
                path = obj:GetFullName(),
                className = obj.ClassName,
                ref = obj
            })
        end
    end
    return allRemotes
end

-- ===========================================
-- 2. وظيفة السحب (لجميع الواجهات)
-- ===========================================
local function makeDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ===========================================
-- 3. صفحة تنفيذ الهجوم (Method 1 & 6)
-- ===========================================
local function showAttackUI()
    -- تنظيف الواجهة القديمة إذا وجدت
    local oldGui = plr.PlayerGui:FindFirstChild("AttackUIPage")
    if oldGui then oldGui:Destroy() end
    
    local attackGui = Instance.new("ScreenGui")
    attackGui.Name = "AttackUIPage"
    attackGui.Parent = plr.PlayerGui
    attackGui.ResetOnSpawn = false
    
    -- إطار رئيسي أصغر (300x260)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 260)
    frame.Position = UDim2.new(0.5, -150, 0.5, -130)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
    frame.BorderSizePixel = 0
    frame.Parent = attackGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    
    -- شريط العنوان (للسحب)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    titleBar.Parent = frame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔪 Execute Attack"
    title.TextColor3 = Color3.fromRGB(255, 200, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- زر إغلاق (تصغير)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = titleBar
    
    -- معلومات الهدف المختار
    local targetInfo = Instance.new("TextLabel")
    targetInfo.Size = UDim2.new(0.9, 0, 0, 50)
    targetInfo.Position = UDim2.new(0.05, 0, 0.18, 0)
    targetInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    targetInfo.Text = selectedRemoteName and ("🎯 " .. selectedRemoteName .. "\n📁 " .. selectedRemotePath) or "❌ No Remote Selected"
    targetInfo.TextColor3 = Color3.fromRGB(180, 180, 200)
    targetInfo.Font = Enum.Font.Gotham
    targetInfo.TextSize = 9
    targetInfo.TextWrapped = true
    targetInfo.Parent = frame
    Instance.new("UICorner", targetInfo).CornerRadius = UDim.new(0, 8)
    
    -- زر Method 1
    local m1Btn = Instance.new("TextButton")
    m1Btn.Size = UDim2.new(0.85, 0, 0, 45)
    m1Btn.Position = UDim2.new(0.075, 0, 0.55, 0)
    m1Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    m1Btn.Text = "🔪 METHOD 1 (FireServer)"
    m1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    m1Btn.Font = Enum.Font.GothamBold
    m1Btn.TextSize = 12
    m1Btn.Parent = frame
    Instance.new("UICorner", m1Btn).CornerRadius = UDim.new(0, 8)
    
    -- زر Method 6
    local m6Btn = Instance.new("TextButton")
    m6Btn.Size = UDim2.new(0.85, 0, 0, 45)
    m6Btn.Position = UDim2.new(0.075, 0, 0.78, 0)
    m6Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    m6Btn.Text = "🔄 METHOD 6 (Replay)"
    m6Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    m6Btn.Font = Enum.Font.GothamBold
    m6Btn.TextSize = 12
    m6Btn.Parent = frame
    Instance.new("UICorner", m6Btn).CornerRadius = UDim.new(0, 8)
    
    -- منطق Method 1 (جراحي - يضرب الهدف المختار فقط)
    m1Btn.MouseButton1Click:Connect(function()
        if selectedRemote and selectedRemote:IsA("RemoteEvent") then
            local payload = { 
                action = "purchase", 
                gamepassId = 123456, 
                player = plr.UserId,
                timestamp = os.time()
            }
            selectedRemote:FireServer(payload)
            m1Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.delay(0.5, function()
                if m1Btn then m1Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50) end
            end)
        elseif not selectedRemote then
            targetInfo.Text = "❌ No Remote Selected!\nGo back and select one."
        end
    end)
    
    -- منطق Method 6 (جراحي - يضرب الهدف المختار فقط)
    m6Btn.MouseButton1Click:Connect(function()
        if selectedRemote then
            local payload = { 
                action = "replay", 
                signature = tostring(os.time()),
                data = "replayed"
            }
            if selectedRemote:IsA("RemoteEvent") then
                selectedRemote:FireServer(payload)
                selectedRemote:FireServer({payload})
            elseif selectedRemote:IsA("RemoteFunction") then
                pcall(function() selectedRemote:InvokeServer(payload) end)
            end
            m6Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.delay(0.5, function()
                if m6Btn then m6Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50) end
            end)
        elseif not selectedRemote then
            targetInfo.Text = "❌ No Remote Selected!\nGo back and select one."
        end
    end)
    
    -- زر تصغير إلى دائرة M
    closeBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
        if miniBtn then miniBtn.Visible = true end
    end)
    
    makeDraggable(frame)
end

-- ===========================================
-- 4. صفحة اختيار الـ Remote (قائمة)
-- ===========================================
local function showSelectionUI()
    local oldGui = plr.PlayerGui:FindFirstChild("SelectionUIPage")
    if oldGui then oldGui:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SelectionUIPage"
    screenGui.Parent = plr.PlayerGui
    screenGui.ResetOnSpawn = false
    
    -- إطار أصغر (320x380)
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 320, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
    
    -- شريط العنوان
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    titleBar.Parent = mainFrame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔪 Select Remote Target"
    title.TextColor3 = Color3.fromRGB(255, 200, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- زر التصغير (X)
    local miniButton = Instance.new("TextButton")
    miniButton.Size = UDim2.new(0, 32, 0, 32)
    miniButton.Position = UDim2.new(1, -38, 0, 4)
    miniButton.Text = "✕"
    miniButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    miniButton.BackgroundTransparency = 1
    miniButton.Font = Enum.Font.GothamBold
    miniButton.TextSize = 16
    miniButton.Parent = titleBar
    
    -- منطقة القائمة (ScrollingFrame)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -80)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
    scroll.ScrollBarThickness = 3
    scroll.Parent = mainFrame
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 10)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll
    
    -- تعبئة القائمة بالـ Remotes
    for i, remote in ipairs(allRemotes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 48)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Text = "📡 " .. remote.name .. "\n📁 " .. remote.path
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 9
        btn.TextWrapped = true
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        btn.MouseButton1Click:Connect(function()
            selectedRemote = remote.ref
            selectedRemoteName = remote.name
            selectedRemotePath = remote.path
            -- إغلاق صفحة الاختيار
            screenGui:Destroy()
            -- فتح صفحة التنفيذ
            showAttackUI()
        end)
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, (#allRemotes * 54) + 20)
    
    -- زر التصغير
    miniButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        if miniBtn then miniBtn.Visible = true end
    end)
    
    makeDraggable(mainFrame)
end

-- ===========================================
-- 5. زر التصغير العالمي (دائرة M)
-- ===========================================
local function createMinimizeButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MinimizeButton"
    screenGui.Parent = plr.PlayerGui
    screenGui.ResetOnSpawn = false
    
    miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 55, 0, 55)
    miniBtn.Position = UDim2.new(0.03, 0, 0.7, 0)
    miniBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    miniBtn.Text = "M"
    miniBtn.TextColor3 = Color3.fromRGB(255, 150, 0)
    miniBtn.Font = Enum.Font.FredokaOne
    miniBtn.TextSize = 32
    miniBtn.Visible = false
    miniBtn.Parent = screenGui
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 14)
    
    -- تأثير قوس قزح
    task.spawn(function()
        while true do
            local hue = tick() % 5 / 5
            miniBtn.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait(0.15)
        end
    end)
    
    miniBtn.MouseButton1Click:Connect(function()
        -- محاولة إظهار الواجهة المناسبة
        local selectionGui = plr.PlayerGui:FindFirstChild("SelectionUIPage")
        local attackGui = plr.PlayerGui:FindFirstChild("AttackUIPage")
        
        if selectionGui and selectionGui:FindFirstChildWhichIsA("Frame") then
            selectionGui:FindFirstChildWhichIsA("Frame").Visible = true
            miniBtn.Visible = false
        elseif attackGui and attackGui:FindFirstChildWhichIsA("Frame") then
            attackGui:FindFirstChildWhichIsA("Frame").Visible = true
            miniBtn.Visible = false
        else
            -- لو مافي واجهة، نفتح صفحة الاختيار
            showSelectionUI()
            miniBtn.Visible = false
        end
    end)
    
    makeDraggable(miniBtn)
end

-- ===========================================
-- 6. التشغيل الرئيسي
-- ===========================================
fetchAllRemotes()
if #allRemotes > 0 then
    createMinimizeButton()
    showSelectionUI()
    print("✅ MOZER SURGICAL EDITION READY")
    print("📡 " .. #allRemotes .. " Remotes found")
    print("🔪 Select your target from the list")
else
    print("❌ No Remotes found in this game")
end
