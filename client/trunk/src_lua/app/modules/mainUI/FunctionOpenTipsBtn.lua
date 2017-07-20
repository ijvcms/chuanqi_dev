--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-22 19:52:38
-- 功能开放提示按钮
local FunctionOpenTipsBtn = class("FunctionOpenTipsBtn", function()
	return display.newNode()
end)

function FunctionOpenTipsBtn.create(param)
	return FunctionOpenTipsBtn.new(param)
end

function FunctionOpenTipsBtn:ctor(param)
	self.widthHalf = 130/2
	self.heighthalf = 48/2
	self.bg = display.newSprite("#scene/scene_btnListBg.png")
	self:addChild(self.bg)
	self.openTipsStr = display.newSprite("#scene/scene_textOpenTips.png")
    self.bg:addChild(self.openTipsStr)
    self.openTipsStr:setTouchEnabled(false)
   	self.openTipsStr:setPosition(45,self.heighthalf+9)

   	self.openStr = display.newSprite("#scene/scene_textOpen.png")
    self.bg:addChild(self.openStr)
    self.openStr:setTouchEnabled(false)
   	self.openStr:setPosition(60,self.heighthalf-12)
    

	self.redBg = display.newSprite("#scene/scene_redPointPic.png")
    self:addChild(self.redBg,10000)
    self.redBg:setTouchEnabled(false)
   	self.redBg:setPosition(self.widthHalf - 8,self.heighthalf-8)
   	self.redBg:setVisible(false)

	-- ArmatureManager:getInstance():loadEffect("functionEffect")
	-- 	self.effArmature = ccs.Armature:create("functionEffect")
	-- 	self.effArmature:setScaleX(1)
	--     self.effArmature:setScaleY(1) 
	--     self.effArmature:getAnimation():setSpeedScale(1)
	--     self:addChild(self.effArmature,10)
	--     self.effArmature:setPosition(0,0)
	--     self.effArmature:stopAllActions()
	--     self.effArmature:getAnimation():play("effect")
	self:setRedPointTip(false)
    self.iconUrl = ""
    self.bg:setTouchEnabled(true)
    self.bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self:setScale(1.05)
        elseif event.name == "ended" then
            self:setScale(1)
            if self.functionConf then
		        GlobalWinManger:openWin(WinName.FUNCTIONOPENPRIZEVIEW,self.functionConf)
		    end
        end
        return true
    end)
end

function FunctionOpenTipsBtn:open(functionConf,hasPrize)
	self.functionConf = functionConf
	self.hasPrize = hasPrize

	if self.tipLabel == nil then
		self.tipLabel = display.newBMFontLabel({
	    	text = "",
	    	font = "fonts/bitmapText_22.fnt",
	   	 	x = 20,
	    	y = self.heighthalf-12,
			})
	  	self.bg:addChild(self.tipLabel,100)
	  	--self.tipLabel:setOpacity(180)
	  	self.tipLabel:setTouchEnabled(false)
  	end

	if self.hasPrize then
		self:setRedPointTip(true)
		self.openStr:setVisible(false)
		self.tipLabel:setVisible(false)
		self.openTipsStr:setPosition(45,self.heighthalf)
	else
		self:setRedPointTip(false)
		self.tipLabel:setVisible(true)
		self.openStr:setVisible(true)
		self.openTipsStr:setPosition(45,self.heighthalf+9)
	end

	if self.functionConf.icon ~= self.iconUrl then
		if self.bgSpr then
			self.bg:removeChild(self.bgSpr)
			self.bgSpr = nil
		end
		if self.bgSpr == nil then
			self.bgSpr = display.newSprite("#"..self.functionConf.icon..".png")
			self.bgSpr:setScale(0.8)
			self.bg:addChild(self.bgSpr,0)
			self.iconUrl = self.functionConf.icon
			self.bgSpr:setPosition(self.widthHalf + 40,self.heighthalf)
		end
	end

  	self.tipLabel:setString(self.functionConf.lv)
end


function FunctionOpenTipsBtn:setRedPointTip(bool)
	self.redBg:setVisible(false)
	if bool then
		if self.effArmature == nil then
			ArmatureManager:getInstance():loadEffect("functionEffect")
			self.effArmature = ccs.Armature:create("functionEffect")
			self.effArmature:setScale(0.8)
		    --self.effArmature:setScaleY(1) 
		    self.effArmature:getAnimation():setSpeedScale(1)
		    self:addChild(self.effArmature,10)
		    self.effArmature:setPosition(40,0)
		end
		self.effArmature:setVisible(true)
	    self.effArmature:stopAllActions()
	    self.effArmature:getAnimation():play("effect")
	else
		if self.effArmature then 
			self.effArmature:stopAllActions()
			self.effArmature:getAnimation():stop()
			self.effArmature:setVisible(false)
		end
 	end
end


function FunctionOpenTipsBtn:destory()
	-- if self.timerId then
	--  	GlobalTimer.unscheduleGlobal(self.timerId)
	--  	self.timerId = nil
	-- end

	if self.effArmature then 
		self.effArmature:stopAllActions()
		self.effArmature:getAnimation():stop()
		if self.effArmature:getParent() then
			self.effArmature:getParent():removeChild(self.effArmature)
		end
		self.effArmature = nil
	end
	ArmatureManager:getInstance():unloadEffect("functionEffect")
end



return FunctionOpenTipsBtn