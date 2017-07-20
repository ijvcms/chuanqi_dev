--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 抽奖
local LuckDrawWin = class("LuckDrawWin", BaseView)
local lotteryConfig = import("app.conf.lottery_coinConfig").new()
function LuckDrawWin:ctor(winTag,data,winconfig)
	LuckDrawWin.super.ctor(self,winTag,data,winconfig)
    self.root:setPosition((display.width-700)/2,(display.height-500)/2+50)

    self.oneBtn = self:seekNodeByName("oneBtn")
    self.tenBtn = self:seekNodeByName("tenBtn")

    --self.recordLayer = self:seekNodeByName("recordLayer")--ListView_25 recordLayer
    self.ListView_25 = self:seekNodeByName("ListView_25")
    self.closeBtn = self:seekNodeByName("closeBtn")
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

    self.item1 = self:seekNodeByName("item1")
    self.item2 = self:seekNodeByName("item2")
    self.item3 = self:seekNodeByName("item3")
    self.item4 = self:seekNodeByName("item4")
    self.item5 = self:seekNodeByName("item5")
    self.item6 = self:seekNodeByName("item6")
    self.item7 = self:seekNodeByName("item7")
    self.item8 = self:seekNodeByName("item8")

    self.selectBg = self:seekNodeByName("selectBg")

    self.goldNumber = self:seekNodeByName("goldNumber")

    self.ruleBtn = self:seekNodeByName("ruleBtn")
    self.ruleBtn:setTouchEnabled(true)
    self.ruleBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.ruleBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.ruleBtn:setScale(1.0)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(15),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)
    self.angleList = {}
    for i=1,8 do
        local posx,posy = self["item"..i]:getPosition()
        table.insert(self.angleList,{posx,posy})
    end
    --self.angleList = {{160,279},{273,279},{273,162},{273,46},{159,46},{45,46},{45,164},{45,279}}

    -- self.uiLay = display.newNode()
    -- self.uiLay:setTouchEnabled(false)
    -- self:addChild(self.uiLay)
    -- self.uiLay:setPosition((display.width-900)/2,(display.height-496)/2)
    -- self:creatPillar()
    
  	self.data = data

    self.oneBtn:setTouchEnabled(true)
    self.oneBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.oneBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.oneBtn:setScale(1)
            self:sendData(1)
        end
        return true
    end)

    self.tenBtn:setTouchEnabled(true)
    self.tenBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.tenBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.tenBtn:setScale(1)
            self:sendData(10)
        end
        return true
    end)

    self.curTurnIndex = 1
    self.isRurnPlateRun = false
end

function LuckDrawWin:sendData(times)
    local jingbi = RoleManager:getInstance().wealth.coin
    local needMoney = 0
    if times == 1 then
        needMoney = 100000
    elseif times == 10 then
        needMoney = 1000000
    end
    if jingbi >= needMoney then
        local bagnum = BagManager:getInstance():getBagRemain()
        if bagnum <= times then
            GlobalMessage:show("背包已满或背包空格少于"..times.."格")
        else
            if self.isRurnPlateRun then
                --GlobalMessage:show("正在抽奖中，请稍候！")
                self:stopPlayTurn()
            else
                GameNet:sendMsgToSocket(36001,{num = times})
            end
        end
    else
        GlobalMessage:show("金币不足！")
    end
end


function LuckDrawWin:gotoItem(endValue)
    local curIndex = self.curTurnIndex
    local endIndex = endValue
    local indexLen = endIndex + 8*8
    endIndex = indexLen

    self.angleIndexList = {}
    for i=curIndex,endIndex do
        local len = i-(curIndex+4)
        if len >= 0 then
          len = endIndex - i-8
        end
        if len >= 0 then
          len = 0
        end
        len = 0-len
        for l=1,len*2+1 do
            table.insert(self.angleIndexList,{self.angleList[(i-1)%8+1],(i-1)%8+1,endIndex})
        end
    end
    if self.timerId == nil then
        self.isRurnPlateRun = true
        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.playTurn),0.03)--GlobalTimer.scheduleUpdateGlobal(handler(self,self.playTurn))
    end
    -- if self.timerId then
    --     GlobalTimer.unscheduleGlobal(self.timerId)
    --     self.timerId = nil
    -- end
end

function LuckDrawWin:stopPlayTurn()
    if #self.angleIndexList > 1 then
        for i=1,#self.angleIndexList-1 do
            table.remove(self.angleIndexList,1)
        end
    end 
    self:playTurn()
end

function LuckDrawWin:playTurn()
    local value = table.remove(self.angleIndexList,1)
    if value then
        if value[2] ~= self.curTurnIndex then
            SoundManager:playSoundByType(SoundType.LUCKPLATETRUN)
        end
        self.selectBg:setPosition(value[1][1]+28,value[1][2]+76)
        self.curTurnIndex = value[2]
    end
    if #self.angleIndexList <= 0 then
        if self.timerId then
            self.isRurnPlateRun = false
            self:showGetPropAndEquip()
            GlobalTimer.unscheduleGlobal(self.timerId)
            self.timerId = nil
        end
        return
    end
end


function LuckDrawWin:open()
    LuckDrawWin.super.open(self)
    self.isRurnPlateRun = false
    self.turnTipLabData = {}

    if self.prizeListItem then
        for i=1,#self.prizeListItem do
            self.prizeListItem[i]:destory()
            if self.prizeListItem[i]:getParent() then
                self.prizeListItem[i]:getParent():removeChild(self.prizeListItem[i])
            end
        end
    end
    self.prizeList = lotteryConfig.datas
    --[1] = {1, {{110064,1,2}}},
    self.prizeListItem = {

    }
    for i=1,#self.prizeList do
        local item = CommonItemCell.new()
        self["item"..i]:addChild(item)
        item:setData({goods_id = self.prizeList[i][2][1][1], is_bind = self.prizeList[i][2][1][2], num = self.prizeList[i][2][1][3]})
        item:setCount(self.prizeList[i][2][1][3])
        item:setPosition(38,38)
        self.prizeListItem[i] = item
    end
    
    --    LuckDrawEvent = {
--   LUCKDRAW_GET = "LUCKDRAW_GET", --转盘抽奖
--   LUCKDRAW_TIP_UPDATE = "LUCKDRAW_TIP_UPDATE", --转盘抽奖提示更新
-- }

    if self.luckDrawGetEventId == nil then
        self.luckDrawGetEventId = GlobalEventSystem:addEventListener(LuckDrawEvent.LUCKDRAW_GET,handler(self,self.luckDrawPlay))
    end
    if self.luckDrawTipEventId == nil then
        self.luckDrawTipEventId = GlobalEventSystem:addEventListener(LuckDrawEvent.LUCKDRAW_TIP_UPDATE,handler(self,self.luckDrawTip))
    end

    if self.wealthChangEventId == nil then
         self.wealthChangEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,handler(self,self.refreshCoin))
    end
    self:refreshCoin()

    self.selectBg:setPosition(self.angleList[self.curTurnIndex][1]+28,self.angleList[self.curTurnIndex][2]+76)

    GameNet:sendMsgToSocket(36000,{last_id = 0})
    self.goodsList = nil
    self.equipList = nil
    self.luckDrawTipList = nil
end

function LuckDrawWin:refreshCoin(data)
    self.goldNumber:setString(RoleManager:getInstance().wealth.coin)
end

function LuckDrawWin:luckDrawPlay(data)
    data = data.data
    self.goodsList = data.goods_info
    self.equipList = data.equips_info
    self.rewardList = {}
    if data.idList then
        if #data.idList >= 1 then
            for i=1,#data.idList do
                local id = data.idList[i]
                table.insert(self.rewardList,{goods_id = self.prizeList[id][2][1][1], is_bind = self.prizeList[id][2][1][2], num = self.prizeList[id][2][1][3]})
            end
        end
        local value = data.idList[#data.idList]
        if self.showCompleteItem ~= nil then
            self.showCompleteItem:destory()
            self.root:removeChild(self.showCompleteItem)
            self.showCompleteItem = nil
        end
        self:gotoItem(value)
    end
end

function LuckDrawWin:showGetPropAndEquip()
    if self.goodsList and #self.goodsList > 0 then
        -- for i=1,#self.goodsList do
        --     GlobalController.bag:onHandle14002({goods_info = self.goodsList[i]})
        -- end
        GlobalController.bag:onHandle14002({goods_list = self.goodsList})
        self.goodsList = nil
    end
    if self.equipList and #self.equipList > 0 then
        -- for i=1,#self.equipList do
        --     GlobalController.bag:onHandle14021({equips_info = self.equipList[i]})
        --     self.equipList = nil
        -- end

        GlobalController.bag:onHandle14021({equips_list = self.equipList})
        self.equipList = nil

    end
    if self.rewardList and #self.rewardList > 1 then
        self:showReward(self.rewardList)
    end

    if self.luckDrawTipList and #self.luckDrawTipList > 0 then
        SoundManager:playSoundByType(SoundType.LUCKPLATETRUNOK)
        GlobalEventSystem:dispatchEvent(LuckDrawEvent.LUCKDRAW_TIP_UPDATE, {list = self.luckDrawTipList,isLate = 0})
        self.luckDrawTipList = nil
    end
    if self.rewardList then
        local value = self.rewardList[#self.rewardList]
        if value then
            if self.showCompleteItem ~= nil then
                self.showCompleteItem:destory()
                self.root:removeChild(self.showCompleteItem)
            end
            self.showCompleteItem = CommonItemCell.new()
            self.showCompleteItem :setData({goods_id = value.goods_id, is_bind = value.is_bind, num = value.num})
            self.showCompleteItem :setCount(value.num)
            self.root:addChild(self.showCompleteItem)
            self.showCompleteItem:setPosition(189,241)
        end
    end
end

function LuckDrawWin:luckDrawTip(data)
    if data.data.isLate == 1 then
        if data.data.list and #data.data.list>0 then
            self.luckDrawTipList = data.data.list
        end
        return
    end
    for i=1,#data.data.list do
        table.insert(self.turnTipLabData,1,data.data.list[i])
    end
    if #self.turnTipLabData > 20 then
        for i=#self.turnTipLabData,20,-1 do
            table.remove(self.turnTipLabData,i)
        end
    end
    if self.turnTipLab == nil then

        self.turnTipLab = {}
        for i=1,20 do
            local item = self.ListView_25:newItem()
            local lab = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'></font>")
            item:addContent(lab)
             item:setItemSize(250, 25)
            self.ListView_25:addItem(item)
            table.insert(self.turnTipLab,lab)
        end
    end
    local tips = ""
    local len = math.max(math.min(#self.turnTipLabData,20),1)
    for i=1,len+1 do
        local obj = self.turnTipLabData[i]
        if obj and self.turnTipLab[i] then
            --and self.prizeList[obj.goods_id]
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
            self.turnTipLab[i]:renderXml(tips)
            self.turnTipLab[i]:setVisible(true)
        end
    end
    for i=len+1,21 do
        if self.turnTipLab[i] then
            self.turnTipLab[i]:setVisible(false)
        end
    end
    -- -- self:addChild(self.turnTipLab)
    -- -- self.turnTipLab:setAnchorPoint(0,-1)
    -- self.turnTipLab:setPosition(0,210)
    -- self.turnTipLab:renderXml(tips)
    -- --dump(self.turnTipLab:getContentSize())
    -- self.Image_27:setContentSize(400,210)

    --self.turnTipLab:setPosition(0,0)

    self.ListView_25:reload()

end

local function _removeEvent(self)
    if self.luckDrawGetEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.luckDrawGetEventId)
        self.luckDrawGetEventId = nil
    end
    if self.luckDrawTipEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.luckDrawTipEventId)
        self.luckDrawTipEventId = nil
    end

    if self.wealthChangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.wealthChangEventId)
        self.wealthChangEventId = nil
    end

    if self.showCompleteItem ~= nil then
        self.showCompleteItem:destory()
        self.root:removeChild(self.showCompleteItem)
    end
    

    if self.timerId then
            GlobalTimer.unscheduleGlobal(self.timerId)
            self.timerId = nil
    end
end

function LuckDrawWin:close()
    self:showGetPropAndEquip()
    _removeEvent(self)
    GameNet:sendMsgToSocket(36003)
    LuckDrawWin.super.close(self)

end

function LuckDrawWin:showReward(data)
    if self.rewardWin == nil then
        self.rewardWin = import("app.modules.luckDraw.LuckDrawRewardWin").new()
        self:addChild(self.rewardWin)
    end
    self.rewardWin:setVisible(true)
    self.rewardWin:open(data)
end

--清理界面
function LuckDrawWin:destory()
    _removeEvent(self)
	LuckDrawWin.super.destory(self)
	 
end

return LuckDrawWin