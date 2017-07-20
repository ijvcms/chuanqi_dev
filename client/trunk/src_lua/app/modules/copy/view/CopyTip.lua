--
-- Author: Your Name
-- Date: 2015-12-15 18:17:07
--
local  CopyTip = CopyTip or class("CopyTip", BaseView)

function CopyTip:ctor(winTag,data,winconfig)

	--CopyTip.super.ctor(self, winTag,data,winconfig)
 
	local ccui = cc.uiloader:load("resui/copyInformation.ExportJson")
  	self:addChild(ccui)
  	self:setContentSize(cc.size(ccui:getContentSize().width,ccui:getContentSize().height))
  	local root = cc.uiloader:seekNodeByName(ccui,"root")
  	root:setTouchEnabled(true)
  	root:setTouchSwallowEnabled(true)

  	self.monsterLbl = cc.uiloader:seekNodeByName(root,"number1")
	self.bossLbl = cc.uiloader:seekNodeByName(root,"number2")
	self.timeLbl = cc.uiloader:seekNodeByName(root,"time")

	self.proLbl = display.newTTFLabel({
            text = "0",      
            size = 16,
            color = TextColor.BTN_W, 
    })
    display.setLabelFilter(self.proLbl)
    root:addChild(self.proLbl)
    self.proLbl:setPosition(self.monsterLbl:getPositionX(),self.monsterLbl:getPositionY() + self.monsterLbl:getPositionY() - self.bossLbl:getPositionY())

    --GlobalEventSystem:addEventListener(CopyEvent.COPY_ENTERCOPY, handler(self, self.setView))
	GlobalEventSystem:addEventListener(CopyEvent.COPY_TIPINFO, handler(self, self.setInfo))

end

function CopyTip:update(delay)

	if self.timeLbl ~= nil then

		self.data.time = self.data.time - delay
		if self.data.time <= 0 then
			self.data.time = 0
			GlobalTimer.unscheduleGlobal(self.timeId)
			self.timeId = nil
		end
		
		self.timeLbl:setString(StringUtil.convertTime(self.data.time))

	end
end

function CopyTip:setView(data)
 GameNet:sendMsgToSocket(11014)
end

function CopyTip:setInfo(data)

	data = data.data
	self.monsterLbl:setString(data.kill_monster.."/"..data.monster_count)
	self.bossLbl:setString(data.kill_boss.."/"..data.boss_count)
	self.proLbl:setString("第"..data.round.."波")
	if data.time > 0  and self.timeId == nil then
		self.data = data
        self.timeId = GlobalTimer.scheduleGlobal(handler(self, self.update), 1)
        self.timeLbl:setString(StringUtil.convertTime(self.data.time)) 
    end
end

function CopyTip:destory()
	if self.timeId ~= nil then
		GlobalTimer.unscheduleGlobal(self.timeId)
		self.timeId = nil
		--GlobalEventSystem:removeEventListener(CopyEvent.COPY_ENTERCOPY)
		--GlobalEventSystem:removeEventListener(CopyEvent.COPY_TIPINFO)
	end
  
	GlobalEventSystem:removeEventListener(CopyEvent.COPY_TIPINFO)
 
	self:removeSelf()
end

function CopyTip:close()
	
	self:destory()
end

return CopyTip