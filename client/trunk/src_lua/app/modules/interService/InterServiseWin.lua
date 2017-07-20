--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-04 15:34:06
-- 跨服Boss
local InterServiseWin = class("InterServiseWin", BaseView)
function InterServiseWin:ctor(winTag,data,winconfig)
    InterServiseWin.super.ctor(self,winTag,data,winconfig)
    
    self.time1 = self:seekNodeByName("time1")
    self.time2 = self:seekNodeByName("time2")
    self.goBtn1 = self:seekNodeByName("goBtn1")

    self.time3 = self:seekNodeByName("time3")
    self.time4 = self:seekNodeByName("time4")
    self.goBtn2 = self:seekNodeByName("goBtn2")
    self.tipsLabel2 = self:seekNodeByName("tipsLabel2")--开服7天后开启

    -- 跨服幻境之城
    self.time5 = self:seekNodeByName("time5")
    self.time6 = self:seekNodeByName("time6")
    self.goBtn3 = self:seekNodeByName("goBtn3")

   
    self.goBtn1:setTouchEnabled(true)
    self.goBtn1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn1:setScale(1.1)
        elseif event.name == "ended" then
            self.goBtn1:setScale(1)
            self:gotoActicity(7)
        end
        return true
    end)
    self.goBtn2:setTouchEnabled(true)
    self.goBtn2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn2:setScale(1.1)
        elseif event.name == "ended" then
            self.goBtn2:setScale(1)
            self:gotoActicity(8)
        end
        return true
    end)

    -- 跨服幻境之城
    self.goBtn3:setTouchEnabled(true)
    self.goBtn3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn3:setScale(1.1)
        elseif event.name == "ended" then
            self.goBtn3:setScale(1)
            self:gotoActicity(12)
        end
        return true
    end)

    --self.rewardLayer = self:seekNodeByName("rewardLayer")
    
end

function InterServiseWin:sendData(times)
    GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(31002)})
    -- local jingbi = RoleManager:getInstance().wealth.coin
    -- local needMoney = 0
    -- if times == 1 then
    --     needMoney = 100000
    -- elseif times == 10 then
    --     needMoney = 1000000
    -- end
    -- if jingbi >= needMoney then
    --     local bagnum = BagManager:getInstance():getBagRemain()
    --     if bagnum <= 0 then
    --         GlobalMessage:show("背包已满！")
    --     else
    --         if self.isRurnPlateRun then
    --             GlobalMessage:show("正在抽奖中，请稍候！")
    --         else
    --             GameNet:sendMsgToSocket(36001,{num = times})
    --         end
    --     end
    -- else
    --     GlobalMessage:show("金币不足！")
    -- end
end

function InterServiseWin:gotoActicity(ctype)
    if ctype == 7 then
        -- if self.curServerDragonView == nil then
        --     self.curServerDragonView = import("app.modules.interService.ServerDragonView").new()
        --     self:addChild(self.curServerDragonView)
        -- end
        -- self.curServerDragonView:open()
        GlobalWinManger:openWin(WinName.KFHLSDWEEKWIN)
    elseif ctype == 8 then       
        GlobalWinManger:openWin(WinName.SERVERDARKWIN,3)
    elseif ctype == 9 then
        if self.curServerLuangdou == nil then
            self.curServerLuangdou = import("app.modules.interService.ServerLuangdou").new()
            self:addChild(self.curServerLuangdou)
        end
        self.curServerLuangdou:open()
    elseif ctype == 12 then
        -- 跨服幻境之城
        GlobalWinManger:openWin(WinName.DREAMLANDWIN)
    end

end


function InterServiseWin:open()
    InterServiseWin.super.open(self)

    self.activity7 = configHelper:getDarkHouseGoods(7)
    self.activity8 = configHelper:getDarkHouseGoods(8)
    self.activity9 = configHelper:getDarkHouseGoods(9)

    self.activity12 = configHelper:getDarkHouseGoods(12) or {}

    self.time1:setString(self.activity7.open_time1)
    self.time2:setString(self.activity7.open_time2)

    self.time3:setString(self.activity8.open_time1)
    self.time4:setString(self.activity8.open_time2)

    -- 跨服幻境之城 读取配置 dark_palace.xml中id=12字段open_time1,open_time2
    self.time5:setString(self.activity12.open_time1 or "") 
    self.time6:setString(self.activity12.open_time2 or "")
  
    -- self.prizeList = configHelper:getDarkHouseGoods(7).drop_list
    -- self.prizeListItem = {}

    -- for i=1,#self.prizeList do
    --     local item = self.prizeListItem[i]
    --     if item == nil then
    --         item = CommonItemCell.new()
    --         self.rewardLayer:addChild(item)
    --         self.prizeListItem[i] = item
    --     end
    --     local d = self.prizeList[i]
    --     item:setData({goods_id = d[1], is_bind = d[2], num = d[3]})
    --     item:setCount(d.num)
    --     item:setPosition(90*i,50)
    -- end
    GameNet:sendMsgToSocket(10018)
    if self.serverOpenTimeEventId == nil then
        self.serverOpenTimeEventId = GlobalEventSystem:addEventListener(GlobalEvent.GET_SERVER_TIME,handler(self,self.setServerOpenTime))
    end
end

function InterServiseWin:setServerOpenTime(data)
    self.serverOpenTime = data.data.open_days
    --if self.serverOpenTime >
    if 8 - self.serverOpenTime <=0 then
         self.goBtn2:setVisible(true)
         self.tipsLabel2:setVisible(false)
         --self.tipsLabel2:setString("开服"..(8 - self.serverOpenTime).."天后开启")
    else
         self.goBtn2:setVisible(false)
         self.tipsLabel2:setVisible(true)
         self.tipsLabel2:setString(""..(8 - self.serverOpenTime).."天后开启")
    end
end

local function _removeEvent(self)
    if self.serverOpenTimeEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.serverOpenTimeEventId)
        self.serverOpenTimeEventId = nil
    end
end

function InterServiseWin:close()
    _removeEvent(self)
    
    InterServiseWin.super.close(self)

end



--清理界面
function InterServiseWin:destory()
    _removeEvent(self)
    InterServiseWin.super.destory(self)
    
end

return InterServiseWin