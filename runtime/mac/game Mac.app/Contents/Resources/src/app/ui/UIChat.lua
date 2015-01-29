--
-- Author: wangshaopei
-- Date: 2014-12-11 14:29:57
--
local UIButtonCtrl = require("app.ac.ui.UIButtonCtrl")
local UIUtil = require("app.ac.ui.UIUtil")
local configMgr = require("config.configMgr")
local StringData = require("config.zhString")
local item_operator = require("app.mediator.item.item_operator")
local UIListView = require("app.ac.ui.UIListViewCtrl")
local RichLabelEx = require("app.ac.ui.RichLabelEx")
local CommonUtil = require("app.ac.CommonUtil")
local CommonDefine = require("app.ac.CommonDefine")
------------------------------------------------------------------------------
local UIChat  = class("UIChat", require("app.ac.ui.UIBase"))
------------------------------------------------------------------------------
local uiLayerDef =require("app.ac.uiLayerDefine")
UIChat.DialogID=uiLayerDef.ID_Chat
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function UIChat:ctor(UIManager)
    UIChat.super.ctor(self,UIManager)
    self._lst_ctrl=nil
    self._content={}
    self._btn_chl={}
    self._chl_datas={}
    self._cur_chl_data=nil
    self._old_rc=nil
    self._sel_chat_id=nil -- 选择聊天对象id
end
------------------------------------------------------------------------------
-- 退出
function UIChat:onExit()
    UIChat.super.onExit(self)
end
function UIChat:onEnter()
    UIChat.super.onEnter(self)
end
function UIChat:init( params )
    UIChat.super.init(self,params)
    self._args = params.args
    self._is_open=true
    self._editbox = nil
    self._label_name=nil
    -- self._lst_ctrl = UIListView.new(UIHelper:seekWidgetByName(self._root_widget, "ScrollView"))
    -- self._lst_ctrl:InitialItem()
    self._lst_ctrl=UIHelper:seekWidgetByName(self._root_widget, "ListView")
    self._lst_ctrl:setDirection(ccui.ScrollViewDir.vertical)
    self._lst_ctrl:setBounceEnabled(true)
    self._lst_ctrl:setContentSize(cc.size(746,433))
    self._lst_ctrl:requestRefreshView()
    -- self._tmp_item=GUIReader:shareReader():widgetFromJsonFile("UI/chat_item.json")
    -- set all items layout gravity
    self._lst_ctrl:setGravity(ccui.ListViewGravity.centerVertical)

    --set items margin
    -- self._lst_ctrl:setItemsMargin(2.0)
    local tmp_btn_chl=UIHelper:seekWidgetByName(self._root_widget, "ButtonChl")
    local tmp_list_view = UIHelper:seekWidgetByName(self._root_widget, "ListView")
    for i=1,3 do
        if not self._chl_datas[i] then
            self._chl_datas[i]={content={},btn_title=nil,list_view=nil,chl_id=i,sender_name=nil}
        end
        local btn = tmp_btn_chl:clone()
        btn:setTitleColor(display.COLOR_WHITE)
        local chl_name = "世界"
        if i==2 then
            chl_name = "国家"
        elseif i==3 then
            chl_name = "私人"
            -- btn:setTitleColor(CommonUtil:GetHexToC3b(CommonDefine.C3b.purple))
        end
        btn:setTitleText(chl_name)
        self._chl_datas[i].btn_title=UIButtonCtrl.new(btn)
        tmp_btn_chl:getParent():addChild(self._chl_datas[i].btn_title:GetCtrl())
        self._chl_datas[i].btn_title:GetCtrl():setPositionX(tmp_btn_chl:getPositionX()+(i-1)*tmp_btn_chl:getContentSize().width)
        self._chl_datas[i].list_view=tmp_list_view:clone()
        tmp_list_view:getParent():addChild(self._chl_datas[i].list_view)

    end
    tmp_btn_chl:removeSelf()
    tmp_list_view:removeSelf()
    --
    local bg=UIHelper:seekWidgetByName(self._root_widget,"ImageInputBg")
    self._bg_input = bg
    self._old_rc=cc.rect(bg:getPositionX()-bg:getContentSize().width/2,bg:getPositionY(),
    bg:getContentSize().width,bg:getContentSize().height)
    bg:setVisible(false)
    self._label_name=UIHelper:seekWidgetByName(self._root_widget,"LabelName")
    self._label_name:setVisible(false)
    --
    self:Listen()
    self:UpdataData()
    self:Activate()
    self:ChangeChl(1,{})
end
function UIChat:ChangeChl(chl_id,options)
    if self._cur_chl_data and self._cur_chl_data.chl_id == chl_id then
        return
    end
    for i=1,#self._chl_datas do
        local chl=self._chl_datas[i]
        chl.list_view:setVisible(false)
        chl.btn_title:SetDisable(true,true)
    end
    if chl_id == 3 then
        self._editbox:setPositionX(self._old_rc.x+130)
        self._editbox:setContentSize(cc.size(self._old_rc.width-130,self._old_rc.height))
        self._label_name:setVisible(true)
        self._label_name:setString(options.target_name or "请选择目标对象")
    elseif self._cur_chl_data and self._cur_chl_data.chl_id==3 then
        self._editbox:setPositionX(self._old_rc.x)
        self._editbox:setContentSize(cc.size(self._old_rc.width,self._old_rc.height))
        self._label_name:setVisible(false)
    end
    local chl=self._chl_datas[chl_id]
    chl.list_view:setVisible(true)
    chl.btn_title:SetDisable(false)
    self._cur_chl_data=chl
end
function UIChat:Listen()
    for i=1,#self._chl_datas do
        local btn=self._chl_datas[i].btn_title:GetCtrl()
        btn:addTouchEventListener(function(sender, eventType)
                                            if eventType == self.ccs.TouchEventType.ended then
                                                self._sel_chat_id=nil
                                                self:ChangeChl(i,{})
                                        end
                                    end)
    end
    local open=UIHelper:seekWidgetByName(self._root_widget,"ButtonOpen")
    open:addTouchEventListener(function(sender, eventType)
                                        if eventType == self.ccs.TouchEventType.ended then
                                            self:Activate()
                                    end
                                end)

    local send=UIHelper:seekWidgetByName(self._root_widget,"ButtonSend")
    send:addTouchEventListener(function(sender, eventType)
                                        if eventType == self.ccs.TouchEventType.ended then

                                            local options = {
                                                    channel_id=self._cur_chl_data.chl_id ,-- 世界频道
                                                    content=self._editbox:getText(),
                                                    -- content="1\n2",
                                                    date=os.date("%H:%M"),
                                                    sender_name="我是发送者",
                                                    target_name="我是目标",
                                                    sender_icon="",
                                                    font_size=28,
                                            }
                                            if self._cur_chl_data.chl_id==3 and not self._sel_chat_id then
                                                return
                                            end
                                            self:AddContent(options)
                                            local s= self._editbox:getText()
                                            local head=string.sub(s,1,2)
                                            if head == "!!" then
                                                local content_=string.sub(s,3)
                                                local arr = string.split(content_," ")

                                                PLAYER:send("CS_Command",{
                                                     content = table.concat(arr," ")
                                                })
                                                -- if arr[2] == "createitem" then
                                                --     for i=3,#arr do
                                                --         PLAYER:send("CS_Command",{
                                                --             content = "createitem "..arr[i]
                                                --         })
                                                --     end
                                                -- end
                                                -- print("···",arr[1],arr[2],arr[3])
                                                -- PLAYER:send("CS_Command",{
                                                --      content = arr[2].." "..arr[3]
                                                -- })
                                            end
                                    end
                                end)
    -- local function textFieldEvent(sender, eventType)
    --     if eventType == ccui.TextFiledEventType.attach_with_ime then
    --         local textField = sender

    --     elseif eventType == ccui.TextFiledEventType.detach_with_ime then
    --         local textField = sender
    --         print("···1")
    --     elseif eventType == ccui.TextFiledEventType.insert_text then
    --         print("···2")
    --     elseif eventType == ccui.TextFiledEventType.delete_backward then
    --         print("···3")
    --     end
    -- end
    -- local textField = UIHelper:seekWidgetByName(self._root_widget,"TextFieldInput")
    -- textField:setPlaceHolder("input words here")
    -- textField:addEventListener(textFieldEvent)

    local function onEdit(event, editbox)
        if event == "began" then
            -- 开始输入
            print("began")
        elseif event == "changed" then
            -- 输入框内容发生变化
            -- print("changed:"..editbox:getText())
        elseif event == "ended" then
            -- 输入结束
            print("ended")
        elseif event == "return" then
            -- 从输入框返回
            print("return")
        end
    end
    local editbox = ui.newEditBox({
        image = "UI/chat/chat_input_2.png",
        listener = onEdit,
        size = self._bg_input:getContentSize()
    })
    self:GetTouchGroup():addChild(editbox,1)
    editbox:setFontName("Paint Boy" )
    editbox:setFontSize(28)
    editbox:setFontColor(display.COLOR_RED)
    editbox:setPlaceHolder("输入文字")
    editbox:setMaxLength(256)
    editbox:setAnchorPoint(cc.p(0,0.5))
    editbox:setPositionX(-self._bg_input:getContentSize().width)
    self._editbox=editbox
-------
end
function UIChat:Activate()

    if self._is_open then
        self:setPosition(-self._root_widget:getContentSize().width+68, 0)
        local pos=self._bg_input:getParent():convertToWorldSpace(cc.p(self._old_rc.x,self._old_rc.y))
        self._editbox:setPosition(cc.p(pos.x-self._root_widget:getContentSize().width+68,pos.y))
        self._is_open=false
    else
        self:setPosition(0, 0)
        local pos=self._bg_input:getParent():convertToWorldSpace(cc.p(self._old_rc.x,self._old_rc.y))
        self._editbox:setPosition(pos)
        self._is_open=true
    end
end
-- function UIChat:AddContent(content)
--     local item = nil
--     self._content[#self._content+1]=content
--     if #self._content > 1 then
--         item=self._lst_ctrl:AddItem(#self._content+1)
--     else
--         item=self._lst_ctrl:AddItem(1)
--     end
--     item:getChildByName("LabelContent"):setString(content)

-- end
function UIChat:AddContent(options)
    local item = nil
    local height = 0
    local _content = self._cur_chl_data.content
    _content[#_content+1]=options.content
    self._cur_chl_data.sender_name=options.sender_name
    item=GUIReader:shareReader():widgetFromJsonFile("UI/chat_item.json")
    local lst_ctrl=self._cur_chl_data.list_view
    -- item=self._tmp_item:clone()
    --
    local img_line = item:getChildByName("ImageLine")
    local lable_date = item:getChildByName("LabelDate")
    lable_date:setString(options.date)
    --
    local img_head = item:getChildByName("ImageHead")
    --
    local sender_title=string.format(StringData[100210002],options.sender_name)
    if options.channel_id == 3 then
        sender_title = string.format(StringData[100210001],options.sender_name,
            CommonDefine.C3b.purple,options.target_name)
        -- label_name:setString(options.sender_name)
        -- label_name:setTextColor(cc.c4b(0,255,255,255))
    end
    local label_name=RichLabelEx:create(sender_title,item:getChildByName("LabelName"),
        {is_ignore_adapt_size=true}).rich_text


    height = height + label_name:getContentSize().height
    -- 创建富文本
    local rich=RichLabelEx:create(string.format(StringData[100210003], options.content),item:getChildByName("LabelContent"),
        {is_ignore_adapt_size=true})
    local rich_text = rich.rich_text
    local lable_max_width = lst_ctrl:getContentSize().width-rich_text:getPositionX()
    local y= math.floor(rich_text:getContentSize().width / lable_max_width)
    local y_ = rich_text:getContentSize().width % lable_max_width
    if y_ > 0 then
        y = y + 1
    end
    local w,h = lable_max_width,y *  options.font_size + 8--label:getFontSize()
    rich_text:ignoreContentAdaptWithSize(false)
    rich_text:setContentSize(cc.size(w,h))
    rich_text:setPositionX(rich_text:getPositionX() + w/2)
    height = height + rich_text:getContentSize().height
    --
    height = height + img_line:getContentSize().height
    --
    item:setContentSize(cc.size(item:getContentSize().width,height))
    img_head:setPositionY(height-img_head:getContentSize().height/2)
    lable_date:setPositionY(height-lable_date:getContentSize().height/2)
    label_name:setPosition(label_name:getPositionX()+label_name:getContentSize().width/2,height-label_name:getContentSize().height/2)
    rich_text:setPositionY(height-label_name:getContentSize().height-h/2)
    local head=item:getChildByName("ImageHead")
    head:setTouchEnabled(true)
    head:addTouchEventListener(function(sender, eventType)
                                            if eventType == self.ccs.TouchEventType.ended then
                                            self._sel_chat_id=1
                                                self:ChangeChl(3,{target_name=options.target_name})
                                        end
                                    end)
    --
    lst_ctrl:addChild(item)
    lst_ctrl:refreshView()
    lst_ctrl:scrollToPercentVertical(100,0.2,true)
    -- self._root_widget:addChild(item,1000)
end
function UIChat:UpdataData()
        -- self._lst_ctrl = UIListView.new(UIHelper:seekWidgetByName(self._root_widget, "ScrollView"))
        -- self._lst_ctrl:InitialItem()
end

function UIChat:ProcessNetResult(params)
    -- if params.msg_type == "C_UpdataHeroInfo"
    --     then
    --         self:UpdataData()
    -- end
end
------------------------------------------------------------------------------
return UIChat
------------------------------------------------------------------------------