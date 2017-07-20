--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 16:18:25
-- 合服累冲礼包
local mergeTotalChargeWin = mergeTotalChargeWin or class("mergeTotalChargeWin", BaseView)

function mergeTotalChargeWin:ctor(winTag,data,winconfig)
    self.data = data
	mergeTotalChargeWin.super.ctor(self,winTag,data,{url = "resui/"..data.viewType..".ExportJson"})
   	self.root:setPosition(0,0)
    
    
    self.mainLayer = self:seekNodeByName("mainLayer")
    self.timeLabel = self:seekNodeByName("timeLabel")
    self.chargeNumLab = self:seekNodeByName("Label_9_0")

	self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 658, 352),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)
    self.itemListView:setPosition(0,0)

    self.itemList = {}
    
end

function mergeTotalChargeWin:update()
    self.serverData = MergeActivityModel:getInstance():getActivityTypeData(self.data.id)
    self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",self.serverData.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",self.serverData.end_time))
    self.chargeNumLab:setString(self.serverData.my_value)
    local list = self.serverData.active_service_list
    local listItem = require("app.modules.mergeActivity.view.item.mergeTotalChargeItem")
    for i=1,#list do
    	local activeServiceId = list[i].active_service_id
    
    	local content = self.itemList[activeServiceId]
    	if content == nil then
            local item = self.itemListView:newItem()
            content = listItem.new(list[i])
            self.itemList[activeServiceId] = content
            item:addContent(content)
            item:setItemSize(658, 155)
            self.itemListView:addItem(item)
        end

    end
    self.itemListView:reload()
end

function mergeTotalChargeWin:touchListener(event)
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

function mergeTotalChargeWin:getMergePrizeSuccess(data)
	for k,v in pairs(self.itemList) do
		 if data.data == v.active_service_id then
		 	v.data.is_receive = 2
		 	v:update()
		 end
	end
end

function mergeTotalChargeWin:open()
    mergeTotalChargeWin.super.open(self)
    if self.getMergePrizeSuccessEventId == nil then
        self.getMergePrizeSuccessEventId = GlobalEventSystem:addEventListener(MergeActivityEvent.GET_MERGE_PRIZE_SUCCESS,handler(self,self.getMergePrizeSuccess))
    end
end

function mergeTotalChargeWin:close()
    mergeTotalChargeWin.super.close(self)
    if self.getMergePrizeSuccessEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.getMergePrizeSuccessEventId)
        self.getMergePrizeSuccessEventId = nil
    end
end

function mergeTotalChargeWin:destory()
    mergeTotalChargeWin.super.destory(self)
    self:close()
    for k,v in pairs(self.itemList or {}) do
    	v:destory()
    	self.itemList[k] = nil
    end
end

return mergeTotalChargeWin
