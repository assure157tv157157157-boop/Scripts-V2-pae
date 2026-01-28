--[[
    SimpleSpy v3.0 - Modern UI Edition
    Versão aprimorada com interface moderna e suporte multiplataforma
]]

-- Fecha instância anterior
if _G.SimpleSpyExecuted and type(_G.SimpleSpyShutdown) == "function" then
    pcall(_G.SimpleSpyShutdown)
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

-- Carrega syntax highlighting
local Highlight = loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/highlight.lua"))()

-- Configurações de UI
local isMobile = UserInputService.TouchEnabled
local minSize = isMobile and UDim2.new(0, 350, 0, 400) or UDim2.new(0, 500, 0, 350)
local buttonSize = isMobile and 35 or 25

---- INTERFACE MODERNA ----

-- Instâncias principais
local SimpleSpy3 = Instance.new("ScreenGui")
SimpleSpy3.Name = "SimpleSpy3"
SimpleSpy3.ResetOnSpawn = false
SimpleSpy3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Container principal
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Parent = SimpleSpy3
MainContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
MainContainer.BorderSizePixel = 0
MainContainer.Position = UDim2.new(0.1, 0, 0.1, 0)
MainContainer.Size = minSize
MainContainer.Active = true
MainContainer.Selectable = true

-- Sombra do container
local ContainerShadow = Instance.new("ImageLabel")
ContainerShadow.Name = "ContainerShadow"
ContainerShadow.Parent = MainContainer
ContainerShadow.BackgroundTransparency = 1
ContainerShadow.Size = UDim2.new(1, 10, 1, 10)
ContainerShadow.Position = UDim2.new(0, -5, 0, -5)
ContainerShadow.Image = "rbxassetid://5554236805"
ContainerShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
ContainerShadow.ImageTransparency = 0.8
ContainerShadow.ScaleType = Enum.ScaleType.Slice
ContainerShadow.SliceCenter = Rect.new(23, 23, 277, 277)

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainContainer
TitleBar.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

-- Título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "SimpleSpy v3.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 15, 0, 0)

-- Botão de status
local StatusButton = Instance.new("TextButton")
StatusButton.Name = "StatusButton"
StatusButton.Parent = TitleBar
StatusButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
StatusButton.BorderSizePixel = 0
StatusButton.Position = UDim2.new(1, -90, 0.5, -12)
StatusButton.Size = UDim2.new(0, 24, 0, 24)
StatusButton.Font = Enum.Font.GothamBold
StatusButton.Text = "●"
StatusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusButton.TextSize = 14
StatusButton.AutoButtonColor = false

-- Botão de minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -60, 0.5, -12)
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16

-- Botão de fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -30, 0.5, -12)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.Gotham
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20

-- Área de conteúdo
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainContainer
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 0, 0, 40)
ContentArea.Size = UDim2.new(1, 0, 1, -40)

-- Painel esquerdo (lista de remotes)
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Parent = ContentArea
LeftPanel.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
LeftPanel.BorderSizePixel = 0
LeftPanel.Size = UDim2.new(0.35, 0, 1, 0)

-- Título da lista
local ListTitle = Instance.new("TextLabel")
ListTitle.Name = "ListTitle"
ListTitle.Parent = LeftPanel
ListTitle.BackgroundTransparency = 1
ListTitle.Size = UDim2.new(1, 0, 0, 30)
ListTitle.Font = Enum.Font.GothamMedium
ListTitle.Text = "REMOTE LOGS"
ListTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
ListTitle.TextSize = 14
ListTitle.TextXAlignment = Enum.TextXAlignment.Left
ListTitle.Position = UDim2.new(0, 10, 0, 0)

-- Lista de remotes
local RemoteList = Instance.new("ScrollingFrame")
RemoteList.Name = "RemoteList"
RemoteList.Parent = LeftPanel
RemoteList.BackgroundTransparency = 1
RemoteList.BorderSizePixel = 0
RemoteList.Position = UDim2.new(0, 0, 0, 30)
RemoteList.Size = UDim2.new(1, 0, 1, -30)
RemoteList.CanvasSize = UDim2.new(0, 0, 0, 0)
RemoteList.ScrollBarThickness = 4
RemoteList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = RemoteList
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Template do item de remote
local RemoteItemTemplate = Instance.new("Frame")
RemoteItemTemplate.Name = "RemoteItemTemplate"
RemoteItemTemplate.BackgroundColor3 = Color3.fromRGB(50, 50, 52)
RemoteItemTemplate.BorderSizePixel = 0
RemoteItemTemplate.Size = UDim2.new(0.9, 0, 0, 50)
RemoteItemTemplate.Visible = false

local ItemCorner = Instance.new("UICorner")
ItemCorner.CornerRadius = UDim.new(0, 6)
ItemCorner.Parent = RemoteItemTemplate

local RemoteIcon = Instance.new("TextLabel")
RemoteIcon.Name = "RemoteIcon"
RemoteIcon.Parent = RemoteItemTemplate
RemoteIcon.BackgroundTransparency = 1
RemoteIcon.Position = UDim2.new(0, 10, 0.5, -10)
RemoteIcon.Size = UDim2.new(0, 20, 0, 20)
RemoteIcon.Font = Enum.Font.GothamBold
RemoteIcon.Text = "⚡"
RemoteIcon.TextColor3 = Color3.fromRGB(255, 204, 0)
RemoteIcon.TextSize = 16

local RemoteName = Instance.new("TextLabel")
RemoteName.Name = "RemoteName"
RemoteName.Parent = RemoteItemTemplate
RemoteName.BackgroundTransparency = 1
RemoteName.Position = UDim2.new(0, 40, 0, 5)
RemoteName.Size = UDim2.new(1, -45, 0, 20)
RemoteName.Font = Enum.Font.Gotham
RemoteName.Text = "RemoteName"
RemoteName.TextColor3 = Color3.fromRGB(255, 255, 255)
RemoteName.TextSize = 14
RemoteName.TextXAlignment = Enum.TextXAlignment.Left
RemoteName.TextTruncate = Enum.TextTruncate.AtEnd

local RemoteType = Instance.new("TextLabel")
RemoteType.Name = "RemoteType"
RemoteType.Parent = RemoteItemTemplate
RemoteType.BackgroundTransparency = 1
RemoteType.Position = UDim2.new(0, 40, 0, 25)
RemoteType.Size = UDim2.new(1, -45, 0, 20)
RemoteType.Font = Enum.Font.Gotham
RemoteType.Text = "Event"
RemoteType.TextColor3 = Color3.fromRGB(180, 180, 180)
RemoteType.TextSize = 12
RemoteType.TextXAlignment = Enum.TextXAlignment.Left

local SelectButton = Instance.new("TextButton")
SelectButton.Name = "SelectButton"
SelectButton.Parent = RemoteItemTemplate
SelectButton.BackgroundTransparency = 1
SelectButton.Size = UDim2.new(1, 0, 1, 0)
SelectButton.Text = ""
SelectButton.ZIndex = 2

-- Painel direito
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Parent = ContentArea
RightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
RightPanel.BorderSizePixel = 0
RightPanel.Position = UDim2.new(0.35, 0, 0, 0)
RightPanel.Size = UDim2.new(0.65, 0, 1, 0)

-- Área de código
local CodeBoxContainer = Instance.new("Frame")
CodeBoxContainer.Name = "CodeBoxContainer"
CodeBoxContainer.Parent = RightPanel
CodeBoxContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
CodeBoxContainer.BorderSizePixel = 0
CodeBoxContainer.Size = UDim2.new(1, 0, 0.6, 0)

local CodeTitle = Instance.new("TextLabel")
CodeTitle.Name = "CodeTitle"
CodeTitle.Parent = CodeBoxContainer
CodeTitle.BackgroundTransparency = 1
CodeTitle.Size = UDim2.new(1, 0, 0, 30)
CodeTitle.Font = Enum.Font.GothamMedium
CodeTitle.Text = "GENERATED CODE"
CodeTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
CodeTitle.TextSize = 14
CodeTitle.TextXAlignment = Enum.TextXAlignment.Left
CodeTitle.Position = UDim2.new(0, 10, 0, 0)

local CodeBox = Instance.new("TextBox")
CodeBox.Name = "CodeBox"
CodeBox.Parent = CodeBoxContainer
CodeBox.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
CodeBox.BorderSizePixel = 0
CodeBox.Position = UDim2.new(0, 10, 0, 35)
CodeBox.Size = UDim2.new(1, -20, 1, -45)
CodeBox.Font = Enum.Font.RobotoMono
CodeBox.Text = "-- Select a remote to view code"
CodeBox.TextColor3 = Color3.fromRGB(220, 220, 220)
CodeBox.TextSize = 14
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.TextWrapped = true
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true

-- Barra de ferramentas
local Toolbar = Instance.new("Frame")
Toolbar.Name = "Toolbar"
Toolbar.Parent = RightPanel
Toolbar.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
Toolbar.BorderSizePixel = 0
Toolbar.Position = UDim2.new(0, 0, 0.6, 0)
Toolbar.Size = UDim2.new(1, 0, 0.4, 0)

local ToolbarTitle = Instance.new("TextLabel")
ToolbarTitle.Name = "ToolbarTitle"
ToolbarTitle.Parent = Toolbar
ToolbarTitle.BackgroundTransparency = 1
ToolbarTitle.Size = UDim2.new(1, 0, 0, 30)
ToolbarTitle.Font = Enum.Font.GothamMedium
ToolbarTitle.Text = "QUICK ACTIONS"
ToolbarTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
ToolbarTitle.TextSize = 14
ToolbarTitle.TextXAlignment = Enum.TextXAlignment.Left
ToolbarTitle.Position = UDim2.new(0, 10, 0, 0)

-- Grid de botões
local ButtonGrid = Instance.new("ScrollingFrame")
ButtonGrid.Name = "ButtonGrid"
ButtonGrid.Parent = Toolbar
ButtonGrid.BackgroundTransparency = 1
ButtonGrid.BorderSizePixel = 0
ButtonGrid.Position = UDim2.new(0, 0, 0, 30)
ButtonGrid.Size = UDim2.new(1, 0, 1, -30)
ButtonGrid.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonGrid.ScrollBarThickness = 4

local GridLayout = Instance.new("UIGridLayout")
GridLayout.Parent = ButtonGrid
GridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
GridLayout.CellSize = isMobile and UDim2.new(0, 100, 0, 40) or UDim2.new(0, 120, 0, 35)
GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GridLayout.StartCorner = Enum.StartCorner.TopLeft

-- Template do botão
local ButtonTemplate = Instance.new("TextButton")
ButtonTemplate.Name = "ButtonTemplate"
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
ButtonTemplate.BorderSizePixel = 0
ButtonTemplate.Size = UDim2.new(0, 120, 0, 35)
ButtonTemplate.Font = Enum.Font.Gotham
ButtonTemplate.Text = "Button"
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.TextSize = 14
ButtonTemplate.Visible = false

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ButtonTemplate

-- Tooltip
local ToolTip = Instance.new("Frame")
ToolTip.Name = "ToolTip"
ToolTip.Parent = SimpleSpy3
ToolTip.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToolTip.BorderSizePixel = 0
ToolTip.Size = UDim2.new(0, 200, 0, 60)
ToolTip.Visible = false
ToolTip.ZIndex = 100

local ToolTipCorner = Instance.new("UICorner")
ToolTipCorner.CornerRadius = UDim.new(0, 6)
ToolTipCorner.Parent = ToolTip

local ToolTipLabel = Instance.new("TextLabel")
ToolTipLabel.Name = "ToolTipLabel"
ToolTipLabel.Parent = ToolTip
ToolTipLabel.BackgroundTransparency = 1
ToolTipLabel.Size = UDim2.new(1, -10, 1, -10)
ToolTipLabel.Position = UDim2.new(0, 5, 0, 5)
ToolTipLabel.Font = Enum.Font.Gotham
ToolTipLabel.Text = "Tooltip text"
ToolTipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolTipLabel.TextSize = 13
ToolTipLabel.TextWrapped = true
ToolTipLabel.TextXAlignment = Enum.TextXAlignment.Left
ToolTipLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Indicador de arrasto para mobile
local DragIndicator = Instance.new("Frame")
DragIndicator.Name = "DragIndicator"
DragIndicator.Parent = MainContainer
DragIndicator.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
DragIndicator.BackgroundTransparency = 0.7
DragIndicator.BorderSizePixel = 0
DragIndicator.Size = UDim2.new(1, 0, 0, 3)
DragIndicator.Visible = false

local DragCorner = Instance.new("UICorner")
DragCorner.CornerRadius = UDim.new(0, 2)
DragCorner.Parent = DragIndicator

-------------------------------------------------------------------------------
-- VARIÁVEIS E CONFIGURAÇÕES
-------------------------------------------------------------------------------

-- Estado da interface
local isMinimized = false
local isMaximized = false
local isClosed = false
local isDragging = false
local dragStartPos
local frameStartPos

-- Configurações
local selectedColor = Color3.fromRGB(0, 122, 255)
local deselectedColor = Color3.fromRGB(50, 50, 52)
local logs = {}
local selectedLog = nil
local blacklist = {}
local blocklist = {}
local connectedRemotes = {}
local toggle = false

-- API do SimpleSpy
local SimpleSpy = {}

-- Configurações globais
_G.SIMPLESPYCONFIG_MaxRemotes = 500
_G.SimpleSpyMaxTableSize = 1000
_G.SimpleSpyMaxStringSize = 10000

-- Conexões
local connections = {}

-------------------------------------------------------------------------------
-- FUNÇÕES DA INTERFACE
-------------------------------------------------------------------------------

-- Atualiza layout para mobile
function updateMobileLayout()
    if isMobile then
        MainContainer.Size = UDim2.new(0.9, 0, 0.8, 0)
        LeftPanel.Size = UDim2.new(1, 0, 0.4, 0)
        RightPanel.Size = UDim2.new(1, 0, 0.6, 0)
        RightPanel.Position = UDim2.new(0, 0, 0.4, 0)
        CodeBoxContainer.Size = UDim2.new(1, 0, 0.5, 0)
        Toolbar.Size = UDim2.new(1, 0, 0.5, 0)
        Toolbar.Position = UDim2.new(0, 0, 0.5, 0)
    end
end

-- Move a janela
function startDragging()
    isDragging = true
    dragStartPos = UserInputService:GetMouseLocation()
    frameStartPos = MainContainer.Position
    
    if isMobile then
        DragIndicator.Visible = true
        TweenService:Create(DragIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if isDragging then
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - dragStartPos
            local newPos = frameStartPos + UDim2.new(0, delta.X, 0, delta.Y)
            
            -- Limitar à tela
            local viewport = workspace.CurrentCamera.ViewportSize
            local containerSize = MainContainer.AbsoluteSize
            
            if newPos.X.Offset < 0 then
                newPos = UDim2.new(0, 0, newPos.Y.Scale, newPos.Y.Offset)
            elseif newPos.X.Offset + containerSize.X > viewport.X then
                newPos = UDim2.new(0, viewport.X - containerSize.X, newPos.Y.Scale, newPos.Y.Offset)
            end
            
            if newPos.Y.Offset < 0 then
                newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset, 0, 0)
            elseif newPos.Y.Offset + containerSize.Y > viewport.Y - 36 then
                newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset, 0, viewport.Y - containerSize.Y - 36)
            end
            
            MainContainer.Position = newPos
        else
            connection:Disconnect()
            if isMobile then
                TweenService:Create(DragIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
                wait(0.2)
                DragIndicator.Visible = false
            end
        end
    end)
    
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end))
end

-- Minimiza/restaura janela
function toggleMinimize()
    if isMinimized then
        -- Restaurar
        TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = minSize}):Play()
        ContentArea.Visible = true
        isMinimized = false
    else
        -- Minimizar
        TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 40)}):Play()
        ContentArea.Visible = false
        isMinimized = true
    end
end

-- Redimensiona janela
function startResizing()
    local startSize = MainContainer.Size
    local startPos = UserInputService:GetMouseLocation()
    local isResizing = true
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if isResizing then
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - startPos
            
            local newWidth = math.max(minSize.X.Offset, startSize.X.Offset + delta.X)
            local newHeight = math.max(minSize.Y.Offset, startSize.Y.Offset + delta.Y)
            
            MainContainer.Size = UDim2.new(0, newWidth, 0, newHeight)
        else
            connection:Disconnect()
        end
    end)
    
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = false
        end
    end))
end

-- Mostra tooltip
function showTooltip(text, position)
    ToolTipLabel.Text = text
    ToolTip.Visible = true
    ToolTip.Position = position
    
    -- Ajustar tamanho
    local textSize = TextService:GetTextSize(text, 13, Enum.Font.Gotham, Vector2.new(190, math.huge))
    ToolTip.Size = UDim2.new(0, math.max(200, textSize.X + 20), 0, textSize.Y + 20)
end

-- Esconde tooltip
function hideTooltip()
    ToolTip.Visible = false
end

-- Cria botão na toolbar
function createToolbarButton(name, tooltip, onClick)
    local button = ButtonTemplate:Clone()
    button.Name = name
    button.Text = name
    button.Visible = true
    button.Parent = ButtonGrid
    
    -- Eventos para PC
    button.MouseEnter:Connect(function()
        showTooltip(tooltip, UDim2.new(0, button.AbsolutePosition.X, 0, button.AbsolutePosition.Y - 70))
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 255)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        hideTooltip()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
    end)
    
    button.MouseButton1Click:Connect(onClick)
    
    -- Eventos para mobile
    local touchStartTime = 0
    local touchStartPos
    
    button.TouchLongPress:Connect(function()
        showTooltip(tooltip, UDim2.new(0, button.AbsolutePosition.X, 0, button.AbsolutePosition.Y - 70))
        wait(2)
        hideTooltip()
    end)
    
    button.TouchTap:Connect(function()
        onClick()
    end)
    
    return button
end

-- Adiciona log de remote
function addRemoteLog(name, type, args, remote, blocked)
    local logItem = RemoteItemTemplate:Clone()
    logItem.Name = "Log_" .. #logs + 1
    logItem.Visible = true
    logItem.LayoutOrder = #logs + 1
    logItem.Parent = RemoteList
    
    logItem.RemoteName.Text = string.sub(name, 1, 30)
    logItem.RemoteType.Text = type
    
    -- Cor baseada no tipo
    if type:lower() == "event" then
        logItem.RemoteIcon.TextColor3 = Color3.fromRGB(255, 204, 0)
    else
        logItem.RemoteIcon.TextColor3 = Color3.fromRGB(100, 200, 255)
    end
    
    -- Marcar como bloqueado
    if blocked then
        logItem.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
        logItem.RemoteName.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    local logData = {
        Name = name,
        Type = type,
        Args = args,
        Remote = remote,
        Blocked = blocked,
        Item = logItem,
        GenScript = "-- Generating script...\n-- Remote: " .. name
    }
    
    table.insert(logs, logData)
    
    -- Selecionar ao clicar
    logItem.SelectButton.MouseButton1Click:Connect(function()
        selectLog(logData)
    end)
    
    logItem.SelectButton.TouchTap:Connect(function()
        selectLog(logData)
    end)
    
    -- Atualizar tamanho da lista
    RemoteList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    
    return logData
end

-- Seleciona um log
function selectLog(logData)
    -- Desselecionar anterior
    if selectedLog then
        TweenService:Create(selectedLog.Item, TweenInfo.new(0.3), {BackgroundColor3 = deselectedColor}):Play()
    end
    
    -- Selecionar novo
    selectedLog = logData
    TweenService:Create(logData.Item, TweenInfo.new(0.3), {BackgroundColor3 = selectedColor}):Play()
    
    -- Atualizar código
    CodeBox.Text = logData.GenScript
    
    -- Gerar script completo (simplificado)
    schedule(function()
        logData.GenScript = generateScript(logData.Remote, logData.Args)
        if logData.Blocked then
            logData.GenScript = "-- BLOCKED REMOTE\n-- This remote was prevented from firing\n\n" .. logData.GenScript
        end
        if selectedLog == logData then
            CodeBox.Text = logData.GenScript
        end
    end)
end

-- Gera script (versão simplificada)
function generateScript(remote, args)
    local script = "-- Generated by SimpleSpy v3.0\n"
    
    if remote:IsA("RemoteEvent") then
        script = script .. "local remote = game:GetService('ReplicatedStorage'):FindFirstChild('" .. remote.Name .. "')\n"
        script = script .. "if remote then\n"
        script = script .. "    remote:FireServer("
        
        for i, arg in ipairs(args) do
            if type(arg) == "string" then
                script = script .. '"' .. arg .. '"'
            else
                script = script .. tostring(arg)
            end
            
            if i < #args then
                script = script .. ", "
            end
        end
        
        script = script .. ")\nend"
    else
        script = script .. "-- RemoteFunction detected\n"
        script = script .. "-- Use :InvokeServer() instead"
    end
    
    return script
end

-- Limpa logs
function clearLogs()
    for _, log in ipairs(logs) do
        if log.Item then
            log.Item:Destroy()
        end
    end
    logs = {}
    selectedLog = nil
    CodeBox.Text = "-- Select a remote to view code"
    RemoteList.CanvasSize = UDim2.new(0, 0, 0, 0)
end

-------------------------------------------------------------------------------
-- FUNÇÕES DO SIMPLESPY (adaptadas)
-------------------------------------------------------------------------------

-- Agendador de tarefas
local scheduled = {}
function schedule(f, ...)
    table.insert(scheduled, {f, ...})
end

function taskscheduler()
    if #scheduled > 0 then
        local task = scheduled[1]
        table.remove(scheduled, 1)
        if type(task) == "table" and type(task[1]) == "function" then
            pcall(unpack(task))
        end
    end
end

-- Hook de remotes (versão simplificada)
local originalNamecall
local remoteEvent = Instance.new("RemoteEvent")
local remoteFunction = Instance.new("RemoteFunction")
local originalFireServer = remoteEvent.FireServer
local originalInvokeServer = remoteFunction.InvokeServer

function toggleSpy()
    if not toggle then
        -- Ativar spy
        if hookmetamethod then
            local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if (method == "FireServer" or method == "InvokeServer") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                    if not (blacklist[self] or blacklist[self.Name]) then
                        schedule(function()
                            addRemoteLog(
                                self.Name,
                                self.ClassName == "RemoteEvent" and "Event" or "Function",
                                args,
                                self,
                                blocklist[self] or blocklist[self.Name]
                            )
                        end)
                    end
                    
                    if blocklist[self] or blocklist[self.Name] then
                        return nil
                    end
                end
                
                return oldNamecall(self, ...)
            end)
            originalNamecall = oldNamecall
        end
        
        StatusButton.BackgroundColor3 = Color3.fromRGB(76, 217, 100)
        toggle = true
    else
        -- Desativar spy
        if hookmetamethod and originalNamecall then
            hookmetamethod(game, "__namecall", originalNamecall)
        end
        
        StatusButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
        toggle = false
    end
end

-------------------------------------------------------------------------------
-- CONFIGURAÇÃO INICIAL
-------------------------------------------------------------------------------

-- Configurar eventos da interface
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDragging()
    end
end)

MinimizeButton.MouseButton1Click:Connect(toggleMinimize)
MinimizeButton.TouchTap:Connect(toggleMinimize)

CloseButton.MouseButton1Click:Connect(function()
    SimpleSpy3:Destroy()
    _G.SimpleSpyExecuted = false
end)

CloseButton.TouchTap:Connect(function()
    SimpleSpy3:Destroy()
    _G.SimpleSpyExecuted = false
end)

StatusButton.MouseButton1Click:Connect(toggleSpy)
StatusButton.TouchTap:Connect(toggleSpy)

-- Botões da toolbar
createToolbarButton("Copy", "Copy code to clipboard", function()
    if CodeBox.Text ~= "-- Select a remote to view code" then
        setclipboard(CodeBox.Text)
        showTooltip("Code copied!", UDim2.new(0.5, -100, 0.5, -30))
        wait(1)
        hideTooltip()
    end
end)

createToolbarButton("Run", "Execute code", function()
    if CodeBox.Text ~= "-- Select a remote to view code" then
        loadstring(CodeBox.Text)()
        showTooltip("Code executed!", UDim2.new(0.5, -100, 0.5, -30))
        wait(1)
        hideTooltip()
    end
end)

createToolbarButton("Clear", "Clear all logs", function()
    clearLogs()
    showTooltip("Logs cleared!", UDim2.new(0.5, -100, 0.5, -30))
    wait(1)
    hideTooltip()
end)

createToolbarButton("Exclude", "Exclude selected remote", function()
    if selectedLog then
        blacklist[selectedLog.Remote] = true
        showTooltip("Remote excluded!", UDim2.new(0.5, -100, 0.5, -30))
        wait(1)
        hideTooltip()
    end
end)

createToolbarButton("Block", "Block selected remote", function()
    if selectedLog then
        blocklist[selectedLog.Remote] = true
        selectedLog.Item.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
        selectedLog.Item.RemoteName.TextColor3 = Color3.fromRGB(255, 100, 100)
        showTooltip("Remote blocked!", UDim2.new(0.5, -100, 0.5, -30))
        wait(1)
        hideTooltip()
    end
end)

createToolbarButton("Refresh", "Refresh remote list", function()
    -- Atualiza UI
    showTooltip("Refreshed!", UDim2.new(0.5, -100, 0.5, -30))
    wait(1)
    hideTooltip()
end)

-- Configurar para mobile
updateMobileLayout()

-- Iniciar scheduler
local scheduler = RunService.Heartbeat:Connect(taskscheduler)
table.insert(connections, scheduler)

-- Iniciar SimpleSpy
if syn and syn.protect_gui then
    pcall(syn.protect_gui, SimpleSpy3)
end

SimpleSpy3.Parent = CoreGui
_G.SimpleSpyExecuted = true

-- Ativar spy por padrão
toggleSpy()

print("SimpleSpy v3.0 loaded successfully!")
print("Platform: " .. (isMobile and "Mobile" or "Desktop"))