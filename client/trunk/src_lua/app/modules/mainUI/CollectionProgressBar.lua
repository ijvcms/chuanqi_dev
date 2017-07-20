--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-08 11:10:57
-- 采集进度条，可以用作采集，挖宝 解锁等
local CollectionProgressBar = class("CollectionProgressBar", function()
	return display.newNode()
end)

function CollectionProgressBar:ctor()
	local bg  = display.newSprite("#scene/scene_bar1Bg.png")
    bg:setAnchorPoint(0,0)
    self:addChild(bg)
    bg:setPositionX(-90)

    self.collectionClippingRegion = cc.ClippingRegionNode:create()
    self.collectionClippingRegion:setAnchorPoint(0,0)
    self.collectionClippingRegion:setPosition(2-90,3)
    self:addChild(self.collectionClippingRegion)
    local collectionBar = display.newSprite("#scene/scene_barRed.png")
    collectionBar:setAnchorPoint(0,0)
    self.collectionClippingRegion:addChild(collectionBar)
    self.collectionbloodRect = cc.rect(0, 0, 0, 12) --93，9
    --self.bloodRect.width = 50
    self.collectionClippingRegion:setClippingRegion(self.collectionbloodRect)

    self.collectionLab = display.newTTFLabel({
        text = "",
        size = 18,color = cc.c3b(255, 255, 255)})
        :align(display.CENTER,0,0)
        :addTo(self)
    self.collectionLab:setPosition(0,35)
end

function CollectionProgressBar:open(data)
	self.collectinBarTips = data.tips or "采集中"
    self.collectionCompleteBackFun = data.backFun
    if self.collectionLab then
    	self.collectionLab:setString(self.collectinBarTips)
    end

    self.showCollectionBeginTime = socket.gettime()
    self.showCollectionEndTime = socket.gettime()+ (data.time or 6)

	if self.collectionBarTimeEventId == nil then
        self.collectionBarTimeEventId =  GlobalTimer.scheduleUpdateGlobal(handler(self,self.updateCollectionBar),0.05)
    end
end

function CollectionProgressBar:updateCollectionBar()
    if socket.gettime() < self.showCollectionEndTime then
        FightModel.pauseAutoAtk = true
        local curPrecent = (socket.gettime() - self.showCollectionBeginTime)/(self.showCollectionEndTime - self.showCollectionBeginTime)
        self.collectionbloodRect.width = math.min(curPrecent*176,176)
        self.collectionClippingRegion:setClippingRegion(self.collectionbloodRect)
    else
        FightModel.pauseAutoAtk = false
        if self.collectionCompleteBackFun then
            self.collectionCompleteBackFun()
            self.collectionCompleteBackFun = nil
        end
        GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_COLLECT_BAR,{isOpen = false})
    end
end



function CollectionProgressBar:destory()
	FightModel.pauseAutoAtk = false
    if self.collectionBarTimeEventId then
        GlobalTimer.unscheduleGlobal(self.collectionBarTimeEventId)
        self.collectionBarTimeEventId = nil
    end
end



return CollectionProgressBar