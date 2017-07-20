--
-- Author: Yi hanneng
-- Date: 2016-02-26 21:03:42
--
local ExchangeBuyTipView = ExchangeBuyTipView or class("ExchangeBuyTipView", BaseView)

function ExchangeBuyTipView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/exchangeBuyTipsWin.ExportJson")
  	self:addChild(self.ccui)

  	self.ccui:setPosition((display.width-456)/2,(display.height-346)/2)
   	
   	self:init()
end

function ExchangeBuyTipView:init()

	self.fee = 0
	self.confirmFunc = nil
	self.itemBg = cc.uiloader:seekNodeByName(self.ccui, "itemBg")
	self.itemLabel = cc.uiloader:seekNodeByName(self.ccui, "itemLabel")
	self.amountLabel = cc.uiloader:seekNodeByName(self.ccui, "amountLabel")
	self.priceLabel = cc.uiloader:seekNodeByName(self.ccui, "priceLabel")
 
	self.taxLabel = cc.uiloader:seekNodeByName(self.ccui, "taxLabel")
 
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
	            GlobalEventSystem:removeEventListener(ExChangeEvent.BUYVIEW_FEE)
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
		 
	            if self.fee > wealthInfo.jade then
 
	            	local function enterFun()
  						GlobalWinManger:openWin(WinName.RECHARGEWIN)
  						if self:getParent() then
						    self:removeSelf()
						end
					end
					               
					tipTxt = "元宝数量不足，是否要去充值？"
						           
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
function ExchangeBuyTipView:setData(data,func)
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
	commonItem:setData(data)
	self.itemBg:addChild(commonItem, 10,10)
	commonItem:setPosition(self.itemBg:getContentSize().width/2, self.itemBg:getContentSize().height/2)
	commonItem:setScale(1)

	self.itemLabel:setString(configHelper:getGoodNameByGoodId(data.goods_id))
	self.amountLabel:setString("x"..data.num)
	self.amountLabel:setPositionX(self.itemLabel:getPositionX() + self.itemLabel:getContentSize().width/2 + 5)
	self.priceLabel:setString(data.jade)

	self.fee = data.jade
 
	GameNet:sendMsgToSocket(33008,{sale_id = data.sale_id})
	
 	GlobalEventSystem:addEventListener(ExChangeEvent.BUYVIEW_FEE,handler(self,self.setRate))

end

function ExchangeBuyTipView:setRate(data)
	self.fee = self.fee + data.data.result
	self.taxLabel:setString(data.data.result.."元宝")
	GlobalEventSystem:removeEventListener(ExChangeEvent.BUYVIEW_FEE)
end
 

return ExchangeBuyTipView