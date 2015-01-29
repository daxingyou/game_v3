--
-- Author: wangshaopei
-- Date: 2015-01-14 13:54:10
--
local UIUtil = require("app.ac.ui.UIUtil")
local StringData = require("config.zhString")
local item_operator = require("app.mediator.item.item_operator")
local RichLabelEx = require("app.ac.ui.RichLabelEx")
local G_SysMsgs = G_SysMsgs

------------------------------------------------------------------------------
local DlgScreenMsg  = class("DlgScreenMsg",function ()
    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0,0),display.width,display.height)
    -- layer:setNodeEventEnabled(true)
    return layer
end)
------------------------------------------------------------------------------
function DlgScreenMsg:ctor()
    -- DlgMsg.super.ctor(self,UIManager)
    self._layers={}
    self._last_time=0
    self._is_show=true
end
------------------------------------------------------------------------------
--
function DlgScreenMsg:onEnter()
    -- DlgMsg.super.onEnter(self)
    -- local layer=cc.CSLoader:createNode("UI/LayerMsg.csb")
    -- layer:getChildByName("ImageBg"):setTouchEnabled(true)
    -- cc.uiloader:seekNodeByName(layer,"LayerMsg"):setTouchEnabled(true)
    -- self:addChild(layer)
    -- local run_scene = display.getRunningScene()
    -- if run_scene then
    --     run_scene:addChild(layer)
    -- end
end
------------------------------------------------------------------------------
-- 退出
function DlgScreenMsg:onExit()
    -- DlgMsg.super.onExit(self)
end
------------------------------------------------------------------------------
--
function DlgScreenMsg:init( params )
    -- DlgMsg.super.init(self,params)
    -- self._args = params.args
end
function DlgScreenMsg:Listen()
end
-- 屏幕公告
function DlgScreenMsg:UpdateBulletin(dt)
    local msg_ = G_SysMsgs:GetMsg(1,"bulletin")
    if msg_ and self._is_show then
        self._is_show = false
        G_SysMsgs:DelMsg(1,"bulletin")
        local layer=cc.CSLoader:createNode("UI/DlgMsg.csb")
        --
        local rich=RichLabelEx:create(msg_.content,layer:getChildByName("TextContent"),{is_ignore_adapt_size=true})
        local bg = layer:getChildByName("ImageBg")
        -- 设置9宫格背景
        bg:setContentSize(cc.size(rich.rich_text:getContentSize().width+20,
            rich.rich_text:getContentSize().height+20) )
        layer:setContentSize(bg:getContentSize())
        --
        self:addChild(layer,1)
        layer:setPosition(display.cx,display.top - 100)
        --
        layer:setOpacity(0)
        local sequence = transition.sequence({
                CCFadeIn:create(0.3),
                CCDelayTime:create(3),
                CCEaseExponentialIn:create(CCFadeOut:create(0.3)),
            })
            transition.execute( layer,sequence,{
                onComplete = function()
                    layer:removeFromParent()
                    self._is_show = true
                end,
            })
    end
end
-- 屏幕提示
function DlgScreenMsg:UpdateHint(dt)
    self._last_time = self._last_time+dt
    if self._last_time < 0.2 then
        return
    end
    self._last_time=0
    local h = display.cy+display.cy/3
    local msg_ = G_SysMsgs:GetMsg(1,"hint")
    if msg_ then
        G_SysMsgs:DelMsg(1,"hint")
        local layer=cc.CSLoader:createNode("UI/DlgMsg.csb")
        layer:setVisible(false)
        --
        local rich=RichLabelEx:create(msg_.content,layer:getChildByName("TextContent"),{is_ignore_adapt_size=true})
        local bg = layer:getChildByName("ImageBg")
        -- 设置9宫格背景
        bg:setContentSize(cc.size(rich.rich_text:getContentSize().width+20,
            rich.rich_text:getContentSize().height+20) )
        layer:setContentSize(bg:getContentSize())
        --
        for i=1,#self._layers do
                local v = self._layers[i]
                local sequence = transition.sequence({
                    -- CCFadeIn:create(0.2),
                    -- CCDelayTime:create(0.5),
                    CCMoveBy:create(0.1, cc.p(0,v:getContentSize().height)),
                    -- CCDelayTime:create(1),
                    -- CCEaseExponentialIn:create(CCFadeOut:create(0.3)),
                    -- CCDelayTime:create(0.5),
                })
                transition.execute( v,sequence,{
                    onComplete = function()
                    layer:setVisible(true)
                    end,
                })
        end
        if #self._layers==0 then
            layer:setVisible(true)
        end
        --
        self:addChild(layer,0)
        layer:setPosition(display.cx,h)
        table.insert(self._layers,layer)

        layer:setOpacity(0)
        local sequence = transition.sequence({
                CCFadeIn:create(0.3),
                -- CCMoveBy:create(0.1, cc.p(0,v:getContentSize().height)),
                CCDelayTime:create(1.5),
                CCEaseExponentialIn:create(CCFadeOut:create(0.3)),
                -- CCMoveBy:create(0.3, cc.p(0,layer:getContentSize().height)),
                -- CCDelayTime:create(0.5),
            })
            transition.execute( layer,sequence,{
                onComplete = function()
                    layer:removeFromParent()
                    table.remove(self._layers,1)
                end,
            })

    end
end
------------------------------------------------------------------------------
return DlgScreenMsg
------------------------------------------------------------------------------
