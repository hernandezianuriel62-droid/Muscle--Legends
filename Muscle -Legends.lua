-- ==========================================================
-- Muscle Legends - Ultra Fast Training & Hub v1.1
-- ==========================================================

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Global Flags
getgenv().UltraFastTraining = false
getgenv().AutoRebirth = false
getgenv().FastPunch = false
getgenv().AutoBoss = false
getgenv().AntiAFK = true
getgenv().FPSBooster = false

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
-- 2. Automatización Avanzada (Ultra Fast Reps & Punch)
-- ----------------------------------------------------------

-- Fast Punch / Ataque Rápido
task.spawn(function()
    while true do
        task.wait()
        if getgenv().FastPunch then
            pcall(function()
                local muscleEvent = LocalPlayer.MuscleEvent or ReplicatedStorage:FindFirstChild("MuscleEvent")
                if muscleEvent then
                    muscleEvent:FireServer("punch", "rightHand")
                    muscleEvent:FireServer("punch", "leftHand")
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
                local rebirthEvent = ReplicatedStorage:FindFirstChild("rEvent") or ReplicatedStorage:FindFirstChild("RebirthEvent")
                if rebirthEvent then
                    rebirthEvent:FireServer("rebirthRequest")
                end
            end)
        end
    end
end)

-- ULTRA FAST TRAINING (Bucle síncronizado por cuadro para velocidad máxima)
RunService.RenderStepped:Connect(function()
    if getgenv().UltraFastTraining then
        pcall(function()
            local muscleEvent = LocalPlayer.MuscleEvent or ReplicatedStorage:FindFirstChild("MuscleEvent")
            if muscleEvent then
                -- Dispara múltiples repeticiones de golpe por frame para saturar la velocidad
                muscleEvent:FireServer("rep")
                muscleEvent:FireServer("rep")
            end
        end)
    end
end)

-- Auto Boss
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().AutoBoss then
            pcall(function()
                local bossFolder = workspace:FindFirstChild("Bosses") or workspace:FindFirstChild("Boss")
                if bossFolder then
                    for _, boss in pairs(bossFolder:GetChildren()) do
                        local hrp = boss:FindFirstChild("HumanoidRootPart")
                        local hum = boss:FindFirstChild("Humanoid")
                        if hrp and hum and hum.Health > 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, 3)
                            local muscleEvent = LocalPlayer.MuscleEvent or ReplicatedStorage:FindFirstChild("MuscleEvent")
                            if muscleEvent then
                                muscleEvent:FireServer("punch", "rightHand")
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
MainFrame.Size = UDim2.new(0, 240, 0, 310)
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
Title.Text = "Muscle Hub v1.1"
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
        MainFrame.Size = UDim2.new(0, 240, 0, 310)
        ToggleSizeBtn.Text = "-"
    end
end)

-- ----------------------------------------------------------
-- 4. Creación de Botones en la Interfaz
-- ----------------------------------------------------------
CreateToggle("Ultra Fast Training", "UltraFastTraining")
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
1
