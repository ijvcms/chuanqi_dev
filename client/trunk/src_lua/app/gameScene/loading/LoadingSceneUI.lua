--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-28 21:02:37
-- 场景加载UI
local LoadingSceneUI = class("LoadingSceneUI", function()
	return display.newNode()
end)

function LoadingSceneUI:ctor()
	self.resList = {
		[1] = "common/login/login_bg.jpg",
        [2] = "common/login/login_logo.png",
	}
	local bg = display.newSprite(self.resList[1])
    self:addChild(bg)
    bg:setScaleX(display.width/1139)
    bg:setScaleY(display.height/640)
    bg:setPosition(display.cx,display.cy)

    local logo = display.newSprite(self.resList[2])
    logo:setPosition(display.cx, display.height - 200)
    self:addChild(logo)

    self.bgBar = display.newScale9Sprite("#scene/scene_prgRedBarBg.png", 0, 0, cc.size(812,41),cc.rect(83, 20,1, 1))
    self:addChild(self.bgBar)
    self.bgBar:setAnchorPoint(0,0)
    --self.bgBar:setScale(1334/1000)
    self.bgBar:setPosition((display.width - 812)/2,85)
  	
  	self.barClippingRegion = cc.ClippingRegionNode:create()
	self.barClippingRegion:setAnchorPoint(0,0)
	self.barClippingRegion:setPosition(57,17)
	self.bgBar:addChild(self.barClippingRegion)

  	self.bar = display.newScale9Sprite("#scene/scene_prgRedBar.png", 0, 0, cc.size(700,7))
    self.barClippingRegion:addChild(self.bar)
    self.bar:setAnchorPoint(0,0)
    --self.bar:setScale(1334/1000)
    --self.bar:setPosition((display.width - 805)/2,90)

    self.barRect = cc.rect(0, 0, 700*0, 8)
    self.barClippingRegion:setClippingRegion(self.barRect)

    self.tipText = display.newTTFLabel({text = "",
        size = 18,color = TextColor.TEXT_WHITE})
            :align(display.CENTER,0,0)
            :addTo(self)
    self.tipText:setPosition(display.width/2,130)
    --display.setLabelFilter(self.tipText)
    self.time = os.time() - 70
    self.realWidth = 0

    self.loadingTips = require("app.conf.loadingtextConfig").new()
    self:setTouchEnabled(true)
end

function LoadingSceneUI:timeHandler(data)
    if self.barRect then
        if self.realWidth > self.barRect.width then
            self.barRect.width = self.barRect.width + self.addDis
            self.barClippingRegion:setClippingRegion(self.barRect)
        end
    end
    if os.time() - self.time > 6 and self.loadingTips then
        self.time = os.time()
        self.tipText:setString("加载提示:"..self.loadingTips.datas[math.random(1,#self.loadingTips.datas)][2])
    end
end

function LoadingSceneUI:updateValue(data)
	if self.barClippingRegion then
        self.realWidth = 700*data.data
		if self.barRect.width > self.realWidth then
            self.barRect.width = self.realWidth
        end
        self.addDis = (self.realWidth - self.barRect.width)/15
	end
end

function LoadingSceneUI:open()
    if self.updateSceneLoading == nil then
        self.updateSceneLoading = GlobalEventSystem:addEventListener(GlobalEvent.UPDATE_SCENE_LOADING,handler(self,self.updateValue))
    end
    if self.timerIds == nil then
        self.timerIds =  GlobalTimer.scheduleUpdateGlobal(handler(self, self.timeHandler))
    end
end

function LoadingSceneUI:close()
    if self.timerIds then
        GlobalTimer.unscheduleGlobal(self.timerIds)
        self.timerIds = nil
    end
    if self.updateSceneLoading then
        GlobalEventSystem:removeEventListenerByHandle(self.updateSceneLoading)
        self.updateSceneLoading = nil
    end
end

function LoadingSceneUI:destory()
    self:close()
    self:stopAllActions()
	for i=1,#self.resList do
		display.removeSpriteFrameByImageName(self.resList[i]) 
	end	 
end

return LoadingSceneUI