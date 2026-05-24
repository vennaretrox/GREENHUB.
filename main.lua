-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hyperActive = false
local hyperMultiplier = 1.3 -- Doğal ve fark edilmeyen gizli hız çarpanı

-- [GREENHUB LEGACY BASE - V92]
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V92_LEGACY"

-- LOGO (ESKİ KISA G H)
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(60, 60)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 80, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
btn.ZIndex = 10
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 40, 0)
btnStroke.Thickness = 2.5

-- MENÜ TASARIMI
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(250, 350)
menu.Position = UDim2.new(0, 50, 0, 120)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

-- BAŞLIKLAR
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 15)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 42)
sub.BackgroundTransparency = 1
sub.Text = "TIME BOMB"
sub.TextColor3 = Color3.fromRGB(0, 120, 0)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 15

-- [YAVAŞ LOGO PARLAMA ANİMASYONU - 1.2s]
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    local isVis = menu.Visible
    
    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(btn, tweenInfo, {
        TextColor3 = isVis and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 80, 0)
    }):Play()
    
    TweenService:Create(btnStroke, tweenInfo, {
        Color = isVis and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 40, 0),
        Thickness = isVis and 2.9 or 2.5
    }):Play()
end)

-- SÜRÜKLEME SİSTEMİ
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = btn.Position end end)
UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 70) end end)
UIS.InputEnded:Connect(function(input) dragging = false end)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.Position = UDim2.new(0, 10, 0, 95)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

-- Geliştirilmiş Renkli Buton Fonksiyonu
local function createButton(text, onColor, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 255, 0) -- OFF durumunda hepsi yeşil
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        -- ON olduğunda butona özel atanan renk, OFF olduğunda yeşil
        local targetColor = active and onColor or Color3.fromRGB(0, 255, 0)
        TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = targetColor}):Play()
        b.Text = text .. (active and ": ON" or ": OFF")
        callback(active)
    end)
end

-- RENK PALETİ
local colorOrange = Color3.fromRGB(255, 140, 0)
local colorYellow = Color3.fromRGB(255, 255, 0)
local colorPurple = Color3.fromRGB(140, 0, 255)
local colorRed    = Color3.fromRGB(255, 0, 0)

-- ==========================================
--     TIME BOMB ALPHA STEALTH FEATURES
-- ==========================================

-- 1. BOMB TRACKER (ON: TURUNCU)
local bombFolder = Instance.new("Folder", CoreGui)
createButton("Bomb Tracker", colorOrange, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            if not state then return end
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if (v.Name:find("Bomb") or v:IsA("Tool") and v.Name:find("Bomb")) and not bombFolder:FindFirstChild(v.Name) then
                    local highlight = Instance.new("Highlight", bombFolder)
                    highlight.Name = v.Name
                    highlight.Adornee = v
                    highlight.FillColor = Color3.fromRGB(140, 0, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                end
            end
        end)
    else
        bombFolder:ClearAllChildren()
    end
end)

-- 2. LEGIT VELOCITY (ON: MOR) -> İsteğin üzerine ON olunca mor yanan gizli hız eklendi
local speedConnection
createButton("Legit Velocity", colorPurple, function(state)
    hyperActive = state
    if hyperActive then
        speedConnection = RunService.Stepped:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
                if character.Humanoid.MoveDirection.Magnitude > 0 then
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + (character.Humanoid.MoveDirection * (hyperMultiplier / 15))
                end
            end
        end)
    else
        if speedConnection then speedConnection:Disconnect() end
    end
end)

-- 3. PLAYER VISION (ON: SARI)
local playerEspFolder = Instance.new("Folder", CoreGui)
createButton("Player Vision", colorYellow, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            if not state then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not playerEspFolder:FindFirstChild(p.Name) then
                        local hl = Instance.new("Highlight", playerEspFolder)
                        hl.Name = p.Name
                        hl.Adornee = p.Character
                        hl.FillColor = Color3.fromRGB(255, 255, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.6
                    end
                end
            end
        end)
    else
        playerEspFolder:ClearAllChildren()
    end
end)

-- 4. SILENT DEFUSE (ON: KIRMIZI - EN GÜÇLÜ ÖZELLİK)
local promptConnection
createButton("Silent Defuse", colorRed, function(state)
    if state then
        promptConnection = game.Workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end)
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
    else
        if promptConnection then promptConnection:Disconnect() end
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 3
            end
        end
    end
end)
