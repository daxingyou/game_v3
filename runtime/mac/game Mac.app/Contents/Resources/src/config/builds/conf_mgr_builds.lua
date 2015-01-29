--
-- Author: wangshaopei
-- Date: 2015-01-08 18:25:22
--
------------------------------------------------------------------------------
local conf_mgr_builds = {}
------------------------------------------------------------------------------
--根据type读取相应的配置文件管理器
function conf_mgr_builds:get_info(data_id)
    local conf = nil
    if 1 == math.floor(data_id/1000) then -- 科技
         conf = require("config.builds.conf_mgr_science")
    end
    if conf == nil then
        return nil
    end
    return conf:get_info(data_id)
end
function conf_mgr_builds:get_add_val(data_id,level)
    local conf = self:get_info(data_id)
    local add_val = math.round(conf.base_val*(1+level*conf.factor))
    return add_val
end
------------------------------------------------------------------------------
return conf_mgr_builds
------------------------------------------------------------------------------