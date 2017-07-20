--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-26 15:13:53
--
local ActivityItem = class("ActivityItem",function() return display.newNode() end)

function ActivityItem:ctor(itemRoot)
	self.ccui = cc.uiloader:load("resui/activityWinItem.ExportJson")
	self:addChild(self.ccui)
	self._root = self.ccui
	self:initialization()
end

function ActivityItem:initialization()
	self.img_hight_yield = cc.uiloader:seekNodeByName(self._root, "label1")
	self.img_act_icon = cc.uiloader:seekNodeByName(self._root, "system")
	self.img_act_lock = cc.uiloader:seekNodeByName(self._root, "limit")
	self.img_act_text = cc.uiloader:seekNodeByName(self._root, "name1")
	self.lbl_button = cc.uiloader:seekNodeByName(self._root, "name2")
	self.img_progress = cc.uiloader:seekNodeByName(self._root, "progress")
	self.lbl_progress = cc.uiloader:seekNodeByName(self._root, "number")
	self.button = cc.uiloader:seekNodeByName(self._root, "btn1")
	self.timeLabel = cc.uiloader:seekNodeByName(self._root, "timeLabel")
	self.Image_19 = cc.uiloader:seekNodeByName(self._root, "Image_19")

	self.button:setTouchEnabled(true)
	self.button:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.button:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.button:setScale(1.0)
            if self._handler then
            	self._handler(self)
            end
        end
        return true
    end)
end

function ActivityItem:setOnItemClickeHandler(handler) self._handler = handler end

function ActivityItem:getView() return self._root end
function ActivityItem:getData() return self._data end
function ActivityItem:setData(data)
	self._data = data
	self:invalidateData()
	if self._data._functionConfig.id == 17 then --每日任务
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_DAILY_TARGET,self.button,104,34)
	elseif self._data._functionConfig.id == 18 then --排位赛
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_ARENA,self.button,104,34)
	elseif self._data._functionConfig.id == 23 then --功勋任务
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_TASK_MERIT,self.button,104,34)
	elseif self._data._functionConfig.id == 24 then --膜拜功能
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_WORSHIP,self.button,104,34)
	elseif self._data._functionConfig.id == 26 then --个人副本
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_INSTANCE_SINGLE,self.button,104,34)
	elseif self._data._functionConfig.id == 36 then --日常任务
	elseif self._data._functionConfig.id == 37 then -- 未知暗殿
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_WZAD,self.button,104,34)
	elseif self._data._functionConfig.id == 38 then -- 屠龙大会
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_TLDH,self.button,104,34)
	elseif self._data._functionConfig.id == 39 then -- 胜者为王
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SZWW,self.button,104,34)
	elseif self._data._functionConfig.id == 83 then -- 怪物攻城
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_MAC,self.button,104,34)
	elseif self._data._functionConfig.id == 22 then -- 挂机
		local btnTip = BaseTipsBtn.new(BtnTipsType.BTN_HOOK,self.button,104,34)
	end
end

function ActivityItem:invalidateData()
	if not self._data then return end
	local data = self._data
	 
	self.img_hight_yield:setVisible(data:isHightYield())
	self.img_act_icon:setSpriteFrame(data:getIconSpriteFrame())

	self.img_act_text:setSpriteFrame(data:getTextSpriteFrame())
	self:setDescribeHTML(data:getDescribeHTML())

	local isOpen = data:isOpen()
	if isOpen then
		self.lbl_button:setString(data:getButtonLabel())
	else
		self.lbl_button:setString(data:getConditionText())
	end
	self:enabledImageButton(self.button, isOpen)
	self.img_act_lock:setVisible(not isOpen)

	if data._data.time and  data._data.time ~= "" then
		self.timeLabel:setString(data._data.time)
		self.timeLabel:setVisible(true)
		self.lbl_progress:setVisible(false)
		self.img_progress:setVisible(false)
		self.Image_19:setVisible(false)
		
	else
		self.timeLabel:setVisible(false)
		self.lbl_progress:setVisible(true)
		self.img_progress:setVisible(true)
		self.Image_19:setVisible(true)
	end
	-- 无限制次数活动
	if not data:isShowNum() then
		self.lbl_progress:setString("无限制")
		self.img_progress:setPercent(100)
	end
end

function ActivityItem:setProgress(current, max)
	current = checknumber(current)
	max = checknumber(max)

	if current == 0 then
		self.img_progress:setVisible(false)
	else
		self.img_progress:setVisible(true)
		self.img_progress:setPercent(math.max(current / max * 100, 9))
	end
	self.lbl_progress:setString(string.format("%d/%d", current, max))
end

function ActivityItem:setDescribeHTML(htmlText)
	if not self.lbl_describe then
		local centerNode = display.newNode()
		local lbl_describe = SuperRichText.new()
		local lbl_text = cc.uiloader:seekNodeByName(self._root, "text")
		centerNode:addChild(lbl_describe)
		centerNode:setPositionX(lbl_text:getPositionX())
	 
		lbl_text:removeFromParent()
		self._root:addChild(centerNode)
		self.lbl_describe = lbl_describe
	end

	self.lbl_describe:renderXml(htmlText)

	self.lbl_describe:setPositionX(-self.lbl_describe:getContentSize().width * .5)
	self.lbl_describe:setPositionY( self.img_act_text:getPositionY() - self.lbl_describe:getContentSize().height - 15)
end

function ActivityItem:enabledImageButton(target, enabled)
	target:setTouchEnabled(enabled)
	target:setColor(enabled and cc.c3b(255, 255, 255) or cc.c3b(128, 128, 128))
end

return ActivityItem