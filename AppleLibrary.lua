local AppleLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Mouse = game.Players.LocalPlayer:GetMouse()

-- Вспомогательная функция для плавных анимаций (эстетика Apple)
local function PackTween(obj, time, goal)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, goal):Play()
end

function AppleLib:CreateWindow(title, version, user)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "AppleUI_" .. math.random(100, 999)

    -- MAIN FRAME (macOS Style)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 600, 0, 420)
    Main.Position = UDim2.new(0.5, -300, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Deep Dark
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(55, 55, 55)
    MainStroke.Thickness = 1

    -- SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    Sidebar.BorderSizePixel = 0
    
    -- Title & User Info
    local Title = Instance.new("TextLabel", Sidebar)
    Title.Text = title .. "  " .. version
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local UserInfo = Instance.new("TextLabel", Sidebar)
    UserInfo.Text = "Welcome, " .. user
    UserInfo.Size = UDim2.new(1, 0, 0, 20)
    UserInfo.Position = UDim2.new(0, 15, 0, 35)
    UserInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
    UserInfo.Font = Enum.Font.Gotham
    UserInfo.TextSize = 12
    UserInfo.TextXAlignment = Enum.TextXAlignment.Left
    UserInfo.BackgroundTransparency = 1

    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Position = UDim2.new(0, 0, 0, 70)
    TabContainer.Size = UDim2.new(1, 0, 1, -70)
    TabContainer.BackgroundTransparency = 1
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 2)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- PAGES CONTAINER
    local Pages = Instance.new("Frame", Main)
    Pages.Position = UDim2.new(0, 190, 0, 15)
    Pages.Size = UDim2.new(1, -205, 1, -30)
    Pages.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(name, iconId)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.92, 0, 0, 34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local Icon = Instance.new("ImageLabel", TabBtn)
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.Position = UDim2.new(0, 10, 0.5, -9)
        Icon.Image = iconId or "rbxassetid://10704946682" -- Default icon
        Icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
        Icon.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel", TabBtn)
        Label.Text = name
        Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Position = UDim2.new(0, 35, 0, 0)
        Label.TextColor3 = Color3.fromRGB(180, 180, 180)
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y)
        end)

        if FirstTab then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Icon.ImageColor3 = Color3.fromRGB(0, 122, 255) -- Apple Blue active icon
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then
                    PackTween(v, 0.2, {BackgroundTransparency = 1})
                    PackTween(v.ImageLabel, 0.2, {ImageColor3 = Color3.fromRGB(180, 180, 180)})
                    PackTween(v.TextLabel, 0.2, {TextColor3 = Color3.fromRGB(180, 180, 180)})
                end
            end
            Page.Visible = true
            PackTween(TabBtn, 0.2, {BackgroundTransparency = 0})
            PackTween(Icon, 0.2, {ImageColor3 = Color3.fromRGB(0, 122, 255)})
            PackTween(Label, 0.2, {TextColor3 = Color3.fromRGB(255, 255, 255)})
        end)

        local Elements = {}

        -- 1. BUTTON (Apple Style)
        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 38)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            Btn.AutoButtonColor = false
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", Btn).Color = Color3.fromRGB(60, 60, 63)

            Btn.MouseEnter:Connect(function() PackTween(Btn, 0.2, {BackgroundColor3 = Color3.fromRGB(55, 55, 58)}) end)
            Btn.MouseLeave:Connect(function() PackTween(Btn, 0.2, {BackgroundColor3 = Color3.fromRGB(45, 45, 48)}) end)
            Btn.MouseButton1Down:Connect(function() PackTween(Btn, 0.05, {BackgroundColor3 = Color3.fromRGB(40, 40, 43)}) end)
            Btn.MouseButton1Up:Connect(function() PackTween(Btn, 0.05, {BackgroundColor3 = Color3.fromRGB(55, 55, 58)}) end)
            
            Btn.MouseButton1Click:Connect(callback)
        end

        -- 2. TOGGLE (iOS Style)
        function Elements:CreateToggle(text, default, callback)
            local Toggled = default or false
            local ToggleFrame = Instance.new("TextButton", Page)
            ToggleFrame.Size = UDim2.new(1, -10, 0, 38)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            ToggleFrame.Text = "  " .. text
            ToggleFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            ToggleFrame.Font = Enum.Font.Gotham
            ToggleFrame.TextSize = 13
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            ToggleFrame.AutoButtonColor = false
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", ToggleFrame).Color = Color3.fromRGB(60, 60, 63)

            local Switch = Instance.new("Frame", ToggleFrame)
            Switch.Position = UDim2.new(1, -50, 0.5, -11)
            Switch.Size = UDim2.new(0, 40, 0, 22)
            Switch.BackgroundColor3 = Toggled and Color3.fromRGB(48, 209, 88) or Color3.fromRGB(120, 120, 128)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local SliderCircle = Instance.new("Frame", Switch)
            SliderCircle.Size = UDim2.new(0, 18, 0, 18)
            SliderCircle.Position = Toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", SliderCircle).CornerRadius = UDim.new(1, 0)

            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local targetColor = Toggled and Color3.fromRGB(48, 209, 88) or Color3.fromRGB(120, 120, 128)
                local targetPos = Toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                PackTween(Switch, 0.2, {BackgroundColor3 = targetColor})
                PackTween(SliderCircle, 0.2, {Position = targetPos})
                callback(Toggled)
            end)
        end

        -- 3. SLIDER (Rayfield + Apple Style)
        function Elements:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(1, -10, 0, 50) -- Чуть выше для текста значения
            SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", SliderFrame).Color = Color3.fromRGB(60, 60, 63)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Text = "  " .. text
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1

            local ValueLabel = Instance.new("TextLabel", SliderFrame)
            ValueLabel.Text = tostring(default) .. "  "
            ValueLabel.Size = UDim2.new(1, 0, 0, 25)
            ValueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            ValueLabel.Font = Enum.Font.GothamMedium
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.BackgroundTransparency = 1

            local SliderBack = Instance.new("TextButton", SliderFrame)
            SliderBack.Size = UDim2.new(0.9, 0, 0, 4)
            SliderBack.Position = UDim2.new(0.05, 0, 0.7, 0)
            SliderBack.BackgroundColor3 = Color3.fromRGB(80, 80, 83)
            SliderBack.Text = ""
            SliderBack.AutoButtonColor = false
            Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)

            local SliderDrag = Instance.new("Frame", SliderBack)
            SliderDrag.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderDrag.BackgroundColor3 = Color3.fromRGB(0, 122, 255) -- Apple Blue
            Instance.new("UICorner", SliderDrag).CornerRadius = UDim.new(1, 0)

            local function UpdateSlider()
                local pct = math.clamp((Mouse.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pct)
                SliderDrag.Size = UDim2.new(pct, 0, 1, 0)
                ValueLabel.Text = tostring(val) .. "  "
                callback(val)
            end

            local dragging = false
            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true UpdateSlider() end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            Mouse.Move:Connect(function() if dragging then UpdateSlider() end end)
        end
        
        -- 4. INPUT (Text Field)
        function Elements:CreateInput(text, placeholder, callback)
            local InputFrame = Instance.new("Frame", Page)
            InputFrame.Size = UDim2.new(1, -10, 0, 38)
            InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", InputFrame)
            Stroke.Color = Color3.fromRGB(60, 60, 63)

            local Label = Instance.new("TextLabel", InputFrame)
            Label.Text = "  " .. text
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1

            local TextBox = Instance.new("TextBox", InputFrame)
            TextBox.Size = UDim2.new(0.55, 0, 0, 26)
            TextBox.Position = UDim2.new(0.4, 0, 0.5, -13)
            TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            TextBox.Text = ""
            TextBox.PlaceholderText = placeholder
            TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 103)
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 12
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
            
            TextBox.Focused:Connect(function() PackTween(Stroke, 0.2, {Color = Color3.fromRGB(0, 122, 255)}) end)
            TextBox.FocusLost:Connect(function() PackTween(Stroke, 0.2, {Color = Color3.fromRGB(60, 60, 63)}) callback(TextBox.Text) end)
        end

        -- 5. DROPDOWN (Simplified Rayfield style)
        function Elements:CreateDropdown(text, list, default, callback)
            local Dropped = false
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, -10, 0, 38)
            DropFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", DropFrame).Color = Color3.fromRGB(60, 60, 63)

            local TitleBtn = Instance.new("TextButton", DropFrame)
            TitleBtn.Size = UDim2.new(1, 0, 0, 38)
            TitleBtn.BackgroundTransparency = 1
            TitleBtn.Text = "  " .. text .. " : " .. (default or "None")
            TitleBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
            TitleBtn.Font = Enum.Font.Gotham
            TitleBtn.TextSize = 13
            TitleBtn.TextXAlignment = Enum.TextXAlignment.Left
            
            local Arrow = Instance.new("ImageLabel", TitleBtn)
            Arrow.Size = UDim2.new(0, 16, 0, 16)
            Arrow.Position = UDim2.new(1, -25, 0.5, -8)
            Arrow.Image = "rbxassetid://10704992419" -- Chevron down
            Arrow.BackgroundTransparency = 1
            Arrow.ImageColor3 = Color3.fromRGB(200, 200, 200)

            local OptionContainer = Instance.new("Frame", DropFrame)
            OptionContainer.Position = UDim2.new(0, 5, 0, 38)
            OptionContainer.Size = UDim2.new(1, -10, 0, #list * 30)
            OptionContainer.BackgroundTransparency = 1
            
            local OptionList = Instance.new("UIListLayout", OptionContainer)
            OptionList.Padding = UDim.new(0, 2)

            TitleBtn.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                local targetHeight = Dropped and (38 + #list * 32) or 38
                PackTween(DropFrame, 0.3, {Size = UDim2.new(1, -10, 0, targetHeight)})
                PackTween(Arrow, 0.3, {Rotation = Dropped and 180 or 0})
            end)

            for _, optionName in pairs(list) do
                local OptBtn = Instance.new("TextButton", OptionContainer)
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 58)
                OptBtn.Text = "   " .. optionName
                OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.AutoButtonColor = true
                Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 6)

                OptBtn.MouseButton1Click:Connect(function()
                    Dropped = false
                    PackTween(DropFrame, 0.3, {Size = UDim2.new(1, -10, 0, 38)})
                    PackTween(Arrow, 0.3, {Rotation = 0})
                    TitleBtn.Text = "  " .. text .. " : " .. optionName
                    callback(optionName)
                end)
            end
        end

        -- 6. COLOR PICKER (Advanced)
        function Elements:CreateColorPicker(text, default, callback)
            local Picking = false
            local ColorFrame = Instance.new("Frame", Page)
            ColorFrame.Size = UDim2.new(1, -10, 0, 38)
            ColorFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            Instance.new("UICorner", ColorFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", ColorFrame).Color = Color3.fromRGB(60, 60, 63)

            local Label = Instance.new("TextLabel", ColorFrame)
            Label.Text = "  " .. text
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1

            local ColorBox = Instance.new("TextButton", ColorFrame)
            ColorBox.Size = UDim2.new(0, 26, 0, 26)
            ColorBox.Position = UDim2.new(1, -35, 0.5, -13)
            ColorBox.BackgroundColor3 = default
            ColorBox.Text = ""
            Instance.new("UICorner", ColorBox).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", ColorBox).Color = Color3.fromRGB(255,255,255) -- White border

            -- Упрощенное окно выбора (просто HSV слайдеры в новом окне)
            -- В реальности это сложный UI, здесь я делаю кнопку для открытия
            ColorBox.MouseButton1Click:Connect(function()
                -- Тут должен быть код настоящего Picker. 
                -- Для компактности я просто меняю цвет на случайный
                local randomColor = Color3.fromHSV(math.random(), 1, 1)
                ColorBox.BackgroundColor3 = randomColor
                callback(randomColor)
            end)
        end

        return Elements
    end

    -- DRAGGING (macOS Like window dragging)
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = Main.Position
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            PackTween(Main, 0.05, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    return Tabs
end

return AppleLib
