--
-- Author: Yi hanneng
-- Date: 2016-04-21 14:50:41
--

--[[
福利中心－－－－每日签到
--]]

local WelfareSignView = WelfareSignView or class("WelfareSignView", BaseView)
function WelfareSignView:ctor()

	self.ccui = cc.uiloader:load("resui/welfareSignWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setNodeEventEnabled(true)
end

function WelfareSignView:onCleanup()
	self:close()
end

function WelfareSignView:init()
 
 	self.tagList = {}
 	self.itemList = {}
 	self.rightUpLayer = cc.uiloader:seekNodeByName(self.ccui, "rightUpLayer")
	self.totalNum = cc.uiloader:seekNodeByName(self.ccui, "totalNum")
	self.monthLayer = cc.uiloader:seekNodeByName(self.ccui, "monthLayer")
	self.tagList[1] = cc.uiloader:seekNodeByName(self.ccui, "2_Btn")
	self.tagList[2] = cc.uiloader:seekNodeByName(self.ccui, "5_Btn")
	self.tagList[3] = cc.uiloader:seekNodeByName(self.ccui, "10_Btn")
	self.tagList[4] = cc.uiloader:seekNodeByName(self.ccui, "17_Btn")
	self.tagList[5] = cc.uiloader:seekNodeByName(self.ccui, "26_Btn")
	self.timesLabel = cc.uiloader:seekNodeByName(self.ccui, "timesLabel")
	self.rewardLayer = cc.uiloader:seekNodeByName(self.ccui, "rewardLayer")
	self.btn_Get = cc.uiloader:seekNodeByName(self.ccui, "btn_Get")
	self.btn_Sign2 = cc.uiloader:seekNodeByName(self.ccui, "btn_Sign2")
	self.btn_Sign = cc.uiloader:seekNodeByName(self.ccui, "btn_Sign")
 
	 
    self.monLab = display.newBMFontLabel({
        text = "0",
        font = "fonts/sign_Font.fnt",
        --color = cc.c3b(73, 73, 73),  
    })
 	--[[
	self.monLab = cc.LabelAtlas:_create()
    self.monLab:initWithString(
              "",
              "fonts/sign_Font_0.png",
              16,
              19,
              string.byte(0))
 	--]]
 	self.monLab:setString(tonumber(os.date("%m")).."月")
    self.rightUpLayer:addChild(self.monLab)
    self.monLab:setPosition(self.monthLayer:getPositionX() + 20,self.totalNum:getPositionY() - self.monLab:getContentSize().height+9)
    self.monLab:setAnchorPoint(0,0)

    for i=1,#self.tagList do
    	self.tagList[i]:setTouchEnabled(true)
    	self.tagList[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then            
            SoundManager:playClickSound()

        elseif event.name == "ended" then
        	self.tagList[i]:setSpriteFrame("welfare_xuanz.png")
        	if self.lastClick and self.lastClick ~= self.tagList[i] then
        		self.lastClick:setSpriteFrame("welfare_weixz.png")
        	end

        	if self.lastClick ~= self.tagList[i] then
        		self.lastClick = self.tagList[i]
        		self:onClickTypeItem(i)
        	end
        	
        end
        return true
    	end)
    end

	local dayCount = getDayCountOfMonth(tonumber(os.date("%m")), tonumber(os.date("%Y")))
	local startNumber = getStartNumber(tonumber(os.date("%m")), tonumber(os.date("%Y")))
	local  i = math.floor(startNumber)

 	self.today = tonumber(os.date("%d"))

 	self.dayCount = dayCount
 	self.dateList = {}
 	self.tipList = {}
 	self.signList = {}
 	local w = self.monthLayer:getContentSize().width
 	local h = self.monthLayer:getContentSize().height
 	local tem = 1--math.floor((i+1)/7) == 0 and 1 or 0
	for  j = 1, dayCount  do
		i = i + 1
	 	local date  = display.newTTFLabel({
            text = j,      
            size = 18,
            color = TextColor.BTN_W, 
    	})
	    display.setLabelFilter(date)

	    date:setPosition(((i-1)%7+1) * w/7.5 - 20,  h - math.floor((i-1)/7 + tem) * h/6.5 - 5)
	    self.monthLayer:addChild(date)
	    self.dateList[j] = date
	end
 
	self.btn_Get:setTouchEnabled(true)
	self.btn_Sign2:setTouchEnabled(true)
	self.btn_Sign:setTouchEnabled(true)

	self.btn_Get:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_Get:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_Get:setScale(1.0)
   			GlobalController.welfare:requestSignRewards(self.currentDays)
        end
        return true
    end)

    self.btn_Sign2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_Sign2:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_Sign2:setScale(1.0)

            GlobalMessage:alert({
              enterTxt = "确定",
              backTxt= "取消",
              tipTxt = "是否消耗10元宝补签？",
              enterFun = function() GlobalController.welfare:requestDoSign2() end,
              tipShowMid = true
            })
 			
        end
        return true
    end)

    self.btn_Sign:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_Sign:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_Sign:setScale(1.0)
 			GlobalController.welfare:requestDoSign()
        end
        return true
    end)

end

function WelfareSignView:setViewInfo(data)

	if data == nil or data.data == nil then
		return 
	end

	data = data.data
	self.data = data
	self.totalNum:setString(#data.sign_list)
	self.timesLabel:setString(data.count)

	self:findFirst()

	if data.count == 0 then
		self.btn_Sign2:setButtonEnabled(false)
	end
 
	for i=1,#data.sign_list do
	 	if self.tipList[data.sign_list[i]] then
 			self.tipList[data.sign_list[i]]:setSpriteFrame("welfare_signIcon.png")
 			self.signList[data.sign_list[i]] = self.tipList[data.sign_list[i]]
 			--table.remove(self.tipList,data.sign_list[i])
		elseif self.signList[data.sign_list[i]] == nil then
			local test = display.newSprite("#welfare_signIcon.png"):addTo( self.monthLayer)
			test:setPosition(self.dateList[data.sign_list[i]]:getPositionX(), self.dateList[data.sign_list[i]]:getPositionY())
			self.signList[data.sign_list[i]] = test
			if self.todaySprite ~= nil then
				self.todaySprite:setLocalZOrder(1000)
			end
		end
 
	end

	for i=1,self.dayCount do

		if  i < self.today then
 
			if self.signList[i] == nil and self.tipList[i] == nil then
				local test = display.newSprite("#welfare_signIcon2.png"):addTo( self.monthLayer)
				test:setPosition(self.dateList[i]:getPositionX(), self.dateList[i]:getPositionY())
				self.tipList[i] = test
			end

		else

			if i == self.today then
 				if self.todaySprite == nil then
 					self.todaySprite = display.newSprite("#welfare_today.png"):addTo( self.monthLayer)
 					--self.todaySprite:setScale(0.8)
 				end

 				if self.signList[i] then
 					self.btn_Sign:setButtonEnabled(false)
 					self.btn_Sign:setButtonLabelString("已签")
 				end
 				self.todaySprite:setPosition(self.dateList[i]:getPositionX(), self.dateList[i]:getPositionY())
			else
				break
			end
		end

	end

end

function WelfareSignView:findFirst()

	if self.lastClick then
        self.lastClick:setSpriteFrame("welfare_weixz.png")
    end
 
    local config = configHelper:getDailyConfig()
	
    for i=1,#self.tagList do
    	local goodList = config[i]
	 
		if goodList == nil then
			return 
		end

		local days = goodList.count

		if #self.data.sign_list >= days then
			if self:getRewardButton(days) then
				self.tagList[i]:setSpriteFrame("welfare_xuanz.png")
				self.lastClick = self.tagList[i]
				self:onClickTypeItem(i)
				return
			end
	 
		end

    end

    self.tagList[1]:setSpriteFrame("welfare_xuanz.png")
	self.lastClick = self.tagList[1]
	self:onClickTypeItem(1)

end

function WelfareSignView:onClickTypeItem(index)

	self.currentDays = index

	local config = configHelper:getDailyConfig()
	local goodList = config[index]
	 
	if goodList == nil then
		return 
	end

	self.currentDays = goodList.count

	if #self.data.sign_list >= self.currentDays then
		if self:getRewardButton(self.currentDays) then
			self.btn_Get:setButtonEnabled(true)
			self.btn_Get:setButtonLabelString("领取")
		else
			self.btn_Get:setButtonEnabled(false)
			self.btn_Get:setButtonLabelString("已领取")
		end
	else

		self.btn_Get:setButtonEnabled(false)
		self.btn_Get:setButtonLabelString("未获得")
	end
	--[[
	if self.rewardLayer then
		self.rewardLayer:removeAllChildren()
	end

	for i=1,#goodList.reward do
		local commonItem = CommonItemCell.new()
		commonItem:setData({goods_id = goodList.reward[i][1],is_bind = goodList.reward[i][2]})
		commonItem:setCount(goodList.reward[i][3])
		self.rewardLayer:addChild(commonItem, 10, 10)
		commonItem:setPosition(i*(commonItem:getContentSize().width + 25) - 40 , commonItem:getContentSize().height/2 + 15)
	end
	--]]

	if #self.itemList > 0 then

        for i=#self.itemList,#goodList.reward + 1, -1 do
            self.itemList[i]:setVisible(false)
        end

        for i=1,#goodList.reward do
            if self.itemList[i] == nil then
                local commonItem = CommonItemCell.new()
				commonItem:setData({goods_id = goodList.reward[i][1],is_bind = goodList.reward[i][2]})
				commonItem:setCount(goodList.reward[i][3])
				self.rewardLayer:addChild(commonItem, 10, 10)
				self.itemList[#self.itemList + 1] = commonItem
				commonItem:setPosition(i*(commonItem:getContentSize().width + 25) - 40 , commonItem:getContentSize().height/2 + 15)
			else
                self.itemList[i]:setData({goods_id = goodList.reward[i][1],is_bind = goodList.reward[i][2]})
                self.itemList[i]:setCount(goodList.reward[i][3])
            end
 
        end
    else
        for i=1,#goodList.reward do
			local commonItem = CommonItemCell.new()
			commonItem:setData({goods_id = goodList.reward[i][1],is_bind = goodList.reward[i][2]})
			commonItem:setCount(goodList.reward[i][3])
			self.rewardLayer:addChild(commonItem, 10, 10)
			self.itemList[#self.itemList + 1] = commonItem
			commonItem:setPosition(i*(commonItem:getContentSize().width + 25) - 40 , commonItem:getContentSize().height/2 + 15)
		end
    end

end

function WelfareSignView:getRewardButton(days)

	for i=1,#self.data.reward_list do
		if self.data.reward_list[i] == days then
			return false
		end
	end

	return true

end
 
function WelfareSignView:getRewardSuccess()
end
 
function WelfareSignView:open()
  
	self.signListHandle = GlobalEventSystem:addEventListener(WelfareEvent.GET_SIGN_LIST,handler(self, self.setViewInfo))
	self.getRewardHandle = GlobalEventSystem:addEventListener(WelfareEvent.GET_SIGN_REWARDS,handler(self, self.getRewardSuccess))
 
    GlobalController.welfare:requestSignList()
end

function WelfareSignView:close()
	if self.signListHandle then
		GlobalEventSystem:removeEventListenerByHandle(self.signListHandle)
		self.signListHandle = nil
	end
    if self.getRewardHandle then
    	GlobalEventSystem:removeEventListenerByHandle(self.getRewardHandle)
    	self.getRewardHandle = nil
    end
end

function WelfareSignView:destory()
	self:close()

	if self.todaySprite then
		self.todaySprite:removeSelf()
		self.todaySprite = nil
	end

	for i=1,#self.dateList do
		self.dateList[i]:removeSelf()
	end
	self.dateList = {}
 	self.tipList = {}
 	self.signList = {}
 	self.super.destory(self)
end


return WelfareSignView