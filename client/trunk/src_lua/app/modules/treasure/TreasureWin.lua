--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 转盘
local TreasureWin = class("TreasureWin", BaseView)
function TreasureWin:ctor(winTag,data,winconfig)
	TreasureWin.super.ctor(self,winTag,data,winconfig)

    self.coinTxt1 = self:seekNodeByName("coinTxt1") --金币
    self.coinTxt2 = self:seekNodeByName("coinTxt2") --元宝
    self.coinTxt3 = self:seekNodeByName("coinTxt3") --绑定元宝

    self.timesLabel = self:seekNodeByName("timesLabel") --可购买次数

    self.timeLabel = self:seekNodeByName("timeLabel") --倒计时

    self.refreshBtn = self:seekNodeByName("refreshBtn") --刷新按钮

    self.mainLayer = self:seekNodeByName("mainLayer") --商品容器
    
  	self.data = data

    self.refreshBtn:setTouchEnabled(true)
    self.refreshBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.refreshBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.refreshBtn:setScale(1)
             GameNet:sendMsgToSocket(16102)
        end
        return true
    end)

    self.buyItemID = 0
    self.isCancelRemoveSpriteFrams = true

end




function TreasureWin:open()
    TreasureWin.super.open(self)

    if self.wealthChangEventId == nil then
         self.wealthChangEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,handler(self,self.refreshCoin))
    end
    if self.buySuccessEventId == nil then
         self.buySuccessEventId = GlobalEventSystem:addEventListener(TreasureEvent.BUY_SUCCESS,handler(self,self.buySuccess))
    end

    self:refreshCoin()
    if self.updateShopListEventId == nil then
        self.updateShopListEventId = GlobalEventSystem:addEventListener(TreasureEvent.UPDATE_SHOP_LIST,handler(self,self.updateShopList))
    end
    self.shopItemViewList = {}
    GameNet:sendMsgToSocket(16100)
    self:setVisible(false)
end


function TreasureWin:refreshCoin(data)
    self.coinTxt1:setString(RoleManager:getInstance().wealth.coin)
    self.coinTxt2:setString(RoleManager:getInstance().wealth.jade)
    self.coinTxt3:setString(RoleManager:getInstance().wealth.gift)
    -- self.coinTxt1 = self:seekNodeByName("coinTxt1") --金币
    -- self.coinTxt2 = self:seekNodeByName("coinTxt2") --元宝
    -- self.coinTxt3 = self:seekNodeByName("coinTxt3") --绑定元宝
end

function TreasureWin:buySuccess(data)
    if GlobalController.treasure.curBuyItemId then
        --self.shopItemViewList[i]
        for i=1,#self.shopItemViewList do
            self.shopItemViewList[i]:setBuy(GlobalController.treasure.curBuyItemId)
        end
        if self.bugTimes > 0 then
            self.bugTimes = self.bugTimes - 1
            self.timesLabel:setString(self.bugTimes)
        end
    end
end


function TreasureWin:updateRefreshTime(data)
    if self.refreshTime and self.refreshTime > 0 then
        self.refreshTime = self.refreshTime -1
        local curTime = self.refreshTime
        local str = ""
        local curNum = math.floor(curTime/3600)
        if curNum < 10 then
            str = str.."0"..curNum
        else
            str = str..curNum
        end
        str=str..":"
        curTime = curTime%3600
        curNum = math.floor(curTime/60)
        if curNum < 10 then
            str = str.."0"..curNum
        else
            str = str..curNum
        end
        str=str..":"

        curNum = math.floor(curTime%60)
        if curNum < 10 then
            str = str.."0"..curNum
        else
            str = str..curNum
        end

        self.timeLabel:setString(str)
    else
        if self.timerId then
            GameNet:sendMsgToSocket(16100)
            GlobalTimer.unscheduleGlobal(self.timerId)
            self.timerId = nil
        end
    end
end

function TreasureWin:updateShopList(data)
    data = data.data
    if data.is_open == 0 then
        GlobalMessage:show("神秘探宝暂未开放")
        GlobalWinManger:closeWin(self.winTag)
        return
    end
    self:setVisible(true)
    self.shopList = data.list
    if #self.shopList > 1 then
        table.sort( self.shopList, function(a,b) return a["vip"] < b["vip"] end )
    end
    if data.bugTimes then
        self.bugTimes = data.bugTimes
        self.timesLabel:setString(self.bugTimes)
    end
    if data.refreshTime then
        self.refreshTime = data.refreshTime
        self.timeLabel:setString("00:00:00")

        if self.timerId == nil and self.refreshTime > 0 then
            self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.updateRefreshTime),1)--GlobalTimer.scheduleUpdateGlobal(handler(self,self.playTurn))
        end
    end

    if data.refreshNeedJade then
        self.refreshNeedJade = data.refreshNeedJade
        
    end

    -- self.buyItemID
    for i=1,#self.shopList do
        local item = self.shopItemViewList[i]
        if item == nil then
            item = import("app.modules.treasure.TreasureItem").new()
            self.mainLayer:addChild(item)
            item:setPosition(172*(i-1),0)
            self.shopItemViewList[i] = item
        end
        item:setData(self.shopList[i])
    end
end



function TreasureWin:close()

    if self.updateShopListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateShopListEventId)
        self.updateShopListEventId = nil
    end
    if self.wealthChangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.wealthChangEventId)
        self.wealthChangEventId = nil
    end

    if self.buySuccessEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.buySuccessEventId)
        self.buySuccessEventId = nil
    end

    if self.timerId then
            GlobalTimer.unscheduleGlobal(self.timerId)
            self.timerId = nil
    end
   
    TreasureWin.super.close(self)
end


--清理界面
function TreasureWin:destory()
    self:close()
    for k,v in pairs(self.shopItemViewList or {}) do
        v:destory()
    end
    self.shopItemViewList = {}
	TreasureWin.super.destory(self)
	
end

return TreasureWin