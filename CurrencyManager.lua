-- Modulo CurrencyManager per gestire le monete e l'inventario dei giocatori
-- Questo modulo gestisce tutto ciò che riguarda valuta e oggetti posseduti

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local CurrencyManager = {}

-- DataStore per salvare i dati dei giocatori
local playerDataStore = DataStoreService:GetDataStore("PlayerData")

-- Cache locale per i dati dei giocatori
local playerData = {}

-- Struttura dati default per un nuovo giocatore
local defaultPlayerData = {
    coins = 1000,  -- Monete iniziali
    inventory = {},  -- Inventario vuoto
    lastLogin = 0,
    totalSpent = 0,
    totalEarned = 1000
}

-- Funzione per caricare i dati di un giocatore
local function loadPlayerData(player)
    local userId = tostring(player.UserId)
    local success, data = pcall(function()
        return playerDataStore:GetAsync(userId)
    end)
    
    if success and data then
        playerData[userId] = data
        -- Assicurati che tutti i campi necessari esistano
        for key, value in pairs(defaultPlayerData) do
            if playerData[userId][key] == nil then
                playerData[userId][key] = value
            end
        end
    else
        -- Nuovo giocatore o errore nel caricamento
        playerData[userId] = {}
        for key, value in pairs(defaultPlayerData) do
            playerData[userId][key] = value
        end
        warn("Non è stato possibile caricare i dati per " .. player.Name .. ". Utilizzando dati default.")
    end
    
    -- Aggiorna l'ultimo login
    playerData[userId].lastLogin = os.time()
end

-- Funzione per salvare i dati di un giocatore
local function savePlayerData(player)
    local userId = tostring(player.UserId)
    if playerData[userId] then
        local success, errorMessage = pcall(function()
            playerDataStore:SetAsync(userId, playerData[userId])
        end)
        
        if not success then
            warn("Errore nel salvare i dati per " .. player.Name .. ": " .. errorMessage)
        end
    end
end

-- Funzione per ottenere le monete di un giocatore
function CurrencyManager.getCoins(player)
    local userId = tostring(player.UserId)
    if playerData[userId] then
        return playerData[userId].coins
    end
    return 0
end

-- Funzione per aggiungere monete a un giocatore
function CurrencyManager.addCoins(player, amount)
    local userId = tostring(player.UserId)
    if playerData[userId] and amount > 0 then
        playerData[userId].coins = playerData[userId].coins + amount
        playerData[userId].totalEarned = playerData[userId].totalEarned + amount
        savePlayerData(player)
        return true
    end
    return false
end

-- Funzione per spendere monete
function CurrencyManager.spendCoins(player, amount)
    local userId = tostring(player.UserId)
    if playerData[userId] and amount > 0 and playerData[userId].coins >= amount then
        playerData[userId].coins = playerData[userId].coins - amount
        playerData[userId].totalSpent = playerData[userId].totalSpent + amount
        savePlayerData(player)
        return true
    end
    return false
end

-- Funzione per impostare le monete (per amministratori)
function CurrencyManager.setCoins(player, amount)
    local userId = tostring(player.UserId)
    if playerData[userId] and amount >= 0 then
        playerData[userId].coins = amount
        savePlayerData(player)
        return true
    end
    return false
end

-- Funzione per ottenere l'inventario di un giocatore
function CurrencyManager.getInventory(player)
    local userId = tostring(player.UserId)
    if playerData[userId] then
        return playerData[userId].inventory
    end
    return {}
end

-- Funzione per aggiungere un oggetto all'inventario
function CurrencyManager.addItem(player, itemId, quantity)
    local userId = tostring(player.UserId)
    if not playerData[userId] then
        return false
    end
    
    quantity = quantity or 1
    
    if playerData[userId].inventory[itemId] then
        playerData[userId].inventory[itemId] = playerData[userId].inventory[itemId] + quantity
    else
        playerData[userId].inventory[itemId] = quantity
    end
    
    savePlayerData(player)
    return true
end

-- Funzione per rimuovere un oggetto dall'inventario
function CurrencyManager.removeItem(player, itemId, quantity)
    local userId = tostring(player.UserId)
    if not playerData[userId] or not playerData[userId].inventory[itemId] then
        return false
    end
    
    quantity = quantity or 1
    
    if playerData[userId].inventory[itemId] <= quantity then
        playerData[userId].inventory[itemId] = nil
    else
        playerData[userId].inventory[itemId] = playerData[userId].inventory[itemId] - quantity
    end
    
    savePlayerData(player)
    return true
end

-- Funzione per controllare se un giocatore possiede un oggetto
function CurrencyManager.hasItem(player, itemId)
    local userId = tostring(player.UserId)
    if playerData[userId] and playerData[userId].inventory[itemId] then
        return playerData[userId].inventory[itemId] > 0
    end
    return false
end

-- Funzione per ottenere la quantità di un oggetto
function CurrencyManager.getItemQuantity(player, itemId)
    local userId = tostring(player.UserId)
    if playerData[userId] and playerData[userId].inventory[itemId] then
        return playerData[userId].inventory[itemId]
    end
    return 0
end

-- Funzione per ottenere le statistiche di un giocatore
function CurrencyManager.getPlayerStats(player)
    local userId = tostring(player.UserId)
    if playerData[userId] then
        local stats = {
            coins = playerData[userId].coins,
            totalSpent = playerData[userId].totalSpent,
            totalEarned = playerData[userId].totalEarned,
            itemsOwned = 0,
            lastLogin = playerData[userId].lastLogin
        }
        
        -- Conta il numero totale di oggetti
        for itemId, quantity in pairs(playerData[userId].inventory) do
            stats.itemsOwned = stats.itemsOwned + quantity
        end
        
        return stats
    end
    return nil
end

-- Funzione per dare monete giornaliere (bonus login)
function CurrencyManager.claimDailyBonus(player)
    local userId = tostring(player.UserId)
    if not playerData[userId] then
        return false, "Dati giocatore non trovati"
    end
    
    local currentTime = os.time()
    local lastClaim = playerData[userId].lastDailyBonus or 0
    local oneDay = 24 * 60 * 60  -- 24 ore in secondi
    
    if currentTime - lastClaim >= oneDay then
        local bonusAmount = 100  -- Bonus giornaliero
        playerData[userId].coins = playerData[userId].coins + bonusAmount
        playerData[userId].totalEarned = playerData[userId].totalEarned + bonusAmount
        playerData[userId].lastDailyBonus = currentTime
        savePlayerData(player)
        return true, bonusAmount
    else
        local timeLeft = oneDay - (currentTime - lastClaim)
        local hoursLeft = math.floor(timeLeft / 3600)
        local minutesLeft = math.floor((timeLeft % 3600) / 60)
        return false, string.format("Prossimo bonus tra %d ore e %d minuti", hoursLeft, minutesLeft)
    end
end

-- Funzione per trasferire monete tra giocatori
function CurrencyManager.transferCoins(fromPlayer, toPlayer, amount)
    if CurrencyManager.spendCoins(fromPlayer, amount) then
        if CurrencyManager.addCoins(toPlayer, amount) then
            return true
        else
            -- Ripristina le monete se il trasferimento fallisce
            CurrencyManager.addCoins(fromPlayer, amount)
            return false
        end
    end
    return false
end

-- Funzione per resettare i dati di un giocatore (solo per amministratori)
function CurrencyManager.resetPlayerData(player)
    local userId = tostring(player.UserId)
    playerData[userId] = {}
    for key, value in pairs(defaultPlayerData) do
        playerData[userId][key] = value
    end
    savePlayerData(player)
    return true
end

-- Funzione per ottenere la classifica dei giocatori più ricchi
function CurrencyManager.getLeaderboard(maxPlayers)
    maxPlayers = maxPlayers or 10
    local leaderboard = {}
    
    for userId, data in pairs(playerData) do
        local player = Players:GetPlayerByUserId(tonumber(userId))
        if player then
            table.insert(leaderboard, {
                player = player,
                coins = data.coins,
                totalSpent = data.totalSpent
            })
        end
    end
    
    -- Ordina per monete (dal più ricco al meno ricco)
    table.sort(leaderboard, function(a, b)
        return a.coins > b.coins
    end)
    
    -- Taglia la lista al numero massimo richiesto
    local result = {}
    for i = 1, math.min(maxPlayers, #leaderboard) do
        result[i] = leaderboard[i]
    end
    
    return result
end

-- Funzione per esportare i dati di un giocatore (backup)
function CurrencyManager.exportPlayerData(player)
    local userId = tostring(player.UserId)
    if playerData[userId] then
        return playerData[userId]
    end
    return nil
end

-- Funzione per importare i dati di un giocatore (ripristino)
function CurrencyManager.importPlayerData(player, data)
    local userId = tostring(player.UserId)
    if data and type(data) == "table" then
        playerData[userId] = data
        savePlayerData(player)
        return true
    end
    return false
end

-- Sistema di achievement per spesa
function CurrencyManager.checkSpendingAchievements(player)
    local userId = tostring(player.UserId)
    if not playerData[userId] then return {} end
    
    local totalSpent = playerData[userId].totalSpent
    local achievements = {}
    
    local spendingMilestones = {
        {amount = 500, title = "Primo Acquirente", reward = 50},
        {amount = 1000, title = "Compratore Abituale", reward = 100},
        {amount = 2500, title = "Spendaccione", reward = 200},
        {amount = 5000, title = "Collezionista", reward = 500},
        {amount = 10000, title = "Magnate", reward = 1000}
    }
    
    for _, milestone in ipairs(spendingMilestones) do
        if totalSpent >= milestone.amount then
            table.insert(achievements, milestone)
        end
    end
    
    return achievements
end

-- Eventi per gestire i giocatori
Players.PlayerAdded:Connect(function(player)
    loadPlayerData(player)
end)

Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
    local userId = tostring(player.UserId)
    playerData[userId] = nil  -- Libera memoria
end)

-- Salvataggio automatico ogni 5 minuti
spawn(function()
    while true do
        wait(300)  -- 5 minuti
        for _, player in ipairs(Players:GetPlayers()) do
            savePlayerData(player)
        end
        print("Dati salvati automaticamente per tutti i giocatori")
    end
end)

-- Carica i dati per i giocatori già presenti (per hot reload)
for _, player in ipairs(Players:GetPlayers()) do
    if not playerData[tostring(player.UserId)] then
        loadPlayerData(player)
    end
end

return CurrencyManager