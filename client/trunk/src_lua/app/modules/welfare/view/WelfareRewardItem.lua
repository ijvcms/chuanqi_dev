--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-29 18:19:11
--
local WelfareRewardItem = class("WelfareRewardItem")

local CURRENT_MODULE_NAME = ...

--
-- Factory Method
--
function WelfareRewardItem.create(root, data)
	local itemType = data.type
	local item = nil
	if itemType == 2 then
		item = import(".WelfareRewardItem_Online", CURRENT_MODULE_NAME).new(root)
	else
		item = WelfareRewardItem.new(root)
	end

	item:setData(data)
	return item
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////

function WelfareRewardItem:ctor(root)
	self._root = root
	self:initialization()
end

function WelfareRewardItem:initialization()
	self:initComponent()

	self:getRoot():addNodeEventListener(cc.NODE_EVENT, function(event)
    	if event.name == "cleanup" then
    		self:onDestory()
    	end
    end)

    self._change_handle = GlobalEventSystem:addEventListener(WelfareEvent.CHANGE_REWARDS_STATE, function()
    	self:invalidateData()
	end)
end

function WelfareRewardItem:initComponent()
	local goodsBg = cc.uiloader:seekNodeByName(self._root, "icon")
	self.goodsItem = CommonBagItem.new()
	self.goodsItem:setPosition(goodsBg:getPosition())
	self._root:addChild(self.goodsItem)

	self.lbl_reward_name = cc.uiloader:seekNodeByName(self._root, "welfarelist")
	self.lbl_condition_desc = cc.uiloader:seekNodeByName(self._root, "welfarelimit")
	self.btn_receive = cc.uiloader:seekNodeByName(self._root, "btnget")
	self.btn_check = cc.uiloader:seekNodeByName(self._root, "btnshow")

	self.btn_receive:onButtonClicked(handler(self, self.onClickReceive))
	self.btn_check:onButtonClicked(handler(self, self.onClickCheck))
end

function WelfareRewardItem:onClickReceive()
	local data = self:getData()
	if data then
		GlobalController.welfare:RequestReceiveReward(data.key)

		-- GUIDE CONFIRM
		if data.value == 1 then
			GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_REWARD_FIRST_DAT)
		end
	end
end

function WelfareRewardItem:onClickCheck()
	-- 14009
	local data = self:getData()
	if data then
		GameNet:sendMsgToSocket(14009, {goods_id = data.goods_info.goods_id})
	end
end

function WelfareRewardItem:invalidateData()
	local data = self:getData()
	if data then
		self.lbl_reward_name:setString(data.desc)
		self.lbl_condition_desc:setString(data.condition_text)

		self.goodsItem:setData(data.goods_info)

		-- 0未领取 1已领取 2 条件未达到，无法领取
		local itemState = GlobalController.welfare:GetRewardState(data.key)
		if itemState == 0 then
			self.btn_receive:setButtonEnabled(true)
			self.btn_receive:setButtonLabelString("领取")
		elseif itemState == 1 then
			self.btn_receive:setButtonEnabled(false)
			self.btn_receive:setButtonLabelString("已领取")
		elseif itemState == 2 then
			self.btn_receive:setButtonEnabled(false)
			self.btn_receive:setButtonLabelString("未获得")
		end
	end
end

function WelfareRewardItem:onDestory()
	if self._change_handle then
		GlobalEventSystem:removeEventListenerByHandle(self._change_handle)
		self._change_handle = nil
	end
end

function WelfareRewardItem:getRoot() return self._root end

function WelfareRewardItem:getData() return self._data end
function WelfareRewardItem:setData(data)
	self._data = data
	self:invalidateData()
end

return WelfareRewardItem