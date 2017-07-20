--
-- Author: Yi hanneng
-- Date: 2016-03-29 17:20:32
--
local TeamNavItem = TeamNavItem or class("TeamNavItem", function() return display.newNode()end)

function TeamNavItem:ctor()
	self.ccui = cc.uiloader:load("resui/teamLead.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function TeamNavItem:init()

	self.Add = cc.uiloader:seekNodeByName(self.ccui, "Add")
	self.Create = cc.uiloader:seekNodeByName(self.ccui, "Create")
	self.line = cc.uiloader:seekNodeByName(self.ccui, "line")

	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	self.occupation = cc.uiloader:seekNodeByName(self.ccui, "occupation")
	self.name = cc.uiloader:seekNodeByName(self.ccui, "name")
	self.bar = cc.uiloader:seekNodeByName(self.ccui, "bar")
	self.leader = cc.uiloader:seekNodeByName(self.ccui, "leader")

	self.mainLayer:setVisible(false)
	self.Create:setVisible(false)	
	self.line:setVisible(false)
	self.Add:setVisible(false)

	self.Create:setTouchEnabled(true)
	self.Add:setTouchEnabled(true)

	self.Create:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.Create:setScale(1.1)
        elseif event.name == "ended" then
            self.Create:setScale(1)
 			--GlobalController.team:CreateTeam()
 			GlobalWinManger:openWin(WinName.TEAMWIN)
        end
        return true
    end)

    self.Add:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.Add:setScale(1.1)
        elseif event.name == "ended" then
            self.Add:setScale(1)
            --打开活动邀请界面
	 
            if self.itemClick then
            	self.itemClick()
            end  
 
        end
        return true
    end)
end

--[[

  <Param name="player_id" type="int64" describe="玩家id" /> 
  <Param name="name" type="string" describe="玩家姓名" /> 
  <Param name="type" type="int8" describe="玩家类型1队长 2队员" /> 
  <Param name="lv" type="int8" describe="等级" /> 
  <Param name="career" type="int16" describe="职业" /> 
  <Param name="guild_name" type="string" describe="所在行会名" /> 
  <Param name="fight" type="int32" describe="战斗力" /> 
  <Param name="is_online" type="int32" describe="是否在线" /> 
--]]

function TeamNavItem:setData(data)
	self.data = data

	if data.none then
		if data.none == 1 then
			self.Create:setVisible(true)
			self.mainLayer:setVisible(false)	
			self.Add:setVisible(false)
			self.line:setVisible(true)
		elseif data.none == 2  then
			self.Create:setVisible(false)
			self.mainLayer:setVisible(false)	
			self.Add:setVisible(true)
			self.line:setVisible(true)
		elseif data.none == 3 then
			self.mainLayer:setVisible(false)
			self.Create:setVisible(false)	
			self.line:setVisible(false)
			self.Add:setVisible(false)
		end
	else
		self.Create:setVisible(false)
		self.mainLayer:setVisible(true)	
		self.line:setVisible(false)
		self.Add:setVisible(false)
		self.line:setVisible(true)
 		 
		self.name:setString(data.name)
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

end

function TeamNavItem:setItemClick(func)
	self.itemClick = func
end

function TeamNavItem:setHp(percent)
	if self.bar then
		self.bar:setScaleX(percent)
	end
end

function TeamNavItem:getData()
	return self.data
end

function TeamNavItem:destory()
end

return TeamNavItem