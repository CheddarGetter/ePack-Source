local Prompt = Instance.new("ScreenGui")
Prompt.Name = "Prompt"
Prompt.DisplayOrder = 1e+09
Prompt.IgnoreGuiInset = true
Prompt.ResetOnSpawn = false
Prompt.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local BackFrame = Instance.new("Frame")
BackFrame.Name = "BackFrame"
BackFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackFrame.AutomaticSize = Enum.AutomaticSize.XY
BackFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BackFrame.BackgroundTransparency = 0.05
BackFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
BackFrame.BorderSizePixel = 0
BackFrame.Position = UDim2.fromScale(0.5, 0.5)

local Corner = Instance.new("UICorner")
Corner.Name = "Corner"
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = BackFrame

local Layout = Instance.new("UIListLayout")
Layout.Name = "Layout"
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = BackFrame

local Padding = Instance.new("UIPadding")
Padding.Name = "Padding"
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.PaddingTop = UDim.new(0, 10)
Padding.Parent = BackFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Font = Enum.Font.ArialBold
Title.RichText = true
Title.Text = "Text"
Title.TextColor3 = Color3.fromRGB(204, 204, 204)
Title.TextSize = 23
Title.TextYAlignment = Enum.TextYAlignment.Top
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 1
Title.Size = UDim2.fromOffset(300, 25)
Title.Parent = BackFrame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.RichText = true
InfoLabel.Text = "Text"
InfoLabel.TextColor3 = Color3.fromRGB(204, 204, 204)
InfoLabel.TextSize = 23
InfoLabel.TextTransparency = 0.25
InfoLabel.TextWrapped = true
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.AutomaticSize = Enum.AutomaticSize.XY
InfoLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.BackgroundTransparency = 1

local Padding1 = Instance.new("UIPadding")
Padding1.Name = "Padding1"
Padding1.PaddingBottom = UDim.new(0, 15)
Padding1.PaddingTop = UDim.new(0, 5)
Padding1.Parent = InfoLabel

InfoLabel.Parent = BackFrame

local ButtonHolder = Instance.new("Frame")
ButtonHolder.Name = "ButtonHolder"
ButtonHolder.AutomaticSize = Enum.AutomaticSize.X
ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.Size = UDim2.fromOffset(300, 30)
ButtonHolder.Visible = false

local ButtonPrefab = Instance.new("TextButton")
ButtonPrefab.Name = "ButtonPrefab"
ButtonPrefab.Font = Enum.Font.SourceSans
ButtonPrefab.RichText = true
ButtonPrefab.Text = "Text"
ButtonPrefab.TextColor3 = Color3.fromRGB(204, 204, 204)
ButtonPrefab.TextSize = 23
ButtonPrefab.AutomaticSize = Enum.AutomaticSize.X
ButtonPrefab.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
ButtonPrefab.BackgroundTransparency = 0.8
ButtonPrefab.BorderSizePixel = 0
ButtonPrefab.Size = UDim2.new(0, 150, 1, 0)
ButtonPrefab.Visible = false

local Corner1 = Instance.new("UICorner")
Corner1.Name = "Corner1"
Corner1.CornerRadius = UDim.new(0, 4)
Corner1.Parent = ButtonPrefab

local Stroke = Instance.new("UIStroke")
Stroke.Name = "Stroke"
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Color = Color3.fromRGB(204, 204, 204)
Stroke.Thickness = 0.8
Stroke.Parent = ButtonPrefab

local ButtonPadding = Instance.new("UIPadding")
ButtonPadding.Name = "ButtonPadding"
ButtonPadding.PaddingBottom = UDim.new(0, 3)
ButtonPadding.PaddingLeft = UDim.new(0, 3)
ButtonPadding.PaddingRight = UDim.new(0, 3)
ButtonPadding.PaddingTop = UDim.new(0, 3)
ButtonPadding.Parent = ButtonPrefab

ButtonPrefab.Parent = ButtonHolder

local Layout1 = Instance.new("UIGridLayout")
Layout1.Name = "Layout1"
Layout1.CellPadding = UDim2.fromOffset(10, 10)
Layout1.CellSize = UDim2.fromOffset(150, 30)
Layout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout1.SortOrder = Enum.SortOrder.LayoutOrder
Layout1.Parent = ButtonHolder

ButtonHolder.Parent = BackFrame
BackFrame.Parent = Prompt


-- Non convertable
if (syn) then
    syn.protect_gui(Prompt)
end

Prompt.Parent = syn and game:GetService("CoreGui") or nil


-- Functions
local function SetTitleText(Text)
    Title.Text = Text
end

local function SetInfoText(Text)
    InfoLabel.Text = Text
end

local function DestroyButtons()
    for _, b in ipairs(ButtonHolder:GetChildren()) do
        if (b:IsA("TextButton") and b ~= ButtonPrefab) then
            b:Destroy()
        end
    end

    ButtonHolder.Visible = false
end

local function NewButton(Text, ClickedCallback)
    if (not ButtonHolder.Visible) then
        ButtonHolder.Visible = true
    end

    local Button = ButtonPrefab:Clone()
    Button.Name = Text
    Button.Text = Text
    Button.Parent = ButtonPrefab.Parent
    Button.Visible = true

    Button.MouseButton1Click:Connect(ClickedCallback)
end

local function CreateCloseButton()
    DestroyButtons()

    NewButton("Close", function()
        Prompt:Destroy()

        if (InstallCompleted) then -- for debugging lol
            InstallCompleted:Fire()
        end
    end)
end


-- Functionality
SetTitleText("Install Wizard")
SetInfoText("Would you like to install ePack?\nThis creates files & folders inside of your workspace folder")

NewButton("Yes", function()
    SetInfoText("Creating folder directory...")
    DestroyButtons()
    
    for _, f in ipairs({"ePack", "ePack/Packs", "ePack/Data"}) do
        if (not isfolder(f)) then
            makefolder(f)
        end
    end

    task.wait(0.5)

    SetInfoText("Installing the ePack Controller...")
    local src = game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack-Source/master/src/Controller.lua")
    if (IsProductionBuild) then
        writefile("ePack/Controller.lua", src)
    end
    
    SetInfoText("ePack successfully installed")

    CreateCloseButton()
end)

NewButton("No", function()
    Prompt:Destroy()
end)
