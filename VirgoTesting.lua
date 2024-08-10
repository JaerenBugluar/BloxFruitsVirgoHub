local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--Toggle UI
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local soundId = "rbxassetid://130785805" 
local sound = Instance.new("Sound")
sound.Name = "ButtonClickSound"
sound.SoundId = soundId
sound.Parent = ReplicatedStorage

local MainScreenGui = Instance.new("ScreenGui")
local ButtonScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

MainScreenGui.Name = "MainScreenGui"
MainScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

ButtonScreenGui.Name = "ButtonScreenGui"
ButtonScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

ImageButton.Parent = ButtonScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.5, 10, 0, 10) 
ImageButton.AnchorPoint = Vector2.new(0.5, 0) 
ImageButton.Size = UDim2.new(0, 40, 0, 40)
ImageButton.Image = "rbxassetid://18403614991"

UICorner.CornerRadius = UDim.new(1, 0) 
UICorner.Parent = ImageButton

UIStroke.Color = Color3.fromRGB(75, 0, 130)
UIStroke.Parent = ImageButton

-- Thêm phần thay đổi màu RGB liên tục cho UIStroke
local colors = {
    Color3.fromRGB(255, 0, 0),   -- Đỏ
    Color3.fromRGB(255, 165, 0), -- Cam
    Color3.fromRGB(255, 255, 0), -- Vàng
    Color3.fromRGB(3, 252, 40),   -- Xanh lá
    Color3.fromRGB(0, 0, 255),   -- Xanh dương
    Color3.fromRGB(75, 0, 130),  -- Chàm
    Color3.fromRGB(23, 255, 224)-- Tím
}

local index = 1

spawn(function()
    while true do
        UIStroke.Color = colors[index]
        index = index % #colors + 1 
        wait(0.5) 
    end
end)

local function toggleUI()
    MainScreenGui.Enabled = not MainScreenGui.Enabled
end

ImageButton.MouseButton1Click:Connect(function()
    
    local goal = {Rotation = 360} 
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back) 
    local tween = TweenService:Create(ImageButton, tweenInfo, goal)

    tween:Play()
    tween.Completed:Connect(function()
        ImageButton.Rotation = 0 
        toggleUI() 
    end)

    local clickSound = sound:Clone()
    clickSound.Parent = SoundService
    clickSound:Play()
    
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
end)

local Window = Fluent:CreateWindow({
    Title = "BloxFruits | Virgo Hub",
    SubTitle = "Hello! " .. game.Player.LocalPlayer.DisplayName,
    TabWidth = 100,
    Size = UDim2.fromOffset(400, 280),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Sh = Window:AddTab({ Title = "Shop Tab", Icon = "shopping-cart" }),
    Main = Window:AddTab({ Title = "Farming Tab", Icon = "house" }),
    Qs = Window:AddTab({ Title = "Sub Farming", Icon = "house-plus" }), 
    stack = Window:AddTab({ Title = "Stack Farming", Icon = "layers" }), 
    Se = Window:AddTab({ Title = "Sea Event Tab", Icon = "sailboat" }),   
    St = Window:AddTab({ Title = "Status and Server", Icon = "chart-bar-increasing" }),    
    Lc = Window:AddTab({ Title = "Travel Tab", Icon = "map-pin" }),   
    spl = Window:AddTab({ Title = "Player Status", Icon = "user" }),   
    RC = Window:AddTab({ Title = "Upgrade Race", Icon = "cog" }),
    raid = Window:AddTab({ Title = "Dungeon Tab", Icon = "door-open" }),
    De = Window:AddTab({ Title = "Fruit Tab", Icon = "cherry" }),    
    Ms = Window:AddTab({ Title = "Misc Tab", Icon = "square-kanban" }),   
    Settings = Window:AddTab({ Title = "Setting Tab", Icon = "settings" }),
}

local Options = Fluent.Options


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()