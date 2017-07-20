--
-- Author: Yi hanneng
-- Date: 2016-04-28 15:20:58
--
local  WelfareMonthCardView = WelfareMonthCardView or class("WelfareMonthCardView", BaseView)

function WelfareMonthCardView:ctor()
	self.ccui = cc.uiloader:load("resui/welfareMonthCardWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function WelfareMonthCardView:init()

	self.desLabel1 = cc.uiloader:seekNodeByName(self.ccui, "desLabel1")
	self.desLabel2 = cc.uiloader:seekNodeByName(self.ccui, "desLabel2")
	self.itemBg = cc.uiloader:seekNodeByName(self.ccui, "itemBg")
	self.usefulLifeLabel = cc.uiloader:seekNodeByName(self.ccui, "usefulLifeLabel")
	self.btn_Recharge = cc.uiloader:seekNodeByName(self.ccui, "btn_Recharge")
	 
	self.btn_Recharge:setTouchEnabled(true)
	self.btn_Recharge:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_Recharge:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_Recharge:setScale(1.0)
            if self.state == 1 then
            	GlobalWinManger:openWin(WinName.RECHARGEWIN) 
           	elseif self.state == 2 then
           		GlobalController.welfare:requestGetMonthCard()
            end
 
         end     
        return true
    end)

	self:setViewInfo(configHelper:getMonthCardConfig()[1])
end

function WelfareMonthCardView:setViewInfo(data)

	if data == nil then
		return 
	end

	self.data = data

	self.desLabel1:setString(data.des1)
	self.desLabel2:setString(data.des2)
	 
	local commonItem = CommonItemCell.new()
	commonItem:setData({goods_id = data.goods_id})
	self.itemBg:addChild(commonItem, 0, 0)
	commonItem:setPosition(commonItem:getContentSize().width/2   , commonItem:getContentSize().height/2 )

	--self.usefulLifeLabel:setString(data.usefulLife)
	--self.btn_Recharge:setButtonLabelString("充值"..data.price.."元")
	
end

--[[
<Packet describe="月卡信息" name="req_get_charge_month_info" type="c2s" proto="30003"> </Packet>


-<Packet describe="月卡信息" name="rep_get_charge_month_info" type="s2c" proto="30003">

<Param describe="1，没有购买月卡，2，可以领取奖励，3，奖励已经领取过了" name="state" type="int8"/>

<Param describe="剩余天数" name="over_day" type="int32"/>

</Packet>
--]]

function WelfareMonthCardView:open()

	GlobalEventSystem:addEventListener(WelfareEvent.GET_MONTHCARD_INFO, function(data)

		self.state = data.data.state
		self.day = data.data.over_day

		if data.data.state == 1 then
			self.btn_Recharge:setButtonEnabled(true)
			self.usefulLifeLabel:setVisible(false)
			self.btn_Recharge:setButtonLabelString("充值"..self.data.price.."元")
		elseif data.data.state == 2 then
			self.btn_Recharge:setButtonEnabled(true)
			self.usefulLifeLabel:setVisible(true)
			self.btn_Recharge:setButtonLabelString("领取")
		elseif data.data.state == 3 then
			self.btn_Recharge:setButtonEnabled(false)
			self.usefulLifeLabel:setVisible(true)
			self.btn_Recharge:setButtonLabelString("已领取")
		end
		 
		self.usefulLifeLabel:setString("有效期"..data.data.over_day.."天")
	end)

	GlobalEventSystem:addEventListener(WelfareEvent.GET_MONTHCARD, function(data)
 
			self.btn_Recharge:setButtonEnabled(false)
			self.usefulLifeLabel:setVisible(true)
			self.btn_Recharge:setButtonLabelString("已领取")
			self.usefulLifeLabel:setString("有效期"..(self.day-1).."天")
 
	end)

	GlobalController.welfare:requestMonthCardInfo()
 
end

function WelfareMonthCardView:close()
	GlobalEventSystem:removeEventListener(WelfareEvent.GET_MONTHCARD_INFO)
	GlobalEventSystem:removeEventListener(WelfareEvent.GET_MONTHCARD)
end

function WelfareMonthCardView:destory()
	self:close()
	WelfareMonthCardView.super.destory(self)
end

return WelfareMonthCardView