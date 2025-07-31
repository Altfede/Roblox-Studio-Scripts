-- Modulo ShopData per gestire gli oggetti del negozio
-- Questo modulo contiene tutti gli oggetti disponibili nel negozio

local ShopData = {}

-- Database degli oggetti del negozio
local shopItems = {
    {
        id = "sword_basic",
        name = "Spada di Ferro",
        description = "Una spada robusta per i guerrieri principianti",
        price = 100,
        category = "armi",
        image = "rbxassetid://0", -- Sostituisci con l'ID di un'immagine reale
        rarity = "comune",
        stats = {
            damage = 25,
            durability = 100
        }
    },
    {
        id = "sword_steel",
        name = "Spada d'Acciaio",
        description = "Una spada più potente forgiata con acciaio di qualità",
        price = 250,
        category = "armi",
        image = "rbxassetid://0",
        rarity = "non_comune",
        stats = {
            damage = 45,
            durability = 150
        }
    },
    {
        id = "sword_diamond",
        name = "Spada di Diamante",
        description = "Una spada leggendaria incastonata di diamanti scintillanti",
        price = 500,
        category = "armi",
        image = "rbxassetid://0",
        rarity = "raro",
        stats = {
            damage = 75,
            durability = 250
        }
    },
    {
        id = "armor_leather",
        name = "Armatura di Cuoio",
        description = "Protezione di base per avventurieri novizi",
        price = 80,
        category = "armature",
        image = "rbxassetid://0",
        rarity = "comune",
        stats = {
            defense = 15,
            durability = 80
        }
    },
    {
        id = "armor_chain",
        name = "Cotta di Maglia",
        description = "Armatura resistente che offre buona protezione",
        price = 200,
        category = "armature",
        image = "rbxassetid://0",
        rarity = "non_comune",
        stats = {
            defense = 30,
            durability = 120
        }
    },
    {
        id = "armor_plate",
        name = "Armatura a Piastre",
        description = "Protezione pesante per i più valorosi guerrieri",
        price = 400,
        category = "armature",
        image = "rbxassetid://0",
        rarity = "raro",
        stats = {
            defense = 50,
            durability = 200
        }
    },
    {
        id = "potion_health",
        name = "Pozione di Cura",
        description = "Ripristina la salute istantaneamente",
        price = 25,
        category = "consumabili",
        image = "rbxassetid://0",
        rarity = "comune",
        consumable = true,
        effect = {
            type = "heal",
            amount = 50
        }
    },
    {
        id = "potion_mana",
        name = "Pozione di Mana",
        description = "Ripristina l'energia magica",
        price = 30,
        category = "consumabili",
        image = "rbxassetid://0",
        rarity = "comune",
        consumable = true,
        effect = {
            type = "mana",
            amount = 75
        }
    },
    {
        id = "potion_speed",
        name = "Pozione di Velocità",
        description = "Aumenta temporaneamente la velocità di movimento",
        price = 50,
        category = "consumabili",
        image = "rbxassetid://0",
        rarity = "non_comune",
        consumable = true,
        effect = {
            type = "speed_boost",
            duration = 60,
            multiplier = 1.5
        }
    },
    {
        id = "gem_ruby",
        name = "Rubino Brillante",
        description = "Una gemma preziosa che irradia energia magica",
        price = 150,
        category = "gemme",
        image = "rbxassetid://0",
        rarity = "raro",
        magical = true
    },
    {
        id = "gem_emerald",
        name = "Smeraldo Mistico",
        description = "Una gemma verde che pulsa di antica magia",
        price = 175,
        category = "gemme",
        image = "rbxassetid://0",
        rarity = "raro",
        magical = true
    },
    {
        id = "gem_sapphire",
        name = "Zaffiro del Cielo",
        description = "Una gemma blu profondo che cattura la luce delle stelle",
        price = 200,
        category = "gemme",
        image = "rbxassetid://0",
        rarity = "epico",
        magical = true
    },
    {
        id = "cape_shadow",
        name = "Mantello delle Ombre",
        description = "Un mantello che si fonde con l'oscurità",
        price = 300,
        category = "accessori",
        image = "rbxassetid://0",
        rarity = "epico",
        special_ability = "stealth"
    },
    {
        id = "ring_power",
        name = "Anello del Potere",
        description = "Un anello che amplifica le abilità del portatore",
        price = 450,
        category = "accessori",
        image = "rbxassetid://0",
        rarity = "leggendario",
        special_ability = "power_boost"
    },
    {
        id = "mount_horse",
        name = "Cavallo Veloce",
        description = "Un fedele destriero per viaggiare rapidamente",
        price = 600,
        category = "cavalcature",
        image = "rbxassetid://0",
        rarity = "epico",
        mount_speed = 2.0
    },
    {
        id = "mount_dragon",
        name = "Drago Giovane",
        description = "Un drago addestrato che può volare nei cieli",
        price = 1200,
        category = "cavalcature",
        image = "rbxassetid://0",
        rarity = "leggendario",
        mount_speed = 3.0,
        can_fly = true
    }
}

-- Funzione per ottenere tutti gli oggetti
function ShopData.getItems()
    return shopItems
end

-- Funzione per ottenere un oggetto specifico per ID
function ShopData.getItemById(id)
    for _, item in ipairs(shopItems) do
        if item.id == id then
            return item
        end
    end
    return nil
end

-- Funzione per ottenere oggetti per categoria
function ShopData.getItemsByCategory(category)
    local categoryItems = {}
    for _, item in ipairs(shopItems) do
        if item.category == category then
            table.insert(categoryItems, item)
        end
    end
    return categoryItems
end

-- Funzione per ottenere oggetti per rarità
function ShopData.getItemsByRarity(rarity)
    local rarityItems = {}
    for _, item in ipairs(shopItems) do
        if item.rarity == rarity then
            table.insert(rarityItems, item)
        end
    end
    return rarityItems
end

-- Funzione per ottenere tutte le categorie disponibili
function ShopData.getCategories()
    local categories = {}
    local seen = {}
    
    for _, item in ipairs(shopItems) do
        if not seen[item.category] then
            table.insert(categories, item.category)
            seen[item.category] = true
        end
    end
    
    return categories
end

-- Funzione per ottenere le rarità disponibili
function ShopData.getRarities()
    return {"comune", "non_comune", "raro", "epico", "leggendario"}
end

-- Funzione per ottenere il colore associato a una rarità
function ShopData.getRarityColor(rarity)
    local colors = {
        comune = Color3.fromRGB(150, 150, 150),      -- Grigio
        non_comune = Color3.fromRGB(0, 200, 0),      -- Verde
        raro = Color3.fromRGB(0, 100, 255),          -- Blu
        epico = Color3.fromRGB(128, 0, 128),         -- Viola
        leggendario = Color3.fromRGB(255, 165, 0)    -- Arancione
    }
    
    return colors[rarity] or Color3.fromRGB(255, 255, 255)
end

-- Funzione per filtrare oggetti per prezzo
function ShopData.getItemsByPriceRange(minPrice, maxPrice)
    local filteredItems = {}
    for _, item in ipairs(shopItems) do
        if item.price >= minPrice and item.price <= maxPrice then
            table.insert(filteredItems, item)
        end
    end
    return filteredItems
end

-- Funzione per ordinare oggetti per prezzo
function ShopData.sortItemsByPrice(ascending)
    local sortedItems = {}
    for i, item in ipairs(shopItems) do
        sortedItems[i] = item
    end
    
    table.sort(sortedItems, function(a, b)
        if ascending then
            return a.price < b.price
        else
            return a.price > b.price
        end
    end)
    
    return sortedItems
end

-- Funzione per cercare oggetti per nome
function ShopData.searchItems(searchTerm)
    local results = {}
    local lowerSearchTerm = string.lower(searchTerm)
    
    for _, item in ipairs(shopItems) do
        local lowerName = string.lower(item.name)
        local lowerDescription = string.lower(item.description)
        
        if string.find(lowerName, lowerSearchTerm) or string.find(lowerDescription, lowerSearchTerm) then
            table.insert(results, item)
        end
    end
    
    return results
end

-- Funzione per aggiungere un nuovo oggetto (per uso futuro)
function ShopData.addItem(itemData)
    -- Verifica che l'ID non esista già
    if ShopData.getItemById(itemData.id) then
        warn("Un oggetto con ID '" .. itemData.id .. "' esiste già!")
        return false
    end
    
    table.insert(shopItems, itemData)
    return true
end

-- Funzione per rimuovere un oggetto (per uso futuro)
function ShopData.removeItem(id)
    for i, item in ipairs(shopItems) do
        if item.id == id then
            table.remove(shopItems, i)
            return true
        end
    end
    return false
end

-- Funzione per ottenere statistiche del negozio
function ShopData.getShopStats()
    local stats = {
        totalItems = #shopItems,
        categories = {},
        rarities = {},
        priceRange = {min = math.huge, max = 0},
        averagePrice = 0
    }
    
    local totalPrice = 0
    
    for _, item in ipairs(shopItems) do
        -- Conteggio categorie
        stats.categories[item.category] = (stats.categories[item.category] or 0) + 1
        
        -- Conteggio rarità
        stats.rarities[item.rarity] = (stats.rarities[item.rarity] or 0) + 1
        
        -- Range prezzi
        if item.price < stats.priceRange.min then
            stats.priceRange.min = item.price
        end
        if item.price > stats.priceRange.max then
            stats.priceRange.max = item.price
        end
        
        totalPrice = totalPrice + item.price
    end
    
    stats.averagePrice = totalPrice / #shopItems
    
    return stats
end

return ShopData