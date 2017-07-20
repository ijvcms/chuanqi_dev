--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-01-06 16:19:43
-- 七天登录
local SevenLoginWin = SevenLoginWin or class("SevenLoginWin", BaseView)

function SevenLoginWin:ctor(winTag, data, winconfig)
	SevenLoginWin.super.ctor(self, winTag, data, winconfig)
	local root = self:getRoot()
	--root:setPosition((display.width-960)/2,(display.height-640)/2)
	--self:creatPillar()
	self:initialization()
end

function SevenLoginWin:initialization()
 
	self:initComponents()
	self:initListeners()
end

--
-- 初始化事件监听。
--
function SevenLoginWin:initListeners()

end

--
-- 初始化当前窗口的所有组件。
--
function SevenLoginWin:initComponents()
	local root = self:getRoot()
	local win = cc.uiloader:seekNodeByName(root, "win")

	self.bglist = {}
	self.namelist = {}
	self.gotPiclist = {}
	self.tianTxtList = {}
	self.giftItem = {}
	for i=1,7 do
		self.giftItem[i] = cc.uiloader:seekNodeByName(root, "item"..i)
		self.bglist[i] = cc.uiloader:seekNodeByName(root, "bg"..i)
		self.namelist[i] = cc.uiloader:seekNodeByName(root, "name"..i)
		self.gotPiclist[i] = cc.uiloader:seekNodeByName(root, "gotPic"..i)

		self.bglist[i]:setTouchEnabled(true)
	    self.bglist[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.bglist[i]:setScale(1.2)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.bglist[i]:setScale(1.0)
	            self:setSelectDay(i)
	        end
	        return true
	    end)

	end
	self.selected = cc.uiloader:seekNodeByName(root, "selected")
	self.dayImg = cc.uiloader:seekNodeByName(root, "dayImg")
	self.itemLayer = cc.uiloader:seekNodeByName(root, "itemLayer")
	self.equipLayer = cc.uiloader:seekNodeByName(root, "equipLayer")
	self.getBtn = cc.uiloader:seekNodeByName(root, "getBtn")
	self.bar = cc.uiloader:seekNodeByName(root, "bar")--self.bar:setPercent(wing.lv[2] / 10 * 100)

	self.getBtn:setTouchEnabled(true)
    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.getBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.getBtn:setScale(1.0)
            if self.currentIndex > 0  then
            	GlobalController.welfare:RequestReceiveReward(self.config[self.currentIndex].key)
            end
        end
        return true
    end)

 	ArmatureManager:getInstance():loadEffect("goodsEff1")
    self.showPrizeEff = ccs.Armature:create("goodsEff1")
    self.equipLayer:addChild(self.showPrizeEff)
    self.equiplayer2=display.newNode()
    self.equipLayer:addChild(self.equiplayer2)
    self.showPrizeEff:setPosition(100,25)
    self.showPrizeEff:getAnimation():play("effect")

	--关闭窗口按钮
    self.closeBtn = cc.uiloader:seekNodeByName(win, "closeBtn")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
    end)

    self.itemList = {}

    self.config = configHelper:getWelfareRewardsByType(1)

    for i=1,#self.config do
		local bg = self.bglist[i]
		local xx,yy = bg:getPosition()
		local icon = display.newSprite(ResUtil.getGoodsIcon(self.config[i].icon_id))
		icon:setPosition(35,35)
		bg:addChild(icon)
		self.namelist[i]:setString(self.config[i].desc)
		self.gotPiclist[i]:setVisible(false)
	end

	self.currentIndex = 1 --当前签到的索引


	local sequeue = transition.sequence({
        transition.newEasing(cca.moveBy(1.5, 0, 15), "Out"),
        transition.newEasing(cca.moveBy(1.5, 0, -15), "Out")
    })
    local action = cc.RepeatForever:create(sequeue)
    --target:runAction(action)
	self.equiplayer2:runAction(action)
end

function SevenLoginWin:setSelectDay(index)
	self.currentIndex = index;
	if self.equipIcon then
		self.equiplayer2:removeChild(self.equipIcon)
	end
	self.equipIcon = display.newSprite("#"..self.config[index].pic_name..".png")
	self.equiplayer2:addChild(self.equipIcon)
	self.equipIcon:setPosition(95, 95)

	self.selected:setPosition(self.giftItem[index]:getPosition())

	local arr = self.config[index].reward

	local len = #arr;
    local beginX = len/2
    if len > 5 then
        beginX = 5/2
    end
    for i=1,#arr do
        local vo = arr[i]--self.allPrizeConfig[data.data.lottery_id_list[i]]
        if vo then
            local item = self.itemList[i]
            if item == nil then
            	item = CommonItemCell.new()
            	self.itemLayer:addChild(item)
            	self.itemList[i] = item;
            end
            item:setVisible(true)
            item:setData({goods_id = vo[1], is_bind = vo[2], num = vo[3]})
            item:setCount(vo[3])
            -- item:setVisible(false)
            item:setPosition(214 -20 + ((i-1)%5 - beginX)*90 - 40+90, 63-136+20+120*(2-math.ceil((i)/5)))
        end
    end
    for i=len+1,#self.itemList do
    	self.itemList[i]:setVisible(false)
    end

    local itemState = GlobalController.welfare:GetRewardState(self.config[index].key)
    if itemState == 0 then
	    self.getBtn:setButtonLabelString("领取奖励")
	    self.getBtn:setButtonEnabled(true)
	elseif itemState == 1 then
		self.getBtn:setButtonLabelString("已领取")
	    self.getBtn:setButtonEnabled(false)
	elseif itemState == 2 then
		self.getBtn:setButtonLabelString("未获得")
	    self.getBtn:setButtonEnabled(false)
	end

end

function SevenLoginWin:updateCurLogin()
	--奖励领取状态0未领取 1已领取 2条件未达到
	self.currentIndex = 0
	for i=1,#self.config do
		local itemState = GlobalController.welfare:GetRewardState(self.config[i].key)
		self.gotPiclist[i]:setVisible(false)
		if itemState == 0 and self.currentIndex == 0 then
			self.currentIndex = i
		elseif itemState == 1 then
			self.gotPiclist[i]:setVisible(true)
		end
	end
	--如果没有可以领取，则默认选中最后一个已领取的
	if self.currentIndex == 0 then
		for i=#self.config,1,-1 do
			local itemState = GlobalController.welfare:GetRewardState(self.config[i].key)
			if itemState == 1 then
				self.currentIndex = i
				break
			end
		end
	end
	if self.currentIndex == 0 then
		self.currentIndex = 1
	end
	self.bar:setPercent((self.currentIndex/ #self.config) * 100)
	self.dayImg:setSpriteFrame("sevenday_"..self.currentIndex..".png")
	if self.currentIndex > 0 and self.currentIndex <= #self.config then
		self:setSelectDay(self.currentIndex)
	end
end


--打开界面
function SevenLoginWin:open()
	self.super.open(self)
	if self._change_handle == nil then
		self._change_handle = GlobalEventSystem:addEventListener(WelfareEvent.CHANGE_REWARDS_STATE, function()
	    	if self.config then
	    		self:updateCurLogin()
	    	end
		end)
	end
    self:updateCurLogin()  
end

--关闭界面
function SevenLoginWin:close()
	 if self.equiplayer2 then
        self.equiplayer2:stopAllActions()
    end
	self.super.close(self)
	GlobalController.welfare:requestSignList()
	if self._change_handle then
		GlobalEventSystem:removeEventListenerByHandle(self._change_handle)
		self._change_handle = nil
	end
end

--清理界面
function SevenLoginWin:destory()
	self:close()
	self.super.destory(self)
	if self.itemList and #self.itemList > 0 then
		for i=1,#self.itemList do
			self.itemList[i]:destory()
			--self.itemLayer.removeChild(self.itemList[i])
		end
	end
end

return SevenLoginWin