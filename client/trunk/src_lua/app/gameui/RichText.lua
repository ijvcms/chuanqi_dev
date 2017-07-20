--[[
Author: nuk
Link:   1546292145@qq.com
Date: 	2015-07-16 09:42:15
Detail:	富文本标签
]]

local RichText = class("RichText", function()
	return display.newNode()--display.newColorLayer(cc.c4b(255,255,0,255)) 
end)


function RichText.create(param)
	return RichText.new(param)
end

function RichText:ctor(param)

--[[param = 
{
maxwidth=200,
verticalSpace=0,
content={
{image="game/sliderballnormal.png"},
{color="F0000F",text="[2]",fontsize=20,fontname="Helvetica"},
}
}]]
	
	local size = cc.Director:getInstance():getWinSize()  

	local maxwidth = param.maxwidth or size.width
	local verticalSpace = param.verticalSpace or 0
	local content = param.content
    
	--计算size
	local richTextTemp = ccui.RichText:create()
	richTextTemp:ignoreContentAdaptWithSize(false)
	richTextTemp:setContentSize(cc.size(maxwidth, 0))
	richTextTemp:setVerticalSpace(verticalSpace)

	if content then
	    for i=1, #content do
	        if content[i].color then
	        	local fontName = content[i].fontname or "Helvetica"
	        	local fontSize = content[i].fontsize or 20
	        	local re1 = ccui.RichElementText:create(i, self:GetTextColor(content[i].color), 255, content[i].text, fontName, fontSize)
	        	richTextTemp:pushBackElement(re1)
	       	elseif content[i].image then
	       		local reimg = ccui.RichElementImage:create(i, cc.c3b(255, 255, 255), 255, content[i].image)
	       		richTextTemp:pushBackElement(reimg)
	        end 
		end
	end

    richTextTemp:formatText()
    local sizeFit = richTextTemp:getContentSize()

    richTextTemp:removeFromParentAndCleanup(true)
    richTextTemp = nil

    --来真的

	--local bgLayer = cc.LayerColor:create(cc.c4b(255,0,0,255))  
    --self:addChild(bgLayer, -1)  

	self._richText = ccui.RichText:create()
    self._richText:ignoreContentAdaptWithSize(false)
    self._richText:setContentSize(cc.size(maxwidth, sizeFit.height))
    self._richText:setVerticalSpace(verticalSpace)

    if content then
	    for i=1, #content do
	        if content[i].color then
	        	local fontName = content[i].fontname or "Helvetica"
	        	local fontSize = content[i].fontsize or 20
	        	local re1 = ccui.RichElementText:create(i, self:GetTextColor(content[i].color), 255, content[i].text, fontName, fontSize)
	        	self._richText:pushBackElement(re1)
	       	elseif content[i].image then
	       		local reimg = ccui.RichElementImage:create(i, cc.c3b(255, 255, 255), 255, content[i].image)
	       		self._richText:pushBackElement(reimg)
	        end 
		end
	end

    self._richText:formatText()
    
    self:addChild(self._richText)

end	

--获取控件size
function RichText:getContentSize()
	return cc.size(self._richText:getContentSize().width,self._richText:getContentSize().height)
end

--颜色“FFFFFF”转cc.c3b(255,255,255)
function RichText:GetTextColor(xStr)
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
                print("RichText: Wrong color value.")
                tmp[6-i] = 0
            end
        end
        local r = tmp[6] * 16 + tmp[5]
        local g = tmp[4] * 16 + tmp[3]
        local b = tmp[2] * 16 + tmp[1]
        return cc.c3b(r, g, b)
    end
    return cc.c3b(255,255,255)
end

return RichText