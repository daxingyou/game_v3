--
-- Author: wangshaopei
-- Date: 2015-01-15 16:39:40
--
local conf_mgr_anis = require("config.anis.conf_mgr_anis")
local RichLabelEx = class("RichLabel", function()
    local node = display.newNode()
    return node
end)
RichLabelEx.default_options={
size=30,
font_name=FONT_GAME,
color={r=255,g=255,b=255},
-- is_ignore_adapt_size=true,
}
function RichLabelEx:create(content,parent,params)
    if parent then
        parent:setVisible(false)
        -- parent:setString("")
    end
    params=params or {}
    if params then
       self.is_ignore_adapt_size = params.is_ignore_adapt_size
    end
    local datas = {}
    local prase = {}
    local datas_record = {}
    local first_options ={}
    local content_ = string.gsub(content,"#(%d%d%d)","<ani=%1></ani>")
    local st__=string.find(content_,"<(.-)>(.-)</(.-)>")
    if st__ then -- 有富文本
        while st__ do
            local st_,en_,tag_=string.find(content_,"<(.-)>",st__)
            st__=en_
            if tag_ then
                table.insert(prase,{st=st_,en=en_,tag=tag_})
            end
        end
        for i=1,#prase do
            -- local options = {}
            local data = {text="",options={nil,nil,nil,nil}}
            self:ParseTag(prase[i].tag,data.options)
            if i==1 then
                first_options=data.options
            end

            if i+1> #prase then
                break
            end
            if data.options.type=="font" then
                data.options.color=data.options.color or first_options.color or self.default_options.color
                data.options.size=data.options.size or first_options.size or self.default_options.size
                data.options.font_name=data.options.font_name or first_options.font_name or self.default_options.font_name
            end
            if string.sub(prase[i].tag,1,1) ~= "/" and string.sub(prase[i+1].tag,1,1) == "/" then
                -- local s = string.sub(content_,prase[i].en+1,prase[i+1].st-1)
                -- if s ~= "" then
                    -- self:ParseTag(prase[i].tag,data.options)
                -- end
            -- 找到结束符的处理
            elseif string.sub(prase[i].tag,1,1) == "/" and string.sub(prase[i+1].tag,1,1) == "/" then
                assert(#datas_record>0,string.format("num1=%d,tag1=%s,num2=%d,tag2=%s",i,prase[i].tag,i+1,prase[i+1].tag))
                data.options=datas_record[#datas_record]
                table.remove(datas_record,#datas_record)
            -- 未找到结束符的处理
            elseif string.sub(prase[i].tag,1,1) ~= "/" and string.sub(prase[i+1].tag,1,1) ~= "/" then
                table.insert(datas_record, data.options)
            else
                if #datas_record>0 then
                    data.options=datas_record[#datas_record]
                end
            end
            local s = string.sub(content_,prase[i].en+1,prase[i+1].st-1)
             if  data.options.type == "font" then
                if s ~= "" then
                    data.text=s
                    table.insert(datas, data)
                end
             elseif data.options.type ~= nil then
                 table.insert(datas, data)
            end
            -- end
        end
    else -- 没有富文本
        local data = {text=content_,options=self.default_options}
        table.insert(datas, data)
    end

    self.rich_text = ccui.RichText:create()
    -- self.rich_text:setAnchorPoint(cc.p(0,1))
    for i,v in ipairs(datas) do
        local re=nil
        if v.options.type=="img" then
            re = ccui.RichElementImage:create(i, cc.c3b(255, 255, 255), 255, v.options.img)
        elseif v.options.type=="ani" then -- 动画
            local conf_ani = conf_mgr_anis:get_info(v.options.ani)
            local animation = display.newAnimation(
                display.newFrames(conf_ani.name, 1, conf_ani.amount_frames),
                conf_ani.time/1000/conf_ani.amount_frames)
            local sprite = display.newSprite(string.format("#"..conf_ani.name,1))
             transition.playAnimationForever(sprite, animation, 0)
            re = ccui.RichElementCustomNode:create(i, cc.c3b(255, 255, 255), 255, sprite)
        else
            local r,g,b = v.options.color.r,v.options.color.g,v.options.color.b
            re = ccui.RichElementText:create(i, cc.c3b(r, g, b), 255, v.text,v.options.font_name, v.options.size)
        end
        if re then
            self.rich_text:pushBackElement(re)
        end

    end

    if self.is_ignore_adapt_size then
        self.rich_text:ignoreContentAdaptWithSize(true)
        self.rich_text:formatText()
    else
        local size_=parent:getContentSize()
        -- assert(size_.width~=0 and size_.height~=0)
        self.rich_text:ignoreContentAdaptWithSize(false)
        self.rich_text:setContentSize(size_)
    end
    if parent then
        self.rich_text:setPosition(parent:getPosition())
        parent:getParent():addChild(self.rich_text)
    end
    return self

    -- local re1 = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, "This color is white. ", "Helvetica", 10)
    -- local re2 = ccui.RichElementText:create(2, cc.c3b(255, 255,   0), 255, "And this is yellow. ", "Helvetica", 10)
    -- local re3 = ccui.RichElementText:create(3, cc.c3b(0,   0, 255), 255, "This one is blue. ", "Helvetica", 10)
    -- local re4 = ccui.RichElementText:create(4, cc.c3b(0, 255,   0), 255, "And green. ", "Helvetica", 10)
    -- local re5 = ccui.RichElementText:create(5, cc.c3b(255,  0,   0), 255, "Last one is red ", "Helvetica", 10)

    -- local reimg = ccui.RichElementImage:create(6, cc.c3b(255, 255, 255), 255, "cocosui/sliderballnormal.png")

    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("cocosui/100/100.ExportJson")
    -- local arr = ccs.Armature:create("100")
    -- arr:getAnimation():play("Animation1")

    -- local recustom = ccui.RichElementCustomNode:create(1, cc.c3b(255, 255, 255), 255, arr)
    -- local re6 = ccui.RichElementText:create(7, cc.c3b(255, 127,   0), 255, "Have fun!! ", "Helvetica", 10)
    -- self._richText:pushBackElement(re1)
    -- self._richText:insertElement(re2, 1)
    -- self._richText:pushBackElement(re3)
    -- self._richText:pushBackElement(re4)
    -- self._richText:pushBackElement(re5)
    -- self._richText:insertElement(reimg, 2)
    -- self._richText:pushBackElement(recustom)
    -- self._richText:pushBackElement(re6)

    -- self._richText:setPosition(cc.p(widgetSize.width / 2, widgetSize.height / 2))
    -- self._richText:setLocalZOrder(10)


    -- self._widget:addChild(self._richText)
end
--
function RichLabelEx:ParseTag(parse_content,out_options)
    if not string.find(parse_content, "=") then
        return nil
    end
    local temTab = string.split(parse_content, " ") -- 支持标签内嵌
    for i,pstr in ipairs(temTab) do
        local temtab1 = string.split(pstr, "=")
        local pname = temtab1[1]
        local js = temtab1[2]
        local p = string.find(js, "[^%d.]")
        if not p then
            js = tonumber(js)
        end
        if pname=="color" then
            out_options[pname]=self:GetTextColor(js)
        else
           out_options[pname]=js
        end
        if i==1 then
            if pname == "color" then
                out_options["type"]="font"
            else
                out_options["type"]=pname
            end
        end

    end
    -- dump(out_options)
end
-- 解析输入的文本
function RichLabelEx:parseString(str, param)
    local clumpheadTab = {} -- 标签头
    for w in string.gfind(str, "%b[]") do --取得［］之间的内容
        if  string.sub(w,2,2) ~= "/" then-- 去尾
            table.insert(clumpheadTab, w)
        end
    end

    -- 解析标签
    local totalTab = {}
    for k,ns in pairs(clumpheadTab) do
        local tab = {}
        local tStr
        -- 第一个等号前为块标签名
        string.gsub(ns, string.sub(ns, 2, #ns-1), function (w)
            local n = string.find(w, "=")
            if n then
                local temTab = self:strSplit(w, " ") -- 支持标签内嵌
                for k,pstr in pairs(temTab) do
                    local temtab1 = self:strSplit(pstr, "=")

                    local pname = temtab1[1]
                    if k == 1 then tStr = pname end -- 标签头

                    local js = temtab1[2]
                    local p = string.find(js, "[^%d.]")
                    if not p then js = tonumber(js) end
                    if pname == "color" then
                        tab[pname] = self:GetTextColor(js)
                    else
                        tab[pname] = js
                    end
                end
            end
        end)
        if tStr then
            -- 取出文本
            local beginFind,endFind = string.find(str, "%[%/"..tStr.."%]")
            local endNumber = beginFind-1
            local gs = string.sub(str, #ns+1, endNumber)
            if string.find(gs, "%[") then

                tab["text"] = gs
            else

                string.gsub(str, gs, function (w)

                    tab["text"] = w
                end)
            end
            -- 截掉已经解析的字符
            str = string.sub(str, endFind+1, #str)
            if param then
                if not tab.number then  param.number = k end -- 未指定number则自动生成
                self:tab_addDataTo(tab, param)
            end
            table.insert(totalTab, tab)
        end
    end
    -- 普通格式label显示
    if table.nums(clumpheadTab) == 0 then
        local ptab = {}
        ptab.text = str
        if param then
            param.number = 1
            self:tab_addDataTo(ptab, param)
        end
        table.insert(totalTab, ptab)
    end
    return totalTab
end
-- string.split()
function RichLabelEx:strSplit(str, flag)
    local tab = {}
    while true do
        local n = string.find(str, flag)
        if n then
            local first = string.sub(str, 1, n-1)
            str = string.sub(str, n+1, #str)
            table.insert(tab, first)
        else
            table.insert(tab, str)
            break
        end
    end
    return tab
end
--[[解析16进制颜色rgb值]]
function  RichLabelEx:GetTextColor(xStr)
    if string.len(xStr) == 6 then
        local tmp = {}
        for i = 0,5 do
            local str =  string.sub(xStr,i+1,i+1)
            if(str >= '0' and str <= '9') then
                tmp[6-i] = str - '0'
            elseif(str == 'A' or str == 'a') then
                tmp[6-i] = 10
            elseif(str == 'B' or str == 'b') then
                tmp[6-i] = 11
            elseif(str == 'C' or str == 'c') then
                tmp[6-i] = 12
            elseif(str == 'D' or str == 'd') then
                tmp[6-i] = 13
            elseif(str == 'E' or str == 'e') then
                tmp[6-i] = 14
            elseif(str == 'F' or str == 'f') then
                tmp[6-i] = 15
            else
                print("Wrong color value.")
                tmp[6-i] = 0
            end
        end
        local r = tmp[6] * 16 + tmp[5]
        local g = tmp[4] * 16 + tmp[3]
        local b = tmp[2] * 16 + tmp[1]
        return cc.c3b(r,g,b)
    end
    return cc.c3b(255,255,255)
end

-- 设置监听函数
function  RichLabelEx:setClilckEventListener(eventName)
    self.listener = eventName
end

return RichLabelEx