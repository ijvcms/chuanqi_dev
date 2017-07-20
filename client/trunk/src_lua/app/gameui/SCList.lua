--
-- Author: Yi hanneng
-- Date: 2016-01-20 09:29:58
--

--排序
SORT_TYPE = {
	
	SORT_NONE = -1,
	SORT_UP = 1,
	SORT_DOWN = 0,

}
 
local SCList = SCList or class("SCList", function() return display.newNode() end )
function SCList:ctor(rect,direction)
 
	self.itemList = {}
 	self.itemDataList = {}
	self.itemClickFunc = nil
	self.itemClass = nil
 
	self.currentSortType = SORT_TYPE.SORT_NONE
 	self.loadFunc = nil
 	self.loading = false
 	self.lastClickItem = nil
	self.driection = direction

	self:setContentSize(cc.size(rect.width, rect.height))
	self:init(rect,direction)
end

function SCList:init(rect,direction)

	self.listView = cc.ui.UIListView.new {
        viewRect = rect,
        direction = direction,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self)

end
 
function SCList:setData(dataList,Item,conditionFuc)
 	
	if dataList == nil or Item == nil then
		return
	end

	self.itemClass = Item
 	self.loading = false

  	for i=1,#dataList do
  		if conditionFuc == nil or conditionFuc(dataList[i]) then -- self:hasItemDataById(dataList[i].sale_id) 
			local item = self.listView:newItem()
			local content = Item.new()
			content:setData(dataList[i])
			item:addContent(content)
			self.itemSize = content:getContentSize()
		    item:setItemSize(content:getContentSize().width, content:getContentSize().height)
	 
			self.itemList[#self.itemList + 1] = content
			self.itemDataList[#self.itemDataList + 1] = dataList[i]
			self.listView:addItem(item)
		end
	end

	self.listView:reload()
	if self.hasItemsCount and self.hasItemsCount > 0 then

		if self.driection == cc.ui.UIScrollView.DIRECTION_VERTICAL then
			self.listView:scrollTo(self.listView:getScrollNode():getPositionX(),self.listView:getViewRect().height - #self.itemList*self.itemSize.height + self.hasItemsCount*self.itemSize.height + 20)
		elseif self.driection == cc.ui.UIScrollView.DIRECTION_HORIZONTAL then
			self.listView:scrollTo(self.listView:getViewRect().width - #self.itemList*self.itemSize.width + self.hasItemsCount*self.itemSize.width + 20,self.listView:getScrollNode():getPositionY())
		end
 
	end


end
--回调
function SCList:setItemClickFunc(func)
	self.itemClickFunc = func
end
--设置加载函数
function SCList:setLoadFunc(func)
	self.loadFunc = func
end 

function SCList:touchListener(event)
	 local listView = event.listView

    if "clicked" == event.name then

    	if self.lastClickItem  then
    		self.lastClickItem:setSelect(false)
    	end

        local item = self.itemList[event.itemPos]
        self.lastClickItem = item
     
 		if item then
 			item:setSelect(true)
 		end

 		if self.itemClickFunc ~= nil then
 			self.itemClickFunc(item)
 		end
 	
    elseif "moved" == event.name then
        
    elseif "ended" == event.name then
    
    	if self.driection == cc.ui.UIScrollView.DIRECTION_VERTICAL then
			if listView:getScrollNode():getPositionY() > 0 and not self.loading then
        	self.hasItemsCount = #self.itemList

        	if self.loadFunc ~= nil then
        		self.loading = true
 				self.loadFunc(item)
 			end
        	end
		elseif self.driection == cc.ui.UIScrollView.DIRECTION_HORIZONTAL then
			if listView:getScrollNode():getPositionX() > 0 and not self.loading then
        	self.hasItemsCount = #self.itemList

        	if self.loadFunc ~= nil then
        		self.loading = true
 				self.loadFunc(item)
 			end
        	end
		end
        
        
    end
end

function SCList:getItemsNum()
	if self.itemList ~= nil then
		return #self.itemList
	else
		return 0
	end
end

function SCList:getItems()
	return self.itemList
end

function SCList:setSort(flag)
	self.currentSortType = flag
end

function SCList:sort(flag,key)

	if self.currentSortType == flag then
		return
	end

	self.currentSortType = flag

	if self.itemDataList and #self.itemDataList > 1 and self.itemClass ~= nil then

		if self.currentSortType == SORT_TYPE.SORT_UP then
			table.sort( self.itemDataList, function(a,b) return a[key] < b[key] end )
		elseif self.currentSortType == SORT_TYPE.SORT_DOWN then
			table.sort( self.itemDataList, function(a,b) return a[key] > b[key] end )
		end

		if self.listView then
			self.listView:removeAllItems()
		end
		self.itemList = {}
 
		self.lastClickItem = nil
		self.loading = false
		 

	 	for i=1,#self.itemDataList do
			local item = self.listView:newItem()
			local content = self.itemClass.new()
			content:setData(self.itemDataList[i])
			item:addContent(content)
		    item:setItemSize(content:getContentSize().width, content:getContentSize().height)
	 
			self.itemList[#self.itemList + 1] = content
			self.listView:addItem(item)
		end

		self.listView:reload()
		
	end
end

function SCList:scrollAuto()
	if self.listView then
		self.listView:scrollAuto()
	end
end

function SCList:clear()
	if self.listView then
		self.listView:removeAllItems()
	end
	self.itemList = {}
	self.itemDataList = {}
	self.lastClickItem = nil
	self.loading = false
end
 
function SCList:destory()
	
	if self.listView then
		self.listView:removeAllItems()
		self.listView:removeSelf()
	end
 
	self.itemList = {}
	self.itemDataList = {}
	self.itemWidth = 0
	self.itemHeight = 0
	self.itemClickFunc = nil
 	self.loadFunc = nil

end

return SCList