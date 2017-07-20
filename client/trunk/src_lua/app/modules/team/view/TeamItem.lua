--
-- Author: Yi hanneng
-- Date: 2016-03-30 11:38:58
--

local TeamItem = TeamItem or class("TeamItem", function() return display.newNode()end)

function TeamItem:ctor()
	self:setAnchorPoint(0,0.5)
	self.ccui = cc.uiloader:load("resui/teamItem.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function TeamItem:init()
	self.name = cc.uiloader:seekNodeByName(self.ccui, "name")
	self.occupation = cc.uiloader:seekNodeByName(self.ccui, "occupation")
	self.level = cc.uiloader:seekNodeByName(self.ccui, "level")
	self.union = cc.uiloader:seekNodeByName(self.ccui, "union")
	self.level = cc.uiloader:seekNodeByName(self.ccui, "level")
	self.power = cc.uiloader:seekNodeByName(self.ccui, "power")
	self.leader = cc.uiloader:seekNodeByName(self.ccui, "leader")
end

function TeamItem:setData(data)
	self.data = data
 
	self.name:setString(data.name) 
	self.level:setString(data.lv)
	self.union:setString(data.guild_name)
	self.power:setString(data.fight)
	
	if data.career == 1000 then
		self.occupation:setSpriteFrame((data.is_online == 1 and "com_carrerIcon1.png")or "com_carrerIcon1Off.png")
	elseif data.career == 2000 then
		self.occupation:setSpriteFrame((data.is_online == 1 and "com_carrerIcon2.png")or "com_carrerIcon2Off.png")
	elseif data.career == 3000 then
		self.occupation:setSpriteFrame((data.is_online == 1 and "com_carrerIcon3.png")or "com_carrerIcon3Off.png")
	end
	
	if data.type == 1 then
		self.leader:setVisible(true)
	else
		self.leader:setVisible(false)
	end

end

function TeamItem:setItemClick(func)
	self.itemClick = func
end

function TeamItem:getData()
	return self.data
end

return TeamItem