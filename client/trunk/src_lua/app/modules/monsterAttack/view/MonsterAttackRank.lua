--
-- Author: Yi hanneng
-- Date: 2016-06-27 19:17:57
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local MonsterAttackRank = MonsterAttackRank or class("MonsterAttackRank", function() return display.newNode() end )

function MonsterAttackRank:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/monsterAttackRankWin.ExportJson")
  	self:addChild(self.ccui)
   	self.ccui:setPosition((display.width-self.ccui:getContentSize().width)/2,(display.height-self.ccui:getContentSize().height)/2)
 
   	self:init()
end

function MonsterAttackRank:init()

	self.itemList = {}

	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
	self.layer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
 
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	self.closeBtn:setScale(1.1)
         elseif event.name == "ended" then
        	self.closeBtn:setScale(1)
        	self:destory()
        end
        return true
    end)


    for i=1,5 do
		local item = self:createItem(nil,cc.size(self.layer:getContentSize().width - 20, 40))
		self.itemList[i] = item
		self.layer:addChild(item)
		item:setPosition(10, 200 - (i-1)*38)
		self.itemList[i]:setVisible(false)
	end

 
end
 

function MonsterAttackRank:setViewInfo(data)

	if data == nil then
		return
	end
 
	--设置自己排名和伤害

	if self.itemList and #self.itemList > #data.rank_list then
		for i=#data.rank_list + 1,#self.itemList do
			self.itemList[i]:setVisible(false)
		end
	end

	if #data.rank_list > 1 then
		table.sort(data.rank_list,function(a,b)  return a.rank < b.rank end)
	end
	

	for i=1,#data.rank_list do
		if self.itemList[i] then
			self:setItemData(self.itemList[i],data.rank_list[i])
			self.itemList[i]:setVisible(true)
		end
	end

	--设置自己排名和伤害
	if self.myItem == nil then
		self.myItem = self:createItem({rank = data.player_rank,name = RoleManager:getInstance().roleInfo.name,score = data.player_score},cc.size(200, 40),true)
		self.layer:addChild(self.myItem)
		self.myItem:setPosition(20, 0)
	else
		self:setItemData(self.myItem,{rank = data.player_rank,name = RoleManager:getInstance().roleInfo.name,score = data.player_score})
	end


end

function MonsterAttackRank:createItem(data,size,isSelf)
	local node = display.newNode()
	node:setContentSize(cc.size(size.width, size.height))
	node:setAnchorPoint(0,0)
	local numLabel = display.newTTFLabel({size = 20})
    numLabel:setColor(cc.c3b( 221,206,175))
    numLabel:setAnchorPoint(0,0.5)
    numLabel:setPosition(5,20)

    display.setLabelFilter(numLabel)

    local nameLabel = display.newTTFLabel({size = 20})

    if isSelf ~= nil and isSelf then
    	nameLabel:setColor(cc.c3b(240,243,20))
    else
    	nameLabel:setColor(cc.c3b( 221,206,175))
    end
    
    nameLabel:setAnchorPoint(0,0.5)
    nameLabel:setPosition(25,20)

    display.setLabelFilter(nameLabel)

	local countLabel = display.newTTFLabel({size = 20})
    countLabel:setColor(cc.c3b(235,12,16))
    countLabel:setAnchorPoint(0,0.5)
    countLabel:setPosition(155,20)

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

function MonsterAttackRank:setItemData(item,data)
	if item then
		if item:getChildByTag(10) then
			item:getChildByTag(10):setString(data.rank)
		end

		if item:getChildByTag(11) then
			item:getChildByTag(11):setString(data.name)
		end

		if item:getChildByTag(12) then
			item:getChildByTag(12):setString(data.score)
		end
	end
end

function MonsterAttackRank:destory()
 
	self:close()
	self:removeSelf()
end

function MonsterAttackRank:close()
	 
	 
end

return MonsterAttackRank