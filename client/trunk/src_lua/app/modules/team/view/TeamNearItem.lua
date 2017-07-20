--
-- Author: Yi hanneng
-- Date: 2016-04-06 19:37:27
--
local TeamNearItem = TeamNearItem or class("TeamNearItem", function() return display.newNode()end)

function TeamNearItem:ctor()

	self:setAnchorPoint(0,0.5)
	self.ccui = cc.uiloader:load("resui/teamItem.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function TeamNearItem:init()

	self.itemClickFun = nil

	self.name = cc.uiloader:seekNodeByName(self.ccui, "name")
	self.occupation = cc.uiloader:seekNodeByName(self.ccui, "occupation")
	self.level = cc.uiloader:seekNodeByName(self.ccui, "level")
	self.number = cc.uiloader:seekNodeByName(self.ccui, "power")
	self.union = cc.uiloader:seekNodeByName(self.ccui, "union")
 
end

function TeamNearItem:setData(data)

	if data == nil then
		return 
	end
 
	self.data = data
	self.name:setString(data.name) 
	self.level:setString(data.lv)
	self.union:setString(data.guild_name) 
	self.number:setString(data.memeber_num)
	
	if data.career == 1000 then
		self.occupation:setSpriteFrame("com_carrerIcon1.png")
	elseif data.career == 2000 then
		self.occupation:setSpriteFrame("com_carrerIcon2.png")
	elseif data.career == 3000 then
		self.occupation:setSpriteFrame("com_carrerIcon3.png")
	end

end

function TeamNearItem:getData()
	return self.data
end

return TeamNearItem