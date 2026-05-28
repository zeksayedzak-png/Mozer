-- إنشاء الـ ScreenGui الرئيسي
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MinimizedFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local GamepassBtn = Instance.new("TextButton")
local BuyBtn = Instance.new("TextButton")
local TopSeparator = Instance.new("Frame")
local DragHandle = Instance.new("Frame")
local MText = Instance.new("TextLabel")

-- إعدادات الـ ScreenGui
ScreenGui.Name = "MozerHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. وظيفة الإشعار (يشبه إشعار اللعبة الأصلي)
local function CustomNotification()
    local NotiFrame = Instance.new("Frame")
    local NotiTitle = Instance.new("TextLabel")
    local NotiDesc = Instance.new("TextLabel")
    local NotiCorner = Instance.new("UICorner")

    NotiFrame.Name = "CustomNotification"
    NotiFrame.Parent = ScreenGui
    NotiFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotiFrame.BackgroundTransparency = 0.1
    NotiFrame.BorderSizePixel = 0
    NotiFrame.Position = UDim2.new(1, 20, 0.8, 0) -- يبدأ من خارج الشاشة
    NotiFrame.Size = UDim2.new(0, 260, 0, 70)

    NotiCorner.CornerRadius = UDim.new(0, 10)
    NotiCorner.Parent = NotiFrame

    -- عنوان الإشعار (ProMagic)
    NotiTitle.Parent = NotiFrame
    NotiTitle.BackgroundTransparency = 1
    NotiTitle.Position = UDim2.new(0.05, 0, 0.1, 0)
    NotiTitle.Size = UDim2.new(0.9, 0, 0.4, 0)
    NotiTitle.Font = Enum.Font.GothamBold
    NotiTitle.Text = "ProMagic"
    NotiTitle.TextSize = 18
    NotiTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- محتوى الإشعار
    NotiDesc.Parent = NotiFrame
    NotiDesc.BackgroundTransparency = 1
    NotiDesc.Position = UDim2.new(0.05, 0, 0.5, 0)
    NotiDesc.Size = UDim2.new(0.9, 0, 0.4, 0)
    NotiDesc.Font = Enum.Font.GothamMedium
    NotiDesc.Text = "نحن هنا للتهكير ولسنا هنا للتعمير"
    NotiDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    NotiDesc.TextSize = 14
    NotiDesc.TextXAlignment = Enum.TextXAlignment.Left

    -- تأثير قوس قزح للعنوان فقط
    spawn(function()
        while NotiFrame.Parent do
            local hue = tick() % 5 / 5
            NotiTitle.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait()
        end
    end)

    -- تحريك الإشعار للداخل (Slide In)
    NotiFrame:TweenPosition(UDim2.new(1, -270, 0.8, 0), "Out", "Quart", 0.5, true)

    -- اختفاء بعد 5 ثواني
    task.wait(5)
    NotiFrame:TweenPosition(UDim2.new(1, 20, 0.8, 0), "In", "Quart", 0.5, true)
    task.wait(0.5)
    NotiFrame:Destroy()
end

-- 2. رسالة الترحيب (Mozer Welcome)
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
    WelcomeLabel.Position = UDim2.new(0, 0, 0.56, 0) -- مسافة أكبر كما طلبت
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "Welcome"
    WelcomeLabel.TextSize = 50
    WelcomeLabel.Font = Enum.Font.FredokaOne

    spawn(function()
        while WelcomeGui.Parent do
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            MozerLabel.TextColor3 = color
            WelcomeLabel.TextColor3 = color
            task.wait()
        end
    end)

    task.wait(2.5)
    WelcomeGui:Destroy()
end

-- 3. الواجهة الرئيسية (MainFrame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Visible = false

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0.02, 0)
Title.Size = UDim2.new(0, 150, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "Be Mozer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.9, -5, 0.02, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 35)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18

TopSeparator.Parent = MainFrame
TopSeparator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TopSeparator.BorderSizePixel = 0
TopSeparator.Position = UDim2.new(0, 0, 0.16, 0)
TopSeparator.Size = UDim2.new(1, 0, 0, 1)

GamepassBtn.Parent = MainFrame
GamepassBtn.Size = UDim2.new(0, 75, 0, 22)
GamepassBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
GamepassBtn.Text = "Gamepass"
GamepassBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
GamepassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GamepassBtn.Font = Enum.Font.GothamBold
GamepassBtn.TextSize = 11
Instance.new("UICorner", GamepassBtn).CornerRadius = UDim.new(0, 4)

BuyBtn.Parent = MainFrame
BuyBtn.Size = UDim2.new(0, 75, 0, 22)
BuyBtn.Position = UDim2.new(0.28, 0, 0.22, 0)
BuyBtn.Text = "Buy"
BuyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyBtn.Font = Enum.Font.GothamBold
BuyBtn.TextSize = 11
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 4)

DragHandle.Parent = MainFrame
DragHandle.Size = UDim2.new(0, 50, 0, 3)
DragHandle.Position = UDim2.new(0.5, -25, 0.95, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DragHandle.BackgroundTransparency = 0.8
Instance.new("UICorner", DragHandle)

-- 4. المربع الصغير (Minimized)
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinimizedFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizedFrame.Size = UDim2.new(0, 55, 0, 55)
MinimizedFrame.Visible = false
Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(0, 12)

MText.Parent = MinimizedFrame
MText.Size = UDim2.new(1, 0, 1, 0)
MText.Text = "M"
MText.Font = Enum.Font.FredokaOne
MText.TextSize = 32
MText.BackgroundTransparency = 1

spawn(function()
    while true do
        local hue = tick() % 5 / 5
        MText.TextColor3 = Color3.fromHSV(hue, 1, 1)
        task.wait()
    end
end)

-- وظيفة السحب
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

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

MinimizedFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local start = tick()
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if (tick() - start) < 0.2 then
                    MainFrame.Visible = true
                    MinimizedFrame.Visible = false
                end
                connection:Disconnect()
            end
        end)
    end
end)

-- 5. تشغيل التسلسل
spawn(function()
    ShowWelcome() -- شاشة الترحيب
    MainFrame.Visible = true -- فتح الواجهة
    CustomNotification() -- ظهور الإشعار في الزاوية
end)
