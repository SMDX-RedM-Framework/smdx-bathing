local SMDXCore = exports['smdx-core']:GetSMDX()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^1['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/SMDX-RedM-Framework/smdx-bathing/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------

BathingSessions = {}

RegisterServerEvent("smdx-bathing:server:canEnterBath")
AddEventHandler("smdx-bathing:server:canEnterBath", function(town)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local currentMoney = Player.PlayerData.money["cash"]

    if not BathingSessions[town] then
        if currentMoney >= Config.NormalBathPrice then
            Player.Functions.RemoveMoney("cash", Config.NormalBathPrice)
            BathingSessions[town] = src
            TriggerClientEvent("smdx-bathing:client:StartBath", src, town)
        else
            print("NOTIFICATION HERE")
        end
    else
        print("NOTIFICATION HERE")
    end
end)


RegisterServerEvent("smdx-bathing:server:canEnterDeluxeBath")
AddEventHandler("smdx-bathing:server:canEnterDeluxeBath", function(p1 , p2 , p3)
    local src = source
    if BathingSessions[p2] == src then

        local Player = SMDXCore.Functions.GetPlayer(src)
        local currentMoney = Player.PlayerData.money["cash"]
            
        if currentMoney >= Config.DeluxeBathPrice then
            Player.Functions.RemoveMoney("cash", Config.DeluxeBathPrice)
            TriggerClientEvent("smdx-bathing:client:StartDeluxeBath", src , p1 , p2 , p3)
        else
            print("NOTIFICATION HERE")
            TriggerClientEvent("smdx-bathing:client:HideDeluxePrompt", src)
        end
    end
end)

RegisterServerEvent("smdx-bathing:server:setBathAsFree")
AddEventHandler("smdx-bathing:server:setBathAsFree", function(town)
    if BathingSessions[town] == source then
        BathingSessions[town] = nil
    end
end)

AddEventHandler('playerDropped', function()
    for town,player in pairs(BathingSessions) do
        if player == source then
            BathingSessions[town] = nil
        end
    end
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
