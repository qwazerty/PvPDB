--[===[
PvPDB by Qwazerty
--]===]

local _, ns = ...
ns.REGION = GetCVar("portal"):lower()
ns.db = {}
ns.debug = false

local function BracketTooltip(name, realm, bracketId, bracketName)
    if ns.db[realm][name][bracketId] ~= nil then
        local won = ns.db[realm][name][bracketId]['sms'][1]
        local lost = ns.db[realm][name][bracketId]['sms'][2]
        local winrate = math.floor(won*100/(won+lost) * 100) / 100
        GameTooltip:AddDoubleLine(
            format("Ranked %s: %s CR", bracketName, ns.db[realm][name][bracketId]['cr']),
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
            GameTooltip:Show()
            if ns.db ~= nil then
                GameTooltip:AddLine("db not nil", 1, 1, 1)
                if ns.db[realm] ~= nil then
                    GameTooltip:AddLine("db[realm] not nil", 1, 1, 1)
                    if ns.db[realm][name] ~= nil then
                        GameTooltip:AddLine("db[realm][name] not nil", 1, 1, 1)
                    else
                        GameTooltip:AddLine("db[realm][name] nil", 1, 1, 1)
                    end
                else
                    GameTooltip:AddLine("db[realm] nil", 1, 1, 1)
                end
            else
                GameTooltip:AddLine("db nil", 1, 1, 1)
            end
            GameTooltip:Show()
        end

        if ns.db ~= nil and ns.db[realm] ~= nil and ns.db[realm][name] ~= nil then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Score PvPDB")
            if ns.db[realm][name]['hl'] ~= nil then
                GameTooltip:AddLine("Honor Level: "..ns.db[realm][name]['hl'], 1, 1, 1)
            else
                GameTooltip:AddLine("Honor Level: No Data", 1, 1, 1)
            end
            BracketTooltip(name, realm, "2v2", "2v2")
            BracketTooltip(name, realm, "3v3", "3v3")
            BracketTooltip(name, realm, "bg", "RBG")
            GameTooltip:Show()
        end
    end
end

local Mouseover_EventFrame = CreateFrame("Frame")
Mouseover_EventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
Mouseover_EventFrame:SetScript("OnEvent", Mouseover_OnEvent)

--local name = UnitName("player")
--local realm = GetNormalizedRealmName()
-- message('PvPDB : name='..name..', realm='..realm)