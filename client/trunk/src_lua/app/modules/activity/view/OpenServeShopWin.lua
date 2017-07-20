--
-- Author: Yi hanneng
-- Date: 2016-08-23 16:51:57
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local  OpenServeShopItem = import(".OpenServeShopItem")
local batchBuyWin  = import("app.modules.store.view.batchBuyWin")

local OpenServeShopWin = OpenServeShopWin or class("OpenServeShopWin", BaseView)

function OpenServeShopWin:ctor(w,h)
 
   	self:setContentSize(cc.size(w,h))
   	self:init()

end

function OpenServeShopWin:init()
	self.itemList = {}
    self.layer = display.newNode()
	self.layer:setContentSize(cc.size(self:getContentSize().width - 10 , self:getContentSize().height - 10))
	self.listView = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self:getContentSize().width - 10 , self:getContentSize().height - 10)}):addScrollNode(self.layer):pos(0,2)
	self.listView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
	self.listView:setTouchSwallowEnabled(false)
	self:addChild(self.listView)
end

function OpenServeShopWin:itemClick(data)

	if data == nil or data.id == nil then
		return
	end

	local bw = batchBuyWin.new({
        title="购买道具",

        sureText="购买",

        clickFunc=function(curCount,data)
            --发送购买商城物品协议
            GlobalController.activity:requestActivityServiceBuy(data.id,curCount)
        end,
        countFunc=function(curCount,label)
            local coinString = "金币"
            if data.curr_type == 1 then
                coinString = "金币"
            elseif data.curr_type == 2 then
                coinString = "元宝"
            elseif data.curr_type == 3 then
                coinString = "绑定元宝"
            end
            label:setString("总共"..curCount*data.price..coinString)
        end,

        data = data
    })

	bw:setMax(data.limit_num - data.buy_num)

    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,bw)
	
end

function OpenServeShopWin:setViewInfo(data)
	

	if data == nil then
		return
	end
 
	self.data = data
 
 	local bossDataList = data.goods_list
 
    local itemWidth = 0
    local itemHeight = 0
    local len = #bossDataList
    local loaded = 0

    if len == 0 then
    	return
    end

    for i=#self.itemList,len + 1, -1 do
        self.itemList[i]:setVisible(false)
    end

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function()
            
    	if bossDataList and  loaded < len then
           	loaded = loaded + 1
            local info = bossDataList[loaded]
            if info then

            	if self.itemList[loaded] == nil then
            		local item = OpenServeShopItem.new()
	                self:selectFunc(item)
	                self.layer:addChild(item)
	                self.itemList[loaded] = item
            	end
               	
                self.itemList[loaded]:setVisible(true)
               	self.itemList[loaded]:setData(info)
                itemWidth = self.itemList[loaded]:getContentSize().width + 14
                itemHeight = self.itemList[loaded]:getContentSize().height + 10

                self.itemList[loaded]:setPosition(((loaded-1)%2)*itemWidth + 10,itemHeight*math.ceil(#bossDataList/2) - math.floor((loaded-1)/2)*itemHeight - itemHeight/2)
            end
        end

        if loaded == len then
            self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
            self.layer:setContentSize(cc.size(itemWidth*2, itemHeight*math.ceil(#bossDataList/2)))
            self.layer:setPosition(0, self:getContentSize().height - self.layer:getContentSize().height - itemHeight/2 - 10 )
        end
    end)

    self:scheduleUpdate()

end

function OpenServeShopWin:selectFunc(item)

	if item ~= nil then

        item:setItemBtnClickFunc(handler(self, self.itemClick))
 
	end

end

function OpenServeShopWin:buySuccess(data)
    if data == nil then
        return 
    end
  
    data = data.data.active_shop_info

    for i=1,#self.itemList,1 do
        local info = self.itemList[i]:getData()
        if info.id == data.id then
            self.itemList[i]:setData(data)
        end
         
    end

end

function OpenServeShopWin:open(data)
	GlobalEventSystem:addEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_SHOP_BUY,handler(self,self.buySuccess))
	--self.rankListAdapter:setData(data.rewards)
end

function OpenServeShopWin:close()
	GlobalEventSystem:removeEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_SHOP_BUY)
end

function OpenServeShopWin:destory()
	self:close()
    OpenServeShopWin.super.destory(self)
end

return OpenServeShopWin