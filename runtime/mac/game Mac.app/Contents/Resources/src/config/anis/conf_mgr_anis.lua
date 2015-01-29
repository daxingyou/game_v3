--
-- Author: wangshaopei
-- Date: 2015-01-08 18:25:22
--
local conf = require("config.anis.anis")
------------------------------------------------------------------------------
local conf_mgr_anis = {}
------------------------------------------------------------------------------
--根据type读取相应的配置文件管理器
function conf_mgr_anis:get_info(data_id)
    local id = math.floor(data_id/100)
    return conf[id][data_id%100]
end
function conf_mgr_anis:load()
    for i,v in ipairs(conf) do
        local data=v[1]
        if data and data.load_mode == 1 then -- 配置导入
            display.addSpriteFrames(data.path1 , data.path2)
             print("succeed load ",data.path2)
        end
    end
end
------------------------------------------------------------------------------
return conf_mgr_anis
------------------------------------------------------------------------------