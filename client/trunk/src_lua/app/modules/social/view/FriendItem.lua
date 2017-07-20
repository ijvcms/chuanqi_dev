--
-- Author: Your Name
-- Date: 2015-12-14 20:25:18
--

FriendItem = FriendItem or class("FriendItem", function()
	return display.newNode()
end)

function FriendItem:ctor(data)
	local ccui = cc.uiloader:load("resui/friendItem.ExportJson")
    self:addChild(ccui)
    ccui:setPosition(-ccui:getBoundingBox().width/2, -ccui:getBoundingBox().height/2)
 
    self.data = data
    self.func = param
 
    local root = cc.uiloader:seekNodeByName(ccui, "root")
 	self.sprSel= cc.uiloader:seekNodeByName(ccui,"sprSel")
	self.lblName = cc.uiloader:seekNodeByName(ccui,"lblName")
	self.lblLv = cc.uiloader:seekNodeByName(ccui,"lblLv")
	self.lblJob = cc.uiloader:seekNodeByName(ccui,"lblJob")
    self.lblPower = cc.uiloader:seekNodeByName(ccui,"lblPower")
	self.lblState = cc.uiloader:seekNodeByName(ccui,"lblState")
  
	self.sprSel:setVisible(false)

	self:setView(data)
 
 
end
 
function FriendItem:setView(data)

	self.lblName:setString(data.name)
	self.lblLv:setString(data.lv)
	self.lblJob:setString(data.career)
	self.lblPower:setString(data.fight)

	if data.isonline == 1 then
		self.lblState:setString("在线")
	else
		self.lblState:setString("离线")
	end
 
end

function FriendItem:setSelect(b)
    self.sprSel:setVisible(b)
end

function FriendItem:setData(data)
  	self.data = data
  	self:setView(data)
end

function FriendItem:getData()
  return self.data
end

return FriendItem