--
-- Author: Anthony
-- Date: 2014-12-25 11:20:39
-- Filename: mission_mgr.lua
--
----------------------------------------------------------------
local mission = import(".mission")
----------------------------------------------------------------
local mission_mgr = class("mission_mgr")
----------------------------------------------------------------
function mission_mgr:ctor(player)
	self.__data = {}
    self.player = player
end
----------------------------------------------------------------
--
----------------------------------------
-- 得到所有数据
function mission_mgr:get_data()
    return self.__data
end
----------------------------------------
function mission_mgr:set_data( data )
    table.walk(data, function(v, k)
        self:update(v)
    end)
    -- dump(self.__data)
end
----------------------------------------
function mission_mgr:get_count()
    return table.nums(self.__data)
end
----------------------------------------
function mission_mgr:remove( Id )
    self.__data[Id] = nil
end
----------------------------------------
-- 根据id得到关卡数据
function mission_mgr:get_info(Id)
    local data = self.__data[Id]
    if data then
        return data:get_info()
    end
    return nil
end
----------------------------------------
function mission_mgr:update(newdata)
    -- 添加一条新数据
    self.__data[newdata.Id] = mission.new(newdata)
    -- print("---------update")
    -- dump(self.__data)
end
----------------------------------------------------------------
return mission_mgr
----------------------------------------------------------------