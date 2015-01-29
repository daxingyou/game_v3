--
-- Author: wangshaopei
-- Date: 2014-10-22 17:06:45
-- Filename:
--
------------------------------------------------------------------------------
local conf_science	= require("config.builds.science")
------------------------------------------------------------------------------
local conf_mgr_science = {}
-----------------------------------------
function conf_mgr_science:get_info(data_id)
    return conf_science[data_id]
end
------------------------------------------------------------------------------
return conf_mgr_science