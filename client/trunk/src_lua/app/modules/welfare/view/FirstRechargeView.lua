--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-30 18:04:24
--

--[[
    视图：首冲奖励
]]

local FirstRechargeView = class("FirstRechargeView", function()
	return display.newColorLayer(cc.c4b(0, 0, 0, 100))
end)

function FirstRechargeView:ctor()
	self:initialization()
end

function FirstRechargeView:initialization()
	self._rewards_id = configHelper:getFirstRewardId()
	self._state = GlobalController.welfare:GetRewardState(self._rewards_id)
	self:initComponent()
	self:registerGlobalEventHandler(WelfareEvent.GET_FIRST_GOODS_LIST, function(event)
		self:loadRewardGoodsList(event.data)
	end)
	GlobalController.welfare:RequestGetFirstGoodsList()
end

function FirstRechargeView:initComponent()
	local ccui = cc.uiloader:load("resui/firstRecharge.ExportJson")
	local win = cc.uiloader:seekNodeByName(ccui, "win")
    local mainLayer = cc.uiloader:seekNodeByName(ccui, "mainLayer")

    local contentSize = mainLayer:getContentSize()
	-- 物品列表
	 self._goodsList = cc.ui.UIListView.new({
        viewRect = cc.rect(0, 0, contentSize.width, contentSize.height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
        :addTo(mainLayer)

    -- 充值跳转/领取按钮。
    self.funcBtn = cc.uiloader:seekNodeByName(win, "buy")
    self.funcBtn:setTouchEnabled(true)
    self.funcBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.funcBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.funcBtn:setScale(1.0)
            self:onClickFuncButton()
        end
        return true
    end)
    local btnLabel = cc.uiloader:seekNodeByName(win, "Label")
    if self._state == 0 then
    	btnLabel:setString("领取首充大礼包")
    elseif self._state == 1 then
    	btnLabel:setString("已领取礼包")
    	self.funcBtn:setTouchEnabled(false)
    	self.funcBtn:setColor(cc.c3b(128, 128, 128))
    elseif self._state == 2 then
    	btnLabel:setString("首充领礼包")
    end

	-- 关闭窗口按钮
    self.closeBtn = cc.uiloader:seekNodeByName(win, "closeBtn")
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

    local career = RoleManager:getInstance().roleInfo.career --职业 战士1000 法师 2000 道士 3000
    local equipImg = cc.uiloader:seekNodeByName(ccui, "equipImg")
    local equipName = cc.uiloader:seekNodeByName(ccui, "equipName")
    if  career == 1000 then
        equipImg:setSpriteFrame("firstRecharge_equip1.png")
        equipName:setSpriteFrame("firstRecharge_equipName1.png")
    elseif career == 2000 then
        equipImg:setSpriteFrame("firstRecharge_equip2.png")
        equipName:setSpriteFrame("firstRecharge_equipName2.png")
    else
        equipImg:setSpriteFrame("firstRecharge_equip3.png")
        equipName:setSpriteFrame("firstRecharge_equipName3.png")
    end
    self:playAnimation(equipImg)
    local wingImg = cc.uiloader:seekNodeByName(ccui, "wingImg")
    self:playAnimation(wingImg)
    local uiSize = ccui:getContentSize()
    ccui:setPosition((display.width - uiSize.width) * .5, (display.height - uiSize.height) * .5)
	self:addChild(ccui)
end

function FirstRechargeView:playAnimation(target)
    local sequeue = transition.sequence({
        transition.newEasing(cca.moveBy(1.5, 0, 15), "Out"),
        transition.newEasing(cca.moveBy(1.5, 0, -15), "Out")
    })
    local action = cc.RepeatForever:create(sequeue)
    target:runAction(action)
end

function FirstRechargeView:loadRewardGoodsList(goods_list)
	self._goodsList:removeAllItems()
    
	local NUM_OF_COLUMN = 4
    local ROW_WIDTH = self._goodsList:getViewRect().width
	local NUM_OF_ROWS   = math.ceil(#goods_list / NUM_OF_COLUMN)
	local ELEMENT_SIZE = cc.size(74, 74)
	local ELEMENT_COLUMN_GAP = (ROW_WIDTH - NUM_OF_COLUMN * ELEMENT_SIZE.width) / NUM_OF_COLUMN
	local LAYOUT_WIDTH  = ELEMENT_SIZE.width + ELEMENT_COLUMN_GAP

    -- add items
    for i = 1, NUM_OF_ROWS do
        local item = self._goodsList:newItem()
        local content = display.newNode()

        for count = 1, NUM_OF_COLUMN do
        	local idx = (i - 1) * NUM_OF_COLUMN + count
        	local goods_info = goods_list[idx]
        	if not goods_info then break end
    		
            local goods = CommonItemCell.new()
            goods:setData(goods_info)
            goods:setPosition((count - 1) * LAYOUT_WIDTH + (LAYOUT_WIDTH / 2), (ELEMENT_SIZE.height + 10) * .5)
            goods:setTouchSwallowEnabled(false)
            goods:checkNumAndArrow()
            content:addChild(goods)
        end
        -- content:addChild(display.newRect(cc.rect(0, 0, 450, ELEMENT_SIZE.height + 10), {fillColor = cc.c4f(1,0,0,.2), borderColor = cc.c4f(0,1,0,.2), borderWidth = 1}))
        content:setContentSize(ROW_WIDTH, ELEMENT_SIZE.height + 10)
        item:addContent(content)
        item:setItemSize(ROW_WIDTH, ELEMENT_SIZE.height + 10)

        self._goodsList:addItem(item)
    end
    self._goodsList:reload()
    -- self._goodsList:elasticScroll()
end

function FirstRechargeView:show()
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, self)
end

function FirstRechargeView:onClickFuncButton()
	if self._state == 0 then
		-- 领取
		GlobalController.welfare:RequestReceiveReward(self._rewards_id)
    elseif self._state == 2 then
    	-- 跳转至充值界面
    	GlobalWinManger:openWin(WinName.RECHARGEWIN)
    end

    self:close()
end


--
-- 注册全局事件监听。
--
function FirstRechargeView:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function FirstRechargeView:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

function FirstRechargeView:close()
	self:removeAllEvents()
	self:removeFromParent()
    display.removeSpriteFramesWithFile("firstRecharge0.plist", "firstRecharge0.png")
end

return FirstRechargeView
