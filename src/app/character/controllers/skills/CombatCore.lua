--
-- Author: wangshaopei
-- Date: 2014-08-25 11:57:13
--

local CommonDefine = require("app.ac.CommonDefine")
local ImpactLogic003 = import(".impactLogics.LogicImpact003")
local conf_mgr_builds = require("config.builds.conf_mgr_builds")
local conf_mgr_formations = require("config.formations.conf_mgr_formations")
local CombatCore = class("CombatCore")

function CombatCore:ctor()
    self._add_atk_phy=0
    self._add_def_phy=0
    self._add_atk_magic=0
    self._add_def_magic=0
    self._add_atk_tactics=0
    self._add_def_tactics=0
end
--------------------------------------------------------------------
--
function CombatCore:getResultImpact(rAttacker,rDefender,ownImpact)
    -- 逻辑id为003的伤害计算
    local impLogic=ImpactLogic003.new()

    --
    self._add_atk_phy = impLogic:getDamagePhy(ownImpact)
    self._add_atk_magic = impLogic:getDamageMagic(ownImpact)
    self._add_atk_tactics = impLogic:getDamageTactics(ownImpact)
    -- 物理伤害
    local damage=self:CalcPhyDamage(rAttacker, rDefender, self._add_atk_phy, self._add_def_phy)
    if damage  ~= nil then
        impLogic:setDamagePhy(ownImpact, math.round(damage))
    end

    -- 战法伤害
     damage=self:CalcMagicDamage(rAttacker, rDefender, self._add_atk_magic, self._add_def_magic)
    if damage  ~= nil then
        impLogic:setDamageMagic(ownImpact, math.round(damage))
    end

    -- 计策伤害
     damage=self:CalcTacticsDamage(rAttacker, rDefender, self._add_atk_tactics,self._add_def_tactics)
    if damage  ~= nil then
        impLogic:setDamageTactics(ownImpact, math.round(damage))
    end

    return damage
end
--------------------------------------------------------------------
-- 普通伤害计算
function CombatCore:CalcPhyDamage(atk_obj,def_obj,add_atk_phy,add_def_atk)
    if add_atk_phy ==-1 or add_atk_phy==0 or add_atk_phy == nil then
        return nil
    end
     -- 攻方科技加成物攻属性
    local science_phy_atk_level=0
    local science_akt_phy_akt_add_val = conf_mgr_builds:get_add_val(1001,science_phy_atk_level)
    -- 防方科技加成物防属性
    local science_phy_def_level=0
    local science_def_phy_def_add_val = conf_mgr_builds:get_add_val(1002,science_phy_def_level)

    local r1 = ((atk_obj:getAttackPhysics()+science_akt_phy_akt_add_val) * (atk_obj.attr_.Captain * 0.005 + 1)
        - (def_obj:getDefensePhysice()+science_def_phy_def_add_val) *(def_obj.attr_.Captain * 0.005 + 1))
    --
    local ratio = def_obj.arm_.PhysicsAtkRatio
    assert(ratio~=0,"CalcPhyDamage() - the dinominetor is not zero")
    local r2 = atk_obj.arm_.PhysicsAtkRatio/def_obj.arm_.PhysicsAtkRatio
    --
    local r3 = (atk_obj.attr_.Captain/def_obj.attr_.Captain)
    --
    -- 1 = MapConstants.PLAYER_CAMP
    local battle_info_atk = atk_obj:getMap().battle_info[1]
    local v3 = conf_mgr_formations:get_add_val(battle_info_atk,1) -- 攻方阵法物攻加成
    local battle_info_def = atk_obj:getMap().battle_info[2]
    local v4 = conf_mgr_formations:get_add_val(battle_info_def,2) -- 防方阵法物防加成
    local r4 = (1+v3)*(1-v4)

    local damage = math.floor(add_atk_phy*r1*r2*r3*r4)
    if damage<0 then
        damage=0
    end
    -- print("···g",damage)
    return damage
end
-- 战法伤害计算
function CombatCore:CalcMagicDamage(atk_obj,def_obj,add_atk_magic,add_def_magic)
    if add_atk_magic ==-1 or add_atk_magic == 0 or add_atk_magic == nil then
        return nil
    end
    -- 最终加成属性值=round（基础值*（1+科技等级*成长系数））

    -- 攻方科技加成战攻属性
    local science_magic_atk_level=0
    local science_akt_magic_akt_add_val = conf_mgr_builds:get_add_val(1003,science_magic_atk_level)
    -- 防方科技加成战防属性
    local science_magic_def_level=0
    local science_def_magic_def_add_val = conf_mgr_builds:get_add_val(1004,science_magic_def_level)

    --
    local r1 = (100+(atk_obj:getAttackMagic()+science_akt_magic_akt_add_val))/(100+def_obj:getDefenseMagic()+science_def_magic_def_add_val)
    --
    local ratio = def_obj.arm_.MagicAtkRatio
    assert(ratio~=0,"CalcMagicDamage() - the dinominetor is not zero")
    local r2 = atk_obj.arm_.MagicAtkRatio/ratio
    --
    local r3 = (atk_obj.attr_.Str/def_obj.attr_.Str)

    -- 1 = MapConstants.PLAYER_CAMP
    local battle_info_atk = atk_obj:getMap().battle_info[1]
    local v3 = conf_mgr_formations:get_add_val(battle_info_atk,3) -- 攻方阵法战攻加成
    local battle_info_def = atk_obj:getMap().battle_info[2]
    local v4 = conf_mgr_formations:get_add_val(battle_info_def,4) -- 防方阵法战防加成
    local r4 = (1+v3)*(1-v4)
    local damage = add_atk_magic*r1*r2*r3*r4
    if damage<0 then
        damage=0
    end
    return damage
end
-- 计策伤害计算
function CombatCore:CalcTacticsDamage(atk_obj,def_obj,add_atk_tactics,add_def_tactics)
    if add_atk_tactics ==-1 or add_atk_tactics == 0 or add_atk_tactics == nil then
        return nil
    end
    -- 攻方科技加成战攻属性
    local science_tactics_atk_level=0
    local science_akt_tactics_akt_add_val = conf_mgr_builds:get_add_val(1005,science_tactics_atk_level)
    -- 防方科技加成战防属性
    local science_tactics_def_level=0
    local science_def_tactics_def_add_val = conf_mgr_builds:get_add_val(1006,science_tactics_def_level)
    --
    local r1 = (100+(atk_obj:getAttackTactics()+science_tactics_atk_level))/(100+(def_obj:getDefenseTactics()+science_tactics_def_level))
    --
    local ratio = def_obj.arm_.TacticsDefRatio
    assert(ratio~=0,"CalcTacticsDamage() - the dinominetor is not zero")
    local r2 = atk_obj.arm_.TacticsAtkRatio/ratio
    --
    local r3 = (atk_obj.attr_.Int/def_obj.attr_.Int)
    --
    -- 1 = MapConstants.PLAYER_CAMP
    local battle_info_atk = atk_obj:getMap().battle_info[1]
    local v3 = conf_mgr_formations:get_add_val(battle_info_atk,5) -- 攻方阵法战攻加成
    local battle_info_def = atk_obj:getMap().battle_info[2]
    local v4 = conf_mgr_formations:get_add_val(battle_info_def,6) -- 防方阵法战防加成
    local r4 = (1+v3)*(1-v4)
    local damage = add_atk_tactics*r1*r2*r3*r4
    if damage<0 then
        damage=0
    end
    return damage
end
--------------------------------------------------------------------
--
-- function CombatCore:physicalDamage(rMe,rTar,addAttack,addDefence)
--     local damage = 0
--     --物理攻击
--     local attack = rMe:getAttackPhysics()+addAttack
--     --物理防御
--     local defence= rTar:getDefensePhysice()+addDefence
--     --抵消物理攻击百分比
--     local ignoreRate = 0

--     damage=attack-defence

--     if damage<0 then
--         damage=0
--     end

--     return damage
-- end
--------------------------------------------------------------------
--命中相关
function CombatCore:isHit(hitRate,rand)
    if hitRate<0 then
        hitRate=0
    elseif hitRate>CommonDefine.RATE_LIMITE_100 then
        hitRate=CommonDefine.RATE_LIMITE_100
    end
    if hitRate>rand then
        return true
    end
    return false
end
-- 命中率
function CombatCore:calcHitRate(hit,miss)
    if hit + miss == 0 then
        return 0
    end
    return math.floor(hit/(hit+miss))
end
--------------------------------------------------------------------
-- 真实暴击率
function CombatCore:calcCrtRate(crt,crt_factor,crtdef,crtdef_factor)
    local crt_rate=self:_calcCrtRate(crt,crt_factor)
    local crtdef_rate=self:calcCrtdef(crtdef,crtdef_factor)
    local ret = crt_rate * ( 1 - crtdef_rate )
    return ret
end
-- 暴击率
function CombatCore:_calcCrtRate(crt,crt_factor)
    return crt*(crt_factor/100)
end
-- 抗暴击率
function CombatCore:calcCrtdef(crtdef,crtdef_factor)
    return crtdef*(crtdef_factor/100)
end
function CombatCore:isCrtHit(hitRate,rand)
    if hitRate<0 then
        hitRate=0
    elseif hitRate>CommonDefine.RATE_LIMITE_100 then
        hitRate=CommonDefine.RATE_LIMITE_100
    end
    if hitRate>rand then
        return true
    end
    return false
end
--------------------------------------------------------------------
return CombatCore
--------------------------------------------------------------------