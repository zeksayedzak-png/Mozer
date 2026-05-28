-- إنشاء الـ ScreenGui الرئيسي
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftSidebar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local UserProfile = Instance.new("Frame")
local UserName = Instance.new("TextLabel")
local UserIcon = Instance.new("ImageLabel")
local TabContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

-- إعدادات الـ ScreenGui
ScreenGui.Name = "MozerHub_Modern"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. رسالة الترحيب (Mozer Welcome)
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
            task.wait()
        end
    end)
    task.wait(2.5)
    WelcomeGui:Destroy()
end

-- 2. الواجهة الرئيسية (MainFrame) - اللون الأسود
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- أسود غامق
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- القائمة الجانبية (Left Sidebar)
LeftSidebar.Name = "Sidebar"
LeftSidebar.Parent = MainFrame
LeftSidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- رمادي غامق جداً
LeftSidebar.Size = UDim2.new(0, 140, 1, 0)
LeftSidebar.BorderSizePixel = 0
local SideCorner = Instance.new("UICorner", LeftSidebar)
SideCorner.CornerRadius = UDim.new(0, 15)

-- العنوان (Be Mozer)
Title.Parent = LeftSidebar
Title.Text = "Be Mozer"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- زر الإغلاق (X أبيض شفاف)
CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20

-- حاوية الأزرار (Tabs)
TabContainer.Parent = LeftSidebar
TabContainer.Position = UDim2.new(0, 5, 0, 60)
TabContainer.Size = UDim2.new(1, -10, 0.6, 0)
TabContainer.BackgroundTransparency = 1

UIListLayout.Parent = TabContainer
UIListLayout.Padding = UDim.new(0, 5)

local function CreateTab(name)
    local Btn = Instance.new("TextButton", TabContainer)
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = "  " .. name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    return Btn
end

local GamepassBtn = CreateTab("Gamepass")
local BuyBtn = CreateTab("Buy")
local InfoBtn = CreateTab("Information")

-- بروفايل المستخدم (أسفل اليسار)
UserProfile.Parent = LeftSidebar
UserProfile.Size = UDim2.new(1, -10, 0, 45)
UserProfile.Position = UDim2.new(0, 5, 1, -55)
UserProfile.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", UserProfile).CornerRadius = UDim.new(0, 8)

UserIcon.Parent = UserProfile
UserIcon.Size = UDim2.new(0, 30, 0, 30)
UserIcon.Position = UDim2.new(0, 7, 0.5, -15)
UserIcon.Image = "rbxassetid://6073754552" -- صورة افتراضية
Instance.new("UICorner", UserIcon).CornerRadius = UDim.new(1, 0)

UserName.Parent = UserProfile
UserName.Text = game.Players.LocalPlayer.Name
UserName.Size = UDim2.new(1, -45, 1, 0)
UserName.Position = UDim2.new(0, 42, 0, 0)
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.Font = Enum.Font.GothamBold
UserName.TextSize = 11
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.BackgroundTransparency = 1

-- منطقة المحتوى اليمنى
RightContent.Name = "Content"
RightContent.Parent = MainFrame
RightContent.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
RightContent.Position = UDim2.new(0, 145, 0, 50)
RightContent.Size = UDim2.new(1, -155, 1, -60)
Instance.new("UICorner", RightContent).CornerRadius = UDim.new(0, 10)

-- وظيفة سحب الواجهة
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

-- الفتح والإغلاق
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- بدء التشغيل
task.spawn(function()
    ShowWelcome()
    MainFrame.Visible = true
end)
