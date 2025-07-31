# 🛍️ Sistema Negozio Completo per Roblox Studio

Un sistema di negozio funzionale e completo per Roblox Studio con GUI moderne, gestione valuta, inventario e molto altro!

## ✨ Caratteristiche

### 🎮 Interfaccia Utente
- **GUI del Negozio** moderna con animazioni fluide
- **Inventario del Giocatore** con statistiche dettagliate
- **Controlli intuitivi** con tasti di scelta rapida
- **Notifiche animate** per feedback utente
- **Design responsivo** con temi scuri

### 💰 Sistema Valuta
- **Monete** come valuta di gioco
- **Bonus giornaliero** per engagement
- **Salvataggio automatico** dei dati giocatore
- **Statistiche spesa** e guadagni
- **Sistema DataStore** integrato

### 🎒 Gestione Inventario
- **Visualizzazione oggetti** posseduti
- **Quantità multipla** per oggetti stackabili
- **Bordi di rarità** colorati
- **Calcolo valore** inventario
- **Statistiche dettagliate** del giocatore

### 🏪 Negozio Avanzato
- **16 oggetti predefiniti** di varie categorie:
  - Armi (Spade)
  - Armature
  - Pozioni
  - Gemme magiche
  - Accessori
  - Cavalcature
- **Sistema di rarità** (Comune, Non Comune, Raro, Epico, Leggendario)
- **Validazione acquisti** intelligente
- **Aggiornamento GUI** in tempo reale

## 📁 Struttura File

```
Roblox-Studio-Scripts/
├── README.md                 # Questo file
├── MainShopSystem.lua        # Script principale del sistema
├── ShopGUI.lua              # Interfaccia del negozio
├── InventoryGUI.lua         # Interfaccia inventario
├── ShopData.lua             # Database oggetti negozio
└── CurrencyManager.lua      # Gestione valuta e dati
```

## 🚀 Installazione

### Passo 1: Preparazione Roblox Studio
1. Apri **Roblox Studio**
2. Crea un nuovo posto o apri quello esistente
3. Vai in **ServerStorage** o **ReplicatedStorage**

### Passo 2: Creazione Struttura
1. Crea una **Folder** chiamata `ShopSystem`
2. All'interno della folder, crea 5 **ModuleScript**:
   - `MainShopSystem`
   - `ShopGUI`
   - `InventoryGUI` 
   - `ShopData`
   - `CurrencyManager`

### Passo 3: Copia Codice
1. Copia il contenuto di ogni file `.lua` nel rispettivo **ModuleScript**
2. Assicurati che la gerarchia sia corretta:
   ```
   ShopSystem (Folder)
   ├── MainShopSystem (ModuleScript)
   ├── ShopGUI (ModuleScript)
   ├── InventoryGUI (ModuleScript)
   ├── ShopData (ModuleScript)
   └── CurrencyManager (ModuleScript)
   ```

### Passo 4: Configurazione DataStore
1. Vai nelle **Game Settings** di Roblox Studio
2. Abilita **API Services** per permettere DataStore
3. Pubblica il gioco per attivare DataStore

### Passo 5: Script di Avvio
1. Crea un **LocalScript** in **StarterPlayerScripts**
2. Aggiungi questo codice:
   ```lua
   local ShopSystem = require(game.ReplicatedStorage.ShopSystem.MainShopSystem)
   ```

## 🎮 Controlli di Gioco

### Tasti di Scelta Rapida
- **M** - Apri/Chiudi Negozio
- **I** - Apri/Chiudi Inventario  
- **H** - Mostra/Nascondi Controlli
- **B** - Bonus Giornaliero

### Comandi Chat (Sviluppatori)
- `/givecoins [nome] [quantità]` - Dai monete a un giocatore
- `/resetdata [nome]` - Resetta dati giocatore
- `/shophelp` - Mostra aiuto comandi

## 🛠️ Personalizzazione

### Aggiungere Nuovi Oggetti
Modifica il file `ShopData.lua` aggiungendo oggetti all'array `shopItems`:

```lua
{
    id = "mio_oggetto",
    name = "Nome Oggetto",
    description = "Descrizione dell'oggetto",
    price = 100,
    category = "categoria",
    image = "rbxassetid://123456789", -- ID immagine Roblox
    rarity = "comune",
    -- Proprietà aggiuntive...
}
```

### Modificare Monete Iniziali
Nel file `CurrencyManager.lua`, cambia il valore in `defaultPlayerData`:

```lua
local defaultPlayerData = {
    coins = 2000,  -- Cambia questo valore
    -- ...
}
```

### Aggiungere Nuove Categorie
1. Aggiungi oggetti con nuova `category` in `ShopData.lua`
2. Il sistema rileverà automaticamente la nuova categoria

### Personalizzare Bonus Giornaliero
Nel file `CurrencyManager.lua`, modifica la funzione `claimDailyBonus`:

```lua
local bonusAmount = 200  -- Cambia l'importo del bonus
```

## 🎨 Immagini per Oggetti

Per aggiungere immagini agli oggetti:

1. **Carica immagini** su Roblox (Develop > Decals)
2. **Copia l'Asset ID** dell'immagine
3. **Sostituisci** `rbxassetid://0` con `rbxassetid://TUO_ID`

Esempio:
```lua
image = "rbxassetid://123456789"
```

## 🔧 Risoluzione Problemi

### DataStore non funziona
- Verifica che **API Services** sia abilitato
- Assicurati che il gioco sia **pubblicato**
- Controlla la **connessione internet**

### GUI non appare
- Verifica che lo script sia in **StarterPlayerScripts**
- Controlla la **gerarchia** dei moduli
- Verifica i **nomi** dei ModuleScript

### Errori di script
- Controlla la **console di output** per errori
- Verifica che tutti i **moduli** siano presenti
- Assicurati che i **require** puntino ai percorsi corretti

## 📊 Sistema di Rarità

| Rarità | Colore | Descrizione |
|--------|--------|-------------|
| Comune | Grigio | Oggetti base |
| Non Comune | Verde | Oggetti migliori |
| Raro | Blu | Oggetti preziosi |
| Epico | Viola | Oggetti molto rari |
| Leggendario | Arancione | Oggetti unici |

## 💡 Suggerimenti per Sviluppatori

### Performance
- Il sistema usa **spawn()** per animazioni non bloccanti
- **DataStore** salvati automaticamente ogni 5 minuti
- **Cache locale** per prestazioni migliori

### Estensibilità
- Facile aggiungere **nuove funzionalità**
- **Sistema modulare** ben organizzato
- **API** per sviluppatori avanzati

### Sicurezza
- **Validazione** server-side raccomandata per produzione
- **Anti-exploit** per transazioni importanti
- **Backup** dati giocatore

## 🤝 Supporto

Per problemi o domande:
1. Controlla la **documentazione** sopra
2. Verifica la **console di output** per errori
3. Assicurati di aver seguito tutti i **passi di installazione**

## 🎉 Crediti

Sistema creato per fornire una base solida per negozi in Roblox. 
Sentiti libero di modificare e espandere secondo le tue esigenze!

---

**Buona programmazione! 🚀**