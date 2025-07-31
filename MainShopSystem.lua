-- Main Shop System for Roblox Studio
-- Questo script principale inizializza e coordina tutto il sistema del negozio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Moduli del sistema
local ShopGUI = require(script:WaitForChild("ShopGUI"))
local InventoryGUI = require(script:WaitForChild("InventoryGUI"))
local CurrencyManager = require(script:WaitForChild("CurrencyManager"))

-- Variabili globali
local controlsGui
local dailyBonusGui
local isControlsVisible = false

-- Funzione per creare la GUI dei controlli
local function createControlsGUI()
    controlsGui = Instance.new("ScreenGui")
    controlsGui.Name = "ShopControlsGUI"
    controlsGui.ResetOnSpawn = false
    controlsGui.Parent = playerGui
    
    -- Frame dei controlli
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "ControlsFrame"
    controlsFrame.Size = UDim2.new(0, 250, 0, 300)
    controlsFrame.Position = UDim2.new(0, 20, 0.5, -150)
    controlsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    controlsFrame.BorderSizePixel = 0
    controlsFrame.Parent = controlsGui
    
    local controlsCorner = Instance.new("UICorner")
    controlsCorner.CornerRadius = UDim.new(0, 15)
    controlsCorner.Parent = controlsFrame
    
    -- Titolo dei controlli
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🎮 CONTROLLI NEGOZIO"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = controlsFrame
    
    -- Bottone per aprire il negozio
    local shopButton = Instance.new("TextButton")
    shopButton.Name = "ShopButton"
    shopButton.Size = UDim2.new(1, -20, 0, 50)
    shopButton.Position = UDim2.new(0, 10, 0, 60)
    shopButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    shopButton.BorderSizePixel = 0
    shopButton.Text = "🛍️ Apri Negozio (M)"
    shopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    shopButton.TextScaled = true
    shopButton.Font = Enum.Font.GothamBold
    shopButton.Parent = controlsFrame
    
    local shopCorner = Instance.new("UICorner")
    shopCorner.CornerRadius = UDim.new(0, 10)
    shopCorner.Parent = shopButton
    
    -- Bottone per aprire l'inventario
    local inventoryButton = Instance.new("TextButton")
    inventoryButton.Name = "InventoryButton"
    inventoryButton.Size = UDim2.new(1, -20, 0, 50)
    inventoryButton.Position = UDim2.new(0, 10, 0, 120)
    inventoryButton.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
    inventoryButton.BorderSizePixel = 0
    inventoryButton.Text = "🎒 Apri Inventario (I)"
    inventoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    inventoryButton.TextScaled = true
    inventoryButton.Font = Enum.Font.GothamBold
    inventoryButton.Parent = controlsFrame
    
    local inventoryCorner = Instance.new("UICorner")
    inventoryCorner.CornerRadius = UDim.new(0, 10)
    inventoryCorner.Parent = inventoryButton
    
    -- Bottone per il bonus giornaliero
    local dailyButton = Instance.new("TextButton")
    dailyButton.Name = "DailyButton"
    dailyButton.Size = UDim2.new(1, -20, 0, 50)
    dailyButton.Position = UDim2.new(0, 10, 0, 180)
    dailyButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    dailyButton.BorderSizePixel = 0
    dailyButton.Text = "💰 Bonus Giornaliero"
    dailyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    dailyButton.TextScaled = true
    dailyButton.Font = Enum.Font.GothamBold
    dailyButton.Parent = controlsFrame
    
    local dailyCorner = Instance.new("UICorner")
    dailyCorner.CornerRadius = UDim.new(0, 10)
    dailyCorner.Parent = dailyButton
    
    -- Bottone per nascondere i controlli
    local hideButton = Instance.new("TextButton")
    hideButton.Name = "HideButton"
    hideButton.Size = UDim2.new(1, -20, 0, 40)
    hideButton.Position = UDim2.new(0, 10, 1, -50)
    hideButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    hideButton.BorderSizePixel = 0
    hideButton.Text = "Nascondi (H)"
    hideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideButton.TextScaled = true
    hideButton.Font = Enum.Font.Gotham
    hideButton.Parent = controlsFrame
    
    local hideCorner = Instance.new("UICorner")
    hideCorner.CornerRadius = UDim.new(0, 10)
    hideCorner.Parent = hideButton
    
    -- Eventi dei bottoni
    shopButton.MouseButton1Click:Connect(function()
        ShopGUI.openShop()
    end)
    
    inventoryButton.MouseButton1Click:Connect(function()
        InventoryGUI.openInventory()
    end)
    
    dailyButton.MouseButton1Click:Connect(function()
        claimDailyBonus()
    end)
    
    hideButton.MouseButton1Click:Connect(function()
        toggleControls()
    end)
    
    -- Effetti hover per i bottoni
    local buttons = {shopButton, inventoryButton, dailyButton, hideButton}
    for _, button in ipairs(buttons) do
        button.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(button, TweenInfo.new(0.2), {
                Size = UDim2.new(1, -15, 0, button.Size.Y.Offset + 5)
            })
            hoverTween:Play()
        end)
        
        button.MouseLeave:Connect(function()
            local leaveTween = TweenService:Create(button, TweenInfo.new(0.2), {
                Size = UDim2.new(1, -20, 0, button.Size.Y.Offset - 5)
            })
            leaveTween:Play()
        end)
    end
end

-- Funzione per attivare/disattivare i controlli
function toggleControls()
    if isControlsVisible then
        -- Nascondi controlli
        local hideTween = TweenService:Create(controlsGui.ControlsFrame, TweenInfo.new(0.3), {
            Position = UDim2.new(0, -270, 0.5, -150)
        })
        hideTween:Play()
        isControlsVisible = false
    else
        -- Mostra controlli
        local showTween = TweenService:Create(controlsGui.ControlsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 20, 0.5, -150)
        })
        showTween:Play()
        isControlsVisible = true
    end
end

-- Funzione per rivendicare il bonus giornaliero
function claimDailyBonus()
    local success, result = CurrencyManager.claimDailyBonus(player)
    
    if success then
        -- Bonus rivendicato con successo
        showNotification("✅ Bonus Giornaliero!", "Hai ricevuto " .. result .. " monete!", Color3.fromRGB(0, 200, 0))
        
        -- Aggiorna le GUI se sono aperte
        ShopGUI.refreshShop()
        InventoryGUI.refreshInventory()
    else
        -- Non è possibile rivendicare il bonus
        showNotification("⏰ Bonus Non Disponibile", result, Color3.fromRGB(255, 150, 0))
    end
end

-- Funzione per mostrare notifiche
function showNotification(title, message, color)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationGUI"
    notificationGui.Parent = playerGui
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 350, 0, 120)
    notificationFrame.Position = UDim2.new(0.5, -175, 0, -130)
    notificationFrame.BackgroundColor3 = color
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Parent = notificationGui
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 15)
    notificationCorner.Parent = notificationFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = notificationFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 60)
    messageLabel.Position = UDim2.new(0, 10, 0, 50)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextWrapped = true
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.Parent = notificationFrame
    
    -- Animazione di entrata
    local enterTween = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -175, 0, 30)
    })
    enterTween:Play()
    
    -- Animazione di uscita dopo 3 secondi
    spawn(function()
        wait(3)
        local exitTween = TweenService:Create(notificationFrame, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -175, 0, -130),
            BackgroundTransparency = 1
        })
        exitTween:Play()
        
        exitTween.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end)
end

-- Funzione per mostrare il benvenuto al giocatore
local function showWelcomeMessage()
    spawn(function()
        wait(2)  -- Aspetta che tutto sia caricato
        
        local coins = CurrencyManager.getCoins(player)
        local welcomeMessage = string.format("Benvenuto nel negozio, %s!\nHai %d monete.\n\nPremi M per aprire il negozio\nPremi I per aprire l'inventario\nPremi H per mostrare/nascondere i controlli", player.Name, coins)
        
        showNotification("🎉 Benvenuto!", welcomeMessage, Color3.fromRGB(100, 100, 255))
    end)
end

-- Funzione per gestire i tasti di scelta rapida
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.H then
        toggleControls()
    elseif input.KeyCode == Enum.KeyCode.B then
        claimDailyBonus()
    end
end)

-- Funzione per dare monete ai giocatori (comando per sviluppatori)
local function giveCoins(targetPlayer, amount)
    if CurrencyManager.addCoins(targetPlayer, amount) then
        showNotification("💰 Monete Aggiunte", string.format("Aggiunte %d monete a %s", amount, targetPlayer.Name), Color3.fromRGB(0, 200, 0))
        return true
    end
    return false
end

-- Funzione per resettare i dati di un giocatore (comando per sviluppatori)
local function resetPlayerData(targetPlayer)
    if CurrencyManager.resetPlayerData(targetPlayer) then
        showNotification("🔄 Dati Resettati", string.format("Dati di %s resettati", targetPlayer.Name), Color3.fromRGB(255, 150, 0))
        return true
    end
    return false
end

-- Inizializzazione del sistema
local function initializeShopSystem()
    -- Crea la GUI dei controlli
    createControlsGUI()
    
    -- Nascondi inizialmente i controlli
    controlsGui.ControlsFrame.Position = UDim2.new(0, -270, 0.5, -150)
    
    -- Mostra il messaggio di benvenuto
    showWelcomeMessage()
    
    -- Mostra i controlli dopo 1 secondo
    spawn(function()
        wait(1)
        toggleControls()
    end)
    
    print("✅ Sistema Negozio inizializzato correttamente!")
    print("📖 Comandi disponibili:")
    print("   M - Apri/Chiudi Negozio")
    print("   I - Apri/Chiudi Inventario")
    print("   H - Mostra/Nascondi Controlli")
    print("   B - Bonus Giornaliero")
end

-- Comando chat per gli sviluppatori
player.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]:lower()
    
    if command == "/givecoins" and #args >= 3 then
        local targetName = args[2]
        local amount = tonumber(args[3])
        
        if amount and amount > 0 then
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer then
                giveCoins(targetPlayer, amount)
            else
                showNotification("❌ Errore", "Giocatore non trovato: " .. targetName, Color3.fromRGB(255, 50, 50))
            end
        end
    elseif command == "/resetdata" and #args >= 2 then
        local targetName = args[2]
        local targetPlayer = Players:FindFirstChild(targetName)
        
        if targetPlayer then
            resetPlayerData(targetPlayer)
        else
            showNotification("❌ Errore", "Giocatore non trovato: " .. targetName, Color3.fromRGB(255, 50, 50))
        end
    elseif command == "/shophelp" then
        local helpMessage = "Comandi disponibili:\n/givecoins [nome] [quantità]\n/resetdata [nome]\n/shophelp - Mostra questo aiuto"
        showNotification("📚 Aiuto Comandi", helpMessage, Color3.fromRGB(100, 150, 255))
    end
end)

-- Avvia il sistema quando lo script viene eseguito
initializeShopSystem()

-- Esporta funzioni per uso esterno
local MainShopSystem = {}
MainShopSystem.giveCoins = giveCoins
MainShopSystem.resetPlayerData = resetPlayerData
MainShopSystem.showNotification = showNotification
MainShopSystem.toggleControls = toggleControls
MainShopSystem.claimDailyBonus = claimDailyBonus

return MainShopSystem