--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-18 09:46:40
-- 副本倒计时页面
local CopyCountDownView = class("CopyCountDownView", BaseView)
function CopyCountDownView:ctor(winTag,data,winconfig)
	self.data = data
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
	self:addChild(self.bg)
	
	CopyCountDownView.super.ctor(self,winTag,data,winconfig)
	-- self.root = cc.uiloader:load("resui/storyInstanceWin.ExportJson")
	-- self:addChild(self.root)

    self.root:setPosition((display.width-364)/2,(display.height-232)/2)

    -- self.closeBtn = self:seekNodeByName("closeBtn")
    -- self.closeBtn:setTouchEnabled(true)
    -- self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     if event.name == "began" then
    --         self.closeBtn:setScale(1.1)
    --     elseif event.name == "ended" then
    --         self.closeBtn:setScale(1)
    --        	GlobalWinManger:closeWin(WinName.COPYCOUNTDOWNVIEW)
    --     end
    --     return true
    -- end)
	
    self.continueBtn = self:seekNodeByName("continueBtn")
    self.continueBtn:setTouchEnabled(true)
    self.continueBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.continueBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.continueBtn:setScale(1)
            GameNet:sendMsgToSocket(11051)
            GlobalWinManger:closeWin(WinName.COPYCOUNTDOWNVIEW)
        end
        return true
    end)

    self.leaveBtn = self:seekNodeByName("leaveBtn")
    self.leaveBtn:setTouchEnabled(true)
    self.leaveBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.leaveBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.leaveBtn:setScale(1)
          	self:leaveClick()
        end
        return true
    end)

    self.text = self:seekNodeByName("text")
    self.countDownTime = 5
    self.isCancelRemoveSpriteFrams = true
end

function CopyCountDownView:leaveClick()
	GameNet:sendMsgToSocket(11016)
	if self.timerId then
	    GlobalTimer.unscheduleGlobal(self.timerId)
	    self.timerId = nil
	end
    GlobalWinManger:closeWin(WinName.COPYCOUNTDOWNVIEW)
end

function CopyCountDownView:update()
	if self.countDownTime > 0 then
		self.text:setString(math.floor(self.countDownTime).."后自动离开副本")
		self.countDownTime = self.countDownTime -1
	else
		self:leaveClick()
	end
end

function CopyCountDownView:open()

	if self.timerId == nil then
        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.update),1)
    end
    if self.data and self.data.time and self.data.time >=1 then
    	self.countDownTime = self.data.time
    end
    self.text:setString(math.floor(self.countDownTime).."后自动离开副本")
end



function CopyCountDownView:close()
    CopyCountDownView.super.close(self)

    if self.timerId then
        GlobalTimer.unscheduleGlobal(self.timerId)
        self.timerId = nil
    end
end


--清理界面
function CopyCountDownView:destory()
    self:close()
    self.super.destory(self)
	
end

return CopyCountDownView