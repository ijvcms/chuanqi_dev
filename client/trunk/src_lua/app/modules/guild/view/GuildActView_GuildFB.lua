--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-22 18:14:51
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local GuildActViewBase  = import(".GuildActViewBase")
local GuildActView_GuildFB = class("GuildActView_GuildFB", GuildActViewBase)

local COUNT_DOWN_TEMPLATE = "<font color='0xB59F76' size='20'>秘境将在<font color='0xFB1827' size='20'>%s</font>后关闭</font>"

function GuildActView_GuildFB:initialization()
	self:initComponents()
end

function GuildActView_GuildFB:initComponents()
	self:addBlockMaskLayer()

	-- 窗口布局
	local layoutNode = cc.uiloader:load("resui/guildDreamlandWin.ExportJson")
	local layoutSize = layoutNode:getContentSize()
	layoutNode:setTouchEnabled(true)
	layoutNode:setPosition(display.cx - layoutSize.width * .5, display.cy - layoutSize.height * .5)

	self.lbl_layer_num = cc.uiloader:seekNodeByName(layoutNode, "floor")
	self.lbl_state = cc.uiloader:seekNodeByName(layoutNode, "state")
	self.lbl_level = cc.uiloader:seekNodeByName(layoutNode, "lv")
	self.btn_enter = cc.uiloader:seekNodeByName(layoutNode, "btnenter")
	self.btn_enter:onButtonClicked(function()
		GlobalController.guild:enterGuildFB()
	end)

	-- 规则说明（滚动 + HTML文字）
	local lbl_countdown = SuperRichText.new(nil, 255)
	local container = display.newNode()
	lbl_countdown:renderXml(self:getGuildActivity():getActivityConfig().ruledesc)
	container:setContentSize(lbl_countdown:getContentSize())
	container:addChild(lbl_countdown)

	local scrollView = cc.ScrollView:create(cc.size(255, 260))
	scrollView:setPosition(45, 40)
	scrollView:setContainer(container)
	scrollView:setContentOffset(cc.p(0, 260 - container:getContentSize().height))
	-- scrollView:setDelegate()
	scrollView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
	layoutNode:addChild(scrollView)

	--关闭窗口按钮
    self.closeBtn = cc.uiloader:seekNodeByName(layoutNode, "close")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:close()
        end
        return true
    end)

	self:addChild(layoutNode)
	self.win = layoutNode
end

function GuildActView_GuildFB:invalidateData()
	self._info = self:getGuildActivity():getGuildFBInfo()
	self._currentState = self._info:getState()

	self:refreshView()
	self:startTimer()
end

function GuildActView_GuildFB:refreshView()
	local info = self._info

	self.lbl_layer_num:setString(info:getLayerNumer() .. "层")
	self.lbl_level:setString(info:getEnterLowLevel() .. "级")

	if self._currentState == 1 then
		self.lbl_state:setString("已开启")
		self.lbl_state:setColor(cc.c3b(62, 212, 39))
		self.btn_enter:setButtonEnabled(true)
	elseif self._currentState == 2 then
		self.lbl_state:setString("未开启")
		self.lbl_state:setColor(cc.c3b(251, 24, 39))
		self.btn_enter:setButtonEnabled(false)
	end

	if info:getEnterLowLevel() > RoleManager:getInstance().guildInfo.guild_lv then
		self.lbl_level:setColor(cc.c3b(251, 24, 39))
		self.btn_enter:setButtonEnabled(false)
	else
		self.lbl_level:setColor(cc.c3b(62, 212, 39))
	end

end

function GuildActView_GuildFB:onTimerHandler()
	if self._currentState ~= self._info:getState() then
		self._currentState = self._info:getState()
		self:refreshView()
	end

	-- 倒计时
	if self._currentState == 1 then
		if not self.lbl_countdown then
			local centerNode = display.newNode()
			local lbl_countdown = SuperRichText.new()
			centerNode:addChild(lbl_countdown)
			centerNode:setPositionX(self.btn_enter:getPositionX()-7)
			centerNode:setPositionY(self.btn_enter:getPositionY() + 35)
			self.win:addChild(centerNode)
			self.lbl_countdown = lbl_countdown
		end

		self.lbl_countdown:setVisible(true)
		self.lbl_countdown:renderXml(string.format(COUNT_DOWN_TEMPLATE, self._info:getCountdownTimeStr()))
		self.lbl_countdown:setPositionX(-self.lbl_countdown:getContentSize().width * .5)
	else
		if self.lbl_countdown then
			self.lbl_countdown:setVisible(false)
		end
	end
end

function GuildActView_GuildFB:startTimer()
	self:clearTimer()
	self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 1)
	self:onTimerHandler()
end

function GuildActView_GuildFB:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end

--
-- 关闭方法。
--
function GuildActView_GuildFB:close()
	self:clearTimer()
	GuildActView_GuildFB.super.close(self)
	display.removeSpriteFramesWithFile("resui/guildWin0.plist", "resui/guildWin0.png")
end

return GuildActView_GuildFB
