-- إنشاء الـ ScreenGui الرئيسي
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MinimizedFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local GamepassBtn = Instance.new("TextButton")
local BuyBtn = Instance.new("TextButton")
local Separator = Instance.new("Frame")
local DragHandle = Instance.new("Frame")
local MText = Instance.new("TextLabel")

-- إعدادات الـ ScreenGui
ScreenGui.Name = "MozerHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. رسالة الترحيب (Mozer Welcome) - كبيرة كما طلبت
local function ShowWelcome()
    local WelcomeGui = Instance.new("ScreenGui", game.CoreGui)
    
    local MozerLabel = Instance.new("TextLabel", WelcomeGui)
    MozerLabel.Size = UDim2.new(1, 0, 0.2, 0)
    MozerLabel.Position = UDim2.new(0, 0, 0.35, 0)
    MozerLabel.BackgroundTransparency = 1
    MozerLabel.Text = "Mozer"
    MozerLabel.TextSize = 100
    MozerLabel.Font = Enum.Font.FredokaOne

    local WelcomeLabel = Instance.new("TextLabel", WelcomeGui)
    WelcomeLabel.Size = UDim2.new(1, 0, 0.1, 0)
    WelcomeLabel.Position = UDim2.new(0, 0, 0.52, 0)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "Welcome"
    WelcomeLabel.TextSize = 60
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

    task.wait(3)
    WelcomeGui:Destroy()
end

-- 2. الواجهة الرئيسية (MainFrame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
MainFrame.Size = UDim2.new(0, 400, 0, 280)
MainFrame.Visible = false

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 15)

-- العنوان (Be Mozer)
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0.02, 0)
Title.Size = UDim2.new(0, 150, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Be Mozer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر الإغلاق (X فقط أبيض بدون خلفية)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundTransparency = 1 -- شفاف تماماً
CloseBtn.Position = UDim2.new(0.92, 0, 0.02, 0)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 22

-- الأزرار العلوية (Gamepass & Buy) - صغيرة وفي الأعلى
GamepassBtn.Parent = MainFrame
GamepassBtn.Size = UDim2.new(0, 80, 0, 25) -- حجم صغير
GamepassBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
GamepassBtn.Text = "Gamepass"
GamepassBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GamepassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GamepassBtn.Font = Enum.Font.GothamBold
GamepassBtn.TextSize = 12
Instance.new("UICorner", GamepassBtn).CornerRadius = UDim.new(0, 5)

BuyBtn.Parent = MainFrame
BuyBtn.Size = UDim2.new(0, 80, 0, 25) -- حجم صغير
BuyBtn.Position = UDim2.new(0.28, 0, 0.15, 0)
BuyBtn.Text = "Buy"
BuyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyBtn.Font = Enum.Font.GothamBold
BuyBtn.TextSize = 12
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 5)

-- الخط الفاصل (تحت الأزرار العلوية)
Separator.Name = "Separator"
Separator.Parent = MainFrame
Separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Separator.BorderSizePixel = 0
Separator.Position = UDim2.new(0.05, 0, 0.28, 0)
Separator.Size = UDim2.new(0.9, 0, 0, 1)

-- مقبض السحب السفلي
DragHandle.Parent = MainFrame
DragHandle.Size = UDim2.new(0.15, 0, 0, 3)
DragHandle.Position = UDim2.new(0.425, 0, 0.95, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DragHandle.BackgroundTransparency = 0.8
Instance.new("UICorner", DragHandle)

-- 3. المربع الصغير (Minimized)
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinimizedFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizedFrame.Size = UDim2.new(0, 60, 0, 60)
MinimizedFrame.Visible = false
Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(0, 15)

MText.Parent = MinimizedFrame
MText.Size = UDim2.new(1, 0, 1, 0)
MText.Text = "M"
MText.Font = Enum.Font.FredokaOne
MText.TextSize = 35
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

-- الفتح والإغلاق
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

spawn(function()
    ShowWelcome()
    MainFrame.Visible = true
end)
