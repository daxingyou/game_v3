--
-- Author: wangshaopei
-- Date: 2015-01-14 16:08:04
--
local HorseRaceLamp = class("HorseRaceLamp")
-- local DlgMsg = require("app.ac.DlgMsg")
------------------------------------------------------------------------------
function HorseRaceLamp:ctor()
    self._msgs={}
end
function HorseRaceLamp:AddContent(content)
    table.insert(self._msgs,{content=content})
end
function HorseRaceLamp:Update(dt)
    for i,v in ipairs(self._msgs) do
        local l =require("app.ac.DlgMsg")
            local msg = DlgMsg.new(v.content)
            self:addChild(msg)
    end
end
return HorseRaceLamp