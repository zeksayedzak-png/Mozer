-- ===========================================
-- 🔪 MOZER - SURGICAL EDITION
-- ⚡ تحليل + اختيار + تنفيذ جراحي
-- ===========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- ===========================================
-- المتغيرات الرئيسية
-- ===========================================
local allRemotes = {}     -- قائمة بكل Remotes اللعبة
local selectedRemote = nil -- الـ Remote الذي اختاره المستخدم
local targetFrame = nil
local remoteListFrame = nil

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
-- 2. عرض القائمة على المستخدم للاختيار
-- ===========================================
local function showSelectionUI()
    -- تنظيف الواجهة القديمة
    if targetFrame then targetFrame:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MozerSurgical"
    screenGui.Parent = plr.PlayerGui
    
    targetFrame = Instance.new("Frame")
    targetFrame.Size = UDim2.new(0, 450, 0, 350)
    targetFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    targetFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    targetFrame.Parent = screenGui
    Instance.new("UICorner", targetFrame).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    title.Text = "🔪 Select Target Remote"
    title.TextColor3 = Color3.fromRGB(255, 200, 0)
    title.Font = Enum.Font.GothamBold
    title.Parent = targetFrame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0, 2)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = targetFrame
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -80)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
    scroll.Parent = targetFrame
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scroll
    
    -- إضافة كل Remote كزر
    for i, remote in ipairs(allRemotes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Text = remote.name .. " (" .. remote.className .. ")"
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        btn.MouseButton1Click:Connect(function()
            selectedRemote = remote.ref
            targetFrame:Destroy()
            showAttackUI(remote)
        end)
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, #allRemotes * 52)
    
    closeBtn.MouseButton1Click:Connect(function()
        targetFrame:Destroy()
    end)
end

-- ===========================================
-- 3. واجهة الهجوم (جراحي)
-- ===========================================
local function showAttackUI(selected)
    local attackGui = Instance.new("ScreenGui")
    attackGui.Name = "AttackUI"
    attackGui.Parent = plr.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.Parent = attackGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 60)
    info.Position = UDim2.new(0, 10, 0, 10)
    info.BackgroundTransparency = 1
    info.Text = "🎯 Target Locked:\n" .. selected.name .. "\n" .. selected.path
    info.TextColor3 = Color3.fromRGB(200, 200, 200)
    info.TextSize = 11
    info.TextWrapped = true
    info.Parent = frame
    
    -- زر Method 1 (جراحي)
    local m1 = Instance.new("TextButton")
    m1.Size = UDim2.new(0.9, 0, 0, 45)
    m1.Position = UDim2.new(0.05, 0, 0.4, 0)
    m1.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    m1.Text = "🔪 METHOD 1 (To Selected Remote)"
    m1.TextColor3 = Color3.fromRGB(255, 255, 255)
    m1.Parent = frame
    Instance.new("UICorner", m1).CornerRadius = UDim.new(0, 8)
    
    -- زر Method 6 (جراحي)
    local m6 = Instance.new("TextButton")
    m6.Size = UDim2.new(0.9, 0, 0, 45)
    m6.Position = UDim2.new(0.05, 0, 0.65, 0)
    m6.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    m6.Text = "🔄 METHOD 6 (To Selected Remote)"
    m6.TextColor3 = Color3.fromRGB(255, 255, 255)
    m6.Parent = frame
    Instance.new("UICorner", m6).CornerRadius = UDim.new(0, 8)
    
    -- منطق Method 1 الجراحي
    m1.MouseButton1Click:Connect(function()
        if selectedRemote and selectedRemote:IsA("RemoteEvent") then
            local payload = { action = "purchase", gamepassId = 123456, player = plr.UserId }
            selectedRemote:FireServer(payload) -- يرسل للـ Remote المختار فقط
            m1.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.wait(0.5)
            m1.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        end
    end)
    
    -- منطق Method 6 الجراحي
    m6.MouseButton1Click:Connect(function()
        if selectedRemote then
            local payload = { action = "replay", signature = tostring(os.time()) }
            if selectedRemote:IsA("RemoteEvent") then
                selectedRemote:FireServer(payload)
                selectedRemote:FireServer({payload})
            elseif selectedRemote:IsA("RemoteFunction") then
                selectedRemote:InvokeServer(payload)
            end
            m6.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.wait(0.5)
            m6.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        end
    end)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0, 2)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function()
        attackGui:Destroy()
    end)
    
    -- السحب
    local function drag(frame)
        local dragStart, startPos, dragging
        frame.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = i.Position
                startPos = frame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.Touch then
                local delta = i.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end
    drag(frame)
end

-- ===========================================
-- 4. التشغيل
-- ===========================================
fetchAllRemotes()
if #allRemotes > 0 then
    showSelectionUI()
    print("✅ MOZER SURGICAL EDITION: Select your target from the list.")
else
    print("❌ No Remotes found in this game.")
end
