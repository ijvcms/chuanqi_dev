--
-- Author: Yi hanneng
-- Date: 2016-03-10 09:51:04
--
local DragonList = DragonList or class("DragonList", function() return display.newNode() end )

function DragonList:ctor()
	self.ccui = cc.uiloader:load("resui/DamageList.ExportJson")
  	self:addChild(self.ccui)
   	
   	self:init()
end

function DragonList:init()

	self.itemList = {}

	self.retractBtn = cc.uiloader:seekNodeByName(self.ccui, "retractBtn")
	self.retractBtn:setScaleX(-1)
	self.layer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")

	self.showPoint = self.layer:getPositionX()
	self.hidePoint = self.layer:getPositionX() - 176
	self.btnState = true

	self.retractBtn:setTouchEnabled(true)
	self.retractBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
             if self.btnState then
             	self:hide()	
             else
             	self:show()
             end
 
        end
        return true
    end)

	for i=1,5 do
		local item = self:createItem(nil,cc.size(self.layer:getContentSize().width - 20, 40))
		self.itemList[i] = item
		self.layer:addChild(item)
		item:setPosition(-20, 152 - (i-1)*28)
		self.itemList[i]:setVisible(false)
	end
	--NodeEvent
	 
	GlobalEventSystem:addEventListener(GragonEvent.GRAGON_UPDATE_INFO,handler(self,self.setViewInfo))
	 
end
 
function DragonList:hide()
	if self.layer then
		--todo
	local action = cc.MoveTo:create(0.3, cc.p(self.hidePoint, self.layer:getPositionY()))	
    local action2 = cc.CallFunc:create(function() 
	    --self.retractBtn:setScaleX(-1)
	    self.retractBtn:setScaleX(1)
	    self.btnState = false 
    end)       
    self.layer:stopAllActions()
	self.layer:runAction(transition.sequence({action,action2}))
	end

end

function DragonList:show()
	if self.layer then
	local action = cc.MoveTo:create(0.3, cc.p(self.showPoint, self.layer:getPositionY()))					
	local action3 = cc.CallFunc:create(function()
		self.retractBtn:setScaleX(-1)
		self.btnState = true 
	end)     
	self.layer:stopAllActions()  
	self.layer:runAction(transition.sequence({action,action3}))
end

end

function DragonList:setViewInfo(data)

	if self.itemList == nil then
		return
	end

	data = data.data
 
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
		self.myItem = self:createItem({rank = data.player_rank,name = RoleManager:getInstance().roleInfo.name,harm = data.player_harm},cc.size(200, 40),true)
		self.layer:addChild(self.myItem)
		self.myItem:setPosition(-20, 0)
	else
		self:setItemData(self.myItem,{rank = data.player_rank,name = RoleManager:getInstance().roleInfo.name,harm = data.player_harm})
	end

end

function DragonList:createItem(data,size,isSelf)
	local node = display.newNode()
	node:setContentSize(cc.size(size.width, size.height))
	node:setAnchorPoint(0,0)
	local numLabel = display.newTTFLabel({size = 16})
    numLabel:setColor(TextColor.TITLE)
    numLabel:setAnchorPoint(0,0.5)
    numLabel:setPosition(35,20)

    display.setLabelFilter(numLabel)

    local nameLabel = display.newTTFLabel({size = 16})

    if isSelf ~= nil and isSelf then
    	nameLabel:setColor(TextColor.TEXT_G)
    else
    	nameLabel:setColor(TextColor.TITLE)
    end
    
    nameLabel:setAnchorPoint(0,0.5)
    nameLabel:setPosition(50,20)

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

    numLabel:setString("data")
	nameLabel:setString("data")
	countLabel:setString("data")

    if data then
    	numLabel:setString(data.rank)
	    nameLabel:setString(data.name)
	    countLabel:setString(data.harm)
    end
    
    return node

end

function DragonList:setItemData(item,data)
	if item then
		if item:getChildByTag(10) then
			item:getChildByTag(10):setString(data.rank)
		end

		if item:getChildByTag(11) then
			item:getChildByTag(11):setString(data.name)
		end

		if item:getChildByTag(12) then
			item:getChildByTag(12):setString(data.harm)
		end
	end
end

function DragonList:destory()
	GlobalEventSystem:removeEventListener(GragonEvent.GRAGON_UPDATE_INFO)
	self:removeSelf()
end

function DragonList:close()
	self:destory()
end

return DragonList