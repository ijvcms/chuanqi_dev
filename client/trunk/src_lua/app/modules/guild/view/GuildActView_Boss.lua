--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-21 20:30:26
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")
local GuildActViewBase  = import(".GuildActViewBase")
local GuildActView_Boss = class("GuildActView_Boss", GuildActViewBase)

local ListItem = class("ListItem", function()
	return display.newNode()
end)

local ITEM_LAYOUT_FILE = "resui/BossListWin.ExportJson"

function GuildActView_Boss:initialization()
	local loader = GameUILoaderUtils.new()
	self.loader = loader
	self.loader:AddUIEditorCache(ITEM_LAYOUT_FILE)

	self:initComponents()
	self:loadBossList()
end

function GuildActView_Boss:initComponents()
	self:addBlockMaskLayer()

	-- 窗口布局
	local layoutNode = cc.uiloader:load("resui/guildBossWin.ExportJson")
	local layoutSize = layoutNode:getContentSize()
	layoutNode:setTouchEnabled(true)
	layoutNode:setPosition(display.cx - layoutSize.width * .5, display.cy - layoutSize.height * .5)
	self:addChild(layoutNode)
	
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

	-- 滑动列表
	local listView = cc.ui.UIListView.new({
		viewRect = cc.rect(0, 0, 580, 290),
		direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
	})
	listView:setPosition(25, 25)
	layoutNode:addChild(listView)

	self.listView = listView
	self.win = layoutNode
end

function GuildActView_Boss:loadBossList()
	self.listView:removeAllItems()
	local bossList = self:getGuildActivity():getBossList()
	for _, config in ipairs(bossList) do
		local newLayoutNode = self.loader:BuildNodesByCache(ITEM_LAYOUT_FILE)
		local listContent = ListItem.new(newLayoutNode)
        local itemSize = newLayoutNode:getContentSize()
        listContent:setItemData(config)
        listContent:setOnEnterClickHandler(handler(self, self.onItemEnterHandler))

        local item = self.listView:newItem()
        item:addContent(listContent)
        item:setItemSize(itemSize.width, itemSize.height + 10)
        self.listView:addItem(item)
	end

	self.listView:reload()
end

function GuildActView_Boss:onItemEnterHandler(config)
	GlobalController.guild:challengeBoss(config.act_id)
end

function GuildActView_Boss:close()
	if self.loader then
		self.loader:Clear()
		self.loader = nil
	end

	GuildActView_Boss.super.close(self)
	 display.removeSpriteFramesWithFile("resui/guildWin0.plist", "resui/guildWin0.png")
end

-- ============================================================================================ Class ListItem imp
function ListItem:ctor(root)
	self._root = root
	self:initialization()
end

function ListItem:initialization()
	self:addNodeEventListener(cc.NODE_EVENT, function(event)
    	if event.name == "cleanup" then
    		self:clearTimer()
    	end
    end)

	self:initComponents()
end

function ListItem:initComponents()
	local itemUI = self._root
	self:addChild(itemUI)
	self:setContentSize(itemUI:getContentSize())

	self.lbl_boss_name = cc.uiloader:seekNodeByName(itemUI, "activityname")
	self.lbl_state     = cc.uiloader:seekNodeByName(itemUI, "open")
	self.lbl_time_tip  = cc.uiloader:seekNodeByName(itemUI, "timetxt")
	self.lbl_describe  = cc.uiloader:seekNodeByName(itemUI, "describe")
	self.lbl_countdown = cc.uiloader:seekNodeByName(itemUI, "time")
	self.btn_challenge = cc.uiloader:seekNodeByName(itemUI, "btnenter")

	local avatarBorder = cc.uiloader:seekNodeByName(itemUI, "bosshead")
	self.img_avatar = display.newSprite()
	self.img_avatar:setPosition(avatarBorder:getPosition())
	itemUI:addChild(self.img_avatar)

	self.btn_challenge:onButtonClicked(function()
		if self._handler then
			self._handler(self:getItemData())
		end
	end)
end

function ListItem:invalidateData()
	local data = self:getItemData()
	if data then
		local monster_id = data.monster_id
		local monster_avatar = string.format("xxxxx_%d.png", configHelper:getMonsterResById(monster_id))
		local monster_name = configHelper:getMonsterNameById(monster_id)

		-- self.img_avatar:setSpriteFrame(monster_avatar)
		self.img_avatar:setTexture("icons/tarHead/tarh_00000.png")
		self.lbl_boss_name:setString(monster_name)

		local stateCode = self:getStateCode()
		local isOpen = stateCode == 3
		self.lbl_time_tip:setVisible(isOpen)
		self.lbl_countdown:setVisible(isOpen)
		self.lbl_describe:setVisible(not isOpen)
		self.btn_challenge:setVisible(isOpen)

		-- 行会等级不足
		if stateCode == 1 then
			self.lbl_state:setString("不可用")
			self.lbl_state:setColor(cc.c3b(73, 67, 58))

			self.lbl_describe:setString(string.format("行会等级达%d级开启", data.guild_lv))
			self.lbl_describe:setColor(cc.c3b(251, 24, 39))
		-- 已结束
		elseif stateCode == 2 then
			self.lbl_state:setString("已结束")
			self.lbl_state:setColor(cc.c3b(73, 67, 58))

			self.lbl_describe:setString(string.format("每天%s自动开启", data.open_time))
			self.lbl_describe:setColor(cc.c3b(209, 159, 84))
		-- 已开启
		elseif stateCode == 3 then
			self.lbl_state:setString("已开启")
			self.lbl_state:setColor(cc.c3b(62, 212, 39))
		-- 未开启
		elseif stateCode == 4 then
			self.lbl_state:setString("未开启")
			self.lbl_state:setColor(cc.c3b(251, 24, 39))
			self.lbl_describe:setString(string.format("每天%s自动开启", data.open_time))
			self.lbl_describe:setColor(cc.c3b(209, 159, 84))
		end

		self._currentState = stateCode
		self:startTimer()
	else
		self:clearTimer()
	end
end

function ListItem:onTimerHandler()
	if self._currentState ~= self:getStateCode() then
		self:invalidateData()
	end

	-- 倒计时
	if self._currentState == 3 then
		self.lbl_countdown:setString(self:getCountDownTimeStr())
	end
end

function ListItem:startTimer()
	self:clearTimer()
	self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 1)
	self:onTimerHandler()
end

function ListItem:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end

--
-- 获取状态信息 1 = 行会等级不足， 2 = 已结束， 3 = 已开启， 4 = 未开启
--
function ListItem:getStateCode()
	local data = self:getItemData()
	if not data then return 0 end
	local guildLevel = RoleManager:getInstance().guildInfo.guild_lv

	if guildLevel < data.guild_lv then
		return 1
	end
	local nowTime = os.time()
	if nowTime > self:getEndTime() then
		return 2
	elseif nowTime > self:getStartTime() then
		return 3
	else
		return 4
	end
end

function ListItem:getStartTime()
	local data = self:getItemData()
	local hour, min = string.match(data.open_time, "(%d+):(%d+)")
    local currentTime = os.date("*t", os.time())
    currentTime.hour = checknumber(hour)
    currentTime.min = checknumber(min)
    currentTime.sec = 0
    return os.time(currentTime)
end

function ListItem:getEndTime()
	local data = self:getItemData()
	local hour, min = string.match(data.close_time, "(%d+):(%d+)")
    local currentTime = os.date("*t", os.time())
    currentTime.hour = checknumber(hour)
    currentTime.min = checknumber(min)
    currentTime.sec = 0
    return os.time(currentTime)
end

function ListItem:getCountDownTimeStr()
	local timeInterval = self:getEndTime() - os.time()
	return StringUtil.convertTime(timeInterval)
end

function ListItem:setItemData(data)
	self._data = data
	self:invalidateData()
end

function ListItem:getItemData()
	return self._data
end

function ListItem:setOnEnterClickHandler(handler) self._handler = handler end


return GuildActView_Boss