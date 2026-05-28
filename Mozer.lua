-- إنشاء الـ ScreenGui الرئيسي
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MinimizedFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local TabsFrame = Instance.new("Frame")
local GamepassBtn = Instance.new("TextButton")
local BuyBtn = Instance.new("TextButton")
local Separator = Instance.new("Frame")
local DragHandle = Instance.new("Frame")
local MText = Instance.new("TextLabel")

-- إعدادات الـ ScreenGui
ScreenGui.Name = "MozerHub"
ScreenGui.Parent = game.CoreGui -- يعمل على Delta
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. رسالة الترحيب (Mozer Welcome)
local function ShowWelcome()
    local WelcomeGui = Instance.new("ScreenGui", game.CoreGui)
    
    local MozerLabel = Instance.new("TextLabel", WelcomeGui)
    MozerLabel.Size = UDim2.new(1, 0, 0.1, 0)
    MozerLabel.Position = UDim2.new(0, 0, 0.4, 0)
    MozerLabel.BackgroundTransparency = 1
    MozerLabel.Text = "Mozer"
    MozerLabel.TextSize = 60
    MozerLabel.Font = Enum.Font.FredokaOne

    local WelcomeLabel = Instance.new("TextLabel", WelcomeGui)
    WelcomeLabel.Size = UDim2.new(1, 0, 0.1, 0)
    WelcomeLabel.Position = UDim2.new(0, 0, 0.5, 0)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "Welcome"
    WelcomeLabel.TextSize = 40
    WelcomeLabel.Font = Enum.Font.FredokaOne

    -- تأثير قوس قزح للترحيب
    spawn(function()
        while WelcomeGui.Parent do
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            MozerLabel.TextColor3 = color
            WelcomeLabel.TextColor3 = color
            task.wait()
        end
    end)

    task.wait(3) -- تظهر لمدة 3 ثواني
    WelcomeGui:Destroy()
end

-- 2. إعداد الواجهة الكبيرة (MainFrame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Visible = false

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 10)

-- العنوان (Be Mozer)
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Size = UDim2.new(0, 100, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "Be Mozer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر الإغلاق (X)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Position = UDim2.new(0.9, -5, 0.05, 0)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(1, 0)

-- الخط الفاصل السفلي
Separator.Name = "Separator"
Separator.Parent = MainFrame
Separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Separator.BorderSizePixel = 0
Separator.Position = UDim2.new(0.05, 0, 0.75, 0)
Separator.Size = UDim2.new(0.9, 0, 0, 2)

-- أزرار الصفحات (Gamepass & Buy)
GamepassBtn.Parent = MainFrame
GamepassBtn.Size = UDim2.new(0.4, 0, 0, 25)
GamepassBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
GamepassBtn.Text = "Gamepass"
GamepassBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GamepassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

BuyBtn.Parent = MainFrame
BuyBtn.Size = UDim2.new(0.4, 0, 0, 25)
BuyBtn.Position = UDim2.new(0.55, 0, 0.82, 0)
BuyBtn.Text = "Buy"
BuyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- مقبض السحب السفلي (الأبيض الشفاف)
DragHandle.Parent = MainFrame
DragHandle.Size = UDim2.new(0.3, 0, 0, 5)
DragHandle.Position = UDim2.new(0.35, 0, 0.95, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DragHandle.BackgroundTransparency = 0.7
Instance.new("UICorner", DragHandle)

-- 3. المربع الصغير (MinimizedFrame)
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinimizedFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
MinimizedFrame.Visible = false
local MinCorner = Instance.new("UICorner", MinimizedFrame)
MinCorner.CornerRadius = UDim.new(0, 12)

MText.Parent = MinimizedFrame
MText.Size = UDim2.new(1, 0, 1, 0)
MText.Text = "M"
MText.Font = Enum.Font.FredokaOne
MText.TextSize = 30
MText.BackgroundTransparency = 1

-- تأثير قوس قزح لحرف M
spawn(function()
    while true do
        local hue = tick() % 5 / 5
        MText.TextColor3 = Color3.fromHSV(hue, 1, 1)
        task.wait()
    end
end)

-- وظيفة سحب الواجهات باللمس (Mobile Drag)
local function MakeDraggable(frame)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

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

-- نظام التبديل (فتح/إغلاق)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

MinimizedFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- إذا ضغطت بسرعة يفتح الواجهة، وإذا سحبت يتحرك
        local start = tick()
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End and (tick() - start) < 0.2 then
                MainFrame.Visible = true
                MinimizedFrame.Visible = false
            end
        end)
    end
end)

-- تشغيل الترحيب ثم إظهار الواجهة
spawn(function()
    ShowWelcome()
    MainFrame.Visible = true
end)
