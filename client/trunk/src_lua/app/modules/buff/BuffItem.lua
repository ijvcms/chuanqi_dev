--
-- Author: Yi hanneng
-- Date: 2016-04-20 15:19:58
--
local BuffItem = BuffItem or class("BuffItem", function()return display.newNode()end)

function BuffItem:ctor()

	self.ccui = cc.uiloader:load("resui/buffWin_1.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function BuffItem:init()
	self.icon = cc.uiloader:seekNodeByName(self.ccui, "icon")
	self.name = cc.uiloader:seekNodeByName(self.ccui, "name")
	self.describe = cc.uiloader:seekNodeByName(self.ccui, "describe")
	self.time = cc.uiloader:seekNodeByName(self.ccui, "time")
	self.buff = cc.uiloader:seekNodeByName(self.ccui, "buff")
	self.nobuff = cc.uiloader:seekNodeByName(self.ccui, "nobuff")
end

function BuffItem:setView(data)

	if data == nil then
		self.nobuff:setVisible(true)
		self.buff:setVisible(false)
		return
	end

	self.nobuff:setVisible(false)
	self.buff:setVisible(true)

	self.tiemData = data.value

	local icon = display.newSprite(ResUtil.getGoodsIcon(data.icon)):addTo(self.icon)
	icon:setAnchorPoint(0.5,0.5)
	icon:setPosition(self.icon:getContentSize().width/2, self.icon:getContentSize().height/2)
	icon:setScale(0.6)
	self.name:setString(data.name)
	self.describe:setString(data.describe)
	if data.special == 1 then
		if data.value == 0 then
			self.time:setVisible(false)
		end
		self.time:setString("剩余:"..data.value)
	else
		self.time:setString("剩余时间:"..StringUtil.convertTime(data.value))
		if self.timeEventId == nil then
			self.timeEventId = GlobalTimer.scheduleGlobal(handler(self, self.update), 1)
		end
	end
	
end

function BuffItem:update(delay)

	if self.time ~= nil then

		self.tiemData = self.tiemData - delay
		if self.tiemData <= 0 then
			self.tiemData = 0
			GlobalTimer.unscheduleGlobal(self.timeEventId)
			self.timeEventId = nil
		end
		
		self.time:setString("剩余时间:"..StringUtil.convertTime(self.tiemData))

	end

end

function BuffItem:setData(data)
	if data == nil then
		return
	end
	self.data = data
	self:setView(data)
end

function BuffItem:getData()
	return self.data
end

function BuffItem:destory()

	if self.timeEventId ~= nil then
		GlobalTimer.unscheduleGlobal(self.timeEventId)
		self.timeEventId = nil
	end

end

return BuffItem