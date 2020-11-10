--[===[
PvPDB by Qwazerty
--]===]

local _, ns = ...
ns.REGION = GetCVar("portal"):lower()
ns.db = {}
ns.debug = false

local function BracketTooltip(name, realm, faction, bracketId, bracketName)
    if ns.db[realm][faction][name][bracketId] ~= nil then
        local won = ns.db[realm][faction][name][bracketId]['sms'][1]
        local lost = ns.db[realm][faction][name][bracketId]['sms'][2]
        local winrate = math.floor(won*100/(won+lost) * 100) / 100
        GameTooltip:AddDoubleLine(
            format("Ranked %s: %s CR", bracketName, ns.db[realm][faction][name][bracketId]['cr']),
            format("%sW / %sL (%s%%)", won,	lost, winrate),
            1, 1, 1, 1, 1, 1)
    end
end

local function Mouseover_OnEvent(self, event, ...)
    if UnitIsPlayer("mouseover") then
        local name, realm = UnitName("mouseover")
        realm = realm and realm ~= "" and realm or GetNormalizedRealmName()
        local faction, _ = UnitFactionGroup("mouseover")

        if ns.debug then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Tooltip Info")
            GameTooltip:AddLine("Name: "..name, 1, 1, 1)
            GameTooltip:AddLine("Realm: "..realm, 1, 1, 1)
            GameTooltip:AddLine("Faction: "..faction, 1, 1, 1)
            GameTooltip:AddLine("Region: "..ns.REGION, 1, 1, 1)
            GameTooltip:AddLine("db="..(tostring(ns.db)), 1, 1, 1)
            if ns.db ~= nil then
                GameTooltip:AddLine("db["..realm.."]="..(tostring(ns.db[realm])), 1, 1, 1)
                if ns.db[realm] ~= nil then
                    GameTooltip:AddLine("db["..realm.."]["..faction.."]="..(tostring(ns.db[realm][faction])), 1, 1, 1)
                    if ns.db[realm][faction] ~= nil then
                        GameTooltip:AddLine("db["..realm.."]["..faction.."]["..name.."]="..(tostring(ns.db[realm][faction][name])), 1, 1, 1)
                    end
                end
            end
            GameTooltip:Show()
        end

        if ns.db ~= nil and ns.db[realm] ~= nil and ns.db[realm][faction] ~= nil and ns.db[realm][faction][name] ~= nil then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Score PvPDB")
            local hl = ns.db[realm][faction][name]['hl'] and ns.db[realm][faction][name]['hl'] or "No Data"
            GameTooltip:AddLine("Honor Level: "..hl, 1, 1, 1)
            BracketTooltip(name, realm, faction, "2v2", "2v2")
            BracketTooltip(name, realm, faction, "3v3", "3v3")
            BracketTooltip(name, realm, faction, "bg", "RBG")
            GameTooltip:Show()
        end
    end
end

local Mouseover_EventFrame = CreateFrame("Frame")
Mouseover_EventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
Mouseover_EventFrame:SetScript("OnEvent", Mouseover_OnEvent)
