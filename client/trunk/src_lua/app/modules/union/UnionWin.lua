--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 结盟
local UnionWin = class("UnionWin", BaseView)
local lotteryConfig = import("app.conf.lottery_coinConfig").new()
function UnionWin:ctor(winTag,data,winconfig)
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)
    UnionWin.super.ctor(self,winTag,data,winconfig)
    self.root:setPosition((display.width-625)/2,(display.height-436)/2)


    self.leaveBtn = self:seekNodeByName("leaveBtn")

    self.mainLayer = self:seekNodeByName("mainLayer")
    self.itemListView = self.mainLayer

    self.helpBtn = self:seekNodeByName("helpBtn")
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

    self.helpBtn:setTouchEnabled(true)
    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.helpBtn:setScale(1)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(28),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end
        return true
    end)

    self.leaveBtn:setTouchEnabled(true)
    self.leaveBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.leaveBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.leaveBtn:setScale(1)
            GameNet:sendMsgToSocket(17089)
        end
        return true
    end)

    self.itemlist = {}
   -- for i=1,6 do
   --      local item = import("app.modules.union.UnionItem").new()
   --      self.mainLayer:addChild(item)
   --      item:setPosition(0,230 - i*60)
   --      self.itemlist[i] = item
   --      item:setVisible(false)
   -- end
   self.leaveBtn:setVisible(false)
   self.isCancelRemoveSpriteFrams = true


   self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(2, 2, 570, 240),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)
    self.itemListView:setPosition(0, 0)

end

function UnionWin:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        --self:onListClick(self.itemList[event.itemPos])
    elseif "moved" == event.name then
        --self.bListViewMove = true
    elseif "ended" == event.name then
        --self.bListViewMove = false
    end
end

--
function UnionWin:updateItem()
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
        item:setItemSize(570, 76)
        content:setData(list[i])
        self.itemListView:addItem(item)
    end
    self.itemListView:reload()

    if #list > 1 then
       if RoleManager:getInstance().guildInfo.position == 1 or RoleManager:getInstance().guildInfo.position == 2 then
            self.leaveBtn:setVisible(false)
       else
            self.leaveBtn:setVisible(false)
       end
    end
end

function UnionWin:open()
    UnionWin.super.open(self)

    if self.getUnionListEventId == nil then
         self.getUnionListEventId = GlobalEventSystem:addEventListener(UnionEvent.GET_UNION_INFO_LIST,handler(self,self.updateItem))
    end
    GameNet:sendMsgToSocket(17093)
    self:updateItem()
end


function UnionWin:close()
    if self.getUnionListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.getUnionListEventId)
        self.getUnionListEventId = nil
    end
    UnionWin.super.close(self)

end


--清理界面
function UnionWin:destory()
    self:close()
	UnionWin.super.destory(self)
	
end

return UnionWin