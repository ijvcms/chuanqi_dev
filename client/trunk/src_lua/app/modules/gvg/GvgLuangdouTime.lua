--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-11-22 20:39:38
--

local GvgLuangdouTime = class("GvgLuangdouTime", function()
	return display.newNode() --cc.Sprite:create() -- 
end)

function GvgLuangdouTime:ctor(data)	
	self.bg = display.newSprite("#com_nameBg.png")
	self:addChild(self.bg)

	self.tipText = display.newTTFLabel({text = "敌我变更倒计时:",
             size = 18,color = TextColor.TEXT_WHITE})
                 :align(display.CENTER,0,0)
                 :addTo(self)
    self.tipText:setPosition(-100,0)             
	self.powerLab = cc.LabelAtlas:_create()
    self.powerLab:initWithString(
              "1",
              "fonts/countFont_0.png",
              70,
              90,
              string.byte(0))
    self.powerLab:setTouchEnabled(false)
    self:addChild(self.powerLab)
    self.powerLab:setPosition(0,-18)   
    --self.powerLab:setAnchorPoint(0,0)
    --self.powerLab:setString(0)
end

function GvgLuangdouTime:update()
	if math.floor(self.time) >= 0 then
		self.powerLab:setString(self.time)
		self.time = self.time - 1
	else
		self:close()
	end
end


function GvgLuangdouTime:open(time)
	self:setVisible(true)
	self.time = math.floor(time)
	self.powerLab:setString(self.time)
	if self.timerId == nil then
        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.update),1)--GlobalTimer.scheduleUpdateGlobal(handler(self,self.playTurn))
    end
end

function GvgLuangdouTime:close()
	self:setVisible(false)
	if self.timerId then
        GlobalTimer.unscheduleGlobal(self.timerId)
        self.timerId = nil
    end
end
return GvgLuangdouTime