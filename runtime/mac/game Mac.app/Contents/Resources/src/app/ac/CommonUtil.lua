--
-- Author: wangshaopei
-- Date: 2014-10-29 22:02:55
--
local StringData = require("config.zhString")
local CommonUtil = {}
-- item attribute index map
-- 映射game_attr.lua 的属性
-- 根据这个顺去可以从 zhString.lua（800000101） 读出属性名称
function CommonUtil:GetItemAttrIndexMap()
    local attr_map = {
        -- 一级属性
        "Con"    ,      -- 体质
        "Captain" ,      -- 统帅
        "Str"  ,     -- 力量
        "Int"    ,     -- 智力
        "Cha"   ,        -- 魅力
        "Speed",    -- 攻击速度
        -- 二级属性
        "Hit"    ,      -- 命中率
        "Evd"   ,       -- 闪避率
        "Crt"    ,       -- 暴击率
        "Crtdef"  ,    -- 抗暴击率
        "DecDef"  , -- 破防伤害
        "DecDefRed", -- 破防伤害减免

        "MaxRage"    ,    -- 最大怒气
        "MaxHP"     ,  -- 最大hp
        "MaxMP"     ,  -- 最大mp
        "PhysicsAtk" , -- 物理攻击力
        "PhysicsDef"  , -- 物理防御力
        "MagicAtk"    ,   -- 魔法攻击力
        "MagicDef"   ,   -- 魔法防御力
        "TacticsAtk" , -- 战法攻击力
        "TacticsDef"  , -- 战法防御力
    }
    return attr_map
end
function CommonUtil:GetItemAttrName(index)
    local arrt_name =self:GetItemAttrIndexMap()
    return arrt_name[index]
end
function CommonUtil:GetItemAttrNameText(index)
    return StringData[800000100+index]
end
-- 技能目标条件
function CommonUtil:ToTargetConditions(target_conditions_,obj_type_val)
    local obj_type_ = "hero"
    if obj_type_val == 2 then
        obj_type_ = "build"
    elseif obj_type_val == 3 then
        obj_type_ = "all"
    end

    local t = {
        num=nil,            -- 数量
        atk_dis=nil,        -- 距离
        is_oppose=nil,      -- 是否包含对立方
        is_team=nil,        -- 是否包含队友
        is_self=nil,        -- 是否包含自己
        obj_type=obj_type_,    --
    }
    local conditions = target_conditions_
    t.num=conditions[1]
    if conditions[2]==1 then
        t.is_oppose=true
    end
    if conditions[3]==1 then
        t.is_team=true
    end
    if conditions[4]==1 then
        t.is_self=true
    end
    return t
end
-- c3b 转 十进制
function CommonUtil:C3bToInt(c3b)
    local str=string.format("0x%02x%02x%02x",c3b.r,c3b.g,c3b.b)
    return tonumber(str,16)
end
function CommonUtil:HexToInt(hex)
    return tonumber(hex,16)
end
--[[解析16进制颜色rgb值]]
function  CommonUtil:GetHexToC3b(hex)
    if string.len(hex) == 6 then
        local tmp = {}
        for i = 0,5 do
            local str =  string.sub(hex,i+1,i+1)
            if(str >= '0' and str <= '9') then
                tmp[6-i] = str - '0'
            elseif(str == 'A' or str == 'a') then
                tmp[6-i] = 10
            elseif(str == 'B' or str == 'b') then
                tmp[6-i] = 11
            elseif(str == 'C' or str == 'c') then
                tmp[6-i] = 12
            elseif(str == 'D' or str == 'd') then
                tmp[6-i] = 13
            elseif(str == 'E' or str == 'e') then
                tmp[6-i] = 14
            elseif(str == 'F' or str == 'f') then
                tmp[6-i] = 15
            else
                print("Wrong color value.")
                tmp[6-i] = 0
            end
        end
        local r = tmp[6] * 16 + tmp[5]
        local g = tmp[4] * 16 + tmp[3]
        local b = tmp[2] * 16 + tmp[1]
        return cc.c3b(r,g,b)
    end
    return cc.c3b(255,255,255)
end
function CommonUtil:NewGraySprite(file_name)
    local __curFilter = {"GRAY",{0.2, 0.3, 0.5, 0.1}}
    local __filters, __params = unpack(__curFilter)
    if __params and #__params == 0 then
        __params = nil
    end
    return display.newFilteredSprite(file_name, __filters, __params)
end
--------------------------------------------------------
return CommonUtil
--------------------------------------------------------