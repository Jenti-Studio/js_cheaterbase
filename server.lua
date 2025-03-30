local webhookURL = "YOUR_WEBHOOK_HERE"

RegisterCommand("melden", function(source, args, rawCommand)
    if #args < 2 then
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Benutzung: /melden [ID] [Grund]")
        return
    end

    local targetID = tonumber(args[1])
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    if not targetID or GetPlayerName(targetID) == nil then
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Ungültige Spieler-ID!")
        return
    end

    -- Get player information
    local playerName = GetPlayerName(targetID) or "Unbekannt"
    local reporterName = GetPlayerName(source) or "Unbekannt"

    local steamID, discordID, license, xboxID, liveID, hwid = "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown"

    for _, identifier in ipairs(GetPlayerIdentifiers(targetID)) do
        if string.sub(identifier, 1, 6) == "steam:" then
            steamID = identifier
        elseif string.sub(identifier, 1, 8) == "discord:" then
            discordID = "<@" .. string.sub(identifier, 9) .. ">" -- Makes the Discord ID mentionable
        elseif string.sub(identifier, 1, 7) == "license" then
            license = identifier
        elseif string.sub(identifier, 1, 4) == "xbl:" then
            xboxID = identifier
        elseif string.sub(identifier, 1, 5) == "live:" then
            liveID = identifier
        elseif string.sub(identifier, 1, 6) == "hwid:" then
            hwid = identifier
        end
    end

    local embed = {
        {
            ["color"] = 16711680, -- Red color
            ["title"] = "?? Neue Cheat-Meldung",
            ["description"] = "**Spieler:** " .. playerName .. " wurde als Cheater gemeldet!\n**Grund:** " .. reason,
            ["fields"] = {
                { ["name"] = "?? Spieler Name", ["value"] = playerName, ["inline"] = true },
                { ["name"] = "?? Steam ID", ["value"] = steamID, ["inline"] = true },
                { ["name"] = "?? Discord ID", ["value"] = discordID, ["inline"] = true },
                { ["name"] = "?? License", ["value"] = license, ["inline"] = false },
                { ["name"] = "?? Xbox ID", ["value"] = xboxID, ["inline"] = true },
                { ["name"] = "?? Live ID", ["value"] = liveID, ["inline"] = true },
                { ["name"] = "??? HWID", ["value"] = hwid, ["inline"] = false }
            },
            ["footer"] = {
                ["text"] = "Gemeldet von: " .. reporterName
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, "POST", json.encode({username = "CheaterBase", embeds = embed}), { ["Content-Type"] = "application/json" })

    TriggerClientEvent("chatMessage", source, "SYSTEM", {0, 255, 0}, "Meldung wurde gesendet!")
end, false)
