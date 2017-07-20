--
-- Author: zhangshunqiu
-- Date: 2015-02-09 17:41:46
-- 限时活动
local TimeActivityWin = class("TimeActivityWin", BaseView)

function TimeActivityWin:ctor(winTag,data,winconfig)
	TimeActivityWin.super.ctor(self,winTag,data,winconfig)
    self.mainLayer = self:seekNodeByName("mainLayer")
    self.desLabel = self:seekNodeByName("desLabel")
    self.goBtn = self:seekNodeByName("goBtn")
    self.titleTxt = self:seekNodeByName("titleTxt")

    self.Tag1 = self:seekNodeByName("Tag1")
    self.selected1 = self:seekNodeByName("selected1")-- 所有
    self.Tag1:setTouchEnabled(true)
    self.Tag1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            --self:setTabIndex(1)
            self:setTabIndex(2)
        end     
        return true
    end)

    self.Tag2 = self:seekNodeByName("Tag2")
    self.selected2 = self:seekNodeByName("selected2") --本服
    self.Tag2:setTouchEnabled(true)
    self.Tag2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:setTabIndex(2)
        end     
        return true
    end)
    self.Tag2:setVisible(false)

    self.Tag3 = self:seekNodeByName("Tag3")
    self.selected3 = self:seekNodeByName("selected3") --跨服
    self.Tag3:setTouchEnabled(true)
    self.Tag3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:setTabIndex(3)
        end     
        return true
    end)
    self.Tag3:setVisible(false)


    self.curSelectIndex = 0

    self.goBtn:setTouchEnabled(true)
    self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.goBtn:setScale(1)
            GlobalWinManger:closeWin(self.winTag)
            self:onGoClick()
        end
        return true
    end)

    self.prizeItem = {}

    for i=1,6 do
    	self["item"..i] = self:seekNodeByName("Item"..i)

    	local item = CommonItemCell.new()
    	self.prizeItem[i] = item
	    self["item"..i]:addChild(item)
	    -- self.item:setData({goods_id = goods[1], is_bind = goods[2], num = goods[3]})
	    -- self.item:setCount(goods[3])
	    item:setPosition(38,38)
    end

    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 600, 400),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png" }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)
    self.itemList = {}

    self.isCancelRemoveSpriteFrams = true
end

function TimeActivityWin:touchListener(event)
    if "clicked" == event.name then
    	self:setSelectItem(event.itemPos)
    end
end

function TimeActivityWin:onGoClick()
	if self.curSelectItem == nil then return end
    local func_id = self.curSelectItem:getData().activity_id
    dump(func_id, "func_id")

    if func_id == 112 then 
        -- 跨服幻境之城
        GlobalWinManger:openWin(WinName.DREAMLANDWIN)
        return 
    end

    if func_id == 115 or func_id == 116 or func_id == 117 then 
        -- 本服幻境之城
        GlobalWinManger:openWin(WinName.DREAMLANDLOCALWIN)
        return 
    end

    if func_id == FUNC_OPID.OPEN_INTERSERVICE_DARK_WIN or func_id == FUNC_OPID.OPEN_KFAD_BEGIN_WIN or func_id == FUNC_OPID.OPEN_KFAD_JXZ_WIN or func_id == FUNC_OPID.OPEN_KFAD_WIN or func_id == FUNC_OPID.OPEN_KFAD_WIN2 or func_id == FUNC_OPID.OPEN_KFAD_WIN3 then
        GlobalWinManger:openWin(WinName.SERVERDARKWIN)
        return
    end

    if (func_id >= 103 and func_id <=105) or (func_id >= 109 and func_id <=111) then
        GlobalWinManger:openWin(WinName.HLSDWIN)
        return
    end
    if (func_id >= 106 and func_id <=108) then
        GlobalWinManger:openWin(WinName.KFHLSDWIN)
        return
    end
    if func_id == 81 then
        GlobalWinManger:openWin(WinName.KFHLSDWEEKWIN)
        return 
    end

	--local func_id = self.curSelectItem:getData().activity_id
	FunctionOpenManager:gotoFunctionById(func_id)

	-- GUIDE CONFIRM
	if func_id == FUNC_OPID.OPEN_QUALIFYING_WIN then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_QUALIFYING)
	end

	if func_id == FUNC_OPID.GOTO_FEAT_NPC then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_FEAT_TASK)
	end

	if func_id == FUNC_OPID.OPEN_WORLD_BOSS_WIN then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_WORLD_BOSS)
	end

	if func_id == FUNC_OPID.GOTO_DAILY_TASK_NPC then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_DAILY_TASK)
	end
end

--打开
function TimeActivityWin:setTabIndex(index)
    if not self.serverOpenTime then return end
    
    if self.curSelectIndex ~= index then
        self.curSelectIndex = index
        for i=1,3 do
            if i== self.curSelectIndex then
                self["selected"..i]:setVisible(true)
            else
                self["selected"..i]:setVisible(false)
            end
        end
        local config = configHelper:getActivity_limitConfig()
        local newList = {}
        local atype= self.curSelectIndex -1

        for i=1,#config do
            local dd = config[i]
            if atype == 0 or dd.type == atype then
                local isShow = true
                if dd.open_day > 0 and self.serverOpenTime < dd.open_day then
                    isShow = false
                end
                if isShow then
                    if dd.colse_day > 0 and self.serverOpenTime >= dd.colse_day then
                        isShow = false
                    end
                end
                if isShow then
                    table.insert(newList,dd)
                end
            end
        end

        self:updateList(newList)
    end
end

--打开
function TimeActivityWin:setSelectItem(index)
	local vo = nil
    local item = self.itemList[index]
    if not item then
        return
    end
    if self.curSelectItem  then
        self.curSelectItem:setSelect(false)
    end

    item:setSelect(true)
    if self.curSelectItem ~= item then
        vo = item:getData()
        self.curSelectItem = item
    end
    if vo then
        self.titleTxt:setString(vo.name)
    	self.desLabel:setString(vo.des)
        local dropList = vo["drop_list_"..RoleManager:getInstance().roleInfo.career]
    	for i=1,math.min(6,#dropList) do
    		local item = dropList[i]
    		self.prizeItem[i]:setData({goods_id = item[1], is_bind = item[2], num = item[3]})
    		-- self.item:setData({goods_id = goods[1], is_bind = goods[2], num = goods[3]})
	    	self.prizeItem[i]:setCount(item[3])
	    	self.prizeItem[i]:setVisible(true)
    	end
    	for i=#dropList+1,6 do
    		self.prizeItem[i]:setVisible(false)
    	end
        if vo.state == 0 or vo.state == 2 then
            self.goBtn:setVisible(false)
        else
            self.goBtn:setVisible(true)
        end
    end
end


--打开
function TimeActivityWin:open(data)
    GameNet:sendMsgToSocket(10018)
    -- if self.serverOpenTimeEventId == nil then
    --     self.serverOpenTimeEventId = GlobalEventSystem:addEventListener(GvgEvent.GVG_CHANG_TIME,handler(self,self.setServerOpenTime))
    -- end

    if self.serverOpenTimeEventId == nil then
        self.serverOpenTimeEventId = GlobalEventSystem:addEventListener(GlobalEvent.GET_SERVER_TIME,handler(self,self.setServerOpenTime))
    end
end

function TimeActivityWin:setServerOpenTime(data)
    if self.serverOpenTimeEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.serverOpenTimeEventId)
        self.serverOpenTimeEventId = nil
    end
    self.curOSTime = os.time()
    self.curServerTime = data.data.server_time --os.time()
    self.serverOpenTime = data.data.open_days

    if self.timerId == nil then
        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.updateActivityStates),3)--GlobalTimer.scheduleUpdateGlobal(handler(self,self.playTurn))
    end

    --self:setTabIndex(1)
    self:setTabIndex(2)
end

-- 更新Item状态
function TimeActivityWin:updateActivityStates()
    local date = os.date("*t", os.time()- self.curOSTime + self.curServerTime)
    for i=1,#self.itemList do
        self.itemList[i]:updateStates(date)
    end
end

-- 更新ITEM列表
function TimeActivityWin:updateList(data)
    local config = data or configHelper:getActivity_limitConfig()
    self.itemListView:removeAllItems()
    self.itemList= {}
    self.curSelectItem = nil
    local index = 0
    local temp = os.date("*t", os.time()- self.curOSTime + self.curServerTime)

    local beginIndex = 1
    local beginotype = 10
    for i=1,#config do
        local dd = config[i]
        local otype = self:getActivityOpenType(temp,dd)
        if beginotype > otype then
            beginotype = otype
            beginIndex = i
        end

    end
    local arr = {}
    for i=beginIndex,#config do
        table.insert(arr,config[i])
    end
    for i=1,beginIndex-1 do
        table.insert(arr,config[i])
    end



    if #self.itemList == 0 then
        local TimeActivityItem = require("app.modules.timeActivity.TimeActivityItem")
        -- local config = configHelper:getActivity_limitConfig()
        for i=1,#arr do
            local dd = arr[i]
            if arr[i].state ~= 0 then
                index= index +1
                local item = self.itemListView:newItem()
                local content = TimeActivityItem.new()
                content:setData(arr[i],temp)
                self.itemList[index] = content
                item:addContent(content)
                item:setItemSize(585, 46)
                self.itemListView:addItem(item)
            end
        end
        self.itemListView:reload()

        self:setSelectItem(1)
    end
end

function TimeActivityWin:getActivityOpenType(temp,vo)
    temp = temp or os.date("*t", os.time())
    if self:isdays(temp.wday,vo.open_week) == false then
        return 5
    elseif vo.state == 0 then
        return 6
    elseif StringUtil:isBeforecurTime(vo.tips_time,temp) == false and StringUtil:isBeforecurTime(vo.open_time,temp) then
            --self.state:setString("即将开始") --白
        return 2
    elseif StringUtil:isBeforecurTime(vo.open_time,temp)== false and  StringUtil:isBeforecurTime(vo.close_time,temp) then
        --self.state:setString("进行中") --绿
        return 1
    elseif StringUtil:isBeforecurTime(vo.close_time,temp) == false then
        --self.state:setString("已结束") --灰
        return 4
    elseif StringUtil:isBeforecurTime(vo.tips_time,temp) then
        --self.state:setString("未开始") --白
        return 3
    end

    return 7;
    -- if vo.state == 0 then
    --     --self.state:setString("敬请期待") --红
    --     return 6
    -- else
    --     if self:isdays(temp.wday,vo.open_week) then
    --         if StringUtil:isBeforecurTime(vo.tips_time,temp) == false and StringUtil:isBeforecurTime(vo.open_time,temp) then
    --             --self.state:setString("即将开始") --白
    --             return 2
    --         elseif StringUtil:isBeforecurTime(vo.open_time,temp)== false and  StringUtil:isBeforecurTime(vo.close_time,temp) then
    --             --self.state:setString("进行中") --绿
    --              return 1
    --         elseif StringUtil:isBeforecurTime(vo.close_time,temp) == false then
    --             --self.state:setString("已结束") --灰
    --              return 5
    --         else
    --             --self.state:setString("未开始") --白
    --             return 3
    --         end
    --     else
    --         --self.state:setString("未开始") --白
    --         return 4
    --     end
    -- end
end

--是否当天开放
function TimeActivityWin:isdays(osWeekid,days)
    osWeekid = osWeekid -1
    if osWeekid == 0 then
        osWeekid = 7
    end

    for i=1,#days do
        if days[i] == osWeekid then
            return true
        end
    end
    return false
end

--关闭
function TimeActivityWin:close()
    if self.timerId then
        GlobalTimer.unscheduleGlobal(self.timerId)
        self.timerId = nil
    end
    if self.serverOpenTimeEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.serverOpenTimeEventId)
        self.serverOpenTimeEventId = nil
    end
end 

--销毁
function TimeActivityWin:destory()
    self:close()
    self.super.destory(self)
end

return TimeActivityWin