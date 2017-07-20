
--背包view
local BagView = class("BagView", function()
	return display.newNode() --cc.Sprite:create() -- 
end)

function BagView:ctor(bgSize)
	--背景
	self:setAnchorPoint(0,0)
	local bg
	if bgSize then
		bg = display.newScale9Sprite("#com_viewBg1.png", 0, 0, bgSize)
	else
		bg = display.newScale9Sprite("#com_viewBg1.png", 0, 0, cc.size(463,410))
	end
	bg:setAnchorPoint(0,0)
	self:addChild(bg)
	self:setContentSize(bg:getContentSize())
	self.move = false
	--触摸层
	self.touchLayer = display.newLayer()
	self.touchLayer:setContentSize(bg:getContentSize())
	self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.onTLTouch))
	bg:addChild(self.touchLayer,10)
	self.touchLayer:setTouchSwallowEnabled(false)

	--内容层
	self.contentLayer = display.newLayer()
	self.contentLayer:setContentSize(bg:getContentSize())
	self.contentLayer:setAnchorPoint(0,0)
    bg:addChild(self.contentLayer,5)

    --5个page
    self.pages = {}
    self.curPageIndex = 1
    self.itemBgs = {}
    for i=1,5 do
    	self:createPage()
    end
    self.pages[1]:setVisible(true)

    --5个page tag
    local tagPos = {
    	[1] = {153,32},
		[2] = {193,32},
		[3] = {233,32},
		[4] = {273,32},
		[5] = {313,32},
	}
    self.pageTags = {}
    for i=1,5 do
    	local sp = display.newSprite("#com_radioBg.png")
    	local selected =  display.newSprite("#com_radioPic.png")
    	selected:setTag(10)
    	selected:setPosition(sp:getContentSize().width/2,sp:getContentSize().height/2)
    	selected:setVisible(false)
    	sp:addChild(selected)
    	bg:addChild(sp)
    	sp:setPosition(tagPos[i][1], tagPos[i][2])
    	table.insert(self.pageTags,sp)
    end
    self.pageTags[1]:getChildByTag(10):setVisible(true)
 

	-- self.rightArrow:setScaleX(-1)
	-- self.contentLayer:addChild(self.rightArrow)
	-- self.contentLayer:addChild(self.leftArrow)

	-- self.leftArrow:setPosition( -self.leftArrow:getContentSize().width/2 + 12, self.contentLayer:getContentSize().height/2 + self.rightArrow:getContentSize().height/2)
	-- self.rightArrow:setPosition(self.contentLayer:getContentSize().width + self.leftArrow:getContentSize().width/2 - 12, self.leftArrow:getPositionY())
   
 --   local action1 = cc.FadeIn:create(1.0)
 --   local action2 = cc.FadeOut:create(1.0)
 --   local action3 = transition.sequence({action1,action2})
 --   local action = cc.RepeatForever:create(action3)
	-- self.leftArrow:runAction(action)
 --    self.rightArrow:runAction(action:clone())
    --
    self.itemDelayLoad = {}
    for i=1,5 do
		self.itemDelayLoad[i] = {}
    end
    
end


local itemBgGapX = 90
local itemBgGapY = 85
local itemBg1Pos = {x=40,y=300}
local itemBgPerCol = 4 		--每列4个
local itemBgPerRow = 5		--每行5个
function BagView:createPage()
	if not self.createItemBgIndex then
		self.createItemBgIndex = 0
	end
	local page = display.newLayer()
	page:setAnchorPoint(0,0)
	page:setContentSize(440,340)

	for i=1,itemBgPerCol*itemBgPerRow do
		self.createItemBgIndex = self.createItemBgIndex+1
		local itemBg = display.newSprite("#com_propBg1.png")
		table.insert(self.itemBgs,itemBg)
		page:addChild(itemBg)
		itemBg:setTag(self.createItemBgIndex)
		local col = (self.createItemBgIndex%itemBgPerRow)==0 and itemBgPerRow or (self.createItemBgIndex%itemBgPerRow)
		-- local row = math.floor(self.createItemBgIndex/itemBgPerRow) + (self.createItemBgIndex/itemBgPerRow==1 and 0 or 1)
		local row = self.createItemBgIndex%itemBgPerRow==0 and self.createItemBgIndex/itemBgPerRow or math.ceil(self.createItemBgIndex/itemBgPerRow)
		row = row%itemBgPerCol==0 and itemBgPerCol or row%4
		itemBg:setPosition((col-1)*itemBgGapX+itemBg1Pos.x, itemBg1Pos.y - (row-1)*itemBgGapY)

		if #self.pages*itemBgPerCol*itemBgPerRow + i > RoleManager:getInstance().roleInfo.bag then
         	local itemLock = display.newSprite("#com_propGoldLock.png")
         	itemBg:addChild(itemLock, 8, 8)
         	itemLock:setTag(8)
         	itemLock:setPosition(itemBg:getContentSize().width/2, itemBg:getContentSize().height/2)
         	itemLock:setTouchEnabled(true)
         	itemLock:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
         		if event.name == "ended" then
         			if self.lockFunc ~= nil and self.move == false then
         				self.lockFunc()
         			end
         		end
         		return true
         		end)
    	end

	end
	
	page:setVisible(false)
	page:setPosition(11,59)
	self.contentLayer:addChild(page)
	table.insert(self.pages,page)
end

function BagView:getItemBgs()
	return self.itemBgs
end

-- 添加一个物品数据到bagView中
-- index:格子号
-- itemData:物品数据
-- modifyFunc:加载commonItem后执行的回调函数
-- args:传递给modifyFunc的附属参数
function BagView:setBagItem(index,itemData,modifyFunc,args)
	if not self.itemBgs[index] then return end
    if self.itemBgs[index]:getChildByTag(10) then
        self.itemBgs[index]:removeChildByTag(10, true)
    end
    if not itemData then
    	local pageIndex = math.ceil(index/(itemBgPerCol*itemBgPerRow))
    	self.itemDelayLoad[pageIndex][index] = nil
        return
    end

    local pageIndex = math.ceil(index/(itemBgPerCol*itemBgPerRow))
    if pageIndex == self.curPageIndex and index < RoleManager:getInstance().roleInfo.bag then 			--如果是当前页,则直接加载
    	local commonItem = CommonItemCell.new()
	    self.itemBgs[index]:addChild(commonItem, 10, 10)
	    commonItem:setPosition(self.itemBgs[index]:getContentSize().width/2,self.itemBgs[index]:getContentSize().height/2)
	    commonItem:setData(itemData)--先设置位置，在设置数据
	    commonItem:setTouchSwallowEnabled(false)
	    if modifyFunc then
	    	modifyFunc(commonItem,args)
	    end
	    return commonItem
	else 											--不是当前页,则留到切换到这页时再加载
		self:addItemDelayLoad(index,itemData,modifyFunc,args)
    end
end

function BagView:addItemDelayLoad(index,itemData,modifyFunc,args)
	if index > RoleManager:getInstance().roleInfo.bag then
		return
	end
	local pageIndex = math.ceil(index/(itemBgPerCol*itemBgPerRow))
	self.itemDelayLoad[pageIndex][index] = {data = itemData,func = modifyFunc,param = args}
end

function BagView:cleanBagItem()
	for i=1,#self.itemBgs do
		self:setBagItem(i,nil)
	end
end

--找出点击点在哪个item上面,没有返回nil
function BagView:findTouchItem(x,y)
	return nil
end

--翻到下一页
function BagView:gotoNextPage(isRight)
	if isRight then
		self:gotoPage(self.curPageIndex+1)
	else
		self:gotoPage(self.curPageIndex-1)
	end
end

function BagView:gotoPage(pageIndex)
 	self.rightArrow:setVisible(pageIndex < #self.pages)
	self.leftArrow:setVisible(not (pageIndex == 1) )
	if pageIndex and self.pages[pageIndex] then
		self.pages[self.curPageIndex]:setVisible(false)
		self.pageTags[self.curPageIndex]:getChildByTag(10):setVisible(false)
		self.pages[pageIndex]:setVisible(true)
		self.curPageIndex = pageIndex
		self.pageTags[self.curPageIndex]:getChildByTag(10):setVisible(true)

		--加载item
		for k,v in pairs(self.itemDelayLoad[pageIndex]) do
			local commonItem = CommonItemCell.new()
		    commonItem:setData(v.data)
		    self.itemBgs[k]:addChild(commonItem, 10, 10)
		    commonItem:setPosition(self.itemBgs[k]:getContentSize().width/2,self.itemBgs[k]:getContentSize().height/2)
		    commonItem:setTouchSwallowEnabled(false)
		    if v.func then
		    	v.func(commonItem,v.param)
		    end
		    self.itemDelayLoad[pageIndex][k] = nil
		end
	end
end

function BagView:onTLTouch(event)
    if event.name == "began" then
       self.touchBeganPos = {x = event.x, y = event.y}
       -- self.touchOnItem = self:findTouchItem()
    elseif event.name == "ended" then
       self.touchEndPos = {x = event.x, y = event.y}
       -- --如果一开始触摸的时候触摸点在某个item上,那么需要检测触摸结束时还是否在这个item上
       -- if self.touchOnItem then
       -- 		--如果还在同一个item上,触发这个item的点击事件
       -- end
       --结束触摸与开始触摸时的X轴超过了设定值,那么翻到下一页
       if math.abs(self.touchEndPos.x-self.touchBeganPos.x)>=80 then
       		self.move = true
       		local isRight = (self.touchEndPos.x-self.touchBeganPos.x)<0
       		self:gotoNextPage(isRight)
       	else
       		self.move = false
       end
    end     
    return true
end
--解锁
function BagView:unLock(num)

	for i=1,RoleManager:getInstance().roleInfo.bag do
		if self.itemBgs[i] and self.itemBgs[i]:getChildByTag(8) then
			self.itemBgs[i]:removeChildByTag(8, true)
		end
	end

end

function BagView:setLockFunc(func)
	self.lockFunc = func
end

return BagView