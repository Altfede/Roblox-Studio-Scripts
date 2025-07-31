-- Inventory GUI System for Roblox Studio
-- Questo script gestisce l'interfaccia dell'inventario per visualizzare gli oggetti posseduti

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Moduli
local ShopData = require(script.Parent:WaitForChild("ShopData"))
local CurrencyManager = require(script.Parent:WaitForChild("CurrencyManager"))

-- Variabili globali
local inventoryGui
local mainFrame
local itemsScrollFrame
local statsFrame
local isInventoryOpen = false

-- Funzione per creare la GUI dell'inventario
local function createInventoryGUI()
    -- ScreenGui principale
    inventoryGui = Instance.new("ScreenGui")
    inventoryGui.Name = "InventoryGUI"
    inventoryGui.ResetOnSpawn = false
    inventoryGui.Parent = playerGui
    
    -- Frame principale dell'inventario
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.075, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = inventoryGui
    
    -- Angoli arrotondati
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Header dell'inventario
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = header
    
    -- Titolo dell'inventario
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎒 INVENTARIO"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = header
    
    -- Bottone di chiusura
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 50, 0, 50)
    closeButton.Position = UDim2.new(1, -60, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 25)
    closeCorner.Parent = closeButton
    
    -- Frame delle statistiche del giocatore
    statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.Size = UDim2.new(0.25, -10, 1, -80)
    statsFrame.Position = UDim2.new(0, 10, 0, 80)
    statsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = mainFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 12)
    statsCorner.Parent = statsFrame
    
    -- Titolo delle statistiche
    local statsTitle = Instance.new("TextLabel")
    statsTitle.Name = "StatsTitle"
    statsTitle.Size = UDim2.new(1, -20, 0, 40)
    statsTitle.Position = UDim2.new(0, 10, 0, 10)
    statsTitle.BackgroundTransparency = 1
    statsTitle.Text = "📊 STATISTICHE"
    statsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsTitle.TextScaled = true
    statsTitle.Font = Enum.Font.GothamBold
    statsTitle.Parent = statsFrame
    
    -- Container per le statistiche
    local statsContainer = Instance.new("ScrollingFrame")
    statsContainer.Name = "StatsContainer"
    statsContainer.Size = UDim2.new(1, -20, 1, -60)
    statsContainer.Position = UDim2.new(0, 10, 0, 50)
    statsContainer.BackgroundTransparency = 1
    statsContainer.BorderSizePixel = 0
    statsContainer.ScrollBarThickness = 6
    statsContainer.Parent = statsFrame
    
    local statsLayout = Instance.new("UIListLayout")
    statsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    statsLayout.Padding = UDim.new(0, 10)
    statsLayout.Parent = statsContainer
    
    -- Area di scroll per gli oggetti dell'inventario
    itemsScrollFrame = Instance.new("ScrollingFrame")
    itemsScrollFrame.Name = "ItemsScrollFrame"
    itemsScrollFrame.Size = UDim2.new(0.75, -20, 1, -80)
    itemsScrollFrame.Position = UDim2.new(0.25, 10, 0, 80)
    itemsScrollFrame.BackgroundTransparency = 1
    itemsScrollFrame.BorderSizePixel = 0
    itemsScrollFrame.ScrollBarThickness = 8
    itemsScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    itemsScrollFrame.Parent = mainFrame
    
    -- Layout per gli oggetti
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 180, 0, 220)
    gridLayout.CellPadding = UDim2.new(0, 15, 0, 15)
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = itemsScrollFrame
    
    -- Padding per il contenuto
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = itemsScrollFrame
    
    -- Eventi
    closeButton.MouseButton1Click:Connect(function()
        closeInventory()
    end)
    
    -- Aggiorna il canvas size quando il layout cambia
    gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        itemsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
    end)
    
    statsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        statsContainer.CanvasSize = UDim2.new(0, 0, 0, statsLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- Funzione per creare una statistica
local function createStatItem(parent, label, value, icon)
    local statFrame = Instance.new("Frame")
    statFrame.Name = label .. "Stat"
    statFrame.Size = UDim2.new(1, 0, 0, 50)
    statFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    statFrame.BorderSizePixel = 0
    statFrame.Parent = parent
    
    local statCorner = Instance.new("UICorner")
    statCorner.CornerRadius = UDim.new(0, 8)
    statCorner.Parent = statFrame
    
    local statLabel = Instance.new("TextLabel")
    statLabel.Name = "Label"
    statLabel.Size = UDim2.new(1, -10, 0.5, 0)
    statLabel.Position = UDim2.new(0, 5, 0, 0)
    statLabel.BackgroundTransparency = 1
    statLabel.Text = icon .. " " .. label
    statLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statLabel.TextScaled = true
    statLabel.Font = Enum.Font.Gotham
    statLabel.TextXAlignment = Enum.TextXAlignment.Left
    statLabel.Parent = statFrame
    
    local statValue = Instance.new("TextLabel")
    statValue.Name = "Value"
    statValue.Size = UDim2.new(1, -10, 0.5, 0)
    statValue.Position = UDim2.new(0, 5, 0.5, 0)
    statValue.BackgroundTransparency = 1
    statValue.Text = tostring(value)
    statValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    statValue.TextScaled = true
    statValue.Font = Enum.Font.GothamBold
    statValue.TextXAlignment = Enum.TextXAlignment.Left
    statValue.Parent = statFrame
    
    return statFrame
end

-- Funzione per aggiornare le statistiche
local function updateStats()
    -- Pulisci statistiche esistenti
    for _, child in ipairs(statsFrame.StatsContainer:GetChildren()) do
        if child:IsA("Frame") and string.find(child.Name, "Stat") then
            child:Destroy()
        end
    end
    
    local stats = CurrencyManager.getPlayerStats(player)
    if stats then
        createStatItem(statsFrame.StatsContainer, "Monete", stats.coins, "💰")
        createStatItem(statsFrame.StatsContainer, "Oggetti", stats.itemsOwned, "📦")
        createStatItem(statsFrame.StatsContainer, "Spese Totali", stats.totalSpent, "💸")
        createStatItem(statsFrame.StatsContainer, "Guadagni Totali", stats.totalEarned, "💎")
        
        -- Calcola il valore dell'inventario
        local inventoryValue = 0
        local inventory = CurrencyManager.getInventory(player)
        for itemId, quantity in pairs(inventory) do
            local itemData = ShopData.getItemById(itemId)
            if itemData then
                inventoryValue = inventoryValue + (itemData.price * quantity)
            end
        end
        
        createStatItem(statsFrame.StatsContainer, "Valore Inventario", inventoryValue, "💼")
        
        -- Calcola il risparmio
        local savings = stats.totalEarned - stats.totalSpent
        createStatItem(statsFrame.StatsContainer, "Risparmi", savings, "🏦")
    end
end

-- Funzione per creare un oggetto dell'inventario
local function createInventoryItem(itemData, quantity, index)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "Item_" .. itemData.id
    itemFrame.Size = UDim2.new(0, 180, 0, 220)
    itemFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    itemFrame.BorderSizePixel = 0
    itemFrame.LayoutOrder = index
    itemFrame.Parent = itemsScrollFrame
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 12)
    itemCorner.Parent = itemFrame
    
    -- Bordo di rarità
    local rarityBorder = Instance.new("UIStroke")
    rarityBorder.Color = ShopData.getRarityColor(itemData.rarity)
    rarityBorder.Thickness = 3
    rarityBorder.Parent = itemFrame
    
    -- Immagine dell'oggetto
    local itemImage = Instance.new("ImageLabel")
    itemImage.Name = "ItemImage"
    itemImage.Size = UDim2.new(1, -20, 0, 100)
    itemImage.Position = UDim2.new(0, 10, 0, 10)
    itemImage.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    itemImage.BorderSizePixel = 0
    itemImage.Image = itemData.image or ""
    itemImage.ScaleType = Enum.ScaleType.Fit
    itemImage.Parent = itemFrame
    
    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 8)
    imageCorner.Parent = itemImage
    
    -- Quantità dell'oggetto
    if quantity > 1 then
        local quantityLabel = Instance.new("TextLabel")
        quantityLabel.Name = "QuantityLabel"
        quantityLabel.Size = UDim2.new(0, 40, 0, 25)
        quantityLabel.Position = UDim2.new(1, -45, 0, 5)
        quantityLabel.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        quantityLabel.BorderSizePixel = 0
        quantityLabel.Text = "x" .. quantity
        quantityLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        quantityLabel.TextScaled = true
        quantityLabel.Font = Enum.Font.GothamBold
        quantityLabel.Parent = itemImage
        
        local quantityCorner = Instance.new("UICorner")
        quantityCorner.CornerRadius = UDim.new(0, 12)
        quantityCorner.Parent = quantityLabel
    end
    
    -- Nome dell'oggetto
    local itemName = Instance.new("TextLabel")
    itemName.Name = "ItemName"
    itemName.Size = UDim2.new(1, -20, 0, 25)
    itemName.Position = UDim2.new(0, 10, 0, 120)
    itemName.BackgroundTransparency = 1
    itemName.Text = itemData.name
    itemName.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemName.TextScaled = true
    itemName.Font = Enum.Font.GothamBold
    itemName.Parent = itemFrame
    
    -- Rarità dell'oggetto
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Name = "RarityLabel"
    rarityLabel.Size = UDim2.new(1, -20, 0, 20)
    rarityLabel.Position = UDim2.new(0, 10, 0, 145)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = string.upper(itemData.rarity)
    rarityLabel.TextColor3 = ShopData.getRarityColor(itemData.rarity)
    rarityLabel.TextScaled = true
    rarityLabel.Font = Enum.Font.Gotham
    rarityLabel.Parent = itemFrame
    
    -- Descrizione dell'oggetto
    local itemDescription = Instance.new("TextLabel")
    itemDescription.Name = "ItemDescription"
    itemDescription.Size = UDim2.new(1, -20, 0, 30)
    itemDescription.Position = UDim2.new(0, 10, 0, 170)
    itemDescription.BackgroundTransparency = 1
    itemDescription.Text = itemData.description
    itemDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
    itemDescription.TextWrapped = true
    itemDescription.TextScaled = true
    itemDescription.Font = Enum.Font.Gotham
    itemDescription.Parent = itemFrame
    
    -- Valore dell'oggetto
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(1, -20, 0, 20)
    valueLabel.Position = UDim2.new(0, 10, 1, -30)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = "💰 Valore: " .. (itemData.price * quantity)
    valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = itemFrame
    
    -- Effetto di apparizione
    itemFrame.BackgroundTransparency = 1
    itemFrame.Size = UDim2.new(0, 0, 0, 0)
    
    wait(index * 0.03)
    
    local appearTween = TweenService:Create(itemFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 180, 0, 220)
    })
    appearTween:Play()
    
    -- Effetto hover
    itemFrame.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 185, 0, 225),
            BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        })
        hoverTween:Play()
    end)
    
    itemFrame.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 180, 0, 220),
            BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        })
        leaveTween:Play()
    end)
end

-- Funzione per popolare l'inventario
local function populateInventory()
    -- Pulisci oggetti esistenti
    for _, child in ipairs(itemsScrollFrame:GetChildren()) do
        if child:IsA("Frame") and string.find(child.Name, "Item_") then
            child:Destroy()
        end
    end
    
    local inventory = CurrencyManager.getInventory(player)
    local index = 1
    
    if next(inventory) == nil then
        -- Inventario vuoto
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Name = "EmptyLabel"
        emptyLabel.Size = UDim2.new(1, 0, 0, 100)
        emptyLabel.Position = UDim2.new(0, 0, 0.3, 0)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "🎒\n\nIl tuo inventario è vuoto!\nVisita il negozio per acquistare oggetti."
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.TextScaled = true
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.Parent = itemsScrollFrame
    else
        for itemId, quantity in pairs(inventory) do
            local itemData = ShopData.getItemById(itemId)
            if itemData then
                spawn(function()
                    createInventoryItem(itemData, quantity, index)
                end)
                index = index + 1
            end
        end
    end
    
    -- Aggiorna le statistiche
    updateStats()
end

-- Funzione per aprire l'inventario
function openInventory()
    if not isInventoryOpen then
        isInventoryOpen = true
        mainFrame.Visible = true
        
        -- Popola l'inventario
        populateInventory()
        
        -- Animazione di apertura
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.9, 0, 0.85, 0),
            Position = UDim2.new(0.05, 0, 0.075, 0)
        })
        openTween:Play()
    end
end

-- Funzione per chiudere l'inventario
function closeInventory()
    if isInventoryOpen then
        isInventoryOpen = false
        
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        
        closeTween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
end

-- Funzione per aggiornare l'inventario
function refreshInventory()
    if isInventoryOpen then
        populateInventory()
    end
end

-- Controllo input per aprire/chiudere l'inventario
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.I then
        if isInventoryOpen then
            closeInventory()
        else
            openInventory()
        end
    end
end)

-- Inizializzazione
createInventoryGUI()

-- Esporta funzioni pubbliche
local InventoryGUI = {}
InventoryGUI.openInventory = openInventory
InventoryGUI.closeInventory = closeInventory
InventoryGUI.refreshInventory = refreshInventory

return InventoryGUI