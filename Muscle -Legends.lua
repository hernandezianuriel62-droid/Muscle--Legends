-- ==========================================================
-- Muscle Legends - Hyper Speed Reps Hub v1.5
-- ==========================================================

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Global Flags
getgenv().HyperSpeedTraining = false
getgenv().AutoTPHalloween = false
getgenv().FastPunch = false
getgenv().AutoRebirth = false
getgenv().AutoBoss = false
getgenv().AntiAFK = true
getgenv().FPSBooster = false

-- Función segura para obtener el evento de golpes/repeticiones
local function getMuscleEvent()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("MuscleEvent") then
        return LocalPlayer.Character.MuscleEvent
    elseif ReplicatedStorage:FindFirstChild("MuscleEvent") then
        return ReplicatedStorage.MuscleEvent
    elseif ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("MuscleEvent") then
        return ReplicatedStorage.events.MuscleEvent
    end
    return nil
end

-- Función segura para obtener el evento de Rebirth
local function getRebirthEvent()
    local possibleNames = {"rEvent", "RebirthEvent", "rebirthEvent", "rebirth"}
    for _, name in ipairs(possibleNames) do
        if ReplicatedStorage:FindFirstChild(name) then
            return ReplicatedStorage[name]
        end
    end
    return nil
end

-- ----------------------------------------------------------
-- 1. Anti-AFK
-- ----------------------------------------------------------
LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- ----------------------------------------------------------
-- 2. Automatización & Hyper Speed (Decenas de Reps por Segundo)
-- ----------------------------------------------------------

-- Fast Punch
task.spawn(function()
    while true do
        task.wait()
        if getgenv().FastPunch then
            pcall(function()
                local event = getMuscleEvent()
                if event then
                    event:FireServer("punch", "rightHand")
                    event:FireServer("punch", "leftHand")
                end
            end)
        end
    end
end)

-- Auto Rebirth
task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().AutoRebirth then
            pcall(function()
                local rEvent = getRebirthEvent()
                if rEvent then
                    rEvent:FireServer("rebirthRequest")
                end
            end)
        end
    end
end)

-- HYPER SPEED TRAINING (Dispara decenas/cientos de repeticiones por segundo en bucle paralelo)
task.spawn(function()
    while true do
        if getgenv().HyperSpeedTraining then
            pcall(function()
                local event = getMuscleEvent()
                if event then
                    -- Lanza múltiples ráfagas instantáneas en el mismo ciclo
                    for i = 1, 15 do
                        event:FireServer("rep")
                    end
                end
            end)
        end
        task.wait() -- Sin retraso fijo, avanza al siguiente micro-ciclo inmediatamente
    end
end)

-- AUTO TP & HALLOWEEN GYM + HYPER SPEED
task.spawn(function()
    while true do
        if getgenv().AutoTPHalloween then
            pcall(function()
                local event = getMuscleEvent()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    
                    -- Busca la máquina de Halloween en el mapa y te posiciona
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("halloween") or obj.Name:lower():find("spooky") or obj.Name:lower():find("pumpkin") or obj.Name:lower():find("candy") then
                            if obj:IsA("BasePart") and (obj.Size.Magnitude > 2 and obj.Size.Magnitude < 20) then
                                hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                break
                            end
                        end
                    end
                    
                    -- Envía la ráfaga masiva de repeticiones
                    if event then
                        for i = 1, 15 do
                            event:FireServer("rep")
                        end
                    end
                end
            end)
        end
        task.wait()
    end
end)

-- Auto Boss
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().AutoBoss then
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:lower():find("boss") or obj.Name == "Electro Legends Boss" or obj.Name == "King Kronos" then
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                        local hum = obj:FindFirstChild("Humanoid")
                        if hrp and hum and hum.Health > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, 4)
                            local event = getMuscleEvent()
                            if event then
                                event:FireServer("punch", "rightHand")
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- 3. Interfaz Gráfica (GUI)
-- ----------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MuscleLegendsGUI"
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 380)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Muscle Hub v1.5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Botón Minimizar (-)
local ToggleSizeBtn = Instance.new("TextButton")
ToggleSizeBtn.Size = UDim2.new(0, 25, 0, 25)
ToggleSizeBtn.Position = UDim2.new(1, -30, 0, 5)
ToggleSizeBtn.Text = "-"
ToggleSizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleSizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleSizeBtn.Font = Enum.Font.GothamBold
ToggleSizeBtn.TextSize = 16
ToggleSizeBtn.Parent = MainFrame

local UICornerBtn = Instance.new("UICorner", ToggleSizeBtn)
UICornerBtn.CornerRadius = UDim.new(0, 5)

-- Contenedor
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -45)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- Función para crear Toggles
local function CreateToggle(name, flagName, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 13
    Button.Parent = Container

    local Corner = Instance.new("UICorner", Button)
    Corner.CornerRadius = UDim.new(0, 6)

    Button.MouseButton1Click:Connect(function()
        getgenv()[flagName] = not getgenv()[flagName]
        if getgenv()[flagName] then
            Button.Text = name .. ": ON"
            Button.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Button.Text = name .. ": OFF"
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        if callback then callback(getgenv()[flagName]) end
    end)
end

-- Lógica de minimizar
local minimized = false
ToggleSizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Container.Visible = false
        MainFrame.Size = UDim2.new(0, 240, 0, 35)
        ToggleSizeBtn.Text = "+"
    else
        Container.Visible = true
        MainFrame.Size = UDim2.new(0, 240, 0, 380)
        ToggleSizeBtn.Text = "-"
    end
end)

-- Creación de Botones en la Interfaz
CreateToggle("Auto TP & Halloween", "AutoTPHalloween")
CreateToggle("Hyper Speed (Massive)", "HyperSpeedTraining")
CreateToggle("Fast Punch", "FastPunch")
CreateToggle("Auto Rebirth", "AutoRebirth")
CreateToggle("Auto Boss", "AutoBoss")
CreateToggle("Anti AFK", "AntiAFK")

-- FPS Booster
CreateToggle("FPS Booster", "FPSBooster", function(state)
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        game:GetService("Lighting").GlobalShadows = false
    end
end)

Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
