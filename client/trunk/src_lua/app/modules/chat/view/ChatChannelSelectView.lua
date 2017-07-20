--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-06 15:02:00
-- 拆解自 ChatView
--
local ChatMetadata = import("..model.ChatMetadata")
local ChatChannelSelectView = class("ChatChannelSelectView", function()
	return display.newNode()
end)


local ChannelNameColor = {
	[1] = TextColor.TEXT_G,
	[2] = TextColor.TEXT_Y,
	[3] = TextColor.ITEM_B,
	[4] = TextColor.ITEM_P,
--	[5] = TextColor.TEXT_HR,
}

local ChatChannelName = {
	[1] = "世界",
	[2] = "行会",
	[3] = "组队",
	[4] = "私聊",
--	[5] = "军团",
}

function ChatChannelSelectView:ctor()
	self:setTouchEnabled(true)
	local height = 0
	local width = 0
	self.items = {}
	self.itemSize = {}
	self.gap = 2
	local layer = display.newNode()
	for i=1, #ChatChannelName do
		local sp = display.newSprite("#com_btnStyle1N.png")
		sp:setScale(0.9)
		if not self.itemSize.width then self.itemSize.width = sp:getContentSize().width*0.9 end
		if not self.itemSize.height then self.itemSize.height = sp:getContentSize().height*0.9 end
		local lab = display.newTTFLabel({
	    	text = ChatChannelName[i],
	    	size = 20,
	    	color = ChannelNameColor[i]
		})
		display.setLabelFilter(lab)
		lab:setPosition(sp:getContentSize().width/2,sp:getContentSize().height/2)
		sp:addChild(lab)
		table.insert(self.items,sp)
		height = height + sp:getContentSize().height*0.9 + self.gap 
		width = sp:getContentSize().width*0.9 
		layer:addChild(sp)

		sp:setTouchEnabled(true)
		sp:setTouchSwallowEnabled(false)
		sp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()   
            elseif event.name == "ended" then
            	if self.showing == false then 
            		if self.curChannelIndex == i then
            			self:startShow()
            		else
            			return
            		end
            	end
            	if self.showingAni then return end
                self:setCurChannel(i)
            end     
            return true
        end)
	end
	self.maxHeight = height
	self:setContentSize(width, self.itemSize.width)

	--遮罩
    self.mask = cc.ClippingRegionNode:create()
    self:addChild(self.mask)
    self.mask:setPosition(0,0)
    self.mask:addChild(layer)
    self.mask:setClippingRegion(cc.rect(-self.itemSize.width/2,0,self.itemSize.width,self.itemSize.height))
    self.showing = false
	self:setCurChannel(1)

	--NodeEvent
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end

function ChatChannelSelectView:onNodeEvent(data)
	if data.name == "cleanup" then
    	if self.scheId then
    		scheduler.unscheduleGlobal(self.scheId)
			self.scheId = nil
    	end
    end
end

function ChatChannelSelectView:setCurChannel(channelIndex)

	--特殊处理，综合和世界转换
	local isSix = false
	if channelIndex == 6 then
		isSix = true
		channelIndex = 1
	elseif channelIndex == 7 then --军团
		channelIndex = 5
	end


	if not self.items[channelIndex] then return end
	--调整位置
	for i=1,#self.items do
		if i>channelIndex then
			self.items[i]:setPositionY((self.itemSize.height+self.gap)*(i-channelIndex)+self.itemSize.height/2)
		elseif i==channelIndex then
			self.items[i]:setPositionY(self.itemSize.height/2)
		elseif i<channelIndex then
			local height = self:getContentSize().height
			self.items[i]:setPositionY(height-((self.itemSize.height+self.gap)*(channelIndex-i-1)+self.itemSize.height/2))
		end
	end
	self.curChannelIndex = channelIndex
	if not isSix then
		GlobalEventSystem:dispatchEvent(ChatEvent.CHANGE_SEND_CHANNEL, self:getCurChannel())
	end
	self:hideShow()
end

function ChatChannelSelectView:getCurChannel()
	if self.curChannelIndex == 5 then --军团
		return 7
	end
	return self.curChannelIndex
end

function ChatChannelSelectView:startShow()
	local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
	if self.scheId then
		scheduler.unscheduleGlobal(self.scheId)
	end
	self:setContentSize(self.itemSize.width, self.maxHeight)
	self.scheId = scheduler.scheduleUpdateGlobal(function()
		height = self.mask:getClippingRegion().height + 10
		self.mask:setClippingRegion(cc.rect(-self.itemSize.width/2,0,self.itemSize.width,height))
		if height >= self.maxHeight then
			self.mask:setClippingRegion(cc.rect(-self.itemSize.width/2,0,self.itemSize.width, self.maxHeight))
			scheduler.unscheduleGlobal(self.scheId)
			self.scheId = nil
			self.showing = true
		end
	end)
end

function ChatChannelSelectView:hideShow()
	if self.showing == false then return end
	self.showingAni = true
	local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
	if self.scheId then
		scheduler.unscheduleGlobal(self.scheId)
		self.scheId = nil
	end
	self.scheId = scheduler.scheduleUpdateGlobal(function()
		height = self.mask:getClippingRegion().height - 10
		self.mask:setClippingRegion(cc.rect(-self.itemSize.width/2,0,self.itemSize.width,height))
		if height<=self.itemSize.height then
			height = self.itemSize.height
			self:setContentSize(self.itemSize.width, height)
			self.mask:setClippingRegion(cc.rect(-self.itemSize.width/2,0,self.itemSize.width,height))
			scheduler.unscheduleGlobal(self.scheId)
			self.scheId = nil
			self.showing = false
			self.showingAni = false
		end
	end)
end

return ChatChannelSelectView