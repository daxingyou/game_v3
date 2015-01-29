--
-- Author: Anthony
-- Date: 2015-01-09 16:31:08
-- Filename: SC_MailRet.lua
--
local ui_helper 	= require("app.ac.ui.ui_helper")
return function ( player, args )

	if args.type == 0 then --得到邮件列表

		local st = require("config.zhString")
		local function getstr( str )
			local retstr = {}
			local tmp = string.split(str, "&&")
			for p,u in ipairs(tmp) do
				-- print("···",p,u)
				local temp1 = string.split(u, "#")
				for i,v in ipairs(temp1) do
					if  i == 1 then
						table.insert(retstr,v or "")
					else
						local tempstr = string.split(v, "|")
						for j,k in ipairs(tempstr) do
							table.insert(retstr,st[tonumber(k)])
						end
					end
				end
			end
			return table.concat(retstr)
		end

		local mail_list = {}
		for i,v in ipairs(args.maillist) do
			local sender
			if v.mailtype == 1 then
				sender = st[100100002]
			else
				sender = v.sender
			end
			mail_list[#mail_list+1] = {
				sno = v.sno,
				mailtype = v.mailtype,
				sender = sender,
				sendtime = v.sendtime,
				title = getstr(v.title),
				content = getstr(v.content),

				money = v.money,
				RMB = v.RMB,
				items = v.items,
			}
		end
		-- dump(mail_list)
		ui_helper:dispatch_event({msg_type="C_UpdataMaillist",args=mail_list})
	elseif args.type == 1 then -- 收取邮件
		ui_helper:dispatch_event({msg_type="C_RecvMail",args={sno=args.param}})
	elseif args.type == 2 then -- 通知新邮件，用来显示小红点
		ui_helper:dispatch_event({msg_type="C_NotifyMail",args={count=args.param}})
	end

end