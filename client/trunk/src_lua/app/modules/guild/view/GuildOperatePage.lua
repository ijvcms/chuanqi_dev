--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:21:23
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--
--行会操作页
local GuildBasePage         = import(".GuildBasePage")
local GuildInfoPage         = import(".GuildInfoPage")
local GuildMemberPage       = import(".GuildMemberPage")
local GuildUnionPage        = import(".GuildUnionPage")
local GuildActivityPage     = import(".GuildActivityPage")
local GuildStorePage        = import(".GuildStorePage")
local GuildProposerPage     = import(".GuildProposerPage")
local GuildLogPage          = import(".GuildLogPage")
local GuildBriberyMoneyPage = import(".GuildBriberyMoneyPage")

local GuildOperatePage = class("GuildOperatePage", GuildBasePage)

local SubViewIndexs = {
	SubView_Info            = 1,
	SubView_Menber          = 2,
	SubView_Union           = 3,
	SubView_Activity        = 4,
	SubView_Store           = 5,
	SubView_Bribery_Money   = 6,
	SubView_Proposer        = 7,
	SubView_Log             = 8,
}

local SubViewInfo = {
	[SubViewIndexs.SubView_Info]             = {tagName = "行会信息", class = GuildInfoPage},
	[SubViewIndexs.SubView_Menber]           = {tagName = "行会成员", class = GuildMemberPage},
	[SubViewIndexs.SubView_Union]            = {tagName = "行会结盟", class = GuildUnionPage},
	[SubViewIndexs.SubView_Activity]         = {tagName = "行会活动", class = GuildActivityPage},
	[SubViewIndexs.SubView_Store]            = {tagName = "行会商店", class = GuildStorePage},
	[SubViewIndexs.SubView_Bribery_Money]    = {tagName = "行会红包", class = GuildBriberyMoneyPage},
	[SubViewIndexs.SubView_Proposer]         = {tagName = "申请列表", class = GuildProposerPage},
	[SubViewIndexs.SubView_Log]              = {tagName = "行会日志", class = GuildLogPage},
}

function GuildOperatePage:ctor(param)
	--左边
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
        if info.tagName == "行会信息" then
			local dd = BaseTipsBtn.new(BtnTipsType.BTN_GUILD_INFO,tagButton,170-8,44-8)
		elseif info.tagName == "申请列表" then
			local dd = BaseTipsBtn.new(BtnTipsType.BTN_GUILD_APPLY_LIST,tagButton,170-8,44-8)
		elseif info.tagName == "行会活动" then
			local dd = BaseTipsBtn.new(BtnTipsType.BTN_GUILD_ACTIVITY,tagButton,170-8,44-8)
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

function GuildOperatePage:createTagButton(index, tagName)
	local tag = display.newSprite("#com_labBtn4.png")
	local selected = display.newSprite("#com_labBtn4Sel.png")
	selected:setTag(10)
	selected:setPosition(tag:getContentSize().width/2,tag:getContentSize().height/2)
	selected:setVisible(false)
	tag:addChild(selected)
	-- tag:setTouchEnabled(true)
 --    tag:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
 --        if event.name == "began" then
 --            SoundManager:playClickSound()
 --        elseif event.name == "ended" then
 --            self:onTagClick(index)
 --        end     
 --        return true
 --    end)
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

function GuildOperatePage:onListViewTouch(event)
	if "clicked" == event.name then
		SoundManager:playClickSound()
		self:onTagClick(event.itemPos)
	end
end

function GuildOperatePage:onTagClick(index)
	if self.curTag then
		self.curTag:getChildByTag(10):setVisible(false)
	end
	self.curTag = self.tagBtns[index]
	self.curTag:getChildByTag(10):setVisible(true)

	self:showPage(index)
	
end

function GuildOperatePage:showPage(index)
	if not self.pages[index] then
		local pageInfo = SubViewInfo[index]
		if pageInfo then
			self.pages[index] = pageInfo.class.new()
			self.pages[index]:setVisible(false)
			self:addChild(self.pages[index])
		end
	end

	for _, idx in pairs(SubViewIndexs) do
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

function GuildOperatePage:onGZClick()
	GlobalMessage:alert({
		title = "行会规则",
        enterTxt = "确定",
        tipTxt = configHelper:getRuleByKey(3),
        tipShowMid = true,
        hideBackBtn = true,
    })
end

function GuildOperatePage:onDestory()
	for _, v in pairs(self.pages) do
		v:onDestory()
	end
end

return GuildOperatePage