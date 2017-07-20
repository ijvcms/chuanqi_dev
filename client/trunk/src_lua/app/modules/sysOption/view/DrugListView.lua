local DrugListView = class("DrugListView", function()
    return display.newNode()
end)

function DrugListView:ctor(drugType,obj)
    local layer = display.newLayer()
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onCloseClick()
        end     
        return true
    end)
    self:addChild(layer)

    local bg = display.newScale9Sprite("#com_panelBg2.png",nil,nil,cc.size(370,394),cc.rect(63, 49,1, 1))
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)
    bg:setPosition(display.width/2,display.height/2)
    self:addChild(bg)

    local titleBg = display.newSprite("#com_alertTitleBg.png")
    local lab = display.newTTFLabel({
        text = "设置",
        size = 24,
        color = TextColor.TEXT_O
    })
    display.setLabelFilter(lab)
    lab:setPosition(titleBg:getContentSize().width/2,titleBg:getContentSize().height/2)
    titleBg:addChild(lab)
    titleBg:setPosition(bg:getContentSize().width/2, bg:getContentSize().height-35)
    bg:addChild(titleBg)

    local bg1 = display.newScale9Sprite("#com_tabBg1.png",nil,nil,cc.size(336,304),cc.rect(6, 6,1, 1))
    bg1:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2-20)
    bg:addChild(bg1)
    self.bg1 = bg1


    local drugList = configHelper:getAutoDrugIdList(drugType)
    self.drugType = drugType
    self:createDrugList(drugList,obj)

    self:setNodeEventEnabled(true)
end

function DrugListView:onCleanup()
    if self.closeCallback then self.closeCallback() end
    self.closeCallback = nil
end

function DrugListView:createDrugList(drugList,obj)
    if not drugList then return end
    local drugIds = {}
    for i=1,#drugList do
        drugIds[i] = drugList[i]
    end
    local gap = 8
    local layer = display.newLayer()
    self.scrollView = require("app.modules.bag.view.GBUIScrollView").new({viewRect = cc.rect(0,4,336,296),direction=1})
        :addTo(self.bg1)
    
    if #drugIds<3 then
        for i=#drugIds+1,3 do
            drugIds[i] = -1
        end
    end
    local height = 0
    for i=1,#drugIds do
        local sp = display.newScale9Sprite("#com_viewBg3.png",nil,nil,cc.size(326,98),cc.rect(6, 6,1, 1))--display.newSprite("#com_viewBg3.png")

        local line = display.newSprite("#com_uiLine1.png")
        line:setPosition(195,sp:getContentSize().height/2)
        line:setScaleX(50)
        sp:addChild(line)

        --图标背景
        local itemBg = display.newSprite("#com_propBg1.png")
        itemBg:setPosition(itemBg:getContentSize().width/2+10,sp:getContentSize().height/2)
        sp:addChild(itemBg)

        if drugIds[i]~=-1 then
            
            --图标
            local commonItem = CommonItemCell.new()
            commonItem:setData({goods_id=drugIds[i]})
            itemBg:addChild(commonItem)
            commonItem:setPosition(itemBg:getContentSize().width/2,itemBg:getContentSize().height/2)
            local bagManager = BagManager:getInstance()
            local count = bagManager:findItemCountByItemId(drugIds[i])
            commonItem:setCount(count)
            commonItem:setCountVisible(true)
            if count <= 0 then
                local filters = filter.newFilter("GRAY", {0.2, 0.3, 0.5, 0.1})
                commonItem:setFilter(filters)
            else
                commonItem:setItemClickFunc(function()
                    if obj then
                        if obj:getChildByTag(10) then
                            obj:removeChildByTag(10)
                        end
                        local item = CommonItemCell.new()
                        item:setData({goods_id=drugIds[i]})
                        item:setPosition(obj:getContentSize().width/2,obj:getContentSize().height/2)
                        item:setTouchEnabled(false)
                        item:setTouchSwallowEnabled(false)
                        item:setTag(10)
                        local bagManager = BagManager:getInstance()
                        local count = bagManager:findItemCountByItemId(drugIds[i])
                        item:setCount(count)
                        item:setCountVisible(true)
                        if count <= 0 then
                            local filters = filter.newFilter("GRAY", {0.2, 0.3, 0.5, 0.1})
                            item:setFilter(filters)
                        end
                        obj:addChild(item)
                        GlobalEventSystem:dispatchEvent(AutoDrugEvent.AUTO_DRUG_ID_CHANGE,{drugType=self.drugType,id=drugIds[i]})
                        GlobalController.guide:notifyEventWithConfirm(CLICK_SYS_OP_DRUG_LIST)
                        self:onCloseClick()
                        
                    end
                end)
            end
            
            
            --药品名
            local lab = display.newTTFLabel({
                text = configHelper:getGoodNameByGoodId(drugIds[i]),
                size = 20,
                color = TextColor.TEXT_W
            })
            display.setLabelFilter(lab)
            lab:setPosition(195,69)
            sp:addChild(lab)

            --药品描述
            local lab = display.newTTFLabel({
                text = configHelper:getGoodDescByGoodId(drugIds[i]),
                size = 16,
                color = TextColor.TEXT_W,
                dimensions = cc.size(190, 40)
            })
            display.setLabelFilter(lab)
            lab:setPosition(195,22)
            sp:addChild(lab)
        end
        
        layer:addChild(sp)
        sp:setPosition(sp:getContentSize().width/2+(336-sp:getContentSize().width)/2,(#drugIds-i)*(sp:getContentSize().height+gap)+sp:getContentSize().height/2)
        local curHeight = (#drugIds-i)*(sp:getContentSize().height+gap)+sp:getContentSize().height 
        height = curHeight>height and curHeight or height
    end
    self.scrollView:addScrollNode(layer)
    layer:setContentSize(336,height)
end

function DrugListView:onCloseClick()
    if self.closeCallback then self.closeCallback() end
    self.closeCallback = nil
    self:removeSelfSafety()
end

function DrugListView:setCloseCallback(callback)
    self.closeCallback = callback
end

return DrugListView