--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-02-24 10:53:20
--
local NoticeView = class("NoticeView", function()
	return display.newColorLayer(cc.c4b(0,0,0,100))
end)

local BOTTM_MARGIN = 80
local VIEW_SIZE = cc.size(440, 520)
local INFO_SIZE = cc.size(400, 360)

function NoticeView:ctor(noticeManager,cViewKey,info)
	self.isDestory = false
	self.manager = noticeManager
	self.viewKey = cViewKey
	self.info = info or "<font color='0xffd3af' size='18' >1.每天有10次挑战机会。<br />2.战胜比自己排名靠前的玩家可以提升自己的名次。<br />3.每天22点会根据实时排名结算名次奖励并发放。<br />4.名次奖励的声望可以在竞技场商店购买道具。</font>"
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
	self:initialization()
end

function NoticeView:onNodeEvent(data)
	--动作还没执行完就被移除,那么需要从tips队列里删掉这个tips
	if data.name == "exit" then
       self:destory()
    end
end

function NoticeView:initialization()
	local container = display.newNode()
		:addTo(self)
		:pos((display.width - VIEW_SIZE.width) / 2, (display.height - VIEW_SIZE.height) / 2)
	--标题背景
	local titleBg = display.newSprite()
	local titleBgSize = titleBg:getContentSize()
	titleBg:setPosition(VIEW_SIZE.width / 2, VIEW_SIZE.height - 30)

	--标题
	local title = display.newTTFLabel({text = "公告", size = 24})
	title:setPosition(titleBgSize.width / 2, titleBgSize.height / 2)
	--display.setLabelFilter(title)
	titleBg:addChild(title)

	-- 背景
    -- 描点设置为左下，并居中且拦截鼠标事件。
	local bg = display.newScale9Sprite("common/com_panelPic1.png", 0, 0, VIEW_SIZE,cc.rect(63, 49,1, 1))
	bg:setAnchorPoint(0, 0)
	bg:addChild(titleBg)
	container:addChild(bg)

	local infoBg = display.newScale9Sprite("common/com_viewBgPic2.png", 0, 0, cc.size(INFO_SIZE.width + 20, INFO_SIZE.height + 15))
	infoBg:setAnchorPoint(0, 0)
	infoBg:setPosition((VIEW_SIZE.width - (INFO_SIZE.width + 20)) / 2, BOTTM_MARGIN)
	container:addChild(infoBg)

    -- 公告信息（滚动 + HTML文字）
	local lbl_info = SuperRichText.new(nil, INFO_SIZE.width)
	lbl_info:renderXml(self.info)

	local scrollContainer = display.newNode()
	scrollContainer:setContentSize(lbl_info:getContentSize())
	scrollContainer:addChild(lbl_info)

	local scrollView = cc.ScrollView:create(INFO_SIZE)
	scrollView:setPosition((VIEW_SIZE.width - INFO_SIZE.width) / 2, BOTTM_MARGIN)
	scrollView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
	scrollView:setContainer(scrollContainer)
	scrollView:setContentOffset(cc.p(0, INFO_SIZE.height - scrollContainer:getContentSize().height))
	container:addChild(scrollView)

	--关闭窗口按钮
	self.closeBtn = display.newSprite("common/com_labBtnPic1.png")
		:addTo(container)
		:pos(VIEW_SIZE.width / 2, 40)
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:destory()
        end
        return true
    end)

    local upgradeLab = display.newTTFLabel({text = "确  定", size = 20, color = TextColor.BTN_W})
    	:addTo(self.closeBtn)
    	:pos(56, 21)
    --display.setLabelFilter(upgradeLab)
end

function NoticeView:close()
	if self:getParent() then
		self:removeFromParent()
	end
end

function NoticeView:destory()
	if self.isDestory == false then
		if self.viewKey and self.manager then 
			self.manager:clearNoticeViewKey(self.viewKey)
		end
		self.isDestory = true
		self:close()
	end
end

return NoticeView