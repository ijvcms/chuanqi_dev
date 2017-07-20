--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 神皇密境
local ShengHuangMJWin = class("ShengHuangMJWin", BaseView)
local lotteryConfig = import("app.conf.lottery_coinConfig").new()
function ShengHuangMJWin:ctor(winTag,data,winconfig)
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)
    ShengHuangMJWin.super.ctor(self,winTag,data,winconfig)
    -- self.root:setPosition((display.width-960)/2,(display.height-640)/2)

    self.coinTxt = self:seekNodeByName("coinTxt")
    self.bonusPointTxt = self:seekNodeByName("bonusPointTxt")
    for i=1,12 do
        self["item"..i] = self:seekNodeByName("item"..i)
    end

    self.onceBtn = self:seekNodeByName("onceBtn")
    self.fiveTimesBtn = self:seekNodeByName("fiveTimesBtn")
    self.tenTimesBtn = self:seekNodeByName("tenTimesBtn")
    self.coinTxt1 = self:seekNodeByName("coinTxt1")
    self.coinTxt2 = self:seekNodeByName("coinTxt2")
    self.coinTxt3 = self:seekNodeByName("coinTxt3")

    self.ListView1 = self:seekNodeByName("ListView1")
    self.ListView2 = self:seekNodeByName("ListView2")

    self.exchangeBtn = self:seekNodeByName("exchangeBtn")
    self.quickChargeBtn = self:seekNodeByName("quickChargeBtn")

    self.closeBtn = self:seekNodeByName("btnClose")

    self.prizeConfig = {}
    self.allPrizeConfig = {}

    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
    end)

    self.exchangeBtn:setTouchEnabled(true)
    self.exchangeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.exchangeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.exchangeBtn:setScale(1)
            self:showExChangView()
        end
        return true
    end)

    self.quickChargeBtn:setTouchEnabled(true)
    self.quickChargeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.quickChargeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.quickChargeBtn:setScale(1)
            GlobalWinManger:openWin(WinName.RECHARGEWIN)
        end
        return true
    end)


    self.onceBtn:setTouchEnabled(true)
    self.onceBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.onceBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.onceBtn:setScale(1)
           self:sendData(1)
        end
        return true
    end)
    self.fiveTimesBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.fiveTimesBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.fiveTimesBtn:setScale(1)
           self:sendData(5)
        end
        return true
    end)
    self.tenTimesBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.tenTimesBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.tenTimesBtn:setScale(1)
           self:sendData(10)
        end
        return true
    end)
    self.clicktime = 0
end

--更新自己购买记录
function ShengHuangMJWin:updateSelfBuyLog(data)
    
    self.mySelfLogData = {}
    for i=1,#data do
        table.insert(self.mySelfLogData,data[i])
    end
    if #self.mySelfLogData > 10 then
        for i=#self.mySelfLogData,11,-1 do
            table.remove(self.mySelfLogData,i)
        end
    end
    if self.mySelfLogLab == nil then
        self.mySelfLogLab = {}
        for i=1,10 do
            local item = self.ListView1:newItem()
            local lab = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'></font>")
            item:addContent(lab)
             item:setItemSize(250, 25)
            self.ListView1:addItem(item)
            table.insert(self.mySelfLogLab,lab)
        end
    end
    local tips = ""
    local len = math.max(math.min(#self.mySelfLogData,10),1)
    for i=1,len do
        local obj = self.mySelfLogData[i]
        if obj and self.mySelfLogLab[i] then
            -- local goodId = self.prizeList[obj.goods_id].goods_id
            local itemName = configHelper:getGoodNameByGoodId(obj.goods_id)
            local quality = configHelper:getGoodQualityByGoodId(obj.goods_id)
            local color = '0xffd3af'
                if quality then
                    if quality == 1 then            --白
                        color = '0xffd3af'
                    elseif quality == 2 then        --绿
                        color = '0x6fc491'
                    elseif quality == 3 then        --蓝
                        color = '0x9bc6d4'
                    elseif quality == 4 then        --紫
                        color = '0xff65e7'
                    elseif quality == 5 then        --橙
                        color = '0xff7633'
                    elseif quality == 6 then        --红
                        color = '0xf72121'
                    end 
                end
            local playName = obj.name
            tips = "<font color='0xDBAE67' size='20' opacity='255'>"..playName.."<font color='0x00EE00' size='20' opacity='255'>获得了</font><font color='"..color.."' size='20' opacity='255'>"..itemName.."</font></font><br/>"
            self.mySelfLogLab[i]:renderXml(tips)
            self.mySelfLogLab[i]:setVisible(true)
        end
    end
    for i=len+1,21 do
        if self.mySelfLogLab[i] then
            self.mySelfLogLab[i]:setVisible(false)
        end
    end
    self.ListView1:reload()
end


--更新自己购买记录
function ShengHuangMJWin:updateAllServerLog(data)
    -- data = {
    --     [1] = {name= "FFGG",goods_id = 201061},
    --     [2] = {name= "FFGG",goods_id = 201061},
    --     [3] = {name= "FFGG",goods_id = 201061},
    --     [4] = {name= "FFGG",goods_id = 201061},
    --     [5] = {name= "FFGG",goods_id = 201061},
    --     [6] = {name= "FFGG",goods_id = 201061},
    -- }
    if self.allServerLogData == nil then
        self.allServerLogData = {}
    end
    self.allServerLogData = {}
    for i=1,#data do
        table.insert(self.allServerLogData,data[i])
    end
    if #self.allServerLogData > 10 then
        for i=#self.allServerLogData,11,-1 do
            table.remove(self.allServerLogData,i)
        end
    end
    if self.allServerLogLab == nil then
        self.allServerLogLab = {}
        for i=1,10 do
            local item = self.ListView1:newItem()
            local lab = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'></font>")
            item:addContent(lab)
             item:setItemSize(250, 25)
            self.ListView2:addItem(item)
            table.insert(self.allServerLogLab,lab)
        end
    end
    local tips = ""
    local len = math.max(math.min(#self.allServerLogData,10),1)
    for i=1,len+1 do
        local obj = self.allServerLogData[i]
        if obj and self.allServerLogLab[i] then
            -- local goodId = self.prizeList[obj.goods_id].goods_id
            local itemName = configHelper:getGoodNameByGoodId(obj.goods_id)
            local quality = configHelper:getGoodQualityByGoodId(obj.goods_id)
            local color = '0xffd3af'
                if quality then
                    if quality == 1 then            --白
                        color = '0xffd3af'
                    elseif quality == 2 then        --绿
                        color = '0x6fc491'
                    elseif quality == 3 then        --蓝
                        color = '0x9bc6d4'
                    elseif quality == 4 then        --紫
                        color = '0xff65e7'
                    elseif quality == 5 then        --橙
                        color = '0xff7633'
                    elseif quality == 6 then        --红
                        color = '0xf72121'
                    end 
                end
            local playName = obj.name
            tips = "<font color='0xDBAE67' size='20' opacity='255'>"..playName.."<font color='0x00EE00' size='20' opacity='255'>获得了</font><font color='"..color.."' size='20' opacity='255'>"..itemName.."</font></font><br/>"
            self.allServerLogLab[i]:renderXml(tips)
            self.allServerLogLab[i]:setVisible(true)
        end
    end
    for i=len+1,21 do
        if self.allServerLogLab[i] then
            self.allServerLogLab[i]:setVisible(false)
        end
    end
    self.ListView2:reload()
end

function ShengHuangMJWin:sendData(times)

    if socket.gettime() - self.clicktime < 0.6 then
        return 
    end
    self.clicktime = socket.gettime()
    local jingbi = RoleManager:getInstance().wealth.jade
    local needMoney = 0
    if times == 1 then
        needMoney = self.initData.num1_need_jade
    elseif times == 5 then
        needMoney = self.initData.num5_need_jade
    elseif times == 10 then
        needMoney = self.initData.num10_need_jade
    end
    if jingbi >= needMoney then
        local bagnum = BagManager:getInstance():getBagRemain()
        if bagnum < times then
            GlobalMessage:show("背包已满或背包空格少于"..times.."格")
        else
            GameNet:sendMsgToSocket(35005,{num = times})
        end
    else
        GlobalMessage:show("元宝不足！")
        -- self:showPrizeView()
    end
end



function ShengHuangMJWin:refreshCoin(data)
    self.coinTxt:setString(RoleManager:getInstance().wealth.jade)
end

function ShengHuangMJWin:showPrizeView(data)
    -- data = {}
    -- data.data = {}
    -- data.data.lottery_id_list = {1,2,3,4,5}
    self.canClickClosePrize = false
    self.initData.lottery_score = data.data.lottery_score
    self.bonusPointTxt:setString(data.data.lottery_score)

   
    self.showPrizeNode = display.newNode()
    self.showPrizeNode:setContentSize(display.width, display.height)
    self:addChild(self.showPrizeNode)
    self.showPrizeNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            if self.canClickClosePrize then
                self.showPrizeNode:setVisible(false)
                if self.showPrizeEff then
                    self.showPrizeEff:stopAllActions()
                    self.showPrizeEff:getAnimation():stop()
                    self.showPrizeEff:getParent():removeChild(self.showPrizeEff)
                    ArmatureManager:getInstance():unloadEffect(self.curAckEff)
                    self.showPrizeEff = nil
                end
                if self.shouPrizeList then
                    for k,v in pairs(self.shouPrizeList) do
                        v:destory()
                        if v:getParent() then
                            v:getParent():removeChild(v)
                        end
                        self.shouPrizeList[k] = nil
                    end
                    self.shouPrizeList = nil
                end
                if self.showPrizeNode then
                    self.showPrizeNode:removeChild(bg)
                    self.showPrizeNode = nil
                end
            end
        end
        return true
    end)
    self.showPrizeNode:setTouchEnabled(true)
    local bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    bg:setContentSize(display.width, display.height)
    self.showPrizeNode:addChild(bg)

    --self.showPrizeEff = backArr
    ArmatureManager:getInstance():loadEffect("lucky_effect")
    if self.showPrizeEff == nil then
        self.showPrizeEff = ccs.Armature:create("lucky_effect")
        self.showPrizeNode:addChild(self.showPrizeEff)
        self.showPrizeEff:setPosition(display.width/2,display.height/2-100)

        local function animationEvent(armatureBack,movementType,movementID)
            if self.isDestory or self.isDestory == nil then
                return
            end
            if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
                armatureBack:getAnimation():setMovementEventCallFunc(function()end)
                --self:clearBuffEffectByID(buffEffId)
                self.showPrizeEff:setVisible(false)
                self.showPrizeEff:stopAllActions()
                self.showPrizeEff:getAnimation():stop()
            end
        end
        self.showPrizeEff:getAnimation():setMovementEventCallFunc(animationEvent)
    end
    self.showPrizeEff:setVisible(true)
    self.showPrizeEff:getAnimation():play("effect")

    self.shouPrizeList = {} 

    -- for i=#data.data.lottery_id_list,1,-1 do
    --     local vo = self.prizeConfig[data.data.lottery_id_list[i]]
    --     if vo == nil then
    --         table.remove(data.data.lottery_id_list,i)
    --     else
    --         print(data.data.lottery_id_list[i])
    --     end
    -- end
    local len = #data.data.lottery_id_list;
    local beginX = len/2
    if len > 5 then
        beginX = 5/2
    end
    for i=1,#data.data.lottery_id_list do
        local vo = data.data.goods_list[i]--self.allPrizeConfig[data.data.lottery_id_list[i]]
        if vo then
            local item = CommonItemCell.new()
            self.showPrizeNode:addChild(item)
            item:setData({goods_id = vo.goods_id, is_bind = vo.is_bind, num = vo.num})
            item:setCount(vo.num)
            item:setVisible(false)
            item:setPosition(display.width/2, display.height/2)
            table.insert(self.shouPrizeList,item)

            local action1 = cc.DelayTime:create(0.2*(i - 1))
            local action2 = cc.CallFunc:create(function () item:setVisible(true) end) 
            local action3 = cc.MoveTo:create(0.10, cc.p(display.width/2 + ((i-1)%5 - beginX)*90 - 40+90 ,display.height/2+20+120*(2-math.ceil((i)/5))))
            
            local action6 = transition.sequence({
                             action1,
                             action2,
                             action3,
                         }) 
            if i == #data.data.lottery_id_list then
                local action7 = cc.CallFunc:create(function () self.canClickClosePrize = true end) 
                action6 = transition.sequence({
                             action1,
                             action2,
                             action3,
                             action7,
                         }) 
            end
            item:runAction(action6)
        end
    end


end

function ShengHuangMJWin:updateItem()
    if self.prizeListItem == nil then  
        self.prizeListItem = {}

        local min = 10000
        local max = 1
        for k,v in pairs(self.prizeConfig) do
            if k <min then
                min = k
            end
            if k > max then
                max = k
            end
        end
        
        local index = 1
        for i=min,max do
            local vo = self.prizeConfig[i]
            if vo then
                local item = CommonItemCell.new()
                self["item"..index]:addChild(item)
                item:setData({goods_id = vo.goods[1][1], is_bind = vo.goods[1][2], num = vo.goods[1][3]})
                item:setCount(vo.goods[1][3])
                item:setPosition(40,40)
                self.prizeListItem[vo.id] = item
                index= index +1
            end
        end

    end
end



function ShengHuangMJWin:shengHuangInit(data)
    self.initData = data.data or {}
    self.groupId = self.initData.group_id
    self.prizeConfig = configHelper:getLuckydraw_displayConfigByGroup(self.groupId)
    self.allPrizeConfig = configHelper:getLottery_boxConfigByGroup(1) 
    
    self:updateSelfBuyLog(self.initData.my_log_lists)
    self:updateAllServerLog(self.initData.all_log_lists)
    self:updateItem()

    self.bonusPointTxt:setString(self.initData.lottery_score)

    self.coinTxt1:setString(self.initData.num1_need_jade)
    self.coinTxt2:setString(self.initData.num5_need_jade)
    self.coinTxt3:setString(self.initData.num10_need_jade)
end

function ShengHuangMJWin:updateLog(data)
    for k,v in pairs(data.data) do
        if v.player_id == RoleManager:getInstance().roleInfo.player_id then
            table.insert(self.initData.my_log_lists,1,v)
            if #self.initData.my_log_lists >= 20 then
                table.remove(self.initData.my_log_lists,20)
            end

            table.insert(self.initData.all_log_lists,1,v)
            if #self.initData.all_log_lists >= 20 then
                table.remove(self.initData.all_log_lists,20)
            end
        else
            table.insert(self.initData.all_log_lists,1,v)
            if #self.initData.all_log_lists >= 20 then
                table.remove(self.initData.all_log_lists,20)
            end
        end
    end
    self:updateSelfBuyLog(self.initData.my_log_lists)
    self:updateAllServerLog(self.initData.all_log_lists)
end


function ShengHuangMJWin:open()
    ShengHuangMJWin.super.open(self)

    if self.shenghuangInitEventId == nil then
         self.shenghuangInitEventId = GlobalEventSystem:addEventListener(ShenghuangEvent.SHENGHUANG_INIT,handler(self,self.shengHuangInit))
    end
    if self.wealthChangEventId == nil then
         self.wealthChangEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,handler(self,self.refreshCoin))
    end
    if self.shenghuangGetPrizeEventId == nil then
        --showExChangView
         self.shenghuangGetPrizeEventId = GlobalEventSystem:addEventListener(ShenghuangEvent.SHENGHUANG_GET_PRIZE,handler(self,self.showPrizeView))
    end
    if self.shenghuangUpdateLogEventId == nil then
         self.shenghuangUpdateLogEventId = GlobalEventSystem:addEventListener(ShenghuangEvent.SHENGHUANG_UPDATE_LOG,handler(self,self.updateLog))
    end

    if self.shenghuangExchangEventId == nil then
         self.shenghuangExchangEventId = GlobalEventSystem:addEventListener(ShenghuangEvent.SHENGHUANG_EXCHANG,handler(self,self.updateScore))
    end


    self:refreshCoin()
    print("35004")
    GameNet:sendMsgToSocket(35004,{last_id = 0})
end

local function removeEvents(self)
    if self.shenghuangInitEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.shenghuangInitEventId)
        self.shenghuangInitEventId = nil
    end
    if self.wealthChangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.wealthChangEventId)
        self.wealthChangEventId = nil
    end
    if self.shenghuangGetPrizeEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.shenghuangGetPrizeEventId)
        self.shenghuangGetPrizeEventId = nil
    end
    if self.shenghuangUpdateLogEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.shenghuangUpdateLogEventId)
        self.shenghuangUpdateLogEventId = nil
    end

    if self.shenghuangExchangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.shenghuangExchangEventId)
        self.shenghuangExchangEventId = nil
    end
end

function ShengHuangMJWin:close()
    removeEvents(self)

    if self.prizeListItem then
        for k,v in pairs(self.prizeListItem) do
            v:destory()
            if v:getParent() then
                v:getParent():removeChild(v)
            end
            self.prizeListItem[k] = nil
        end
        self.prizeListItem = nil
    end
    if self.shouPrizeList then
        for k,v in pairs(self.shouPrizeList) do
            v:destory()
            if v:getParent() then
                v:getParent():removeChild(v)
            end
            self.shouPrizeList[k] = nil
        end
        self.shouPrizeList = nil
    end

    if self.showPrizeEff then
                self.showPrizeEff:stopAllActions()
                self.showPrizeEff:getAnimation():stop()
                self.showPrizeEff:getParent():removeChild(self.showPrizeEff)
                ArmatureManager:getInstance():unloadEffect(self.curAckEff)
                self.showPrizeEff = nil
            end
    
    if self.exChangView then
        self.exChangView:destory()
        self:removeChild(self.exChangView)
        self.exChangView = nil
    end
    ShengHuangMJWin.super.close(self)

end

function ShengHuangMJWin:updateScore(data)
    self.initData.lottery_score = data.data.lottery_score
    self.bonusPointTxt:setString(data.data.lottery_score)
end


function ShengHuangMJWin:showExChangView()
    if self.exChangView == nil then
        self.exChangView = import("app.modules.shenghuangmj.ShengHuangMJRewardWin").new()
        self:addChild(self.exChangView)
    end
    self.exChangView:setVisible(true)
    self.exChangView:open(self.initData.lottery_score)
end

--清理界面
function ShengHuangMJWin:destory()
    removeEvents(self)
	ShengHuangMJWin.super.destory(self)
end

return ShengHuangMJWin