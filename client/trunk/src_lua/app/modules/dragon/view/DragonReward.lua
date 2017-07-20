--
-- Author: Yi hanneng
-- Date: 2016-03-10 09:51:43
--
local DragonReward = DragonReward or class("DragonReward", function() return display.newNode() end )

function DragonReward:ctor(winTag,data,winconfig)

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/DragonReward.ExportJson")
  	self:addChild(self.ccui)
   	self.ccui:setPosition((display.width-self.ccui:getContentSize().width)/2,(display.height-self.ccui:getContentSize().height)/2)
   	self:init()
end

function DragonReward:init()

	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
	self.damageLabel = cc.uiloader:seekNodeByName(self.ccui, "damageLabel")
	self.rank = cc.uiloader:seekNodeByName(self.ccui, "rank")
	self.damage = cc.uiloader:seekNodeByName(self.ccui, "damage")
	-- self.amount = cc.uiloader:seekNodeByName(self.ccui, "amount")
	-- self.item1 = cc.uiloader:seekNodeByName(self.ccui, "item1")
	-- self.item2 = cc.uiloader:seekNodeByName(self.ccui, "item2")
	-- self.item3 = cc.uiloader:seekNodeByName(self.ccui, "item3")


	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	            if self:getParent() then
    				--self:setVisible(false)
    				self:removeSelfSafety()
    				
  				end	        
			end     
	        return true
    end)

	--NodeEvent
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end


function DragonReward:onNodeEvent(data)
	if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
    	self:unregisterEvent()
    	--通用素材，不能删除
    end
end

function DragonReward:registerEvent()
	GlobalEventSystem:addEventListener(GragonEvent.GRAGON_OPEN_REWARD,handler(self,self.setViewInfo))
end

function DragonReward:unregisterEvent()
	GlobalEventSystem:removeEventListener(GragonEvent.GRAGON_OPEN_REWARD)
end


function DragonReward:setViewInfo(data)

	--data = data.data
	self.itemList = {}
	if #data.rank_list > 1 then
		table.sort(data.rank_list,function(a,b)  return a.rank < b.rank end)
	end
	
	for i=1,#data.rank_list do
		
		local item = self:createItem(data.rank_list[i],cc.size(220, 40))
		if item then
			self.itemList[i] = item
			self.ccui:addChild(item)
			item:setPosition(self.damageLabel:getPositionX() - item:getContentSize().width/2 - 35, self.damageLabel:getPositionY()-i*30 - 30)
		end
	end

	--设置自己排名和伤害
	self.rank:setString(data.player_rank)
	self.damage:setString(data.player_harm)
 
	--设置奖励信息

	self:createRewardItem(data.player_rank)
end

function DragonReward:createRewardItem(rank)

	local data = configHelper:getDragonRewardByRank(rank)

	local temp = 1
	for i=1,#data do
		
		local commonItem = CommonItemCell.new()
		commonItem:setData({goods_id = data[i][1],is_bind = data[i][2]})
		commonItem:setCount(data[i][3])
		
		self.ccui:addChild(commonItem)

		local x = 130 * i
		if i == 1 then
			x = x + 40
		elseif i > 2 then

			x = x - (temp * 40)
			temp = temp + 1
		end
		commonItem:setPosition(x , 70)
		--commonItem:setScale(0.8)

	end

end

function DragonReward:createItem(data,size,isSelf)
	local node = display.newNode()
	node:setContentSize(cc.size(size.width, size.height))
	node:setAnchorPoint(0,0)
	local numLabel = display.newTTFLabel({size = 16})
    numLabel:setColor(TextColor.TITLE)
    numLabel:setAnchorPoint(0,0.5)
    numLabel:setPosition(30,20)

    display.setLabelFilter(numLabel)

    local nameLabel = display.newTTFLabel({size = 16})

    if isSelf ~= nil and isSelf then
    	nameLabel:setColor(TextColor.TITLE)
    else
    	nameLabel:setColor(TextColor.TITLE)
    end
    
    nameLabel:setAnchorPoint(0,0.5)
    nameLabel:setPosition(53,20)

    display.setLabelFilter(nameLabel)

	local countLabel = display.newTTFLabel({size = 16})
    countLabel:setColor(TextColor.TITLE)
    countLabel:setAnchorPoint(0,0.5)
    countLabel:setPosition(170,20)

    display.setLabelFilter(countLabel)

    node:addChild(numLabel)
    node:addChild(nameLabel)
    node:addChild(countLabel)

    numLabel:setTag(10)
    nameLabel:setTag(11)
    countLabel:setTag(12)

    numLabel:setString(data.rank)
    nameLabel:setString(data.name)
    countLabel:setString(data.harm)

    return node

end

return DragonReward