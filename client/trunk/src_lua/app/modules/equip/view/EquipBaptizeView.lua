--
-- Author: Yi hanneng
-- Date: 2016-05-16 18:51:25
--

--[[
------------------------洗炼－－－－－－－－－－－－－－

--]]
local EquipBaptizeView = EquipBaptizeView or class("EquipBaptizeView", BaseView)
function EquipBaptizeView:ctor(winTag,data,winconfig)

	EquipBaptizeView.super.ctor(self,winTag,data,winconfig)
  	local root = self:getRoot()
    self.data = nil
  	self:init()

end

function EquipBaptizeView:init()
	self.itemLayer = self:seekNodeByName("itemLayer")
  	self.equipName = self:seekNodeByName("equipName")
 	self.ProgressBar = self:seekNodeByName("ProgressBar")
 	self.ProgressBarNum = self:seekNodeByName("ProgressBarNum")
  	self.stoneNum = self:seekNodeByName("stoneNum")
 	self.coinNum = self:seekNodeByName("coinNum")
 	self.helpBtn = self:seekNodeByName("helpBtn")
  	self.baptizeBtn = self:seekNodeByName("baptizeBtn")
 	self.keepBtn = self:seekNodeByName("keepBtn")
 	self.powerNum1 = self:seekNodeByName("powerNum1")
 	self.powerNum2 = self:seekNodeByName("powerNum2")
 	self.arrowIcon = self:seekNodeByName("arrowIcon")
 	self.attriPanel = self:seekNodeByName("attriPanel")

 	self.helpBtn:setTouchEnabled(true)
    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.helpBtn:setScale(1.0)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(13),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)

    self.baptizeBtn:setTouchEnabled(true)
    --[[
    self.baptizeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.baptizeBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "click" then
            self.baptizeBtn:setScale(1.0)
            if not self.data then return end
		    local data = {
		        id = self.data.id
		    }
		    GameNet:sendMsgToSocket(14026, data)
        end     
        return true
    end)
    --]]
    self.baptizeBtn:onButtonPressed(function() 
       self.baptizeBtn:setScale(1.1)
        end)
    self.baptizeBtn:onButtonClicked(function() 
        if not self.data then return end
            local data = {
                id = self.data.id
            }
            GameNet:sendMsgToSocket(14026, data)
            -- GUIDE CONFIRM
            GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_BAPTIZE_OP_BAPTIZE)
        end)
    self.baptizeBtn:onButtonRelease(function() 
        self.baptizeBtn:setScale(1.0)
        end)
    
    self.keepBtn:setTouchEnabled(true)
    self.keepBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.keepBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.keepBtn:setScale(1.0)
            self:onSaveClick()
            -- GUIDE CONFIRM
            GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_BAPTIZE_OP_SAVE)
        end     
        return true
    end)

    self.itemLayer:setTouchEnabled(true)
  	self.itemLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.itemLayer:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.itemLayer:setScale(1.0)
           	self:equipClick()
            -- GUIDE CONFIRM
            GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_BAPTIZE_OP_SEL)
        end     
        return true
    end)

  	self.keepBtn:setButtonEnabled(false)
    self.itemList = {}

end

function EquipBaptizeView:setViewInfo(data)

	if data == nil then
		return
	end
	data = data.data
	self.data = data
	self.curBaptizeItem = data

	if self.itemLayer:getChildByTag(10) then
		self.itemLayer:removeChildByTag(10, true)
	end
 
	local commonItem = CommonItemCell.new()
	commonItem:setData(data)
	commonItem:setTag(10)
	self.itemLayer:addChild(commonItem)
	commonItem:setItemClickFunc(handler(self,self.equipClick))
	commonItem:setPosition(self.itemLayer:getContentSize().width/2, self.itemLayer:getContentSize().height/2)
	commonItem:setScale(0.94)
	self.equipName:setString(configHelper:getGoodNameByGoodId(data.goods_id))

    self.currentItemDataBaptize = data.baptize_attr_list
	local info = EquipUtil.showBaptizeAttrFormat(data.baptize_attr_list)

	local quality = configHelper:getGoodQualityByGoodId(data.goods_id)
    local baptizeNum = configHelper:getEquipBaptizeNumByQuality(quality)

	self:reset(true)

	local item
	local color
	local lock = 0 
     
 	for i=1,#info do

 		per = info[i].min/configHelper:getEquipBaptizeMaxById(info[i].key)*100
		if per <= 30 then
                color = TextColor.TEXT_W
            elseif per > 30 and per <= 60 then
                color = TextColor.TEXT_G
            elseif per > 60 and per <= 80 then
                color = TextColor.TEXT_B
            elseif per > 80 and per <= 100 then
                color = TextColor.TEXT_P
            end

        if info[i].state == 1 then
        	lock = lock + 1
        end

 		if self.itemList[info[i].id] == nil then
 			item = require("app.modules.equip.view.EquipBaptizeItem").new()
 			item:setItemClick(handler(self, self.itemLockClick))
 			self.itemList[info[i].id] = item
 			self.attriPanel:addChild(item)
 			item:setNewData({name="",min = ""})
			item:setPosition(30, self.attriPanel:getContentSize().height - (30+5)*info[i].id)
 		else
 			item = self.itemList[info[i].id]
 		end

 		item:setVisible(true)
		item:setData(info[i],color)
 		
 	end
    
    if baptizeNum > #info then
        for i=#info+1,baptizeNum do
            if self.itemList[i] == nil then
                item = require("app.modules.equip.view.EquipBaptizeItem").new()
                item:setItemClick(handler(self, self.itemLockClick))
                self.itemList[i] = item
                self.attriPanel:addChild(item)
                item:setNewData({name="",min = ""})
                item:setPosition(30, self.attriPanel:getContentSize().height - (30+5)*i)
            else
                item = self.itemList[i]
            end

            item:setVisible(true)
            item:setDes("[可洗炼]",cc.c3b(0, 255, 0))
        end
    end
    

 	self.powerNum1:setString(data.fighting)
 	self.currentFighting = data.fighting

 	--当前有多少洗炼石
    local consume
    consume = configHelper:getBaptizeCByEquipId(data.goods_id)
    
    if not consume then
        consume = {}
        consume["use_coin"] = 0
        consume["use_goods"] = 110003
        consume["use_goods_num"] = 0
    end

    local bagManager = BagManager:getInstance()
    local bagInfo = bagManager.bagInfo
    local count = bagInfo:findItemCountByItemId(consume["use_goods"])
    --需要多少洗炼石
    local lockAddStone = configHelper:getEquipBaptizeLockStone(lock)

    self.stoneNum:setString((consume["use_goods_num"]+lockAddStone).."/"..count)
    
    if consume["use_goods_num"] + lockAddStone > count then      --如果需要的洗炼石多于背包有的强化石,label变红色
        self.stoneNum:setTextColor(cc.c4b(200,0,0,255))
    else                            --如果需要的洗炼石少于或等于背包有的强化石,label变绿色
        self.stoneNum:setTextColor(cc.c4b(0,200,0,255))
    end

    --当前有多少金钱
  
    local roleManager = RoleManager:getInstance()
    local wealthInfo = roleManager.wealth
    --需要多少金钱
    --local labNeedCoin = cc.uiloader:seekNodeByName(baptizeLayer,"labNeedCoin")
    self.coinNum:setString(consume["use_coin"].."/"..wealthInfo.coin)
    self.coinNum:setVisible(true)

    if wealthInfo.coin and consume["use_coin"] > wealthInfo.coin then        --如果需要的金币多于有的金币,label变红色
        self.coinNum:setTextColor(cc.c4b(200,0,0,255))
    else                                                            --如果需要的金币少于或等于有的金币,label变绿色
        self.coinNum:setTextColor(cc.c4b(0,200,0,255))
    end
    --洗炼程度
    local per = 0
    if data.baptize_attr_list and #data.baptize_attr_list > 0 then
        for i=1,#data.baptize_attr_list do
            per = per + data.baptize_attr_list[i].value/configHelper:getEquipBaptizeMaxById(data.baptize_attr_list[i].key)
        end
        per = per/#data.baptize_attr_list
        per = math.ceil(per*100)
    end

    self.ProgressBarNum:setString(per.."%")
    self.ProgressBar:setPercent(per)

end
--选择装备洗炼
function EquipBaptizeView:equipClick()


    if self.haveBapAttr then
        local function enterFun()
            self:onSaveClick()
            self:openSelectItemWin()
        end
        local function backFun()
            self.data.baptize_attr_list = self.currentItemDataBaptize
            self.haveBapAttr = false
            self.keepBtn:setButtonEnabled(false)
            self:openSelectItemWin()
        end
        GlobalMessage:alert({
                    enterTxt = "保留",
                    backTxt= "不保留",
                    tipTxt = "是否保留最新洗炼属性?",
                    enterFun = handler(self, enterFun),
                    backFun = handler(self, backFun),
                    tipShowMid = true,
        })
        return 
    else
        self:openSelectItemWin()
    end



	 
end
--打开装备选择列表
function EquipBaptizeView:openSelectItemWin()

    local bodylist = {}
    local baglist = {}
    local body = RoleManager:getInstance().roleInfo.equip
    local bag = BagManager:getInstance().bagInfo:getEquipList()

    for i=1,#body do
        local subTypeName,subType = configHelper:getEquipTypeByEquipId(body[i].goods_id)
        if configHelper:getGoodQualityByGoodId(body[i].goods_id) > 1 and configHelper:getGoodTimeLinessByGoodId(body[i].goods_id) ~= 1 and configHelper:getEquipCanBaptizeBySubType(subType) then
            table.insert(bodylist, body[i])
        end
    end

    for j=1,#bag do
        local subTypeName,subType = configHelper:getEquipTypeByEquipId(bag[j].goods_id)
        if configHelper:getGoodQualityByGoodId(bag[j].goods_id) > 1 and configHelper:getGoodTimeLinessByGoodId(bag[j].goods_id) ~= 1  and configHelper:getEquipCanBaptizeBySubType(subType) then
            table.insert(baglist, bag[j])
        end
    end

    local selectItemsWin = require("app.modules.equip.view.SelectItemsWin").new({name = "选择装备",type = 1,from = 1, bodyEquiplist = bodylist,bagEquipList = baglist})--
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,selectItemsWin)
end

--洗炼属性
function EquipBaptizeView:baptize(data)

	if data == nil then
		return 
	end

	self.keepBtn:setButtonEnabled(true)
	self.haveBapAttr = true
	self.data.baptize_attr_list = data.data
	local info = EquipUtil.formatEquipItem(self.data)

	data = EquipUtil.showBaptizeAttrFormat(data.data)
	self.powerNum2:setString(info.fighting)

	if self.currentFighting >= info.fighting then
		self.arrowIcon:setSpriteFrame("com_equipDownArr.png")
	else
		self.arrowIcon:setSpriteFrame("com_equipUpArr.png")
	end

	self:reset()

	local item
	local color
	local per
 	for i=1,#data do

 		per = data[i].min/configHelper:getEquipBaptizeMaxById(data[i].key)*100
            if per <= 30 then
                color = TextColor.TEXT_W
            elseif per > 30 and per <= 60 then
                color = TextColor.TEXT_G
            elseif per > 60 and per <= 80 then
                color = TextColor.TEXT_B
            elseif per > 80 and per <= 100 then
                color = TextColor.TEXT_P
            end

 		if self.itemList[data[i].id] == nil then
 			item = require("app.modules.equip.view.EquipBaptizeItem").new()
 			item:setItemClick(handler(self, self.itemLockClick))
 			self.itemList[data[i].id] = item
 			self.attriPanel:addChild(item)
			item:setPosition(self.attriPanel:getContentSize().width/2 - item:getContentSize().width/2, self.attriPanel:getContentSize().height - (item:getContentSize().height+5)*data[i].id)
 		else
 			item = self.itemList[data[i].id]
 		end

 		item:setVisible(true)
		item:setNewData(data[i],color)
 	
 	end
end
--洗炼成功播放特效
function EquipBaptizeView:baptizeSuccess()

	self:playStrengEffect()
end

--播强化成功特效
function EquipBaptizeView:playStrengEffect()
    if self.streng then
        self.streng:getAnimation():play("effect")
        self.streng:setPosition(235,470)
        return
    end
    ArmatureManager:getInstance():loadEffect("qianghua")
    self.streng = ccs.Armature:create("qianghua")
    self.itemLayer:addChild(self.streng, 100,100)
    self.streng:setPosition(self.itemLayer:getContentSize().width/2,self.itemLayer:getContentSize().height/2)
    self.streng:stopAllActions()

    local function animationEvent(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
            armatureBack:getAnimation():setMovementEventCallFunc(function()end)
            --self:clearBuffEffectByID(buffEffId)
            self.streng:stopAllActions()
            self.streng:getAnimation():stop()      
            if self.streng:getParent() then
                self.streng:getParent():removeChild(self.streng)
            end 
            self.streng = nil
            ArmatureManager:getInstance():unloadEffect("qianghua")
        end
    end
    self.streng:getAnimation():setMovementEventCallFunc(animationEvent)
    self.streng:getAnimation():play("effect")
end
--洗炼属性锁定
function EquipBaptizeView:itemLockClick(item)

	if item == nil then
		return
	end

	local info = item:getData()

    if info == nil then
        return
    end

	GlobalController.equip:requestEquipBaptizeLock(self.data.id,info.id,(info.state == 1 and 0) or 1)
end
--保留洗炼属性
function EquipBaptizeView:onSaveClick()
    if not self.data or self.haveBapAttr == false then return end
    local data = {
        id = self.data.id
    }
    self.haveBapAttr = false
    self.keepBtn:setButtonEnabled(false)
    GameNet:sendMsgToSocket(14027, data)
 	if self.itemList then
		for k,v in pairs(self.itemList) do
			v:setNewData({name="",min = ""})
		end
	end
 	self.powerNum2:setString("")

end

function EquipBaptizeView:onClose()

	if self.haveBapAttr then
		local function enterFun()
		    self:onSaveClick()
		    GlobalWinManger:closeWin(self.winTag)
		end
		local function backFun()
		    self.data.baptize_attr_list = self.currentItemDataBaptize
		    self.haveBapAttr = false
		    self.keepBtn:setButtonEnabled(false)
		    GlobalWinManger:closeWin(self.winTag)
		end
		GlobalMessage:alert({
		            enterTxt = "保留",
		            backTxt= "不保留",
		            tipTxt = "是否保留最新洗炼属性?",
		            enterFun = handler(self, enterFun),
		            backFun = handler(self, backFun),
		            tipShowMid = true,
		})
		return 

	else
		GlobalWinManger:closeWin(self.winTag)
	end

end

function EquipBaptizeView:reset(flag)

	if self.itemList then
        
		for k,v in pairs(self.itemList) do

            if  not v.hasNew then
                v:setVisible(false)
            end
			
            if flag then
                v:clear()
            end
		end
	end

end

function EquipBaptizeView:open()
	GlobalEventSystem:addEventListener(EquipEvent.SELECT_GOODS_SUCCESS,handler(self,self.setViewInfo))
	GlobalEventSystem:addEventListener(EquipEvent.BAPTIZE_SUCCESS,handler(self,self.baptize))
	local function onEquipChange(data)
         
        if self.data then
            for _,equip in ipairs(data.data) do
                if equip.id == self.data.id then
                    self:baptizeSuccess()
                    self:setViewInfo({data = equip})
                    break
                end
            end
            
        end

    end
    GlobalEventSystem:addEventListener(BagEvent.EQUIP_CHANGE, onEquipChange)
end

function EquipBaptizeView:close()
	--self:onClose()
	GlobalEventSystem:removeEventListener(EquipEvent.SELECT_GOODS_SUCCESS)
	GlobalEventSystem:removeEventListener(EquipEvent.BAPTIZE_SUCCESS)
	GlobalEventSystem:removeEventListener(BagEvent.EQUIP_CHANGE)
end

function EquipBaptizeView:destory()
	self:close()
	EquipBaptizeView.super.destory(self)
end

  --点击关闭按钮
function EquipBaptizeView:onClickCloseBtn()
    GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_WIN_CLOSE_BUTTON)--在关闭之前
    self.super.onClickCloseBtn(self)
end
 
return EquipBaptizeView