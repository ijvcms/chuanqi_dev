--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 神皇密境
--
local ShengHuangMJWinRewardWin = class("ShengHuangMJWinRewardWin", BaseView)
function ShengHuangMJWinRewardWin:ctor(winTag,data,winconfig)
	
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
	self:addChild(self.bg)
	
	self.root = cc.uiloader:load("resui/shenhuangExchangeWin.ExportJson")
	self:addChild(self.root)

    self.root:setPosition((display.width-670)/2,(display.height-490)/2)

    self.closeBtn = self:seekNodeByName("btnClose")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
           	self:setVisible(false)
        end
        return true
    end)

    self.numLabel = self:seekNodeByName("numLabel")
    self.mainLayer = self:seekNodeByName("mainLayer")

    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 622, 370), --622,380
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)

    local skillUiItem = require("app.modules.shenghuangmj.ShengHuangMJRewardItem")
    self.configs = configHelper:getLuckdraw_exchangeConfig()
    local len = #self.configs
    self.itemList = {}
    local index = 0
    for i=1,math.ceil(len/4) do
        local viewe = display.newNode()
        viewe:setContentSize(152*4, 178)
        local content
        for i=1,4 do
            index = index +1
            if index <= len then
                content = skillUiItem.new()
                content:setData(self.configs[index])
                viewe:addChild(content)
                content:setPosition((i-1)*152,0)
                self.itemList[index] = content
            end
        end
        

        local item = self.itemListView:newItem()
        item:addContent(viewe)
        item:setItemSize(152*4, 178)
        self.itemListView:addItem(item)

        -- content:updateStar(self.starlist[i] or 0)
        --content:setPosition(-251,-45)
        --content:setAnchorPoint(cc.p(0.5, 0.5)
        
    end
    self.itemListView:reload()
    self.isCancelRemoveSpriteFrams = true
    self:setNodeEventEnabled(true)
end

function ShengHuangMJWinRewardWin:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        --self:onListClick(self.itemList[event.itemPos])
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end


function ShengHuangMJWinRewardWin:open(score)
   self.score = score
   self.numLabel:setString(self.score)
   if self.shenghuangExchangEventId == nil then
         self.shenghuangExchangEventId = GlobalEventSystem:addEventListener(ShenghuangEvent.SHENGHUANG_EXCHANG,handler(self,self.update))
    end
  
end

function ShengHuangMJWinRewardWin:update(data)
    self.score = data.data.lottery_score
    self.numLabel:setString(data.data.lottery_score)
end

function ShengHuangMJWinRewardWin:close()
    if self.itemList then
        for i=1,#self.itemList do
            self.itemList[i]:destory()
        end
        self.itemList = nil
    end
     if self.shenghuangExchangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.shenghuangExchangEventId)
        self.shenghuangExchangEventId = nil
    end
    ShengHuangMJWinRewardWin.super.close(self)
end


--清理界面
function ShengHuangMJWinRewardWin:destory()
    self:close()
    self.super.destory(self)
end

return ShengHuangMJWinRewardWin