--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-18 15:37:03
-- 穿戴坐骑提示界面
local WearRideTipsView = class("WearRideTipsView", BaseView)
function WearRideTipsView:ctor(winTag,data,winconfig)
	self.data = data
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
	self:addChild(self.bg)
	
	WearRideTipsView.super.ctor(self,winTag,data,winconfig)
	-- self.root = cc.uiloader:load("resui/storyInstanceWin.ExportJson")
	-- self:addChild(self.root)

    self.root:setPosition((display.width-462)/2,(display.height-550)/2)

    self.closeBtn = self:seekNodeByName("closeBtn")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
           	GlobalWinManger:closeWin(WinName.WEARRIDETIPSVIEW)
        end
        return true
    end)
	
	--穿戴翅膀按钮
    self.checkBtn = self:seekNodeByName("checkBtn")
    self.checkBtn:setTouchEnabled(true)
    self.checkBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.checkBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.checkBtn:setScale(1)
            GlobalWinManger:openWin(WinName.MAINROLEWIN,{tabIndex = 4})
            GlobalWinManger:closeWin(WinName.WEARRIDETIPSVIEW)
        end
        return true
    end)

    -- --获取永久翅膀按钮
    -- self.btnwing1 = self:seekNodeByName("btnwing1")
    -- self.btnwing1:setTouchEnabled(true)
    -- self.btnwing1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     if event.name == "began" then
    --         self.btnwing1:setScale(1.1)
    --     elseif event.name == "ended" then
    --         self.btnwing1:setScale(1)
    --         GlobalWinManger:closeWin(WinName.WEARRIDETIPSVIEW)
    --     end
    --     return true
    -- end)
    

    self.time = self:seekNodeByName("time") --倒计时00:00:00
    self.closetime = self:seekNodeByName("countDown") --面板关闭倒计时5s
    self.closetime:setVisible(false)
    self.countDownTime = 5000000
    self.isCancelRemoveSpriteFrams = true

end


function WearRideTipsView:update()
	if self.countDownTime > 0 then
		self.closetime:setString("("..math.floor(self.countDownTime).."s)")
		self.countDownTime = self.countDownTime -1
	else
        if self.timerId then
            GlobalTimer.unscheduleGlobal(self.timerId)
            self.timerId = nil
        end
		GlobalWinManger:closeWin(WinName.WEARRIDETIPSVIEW)
		return
	end 
end

function WearRideTipsView:open()

	if self.timerId == nil then
        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.update),1)
    end
    -- if self.data and self.data.time and self.data.time >=1 then
    -- 	self.countDownTime = self.data.time
    -- end
    self:update()
end



function WearRideTipsView:close()
    WearRideTipsView.super.close(self)

    if self.timerId then
        GlobalTimer.unscheduleGlobal(self.timerId)
        self.timerId = nil
    end
end


--清理界面
function WearRideTipsView:destory()
    self:close()
    self.super.destory(self)
	
end

return WearRideTipsView