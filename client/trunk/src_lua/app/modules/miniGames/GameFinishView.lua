--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-04-11 16:45:07
-- 游戏完成面板,显示完成和时间到图片

local GameFinishView = class("GameFinishView", function()
	return display.newNode()
end)

function GameFinishView:ctor(width,height,parent,gameId,gameType,platform)
	self.gameId = gameId
	self.width = width
	self.height = height
	self.parent = parent
    self.platform = platform
    self.gameType = gameType

    self.resList = {
    	[1] = "game/pic_bg_4.png",
    	[2] = "game/pic_txt_over.png",
    	[3] = "game/pic_timeout_clock.png",
    	[4] = "game/pic_txt_timeout.png",
	}

	--self.bg =  cc.LayerColor:create(cc.c4b(237,237,237,255))
	self.bg = display.newScale9Sprite(self.resList[1], self.width/2, self.height/2, cc.size(self.width, self.height))
	--self.bg:setOpacity(255*0.8)
	--self.bg:setContentSize(self.width, self.height)
	self.bg:setTouchEnabled(true)
	self.bg:setTouchSwallowEnabled(true)
	self:addChild(self.bg)
	-- self.bg:setColor(cc.c3b(0,161,233))
	self.finishTextPic = self.resList[2]
	self.picClockPic = self.resList[3]
	self.timeOutTxtPic = self.resList[4]
end

function GameFinishView:open(key,completeFun)
	self.backFun = completeFun
	key = key or "finish"
	self:clear()
	if key == "finish" then
		if self.finishText == nil then
			self.finishText = display.newSprite(self.finishTextPic)
    		-- self.redWarnFrame:setOpacity(255)
    		self:addChild(self.finishText)	
		end
		self.finishText:setPosition(self.width/2,self.height)
		local action1 = cc.MoveTo:create(0.2, cc.p(self.width/2,self.height/2+40))
    	local action11 = cc.DelayTime:create(2)
    	local action2 = cc.CallFunc:create(handler(self,self.onExit))
    	local action3 = transition.sequence({
            action1,
            action11,
            action2,
        })
    	self.finishText:runAction(action3)
		
	else
		if self.picClock ==nil then
			self.picClock = display.newSprite(self.picClockPic)
			self:addChild(self.picClock)
		end
		self.picClock:setPosition(self.width/2,self.height)

		self.timeOutTxt = display.newSprite(self.timeOutTxtPic)
		self.picClock:addChild(self.timeOutTxt)
		self.timeOutTxt:setPosition(55,-70)

		local action1 = cc.MoveTo:create(0.2, cc.p(self.width/2,self.height/2+60+40))
    	local action11 = cc.DelayTime:create(2)
    	local action2 = cc.CallFunc:create(handler(self,self.onExit))
    	local action3 = transition.sequence({
            action1,
            action11,
            action2,
        })
    	self.picClock:runAction(action3)
	end
end


function GameFinishView:clear()
	if self.finishOverTxt then
		self.finishOverTxt:stopAllActions()
		self.finishOverTxt:setVisible(false)
	end
	
	if self.picClock then
		self.picClock:stopAllActions()
		self.picClock:setVisible(false)
	end
end

function GameFinishView:onExit()
	for i=1,#self.resList do
		display.removeSpriteFrameByImageName(self.resList[i]) 
	end
	self:clear()
	if self.backFun then
		self.backFun()
		self.backFun = nil
	end
end

return GameFinishView
