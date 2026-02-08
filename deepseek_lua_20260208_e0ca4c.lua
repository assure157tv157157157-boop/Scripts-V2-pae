--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

plr.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end)

--// CRIAR UI PERSONALIZADA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpectraHub"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = plr:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

--// TÍTULO
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Spectra Hub | Brookhaven RP 🏡"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(0.7, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 10, 0, 18)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by: assure_TV"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TitleBar

--// BOTÕES X e -
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -75, 0, 3)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.white
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)
MinimizeCorner.Parent = MinimizeButton

local Minimized = false
local OriginalSize = MainFrame.Size
local OriginalPosition = MainFrame.Position

MinimizeButton.MouseButton1Click:Connect(function()
    if Minimized then
        -- Restaurar
        MainFrame.Size = OriginalSize
        Minimized = false
    else
        -- Minimizar
        MainFrame.Size = UDim2.new(0, 350, 0, 35)
        Minimized = true
    end
end)

--// ÁREA DE ROLAGEM
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 0, 0)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = MainFrame

--// FUNÇÃO PARA CRIAR BOTÃO TOGGLE
local function CreateToggleButton(name, parent)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = name .. "Frame"
    ButtonFrame.Size = UDim2.new(1, -10, 0, 40)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ButtonFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = name .. "Button"
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = "  " .. name
    ToggleButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
    ToggleButton.Parent = ButtonFrame
    
    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(0, 25, 0, 25)
    Status.Position = UDim2.new(1, -35, 0.5, -12.5)
    Status.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Status.Text = "✗"
    Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    Status.TextSize = 16
    Status.Font = Enum.Font.GothamBold
    Status.Parent = ButtonFrame
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 4)
    StatusCorner.Parent = Status
    
    local Active = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        Active = not Active
        if Active then
            Status.Text = "✓"
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
            Status.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
        else
            Status.Text = "✗"
            Status.TextColor3 = Color3.fromRGB(255, 50, 50)
            Status.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        return Active
    end)
    
    local function SetState(state)
        Active = state
        if Active then
            Status.Text = "✓"
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
            Status.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
        else
            Status.Text = "✗"
            Status.TextColor3 = Color3.fromRGB(255, 50, 50)
            Status.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        return Active
    end
    
    return ToggleButton, SetState
end

--// SEPARADOR
local function CreateSeparator(parent)
    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(1, -20, 0, 1)
    Separator.Position = UDim2.new(0, 10, 0, 0)
    Separator.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    Separator.BorderSizePixel = 0
    Separator.Parent = parent
    return Separator
end

--// TÍTULO DA SEÇÃO
local function CreateSection(title, parent)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, -10, 0, 30)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = parent
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 1, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = Color3.fromRGB(255, 150, 150)
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionFrame
    
    return SectionFrame
end

--// PLAYER LIST
local selectedPlayer
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1, -10, 0, 100)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerListFrame.Parent = ScrollFrame

local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 6)
PlayerListCorner.Parent = PlayerListFrame

local PlayerListTitle = Instance.new("TextLabel")
PlayerListTitle.Size = UDim2.new(1, 0, 0, 25)
PlayerListTitle.BackgroundTransparency = 1
PlayerListTitle.Text = "PLAYER LIST"
PlayerListTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
PlayerListTitle.TextSize = 14
PlayerListTitle.Font = Enum.Font.GothamBold
PlayerListTitle.Parent = PlayerListFrame

local DropdownFrame = Instance.new("Frame")
DropdownFrame.Size = UDim2.new(1, -20, 0, 35)
DropdownFrame.Position = UDim2.new(0, 10, 0, 30)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DropdownFrame.Parent = PlayerListFrame

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 4)
DropdownCorner.Parent = DropdownFrame

local DropdownButton = Instance.new("TextButton")
DropdownButton.Size = UDim2.new(1, 0, 1, 0)
DropdownButton.BackgroundTransparency = 1
DropdownButton.Text = "Escolher Player"
DropdownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
DropdownButton.TextSize = 14
DropdownButton.Font = Enum.Font.Gotham
DropdownButton.Parent = DropdownFrame

local SelectedPlayerText = Instance.new("TextLabel")
SelectedPlayerText.Size = UDim2.new(1, 0, 0, 20)
SelectedPlayerText.Position = UDim2.new(0, 10, 0, 70)
SelectedPlayerText.BackgroundTransparency = 1
SelectedPlayerText.Text = "Selecionado: Nenhum"
SelectedPlayerText.TextColor3 = Color3.fromRGB(180, 180, 180)
SelectedPlayerText.TextSize = 12
SelectedPlayerText.Font = Enum.Font.Gotham
SelectedPlayerText.TextXAlignment = Enum.TextXAlignment.Left
SelectedPlayerText.Parent = PlayerListFrame

local function getPlayers()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr then
            table.insert(t, p.Name)
        end
    end
    return t
end

-- Lista suspensa
local DropdownOpen = false
local DropdownOptions = Instance.new("Frame")
DropdownOptions.Name = "DropdownOptions"
DropdownOptions.Size = UDim2.new(1, 0, 0, 0)
DropdownOptions.Position = UDim2.new(0, 0, 1, 2)
DropdownOptions.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DropdownOptions.Visible = false
DropdownOptions.Parent = DropdownFrame

local DropdownOptionsCorner = Instance.new("UICorner")
DropdownOptionsCorner.CornerRadius = UDim.new(0, 4)
DropdownOptionsCorner.Parent = DropdownOptions

local OptionsList = Instance.new("UIListLayout")
OptionsList.Parent = DropdownOptions

DropdownButton.MouseButton1Click:Connect(function()
    DropdownOpen = not DropdownOpen
    DropdownOptions.Visible = DropdownOpen
    
    if DropdownOpen then
        -- Limpar opções antigas
        for _, child in ipairs(DropdownOptions:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Adicionar novas opções
        local players = getPlayers()
        local height = 0
        
        for _, playerName in ipairs(players) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            OptionButton.Text = playerName
            OptionButton.TextColor3 = Color3.white
            OptionButton.TextSize = 14
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Parent = DropdownOptions
            
            OptionButton.MouseButton1Click:Connect(function()
                selectedPlayer = playerName
                DropdownButton.Text = playerName
                SelectedPlayerText.Text = "Selecionado: " .. playerName
                DropdownOpen = false
                DropdownOptions.Visible = false
            end)
            
            height = height + 30
        end
        
        DropdownOptions.Size = UDim2.new(1, 0, 0, math.min(height, 150))
    end
end)

-- Botão atualizar
local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0.5, -5, 0, 25)
RefreshButton.Position = UDim2.new(0, 10, 1, -30)
RefreshButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
RefreshButton.Text = "Atualizar Lista"
RefreshButton.TextColor3 = Color3.white
RefreshButton.TextSize = 12
RefreshButton.Font = Enum.Font.Gotham
RefreshButton.Parent = PlayerListFrame

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 4)
RefreshCorner.Parent = RefreshButton

RefreshButton.MouseButton1Click:Connect(function()
    DropdownButton.Text = "Escolher Player"
    SelectedPlayerText.Text = "Selecionado: Nenhum"
    selectedPlayer = nil
end)

--// SPECTATE SYSTEM
local Camera = workspace.CurrentCamera
local spectating = false
local spectateConn
local charConn
local currentTarget

local function resetCamera()
    if spectateConn then spectateConn:Disconnect() spectateConn = nil end
    if charConn then charConn:Disconnect() charConn = nil end
    currentTarget = nil
    
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        Camera.CameraSubject = hum
        Camera.CameraType = Enum.CameraType.Custom
    end
end

local function spectatePlayer(player)
    if not spectating or not player then return end
    
    resetCamera()
    spectating = true
    currentTarget = player
    
    spectateConn = RunService.RenderStepped:Connect(function()
        if not spectating then return end
        if not currentTarget or not currentTarget.Character then return end
        
        local hum = currentTarget.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            Camera.CameraSubject = hum
            Camera.CameraType = Enum.CameraType.Custom
        end
    end)
    
    charConn = player.CharacterAdded:Connect(function()
        task.wait(0.1)
        if spectating and currentTarget == player then
            spectatePlayer(player)
        end
    end)
end

Players.PlayerRemoving:Connect(function(plr)
    if spectating and currentTarget == plr then
        resetCamera()
        spectating = false
    end
end)

--// VARIÁVEIS GLOBAIS PROP SYSTEM
local PROP_RAID_ENABLED = false
local PROP_RAID_CONNECTION
local PROP_RAID_Targets = {}

local Character = plr.Character
local HRP = Character and Character:WaitForChild("HumanoidRootPart", 5)
local Humanoid = Character and Character:WaitForChild("Humanoid", 5)

local function UpdateRaidCharacter(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart", 5)
    Humanoid = char:WaitForChild("Humanoid", 5)
end

if Character then
    UpdateRaidCharacter(Character)
end

plr.CharacterAdded:Connect(function(char)
    StopPropRaid()
    task.wait(0.5)
    UpdateRaidCharacter(char)
    if PROP_RAID_ENABLED then
        task.wait(0.5)
        StartPropRaid()
    end
end)

-- Inicializar props
pcall(function()
    ReplicatedStorage.RE["1Too1l"]:InvokeServer("PickingTools", "PropMaker")
end)

task.wait(0.3)

pcall(function()
    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer(
        "RequestingPropName",
        "FurnitureBleachers",
        "Furniture"
    )
end)

local propCache = {}
local lastUpdate = 0

local function GetMyPropsRaid()
    if tick() - lastUpdate < 0.4 then return propCache end
    
    propCache = {}
    local ws = workspace:FindFirstChild("WorkspaceCom")
    if not ws then return propCache end
    
    for _, folder in ipairs(ws:GetChildren()) do
        for _, prop in ipairs(folder:GetChildren()) do
            if prop:FindFirstChild("SetCurrentCFrame")
            and prop.Name:lower():find(plr.Name:lower()) then
                table.insert(propCache, prop)
            end
        end
    end
    
    lastUpdate = tick()
    return propCache
end

--// CRIAÇÃO DOS TOGGLES
local Toggles = {}
local ToggleStates = {}

-- Separador
CreateSeparator(ScrollFrame)

-- Seção Troll
CreateSection("TROLL CONTROLS", ScrollFrame)

-- Spectar Jogador
local SpectateToggle, SpectateSet = CreateToggleButton("Spectar Jogador", ScrollFrame)
table.insert(Toggles, {button = SpectateToggle, set = SpectateSet})
ToggleStates["Spectar Jogador"] = false

SpectateToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["Spectar Jogador"]
    ToggleStates["Spectar Jogador"] = not state
    SpectateSet(not state)
    
    spectating = not state
    if not state then
        local target = Players:FindFirstChild(selectedPlayer)
        if target then
            spectatePlayer(target)
        else
            resetCamera()
        end
    else
        resetCamera()
    end
end)

CreateSeparator(ScrollFrame)
CreateSection("PROP CONTROLS", ScrollFrame)

-- próp sit all
local PropSitToggle, PropSitSet = CreateToggleButton("próp sit all", ScrollFrame)
table.insert(Toggles, {button = PropSitToggle, set = PropSitSet})
ToggleStates["próp sit all"] = false

local function GetTargetsRaid()
    local t = {}
    if not HRP then return t end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= plr
        and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - HRP.Position).Magnitude
            if dist <= 222 then
                table.insert(t, plr)
            end
        end
    end
    return t
end

local function AssignTargetsRaid(props, targets)
    if #targets == 0 then return end
    for i, prop in ipairs(props) do
        local index = ((i - 1) % #targets) + 1
        PROP_RAID_Targets[prop] = targets[index]
    end
end

local function GetNextTargetRaid(targets, current)
    if #targets == 0 then return nil end
    for i, plr in ipairs(targets) do
        if plr == current then
            return targets[(i % #targets) + 1]
        end
    end
    return targets[1]
end

local angle = 0
local height = 0
local dir = 1

function StartPropRaid()
    if PROP_RAID_CONNECTION then PROP_RAID_CONNECTION:Disconnect() end
    
    PROP_RAID_CONNECTION = RunService.Heartbeat:Connect(function()
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyPropsRaid()
        local targets = GetTargetsRaid()
        if #props == 0 or #targets == 0 then return end
        
        AssignTargetsRaid(props, targets)
        
        angle += math.rad(20)
        if height > 4 then dir = -1 end
        if height < -4 then dir = 1 end
        height += 0.3 * dir
        
        for _, prop in ipairs(props) do
            local target = PROP_RAID_Targets[prop]
            if not target or not target.Character then
                PROP_RAID_Targets[prop] = GetNextTargetRaid(targets, target)
                continue
            end
            
            local hum = target.Character:FindFirstChild("Humanoid")
            local root = target.Character:FindFirstChild("HumanoidRootPart")
            if not hum or not root then continue end
            
            if hum.Sit then
                PROP_RAID_Targets[prop] = GetNextTargetRaid(targets, target)
                continue
            end
            
            local radius = math.random(2,5)
            local offset = Vector3.new(math.cos(angle)*radius,height,math.sin(angle)*radius)
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    root.CFrame * CFrame.new(offset)
                )
            end)
        end
    end)
end

function StopPropRaid()
    if PROP_RAID_CONNECTION then
        PROP_RAID_CONNECTION:Disconnect()
        PROP_RAID_CONNECTION = nil
    end
    PROP_RAID_Targets = {}
end

PropSitToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["próp sit all"]
    ToggleStates["próp sit all"] = not state
    PropSitSet(not state)
    
    PROP_RAID_ENABLED = not state
    if not state then
        StartPropRaid()
    else
        StopPropRaid()
    end
end)

-- Prop Cobra
local CobraToggle, CobraSet = CreateToggleButton("Prop Cobra", ScrollFrame)
table.insert(Toggles, {button = CobraToggle, set = CobraSet})
ToggleStates["Prop Cobra"] = false

local COBRA_ENABLED = false
local COBRA_CONNECTION

local function StartCobra()
    if COBRA_CONNECTION then COBRA_CONNECTION:Disconnect() end
    local time = 0
    
    COBRA_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyPropsRaid()
        if #props == 0 then return end
        
        time += dt * 10
        
        for i, prop in ipairs(props) do
            local phase = time - i * 1.1
            
            local backDir = -HRP.CFrame.LookVector
            local rightDir = HRP.CFrame.RightVector
            local upDir = Vector3.new(0,1,0)
            
            local backOffset = backDir * (3.5 * i)
            local sideOffset = rightDir * (math.sin(phase) * 3.2)
            local upOffset = upDir * (math.cos(phase * 0.8) * 1.2)
            
            local pos = HRP.Position + backOffset + sideOffset + upOffset
            local cf = CFrame.new(pos, pos + backDir)
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, 0.35)
                )
            end)
        end
    end)
end

local function StopCobra()
    if COBRA_CONNECTION then
        COBRA_CONNECTION:Disconnect()
        COBRA_CONNECTION = nil
    end
end

CobraToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["Prop Cobra"]
    ToggleStates["Prop Cobra"] = not state
    CobraSet(not state)
    
    COBRA_ENABLED = not state
    if not state then
        StartCobra()
    else
        StopCobra()
    end
end)

-- Furacão de Props
local FuracaoToggle, FuracaoSet = CreateToggleButton("Furacão de Props", ScrollFrame)
table.insert(Toggles, {button = FuracaoToggle, set = FuracaoSet})
ToggleStates["Furacão de Props"] = false

local FURACAO_ENABLED = false
local FURACAO_CONNECTION

local function StartFuracao()
    if FURACAO_CONNECTION then FURACAO_CONNECTION:Disconnect() end
    
    local t = 0
    
    FURACAO_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyPropsRaid()
        if #props == 0 then return end
        
        t += dt * 4
        
        for i, prop in ipairs(props) do
            local angle = t + (i * 0.7)
            local radius = 4 + math.sin(t + i) * 3
            local height = math.cos(t*2 + i) * 4
            
            local offset = Vector3.new(
                math.cos(angle) * radius,
                height,
                math.sin(angle) * radius
            )
            
            local pos = HRP.Position + offset
            local look = CFrame.new(pos, HRP.Position)
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(look, 0.35)
                )
            end)
        end
    end)
end

local function StopFuracao()
    if FURACAO_CONNECTION then
        FURACAO_CONNECTION:Disconnect()
        FURACAO_CONNECTION = nil
    end
end

FuracaoToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["Furacão de Props"]
    ToggleStates["Furacão de Props"] = not state
    FuracaoSet(not state)
    
    FURACAO_ENABLED = not state
    if not state then
        StartFuracao()
    else
        StopFuracao()
    end
end)

-- Props strela
local StrelaToggle, StrelaSet = CreateToggleButton("Props strela", ScrollFrame)
table.insert(Toggles, {button = StrelaToggle, set = StrelaSet})
ToggleStates["Props strela"] = false

local AIR_ENABLED = false
local AIR_CONNECTION

local function StartAirSpread()
    if AIR_CONNECTION then AIR_CONNECTION:Disconnect() end
    
    local t = 0
    
    AIR_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyPropsRaid()
        if #props == 0 then return end
        
        t += dt
        
        for i, prop in ipairs(props) do
            local height = 30 + math.sin(t + i) * 3
            local angle = (i * 2.5)
            local radius = 12 + (i * 2)
            
            local offset = Vector3.new(
                math.cos(angle) * radius,
                height,
                math.sin(angle) * radius
            )
            
            local pos = HRP.Position + offset
            
            local cf = CFrame.new(pos) * CFrame.Angles(
                math.rad((t*50 + i*30) % 360),
                math.rad((t*35 + i*20) % 360),
                0
            )
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, 0.30)
                )
            end)
        end
    end)
end

local function StopAirSpread()
    if AIR_CONNECTION then
        AIR_CONNECTION:Disconnect()
        AIR_CONNECTION = nil
    end
end

StrelaToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["Props strela"]
    ToggleStates["Props strela"] = not state
    StrelaSet(not state)
    
    AIR_ENABLED = not state
    if not state then
        StartAirSpread()
    else
        StopAirSpread()
    end
end)

-- prop kill all
local HuntToggle, HuntSet = CreateToggleButton("prop kill all", ScrollFrame)
table.insert(Toggles, {button = HuntToggle, set = HuntSet})
ToggleStates["prop kill all"] = false

local HUNT_ENABLED = false
local HUNT_CONNECTION
local PropTargetMap = {}
local DroppedProps = {}

local function GetNearbyPlayers()
    local list = {}
    if not HRP then return list end
    
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= plr
        and p.Character
        and p.Character:FindFirstChild("HumanoidRootPart")
        and p.Character:FindFirstChild("Humanoid")
        and p.Character.Humanoid.Health > 0 then
            
            local dist = (p.Character.HumanoidRootPart.Position - HRP.Position).Magnitude
            if dist <= 150 then
                table.insert(list, p)
            end
        end
    end
    
    return list
end

local function CountPropsOnPlayer(player)
    local count = 0
    for _,target in pairs(PropTargetMap) do
        if target == player then
            count += 1
        end
    end
    return count
end

local function GetBestTarget(targets)
    local bestPlayer = nil
    local lowestCount = math.huge
    
    for _,plr in ipairs(targets) do
        local c = CountPropsOnPlayer(plr)
        if c < lowestCount and c < 3 then
            lowestCount = c
            bestPlayer = plr
        end
    end
    
    return bestPlayer
end

local function StartHunter()
    if HUNT_CONNECTION then HUNT_CONNECTION:Disconnect() end
    
    local t = 0
    
    HUNT_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        t += dt
        
        local props = GetMyPropsRaid()
        if #props == 0 then return end
        
        local targets = GetNearbyPlayers()
        
        for i, prop in ipairs(props) do
            local currentTarget = PropTargetMap[prop]
            
            if currentTarget then
                local char = currentTarget.Character
                if not char
                or not char:FindFirstChild("HumanoidRootPart")
                or not char:FindFirstChild("Humanoid")
                or char.Humanoid.Health <= 0
                or (char.HumanoidRootPart.Position - HRP.Position).Magnitude > 150 then
                    PropTargetMap[prop] = nil
                    currentTarget = nil
                end
            end
            
            if not currentTarget then
                local newTarget = GetBestTarget(targets)
                PropTargetMap[prop] = newTarget
                currentTarget = newTarget
            end
            
            if not currentTarget then
                local offset = Vector3.new(
                    math.cos(i+t)*4,
                    2 + math.sin(t*2+i),
                    math.sin(i+t)*4
                )
                
                local cf = CFrame.new(HRP.Position + offset)
                
                pcall(function()
                    prop.SetCurrentCFrame:InvokeServer(
                        prop:GetPivot():Lerp(cf, 0.3)
                    )
                end)
                continue
            end
            
            local hum = currentTarget.Character:FindFirstChild("Humanoid")
            local root = currentTarget.Character:FindFirstChild("HumanoidRootPart")
            if not hum or not root then continue end
            
            if hum.Sit then
                if not DroppedProps[prop] then
                    DroppedProps[prop] = true
                    
                    local dropPos = Vector3.new(
                        root.Position.X,
                        -460,
                        root.Position.Z
                    )
                    
                    pcall(function()
                        prop.SetCurrentCFrame:InvokeServer(CFrame.new(dropPos))
                    end)
                end
                continue
            end
            
            if DroppedProps[prop] and not hum.Sit then
                DroppedProps[prop] = nil
            end
            
            local move = Vector3.new(
                math.cos(t*3 + i) * 2,
                -1.5 + math.sin(t*4 + i),
                math.sin(t*3 + i) * 2
            )
            
            local cf = root.CFrame * CFrame.new(move) *
                CFrame.Angles(
                    math.rad(math.sin(t*5+i)*120),
                    math.rad(t*180),
                    0
                )
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, 0.35)
                )
            end)
        end
    end)
end

local function StopHunter()
    if HUNT_CONNECTION then
        HUNT_CONNECTION:Disconnect()
        HUNT_CONNECTION = nil
    end
    PropTargetMap = {}
    DroppedProps = {}
end

HuntToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["prop kill all"]
    ToggleStates["prop kill all"] = not state
    HuntSet(not state)
    
    HUNT_ENABLED = not state
    if not state then
        StartHunter()
    else
        StopHunter()
    end
end)

-- Portal de Props
local PortalToggle, PortalSet = CreateToggleButton("Portal de Props", ScrollFrame)
table.insert(Toggles, {button = PortalToggle, set = PortalSet})
ToggleStates["Portal de Props"] = false

local FRONT_CIRCLE_ENABLED = false
local FRONT_CIRCLE_CONNECTION

local function StartFrontCircle()
    if FRONT_CIRCLE_CONNECTION then FRONT_CIRCLE_CONNECTION:Disconnect() end
    
    local t = 0
    
    FRONT_CIRCLE_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyPropsRaid()
        if #props == 0 then return end
        
        t += dt * 1.8
        
        local center = HRP.Position + HRP.CFrame.LookVector * 8 + Vector3.new(0, 2, 0)
        local total = #props
        local radius = 6
        
        for i, prop in ipairs(props) do
            local angle = ((i-1)/total) * math.pi * 2
            local spin = t
            
            local side = math.cos(angle + spin) * radius
            local up = math.sin(angle + spin) * radius
            
            local pos =
                center
                + HRP.CFrame.RightVector * side
                + Vector3.new(0, up, 0)
            
            local cf = CFrame.new(pos) * CFrame.Angles(
                math.rad(up * 5),
                math.rad((angle+spin)*180/math.pi),
                0
            )
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, 0.25)
                )
            end)
        end
    end)
end

local function StopFrontCircle()
    if FRONT_CIRCLE_CONNECTION then
        FRONT_CIRCLE_CONNECTION:Disconnect()
        FRONT_CIRCLE_CONNECTION = nil
    end
end

PortalToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["Portal de Props"]
    ToggleStates["Portal de Props"] = not state
    PortalSet(not state)
    
    FRONT_CIRCLE_ENABLED = not state
    if not state then
        StartFrontCircle()
    else
        StopFrontCircle()
    end
end)

-- Atacar Player (Dropa -460)
local AttackToggle, AttackSet = CreateToggleButton("Atacar Player (-460)", ScrollFrame)
table.insert(Toggles, {button = AttackToggle, set = AttackSet})
ToggleStates["Atacar Player (-460)"] = false

local TARGET_ENABLED = false
local TARGET_CONNECTION
local SentProps = {}

local function getTargetPlayer()
    if not selectedPlayer then return nil end
    return Players:FindFirstChild(selectedPlayer)
end

local function StartSelectedTarget()
    if TARGET_CONNECTION then TARGET_CONNECTION:Disconnect() end
    
    local t = 0
    
    TARGET_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local target = getTargetPlayer()
        if not target or not target.Character then return end
        
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        local hum = target.Character:FindFirstChild("Humanoid")
        if not root or not hum then return end
        
        local props = GetMyPropsRaid()
        if #props == 0 then return end
        
        t += dt * 3
        
        for i, prop in ipairs(props) do
            if hum.Sit then
                if not SentProps[prop] then
                    SentProps[prop] = true
                    
                    local downPos = Vector3.new(
                        root.Position.X,
                        -460,
                        root.Position.Z
                    )
                    
                    pcall(function()
                        prop.SetCurrentCFrame:InvokeServer(CFrame.new(downPos))
                    end)
                end
                continue
            end
            
            if SentProps[prop] then
                SentProps[prop] = nil
                
                local backPos = HRP.Position + Vector3.new(
                    math.cos(i)*4,
                    3,
                    math.sin(i)*4
                )
                
                pcall(function()
                    prop.SetCurrentCFrame:InvokeServer(CFrame.new(backPos))
                end)
                continue
            end
            
            local move = Vector3.new(
                math.cos(t + i) * 3,
                math.sin(t*2 + i) * 2,
                math.sin(t + i*2) * 3
            )
            
            local cf = root.CFrame * CFrame.new(move) *
                CFrame.Angles(
                    math.rad(math.sin(t*4+i)*180),
                    math.rad(t*200),
                    math.rad(math.cos(t*3+i)*180)
                )
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, 0.35)
                )
            end)
        end
    end)
end

local function StopSelectedTarget()
    if TARGET_CONNECTION then
        TARGET_CONNECTION:Disconnect()
        TARGET_CONNECTION = nil
    end
    SentProps = {}
end

AttackToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["Atacar Player (-460)"]
    ToggleStates["Atacar Player (-460)"] = not state
    AttackSet(not state)
    
    TARGET_ENABLED = not state
    if not state then
        StartSelectedTarget()
    else
        StopSelectedTarget()
    end
end)

-- próp círculo
local CircleToggle, CircleSet = CreateToggleButton("próp círculo", ScrollFrame)
table.insert(Toggles, {button = CircleToggle, set = CircleSet})
ToggleStates["próp círculo"] = false

local RING_ENABLED = false
local RING_CONNECTION

local function StartRing()
    if RING_CONNECTION then RING_CONNECTION:Disconnect() end
    
    local t = 0
    
    RING_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local target = getTargetPlayer()
        if not target or not target.Character then return end
        
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local props = GetMyPropsRaid()
        if #props == 0 then return end
        
        t += dt * 1.8
        
        local radius = 8
        local total = #props
        local gapAngle = math.rad(70)
        local usableAngle = (math.pi * 2) - gapAngle
        
        for i, prop in ipairs(props) do
            local percent = (i-1) / total
            local angle = percent * usableAngle
            local spin = t
            local finalAngle = angle + spin
            
            local x = math.cos(finalAngle) * radius
            local z = math.sin(finalAngle) * radius
            
            local pos = root.Position + Vector3.new(x, -2.7, z)
            
            local cf = CFrame.new(pos) * CFrame.Angles(
                0,
                math.rad((finalAngle) * 180/math.pi),
                0
            )
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, 0.28)
                )
            end)
        end
    end)
end

local function StopRing()
    if RING_CONNECTION then
        RING_CONNECTION:Disconnect()
        RING_CONNECTION = nil
    end
end

CircleToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["próp círculo"]
    ToggleStates["próp círculo"] = not state
    CircleSet(not state)
    
    RING_ENABLED = not state
    if not state then
        StartRing()
    else
        StopRing()
    end
end)

-- Prop Cobra (Selecionado)
local CobraTargetToggle, CobraTargetSet = CreateToggleButton("Prop Cobra (Selecionado)", ScrollFrame)
table.insert(Toggles, {button = CobraTargetToggle, set = CobraTargetSet})
ToggleStates["Prop Cobra (Selecionado)"] = false

local COBRA_TARGET_ENABLED = false
local COBRA_TARGET_CONNECTION

local function StartCobraTarget()
    if COBRA_TARGET_CONNECTION then COBRA_TARGET_CONNECTION:Disconnect() end
    
    local t = 0
    
    COBRA_TARGET_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        local target = getTargetPlayer()
        if not target or not target.Character then return end
        
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        local hum = target.Character:FindFirstChild("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        
        local props = GetMyPropsRaid()
        if #props == 0 then return end
        
        t += dt * 10
        
        for i, prop in ipairs(props) do
            local phase = t - i * 1.1
            
            local backDir = -root.CFrame.LookVector
            local rightDir = root.CFrame.RightVector
            local upDir = Vector3.new(0,1,0)
            
            local backOffset = backDir * (3.5 * i)
            local sideOffset = rightDir * (math.sin(phase) * 3.2)
            local upOffset = upDir * (math.cos(phase * 0.8) * 1.2)
            
            local pos = root.Position + backOffset + sideOffset + upOffset
            local cf = CFrame.new(pos, pos + backDir)
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, 0.35)
                )
            end)
        end
    end)
end

local function StopCobraTarget()
    if COBRA_TARGET_CONNECTION then
        COBRA_TARGET_CONNECTION:Disconnect()
        COBRA_TARGET_CONNECTION = nil
    end
end

CobraTargetToggle.MouseButton1Click:Connect(function()
    local state = ToggleStates["Prop Cobra (Selecionado)"]
    ToggleStates["Prop Cobra (Selecionado)"] = not state
    CobraTargetSet(not state)
    
    COBRA_TARGET_ENABLED = not state
    if not state then
        StartCobraTarget()
    else
        StopCobraTarget()
    end
end)

--// DESATIVAR TODOS OS TOGGLES QUANDO FECHAR
CloseButton.MouseButton1Click:Connect(function()
    -- Parar todos os sistemas
    resetCamera()
    StopPropRaid()
    StopCobra()
    StopFuracao()
    StopAirSpread()
    StopHunter()
    StopFrontCircle()
    StopSelectedTarget()
    StopRing()
    StopCobraTarget()
    
    ScreenGui:Destroy()
end)

--// CORES DE HOVER
for _, toggle in ipairs(Toggles) do
    toggle.button.MouseEnter:Connect(function()
        toggle.button.Parent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    
    toggle.button.MouseLeave:Connect(function()
        toggle.button.Parent.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
end

RefreshButton.MouseEnter:Connect(function()
    RefreshButton.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
end)

RefreshButton.MouseLeave:Connect(function()
    RefreshButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
end)

CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
end)

MinimizeButton.MouseEnter:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

MinimizeButton.MouseLeave:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

--// NOTIFICAÇÃO INICIAL
local Notification = Instance.new("TextLabel")
Notification.Size = UDim2.new(0, 300, 0, 50)
Notification.Position = UDim2.new(0.5, -150, 1, -60)
Notification.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Notification.Text = "Spectra Hub Carregado!"
Notification.TextColor3 = Color3.fromRGB(255, 150, 150)
Notification.TextSize = 16
Notification.Font = Enum.Font.GothamBold
Notification.Parent = ScreenGui

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 8)
NotifCorner.Parent = Notification

local NotifStroke = Instance.new("UIStroke")
NotifStroke.Color = Color3.fromRGB(150, 0, 0)
NotifStroke.Thickness = 2
NotifStroke.Parent = Notification

wait(2)

local tween = TweenService:Create(Notification, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 1, 10)})
tween:Play()
tween.Completed:Wait()
Notification:Destroy()