--
-- Author: Your Name
-- Date: 2014-08-06 10:44:10
--
local configMgr       = require("config.configMgr")         -- 配置
------------------------------------------------------------------------------
local conf_mgr_skills={}
------------------------------------------------------------------------------
function conf_mgr_skills:GetSkillInstanceBySkillId(SkillId)
    assert(SkillId~=nil,"GetSkillInstanceBySkillId() - SkillId is nil")
    local TypeId = SkillId/1000
    local lev = SkillId%1000
    local skillInstanceId = self:GetSkillTemplate(SkillId).instanceId
    local ins = self:GetSkillInstance(skillInstanceId,lev)
    assert(ins~=nil,string.format("GetSkillInstanceBySkillId() - instance is nil skillId = %d",SkillId))
    return ins
end
------------------------------------------------------------------------------
function conf_mgr_skills:GetSkillTemplate(SkillId)
    local TypeId = math.floor(SkillId/1000)
    local conf_skillTemps = require("config.skills.skillTemplate")
    assert(conf_skillTemps[TypeId]~=nil,"GetSkillTemplate failed SkillId = "..SkillId)
    return conf_skillTemps[TypeId][1]
end
------------------------------------------------------------------------------
function conf_mgr_skills:GetSkillInstance(instanceId,lev)
    local conf_skillDatas = require("config.skills.skillData")
    return conf_skillDatas[instanceId][lev]
end

------------------------------------------------------------------------------
function conf_mgr_skills:GetSkillEffect(SkillId)
    assert(SkillId ~= nil,"SkillId == nil")

    local skillInstance = self:GetSkillInstanceBySkillId(SkillId)
    if not skillInstance.skillEffId  then
        return nil
    end
    --local TypeId = math.floor(skillInstance.skillEffId/1000)
    return self:GetSkillEffectByEffectId(skillInstance.skillEffId)
end
function conf_mgr_skills:GetSkillEffectByEffectId(EffectId)
    if not EffectId then
        return nil
    end
    local conf_skillEffects = require("config.skills.skillEffects")
    local conf_skillEffects_ = conf_skillEffects[EffectId]
    assert(conf_skillEffects_~=nil,string.format("GetSkillEffectByEffectId() - SkillEffect is nil,EffectId = %d", EffectId))
    local eff = conf_skillEffects_[1]
    return eff
end
------------------------------------------------------------------------------
function conf_mgr_skills:GetSkillData(SkillId)
    local skillTemp = self:GetSkillTemplate(SkillId)
    local skillIns = self:GetSkillInstanceBySkillId(SkillId)
    local appendImpactRuleData = self:GetSkillAppendImpactIdDatas(SkillId)
    local skillData = {
    type=skillTemp.type,
    logicId=appendImpactRuleData[1].logicId,        -- 技能逻辑Id
    nickname=skillTemp.nickname,
    lev=skillIns.lev,
    iconId=skillTemp.iconId,
    sikllBrief=skillIns.sikllBrief,
    target_condition=skillTemp.target_condition,    -- 攻击目标条件
    atkDistance=skillIns.atkDistance,               -- 攻击距离
}
    return skillData
end
function conf_mgr_skills:GetSkillIcon(SkillId)
    local skillTemp = self:GetSkillTemplate(SkillId)
    local conf_skillIcons = require("config.skills.skillIcon")
    assert(conf_skillIcons[skillTemp.iconId] ~= nil,string.format("GetSkillIcon() - iconid failed,skillId = %d", SkillId))
    return conf_skillIcons[skillTemp.iconId][1]
end
------------------------------------------------------------------------------
--技能效果相关
--取得技能的效果索引列表
function conf_mgr_skills:GetSkillAppendImpactIdDatas(SkillId)
    local skillInstance = self:GetSkillInstanceBySkillId(SkillId)
    local conf_appendImpacts = require("config.skills.appendImpacts")
    return conf_appendImpacts[skillInstance.appendImpactRule]
end
function conf_mgr_skills:GetSkillAppendImpacParams(SkillId)
    local data=self:GetSkillAppendImpactIdDatas(SkillId)
    local paramsLst={}
    for i=1,#data do
        if not paramsLst[i] then
            paramsLst[i]={}
        end
        paramsLst[i][1]=data[i].param1
        paramsLst[i][2]=data[i].param2
        paramsLst[i][3]=data[i].param3
        paramsLst[i][4]=data[i].param4
        paramsLst[i][5]=data[i].param5
        paramsLst[i][6]=data[i].param5
        paramsLst[i][7]=data[i].param5
        paramsLst[i][8]=data[i].param5
        paramsLst[i][9]=data[i].param5
        paramsLst[i][10]=data[i].param5
    end
    return paramsLst
end
function conf_mgr_skills:GetInitDataByType(initValType)
    local conf_initDatas = require("config.skills.initializeData")
    local v = conf_initDatas[initValType]
    if v == nil then
        return 0
    end
    return v[1].value
end
------------------------------------------------------------------------------
return conf_mgr_skills
------------------------------------------------------------------------------