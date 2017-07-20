--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 16:18:25
-- 合服首冲礼包
local mergeChargeWin = mergeChargeWin or class("mergeChargeWin", BaseView)

function mergeChargeWin:ctor(winTag,data,winconfig)
    self.data = data
	  mergeChargeWin.super.ctor(self,winTag,data,{url = "resui/"..data.viewType..".ExportJson"})
   	self.root:setPosition(0,0)
    
    self.itemLayer = self:seekNodeByName("itemLayer")
    self.timeLabel = self:seekNodeByName("timeLabel")

    self.goBtn = self:seekNodeByName("goBtn")
  	self.goBtn:setTouchEnabled(true)
  	self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.goBtn:setScale(1)

            if self.btnStates == 0 then
                GlobalController.mergeActivity:send38013(self.active_service_id,self.data.id)
                --self.goBtn:setButtonLabelString("领取")
            elseif self.btnStates == 1 then
                GlobalWinManger:openWin(WinName.RECHARGEWIN)
                --self.goBtn:setButtonLabelString("前往充值")
            elseif self.btnStates >= 2 then
                GlobalMessage:show("已经领取")
                --self.goBtn:setButtonLabelString("已经领取")
            end
        end
        return true
  	end)
    self.listItem = {}
end

function mergeChargeWin:update()
    -- 0可以领取1,未达到条件，2，已经领取，3，已经领取完了"/>
    self.serverData = MergeActivityModel:getInstance():getActivityTypeData(self.data.id)
    self.btnStates = self.serverData.active_service_list[1].is_receive
    self.active_service_id = self.serverData.active_service_list[1].active_service_id
    if #self.listItem == 0 then
        local itemDatalist =  configHelper:getActiveServiceMerge(self.active_service_id)["reward_"..RoleManager:getInstance().roleInfo.career]
        for i=1,math.min(#itemDatalist,6) do
            local item = self.listItem[i]
            if item == nil then
                item = CommonItemCell.new()
                self.itemLayer:addChild(item)
                self.listItem[i] = item
            end
            local d = itemDatalist[i]
            --110140,1,3
            item:setData({goods_id = d[1], is_bind = d[2], num = d[3]})
            item:setCount(d[3])
            item:setPosition(85*i,60)
        end
    end
    if self.btnStates == 0 then
        self.goBtn:setButtonLabelString("领取")
        self.goBtn:setButtonEnabled(true)
    elseif self.btnStates == 1 then
        self.goBtn:setButtonLabelString("前往充值")
        self.goBtn:setButtonEnabled(true)
    elseif self.btnStates >= 2 then
        self.goBtn:setButtonLabelString("已领取")
        self.goBtn:setButtonEnabled(false)
    end

    --self.timeLabel = self:seekNodeByName("timeLabel")
    self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",self.serverData.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",self.serverData.end_time))

end

function mergeChargeWin:getMergePrizeSuccess(data)
    if data.data == self.active_service_id then
        self.serverData.active_service_list[1].is_receive = 2
        self:update()
    end
end

function mergeChargeWin:open()
    mergeChargeWin.super.open(self)
    if self.getMergePrizeSuccessEventId == nil then
        self.getMergePrizeSuccessEventId = GlobalEventSystem:addEventListener(MergeActivityEvent.GET_MERGE_PRIZE_SUCCESS,handler(self,self.getMergePrizeSuccess))
    end
end

function mergeChargeWin:close()
    mergeChargeWin.super.close(self)
    if self.getMergePrizeSuccessEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.getMergePrizeSuccessEventId)
        self.getMergePrizeSuccessEventId = nil
    end
end

function mergeChargeWin:destory()
    self:close()
    mergeChargeWin.super.destory(self)
    for k,v in pairs(self.listItem or {}) do
        v:destory()
        self.listItem[k] = nil
    end
end

return mergeChargeWin
