--
-- Author: Anthony
-- Date: 2014-12-02 11:45:26
-- Filename: SC_UpdateHeroEquip.lua
--
return function ( player, args )
	-- print("···",args.hero_dataId)
	player:get_mgr("hero"):update_equip(args.hero_dataId,args.equip)
end