--
-- Author: Shine
-- Date: 2016-09-05
--
--军团操作页
local GuildBasePage          = import(".GuildBasePage")
local CorpsInfoPage          = import(".CorpsInfoPage")
local CorpsMemberPage       = import(".CorpsMemberPage")
local CorpsProposerPage      = import(".CorpsProposerPage")

local CorpsOperatePage = class("CorpsOperatePage", GuildBasePage)

local SubViewInfo = {
	{tagName = "军团信息", class = CorpsInfoPage},
	{tagName = "军团成员", class = CorpsMemberPage},
	{tagName = "申请列表", class = CorpsProposerPage},
}

function CorpsOperatePage:ctor(param)
	--左边背景
	local leftBg = display.newScale9Sprite("#com_viewBg1.png", 0, 0, cc.size(245,360))
	self:addChild(leftBg)
	leftBg:setAnchorPoint(0,0)
	leftBg:setPosition(39,183)
	self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 190, 385),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.onListViewTouch))
    self.itemListView:setContentSize(cc.size(190,385))
    self.itemListView:setPosition(10,104)
    self:addChild(self.itemListView)

	self.tagBtns = {}
	self.pages = {}
	
	for index = 1, #SubViewInfo do
		local info = SubViewInfo[index]
        local item = self.itemListView:newItem()
        local tagButton = self:createTagButton(index, info.tagName)
        item:addContent(tagButton)
  --       if info.tagName == "军团信息" then
		-- 	local dd = BaseTipsBtn.new(BtnTipsType.BTN_GUILD_INFO,tagButton,170-8,44-8)
		-- else
		if info.tagName == "申请列表" then
			local dd = BaseTipsBtn.new(BtnTipsType.BTN_GROUP_APPLY_LIST,tagButton,170-8,44-8)
		-- elseif info.tagName == "行会活动" then
		-- 	local dd = BaseTipsBtn.new(BtnTipsType.BTN_GUILD_ACTIVITY,tagButton,170-8,44-8)
		end

        local size = tagButton:getContentSize()
        item:setItemSize(size.width, size.height + 6)
        self.itemListView:addItem(item)
		self.tagBtns[index] = tagButton
	end
    self.itemListView:reload()
	--规则按钮
	local btnGZ = display.newSprite("#com_helpBtn.png")
	btnGZ:setTouchEnabled(true)
    btnGZ:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnGZ:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnGZ:setScale(1.0)
            self:onGZClick()
        end
        return true
    end)
    btnGZ:setPosition(80,155-100)
    local label = display.newTTFLabel({
    	text = "规 则",
    	size = 20,
    	color = TextColor.BTN_Y
	})
	label:setPosition(btnGZ:getPositionX() + btnGZ:getContentSize().width + 8, btnGZ:getPositionY())
	display.setLabelFilter(label)
	self:addChild(label)
	self:addChild(btnGZ)

	--进来选择第一页
	if param ~= nil and param.tab then
		self:onTagClick(param.tab)
	else
		self:onTagClick(1)
	end
	
end

function CorpsOperatePage:createTagButton(index, tagName)
	local tag = display.newSprite("#com_labBtn4.png")
	local selected = display.newSprite("#com_labBtn4Sel.png")
	selected:setTag(10)
	selected:setPosition(tag:getContentSize().width/2,tag:getContentSize().height/2)
	selected:setVisible(false)
	tag:addChild(selected)

    local labName = display.newTTFLabel({
    	text = tagName,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	labName:setPosition(tag:getContentSize().width/2,tag:getContentSize().height/2)
	display.setLabelFilter(labName)
	tag:addChild(labName)

	return tag
end

function CorpsOperatePage:onListViewTouch(event)
	if "clicked" == event.name then
		SoundManager:playClickSound()
		self:onTagClick(event.itemPos)
	end
end

function CorpsOperatePage:onTagClick(index)
	if self.curTag then
		self.curTag:getChildByTag(10):setVisible(false)
	end
	self.curTag = self.tagBtns[index]
	self.curTag:getChildByTag(10):setVisible(true)

	self:showPage(index)
	
end

function CorpsOperatePage:showPage(index)
	if not self.pages[index] then
		local pageInfo = SubViewInfo[index]
		if pageInfo then
			self.pages[index] = pageInfo.class.new()
			self.pages[index]:setVisible(false)
			self:addChild(self.pages[index])
		end
	end

	for idx = 1, #SubViewInfo do
		if self.pages[idx] then
			if idx == index then
				if not self.pages[idx]:isVisible() then
					self.pages[idx]:onShow()
					self.pages[idx]:setVisible(true)
				end
			else
				if self.pages[idx]:isVisible() then
					self.pages[idx]:onHide()
					self.pages[idx]:setVisible(false)
				end
			end
		end
	end
end

function CorpsOperatePage:onGZClick()
	GlobalMessage:alert({
		title = "军团规则",
        enterTxt = "确定",
        tipTxt = configHelper:getRuleByKey(20),
        tipShowMid = true,
        hideBackBtn = true,
    })
end

function CorpsOperatePage:onDestory()
	for _, v in pairs(self.pages) do
		v:onDestory()
	end
end

return CorpsOperatePage