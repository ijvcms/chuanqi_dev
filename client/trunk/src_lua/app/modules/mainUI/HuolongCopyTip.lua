--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-07 20:13:55
-- 火龙副本杀怪提示信息
local HuolongCopyTip = class("HuolongCopyTip", function()
	return display.newNode()
end)

function HuolongCopyTip.create(param)
	return HuolongCopyTip.new(param)
end

function HuolongCopyTip:ctor(param)
	self.bg = display.newScale9Sprite("#com_panelBg5.png", 0, 0, cc.size(300, 100))
    self:addChild(self.bg)
    self.bg:setTouchEnabled(false)
    self.bg:setPosition(0,-50)


    self.tips1 = display.newTTFLabel({
                text = "第一阶段",
                size = 20,color = cc.c3b(255, 255, 255)})
                :align(display.CENTER,0,0)
                :addTo(self)
    self.tips1:setPosition(0,-22)

    -- self.tips2 = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'></font>",250)
    -- self:addChild(self.tips2)
    -- self.tips2:renderXml("<font color='0xFFFFFF' size='18' opacity='255'>".."所抵抗力激发林科所当局法".."</font>")
    -- self.tips2:setPosition(-125,-60)
    self.tips2 = display.newTTFLabel({
                text = "",
                size = 18,color = cc.c3b(255, 255, 255)})
                :align(display.CENTER,0,0)
                :addTo(self)
    self.tips2:setPosition(0,-55)

    self.tips3 = display.newTTFLabel({
                text = "当前已击杀",
                size = 18,color = cc.c3b(255, 255, 255)})
                :align(display.CENTER,0,0)
                :addTo(self)
    self.tips3:setPosition(-30,-75)

    self.tips4 = display.newTTFLabel({
                text = "0",
                size = 18,color = cc.c3b(255, 0, 0)})
                :align(display.CENTER,0,0)
                :addTo(self)
    self.tips4:setPosition(40,-75)

    GameNet:sendMsgToSocket(11054)
    --self:updateNum({data=3})
end

function HuolongCopyTip:updateNum(data)
    local confList
    if (GameSceneModel.sceneId >= 31002 and GameSceneModel.sceneId <= 31004) then
        confList = configHelper:getInstanceDragonConfig()
    elseif GameSceneModel.sceneId >= 32109 and GameSceneModel.sceneId <= 32111 then
        confList = configHelper:getInstance_dragon_weekenConfig()
    elseif GameSceneModel.sceneId == 32108 then
        confList = configHelper:getInstance_dragon_nativeConfig()
    end

    local num = data.data
    local min = 1000000000
    local curKey = 5
    for k,v in pairs(confList) do
        if k > num then
            if k - num < min then
                min = k - num
                curKey = k
            end
        end
    end
    local conf = confList[curKey]
    self.tips2:setString(conf.description)
    self.tips1:setString(conf.stage)
    self.tips4:setString(data.data)
end


function HuolongCopyTip:open(param)
    if self.EventId == nil then
        self.EventId = GlobalEventSystem:addEventListener(SceneEvent.HUOLONG_COPY_TIPS,handler(self,self.updateNum))
    end
end

function HuolongCopyTip:destory(param)
    if self.EventId then
        GlobalEventSystem:removeEventListenerByHandle(self.EventId)
        self.EventId = nil
    end
end

return HuolongCopyTip