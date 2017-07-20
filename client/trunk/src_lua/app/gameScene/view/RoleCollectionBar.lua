--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-12-29 14:20:15
-- 场景采集条
--
local RoleCollectionBar = class("RoleCollectionBar", function()
	return display.newNode()
end)

function RoleCollectionBar:ctor()
	local bg  = display.newSprite("#scene/scene_collectLineBg2.png") --128 20
    bg:setAnchorPoint(0,0)
    self:addChild(bg)
    self.collectionClippingRegion = cc.ClippingRegionNode:create()
    self.collectionClippingRegion:setAnchorPoint(0,0)
    self.collectionClippingRegion:setPosition(17,4)
    self:addChild(self.collectionClippingRegion)

    local collectionBar = display.newSprite("#scene/scene_collectLine2.png")--106 12
    collectionBar:setAnchorPoint(0,0)
    self.collectionClippingRegion:addChild(collectionBar)
    self.collectionbloodRect = cc.rect(0, 0, 0, 12) --93，9
    --self.bloodRect.width = 50
    self.collectionClippingRegion:setClippingRegion(self.collectionbloodRect)

    self.collectionPointEff = display.newSprite("#scene/scene_collectEffect2.png")
    self:addChild(self.collectionPointEff)
    self.collectionPointEff:setAnchorPoint(1,0.5)
    self.collectionPointEff:setPosition(35,15)

    self.collectionLab = display.newTTFLabel({
        text = "采集中",
        size = 18,color = cc.c3b(255, 255, 255)})
        :align(display.CENTER,0,0)
        :addTo(self)
    self.collectionLab:setPosition(64,28)
end

function RoleCollectionBar:open(data)
    self:setVisible(true)
	self.collectinBarTips = data.tips or "采集中"
    self.collectionCompleteBackFun = data.backFun
    if self.collectionLab then
    	self.collectionLab:setString(self.collectinBarTips)
    end

    self.showCollectionBeginTime = socket.gettime()
    self.showCollectionEndTime = socket.gettime()+ (data.time or 5)
	if self.collectionBarTimeEventId == nil then
        self.collectionBarTimeEventId =  GlobalTimer.scheduleUpdateGlobal(handler(self,self.updateCollectionBar),0.05)
    end
end

function RoleCollectionBar:updateCollectionBar()
    if socket.gettime() < self.showCollectionEndTime then
        local curPrecent = (socket.gettime() - self.showCollectionBeginTime)/(self.showCollectionEndTime - self.showCollectionBeginTime)
        self.collectionbloodRect.width = math.min(curPrecent*106,106)
        self.collectionPointEff:setPosition(25+self.collectionbloodRect.width,10)
        self.collectionClippingRegion:setClippingRegion(self.collectionbloodRect)
    else
        if self.collectionCompleteBackFun then
            self.collectionCompleteBackFun()
            self.collectionCompleteBackFun = nil
        end
        self:destory()
        --GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_COLLECT_BAR,{isOpen = false})
    end
end



function RoleCollectionBar:destory()
    if self.collectionBarTimeEventId then
        GlobalTimer.unscheduleGlobal(self.collectionBarTimeEventId)
        self.collectionBarTimeEventId = nil
    end
    self:setVisible(false)
end



return RoleCollectionBar