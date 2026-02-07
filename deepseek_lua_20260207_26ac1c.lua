-- Criação da aba Props
local PropsTab = Window:MakeTab({
	Name = "Props",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--===============================
-- VARIÁVEIS GLOBAIS
--===============================
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local Character, HRP, Humanoid

local function UpdateCharacter(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart", 5)
    Humanoid = char:WaitForChild("Humanoid", 5)
end

if LocalPlayer.Character then
    UpdateCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    UpdateCharacter(char)
end)

-- Função para obter as props do jogador
local propCache = {}
local lastUpdate = 0

local function GetMyProps()
    if tick() - lastUpdate < 0.4 then return propCache end
    
    propCache = {}
    local ws = workspace:FindFirstChild("WorkspaceCom")
    if not ws then return propCache end
    
    for _, folder in ipairs(ws:GetChildren()) do
        for _, prop in ipairs(folder:GetChildren()) do
            if prop:FindFirstChild("SetCurrentCFrame")
            and prop.Name:lower():find(LocalPlayer.Name:lower()) then
                table.insert(propCache, prop)
            end
        end
    end
    
    lastUpdate = tick()
    return propCache
end

-- Primeira seção: Props para trollar TODOS
PropsTab:AddSection({"Props para Trollar TODOS"})

--===============================
-- PROP RAID (troll prop all)
--===============================

local PROP_RAID_ENABLED = false
local PROP_RAID_CONNECTION
local PROP_RAID_Targets = {}

local function GetTargetsRaid()
    local t = {}
    if not HRP then return t end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
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

local function StartPropRaid()
    if PROP_RAID_CONNECTION then PROP_RAID_CONNECTION:Disconnect() end
    
    PROP_RAID_CONNECTION = RunService.Heartbeat:Connect(function()
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyProps()
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

local function StopPropRaid()
    if PROP_RAID_CONNECTION then
        PROP_RAID_CONNECTION:Disconnect()
        PROP_RAID_CONNECTION = nil
    end
    PROP_RAID_Targets = {}
end

PropsTab:AddToggle({
    Name = "Prop Sit All",
    Default = false,
    Callback = function(v)
        PROP_RAID_ENABLED = v
        if v then
            StartPropRaid()
        else
            StopPropRaid()
        end
    end
})

--===============================
-- PROPS CAÇADORES INTELIGENTES
--===============================

local HUNT_ENABLED = false
local HUNT_CONNECTION
local TARGET_RADIUS = 150
local MAX_PROPS_PER_PLAYER = 3

local PropTargetMap = {}
local DroppedProps = {}

local function GetNearbyPlayers()
    local list = {}
    if not HRP then return list end
    
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer
        and p.Character
        and p.Character:FindFirstChild("HumanoidRootPart")
        and p.Character:FindFirstChild("Humanoid")
        and p.Character.Humanoid.Health > 0 then
            
            local dist = (p.Character.HumanoidRootPart.Position - HRP.Position).Magnitude
            if dist <= TARGET_RADIUS then
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
        if c < lowestCount and c < MAX_PROPS_PER_PLAYER then
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
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        local targets = GetNearbyPlayers()
        
        for i, prop in ipairs(props) do
            local currentTarget = PropTargetMap[prop]
            
            -- verifica se alvo saiu da área ou morreu
            if currentTarget then
                local char = currentTarget.Character
                if not char
                or not char:FindFirstChild("HumanoidRootPart")
                or not char:FindFirstChild("Humanoid")
                or char.Humanoid.Health <= 0
                or (char.HumanoidRootPart.Position - HRP.Position).Magnitude > TARGET_RADIUS then
                    PropTargetMap[prop] = nil
                    currentTarget = nil
                end
            end
            
            -- escolhe novo alvo inteligente
            if not currentTarget then
                local newTarget = GetBestTarget(targets)
                PropTargetMap[prop] = newTarget
                currentTarget = newTarget
            end
            
            -- sem ninguém perto → volta para você
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
            
            -- sentou → joga para baixo
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
            
            -- levantou → volta para o sistema
            if DroppedProps[prop] and not hum.Sit then
                DroppedProps[prop] = nil
            end
            
            -- movimento inteligente perto do player
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

PropsTab:AddToggle({
    Name = "Prop Kill All",
    Default = false,
    Callback = function(v)
        HUNT_ENABLED = v
        if v then
            StartHunter()
        else
            StopHunter()
        end
    end
})

-- Segunda seção: Props para usar em você
PropsTab:AddSection({"Props para usar em você"})

--===============================
-- PROP COBRA
--===============================

local COBRA_ENABLED = false
local COBRA_CONNECTION

local COBRA_FOLLOW_DISTANCE = 3.5
local COBRA_SIDE_AMPLITUDE = 3.2
local COBRA_UP_AMPLITUDE = 1.2
local COBRA_WAVE_SPEED = 10
local COBRA_PHASE_OFFSET = 1.1
local COBRA_SMOOTHNESS = 0.35

local function StartCobra()
    if COBRA_CONNECTION then COBRA_CONNECTION:Disconnect() end
    local time = 0
    
    COBRA_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        time += dt * COBRA_WAVE_SPEED
        
        for i, prop in ipairs(props) do
            local phase = time - i * COBRA_PHASE_OFFSET
            
            local backDir = -HRP.CFrame.LookVector
            local rightDir = HRP.CFrame.RightVector
            local upDir = Vector3.new(0,1,0)
            
            local backOffset = backDir * (COBRA_FOLLOW_DISTANCE * i)
            local sideOffset = rightDir * (math.sin(phase) * COBRA_SIDE_AMPLITUDE)
            local upOffset = upDir * (math.cos(phase * 0.8) * COBRA_UP_AMPLITUDE)
            
            local pos = HRP.Position + backOffset + sideOffset + upOffset
            local cf = CFrame.new(pos, pos + backDir)
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, COBRA_SMOOTHNESS)
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

PropsTab:AddToggle({
    Name = "Prop Cobra",
    Default = false,
    Callback = function(v)
        COBRA_ENABLED = v
        if v then
            StartCobra()
        else
            StopCobra()
        end
    end
})

--===============================
-- PROP FURACÃO
--===============================

local FURACAO_ENABLED = false
local FURACAO_CONNECTION

local function StartFuracao()
    if FURACAO_CONNECTION then FURACAO_CONNECTION:Disconnect() end
    
    local t = 0
    
    FURACAO_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        t += dt * 4
        
        for i, prop in ipairs(props) do
            local angle = t + (i * 0.7)
            
            -- distância varia (afasta e aproxima)
            local radius = 4 + math.sin(t + i) * 3
            
            -- sobe e desce
            local height = math.cos(t*2 + i) * 4
            
            -- gira em volta
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

PropsTab:AddToggle({
    Name = "Furacão de Props",
    Default = false,
    Callback = function(v)
        FURACAO_ENABLED = v
        if v then
            StartFuracao()
        else
            StopFuracao()
        end
    end
})

--===============================
-- PROPS ESPALHADOS NO AR
--===============================

local AIR_ENABLED = false
local AIR_CONNECTION

local function StartAirSpread()
    if AIR_CONNECTION then AIR_CONNECTION:Disconnect() end
    
    local t = 0
    
    AIR_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        t += dt
        
        for i, prop in ipairs(props) do
            -- ALTURA fixa ~25m
            local height = 30 + math.sin(t + i) * 3
            
            -- ESPALHAMENTO MUITO MAIOR
            local angle = (i * 2.5)
            local radius = 12 + (i * 2)   -- bem mais longe um do outro
            
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

PropsTab:AddToggle({
    Name = "Props Espalhados",
    Default = false,
    Callback = function(v)
        AIR_ENABLED = v
        if v then
            StartAirSpread()
        else
            StopAirSpread()
        end
    end
})

--===============================
-- CÍRCULO VERTICAL NA FRENTE
--===============================

local FRONT_CIRCLE_ENABLED = false
local FRONT_CIRCLE_CONNECTION

local function StartFrontCircle()
    if FRONT_CIRCLE_CONNECTION then FRONT_CIRCLE_CONNECTION:Disconnect() end
    
    local t = 0
    
    FRONT_CIRCLE_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        t += dt * 1.8
        
        -- posição do "portal" na frente
        local center = HRP.Position + HRP.CFrame.LookVector * 8 + Vector3.new(0, 2, 0)
        
        local total = #props
        local radius = 6 -- MAIS ESPAÇADO
        
        for i, prop in ipairs(props) do
            local angle = ((i-1)/total) * math.pi * 2
            local spin = t
            
            -- círculo VERTICAL (altura + lateral)
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

PropsTab:AddToggle({
    Name = "Portal Prop",
    Default = false,
    Callback = function(v)
        FRONT_CIRCLE_ENABLED = v
        if v then
            StartFrontCircle()
        else
            StopFrontCircle()
        end
    end
})

--===============================
-- PROPS DOIDOS EM MIM
--===============================

local CRAZY_ME_ENABLED = false
local CRAZY_ME_CONNECTION
local CRAZY_STATES = {}

local CRAZY_MAX_DIST = 20
local CRAZY_CHANGE_TIME_MIN = 0.15
local CRAZY_CHANGE_TIME_MAX = 0.45

local function newCrazyState(prop)
    CRAZY_STATES[prop] = {
        nextChange = tick() + math.random() * 0.3,
        targetOffset = Vector3.new(
            math.random(-CRAZY_MAX_DIST, CRAZY_MAX_DIST),
            math.random(-15, 20),
            math.random(-CRAZY_MAX_DIST, CRAZY_MAX_DIST)
        ),
        rotSpeed = Vector3.new(
            math.random(200,900),
            math.random(200,900),
            math.random(200,900)
        )
    }
end

local function StartCrazyMe()
    if CRAZY_ME_CONNECTION then CRAZY_ME_CONNECTION:Disconnect() end
    
    CRAZY_ME_CONNECTION = RunService.Heartbeat:Connect(function()
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
        local root = Character.HumanoidRootPart
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        for _,prop in ipairs(props) do
            if not CRAZY_STATES[prop] then
                newCrazyState(prop)
            end
            
            local st = CRAZY_STATES[prop]
            
            -- muda posição direto (sem sincronia)
            if tick() >= st.nextChange then
                st.targetOffset = Vector3.new(
                    math.random(-CRAZY_MAX_DIST, CRAZY_MAX_DIST),
                    math.random(-15, 20),
                    math.random(-CRAZY_MAX_DIST, CRAZY_MAX_DIST)
                )
                
                st.rotSpeed = Vector3.new(
                    math.random(300,1200),
                    math.random(300,1200),
                    math.random(300,1200)
                )
                
                st.nextChange = tick() + math.random(CRAZY_CHANGE_TIME_MIN*100, CRAZY_CHANGE_TIME_MAX*100)/100
            end
            
            local targetPos = root.Position + st.targetOffset
            
            local rx = math.rad((tick()*st.rotSpeed.X)%360)
            local ry = math.rad((tick()*st.rotSpeed.Y)%360)
            local rz = math.rad((tick()*st.rotSpeed.Z)%360)
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(
                        CFrame.new(targetPos) * CFrame.Angles(rx,ry,rz),
                        0.35
                    )
                )
            end)
        end
    end)
end

local function StopCrazyMe()
    if CRAZY_ME_CONNECTION then
        CRAZY_ME_CONNECTION:Disconnect()
        CRAZY_ME_CONNECTION = nil
    end
    CRAZY_STATES = {}
end

PropsTab:AddToggle({
    Name = "Props Doidos",
    Default = false,
    Callback = function(v)
        CRAZY_ME_ENABLED = v
        if v then
            StartCrazyMe()
        else
            StopCrazyMe()
        end
    end
})

-- Terceira seção: Props para usar em pessoas selecionadas
PropsTab:AddSection({"Props para usar em pessoas selecionadas"})

-- Variável para armazenar o jogador selecionado
local selectedPlayer = nil

-- Dropdown para selecionar jogador
local playerDropdown = PropsTab:AddDropdown({
    Name = "Selecionar Jogador",
    Default = "",
    Options = {},
    Callback = function(option)
        selectedPlayer = option
    end
})

-- Atualizar lista de jogadores
local function UpdatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    playerDropdown:Refresh(playerNames, true)
end

-- Atualizar lista quando jogadores entrarem/saírem
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

--===============================
-- PROPS NO PLAYER SELECIONADO
--===============================

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
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        t += dt * 3
        
        for i, prop in ipairs(props) do
            
            -- SENTOU → sobe MUITO ALTO
            if hum.Sit then
                if not SentProps[prop] then
                    SentProps[prop] = true
                    
                    local upPos = Vector3.new(
                        root.Position.X,
                        1000000, -- muito alto
                        root.Position.Z
                    )
                    
                    pcall(function()
                        prop.SetCurrentCFrame:InvokeServer(CFrame.new(upPos))
                    end)
                end
                continue
            end
            
            -- LEVANTOU → volta para você
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
            
            -- MOVIMENTO LOUCO EM VOLTA DO PLAYER
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

PropsTab:AddToggle({
    Name = "Prop Fling Player",
    Default = false,
    Callback = function(v)
        TARGET_ENABLED = v
        if v then
            StartSelectedTarget()
        else
            StopSelectedTarget()
        end
    end
})

--===============================
-- PLAYER SELECIONADO (SENTOU = DESCE)
--===============================

local KILL_ENABLED = false
local KILL_CONNECTION
local KillProps = {}

local function StartKillTarget()
    if KILL_CONNECTION then KILL_CONNECTION:Disconnect() end
    
    local t = 0
    
    KILL_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then return end
        
        local target = getTargetPlayer()
        if not target or not target.Character then return end
        
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        local hum = target.Character:FindFirstChild("Humanoid")
        if not root or not hum then return end
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        t += dt * 3
        
        for i, prop in ipairs(props) do
            
            -- SENTOU → vai para -460
            if hum.Sit then
                if not KillProps[prop] then
                    KillProps[prop] = true
                    
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
            
            -- LEVANTOU → volta para você
            if KillProps[prop] then
                KillProps[prop] = nil
                
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
            
            -- MOVIMENTO EM VOLTA DO PLAYER
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

local function StopKillTarget()
    if KILL_CONNECTION then
        KILL_CONNECTION:Disconnect()
        KILL_CONNECTION = nil
    end
    KillProps = {}
end

PropsTab:AddToggle({
    Name = "Prop Kill Player",
    Default = false,
    Callback = function(v)
        KILL_ENABLED = v
        if v then
            StartKillTarget()
        else
            StopKillTarget()
        end
    end
})

--===============================
-- CÍRCULO PERFEITO NO CHÃO
--===============================

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
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        t += dt * 1.8
        
        local radius = 8
        local total = #props
        
        -- tamanho do buraco em graus
        local gapAngle = math.rad(70)
        local usableAngle = (math.pi * 2) - gapAngle
        
        for i, prop in ipairs(props) do
            -- distribui TODOS dentro da parte que sobra do círculo
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

PropsTab:AddToggle({
    Name = "Prop Círculo Player",
    Default = false,
    Callback = function(v)
        RING_ENABLED = v
        if v then
            StartRing()
        else
            StopRing()
        end
    end
})

--===============================
-- PROP COBRA (PLAYER SELECIONADO)
--===============================

local COBRA_PLAYER_ENABLED = false
local COBRA_PLAYER_CONNECTION

local COBRA_PLAYER_FOLLOW_DISTANCE = 3.5
local COBRA_PLAYER_SIDE_AMPLITUDE = 3.2
local COBRA_PLAYER_UP_AMPLITUDE = 1.2
local COBRA_PLAYER_WAVE_SPEED = 10
local COBRA_PLAYER_PHASE_OFFSET = 1.1
local COBRA_PLAYER_SMOOTHNESS = 0.35

local function StartCobraPlayer()
    if COBRA_PLAYER_CONNECTION then COBRA_PLAYER_CONNECTION:Disconnect() end
    
    local time = 0
    
    COBRA_PLAYER_CONNECTION = RunService.Heartbeat:Connect(function(dt)
        local target = getTargetPlayer()
        if not target or not target.Character then return end
        
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        local hum = target.Character:FindFirstChild("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        
        local props = GetMyProps()
        if #props == 0 then return end
        
        time += dt * COBRA_PLAYER_WAVE_SPEED
        
        for i, prop in ipairs(props) do
            local phase = time - i * COBRA_PLAYER_PHASE_OFFSET
            
            local backDir = -root.CFrame.LookVector
            local rightDir = root.CFrame.RightVector
            local upDir = Vector3.new(0,1,0)
            
            local backOffset = backDir * (COBRA_PLAYER_FOLLOW_DISTANCE * i)
            local sideOffset = rightDir * (math.sin(phase) * COBRA_PLAYER_SIDE_AMPLITUDE)
            local upOffset = upDir * (math.cos(phase * 0.8) * COBRA_PLAYER_UP_AMPLITUDE)
            
            local pos = root.Position + backOffset + sideOffset + upOffset
            local cf = CFrame.new(pos, pos + backDir)
            
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(
                    prop:GetPivot():Lerp(cf, COBRA_PLAYER_SMOOTHNESS)
                )
            end)
        end
    end)
end

local function StopCobraPlayer()
    if COBRA_PLAYER_CONNECTION then
        COBRA_PLAYER_CONNECTION:Disconnect()
        COBRA_PLAYER_CONNECTION = nil
    end
end

PropsTab:AddToggle({
    Name = "Prop Cobra em Player",
    Default = false,
    Callback = function(v)
        COBRA_PLAYER_ENABLED = v
        if v then
            StartCobraPlayer()
        else
            StopCobraPlayer()
        end
    end
})

-- Funções de utilidade para obter props
PropsTab:AddSection({"Utilitários"})

PropsTab:AddButton({
    Name = "Obter Props Maker",
    Callback = function()
        pcall(function()
            ReplicatedStorage.RE["1Too1l"]:InvokeServer("PickingTools", "PropMaker")
        end)
    end
})

PropsTab:AddButton({
    Name = "Obter Prop Bleachers",
    Callback = function()
        pcall(function()
            ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer(
                "RequestingPropName",
                "FurnitureBleachers",
                "Furniture"
            )
        end)
    end
})

PropsTab:AddButton({
    Name = "Limpar Todas as Props",
    Callback = function()
        -- Desativa todas as funções
        if PROP_RAID_ENABLED then StopPropRaid() end
        if HUNT_ENABLED then StopHunter() end
        if COBRA_ENABLED then StopCobra() end
        if FURACAO_ENABLED then StopFuracao() end
        if AIR_ENABLED then StopAirSpread() end
        if FRONT_CIRCLE_ENABLED then StopFrontCircle() end
        if CRAZY_ME_ENABLED then StopCrazyMe() end
        if TARGET_ENABLED then StopSelectedTarget() end
        if KILL_ENABLED then StopKillTarget() end
        if RING_ENABLED then StopRing() end
        if COBRA_PLAYER_ENABLED then StopCobraPlayer() end
        
        -- Limpa todos os estados
        propCache = {}
        PROP_RAID_Targets = {}
        PropTargetMap = {}
        DroppedProps = {}
        CRAZY_STATES = {}
        SentProps = {}
        KillProps = {}
        
        warn("Todas as props foram limpas e funções desativadas!")
    end
})

-- Notificação de inicialização
warn("Aba Props carregada com sucesso!")
warn("Selecione um jogador na dropdown para usar as funções de player")