--
-- Author: Your Name
-- Date: 2015-12-10 20:28:14
--
local MayaItem = class("MayaItem", function()
	return display.newNode()
	end)

function MayaItem:ctor(data)
	self.data = data
	local ccui = cc.uiloader:load("resui/mayaItem.json")
    self:addChild(ccui)

    local root = cc.uiloader:seekNodeByName(ccui, "root")
    local win = cc.uiloader:seekNodeByName(ccui, "win")
    self.nameLbl = cc.uiloader:seekNodeByName(ccui, "nameLbl")
    self.timeLbl = cc.uiloader:seekNodeByName(ccui, "timeLbl")

    self.nameLbl:setString(data.name)
    self.timeLbl:setString(StringUtil.convertTime(data.time))

	self.timeId = nil
    if data.time > 0 then
    	self.timeLbl:setColor(cc.c3b(0, 255, 0))
        self.timeId = GlobalTimer.scheduleGlobal(handler(self, self.update), 1)
    else
    	self.timeLbl:setString("已刷新")
		self.timeLbl:setColor(cc.c3b(0, 0, 0))
    end

    self:setNodeEventEnabled(true)
    
end

function MayaItem:onCleanup()
	self:destory()
end

function MayaItem:update(delay)

	if self.timeLbl ~= nil then
		self.data.time = self.data.time - delay
		if self.data.time < 0 then
			self.data.time = 0
			GlobalTimer.unscheduleGlobal(self.timeId)
			self.timeId = nil
			self.timeLbl:setString("已刷新")
			self.timeLbl:setColor(cc.c3b(0, 0, 0))
			return
		else
			self.timeLbl:setString(StringUtil.convertTime(self.data.time))
		end
		
		
	end
end

function MayaItem:destory()
	if self.timeId ~= nil then
		GlobalTimer.unscheduleGlobal(self.timeId)
		self.timeId = nil
	end
end



return MayaItem