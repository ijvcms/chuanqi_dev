--
-- Author: gxg
-- Date: 2017-1-18
--
-- 跨服幻境之城 - 战斗中 - 排行
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local DreamlandBattleRank = DreamlandBattleRank or class("DreamlandBattleRank", BaseView)

function DreamlandBattleRank:ctor(parent)
    self.parent = parent

    DreamlandBattleRank.super.ctor(self, "", nil, { url = "resui/dreamlandRankWin.ExportJson" })
    local root = self:getRoot()
    self:setContentSize(cc.size(root:getContentSize().width, root:getContentSize().height))
    self:init()
    self:addEvent()

end

function DreamlandBattleRank:init()
    self.closeBtn = self:seekNodeByName("closeBtn")

    self.mainLayer = self:seekNodeByName("mainLayer")
    self.rankLabel = self:seekNodeByName("rankLabel")   -- 排名
    self.roomLabel = self:seekNodeByName("roomLabel")   -- 房间数

    local size = self.mainLayer:getContentSize()
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, size.width, size.height)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listViewAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/dreamlandRankItem.ExportJson", "app.modules.dreamland.view.DreamlandBattleRankItem", 10)
    self.listView:setAdapter(self.listViewAdapter)
    self.mainLayer:addChild(self.listView)
    --self.listView:onTouch(handler(self, self.onListTouch))

end

function DreamlandBattleRank:addEvent()
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

-- 获取幻境之城的排名信息
function DreamlandBattleRank:hjzc_rank_list(data)
    if data == nil then return end
    data = data.data
    --dump(data)

    self.rank_list = data.rank_list

    -- 
    local rank = 0
    local player_id = RoleManager:getInstance().roleInfo.player_id
    for _,v in pairs(self.rank_list) do
        if v.player_id == player_id then
            rank = v.rank
            break
        end
    end
    if rank == 0 then
        rank = "未上榜"
    end
    self.rankLabel:setString(rank)

    -- 设置排行
    self.listViewAdapter:setData(self.rank_list)

end

-- 获取玩家幻境之城的点亮信息
function DreamlandBattleRank:hjzc_plyaer_info(data)
    if data == nil then return end
    data = data.data
    --dump(data)

    self.pass_room_num_list = data.pass_room_num_list

    self.roomLabel:setString(#self.pass_room_num_list)

end

-- 打开界面
function DreamlandBattleRank:open()
    -- 添加监听
    if self.registerEventId == nil then
        self.registerEventId = {}
    end
    -- 获取幻境之城的排名信息
    self.registerEventId[1] = GlobalEventSystem:addEventListener(DreanlandEvent.hjzc_rank_list, handler(self, self.hjzc_rank_list))    
    -- 获取玩家幻境之城的点亮信息
    self.registerEventId[2] = GlobalEventSystem:addEventListener(DreanlandEvent.hjzc_plyaer_info, handler(self, self.hjzc_plyaer_info))

    -- 获取幻境之城的排名信息
    GlobalController.dreamland:req_get_hjzc_rank_list()
    -- 获取玩家幻境之城的点亮信息
    GlobalController.dreamland:req_get_hjzc_plyaer_info()

end

-- 关闭界面
function DreamlandBattleRank:close()
    -- 移除监听
    if self.registerEventId ~= nil then
        for i=1,#self.registerEventId do
            GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
        end  
    end
    self.registerEventId = nil

    if self.parent ~= nil then
        self.parent.rank_ui = nil
    end

    self:destory() 

end

-- 清理界面
function DreamlandBattleRank:destory()
    self.super.destory(self)
    self:removeSelf()

end

return DreamlandBattleRank