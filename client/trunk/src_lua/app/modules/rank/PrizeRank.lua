--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-02-09 15:57:55
-- 奖励排行
--
local PrizeRank = PrizeRank or class("PrizeRank", BaseView)

function PrizeRank:ctor(winTag,data,winconfig)
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)
	self.super.ctor(self,winTag,data,winconfig)
    local root = self:getRoot()
  	root:setPosition((display.width-360)/2,(display.height-440)/2)
  	self:creatPillar()
  	
  	self:setTouchEnabled(true)
  	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            GlobalWinManger:closeWin(self.winTag)
        end     
        return true
    end)
   
    self.mainLayer = self:seekNodeByName("mainLayer")

    --左边技能列表
    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 330, 355),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)

    self.itemList = {}
end


function PrizeRank:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        --self:onListClick(self.itemList[event.itemPos])
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end

function PrizeRank:open()
    PrizeRank.super.open(self)
    local prizeRankItem = require("app.modules.rank.PrizeRankItem")
    local list = configHelper:getDreamland_rankByType(self.data.type)
    for i=1,#list do
		local content = self.itemList[i]
		if content == nil then
            local item = self.itemListView:newItem()
			content = prizeRankItem.new()
        	content:setData(list[i])

			self.itemList[i] = content
            item:addContent(content)
            item:setItemSize(306, 116)
            self.itemListView:addItem(item)
		end
	end
    self.itemListView:reload()

end

function PrizeRank:close()
  	 for k,v in pairs(self.itemList) do
  	 	v:destory()
  	 end
  	 self.itemList = {}
end



return PrizeRank