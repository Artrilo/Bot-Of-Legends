local ScriptName = "Monster Bundle"
local Version = 0.2
local Champions = {
    ["MasterYi"] = function() return __MasterYi() end,
    ["Kennen"] = function() return __Kennen() end,
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
        end
        local ChampionCallbacks = {
            ["MasterYi"] = { ["OnTick"] = true, },
            ["Kennen"]   = { ["OnTick"] = true, ["OnProcessSpell"] = true, ["OnApplyBuff"] = true, ["OnRemoveBuff"] = true, },
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

DelayAction(
        function()
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
            local LocalVersion = Version
            local UseHttps = true
            local Size = nil
            local VersionPath = "raw.githubusercontent.com/Artrilo/Bot-Of-Legends/master/version/MonsterBundle.version"
            local ScriptPath = "raw.githubusercontent.com/Artrilo/Bot-Of-Legends/master/version/MonsterBundle.lua"
            local SavePath = SCRIPT_PATH.._ENV.FILE_NAME
            local VersionPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..Base64Encode2(VersionPath)..'&rand='..math.random(99999999)
            local ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..Base64Encode2(ScriptPath)..'&rand='..math.random(99999999)
            local LuaSocket, Socket, Url, Started, File, GotScriptVersion, NewFile, GotScriptUpdate = nil, nil, nil, false, "", false, '', false
            local Receive, Status, Snipped, RecvStarted, RecvStarted, OnlineVersion = nil, nil, nil, false, 0
            local Url = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..Base64Encode2(VersionPath)..'&rand='..math.random(99999999)
            local function CreateSocket2(url)
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
                    Socket:connect(tostring('sx-bol.eu'), 80)
                    Url = url
                    Started = false
                    File = ""
                end
            end
            CreateSocket2(VersionPath)
            AddTickCallback(
                function()
                    if GotScriptVersion then return end
                
                    Receive, Status, Snipped = Socket:receive(1024)
                    if Status == 'timeout' and not Started then
                        Started = true
                        Socket:send("GET "..Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
                    end
                    if (Receive or (#Snipped > 0)) and not RecvStarted then
                        RecvStarted = true
                    end
                
                    File = File .. (Receive or Snipped)
                    if File:find('</s'..'ize>') then
                        if not Size then
                            Size = tonumber(File:sub(File:find('<si'..'ze>') + 6, File:find('</si'..'ze>')-1))
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
                        local HeaderEnd, ContentStart = File:find('<scr'..'ipt>')
                        local ContentEnd, _ = File:find('</sc'..'ript>')
                        if not ContentStart or not ContentEnd then
                        else
                            OnlineVersion = (Base64Decode(File:sub(ContentStart + 1,ContentEnd-1)))
                            if OnlineVersion ~= nil then
                                OnlineVersion = tonumber(OnlineVersion)
                                if OnlineVersion ~= nil and LocalVersion ~= nil and type(OnlineVersion) == "number" and type(LocalVersion) == "number" and OnlineVersion > LocalVersion then
                                    CreateSocket2(ScriptPath)
                                    AddTickCallback(function()
                                        if GotScriptUpdate then return end
                                        Receive, Status, Snipped = Socket:receive(1024)
                                        if Status == 'timeout' and not Started then
                                            Started = true
                                            Socket:send("GET "..Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
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
                                                    local f = io.open(SavePath,"w+b")
                                                    f:write(newf)
                                                    f:close()
                                                end
                                            end
                                            GotScriptUpdate = true
                                        end
                                    end)
                                else

                                end
                            end
                        end
                        GotScriptVersion = true
                    end
                end)
        end, 
    30
)
