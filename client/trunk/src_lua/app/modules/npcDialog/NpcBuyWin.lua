--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-01-06 20:03:45
-- Npc购买界面
local NpcBuyWin = class("NpcBuyWin", BaseView)

function NpcBuyWin:ctor(winTag,data,winconfig)
    --winconfig.url = "resui/npcshopWin_3.ExportJson"
  	NpcBuyWin.super.ctor(self,winTag,data,winconfig)
  	self.npcVO = data
    self.storeType = 10
    if self.npcVO.id == 7517 or self.npcVO.id == 7530 or self.npcVO.id == 7557 or self.npcVO.id == 7702  or self.npcVO.id == 8003 then
      self.storeType = 10
    elseif self.npcVO.id == 7509 or self.npcVO.id == 7531 or self.npcVO.id == 7556 or self.npcVO.id == 7703  or self.npcVO.id == 8004 then
      self.storeType = 11
    elseif self.npcVO.id == 7510 or self.npcVO.id == 7555 or self.npcVO.id == 7704   or self.npcVO.id == 8005 then
      self.storeType = 12
    elseif self.npcVO.id == 7519 or self.npcVO.id == 7527 or self.npcVO.id == 7559 or self.npcVO.id == 7706  or self.npcVO.id == 8007 then
      self.storeType = 13
    elseif self.npcVO.id == 7533 or self.npcVO.id == 7526 or self.npcVO.id == 7562 or self.npcVO.id == 7705  or self.npcVO.id == 8006  then
      self.storeType = 14
    elseif self.npcVO.id == 7582 then
        self.storeType = 15
    elseif self.npcVO.id == 7518 then
        self.storeType = 16
    end
    self.root:setTouchEnabled(true)

    self.coin1 = self:seekNodeByName("coin1")
    self.coin2 = self:seekNodeByName("coin2")
    self.coin3 = self:seekNodeByName("coin3")
    --金币label
    self.coin1Label = cc.uiloader:seekNodeByName(self.coin1,"value")
    self.coin1Label:setString("")
    --金锭label
    self.coin2Label = cc.uiloader:seekNodeByName(self.coin2,"value")
    self.coin2Label:setString("")
    --银票label
    self.coin3Label = cc.uiloader:seekNodeByName(self.coin3,"value")
    self.coin3Label:setString("")

    self.listLay = self:seekNodeByName("Image_23")
    
    --左边技能列表
    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(6, 4, 850+6, 450),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.listtouchListener))
        :addTo(self.listLay)
       --self.itemListView:setPosition(500,200)

    self:setTouchCaptureEnabled(true)
end


function NpcBuyWin:listtouchListener(event)

    local listView = event.listView
    if "clicked" == event.name then
        
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end


function NpcBuyWin:updateMaxCount()
    for i=1,#self.itemList do
        self.itemList[i]:updateMaxNum()
    end
end

function NpcBuyWin:onWealthChange()
    local wealthInfo = RoleManager:getInstance().wealth
    self.coin1Label:setString(wealthInfo.coin)
    --金锭labe
    self.coin2Label:setString(wealthInfo.jade)
    --银票label
    self.coin3Label:setString(wealthInfo.gift)
    self:updateMaxCount()
end

function NpcBuyWin:handlerNpc15(data)
    data = data.data.shop_list
    local itemData = {}
    for i=1,#data do
        for j=1,#self.datas do
            if data[i].shop_id == self.datas[j].key then
                self.datas[j].count = data[i].count
                itemData[#itemData + 1] = self.datas[j]
                break
            end
        end
    end
    self:setViewInfo(itemData)
end

function NpcBuyWin:setViewInfo(data)

    if self.itemList and #self.itemList > 0 then
        self.itemListView:removeAllItems()
        self.selectItem = nil
    end    

    self.itemList = {}
    local npcBuyWinItem = require("app.modules.npcDialog.NpcBuyWinItem")

    local goodsList = data
    local find = false
    for i=1,#goodsList do
        
        local item = self.itemListView:newItem()
        content = npcBuyWinItem.new(goodsList[i])
            
        self.itemList[i] = content
        item:addContent(content)
        item:setItemSize(333, 103)
        self.itemListView:addItem(item)
    end

    self.itemListView:reload()
end

function NpcBuyWin:open()
    if self.wealthChangEventId == nil then
        self.wealthChangEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,handler(self,self.onWealthChange))
    end

    self.datas = configHelper.getInstance():getStoreItemsByType(self.storeType)

    --云旅商人
    if self.storeType == 15 then
        if self.NPC15EventId == nil then
            self.NPC15EventId = GlobalEventSystem:addEventListener(SceneEvent.NPC_15_BUY,handler(self,self.handlerNpc15))
        end
        GameNet:sendMsgToSocket(16002)
    else
        self:setViewInfo(self.datas)
    end

    self:onWealthChange()
end

function NpcBuyWin:close()
  	if self.wealthChangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.wealthChangEventId)
        self.wealthChangEventId = nil
    end

    if self.NPC15EventId then
        GlobalEventSystem:removeEventListenerByHandle(self.NPC15EventId)
        self.NPC15EventId = nil
    end
    for k,v in pairs(self.itemList) do
        v:destory()
    end
    self.super.close(self)
end

function NpcBuyWin:destory()
    self:close()
    self.super.destory(self)
end

return NpcBuyWin



