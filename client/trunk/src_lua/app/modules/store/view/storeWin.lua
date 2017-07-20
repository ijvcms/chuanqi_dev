--
-- Author: casen
-- Date: 2015-10-01 
-- 商城窗口

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local StoreWin    = class("StoreWin", BaseView)

local batchBuyWin  = import(".batchBuyWin")

local StoreItem = class("StoreItem", function()
    return display.newNode()
end)

local RareItem = class("RareItem", function()
    return display.newNode()
end)

local VipShopItem = class("VipShopItem", function()
    return display.newNode()
end)



function StoreWin:ctor(winTag,data,winconfig)
    StoreWin.super.ctor(self,winTag,data,winconfig)
    self.effectList = {}
    local root = self:getRoot()
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    local win  = cc.uiloader:seekNodeByName(root,"win")

    --金锭label
    self.coin2Label = cc.uiloader:seekNodeByName(win,"coinValue2")
    self.coin2Label:setString("")
    --银票label
    self.coin3Label = cc.uiloader:seekNodeByName(win,"coinValue3")
    self.coin3Label:setString("")


    self.tagBtns = {}

    --元宝标签按钮
    self.tagBtns[1] = cc.uiloader:seekNodeByName(win,"btn_jade")
    self.tagBtns[1]:setTouchEnabled(true)
    self.tagBtns[1]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(1)
        end     
        return true
    end)

    --绑元标签按钮
    self.tagBtns[2] = cc.uiloader:seekNodeByName(win,"btn_coupon")
    self.tagBtns[2]:setTouchEnabled(true)
    self.tagBtns[2]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(2)
        end     
        return true
    end)
    --VIP限购标签按钮
    self.tagBtns[3] = cc.uiloader:seekNodeByName(win,"btn_VIPgoods")
    self.tagBtns[3]:setTouchEnabled(true)
    self.tagBtns[3]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(3)
        end     
        return true
    end)
    --稀有标签按钮
    self.tagBtns[4] = cc.uiloader:seekNodeByName(win,"btn_rare")
    self.tagBtns[4]:setTouchEnabled(true)
    self.tagBtns[4]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(4)
        end     
        return true
    end)

    self.rechargeBtn = cc.uiloader:seekNodeByName(win,"rechargeBtn")
    self.rechargeBtn:setTouchEnabled(true)
    self.rechargeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.rechargeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.rechargeBtn:setScale(1.0)
            GlobalWinManger:openWin(WinName.RECHARGEWIN) 
        end     
        return true
    end)

    --VIP特权
    self.vipBtn = cc.uiloader:seekNodeByName(win,"vipBtn")
    self.vipBtn:setTouchEnabled(true)
    self.vipBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.vipBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.vipBtn:setScale(1.0)
            GlobalWinManger:openWin(WinName.VIPWIN) 
        end     
        return true
    end)
    --
    self.leftLayer = cc.uiloader:seekNodeByName(win,"leftLayer")
    self.rightLayer = cc.uiloader:seekNodeByName(win,"rightLayer")

    self.rareLayer = cc.uiloader:seekNodeByName(win, "rareLayer")
    self.itemLayer = cc.uiloader:seekNodeByName(self.rareLayer, "itemLayer")
    self.itemName = cc.uiloader:seekNodeByName(self.rareLayer, "itemName")

    self.vipLayer = cc.uiloader:seekNodeByName(win, "vipLayer")
    self.vipText = cc.uiloader:seekNodeByName(self.vipLayer, "vipText")
    for i = 1, 4 do
        local strName = "vipItemBg"..i
        self[strName] = cc.uiloader:seekNodeByName(self.vipLayer, "itemLayer"..i)
        local bg = cc.uiloader:seekNodeByName(self[strName], "item"..i)
        local item = CommonItemCell.new()
        local size = bg:getContentSize()
        item:setPosition(size.width / 2, size.height / 2)
        bg:addChild(item)
        self["vipItem"..i] = item
        self["vipItemName"..i] = cc.uiloader:seekNodeByName(self[strName], "name"..i)
    end


    --{x = -36, y = 150, height = 375, width = 540}
    self.scrollView = {}
    for i=1, #self.tagBtns do
        local layer = cc.Node:create()
        self.scrollView[i] = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.rightLayer:getContentSize().width,self.rightLayer:getContentSize().height)})
        :addScrollNode(layer)   
        :addTo(self.rightLayer)
        :setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)  
        --:onScroll(handler(self, self.onTouchHandler))
        self.scrollView[i]:setPosition(0,0)
        self.scrollView[i]:setVisible(false)
        self.scrollView[i]:setTouchSwallowEnabled(false)
        self.scrollView[i].loaded = false
     end

    --展示翅膀用
    self.imv = InnerModelView.new()
    self.imv:setPosition(190, 325-65)
    self.leftLayer:addChild(self.imv,100)
 
    --
    
    display.addImageAsync("common/belle.png", function()
        if self.isDestory then return end
        self.belle = display.newSprite("common/belle.png")
        --self.belle:setScale(0.74)
        self.belle:setAnchorPoint(0.5,0.5)
        self.belle:setPosition(175, 220)
        self.belle:addTo(self.leftLayer, 10, 20) 
    end)
    

    --
    self:refreshCoin()

    --注册监听事件
    self:registerEvent()

    --打开时选中热销标签
    self:onTagBtnClick(1)
end

 
--
-- 当一个子项被点击之后将会调用此方法。
--
function StoreWin:onClickItem(item)
   -- if self._onClickHandler then
        self:onStoreItemClick(item:getData())
--    end

end

--VIP点击
function StoreWin:onVipClickItem(item, itemData)
    if  self.selectVipItem == item then
        return
    end
    if  self.selectVipItem then
        self.selectVipItem:setSelect(false)
    end
    
    if item then
        item:setSelect(true)
        self.vipText:setString(item:getName())
    end
    local bagType = configHelper:getGoodsByGoodId(item:getData().goods_id).vip_display
    local goodsData
    if bagType[1] == 0 then
        goodsData = configHelper:getBagData(bagType[2])
    elseif bagType[1] == 1 then
        local index = RoleManager:getInstance().roleInfo.career / 1000
        goodsData = configHelper:getBagData(bagType[2][index])
    else
        return
    end
    local idx = 1
    while idx <= #goodsData do
        local item = self["vipItem"..idx]
        item:setData({goods_id = goodsData[idx][1]})
        item:setLock(goodsData[idx][2] == 1)
        item:setCount(goodsData[idx][3])
        self["vipItemBg"..idx]:setVisible(true)
        self["vipItemName"..idx]:setString(configHelper:getGoodNameByGoodId(goodsData[idx][1]))
        idx = idx + 1
    end
    while idx <= 4 do
        self["vipItemBg"..idx]:setVisible(false)
        idx = idx + 1
    end
    self.selectVipItem = item
    if self.belle then
        self.belle:setVisible(false)
    end
    
    self.rareLayer:setVisible(false)
    self.vipLayer:setVisible(true)

end

--稀有点击,切换左边的图
function StoreWin:onRareClickItem(item, itemData)
    if  self.selectRareItem == item then
        return
    end
    if  self.selectRareItem then
        self.selectRareItem:setSelect(false)
    end
    
    if item then
        item:setSelect(true)
        self.itemName:setString(item:getName())
    end
    self.selectRareItem = item
    self.belle:setVisible(false)
    self.vipLayer:setVisible(false)
    self.rareLayer:setVisible(true)

    if itemData.icon_name ~= "" then
        if not self.itemPic then
            local size = self.itemLayer:getContentSize()
            self.itemPic = display.newSprite()
            self.itemPic:setPosition(size.width / 2, size.height / 2)
            self.itemLayer:addChild(self.itemPic, 80)
        end
        self.itemPic:setVisible(true)
        self.itemPic:setSpriteFrame(itemData.icon_name)
    elseif self.itemPic then
        self.itemPic:setVisible(false)
    end
    if self.animation then
       self.animation:removeSelf()
       self.animation = nil
    end
    if itemData.effect ~= ""  then
        self.animationId = itemData.effect
        if itemData.icon_name ~= "" then
            ArmatureManager:getInstance():loadEffect(itemData.effect, handler(self, self.onLoadEffectCompleted))
        else
            ArmatureManager:getInstance():loadModel(itemData.effect, handler(self, self.onLoadModelCompleted))
        end
        
    end
    
end

function StoreWin:onLoadModelCompleted(armatureData, mid)
    if self.isDestory then return end
    if self.animationId == nil then
        return 
    end
    if self.animation then
       self.animation:removeSelf()
       self.animation = nil
    end
    local itemData = self.selectRareItem:getData()
    if itemData.effect ~= tonumber(mid, 10) then
        return
    end
    self.animation = ccs.Armature:create(mid)
    local pos = string.split(itemData.effect_location, ",") 
    self.animation:setPosition(pos[1], pos[2])
    self.animation:setScale(1.4)
    self.itemLayer:addChild(self.animation)
    self.animation:getAnimation():play("stand_3")
end

function StoreWin:onLoadEffectCompleted(effect)
    if self.isDestory then return end
    self.effectList[effect] = effect
    if self.animationId == nil then
        return 
    end
    if self.animation then
       self.animation:removeSelf()
       self.animation = nil
    end
    local itemData = self.selectRareItem:getData()
    if itemData.effect ~= effect then
        return
    end
    self.animation = ccs.Armature:create(effect)
    local pos = string.split(itemData.effect_location, ",") 
    self.animation:setPosition(pos[1], pos[2])
    self.itemLayer:addChild(self.animation)
    self.animation:getAnimation():play("effect")
end


--刷新金币
function StoreWin:refreshCoin()
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo

    local wealthInfo = roleManager.wealth

    --金币值
    -- self:setCoinValue(1, wealthInfo.coin or 0)

    --金锭(元宝值)
    self:setCoinValue(2, wealthInfo.jade or 0)

    --礼券
    self:setCoinValue(3, wealthInfo.gift or 0)
end

--金币点击回调
--coinType:金币类型,1:金币 2:金锭 3:银票
function StoreWin:onCoinClick(coinType)
    -- body
end

--设置金币数
--coinType:金币类型,1:金币 2:金锭 3:银票
--value:金币数
function StoreWin:setCoinValue(coinType,value)
    local coinLabel
    if coinType == 1 then               --金币
        coinLabel = self.coin1Label
    elseif coinType == 2 then           --金锭
        coinLabel = self.coin2Label
    elseif coinType == 3 then           --银票
        coinLabel = self.coin3Label
    end

    if coinLabel then
        coinLabel:setString(value)
    end
end

--标签按钮点击回调
--tagBtnIndex:标签按钮类型,1:元宝 2:绑元 3:VIP限购 4:稀有
function StoreWin:onTagBtnClick(tagBtnIndex)
    if not self.tagBtns[tagBtnIndex] then return end

    if self.curTagBtnIndex and self.curTagBtnIndex == tagBtnIndex then
        return
    else
        if self.curTagBtnIndex then
            local sp = cc.uiloader:seekNodeByName(self.tagBtns[self.curTagBtnIndex],"selected")
            sp:setVisible(false)
            self.scrollView[self.curTagBtnIndex]:setVisible(false)
        end
        if self.curTagBtnIndex == 4 or self.curTagBtnIndex == 3 then --从稀有切换回来--从VIP限购切换回来
            if self.belle then self.belle:setVisible(true) end
            
            self.rareLayer:setVisible(false)
            self.vipLayer:setVisible(false)
        end
        self.curTagBtnIndex = tagBtnIndex
        local sp = cc.uiloader:seekNodeByName(self.tagBtns[self.curTagBtnIndex],"selected")
        sp:setVisible(true)
        self.scrollView[self.curTagBtnIndex]:setVisible(true)
    end
    self:loadStoreGoods(tagBtnIndex)
end

function StoreWin:onStoreItemClick(itemData)
    local goodType = configHelper:getGoodTypeByGoodId(itemData.goods_id)
    if goodType and goodType == 2 then
        local etName,et = configHelper:getEquipTypeByEquipId(itemData.goods_id)
        if et then
            if et==13 then              --翅膀
                self.imv:setVisible(true)
                self.imv:setWingId(configHelper:getGoodResId(itemData.goods_id))
                if self.pPetView then
                    self.pPetView:stopAllActions()
                    self.pPetView:getAnimation():stop()      
                    if self.pPetView:getParent() then
                        self.pPetView:getParent():removeChild(self.pPetView)
                    end 
                    self.pPetView = nil
                    ArmatureManager:getInstance():unloadPetShow(self.curPetId)
                end
                if self.belle then
                    self.belle:setVisible(false)
                end
            elseif et==14 then          --宠物
                self.imv:setVisible(false)
                if self.pPetView then
                    self.pPetView:stopAllActions()
                    self.pPetView:getAnimation():stop()      
                    if self.pPetView:getParent() then
                        self.pPetView:getParent():removeChild(self.pPetView)
                    end 
                    self.pPetView = nil
                    ArmatureManager:getInstance():unloadPetShow(self.curPetId)
                end
                if self.belle then
                    self.belle:setVisible(false)
                end
        
                local fileUtil = cc.FileUtils:getInstance()
                if fileUtil:isFileExist(ResUtil.getPetShow(configHelper:getGoodResId(itemData.goods_id))) then
                    ArmatureManager:getInstance():loadPetShow(configHelper:getGoodResId(itemData.goods_id))
                    self.pPetView = ccs.Armature:create(configHelper:getGoodResId(itemData.goods_id).."pet")
                    self.curPetId = configHelper:getGoodResId(itemData.goods_id)
                    self.leftLayer:addChild(self.pPetView)
                    self.pPetView:setPosition(195,610)
                    self.pPetView:stopAllActions()
                    self.pPetView:getAnimation():play("effect")
                else
                    if self.belle then
                        self.belle:setVisible(true)
                    end
                end
            end
        end
    else
        self.imv:setVisible(false)
        if self.pPetView then
            self.pPetView:stopAllActions()
            self.pPetView:getAnimation():stop()      
            if self.pPetView:getParent() then
                self.pPetView:getParent():removeChild(self.pPetView)
            end 
            self.pPetView = nil
            ArmatureManager:getInstance():unloadPetShow(self.curPetId)
        end
        if self.belle then self.belle:setVisible(true) end
        
    end

    local bw = batchBuyWin.new({
        title="购买道具",

        sureText="购买",

        clickFunc=function(curCount,data)
            --发送购买商城物品协议
            local sendData = {
                id = data.key,
                num = curCount
            }
            GameNet:sendMsgToSocket(16001, sendData)
        end,

        countFunc=function(curCount,label)
            local coinString = "金币"
            if itemData.curr_type == 1 then
                coinString = "金币"
            elseif itemData.curr_type == 2 then
                coinString = "元宝"
            elseif itemData.curr_type == 3 then
                coinString = "绑定元宝"
            end
            label:setString("总共"..curCount*itemData.price..coinString)
        end,

        data = itemData
    })
    if itemData.curr_type == 1 then
        bw:setMax(math.floor(RoleManager:getInstance().wealth.coin / itemData.price))
    elseif itemData.curr_type == 2 then
        bw:setMax(math.floor(RoleManager:getInstance().wealth.jade / itemData.price))
    elseif itemData.curr_type == 3 then
        bw:setMax(math.floor(RoleManager:getInstance().wealth.gift / itemData.price))
    end
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,bw)
end

function StoreWin:loadStoreGoods(storeType)

    if self.scrollView[self.curTagBtnIndex] and not self.scrollView[self.curTagBtnIndex].loaded then
        local sellItemList = configHelper:getStoreItemsByType(storeType)
        self:createTagPage(self.scrollView[self.curTagBtnIndex]:getScrollNode(), sellItemList)
        self.scrollView[self.curTagBtnIndex].loaded = true
    end
    if self.curTagBtnIndex == 3 then
        local sellItemList = configHelper:getStoreItemsByType(storeType)
        if  self.selectVipItem then
            self.selectVipItem:setSelect(false)
            self.selectVipItem = nil
        end
        self:onVipClickItem(self.initSelectVipItem, sellItemList[1])
    end
    if self.curTagBtnIndex == 4 then
        local sellItemList = configHelper:getStoreItemsByType(storeType)
        if  self.selectRareItem then
            self.selectRareItem:setSelect(false)
            self.selectRareItem = nil
        end
        self:onRareClickItem(self.initSelectRareItem, sellItemList[1])
    end
end

function StoreWin:createTagPage(page,data)
    if self.curTagBtnIndex == 3 then
        self:createVIPTagPage(page, data)
        return
    end
    if self.curTagBtnIndex == 4 then
        self:createRareTagPage(page, data)
        return
    end

    if page~= nil and data ~= nil then
        local w = 0
        local h = 0
        for i=1,#data do
            local item = StoreItem.new()
            item:setData(data[i])
            item:setItemClickFunc(handler(self, self.onClickItem))
            page:addChild(item)

            w = item:getContentSize().width + 6
            h = item:getContentSize().height + 5

            item:setPosition(((i-1)%2)*w,h*math.ceil(#data/2) - math.floor((i-1)/2)*h)
            
        end
        page:setContentSize(cc.size(w*2, h*math.ceil(#data/2)))
        page:setPosition(0, self.rightLayer:getContentSize().height - page:getContentSize().height)
    end

end
--创建VIP限购的Tag
function StoreWin:createVIPTagPage(page, data)
    if page~= nil and data ~= nil then
        local w = 0
        local h = 0
        for i=1,#data do
            local item = VipShopItem.new()
            item:setData(data[i])
            item:setItemClickFunc(handler(self, self.onVipClickItem))
            page:addChild(item)
            w = item:getContentSize().width
            h = item:getContentSize().height + 5
            item:setPosition(2, h * #data - i * h)
            if i == 1 then
                self.initSelectVipItem = item
            end
        end
        page:setContentSize(cc.size(w, h * #data))
        page:setPosition(0, self.rightLayer:getContentSize().height - page:getContentSize().height)
    end
end


--创建稀有的Tag
function StoreWin:createRareTagPage(page, data)
    if page~= nil and data ~= nil then
        local w = 0
        local h = 0
        for i=1,#data do
            local item = RareItem.new()
            item:setData(data[i])
            item:setItemClickFunc(handler(self, self.onRareClickItem))
            page:addChild(item)
            w = item:getContentSize().width
            h = item:getContentSize().height + 5
            item:setPosition(2, h * #data - i * h)
            if i == 1 then
                self.initSelectRareItem = item
            end
        end
        page:setContentSize(cc.size(w, h * #data))
        page:setPosition(0, self.rightLayer:getContentSize().height - page:getContentSize().height)
    end
end



--注册监听的事件
function StoreWin:registerEvent()
    self.registerEventId = {}

    local function onWealthChange()
        self:refreshCoin()
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,onWealthChange)
end

--解除监听的事件
function StoreWin:unregisterEvent()
    if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

--关闭按钮回调
function StoreWin:onCloseClick()
    GlobalWinManger:closeWin(self.winTag)
end

local function _clear(self)
    self.animationId = nil
    --解除监听事件
    self:unregisterEvent()
    
    cc.Director:getInstance():getTextureCache():removeTextureForKey("common/belle.png")
    for k,v in pairs(self.effectList or {}) do
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(ResUtil.getEffect(v))
    end
    self.effectList = {}
end

function StoreWin:close()
    _clear(self)
    if self.belle then self.belle:removeSelf() end
end

function StoreWin:destory()
    _clear(self)
    self.super.destory(self)
end

-- ============================================================================================ PageManager Imp
function StoreItem:ctor()
    self:initialization()
end

function StoreItem:initialization()
    self.onClickFunc = nil
    self:initComponents()
end

function StoreItem:initComponents()
    local sp = display.newScale9Sprite("#com_listBg1.png", 0, 0, cc.size(246, 110),cc.rect(30, 30,1, 1))
    --display.newSprite("#com_listBg1.png")
    sp:setAnchorPoint(0,0)
    self:setAnchorPoint(0,1)
    self:setContentSize(cc.size(sp:getContentSize().width, sp:getContentSize().height))

    sp:setTouchEnabled(true)  
    sp:setTouchSwallowEnabled(false)
    sp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
        if event.name == "began" then
            self.start = true
            self.startY = event.y
            self.moving = false
        elseif event.name == "moved" then
            self.moving = true
        elseif event.name == "ended" then
            if self.start and math.abs(event.y - self.startY) < 10 then
                if self.onClickFunc then
                    self.onClickFunc(self)
                end
            end
        end     
        return true
 
    end)
    
    --图标
    local commonItem = CommonItemCell.new()
    commonItem:setPosition(49,57)
    commonItem:setScale(0.8)
 
    --名字
    local nameLabel = display.newTTFLabel({}):addTo(sp,15)
    nameLabel:setColor(TextColor.TITLE)
    nameLabel:setAnchorPoint(0,0.5)
    nameLabel:setPosition(98,78)

    display.setLabelFilter(nameLabel)
    --"售价:"
    local sjLabel = display.newTTFLabel({}):addTo(sp,15)
    sjLabel:setColor(TextColor.TEXT_W)
    sjLabel:setString("售价:")
    sjLabel:setAnchorPoint(0,0.5)
    sjLabel:setPosition(98,36)
    display.setLabelFilter(sjLabel)
    --价格
    local jgLabel = display.newTTFLabel({}):addTo(sp,15)
    jgLabel:setColor(TextColor.TEXT_Y)
    jgLabel:setAnchorPoint(0,0.5)
    jgLabel:setPosition(sjLabel:getPositionX()+sjLabel:getContentSize().width,36)
    display.setLabelFilter(jgLabel)
    --代表是何种金币的图标
    local coinIcon = display.newSprite():addTo(sp,15)
    coinIcon:setAnchorPoint(0,0.5)

    self._goodsItem  = commonItem
    self._goodsName  = nameLabel
    self._goodsPrice = jgLabel
    self._coinIcon   = coinIcon
    
    self:addChild(sp)
    self:addChild(commonItem)
end

function StoreItem:clear()
    self._goodsItem:clear()
end

function StoreItem:setData(data)
    self._data = data
    self:invalidateData()
end

function StoreItem:getData()
    return self._data
end

function StoreItem:setItemClickFunc(func)
    self.onClickFunc = func
end

function StoreItem:invalidateData()
    local itemData = self._data
    if not itemData then return end

    self._goodsItem:setData(itemData)
    local goods = configHelper:getGoodsByGoodId(itemData.goods_id)
    self._goodsName:setString(goods.name)

    --根据品质改变名字颜色
    local quality = goods.quality
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
            self._goodsName:setColor(color)
        end
    end

    self._goodsPrice:setString(itemData.price)

    self._coinIcon:setSpriteFrame("com_coin_"..itemData.curr_type..".png")
    self._coinIcon:setPosition(self._goodsPrice:getPositionX()+self._goodsPrice:getContentSize().width + 2, 36)
end

-- ==================================================================================== VIP限购

function VipShopItem:ctor()
    self:initialization()
end

function VipShopItem:initialization()
    self.onClickFunc = nil
    self:initComponents()
end

function VipShopItem:initComponents()
    self.root = cc.uiloader:load("resui/storeVIPItem.ExportJson")
    self.root:setTouchEnabled(true)  
    self.root:setTouchSwallowEnabled(false)
    self.root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
        if event.name == "began" then
            self.touchBeganX = event.x
            self.touchBeganY = event.y
        elseif event.name == "moved" then
            self.moved = math.abs(event.x - self.touchBeganX) > 6 or math.abs(event.y - self.touchBeganY) > 6
        elseif event.name == "ended" then
            if not self.moved and self.root:getCascadeBoundingBox():containsPoint(cc.p(self.touchBeganX, self.touchBeganY)) then
                SoundManager:playClickSound()
                if self.onClickFunc then
                    self.onClickFunc(self, self._data)
                end
            end
            self.moved = false
        end     
        return true
    end)

    self.nameLabel = cc.uiloader:seekNodeByName(self.root, "nameLabel")
    self.vipLabel = cc.uiloader:seekNodeByName(self.root, "vipLabel")
    self.oldPriceLabel = cc.uiloader:seekNodeByName(self.root, "priceLabel")
    self.nowPriceLabel = cc.uiloader:seekNodeByName(self.root, "priceLabel2")
    
    self.buyBtn = cc.uiloader:seekNodeByName(self.root, "buyBtn")
    self.buyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
        if event.name == "began" then
            self.buyBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.buyBtn:setScale(1.0)
            --发送购买商城物品协议
            local sendData = {
                id = self._data.key,
                num = 1
            }
            GameNet:sendMsgToSocket(16001, sendData)
        end     
        return true
    end)
    self.itemBg = cc.uiloader:seekNodeByName(self.root, "itemBg")
    --图标
    self.item = CommonItemCell.new()
    local size = self.itemBg:getContentSize()
    self.item:setPosition(size.width / 2, size.height / 2)
    self.itemBg:addChild(self.item) 

    self.bg = cc.uiloader:seekNodeByName(self.root, "bg")
    self.selectBg = cc.uiloader:seekNodeByName(self.root, "selectBg")
    self.selectBg:setVisible(false)
    self:addChild(self.root)
    self:setContentSize(self.root:getContentSize())
end

function VipShopItem:setData(data)
    self._data = data
    self:invalidateData()
end

function VipShopItem:getName()
    return self.nameLabel:getString()
end

function VipShopItem:setSelect(yesOrNo)
    if yesOrNo then
        self.selectBg:setVisible(true)
    else
        self.selectBg:setVisible(false)
    end
end

function VipShopItem:getData()
    return self._data
end

function VipShopItem:setItemClickFunc(func)
    self.onClickFunc = func
end

function VipShopItem:invalidateData()
    local itemData = self._data
    if not itemData then return end
    local goods_id = itemData.goods_id
    local goods = configHelper:getGoodsByGoodId(itemData.goods_id)
    self.nameLabel:setString(goods.name)
    --根据品质改变名字颜色
    local quality = goods.quality
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
            self.nameLabel:setColor(color)
        end
    end
    self.item:setData(itemData)
    self.vipLabel:setString("VIP"..itemData.limit_vip)
    self.oldPriceLabel:setString(itemData.price_old)
    self.nowPriceLabel:setString(itemData.price)
end

-- ==================================================================================== 稀有

function RareItem:ctor()
    self:initialization()
end

function RareItem:initialization()
    self.onClickFunc = nil
    self:initComponents()
end

function RareItem:initComponents()
    self.root = cc.uiloader:load("resui/storeItem.ExportJson")
    self.root:setTouchEnabled(true)  
    self.root:setTouchSwallowEnabled(false)
    self.root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
        if event.name == "began" then
            self.touchBeganX = event.x
            self.touchBeganY = event.y
        elseif event.name == "moved" then
            self.moved = math.abs(event.x - self.touchBeganX) > 6 or math.abs(event.y - self.touchBeganY) > 6
        elseif event.name == "ended" then
            if not self.moved and self.root:getCascadeBoundingBox():containsPoint(cc.p(self.touchBeganX, self.touchBeganY)) then
                SoundManager:playClickSound()
                if self.onClickFunc then
                    self.onClickFunc(self, self._data)
                end
            end
            self.moved = false
        end     
        return true
    end)

    self.nameLabel = cc.uiloader:seekNodeByName(self.root, "nameLabel")
    self.desLabel = cc.uiloader:seekNodeByName(self.root, "desLabel")
    self.label1 = cc.uiloader:seekNodeByName(self.root, "label1")
    
    self.layer1 = cc.uiloader:seekNodeByName(self.root, "layer1")
    self.priceLabel = cc.uiloader:seekNodeByName(self.layer1, "priceLabel")
    
    self.layer2 = cc.uiloader:seekNodeByName(self.root, "layer2")
    self.vipLabel = cc.uiloader:seekNodeByName(self.layer2, "vipLabel")
   
    
    self.buyBtn = cc.uiloader:seekNodeByName(self.root, "buyBtn")
    self.buyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
        if event.name == "began" then
            self.buyBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.buyBtn:setScale(1.0)
            if self._data.price == 0 then
                if self._data.skip and self._data.skip ~= "" then
                    GlobalEventSystem:dispatchEvent(DailyTaskEvent.TASK_JUMP, {win = self._data.skip})
                end
                return true
            end
            --发送购买商城物品协议
            local sendData = {
                id = self._data.key,
                num = 1
            }
            GameNet:sendMsgToSocket(16001, sendData)
        end     
        return true
    end)
    self.itemBg = cc.uiloader:seekNodeByName(self.root, "itemBg")
    --图标
    self.item = CommonItemCell.new()
    local size = self.itemBg:getContentSize()
    self.item:setPosition(size.width / 2, size.height / 2)
    self.itemBg:addChild(self.item) 

    self.bg = cc.uiloader:seekNodeByName(self.root, "bg")
    self.selectBg = cc.uiloader:seekNodeByName(self.root, "selectBg")
    self.selectBg:setVisible(false)
    self:addChild(self.root)
    self:setContentSize(self.root:getContentSize())
end

function RareItem:setData(data)
    self._data = data
    self:invalidateData()
end

function RareItem:getName()
    return self.nameLabel:getString()
end

function RareItem:setSelect(yesOrNo)
    if yesOrNo then
        self.selectBg:setVisible(true)
    else
        self.selectBg:setVisible(false)
    end
end

function RareItem:getData()
    return self._data
end

function RareItem:setItemClickFunc(func)
    self.onClickFunc = func
end

function RareItem:invalidateData()
    local itemData = self._data
    if not itemData then return end
    local goods_id = itemData.goods_id
    local goods = configHelper:getGoodsByGoodId(itemData.goods_id)
    self.nameLabel:setString(goods.name)
    --根据品质改变名字颜色
    local quality = goods.quality
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
            self.nameLabel:setColor(color)
        end
    end
    self.desLabel:setString(goods.shop_tips)
    self.item:setData(itemData)
    if itemData.price == 0 then
        self.layer2:setVisible(true)
        self.layer1:setVisible(false)
        self.vipLabel:setString(itemData.num)
        self.buyBtn:setButtonLabelString("前往")
    else
        self.layer1:setVisible(true)
        self.layer2:setVisible(false)
        self.priceLabel:setString(itemData.price)
        self.buyBtn:setButtonLabelString("购买")
    end
end

return StoreWin

