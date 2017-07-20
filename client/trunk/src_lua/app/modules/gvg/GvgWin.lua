--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- GVG
local GvgWin = class("GvgWin", BaseView)
function GvgWin:ctor(winTag,data,winconfig)
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)
    GvgWin.super.ctor(self,winTag,data,winconfig)
    self.data = data
    self.root:setPosition((display.width-960)/2,(display.height-640)/2)


    self.mainLayer = self:seekNodeByName("mainLayer")

    self.closeBtn = self:seekNodeByName("closeBtn")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
    end)

    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(14, 10, 570, 330),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png" }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)

    self.itemList = {}
    self:updateItem(self.data)

    self.myRank = self:seekNodeByName("myRank")
    self.myPoint = self:seekNodeByName("myPoint")
end


function GvgWin:touchListener(e)
end

function GvgWin:updateItem(data)
    local gvgItem = require("app.modules.gvg.GvgItem")
    local player_rank = data.player_rank
    local player_score = data.player_score
    local rank_list = data.rank_list
    self.myRank:setString(player_rank)
    self.myPoint:setString(player_score)
    for i=1,#rank_list do
        local content = self.itemList[i]
        if content == nil then
            local item = self.itemListView:newItem()
            content = gvgItem.new()
            content:setData(rank_list[i])
            self.itemList[i] = content
            item:addContent(content)
            item:setItemSize(570, 36)
            self.itemListView:addItem(item)
        end
    end
    self.itemListView:reload()
end

function GvgWin:open()
    GvgWin.super.open(self)
    -- if self.gvgRankEventId == nil then
    --      self.gvgRankEventId = GlobalEventSystem:addEventListener(GvgEvent.GVG_OVER,handler(self,self.updateItem))
    -- end
end


function GvgWin:close()
    -- if self.gvgRankEventId then
    --     GlobalEventSystem:removeEventListenerByHandle(self.gvgRankEventId)
    --     self.gvgRankEventId = nil
    -- end
    
    GvgWin.super.close(self)

end


--清理界面
function GvgWin:destory()
	GvgWin.super.destory(self)
	
end

return GvgWin