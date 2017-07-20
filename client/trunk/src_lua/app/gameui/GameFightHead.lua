--
-- Author: zhangshunqiu
-- Date: 2015-02-05 14:15:03
-- 游戏对战上面的UI
local GameFightHead = class("GameFightHead", function()
	return display.newNode()
end)

function GameFightHead:ctor(data)	
	data = data or {}
	local width = data.width or 600	
	local height = data.height or 100
	local bgColor = data.bgColor or display.BG_COLOR_GRAY1
	local barHeight = data.barHeight or 20
	self.lScore = data.lScore or 0
	self.rScore = data.rScore or 0
	self.time = data.time or 0
	local lHeadUrl = data.lHeadUrl or ""
	local rHeadUrl = data.rHeadUrl or ""

	local bg = display.newRect(cc.rect(0, 0, width, height),
        {fillColor = bgColor, borderColor = display.BG_COLOR_WHITE, borderWidth = 0})
	self:addChild(bg)

	local scoreTipLabOffsetX = 180
	local scoreTipLabOffsetY = 45
	local roleHeadOffsetX = 65

	--左侧头像相关
	self.lRoleHead = RoleHead.new(lHeadUrl)
	self.lRoleHead:setPosition(roleHeadOffsetX,height/2 + barHeight/2)
	self:addChild(self.lRoleHead)

	local lScoreTipLab = display.newTTFLabel({
    	text = "得分",
    	-- font = "Arial",
    	size = 30,
    	color = display.COLOR_WHITE, -- 使用纯红色
    	-- align = cc.TEXT_ALIGNMENT_LEFT,
    	-- valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    	-- dimensions = cc.size(400, 200)    
	})
	lScoreTipLab:setPosition(scoreTipLabOffsetX,height - scoreTipLabOffsetY)
	self:addChild(lScoreTipLab)
	self.lScoreLab = display.newTTFLabel({
    	text = tostring(self.lScore),    
    	size = 30,
    	color = display.COLOR_WHITE,
	})
	self.lScoreLab:setPosition(scoreTipLabOffsetX,scoreTipLabOffsetY +barHeight)
	self:addChild(self.lScoreLab)

	--右侧头像相关	
	self.rRoleHead = RoleHead.new(rHeadUrl)
	self.rRoleHead:setPosition(width - roleHeadOffsetX,height/2+ barHeight/2)
	self:addChild(self.rRoleHead)
	local rScoreTipLab = display.newTTFLabel({
    	text = "得分",
    	size = 30,
    	color = display.COLOR_WHITE, 	
	})
	rScoreTipLab:setPosition(width-scoreTipLabOffsetX,height - scoreTipLabOffsetY)
	self:addChild(rScoreTipLab)
	self.rScoreLab = display.newTTFLabel({
    	text = tostring(self.rScore),    
    	size = 30,
    	color = display.COLOR_WHITE,
	})
	self.rScoreLab:setPosition(width-scoreTipLabOffsetX,scoreTipLabOffsetY+barHeight)
	self:addChild(self.rScoreLab)

	--倒计时相关
	local countdownTipLab = display.newTTFLabel({
    	text = "time",
    	size = 30,
    	color = display.COLOR_WHITE, 	
	})
	countdownTipLab:setPosition(width/2,height-35)
	self:addChild(countdownTipLab)
	self.countdownLab = display.newTTFLabel({
    	text = tostring(self.time),
    	size = 50,
    	color = display.COLOR_WHITE,
	})
	self.countdownLab:setPosition(width/2,35+barHeight)
	self:addChild(self.countdownLab)

	--进度条
	self.scoreBar = ProgressBar.new({style = 1,width = width,height= barHeight})
	self:addChild(self.scoreBar)
	self:setBarPercent(self.lScore,self.rScore)

	self.lScore = data.lScore or 0
	self.rScore = data.rScore or 0
	self.time = data.time or 0


	self.curLScore = self.lScore
	self.curRScore = self.rScore
	self.curTime = self.time
end	

--设置进度条
--@param number leftValue 左边积分
--@param number rightValue 右边积分
function GameFightHead:setBarPercent(leftValue,rightValue,isMove)
	self:setLScore(leftValue)
	self:setRScore(rightValue)
	if leftValue == 0 and rightValue == 0 then
		self.scoreBar:setPercent(50,false)
		return
	end	
	local curPrecent = math.floor((leftValue/(leftValue+rightValue))*100)
	self.scoreBar:setPercent(curPrecent,isMove)
end	

--设置左边的积分
function GameFightHead:setLScore(value)
	self.lScore = value
	self.lScoreLab:setString(value)
	-- local listenerFun =  function()
 --       if self.curLScore == self.lScore or math.abs(self.lScore - self.curLScore) <1  then
 --       		self.curLScore = self.lScore
 --       		self.lScoreLab:setString(math.floor(self.curLScore))
 --       		GlobalTimer.unscheduleGlobal(self.timerId)
 --       		self.timerId = nil
 --       else
 --       		self.curLScore = self.curLScore + (self.lScore-self.curLScore)/20
 --       		self.lScoreLab:setString(math.floor(self.curLScore))
 --       end
 --       self.lScoreLab:setString(math.floor(self.curLScore))
 --   	end
 --   	if self.timerId == nil then
 --  		self.timerId = GlobalTimer.scheduleUpdateGlobal(listenerFun)
 --  	end
end	

--设置右边的积分
function GameFightHead:setRScore(value)
	self.rScore = value
	self.rScoreLab:setString(value)
end

--设置左边头像地址
function GameFightHead:setLHeadUrl(value)
	self.lRoleHead:setImage(value)
end	
--设置右边头像地址
function GameFightHead:setRHeadUrl(value)
	self.rRoleHead:setImage(value)
end	

--设置倒计时
function GameFightHead:setCountdown(value)
	self.time = value
	self.countdownLab:setString(value)
end

--清理
function GameFightHead:destory()
	if self.timerId then
		GlobalTimer.unscheduleGlobal(self.timerId)
 		self.timerId = nil
	end
	if self.lRoleHead then
		self.lRoleHead:destory()
	end	
	if self.rRoleHead then
		self.rRoleHead:destory()
	end
	if self.scoreBar then
		self.scoreBar:destory()
	end	
end

return GameFightHead