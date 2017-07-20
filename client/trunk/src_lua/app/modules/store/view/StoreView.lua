
--商城view
local StoreView = class("StoreView", function()
	return display.newNode() --cc.Sprite:create() -- 
end)

function StoreView:ctor()
	--背景
	self:setAnchorPoint(0,0)
	local bg = display.newScale9Sprite("#com_viewBg2.png", 0, 0,cc.size(560,464))
	self.bg = bg
	-- local bg = display.newScale9Sprite("#com_viewBg2.png", 0, 0, cc.size(463,410))
	bg:setAnchorPoint(0,0)
	self:addChild(bg)
	self:setContentSize(bg:getContentSize())

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

    self.pages = {}
    self.itemDelayLoad = {}
    self.pageTags = {}
    self:createPage()
    self.curPageIndex = 1
    self.itemCount = 0

    
end

local itemWidth = 261
local itemHeight = 113
local gapX = 542-261*2
local gapY = (359-113*3)/2
local itemBgPerCol = 3 		--每列3个
local itemBgPerRow = 2		--每行2个

function StoreView:createPage()
	local page = display.newLayer()
	page:setTouchEnabled(false)
	page:setTouchSwallowEnabled(false)
	page:setContentSize(542,359)
	page:setPosition((self.contentLayer:getContentSize().width-542)/2,85)
	self.contentLayer:addChild(page)
	table.insert(self.pages,page)
	table.insert(self.itemDelayLoad,{})
	self:createPageTag()
	return page
end

function StoreView:createPageTag()
	local sp = display.newSprite("#com_radioBg.png")
	local selected =  display.newSprite("#com_radioPic.png")
	selected:setTag(10)
	selected:setPosition(sp:getContentSize().width/2,sp:getContentSize().height/2)
	selected:setVisible(false)
	sp:addChild(selected)
	self.bg:addChild(sp)
	table.insert(self.pageTags,sp)

	local tagGap = 20
    local tagWidth = 27
	for i=1,#self.pageTags do
        local x = 0
        if i==1 then
            x = -((#self.pageTags-1)*tagWidth/2 + (#self.pageTags-1)*tagGap/2) + self.bg:getContentSize().width/2
        else
            x = self.pageTags[i-1]:getPositionX() + tagWidth + tagGap
        end
        self.pageTags[i]:setPosition(x,50)
    end
end

function StoreView:pushItemData(itemData,modifyFunc,args)
	if not itemData then return end
	self.itemCount = self.itemCount+1
	local pageIndex = math.ceil(self.itemCount/(itemBgPerCol*itemBgPerRow))
	local page 
	if not self.pages[pageIndex] then
		page = self:createPage()
	else
		page = self.pages[pageIndex]
	end

	if pageIndex == self.curPageIndex then 			--如果是当前页,则直接加载
		local item = self:createStoreItem(itemData)
    	page:addChild(item)
    	local row = math.ceil((self.itemCount-(pageIndex-1)*itemBgPerCol*itemBgPerRow)/itemBgPerRow)
    	local col = self.itemCount%itemBgPerRow == 0 and 2 or 1
    	item:setPosition((col-1)*(itemWidth+gapX),(itemBgPerCol-row)*(itemHeight+gapY))
    	if modifyFunc then
    		modifyFunc(item,args)
    	end
	else 											--不是当前页,则留到切换到这页时再加载
		self:addItemDelayLoad(self.itemCount,itemData,modifyFunc,args)
    end
end

function StoreView:addItemDelayLoad(index,itemData,modifyFunc,args)
	local pageIndex = math.ceil(index/(itemBgPerCol*itemBgPerRow))
	self.itemDelayLoad[pageIndex][index] = {data = itemData,func = modifyFunc,param = args}
end

function StoreView:createStoreItem(itemData)
    local sp = display.newScale9Sprite("#com_listBg1.png", 0, 0, cc.size(261,113))
    sp:setAnchorPoint(0,0)

    --图标
    local commonItem = CommonItemCell.new()
    commonItem:setData(itemData)
    commonItem:setPosition(49,57)
    commonItem:setTouchEnabled(false)
    commonItem:setTouchSwallowEnabled(false)
    sp:addChild(commonItem)
    --名字
    local nameLabel = display.newTTFLabel({font = "Marker Felt"}):addTo(sp,15)
    nameLabel:setColor(TextColor.TITLE)
    nameLabel:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))
    nameLabel:setAnchorPoint(0,0.5)
    nameLabel:setPosition(98,78)
    --根据品质改变名字颜色
    local quality = configHelper:getGoodQualityByGoodId(itemData.goods_id)
    if quality then
        local color
        if quality == 1 then            --白
            color = TextColor.TEXT_W
        elseif quality == 2 then        --绿
            color = TextColor.TEXT_G
        elseif quality == 3 then        --蓝
            color = TextColor.ITEM_B
        elseif quality == 4 then        --紫
            color = TextColor.ITEM_P
        elseif quality == 5 then        --橙
            color = TextColor.TEXT_O
        elseif quality == 6 then        --红
                    color = TextColor.TEXT_R
        end 
        if color then
            nameLabel:setTextColor(color)
        end
    end
    display.setLabelFilter(nameLabel)
    --"售价:"
    local sjLabel = display.newTTFLabel({font = "Marker Felt"}):addTo(sp,15)
    sjLabel:setColor(TextColor.TEXT_W)
    sjLabel:setString("售价:")
    sjLabel:setAnchorPoint(0,0.5)
    sjLabel:setPosition(98,36)
    display.setLabelFilter(sjLabel)
    --价格
    local jgLabel = display.newTTFLabel({font = "Marker Felt"}):addTo(sp,15)
    jgLabel:setColor(TextColor.TEXT_Y)
    jgLabel:setString(itemData.price)
    jgLabel:setAnchorPoint(0,0.5)
    jgLabel:setPosition(sjLabel:getPositionX()+sjLabel:getContentSize().width,36)
    display.setLabelFilter(jgLabel)
    --代表是何种金币的图标
    local coinIcon = display.newSprite("#com_coin"..itemData.curr_type..".png"):addTo(sp,15)
    coinIcon:setAnchorPoint(0,0.5)
    coinIcon:setPosition(jgLabel:getPositionX()+jgLabel:getContentSize().width + 2, 36)

    return sp
end

--翻到下一页
function StoreView:gotoNextPage(isRight)
	if isRight then
		self:gotoPage(self.curPageIndex+1)
	else
		self:gotoPage(self.curPageIndex-1)
	end
end

function StoreView:gotoPage(pageIndex)
	if pageIndex and self.pages[pageIndex] then
		self.pages[self.curPageIndex]:setVisible(false)
		self.pageTags[self.curPageIndex]:getChildByTag(10):setVisible(false)
		self.pages[pageIndex]:setVisible(true)
		self.curPageIndex = pageIndex
		self.pageTags[self.curPageIndex]:getChildByTag(10):setVisible(true)

		--加载item
		for k,v in pairs(self.itemDelayLoad[pageIndex]) do
			local item = self:createStoreItem(v.data)
			self.pages[pageIndex]:addChild(item)
	    	local row = math.ceil((k-(pageIndex-1)*itemBgPerCol*itemBgPerRow)/itemBgPerRow)
	    	local col = k%itemBgPerRow == 0 and 2 or 1
	    	item:setPosition((col-1)*(itemWidth+gapX),(itemBgPerCol-row)*(itemHeight+gapY))
		    self.itemDelayLoad[pageIndex][k] = nil
		    if v.func then
		    	v.func(item,v.param)
		    end
		end
	end
end

function StoreView:onTLTouch(event)
    if event.name == "began" then
       self.touchBeganPos = {x = event.x, y = event.y}
       -- self.touchOnItem = self:findTouchItem()
    elseif event.name == "ended" then
       self.touchEndPos = {x = event.x, y = event.y}
       --结束触摸与开始触摸时的X轴超过了设定值,那么翻到下一页
       -- --如果一开始触摸的时候触摸点在某个item上,那么需要检测触摸结束时还是否在这个item上
       -- if self.touchOnItem then
       -- 		--如果还在同一个item上,触发这个item的点击事件

       -- end
       if math.abs(self.touchEndPos.x-self.touchBeganPos.x)>=80 then
       		local isRight = (self.touchEndPos.x-self.touchBeganPos.x)<0
       		self:gotoNextPage(isRight)
       end
    end     
    return true
end


return StoreView