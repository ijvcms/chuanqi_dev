--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 投资
local InvestWin = class("InvestWin", BaseView)
function InvestWin:ctor(winTag,data,winconfig)
	InvestWin.super.ctor(self,winTag,data,winconfig)
    self.root:setPosition((display.width-960)/2,(display.height-640)/2)

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
    self.tag1 = self:seekNodeByName("tag1")
    self.tag2 = self:seekNodeByName("tag2")

    self.label1 = self:seekNodeByName("label1")
    self.label2 = self:seekNodeByName("label2")

    self.priceLabel = self:seekNodeByName("priceLabel")

    self.buyBtn = self:seekNodeByName("buyBtn")

    self.timeLabel = self:seekNodeByName("timeLabel")

    self.titleBg = self:seekNodeByName("titleBg")

    self.mainLayer = self:seekNodeByName("mainLayer")
    
  	self.data = data

    self.buyBtn:setTouchEnabled(true)
    self.buyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.buyBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.buyBtn:setScale(1.0)
            --self:sendData()
            -- dump(item:getData())
            -- RechargeManager:getInstance():setChargeItemData(item:getData())
            -- GameNet:sendMsgToSocket(30001,{key = item:getData().key, order_id = ""}) 
            local data
            if self.selectTabIndex == 1 then
                data = {number = 3,rmb = 25,jade = 250,key = 3,markIcon ="chargeDouble",icon = "coin3",finish = false,first_giving = 250,giving_desc= "首次充值返利250元宝",common_giving = 0,common_desc = ""}
                RechargeManager:getInstance():setChargeItemData(data)
                GameNet:sendMsgToSocket(30005,{key = 3, type = 1}) 
            else
                data = {number = 5,rmb = 98,jade = 980,key = 5,markIcon ="chargeDouble",icon = "coin5",finish = false,first_giving = 980,giving_desc= "首次充值返利980元宝",common_giving = 0,common_desc = ""}
                RechargeManager:getInstance():setChargeItemData(data)
                GameNet:sendMsgToSocket(30005,{key = 5, type = 1})
            end
        end     
        return true
    end)

    if ArmatureManager:getInstance():loadEffect("btnEffect") then
        self.btnEffArmature = ccs.Armature:create("btnEffect")
        local xx,yy = self.buyBtn:getPosition()
       -- self.btnEffArmature:setPosition(xx+3,yy)
        self.buyBtn:addChild(self.btnEffArmature)
        self.btnEffArmature:getAnimation():play("effect")
    end


    self.tag1:setTouchEnabled(true)
    self.tag1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            --self.tag1:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            --self.tag1:setScale(1.0)
            self:setSelectTab(1)
        end     
        return true
    end)

    self.tag2:setTouchEnabled(true)
    self.tag2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            --self.tag2:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            --self.tag2:setScale(1.0)
            self:setSelectTab(2)
        end     
        return true
    end)

    local function listTouchListener(event)

    end
    self.listView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 850-16, 240-20),
        direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
        }
        :onTouch(listTouchListener)
        :addTo(self.mainLayer)
    self.listView:setPosition(8,10)

    self.selectTabIndex = -1

    self.itemList = {}
    self.statesDic = {}
end

function InvestWin:setSelectTab(index)
    if self.selectTabIndex ~= index then
        self.selectTabIndex = index 
        if self.selectTabIndex == 1 then
            self.tag1:setSpriteFrame("com_labBtn5Sel.png")
            self.tag2:setSpriteFrame("com_labBtn5.png")
            self.label2:setColor(cc.c3b(203, 185, 156))
            self.label1:setColor(cc.c3b(255, 252, 175))
            self.titleBg:setSpriteFrame("invest_bg1.png")
            GameNet:sendMsgToSocket(30006,{type = 1})
            self.confList = configHelper:getInvestDisplayConfig(self.selectTabIndex)
            self.priceLabel:setString(self.confList[1].price_txt)
        else
            self.tag2:setSpriteFrame("com_labBtn5Sel.png")
            self.tag1:setSpriteFrame("com_labBtn5.png")

            self.label1:setColor(cc.c3b(203, 185, 156))
            self.label2:setColor(cc.c3b(255, 252, 175))

            self.titleBg:setSpriteFrame("invest_bg2.png")
            GameNet:sendMsgToSocket(30006,{type = 2})
            self.confList = configHelper:getInvestDisplayConfig(self.selectTabIndex)
            self.priceLabel:setString(self.confList[1].price_txt)
        end

        for i=1,#self.itemList do
            self.itemList[i]:destory()
        end
        self.listView:removeAllItems()
        self.itemList = {}

        for i=1,#self.confList do
            local item = self.listView:newItem()
            local content = import("app.modules.invest.InvestItem").new()
            --content:open(vo)
            self.itemList[i] = content
            content:setContentSize(136, 208)
            item:addContent(content)
            item:setItemSize(140, 208)

            self.listView:addItem(item)
        end
        self.listView:reload()

    end
end

function InvestWin:initList(data)
    if data.data.type ~= self.selectTabIndex then return end
    local arr = data.data.state_list;
    self.statesDic = {}
    local vo
    for i=1,#arr do
        vo = arr[i]
         self.statesDic[vo.key] = vo.state
    end
    local left_time = data.data.left_time
    self.timeLabel:setString(StringUtil.GetMiaoNumToDayHours(data.data.left_time))

    if #arr >0 or left_time <= 0  then
        self.buyBtn:setButtonEnabled(false)
        self.buyBtn:setButtonLabelString("已购买")
        self.btnEffArmature:setVisible(false)
    else
        self.buyBtn:setButtonEnabled(true)
        self.buyBtn:setButtonLabelString("立即购买")
        self.btnEffArmature:setVisible(true)
    end
    
    for i=1,#self.confList do
        local vo = self.confList[i]
        vo.states = self.statesDic[vo.value]
        self.itemList[i]:open(vo)
    end
end

function InvestWin:chongZhi(data)

end

function InvestWin:getPrize(data)
    GameNet:sendMsgToSocket(30006,{type = self.selectTabIndex})
end

--打开
function InvestWin:open()
    InvestWin.super.open(self)
    if self.investGetEventId == nil then
        self.investGetEventId = GlobalEventSystem:addEventListener(InvestEvent.GET_INVEST,handler(self,self.getPrize))
    end
    if self.investListEventId == nil then
        self.investListEventId = GlobalEventSystem:addEventListener(InvestEvent.INVEST_LIST,handler(self,self.initList))
    end
    if self.investChongZhiEventId == nil then
        self.investChongZhiEventId = GlobalEventSystem:addEventListener(InvestEvent.CHONGZHI,handler(self,self.chongZhi))
    end

    self:setSelectTab(1)
end

--关闭
function InvestWin:close()
     InvestWin.super.close(self)
    if self.investGetEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.investGetEventId)
        self.investGetEventId = nil
    end
    if self.investListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.investListEventId)
        self.investListEventId = nil
    end

    if self.investChongZhiEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.investChongZhiEventId)
        self.investChongZhiEventId = nil
    end
    if self.timerId then
        GlobalTimer.unscheduleGlobal(self.timerId)
        self.timerId = nil
    end
end

--清理界面
function InvestWin:destory()
    self:close()
	InvestWin.super.destory(self)
    if self.btnEffArmature then
        self.btnEffArmature:stopAllActions()
        self.btnEffArmature:getAnimation():stop()
        self.btnEffArmature:getParent():removeChild(self.btnEffArmature)
        ArmatureManager:getInstance():unloadEffect("btnEffect")
    end
    for _,item in ipairs(self.itemList or {}) do
        item:destory()
    end
    self.listView:removeAllItems()
    self.itemList = {}

end

return InvestWin