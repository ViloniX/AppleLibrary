local AppleLib = {}
local TweenService = game:GetService("TweenService")

function AppleLib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "AppleUI_" .. math.random(100, 999)

    -- Main Frame (macOS Style)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Deep Dark
    Main.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 14)

    -- Stroke (Тонкая рамка как в iOS)
    local UIStroke = Instance.new("UIStroke", Main)
    UIStroke.Color = Color3.fromRGB(60, 60, 60)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    Sidebar.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel", Sidebar)
    Title.Text = "  " .. title
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.BackgroundTransparency = 1
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Pages = Instance.new("Frame", Main)
    Pages.Position = UDim2.new(0, 170, 0, 15)
    Pages.Size = UDim2.new(1, -185, 1, -30)
    Pages.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "   " .. name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabBtnCorner = Instance.new("UICorner", TabBtn)
        TabBtnCorner.CornerRadius = UDim.new(0, 8)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 10)

        if FirstTab then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            Btn.AutoButtonColor = true
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            
            Btn.MouseButton1Click:Connect(callback)
        end

        function Elements:CreateToggle(text, callback)
            local Toggled = false
            local ToggleFrame = Instance.new("TextButton", Page)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            ToggleFrame.Text = "  " .. text
            ToggleFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            ToggleFrame.Font = Enum.Font.Gotham
            ToggleFrame.TextSize = 14
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

            local Indicator = Instance.new("Frame", ToggleFrame)
            Indicator.Position = UDim2.new(1, -45, 0.5, -10)
            Indicator.Size = UDim2.new(0, 35, 0, 20)
            Indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local targetColor = Toggled and Color3.fromRGB(48, 209, 88) or Color3.fromRGB(100, 100, 100)
                TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
                callback(Toggled)
            end)
        end

        return Elements
    end

    -- Dragging (Скрипт перетаскивания)
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    return Tabs
end

return AppleLib