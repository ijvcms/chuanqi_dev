local LocalDatasManager = require("common.manager.LocalDatasManager")
local BarWidget    = import(".BarWidget")
local DrugListView = import(".DrugListView")
local DrugView = class("DrugView", function()
    return display.newNode()
end)

local ConfirmOps = {
    [1]  = GUIOP.CLICK_SYS_OP_DRUG_BTN1,
    [2]  = GUIOP.CLICK_SYS_OP_DRUG_BTN2,
    [3]  = GUIOP.CLICK_SYS_OP_DRUG_BTN3,
    [4]  = GUIOP.CLICK_SYS_OP_DRUG_BTN4
}

DrugView.drugListView = nil

function DrugView:ctor()
    -- self.localData = LocalDatasManager:getLocalData("autoDrug")
    -- self.localData = self.localData==nil and {} or self.localData
    -- 改为后端下发自动喝药配置
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    self.localData = roleInfo.autoDrugOption
 
    local info = LocalDatasManager:getLocalData("QUICK_USE_GOODS")
    -- 
    if info then
        self.localData["drugType"..4] = info.id
    end

    local win = cc.uiloader:load("resui/SOW_Drug.ExportJson")
    self:addChild(win)
    -- --回血开关
    -- self.switch1 = cc.uiloader:seekNodeByName(win,"switch1")
    
    -- --瞬回开关
    -- self.switch2 = cc.uiloader:seekNodeByName(win,"switch2")

    --血百分比label
    local labRedPercent = cc.uiloader:seekNodeByName(win,"labRedPercent")
    labRedPercent:setString("0%")

    --蓝百分比label
    local labBluePercent = cc.uiloader:seekNodeByName(win,"labBluePercent")
    labBluePercent:setString("0%")

    --瞬回百分比label
    local labMomentPercent = cc.uiloader:seekNodeByName(win,"labMomentPercent")
    labMomentPercent:setString("0%")

    self.drugItemBgs = {}
    --红药itemBg
    self.redDrugItemBg = cc.uiloader:seekNodeByName(win,"redDrugItemBg")
    local redDrugTouchLayer = display.newLayer()
    redDrugTouchLayer:setContentSize(self.redDrugItemBg:getContentSize())
    self.redDrugItemBg:addChild(redDrugTouchLayer)
    redDrugTouchLayer:setTouchEnabled(true)
    redDrugTouchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:showDrugList(1,self.redDrugItemBg)
        end     
        return true
    end)
    table.insert(self.drugItemBgs,self.redDrugItemBg)

    --蓝药itemBg 
    self.blueDrugItemBg = cc.uiloader:seekNodeByName(win,"blueDrugItemBg")
    local blueDrugTouchLayer = display.newLayer()
    blueDrugTouchLayer:setContentSize(self.blueDrugItemBg:getContentSize())
    self.blueDrugItemBg:addChild(blueDrugTouchLayer)
    blueDrugTouchLayer:setTouchEnabled(true)
    blueDrugTouchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:showDrugList(2,self.blueDrugItemBg)
        end     
        return true
    end)
    table.insert(self.drugItemBgs,self.blueDrugItemBg)

    --瞬回药itemBg
    self.momentDrugItemBg = cc.uiloader:seekNodeByName(win,"momentDrugItemBg")
    local momentDrugTouchLayer = display.newLayer()
    momentDrugTouchLayer:setContentSize(self.momentDrugItemBg:getContentSize())
    self.momentDrugItemBg:addChild(momentDrugTouchLayer)
    momentDrugTouchLayer:setTouchEnabled(true)
    momentDrugTouchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:showDrugList(3,self.momentDrugItemBg)
        end     
        return true
    end)
    table.insert(self.drugItemBgs,self.momentDrugItemBg)


     --快速药itemBg
    self.quickDrugItemBg = cc.uiloader:seekNodeByName(win,"quickDrugItemBg")
    local quickDrugTouchLayer = display.newLayer()
    quickDrugTouchLayer:setContentSize(self.momentDrugItemBg:getContentSize())
    self.quickDrugItemBg:addChild(quickDrugTouchLayer)
    quickDrugTouchLayer:setTouchEnabled(true)
    quickDrugTouchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:showDrugList(4,self.quickDrugItemBg)
        end     
        return true
    end)
    table.insert(self.drugItemBgs,self.quickDrugItemBg)


    for i=1,#self.drugItemBgs do
        BaseTipsBtn.new(BtnTipsType["BIN_AUTO_DRINK"..i],self.drugItemBgs[i], 70,70)
    end

    --红滑动条
    local redBar = BarWidget.new(422,18,1)
    redBar:setPosition(482,397)
    redBar:setListener(function(percent)
        labRedPercent:setString(math.ceil(percent).."%")
        self.localData.redBarPercent = math.ceil(percent)
    end)
    self:addChild(redBar)
    self.redBar = redBar

    --蓝滑动条
    local blueBar = BarWidget.new(422,18,2)
    blueBar:setPosition(482,290)
    blueBar:setListener(function(percent)
        labBluePercent:setString(math.ceil(percent).."%")
        self.localData.blueBarPercent = math.ceil(percent)
    end)
    self:addChild(blueBar)
    self.blueBar = blueBar

    --瞬回滑动条
    local momentBar = BarWidget.new(422,18,1)
    momentBar:setPosition(482,184)
    momentBar:setListener(function(percent)
        labMomentPercent:setString(math.ceil(percent).."%")
        self.localData.momentBarPercent = math.ceil(percent)
    end)
    self:addChild(momentBar)
    self.momentBar = momentBar

    --初始化滑动条
    self:initBar()

    --初始化开关状态
    -- self:initSwitch()

    --初始化选择药品
    self:initDrugItem()

    --node event
    self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))


end

function DrugView:open(data)
    GlobalController.bag:updateAutoDrug()
end

function DrugView:onNodeEvent(data)
    if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
        self:unregisterEvent()
        -- 保存自动喝药配置到userDefault
        -- LocalDatasManager:saveLocalData(self.localData,"autoDrug")
        -- GlobalEventSystem:dispatchEvent(AutoDrugEvent.AUTO_DRUG_DATA_CHANGE)
        -- 发送保存自动喝药配置协议
        local data = {
            hp_set = {
                isuse = self.localData.normalDrug,               --是否开启自动喝药
                hp = self.localData.redBarPercent or 0,          --红百分比
                hp_goods_id = self.localData.drugType1 or 0,     --红药id
                mp = self.localData.blueBarPercent or 0,         --蓝百分比
                mp_goods_id = self.localData.drugType2 or 0,     --蓝药id
            },
            hpmp_set = {
                isuse = self.localData.momentDrug,               --是否开启自动喝瞬回药
                hp = self.localData.momentBarPercent or 0,       --瞬回药百分比
                hp_mp_goods_id = self.localData.drugType3 or 0,  --瞬回药id
            }
        }
        GameNet:sendMsgToSocket(22000, data)
    --设置快速使用喝药
         local data = {
           id =  self.localData.drugType4
        }
        
        if data.id then
            LocalDatasManager:saveLocalData(data, "QUICK_USE_GOODS")
            GlobalEventSystem:dispatchEvent(BagEvent.QUICK_USE_CHANGE, data.id)
        end
    
    end
end

function DrugView:registerEvent()
    self.registerEventId = {}
    --自动喝药的药品改变
    local function onDrugIdChange(data)
       --药品类型 1红，2蓝，3瞬回，4快速
       local drugType = data.data.drugType
       local drugId = data.data.id
       self.localData["drugType"..drugType] = drugId

       if drugId and drugId ~= 0 then
            BtnTipManager:setKeyValue(BtnTipsType["BIN_AUTO_DRINK"..drugType], 0)
        else
            BtnTipManager:setKeyValue(BtnTipsType["BIN_AUTO_DRINK"..drugType], 1)
        end

       if drugType == 1 then
            if self.redDrugItemBg:getChildByTag(10) then
                self.redDrugItemBg:getChildByTag(10):setItemClickFunc(function()
                    self:showDrugList(1,self.redDrugItemBg)
                    end)
            end
        elseif drugType == 2 then
            if self.blueDrugItemBg:getChildByTag(10) then
                self.blueDrugItemBg:getChildByTag(10):setItemClickFunc(function()
                    self:showDrugList(2,self.blueDrugItemBg)
                    end)
            end
        elseif drugType == 3 then
            if self.momentDrugItemBg:getChildByTag(10) then
                self.momentDrugItemBg:getChildByTag(10):setItemClickFunc(function()
                    self:showDrugList(3,self.momentDrugItemBg)
                    end)
            end
        elseif drugType == 4 then
            if self.quickDrugItemBg:getChildByTag(10) then
                self.quickDrugItemBg:getChildByTag(10):setItemClickFunc(function()
                    self:showDrugList(4,self.quickDrugItemBg)
                    end)
            end
       end

    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(AutoDrugEvent.AUTO_DRUG_ID_CHANGE, onDrugIdChange)
end

function DrugView:unregisterEvent()
    if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function DrugView:showDrugList(drugType,obj)
    local node = DrugListView.new(drugType,obj)
    node:setCloseCallback(function()
        self.drugListView = nil
    end)
    self.drugListView = node
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
    GlobalController.guide:notifyEventWithConfirm(ConfirmOps[drugType])
end

function DrugView:initDrugItem()
    local bagManager = BagManager:getInstance()
    for i=1,4 do
        local drugId = self.localData["drugType"..i]
        if drugId ~= nil then
            if tonumber(drugId) >0 and tonumber(bagManager:findItemCountByItemId(drugId)) > 0 then
                if self.drugItemBgs[i]:getChildByTag(10) then
                    self.drugItemBgs[i]:removeChildByTag(10)
                end
                local item = CommonItemCell.new()
                item:setData({goods_id=drugId})
                item:setPosition(self.drugItemBgs[i]:getContentSize().width/2,self.drugItemBgs[i]:getContentSize().height/2)
                item:setTouchEnabled(false)
                item:setTouchSwallowEnabled(false)
                local count = bagManager:findItemCountByItemId(drugId)
                item:setCount(count)
                item:setCountVisible(true)
                self.drugItemBgs[i]:addChild(item)
                item:setTag(10)
            end
        end
    end

end

function DrugView:initBar()
    local redBarPercent = self.localData.redBarPercent
    local blueBarPercent = self.localData.blueBarPercent
    local momentBarPercent = self.localData.momentBarPercent
    self.redBar:setPercent(redBarPercent or 0)
    self.localData.redBarPercent = redBarPercent or 0
    self.blueBar:setPercent(blueBarPercent or 0)
    self.localData.blueBarPercent = blueBarPercent or 0
    self.momentBar:setPercent(momentBarPercent or 0)
    self.localData.momentBarPercent = momentBarPercent or 0
end

-- function DrugView:initSwitch()
--     local open1 = self.localData.normalDrug
--     local open2 = self.localData.momentDrug
--     if open1==1 then self:openSwitch(1) else self:closeSwitch(1) end  
--     if open2==1 then self:openSwitch(2) else self:closeSwitch(2) end  
--     local switch1TouchLayer = display.newLayer()
--     switch1TouchLayer:setContentSize(self.switch1:getContentSize())
--     self.switch1:addChild(switch1TouchLayer)
--     switch1TouchLayer:setTouchEnabled(true)
--     switch1TouchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
--         if event.name == "began" then
--             SoundManager:playClickSound()
--         elseif event.name == "ended" then
--             self:mutexSwitch(1)
--         end     
--         return true
--     end)
--     local switch2TouchLayer = display.newLayer()
--     switch2TouchLayer:setContentSize(self.switch2:getContentSize())
--     self.switch2:addChild(switch2TouchLayer)
--     switch2TouchLayer:setTouchEnabled(true)
--     switch2TouchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
--         if event.name == "began" then
--             SoundManager:playClickSound()
--         elseif event.name == "ended" then
--             self:mutexSwitch(2)
--         end     
--         return true
--     end)
-- end

-- function DrugView:mutexSwitch(switchIndex)
--     local switch = switchIndex==1 and self.switch1 or self.switch2
--     switch:getChildByTag(10):setPositionX(switch:getChildByTag(10):getPositionX() == 0 and switch:getContentSize().width or 0)
--     if switch:getChildByTag(10):getPositionX() == 0 then
--         self:closeSwitch(switchIndex)
--     else
--         self:openSwitch(switchIndex)
--     end
-- end

-- function DrugView:closeSwitch(switchIndex)
--     local switch = switchIndex==1 and self.switch1 or self.switch2
--     switch:getChildByTag(10):setPositionX(0)
--     if switchIndex == 1 then
--         self.localData.normalDrug = 0
--     else
--         self.localData.momentDrug = 0
--     end
-- end

-- function DrugView:openSwitch(switchIndex)
--     local switch = switchIndex==1 and self.switch1 or self.switch2
--     switch:getChildByTag(10):setPositionX(switch:getContentSize().width)
--     if switchIndex == 1 then
--         self.localData.normalDrug = 1
--     else
--         self.localData.momentDrug = 1
--     end
-- end


function DrugView:destory()
    if self.drugListView then
        if self.drugListView.onCloseClick and self.drugListView:getParent()  then
            self.drugListView:getParent():removeChild(self.drugListView)
        end
        self.drugListView = nil
    end
end

return DrugView