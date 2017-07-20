--异步加载ListView by shine
--必须使用修正过的cc.ui.UIListView
--通过 self:setNodeEventEnabled(true)自动清理资源
--@author shine

local UIAsyncListView =  class("UIAsyncListView", cc.ui.UIListView)

--增加pageSize
function UIAsyncListView:ctor(params)
	params.async = true
	UIAsyncListView.super.ctor(self, params)
    self.pageSize = params.pageSize or 20
    self.rowLoaded = 0 --已经加载的行
    self.isToBottom = false --是否要滚动到底部
    self:setDelegate(handler(self, self.listViewDelegate))
    self:setNodeEventEnabled(true)
end

function UIAsyncListView:onCleanup()
    UIAsyncListView.super.onCleanup(self)
    if self.adapter then
        self.adapter:destory()
    end
end

--动态代理
function UIAsyncListView:listViewDelegate(listview, tag, index, listitem)
    if tag == cc.ui.UIListView.COUNT_TAG then
        return self.adapter:getCount()
    elseif tag == cc.ui.UIListView.CELL_TAG then
        local itemView = self.adapter:getView(index, listitem, listview)
        if not itemView then 
            return nil
        end
        if self.isToBottom then
            self:checkScrollToBottom_(itemView:getContentSize(), index)
        end
        if  self.rowLoaded < index then
             self.rowLoaded = index
        end
        return itemView
    elseif tag == cc.ui.UIListView.UNLOAD_CELL_TAG then
        local content = listitem:getChildByTag(11)--UIListViewItem.CONTENT_TAG = 11
        if content and content.onUnLoaded() then
            content:onUnLoaded()
        end

    end
end

function UIAsyncListView:setAdapter(adapter)
	self.adapter = adapter
    adapter:setListView_(self)
end

function UIAsyncListView:getAdapter()
    return self.adapter
end

function UIAsyncListView:callListener_(event)
    UIAsyncListView.super.callListener_(self, event)
    if event.name == "moved" then
        self.isToBottom = false
    end
end

--滚动到底部
function UIAsyncListView:scrollToBottom()
    local itemCount = self.adapter:getCount() 
    if itemCount == 0 then return end
    local itemView = self.items_[#self.items_]
    if itemView == nil then
        self:reload()
        self:scrollToBottom()
        return
    else
        if  itemView.idx_ == self.adapter:getCount() then
            return
        end
        if cc.ui.UIScrollView.DIRECTION_VERTICAL == self.direction then
            local posY = - itemView:getPositionY() + itemView:getContentSize().height
            if posY < self.viewRect_.height then 
                self:reload() 
                return
            end
            self:scrollTo(0, posY)
        else
            local posX = itemView:getContentSize().width * 2 + itemView:getPositionX()
            if posX < self.viewRect_.width then 
                self:reload() 
                return
            end
            self:scrollTo(posX, 0)
        end
        
    end
    self.isToBottom = true
   
end

--检查是不是在底部，私有函数
function UIAsyncListView:checkScrollToBottom_(size, index)
    local itemView = self.items_[#self.items_]
    if itemView == nil then
        return
    end
    if index == self.adapter:getCount() then
        self.isToBottom = false
    end
    if cc.ui.UIScrollView.DIRECTION_VERTICAL == self.direction then
        local posY = - itemView:getPositionY() + size.height
        if posY < self.viewRect_.height then
            return 
        end
        self:scrollTo(0, posY)
    else
        local posX = itemView:getPositionX() + itemView:getContentSize().width + size.width
        if posX < self.viewRect_.width then 
            return 
        end
        self:scrollTo(posX, 0)
    end
end


function UIAsyncListView:update_(dt)
    if not self:isVisibleInViewRect() then
        return
    end
    UIAsyncListView.super.update_(self, dt)
end

--是否可见(没测试)
function UIAsyncListView:isVisibleInViewRect()
    if not self:isVisible() then
        return false
    end
    local box = self:getCascadeBoundingBox()--是否要转换成世界坐标？
    if box.x + box.width < 0 or box.x > display.width or box.y + box.height < 0 or box.y > display.height then
        return false
    end
    return true
end

--判断是否已经滚动到底部（尽头）
function UIAsyncListView:isScrollToBottom()
    if self.isToBottom then return true end 
    local count = self.adapter:getCount()
    if count == 0 then
        return true
    end
    local itemView = self.items_[#self.items_]
    if itemView == nil then
        return false
    end
    if itemView.idx_ ~= count then
        return false
    end
    if cc.ui.UIScrollView.DIRECTION_VERTICAL == self.direction then
        local posY = - itemView:getPositionY()
        if posY <= self.scrollNode:getPositionY() or posY <= self.viewRect_.height then
            return true
        end
    else
        local posX = itemView:getPositionX()
        if posX <= self.scrollNode:getPositionX() or posX <= self.viewRect_.width then
            return true
        end
    end
    return false
end


function UIAsyncListView:isSideShow()
    if not self.bAsyncLoad then
        return UIAsyncListView.super.isSideShow(self)    
    end
    local count = self.adapter:getCount()
    if count == 0 then
        return true
    end
    local scrollPosX, scrollPosY = self.scrollNode:getPosition()
    if cc.ui.UIScrollView.DIRECTION_VERTICAL == self.direction then
        if scrollPosY <= self.viewRect_.height then return true end
        local itemView = self.items_[#self.items_]
        if itemView.idx_ ~= count then return false end
        local posY = - itemView:getPositionY()
        if posY <= scrollPosY or posY <= self.viewRect_.height then
            return true
        end
    else
        if scrollPosX <= self.viewRect_.width then return true end
        local itemView = self.items_[#self.items_]
        if itemView.idx_ ~= count then return false end
        local posX = itemView:getPositionX()
        if posX <= scrollPosX or posX <= self.viewRect_.width then
            return true
        end
    end
    return false
end

function UIAsyncListView:getScrollPosition()
    return {x = self.container:getPositionX(),y = self.container:getPositionY()}
end
 
function UIAsyncListView:getFirstItem()
    
    if self.items_ then
        return self.items_[1]
    end

    return niLbl
end



return UIAsyncListView