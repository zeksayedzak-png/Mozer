-- إنشاء الـ ScreenGui الرئيسي
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftSidebar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local MinimizedFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local UserProfile = Instance.new("Frame")
local UserName = Instance.new("TextLabel")
local UserID = Instance.new("TextLabel")
local UserIcon = Instance.new("ImageLabel")
local TabContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local MText = Instance.new("TextLabel")

-- إعدادات الـ ScreenGui
ScreenGui.Name = "MozerHub_Premium"
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

-- 2. الواجهة الرئيسية (MainFrame) - تصميم احترافي أسود
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- القائمة الجانبية
LeftSidebar.Name = "Sidebar"
LeftSidebar.Parent = MainFrame
LeftSidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
LeftSidebar.Size = UDim2.new(0, 150, 1, 0)
LeftSidebar.BorderSizePixel = 0
local SideCorner = Instance.new("UICorner", LeftSidebar)
SideCorner.CornerRadius = UDim.new(0, 15)

-- العنوان "Be Mozer"
Title.Parent = LeftSidebar
Title.Text = "Be Mozer"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 10)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- زر الإغلاق (X)
CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20

-- الأزرار (Tabs)
TabContainer.Parent = LeftSidebar
TabContainer.Position = UDim2.new(0, 8, 0, 65)
TabContainer.Size = UDim2.new(1, -16, 0.6, 0)
TabContainer.BackgroundTransparency = 1

UIListLayout.Parent = TabContainer
UIListLayout.Padding = UDim.new(0, 6)

local function CreateTab(name, iconId)
    local Btn = Instance.new("TextButton", TabContainer)
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.Text = "      " .. name
    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local Icon = Instance.new("ImageLabel", Btn)
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Position = UDim2.new(0, 8, 0.5, -8)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId or ""
    return Btn
end

CreateTab("Information", "rbxassetid://6031225818")
CreateTab("Gamepass", "rbxassetid://6031763426")
CreateTab("Buy", "rbxassetid://6023426915")

-- بروفايل المستخدم (مثل صورة Voidware)
UserProfile.Parent = LeftSidebar
UserProfile.Size = UDim2.new(1, -12, 0, 50)
UserProfile.Position = UDim2.new(0, 6, 1, -60)
UserProfile.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Instance.new("UICorner", UserProfile).CornerRadius = UDim.new(0, 10)

UserIcon.Parent = UserProfile
UserIcon.Size = UDim2.new(0, 34, 0, 34)
UserIcon.Position = UDim2.new(0, 8, 0.5, -17)
UserIcon.Image = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", UserIcon).CornerRadius = UDim.new(1, 0)

UserName.Parent = UserProfile
UserName.Text = game.Players.LocalPlayer.DisplayName
UserName.Size = UDim2.new(1, -50, 0, 15)
UserName.Position = UDim2.new(0, 48, 0.3, -2)
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.Font = Enum.Font.GothamBold
UserName.TextSize = 11
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.BackgroundTransparency = 1

UserID.Parent = UserProfile
UserID.Text = "@" .. game.Players.LocalPlayer.Name
UserID.Size = UDim2.new(1, -50, 0, 15)
UserID.Position = UDim2.new(0, 48, 0.6, -2)
UserID.TextColor3 = Color3.fromRGB(150, 150, 150)
UserID.Font = Enum.Font.Gotham
UserID.TextSize = 9
UserID.TextXAlignment = Enum.TextXAlignment.Left
UserID.BackgroundTransparency = 1

-- منطقة المحتوى اليمنى
RightContent.Name = "Content"
RightContent.Parent = MainFrame
RightContent.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
RightContent.Position = UDim2.new(0, 160, 0, 50)
RightContent.Size = UDim2.new(1, -170, 1, -60)
Instance.new("UICorner", RightContent).CornerRadius = UDim.new(0, 12)

-- 3. المربع الصغير (MinimizedFrame) - "M"
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

-- تأثير قوس قزح لحرف M
task.spawn(function()
    while true do
        MText.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        task.wait()
    end
end)

-- وظيفة سحب الواجهات
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

-- نظام التبديل (الفتح والإغلاق)
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

-- بدء التشغيل
task.spawn(function()
    ShowWelcome()
    MainFrame.Visible = true
end)
