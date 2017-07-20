--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 14:23:39
-- 活服活动
local MergeActivityWin = MergeActivityWin or class("MergeActivityWin", BaseView)

function MergeActivityWin:ctor(winTag,data,winconfig)
	MergeActivityWin.super.ctor(self,winTag,data,winconfig)
    
    self.leftLayer = self:seekNodeByName("leftLayer")
    self.rightLayer = self:seekNodeByName("rightLayer")

     --左边技能列表
    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 185, 475),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.leftLayer)
    self.itemListView:setPosition(5,6)

    self.selItem = nil
    self.itemList = {}

    self.activityViewList = {}
end

function MergeActivityWin:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
    	if self.selItem then
    		self.selItem:setSelect(false)
    		self:closeView(self.selItem:getId())
    	end
    	if self.itemList[event.itemPos] then
	    	self.selItem = self.itemList[event.itemPos]
	        self.selItem:setSelect(true)
	        self:openView(self.selItem:getId())
	    end
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end

function MergeActivityWin:openView(id)
	if self.activityViewList[id] then
		self.activityViewList[id]:open()
        self.activityViewList[id]:update()
		self.activityViewList[id]:setVisible(true)
	else
		GlobalController.mergeActivity:send38012(id)
        local vo = self.activityList[id]
		if vo.viewType then
			local view = require("app.modules.mergeActivity.view."..vo.viewType).new(self.winTag,vo)
			self.activityViewList[id] = view
			self.rightLayer:addChild(view)
			view:open()
            print(view:getPosition())
            print(self.rightLayer:getPosition())
            print(vo.viewType)
		end
	end 

    GameNet:sendMsgToSocket(38043,{list_id = id})
end

function MergeActivityWin:closeView(id)
	if self.activityViewList[id] then
		self.activityViewList[id]:close()
		self.activityViewList[id]:setVisible(false)
	end
end

function MergeActivityWin:updateActivityType()
    local listItem = require("app.modules.mergeActivity.MergeActivityListItem")
    self.activityList = {}
    local activityTypeInfo = self.model:getActivityTypeInfo()

    --test zhangshunqiu
    -- local list = {}
    -- table.insert(list,{type_id = 1,state = 1})
    -- table.insert(list,{type_id = 2,state = 1})
    -- table.insert(list,{type_id = 9,state = 1})
    -- table.insert(list,{type_id = 15,state = 1})
    -- table.insert(list,{type_id = 16,state = 1})
    -- table.insert(list,{type_id = 17,state = 1})
    -- table.insert(list,{type_id = 18,state = 1})
    -- table.insert(list,{type_id = 19,state = 1})
    -- table.insert(list,{type_id = 20,state = 1})

    -- activityTypeInfo = list
      --test zhangshunqiu

    for i=1,#activityTypeInfo do
        activityTypeInfo[i].sort = configHelper:getActiveServiceMergeType(activityTypeInfo[i].type_id).sort
    end
    table.sort(activityTypeInfo,function(a,b) return a.sort < b.sort end)
    for i=1,#activityTypeInfo do
        local typeId = activityTypeInfo[i].type_id
        self.activityList[typeId] = configHelper:getActiveServiceMergeType(typeId)
        local content = self.itemList[i]
        if content == nil then
            local item = self.itemListView:newItem()
            content = listItem.new(self.activityList[typeId])
            self.itemList[i] = content
            item:addContent(content)
            item:setItemSize(185, 48)
            self.itemListView:addItem(item)
            if self.activityList[typeId].tipsId ~= 0 and self.activityList[typeId].tipsId ~= "" then
                local btnTips = BaseTipsBtn.new(self.activityList[typeId].tipsId,content,162,36)
            end
        end

        if i == 1 then
            self.selItem = content
            self.selItem:setSelect(true)
            self:openView(self.selItem:getId())
        end

    end
    self.itemListView:reload()
end


function MergeActivityWin:updateMerageActivityData()
    if self.selItem then
        local typeId = self.selItem:getId()
        if self.activityViewList[typeId] then
            self.activityViewList[typeId]:update()
        end
    end
end

function MergeActivityWin:open()
    MergeActivityWin.super.open(self)
    self.model = MergeActivityModel:getInstance()
    GameNet:sendMsgToSocket(38019)
    if self.updateActivityEventId == nil then
        self.updateActivityEventId = GlobalEventSystem:addEventListener(MergeActivityEvent.UPDATE_ACTIVITY_TYPE,handler(self,self.updateActivityType))
    end

    if self.updateMerageDataEventId == nil then
        self.updateMerageDataEventId = GlobalEventSystem:addEventListener(MergeActivityEvent.UPDATE_MERGE_ACTIVITY_DATA,handler(self,self.updateMerageActivityData))
    end
     --test zhangshunqiu
    --self:updateActivityType()
end

local function _removeEvent(self)
    if self.updateActivityEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateActivityEventId)
        self.updateActivityEventId = nil
    end

    if self.updateMerageDataEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateMerageDataEventId)
        self.updateMerageDataEventId = nil
    end
end


function MergeActivityWin:close()
    MergeActivityWin.super.close(self)
    _removeEvent(self)
   
    for k,v in pairs(self.activityViewList or {}) do
        v:close()
    end
end

function MergeActivityWin:destory()

    _removeEvent(self)
    MergeActivityWin.super.destory(self)
    for k,v in pairs(self.activityViewList or {}) do
    	v:destory()
    end
    self.activityViewList = nil
    self.selItem = nil
end

return MergeActivityWin