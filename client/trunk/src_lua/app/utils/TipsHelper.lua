--
-- Author: Your Name
-- Date: 2015-01-20 14:37:45
--
local TipsHelper = {}
regObjInGlobal("TipsHelper",TipsHelper)

--添加提示
--type 1.物品提示
function TipsHelper:addTips(Sprite,p,tiptype)
	Sprite:setTouchEnabled(true)
	tiptype = tiptype or 1
	p = p or {}
	Sprite.eventId = Sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			-- print("开始")
			self.startTime = socket.gettime()
        elseif event.name == "moved" then
        	-- print("移动")
        elseif event.name == "ended" then
        	-- print("关闭")
        	self.endTime = socket.gettime()
        	self.passTime = self.endTime-self.startTime
        	print("经过的时间为",self.passTime)
        	if self.passTime >= 0.5 then
        		GlobalWinManger:openWin(WinName.BAGTIPS,p)
        	end
        end
		return true
	end)
end

--删除提示
function TipsHelper:removeTips(Sprite)
	if Sprite.eventId then
		Sprite:removeNodeEventListener(Sprite.eventId)
	end
end

return TipsHelper