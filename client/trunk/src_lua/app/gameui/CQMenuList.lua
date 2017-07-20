--
-- Author: zhangshunqiu
-- Date: 2017-05-24 15:10:02
--
--[[
 	多级菜单
--]]
SCLIST_TYPE = {
	SCLIST_MENU = "SCLIST_MENU",
	SCLIST_SUBITEM = "SCLIST_SUBITEM",

}
 
local CQMenuList = CQMenuList or class("CQMenuList", function() return display.newNode() end )
function CQMenuList:ctor(rect,direction)
 
	self.itemList = {}
	self.itemClickFunc = nil
	self.menuItemClickFunc = nil
	self.item = nil
	self.driection = direction

	self:setContentSize(cc.size(rect.width, rect.height))
	self:init(rect,direction)
end

function CQMenuList:init(rect,direction)

	self.listView = SCUIList.new {
        viewRect = rect,
        direction = direction,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self)

end
--[[
 
--]]
function CQMenuList:setData(menudata,data,item)

 	if data == nil or item == nil then
 		return 
 	end

 	self.data = data
 	self.item = item
 
 	if menudata then
 		self:createItem(menudata,0)
 	end
 	
end
--创建item
function CQMenuList:createItem(dataList,pos)

 	local list = dataList

 	for i=1,#list do
 
		local item = self.listView:newItem()
		local content = self.item.new(list[i])
		item:addContent(content)
	    item:setItemSize(content:getContentSize().width, content:getContentSize().height,true)
		table.insert(self.itemList, pos + i, content)
		self.listView:addItem(item,pos+i)

	end
 
	self.listView:reload()
end
--回调
function CQMenuList:setItemClickFunc(func)
	self.itemClickFunc = func
end

--回调
function CQMenuList:setMenuItemClickFunc(func)
	self.menuItemClickFunc = func
end
--触摸
function CQMenuList:touchListener(event)
	 local listView = event.listView

    if "clicked" == event.name then
 
        local item =self.itemList[event.itemPos]

 		if item:getType() == SCLIST_TYPE.SCLIST_MENU then

 			local posx = listView:getScrollNode():getPositionX()
 			local posy = listView:getScrollNode():getPositionY()
 			local key = item:getData().subKey
  		 
 			if item:isSelected() then
 				self:close(key,event.itemPos)
 				item:selected(false)
 			 
 			else 
 				self:open(key,event.itemPos)
 				item:selected(true)
 				self.temDelLen = 0
				self:findReadyDel(self.data[key])
  
 			end
 		 
 			--listView:scrollTo(posx, posy)

 			if self.menuItemClickFunc ~= nil then
 				self.menuItemClickFunc(item)
 			end
 	 
 		elseif  item:getType() == SCLIST_TYPE.SCLIST_SUBITEM  then

 			if self.lastItem ~= nil then
 				self.lastItem:selected(false)
 			end

 			self.lastItem = item
 			item:selected(true)
 			if self.itemClickFunc ~= nil then
 				self.itemClickFunc(item)
 			end
 		end
    elseif "moved" == event.name then

    elseif "ended" == event.name then
        
    end
end
--打开菜单
function CQMenuList:open(key, pos)

	if not self.data[key] then
		return
	end

  	self:createItem(self.data[key],pos)
 
end
--关闭某菜单
function CQMenuList:close(key,pos)

	if not self.data[key] then
		return
	end
	self.temDelLen = 0

	self:findReadyDel(self.data[key])
 	 
	for i = self.temDelLen,1,-1 do
		local item = self.itemList[pos + i]
		if self.lastItem == item then
			self.lastItem = nil
		end
		table.remove(self.itemList, pos + i)
		self.listView:removeItem(item:getParent())
		self.listView:reload()
	end
 
end

function CQMenuList:clickItem(pos)
	local item = self.itemList[pos]
	if item:getType() == SCLIST_TYPE.SCLIST_MENU then
		self:open(item:getData().subKey, pos)
 	    item:selected(true)
 	    self.temDelLen = 0
	    self:findReadyDel(self.data[key])
	    if self.menuItemClickFunc ~= nil then
 			self.menuItemClickFunc(item)
 		end
	elseif  item:getType() == SCLIST_TYPE.SCLIST_SUBITEM  then
        if self.lastItem ~= nil then
 			self.lastItem:selected(false)
 		end
 		self.lastItem = item
 		item:selected(true)
 		if self.itemClickFunc ~= nil then
 			self.itemClickFunc(item)
 		end
 	end
 			    
end

--查找准备删除子项
function CQMenuList:findReadyDel(data)

	if type(data) ~= "table" then
		return 
	end

	for k,v in pairs(data) do
 
		self.temDelLen = self.temDelLen + 1
		if v.subKey ~= nil and self:checkMenuItemSelect(v) == true then
			self:findReadyDel(self.data[v.subKey])
		end
	end

end
--查找item
function CQMenuList:checkMenuItemSelect(data)
 
	if not self.itemList then
		return
	end

	for i=1,#self.itemList do
		 if data.subKey == self.itemList[i]:getData().subKey and data.name == self.itemList[i]:getData().name then
		 	return self.itemList[i]:isSelected()
		 end
	end
 	
 	return false
end

function CQMenuList:selectOne(num)
	if self.itemList then
		if self.itemList[num] then
			local item =self.itemList[num]

 		if item:getType() == SCLIST_TYPE.SCLIST_MENU then

 			local posx = self.listView:getScrollNode():getPositionX()
 			local posy = self.listView:getScrollNode():getPositionY()
 			local key = item:getData().subKey
  		 
 			if item:isSelected() then
 				self:close(key,num)
 				item:selected(false)
 			 
 			else 
 				self:open(key,num)
 				item:selected(true)
 				self.temDelLen = 0
				self:findReadyDel(self.data[key])
  
 			end
 
 			if self.menuItemClickFunc ~= nil then
 				self.menuItemClickFunc(item)
 			end
 	 
 		elseif  item:getType() == SCLIST_TYPE.SCLIST_SUBITEM  then

 			if self.lastItem ~= nil then
 				self.lastItem:selected(false)
 			end

 			self.lastItem = item
 			item:selected(true)
 			if self.itemClickFunc ~= nil then
 				self.itemClickFunc(item)
 			end
 		end
		end
	end
end

function CQMenuList:destory()
	
	if self.listView then
		self.listView:removeAllItems()
		self.listView:removeSelf()
	end

 
	self.itemList = {}
	self.itemWidth = 0
	self.itemHeight = 0
	self.itemClickFunc = nil
	self.subItem = nil
	self.lastItem = nil

end
return CQMenuList