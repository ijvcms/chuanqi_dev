--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-29 17:38:03
--

local WelfareWin = WelfareWin or class("WelfareWin", BaseView)

function WelfareWin:ctor(winTag, data, winconfig)
	WelfareWin.super.ctor(self, winTag, data, winconfig)
	self:initialization()
end

function WelfareWin:initialization()
 
	self:initComponents()
	self:initListeners()
end

--
-- 初始化事件监听。
--
function WelfareWin:initListeners()
end

--
-- 初始化当前窗口的所有组件。
--
function WelfareWin:initComponents()
	local root = self:getRoot()
	local win = cc.uiloader:seekNodeByName(root, "win")

	self.btnlist = {}
	self.btnlist[1] = cc.uiloader:seekNodeByName(root, "dailySignBtn")
	self.btnlist[2] = cc.uiloader:seekNodeByName(root, "onlineRewardBtn")
	self.btnlist[3] = cc.uiloader:seekNodeByName(root, "redeemCodeBtn")
	self.btnlist[4] = cc.uiloader:seekNodeByName(root, "monthCardBtn")
	self.btnlist[5] = cc.uiloader:seekNodeByName(root, "levelRewardBtn")

	self.btnlist[3]:setVisible(GlobalModel.card_state == 1 )
	--红点提示
	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_AWARD_ONLINE,self.btnlist[2],90,64)
	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_SIGN,self.btnlist[1],90,64)
	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_MONTH_GOODS,self.btnlist[4],90,64)
	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_LV_GIFT,self.btnlist[5],90,64)
 
 	for i=1,#self.btnlist do
 		self.btnlist[i]:setTouchEnabled(true)
 		self.btnlist[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then            
            SoundManager:playClickSound()

        elseif event.name == "ended" then
        	self.btnlist[i]:setSpriteFrame("com_tabBtn1Sel.png")
        	if self.lastClick and self.lastClick ~= self.btnlist[i] then
        		self.lastClick:setSpriteFrame("com_tabBtn1.png")
        	end

        	if self.lastClick ~= self.btnlist[i] then
        		self.lastClick = self.btnlist[i]
        		self:onClickTypeItem(i)
        	end
        	
        end
        return true
    	end)

 	end
end

 
--
-- 点击了福利类型项目。
--
function WelfareWin:onClickTypeItem(index)

	if self.lastTag then

		self.lastTag:setVisible(false)
		self.lastTag:close()

	end

	local x,y = 120,0

	if index == 1 then

		if self.signView == nil then
			self.signView = require("app.modules.welfare.view.WelfareSignView").new()
			self:getRoot():addChild(self.signView)
			self.signView:setPosition(x,y)
		end

		self.lastTag = self.signView
	elseif index == 2 then
		if self.onLineView == nil then
			self.onLineView = require("app.modules.welfare.view.WelfareOnlineView").new()
			self:getRoot():addChild(self.onLineView)
			self.onLineView:setPosition(x,y)
		end
 
		self.lastTag = self.onLineView
	elseif index == 3 then
		if self.codeView == nil then
			self.codeView = require("app.modules.welfare.view.WelfareRedeemCodeView").new()
			self:getRoot():addChild(self.codeView)
			self.codeView:setPosition(x,y)
		end
 
		self.lastTag = self.codeView
	elseif index == 4 then
		if self.monthCardView == nil then
			self.monthCardView = require("app.modules.welfare.view.WelfareMonthCardView").new()
			self:getRoot():addChild(self.monthCardView)
			self.monthCardView:setPosition(x+2,y+2)
		end
 
		self.lastTag = self.monthCardView

	elseif index == 5 then
		if self.levelView == nil then
			self.levelView = require("app.modules.welfare.view.WelfareLevelView").new()
			self:getRoot():addChild(self.levelView)
			self.levelView:setPosition(x,y)
		end
 
		self.lastTag = self.levelView
	end

	self.lastTag:open()
	self.lastTag:setVisible(true)
	
end

--
-- 注册全局事件监听。
--
function WelfareWin:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function WelfareWin:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

--打开界面
function WelfareWin:open()
	self.super.open(self)
	GlobalController.welfare:RequestGetRewardsState()
	self.btnlist[1]:setSpriteFrame("com_tabBtn1Sel.png")
    self.lastClick = self.btnlist[1]
    self:onClickTypeItem(1)
       
end

  --点击关闭按钮
function WelfareWin:onClickCloseBtn()
    GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_WIN_CLOSE_BUTTON)--在关闭之前
    self.super.onClickCloseBtn(self)
end

--关闭界面
function WelfareWin:close()
	self.super.close(self)
end

--清理界面
function WelfareWin:destory()
	self:removeAllEvents()
	if self.loader then
		self.loader:Clear()
		self.loader = nil
	end

	if self.signView ~= nil then
		self.signView:close()
		self.signView:destory()
		self.signView = nil
	end

	if self.loginView ~= nil then
		self.loginView:close()
		self.loginView:destory()
		self.loginView = nil
	end

	if self.onLineView ~= nil then
		self.onLineView:close()
		self.onLineView:destory()
		self.onLineView = nil
	end

	if self.codeView ~= nil then
		self.codeView:close()
		self.codeView:destory()
		self.codeView = nil
	end

	if self.monthCardView ~= nil then
		self.monthCardView:close()
		self.monthCardView:destory()
		self.monthCardView = nil
	end
	
	if self.levelView ~= nil then
		self.levelView:close()
		self.levelView:destory()
		self.levelView = nil
	end
	self.super.destory(self)
end

return WelfareWin