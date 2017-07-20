--
-- Author: Yi hanneng
-- Date: 2016-06-28 09:56:49
--
local MonsterAttackResultView = MonsterAttackResultView or class("MonsterAttackResultView", BaseView)
function MonsterAttackResultView:ctor(winTag,data,winconfig)

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/monsterAttackRewardWin.ExportJson")
  	self:addChild(self.ccui)
   	self.ccui:setPosition((display.width-self.ccui:getContentSize().width)/2,(display.height-self.ccui:getContentSize().height)/2)
   	self:init()
end

function MonsterAttackResultView:init()
 
	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
	self.rankLabel = cc.uiloader:seekNodeByName(self.ccui, "rankLabel")

	self.pointLabel = cc.uiloader:seekNodeByName(self.ccui, "pointLabel")

	self.successLabel = cc.uiloader:seekNodeByName(self.ccui, "successLabel")
	self.defeatLabel = cc.uiloader:seekNodeByName(self.ccui, "defeatLabel")	
	self.damageLabel = cc.uiloader:seekNodeByName(self.ccui, "damageLabel")
	self.defeatLabel:setVisible(false)
	
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


function MonsterAttackResultView:onNodeEvent(data)
	if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
    	self:unregisterEvent()
    end
end

function MonsterAttackResultView:registerEvent()
	GlobalEventSystem:addEventListener(MonsterAttackEvent.MONSTER_OPEN_REWARD,handler(self,self.setViewInfo))
end

function MonsterAttackResultView:unregisterEvent()
	GlobalEventSystem:removeEventListener(MonsterAttackEvent.MONSTER_OPEN_REWARD)
end


function MonsterAttackResultView:setViewInfo(data)

	--设置自己排名和伤害
	self.rankLabel:setString(data.player_rank)
	self.pointLabel:setString(data.player_score)
	 
	--设置奖励信息
	self:createRewardItem(data.player_rank,data.type == 2 and 1 or 0)
	if #data.rank_list > 1 then
		table.sort(data.rank_list,function(a,b)  return a.rank < b.rank end)
	end
	
	for i=1,#data.rank_list do
		
		local item = self:createItem(data.rank_list[i],cc.size(200, 40))
		if item then
			self.ccui:addChild(item)
			item:setPosition(self.damageLabel:getPositionX() - item:getContentSize().width/2 - 35, self.damageLabel:getPositionY()-i*30 - 30)
		end
	end
end

function MonsterAttackResultView:createRewardItem(rank,win)

	self.successLabel:setVisible(win == 1)
	self.defeatLabel:setVisible(win == 0)

	local data = configHelper:getMonsterAttackRewardByRank(rank,win)
	for i=1,#data do
		local item = display.newSprite("#com_propBg1.png")
		local commonItem = CommonItemCell.new()
		commonItem:setData({goods_id = data[i][1],is_bind = data[i][2]})
		commonItem:setCount(data[i][3])
		item:addChild(commonItem)
		self.ccui:addChild(item)
		item:setPosition((item:getContentSize().width+20)*i + 62, 76)
		commonItem:setPosition(commonItem:getContentSize().width/2, commonItem:getContentSize().height/2)
		--commonItem:setScale(0.8)

	end

end

function MonsterAttackResultView:createItem(data,size,isSelf)
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
    countLabel:setPosition(165,20)

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
return MonsterAttackResultView