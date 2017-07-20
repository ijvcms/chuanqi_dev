-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:20:23
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--
--行会联盟页
local GuildBasePage = import(".GuildBasePage")
local GuildUnionPage = class("GuildUnionPage", GuildBasePage)

function GuildUnionPage:ctor()
	self.root = cc.uiloader:load("resui/guildUnionRight.ExportJson")
    self:addChild(self.root)
    self.root:setPosition(210,6)
    
    self.whyBtn = cc.uiloader:seekNodeByName(self.root, "whyBtn")
    self.mainLayer = cc.uiloader:seekNodeByName(self.root, "layer")--648 440
    self.whyBtn:setTouchEnabled(true)
    self.whyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.whyBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.whyBtn:setScale(1)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(29),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end
        return true
    end)

    --self.vipBg = cc.uiloader:seekNodeByName(self.ccui, "vipBg")
    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(10, 10, 630, 420),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)
    --self.itemListView:setPosition(-300, -220)
end

function GuildUnionPage:touchListener(ee)

end

function GuildUnionPage:updateItem()
    local list2 = RoleManager:getInstance().guildInfo.unionInfo
    self.itemListView:removeAllItems()

    local list = {}
    for k,v in pairs(list2) do
        local vo = v
        if vo.guild_id == RoleManager:getInstance().guildInfo.guild_id then
            table.insert(list,1,v)
        else
            table.insert(list,v)
        end
    end
--     list = {{guild_name = "name",chairman_name = "namee",guild_lv = 2,number = "tt",guild_id = "2345245"},
-- {guild_name = "name",chairman_name = "namee",guild_lv = 2,number = "tt",guild_id = "2345245"},
-- {guild_name = "name",chairman_name = "namee",guild_lv = 2,number = "tt",guild_id = "2345245"}}
-- print(#list)
    for i=1,#list do
        local item = self.itemListView:newItem()
        content = import("app.modules.union.UnionItem").new()
        item:addContent(content)
        item:setItemSize(620, 76)
        content:setData(list[i])
        self.itemListView:addItem(item)
    end
    self.itemListView:reload()
end

function GuildUnionPage:onNodeEvent(data)
	
end



function GuildUnionPage:registerEvent()
	if self.getUnionListEventId == nil then
         self.getUnionListEventId = GlobalEventSystem:addEventListener(UnionEvent.GET_UNION_INFO_LIST,handler(self,self.updateItem))
    end
end

function GuildUnionPage:unregisterEvent()
	if self.getUnionListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.getUnionListEventId)
        self.getUnionListEventId = nil
    end
end

function GuildUnionPage:onShow()
	self:registerEvent()
    GameNet:sendMsgToSocket(17093)
end

function GuildUnionPage:onHide()
    self:unregisterEvent()
end

function GuildUnionPage:onDestory()
    self:unregisterEvent()
end

return GuildUnionPage