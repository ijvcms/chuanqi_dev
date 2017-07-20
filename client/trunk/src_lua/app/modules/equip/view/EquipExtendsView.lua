--
-- Author: Yi hanneng
-- Date: 2016-05-10 19:02:17
--

--[[
－－－－－－－－－－－－继承－－－－－－－－－－－
--]]
local PageManager = require("app.modules.bag.view.PageManager")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local EquipBaptizeItem = EquipBaptizeItem or class("EquipBaptizeItem", BaseView)

local EquipExtendsView = EquipExtendsView or class("EquipExtendsView", BaseView)

local GoodsUtil = require("app.utils.GoodsUtil")

function EquipExtendsView:ctor(winTag,data,winconfig)
	EquipExtendsView.super.ctor(self,winTag,data,winconfig)
  	local root = self:getRoot()
  	self:init()
end

function EquipExtendsView:init()
    self.index = 1
    self.tab = {}
    self.lastTab = nil
    self.currentTabIndex = 0
    self.tab[1] = self:seekNodeByName("Btn_strength")
    self.tab[2] = self:seekNodeByName("Btn_soul")
    self.tab[3] = self:seekNodeByName("Btn_baptize")

    self.tab[2]:setVisible(false)
    self.tab[1]:setPositionX(self.tab[2]:getPositionX())

    self.helpBtn = self:seekNodeByName("helpBtn")

    for i=1,#self.tab do
        self.tab[i]:setTouchEnabled(true)
        self.tab[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onClickTab(i)
        end     
        return true
    end)
    end
 

    self.helpBtn:setTouchEnabled(true)
    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then

            self.helpBtn:setScale(1.0)
            local str = ""
            if self.currentTabIndex == 1 then
                str = configHelper:getRuleByKey(9)
            elseif self.currentTabIndex == 2 then
                str = configHelper:getRuleByKey(17)
            elseif self.currentTabIndex == 3 then
                str = configHelper:getRuleByKey(18)
            end

            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt = "取消",
                  tipTxt = str,
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)
    
    ---------------------
    self.layer = {}
    self.lastLayer = nil

	self:initExtends()
    self:initSoul()
    self:initBatize()

    ---------------------
    self.leffLay = self:seekNodeByName("leftLay")

    local pageManager = PageManager.new(self.leffLay, 6, 42,{colum = 4,rows = 5,pageWidth = 340,pageHeight = 440,pageOfNum = 5,pageCapacity = 20}) --352 488
    pageManager:SetOnItemsSelectedHandler(function(event)
        local data       = event.data
        local isSelected = event.isSelected
        self:handleItemClick(data, isSelected)
    end)
    pageManager:SetChooseEnabled(false)
    self.pageManager = pageManager

    ------------------------
    self:onClickTab(1)
    
end

function EquipExtendsView:onClickTab(index)

    if self.currentTabIndex == index or self.tab[index] == nil then
        return
    end

    self.currentTabIndex = index

    if self.lastTab then
        self.lastTab:setSpriteFrame("com_tabBtn1.png")
    end

    if self.lastLayer then
        self.lastLayer:setVisible(false)
    end

    self.layer[index]:setVisible(true)
    self.tab[index]:setSpriteFrame("com_tabBtn1Sel.png")

    self.lastTab = self.tab[index]
    self.lastLayer = self.layer[index]

    self:hanldeTab(index)

end

function EquipExtendsView:hanldeTab(index)
    
    if self.currentTabIndex == 1 then
        self:handleStrenData()
    elseif self.currentTabIndex == 2 then
        self:handleSoulData()
    elseif self.currentTabIndex == 3 then
        self:handleBatizeData()
    end
    
end

function EquipExtendsView:handleItemClick(itemData, isSelected)
    if self.currentTabIndex == 1 then
        self:onStoreItemClick(itemData, isSelected)
    elseif self.currentTabIndex == 2 then
        self:onSoulItemClick(itemData, isSelected)
    elseif self.currentTabIndex == 3 then
        self:onBatizeItemClick(itemData, isSelected)
    end
end


------------------------------------------------
--强化继承
function EquipExtendsView:initExtends()

    self.layer[1] = self:seekNodeByName("LeftLayer")
    self.layer[1]:setVisible(false)

    self.equip1 = self:seekNodeByName("equip1")
    self.equip2 = self:seekNodeByName("equip2")
    self.equip3 = self:seekNodeByName("equip3")

    self.NameLabel1 = self:seekNodeByName("NameLabel1")
    self.NameLabel2 = self:seekNodeByName("NameLabel2")
    self.NameLabel3 = self:seekNodeByName("NameLabel3")

    self.coinLabel = self:seekNodeByName("coinLabel")
    self.inheritanceBtn = self:seekNodeByName("inheritanceBtn")
   
    self.equip2DataId = nil
    self.stren_lv = 0
    self.newSten_lv = 0
    self.sId = 0
    self.dId = 0

    for i=1,2 do

        self:seekNodeByName("equip"..i):setTouchEnabled(true)
        self:seekNodeByName("equip"..i):addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)

            if event.name == "began" then
                SoundManager:playClickSound()
            elseif event.name == "ended" then

                local hash = false
                if self:seekNodeByName("equip"..i):getChildByTag(999) then
                    hash = true
                    self.inheritanceBtn:setButtonEnabled(false)
                    self:seekNodeByName("equip"..i):removeChildByTag(999, true)
                end
               
                if i == 1 then
                    if hash then
                        self.index = 1
                        --恢复背包
                        self:removeExtendsEquip(self.stren_lv)
                        self.newSten_lv = 0
                        self.sId = 0
                        if self.equip2:getChildByTag(999) then
                            self:setExtendsEquip(self.equip2:getChildByTag(999):getData())
                            self.NameLabel1:setString("")
                        end
                        self:initStrenBag(self.index)
                    end
                    
                elseif i == 2 then
                    if hash then
                        self.index = 2
                        if self:seekNodeByName("equip"..1):getChildByTag(999) == nil then
                        self.index = 1
                        end

                        self.dId = 0
                        self:removeExtendsEquip(self.stren_lv)
                        self.NameLabel2:setString("")
                        self.NameLabel3:setString("")
                        self.equip2Data = nil
                        self.equip2DataId = nil
                        self.tempItemData = nil
                        self.stren_lv = 0
                        self:initStrenBag(self.index)
                    end
                end
            
            end     
        return true
        end)
    end
 
    self.inheritanceBtn:setTouchEnabled(true)
    self.inheritanceBtn:setButtonEnabled(false)
    self.inheritanceBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)

        if event.name == "began" then
            self.inheritanceBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.inheritanceBtn:setScale(1.0)
            if self.sId ~= 0 and self.dId ~= 0 then
                GlobalController.equip:requestExtends(self.sId,self.dId)
            end
        end     
        return true
    end)
end

function EquipExtendsView:handleStrenData()
    self:initStrenBag(self.index)
end


--装备的过滤
local function _filterEquip(equip)
    local goods_id = equip.goods_id
    local isLoginRing = GoodsUtil.isLoginSpecialRingByGoodId(goods_id)
    local subTypeName,subType = configHelper:getEquipTypeByEquipId(goods_id)
    return subType ~= 5 and subType ~= 13 and subType ~= 15 and configHelper:getGoodTimeLinessByGoodId(goods_id) ~= 1 and not isLoginRing
end
 
function EquipExtendsView:initStrenBag(type)
 
  self.equipList = {}
  local bodyEquipList = RoleManager:getInstance().roleInfo.equip
  local bagEquipList = BagManager:getInstance().bagInfo:getEquipList()

	if type == 1 then
	 	for i=1,#bodyEquipList do
            local goods_id = bodyEquipList[i].goods_id
            local isLoginRing = GoodsUtil.isLoginSpecialRingByGoodId(goods_id)
	 		local subTypeName,subType = configHelper:getEquipTypeByEquipId(goods_id)
            --筛选勋章和翅膀
            if subType ~= 5 and subType ~= 13 and subType ~= 15 and configHelper:getGoodTimeLinessByGoodId(goods_id) ~= 1 and not isLoginRing then
		      if  bodyEquipList[i].stren_lv > 0 then
    		      self.equipList[#self.equipList + 1] = bodyEquipList[i]
		      end
	  		end
	  	end
	 
	  	for j=1,#bagEquipList do
            local goods_id = bagEquipList[j].goods_id
            local isLoginRing = GoodsUtil.isLoginSpecialRingByGoodId(goods_id)
	   	   local subTypeName,subType = configHelper:getEquipTypeByEquipId(goods_id)
            --筛选勋章和翅膀
            if subType ~= 5 and subType ~= 13 and subType ~= 15 and configHelper:getGoodTimeLinessByGoodId(goods_id) ~= 1 and not isLoginRing then
	      if bagEquipList[j].stren_lv > 0  then
            if EquipUtil.getEquipCanUse(bagEquipList[j].is_use) then
    	        self.equipList[#self.equipList + 1] = bagEquipList[j]
            end
	      end
	  		end
	    end
	elseif type == 2 then
		for i=1,#bodyEquipList do
            local goods_id = bodyEquipList[i].goods_id
            local isLoginRing = GoodsUtil.isLoginSpecialRingByGoodId(goods_id)
			local subTypeName,subType = configHelper:getEquipTypeByEquipId(goods_id)
            --筛选勋章和翅膀
            if subType ~= 5 and subType ~= 13 and subType ~= 15 and configHelper:getGoodTimeLinessByGoodId(goods_id) ~= 1 and not isLoginRing then
	      if  bodyEquipList[i].stren_lv < self.newSten_lv and self.equip2DataId ~= bodyEquipList[i].id then
	        self.equipList[#self.equipList + 1] = bodyEquipList[i]
	      end
	  end
	  	end
	 
	  	for j=1,#bagEquipList do
            local goods_id = bagEquipList[j].goods_id
            local isLoginRing = GoodsUtil.isLoginSpecialRingByGoodId(goods_id)
	  		local subTypeName,subType = configHelper:getEquipTypeByEquipId(goods_id)
            --筛选勋章和翅膀
            if subType ~= 5 and subType ~= 13 and subType ~= 15 and configHelper:getGoodTimeLinessByGoodId(goods_id) ~= 1 and not isLoginRing  then
    	      if bagEquipList[j].stren_lv < self.newSten_lv  and self.equip2DataId ~= bagEquipList[j].id then
                    if EquipUtil.getEquipCanUse(bagEquipList[j].is_use) then
            	        self.equipList[#self.equipList + 1] = bagEquipList[j]
                    end
    	      end
	       end
	    end
	 end
 
 	if self.pageManager then
 		self.pageManager:SetPageItemsData(self.equipList)
    	--self.pageManager:SetItemsSelectVisible(true)
    	--self.pageManager:ResetItemsSelectState()
 	end
    
end

function EquipExtendsView:onStoreItemClick(itemData, isSelected)
 
 	local commonItem = CommonItemCell.new()
    commonItem:setData(itemData)
    commonItem:setTag(999)
    
    --选择第一个
 	if self.index == 1 then
    	self.equip1:addChild(commonItem)
    	commonItem:setTouchEnabled(false)
    	self.newSten_lv = itemData.stren_lv
    	self.sId = itemData.id
    	self.index = 2
    	self.NameLabel1:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))
    	self.coinLabel:setString(configHelper:getStrengCByEquipId(itemData.stren_lv).change_jade)

        if self.tempItemData ~= nil then

            self:removeExtendsEquip(self.newSten_lv)
            self.tempItemData.stren_lv = self.newSten_lv
            self:setExtendsEquip(self.tempItemData)
        end
    	--self.mask:setClippingRegion(cc.rect(-self.ppp:getContentSize().width/2,-self.ppp:getContentSize().height/2,self.ppp:getContentSize().width,0))
 	elseif self.index == 2 then
 		if self.equip2:getChildByTag(999) then
        	self.equip2:removeChildByTag(999, true)
    	end
 		self:removeExtendsEquip(self.sten_lv)
    	self.equip2DataId = itemData.id
    	self.dId = itemData.id
    	self.equip2:addChild(commonItem)
    	commonItem:setTouchEnabled(false)
    	self.sten_lv = itemData.stren_lv
    	itemData.stren_lv = self.newSten_lv
    	self:setExtendsEquip(itemData)
        self.tempItemData = itemData
	    self.NameLabel2:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))
	    self.NameLabel3:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))
 	end

 	if self.equip3:getChildByTag(999) then
 		self.inheritanceBtn:setButtonEnabled(true)
 	end

 	self:initStrenBag(self.index)
 	commonItem:setPosition(self.equip2:getContentSize().width/2,self.equip2:getContentSize().height/2)
end

function EquipExtendsView:setExtendsEquip(data)
	local commonItem3 = CommonItemCell.new()
	commonItem3:setData(data)
	commonItem3:setTag(999)
	self.equip3:addChild(commonItem3)
	commonItem3:setPosition(self.equip2:getContentSize().width/2,self.equip2:getContentSize().height/2)
end

function EquipExtendsView:removeExtendsEquip(stren_lv)
	if self.equip3:getChildByTag(999) then
    	self.equip3:getChildByTag(999):getData().stren_lv = stren_lv
        self.equip3:removeChildByTag(999, true)
    end
end

function EquipExtendsView:open()
	self._extends_handle = GlobalEventSystem:addEventListener(EquipEvent.EXTENDS_SUCCESS, function()
  
        if self.currentTabIndex == 1 then
            self:strenReset()
        elseif self.currentTabIndex == 2 then
            self:soulReset()
        elseif self.currentTabIndex == 3 then
            self:baptizeReset()
        end
    	
	end)

end

function EquipExtendsView:strenReset()
    self:playStrengEffect()
    for i=1,2 do
        if self:seekNodeByName("equip"..i):getChildByTag(999) then
            self:seekNodeByName("equip"..i):removeChildByTag(999, true)
        end
    end
    self.NameLabel1:setString("")
    self.index = 1
    self:initStrenBag(self.index)
end

--播强化成功特效
function EquipExtendsView:playStrengEffect()
    if self.streng then
        self.streng:getAnimation():play("effect")
        self.streng:setPosition(235,470)
        return
    end
    ArmatureManager:getInstance():loadEffect("qianghua")
    self.streng = ccs.Armature:create("qianghua")
    self.equip3:addChild(self.streng, 100,100)
    self.streng:setPosition(self.equip3:getContentSize().width/2,self.equip3:getContentSize().height/2)
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

function EquipExtendsView:close()
	if self._extends_handle then
		GlobalEventSystem:removeEventListenerByHandle(self._extends_handle)
		self._extends_handle = nil
	end
	--[[
	if self.scheId then
		scheduler.unscheduleGlobal(self.scheId)
		self.scheId = nil
	end
	--]]
end

function EquipExtendsView:destory()
	self:close()
	self:removeExtendsEquip(self.sten_lv)
	EquipExtendsView.super.destory(self)
end

-----------铸魂返还---------------
function EquipExtendsView:initSoul()

    self.currentSoulId = 0

    self.layer[2] = self:seekNodeByName("Soul_return")
    self.layer[2]:setVisible(false)
    self.equip = self:seekNodeByName("equip")
    self.equip_name = self:seekNodeByName("equip_name")
    self.goods = self:seekNodeByName("goods")
    self.goods_name = self:seekNodeByName("goods_name")
    self.Btn_soul_return = self:seekNodeByName("Btn_soul_return")
    --self.helpBtn1 = self:seekNodeByName("helpBtn1")
 
        self.equip:setTouchEnabled(true)
        self.equip:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()
            elseif event.name == "ended" then
                self:soulReset()
            end     
        return true
        end)
 
    self.Btn_soul_return:setTouchEnabled(true)
    self.Btn_soul_return:setButtonEnabled(false)
    self.Btn_soul_return:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.Btn_soul_return:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.Btn_soul_return:setScale(1.0)
            if self.currentSoulId ~= 0  then
                GlobalController.equip:requestSouldBack(self.currentSoulId)
            end
        end     
        return true
    end)
end

function EquipExtendsView:handleSoulData()
    self:initSoulBag()
end

function EquipExtendsView:initSoulBag()
 
  self.soulList = {}
  local bodyEquipList = RoleManager:getInstance().roleInfo.equip
  local bagEquipList = BagManager:getInstance().bagInfo:getEquipList()
 
        for i=1,#bodyEquipList do
            if  bodyEquipList[i].soul > 0 and bodyEquipList[i].id ~= self.currentSoulId then
                self.soulList[#self.soulList + 1] = bodyEquipList[i]
            end 
        end
     
        for j=1,#bagEquipList do
            if bagEquipList[j].soul > 0  and bagEquipList[j].id ~= self.currentSoulId  then
                if EquipUtil.getEquipCanUse(bagEquipList[j].is_use) then
                    self.soulList[#self.soulList + 1] = bagEquipList[j]
                end
            end
        end
 
 
    if self.pageManager then
        self.pageManager:SetPageItemsData(self.soulList)
        --self.pageManager:SetItemsSelectVisible(true)
        --self.pageManager:ResetItemsSelectState()
    end
    
end

function EquipExtendsView:onSoulItemClick(itemData, isSelected)
 
    local commonItem
    if self.equip:getChildByTag(999) then
        commonItem = self.equip:getChildByTag(999)
    else
        commonItem = CommonItemCell.new()
        commonItem:setTag(999)  
        self.equip:addChild(commonItem)
        commonItem:setPosition(self.equip:getContentSize().width/2,self.equip:getContentSize().height/2)   
    end
 
    commonItem:setData(itemData)
    commonItem:setTouchEnabled(false)
    self.currentSoulId = itemData.id

    if itemData.stren_lv > 0 then
        self.equip_name:setString(configHelper:getGoodNameByGoodId(itemData.goods_id).."+"..itemData.stren_lv)
    else
        self.equip_name:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))
    end

    local quality = configHelper:getGoodQualityByGoodId(itemData.goods_id)
    if quality then
        local color
        if quality == 1 then            --白
            color = TextColor.TEXT_W
        elseif quality == 2 then        --绿
            color = TextColor.TEXT_G
        elseif quality == 3 then        --蓝
            color = TextColor.ITEM_B
        elseif quality == 4 then        --紫
            color = TextColor.ITEM_P
        elseif quality == 5 then        --橙
            color = TextColor.TEXT_O
        elseif quality == 6 then        --红
            color = TextColor.TEXT_R
        end 
        if color then
            self.equip_name:setTextColor(color)
        end
    end
    
    --返还的铸魂精华
    local commonItem1 = nil
    local sum = 0
    local soulConfig
 
    for i=itemData.soul,0,-1 do
         soulConfig = configHelper:getSoulConfigByIdAndLv(itemData.goods_id,i)
        if soulConfig ~= nil then
            sum = sum + soulConfig[1][2]
        end
    end
     
    if self.goods:getChildByTag(999) then
        commonItem1 = self.goods:getChildByTag(999)
        commonItem1:setVisible(true)
        self.goods_name:setVisible(true)
    else
        commonItem1 = CommonItemCell.new()
        commonItem1:setTag(999)  
        self.goods:addChild(commonItem1)
        commonItem1:setData({goods_id = 110160})
        commonItem1:setPosition(self.goods:getContentSize().width/2,self.goods:getContentSize().height/2)
        commonItem1:setTouchEnabled(false)
        self.goods_name:setString("铸魂精华")
    end

    commonItem1:setCount(sum)
 
    self.Btn_soul_return:setButtonEnabled(true)
    self:initSoulBag()
     
end

function EquipExtendsView:soulReset()

    if self.equip:getChildByTag(999) then
                    
        self.Btn_soul_return:setButtonEnabled(false)
        self.equip:removeChildByTag(999, true)
        self.equip_name:setString("")
        self.currentSoulId = 0
        self:initSoulBag()
        local item = self.goods:getChildByTag(999)
        if item then
            item:setVisible(false)
            self.goods_name:setVisible(false)
        end

    end
end

------------洗炼转移--------------
 
function EquipExtendsView:initBatize()

    self.baptizeIndex = 1
    self.baptizesId = 0
    self.baptizedId = 0
    self.baptizeLen = 0
    self.pos = 0--部位
    self.quality = 0 --原装备品质

    self.baptizeEquip = {}
    self.layer[3] = self:seekNodeByName("Baptize_move")
    self.layer[3]:setVisible(false)
    self.baptizeEquip[1] = self:seekNodeByName("equip_1")
    self.equip_1_name = self:seekNodeByName("equip_1_name")
    self.equip_1_baptize = self:seekNodeByName("equip_1_baptize")
    self.baptizeEquip[2] = self:seekNodeByName("equip_2")
    self.equip_2_name = self:seekNodeByName("equip_2_name")
    self.equip_2_baptize = self:seekNodeByName("equip_2_baptize")


    self.Btn_baptize_move = self:seekNodeByName("Btn_baptize_move")
    self.coin_number = self:seekNodeByName("coin_number")
    self.baptize_show = self:seekNodeByName("baptize_show")

    for i=1,#self.baptizeEquip do

        self.baptizeEquip[i]:setTouchEnabled(true)
        self.baptizeEquip[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()
            elseif event.name == "ended" then

                local hash = false
                if self.baptizeEquip[i]:getChildByTag(999) then
                    hash = true
                    self.Btn_baptize_move:setButtonEnabled(false)
                    self.baptizeEquip[i]:removeChildByTag(999, true)
                    self["equip_"..i.."_name"]:setString("")
                end
               
                if i == 1 then
                    if hash then
                        self:baptizeReset()
                    end
                    
                elseif i == 2 then
                    if hash then

                        for i=1,#self.rightItemList do
                            self.rightItemList[i]:setVisible(false)
                        end

                        self.baptizeIndex = 2
                        if self.baptizeEquip[1]:getChildByTag(999) == nil then
                            self.baptizeIndex = 1
                        end

                        self.baptizedId = 0
                        self.equip_2_name:setString("")
                        self:initBatizeBag(self.baptizeIndex)

                    end
                end
            
            end     
        return true
        end)
    end
    --------------------
    self.Btn_baptize_move:setTouchEnabled(true)
    self.Btn_baptize_move:setButtonEnabled(false)
    self.Btn_baptize_move:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.Btn_baptize_move:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.Btn_baptize_move:setScale(1.0)
            if self.baptizesId ~= 0 and self.baptizedId ~= 0 then
                GlobalController.equip:requestBaptizeExtends(self.baptizesId, self.baptizedId)
            end
        end     
        return true
    end)
    -------------------

    self.leftItemList = {}
    self.rightItemList = {}
    local item
    for i=1,5 do
        item = EquipBaptizeItem.new():addTo(self.equip_1_baptize)
        self.leftItemList[i] = item
        item:setPositionY(self.equip_1_baptize:getContentSize().height - (i)*(item:getContentSize().height + 3)-1)
        item:setVisible(false)
    end

    for i=1,5 do
        item = EquipBaptizeItem.new():addTo(self.equip_2_baptize)
        self.rightItemList[i] = item
        item:setPositionY(self.equip_2_baptize:getContentSize().height - (i)*(item:getContentSize().height + 3)-1)
        item:setVisible(false)
    end

end

function EquipExtendsView:handleBatizeData()
    self:initBatizeBag(self.baptizeIndex)
end

function EquipExtendsView:initBatizeBag(type)
 
  self.BatizeList = {}
  local bodyEquipList = RoleManager:getInstance().roleInfo.equip
  local bagEquipList = BagManager:getInstance().bagInfo:getEquipList()

    if type == 1 then
        for i=1,#bodyEquipList do 
            if  #bodyEquipList[i].baptize_attr_list > 0 then
                self.BatizeList[#self.BatizeList + 1] = bodyEquipList[i]
            end
        end
     
        for j=1,#bagEquipList do
            if #bagEquipList[j].baptize_attr_list > 0  then
                if EquipUtil.getEquipCanUse(bagEquipList[j].is_use) then
                    self.BatizeList[#self.BatizeList + 1] = bagEquipList[j]
                end
            end
        end

    elseif type == 2 then

        for i=1,#bodyEquipList do
            local quality = configHelper:getGoodQualityByGoodId(bodyEquipList[i].goods_id)
            if self.quality <= quality and configHelper:getGoodSubTypeByGoodId(bodyEquipList[i].goods_id) == self.pos and self.baptizedId ~= bodyEquipList[i].id and self.baptizesId ~= bodyEquipList[i].id then
                self.BatizeList[#self.BatizeList + 1] = bodyEquipList[i]
            end
        end
     
        for j=1,#bagEquipList do
            local quality = configHelper:getGoodQualityByGoodId(bagEquipList[j].goods_id)
            if  self.quality <= quality and configHelper:getGoodSubTypeByGoodId(bagEquipList[j].goods_id) == self.pos and self.baptizedId ~= bagEquipList[j].id and self.baptizesId ~= bagEquipList[j].id then
                if EquipUtil.getEquipCanUse(bagEquipList[j].is_use) then
                    self.BatizeList[#self.BatizeList + 1] = bagEquipList[j]
                end
            end
        end
     end
 
    if self.pageManager then
        self.pageManager:SetPageItemsData(self.BatizeList)
        --self.pageManager:SetItemsSelectVisible(true)
        --self.pageManager:ResetItemsSelectState()
    end
    
end

function EquipExtendsView:onBatizeItemClick(itemData, isSelected)
 
    local commonItem = CommonItemCell.new()
    commonItem:setData(itemData)
    commonItem:setTag(999)

    local quality = configHelper:getGoodQualityByGoodId(itemData.goods_id)
    local color
    if quality then
        
        if quality == 1 then            --白
            color = TextColor.TEXT_W
        elseif quality == 2 then        --绿
            color = TextColor.TEXT_G
        elseif quality == 3 then        --蓝
            color = TextColor.ITEM_B
        elseif quality == 4 then        --紫
            color = TextColor.ITEM_P
        elseif quality == 5 then        --橙
            color = TextColor.TEXT_O
        elseif quality == 6 then        --红
            color = TextColor.TEXT_R
        end 
        
    end
    
    --选择第一个
    if self.baptizeIndex == 1 then

        self.baptizeEquip[self.baptizeIndex]:addChild(commonItem)
        commonItem:setTouchEnabled(false)
         
        self.baptizesId = itemData.id
        self.baptizeIndex = 2
        self.baptizeLen = #itemData.baptize_attr_list
        self.pos = configHelper:getGoodSubTypeByGoodId(itemData.goods_id)
        self.quality = quality

        if itemData.stren_lv > 0 then
            self.equip_1_name:setString(configHelper:getGoodNameByGoodId(itemData.goods_id).."+"..itemData.stren_lv)
        else
            self.equip_1_name:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))
        end
        if color then
            self.equip_1_name:setTextColor(color)
        end

        self:sumFee(itemData.baptize_attr_list,self.leftItemList,1)
        commonItem:setPosition(self.baptizeEquip[self.baptizeIndex]:getContentSize().width/2+4,self.baptizeEquip[self.baptizeIndex]:getContentSize().height/2+6)
        --self.mask:setClippingRegion(cc.rect(-self.ppp:getContentSize().width/2,-self.ppp:getContentSize().height/2,self.ppp:getContentSize().width,0))
    elseif self.baptizeIndex == 2 then

        if self.baptizeEquip[self.baptizeIndex]:getChildByTag(999) then
            self.baptizeEquip[self.baptizeIndex]:removeChildByTag(999, true)
        end
         
        self.baptizedId = itemData.id

        self.baptizeEquip[self.baptizeIndex]:addChild(commonItem)
        commonItem:setTouchEnabled(false)
     
        if itemData.stren_lv > 0 then
            self.equip_2_name:setString(configHelper:getGoodNameByGoodId(itemData.goods_id).."+"..itemData.stren_lv)
        else
            self.equip_2_name:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))
        end
        if color then
            self.equip_2_name:setTextColor(color)
        end

        self.Btn_baptize_move:setButtonEnabled(true)
        self:sumFee(itemData.baptize_attr_list,self.rightItemList,2)
        commonItem:setPosition(self.baptizeEquip[self.baptizeIndex]:getContentSize().width/2,self.baptizeEquip[self.baptizeIndex]:getContentSize().height/2)
    end
 
    self:initBatizeBag(self.baptizeIndex)
    
end

function EquipExtendsView:sumFee(data,list,type)
 
    local info = EquipUtil.showBaptizeAttrFormat(data)
 
    local item
    local color
    local sum = 0

    for i=#list,#info+1,-1 do
        list[i]:setVisible(false)
    end

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

        if type == 1 then
            sum = sum + configHelper:getBaptizeFee(per)
        end
        
        item = list[i]
   
        item:setVisible(true)
        item:setData(info[i],color)
        
    end

    if type == 1 then
        self.coin_number:setString(sum)
    end
end
 
function EquipExtendsView:baptizeReset()
    --self:playStrengEffect()
    for i=1,#self.baptizeEquip do
        if self.baptizeEquip[i]:getChildByTag(999) then
            self.baptizeEquip[i]:removeChildByTag(999, true)
        end
    end
 
    for i=1,#self.leftItemList do
        self.leftItemList[i]:setVisible(false)
    end

    for i=1,#self.rightItemList do
        self.rightItemList[i]:setVisible(false)
    end

    self.Btn_baptize_move:setButtonEnabled(false)
 
    self.equip_1_name:setString("")
    self.equip_2_name:setString("")
    self.coin_number:setString("")
    self.baptizeIndex = 1
    self.pos = 0
    self.quality = 0
    self.baptizedId = 0
    self.baptizesId = 0
    self.baptizeLen = 0
    self:initBatizeBag(self.baptizeIndex)
end

--------------------------------------------

function EquipBaptizeItem:ctor()
    self.ccui = cc.uiloader:load("resui/baptize_show.ExportJson")
     
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    self:init()
end

function EquipBaptizeItem:init()

    self.baptize_name = cc.uiloader:seekNodeByName(self.ccui, "baptize_name")
    self.baptize_number = cc.uiloader:seekNodeByName(self.ccui, "baptize_number")
 
end
 
function EquipBaptizeItem:setData(data,color)

    if data == nil then
        return 
    end
    
    self.data = data
   
    self.baptize_name:setString(data.name..":")
    self.baptize_number:setString(data.min)
    self.baptize_name:setColor(color)
    self.baptize_number:setColor(color)
 
end
 
function EquipBaptizeItem:getData()
    return self.data
end
 
function EquipBaptizeItem:destory()
end

return EquipExtendsView