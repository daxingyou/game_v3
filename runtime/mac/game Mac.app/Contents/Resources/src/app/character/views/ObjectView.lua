--
-- Author: Anthony
-- Date: 2014-08-05 10:30:43
--
------------------------------------------------------------------------------
local MapConstants  = require("app.ac.MapConstants")
local configMgr     = require("config.configMgr")         -- 配置
------------------------------------------------------------------------------
local ObjectView = class("ObjectView", function()
    return display.newNode()
end)
ObjectView.BuffIconScale=0.5
------------------------------------------------------------------------------
function ObjectView:ctor(model,params)
    -- 允许显示对象的事件
    self:setNodeEventEnabled(true)

    -- model里面也存视图数据
    model:setView(self)
    self.model_     = model
    self.sprite_    = nil
    self.impactSprite_={}               --保存效果显示的精灵用来删除
    self.buff_icons={}
    self._pos_cell = nil
    self.hpOutlineSprite_=nil
    self.hpSprite_=nil
    self.RageLabel_=nil
end
------------------------------------------------------------------------------
function ObjectView:init(model,params)
    -- 生成sprite
    if params.img then
        self.sprite_ = display.newSprite(params.img)
        self:GetBatch():addChild(self.sprite_,params.zorder or MapConstants.MAX_OBJECT_ZORDER)
    end

    -- 设置是否翻转
    if params.flipx ~= nil then self:flipX(params.flipx) end
    -- 设置坐标
    self:setPosition(cc.p(params.x,params.y))
    self:updataCellPos()
end
------------------------------------------------------------------------------
-- 退出
function ObjectView:onExit()
    -- self:removeView()
    -- self.model_:removeView()
    self.model_ = nil
end
------------------------------------------------------------------------------
--
function ObjectView:onEnter()

end
------------------------------------------------------------------------------
--
function ObjectView:removeView()
    if self.hpOutlineSprite_ then
        self.hpOutlineSprite_:removeSelf()
        self.hpOutlineSprite_ = nil
    end
    if self.hpSprite_ then
        self.hpSprite_:removeSelf()
        self.hpSprite_ = nil
    end

    if self.RageLabel_ then
        -- print("···data",s)
        -- issue :删除报错
        self.RageLabel_:removeSelf()
        self.RageLabel_ = nil
    end
    -- print("···en")
    for k,v in pairs(self.buff_icons) do
        self:removeBuffIcon(k)
    end

end
------------------------------------------------------------------------------
--所在地图
function ObjectView:getMap()
    return self:GetModel():getMap()
end
------------------------------------------------------------------------------
-- 得到model
function ObjectView:GetModel()
    return self.model_
end
------------------------------------------------------------------------------
function ObjectView:GetSprite()
    return self.sprite_
end
------------------------------------------------------------------------------
-- 得到批量渲染
function ObjectView:GetBatch(classId)
    local model = self:GetModel()
    if classId == nil or classId == ""  then
        classId = model:getClassId()
    end

    return model:getMap():GetBatch(classId)
end
------------------------------------------------------------------------------
function ObjectView:flipX(flip)
    self.sprite_:flipX(flip)
    -- self:GetModel():setDir(flip)
    return self
end
------------------------------------------------------------------------------
function ObjectView:isFlipX()
    return self.sprite_:isFlippedX()
end
------------------------------------------------------------------------------
-- 创建
function ObjectView:createView(batch)
    local object = self:GetModel()
    self.batch_ = batch

    self.hpOutlineSprite_ = display.newSprite(string.format("#right-angry.png"))
    --缩放
    self.hpOutlineSprite_:setScaleX(MapConstants.RADIUS_SCALE_X)
    -- 加入批量渲染
    batch:addChild(self.hpOutlineSprite_, MapConstants.HP_BAR_ZORDER)

    self.hpSprite_ = display.newSprite("#right-Blood.png")
    self.hpSprite_:align(display.LEFT_CENTER, 0, 0)
    --缩放
    self.hpSprite_:setScaleX(MapConstants.RADIUS_SCALE_X)
    -- 加入批量渲染
    batch:addChild(self.hpSprite_, MapConstants.HP_BAR_ZORDER + 1)

    self.RageLabel_=cc.ui.UILabel.new({
                        UILabelType = cc.ui.UILabel.LABEL_TYPE_TTF,
                        text = string.format("rage:%d/%d",object:getRage(),object:getMaxRage()),
                        size = 15,
                        color = display.COLOR_GREEN,
                    })
                    :addTo(object:getMap(),MapConstants.MAP_Z_1_0)
end

function ObjectView:updataBuffIcon()
    if not self.hpOutlineSprite_ then
        return
    end
    local xx,yy = self:getPosition()
    local count=0
    for k,v in pairs(self.buff_icons) do
        local buff_w , buff_h = v:getContentSize().width*self.BuffIconScale,v:getContentSize().height*self.BuffIconScale
        v:setPosition(xx + buff_w/2 - (self.hpOutlineSprite_:getContentSize().width / 2*MapConstants.RADIUS_SCALE_X)+count*buff_w,
            self.hpOutlineSprite_:getPositionY()+buff_h/2+2)
        count=count+1
    end
end
------------------------------------------------------------------------------
-- 快速更新
function ObjectView:Update(state)
    self:updateView(state)
end
------------------------------------------------------------------------------
-- 更新
function ObjectView:updateView(state)
    if state=="moving" or not state then
        local sprite = self.sprite_
        if sprite then
            -- sprite:setPosition(cc.p(self:getPosition()))
            sprite:setPosition(cc.p(self:getPosition()))
        end
        self:updataImpacts()
    -- elseif state=="tick" then
    end

    -- hp
    local object = self.model_
    if object:getHp() > 0 then
        local x, y = object:getView():getPosition()

        local x2 = x + self.hpRadiusOffsetX - (self.hpSprite_:getContentSize().width / 2)*MapConstants.RADIUS_SCALE_X
        local y2 = y + self.hpRadiusOffsetY + MapConstants.HP_BAR_OFFSET_Y
        self.hpSprite_:setPosition(x2, y2)
        self.hpSprite_:setScaleX( (object:getHp() / object:getMaxHp()) * 0.4 )
        self.hpSprite_:setVisible(true)
        self.hpOutlineSprite_:setPosition(x + self.hpRadiusOffsetX, y2)
        self.hpOutlineSprite_:setVisible(true)

        local y2 = y2+15
        self.RageLabel_:setString(string.format("  rage:%d/%d\n  hp:%d/%d",object:getRage(),object:getMaxRage()
            ,object:getHp(),object:getMaxHp()))
        self.RageLabel_:setPosition(cc.p(x2,y2))

    else
        -- self.hpSprite_:setVisible(false)
        -- self.hpOutlineSprite_:setVisible(false)
        -- self.RageLabel_:setVisible(false)
    end
    -- buff icon
    self:updataBuffIcon()
end
-- function ObjectView:fastUpdateView(state)
--     self:updateView(state)
-- end

------------------------------------------------------------------------------
--效果特效更新
function ObjectView:updataImpacts()
    for k,v in pairs(self.impactSprite_) do
        local x,y = self:getPosition()
        v:setPosition(cc.p(x, y))
    end
end
function ObjectView:removeImpactsEffect()
    for k,v in pairs(self.impactSprite_) do
        self:removeImpactEffect(k)
    end
end
function ObjectView:removeImpactEffect(resEffectId)
    local c = self.impactSprite_[resEffectId]
    assert(c~=nil,string.format("removeEffect() - sprite is nil,resEffectId = %d", resEffectId))
    c:removeSelf()

    self.impactSprite_[resEffectId]=nil

end
------------------------------------------------------------------------------
--被攻击的效果特效
function ObjectView:createImpactEffect(resEffectId,isRepeatPlay,effectPoint)
    -- assert(resEffectId~=1)
    local resEffectData = configMgr:getConfig("skills"):GetSkillEffectByEffectId(resEffectId)
    assert(resEffectData~=nil,string.format("createBuffEff() - resEffectData is nil,resEffectId = %d",resEffectId))
    if self.impactSprite_[resEffectId] then
        return
    end
    --创建精灵
    local arrOffset = string.split(resEffectData.tarOffsetPos, MapConstants.SPLIT_SING)
    local scale_ = resEffectData.scale/100
    local x,y = self:getPosition()
    local sprite = display.newSprite()
    sprite:setPosition(cc.p(x+arrOffset[1],y+arrOffset[2]))
    sprite:setScale(scale_)
    if effectPoint==nil or effectPoint == 1 then -- 人物身上
        self:GetModel():getMap():addChild(sprite,MapConstants.MAP_Z_2_0)
    elseif effectPoint == 2 then -- 在地上
        self:GetModel():getMap():addChild(sprite,MapConstants.MAP_Z_0_0)
    end
    --创建动画
    local frameName = resEffectData.name
    local time = resEffectData.time/1000
    local frames  = display.newFrames(frameName, 1, resEffectData.amountFrames)
    local animation = display.newAnimation(frames, time/resEffectData.amountFrames)
    --播放动画
    if isRepeatPlay then
        transition.playAnimationForever(sprite, animation, 0)
        -- 一直存在就会放到数组里
        self.impactSprite_[resEffectId] = sprite
    else
        local onComplete = function()
        --print("move completed")
        end
        --播放完成精灵自动删除
        transition.playAnimationOnce(sprite,animation,true,onComplete)
    end
end
------------------------------------------------------------------------------
-- buff icon
function ObjectView:createBuffIcon(impactTypeId,buff_icon_path)
    if self.buff_icons[impactTypeId] then
        return
    end
    local x,y = self:getPosition()
    local buff_icon = display.newSprite(buff_icon_path)
    buff_icon:setPosition(x,y)
    buff_icon:setScale(self.BuffIconScale)
    self:getMap().batch_buff:addChild(buff_icon)

    self.buff_icons[impactTypeId] = buff_icon
    self:updataBuffIcon()
end
function ObjectView:removeBuffIcon(impactTypeId)
    local c = self.buff_icons[impactTypeId]
    c:removeSelf()
    self.buff_icons[impactTypeId]=nil
end
------------------------------------------------------------------------------
function ObjectView:getCellPos()
    return self._pos_cell
end
------------------------------------------------------------------------------
--
function ObjectView:updataCellPos()
    self._pos_cell = self:_getCellPos()
end
------------------------------------------------------------------------------
--取得自己的格子坐标
function ObjectView:_getCellPos()
    local x,y = self:getPosition()
    return self:getMap():getDMap():worldPosToCellPos(cc.p(x,y))
end
------------------------------------------------------------------------------
function ObjectView:createIdleAction()
end
------------------------------------------------------------------------------
function ObjectView:createBeAttackAction()
end
------------------------------------------------------------------------------
function ObjectView:createDeadAction()
end
------------------------------------------------------------------------------
return ObjectView
------------------------------------------------------------------------------
