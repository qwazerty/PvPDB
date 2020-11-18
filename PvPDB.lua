--[===[
PvPDB by Qwazerty
--]===]

local _, ns = ...
ns.REGION = GetCVar("portal"):lower()
ns.dba = {}
ns.dbh = {}
ns.debug = false

local function BracketTooltip(db, name, realm, faction, bracketId, bracketName)
    if db[realm][name][bracketId] ~= nil then
        local won = db[realm][name][bracketId]['sms'][1]
        local lost = db[realm][name][bracketId]['sms'][2]
        local winrate = math.floor(won*100/(won+lost) * 100) / 100
        GameTooltip:AddDoubleLine(
            format("Ranked %s: %s CR", bracketName, db[realm][name][bracketId]['cr']),
            format("%sW / %sL (%s%%)", won,	lost, winrate),
            1, 1, 1, 1, 1, 1)
    end
end

local function Mouseover_OnEvent(self, event, ...)
    if UnitIsPlayer("mouseover") then
        local name, realm = UnitName("mouseover")
        realm = realm and realm ~= "" and realm or GetNormalizedRealmName()
        local faction, _ = UnitFactionGroup("mouseover")
        db = (faction == "Alliance") and ns.dba or ns.dbh

        if ns.debug then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Tooltip Info")
            GameTooltip:AddLine("Name: "..name, 1, 1, 1)
            GameTooltip:AddLine("Realm: "..realm, 1, 1, 1)
            GameTooltip:AddLine("Faction: "..faction, 1, 1, 1)
            GameTooltip:AddLine("Region: "..ns.REGION, 1, 1, 1)
            GameTooltip:AddLine("db="..(tostring(db)), 1, 1, 1)
            if db ~= nil then
                GameTooltip:AddLine("db["..realm.."]="..(tostring(db[realm])), 1, 1, 1)
                if db[realm] ~= nil then
                    GameTooltip:AddLine("db["..realm.."]["..name.."]="..(tostring(db[realm][name])), 1, 1, 1)
                end
            end
            GameTooltip:Show()
        end

        if db ~= nil and db[realm] ~= nil and db[realm][name] ~= nil then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Score PvPDB")
            local hl = db[realm][name]['hl'] and db[realm][name]['hl'] or "No Data"
            GameTooltip:AddLine("Honor Level: "..hl, 1, 1, 1)
            BracketTooltip(db, name, realm, faction, "2v2", "2v2")
            BracketTooltip(db, name, realm, faction, "3v3", "3v3")
            BracketTooltip(db, name, realm, faction, "bg", "RBG")
            GameTooltip:Show()
        end
    end
end

local Mouseover_EventFrame = CreateFrame("Frame")
Mouseover_EventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
Mouseover_EventFrame:SetScript("OnEvent", Mouseover_OnEvent)