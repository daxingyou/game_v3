--
-- Author: wangshaopei
-- Date: 2014-10-22 17:06:45
-- Filename:
--
------------------------------------------------------------------------------
local conf_formations	= require("config.formations.formations")
------------------------------------------------------------------------------
local conf_mgr_formations = {}
-----------------------------------------
function conf_mgr_formations:get_info(data_id)
    return conf_formations[data_id]
end
function conf_mgr_formations:get_add_val(info,attr_type)
    -- 最终阵型加成效果=阵型加成百分比*（1+阵型成长系数*阵型等级）
    local conf=conf_formations[info.fId]
    assert(conf~=nil and conf.level_open~=nil,string.format("conf is nil or the formation is not open,fId = %d",info.fId))
    if conf.attr_type == attr_type then
        return conf.add_percent*(1+conf.factor*info.level)
    end
    return 0
end
------------------------------------------------------------------------------
return conf_mgr_formations