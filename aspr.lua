-- سكربت نسخ الحيوانات والتداول لروبلوكس
-- Save هذا السكربت في LocalScript داخل StarterGui

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- تأكد من تعديل هذه الأسماء وفقًا للعبة
local REMOTE_NAMES = {
    TRADE_REQUEST = "TradeRequest",
    TRADE_ADD_ITEM = "TradeAddItem",
    TRADE_ACCEPT = "TradeAccept",
    CLONE_PET = "ClonePet"
}

-- البحث عن الريموتس
local events = {}
for name, remoteName in pairs(REMOTE_NAMES) do
    events[name] = ReplicatedStorage:FindFirstChild(remoteName) or 
                  ReplicatedStorage:FindFirstChild("Events"):FindFirstChild(remoteName) or
                  ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild(remoteName)
end

-- واجهة المستخدم
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimalTradeGUI"
ScreenGui.Parent = player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
Title.Text = "نظام نسخ وتداول الحيوانات"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Title

local AnimalsList = Instance.new("ScrollingFrame")
AnimalsList.Size = UDim2.new(0.9, 0, 0, 150)
AnimalsList.Position = UDim2.new(0.05, 0, 0.15, 0)
AnimalsList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AnimalsList.BorderSizePixel = 0
AnimalsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
AnimalsList.ScrollBarThickness = 5
AnimalsList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = AnimalsList

local CloneButton = Instance.new("TextButton")
CloneButton.Size = UDim2.new(0.9, 0, 0, 40)
CloneButton.Position = UDim2.new(0.05, 0, 0.55, 0)
CloneButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
CloneButton.Text = "نسخ الحيوان المحدد"
CloneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloneButton.Font = Enum.Font.GothamBold
CloneButton.TextSize = 14
CloneButton.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = CloneButton

local TargetPlayerBox = Instance.new("TextBox")
TargetPlayerBox.Size = UDim2.new(0.9, 0, 0, 40)
TargetPlayerBox.Position = UDim2.new(0.05, 0, 0.68, 0)
TargetPlayerBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TargetPlayerBox.PlaceholderText = "اسم اللاعب للتداول"
TargetPlayerBox.Text = ""
TargetPlayerBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TargetPlayerBox.Font = Enum.Font.Gotham
TargetPlayerBox.TextSize = 14
TargetPlayerBox.Parent = MainFrame

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 6)
UICorner4.Parent = TargetPlayerBox

local TradeButton = Instance.new("TextButton")
TradeButton.Size = UDim2.new(0.9, 0, 0, 40)
TradeButton.Position = UDim2.new(0.05, 0, 0.82, 0)
TradeButton.BackgroundColor3 = Color3.fromRGB(156, 39, 176)
TradeButton.Text = "بدء التداول"
TradeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TradeButton.Font = Enum.Font.GothamBold
TradeButton.TextSize = 14
TradeButton.Parent = MainFrame

local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 6)
UICorner5.Parent = TradeButton

-- متغيرات
local selectedAnimal = nil
local playerAnimals = {}

-- وظيفة البحث عن الحيوانات
local function findPlayerAnimals()
    playerAnimals = {}
    AnimalsList:ClearAllChildren()
    
    -- البحث في workspace
    local animalsFolder = workspace:FindFirstChild("Pets") or 
                         workspace:FindFirstChild("Animals") or
                         workspace:FindFirstChild("PetsFolder")
    
    if animalsFolder then
        for _, animal in pairs(animalsFolder:GetChildren()) do
            if animal:FindFirstChild("Owner") and animal.Owner.Value == player then
                table.insert(playerAnimals, animal)
                
                local animalButton = Instance.new("TextButton")
                animalButton.Size = UDim2.new(1, -10, 0, 30)
                animalButton.Position = UDim2.new(0, 5, 0, 0)
                animalButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                animalButton.Text = animal.Name
                animalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                animalButton.Font = Enum.Font.Gotham
                animalButton.TextSize = 12
                animalButton.Parent = AnimalsList
                
                animalButton.MouseButton1Click:Connect(function()
                    selectedAnimal = animal
                    for _, btn in pairs(AnimalsList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        end
                    end
                    animalButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
                end)
            end
        end
    end
    
    if #playerAnimals == 0 then
        local noPetsLabel = Instance.new("TextLabel")
        noPetsLabel.Size = UDim2.new(1, 0, 0, 30)
        noPetsLabel.BackgroundTransparency = 1
        noPetsLabel.Text = "لا تمتلك أي حيوانات"
        noPetsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        noPetsLabel.Font = Enum.Font.Gotham
        noPetsLabel.TextSize = 14
        noPetsLabel.Parent = AnimalsList
    end
end

-- نسخ الحيوان
CloneButton.MouseButton1Click:Connect(function()
    if selectedAnimal then
        if events.CLONE_PET then
            events.CLONE_PET:FireServer(selectedAnimal)
        else
            -- محاولة نسخ الحيوان يدوياً إذا لم يوجد ريموت
            local clone = selectedAnimal:Clone()
            clone.Parent = selectedAnimal.Parent
            clone:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
        end
    end
end)

-- بدء التداول
TradeButton.MouseButton1Click:Connect(function()
    if selectedAnimal and TargetPlayerBox.Text ~= "" then
        local targetPlayer = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(TargetPlayerBox.Text:lower()) or p.DisplayName:lower():find(TargetPlayerBox.Text:lower()) then
                targetPlayer = p
                break
            end
        end
        
        if targetPlayer then
            if events.TRADE_REQUEST then
                events.TRADE_REQUEST:FireServer(targetPlayer)
                
                -- إضافة الحيوان للتداول بعد ثانية
                wait(1)
                if events.TRADE_ADD_ITEM then
                    events.TRADE_ADD_ITEM:FireServer(selectedAnimal)
                end
            else
                warn("لم يتم العثور على حدث التداول في اللعبة")
            end
        else
            warn("لم يتم العثور على اللاعب: " .. TargetPlayerBox.Text)
        end
    end
end)

-- تحديث قائمة الحيوانات كل 5 ثواني
while true do
    findPlayerAnimals()
    wait(5)
end
