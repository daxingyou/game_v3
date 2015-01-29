--
-- Author: wangshaopei
-- Date: 2015-01-14 13:54:10
--
local UIButtonCtrl = require("app.ac.ui.UIButtonCtrl")
local UIUtil = require("app.ac.ui.UIUtil")
local configMgr = require("config.configMgr")
local StringData = require("config.zhString")
local item_operator = require("app.mediator.item.item_operator")
local UIListView = require("app.ac.ui.UIListViewCtrl")
------------------------------------------------------------------------------
local DlgMsg  = class("DlgMsg",function ()
    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0,0),display.width,display.height)
    layer:setNodeEventEnabled(true)
    return layer
end)
------------------------------------------------------------------------------
function DlgMsg:ctor()
    -- DlgMsg.super.ctor(self,UIManager)
end
------------------------------------------------------------------------------
--
function DlgMsg:onEnter()
    -- DlgMsg.super.onEnter(self)
    -- local layer=cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("UI/LayerMsg.csb")
    local layer=cc.CSLoader:createNode("UI/LayerMsg.csb")
    -- UIHelper:seekWidgetByName(layer,"ImageBg"):setTouchEnabled(true)
    layer:getChildByName("ImageBg"):setTouchEnabled(true)
    -- cc.uiloader:seekNodeByName(layer,"LayerMsg"):setTouchEnabled(true)
    self:addChild(layer)
    -- local run_scene = display.getRunningScene()
    -- if run_scene then
    --     run_scene:addChild(layer)
    -- end
end
------------------------------------------------------------------------------
-- 退出
function DlgMsg:onExit()
    -- DlgMsg.super.onExit(self)
end
------------------------------------------------------------------------------
--
function DlgMsg:init( params )
    -- DlgMsg.super.init(self,params)
    -- self._args = params.args
end
function DlgMsg:Listen()
end

function DlgMsg:UpdataData(maillist)

end
------------------------------------------------------------------------------
return DlgMsg
------------------------------------------------------------------------------
