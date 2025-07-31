-- Shop GUI System for Roblox Studio
-- Questo script gestisce l'interfaccia del negozio

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Moduli
local ShopData = require(script.Parent:WaitForChild("ShopData"))
local CurrencyManager = require(script.Parent:WaitForChild("CurrencyManager"))

-- Variabili globali
local shopGui
local mainFrame
local itemsScrollFrame
local coinsLabel
local isShopOpen = false

-- Funzione per creare la GUI principale
local function createShopGUI()
    -- ScreenGui principale
    shopGui = Instance.new("ScreenGui")
    shopGui.Name = "ShopGUI"
    shopGui.ResetOnSpawn = false
    shopGui.Parent = playerGui
    
    -- Frame principale del negozio
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = shopGui
    
    -- Angoli arrotondati
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Ombra del frame
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 15)
    shadowCorner.Parent = shadow
    
    -- Header del negozio
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = header
    
    -- Titolo del negozio
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🛍️ NEGOZIO"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = header
    
    -- Display delle monete
    local coinsFrame = Instance.new("Frame")
    coinsFrame.Name = "CoinsFrame"
    coinsFrame.Size = UDim2.new(0.2, 0, 0.7, 0)
    coinsFrame.Position = UDim2.new(0.75, 0, 0.15, 0)
    coinsFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    coinsFrame.BorderSizePixel = 0
    coinsFrame.Parent = header
    
    local coinsCorner = Instance.new("UICorner")
    coinsCorner.CornerRadius = UDim.new(0, 10)
    coinsCorner.Parent = coinsFrame
    
    coinsLabel = Instance.new("TextLabel")
    coinsLabel.Name = "CoinsLabel"
    coinsLabel.Size = UDim2.new(1, 0, 1, 0)
    coinsLabel.BackgroundTransparency = 1
    coinsLabel.Text = "💰 " .. CurrencyManager.getCoins(player)
    coinsLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    coinsLabel.TextScaled = true
    coinsLabel.Font = Enum.Font.GothamBold
    coinsLabel.Parent = coinsFrame
    
    -- Bottone di chiusura
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 50, 0, 50)
    closeButton.Position = UDim2.new(1, -60, 0, 15)
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
    
    -- Area di scroll per gli oggetti
    itemsScrollFrame = Instance.new("ScrollingFrame")
    itemsScrollFrame.Name = "ItemsScrollFrame"
    itemsScrollFrame.Size = UDim2.new(1, -20, 1, -100)
    itemsScrollFrame.Position = UDim2.new(0, 10, 0, 90)
    itemsScrollFrame.BackgroundTransparency = 1
    itemsScrollFrame.BorderSizePixel = 0
    itemsScrollFrame.ScrollBarThickness = 8
    itemsScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    itemsScrollFrame.Parent = mainFrame
    
    -- Layout per gli oggetti
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 200, 0, 250)
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
        closeShop()
    end)
    
    -- Aggiorna il canvas size quando il layout cambia
    gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        itemsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- Funzione per creare un oggetto del negozio
local function createShopItem(itemData, index)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "Item_" .. index
    itemFrame.Size = UDim2.new(0, 200, 0, 250)
    itemFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    itemFrame.BorderSizePixel = 0
    itemFrame.LayoutOrder = index
    itemFrame.Parent = itemsScrollFrame
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 12)
    itemCorner.Parent = itemFrame
    
    -- Immagine dell'oggetto
    local itemImage = Instance.new("ImageLabel")
    itemImage.Name = "ItemImage"
    itemImage.Size = UDim2.new(1, -20, 0, 120)
    itemImage.Position = UDim2.new(0, 10, 0, 10)
    itemImage.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    itemImage.BorderSizePixel = 0
    itemImage.Image = itemData.image or ""
    itemImage.ScaleType = Enum.ScaleType.Fit
    itemImage.Parent = itemFrame
    
    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 8)
    imageCorner.Parent = itemImage
    
    -- Nome dell'oggetto
    local itemName = Instance.new("TextLabel")
    itemName.Name = "ItemName"
    itemName.Size = UDim2.new(1, -20, 0, 30)
    itemName.Position = UDim2.new(0, 10, 0, 140)
    itemName.BackgroundTransparency = 1
    itemName.Text = itemData.name
    itemName.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemName.TextScaled = true
    itemName.Font = Enum.Font.Gotham
    itemName.Parent = itemFrame
    
    -- Descrizione dell'oggetto
    local itemDescription = Instance.new("TextLabel")
    itemDescription.Name = "ItemDescription"
    itemDescription.Size = UDim2.new(1, -20, 0, 40)
    itemDescription.Position = UDim2.new(0, 10, 0, 175)
    itemDescription.BackgroundTransparency = 1
    itemDescription.Text = itemData.description
    itemDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
    itemDescription.TextWrapped = true
    itemDescription.TextScaled = true
    itemDescription.Font = Enum.Font.Gotham
    itemDescription.Parent = itemFrame
    
    -- Bottone di acquisto
    local buyButton = Instance.new("TextButton")
    buyButton.Name = "BuyButton"
    buyButton.Size = UDim2.new(1, -20, 0, 35)
    buyButton.Position = UDim2.new(0, 10, 1, -45)
    buyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    buyButton.BorderSizePixel = 0
    buyButton.Text = "💰 Compra - " .. itemData.price .. " monete"
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.TextScaled = true
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Parent = itemFrame
    
    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 8)
    buyCorner.Parent = buyButton
    
    -- Controllo se il giocatore possiede già l'oggetto
    if CurrencyManager.hasItem(player, itemData.id) then
        buyButton.Text = "✅ Posseduto"
        buyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        buyButton.Active = false
    else
        -- Eventi di hover
        buyButton.MouseEnter:Connect(function()
            if CurrencyManager.getCoins(player) >= itemData.price then
                local hoverTween = TweenService:Create(buyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)})
                hoverTween:Play()
            else
                buyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                buyButton.Text = "❌ Monete insufficienti"
            end
        end)
        
        buyButton.MouseLeave:Connect(function()
            local leaveTween = TweenService:Create(buyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 0)})
            leaveTween:Play()
            buyButton.Text = "💰 Compra - " .. itemData.price .. " monete"
        end)
        
        -- Evento di acquisto
        buyButton.MouseButton1Click:Connect(function()
            purchaseItem(itemData)
        end)
    end
    
    -- Effetto di apparizione
    itemFrame.BackgroundTransparency = 1
    itemFrame.Size = UDim2.new(0, 0, 0, 0)
    
    wait(index * 0.05)  -- Ritardo incrementale per l'animazione
    
    local appearTween = TweenService:Create(itemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 200, 0, 250)
    })
    appearTween:Play()
end

-- Funzione per acquistare un oggetto
function purchaseItem(itemData)
    if CurrencyManager.spendCoins(player, itemData.price) then
        CurrencyManager.addItem(player, itemData.id)
        
        -- Aggiorna la visualizzazione delle monete
        coinsLabel.Text = "💰 " .. CurrencyManager.getCoins(player)
        
        -- Effetto di successo
        local successGui = Instance.new("ScreenGui")
        successGui.Name = "SuccessNotification"
        successGui.Parent = playerGui
        
        local successFrame = Instance.new("Frame")
        successFrame.Size = UDim2.new(0, 300, 0, 100)
        successFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
        successFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        successFrame.BorderSizePixel = 0
        successFrame.Parent = successGui
        
        local successCorner = Instance.new("UICorner")
        successCorner.CornerRadius = UDim.new(0, 15)
        successCorner.Parent = successFrame
        
        local successText = Instance.new("TextLabel")
        successText.Size = UDim2.new(1, 0, 1, 0)
        successText.BackgroundTransparency = 1
        successText.Text = "✅ " .. itemData.name .. " acquistato!"
        successText.TextColor3 = Color3.fromRGB(255, 255, 255)
        successText.TextScaled = true
        successText.Font = Enum.Font.GothamBold
        successText.Parent = successFrame
        
        -- Animazione di successo
        successFrame.Position = UDim2.new(0.5, -150, 1, 50)
        local successTween = TweenService:Create(successFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -150, 0.5, -50)
        })
        successTween:Play()
        
        wait(2)
        
        local hideTween = TweenService:Create(successFrame, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -150, -1, -50)
        })
        hideTween:Play()
        
        hideTween.Completed:Connect(function()
            successGui:Destroy()
        end)
        
        -- Ricarica la GUI del negozio per aggiornare lo stato
        refreshShop()
    else
        -- Effetto di errore
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "ErrorNotification"
        errorGui.Parent = playerGui
        
        local errorFrame = Instance.new("Frame")
        errorFrame.Size = UDim2.new(0, 300, 0, 100)
        errorFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
        errorFrame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        errorFrame.BorderSizePixel = 0
        errorFrame.Parent = errorGui
        
        local errorCorner = Instance.new("UICorner")
        errorCorner.CornerRadius = UDim.new(0, 15)
        errorCorner.Parent = errorFrame
        
        local errorText = Instance.new("TextLabel")
        errorText.Size = UDim2.new(1, 0, 1, 0)
        errorText.BackgroundTransparency = 1
        errorText.Text = "❌ Monete insufficienti!"
        errorText.TextColor3 = Color3.fromRGB(255, 255, 255)
        errorText.TextScaled = true
        errorText.Font = Enum.Font.GothamBold
        errorText.Parent = errorFrame
        
        -- Animazione di errore
        errorFrame.Position = UDim2.new(0.5, -150, 1, 50)
        local errorTween = TweenService:Create(errorFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -150, 0.5, -50)
        })
        errorTween:Play()
        
        wait(2)
        
        local hideErrorTween = TweenService:Create(errorFrame, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -150, -1, -50)
        })
        hideErrorTween:Play()
        
        hideErrorTween.Completed:Connect(function()
            errorGui:Destroy()
        end)
    end
end

-- Funzione per popolare il negozio con gli oggetti
local function populateShop()
    -- Pulisci oggetti esistenti
    for _, child in ipairs(itemsScrollFrame:GetChildren()) do
        if child:IsA("Frame") and string.find(child.Name, "Item_") then
            child:Destroy()
        end
    end
    
    -- Aggiungi gli oggetti dal modulo ShopData
    for index, itemData in ipairs(ShopData.getItems()) do
        spawn(function()
            createShopItem(itemData, index)
        end)
    end
end

-- Funzione per aprire il negozio
function openShop()
    if not isShopOpen then
        isShopOpen = true
        mainFrame.Visible = true
        
        -- Aggiorna le monete
        coinsLabel.Text = "💰 " .. CurrencyManager.getCoins(player)
        
        -- Popola il negozio
        populateShop()
        
        -- Animazione di apertura
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.8, 0, 0.8, 0),
            Position = UDim2.new(0.1, 0, 0.1, 0)
        })
        openTween:Play()
    end
end

-- Funzione per chiudere il negozio
function closeShop()
    if isShopOpen then
        isShopOpen = false
        
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

-- Funzione per aggiornare il negozio
function refreshShop()
    if isShopOpen then
        populateShop()
        coinsLabel.Text = "💰 " .. CurrencyManager.getCoins(player)
    end
end

-- Controllo input per aprire/chiudere il negozio
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        if isShopOpen then
            closeShop()
        else
            openShop()
        end
    end
end)

-- Inizializzazione
createShopGUI()

-- Esporta funzioni pubbliche
local ShopGUI = {}
ShopGUI.openShop = openShop
ShopGUI.closeShop = closeShop
ShopGUI.refreshShop = refreshShop

return ShopGUI