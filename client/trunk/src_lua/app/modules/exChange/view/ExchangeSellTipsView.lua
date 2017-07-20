--
-- Author: Yi hanneng
-- Date: 2016-02-25 17:04:02
--

--[[

出售确认窗口
--]]
local ExchangeSellTipsView = ExchangeSellTipsView or class("ExchangeSellTipsView", BaseView)

function ExchangeSellTipsView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/exchangeSellTipsWin.ExportJson")
  	self:addChild(self.ccui)

  	self.ccui:setPosition((display.width-456)/2,(display.height-346)/2)
   	
   	self:init()
end

function ExchangeSellTipsView:init()
	self.fee = 0
	self.confirmFunc = nil
	self.itemBg = cc.uiloader:seekNodeByName(self.ccui, "itemBg")
	self.itemLabel = cc.uiloader:seekNodeByName(self.ccui, "itemLabel")
	self.amountLabel = cc.uiloader:seekNodeByName(self.ccui, "amountLabel")
	self.priceLabel = cc.uiloader:seekNodeByName(self.ccui, "priceLabel")
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.taxLabel = cc.uiloader:seekNodeByName(self.ccui, "taxLabel")
	self.rightParenthesis = cc.uiloader:seekNodeByName(self.ccui, "rightParenthesis")

	self.cancelBtn = cc.uiloader:seekNodeByName(self.ccui, "cancelBtn")
	self.confirmBtn = cc.uiloader:seekNodeByName(self.ccui, "confirmBtn")
	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")

	self.cancelBtn:setTouchEnabled(true)
	self.confirmBtn:setTouchEnabled(true)
	self.closeBtn:setTouchEnabled(true)

	self.cancelBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.cancelBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.cancelBtn:setScale(1.0)
	             if self:getParent() then
				    self:removeSelfSafety()
				  end
	        end     
	        return true
    end)

    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	             if self:getParent() then
				    self:removeSelfSafety()
				  end
	        end     
	        return true
    end)

    self.confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.confirmBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.confirmBtn:setScale(1.0)
	            local roleManager = RoleManager:getInstance()
			    local roleInfo = roleManager.roleInfo

			    local wealthInfo = roleManager.wealth
	            if self.fee > wealthInfo.coin then
	            	local function enterFun()
  						GlobalWinManger:openWin(WinName.STOREWIN)
  						if self:getParent() then
						    self:removeSelf()
						end
					end
					               
					local tipTxt = "金币数量不足，是否要去购买？"
						           
					GlobalMessage:alert({
						enterTxt = "确定",
						backTxt= "取消",
						tipTxt = tipTxt,
						enterFun = handler(self, enterFun),
						tipShowMid = true,
					})

					return 
	            end

	            if self.confirmFunc then
	            	self.confirmFunc(self.data)
	            end
	             if self:getParent() then
				    self:removeSelfSafety()
				  end
	        end     
	        return true
    end)
end

--设置显示数据，func：点击确定回调函数
function ExchangeSellTipsView:setData(data,func)
	--{info = self.itemData, num = self.itemNum, price = self.inputLab:getText(),time = self.time}
	if data == nil then
		return
	end

	self.data = data
	self.confirmFunc = func
	if self.itemBg:getChildByTag(10) then
		self.itemBg:removeChildByTag(10, true)
	end

	local commonItem = CommonItemCell.new()
	commonItem:setData(data.info)
	self.itemBg:addChild(commonItem, 10,10)
	commonItem:setPosition(self.itemBg:getContentSize().width/2, self.itemBg:getContentSize().height/2)
	commonItem:setScale(0.8)

	self.itemLabel:setString(configHelper:getGoodNameByGoodId(data.info.goods_id))
	self.amountLabel:setString("x"..data.num)
	self.amountLabel:setPositionX(self.itemLabel:getPositionX() + self.itemLabel:getContentSize().width/2 + 5)
	self.priceLabel:setString(data.price)
	self.timeLabel:setString(data.time.."小时(手续费")

	GameNet:sendMsgToSocket(33009,{hour = data.time})
	
 	GlobalEventSystem:addEventListener(ExChangeEvent.SALE_FEE,handler(self,self.setRate))

end

function ExchangeSellTipsView:setRate(data)
	self.fee = data.data.result
	self.taxLabel:setString(data.data.result..")")
	GlobalEventSystem:removeEventListener(ExChangeEvent.SALE_FEE)
end
 
return ExchangeSellTipsView

--]]