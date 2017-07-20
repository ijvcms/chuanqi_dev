--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 元宝转盘
local luckTurnPlate2Win = class("luckTurnPlate2Win", BaseView)
function luckTurnPlate2Win:ctor(winTag,data,winconfig)
	luckTurnPlate2Win.super.ctor(self,winTag,data,winconfig)
    self.root:setPosition((display.width-740)/2,(display.height-500)/2+50)

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

    self.helpBtn = self:seekNodeByName("helpBtn")
    self.helpBtn:setTouchEnabled(true)
    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.helpBtn:setScale(1.0)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(31),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)

    self.angleList = {0,72,144,216,288}
    self.selectBg = self:seekNodeByName("core")

    self.item1 = self:seekNodeByName("item1")
    self.item2 = self:seekNodeByName("item2")
    self.item3 = self:seekNodeByName("item3")
    self.item4 = self:seekNodeByName("item4")
    self.item5 = self:seekNodeByName("item5")

    self.timeLabel = self:seekNodeByName("timeLabel")
    self.ecpectNum = self:seekNodeByName("expectNum")
    self.toltalNum = self:seekNodeByName("toltalNum")
    self.timesNum = self:seekNodeByName("timesNum")

    self.clickBtn = self:seekNodeByName("clickBtn")
    --self.priceLabel = self:seekNodeByName("priceLabel")
    self.tipsLabel = self:seekNodeByName("tipsLabel")
    
  	self.data = data

    self.clickBtn:setTouchEnabled(true)
    self.clickBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.clickBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.clickBtn:setScale(1.0)
            if self.isRurnPlateRun then
                GlobalMessage:show("抽奖中，请稍候")
            else
                self:sendData()
            end
            --self:gotoItem(4)
        end     
        return true
    end)

    --self:sendData(1)

    self.curTurnIndex = 1
    self.isRurnPlateRun = false

    self.timesOne = 20
    self.timesTen = 180

    self.beginTime = 0
    self.endTime = 0

    --new
    self.left_time = 0
    self.left_times = 0
    self.next_key = 1

    self.curkey = 1
    self.conf = nil
    self.curTime = os.time()

    self.getJade = 0
end

--发送抽奖
function luckTurnPlate2Win:sendData()
    if os.time() - self.curTime < 1 then
         GlobalMessage:show("请稍候，你点击太频繁！")
        return
    end
    self.curTime = os.time()
    local yuanbao = RoleManager:getInstance().wealth.jade
    local needMoney = self.conf.price
    if yuanbao >= needMoney then
        if self.isRurnPlateRun then
            --GlobalMessage:show("正在抽奖中，请稍候！")
            self:stopPlayTurn()
        else
            GameNet:sendMsgToSocket(35009)
        end
    else
        GlobalMessage:show("元宝不足！")
    end
end


--转盘转动
function luckTurnPlate2Win:gotoItem(endValue)
    local curIndex = self.curTurnIndex
    local endIndex = endValue
    local indexLen = endIndex + 5*10
    endIndex = indexLen

    self.angleIndexList = {}
    for i=curIndex,endIndex do
        local len = i-(curIndex+8)
        if len >= 0 then
          len = endIndex - i-8
        end
        if len >= 0 then
          len = 0
        end
        len = 0-len
        for l=1,len*2+1 do
            table.insert(self.angleIndexList,{self.angleList[(i-1)%5+1],(i-1)%5+1,endIndex})
        end
    end
    if self.timerId == nil then
        self.isRurnPlateRun = true
        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.playTurn),0.02)--GlobalTimer.scheduleUpdateGlobal(handler(self,self.playTurn))
    end
    -- if self.timerId then
    --     GlobalTimer.unscheduleGlobal(self.timerId)
    --     self.timerId = nil
    -- end
end
function luckTurnPlate2Win:stopPlayTurn()
    if #self.angleIndexList > 1 then
        for i=1,#self.angleIndexList-1 do
            table.remove(self.angleIndexList,1)
        end
    end 
    self:playTurn()
end
function luckTurnPlate2Win:playTurn()
    local value = table.remove(self.angleIndexList,1)
    if value then
        if value[2] ~= self.curTurnIndex then
            SoundManager:playSoundByType(SoundType.LUCKPLATETRUN)
        end
        if value[1] == nil then
            dump(value)
        end
        self.selectBg:setRotation(value[1])
        self.curTurnIndex = value[2]
    end
    if #self.angleIndexList <= 0 then
        if self.timerId then
            self.isRurnPlateRun = false
            --self:showGetPropAndEquip()
            GlobalTimer.unscheduleGlobal(self.timerId)
            self.timerId = nil
            self:showTips(self.getJade)
        end
        return
    end
end

function luckTurnPlate2Win:showTips(jade)
    if jade > 0 then
        GameNet:sendMsgToSocket(35008)
        SystemNotice:popAttValueTips(self.getJade,BPTIPS_TYPE_JADE)
        self.getJade = 0
    end
end

--打开
function luckTurnPlate2Win:open()
    luckTurnPlate2Win.super.open(self)
    self.isRurnPlateRun = false

    self.turnTipLabData = {}

    if self.turnPlateGetEventId == nil then
        self.turnPlateGetEventId = GlobalEventSystem:addEventListener(LuckTurnPlate2Event.TURNPLATE2_GET,handler(self,self.turnPlatePlay))
    end
    if self.turnPlateTipEventId == nil then
        self.turnPlateTipEventId = GlobalEventSystem:addEventListener(LuckTurnPlate2Event.TURNPLATE2_TIP_UPDATE,handler(self,self.turnPlateTip))
    end
    if self.turnPlateInitEventId == nil then
        self.turnPlateInitEventId = GlobalEventSystem:addEventListener(LuckTurnPlate2Event.TURNPLATE2_TIP_INIT,handler(self,self.turnPlateInit))
    end

    local config = configHelper:getLotteryCarnivalConfig(RoleManager:getInstance().roleInfo.vip+1)
    if config == nil then
        config = configHelper:getLotteryCarnivalConfig(RoleManager:getInstance().roleInfo.vip)
        self.tipsLabel:setString("已经获取所有次数")
    else
         self.tipsLabel:setString(config.tips)
    end

    self.selectBg:setRotation(self.angleList[self.curTurnIndex])
    GameNet:sendMsgToSocket(35008)
end

--初始化
function luckTurnPlate2Win:turnPlateInit(data)
    data = data.data
    self.left_time = data.left_time
    self.left_times = data.left_times
    self.next_key = data.next_key
    self.sum_jade = data.sum_jade
    self.curkey = self.next_key

    self:updataView()
end
--请求抽奖返回
function luckTurnPlate2Win:turnPlatePlay(data) 
    data = data.data
    self.playkey = 6-data.pos

    self.getJade = data.jade
    --self.weight = data.weight
--
    --self.left_time = data.left_time
   -- self.next_key = data.next_key
    --self.sum_jade = data.sum_jade
    --self:updataView()
    self:gotoItem(self.playkey)
end

--更新显示视图
function luckTurnPlate2Win:updataView()
    self.conf  = configHelper:getLotteryCarnivalConfig(self.next_key)

    self.timeLabel:setString(StringUtil.GetMiaoNumToDayHours(self.left_time))
    self.ecpectNum:setString(self.conf.most_coin)

    self.toltalNum:setString(self.sum_jade)
    self.timesNum:setString(self.left_times)
    self.clickBtn:setButtonLabelString(self.conf.btn_des)
    --self.priceLabel = self:seekNodeByName("priceLabel")
    
    if self.left_times <= 0 then
        self.clickBtn:setButtonEnabled(false)
    else
        self.clickBtn:setButtonEnabled(true)
    end
end

--关闭
function luckTurnPlate2Win:close()
     luckTurnPlate2Win.super.close(self)
    if self.turnPlateGetEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.turnPlateGetEventId)
        self.turnPlateGetEventId = nil
    end
    if self.turnPlateTipEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.turnPlateTipEventId)
        self.turnPlateTipEventId = nil
    end

    if self.turnPlateInitEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.turnPlateInitEventId)
        self.turnPlateInitEventId = nil
    end
    if self.timerId then
        GlobalTimer.unscheduleGlobal(self.timerId)
        self.timerId = nil
    end
end

--清理界面
function luckTurnPlate2Win:destory()
    self:close()
	luckTurnPlate2Win.super.destory(self)
	
end

return luckTurnPlate2Win