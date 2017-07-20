--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 16:18:25
-- 合服首杀
local mergeBossWin = mergeBossWin or class("mergeBossWin", BaseView)

function mergeBossWin:ctor(winTag,data,winconfig)
    self.data = data
	mergeBossWin.super.ctor(self,winTag,data,{url = "resui/"..data.viewType..".ExportJson"})
   	self.root:setPosition(0,0)
    
    self.mainLayer = self:seekNodeByName("mainLayer")

	self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 658, 352),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)
    self.itemListView:setPosition(0,0)

    self.timeLabel = self:seekNodeByName("timeLabel")
    self.itemList = {}
end

function mergeBossWin:update()
    self.serverData = MergeActivityModel:getInstance():getActivityTypeData(self.data.id)
    if not self.serverData then return end

    local list = self.serverData.active_service_list
    local listItem = require("app.modules.mergeActivity.view.item.mergeBossItem")
    for i=1,#list do
    	local activeServiceId = list[i].active_service_id
    
    	local content = self.itemList[activeServiceId]
    	if content == nil then
            local item = self.itemListView:newItem()
            content = listItem.new(list[i])
            self.itemList[activeServiceId] = content
            item:addContent(content)
            item:setItemSize(658, 160)
            self.itemListView:addItem(item)
        end

    end
    self.itemListView:reload()
    --self.timeLabel = self:seekNodeByName("timeLabel")
    self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",self.serverData.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",self.serverData.end_time))
end

function mergeBossWin:touchListener(event)
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

function mergeBossWin:getMergePrizeSuccess(data)
	for k,v in pairs(self.itemList) do
		 if data.data == v.active_service_id then
		 	v.data.is_receive = 2
		 	v:update()
		 end
	end
end

function mergeBossWin:open()
    mergeBossWin.super.open(self)
     if self.getMergePrizeSuccessEventId == nil then
        self.getMergePrizeSuccessEventId = GlobalEventSystem:addEventListener(MergeActivityEvent.GET_MERGE_PRIZE_SUCCESS,handler(self,self.getMergePrizeSuccess))
    end
end

function mergeBossWin:close()
    mergeBossWin.super.close(self)
    if self.getMergePrizeSuccessEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.getMergePrizeSuccessEventId)
        self.getMergePrizeSuccessEventId = nil
    end
end

function mergeBossWin:destory()
    self:close()
    mergeBossWin.super.destory(self)
    for k,v in pairs(self.itemList or {}) do
    	v:destory()
    	self.itemList[k] = nil
    end
end

return mergeBossWin
