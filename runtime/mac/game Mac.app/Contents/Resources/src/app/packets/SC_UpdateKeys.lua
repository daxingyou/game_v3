--
-- Author: Anthony
-- Date: 2014-12-04 14:39:55
-- Filename: SC_UpdateKeys.lua
--
--[[
		hero_dataId
		kvs
			key
			value
]]
----------------------------------------------------------------
local ui_helper 	= require("app.ac.ui.ui_helper")
----------------------------------------------------------------
return function ( player, args )
	-- print("SC_UpdateKeys",args.hero_dataId)
	if args.hero_dataId > 0 then
		local hero = player:get_mgr("hero"):get_hero(args.hero_dataId)
		for i,v in ipairs(args.kvs) do
			-- print(i,v.key,v.value)
			-- if hero:get( v.key ) ~= v.value then
				hero:setkey(v.key,v.value)
			-- end
		end
	else
		-- 玩家属性
		for i,v in ipairs(args.kvs) do
			-- print("..",i,v.key,v.value)
			player:set_basedata(v.key, v.value)
		end
		-- 更新人物信息
		ui_helper:dispatch_event({msg_type = "C_UpdataHeroInfo"})
	end

end