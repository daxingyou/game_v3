--
-- Author: Your Name
-- Date: 2014-07-21 18:00:49
-- 处理一轮人物的每个操作命令
--[[
    处理 HeroOperateManager
]]
local Command = import(".Command")
local HeroOperateCommand = class("HeroOperateCommand",Command)
function HeroOperateCommand:ctor(opObj,map,mapEvent)
    HeroOperateCommand.super.ctor(self)
    self.opObjId_=opObj:GetModel():getId()
    self.opObj_=opObj
    self.map_=map
    self.mapEvent_=mapEvent
    self._isDoDoneBefore=false                          --是否完成前处理过
    self._isDoingBefore=false --开始攻击前
    self._object_view = nil
    self._object = nil
    self._target=nil
end
function HeroOperateCommand:execute(dt)
    HeroOperateCommand.super:execute(self)
    self:clearExpireObj()
    self._object_view = self.map_:getObject(self.opObjId_)
    if self._object_view == nil then
        self:doDone()
    else
        self._object = self._object_view:GetModel()
        self.map_._cur_object_view = self._object_view
        -- 攻击前处理
        if not self._isDoingBefore then
            self:doingBefore(self._object)
            self._isDoingBefore = true
        end
        self._object:AI(self.mapEvent_)

        --执行列表的命令
        --攻击逻辑在这边执行
        HeroOperateManager:updata(dt)
        --没有玩家操作命令HeroOperateManager
        if HeroOperateManager:isEmpty() then
            if self._isDoDoneBefore == false then
                self:doDoneBefore(self._object)
                self._isDoDoneBefore = true
                if HeroOperateManager:isEmpty() then
                    self:doDone(self._object)
                end
            else
                --完成此次步骤
                self:doDone(self._object)
            end
        end
    end

end
-------------------------------------------------------
function HeroOperateCommand:clearExpireObj()
    local delObjLst={}
    for k,v in pairs(self.map_:getAllObjects()) do
        -- 判断是否已经被摧毁
        if v:GetModel():getClassId() == "hero" and v:GetModel():isDestroyed() then
            table.insert(delObjLst,v)
        end
    end
    for i,v in ipairs(delObjLst) do
         v:removeView()
         self.map_:removeObject(v)
    end
end
--------------------------------------------------------
function HeroOperateCommand:doDone(rMe)
        self:setDone(true)
        self._isDoDoneBefore = false
        self._isDoingBefore = false
        -- 触发陷阱效果
        self.map_:updataTrigger(rMe)
        HeroOperateManager:destroyAllCommands()
        if rMe then
            rMe:ResetAI()
        end
end
--------------------------------------------------------
--功能函数
function HeroOperateCommand:doDoneBefore(rMe)
    if rMe then
        rMe:updataBout()
    end
end
function HeroOperateCommand:doingBefore(rMe)
    if rMe then
        rMe:onImpactBeforeBout()
        self.map_:updataTrigger(rMe)
        rMe:updataImpacts()
    end
end
--------------------------------------------------------
return HeroOperateCommand
--------------------------------------------------------