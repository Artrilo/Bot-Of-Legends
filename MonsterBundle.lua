local AUTOUPDATES = true
local ScriptName = "MonsterBundle"
local version = 0.5
local Champions = {
    ["MasterYi"] = function() return __MasterYi() end,
    ["Kennen"]   = function() return __Kennen() end,
    ["Graves"]   = function() return __Graves() end,
    ["Brand"]    = function() return __Brand() end,
    ["DrMundo"]  = function() return __DrMundo() end,
    ["Malphite"] = function() return __Malphite() end,
    ["Kassadin"] = function() return __Kassadin() end,
}
if not Champions[myHero.charName] then return end
local Ignite    = nil
local Flash     = nil
local OffensiveItems = nil
local DefensiveItems = nil
local Colors = { 
    -- O R G B
    Green   =  ARGB(255, 0, 180, 0), 
    Yellow  =  ARGB(255, 255, 215, 00),
    Red     =  ARGB(255, 255, 0, 0),
    White   =  ARGB(255, 255, 255, 255),
    Blue    =  ARGB(255, 0, 0, 255),
}

--Tracker--
assert(load(Base64Decode("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"), nil, "bt", _ENV))()
TrackerLoad("xZpSf4FWP8l56zCE")
--Tracker--

function CheckUpdate()
    if AUTOUPDATES then
        local ToUpdate = {}
        ToUpdate.LocalVersion = version
        ToUpdate.VersionPath = "raw.githubusercontent.com/Artrilo/Bot-Of-Legends/master/version/MonsterBundle.version"
        ToUpdate.ScriptPath = "raw.githubusercontent.com/Artrilo/Bot-Of-Legends/master/MonsterBundle.lua"
        ToUpdate.SavePath = SCRIPT_PATH.._ENV.FILE_NAME
        ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) PrintMessage(ScriptName, "Updated to "..NewVersion..". Please reload with 2x F9.") end
        ToUpdate.CallbackNoUpdate = function(OldVersion) PrintMessage(ScriptName, "No Updates Found.") end
        ToUpdate.CallbackNewVersion = function(NewVersion) PrintMessage(ScriptName, "New Version found ("..NewVersion.."). Please wait...") end
        ToUpdate.CallbackError = function(NewVersion) PrintMessage(ScriptName, "Error while downloading.") end
        _ScriptUpdate(ToUpdate)
    end
end

AddLoadCallback(
    function()
        if not RequireSimpleLib() then return end

        local originalKD = _G.IsKeyDown;
        _G.IsKeyDown = function(theKey)
            if (type(theKey) ~= 'number') then
                local theNumber = tonumber(theKey);
                if (theNumber ~= nil) then
                    return originalKD(theNumber);
                else
                    return originalKD(GetKey(theKey));
                end;
            else
                return originalKD(theKey);
            end;
        end;

        OffensiveItems = {
            Tiamat      = _Spell({Range = 300, DamageName = "TIAMAT", Type = SPELL_TYPE.SELF}):AddSlotFunction(function() return FindItemSlot("Cleave") end),
            Bork        = _Spell({Range = 450, DamageName = "RUINEDKING", Type = SPELL_TYPE.TARGETTED}):AddSlotFunction(function() return FindItemSlot("SwordOfFeastAndFamine") end),
            Bwc         = _Spell({Range = 400, DamageName = "BWC", Type = SPELL_TYPE.TARGETTED}):AddSlotFunction(function() return FindItemSlot("BilgewaterCutlass") end),
            Hextech     = _Spell({Range = 400, DamageName = "HXG", Type = SPELL_TYPE.TARGETTED}):AddSlotFunction(function() return FindItemSlot("HextechGunblade") end),
            Youmuu      = _Spell({Range = myHero.range + myHero.boundingRadius + 250, Type = SPELL_TYPE.SELF}):AddSlotFunction(function() return FindItemSlot("YoumusBlade") end),
            Randuin     = _Spell({Range = 500, Type = SPELL_TYPE.SELF}):AddSlotFunction(function() return FindItemSlot("RanduinsOmen") end),
        }
        DefensiveItems = {
            Zhonyas     = _Spell({Range = 1000, Type = SPELL_TYPE.SELF}):AddSlotFunction(function() return FindItemSlot("ZhonyasHourglass") end),
        }
        Ignite = _Spell({Slot = FindSummonerSlot("summonerdot"), DamageName = "IGNITE", Range = 600, Type = SPELL_TYPE.TARGETTED})
        Flash = _Spell({Slot = FindSummonerSlot("flash"), Range = 400})

        local champion = Champions[myHero.charName]()
        if champion == nil then return end
        champion.Menu = scriptConfig(champion.ScriptName.." by "..champion.Author, champion.ScriptName.."18052016")
                DelayAction(function() CheckUpdate() end, 5)
        DelayAction(function() _arrangePriorities() end, 12)
        if myHero.charName == "MasterYi" then
            champion.TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 600, DAMAGE_PHYSICAL)
            champion.Q = _Spell({Slot = _Q, Range = 600, Type = SPELL_TYPE.TARGETTED}):AddDraw()
            champion.W = _Spell({Slot = _W, Range = 0, Type = SPELL_TYPE.SELF}):AddDraw()
            champion.E = _Spell({Slot = _E, Range = 189, Type = SPELL_TYPE.SELF}):AddDraw()
            champion.R = _Spell({Slot = _R, Range = 0, Type = SPELL_TYPE.SELF})
        
            champion.TS:AddToMenu(champion.Menu)
        
            champion.Menu:addSubMenu(myHero.charName.." - General Settings", "General")
                champion.Menu.General:addParam("Overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
                champion.Menu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseIgnite", "Use Ignite If Killable ", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Combo:addParam("Items", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
                champion.Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
                champion.Menu.LaneClear:addParam("UseQ", "Use Q",  SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
                champion.Menu.JungleClear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                      
            champion.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
                champion.Menu.KillSteal:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")          
                champion.Menu.Auto:addSubMenu("Use Q To Evade", "UseQ")
                    _Evader(champion.Menu.Auto.UseQ):CheckCC():AddCallback(function(target) champion:EvadeQ(target)end)

            champion.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
                champion.Menu.Misc:addParam("SetSkin", "Select Skin", SCRIPT_PARAM_LIST, 10, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
            
            champion.Menu:addSubMenu(myHero.charName.." - Keys Settings", "Keys")
                OrbwalkManager:LoadCommonKeys(champion.Menu.Keys)
                champion.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
                champion.Menu.Keys:permaShow("HarassToggle")
                champion.Menu.Keys.HarassToggle = false
            champion.MenuLoaded = true

            elseif myHero.charName == "Kennen" then
            champion.TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 950, DAMAGE_MAGIC)
            champion.Q = _Spell({Slot = _Q, Range = 950, Width = 50, Delay = 0.175, Speed = 1700, Collision = true, Aoe = false, Type = SPELL_TYPE.LINEAR}):AddDraw()
            champion.W = _Spell({Slot = _W, Range = 900, Type = SPELL_TYPE.SELF}):AddDraw()
            champion.E = _Spell({Slot = _E, Range = 950, Type = SPELL_TYPE.SELF}):AddDraw()
            champion.R = _Spell({Slot = _R, Range = 500, Type = SPELL_TYPE.SELF}):AddDraw()
        
            champion.TS:AddToMenu(champion.Menu)
        
            champion.Menu:addSubMenu(myHero.charName.." - General Settings", "General")
                champion.Menu.General:addParam("Overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
                champion.Menu.Combo:addParam("UseQ","Use Q", SCRIPT_PARAM_LIST, 2, {"Never", "Only On Target", "On Any Enemy"})
                champion.Menu.Combo:addParam("UseW","Wait until % marked >=", SCRIPT_PARAM_SLICE, 60, 0, 100)
                champion.Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseR","Use R If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
                champion.Menu.Combo:addParam("UseIgnite", "Use Ignite If Killable ", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Combo:addParam("Items", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("Zhonyas","Use Zhonyas if % hp <= ", SCRIPT_PARAM_SLICE, 15, 0, 100)
            
            champion.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
                champion.Menu.Harass:addParam("UseQ","Use Q", SCRIPT_PARAM_LIST, 2, {"Never", "Only On Target", "On Any Enemy"})
                champion.Menu.Harass:addParam("UseW","Use W", SCRIPT_PARAM_LIST, 2, {"Never", "If Target Have Mark", "On Any Enemy"})
                champion.Menu.Harass:addParam("UseE","Use E", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Harass:addParam("Mana", "Min. Energy Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
                champion.Menu.LaneClear:addParam("UseQ", "Use Q",  SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.LaneClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("Mana", "Min. Energy Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
                champion.Menu.JungleClear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)

            champion.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
                champion.Menu.LastHit:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LastHit:addParam("Mana", "Min. Mana Percent:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
                      
            champion.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
                champion.Menu.KillSteal:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")          
                champion.Menu.Auto:addParam("UseW", "Auto W If Marked Enemies >=", SCRIPT_PARAM_SLICE, 2, 0, 5)
                champion.Menu.Auto:addParam("UseW2", "Auto W If Range >=", SCRIPT_PARAM_SLICE, 600, 600, 800)
                champion.Menu.Auto:addParam("UseQStun", "Auto Q If Will Stun", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Auto:addParam("UseWStun", "Auto W If Will Stun", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Auto:addParam("Zhonyas", "Auto Zhonyas If R Casted", SCRIPT_PARAM_ONOFF, false)

            champion.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
                champion.Menu.Misc:addParam("SetSkin", "Select Skin", SCRIPT_PARAM_LIST, 10, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
                        
            champion.Menu:addSubMenu(myHero.charName.." - Keys Settings", "Keys")
                OrbwalkManager:LoadCommonKeys(champion.Menu.Keys)
                champion.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
                champion.Menu.Keys:permaShow("HarassToggle")
                champion.Menu.Keys.HarassToggle = false
            champion.MenuLoaded = true

            elseif myHero.charName == "Graves" then
            champion.TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 1200, DAMAGE_PHYSICAL)
            champion.Q = _Spell({Slot = _Q, Range = 800, Width = 40, Delay = 0.25, Speed = 3000, Collision = false, Aoe = true, Type = SPELL_TYPE.LINEAR}):AddDraw()
            champion.W = _Spell({Slot = _W, Range = 900, Width = 225, Delay = 0.25, Speed = 1650, Collision = false, Aoe = true, Type = SPELL_TYPE.CIRCULAR}):AddDraw()
            champion.E = _Spell({Slot = _E, Range = 425}):AddDraw()
            champion.R = _Spell({Slot = _R, Range = 1150, Width = 100, Delay = 0.75, Speed = 1400, Collision = false, Aoe = true, Type = SPELL_TYPE.LINEAR}):AddDraw()
        
            champion.TS:AddToMenu(champion.Menu)
        
            champion.Menu:addSubMenu(myHero.charName.." - General Settings", "General")
                champion.Menu.General:addParam("Overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
                champion.Menu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseE", "Use E (Mouse Pos)", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Combo:addParam("Items", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
                champion.Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
                champion.Menu.LaneClear:addParam("UseQ", "Use Q",  SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("Q", "Use Q If Hit >= ", SCRIPT_PARAM_SLICE, 4, 0, 10)
                champion.Menu.LaneClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
                champion.Menu.JungleClear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                      
            champion.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
                champion.Menu.KillSteal:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")          
                champion.Menu.Auto:addSubMenu("Use E To Evade", "UseE")
                    _Evader(champion.Menu.Auto.UseE):CheckCC():AddCallback(function(target) champion:EvadeE(target)end)

            champion.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
                champion.Menu.Misc:addParam("SetSkin", "Select Skin", SCRIPT_PARAM_LIST, 10, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
            
            champion.Menu:addSubMenu(myHero.charName.." - Keys Settings", "Keys")
                OrbwalkManager:LoadCommonKeys(champion.Menu.Keys)
                champion.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
                champion.Menu.Keys:permaShow("HarassToggle")
                champion.Menu.Keys.HarassToggle = false
            champion.MenuLoaded = true
            elseif myHero.charName == "Brand" then
            champion.TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 1050, DAMAGE_MAGIC)
            champion.Q = _Spell({Slot = _Q, Range = 1050, Width = 60, Delay = 0.25, Speed = 1600, Aoe = false, Collision = true, Type = SPELL_TYPE.LINEAR}):AddDraw()
            champion.W = _Spell({Slot = _W, Range = 900, Width = 240, Delay = 0.85, Speed = math.huge, Collision = false, Aoe = true, Type = SPELL_TYPE.CIRCULAR}):AddDraw()
            champion.E = _Spell({Slot = _E, Range = 625, Type = SPELL_TYPE.TARGETTED}):AddDraw()
            champion.R = _Spell({Slot = _R, Range = 750, Type = SPELL_TYPE.TARGETTED}):AddDraw()
        
            champion.TS:AddToMenu(champion.Menu)
        
            champion.Menu:addSubMenu(myHero.charName.." - General Settings", "General")
                champion.Menu.General:addParam("Overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
                champion.Menu.Combo:addParam("UseQ", "Use Smart Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Combo:addParam("useR2", "Use R If Enemies >=", SCRIPT_PARAM_SLICE, math.min(#GetEnemyHeroes(), 3), 0, 5, 0)
                champion.Menu.Combo:addParam("Zhonyas","Use Zhonyas if % hp <= ", SCRIPT_PARAM_SLICE, 15, 0, 100)
                champion.Menu.Combo:addParam("Items", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
                champion.Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
                champion.Menu.LaneClear:addParam("UseQ", "Use Q",  SCRIPT_PARAM_ONOFF, false)
                champion.Menu.LaneClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("W", "Use W If Hit >= ", SCRIPT_PARAM_SLICE, 4, 0, 10)
                champion.Menu.LaneClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
                champion.Menu.JungleClear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                      
            champion.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
                champion.Menu.KillSteal:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

            champion.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
                champion.Menu.Misc:addParam("SetSkin", "Select Skin", SCRIPT_PARAM_LIST, 10, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
            
            champion.Menu:addSubMenu(myHero.charName.." - Keys Settings", "Keys")
                OrbwalkManager:LoadCommonKeys(champion.Menu.Keys)
                champion.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
                champion.Menu.Keys:permaShow("HarassToggle")
                champion.Menu.Keys.HarassToggle = false
            champion.MenuLoaded = true
            elseif myHero.charName == "DrMundo" then
            champion.TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 1050, DAMAGE_PHYSICAL)
            champion.Q = _Spell({Slot = _Q, Range = 1050, Width = 60, Delay = 0.25, Speed = 2000, Aoe = false, Collision = true, Type = SPELL_TYPE.LINEAR}):AddDraw()
            champion.W = _Spell({Slot = _W, Range = 320, Type = SPELL_TYPE.SELF}):AddDraw()
            champion.E = _Spell({Slot = _E, Range = 200, Type = SPELL_TYPE.SELF}):AddDraw()
            champion.R = _Spell({Slot = _R, Range = 0, Type = SPELL_TYPE.SELF})
        
            champion.TS:AddToMenu(champion.Menu)
        
            champion.Menu:addSubMenu(myHero.charName.." - General Settings", "General")
                champion.Menu.General:addParam("Overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
                champion.Menu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("hp", "What % to ult", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
                champion.Menu.Combo:addParam("Items", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
                champion.Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
            
            champion.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
                champion.Menu.LaneClear:addParam("UseQ", "Use Q",  SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
                champion.Menu.JungleClear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                      
            champion.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
                champion.Menu.KillSteal:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
                champion.Menu.Misc:addParam("SetSkin", "Select Skin", SCRIPT_PARAM_LIST, 10, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
                champion.Menu.Misc:addParam("AutoW", "Use Auto W", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Keys Settings", "Keys")
                OrbwalkManager:LoadCommonKeys(champion.Menu.Keys)
                champion.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
                champion.Menu.Keys:permaShow("HarassToggle")
                champion.Menu.Keys.HarassToggle = false
            champion.MenuLoaded = true
            elseif myHero.charName == "Malphite" then
            champion.TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_MAGIC)
            champion.Q = _Spell({Slot = _Q, Range = 625, Type = SPELL_TYPE.TARGETTED}):AddDraw()
            champion.W = _Spell({Slot = _W, Range = 0, Type = SPELL_TYPE.SELF}):AddDraw()
            champion.E = _Spell({Slot = _E, Range = 400, Type = SPELL_TYPE.SELF}):AddDraw()
            champion.R = _Spell({Slot = _R, Range = 1000, Width = 300, Delay = 0, Speed = 2000, Aoe = true, Collision = false, Type = SPELL_TYPE.CIRCULAR}):AddDraw()
        
            champion.TS:AddToMenu(champion.Menu)
        
            champion.Menu:addSubMenu(myHero.charName.." - General Settings", "General")
                champion.Menu.General:addParam("Overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
                champion.Menu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Combo:addParam("UseR", "Use R If Combo Kills", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Combo:addParam("useR2", "Use R If Enemies >=", SCRIPT_PARAM_SLICE, math.min(#GetEnemyHeroes(), 3), 0, 5, 0)
                champion.Menu.Combo:addParam("Zhonyas","Use Zhonyas if % hp <= ", SCRIPT_PARAM_SLICE, 15, 0, 100)
                champion.Menu.Combo:addParam("Items", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
            
            champion.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
                champion.Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
                champion.Menu.LaneClear:addParam("UseQ", "Use Q",  SCRIPT_PARAM_ONOFF, false)
                champion.Menu.LaneClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
            
            champion.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
                champion.Menu.JungleClear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                      
            champion.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
                champion.Menu.KillSteal:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

            champion.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
                champion.Menu.Misc:addParam("SetSkin", "Select Skin", SCRIPT_PARAM_LIST, 10, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
            
            champion.Menu:addSubMenu(myHero.charName.." - Keys Settings", "Keys")
                OrbwalkManager:LoadCommonKeys(champion.Menu.Keys)
                champion.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
                champion.Menu.Keys:addParam("Run", "Run Nigga", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
                champion.Menu.Keys:permaShow("HarassToggle")
                champion.Menu.Keys.HarassToggle = false
                champion.Menu.Keys.Run = false
            champion.MenuLoaded = true
            elseif myHero.charName == "Kassadin" then
            champion.TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 850, DAMAGE_MAGIC)
            champion.Q = _Spell({Slot = _Q, Range = 650, Type = SPELL_TYPE.TARGETTED}):AddDraw()
            champion.W = _Spell({Slot = _W, Range = 175}):AddDraw()
            champion.E = _Spell({Slot = _E, Range = 600, Width = 39*2, Delay = 0.25, Speed = math.huge, Aoe = true, Type = SPELL_TYPE.CONE}):AddDraw()
            champion.R = _Spell({Slot = _R, Range = 493, Delay = 0.25, Width = 270, Speed = math.huge, Aoe = true, Type = SPELL_TYPE.CIRCULAR}):AddDraw()

            champion.TS:AddToMenu(champion.Menu)

            champion.Menu:addSubMenu(myHero.charName.." - General Settings", "General")
                champion.Menu.General:addParam("Overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)

            champion.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
                champion.Menu.Combo:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("useR", "Use R if Dmg Kills", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Combo:addParam("useR2", "Use R if 1 Target", SCRIPT_PARAM_ONOFF, true)


            champion.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
                champion.Menu.Harass:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

            champion.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
                champion.Menu.LaneClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

            champion.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
                champion.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

            champion.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
                champion.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.LastHit:addParam("Mana", "Min. Mana Percent:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

            champion.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
                champion.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
                champion.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
                champion.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

            champion.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
                champion.Menu.Draw:addParam("Damage", "Damage Calculation Bar", SCRIPT_PARAM_ONOFF, true)

            champion.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")          
                champion.Menu.Auto:addSubMenu("Use R To Evade", "UseR")
                _Evader(champion.Menu.Auto.UseR):CheckCC():AddCallback(function(target) champion:EvadeR(target)end)

            champion.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
                champion.Menu.Misc:addParam("SetSkin", "Select Skin", SCRIPT_PARAM_LIST, 10, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})

            champion.Menu:addSubMenu(myHero.charName.." - Keys Settings", "Keys")
                OrbwalkManager:LoadCommonKeys(champion.Menu.Keys)
                champion.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
                champion.Menu.Keys:permaShow("HarassToggle")
                champion.Menu.Keys.HarassToggle = false
            champion.MenuLoaded = true
        end
        local ChampionCallbacks = {
            ["MasterYi"] = { ["OnTick"] = true, },
            ["Kennen"]   = { ["OnTick"] = true, ["OnProcessSpell"] = true, ["OnApplyBuff"] = true, ["OnRemoveBuff"] = true, },
            ["Graves"]   = { ["OnTick"] = true, },
            ["Brand"]    = { ["OnTick"] = true, },
            ["DrMundo"]  = { ["OnTick"] = true, ["OnApplyBuff"] = true, ["OnRemoveBuff"] = true, },
            ["Malphite"] = { ["OnTick"] = true, },
            ["Kassadin"] = { ["OnTick"] = true, },
        }
        if ChampionCallbacks[myHero.charName]["OnTick"] then AddTickCallback(function() champion:OnTick() end) end
        if ChampionCallbacks[myHero.charName]["OnProcessSpell"] then
            if AddProcessSpellCallback then
                AddProcessSpellCallback(function(unit, spell) champion:OnProcessSpell(unit, spell) end)
            end
            if AddProcessAttackCallback then
                AddProcessAttackCallback(function(unit, spell) champion:OnProcessSpell(unit, spell) end)
            end
        end
        if ChampionCallbacks[myHero.charName]["OnProcessAttack"] then
            if AddProcessAttackCallback then
                AddProcessAttackCallback(function(unit, spell) champion:OnProcessAttack(unit, spell) end)
            end
        end
        if ChampionCallbacks[myHero.charName]["OnCreateObj"] then AddCreateObjCallback(function(obj) champion:OnCreateObj(obj) end) end
        if ChampionCallbacks[myHero.charName]["OnDeleteObj"] then AddDeleteObjCallback(function(obj) champion:OnDeleteObj(obj) end) end
        if ChampionCallbacks[myHero.charName]["OnDraw"] then AddDrawCallback(function() champion:OnDraw() end) end
        if ChampionCallbacks[myHero.charName]["OnRecvPacket"] then if VIP_USER then HookPackets() AddRecvPacketCallback2(function(p) champion:OnRecvPacket(p) end) end end
        if ChampionCallbacks[myHero.charName]["OnSendPacket"] then if VIP_USER then HookPackets() AddSendPacketCallback(function(p) champion:OnSendPacket(p) end) end end
        if ChampionCallbacks[myHero.charName]["OnWndMsg"] then AddMsgCallback(function(msg, key) champion:OnWndMsg(msg, key) end) end
        if ChampionCallbacks[myHero.charName]["OnCastSpell"] then AddCastSpellCallback(function(iSpell, startPos, endPos, targetUnit) champion:OnCastSpell(iSpell, startPos, endPos, targetUnit) end) end
        if ChampionCallbacks[myHero.charName]["OnAnimation"] then AddAnimationCallback(function(unit, animation) champion:OnAnimation(unit, animation) end) end
        if ChampionCallbacks[myHero.charName]["OnApplyBuff"] then AddApplyBuffCallback(function(source, unit, buff) champion:OnApplyBuff(source, unit, buff) end) end
        if ChampionCallbacks[myHero.charName]["OnRemoveBuff"] then AddRemoveBuffCallback(function(unit, buff) champion:OnRemoveBuff(unit, buff) end) end
    end
)


local PredictedDamage = {}
local RefreshTime = 0.4

function GetBestCombo(target, champion)
    if not IsValidTarget(target) then return false, false, false, false, 0 end
    local q = {false}
    local w = {false}
    local e = {false}
    local r = {false}
    local damagetable = PredictedDamage[target.networkID]
    if damagetable ~= nil then
        local time = damagetable[6]
        if os.clock() - time <= RefreshTime then 
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5] 
        else
            if champion.Q:IsReady() then q = {false, true} end
            if champion.W:IsReady() then w = {false, true} end
            if champion.E:IsReady() then e = {false, true} end
            if champion.R:IsReady() then r = {false, true} end
            local bestdmg = 0
            for qCount = 1, #q do
                for wCount = 1, #w do
                    for eCount = 1, #e do
                        for rCount = 1, #r do
                            local d, m = champion:GetComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                            if myHero.mana >= m then
                                if bestdmg >= target.health then
                                    if d < bestdmg then
                                        bestdmg = d 
                                        best = {q[qCount], w[wCount], e[eCount], r[rCount]} 
                                    end
                                else
                                    if d > bestdmg then
                                        bestdmg = d 
                                        best = {q[qCount], w[wCount], e[eCount], r[rCount]} 
                                    end
                                end
                            end
                        end
                    end
                end
            end
            damagetable[1] = best[1]
            damagetable[2] = best[2]
            damagetable[3] = best[3]
            damagetable[4] = best[4]
            damagetable[5] = bestdmg
            damagetable[6] = os.clock()
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5]
        end
    else
        local dmg, mana = champion:GetComboDamage(target, champion.Q:IsReady(), champion.W:IsReady(), champion.E:IsReady(), champion.R:IsReady())
        PredictedDamage[target.networkID] = {false, false, false, false, dmg, os.clock() - RefreshTime * 2}
        return GetBestCombo(target, champion)
    end
end

function ObjectsInArea(objects, range, pos)
    local objects2 = {}
    local position = pos ~= nil and pos or myHero
    for i, object in ipairs(objects) do
        if ValidTarget(object, math.huge, false) then
            if GetDistanceSqr(position, object) <= range * range then
                table.insert(objects2, object)
            end
        end
    end
    return objects2
end

function Collides(vec)
    return IsWall(D3DXVECTOR3(vec.x, vec.y, vec.z))
end

function UseItems(unit)
    for _, item in pairs(OffensiveItems) do
        item:Cast(unit)
    end
end

function PercentageMana(u)
    local unit = u ~= nil and u or myHero
    return unit and unit.mana/unit.maxMana * 100 or 0
end

function PercentageHealth(u)
    local unit = u ~= nil and u or myHero
    return unit and unit.health/unit.maxHealth * 100 or 0
end


function UnderTurret(unit, offset)
    local offset = offset ~= nil and offset or 0
    if unit ~= nil and unit.valid then
        for name, turret in pairs(GetTurrets()) do
            if turret ~= nil and GetDistanceSqr(myHero, turret) < 2000 * 2000 then
                if turret.team ~= myHero.team and GetDistanceSqr(unit, turret) < (turret.range + offset) * (turret.range + offset) then
                    return true
                end
            end
        end
    end
    return false
end

function Latency()
    return GetLatency() / 2000
end

class "__MasterYi"
function __MasterYi:__init()
    self.ScriptName = "Monster Yi"
    self.Author = "Artrilo"
    self.MenuLoaded = false
    self.Menu = nil
    self.TS = nil
end

function __MasterYi:OnTick()
    if self.Menu == nil or self.TS == nil or not self.MenuLoaded then return end
    self.TS:update()
    self:KillSteal()
    SetSkin(myHero, self.Menu.Misc.SetSkin)
    if OrbwalkManager:IsCombo() then
        self:Combo()
    elseif OrbwalkManager:IsHarass() then
        self:Harass()
    elseif OrbwalkManager:IsClear() then
        self:Clear()
    end
    if self.Menu.Keys.HarassToggle then self:Harass() end
end

function __MasterYi:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if IsValidTarget(enemy, 1800) and enemy.health > 0 and PercentageHealth(enemy) <= 30 then
            if self.Menu.KillSteal.UseQ and self.Q:Damage(enemy) >= enemy.health then self.Q:Cast(enemy) end
            if self.Menu.KillSteal.UseIgnite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health then Ignite:Cast(enemy) end
        end
    end
end

function __MasterYi:Combo()
    local target = self.TS.target
    if OrbwalkManager.GotReset and OrbwalkManager:InRange(target) then return end
    if IsValidTarget(target) then
        if self.Menu.Combo.Items then UseItems(target) end
        if self.Menu.Combo.UseQ then
            self.Q:Cast(target)
        end
        if self.Menu.Combo.UseE then
            self.E:Cast()
        end
        if self.Menu.Combo.UseR and GetDistance(target) > 800 then
            self.R:Cast()
        end     
    end
end

function  __MasterYi:Harass()
    if PercentageMana() >= self.Menu.Harass.Mana then
        local target = self.TS.target
        if ValidTarget(target) then
            if self.Menu.Harass.UseQ then
                self.Q:Cast(target)
            end
            if self.Menu.Harass.UseE then
                self.E:Cast(target)
            end
        end
    end
end

function  __MasterYi:Clear()
    if PercentageMana() >= self.Menu.LaneClear.Mana then
        if self.Menu.LaneClear.UseQ then
            self.Q:LaneClear()
        end
         if self.Menu.LaneClear.UseE then
            self.E:LaneClear()
        end
    end
    if self.Menu.JungleClear.UseQ then
        self.Q:JungleClear()
    end
    if self.Menu.JungleClear.UseE then
        self.E:JungleClear()
    end
end

function __MasterYi:GetOverkill()
    return (100 + self.Menu.General.Overkill)/100
end

function __MasterYi:EvadeQ(target)
    if self.Q:IsReady() and IsValidTarget(target) then
        self.Q:Cast(target)
    end
end


class "__Kennen"
function __Kennen:__init()
    self.ScriptName = "Monster Kennen"
    self.Author = "Artrilo"
    self.MenuLoaded = false
    self.Menu = nil
    self.TS = nil
    self:Variables()
    self.AA = { Range = function(target) local int1 = 50 if IsValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end, Damage = function(target) return getDmg("AD", target, myHero) end }
end

function __Kennen:OnTick()
    if self.Menu == nil or self.TS == nil or not self.MenuLoaded then return end
    self.TS:update()
    self:KillSteal()
    self:Auto()
    SetSkin(myHero, self.Menu.Misc.SetSkin)
    if OrbwalkManager:IsCombo() then
        self:Combo()
    elseif OrbwalkManager:IsHarass() then
        self:Harass()
    elseif OrbwalkManager:IsClear() then
        self:Clear()
    elseif OrbwalkManager:IsLastHit() then 
        self:LastHit()
    end
    if self.Menu.Keys.HarassToggle then self:Harass() end
end

function __Kennen:Variables()
    self.LastMarkRequest = 0
    self.EnemiesMarked = {}
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        self.EnemiesMarked[enemy.charName] = false
    end
    self.EnemySoonStunned = {}
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        self.EnemySoonStunned[enemy.charName] = false
    end
    self.EnemiesMarkCounter = {}
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        self.EnemiesMarkCounter[enemy.charName] = 0
    end
    self.AutoAttackMarkObject = nil
end

function __Kennen:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if IsValidTarget(enemy, 1800) and enemy.health > 0 and PercentageHealth(enemy) <= 30 then
            if self.Menu.KillSteal.UseQ and self.Q:Damage(enemy) >= enemy.health then self.Q:Cast(enemy) end
            if self.Menu.KillSteal.UseW and self.W:Damage(enemy) >= enemy.health then self.W:Cast(enemy) end
            if self.Menu.KillSteal.UseE and self.E:Damage(enemy) >= enemy.health then self.E:Cast(enemy) end
            if self.Menu.KillSteal.UseR and self.R:Damage(enemy) >= enemy.health then self.R:Cast(enemy) end
            if self.Menu.KillSteal.UseIgnite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health then Ignite:Cast(enemy) end
        end
    end
end

function __Kennen:OnProcessSpell(unit, spell)
    if self.Menu == nil or not self.MenuLoaded then return end
        if unit and spell and spell.name and unit.isMe then
            if spell.name:lower():find("kennenshurikenstorm") then 
                if self.Menu.Auto.Zhonyas and DefensiveItems.Zhonyas.IsReady() then DelayAction(function() CastSpell(DefensiveItems.Zhonyas.Slot()) end, 0.3) end
            end
        end
end


function __Kennen:OnApplyBuff(source, unit, buff)
    if unit and source and buff and buff.name and buff.name:lower():find("kennen") and unit.type == myHero.type then
        if buff.name:lower() == "kennenmarkofstorm" then
            self.EnemiesMarked[unit.charName] = true
            self.EnemiesMarkCounter[unit.charName] = self.EnemiesMarkCounter[unit.charName] + 1
            if self.EnemiesMarkCounter[unit.charName] == 2 then
                self.EnemySoonStunned[unit.charName] = true
            elseif self.EnemiesMarkCounter[unit.charName] == 3 then
                self.EnemiesMarkCounter[unit.charName] = 0
                self.EnemySoonStunned[unit.charName] = false
            end
        end
    end
end

function __Kennen:OnRemoveBuff(unit, buff)
    if unit and buff and buff.name and buff.name:lower():find("kennen") and unit.type == myHero.type then
        if buff.name:lower() == "kennenmarkofstorm" then
            self.EnemiesMarked[unit.charName] = false
        end
    end
end

function __Kennen:Auto()
    if self.W:IsReady() and self.Menu.Auto.UseW <= #self:EnemyMarkeds() and self.Menu.Auto.UseW > 0 then CastSpell(self.W.Slot) end
    if self.W:IsReady() and self.W:ValidTarget(self.TS.target) and GetDistanceSqr(myHero, self.TS.target) >= self.Menu.Auto.UseW2 * self.Menu.Auto.UseW2 then CastSpell(self.W.Slot) end
    if self.W:IsReady() and self.Menu.Auto.UseWStun then 
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if self.W:ValidTarget(enemy) then
                if self.EnemySoonStunned[enemy.charName] == true then
                    CastSpell(self.W.Slot)
                end
            end
        end
    end
    if self.Q:IsReady() and self.Menu.Auto.UseQ then self:CastQ(ts.target, 3) end
    if self.Q:IsReady() and self.Menu.Auto.UseQStun then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if self.Q:ValidTarget(enemy) then
                if self.EnemySoonStunned[enemy.charName] == true then
                    self:CastQ(enemy)
                end
            end
        end
    end
end

function __Kennen:Combo()
    local target = self.TS.target
    if IsValidTarget(target) then
        if self.Menu.Combo.Items then UseItems(target) end
        if self.Menu.Combo.UseQ > 1 then
            self:CastQ(target, self.Menu.Combo.UseQ)
        end
        if self.Menu.Combo.UseW <= 100 * #self:EnemyMarkeds()/#self.W:ObjectsInArea(GetEnemyHeroes()) then
            CastSpell(self.W.Slot)
        end
        if self.Menu.Combo.UseE then
            self.E:Cast(target)
        end
        if self.Menu.Combo.UseR <= #self.R:ObjectsInArea(GetEnemyHeroes()) and self.Menu.Combo.UseR > 0 then
            CastSpell(self.R.Slot)
        end
        if myHero.health / myHero.maxHealth * 100 < self.Menu.Combo.Zhonyas and DefensiveItems.Zhonyas:IsReady() then
            DefensiveItems.Zhonyas:Cast()
        end
    end
end

function  __Kennen:Harass()
    if PercentageMana() >= self.Menu.Harass.Mana then
        local target = self.TS.target
        if ValidTarget(target) then
            if self.Menu.Harass.UseQ > 1 then
                self:CastQ(target, self.Menu.Harass.UseQ)
            end
            if self.Menu.Harass.UseW > 1 then
                self:CastW(target, self.Menu.Harass.UseW)
            end
            if self.Menu.Harass.UseE then
                self:CastE(target)
            end
        end
    end
end

function  __Kennen:Clear()
    if PercentageMana() >= self.Menu.LaneClear.Mana then
        if self.Menu.LaneClear.UseQ then
            self.Q:LaneClear()
        end
        if self.Menu.LaneClear.UseW then
            self.W:LaneClear()
        end
        if self.Menu.LaneClear.UseE then
            self.E:LaneClear()
        end
    end
    if self.Menu.JungleClear.UseQ then
        self.Q:JungleClear()
    end
    if self.Menu.JungleClear.UseW then
        self.W:JungleClear()
    end
    if self.Menu.JungleClear.UseE then
        self.E:JungleClear()
    end
end

function __Kennen:LastHit()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LastHit.Mana then
        if self.Menu.LastHit.UseQ then
            self.Q:LastHit()
        end
    end
end

function __Kennen:CastQ(target, mod)
    local mode = mod or 2
    if self.Q:IsReady() then
        if mode == 2 then
            self.Q:Cast(target)
        elseif mode == 3 then
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                if self.Q:ValidTarget(enemy) then 
                    self.Q:Cast(enemy)
                    return
                end
            end
        end
    end
end

function __Kennen:CastW(target, mod)
    local mode = mod or 2
    if self.W:IsReady() then
        if mode == 2 then
            if self:EnemyIsMarked(target) and self.W:ValidTarget(target) then 
                CastSpell(self.W.Slot)
            end
        elseif mode == 3 then
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                if self:EnemyIsMarked(enemy) and self.W:ValidTarget(enemy) then 
                    CastSpell(self.W.Slot)
                    return
                end
            end
        end
    end
end

function __Kennen:CastE(target)
    if self.E:IsReady() then
        if self.E:ValidTarget(target) then
            if self:IsE1() then
                self.E:Cast(target)
            end
        end
    end
end

function __Kennen:HaveAutoAttackMark()
    return self.AutoAttackMarkObject ~= nil and self.AutoAttackMarkObject.valid
end

function __Kennen:EnemyIsMarked(enemy)
    if self.EnemiesMarked[enemy.charName] ~= nil then
        return self.EnemiesMarked[enemy.charName]
    end
    return false
end

function __Kennen:IsE1()
    return self.E:GetSpellData().name:lower():find("kennenlightningrush")
end


function __Kennen:EnemyMarkeds()
    local asd = {}
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if self.W:ValidTarget(enemy) then
            if self.EnemiesMarked[enemy.charName] == true then
                table.insert(asd, enemy)
            end
        end
    end
    return asd
end

function __Kennen:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.Q:Damage(target)
            currentManaWasted = currentManaWasted + self.Q:Mana()
        end
        if w then
            comboDamage = comboDamage + self.W:Damage(target)
            currentManaWasted = currentManaWasted + self.W:Mana()
        end
        if e then
            comboDamage = comboDamage + self.E:Damage(target)
            currentManaWasted = currentManaWasted + self.E:Mana()
            comboDamage = comboDamage + self.AA.Damage(target)
        end
        if r then
            comboDamage = comboDamage + self.R:Damage(target)
            currentManaWasted = currentManaWasted + self.R:Mana()
            comboDamage = comboDamage + self.W:Damage(target)
            comboDamage = comboDamage + self.AA.Damage(target) * 2
        end
        comboDamage = comboDamage + self.AA.Damage(target) * 2
        comboDamage = comboDamage 
        local iDmg = Ignite.IsReady() and Ignite.Damage(target) or 0
        comboDamage = comboDamage + iDmg
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function __Kennen:GetOverkill()
    return (100 + self.Menu.General.Overkill)/100
end

class "__Graves"
function __Graves:__init()
    self.ScriptName = "Dead Man Walking"
    self.Author = "Artrilo"
    self.MenuLoaded = false
    self.Menu = nil
    self.TS = nil
end

function __Graves:OnTick()
    if self.Menu == nil or self.TS == nil or not self.MenuLoaded then return end
    self.TS:update()
    self:KillSteal()
    SetSkin(myHero, self.Menu.Misc.SetSkin)
    if OrbwalkManager:IsCombo() then
        self:Combo()
    elseif OrbwalkManager:IsHarass() then
        self:Harass()
    elseif OrbwalkManager:IsClear() then
        self:Clear()
    end
    if self.Menu.Keys.HarassToggle then self:Harass() end
end

function __Graves:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if IsValidTarget(enemy, 1800) and enemy.health > 0 and PercentageHealth(enemy) <= 30 then
            if self.Menu.KillSteal.UseQ and self.Q:Damage(enemy) >= enemy.health then self.Q:Cast(enemy) end
            if self.Menu.KillSteal.UseW and self.W:Damage(enemy) >= enemy.health then self.W:Cast(enemy) end
            if self.Menu.KillSteal.UseR and self.R:Damage(enemy) >= enemy.health then self.R:Cast(enemy) end
            if self.Menu.KillSteal.UseIgnite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health then Ignite:Cast(enemy) end
        end
    end
end

function __Graves:Combo()
    local target = self.TS.target
    if OrbwalkManager.GotReset and OrbwalkManager:InRange(target) then return end
    if IsValidTarget(target) then
        if self.Menu.Combo.Items then UseItems(target) end
        if self.Menu.Combo.UseQ then
            self.Q:Cast(target)
        end
        if self.Menu.Combo.UseW then
            self.W:Cast(target)
        end
        if self.Menu.Combo.UseE and GetDistance(target) < 700 then
            CastSpell(_E, mousePos.x, mousePos.z)
        end     
    end
end

function  __Graves:Harass()
    if PercentageMana() >= self.Menu.Harass.Mana then
        local target = self.TS.target
        if ValidTarget(target) then
            if self.Menu.Harass.UseQ then
                self.Q:Cast(target)
            end
            if self.Menu.Harass.UseW then
                self.W:Cast(target)
            end
        end
    end
end

function  __Graves:Clear()
    if PercentageMana() >= self.Menu.LaneClear.Mana then
        if self.Menu.LaneClear.UseQ then
            self.Q:LaneClear({NumberOfHits = self.Menu.LaneClear.Q})
        end
         if self.Menu.LaneClear.UseW then
            self.W:LaneClear()
        end
    end
    if self.Menu.JungleClear.UseQ then
        self.Q:JungleClear()
    end
    if self.Menu.JungleClear.UseW then
        self.W:JungleClear()
    end
end


function __Graves:EvadeE(target)
    if self.E:IsReady() and IsValidTarget(target) then
        local Position = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized():perpendicular() * self.E.Range
        local Position2 = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized():perpendicular2() * self.E.Range
        if not Collides(Position) then
            self.E:CastToVector(Position)
        elseif not Collides(Position2) then
            self.E:CastToVector(Position2)
        else
            self.E:CastToVector(Position)
        end
    end
end

class "__Brand"
function __Brand:__init()
    self.ScriptName = "Last FireBender"
    self.Author = "Artrilo"
    self.MenuLoaded = false
    self.Menu = nil
    self.TS = nil
end

function __Brand:OnTick()
    if self.Menu == nil or self.TS == nil or not self.MenuLoaded then return end
    self.TS:update()
    self:KillSteal()
    SetSkin(myHero, self.Menu.Misc.SetSkin)
    if OrbwalkManager:IsCombo() then
        self:Combo()
    elseif OrbwalkManager:IsHarass() then
        self:Harass()
    elseif OrbwalkManager:IsClear() then
        self:Clear()
    end
    if self.Menu.Keys.HarassToggle then self:Harass() end
end

function __Brand:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if IsValidTarget(enemy, 1800) and enemy.health > 0 and PercentageHealth(enemy) <= 30 then
            if self.Menu.KillSteal.UseQ and self.Q:Damage(enemy) >= enemy.health then self.Q:Cast(enemy) end
            if self.Menu.KillSteal.UseW and self.W:Damage(enemy) >= enemy.health then self.W:Cast(enemy) end
            if self.Menu.KillSteal.UseE and self.E:Damage(enemy) >= enemy.health then self.E:Cast(enemy) end
            if self.Menu.KillSteal.UseR and self.R:Damage(enemy) >= enemy.health then self.R:Cast(enemy) end
            if self.Menu.KillSteal.UseIgnite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health then Ignite:Cast(enemy) end
        end
    end
end

function __Brand:Combo()
    local target = self.TS.target
    if IsValidTarget(target) then
        if self.Menu.Combo.Zhonyas > 0 and PercentageHealth() <= self.Menu.Combo.Zhonyas and DefensiveItems.Zhonyas:IsReady() then
            DefensiveItems.Zhonyas:Cast()
        end
        if self.Menu.Combo.Items then UseItems(target) end
        if self.Menu.Combo.UseQ and TargetHaveBuff("brandablaze", self.TS.target) then
            self.Q:Cast(target)
        end
        if self.Menu.Combo.UseW then
            self.W:Cast(target)
        end
        if self.Menu.Combo.UseE then
            self.E:Cast(target)
        end
        if self.Menu.Combo.useR2 > 0 then
            if self.R:IsReady() then
                local xTargets = #ObjectsInArea(GetEnemyHeroes(), self.R.Range)
                if xTargets > 2 then
                    self.R:Cast(target)
                end
            end
        end     
    end
end

function  __Brand:Harass()
    if PercentageMana() >= self.Menu.Harass.Mana then
        local target = self.TS.target
        if ValidTarget(target) then
            if self.Menu.Harass.UseQ and TargetHaveBuff("brandablaze", self.TS.target) then
                self.Q:Cast(target)
            end
            if self.Menu.Harass.UseW then
                self.W:Cast(target)
            end
            if self.Menu.Harass.UseE then
                self.E:Cast(target)
            end
        end
    end
end

function  __Brand:Clear()
    if PercentageMana() >= self.Menu.LaneClear.Mana then
        if self.Menu.LaneClear.UseQ then
            self.Q:LaneClear()
        end
         if self.Menu.LaneClear.UseW then
            self.W:LaneClear({NumberOfHits = self.Menu.LaneClear.W})
        end
        if self.Menu.LaneClear.UseE and TargetHaveBuff("brandablaze", minion) then
            self.E:LaneClear()
        end
    end
    if self.Menu.JungleClear.UseQ then
        self.Q:JungleClear()
    end
    if self.Menu.JungleClear.UseW then
        self.W:JungleClear()
    end
    if self.Menu.JungleClear.UseE then
        self.E:JungleClear()
    end
end

class "__DrMundo"
function __DrMundo:__init()
    self.ScriptName = "Dr Edmundo"
    self.Author = "Artrilo"
    self.MenuLoaded = false
    self.Menu = nil
    self.TS = nil
    self.WActive = false
end

function __DrMundo:OnTick()
    if self.Menu == nil or self.TS == nil or not self.MenuLoaded then return end
    self.TS:update()
    self:KillSteal()
    SetSkin(myHero, self.Menu.Misc.SetSkin)
    if OrbwalkManager:IsCombo() then
        self:Combo()
    elseif OrbwalkManager:IsHarass() then
        self:Harass()
    elseif OrbwalkManager:IsClear() then
        self:Clear()
    end
    if myHero:GetSpellData(_W).toggleState == 2 then
        WActive = true
    else
        WActive = false
    end
    if self.Menu.Keys.HarassToggle then self:Harass() end
    if self.Menu.Misc.AutoW then
        self:AutoDisableW()
    end
end

function __DrMundo:OnApplyBuff(source, unit, buff)
    if unit and source and buff and buff.name and buff.name:lower():find("drmundo") and unit.type == myHero.type then
        if buff.name == "BurningAgony" then
            self.WActive = true
        end
    end
end

function __DrMundo:OnRemoveBuff(unit, buff)
    if unit and buff and buff.name and buff.name:lower():find("drmundo") and unit.type == myHero.type then
        if buff.name == "BurningAgony" then
            self.WActive = false
        end
    end
end

function __DrMundo:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if IsValidTarget(enemy, 1800) and enemy.health > 0 and PercentageHealth(enemy) <= 30 then
            if self.Menu.KillSteal.UseQ and self.Q:Damage(enemy) >= enemy.health then self.Q:Cast(enemy) end
            if self.Menu.KillSteal.UseIgnite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health then Ignite:Cast(enemy) end
        end
    end
end

function __DrMundo:Combo()
    local target = self.TS.target
    if OrbwalkManager.GotReset and OrbwalkManager:InRange(target) then return end
    if IsValidTarget(target) then
        if self.Menu.Combo.Items then UseItems(target) end
        if self.Menu.Combo.UseQ then
            self.Q:Cast(target)
        end
        if self.Menu.Combo.UseW and self:GetEnemyW() ~= 0 then
            self:EnableW()
        else
            self:DisableW()
        end
        if self.Menu.Combo.UseE and CountEnemyHeroInRange(self.E.Range) >= 1 then
            self.E:Cast()
        end
        if self.Menu.Combo.UseR and myHero.health/myHero.maxHealth * 100 <= self.Menu.Combo.hp and CountEnemyHeroInRange(600) >= 1 then
            CastSpell(_R)
        end     
    end
end

function __DrMundo:EnableW()
  if not WActive and self.W:IsReady() then
    self.W:Cast()
  end
end

function __DrMundo:DisableW()
  if WActive and self.W:IsReady() then
    self.W:Cast()
  end
end

function __DrMundo:AutoDisableW()
    if WActive and not self:GetAllEnemyW() and self.W:IsReady() and self.Menu.Misc.AutoW then
        self.W:Cast()
    end
end

function __DrMundo:GetAllEnemyW()
  if CountEnemyHeroInRange(500) > 0 then
    return true
  else
    return false
  end
end

function  __DrMundo:Harass()
    local target = self.TS.target
    if ValidTarget(target) then
        if self.Menu.Harass.UseQ then
            self.Q:Cast(target)
        end
        if self.Menu.Harass.UseW then
            self.W:Cast(target)
        end
        if self.Menu.Harass.UseE then
            self.E:Cast(target)
        end
    end
end

function  __DrMundo:Clear()
    if self.Menu.LaneClear.UseQ then
        self.Q:LaneClear()
    end
    if self.Menu.LaneClear.UseW then
        self.W:LaneClear()
    end
     if self.Menu.LaneClear.UseE then
        self.E:LaneClear()
    end
    if self.Menu.JungleClear.UseQ then
        self.Q:JungleClear()
    end
    if self.Menu.JungleClear.UseW then
        self.W:JungleClear()
    end
    if self.Menu.JungleClear.UseE then
        self.E:JungleClear()
    end
end

function __DrMundo:GetEnemyW()
  return CountEnemyHeroInRange(500)
end

function __DrMundo:GetOverkill()
    return (100 + self.Menu.General.Overkill)/100
end

class "__Malphite"
function __Malphite:__init()
    self.ScriptName = "The Rolling Stone"
    self.Author = "Artrilo"
    self.MenuLoaded = false
    self.Menu = nil
    self.TS = nil
end

function __Malphite:OnTick()
    if self.Menu == nil or self.TS == nil or not self.MenuLoaded then return end
    self.TS:update()
    self:KillSteal()
    SetSkin(myHero, self.Menu.Misc.SetSkin)
    if OrbwalkManager:IsCombo() then
        self:Combo()
    elseif OrbwalkManager:IsHarass() then
        self:Harass()
    elseif OrbwalkManager:IsClear() then
        self:Clear()
    end
    if self.Menu.Keys.HarassToggle then self:Harass() end
    if self.Menu.Keys.Run then self:Run() end
end

function __Malphite:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if IsValidTarget(enemy, 1800) and enemy.health > 0 and PercentageHealth(enemy) <= 30 then
            if self.Menu.KillSteal.UseQ and self.Q:Damage(enemy) >= enemy.health then self.Q:Cast(enemy) end
            if self.Menu.KillSteal.UseE and self.E:Damage(enemy) >= enemy.health then self.E:Cast(enemy) end
            if self.Menu.KillSteal.UseR and self.R:Damage(enemy) >= enemy.health then self.R:Cast(enemy) end
            if self.Menu.KillSteal.UseIgnite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health then Ignite:Cast(enemy) end
        end
    end
end

function __Malphite:Combo()
    local target = self.TS.target
    if IsValidTarget(target) then
        if self.Menu.Combo.Zhonyas > 0 and PercentageHealth() <= self.Menu.Combo.Zhonyas and DefensiveItems.Zhonyas:IsReady() then
            DefensiveItems.Zhonyas:Cast()
        end
        if self.Menu.Combo.Items then UseItems(target) end
        if self.Menu.Combo.UseQ then
            self.Q:Cast(target)
        end
        if self.Menu.Combo.UseW and CountEnemyHeroInRange(200) >= 1 then
            self.W:Cast()
        end
        if self.Menu.Combo.UseE then
            self.E:Cast(target)
        end
        if self.Menu.Combo.UseR and self.R:IsReady() and self.Q:IsReady() and self.E:IsReady() then
            if self.Q:Damage(target) + self.E:Damage(target) + self.R:Damage(target) > target.health then
                self.R:Cast(target)
            end
        end
        if self.Menu.Combo.useR2 > 0 then
            if self.R:IsReady() then
                for i, enemy in ipairs(GetEnemyHeroes()) do
                    local CastPosition, WillHit, NumberOfHits = self.R:GetPrediction(enemy, {TypeOfPrediction = "VPrediction"})
                    if NumberOfHits and type(NumberOfHits) == "number" and NumberOfHits >= self.Menu.Combo.useR2 and WillHit then
                        CastSpell(self.R.Slot, CastPosition.x, CastPosition.z)
                    end
                end
            end
        end    
    end
end

function  __Malphite:Harass()
    if PercentageMana() >= self.Menu.Harass.Mana then
        local target = self.TS.target
        if ValidTarget(target) then
            if self.Menu.Harass.UseQ then
                self.Q:Cast(target)
            end
            if self.Menu.Harass.UseW and CountEnemyHeroInRange(200) >= 1 then
                self.W:Cast(target)
            end
            if self.Menu.Harass.UseE then
                self.E:Cast(target)
            end
        end
    end
end

function  __Malphite:Clear()
    if PercentageMana() >= self.Menu.LaneClear.Mana then
        if self.Menu.LaneClear.UseQ then
            self.Q:LaneClear()
        end
         if self.Menu.LaneClear.UseW then
            self.W:LaneClear()
        end
        if self.Menu.LaneClear.UseE then
            self.E:LaneClear()
        end
    end
    if self.Menu.JungleClear.UseQ then
        self.Q:JungleClear()
    end
    if self.Menu.JungleClear.UseW then
        self.W:JungleClear()
    end
    if self.Menu.JungleClear.UseE then
        self.E:JungleClear()
    end
end

function __Malphite:Run()
    local target = self.TS.target
    myHero:MoveTo(mousePos.x, mousePos.z)
    self.Q:Cast(target)
end

class "__Kassadin"
function __Kassadin:__init()
    self.ScriptName = "Monsterdin"
    self.Author = "Artrilo"
    self.MenuLoaded = false
    self.Menu = nil
    self.TS = nil
end
function __Kassadin:OnTick()
    if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
    self.TS:update()
    self:KillSteal()
    SetSkin(myHero, self.Menu.Misc.SetSkin)
    if OrbwalkManager:IsCombo() then
        self:Combo()
    elseif OrbwalkManager:IsHarass() then
        self:Harass()
    elseif OrbwalkManager:IsClear() then
        self:Clear()
    elseif OrbwalkManager:IsLastHit() then
        self:LastHit()
    end
    if self.Menu.Keys.HarassToggle then self:Harass() end 
end

function __Kassadin:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, self.TS.range) and enemy.health > 0 and PercentageHealth(enemy) <= 35 then
            local q, w, e, r, dmg = GetBestCombo(enemy, self)
            if dmg >= enemy.health then
              if self.Menu.KillSteal.useQ and self.Q:Damage(enemy) >= enemy.health and not enemy.dead then self.Q:Cast(enemy) end
              if self.Menu.KillSteal.useE and self.E:Damage(enemy) >= enemy.health and not enemy.dead then self.E:Cast(enemy) end
              if self.Menu.KillSteal.useR and self.R:Damage(enemy) >= enemy.health and not enemy.dead then self.R:Cast(enemy) end
            end
            if self.Menu.KillSteal.useIgnite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health and not enemy.dead then Ignite:Cast(enemy) end
        end
    end
end

function __Kassadin:Combo()
    local target = self.TS.target
    local q, w, e, r, dmg = GetBestCombo(target, self)
    if ValidTarget(target) then
        if OrbwalkManager.GotReset and OrbwalkManager:InRange(target) then return end
        if self.Menu.Combo.useQ then
            self.Q:Cast(target)
        end
        if self.Menu.Combo.useW then
            self.W:Cast(target)
        end
        if self.Menu.Combo.useE then
            self.E:Cast(target)
        end
        if self.Menu.Combo.useR2 and CountEnemyHeroInRange(self.R.Range) <= 1 then
            self.R:Cast(target)
        end
        if self.Menu.Combo.useR and self.Q:IsReady() then
            if self.Q:Damage(target) + self.R:Damage(target) + self.E:Damage(target) > target.health then
                self.R:Cast(target)
            end
        end
    end
end

function __Kassadin:Harass()
    local target = self.TS.target
    if ValidTarget(target) then
        if self.Menu.Harass.useQ then
            self.Q:Cast(target)
        end
        if self.Menu.Harass.useE then
            self.E:Cast(target)
        end
        if self.Menu.Harass.useW then
            self.W:Cast(target)
        end
    end
end

function __Kassadin:Clear()
    if PercentageMana() >= self.Menu.LaneClear.Mana then
        if self.Menu.LaneClear.useQ then
            self.Q:LaneClear()
        end
        if self.Menu.LaneClear.useW then
            self.W:LaneClear()
        end
        if self.Menu.LaneClear.useE then
            self.E:LaneClear()
        end
    end

    if self.Menu.JungleClear.useE then
        self.E:JungleClear()
    end
    if self.Menu.JungleClear.useQ then
        self.Q:JungleClear()
    end
    if self.Menu.JungleClear.useW then
        self.W:JungleClear()
    end
end

function __Kassadin:LastHit()
    if PercentageMana() >= self.Menu.LastHit.Mana then
        if self.Menu.LastHit.useQ then
            self.Q:LastHit()
        end
    end
end

function __Kassadin:EvadeR(target)
    if self.R:IsReady() and IsValidTarget(target) then
        local Position = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized():perpendicular() * self.R.Range
        local Position2 = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized():perpendicular2() * self.R.Range
        if not Collides(Position) then
            self.R:CastToVector(Position)
        elseif not Collides(Position2) then
            self.R:CastToVector(Position2)
        else
            self.R:CastToVector(Position)
        end
    end
end

function __Kassadin:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if IsValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.Q:Damage(target)
            currentManaWasted = currentManaWasted + self.Q:Mana()
        end
        if w then
            comboDamage = comboDamage + self.W:Damage(target)
            currentManaWasted = currentManaWasted + self.W:Mana()
        end
        if e then
            comboDamage = comboDamage + self.E:Damage(target)
            currentManaWasted = currentManaWasted + self.E:Mana()
        end
        if r then
            comboDamage = comboDamage + self.R:Damage(target)
            currentManaWasted = currentManaWasted + self.R:Mana()
        end
        if Ignite:IsReady() then comboDamage = comboDamage + Ignite:Damage(target) end
        comboDamage = comboDamage + getDmg("AD", target, myHero) * 2
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function __Kassadin:GetOverkill()
    return (100 + self.Menu.General.Overkill)/100
end

function RequireSimpleLib()
    if FileExist(LIB_PATH.."SimpleLib.lua") and not FileExist(SCRIPT_PATH.."SimpleLib.lua") then
        require "SimpleLib"
        if _G.SimpleLibVersion == nil then 
            print("Your SimpleLib file is wrong.")
            return false
        end
        if _G.SimpleLibVersion < 1.48 then
            print("You need the lastest version of SimpleLib. The library should autoupdate.")
            return false
        end
        return true
    elseif FileExist(LIB_PATH.."SimpleLib.lua") and FileExist(SCRIPT_PATH.."SimpleLib.lua") then
        print("SimpleLib.lua should not be in Custom Script (Only on Common folder), delete it from there...")
        return false
    else
        local function Base64Encode2(data)
            local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            return ((data:gsub('.', function(x)
                local r,b='',x:byte()
                for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
                return r;
            end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
                if (#x < 6) then return '' end
                local c=0
                for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
                return b:sub(c+1,c+1)
            end)..({ '', '==', '=' })[#data%3+1])
        end
        local SavePath = LIB_PATH.."SimpleLib.lua"
        local ScriptPath = '/BoL/TCPUpdater/GetScript5.php?script='..Base64Encode2("raw.githubusercontent.com/jachicao/BoL/master/SimpleLib.lua")..'&rand='..math.random(99999999)
        local GotScript = false
        local LuaSocket = nil
        local Socket = nil
        local Size = nil
        local RecvStarted = false
        local Receive, Status, Snipped = nil, nil, nil
        local Started = false
        local File = ""
        local NewFile = ""
        if not LuaSocket then
            LuaSocket = require("socket")
        else
            Socket:close()
            Socket = nil
            Size = nil
            RecvStarted = false
        end
        Socket = LuaSocket.tcp()
        if not Socket then
            print('Socket Error')
        else
            Socket:settimeout(0, 'b')
            Socket:settimeout(99999999, 't')
            Socket:connect('sx-bol.eu', 80)
            Started = false
            File = ""
        end
        AddTickCallback(function()
            if GotScript then return end
            Receive, Status, Snipped = Socket:receive(1024)
            if Status == 'timeout' and not Started then
                Started = true
                print("Downloading a library called SimpleLib. Please wait...")
                Socket:send("GET "..ScriptPath.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
            end
            if (Receive or (#Snipped > 0)) and not RecvStarted then
                RecvStarted = true
            end

            File = File .. (Receive or Snipped)
            if File:find('</si'..'ze>') then
                if not Size then
                    Size = tonumber(File:sub(File:find('<si'..'ze>') + 6, File:find('</si'..'ze>') - 1))
                end
            end
            if File:find('</scr'..'ipt>') then
                local a,b = File:find('\r\n\r\n')
                File = File:sub(a,-1)
                NewFile = ''
                for line,content in ipairs(File:split('\n')) do
                    if content:len() > 5 then
                        NewFile = NewFile .. content
                    end
                end
                local HeaderEnd, ContentStart = NewFile:find('<sc'..'ript>')
                local ContentEnd, _ = NewFile:find('</scr'..'ipt>')
                if not ContentStart or not ContentEnd then
                else
                    local newf = NewFile:sub(ContentStart + 1,ContentEnd - 1)
                    local newf = newf:gsub('\r','')
                    if newf:len() ~= Size then
                        return
                    end
                    local newf = Base64Decode(newf)
                    if type(load(newf)) ~= 'function' then
                    else
                        local f = io.open(SavePath, "w+b")
                        f:write(newf)
                        f:close()
                        print("Required library downloaded. Please reload with 2x F9.")
                    end
                end
                GotScript = true
            end
        end)
        return false
    end
end

class "_Downloader"
function _Downloader:__init(t)
    local name = t.Name
    local url = t.Url
    local extension = t.Extension ~= nil and t.Extension or "lua"
    local usehttps = t.UseHttps ~= nil and t.UseHttps or true
    self.SavePath = LIB_PATH..name.."."..extension
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(usehttps and '5' or '6')..'.php?script='..self:Base64Encode(url)..'&rand='..math.random(99999999)
    self:CreateSocket(self.ScriptPath)
    self.DownloadStatus = 'Connect to Server'
    self.GotScript = false
end

function _Downloader:CreateSocket(url)
    if not self.LuaSocket then
        self.LuaSocket = require("socket")
    else
        self.Socket:close()
        self.Socket = nil
        self.Size = nil
        self.RecvStarted = false
    end
    self.Socket = self.LuaSocket.tcp()
    if not self.Socket then
        print('Socket Error')
    else
        self.Socket:settimeout(0, 'b')
        self.Socket:settimeout(99999999, 't')
        self.Socket:connect('sx-bol.eu', 80)
        self.Url = url
        self.Started = false
        self.LastPrint = ""
        self.File = ""
    end
end

function _Downloader:Download()
    if self.GotScript then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading Script (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
        local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
            local newf = newf:gsub('\r','')
            if newf:len() ~= self.Size then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
                return
            end
            local newf = Base64Decode(newf)
            if type(load(newf)) ~= 'function' then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
            else
                local f = io.open(self.SavePath,"w+b")
                f:write(newf)
                f:close()
                if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                    self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
                end
            end
        end
        self.GotScript = true
    end
end

function _Downloader:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
        end
        
