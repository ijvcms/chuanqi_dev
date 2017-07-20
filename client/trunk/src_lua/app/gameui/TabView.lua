--
-- Author: zhangshunqiu
-- Date: 2015-02-06 09:33:56
-- 选项卡组建
--示例
-- local tabData = {
--     	width = display.width,
--     	height = 120,
--     	itemWidth= display.width/6,
--     	--bgImage = "res/publicUI/Button01.png",
--     	bgColor = display.BG_COLOR_GRAY1,
--     	listData = {
--     		{image ="ttgame/nav_1.png",selImage = "ttgame/nav_11.png", isSelect = true,isEnabled = true},    								
--     		{image ="ttgame/nav_2.png",selImage = "ttgame/nav_21.png", isSelect = false,isEnabled = true},
--     		{image ="ttgame/nav_3.png",selImage = "ttgame/nav_31.png", isSelect = false,isEnabled = true},
--     		{image ="ttgame/nav_4.png",selImage = "ttgame/nav_41.png", isSelect = false,isEnabled = true},
--     		{image ="ttgame/nav_5.png",selImage = "ttgame/nav_51.png", isSelect = false,isEnabled = true},
--     		{image ="ttgame/nav_6.png",selImage = "ttgame/nav_61.png", isSelect = false,isEnabled = true},
--     	}
--     }
--     local bottomTab = require("app.gameui.TabView").new(tabData)
--     bottomTab:setPosition(0,0)
--     bottomTab:addNodeEventListener(TABVIEW_CLICK_EVENT, function(event)		
--          			if event.index == 1 then
--          				-- self.bottomTab:setEnabledIndex(4)
         				
--          			elseif event.index == 2 then
--          				-- self.bottomTab:setSelectIndex(1)
--          			elseif event.index == 3 then
--          				-- self.bottomTab:setUnEnabledIndex(4)
--          			end
--          			self:switchView(event.index)  
--          			-- self:EventDispatcher( "changstates", self.itemDic[item:getKey()])
--     end)
local TTabViewItem = class("TTabViewItem", function()
	return display.newNode()
end)
--tabView Item类
--@param table data 数据 {image ="Button01.png",selImage = "Button02.png" isSelect = true,isEnabled = true}
function TTabViewItem:ctor(data,key)
	self:init(data)	
	self.key = key
end	

function TTabViewItem:getKey()
	return self.key
end	

function TTabViewItem:init(data)	
	local isSelect = false
	if data.isSelect == nil then
		isSelect = false
	else
		isSelect = data.isSelect
	end	
	if data.isEnabled == nil then
		self.isEnabled = true
	else
		self.isEnabled = data.isEnabled
	end	

	if data.selImage and data.selImage~= "" and self.selImgSpr == nil then
		self.selImgSpr = display.newSprite(data.selImage, 0, 0)
		--self.selImgSpr:setAnchorPoint(0,0)	
		self.selImgSpr:setVisible(isSelect)
		self:addChild(self.selImgSpr)
		self.selImgSpr:setTouchEnabled(false)
		--self.selImgSpr:setTouchSwallowEnabled(true)
		self.selImgSpr:setTouchCaptureEnabled(true)
	end
	if self.imgSpr == nil then
		self.imgSpr = display.newSprite(data.image, 0, 0)
		--self.imgSpr:setAnchorPoint(0,0)	
		self.imgSpr:setVisible(isSelect == false)
		self:addChild(self.imgSpr)

		self.imgSpr:setTouchEnabled(false)
		--self.imgSpr:setTouchSwallowEnabled(true)
		self.imgSpr:setTouchCaptureEnabled(true)
	end
	self:setSelect(isSelect)
end

--设置是否选中
function TTabViewItem:setSelect(isSelect)	
	if self.isSelect ~= isSelect then
		self.isSelect = isSelect
	else
		return
	end	
	if self.isSelect then
		self.imgSpr:setVisible(false)
		if self.selImgSpr then
			self.selImgSpr:setVisible(true)
		end
	else
		self.imgSpr:setVisible(true)
		if self.selImgSpr then
			self.selImgSpr:setVisible(false)
		end
	end	
end

function TTabViewItem:getSelect()
	return self.isSelect
end	

--设置是否可以用
function TTabViewItem:setEnabled(isEnabled)
	self.isEnabled = isEnabled
end
--获取是否可以用
function TTabViewItem:getEnabled()
	return self.isEnabled
end

function TTabViewItem:destory()
	
end



local TabView = class("TabView", function()
	return display.newNode()
end)

TABVIEW_CLICK_EVENT = "tabview_click_event"

--data格式如下
--{width = 100,height = 90,bgImage = "res/publicUI/Button01.png",listData = {{image ="Button01.png",selImage = "Button02.png" isSelect = true,isEnabled = true},{image ="Button01.png",selImage = "Button02.png" isSelect = true,isEnabled = true} }}
function TabView:ctor(data)
	data = data or {}	
	self.width = data.width or display.width
	self.itemWidth = data.itemWidth or 100
	self.height = data.height or 50
	local bgColor = data.bgColor --or display.BG_COLOR_WHITE
	local bgImage = data.bgImage --or "res/publicUI/Button01.png"
	self.listData = data.listData or {}

	if bgColor then
		local bgColor = display.newRect(cc.rect(0, 0, self.width, self.height),
        		{fillColor = bgColor, borderColor = display.BG_COLOR_WHITE, borderWidth = 0})
		self:addChild(bgColor)
	end
	if bgImage then		
		local bgSprite = display.newScale9Sprite(bgImage, 0, 0, cc.size(self.width, self.height))
		bgSprite:setAnchorPoint(0,0)
		self:addChild(bgSprite)
	end

	self.tabsNode = display.newNode()
	-- local bgSprite = display.newScale9Sprite(bgImage, 0, 0, cc.size(60, 50))
	-- 	bgSprite:setAnchorPoint(0,0)
	-- 	self.tabsNode:addChild(bgSprite)
	self:addChild(self.tabsNode)	

	self.curSelectIndex = -1 
	self.itemDic = {}
	self:updateTab()
end	

--{image ="Button01.png",selImage = "Button02.png" isSelect = true,isEnabled = true}
function TabView:updateTab()	
	local index = 1	
	for i=1,#self.listData do
		local vo = self.listData[i]
		local item = self.itemDic[i]		
		vo.isSelect = vo.isSelect or false
		if vo.isEnabled == nil then
			vo.isEnabled = true		
		end

		if vo.isEnabled then			
			if item then
				item:init(vo)
			else
				item = TTabViewItem.new(vo,i) 
				self.itemDic[i] = item
				item:setTouchEnabled(true)
				item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 				
					if self.curSelectIndex ~= item:getKey() then
						self:setSelectIndex(item:getKey())     			
         				self:EventDispatcher(TABVIEW_CLICK_EVENT, {name = TabView.CLICK_EVENT,index = item:getKey(), item = self.itemDic[item:getKey()]})
       				end
       			end)
			end
			-- if vo.isSelect then
			-- 	item:setLocalZOrder(#self.listData +1)	
			-- else
			-- 	item:setLocalZOrder(i)
			-- end
			local parent = item:getParent()
			if parent == nil then
				self.tabsNode:addChild(item)								
			end
			item:setPosition(self.itemWidth*(index-1)+self.itemWidth/2,self.height/2)
			index = index+1	
		else
			if item then
				local parent = item:getParent()
				if parent == nil then
					self.tabsNode:removeChild(item)
				end	
			end	
		end		
	end
end	

--设置选中的索引
function TabView:setSelectIndex(index)
	if self.curSelectIndex ~= index then
		self.curSelectIndex = index	
		index = math.min(#self.listData,math.max(1,index))
		for i=1,#self.listData do
			local vo = self.listData[i]
			if i == index then
				vo.isSelect = true
			else
				vo.isSelect = false	
			end	
		end
		self:updateTab()
	end
end
--获取选中的索引
function TabView:getSelectIndex()
	return self.curSelectIndex
end

--设置当前索引的Item可用
function TabView:setEnabledIndex(index)
	index = math.min(#self.listData,math.max(1,index))
	local vo = self.listData[index]
	if vo.isEnabled == true then
		--是可用的不处理
	else
		vo.isEnabled = true
		self:updateTab()
	end	
end

--设置当前索引的Item不可用
function TabView:setUnEnabledIndex(index)
	index = math.min(#self.listData,math.max(1,index))
	local vo = self.listData[index]
	if vo.isEnabled == false then
		--是可用的不处理
	else
		vo.isEnabled = false
		self:updateTab()
	end	
end

--清理
function TabView:destory()
end	

return TabView    