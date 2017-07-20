--
-- Author: Shine
-- Date: 2016-09-27
-- 合服限购礼包
require("app.modules.mergeActivity.model.MergeActivityModel")
local MergeBuyWin = class("MergeBuyWin", BaseView)
local MergeBuyItem = class("MergeBuyItem", function()
    return display.newNode()
end)

function MergeBuyWin:ctor(winTag,data,winconfig)
	MergeBuyWin.super.ctor(self,winTag,data,{url = "resui/mergeBuyWin.ExportJson"})
    self._data = data
   	self.root:setPosition(0,0)
    self.timeLabel = self:seekNodeByName("timeLabel")
    local content = self:seekNodeByName("mainLayer")
    local size = content:getContentSize()
    self.listHeight = size.height
    self.scrollList = cc.ui.UIScrollView.new({viewRect = cc.rect(0, 0, size.width, size.height), direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
    self.scrollList:addScrollNode(display.newNode())
    content:addChild(self.scrollList)
     
	
end

function MergeBuyWin:update()
    local data = MergeActivityModel:getInstance():getActivityTypeData(self._data.id)
    self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
    self.itemData = data.goods_list
    if not self.addHandler then
        self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
            self:update_(...)
        end)
    end
    self.loaded = 1
    self.scrollList:getScrollNode():removeAllChildren()
    self.selectionItem = nil
    self.itemList = {}
    self:scheduleUpdate()
end

function MergeBuyWin:update_(...)
    local row = math.ceil(#self.itemData / 2.0)
    local w,h
    while self.loaded <= #self.itemData do
        local item = MergeBuyItem.new()
        local data = self.itemData[self.loaded]
        item:setData(data)
        item:setItemClickFunc(handler(self, self.onItemClick))
        item:setItemBtnClickFunc(handler(self, self.onItemBtnClick))
        w = item:getContentSize().width
        h = item:getContentSize().height
        item:setPosition( w * ((self.loaded - 1) % 2),  self.listHeight -  math.ceil(self.loaded / 2) * h)
        self.scrollList:getScrollNode():addChild(item)
        self.itemList[data.id] = item
        self.loaded = self.loaded + 1
    end
    self.scrollList:getScrollNode():setContentSize(self.scrollList:getContentSize().width, h * row)
    self:unscheduleUpdate()
end

function MergeBuyWin:onItemClick(item)
    if self.selectionItem == item then
       return
    end
    if self.selectionItem then
      self.selectionItem:setSelect(false)
    end
    self.selectionItem = item
    self.selectionItem:setSelect(true)
end

function MergeBuyWin:onItemBtnClick(item)
    GameNet:sendMsgToSocket(38042, {id =  item:getData().id, num = 1})
end

function MergeBuyWin:open()
    MergeBuyWin.super.open(self)
    if self.handle == nil then
        self.handle = GlobalEventSystem:addEventListener(MergeActivityEvent.UPDATE_MERGE_SHOP_DATA, handler(self,self.updateShopData))
    end
end

function MergeBuyWin:updateShopData(data)
    data = data.data
    for _,item in ipairs(self.itemData) do
        if item.id == data.id then
            item.buy_num = data.buy_num
            self.itemList[data.id]:refresh()
            break
        end
    end
    
end

function MergeBuyWin:close()
    MergeBuyWin.super.close(self)
    if self.handle then
        GlobalEventSystem:removeEventListenerByHandle(self.handle)
        self.handle = nil
    end
end

function MergeBuyWin:destory()
    self:close()
    MergeBuyWin.super.destory(self)

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
    local num = data.limit_num - data.buy_num
    self.numLabel:setString(tostring(num))
    if num == 0 then
        self.buyBtn:setButtonEnabled(false)
    else
        self.buyBtn:setButtonEnabled(true)
    end
end

function MergeBuyItem:refresh()
    local num = self._data.limit_num - self._data.buy_num
    self.numLabel:setString(tostring(num))
    if num == 0 then
        self.buyBtn:setButtonEnabled(false)
    else
        self.buyBtn:setButtonEnabled(true)
    end
end

function MergeBuyItem:setItemClickFunc(func)
    self.itemClickFunc = func
end

function MergeBuyItem:setItemBtnClickFunc(func)
    self.itemBtnClickFunc = func
end

function MergeBuyItem:setSelect(b)
    -- if b then
    --     self.bg:setSpriteFrame("com_listBg4Sel.png")
    -- else
    --     self.bg:setSpriteFrame("com_listBg4.png")
    -- end
end

function MergeBuyItem:getData()
    return self._data
end

function MergeBuyItem:destory()
end

return MergeBuyWin
