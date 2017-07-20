--@author shine
--状态栏
local StatusBar =  class("StatusBar", function() return display.newNode() end)

function StatusBar:ctor()
	local width, height = 0, 0
	self.clock = require("app.gameui.statusBar.Clock").new()
	if self.clock:getContentSize().height > height then
	    height = self.clock:getContentSize().height
	end
	width = self.clock:getContentSize().width
	self:addChild(self.clock)
	self.battery = require("app.gameui.statusBar.Battery").new()
	self.battery:setPositionX(width)
	if self.battery:getContentSize().height > height then
	    height = self.battery:getContentSize().height
	end
	width = width + self.battery:getContentSize().width
	self:addChild(self.battery)
	self.network = require("app.gameui.statusBar.Network").new()
	self.network:setPositionX(width-2)
	if self.network:getContentSize().height > height then
	    height = self.network:getContentSize().height
	end
	width = width + self.network:getContentSize().width
	self:addChild(self.network)
	self.clock:setPositionY(height / 2)
	self.battery:setPositionY(height / 2)
	self.network:setPositionY(height / 2)
	self:setContentSize(width, height)
end



return StatusBar