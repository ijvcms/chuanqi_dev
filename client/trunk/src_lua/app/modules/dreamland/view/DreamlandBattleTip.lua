--
-- Author: gxg
-- Date: 2017-1-18
--
-- 跨服幻境之城 - 战斗中 - Tips
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local DreamlandBattleTip = DreamlandBattleTip or class("DreamlandBattleTip", BaseView)

function DreamlandBattleTip:ctor()
    DreamlandBattleTip.super.ctor(self, "", nil, { url = "resui/dreamlandWin2.ExportJson" })
    local root = self:getRoot()
    root:setPosition(0,0)
    self:setContentSize(cc.size(root:getContentSize().width, root:getContentSize().height))
    
    self:init()
    self:addEvent()

end

function DreamlandBattleTip:init()
    self.rankBtn = self:seekNodeByName("rankBtn")           
    self.progressBtn = self:seekNodeByName("progressBtn")           
    self.numLabel = self:seekNodeByName("numLabel")      

end

function DreamlandBattleTip:addEvent()
    -- 
    self.rankBtn:setTouchEnabled(true)
    self.rankBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.rankBtn:setScale(1.1)
            SoundManager:playClickSound()
            self.hasMoving = false
        elseif "moved" == event.name then
            local distance = math.abs(event.x - event.prevX)
            if distance > 5 then
                self.hasMoving = true
            end
        elseif event.name == "ended" then
            self.rankBtn:setScale(1.0)
            if not self.hasMoving then
                -- 关闭探索界面
                if self.map_ui ~= nil then
                    if self.map_ui.close ~= nil then
                        self.map_ui:close()
                    end
                    self.map_ui = nil
                end
                -- 打开排行界面
                if self.rank_ui == nil then
                    self.rank_ui = require("app.modules.dreamland.view.DreamlandBattleRank").new(self) 
                    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,self.rank_ui)
                    self.rank_ui:open()
                end
            end
        end
        return true
    end)

    -- 
    self.progressBtn:setTouchEnabled(true)
    self.progressBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.progressBtn:setScale(1.1)
            SoundManager:playClickSound()
            self.hasMoving = false
        elseif "moved" == event.name then
            local distance = math.abs(event.x - event.prevX)
            if distance > 5 then
                self.hasMoving = true
            end
        elseif event.name == "ended" then
            self.progressBtn:setScale(1.0)
            if not self.hasMoving then
                -- 关闭排行界面
                if self.rank_ui ~= nil then
                    if self.rank_ui.close ~= nil then
                        self.rank_ui:close()
                    end
                    self.rank_ui = nil
                end
                -- 打开探索界面
                if self.map_ui == nil then
                    self.map_ui = require("app.modules.dreamland.view.DreamlandBattleMap").new(self) 
                    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,self.map_ui)
                    self.map_ui:open()
                end
            end
        end
        return true
    end)

end

-- 获取玩家幻境之城的点亮信息
function DreamlandBattleTip:hjzc_plyaer_info(data)
    if data == nil then return end
    data = data.data
    --dump(data)

    self.pass_room_num_list = data.pass_room_num_list
    self.room_num = data.room_num

    -- 已探索数量
    self.numLabel:setString(#self.pass_room_num_list)

end

-- 打开界面
function DreamlandBattleTip:open()
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
function DreamlandBattleTip:close()
    -- 移除监听
    if self.registerEventId ~= nil then
        for i=1,#self.registerEventId do
            GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
        end  
    end
    self.registerEventId = nil

    -- 关闭排行界面
    if self.rank_ui ~= nil then
        if self.rank_ui.close ~= nil then
            self.rank_ui:close()
        end
        self.rank_ui = nil
    end

    -- 关闭探索界面
    if self.map_ui ~= nil then
        if self.map_ui.close ~= nil then
            self.map_ui:close()
        end
        self.map_ui = nil
    end

    self:destory() 

end

-- 清理界面
function DreamlandBattleTip:destory()
    self.super.destory(self)
    self:removeSelf()

end

return DreamlandBattleTip