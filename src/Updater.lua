if (IsProductionBuild) then
    local ePackConfig = GetConfig "ePackConfig"

    if (ePackConfig.DeveloperMode == true) then
        warn("ePack Controller is outdated (Developer Mode)")
        return
    end
end


-- Instances
local ePackPrompt = Instance.new("ScreenGui")
local BackFrame = Instance.new("Frame")
local Layout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")
local Padding = Instance.new("UIPadding")
local InfoLabel = Instance.new("TextLabel")
local ButtonHolder = Instance.new("Frame")
local ButtonPrefab = Instance.new("TextButton")
local Corner = Instance.new("UICorner")
local Stroke = Instance.new("UIStroke")
local ButtonPadding = Instance.new("UIPadding")
local UIListLayout = Instance.new("UIListLayout")
local Stroke_2 = Instance.new("UIStroke")
local Corner_2 = Instance.new("UICorner")

-- Instance Properties
ePackPrompt.Name = "ePackPrompt"
ePackPrompt.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ePackPrompt.DisplayOrder = 1000000000
ePackPrompt.ResetOnSpawn = false
if (syn) then syn.protect_gui(ePackPrompt) end
ePackPrompt.Parent = syn and game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

BackFrame.Name = "BackFrame"
BackFrame.AutomaticSize = Enum.AutomaticSize.XY
BackFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BackFrame.BackgroundTransparency = 0.050
BackFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
BackFrame.BorderSizePixel = 0
BackFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BackFrame.Parent = ePackPrompt

Layout.Name = "Layout"
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 25)
Layout.Parent = BackFrame

Title.Name = "Title"
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 1.000
Title.Size = UDim2.new(0, 300, 0, 25)
Title.RichText = true
Title.Font = Enum.Font.ArialBold
Title.Text = "Text"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 23.000
Title.TextYAlignment = Enum.TextYAlignment.Top
Title.Parent = BackFrame

Padding.Name = "Padding"
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.PaddingTop = UDim.new(0, 10)
Padding.Parent = BackFrame

InfoLabel.Name = "InfoLabel"
InfoLabel.AutomaticSize = Enum.AutomaticSize.XY
InfoLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.BackgroundTransparency = 1.000
InfoLabel.RichText = true
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.Text = "Text"
InfoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoLabel.TextSize = 23.000
InfoLabel.TextTransparency = 0.250
InfoLabel.TextWrapped = true
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.Parent = BackFrame

ButtonHolder.Name = "ButtonHolder"
ButtonHolder.AutomaticSize = Enum.AutomaticSize.X
ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonHolder.BackgroundTransparency = 1.000
ButtonHolder.Size = UDim2.new(0, 300, 0, 35)
ButtonHolder.Visible = false
ButtonHolder.Parent = BackFrame

ButtonPrefab.Name = "ButtonPrefab"
ButtonPrefab.AutomaticSize = Enum.AutomaticSize.X
ButtonPrefab.BackgroundColor3 = Color3.fromRGB(104, 104, 104)
ButtonPrefab.BackgroundTransparency = 0.600
ButtonPrefab.BorderSizePixel = 0
ButtonPrefab.Size = UDim2.new(0, 150, 1, 0)
ButtonPrefab.Visible = false
ButtonPrefab.RichText = true
ButtonPrefab.Font = Enum.Font.SourceSans
ButtonPrefab.Text = "Text"
ButtonPrefab.TextColor3 = Color3.fromRGB(220, 220, 220)
ButtonPrefab.TextSize = 23.000
ButtonPrefab.Parent = ButtonHolder

Corner.Name = "Corner"
Corner.CornerRadius = UDim.new(0, 4)
Corner.Parent = ButtonPrefab

Stroke.Name = "Stroke"
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Color = Color3.fromRGB(115, 115, 115)
Stroke.Thickness = 0.800
Stroke.Parent = ButtonPrefab

ButtonPadding.Name = "ButtonPadding"
ButtonPadding.PaddingBottom = UDim.new(0, 3)
ButtonPadding.PaddingLeft = UDim.new(0, 3)
ButtonPadding.PaddingRight = UDim.new(0, 3)
ButtonPadding.PaddingTop = UDim.new(0, 3)
ButtonPadding.Parent = ButtonPrefab

UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ButtonHolder

Stroke_2.Name = "Stroke"
Stroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke_2.Color = Color3.fromRGB(255, 255, 255)
Stroke_2.Transparency = 0.550
Stroke_2.Parent = BackFrame

Corner_2.Name = "Corner"
Corner_2.CornerRadius = UDim.new(0, 4)
Corner_2.Parent = BackFrame


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
        ePackPrompt:Destroy()

        if (InstallCompleted) then -- for debugging lol
            InstallCompleted:Fire()
        end
    end)
end


local Start
Start = function ()
    SetTitleText("ePack")
    SetInfoText("Would you like to update your ePack Controller?\nIt's outdated from the one on the github repository!")
    DestroyButtons()
    
    NewButton("Yes", function()
        ButtonHolder.Visible = false
        InfoLabel.Text = "Installing Controller..."
        
        local src = game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/ePack/main/Controller.lua")
        if (IsProductionBuild) then
            writefile("ePack/Controller.lua", src)
        end
    
        task.wait(0.5)
    
        SetInfoText("Update complete!\n\nWould you like to rejoin your current game?\nePack will not run the latest version if you don't")
        DestroyButtons()
    
        NewButton("Yes", function()
            ePackPrompt:Destroy()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end)
    
        NewButton("No", function()
            ePackPrompt:Destroy()
        end)
    end)

    NewButton("Enable Developer Mode", function()
        SetInfoText('<font color="rgb(255, 0, 0)"><b><u>Are you sure you want to enable developer mode?</u></b></font>\nYou will not be asked to update your ePack controller when it\'s outdated\nThis can cause things not to work as intended')
        DestroyButtons()
    
        NewButton("Yes", function()
            if (IsProductionBuild) then
                ePackConfig.DeveloperMode = true
            end
    
            SetInfoText('Developer mode enabled')
            CreateCloseButton()
        end)
    
        NewButton("Back", function()
            Start()
        end)
    end)
    
    NewButton("No", function()
        ePackPrompt:Destroy()
    end)
end

Start()
