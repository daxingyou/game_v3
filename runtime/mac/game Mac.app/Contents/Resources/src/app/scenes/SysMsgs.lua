--
-- Author: wangshaopei
-- Date: 2015-01-14 16:24:53
--
local item_operator = require("app.mediator.item.item_operator")
local StringData = require("config.zhString")
local CommonDefine = require("app.ac.CommonDefine")
local item_helper = require("app.mediator.item.item_helper")
local CommonUtil = require("app.ac.CommonUtil")
local SysMsgs = class("SysMsg")
------------------------------------------------------------------------------
function SysMsgs:ctor()
    self._msgs={}
    self._msgs["hint"]={}           -- 提示
    self._msgs["bulletin"]={}       -- 公告
end
function SysMsgs:AddMsgHint(type,options)
    local content_ = ""
    local fmt = ""
    if type == 1 then -- 获得物品
        -- fmt = "获得: %s x %d"
        fmt=StringData[100110001]
        if options.money and options.money > 0 then
            content_=string.format(fmt,28,CommonDefine.C3b.green,"金币" ,
                CommonDefine.C3b.light_yeallow,options.money)
        end
        if options.Id then
            local conf_need_item = item_operator:get_conf_mgr(options.Id)
            local conf_data = conf_need_item:get_info(options.Id)
            content_=string.format(fmt,28,item_helper.get_quality_col_hex(options.Id),conf_data.name ,
                CommonDefine.C3b.light_yeallow,options.count)
        end
    end
    table.insert(self._msgs["hint"],{content=content_})
end
function SysMsgs:AddMsgBulletin(type,options)
    local content_ = ""
    local fmt =StringData[100110002]
    if type == 0 then -- 系统提示
        content_=string.format(fmt,CommonDefine.C3b.red,options.content)
    end
    table.insert(self._msgs["bulletin"],{content=content_})
end
function SysMsgs:GetMsg(index,msg_name)
    return self._msgs[msg_name][index]
end
function SysMsgs:DelMsg(index,msg_name)
    -- assert(#self._msgs>=index)
    table.remove(self._msgs[msg_name],index)
end
return SysMsgs