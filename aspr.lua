-- Mock Pets + Trade UI (Client-side only - Educational/Fake)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Fake inventory data
local pets = {
    {name="Dragon", rarity="Legendary"},
    {name="Phoenix", rarity="Legendary"},
    {name="Wolf", rarity="Rare"},
    {name="Cat", rarity="Common"},
    {name="Dog", rarity="Common"},
    {name="Tiger", rarity="Epic"},
}

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "FakeTradePetsUI"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local function createCard(pet)
    local c = Instance.new("Frame")
    c.BackgroundColor3 = Color3.fromRGB(40,40,40)
    c.Size = UDim2.new(1, -8, 0, 46)
    c.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel")
    lbl.Parent = c
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -100, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = pet.name .. "  •  " .. pet.rarity
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.TextScaled = true

    local add = Instance.new("TextButton")
    add.Parent = c
    add.Size = UDim2.new(0, 90, 0, 32)
    add.Position = UDim2.new(1, -96, 0.5, -16)
    add.Text = "Add to Trade"
    add.Font = Enum.Font.Gotham
    add.TextScaled = true
    add.BackgroundColor3 = Color3.fromRGB(70,70,70)
    add.TextColor3 = Color3.fromRGB(255,255,255)
    add.AutoButtonColor = true

    return c, add
end

local function rounded(obj, radius)
    local ui = Instance.new("UICorner")
    ui.CornerRadius = UDim.new(0, radius)
    ui.Parent = obj
end

local container = Instance.new("Frame")
container.Parent = gui
container.Size = UDim2.new(0.9, 0, 0.8, 0)
container.Position = UDim2.new(0.05, 0, 0.1, 0)
container.BackgroundColor3 = Color3.fromRGB(25,25,25)
rounded(container, 16)

local title = Instance.new("TextLabel")
title.Parent = container
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.Font = Enum.Font.GothamBlack
title.Text = "Fake Pets Inventory & Trade (Client-side demo)"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

local left = Instance.new("Frame")
left.Parent = container
left.Size = UDim2.new(0.5, -15, 1, -70)
left.Position = UDim2.new(0, 10, 0, 60)
left.BackgroundColor3 = Color3.fromRGB(30,30,30)
rounded(left, 12)

local right = Instance.new("Frame")
right.Parent = container
right.Size = UDim2.new(0.5, -15, 1, -70)
right.Position = UDim2.new(0.5, 5, 0, 60)
right.BackgroundColor3 = Color3.fromRGB(30,30,30)
rounded(right, 12)

local invTitle = Instance.new("TextLabel")
invTitle.Parent = left
invTitle.BackgroundTransparency = 1
invTitle.Size = UDim2.new(1, -20, 0, 32)
invTitle.Position = UDim2.new(0, 10, 0, 8)
invTitle.Font = Enum.Font.GothamBold
invTitle.Text = "Your Pets (Mock)"
invTitle.TextColor3 = Color3.fromRGB(255,255,255)
invTitle.TextScaled = true
invTitle.TextXAlignment = Enum.TextXAlignment.Left

local tradeTitle = Instance.new("TextLabel")
tradeTitle.Parent = right
tradeTitle.BackgroundTransparency = 1
tradeTitle.Size = UDim2.new(1, -20, 0, 32)
tradeTitle.Position = UDim2.new(0, 10, 0, 8)
tradeTitle.Font = Enum.Font.GothamBold
tradeTitle.Text = "Trade Window (Local)"
tradeTitle.TextColor3 = Color3.fromRGB(255,255,255)
tradeTitle.TextScaled = true
tradeTitle.TextXAlignment = Enum.TextXAlignment.Left

local invList = Instance.new("ScrollingFrame")
invList.Parent = left
invList.Size = UDim2.new(1, -20, 1, -60)
invList.Position = UDim2.new(0, 10, 0, 50)
invList.CanvasSize = UDim2.new(0, 0, 0, 0)
invList.ScrollBarThickness = 6
invList.BackgroundTransparency = 1

local tradeList = Instance.new("ScrollingFrame")
tradeList.Parent = right
tradeList.Size = UDim2.new(1, -20, 1, -110)
tradeList.Position = UDim2.new(0, 10, 0, 50)
tradeList.CanvasSize = UDim2.new(0, 0, 0, 0)
tradeList.ScrollBarThickness = 6
tradeList.BackgroundTransparency = 1

local confirm = Instance.new("TextButton")
confirm.Parent = right
confirm.Size = UDim2.new(1, -20, 0, 44)
confirm.Position = UDim2.new(0, 10, 1, -52)
confirm.Text = "Confirm (Demo)"
confirm.Font = Enum.Font.GothamBold
confirm.TextScaled = true
confirm.BackgroundColor3 = Color3.fromRGB(60,120,60)
confirm.TextColor3 = Color3.fromRGB(255,255,255)
rounded(confirm, 10)

local tradePets = {}

local function refreshList(frame)
    local y = 0
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, pet in ipairs(pets) do
        local card, addBtn = createCard(pet)
        card.Parent = frame
        card.Position = UDim2.new(0, 0, 0, y)
        rounded(card, 8)
        y = y + 52
        addBtn.MouseButton1Click:Connect(function()
            table.insert(tradePets, pet)
            local t = Instance.new("TextLabel")
            t.Parent = tradeList
            t.BackgroundColor3 = Color3.fromRGB(45,45,45)
            t.Size = UDim2.new(1, -8, 0, 38)
            t.Position = UDim2.new(0, 0, 0, (#tradeList:GetChildren()-1)*40)
            t.Text = pet.name .. " (" .. pet.rarity .. ")"
            t.Font = Enum.Font.Gotham
            t.TextScaled = true
            t.TextColor3 = Color3.fromRGB(255,255,255)
            rounded(t, 8)
            tradeList.CanvasSize = UDim2.new(0, 0, 0, (#tradeList:GetChildren()-1)*40)
        end)
    end
    frame.CanvasSize = UDim2.new(0, 0, 0, y)
end

refreshList(invList)

confirm.MouseButton1Click:Connect(function()
    local names = {}
    for _, p in ipairs(tradePets) do table.insert(names, p.name) end
    local msg = "Trade (LOCAL DEMO) confirmed with pets: " .. (table.concat(names, ", "))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Trade Demo",
        Text = msg ~= "" and msg or "No pets added.",
        Duration = 4
    })
end)
