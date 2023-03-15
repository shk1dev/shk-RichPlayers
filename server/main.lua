QBCore = exports['qb-core']:GetCoreObject()

function sendToDiscord(message) 
    local time = os.date("*t")

    local embed = {
            {
                ["color"] = Config.LogColour, 
                ["author"] = {
                    ["icon_url"] = Config.AvatarURL, 
                    ["name"] = Config.ServerName, 
                },
                ["title"] = "**".. Config.LogTitle .."**", 
                ["description"] = message, 
                ["footer"] = {
                    ["text"] = '' ..time.year.. '/' ..time.month..'/'..time.day..' '.. time.hour.. ':'..time.min, 
                },
            }
        }

    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    while (Config.SendLogByTime.enable) do
        Citizen.Wait(Config.SendLogByTime.time * (60 * 1000)) 
        TriggerEvent("shk-RichPlayer:server:sendLog") 
    end
end)


QBCore.Commands.Add(Lang:t("command.name"), Lang:t("command.help"), {}, true, function()
    if (Config.OnlyTopRichest.enable) then
        TriggerEvent("shk-RichPlayer:server:getTopPlayerMoney", Config.LogMessageType)
    else
        TriggerEvent("shk-RichPlayer:server:getAllPlayerMoney", Config.LogMessageType)
    end
end, 'admin')


RegisterNetEvent("shk-RichPlayer:server:getTopPlayerMoney", function(type)
    if (type == "full") then
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, `license`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        local resultWithLicense = ''

        for _, v in pairs(topRichestPlayers) do
            resultWithLicense = resultWithLicense .. "`" .. _ .. "." .. Lang:t("message.top_with_license", {name = topRichestPlayers[_]["name"], citizenid = topRichestPlayers[_]["citizenid"], license = topRichestPlayers[_]["license"], money = topRichestPlayers[_]["money"], totalMoney = topRichestPlayers[_]["total_money"]})
        end

        sendToDiscord(resultWithLicense) 
    elseif (type == "standard") then
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        local resultWithoutLicense = ''

        for _, v in pairs(topRichestPlayers) do
            resultWithoutLicense = resultWithoutLicense .. "`" .. _ .. "." .. Lang:t("message.top_without_license", {name = topRichestPlayers[_]["name"], citizenid = topRichestPlayers[_]["citizenid"], money = topRichestPlayers[_]["money"], totalMoney = topRichestPlayers[_]["total_money"]})
        end

        sendToDiscord(resultWithoutLicense)
    else
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        local shortMsg = ''

        for _, v in pairs(topRichestPlayers) do
            shortMsg = shortMsg .. "`" .. _ .. "." .. Lang:t("message.short_top_message", {name = topRichestPlayers[_]["name"], citizenid = topRichestPlayers[_]["citizenid"], totalMoney = topRichestPlayers[_]["total_money"]})
        end

        sendToDiscord(shortMsg)
    end
end)


RegisterNetEvent("shk-RichPlayer:server:getAllPlayerMoney", function(type)
    if (type == "full") then
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, `license`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC")
        local resultWithLicense = ''

        for _, v in pairs(topRichestPlayers) do
            resultWithLicense = resultWithLicense .. "`" .. _ .. "." .. Lang:t("message.top_with_license", {name = topRichestPlayers[_]["name"], citizenid = topRichestPlayers[_]["citizenid"], license = topRichestPlayers[_]["license"], money = topRichestPlayers[_]["money"], totalMoney = topRichestPlayers[_]["total_money"]})
        end

        sendToDiscord(resultWithLicense)
    elseif (type == "standard") then
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC")
        local resultWithoutLicense = ''

        for _, v in pairs(topRichestPlayers) do
            resultWithoutLicense = resultWithoutLicense .. "`" .. _ .. "." .. Lang:t("message.top_without_license", {name = topRichestPlayers[_]["name"], citizenid = topRichestPlayers[_]["citizenid"], money = topRichestPlayers[_]["money"], totalMoney = topRichestPlayers[_]["total_money"]})
        end

        sendToDiscord(resultWithoutLicense)
    else
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `name`, `money`, `citizenid`, JSON_VALUE(money, '$.cash') + JSON_VALUE(money, '$.bank') AS `total_money` FROM `players` GROUP BY `name` ORDER BY `total_money` DESC")
        local shortMsg = ''

        for _, v in pairs(topRichestPlayers) do
            shortMsg = shortMsg .. "`" .. _ .. "." .. Lang:t("message.short_top_message", {name = topRichestPlayers[_]["name"], citizenid = topRichestPlayers[_]["citizenid"], totalMoney = topRichestPlayers[_]["total_money"]})
        end

        sendToDiscord(shortMsg)
    end
end)


RegisterNetEvent("shk-RichPlayer:server:sendLog", function()
    if (Config.OnlyTopRichest.enable) then
        TriggerEvent("shk-RichPlayer:server:getTopPlayerMoney", Config.LogMessageType)
    else
        TriggerEvent("shk-RichPlayer:server:getAllPlayerMoney", Config.LogMessageType)
    end
end)