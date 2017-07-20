--
-- Author: Alex mailto: liao131131@vip.qq.com
-- 挂机战争挑战Boss结果界面
-- Date: 2015-12-21 11:13:02
--
local QualifyingResultView = class("QualifyingResultView", function()
	return display.newColorLayer(cc.c4b(0, 0, 0, 100))
end)


function QualifyingResultView:ctor()
	self:initialization()
end
--[[
	使用方法：
		-- 先导入：
		local QualifyingResultView = import("app.modules.qualifying.view.QualifyingResultView")

		-- 使用
		local view = QualifyingResultView:new()
		view:Show({
			isWin = true,    -- 是否胜利
			rank = 1,        -- 排名
			goodsList = {}   -- 奖励物品列表
		})
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, view)
]]


----------------------------------------------------------------------------------------
--  导出方法，你只需要调用这几个方法即可。

--
-- 显示结果
-- @param data 结果数据。
--
function QualifyingResultView:Show(data)
	self._data = data
	self:invalidateData()
end

----------------------------------------------------------------------------------------
-- 内部方法
function QualifyingResultView:initialization()
	self:initComponents()
end

function QualifyingResultView:initComponents()

	self.bg = display.newScale9Sprite("#com_panelBg3.png", 0, 0, cc.size(display.width, display.height))
--    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,225))
    self.bg:setPosition(display.cx, display.cy)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

	local ccui = cc.uiloader:load("resui/qualifyingResult.ExportJson")
	ccui:setPositionX(display.cx - 275)
    self:addChild(ccui)

    self.container_success = cc.uiloader:seekNodeByName(ccui, "container_success")
    self.container_failed  = cc.uiloader:seekNodeByName(ccui, "container_failed")
    self.container_goods   = cc.uiloader:seekNodeByName(ccui, "container_goods")
    self.lbl_rank    = cc.uiloader:seekNodeByName(ccui, "lbl_rank")
    self.img_success = cc.uiloader:seekNodeByName(self.container_success, "img_title")
    self.img_failed  = cc.uiloader:seekNodeByName(self.container_failed, "img_title")

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:close()
        end
        return true
    end)
    if self.closeTimeId == nil then
        self.closeTimeId =  GlobalTimer.scheduleGlobal(handler(self,self.close),5)
    end
end

function QualifyingResultView:close()
	if self.closeTimeId then
        GlobalTimer.unscheduleGlobal(self.closeTimeId)
        self.closeTimeId = nil
    end
    GameNet:sendMsgToSocket(11016)
	self:removeSelfSafety()
	display.removeSpriteFramesWithFile("resui/qualifyingResult0.plist", "resui/qualifyingResult0.png")

end
--
-- 根据数据刷新视图。
--
function QualifyingResultView:invalidateData()
	local data = self._data
	if data then
		local isWin     = data.isWin
		local goodsList = data.goodsList
		local rank      = data.rank

		self.container_success:setVisible(isWin)
		self.container_failed:setVisible(not isWin)

		self:playEffect(isWin and self.img_success or self.img_failed)

		if isWin and rank then
			self.lbl_rank:setString(rank)
		end

		self:clearItems()
		if goodsList then
			local numOfGoods = #goodsList
			for i = 1, numOfGoods do 
				local goodsItemData = goodsList[i]
				self:appendGoodsItem(numOfGoods, i - 1, goodsItemData)
			end
		end
	end
end

--
-- 播放特效。
--
function QualifyingResultView:playEffect(target)
	target:setScale(0.01)
    target:runAction(transition.sequence({
    	cc.ScaleTo:create(0.2, 1.2, 1.2),
    	cc.ScaleTo:create(0.05, 1, 1),
    }))
end

--
-- 添加一个物品至显示列表。
--
function QualifyingResultView:appendGoodsItem(count, index, itemData)
	local ITEM_WIDTH = 125
	local ITEM_START_X = -(ITEM_WIDTH * count / 2) + ITEM_WIDTH / 2
	local item = display.newNode()
	local goodsItem = CommonItemCell.new()
	local itemName = cc.ui.UILabel.new({
		text = itemData.name,
		size = 20,
		color = cc.c3b(243, 167, 36),
		align = cc.TEXT_ALIGNMENT_CENTER,
		valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER})
	itemName:setLayoutSize(240, 30)
	itemName:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER])

	goodsItem:setPositionY(55)
	goodsItem:setData(itemData)
	goodsItem:checkNumAndArrow()

	item:addChild(goodsItem)
	item:addChild(itemName)
	item:setPositionX(ITEM_START_X + index * ITEM_WIDTH)
	self.container_goods:addChild(item)
end

--
-- 清除所有的物品。
--
function QualifyingResultView:clearItems()
	self.container_goods:removeAllChildren()
end

return QualifyingResultView