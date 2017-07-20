--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 16:18:25
-- 合服登录奖励
local mergeLoginWin = mergeLoginWin or class("mergeLoginWin", BaseView)

function mergeLoginWin:ctor(winTag,data,winconfig)
    self.data = data
	mergeLoginWin.super.ctor(self,winTag,data,{url = "resui/"..data.viewType..".ExportJson"})
   	self.root:setPosition(0,0)--
    
    self.mainLayer = self:seekNodeByName("mainLayer")
    -- self.rightLayer = self:seekNodeByName("rightLayer")

   --  self.closeBtn = self:seekNodeByName("btnClose")
  	-- self.closeBtn:setTouchEnabled(true)
  	-- self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
   --      if event.name == "began" then
   --          self.closeBtn:setScale(1.1)
   --      elseif event.name == "ended" then
   --          self.closeBtn:setScale(1)
   --          GlobalWinManger:closeWin(self.winTag)
   --      end
   --      return true
  	-- end)
	
	--左边技能列表
    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 658, 380),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)
    self.itemListView:setPosition(0,0)

    self.itemList = {}
    self.timeLabel = self:seekNodeByName("timeLabel")
end

function mergeLoginWin:update()
     --test zhangshunqiu
    self.serverData = MergeActivityModel:getInstance():getActivityTypeData(self.data.id)

    local list = self.serverData.active_service_list
    local listItem = require("app.modules.mergeActivity.view.item.mergeLoginItem")
    for i=1,#list do
    	local activeServiceId = list[i].active_service_id
    
    	local content = self.itemList[activeServiceId]
    	if content == nil then
            local item = self.itemListView:newItem()
            content = listItem.new(list[i])
            self.itemList[activeServiceId] = content
            item:addContent(content)
            item:setItemSize(658, 134)
            self.itemListView:addItem(item)
        end

    end
    self.itemListView:reload()
    self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",self.serverData.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",self.serverData.end_time))
     --test zhangshunqiu
end


function mergeLoginWin:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
    	-- if self.selItem then
    	-- 	self.selItem:setSelect(false)
    	-- 	self:closeView(self.selItem:getId())
    	-- end
    	-- if self.itemList[event.itemPos] then
	    -- 	self.selItem = self.itemList[event.itemPos]
	    --     self.selItem:setSelect(true)
	    --     self:openView(self.selItem:getId())
	    -- end
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end

function mergeLoginWin:getMergePrizeSuccess(data)
	for k,v in pairs(self.itemList) do
		 if data.data == v.active_service_id then
		 	v.data.is_receive = 2
		 	v:update()
		 end
	end
end


function mergeLoginWin:open()
    mergeLoginWin.super.open(self)
    if self.getMergePrizeSuccessEventId == nil then
        self.getMergePrizeSuccessEventId = GlobalEventSystem:addEventListener(MergeActivityEvent.GET_MERGE_PRIZE_SUCCESS,handler(self,self.getMergePrizeSuccess))
    end
end

function mergeLoginWin:close()
    mergeLoginWin.super.close(self)
    if self.getMergePrizeSuccessEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.getMergePrizeSuccessEventId)
        self.getMergePrizeSuccessEventId = nil
    end
end

function mergeLoginWin:destory()
    self:close()
    mergeLoginWin.super.destory(self)
    for k,v in pairs(self.itemList or {}) do
    	v:destory()
    	self.itemList[k] = nil
    end
end

return mergeLoginWin
