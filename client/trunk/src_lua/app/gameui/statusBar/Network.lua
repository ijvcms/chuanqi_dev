--@author shine
--网络状态
local NetworkMonitor = require("app.gameui.statusBar.NetworkMonitor")
local Network =  class("Network", function() return display.newNode() end)

function Network:ctor()
	self.showImg = display.newSprite("#scene/scene_wifi3.png")
	self:addChild(self.showImg)
	self:setContentSize(self.showImg:getContentSize())
	self:handleNetworkTypeListener({data = GlobalController.networkMonitor.networkType})
	self.typeHandler = GlobalEventSystem:addEventListener(NetworkMonitorEvent.EVENT_TYPE_CHANGED,handler(self, self.handleNetworkTypeListener))
	self.speedHandler = GlobalEventSystem:addEventListener(NetworkMonitorEvent.EVENT_SPEED_CHANGED,handler(self, self.handleNetworkSpeedListener))
    self.showImg:setNodeEventEnabled(true, function(event)
        if event.name == "cleanup" then
        	GlobalEventSystem:removeEventListenerByHandle(self.speedHandler)
        	GlobalEventSystem:removeEventListenerByHandle(self.typeHandler)
        end 
	end)
end

function Network:handleNetworkTypeListener(data)
	self.ntType = data.data
	self:handleNetworkSpeedListener({data = 2})
end

function Network:handleNetworkSpeedListener(data)
	local time = data.data
	if self.ntType == 2 then
		if time > 0.2 then
		    self.showImg:setSpriteFrame("scene/scene_wifi3.png");
	    elseif time > 0.15 then
            self.showImg:setSpriteFrame("scene/scene_wifi2.png");
	    elseif time > 0.1 then
            self.showImg:setSpriteFrame("scene/scene_wifi1.png");
	    else
            self.showImg:setSpriteFrame("scene/scene_wifi3.png");
	    end
	else
		if time > 0.2 then
		    self.showImg:setSpriteFrame("scene/scene_wifi3.png");
	    elseif time > 0.15 then
            self.showImg:setSpriteFrame("scene/scene_wifi2.png");
	    elseif time > 0.1 then
            self.showImg:setSpriteFrame("scene/scene_wifi1.png");
	    else
            self.showImg:setSpriteFrame("scene/scene_wifi3.png");
	    end
	end
end

return Network