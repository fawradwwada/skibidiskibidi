-- RobloxUtility v1.0: Comprehensive Client-Side Script
-- Features: Adminium Auto-Miner, ESP, Speed Modifier, Anti-AFK, and UI Controls

local RobloxUtility = {}
RobloxUtility.Settings = {
    AdminiumMiner = {
        Enabled = false,
        MineSpeed = 0.1,
        AutoRetry = true
    },
    ESP = {
        Enabled = false,
        Players = true,
        Items = true,
        Distance = true,
        RefreshRate = 0.5
    },
    SpeedModifier = {
        Enabled = false,
        Value = 3 -- Multiplier
    },
    AntiAFK = {
        Enabled = true,
        Interval = 30 -- seconds
    }
}

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Player references
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- UI Components
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxUtilityGui"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 650)
MainFrame.Position = UDim2.new(0.8, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui


local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "Title"
TitleText.Size = UDim2.new(1, -10, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Text = "Roblox Utility v1.0"
TitleText.TextSize = 18
TitleText.Parent = TitleBar

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -40)
ContentFrame.Position = UDim2.new(0, 10, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ContentFrame.Parent = MainFrame

-- Function to create section in UI
local function CreateSection(title, positionY)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = title .. "Section"
    SectionFrame.Size = UDim2.new(1, 0, 0, 80)
    SectionFrame.Position = UDim2.new(0, 0, 0, positionY)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Parent = ContentFrame
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Size = UDim2.new(1, -10, 0, 25)
    SectionTitle.Position = UDim2.new(0, 5, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Font = Enum.Font.SourceSansBold
    SectionTitle.Text = title
    SectionTitle.TextSize = 16
    SectionTitle.Parent = SectionFrame
    
    return SectionFrame
end

-- Create Feature Sections
local AdminiumSection = CreateSection("Adminium Auto-Miner", 0)
local ESPSection = CreateSection("ESP", 90)
local SpeedSection = CreateSection("Speed Modifier", 180)
local AntiAFKSection = CreateSection("Anti-AFK", 270)

-- Function to create toggle button
local function CreateToggle(parent, name, defaultState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 25)
    ToggleFrame.Position = UDim2.new(0, 10, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleText = Instance.new("TextLabel")
    ToggleText.Name = "Label"
    ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Font = Enum.Font.SourceSans
    ToggleText.Text = name
    ToggleText.TextSize = 14
    ToggleText.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(0.3, -10, 1, -6)
    Button.Position = UDim2.new(0.7, 5, 0, 3)
    Button.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    Button.Text = defaultState and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BorderSizePixel = 0
    Button.Parent = ToggleFrame
    
    local state = defaultState
    
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(state)
    end)
    
    return Button, state
end

-- Create Sliders
local function CreateSlider(parent, name, min, max, defaultValue, position, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Size = UDim2.new(1, -20, 0, 25)
    SliderFrame.Position = position
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local SliderText = Instance.new("TextLabel")
    SliderText.Name = "Label"
    SliderText.Size = UDim2.new(0.5, 0, 1, 0)
    SliderText.BackgroundTransparency = 1
    SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderText.TextXAlignment = Enum.TextXAlignment.Left
    SliderText.Font = Enum.Font.SourceSans
    SliderText.Text = name .. ": " .. defaultValue
    SliderText.TextSize = 14
    SliderText.Parent = SliderFrame
    
    local SliderBackground = Instance.new("Frame")
    SliderBackground.Name = "Background"
    SliderBackground.Size = UDim2.new(0.5, -10, 0, 10)
    SliderBackground.Position = UDim2.new(0.5, 5, 0.5, -5)
    SliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SliderBackground.BorderSizePixel = 0
    SliderBackground.Parent = SliderFrame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    local percentage = (defaultValue - min) / (max - min)
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBackground
    
    local value = defaultValue
    
    local function updateSlider(input)
        local percentage
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local offset = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
            percentage = offset
        else
            return
        end
        
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        value = min + (max - min) * percentage
        value = math.floor(value * 10) / 10 -- Round to 1 decimal place
        SliderText.Text = name .. ": " .. value
        callback(value)
    end
    
    SliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    updateSlider({Position = UserInputService:GetMouseLocation(), UserInputType = Enum.UserInputType.MouseButton1})
                else
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    return SliderFill, value
end

-- Create Toggles for each feature
local AdminiumToggle, adminiumEnabled = CreateToggle(AdminiumSection, "Enable Mining", RobloxUtility.Settings.AdminiumMiner.Enabled, function(state)
    RobloxUtility.Settings.AdminiumMiner.Enabled = state
    RobloxUtility.ToggleAdminiumMiner(state)
end)

local ESPToggle, espEnabled = CreateToggle(ESPSection, "Enable ESP", RobloxUtility.Settings.ESP.Enabled, function(state)
    RobloxUtility.Settings.ESP.Enabled = state
    RobloxUtility.ToggleESP(state)
end)

local SpeedToggle, speedEnabled = CreateToggle(SpeedSection, "Enable Speed Mod", RobloxUtility.Settings.SpeedModifier.Enabled, function(state)
    RobloxUtility.Settings.SpeedModifier.Enabled = state
    RobloxUtility.ToggleSpeedModifier(state)
end)

local AntiAFKToggle, antiAFKEnabled = CreateToggle(AntiAFKSection, "Enable Anti-AFK", RobloxUtility.Settings.AntiAFK.Enabled, function(state)
    RobloxUtility.Settings.AntiAFK.Enabled = state
    RobloxUtility.ToggleAntiAFK(state)
end)

-- Create sliders for configurable settings
local MineSpeedSlider, mineSpeedValue = CreateSlider(AdminiumSection, "Mine Speed", 0.1, 5, RobloxUtility.Settings.AdminiumMiner.MineSpeed, UDim2.new(0, 10, 0, 55), function(value)
    RobloxUtility.Settings.AdminiumMiner.MineSpeed = value
end)

local SpeedModSlider, speedModValue = CreateSlider(SpeedSection, "Speed Value", 1, 10, RobloxUtility.Settings.SpeedModifier.Value, UDim2.new(0, 10, 0, 55), function(value)
    RobloxUtility.Settings.SpeedModifier.Value = value
    if RobloxUtility.Settings.SpeedModifier.Enabled then
        RobloxUtility.ApplySpeedModifier(value)
    end
end)

local AntiAFKSlider, antiAFKValue = CreateSlider(AntiAFKSection, "Interval (s)", 10, 120, RobloxUtility.Settings.AntiAFK.Interval, UDim2.new(0, 10, 0, 55), function(value)
    RobloxUtility.Settings.AntiAFK.Interval = value
end)

local ESPRefreshSlider, espRefreshValue = CreateSlider(ESPSection, "Refresh Rate", 0.1, 2, RobloxUtility.Settings.ESP.RefreshRate, UDim2.new(0, 10, 0, 55), function(value)
    RobloxUtility.Settings.ESP.RefreshRate = value
end)

-- Status logger
local StatusLog = Instance.new("TextLabel")
StatusLog.Name = "StatusLog"
StatusLog.Size = UDim2.new(1, -10, 0, 20)
StatusLog.Position = UDim2.new(0, 5, 1, -25)
StatusLog.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StatusLog.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLog.Font = Enum.Font.SourceSans
StatusLog.Text = "Ready"
StatusLog.TextSize = 14
StatusLog.TextXAlignment = Enum.TextXAlignment.Left
StatusLog.TextTruncate = Enum.TextTruncate.AtEnd
StatusLog.Parent = MainFrame

-- Log function
local function Log(message)
    print("[RobloxUtility] " .. message)
    StatusLog.Text = message
end

-- Adminium Miner Implementation
RobloxUtility.AdminiumMinerActive = false
RobloxUtility.ToggleAdminiumMiner = function(enable)
    if enable then
        if RobloxUtility.AdminiumMinerActive then return end
        RobloxUtility.AdminiumMinerActive = true
        
        -- Start the mining coroutine
        coroutine.wrap(function()
            Log("Starting Adminium miner...")
            
            local counter = 0
            while RobloxUtility.AdminiumMinerActive do
                local Adminium = workspace:FindFirstChild("Adminium")
                local MineEvent = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("MineEvent")
                local AdminiumMined = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("AdminiumMined")
                
                if MineEvent and AdminiumMined and Adminium then
                    counter = counter + 1
                    Log(string.format("Mining Adminium [Attempt %d]", counter))
                    
                    -- Fire the mining event
                    MineEvent:FireServer(Adminium)
                    
                    -- Fire the Adminium mined event
                    AdminiumMined:Fire()
                    
                    -- Check if the Adminium block still exists
                    if not workspace:FindFirstChild("Adminium") then
                        Log("Adminium mined successfully!")
                        if not RobloxUtility.Settings.AdminiumMiner.AutoRetry then
                            RobloxUtility.ToggleAdminiumMiner(false)
                            AdminiumToggle.Text = "OFF"
                            AdminiumToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                            break
                        else
                            Log("Waiting for Adminium to respawn...")
                            -- Wait for respawn
                            while not workspace:FindFirstChild("Adminium") and RobloxUtility.AdminiumMinerActive do
                                task.wait(1)
                            end
                            if workspace:FindFirstChild("Adminium") then
                                Log("Adminium respawned! Continuing mining...")
                            end
                        end
                    end
                    
                    -- Adjust timing based on settings
                    task.wait(RobloxUtility.Settings.AdminiumMiner.MineSpeed)
                else
                    Log("Mining components not found! Retrying in 2 seconds...")
                    task.wait(2)
                end
            end
        end)()
    else
        RobloxUtility.AdminiumMinerActive = false
        Log("Adminium miner stopped")
    end
end

-- ESP Implementation
RobloxUtility.ESPObjects = {}
RobloxUtility.ESPEnabled = false

RobloxUtility.ToggleESP = function(enable)
    if enable then
        if RobloxUtility.ESPEnabled then return end
        RobloxUtility.ESPEnabled = true
        
        -- Start ESP
        Log("Starting ESP system...")
        
        -- Create ESP container
        if not ScreenGui:FindFirstChild("ESPContainer") then
            local ESPContainer = Instance.new("Folder")
            ESPContainer.Name = "ESPContainer"
            ESPContainer.Parent = ScreenGui
        end
        
        -- ESP Update Loop
        coroutine.wrap(function()
            while RobloxUtility.ESPEnabled do
                RobloxUtility.UpdateESP()
                task.wait(RobloxUtility.Settings.ESP.RefreshRate)
            end
        end)()
    else
        RobloxUtility.ESPEnabled = false
        Log("ESP system stopped")
        
        -- Clear ESP objects
        local container = ScreenGui:FindFirstChild("ESPContainer")
        if container then
            container:ClearAllChildren()
        end
        
        for _, object in pairs(RobloxUtility.ESPObjects) do
            if object.Highlight then
                object.Highlight:Destroy()
            end
        end
        RobloxUtility.ESPObjects = {}
    end
end

RobloxUtility.UpdateESP = function()
    -- Clear old labels
    local container = ScreenGui:FindFirstChild("ESPContainer")
    if container then
        container:ClearAllChildren()
    end
    
    -- Player ESP
    if RobloxUtility.Settings.ESP.Players then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local character = player.Character
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                
                if rootPart and humanoid then
                    -- Create highlight if it doesn't exist
                    if not RobloxUtility.ESPObjects[player.Name] then
                        RobloxUtility.ESPObjects[player.Name] = {
                            Type = "Player",
                            Highlight = Instance.new("Highlight")
                        }
                        RobloxUtility.ESPObjects[player.Name].Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        RobloxUtility.ESPObjects[player.Name].Highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
                        RobloxUtility.ESPObjects[player.Name].Highlight.FillTransparency = 0.5
                        RobloxUtility.ESPObjects[player.Name].Highlight.OutlineTransparency = 0
                        RobloxUtility.ESPObjects[player.Name].Highlight.Adornee = character
                        RobloxUtility.ESPObjects[player.Name].Highlight.Parent = character
                    end
                    
                    -- Create ESP label
                    local distance = math.floor((rootPart.Position - RootPart.Position).Magnitude)
                    local screenPos, isOnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
                    
                    if isOnScreen then
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(0, 150, 0, 20)
                        label.Position = UDim2.new(0, screenPos.X - 75, 0, screenPos.Y - 50)
                        label.BackgroundTransparency = 0.7
                        label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextStrokeTransparency = 0
                        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label.Font = Enum.Font.SourceSansBold
                        label.TextSize = 14
                        label.Text = player.Name
                        
                        if RobloxUtility.Settings.ESP.Distance then
                            label.Text = label.Text .. " [" .. distance .. "m]"
                        end
                        
                        -- Add health bar
                        local healthBar = Instance.new("Frame")
                        healthBar.Size = UDim2.new(1, 0, 0, 3)
                        healthBar.Position = UDim2.new(0, 0, 1, 2)
                        healthBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        healthBar.BorderSizePixel = 0
                        healthBar.Parent = label
                        
                        local healthFill = Instance.new("Frame")
                        healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
                        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        healthFill.BorderSizePixel = 0
                        healthFill.Parent = healthBar
                        
                        label.Parent = container
                    end
                end
            end
        end
    end
    
    -- Item ESP
    if RobloxUtility.Settings.ESP.Items then
        -- Check for important items (like Adminium)
        local itemsToESP = {"Adminium", "Chest", "Item", "Collectible", "Weapon"}
        
        for _, itemName in pairs(itemsToESP) do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find(itemName:lower()) or v.Parent.Name:lower():find(itemName:lower())) then
                    -- Create highlight if it doesn't exist
                    local objectID = v:GetFullName()
                    if not RobloxUtility.ESPObjects[objectID] then
                        RobloxUtility.ESPObjects[objectID] = {
                            Type = "Item",
                            Highlight = Instance.new("Highlight")
                        }
                        RobloxUtility.ESPObjects[objectID].Highlight.FillColor = Color3.fromRGB(255, 255, 0)
                        RobloxUtility.ESPObjects[objectID].Highlight.OutlineColor = Color3.fromRGB(255, 255, 100)
                        RobloxUtility.ESPObjects[objectID].Highlight.FillTransparency = 0.5
                        RobloxUtility.ESPObjects[objectID].Highlight.OutlineTransparency = 0
                        RobloxUtility.ESPObjects[objectID].Highlight.Adornee = v
                        RobloxUtility.ESPObjects[objectID].Highlight.Parent = v
                    end
                    
                    -- Create ESP label if on screen
                    local distance = math.floor((v.Position - RootPart.Position).Magnitude)
                    local screenPos, isOnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Position)
                    
                    if isOnScreen then
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(0, 100, 0, 16)
                        label.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y - 30)
                        label.BackgroundTransparency = 0.7
                        label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        label.TextColor3 = Color3.fromRGB(255, 255, 0)
                        label.TextStrokeTransparency = 0
                        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label.Font = Enum.Font.SourceSansBold
                        label.TextSize = 12
                        label.Text = itemName
                        
                        if RobloxUtility.Settings.ESP.Distance then
                            label.Text = label.Text .. " [" .. distance .. "m]"
                        end
                        
                        label.Parent = container
                    end
                end
            end
        end
    end
end



-- Speed Modifier Implementation
RobloxUtility.OriginalWalkSpeed = 16
RobloxUtility.ToggleSpeedModifier = function(enable)
    if enable then
        Log("Speed modifier enabled")
        RobloxUtility.OriginalWalkSpeed = Humanoid.WalkSpeed
        RobloxUtility.ApplySpeedModifier(RobloxUtility.Settings.SpeedModifier.Value)
    else
        Log("Speed modifier disabled")
        Humanoid.WalkSpeed = RobloxUtility.OriginalWalkSpeed
    end
end

RobloxUtility.ApplySpeedModifier = function(multiplier)
    Humanoid.WalkSpeed = RobloxUtility.OriginalWalkSpeed * multiplier
    Log("Walk speed set to " .. Humanoid.WalkSpeed)
end

-- Anti-AFK Implementation
RobloxUtility.AntiAFKConnection = nil
RobloxUtility.ToggleAntiAFK = function(enable)
    if enable then
        if RobloxUtility.AntiAFKConnection then return end
        Log("Anti-AFK enabled")
        
        -- Prevent idle kick
        local VirtualUser = game:GetService("VirtualUser")
        RobloxUtility.AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            Log("Anti-AFK triggered")
        end)
        
        -- Periodic movement to prevent detection
        coroutine.wrap(function()
            while RobloxUtility.Settings.AntiAFK.Enabled do
                wait(RobloxUtility.Settings.AntiAFK.Interval)
                if RobloxUtility.Settings.AntiAFK.Enabled then
                    -- Small camera movement
                    local camera = workspace.CurrentCamera
                    local originalCFrame = camera.CFrame
                    camera.CFrame = originalCFrame * CFrame.Angles(0, math.rad(0.5), 0)
                    wait(0.1)
                    camera.CFrame = originalCFrame
                    Log("Anti-AFK heartbeat")
                end
            end
        end)()
    else
        if RobloxUtility.AntiAFKConnection then
            RobloxUtility.AntiAFKConnection:Disconnect()
            RobloxUtility.AntiAFKConnection = nil
        end
        Log("Anti-AFK disabled")
    end
end

-- Add this code after the Anti-AFK Implementation section and before the "Initialize feature states" section

-- Teleport Implementation
RobloxUtility.Teleport = function(x, y, z)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Log("Cannot teleport - character not found")
        return false
    end
    
    local targetPosition = Vector3.new(x, y, z)
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    Log("Teleported to " .. tostring(targetPosition))
    return true
end

-- Create Teleport Section in UI
local TeleportSection = CreateSection("Teleport", 360)

-- Create input fields for coordinates
local function CreateCoordinateInput(parent, name, position, defaultValue)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = name .. "Input"
    InputFrame.Size = UDim2.new(0.3, -5, 0, 25)
    InputFrame.Position = position
    InputFrame.BackgroundTransparency = 1
    InputFrame.Parent = parent
    
    local InputLabel = Instance.new("TextLabel")
    InputLabel.Name = "Label"
    InputLabel.Size = UDim2.new(0, 20, 1, 0)
    InputLabel.BackgroundTransparency = 1
    InputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputLabel.Font = Enum.Font.SourceSans
    InputLabel.Text = name .. ":"
    InputLabel.TextSize = 14
    InputLabel.Parent = InputFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "TextBox"
    InputBox.Size = UDim2.new(1, -25, 1, 0)
    InputBox.Position = UDim2.new(0, 25, 0, 0)
    InputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.PlaceholderText = "0"
    InputBox.Text = tostring(defaultValue or 0)
    InputBox.Font = Enum.Font.SourceSans
    InputBox.TextSize = 14
    InputBox.ClearTextOnFocus = true
    InputBox.Parent = InputFrame
    
    return InputBox
end

-- Create coordinate inputs
local CoordLabel = Instance.new("TextLabel")
CoordLabel.Name = "CoordLabel"
CoordLabel.Size = UDim2.new(1, -10, 0, 20)
CoordLabel.Position = UDim2.new(0, 5, 0, 25)
CoordLabel.BackgroundTransparency = 1
CoordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordLabel.TextXAlignment = Enum.TextXAlignment.Left
CoordLabel.Font = Enum.Font.SourceSansBold
CoordLabel.Text = "Coordinates:"
CoordLabel.TextSize = 14
CoordLabel.Parent = TeleportSection

local XInput = CreateCoordinateInput(TeleportSection, "X", UDim2.new(0, 5, 0, 45), 0)
local YInput = CreateCoordinateInput(TeleportSection, "Y", UDim2.new(0.33, 5, 0, 45), 0)
local ZInput = CreateCoordinateInput(TeleportSection, "Z", UDim2.new(0.66, 5, 0, 45), 0)

-- Create teleport button
local TeleportButton = Instance.new("TextButton")
TeleportButton.Name = "TeleportButton"
TeleportButton.Size = UDim2.new(0.7, 0, 0, 25)
TeleportButton.Position = UDim2.new(0.15, 0, 0, 75)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.Text = "TELEPORT"
TeleportButton.TextSize = 16
TeleportButton.Parent = TeleportSection

-- Add current position button
local CurrentPosButton = Instance.new("TextButton")
CurrentPosButton.Name = "CurrentPosButton"
CurrentPosButton.Size = UDim2.new(0.5, 0, 0, 20)
CurrentPosButton.Position = UDim2.new(0.25, 0, 0, 105)
CurrentPosButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
CurrentPosButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CurrentPosButton.Font = Enum.Font.SourceSans
CurrentPosButton.Text = "Get Current Position"
CurrentPosButton.TextSize = 12
CurrentPosButton.Parent = TeleportSection

-- Auto-Teleport Toggle
local AutoTeleportToggle = Instance.new("TextButton")
AutoTeleportToggle.Name = "AutoTeleportToggle"
AutoTeleportToggle.Size = UDim2.new(0.4, 0, 0, 20)
AutoTeleportToggle.Position = UDim2.new(0.05, 0, 0, 135)
AutoTeleportToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoTeleportToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTeleportToggle.Font = Enum.Font.SourceSans
AutoTeleportToggle.TextSize = 12
AutoTeleportToggle.Text = "[ ] Auto Teleport"
AutoTeleportToggle.Parent = TeleportSection

local autoTeleportEnabled = false

AutoTeleportToggle.MouseButton1Click:Connect(function()
    autoTeleportEnabled = not autoTeleportEnabled
    AutoTeleportToggle.Text = autoTeleportEnabled and "[✓] Auto Teleport" or "[ ] Auto Teleport"
end)

-- Teleport Interval Input
local IntervalInput = CreateCoordinateInput(TeleportSection, "Interval (s)", UDim2.new(0.5, 5, 0, 135), 3)

-- Auto-Teleport Logic
task.spawn(function()
    while true do
        task.wait(0.5)
        if autoTeleportEnabled then
            local interval = tonumber(IntervalInput.Text) or 3
            task.wait(interval)

            local x = tonumber(XInput.Text) or 0
            local y = tonumber(YInput.Text) or 0
            local z = tonumber(ZInput.Text) or 0

            RobloxUtility.Teleport(x, y, z)
        end
    end
end)


-- Add teleport functionality
TeleportButton.MouseButton1Click:Connect(function()
    local x = tonumber(XInput.Text) or 0
    local y = tonumber(YInput.Text) or 0
    local z = tonumber(ZInput.Text) or 0
    
    RobloxUtility.Teleport(x, y, z)
end)

-- Get current position button functionality
CurrentPosButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        XInput.Text = tostring(math.floor(pos.X * 10) / 10)
        YInput.Text = tostring(math.floor(pos.Y * 10) / 10)
        ZInput.Text = tostring(math.floor(pos.Z * 10) / 10)
        Log("Current position loaded")
    else
        Log("Character not found")
    end
end)

-- Initialize feature states based on default settings
if RobloxUtility.Settings.AdminiumMiner.Enabled then
    RobloxUtility.ToggleAdminiumMiner(true)
end

if RobloxUtility.Settings.ESP.Enabled then
    RobloxUtility.ToggleESP(true)
end

if RobloxUtility.Settings.SpeedModifier.Enabled then
    RobloxUtility.ToggleSpeedModifier(true)
end

if RobloxUtility.Settings.AntiAFK.Enabled then
    RobloxUtility.ToggleAntiAFK(true)
end

-- Handle Character respawn
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Reapply settings after respawn
    if RobloxUtility.Settings.SpeedModifier.Enabled then
        RobloxUtility.ApplySpeedModifier(RobloxUtility.Settings.SpeedModifier.Value)
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightAlt then
        -- Toggle UI visibility
        MainFrame.Visible = not MainFrame.Visible
    end
    
    -- Quick toggles
    if input.KeyCode == Enum.KeyCode.F1 then
        RobloxUtility.Settings.AdminiumMiner.Enabled = not RobloxUtility.Settings.AdminiumMiner.Enabled
        RobloxUtility.ToggleAdminiumMiner(RobloxUtility.Settings.AdminiumMiner.Enabled)
        AdminiumToggle.Text = RobloxUtility.Settings.AdminiumMiner.Enabled and "ON" or "OFF"
        AdminiumToggle.BackgroundColor3 = RobloxUtility.Settings.AdminiumMiner.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.F2 then
        RobloxUtility.Settings.ESP.Enabled = not RobloxUtility.Settings.ESP.Enabled
        RobloxUtility.ToggleESP(RobloxUtility.Settings.ESP.Enabled)
        ESPToggle.Text = RobloxUtility.Settings.ESP.Enabled and "ON" or "OFF"
ESPToggle.BackgroundColor3 = RobloxUtility.Settings.ESP.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
elseif input.KeyCode == Enum.KeyCode.F3 then
RobloxUtility.Settings.SpeedModifier.Enabled = not RobloxUtility.Settings.SpeedModifier.Enabled
RobloxUtility.ToggleSpeedModifier(RobloxUtility.Settings.SpeedModifier.Enabled)
SpeedToggle.Text = RobloxUtility.Settings.SpeedModifier.Enabled and "ON" or "OFF"
SpeedToggle.BackgroundColor3 = RobloxUtility.Settings.SpeedModifier.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
elseif input.KeyCode == Enum.KeyCode.F4 then
RobloxUtility.Settings.AntiAFK.Enabled = not RobloxUtility.Settings.AntiAFK.Enabled
RobloxUtility.ToggleAntiAFK(RobloxUtility.Settings.AntiAFK.Enabled)
AntiAFKToggle.Text = RobloxUtility.Settings.AntiAFK.Enabled and "ON" or "OFF"
AntiAFKToggle.BackgroundColor3 = RobloxUtility.Settings.AntiAFK.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end
end)

-- Initialize UI
Log("Roblox Utility initialized! Press Right Alt to toggle UI")
-- Add help panel
local HelpButton = Instance.new("TextButton")
HelpButton.Name = "HelpButton"
HelpButton.Size = UDim2.new(0, 20, 0, 20)
HelpButton.Position = UDim2.new(1, -25, 0, 5)
HelpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HelpButton.Text = "?"
HelpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HelpButton.Font = Enum.Font.SourceSansBold
HelpButton.TextSize = 14
HelpButton.Parent = TitleBar
local HelpPanel = Instance.new("Frame")
HelpPanel.Name = "HelpPanel"
HelpPanel.Size = UDim2.new(0, 250, 0, 150)
HelpPanel.Position = UDim2.new(1, 10, 0, 0)
HelpPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HelpPanel.BorderSizePixel = 0
HelpPanel.Visible = false
HelpPanel.Parent = MainFrame
local HelpTitle = Instance.new("TextLabel")
HelpTitle.Name = "HelpTitle"
HelpTitle.Size = UDim2.new(1, 0, 0, 25)
HelpTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HelpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HelpTitle.Font = Enum.Font.SourceSansBold
HelpTitle.Text = "Keybinds"
HelpTitle.TextSize = 16
HelpTitle.Parent = HelpPanel
local HelpContent = Instance.new("TextLabel")
HelpContent.Name = "HelpContent"
HelpContent.Size = UDim2.new(1, -10, 1, -30)
HelpContent.Position = UDim2.new(0, 5, 0, 25)
HelpContent.BackgroundTransparency = 1
HelpContent.TextColor3 = Color3.fromRGB(255, 255, 255)
HelpContent.Font = Enum.Font.SourceSans
HelpContent.TextSize = 14
HelpContent.TextXAlignment = Enum.TextXAlignment.Left
HelpContent.TextYAlignment = Enum.TextYAlignment.Top
HelpContent.Text = "Right Alt - Toggle UI\nF1 - Toggle Adminium Miner\nF2 - Toggle ESP\nF3 - Toggle Speed Modifier\nF4 - Toggle Anti-AFK"
HelpContent.Parent = HelpPanel
HelpButton.MouseButton1Click(function()
HelpPanel.Visible = not HelpPanel.Visible
end)
-- Export the utility for access from other scripts
_G.RobloxUtility = RobloxUtility
return RobloxUtility
