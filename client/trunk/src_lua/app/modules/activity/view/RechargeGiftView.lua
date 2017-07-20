--
-- Author: Yi hanneng
-- Date: 2016-05-03 16:01:34
--
--[[
赤月紫装欢乐送
--]]
local RechargeGiftView = RechargeGiftView or class(RechargeGiftView, BaseView)

function RechargeGiftView:ctor()

	self.ccui = cc.uiloader:load("resui/serveEquipItem.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setViewInfo(nil)

end

function RechargeGiftView:init()

	self.btnGet = cc.uiloader:seekNodeByName(self.ccui, "recharge_btn")
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	self.moneyLabel = cc.uiloader:seekNodeByName(self.ccui, "moneyLabel")
	 
	self.btnGet:setTouchEnabled(true)
	self.btnGet:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnGet:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnGet:setScale(1.0)
            if self.data and self.data.is_receive and self.data.is_receive == 0 then
            	GlobalController.activity:requestActivityServiceReward(self.data.id)
           	else
           		GlobalWinManger:openWin(WinName.RECHARGEWIN)
            end
         end     
        return true
    end)
 

end

function RechargeGiftView:setViewInfo(data)

	if data == nil then
		return 
	end

	self.data = data
	self.moneyLabel:setString(data.value)
	self:setGoods(data["reward_"..RoleManager:getInstance().roleInfo.career])
	--0可以领取1,未达到条件，2，已经领取

	if self.data.is_receive == 0 then
		self.btnGet:setButtonLabelString("领取")
		self.btnGet:setButtonEnabled(true)
	elseif self.data.is_receive == 2 then
		self.btnGet:setButtonLabelString("已领取")
		self.btnGet:setButtonEnabled(false)
	else 
		self.btnGet:setButtonLabelString("前往充值")
		self.btnGet:setButtonEnabled(true)
	end

end

function RechargeGiftView:setGoods(data)

	if data == nil then
		return 
	end

	for i=1,#data do
		local item = self:createItem(data[i])
		self.mainLayer:addChild(item)
		item:setPosition(100 + 90 * ((i-1)%4), self.ccui:getContentSize().height/2 + ((i > 4 and - 110) or 0) - 20)
	end

end

function RechargeGiftView:createItem(data)
    local node = display.newNode()
    local contentBg = display.newSprite("#com_propBg1.png")
    local item = CommonItemCell.new():addTo(contentBg)
    item:setData({goods_id=data[1],is_bind = data[2]})
    item:setCount(data[3])
    --item:setScale(0.85)
 	item:setPosition(contentBg:getContentSize().width/2, contentBg:getContentSize().height/2)
    node:addChild(contentBg)
 
    return node
end

function RechargeGiftView:setViewButtonEnable(enable)

	if self.btnGet then
		self.btnGet:setButtonLabelString("已领取")
		self.btnGet:setButtonEnabled(false)
	end

end

function RechargeGiftView:open()
	 
end

function RechargeGiftView:close()
 
end

function RechargeGiftView:destory()
 
	self:close()
	RechargeGiftView.super.destory(self)
end

return RechargeGiftView