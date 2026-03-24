local AppleLib = {
    Open = true,
    Bind = Enum.KeyCode.RightShift,
    Themes = {
        Midnight = {
            Main = Color3.fromRGB(12, 12, 14),
            Sidebar = Color3.fromRGB(18, 18, 20),
            Element = Color3.fromRGB(25, 25, 27),
            ElementActive = Color3.fromRGB(35, 35, 37),
            Text = Color3.fromRGB(240, 240, 240),
            Accent = Color3.fromRGB(160, 32, 240)
        }
    }
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Mouse = game.Players.LocalPlayer:GetMouse()

local function PackTween(obj, time, goal)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, goal):Play()
end

function AppleLib:CreateWindow(title, version, user)
    local theme = self.Themes.Midnight
    local ScreenGui = Instance.new("ScreenGui")
    pcall(function() ScreenGui.Parent = game.CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:FindFirstChild("PlayerGui") end
    ScreenGui.Name = "AppleUI_" .. math.random(100,999)
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 580, 0, 400)
    Main.Position = UDim2.new(0.5, -290, 0.5, -200)
    Main.BackgroundColor3 = theme.Main
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(50, 50, 50)

    -- Topbar (macos circles)
    local Controls = Instance.new("Frame", Main)
    Controls.Size = UDim2.new(0, 60, 0, 40)
    Controls.Position = UDim2.new(0, 15, 0, 0)
    Controls.BackgroundTransparency = 1
    local CL = Instance.new("UIListLayout", Controls)
    CL.FillDirection = Enum.FillDirection.Horizontal
    CL.Padding = UDim.new(0, 8)
    CL.VerticalAlignment = Enum.VerticalAlignment.Center

    for _, color in pairs({Color3.fromRGB(255, 69, 58), Color3.fromRGB(255, 186, 10), Color3.fromRGB(50, 215, 75)}) do
        local d = Instance.new("Frame", Controls)
        d.Size = UDim2.new(0, 10, 0, 10)
        d.BackgroundColor3 = color
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    end

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 170, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = theme.Sidebar
    Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -190, 1, -60)
    Pages.Position = UDim2.new(0, 180, 0, 50)
    Pages.BackgroundTransparency = 1

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.Bind then
            Main.Visible = not Main.Visible
        end
    end)

    local Tabs = {}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 32)
        TabBtn.BackgroundColor3 = theme.Element
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = theme.Text
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then PackTween(v, 0.2, {BackgroundTransparency = 1}) end end
            Page.Visible = true
            PackTween(TabBtn, 0.2, {BackgroundTransparency = 0})
        end)

        if #TabContainer:GetChildren() == 1 then Page.Visible = true TabBtn.BackgroundTransparency = 0 end

        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(0.97, 0, 0, 36)
            Btn.BackgroundColor3 = theme.Element
            Btn.Text = "  " .. text
            Btn.TextColor3 = theme.Text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            Btn.MouseButton1Click:Connect(callback)
            return { SetText = function(_, t) Btn.Text = "  " .. t end }
        end

        function Elements:CreateToggle(text, def, callback)
            local state = def or false
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(0.97, 0, 0, 36)
            Tgl.BackgroundColor3 = theme.Element
            Tgl.Text = "  " .. text
            Tgl.TextColor3 = theme.Text
            Tgl.Font = Enum.Font.Gotham
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)

            local Sw = Instance.new("Frame", Tgl)
            Sw.Size = UDim2.new(0, 34, 0, 18)
            Sw.Position = UDim2.new(1, -40, 0.5, -9)
            Sw.BackgroundColor3 = state and theme.Accent or Color3.fromRGB(100, 100, 100)
            Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)

            local function up()
                PackTween(Sw, 0.2, {BackgroundColor3 = state and theme.Accent or Color3.fromRGB(100, 100, 100)})
                callback(state)
            end
            Tgl.MouseButton1Click:Connect(function() state = not state up() end)
            return { Set = function(_, v) state = v up() end }
        end

        function Elements:CreateSlider(text, min, max, def, callback)
            local SFrame = Instance.new("Frame", Page)
            SFrame.Size = UDim2.new(0.97, 0, 0, 45)
            SFrame.BackgroundColor3 = theme.Element
            Instance.new("UICorner", SFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", SFrame)
            Label.Text = "  " .. text
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.TextColor3 = theme.Text
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Val = Instance.new("TextLabel", SFrame)
            Val.Size = UDim2.new(1, -10, 0, 20)
            Val.Text = tostring(def)
            Val.TextColor3 = theme.Accent
            Val.BackgroundTransparency = 1
            Val.TextXAlignment = Enum.TextXAlignment.Right

            local Bar = Instance.new("TextButton", SFrame)
            Bar.Size = UDim2.new(0.9, 0, 0, 4)
            Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Bar.Text = ""

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = theme.Accent

            local function update()
                local pct = math.clamp((Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + (max-min) * pct)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Val.Text = tostring(v)
                callback(v)
            end
            Bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local move; move = Mouse.Move:Connect(update)
                    UserInputService.InputEnded:Connect(function(i2)
                        if i2.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
                    end)
                    update()
                end
            end)
            return { Set = function(_, v) 
                local p = math.clamp((v - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(p, 0, 1, 0)
                Val.Text = tostring(v)
                callback(v)
            end }
        end
        return Elements
    end

    -- Dragging
    local d, ds, sp
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local del = i.Position - ds
        Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

    return Tabs
end

return AppleLib
