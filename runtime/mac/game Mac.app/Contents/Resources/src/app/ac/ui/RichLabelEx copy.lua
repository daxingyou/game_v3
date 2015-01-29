--
-- Author: wangshaopei
-- Date: 2015-01-15 16:39:40
--
local RichLabelEx = class("RichLabel", function()
    local node = display.newNode()
    return node
end)

function RichLabelEx:txml1(str_)
    local tStr = nil
    local xml,s=str_,1
    print("···2",s,xml)
    while s do
        _,s,tag=string.find(xml,"%[(.-)%]",s)
        print("···5",_,s,tag)
        if tag then
            local n = string.find(tag, "=")
            if n then
                local temTab = self:strSplit(tag, " ") -- 支持标签内嵌
                for k,pstr in pairs(temTab) do
                    local temtab1 = self:strSplit(pstr, "=")
                    local pname = temtab1[1]
                    if k == 1 then
                        tStr = pname
                        xml=string.gsub(xml,"%["..tag.."%](.-)%[/"..pname.."%]","\r\n".."{"..pname.."=,text=%1,},\r\n")
                        print("···3",xml)
                    end -- 标签头

                end
            end
        end
        -- if tag then
        --     xml=string.gsub(xml,'['..tag..'](.-)[/'..tag..']','\r\n'..tag..'={%1},\r\n')
        --     print("···1",xml)
        -- end
    end
end
function RichLabelEx:txml2(str_)

    local tStr = nil
    local xml,s=str_,1
    local datas = {}
    local datas_record = {}
    table.insert(datas_record,{tag_="default",text="test"})
    while s do
        local ts,te,tstr = string.find(xml,"(.-)%[",1)
        if tstr == "" then
            st,en,tag=string.find(xml,"%[(.-)%]",1)
            s=en
            if tag then
                table.insert(datas,{tag_=tag,text=nil})
                table.insert(datas_record,{tag_=tag})
                local temTab = self:strSplit(tag, " ")
                local temtab1 = self:strSplit(temTab[1], "=")
                local pname = temtab1[1]
                --
                ts,te,tstr=string.find(xml,"(.-)%[%/"..pname.."%]",1)
                if tstr~="" then
                    local s1,e1=string.find(tstr,"%[")
                    if s1==nil then -- 有对应的［／］
                        table.remove(datas_record,#datas_record)
                    else --没有对应的［／］
                        ts,te,tstr=string.find(xml,"(.-)%[",s+1)
                    end
                    datas[#datas].text=tstr
                    xml=string.sub(xml,te)
                    -- dump(datas)
                    -- dump(datas_record)
                    -- return
                end
            end

        else
            table.insert(datas,{color=datas_record[#datas_record].color})
        end
    end
end
function RichLabelEx:txml3(str_)
    local datas = {}
    local prase = {}
    local datas_record = {}
     local xml,s=str_,1
    while s do
        local st_,en_,tag_=string.find(xml,"<(.-)>",s)
        s=en_
        if tag_ then
            table.insert(prase,{st=st_,en=en_,tag=tag_})
        end
    end
    for i=1,#prase do
        if i+1> #prase then
            break
        end
        local data = {tag=nil,text=nil}

        if string.sub(prase[i].tag,1,1) ~= "/" and string.sub(prase[i+1].tag,1,1) == "/" then
            local s = string.sub(xml,prase[i].en+1,prase[i+1].st-1)
            if s ~= "" then
                data.tag=prase[i].tag
            end
        elseif string.sub(prase[i].tag,1,1) == "/" and string.sub(prase[i+1].tag,1,1) == "/" then
            assert(#datas_record>0,string.format("num1=%d,tag1=%s,num2=%d,tag2=%s",i,prase[i].tag,i+1,prase[i+1].tag))
            data.tag=datas_record[#datas_record].tag
            table.remove(datas_record,#datas_record)
        elseif string.sub(prase[i].tag,1,1) ~= "/" and string.sub(prase[i+1].tag,1,1) ~= "/" then
            table.insert(datas_record, {tag=prase[i].tag})
            data.tag=datas_record[#datas_record].tag
        else
            if #datas_record>0 then
                data.tag=datas_record[#datas_record].tag
            end
        end
        local s = string.sub(xml,prase[i].en+1,prase[i+1].st-1)
         if s ~= "" then
            data.text=s
            table.insert(datas, data)
        end
    end
    dump(datas)
end
-- 解析输入的文本
function RichLabelEx:parseString(str, param)
    local clumpheadTab = {} -- 标签头
    for w in string.gfind(str, "%b[]") do --取得［］之间的内容
        print("···1",w)
        if  string.sub(w,2,2) ~= "/" then-- 去尾
            table.insert(clumpheadTab, w)
        end
    end
    dump(clumpheadTab)

    -- 解析标签
    local totalTab = {}
    for k,ns in pairs(clumpheadTab) do
        local tab = {}
        local tStr
        -- 第一个等号前为块标签名
        string.gsub(ns, string.sub(ns, 2, #ns-1), function (w)
            print("...2",w)
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
        print("···3",tStr,ns)
        if tStr then
            -- 取出文本
            local beginFind,endFind = string.find(str, "%[%/"..tStr.."%]")
            print("···5",beginFind,endFind)
            local endNumber = beginFind-1
            local gs = string.sub(str, #ns+1, endNumber)
            if string.find(gs, "%[") then

                tab["text"] = gs
            else
                print("···4",gs)
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
function RichLabelEx:tab_addDataTo(tab, src)
    for k,v in pairs(src) do
        tab[k] = v
    end
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