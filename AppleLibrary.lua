local AppleLib = {
    Open = true,
    Bind = Enum.KeyCode.RightShift,
    Themes = {
        Dark = {
            Main = Color3.fromRGB(28, 28, 30),
            Sidebar = Color3.fromRGB(35, 35, 37),
            Element = Color3.fromRGB(45, 45, 47),
            Text = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(0, 122, 255)
        },
        Light = {
            Main = Color3.fromRGB(242, 242, 247),
            Sidebar = Color3.fromRGB(255, 255, 255),
            Element = Color3.fromRGB(229, 229, 234),
            Text = Color3.fromRGB(0, 0, 0),
            Accent = Color3.fromRGB(0, 122, 255)
        },
        Midnight = {
            Main = Color3.fromRGB(10, 10, 12),
            Sidebar = Color3.fromRGB(15, 15, 17),
            Element = Color3.fromRGB(25, 25, 27),
            Text = Color3.fromRGB(255, 255, 255),
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

function AppleLib:SetBind(key)
    self.Bind = key
end

function AppleLib:CreateWindow(title, version, user, themeName)
    local theme = self.Themes[themeName] or self.Themes.Dark
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 580, 0, 400)
    Main.Position = UDim2.new(0.5, -290, 0.5, -200)
    Main.BackgroundColor3 = theme.Main
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", Main).Color = theme.Element

    -- Управление Keybind
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.Bind then
            self.Open = not self.Open
            Main.Visible = self.Open
        end
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 170, 1, 0)
    Sidebar.BackgroundColor3 = theme.Sidebar
    Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    -- Pages
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -190, 1, -60)
    Pages.Position = UDim2.new(0, 180, 0, 50)
    Pages.BackgroundTransparency = 1

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

        -- BUTTON
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
            return {
                SetText = function(_, newText) Btn.Text = "  " .. newText end
            }
        end

        -- TOGGLE (с функцией Set)
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

            local Switch = Instance.new("Frame", Tgl)
            Switch.Size = UDim2.new(0, 34, 0, 18)
            Switch.Position = UDim2.new(1, -40, 0.5, -9)
            Switch.BackgroundColor3 = state and theme.Accent or Color3.fromRGB(100, 100, 100)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local function update()
                PackTween(Switch, 0.2, {BackgroundColor3 = state and theme.Accent or Color3.fromRGB(100, 100, 100)})
                callback(state)
            end

            Tgl.MouseButton1Click:Connect(function()
                state = not state
                update()
            end)

            return {
                Set = function(_, val) state = val update() end
            }
        end

        -- SLIDER (с функцией Set)
        function Elements:CreateSlider(text, min, max, def, callback)
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(0.97, 0, 0, 45)
            SliderFrame.BackgroundColor3 = theme.Element
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local ValLabel = Instance.new("TextLabel", SliderFrame)
            ValLabel.Size = UDim2.new(1, -10, 0, 25)
            ValLabel.Text = tostring(def)
            ValLabel.TextColor3 = theme.Accent
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.BackgroundTransparency = 1

            local Bar = Instance.new("TextButton", SliderFrame)
            Bar.Size = UDim2.new(0.9, 0, 0, 4)
            Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            Bar.Text = ""

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = theme.Accent

            local function setVal(v)
                local pct = math.clamp((v - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                ValLabel.Text = tostring(v)
                callback(v)
            end

            Bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local moveConn
                    moveConn = Mouse.Move:Connect(function()
                        local pct = math.clamp((Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local val = math.floor(min + (max-min) * pct)
                        setVal(val)
                    end)
                    UserInputService.InputEnded:Connect(function(i2)
                        if i2.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect() end
                    end)
                end
            end)

            return { Set = function(_, v) setVal(v) end }
        end

        return Elements
    end

    -- Драггинг
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
