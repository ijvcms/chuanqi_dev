--
-- Author: gxg
-- Date: 2017-1-18
--
-- 跨服幻境之城 - 战斗中 - 排行 - Item
--

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local DreamlandBattleRankItem = DreamlandBattleRankItem or class("DreamlandBattleRankItem", UIAsynListViewItemEx)

function DreamlandBattleRankItem:ctor(loader, layoutFile)
    local ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(ccui)
    self:setContentSize(cc.size(ccui:getContentSize().width, ccui:getContentSize().height + 5.0))
    ccui:setAnchorPoint(0.0, 0.0)
    --ccui:setPositionX(10.0)

    self:init(ccui)
    self:addEvent()

end

function DreamlandBattleRankItem:init(ccui)
    self.rankLabel = cc.uiloader:seekNodeByName(ccui, "rankLabel")            -- 排名 第1名RGB(235,12,16),第2名RGB(240,147,24),第2名RGB(240,147,24),第3名RGB(242,158,25),第4名RGB(219,174,103)
    self.nameLabel = cc.uiloader:seekNodeByName(ccui, "nameLabel")            -- 名字
    self.numLabel = cc.uiloader:seekNodeByName(ccui, "numLabel")              -- 数量

end

function DreamlandBattleRankItem:addEvent()

end

function DreamlandBattleRankItem:setViewInfo(data)
    local rank_color = cc.c3b(219, 174, 103)
    if data.rank == 1 then
        rank_color = cc.c3b(235, 12, 16)
    elseif data.rank == 2 then
        rank_color = cc.c3b(240, 147, 24)
    elseif data.rank == 3 then
        rank_color = cc.c3b(242, 158, 25)
    end

    self.rankLabel:setString(data.rank)
    self.rankLabel:setColor(rank_color)

    self.nameLabel:setString(data.name)

    self.numLabel:setString(data.num)

end

function DreamlandBattleRankItem:getData()

    return self.data
end 

function DreamlandBattleRankItem:setData(data)
    --dump(data)
    self.data = data
    self:setViewInfo(data)

end

function DreamlandBattleRankItem:close()

end

function DreamlandBattleRankItem:destory()
    local fileUtil = cc.FileUtils:getInstance()
    local fullPath = fileUtil:fullPathForFilename("resui/dreamlandWin0.plist")
    local fullPng = fileUtil:fullPathForFilename("resui/dreamlandWin0.png")
    display.removeSpriteFramesWithFile(fullPath, fullPng)
    self:removeSelf()

end

return DreamlandBattleRankItem