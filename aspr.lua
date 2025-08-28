-- نسخ هذا السكربت كاملاً في LocalScript داخل StarterGui
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- واجهة المستخدم البسيطة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleTradeGUI"
ScreenGui.Parent = player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "نظام التداول البسيط"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
Title.TextColor3 = Color3.white
Title.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Text = "جاري البحث عن حيوانات..."
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0, 40)
Status.TextColor3 = Color3.white
Status.Parent = Frame

-- البحث عن الحيوانات
local function findAnimals()
    local animals = {}
    
    -- الأماكن المحتملة للحيوانات
    local possibleFolders = {
        workspace:FindFirstChild("Pets"),
        workspace:FindFirstChild("Animals"),
        workspace:FindFirstChild("PetsFolder"),
        player:FindFirstChild("Pets"),
        player:FindFirstChild("Animals")
    }
    
    for _, folder in pairs(possibleFolders) do
        if folder then
            for _, item in pairs(folder:GetChildren()) do
                if item:FindFirstChild("Owner") and item.Owner.Value == player then
                    table.insert(animals, item)
                end
            end
        end
    end
    
    return animals
end

-- محاولة التداول
local function tryTrade(animalName, targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if not targetPlayer then
        return "اللاعب غير موجود"
    end
    
    local animals = findAnimals()
    local selectedAnimal = nil
    
    for _, animal in pairs(animals) do
        if animal.Name == animalName then
            selectedAnimal = animal
            break
        end
    end
    
    if not selectedAnimal then
        return "الحيوان غير موجود"
    end
    
    -- محاولة إيجاد أحداث التداول
    local tradeEvent = ReplicatedStorage:FindFirstChild("TradeEvent") or
                      ReplicatedStorage:FindFirstChild("TradeRequest")
    
    if tradeEvent then
        tradeEvent:FireServer(targetPlayer, selectedAnimal)
        return "تم إرسال طلب التداول"
    else
        return "لم يتم العثور على نظام التداول"
    end
end

-- تحديث الحالة
coroutine.wrap(function()
    while true do
        local animals = findAnimals()
        Status.Text = "عدد الحيوانات: " .. #animals
        wait(5)
    end
end)()

-- أوامر الدردشة
player.Chatted:Connect(function(message)
    if message:sub(1, 6) == "!trade " then
        local parts = message:split(" ")
        if #parts >= 3 then
            local result = tryTrade(parts[2], parts[3])
            Status.Text = result
        end
    end
end)
