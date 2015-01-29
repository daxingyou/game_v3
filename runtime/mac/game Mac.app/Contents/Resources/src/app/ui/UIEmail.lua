--
-- Author: wangshaopei
-- Date: 2015-01-08 14:15:24
--
--
local UIButtonCtrl = require("app.ac.ui.UIButtonCtrl")
local UIUtil = require("app.ac.ui.UIUtil")
local configMgr = require("config.configMgr")
local StringData = require("config.zhString")
local item_operator = require("app.mediator.item.item_operator")
local UIListView = require("app.ac.ui.UIListViewCtrl")
------------------------------------------------------------------------------
local UIEmail  = class("UIEmail", require("app.ac.ui.UIBase"))
------------------------------------------------------------------------------
local uiLayerDef =require("app.ac.uiLayerDefine")
UIEmail.DialogID=uiLayerDef.ID_Email
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function UIEmail:ctor(UIManager)
    UIEmail.super.ctor(self,UIManager)
    self._lst_ctrl=nil
end
------------------------------------------------------------------------------
-- 退出
function UIEmail:onExit( )
    UIEmail.super.onExit(self)
end
function UIEmail:onEnter()
    UIEmail.super.onEnter(self)
end
function UIEmail:init( params )
    UIEmail.super.init(self,params)
    -- self._args = params.args
    self._email_list={}
    self._lst_ctrl = UIListView.new(UIHelper:seekWidgetByName(self._root_widget, "ScrollView"))
    self._lst_ctrl:InitialItem()
    self:Listen()

    PLAYER:send("CS_AskInfo",{ type = 6 })

end
function UIEmail:Listen()
    -- local open=UIHelper:seekWidgetByName(self._root_widget,"ButtonOpen")
    -- open:addTouchEventListener(function(sender, eventType)
    --                                     if eventType == self.ccs.TouchEventType.ended then

    --                                 end
    --                             end)

    -- local send=UIHelper:seekWidgetByName(self._root_widget,"ButtonSend")
    -- send:addTouchEventListener(function(sender, eventType)
    --                                     if eventType == self.ccs.TouchEventType.ended then

    --                                         self:AddContent(self._editbox:getText())

    --                                 end
    --                             end)
    -- local bg=UIHelper:seekWidgetByName(self._root_widget,"ImageInputBg")
    -- bg:setEnabled(false)
end


function UIEmail:UpdataData(maillist)
    -- self._lst_ctrl:ClearItem()

    local function get_timestr( time )
        local tab = os.date("*t",time)
        return tab.year.."-"..tab.month.."-"..tab.day
    end

    -- dump(maillist)
    for i,v in ipairs(maillist) do
        self:AddContent(i,{
            sno = v.sno,
            sender_name = v.sender,
            title = v.title,
            date = get_timestr(v.sendtime),
            content = v.content,
            items = v.items,
            money = v.money,
        })
    end
end
function UIEmail:AddContent(i,options)
    -- local count = self._lst_ctrl:getCount()
    local item = self._lst_ctrl:AddItem(i)
    UIHelper:seekWidgetByName(item,"LabelTitle"):setString(options.title)
    UIHelper:seekWidgetByName(item,"LabelTitle"):setColor(display.COLOR_BLACK)
    UIHelper:seekWidgetByName(item,"LabelContent"):setString("发件人："..options.sender_name)
    UIHelper:seekWidgetByName(item,"LabelContent"):setColor(display.COLOR_BLACK)
    UIHelper:seekWidgetByName(item,"LabelDate"):setString(options.date)
    UIHelper:seekWidgetByName(item,"LabelDate"):setColor(display.COLOR_BLACK)
    item:addTouchEventListener(function(sender, eventType)
                                        if eventType == self.ccs.TouchEventType.ended then
                                            self:getUIManager():openUI({uiScript=require("app.ui.UIEmailContent"),
                                            ccsFileName="UI/email_content.json",open_close_effect=true,
                                                params=options})
                                    end
                                end)
end

function UIEmail:ProcessNetResult(params)
    if params.msg_type == "C_UpdataMaillist" then
        self._email_list = params.args
        self:UpdataData(params.args)
    elseif params.msg_type == "C_RecvMail" then
        -- 提取后的处理
        for i,v in ipairs(self._email_list) do
            if v.sno == params.args.sno then
                self._lst_ctrl:DelItem(i,true,true)
                table.remove(self._email_list,i)
                break
            end
        end
    end
end
------------------------------------------------------------------------------
return UIEmail
------------------------------------------------------------------------------