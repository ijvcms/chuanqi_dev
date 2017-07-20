module(..., package.seeall)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--
-- xml.lua - XML parser for use with the Corona SDK.
--
-- version: 1.2
--
-- CHANGELOG:
--
-- 1.2 - Created new structure for returned table
-- 1.1 - Fixed base directory issue with the loadFile() function.
--
-- NOTE: This is a modified version of Alexander Makeev's Lua-only XML parser
-- found here: http://lua-users.org/wiki/LuaXml
--
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function newParser()

    XmlParser = {};

    function XmlParser:ToXmlString(value)
        value = string.gsub(value, "&", "&amp;"); -- '&' -> "&amp;"
        value = string.gsub(value, "<", "&lt;"); -- '<' -> "&lt;"
        value = string.gsub(value, ">", "&gt;"); -- '>' -> "&gt;"
        value = string.gsub(value, "\"", "&quot;"); -- '"' -> "&quot;"
        value = string.gsub(value, "([^%w%&%;%p%\t% ])",
            function(c)
                return string.format("&#x%X;", string.byte(c))
            end);
        return value;
    end

    function XmlParser:FromXmlString(value)
        value = string.gsub(value, "&#x([%x]+)%;",
            function(h)
                return string.char(tonumber(h, 16))
            end);
        value = string.gsub(value, "&#([0-9]+)%;",
            function(h)
                return string.char(tonumber(h, 10))
            end);
        value = string.gsub(value, "&quot;", "\"");
        value = string.gsub(value, "&apos;", "'");
        value = string.gsub(value, "&gt;", ">");
        value = string.gsub(value, "&lt;", "<");
        value = string.gsub(value, "&amp;", "&");
        return value;
    end

    function XmlParser:ParseArgs(node, s)
        string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
            node:addProperty(w, self:FromXmlString(a))
        end)
    end

    function XmlParser:ParseXmlText(xmlText)
        -- --{对换行做一些处理
        -- --1,判断<br/>个数
        -- local temp = xmlText
        -- local brCount = 0
        -- local startSearch = 1
        -- while true do
        --     local s,e = string.find(temp,"<br/>",startSearch)
        --     if s and e then
        --         brCount = brCount + 1
        --         startSearch = e + 1
        --     else
        --         break
        --     end
        -- end
        -- print("brCount ====================",brCount)
        -- -- local xmlText = xmlText

        -- if brCount >0 then
        --     local result = ""
        --     --2,将所有<br/>替换为<br/><font>
        --     xmlText = string.gsub(xmlText,"<br/>","<br/><font>")
        --     --3,如果还有下一个<br/><font>那么
        --     local s,e = string.find(xmlText,"<br/><font>")
        --     result = result..string.sub(xmlText,1,e)
        --     local temp = string.sub(xmlText,e+1)
        --     s,e = string.find(temp,"<br/><font>")
        --     while(s and e) do
        --         local betweenStr = string.sub(temp,1,s-1)
        --         local s1,e1 = string.find(betweenStr,"<font")
        --         local s2,e2 = string.find(betweenStr,"</font")
        --         if s1 or s2 then        -- （1）<br/><font>与<br/><font>之间如果有<font 或 </font 那么在出现的第一个<font或</font前加</font>
        --             if s1 and s2 then   
        --                 if s1>s2 then
        --                     local part1 = string.sub(betweenStr,1,s2-1)
        --                     local part2 = string.sub(betweenStr,s2)
        --                     result = result..part1.."</font>"..part2.."<br/><font>"
        --                 else
        --                     local part1 = string.sub(betweenStr,1,s1-1)
        --                     local part2 = string.sub(betweenStr,s1)
        --                     result = result..part1.."</font>"..part2.."<br/><font>"
        --                 end
        --             elseif s1 and (not s2) then
        --                 local part1 = string.sub(betweenStr,1,s1-1)
        --                 local part2 = string.sub(betweenStr,s1)
        --                 result = result..part1.."</font>"..part2.."<br/><font>"
        --             elseif (not s1) and s2 then
        --                 local part1 = string.sub(betweenStr,1,s2-1)
        --                 local part2 = string.sub(betweenStr,s2)
        --                 result = result..part1.."</font>"..part2.."<br/><font>"
        --             end
        --         else                    -- （2）没有找到<font或</font那么在下一个<br/><font>前加</font>
        --             result = result..betweenStr.."</font><br/><font>"
        --         end
                    
        --         temp = string.sub(temp,e+1)
        --         s,e = string.find(temp,"<br/><font>") 
        --     end

        --     --4,如果没有下一个<br/><font>了
        --     local s1,e1 = string.find(temp,"<font")
        --     local s2,e2 = string.find(temp,"</font")
        --     if s1 or s2 then        -- （1）<br/><font>与结尾之间如果有<font 或 </font 那么在出现的第一个<font或</font前加</font>
        --         if s1 and s2 then   
        --             if s1>s2 then
        --                 local part1 = string.sub(temp,1,s2-1)
        --                 local part2 = string.sub(temp,s2)
        --                 result = result..part1.."</font>"..part2
        --             else
        --                 local part1 = string.sub(temp,1,s1-1)
        --                 local part2 = string.sub(temp,s1)
        --                 result = result..part1.."</font>"..part2
        --             end
        --         elseif s1 and (not s2) then
        --             local part1 = string.sub(temp,1,s1-1)
        --             local part2 = string.sub(temp,s1)
        --             result = result..part1.."</font>"..part2
        --         elseif (not s1) and s2 then
        --             local part1 = string.sub(temp,1,s2-1)
        --             local part2 = string.sub(temp,s2)
        --             result = result..part1.."</font>"..part2
        --         end
        --     else                    -- （2）没有找到<font或</font那么在结尾加</font>
        --         result = result..temp.."</font>"
        --     end
        --     xmlText = result
        -- end
        -- --}

        local stack = {}
        local top = newNode()
        table.insert(stack, top)
        local ni, c, label, xarg, empty
        local i, j = 1, 1
        while true do
            ni, j, c, label, xarg, empty = string.find(xmlText, "<(%/?)([%w_:]+)(.-)(%/?)>", i)
            if not ni then break end
            local text = string.sub(xmlText, i, ni - 1);
            if not string.find(text, "^%s*$") then
                local lVal = (top:value() or "") .. self:FromXmlString(text)
                local lNode = newNode("font")
                lNode:setValue(lVal)
                top:addChild(lNode)
            end
            if empty == "/" then -- empty element tag
                local lNode = newNode(label)
                self:ParseArgs(lNode, xarg)
                top:addChild(lNode)
            elseif c == "" then -- start tag
                local lNode = newNode(label)
                self:ParseArgs(lNode, xarg)
                table.insert(stack, lNode)
        		top = lNode
            else -- end tag
                local toclose = table.remove(stack) -- remove top

                top = stack[#stack]
                if #stack < 1 then
                    --error("XmlParser: nothing to close with " .. label)
                end
                if toclose:name() ~= label then
                    --error("XmlParser: trying to close " .. toclose.name .. " with " .. label)
                end
                top:addChild(toclose)
            end
            i = j + 1
        end
        local text = string.sub(xmlText, i);
        if #stack > 1 then
            --error("XmlParser: unclosed " .. stack[#stack]:name())
        end
        return top
    end

    function XmlParser:loadFile(xmlFilename, base)
        if not base then
            base = system.ResourceDirectory
        end

        local path = system.pathForFile(xmlFilename, base)
        local hFile, err = io.open(path, "r");

        if hFile and not err then
            local xmlText = hFile:read("*a"); -- read file content
            io.close(hFile);
            return self:ParseXmlText(xmlText), nil;
        else
            print(err)
            return nil
        end
    end

    return XmlParser
end

function newNode(name)
    local node = {}
    node.___value = nil
    node.___name = name
    node.___children = {}
    node.___props = {}
    node.___parent = nil

    function node:value() return self.___value or "" end
    function node:setValue(val) self.___value = val end
    function node:name() return self.___name end
    function node:setName(name) self.___name = name end
    function node:children() return self.___children end
    function node:numChildren() return #self.___children end
    function node:addChild(child)
        if self[child:name()] ~= nil then
            if type(self[child:name()].name) == "function" then
                local tempTable = {}
                table.insert(tempTable, self[child:name()])
                self[child:name()] = tempTable
            end
            table.insert(self[child:name()], child)
        else
            self[child:name()] = child
        end
        table.insert(self.___children, child)
        child:setParent(self)
    end

    function node:properties() return self.___props end
    function node:numProperties() return #self.___props end
    function node:addProperty(name, value)
        local lName = "@" .. name
        if self[lName] ~= nil then
            if type(self[lName]) == "string" then
                local tempTable = {}
                table.insert(tempTable, self[lName])
                self[lName] = tempTable
            end
            table.insert(self[lName], value)
        else
            self[lName] = value
        end
        table.insert(self.___props, { name = name, value = self[lName] })
    end

    function node:setParent(parent)
        self.___parent = parent
    end 

    function node:parent()
        return self.___parent
    end

    function node:nextSibling()
        if not self:parent() then return end
        local childs = self:parent():children()
        for i=1,#childs do
            if self == childs[i] then
                return childs[i+1]
            end
        end
    end

    function node:firstChild()
        return self:children()[1]
    end

    return node
end
