--
-- Author: Anthony
-- Date: 2014-10-22 18:09:26
-- Filename: SC_NewItem.lua
--
local item_operator = require("app.mediator.item.item_operator")

return function ( player, args )
	if args.result == 0 then
		-- printError("create item error! dataid:%d result:%d", args.info.dataId,args.result)
		return
	elseif args.result == 2 then
		return
	end

	item_operator:update(args.info)
	printInfo("SC_NewItem update dataId:%d num:%d",args.info.dataId,args.info.num)
	local name = item_operator:get_conf_info(args.info.dataId).name
	-- KNMsg.getInstance():flashShow(string.format("得到 %s x %d",name,args.num))


end