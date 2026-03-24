local AppleLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Mouse = game.Players.LocalPlayer:GetMouse()

-- Вспомогательная функция для анимаций
local function PackTween(obj, time, goal)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

function AppleLib:CreateWindow(title, version, user)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "AppleLib_" .. math.random(100,999)
    ScreenGui.ResetOnSpawn = false

    -- MAIN FRAME
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 580, 0, 400)
    Main.Position = UDim2.new(0.5, -290, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(28, 28, 30) -- Apple Dark Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 12)

    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(60, 60, 60)
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.4

    -- TOPBAR CONTROLS (macOS Buttons)
    local Controls = Instance.new("Frame", Main)
    Controls.Size = UDim2.new(0, 60, 0, 40)
    Controls.Position = UDim2.new(0, 15, 0, 0)
    Controls.BackgroundTransparency = 1

    local ControlList = Instance.new("UIListLayout", Controls)
    ControlList.FillDirection = Enum.FillDirection.Horizontal
    ControlList.Padding = UDim.new(0, 8)
    ControlList.VerticalAlignment = Enum.VerticalAlignment.Center

    local function CreateCircle(color)
        local btn = Instance.new("TextButton", Controls)
        btn.Size = UDim2.new(0, 12, 0, 12)
        btn.BackgroundColor3 = color
        btn.Text = ""
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        return btn
    end

    local CloseBtn = CreateCircle(Color3.fromRGB(255, 69, 58))
    local MinBtn = CreateCircle(Color3.fromRGB(255, 186, 10))
    local HideBtn = CreateCircle(Color3.fromRGB(50, 215, 75))

    -- SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 170, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 37)
    Sidebar.BorderSizePixel = 0

    local SidebarRightStroke = Instance.new("Frame", Sidebar)
    SidebarRightStroke.Size = UDim2.new(0, 1, 1, 0)
    SidebarRightStroke.Position = UDim2.new(1, 0, 0, 0)
    SidebarRightStroke.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SidebarRightStroke.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 4)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- TOP TITLE
    local TopTitle = Instance.new("TextLabel", Main)
    TopTitle.Text = title .. " — " .. version
    TopTitle.Size = UDim2.new(1, -100, 0, 40)
    TopTitle.Position = UDim2.new(0, 85, 0, 0)
    TopTitle.BackgroundTransparency = 1
    TopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.TextSize = 14
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- CONTAINER FOR PAGES
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -190, 1, -60)
    Pages.Position = UDim2.new(0, 180, 0, 50)
    Pages.BackgroundTransparency = 1

    local Tabs = {}
    local SelectedTab = nil

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 62)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    PackTween(v, 0.2, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 180)})
                end
            end
            Page.Visible = true
            PackTween(TabBtn, 0.2, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)})
        end)

        if not SelectedTab then
            SelectedTab = TabBtn
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(0.97, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", Btn).Color = Color3.fromRGB(60, 60, 60)
            
            Btn.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE
        function Elements:CreateToggle(text, def, callback)
            local state = def or false
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(0.97, 0, 0, 36)
            Tgl.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
            Tgl.Text = "  " .. text
            Tgl.TextColor3 = Color3.fromRGB(240, 240, 240)
            Tgl.Font = Enum.Font.Gotham
            Tgl.TextSize = 13
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)

            local Switch = Instance.new("Frame", Tgl)
            Switch.Size = UDim2.new(0, 36, 0, 20)
            Switch.Position = UDim2.new(1, -45, 0.5, -10)
            Switch.BackgroundColor3 = state and Color3.fromRGB(48, 209, 88) or Color3.fromRGB(100, 100, 100)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame", Switch)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            Tgl.MouseButton1Click:Connect(function()
                state = not state
                PackTween(Switch, 0.2, {BackgroundColor3 = state and Color3.fromRGB(48, 209, 88) or Color3.fromRGB(100, 100, 100)})
                PackTween(Circle, 0.2, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                callback(state)
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(text, min, max, def, callback)
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(0.97, 0, 0, 45)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Text = "  " .. text
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValLabel = Instance.new("TextLabel", SliderFrame)
            ValLabel.Text = tostring(def) .. "  "
            ValLabel.Size = UDim2.new(1, 0, 0, 25)
            ValLabel.TextColor3 = Color3.fromRGB(0, 122, 255)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right

            local Bar = Instance.new("TextButton", SliderFrame)
            Bar.Size = UDim2.new(0.9, 0, 0, 4)
            Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            Bar.Text = ""
            Instance.new("UICorner", Bar)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
            Instance.new("UICorner", Fill)

            local dragging = false
            local function update()
                local pct = math.clamp((Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max-min) * pct)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                ValLabel.Text = tostring(val) .. "  "
                callback(val)
            end
            Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            Mouse.Move:Connect(function() if dragging then update() end end)
        end

        return Elements
    end

    -- Кнопка закрытия
    CloseBtn.MouseButton1Click:Connect(function()
        PackTween(Main, 0.3, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    -- Кнопка сворачивания
    local minned = false
    MinBtn.MouseButton1Click:Connect(function()
        minned = not minned
        PackTween(Main, 0.4, {Size = minned and UDim2.new(0, 580, 0, 40) or UDim2.new(0, 580, 0, 400)})
        Sidebar.Visible = not minned
        Pages.Visible = not minned
    end)

    -- Драггинг (Перетаскивание)
    local d, di, ds, sp
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
    Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end end)
    UserInputService.InputChanged:Connect(function(i)
        if i == di and d then
            local del = i.Position - ds
            Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

    return Tabs
end

return AppleLib
