--
-- Author: Yi hanneng
-- Date: 2016-04-05 19:22:57
--

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local NearItem = NearItem or class("NearItem", UIAsynListViewItemEx)

function NearItem:ctor(loader, layoutFile)
	self.ccui = loader:BuildNodesByCache(layoutFile)
	--self.ccui = cc.uiloader:load("resui/NearByItem.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function NearItem:init()
	self.name = cc.uiloader:seekNodeByName(self.ccui, "name")
	self.occupation = cc.uiloader:seekNodeByName(self.ccui, "occupation")
	self.level = cc.uiloader:seekNodeByName(self.ccui, "level")
	self.monsterType = cc.uiloader:seekNodeByName(self.ccui, "monsterType")
	self.select = cc.uiloader:seekNodeByName(self.ccui, "select")
	self.monsterType:setVisible(false)
	self.select:setVisible(false)
end

function NearItem:setData(data)

	if data == nil then
		return
	end

	self.data = data
	local info = data
	self.name:setString(info.name)
	self.level:setString(info.lv) 
	self.monsterType:setVisible(false)

	if info.career == 1000 then
		self.occupation:setVisible(true)
		self.occupation:setSpriteFrame("com_carrerIcon1.png")
	elseif info.career == 2000 then
		self.occupation:setVisible(true)
		self.occupation:setSpriteFrame("com_carrerIcon2.png")
	elseif info.career == 3000 then
		self.occupation:setVisible(true)
		self.occupation:setSpriteFrame("com_carrerIcon3.png")
	else
		self.monsterType:setVisible(true)
		self.occupation:setVisible(false)
		self.monsterType:setString( (info.mConf.type == 2 and "精英") or "BOSS")
	end

end

function NearItem:getData()
	return self.data
end

function NearItem:setSelect(b)
	self.select:setVisible(b)
end

function NearItem:isSelected()
	return self.select:isVisible()
end

return NearItem