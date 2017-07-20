--
-- Author: gxg
-- Date: 2017-1-18
--
-- 跨服幻境之城 - 主面板
--

local DreamlandWin = DreamlandWin or class("DreamlandWin", BaseView)


function DreamlandWin:ctor(winTag, data, winconfig)
	DreamlandWin.super.ctor(self, winTag, data, winconfig)
	local root = self:getRoot()
    root:setAnchorPoint(0.5, 0.5)
    root:setPosition(display.width/2.0, display.height/2.0)
    
    self:init()
    self:addEvent()

   
end

function DreamlandWin:init()
    self.closeBtn = self:seekNodeByName("closeBtn")
    self.enterBtn = self:seekNodeByName("enterBtn")
    self.helpBtn = self:seekNodeByName("helpBtn")

    self.Item = {}
    for i=1,6 do
        self.Item[i] = self:seekNodeByName("Item"..i)     
    end

end

function DreamlandWin:addEvent()
    -- 关闭按钮
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
            SoundManager:playClickSound()
            self.hasMoving = false
        elseif "moved" == event.name then
            local distance = math.abs(event.x - event.prevX)
            if distance > 5 then
                self.hasMoving = true
            end
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            if not self.hasMoving then
               self:onCloseClick()
              --   self.luaNode:removeSelf()
            end
        end
        return true
    end)

    -- 进入按钮
    self.enterBtn:setTouchEnabled(true)
    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.enterBtn:setScale(1.1)
            SoundManager:playClickSound()
            self.hasMoving = false
        elseif "moved" == event.name then
            local distance = math.abs(event.x - event.prevX)
            if distance > 5 then
                self.hasMoving = true
            end
        elseif event.name == "ended" then
            self.enterBtn:setScale(1.0)
            if not self.hasMoving then
                self:onEnterClick()
            end
        end
        return true
    end)

    self.helpBtn:setTouchEnabled(true)
    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.helpBtn:setScale(1.0)
            GlobalWinManger:openWin(WinName.PRIZERANK,{type = 1})
        end     
        return true
    end)

end

function DreamlandWin:setViewInfo()
    -- 奖励
    local conf = configHelper:getDarkHouseGoods(12) -- id=12,跨服幻境之城
    if conf ~= nil then
        local drop_list = conf.drop_list
        for i=1, #drop_list do
            if self.Item[i] ~= nil then
                local good = drop_list[i]
                if self.Item[i]:getChildByTag(10) ~= nil then
                    self.Item[i]:getChildByTag(10):removeSelf()
                end
                local d = {}
                d.goods_id = good[1] or 0
                d.is_bind = good[2] or 0
                d.num = good[3] or 1
                local commonItem = CommonItemCell.new()
                commonItem:setData(d)
                self.Item[i]:addChild(commonItem, 10, 10)
                commonItem:setTouchEnabled(true)
                commonItem:setPosition(self.Item[i]:getContentSize().width/2.0, self.Item[i]:getContentSize().height/2.0)
                self.Item[i]:setVisible(true)
            end
        end
    end

end

-- 关闭按钮
function DreamlandWin:onCloseClick()
    GlobalWinManger:closeWin(self.winTag)

end

function DreamlandWin:onEnterClick()
    local scene_id = 32112 -- 目前配置数据策划正在完善,还不知道从哪里能读取到这个值
    GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(scene_id)})
end

-- 打开界面(自动调用)
function DreamlandWin:open()
    self:setViewInfo()

end

-- 关闭界面(自动调用)
function DreamlandWin:close()

end

-- 清理界面(自动调用)
function DreamlandWin:destory()
    self.super.destory(self)

end

return DreamlandWin