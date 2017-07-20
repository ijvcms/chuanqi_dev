--
-- Author: casen
-- Date: 2015-09-08 
-- 背包窗口
import(".TipsSell")
import(".TipsEquip")
import(".TipsProp")
import(".BatchSell")

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

-- local BagView    = import(".BagView")
import("app.utils.EquipUtil")
local PageManager = import(".PageManager")

local bagWin      = class("bagWin", BaseView)


--构造
function bagWin:ctor(winTag,data,winconfig)
    bagWin.super.ctor(self,winTag,data,winconfig)
    self:creatPillar()
    self.endTime = 3
    local root = self:getRoot()
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    local win  = cc.uiloader:seekNodeByName(root,"win")
    self.win = win
    
    --金币
    self.coin1 = cc.uiloader:seekNodeByName(win,"coin1")
    self.coin1:setTouchEnabled(true)
    self.coin1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.coin1:setScale(1.1)
        elseif event.name == "ended" then
            self.coin1:setScale(1)
            self:onCoinClick(1)
        end     
        return true
    end)
    --金锭
    self.coin2 = cc.uiloader:seekNodeByName(win,"coin2")
    self.coin2:setTouchEnabled(true)
    self.coin2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.coin2:setScale(1.1)
        elseif event.name == "ended" then
            self.coin2:setScale(1)
            --self:onCoinClick(2)
            GlobalWinManger:openWin(WinName.RECHARGEWIN) 
        end     
        return true
    end)
    --银票
    self.coin3 = cc.uiloader:seekNodeByName(win,"coin3")
    self.coin3:setTouchEnabled(true)
    self.coin3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.coin3:setScale(1.1)
        elseif event.name == "ended" then
            self.coin3:setScale(1)
            self:onCoinClick(3)
        end     
        return true
    end)

    --金币label
    self.coin1Label = cc.uiloader:seekNodeByName(self.coin1,"value")
    self.coin1Label:setString("")
    --金锭label
    self.coin2Label = cc.uiloader:seekNodeByName(self.coin2,"value")
    self.coin2Label:setString("")
    --银票label
    self.coin3Label = cc.uiloader:seekNodeByName(self.coin3,"value")
    self.coin3Label:setString("")

    --刷新金币
    self:refreshCoin()

    self.helpBtn = cc.uiloader:seekNodeByName(win,"helpBtn")
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
                  tipTxt = configHelper:getRuleByKey(10),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)

    self.btn_clearUp = cc.uiloader:seekNodeByName(win,"btn_clearUp")
    self.btn_clearUp:setTouchEnabled(true)
    self.btn_clearUp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_clearUp:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_clearUp:setScale(1.0)

            function onTimerHandler()
                self.endTime = self.endTime - 1
                if self.endTime <= 0 then
                    if self._handle then
                        scheduler.unscheduleGlobal(self._handle)
                        self._handle = nil
                    end
                    
                    self.refreashTime = true
                end
            end
      
            if self.refreashTime ~= nil and self.refreashTime == false then
                --GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
            else
                self:refreshBagData(self.curBagType,true)
                self.refreashTime = false
                self.endTime = 3
                if self._handle == nil then
                    self._handle = scheduler.scheduleGlobal(handler(self, onTimerHandler), 1)
                    onTimerHandler()
                end
                
            end
            
        end     
        return true
    end)


    self.tagBtns = {}
    --全部标签按钮
    self.tagBtns[1] = cc.uiloader:seekNodeByName(win,"btn_total")
    self.tagBtns[1]:setTouchEnabled(true)
    self.tagBtns[1]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(1)
        end     
        return true
    end)
    --装备标签按钮
    self.tagBtns[2] = cc.uiloader:seekNodeByName(win,"btn_equip")
    self.tagBtns[2]:setTouchEnabled(true)
    self.tagBtns[2]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(2)
        end     
        return true
    end)
    --道具标签按钮
    self.tagBtns[3] = cc.uiloader:seekNodeByName(win,"btn_prop")
    self.tagBtns[3]:setTouchEnabled(true)
    self.tagBtns[3]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(3)
        end     
        return true
    end)

    --{右边
    local rightLayer = cc.uiloader:seekNodeByName(win,"rightLayer")

    self.tipsLayer = cc.uiloader:seekNodeByName(rightLayer,"bg")

    --扩展按钮
    self.btn_extend = cc.uiloader:seekNodeByName(rightLayer,"btn_extend")
    self.btn_extend:setTouchEnabled(true)
    self.btn_extend:onButtonPressed(function ()
        SoundManager:playClickSound()
    end)
    self.btn_extend:onButtonClicked(function ()
        self:onExtendClick()
    end)

    --批量出售按钮
    self.btn_batchSell = cc.uiloader:seekNodeByName(win,"btn_batchSell")
    self.btn_batchSell:setTouchEnabled(true)
    self.btn_batchSell:onButtonPressed(function ()
        SoundManager:playClickSound()
    end)
    self.btn_batchSell:onButtonClicked(function ()
       
        self:onBatchSellClick()
    end)

    --出售按钮
    self.btn_sell = cc.uiloader:seekNodeByName(win,"btn_sell2")
    self.btn_sell:setTouchEnabled(true)
    self.btn_sell:onButtonPressed(function ()
        SoundManager:playClickSound()
    end)
    self.btn_sell:onButtonClicked(function ()
        self:onSellClick()
    end)

    self.leftLay = cc.uiloader:seekNodeByName(win,"leftLay")
    ------------------------------------------------------------------------------------
    local pageManager = PageManager.new(self.leftLay, 6, 28,{colum = 4,rows = 5,pageWidth = 331,pageHeight = 400,pageOfNum = 5,pageCapacity = 20}) --343 431
    pageManager:SetOnLockClickHandler(handler(self, self.onExtendClick))
    pageManager:SetOnItemsSelectedHandler(function(event)
        local data       = event.data
        local isSelected = event.isSelected
        self:onStoreItemClick(data, isSelected)
    end)
    self.pageManager = pageManager
    ------------------------------------------------------------------------------------

    self:onTagBtnClick(1)
end

--刷新金币
function bagWin:refreshCoin()
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo

    local wealthInfo = roleManager.wealth

	--金币值
    self:setCoinValue(1, wealthInfo.coin or 0)

    --金锭(元宝值)
    self:setCoinValue(2, wealthInfo.jade or 0)

    --礼券
    self:setCoinValue(3, wealthInfo.gift or 0)
end

--金币点击回调
--coinType:金币类型,1:金币 2:金锭 3:银票
function bagWin:onCoinClick(coinType)
    -- body
end

--设置金币数
--coinType:金币类型,1:金币 2:金锭 3:银票
--value:金币数
function bagWin:setCoinValue(coinType,value)
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
--tagBtnIndex:标签按钮类型,1:全部 2:装备 3:道具
function bagWin:onTagBtnClick(tagBtnIndex)
    if not self.tagBtns[tagBtnIndex] then return end

    if self.curTagBtnIndex and self.curTagBtnIndex == tagBtnIndex then
        return
    else
        if self.curTagBtnIndex then
            local sp = cc.uiloader:seekNodeByName(self.tagBtns[self.curTagBtnIndex],"selected")
            sp:setVisible(false)
        end
        self.curTagBtnIndex = tagBtnIndex
        local sp = cc.uiloader:seekNodeByName(self.tagBtns[self.curTagBtnIndex],"selected")
        sp:setVisible(true)
    end

    local bagType
    if tagBtnIndex == 1 then            --全部
       self:onTotalTagClick()
       bagType = nil
    elseif tagBtnIndex == 2 then        --装备
       self:onEquipTagClick()
       bagType = 2
    elseif tagBtnIndex == 3 then        --道具
       self:onPropTagClick()
       bagType = 1
    end

    --背包数据刷新
    self:refreshBagData(bagType)
    --
    self:showTipsByType(nil)
    --
    self.curItem = nil
end

--全部标签按钮点击回调
function bagWin:onTotalTagClick()
    -- body
end

--装备标签按钮点击回调
function bagWin:onEquipTagClick()
	-- body
end

--道具标签按钮点击回调
function bagWin:onPropTagClick()
	-- body
end

--设置背包数据
--bagType: 1道具,2装备,3宝石,nil全部
function bagWin:refreshBagData(bagType, sort)
    self.curBagType = bagType
    local bagManager = BagManager:getInstance()

    local bagItemList
    if bagType == 1 then            --道具
        bagItemList = bagManager.bagInfo:getPropList()
    elseif bagType == 2 then        --装备
        bagItemList = bagManager.bagInfo:getEquipList()
    elseif bagType == 3 then        --宝石
        bagItemList = bagManager.bagInfo:getGemList()
    else                            --全部
        bagItemList = bagManager.bagInfo:getTotalList()
    end

    if sort and sort == true then
        bagManager.bagInfo:sortEquipBag(bagItemList)
    end

    local has = false
    self.curItem = nil

    self.pageManager:SetPageItemsData(bagItemList)

    --[[
        ===================== 还原上次选中 =====================
    ]]
    if self.curItemData ~= nil then
        local findExist = false
        for i = 1, #bagItemList do
            if self.curItemData.id == bagItemList[i].id then
                self.curItemData = bagItemList[i]
                findExist = true
                self.pageManager:SelectItemByData(self.curItemData)
                -- self.pageManager:GotoFirstPage()
                break
            end
        end
        if not findExist then
            self.curItemData = nil
            if self.tipsLayer.tipsProp ~= nil then
                self.tipsLayer.tipsProp:setVisible(false)
            end
        end
    end
    

    if not bagType then
        local labBagItemCount = cc.uiloader:seekNodeByName(self.win,"labBagItemCount")
        labBagItemCount:setVisible(true)
        local roleManager = RoleManager:getInstance()
        local roleInfo = roleManager.roleInfo
        labBagItemCount:setString(string.format("%d/%d",#bagItemList,roleInfo.bag))
    else
        local labBagItemCount = cc.uiloader:seekNodeByName(self.win,"labBagItemCount")
        labBagItemCount:setVisible(false)
    end
end

function bagWin:onStoreItemClick(itemData, isSelected)
    self.curItemData = itemData

    if self.showSelling then
        if isSelected then
            self.tipsLayer.tipsSell:addSellItem(itemData)
        else
            self.tipsLayer.tipsSell:removeSellItem(itemData)
        end
    else
        local goodType = configHelper:getGoodTypeByGoodId(itemData.goods_id)
 
        if not goodType then return end
        
        if goodType == 2 then
            if not self.tipsLayer.tipsEquip then
                self.tipsLayer.tipsEquip = TipsEquip.new()
                self.tipsLayer.tipsEquip:setAnchorPoint(0.5,0.5)
                local cs = self.tipsLayer:getContentSize()
                self.tipsLayer.tipsEquip:setPosition(cs.width/2,cs.height/2)
                self.tipsLayer:addChild(self.tipsLayer.tipsEquip)
            end
            self:showTipsByType(2)
            self.tipsLayer.tipsEquip:setData(itemData)
        elseif goodType == 1 or goodType == 6 or goodType == 7 or goodType == 4 then
            if not self.tipsLayer.tipsProp then
                self.tipsLayer.tipsProp = TipsProp.new()
                self.tipsLayer.tipsProp:setAnchorPoint(0.5,0.5)
                local cs = self.tipsLayer:getContentSize()
                self.tipsLayer.tipsProp:setPosition(cs.width/2,cs.height/2)
                self.tipsLayer:addChild(self.tipsLayer.tipsProp, 999)
            end
            self:showTipsByType(1)
            self.tipsLayer.tipsProp:setData(itemData)
        end
    end
end

function bagWin:showTipsByType(tt)
    if tt == 1 then                                         --显示道具tips
        self.showSelling = false
        if self.tipsLayer.tipsSell then
            self.tipsLayer.tipsSell:setVisible(false)
        end
        if self.tipsLayer.tipsEquip then
            self.tipsLayer.tipsEquip:setVisible(false)
        end
        if self.tipsLayer.tipsProp then
            self.tipsLayer.tipsProp:setVisible(true)
        end
    elseif tt == 2 then                                     --显示装备tips
        self.showSelling = false
        if self.tipsLayer.tipsSell then
            self.tipsLayer.tipsSell:setVisible(false)
        end
        if self.tipsLayer.tipsEquip then
            self.tipsLayer.tipsEquip:setVisible(true)
        end
        if self.tipsLayer.tipsProp then
            self.tipsLayer.tipsProp:setVisible(false)
        end
    elseif tt == 3 then                                     --显示宝石tips
        self.showSelling = false
        if self.tipsLayer.tipsSell then
            self.tipsLayer.tipsSell:setVisible(false)
        end
        if self.tipsLayer.tipsEquip then
            self.tipsLayer.tipsEquip:setVisible(false)
        end
        if self.tipsLayer.tipsProp then
            self.tipsLayer.tipsProp:setVisible(false)
        end
    elseif tt == 4 then                                     --显示出售tips
        self.showSelling = true
        if self.tipsLayer.tipsSell then
            self.tipsLayer.tipsSell:setVisible(true)
        end
        --[[显示出售页面时不隐藏其他的tips页面
        if self.tipsLayer.tipsEquip then
            self.tipsLayer.tipsEquip:setVisible(false)
        end
        if self.tipsLayer.tipsProp then
            self.tipsLayer.tipsProp:setVisible(false)
        end
        --]]
    else
        self.showSelling = false
        if self.tipsLayer.tipsSell then
            self.tipsLayer.tipsSell:setVisible(false)
        end
        if self.tipsLayer.tipsEquip then
            self.tipsLayer.tipsEquip:setVisible(false)
        end
        if self.tipsLayer.tipsProp then
            self.tipsLayer.tipsProp:setVisible(false)
        end
    end

    self.pageManager:SetItemsSelectVisible(false)
    self.pageManager:ResetItemsSelectState()
end

--扩展按钮点击事件
function bagWin:onExtendClick()
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    if roleInfo.bag>=100 then
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"背包数量已达上限!")
    else
        local function enterFun()
            GameNet:sendMsgToSocket(14008, {})
        end
        local kzcs = (roleInfo.bag-50)/5 + 1
        local sycs = 10-kzcs
        GlobalMessage:alert({
            enterTxt = "确定",
            backTxt="取消",
            tipTxt = string.format("本次扩展增加5个背包空间,需要花费%d元宝,还可以\n扩展%d次",kzcs*20,sycs),
            enterFun = handler(self, enterFun)
            --backFun = handler(self, backFun)
            })
    end
end

--批量出售按钮点击事件
function bagWin:onBatchSellClick()
    local batchSell = BatchSell.new()
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,batchSell)  
end

--出售钮点击事件
function bagWin:onSellClick()
    if self.showSelling then
        self.tipsLayer.tipsSell:setVisible(false)
        self.showSelling = false
        self.pageManager:SetItemsSelectVisible(false)
        self.pageManager:ResetItemsSelectState()
    else
        if not self.tipsLayer.tipsSell then
            self.tipsLayer.tipsSell = TipsSell.new()
            self.tipsLayer.tipsSell:setAnchorPoint(0.5,0.5)
            local cs = self.tipsLayer:getContentSize()
            self.tipsLayer.tipsSell:setPosition(cs.width/2,cs.height/2)
            self.tipsLayer:addChild(self.tipsLayer.tipsSell,10)
            self.showSelling = true
        else
            self:showTipsByType(4)
            self.tipsLayer.tipsSell:reset()
        end

        self.pageManager:SetItemsSelectVisible(true)
        self.pageManager:ResetItemsSelectState()
    end
end

--熔炼按钮点击事件
function bagWin:onSmeltClick()
    GlobalWinManger:openWin(WinName.SMELTWIN)
end

--打开界面
function bagWin:open()
 
    self:registerGlobalEventHandler(EquipEvent.DECOMPOSE_SUCCESS, function()
        if self.tipsLayer.tipsEquip then
            self.tipsLayer.tipsEquip:setVisible(false)
        end
    end)

    self:registerGlobalEventHandler(BagEvent.CANCEL_SELL, function()
        self:onSellClick()
    end)

    self:registerGlobalEventHandler(BagEvent.PROP_CHANGE, function()
        self:refreshBagData(self.curBagType)
    end)

    self:registerGlobalEventHandler(BagEvent.EQUIP_CHANGE, function()
        self:refreshBagData(self.curBagType)
    end)

    -- self:registerGlobalEventHandler(BagEvent.UPDATE_WEALTH, function()
    --     print("UPDATE_WEALTH")
    --     self:refreshCoin()
    -- end)
    if self.wealthChangEventId == nil then
        self.wealthChangEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,handler(self,self.refreshCoin))
    end

    local bagManager = BagManager:getInstance()
    bagManager.bagInfo.autoSort = false

    self:registerGlobalEventHandler(BagEvent.BAG_COUNT_CHANGE, function()
        local labBagItemCount = cc.uiloader:seekNodeByName(self.win,"labBagItemCount")
        --labBagItemCount:setVisible(true)
        local bagManager = BagManager:getInstance()
        local bagItemList = bagManager.bagInfo:getTotalList()
        local roleManager = RoleManager:getInstance()
        local roleInfo = roleManager.roleInfo
        labBagItemCount:setString(string.format("%d/%d",#bagItemList,roleInfo.bag))
    end)

    self:registerGlobalEventHandler(BagEvent.EXPAND_BAG_SUCCESS, function()
        self.pageManager:RefreshLockStates()
    end)
    -- self:registerGlobalEventHandler(BagEvent.SEND_SELL, function()
    --     for i=1,#self.bagItems do
    --         local commonItem = self.bagItems[i]:getChildByTag(10)
    --         if commonItem then
    --             commonItem:setSelected(false)
    --         end
    --     end
    -- end)
    
    self:setupGuide()
end

--
-- 注册全局事件监听。
--
function bagWin:registerGlobalEventHandler(eventId, handler)
    local handles = self._eventHandles or {}
    handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
    self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function bagWin:removeAllEvents()
    if self._eventHandles then
        for _, v in pairs(self._eventHandles) do
            GlobalEventSystem:removeEventListenerByHandle(v)
        end
    end

    self:clearGuide()
end

--关闭界面
function bagWin:close()
    if self.wealthChangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.wealthChangEventId)
        self.wealthChangEventId = nil
    end
    if self._handle then
        scheduler.unscheduleGlobal(self._handle)
        self._handle = nil
    end
    self:removeAllEvents()
end

--清理界面
function bagWin:destory()
    self.pageManager:Destory()
    self:close()
    bagWin.super.destory(self)
end

--点击关闭按钮
function bagWin:onClickCloseBtn()
     GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_WIN_CLOSE_BUTTON)
    self.super.onClickCloseBtn(self)
end
-----------------------------------------------------------------------------
-- START---------------------------------------------------------------------
-- MARK GUIDE DEMAND SETUP & CLEAR
function bagWin:setupGuide()
    if self.guideHandle then return end

    self.guideHandle = GlobalController.guide:addDemandEventListener(function(event)
        local demandEvent = event.data
        local guideMark = demandEvent:getGuideMark()

        if guideMark:isDynamic() then
            local omt_type = guideMark:getOptionType()
            if omt_type == GUIMR.OMT_AUTO_CLICK_BAG then
                local goods_id_list = guideMark:getOptionList()
                for _, v in ipairs(goods_id_list) do
                    if self.pageManager:GotoPageByGoodsId(checknumber(v)) then
                        return
                    end
                end
            end
        end
    end)
end

function bagWin:clearGuide()
    if self.guideHandle then
        GlobalController.guide:removeDemandEventByHandle(self.guideHandle)
        self.guideHandle = nil
    end
end
-- END OF GUIDE ---------------------------------------------------------------

return bagWin