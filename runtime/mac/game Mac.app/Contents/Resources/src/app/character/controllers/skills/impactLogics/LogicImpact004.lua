--
-- Author: wangshaopei
-- Date: 2014-08-22 16:24:16
-- 效果：直接修改值，血量，怒气
local SkillDefine=require("app.character.controllers.skills.SkillDefine")
local CommonDefine = require("app.ac.CommonDefine")
local configMgr       = require("config.configMgr")         -- 配置
local ImpactLogic = import(".ImpactLogic")
local LogicImpact004 = class("LogicImpact004",ImpactLogic)
LogicImpact004.ID=SkillDefine.LogicImpact004
function LogicImpact004:ctor()

end
function LogicImpact004:initFromData(ownImpact,impactData)
    --hp
    local v = configMgr:getConfig("impacts"):GetImpactParamVal(ownImpact:getImpactTypeId(),SkillDefine.ImpactParamL004_Hp)
    local r = configMgr:getConfig("impacts"):GetImpactParamVal(ownImpact:getImpactTypeId(),SkillDefine.ImpactParamL004_HpRate)
    if  v  and  r then
        assert(false,string.format("LogicImpact004:initFromData() - two value don't same,impactId = %d,v = %d, r = %d",
            ownImpact:getImpactTypeId(),v,r))
    end
   ownImpact:setParameterByIndex(SkillDefine.ImpactParamL004_Hp,v)
   ownImpact:setParameterByIndex(SkillDefine.ImpactParamL004_HpRate,r)

   --rage
   local v = configMgr:getConfig("impacts"):GetImpactParamVal(ownImpact:getImpactTypeId(),SkillDefine.ImpactParamL004_Rage)
    local r = configMgr:getConfig("impacts"):GetImpactParamVal(ownImpact:getImpactTypeId(),SkillDefine.ImpactParamL004_RageRate)
    if  v  and  r then
        assert(false,string.format("LogicImpact004:initFromData() - two value don't same,impactId = %d,v = %d, r = %d",
            ownImpact:getImpactTypeId(),v,r))
    end
   ownImpact:setParameterByIndex(SkillDefine.ImpactParamL004_Rage,v)
   ownImpact:setParameterByIndex(SkillDefine.ImpactParamL004_RageRate,r)
    return true
end

function LogicImpact004:onActive(rMe,ownImpact)
    local hp = ownImpact:getParameterByIndex(SkillDefine.ImpactParamL004_Hp)
    if hp then
        rMe:increaseHp(hp)
    end
    local hpRate = ownImpact:getParameterByIndex(SkillDefine.ImpactParamL004_HpRate)
    if hpRate then
        hp = math.floor(rMe:getHp()*hpRate/CommonDefine.RATE_LIMITE)
        rMe:increaseHp(hp)
    end

    local rage = ownImpact:getParameterByIndex(SkillDefine.ImpactParamL004_Rage)
    if rage then
        rMe:increaseRage(rage)
        rMe:getView():createRage(rage)
    end
    local rageRate = ownImpact:getParameterByIndex(SkillDefine.ImpactParamL004_RageRate)
    if rageRate then
        rage = math.floor(rMe:getRage()*rageRate/CommonDefine.RATE_LIMITE)
        rMe:increaseRage(rage)
        rMe:getView():createRage(rage)
    end
end
-------------------------------------------------------------------------------
return LogicImpact004
-------------------------------------------------------------------------------