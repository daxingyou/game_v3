--[[

遮挡层 (模态框)

** Return **
    CCLayerColor

]]

local M = {
	layer,
	clickFunc,
	createScene
}


function M:new(args)
	local this = {}
	setmetatable(this , self)
	self.__index = self

	local args = args or {}

	local r = args.r or 0
	local g = args.g or 0
	local b = args.b or 0
	local opacity = args.opacity or 100         -- 透明度
	local priority = args.priority or -129      -- 优先级
	local item = args.item or nil               -- 额外 addChild 上去的元素
	this.clickFunc = args.click or function() end  -- 点击回调函数


	-- 创建层
	this.layer = CCLayerColor:create( cc.c4b(r , g , b , opacity),display.width,display.height )
	-- local view = CCLayerColor:create( cc.c4b(r , g , b , opacity) )

	local function onTouch(eventType , x , y)
	    if eventType == "began" then return true end
	    if eventType == "moved" then return true end

	    if eventType ==  "ended" then
	        -- 点击回调函数
			this.clickFunc(x , y)
	        return true
	    end

	    return false
	end

	-- 屏蔽点击
	this.layer:setTouchEnabled( true )
	-- this.layer:registerScriptTouchHandler(onTouch , false , priority , true)
	this.layer:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT,function(event)
		 	return onTouch(event.name,event.x,event.y)
		 end)



	if item ~= nil then
	    this.layer:addChild(item)
	end

	this.createScene = display.getRunningScene().name

	return this
end


function M:show()
	local cur_scene = display.getRunningScene().name
	if cur_scene == self.createScene then
    	self.layer:setVisible(true)
    end
end

function M:hide()
	local cur_scene = display.getRunningScene().name
	if cur_scene == self.createScene then
    	self.layer:setVisible(false)
    end
end

function M:remove()
	xpcall(function()
	local cur_scene = display.getRunningScene().name
	if cur_scene == self.createScene then
		-- self.layer:removeFromParent(true)
		self.layer:removeFromParent()
		self.layer = nil
	end
	end, __G__TRACKBACK__)
end

-- 设置点击回调函数
function M:click(func)
	self.clickFunc = func
end

function M:getLayer()
	return self.layer
end

return M
