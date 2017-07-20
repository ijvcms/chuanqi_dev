--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-06 14:57:11
-- 拆解自 ChatView
--

local ChatInputWidget = class("ChatInputWidget", function()
	return display.newNode()
end)

function ChatInputWidget:ctor(width,height)
	self:setContentSize(cc.size(width, height))
 
	self.FGList = {}
	self.inputStr = ""
	self.head = ""
	self.privateName = ""
	self.maxNum = 20
	self:init()
end

function ChatInputWidget:init()

    local bgSprite = display.newScale9Sprite("#com_inputBg.png", 0, 0, self:getContentSize())
    self:addChild(bgSprite)
	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(self:getContentSize().width, 30),
          listener = handler(self, self.onEdit),
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          --dimensions = cc.size(self:getContentSize().width, self:getContentSize().height)
        })
	if self.inputLab.setInputShowMode then
		self.inputLab:setInputShowMode(1)
	end
    --self.inputLab:setReturnType(1)
    self:addChild(self.inputLab)
    self.inputLab:setFontSize(18)
    self.inputLab:setPlaceHolder("点击输入聊天内容")
end

function ChatInputWidget:onEdit(event, editbox)
    if event == "changed" then
    	local checkText = editbox:getText()
    	if StringUtil.Utf8strlen(checkText) > self.maxNum then
    		editbox:setText(StringUtil.SubUTF8String(checkText, 1, self.maxNum))
    	end
    	if self.head ~= "" and string.len(checkText) < string.len(self.head) then
    		editbox:setText(self.head)
    	end
    end
end

function ChatInputWidget:setMaxLength(max)
	self.maxNum = max
	self.tmpMaxNum = max
end

function ChatInputWidget:setString(str,repl)

	local len = #self.FGList

    self.FGList[len+1] = {}
    self.FGList[len+1].str = repl
    self.FGList[len+1].use = false
    self.FGList[len+1].name = str
 	self.inputLab:setText(self.inputLab:getText()..str)
end

function ChatInputWidget:getString()
	return self.inputStr,self.privateName
end
--设置私聊对象
function ChatInputWidget:setPrivateChatName(name)
	self.inputLab:setText("")
	self.head = name
	self.maxNum = self.tmpMaxNum + string.len(name)
	self.inputLab:setText(self.head)
end

--清除数据
function ChatInputWidget:clear()

	self.inputLab:setText(self.head)
	self.inputStr = ""
	self.privateName = ""
	self.FGList = {}
end
--处理输入信息
function ChatInputWidget:handlerInput()

	if self.inputLab:getText() == "" then
		self.inputStr = ""
 		return
 	end
 	local _v,s = string.find(self.inputLab:getText(),"/")
 	local _m,e = string.find(self.inputLab:getText(),":")

	local sourceStr
 	if s ~= nil and e ~= 0 and s == 1 then

 		if self.head == "" or  self.head ~= string.sub(self.inputLab:getText(),1,e) then
 			self.head = string.sub(self.inputLab:getText(),1,e)
 		end

 		self.privateName = string.sub(self.inputLab:getText(),2,e-1)
		sourceStr = string.sub(self.inputLab:getText(),e+1,string.len(self.inputLab:getText()))
	else
		sourceStr = self.inputLab:getText()
	end
 
 	if sourceStr ~= "" then
	 	local s = self:trimStr(sourceStr,self.FGList )
	 	s = StringUtil:replaceStr(s,configHelper:getSensitiveWord())
		self.inputStr = s
 	end
 	
end
--
--s 源字符串
--t 替换的字符表
function ChatInputWidget:trimStr(s,t)
 
	local st,n = string.gsub(s,"<[^>]*>", function(s)
        if type(t) == "table" then

        	for i=1,#t do
        		if t[i].name == s then
        			local str = t[i].str
        			table.remove(t,i)
        			return str
        		end
        	end

        end
        end)
 	return st
end
 
function ChatInputWidget:setContentWidthWithAnim(width)
	if self.contentWidthHandler then
		self:removeNodeEventListener(self.contentWidthHandler)
		self:unscheduleUpdate()
	end
	self.endWidth = width
	self.contentWidthHandler = self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
			if self.endWidth ~= self:getContentSize().width then
			    local diff = self.endWidth - self:getContentSize().width
			    if math.abs(diff) <= 10 then
			    	self:setContentSize(self.endWidth, self:getContentSize().height)
			    	self.inputLab:setContentSize(self.endWidth, 30)
			    else
			    	self:setContentSize(self:getContentSize().width + 10, self:getContentSize().height)
			    	self.inputLab:setContentSize(self:getContentSize().width + 10, 30)
			    end
	        else
	        	self:removeNodeEventListener(self.contentWidthHandler)
	        	self.contentWidthHandler = nil
	        	self:unscheduleUpdate()
		    end
		end)
	self:scheduleUpdate()
end
 
return ChatInputWidget