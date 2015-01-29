--
-- Author: Anthony
-- Date: 2014-12-03 15:44:16
-- Filename: material_mgr.lua
--
----------------------------------------------------------------
local material = import(".material")
----------------------------------------------------------------
local material_mgr = class("material_mgr")
----------------------------------------------------------------
function material_mgr:ctor(player)
	self.__data = {}
    self.player = player
end
----------------------------------------------------------------
--
----------------------------------------
-- 得到所有数据
function material_mgr:get_data()
    return self.__data
end
----------------------------------------
function material_mgr:set_data( data )
    table.walk(data, function(v, k)
        self:update(v)
    end)

    -- print("---------set_items")
    -- dump(self.__data)
end
----------------------------------------
function material_mgr:get_count()
    return table.nums(self.__data)
end
----------------------------------------
function material_mgr:remove( dataId )
    self.__data[dataId] = nil
end
----------------------------------------
-- 根据dataId得到hero
function material_mgr:get_info(dataId)
    local data = self.__data[dataId]
    if data then
        return data:get_info()
    end
    return nil
end
----------------------------------------
function material_mgr:update(newdata)
    -- 添加一条新数据
    self.__data[newdata.dataId] = material.new(newdata)
    -- print("---------update")
    -- dump(self.__data)
end
----------------------------------------------------------------
return material_mgr
----------------------------------------------------------------