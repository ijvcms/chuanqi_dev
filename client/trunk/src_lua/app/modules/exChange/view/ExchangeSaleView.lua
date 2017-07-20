--
-- Author: Yi hanneng
-- Date: 2016-02-25 11:46:11
--

local PageManager = import("app.modules.bag.view.PageManager")
local GoodsAccessDialog = import("app.modules.storage.view.GoodsAccessDialog")
local ExchangeSellTipsView = import(".ExchangeSellTipsView")

local ExchangeSaleView = ExchangeSaleView or class("ExchangeSaleView", BaseView)

function ExchangeSaleView:ctor(winTag,data,winconfig)

	self.ccui = cc.uiloader:load("resui/exchangeSellWin.ExportJson")
  	self:addChild(self.ccui)
   	
   	self:init()
end

function ExchangeSaleView:init()

	self.selectBtn = {}
	self.time = 0

	self.leftLayer = cc.uiloader:seekNodeByName(self.ccui, "leftLayer")
	self.itemCountLabel = cc.uiloader:seekNodeByName(self.ccui, "itemCountLabel")
	self.rightLayer = cc.uiloader:seekNodeByName(self.ccui, "rightLayer")
	self.helpBtn = cc.uiloader:seekNodeByName(self.ccui, "helpBtn")
	self.resetBtn = cc.uiloader:seekNodeByName(self.ccui, "resetBtn")
	self.putawayBtn = cc.uiloader:seekNodeByName(self.ccui, "putawayBtn")
	self.informationLayer = cc.uiloader:seekNodeByName(self.ccui, "informationLayer")
	self.tipsLabel = cc.uiloader:seekNodeByName(self.ccui, "tipsLabel")

	self.item = cc.uiloader:seekNodeByName(self.ccui, "item")
	self.itemName = cc.uiloader:seekNodeByName(self.ccui, "itemName")
	self.suggestPriceLabel = cc.uiloader:seekNodeByName(self.ccui, "suggestPriceLabel")
	self.priceTextField = cc.uiloader:seekNodeByName(self.ccui, "priceTextField")
	self.amountLabel = cc.uiloader:seekNodeByName(self.ccui, "amountLabel")
 
	self.selectBtn[1] = cc.uiloader:seekNodeByName(self.ccui, "selectBtn1")
  	self.selectBtn[2] = cc.uiloader:seekNodeByName(self.ccui, "selectBtn2")
  	self.selectBtn[3] = cc.uiloader:seekNodeByName(self.ccui, "selectBtn3")

  	for i=1,#self.selectBtn do
		cc.uiloader:seekNodeByName(self.selectBtn[i], "selected"):setVisible(false)
	end

	local function onEdit(event, editbox)
		if event == "ended" then
		
	    end
	end

	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(200, 30),
          listener = onEdit,
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          --dimensions = cc.size(self:getContentSize().width, self:getContentSize().height)
        })

	self.informationLayer:addChild(self.inputLab)
	self.inputLab:setPosition(self.priceTextField:getPositionX() + 24, self.priceTextField:getPositionY() - 5)
	self.inputLab:setMaxLength(6)
  	------------------------------------------------------------------------------------
    local pageManager = PageManager.new(self.leftLayer, 6, 40,{colum = 5,rows = 4,pageWidth = 424,pageHeight = 400,pageOfNum = 5,pageCapacity = 20}) --436 434
    pageManager:SetOnItemsSelectedHandler(function(event)
        local data       = event.data
        local isSelected = event.isSelected
        self:onStoreItemClick(data, isSelected)
    end)
    self.pageManager = pageManager
 	
    ------------------------

  	for i=1,#self.selectBtn do

  		self.selectBtn[i]:setTouchEnabled(true)
		self.selectBtn[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		        if event.name == "began" then
		            SoundManager:playClickSound()
		        elseif event.name == "ended" then
		            for i=1,#self.selectBtn do
		            	cc.uiloader:seekNodeByName(self.selectBtn[i], "selected"):setVisible(false)
		            end
		            cc.uiloader:seekNodeByName(self.selectBtn[i], "selected"):setVisible(true)
		            if i == 1 then
		            	self.time = 12
		            elseif i == 2 then
		            	self.time = 24
		            elseif i == 3 then
		            	self.time = 48
		            end
		        end     
		        return true
	    end)
  	end

	self.resetBtn:setTouchEnabled(true)
	self.helpBtn:setTouchEnabled(true)
	self.putawayBtn:setTouchEnabled(true)

	self.resetBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.resetBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.resetBtn:setScale(1.0)
	            self:reset()
	        end     
	        return true
    end)

    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.helpBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.helpBtn:setScale(1.0)
	             local function enterFun()
 
					end
				 	           
					GlobalMessage:alert({
						enterTxt = "确定",
						backTxt= "取消",
						tipTxt = configHelper:getRuleByKey(5),
						enterFun = handler(self, enterFun),
						tipShowMid = true,
						hideBackBtn = true,
					})
	        end     
	        return true
    end)

    self.putawayBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.putawayBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.putawayBtn:setScale(1.0)
	            if self.itemData == nil then
	            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请选择需要出售物品！")
	            	return
	            end

	            if self.inputLab:getText() == "" or tonumber(self.inputLab:getText()) < 1 then
	            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请输入出售价格！")
	            	return
	            end
	            --[[
	            local str = configHelper:getGoodSExchangeBy(self.itemData.goods_id)
				local price = string.split(str, ",")
	             if tonumber(self.inputLab:getText()) < tonumber(price[1])*self.itemNum or tonumber(self.inputLab:getText()) > tonumber(price[2])*self.itemNum then
	            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"该物品建议价格在"..price[1]*self.itemNum.."-"..price[2]*self.itemNum.."请重新输入")
	            	return
	            end
 				--]]
	            local dialog = ExchangeSellTipsView.new()
	            local data = {info = self.itemData, num = self.itemNum, price = self.inputLab:getText(),time = self.time}
		 		dialog:setData(data,handler(self, self.sale))
				GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, dialog)
	        end     
	        return true
    end)
end

function ExchangeSaleView:initViewInfo()
	self:open()
	self:handlerBag()
	self:reset()
end
--上架
function ExchangeSaleView:sale(data)
 
	local info = {}
	info.bag_id = data.info.id
	info.goods_id = data.info.goods_id
	info.num = data.num
	info.jade = data.price
	info.hour = data.time

	GameNet:sendMsgToSocket(33004, info)
end
--上架成功刷新背包
function ExchangeSaleView:saleSuccess(data)
	self:handlerBag()
	self:reset()
end

function ExchangeSaleView:open()
	GlobalEventSystem:addEventListener(ExChangeEvent.SALE_UP_SUCCESS,handler(self,self.saleSuccess))
end

function ExchangeSaleView:close()
	GlobalEventSystem:removeEventListener(ExChangeEvent.SALE_UP_SUCCESS)
	
end

------------------------背包处理---------------------

function ExchangeSaleView:handlerBag()

	local bagItemList = {}
	bagItemList = BagManager:getInstance().bagInfo:getTotalList()

	local bagList = {}

	local vo
	for i=1,#bagItemList do
		vo = bagItemList[i]
		if EquipUtil.getEquipCanUse(vo.is_use) then
			if vo.is_bind == 0 and configHelper:getGoodSCanExchangeBy(vo.goods_id) then
				bagList[#bagList + 1] = bagItemList[i]
			end
		end
	end

	self.pageManager:SetPageItemsData(bagList)
 
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    self.itemCountLabel:setString(string.format("%d/%d",#bagItemList,roleInfo.bag))

end
--背包点击
function ExchangeSaleView:onStoreItemClick(itemData,flag)
	local dialog = GoodsAccessDialog.new()
	dialog:SetAccessType(GoodsAccessDialog.ACCESS_TYPE_SAVE)
	dialog:setSaveFunc(handler(self, self.setSaleGoods))
	dialog:SetDialogData(itemData)
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, dialog)
 
end

---------------------------
--设置右边上架物品信息
function ExchangeSaleView:setSaleGoods(itemData,num)

	if itemData == nil then
		return
	end

	self.itemData = itemData
	self.itemNum = num

	self.tipsLabel:setVisible(false)
	self.informationLayer:setVisible(true)
	local goodType = configHelper:getGoodTypeByGoodId(itemData.goods_id)

	if self.item:getChildByTag(10) then
		self.item:removeChildByTag(10, true)
	end

	local commonItem = CommonItemCell.new()
	commonItem:setData(itemData)
	self.item:addChild(commonItem, 10,10)
	commonItem:setPosition(self.item:getContentSize().width/2, self.item:getContentSize().height/2)
	commonItem:setScale(0.8)
	 
	self.itemName:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))

	local str = configHelper:getGoodSExchangeBy(itemData.goods_id)
	local price = string.split(str, ",")
	self.suggestPriceLabel:setString(price[1]*self.itemNum.."-"..price[2]*self.itemNum)
	self.inputLab:setText(price[2]*num/2)
	self.amountLabel:setString(num)

	--默认设置上架12个小时

	for i=1,#self.selectBtn do
		cc.uiloader:seekNodeByName(self.selectBtn[i], "selected"):setVisible(false)
	end
	cc.uiloader:seekNodeByName(self.selectBtn[1], "selected"):setVisible(true)
	self.time = 12 

end
--重置右边物品信息
function ExchangeSaleView:reset()
	self.tipsLabel:setVisible(true)
	self.informationLayer:setVisible(false)
	self.inputLab:setText("")
	self.itemData = nil
	self.itemNum = 0
end
 
return ExchangeSaleView