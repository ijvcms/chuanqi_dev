-- 答题奖励说明
-- Author: Shine
-- Date: 2016-07-26 
--
local AnsweringRewardView =  class("AnsweringRewardView", BaseView)

function AnsweringRewardView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/examinationRewardWin.ExportJson")
  	self:addChild(self.ccui)
   	self.ccui:setPosition((display.width-self.ccui:getContentSize().width)/2,(display.height-self.ccui:getContentSize().height)/2)
   	self:init()
end

function AnsweringRewardView:init()
 
	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
	
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	            if self:getParent() then
    				self:removeSelf()
  				end	        
			end     
	        return true
    end)

end


function AnsweringRewardView:setViewInfo()

	local data = configHelper:getAnsweringRewardConfig()

	for i = 1, 5 do
		local layer = cc.uiloader:seekNodeByName(self.ccui, "Layer"..i)
		self:createRewardItem(layer, data[i].reward_list)
	end
end

function AnsweringRewardView:createRewardItem(layer, item_data)

	for i=1,#item_data do
		local item = display.newSprite("#com_propBg1.png")
		local commonItem = CommonItemCell.new()
		commonItem:setData({goods_id = item_data[i][1],is_bind = item_data[i][2]})
		commonItem:setCount(item_data[i][3])
		item:addChild(commonItem)
		layer:addChild(item)
		item:setPosition(36 + (item:getContentSize().width + 13) * (i - 1), 44)
		commonItem:setPosition(commonItem:getContentSize().width/2, commonItem:getContentSize().height/2)
		--commonItem:setScale(0.8)

	end

end

function AnsweringRewardView:createItem(data,size,isSelf)
	local node = display.newNode()
	node:setContentSize(cc.size(size.width, size.height))
	node:setAnchorPoint(0,0)
	local numLabel = display.newTTFLabel({size = 16})
    numLabel:setColor(TextColor.TITLE)
    numLabel:setAnchorPoint(0,0.5)
    numLabel:setPosition(45,20)

    display.setLabelFilter(numLabel)

    local nameLabel = display.newTTFLabel({size = 16})

    if isSelf ~= nil and isSelf then
    	nameLabel:setColor(TextColor.TITLE)
    else
    	nameLabel:setColor(TextColor.TITLE)
    end
    
    nameLabel:setAnchorPoint(0,0.5)
    nameLabel:setPosition(68,20)

    display.setLabelFilter(nameLabel)

	local countLabel = display.newTTFLabel({size = 16})
    countLabel:setColor(TextColor.TITLE)
    countLabel:setAnchorPoint(0,0.5)
    countLabel:setPosition(150,20)

    display.setLabelFilter(countLabel)

    node:addChild(numLabel)
    node:addChild(nameLabel)
    node:addChild(countLabel)

    numLabel:setTag(10)
    nameLabel:setTag(11)
    countLabel:setTag(12)
    if data then
    numLabel:setString(data.rank)
    nameLabel:setString(data.name)
    countLabel:setString(data.score)
	end

    return node

end

return AnsweringRewardView




