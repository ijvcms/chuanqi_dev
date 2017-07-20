--
-- Author: Yi hanneng
-- Date: 2016-04-01 17:46:37
--
local TeamInviteItem = TeamInviteItem or class("TeamInviteItem", function() return display.newNode()end)

function TeamInviteItem:ctor()

	self.ccui = cc.uiloader:load("resui/teamInviteItem.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function TeamInviteItem:init()

	self.itemClickFun = nil

	self.name = cc.uiloader:seekNodeByName(self.ccui, "Name")
	self.occupation = cc.uiloader:seekNodeByName(self.ccui, "occupation")
	self.level = cc.uiloader:seekNodeByName(self.ccui, "level")
	self.btnInvite = cc.uiloader:seekNodeByName(self.ccui, "btnInvite")
	self.power = cc.uiloader:seekNodeByName(self.ccui, "power")


	self.btnInvite:setTouchEnabled(true)
	self.btnInvite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnInvite:setScale(1.1)
        elseif event.name == "ended" then
            self.btnInvite:setScale(1)
	 		
	 		if self.itemClickFun ~= nil then
	 			self.itemClickFun(self.data)
	 		end
        end
        return true
    end)
end

function TeamInviteItem:setData(data)

	if data == nil then
		return 
	end
 
	self.data = data
	if data.name then
		self.name:setString(data.name)
	else
		self.name:setString(data.player_name)
	end
	self.level:setString(data.lv)
	if data.fight then
		self.power:setString(data.fight)
	elseif data.fighting then
		self.power:setString(data.fighting)
	else
		self.power:setString(data.guild_name)
	end
	

	if data.career == 1000 then
		if data.isonline == nil then
			self.occupation:setSpriteFrame("com_carrerIcon1.png")
		else
			self.occupation:setSpriteFrame((data.isonline == 1 and "com_carrerIcon1.png")or "com_carrerIcon1Off.png")
		end
		
	elseif data.career == 2000 then
		if data.isonline == nil then
			self.occupation:setSpriteFrame("com_carrerIcon2.png")
		else
			self.occupation:setSpriteFrame((data.isonline == 1 and "com_carrerIcon2.png")or "com_carrerIcon2Off.png")
		end
	elseif data.career == 3000 then
		if data.isonline == nil then
			self.occupation:setSpriteFrame("com_carrerIcon3.png")
		else
			self.occupation:setSpriteFrame((data.isonline == 1 and "com_carrerIcon3.png")or "com_carrerIcon3Off.png")
		end
	end

end

function TeamInviteItem:setItemClickFunc(func)
	self.itemClickFun = func
end


return TeamInviteItem