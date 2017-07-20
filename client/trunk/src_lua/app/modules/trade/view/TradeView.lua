
local BagView = require("app.modules.bag.view.BagView")
local batchBuyWin = require("app.modules.store.view.batchBuyWin")

local TradeView = class("TradeView", function()
	return display.newNode()
end)

function TradeView:ctor(peerPlayerName,peerPlayerLV)
	local bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    bg:setContentSize(display.width, display.height)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(bg)

 	--背包底板
 	local bg1 = display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(499, 543),cc.rect(63, 49,1, 1))
 	self:addChild(bg1)
 	--交易底板
 	local bg2 = display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(421, 543),cc.rect(63, 49,1, 1))
 	self:addChild(bg2)
 	bg1:setPosition((display.width-499)/2+(display.width-885)/2,display.height/2)
 	bg2:setPosition((display.width+421)/2+(display.width-885)/2+5,display.height/2)

 	--背包标题
 	local title1 = display.newSprite("#com_alertTitleBg.png")
 	local lab = display.newTTFLabel({
    	text = "背 包",
    	size = 24,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setPosition(title1:getContentSize().width/2,title1:getContentSize().height/2)
	title1:addChild(lab)
	bg1:addChild(title1)
	title1:setPosition(250,543-40)
 	--交易标题
 	local title2 = display.newSprite("#com_alertTitleBg.png")
 	local lab = display.newTTFLabel({
    	text = "交 易",
    	size = 24,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setPosition(title2:getContentSize().width/2,title2:getContentSize().height/2)
	title2:addChild(lab)
	bg2:addChild(title2)
	title2:setPosition(210,543-40)

	--背包
	local bv = BagView.new(cc.size(463,450)):addTo(bg1)
    bv:setPosition(18,20)
    self.bv = bv

    --箭头
    local sp = display.newSprite("#com_uiArrow1.png")
    self:addChild(sp)
    sp:setPosition(bg1:getPositionX()+260,display.height/2- 130)

    --身上的金币元宝数
    local sp = display.newSprite("#com_coin_1.png")
    bg1:addChild(sp)
    sp:setPosition(45,440)
    local lab = display.newTTFLabel({
    	text = "",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setAnchorPoint(0,0.5)
	lab:setPosition(65,440)
	bg1:addChild(lab)
	self.ssjb = lab

    local sp = display.newSprite("#com_coin_2.png")
    bg1:addChild(sp)
    sp:setPosition(170,440)
	local lab = display.newTTFLabel({
    	text = "",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setAnchorPoint(0,0.5)
	lab:setPosition(190,440)
	bg1:addChild(lab)
	self.ssyb = lab
    --背包格子数 yjc
    --交易的各种背景图
    local frameBg = display.newScale9Sprite("#com_viewBg2.png", 0, 0, cc.size(396, 450))
    frameBg:setPosition(210,543/2-26)
    bg2:addChild(frameBg)

    local frameBg2 = display.newScale9Sprite("#com_viewBg2.png", 0, 0, cc.size(375, 185))
    frameBg2:setPosition(210,543/2+95)
    bg2:addChild(frameBg2)
    self.frameBg2 = frameBg2
    local frameBg3 = display.newScale9Sprite("#com_viewBg2.png", 0, 0, cc.size(375, 185))
    frameBg3:setPosition(210,543/2-110)
    bg2:addChild(frameBg3)
    self.frameBg3 = frameBg3
    local line1 =  display.newSprite("#com_uiLine1.png")
    line1:setPosition(375/2,185-35)
    line1:setScaleX(80)
    frameBg2:addChild(line1)
    local line2 =  display.newSprite("#com_uiLine1.png")
    line2:setPosition(375/2,185-35)
    line2:setScaleX(80)
    frameBg3:addChild(line2)



    local roleManager = RoleManager:getInstance()
	local roleInfo = roleManager.roleInfo 
    --对方名字
    local lab = display.newTTFLabel({
    	text = peerPlayerName,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setPosition(375/2,185-18)
	frameBg2:addChild(lab)
	self.peerName = lab
    --我方名字
    local lab = display.newTTFLabel({
    	text = roleInfo.name,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setPosition(375/2,185-18)
	frameBg3:addChild(lab)
	self.myName = lab
    --对方等级
    local lab = display.newTTFLabel({
    	text = "等级:",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setAnchorPoint(0,0.5)
	lab:setPosition(10,185-54)
	frameBg2:addChild(lab)
	local lab = display.newTTFLabel({
    	text = peerPlayerLV,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setAnchorPoint(0,0.5)
	lab:setPosition(70,185-54)
	frameBg2:addChild(lab)
	self.peerLevel = lab
    --
    local lab = display.newTTFLabel({
    	text = "对方",
    	size = 20,
    	color = TextColor.TEXT_R
	})
	display.setLabelFilter(lab)
	lab:setAnchorPoint(0,0.5)
	lab:setPosition(320,185-54)
	frameBg2:addChild(lab)

	--对方4个itemBg
	self.peerItemBgs = {}
	for i=1,4 do
		local sp = display.newSprite("#com_propBg1.png")
		frameBg2:addChild(sp)
		sp:setPosition(50+90*(i-1),78)
		table.insert(self.peerItemBgs,sp)
	end
	--我方4个item
	self.myItemBgs = {}
	for i=1,4 do
		local sp = display.newSprite("#com_propBg1.png")
		frameBg3:addChild(sp)
		sp:setPosition(50+90*(i-1),78)
		table.insert(self.myItemBgs,sp)
	end
	--元宝图标
	local sp = display.newSprite("#com_coin_2.png")
	frameBg2:addChild(sp)
	sp:setPosition(250,20)
	local sp = display.newSprite("#com_coin_2.png")
	frameBg3:addChild(sp)
	sp:setPosition(250,20)
	--对方元宝数
	local lab = display.newTTFLabel({
    	text = "0",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(lab)
	lab:setAnchorPoint(0,0.5)
	lab:setPosition(280,20)
	frameBg2:addChild(lab)
	self.peerYB = lab
	--
 
	--锁定按钮
	local btn = display.newSprite("#com_labBtn1.png",nil,nil,{class=cc.FilteredSpriteWithOne})
	btn:setTouchEnabled(true)
    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btn:setScale(1.0)
            self:onLock()
        end     
        return true
    end)
    btn:setPosition(123,48)
    local label = display.newTTFLabel({
    	text = "锁 定",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	label:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
	btn:addChild(label)
	display.setLabelFilter(label)
	label:setTag(10)
	bg2:addChild(btn)
	self.lockBtn = btn
	--交易按钮
	local btn = display.newSprite("#com_labBtn1.png",nil,nil,{class=cc.FilteredSpriteWithOne})
	btn:setTouchEnabled(true)
    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btn:setScale(1.0)
            self:onTrade()
        end     
        return true
    end)
    btn:setPosition(298,48)
    local label = display.newTTFLabel({
    	text = "交 易",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	label:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
	btn:addChild(label)
	display.setLabelFilter(label)
	label:setTag(10)
	bg2:addChild(btn)
	self.tradeBtn = btn

	--我方元宝输入控件
	local function onEdit(event, editbox)
	    if event == "ended" then
	        -- 输入结束
	        local str = editbox:getText()
	        print(str)
	        if tonumber(str) then
	        	local inputJade = math.abs(tonumber(str))
	        	local roleManager = RoleManager:getInstance()
			    local wealthInfo = roleManager.wealth
			    --金锭(元宝值)
			    local ssJade = wealthInfo.jade or 0
	        	if inputJade>(ssJade-10) then
	        		self.myJadeLab:setString(ssJade-10>0 and ssJade-10 or ssJade)
	        	else
	        		self.myJadeLab:setString(inputJade)
	        	end
	        else
	        	GlobalAlert:show("请输入正确数字！")
	        end
	    end
	end
	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(90, 25),
          listener = onEdit,
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(90, 25)
        })
    self.inputLab:setFontSize(20)
    self.inputLab:setPosition(570, 220)
    self.inputLab:setAnchorPoint(0,0)
    self.inputLab:setMaxLength(20)
    self:addChild(self.inputLab)
    self.inputLab:setTouchEnabled(false)
    self.inputLab:setTouchSwallowEnabled(false)
    --只能输入数字
    self.inputLab:setInputMode(2)
    self.inputLab:setVisible(false)

 	local sp = display.newScale9Sprite("#com_moneyBg.png", 0, 0, cc.size(90, 25))
 	sp:setPosition(340,90)
 	bg2:addChild(sp)
 	sp:setTouchEnabled(true)
 	sp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
        print("tt")
            self.inputLab:touchDownAction(self,2)
        end     
        return true
    end)
 	

 	local label = display.newTTFLabel({
    	text = "0",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	label:setPosition(8,sp:getContentSize().height/2)
	label:setAnchorPoint(0,0.5)
	sp:addChild(label)
	display.setLabelFilter(label)
	self.myJadeLab = label

	--关闭按钮
	local btn = display.newSprite("#com_closeBtn1.png")
	btn:setTouchEnabled(true)
    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btn:setScale(1.0)
            self:onCloseClick()
            --发送交易取消协议
            GameNet:sendMsgToSocket(20004, {})
        end     
        return true
    end)
    btn:setPosition(390,510)
    bg2:addChild(btn)

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
			self:update_(...)
		end)
	self:scheduleUpdate()

    --node event 
    self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))

    self.isLock = false
    self.selectedItems = {}
    self:refreshBagData()
    self:refreshCoin()
end

function TradeView:onNodeEvent(data)
	if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
    	self:unregisterEvent()
    end
end

function TradeView:registerEvent()
	self.registerEventId = {}
    --取得对方交易物品数据变更
    local function onBTradeInfo(data)
       	--设置对方交易元宝数
       	self.peerYB:setString(data.data.jade)
       	--设置对方交易物品
       	self:removeAllTradeItem(2)
       	for i=1,#data.data.goods_list do
       		self:pushTradeItem(data.data.goods_list[i], 2)
       	end
       	--显示锁定遮罩
       	self:showLockColor(2)
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(TradeEvent.GET_B_TRADE_INFO, onBTradeInfo) 

    --交易失败
    local function onFailTrade()
    	self:onCloseClick()
    end
    self.registerEventId[2] = GlobalEventSystem:addEventListener(TradeEvent.GET_FAIL_TRADE, onFailTrade) 

    --交易成功
    local function onSuccessTrade()
    	self:onCloseClick()
    end
    self.registerEventId[3] = GlobalEventSystem:addEventListener(TradeEvent.GET_SUCCESS_TRADE, onSuccessTrade) 

    --金币元宝改变
    local function onWealthChange()
        self:refreshCoin()
    end
    self.registerEventId[4] = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,onWealthChange)
end

function TradeView:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

--刷新身上金币元宝
function TradeView:refreshCoin()
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo

    local wealthInfo = roleManager.wealth

	--金币值
    self.ssjb:setString(wealthInfo.coin or 0)

    --金锭(元宝值)
    self.ssyb:setString(wealthInfo.jade or 0)
end

--刷新背包数据
function TradeView:refreshBagData()
	local bagManager = BagManager:getInstance()
	bagItemList = bagManager.bagInfo:getTotalList()
	self.bv:cleanBagItem()
	self.cellIndex = 1
	self.cellLoaded = 0
end

function TradeView:update_()
	local bagItemList =  BagManager:getInstance().bagInfo:getTotalList()
	if bagItemList and self.cellLoaded < #bagItemList then
		self.cellLoaded = self.cellLoaded + 1
		if bagItemList[self.cellLoaded].is_bind == 0 then 
    		self.bv:setBagItem(self.cellIndex, bagItemList[self.cellLoaded],handler(self,self.bagItemModifyFunc),{})
    		self.cellIndex = self.cellIndex + 1
    	end
	end
end

--背包commonItem调整函数
function TradeView:bagItemModifyFunc(commonItem)
	local goodType = configHelper:getGoodTypeByGoodId(commonItem.data.goods_id)
    if not goodType then return end
	if goodType == 1 or goodType == 3 or goodType == 4 or goodType == 6 or goodType == 5 then      --如果是道具或宝石，需要显示数量
        commonItem:setCount(commonItem.data.num)
        commonItem:setCountVisible(true)
    end
    commonItem:setCBVisible(true)
    commonItem:setSelected(false)

    commonItem:setItemClickFunc(function()
    	--我方锁定了交易,直接return
		if self.isLock then return end
		--已经选择的物品无法再选择
		if commonItem:getSelected() then
			return 
		end
		--已经超过4个交易物品,直接return
		if #self.selectedItems >= 4 then
			return 
		end

    	local data = commonItem:getData()
    	--绑定物品无法交易 
		if data.is_bind == 1 then
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"绑定物品无法交易!")
			return 
		end

		if data.num==1 then 		--等于1的直接放到交易框里面进去
			self:pushTradeItem(commonItem.data,1)
			commonItem:setSelected(true)
			table.insert(self.selectedItems,commonItem)
		elseif data.num>1 then 		--大于1需要可选择拆开多少进行交易
			local bw = batchBuyWin.new({
		        title="存入道具",

		        sureText="确定",

		        clickFunc=function(curCount,data)
		        	local itemData = {}
		        	for k,v in pairs(data) do
		        		itemData[k] = v
		        	end
		        	itemData.num = curCount
		        	dump(itemData)
		            self:pushTradeItem(itemData,1)
		            commonItem:setSelected(true)
					table.insert(self.selectedItems,commonItem)
		        end,

		        countFunc=function(curCount,label)
		            label:setString("总共"..curCount.."个")
		        end,

		        data=data,

		        max=data.num,
		     
		    })
		    bw:setCloseFunc(function()
		    	self.bw = nil
		    end)
		    self.bw = bw
		    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,bw)
		end
    end)
end

--push一个item到交易格子
function TradeView:pushTradeItem(itemData,belong)
	if not belong or not itemData then return end
	if belong == 1 then 		--属于我方的
		for i=1,#self.myItemBgs do
			if not self.myItemBgs[i]:getChildByTag(10) then
				local commonItem = CommonItemCell.new()
				commonItem:setData(itemData)
				self.myItemBgs[i]:addChild(commonItem)
				commonItem:setTag(10)
				commonItem:setPosition(self.myItemBgs[i]:getContentSize().width/2,self.myItemBgs[i]:getContentSize().height/2)
				commonItem:setItemClickFunc(function()
					self:removeTradeItem(i, belong)
				end)
				local goodType = configHelper:getGoodTypeByGoodId(commonItem.data.goods_id)
			    if not goodType then return end
				if goodType == 1 or goodType == 3 or goodType == 4 or goodType == 6 or goodType == 5 then      --如果是道具或宝石，需要显示数量
			        commonItem:setCount(commonItem.data.num)
			        commonItem:setCountVisible(true)
			    end
			    break
			end
		end
	else 						--属于对方的
		for i=1,#self.peerItemBgs do
			if not self.peerItemBgs[i]:getChildByTag(10) then
				local commonItem = CommonItemCell.new()
				commonItem:setData(itemData)
				self.peerItemBgs[i]:addChild(commonItem)
				commonItem:setTag(10)
				commonItem:setPosition(self.peerItemBgs[i]:getContentSize().width/2,self.peerItemBgs[i]:getContentSize().height/2)
				-- commonItem:setItemClickFunc(function()
				-- 	self:removeTradeItem(i, belong)
				-- end)
				local goodType = configHelper:getGoodTypeByGoodId(commonItem.data.goods_id)
			    if not goodType then return end
				if goodType == 1 or goodType == 3 or goodType == 4 or goodType == 6 or goodType == 5 then      --如果是道具或宝石，需要显示数量
			        commonItem:setCount(commonItem.data.num)
			        commonItem:setCountVisible(true)
			    end
			    break
			end
		end
	end
end

--移除一个交易item
function TradeView:removeTradeItem(index,belong)
	if not belong or not index then return end
	if belong == 1 then
		if self.isLock then return end
	end
	local itemBgs = belong==1 and self.myItemBgs or self.peerItemBgs
	if itemBgs[index]:getChildByTag(10) then
		local data = itemBgs[index]:getChildByTag(10):getData()
		for i=1,#self.selectedItems do
			if self.selectedItems[i]:getData().id == data.id then
				self.selectedItems[i]:setSelected(false)
				table.remove(self.selectedItems,i)
				break
			end
		end
		itemBgs[index]:getChildByTag(10):removeSelf()
	end
end

--移除所有交易item
function TradeView:removeAllTradeItem(belong)
	if not belong then return end
	local itemBgs = belong==1 and self.myItemBgs or self.peerItemBgs
	for i=1,#itemBgs do
		if itemBgs[i]:getChildByTag(10) then
			itemBgs[i]:getChildByTag(10):removeSelf()
		end
	end
end

--显示锁定时的颜色遮罩
function TradeView:showLockColor(belong)
	if not belong then return end
	if belong == 1 then
		if not self.lockMaskColor1 then
			self.lockMaskColor1 = display.newScale9Sprite("#com_listSelFrame.png", 0, 0, cc.size(375, 185))
			self.frameBg3:addChild(self.lockMaskColor1)
			self.lockMaskColor1:setPosition(self.frameBg3:getContentSize().width/2,self.frameBg3:getContentSize().height/2)
		end
		self.lockMaskColor1:setVisible(true)
		
	else
		if not self.lockMaskColor2 then
			self.lockMaskColor2 = display.newScale9Sprite("#com_listSelFrame.png", 0, 0, cc.size(375, 185))
			self.frameBg2:addChild(self.lockMaskColor2)
			self.lockMaskColor2:setPosition(self.frameBg2:getContentSize().width/2,self.frameBg2:getContentSize().height/2)
		end
		self.lockMaskColor2:setVisible(true)
	end
end

--锁定点击回调
function TradeView:onLock()
	self.isLock = true
	self:showLockColor(1)
	--锁定按钮变灰
	local filters = filter.newFilter("GRAY", {0.2, 0.3, 0.5, 0.1})
    self.lockBtn:setFilter(filters)
    self.lockBtn:setTouchEnabled(false)
	--发送交易物品变更协议
	local data = {
		jade = tonumber(self.myJadeLab:getString()),
		trade_list  = {},
	}
	for i=1,#self.myItemBgs do
		if self.myItemBgs[i]:getChildByTag(10) then
			local itemData = self.myItemBgs[i]:getChildByTag(10):getData()
			table.insert(data.trade_list,{id=itemData.id,goods_id=itemData.goods_id,num=itemData.num})
		end
	end
	GameNet:sendMsgToSocket(20005, data)
end

--交易点击回调
function TradeView:onTrade()
	if not self.isLock then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请先锁定物品")
		return
	end
	--交易按钮变灰
	local filters = filter.newFilter("GRAY", {0.2, 0.3, 0.5, 0.1})
    self.tradeBtn:setFilter(filters)
    self.tradeBtn:setTouchEnabled(false)
	--发送确认交易协议
	GameNet:sendMsgToSocket(20007, {})
end

--关闭点击回调
function TradeView:onCloseClick()
	if self.bw then
		self.bw:onCloseClick()
		self.bw = nil
	end
	self:removeSelfSafety()
end

return TradeView