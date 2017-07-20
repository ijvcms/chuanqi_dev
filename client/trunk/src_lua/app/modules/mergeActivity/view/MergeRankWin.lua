--
-- Author: Shine
-- Date: 2016-09-27
-- 合服限购礼包
require("app.modules.mergeActivity.model.MergeActivityModel")
local MergeRankWin = class("MergeRankWin", BaseView)
local MergeBuyItem = class("MergeBuyItem", function()
    return display.newNode()
end)

function MergeRankWin:ctor(winTag,data,winconfig)
	MergeRankWin.super.ctor(self,winTag,data,{url = "resui/mergeRankWin.ExportJson"})
    self._data = data
   	self.root:setPosition(0,0)
   	self.timeLabel = self:seekNodeByName("timeLabel")
   	self.myRankLabel = self:seekNodeByName("rankLabel")
   	self.myNumLabel = self:seekNodeByName("numLabel")
   	self.rank1 = self:seekNodeByName("rank1")
   	self.rank2 = self:seekNodeByName("rank2")
   	self.rank3 = self:seekNodeByName("rank3")
   	
    local content = self:seekNodeByName("leftLayer")
    local size = content:getContentSize()
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, size.width, size.height)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0, 0, size.width, size.height))
    self.listAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/mergeRankItem.ExportJson", "app.modules.mergeActivity.view.MergeRankItem", 20)
    self.listView:setAdapter(self.listAdapter)
    local data = configHelper:getActiveServiceMergeByType(self._data.id)
    local itemData = {}
    local key = "reward_"..RoleManager:getInstance().roleInfo.career
    
    for k,v in pairs(data) do
    	table.insert(itemData, {rank = v.rank, goods = v[key]})
    end
    
    if #itemData > 1 then
        table.sort(itemData,function(a,b) return a.rank < b.rank end)
    end

    self.listAdapter:setData(itemData)
	content:addChild(self.listView)
end

function MergeRankWin:update()
    local data = MergeActivityModel:getInstance():getActivityTypeData(self._data.id)
    self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
    self.myRankLabel:setString(data.my_rank)
    self.myNumLabel:setString(data.my_lv)
    local idx = 1
    while idx <=#data.rank_list do
    	local rank = self["rank"..idx]
    	rank:setString(idx.."、"..data.rank_list[idx].name)
    	rank:setVisible(true)
    	idx = idx + 1
    end
    while idx <= 3 do
    	self["rank"..idx]:setVisible(false)
    	idx = idx + 1
    end
end



function MergeRankWin:onItemClick(item)
   if self.selectionItem == item then
      return
   end
   if self.selectionItem then
      self.selectionItem:setSelect(false)
   end
   self.selectionItem = item
   self.selectionItem:setSelect(true)
end

function MergeRankWin:onItemBtnClick(item)
    GameNet:sendMsgToSocket(38042, {id =  item:getData().id, num = 1})
   
end

function MergeRankWin:open()
    MergeRankWin.super.open(self)

end

function MergeRankWin:close()
    MergeRankWin.super.close(self)

end

function MergeRankWin:destory()
    MergeRankWin.super.destory(self)

end

--================================================ Item ====================================
function MergeBuyItem:ctor()
    self.ccui = cc.uiloader:load("resui/mergeBuyItem.ExportJson")
    local size = self.ccui:getContentSize()
    self:setContentSize(size)
    self:init()
    self:addChild(self.ccui)
end

function MergeBuyItem:init()

    self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")
    local itemBg = cc.uiloader:seekNodeByName(self.ccui, "item")
     --图标
    self.item = CommonItemCell.new()
    local size = itemBg:getContentSize()
    self.item:setPosition(size.width / 2, size.height / 2)
    itemBg:addChild(self.item) 
    self.priceOld = cc.uiloader:seekNodeByName(self.ccui, "priceOld")
    self.priceNow = cc.uiloader:seekNodeByName(self.ccui, "priceNow")
    self.coin1 = cc.uiloader:seekNodeByName(self.ccui, "coin1")
    self.coin2 = cc.uiloader:seekNodeByName(self.ccui, "coin2")
    self.numLabel = cc.uiloader:seekNodeByName(self.ccui, "numLabel")
    self.bg = cc.uiloader:seekNodeByName(self.ccui, "Bg")
    self.bg:setTouchEnabled(true)
    self.bg:setTouchSwallowEnabled(false)
    self.bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            if self.itemClickFunc then
                self.itemClickFunc(self)
            end
            
        end     
        return true
    end)
    self.buyBtn = cc.uiloader:seekNodeByName(self.ccui, "buyBtn")
    self.buyBtn:setTouchEnabled(true)
    self.buyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.buyBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.buyBtn:setScale(1.0)
            if self.itemBtnClickFunc then
                self.itemBtnClickFunc(self)
            end
        end     
        return true
    end)
end

function MergeBuyItem:setData(data)
    if data == nil or self._data == data then
        return 
    end
    self._data = data
    self.titleLabel:setString(configHelper:getGoodNameByGoodId(data.goods_id))
    self.item:setData(data)
    self.priceOld:setString(data.price_old)
    self.priceNow:setString(data.price)
    local pic = "com_coin_"..data.curr_type..".png"
    self.coin1:setSpriteFrame(pic)
    self.coin2:setSpriteFrame(pic)
    self.numLabel:setString(tostring(data.limit_num - data.buy_num))
end



function MergeBuyItem:setItemClickFunc(func)
    self.itemClickFunc = func
end

function MergeBuyItem:setItemBtnClickFunc(func)
    self.itemBtnClickFunc = func
end

function MergeBuyItem:setSelect(b)
    if b then
        self.bg:setSpriteFrame("com_listBg4Sel.png")
    else
        self.bg:setSpriteFrame("com_listBg4.png")
    end
end

function MergeBuyItem:getData()
    return self._data
end

function MergeBuyItem:destory()
    
end

return MergeRankWin
