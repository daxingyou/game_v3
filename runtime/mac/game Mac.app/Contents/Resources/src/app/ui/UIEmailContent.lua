--
-- Author: wangshaopei
-- Date: 2015-01-08 14:15:48
--
--
local UIButtonCtrl = require("app.ac.ui.UIButtonCtrl")
local UIUtil = require("app.ac.ui.UIUtil")
local configMgr = require("config.configMgr")
local StringData = require("config.zhString")
local item_operator = require("app.mediator.item.item_operator")
local UIListView = require("app.ac.ui.UIListViewCtrl")
------------------------------------------------------------------------------
local UIEmailContent  = class("UIEmailContent", require("app.ac.ui.UIBase"))
------------------------------------------------------------------------------
local uiLayerDef =require("app.ac.uiLayerDefine")
UIEmailContent.DialogID=uiLayerDef.ID_EmailContent
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function UIEmailContent:ctor(UIManager)
    UIEmailContent.super.ctor(self,UIManager)
    self._lst_ctrl=nil
end
------------------------------------------------------------------------------
-- 退出
function UIEmailContent:onExit( )
    UIEmailContent.super.onExit(self)
end
function UIEmailContent:onEnter()
    UIEmailContent.super.onEnter(self)
end
function UIEmailContent:init( params )
    UIEmailContent.super.init(self,params)
    self.params = params.params
    self._lst_ctrl = UIListView.new(UIHelper:seekWidgetByName(self._root_widget, "ScrollView"))
    self._lst_ctrl:InitialItem()
    self:Listen()
    self:UpdataData()

end
function UIEmailContent:Listen()
    local extract=UIHelper:seekWidgetByName(self._root_widget,"ButtonExtract")
    extract:addTouchEventListener(function(sender, eventType)
                                    if eventType == self.ccs.TouchEventType.ended then
                                        PLAYER:send("CS_AskInfo",{ type = 7,param = self.params.sno })
                                    end
                                end)

    -- local send=UIHelper:seekWidgetByName(self._root_widget,"ButtonSend")
    -- send:addTouchEventListener(function(sender, eventType)
    --                                     if eventType == self.ccs.TouchEventType.ended then

    --                                         self:AddContent(self._editbox:getText())

    --                                 end
    --                             end)
    -- local bg=UIHelper:seekWidgetByName(self._root_widget,"ImageInputBg")
    -- bg:setEnabled(false)
end
function UIEmailContent:UpdataData()
    local count = 1
    local content=UIHelper:seekWidgetByName(self._root_widget,"LabelContent")
    content:setString(self.params.content)
    content:setColor(display.COLOR_BLACK)
    if self.params.money and self.params.money > 0 then
        local item_ctrl =self._lst_ctrl:AddItem(count)
        item_ctrl:getChildByName("LabelName"):setString(string.format("%s x %d",
            "金币" ,self.params.money))
        item_ctrl:getChildByName("LabelName"):setColor(display.COLOR_BLACK)
        count=count+1
    end
    for i=1,#self.params.items do
        local item=self.params.items[i]
        local item_ctrl =self._lst_ctrl:AddItem(count)
        local conf_need_item = item_operator:get_conf_mgr(item.Id)
        local icon = conf_need_item:get_icon(item.Id)
        item_ctrl:getChildByName("LabelName"):setString(string.format("%s x %d",
            conf_need_item:get_info(item.Id).name ,item.count))
        item_ctrl:getChildByName("LabelName"):setColor(display.COLOR_BLACK)
        UIHelper:seekWidgetByName(item_ctrl,"Item"):loadTexture(icon)
        count=count+1
    end
end

function UIEmailContent:ProcessNetResult(params)
    if params.msg_type == "C_RecvMail" then
            -- self:UpdataData()
            -- print("UIEmailContent",params.args.sno)
            if self.params.money and self.params.money > 0 then
                G_SysMsgs:AddMsgHint(1,{money=self.params.money})
            end
            for i=1,#self.params.items do
                local item=self.params.items[i]
                G_SysMsgs:AddMsgHint(1,{Id=item.Id,count=item.count})
            end
            self:close()
    end
end
------------------------------------------------------------------------------
return UIEmailContent
------------------------------------------------------------------------------