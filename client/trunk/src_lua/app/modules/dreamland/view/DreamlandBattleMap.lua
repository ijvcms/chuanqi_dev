--
-- Author: gxg
-- Date: 2017-1-18
--
-- 跨服幻境之城 - 战斗中 - 地图信息
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local DreamlandBattleMap = DreamlandBattleMap or class("DreamlandBattleMap", BaseView)

function DreamlandBattleMap:ctor(parent)
    self.parent = parent
    self.curRoom = nil

    DreamlandBattleMap.super.ctor(self, "", nil, { url = "resui/dreamlandWin.ExportJson" }) 
    local root = self:getRoot()
    self:setContentSize(cc.size(root:getContentSize().width, root:getContentSize().height))
    self:init()
    self:addEvent()

end

function DreamlandBattleMap:init()
    self.closeBtn = self:seekNodeByName("closeBtn")          

    self.room = {}  
    for i=1, 100 do
        if DreamlandManager:getInstance():isSafeArea(i) ~= true then
            self.room[i] = self:seekNodeByName(tostring(i))  -- 中间有9个作为安全区 未点亮-dreamland_gray.png 当前-dreamland_orange.png 已点亮-dreamland_yellow.png
        end
    end

    self.hallBlock = self:seekNodeByName("hallBlock") -- 安全区 当前-dreamland_orange2.png 默认-dreamland_green.png

    self:initUI()

end

function DreamlandBattleMap:initUI()
    for i=1, 100 do
        if self.room[i] ~= nil then
            self.room[i]:setSpriteFrame("dreamland_gray.png")
        end
    end
    self.hallBlock:setSpriteFrame("dreamland_green.png")

end

function DreamlandBattleMap:addEvent()
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
                self:close()
            end
        end
        return true
    end)

end

-- 获取玩家幻境之城的点亮信息
function DreamlandBattleMap:hjzc_plyaer_info(data)
    if data == nil then return end
    data = data.data
    --dump(data)

    self.pass_room_num_list = data.pass_room_num_list
    self.room_num = data.room_num

    --
    self:initUI()

    -- 通过区域
    for _,v in pairs(self.pass_room_num_list) do
        if self.room[v] ~= nil then
            self.room[v]:setSpriteFrame("dreamland_yellow.png")
        end
    end

    -- 当前所在位置
    if self.curRoom ~= nil then
        self.curRoom:stopAllActions()
    end
    if DreamlandManager:getInstance():isSafeArea(self.room_num) == true then
        -- 在安全区
        self.hallBlock:setSpriteFrame("dreamland_orange2.png")
        self.curRoom = self.hallBlock
    else
        if self.room[self.room_num] ~= nil then
            self.room[self.room_num]:setSpriteFrame("dreamland_orange.png")
            self.curRoom = self.room[self.room_num]
        end
    end
    if self.curRoom ~= nil then
        local sequence = transition.sequence({
            cc.Blink:create(1.0, 2)
            })
        local repeatAction = cc.RepeatForever:create(sequence)
        self.curRoom:runAction(repeatAction)
    end

end

-- 打开界面
function DreamlandBattleMap:open()
    -- 添加监听
    if self.registerEventId == nil then
        self.registerEventId = {}
    end
    -- 获取玩家幻境之城的点亮信息
    self.registerEventId[1] = GlobalEventSystem:addEventListener(DreanlandEvent.hjzc_plyaer_info, handler(self, self.hjzc_plyaer_info))

    -- 获取玩家幻境之城的点亮信息
    GlobalController.dreamland:req_get_hjzc_plyaer_info()

end

-- 关闭界面
function DreamlandBattleMap:close()
    -- 移除监听
    if self.registerEventId ~= nil then
        for i=1,#self.registerEventId do
            GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
        end  
    end
    self.registerEventId = nil

    if self.parent ~= nil then
        self.parent.map_ui = nil
    end

    self:destory() 

end

-- 清理界面
function DreamlandBattleMap:destory()
    self.super.destory(self)
    self:removeSelf()

end

return DreamlandBattleMap