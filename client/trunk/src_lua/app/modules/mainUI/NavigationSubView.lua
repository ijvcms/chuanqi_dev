--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-21 09:44:15
--
local NavigationBtn = import(".NavigationBtn")
local NavigationSubView = class("NavigationSubView", function()
	return display.newLayer()
end)

local ITEM_GAP  = 10
local ITEM_SIZE = cc.size(69 + ITEM_GAP, 72)


function NavigationSubView:ctor()
	--self._subItemConfigs = subItemConfigs
	self:initialization()
end

function NavigationSubView:initialization()
	self:initComponents()
end

function NavigationSubView:initComponents()
	
	self:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)

	self.itemList = {}

	self.itemContainer = display.newNode()
	self.centerContainer = display.newNode()

	self.centerContainer:addChild(self.itemContainer)

	local viewSize = cc.size(10 + 40, 80)
	self.viewbg = display.newScale9Sprite("#scene/scene_btnListBg.png", 0, 0, viewSize)

	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "ended" then
			if not cc.rectContainsPoint(self.itemContainer:getBoundingBox(), event) then
                self:setVisible(false)
                GlobalEventSystem:dispatchEvent(SceneEvent.RESET_NAV_CHILD)
               	--self:close()
            end
		end
		return true
	end)

	local arrow = display.newSprite("#scene/scene_btnListArrow.png")
	--local items = self:createNavigationItems()

	self.viewbg:setAnchorPoint(cc.p(.5, 0))
	self.viewbg:setPositionY(arrow:getContentSize().height-1)
	arrow:setAnchorPoint(cc.p(.5, 0))
	self.centerContainer:setPositionY(self.viewbg:getPositionY() + viewSize.height * .5)

	local container = display.newNode()
	container:setAnchorPoint(cc.p(.5, 0))
	container:addChild(self.viewbg)
	container:addChild(arrow)
	container:addChild(self.centerContainer)

	self:addChild(container)
	self.container = container
end

function NavigationSubView:setConfig(subItemConfigs)
	self._subItemConfigs = subItemConfigs
	local viewSize = cc.size(self:measureWidth() + 40, 80)
	self.viewbg:setContentSize(cc.size(viewSize.width, viewSize.height))
	self:createNavigationItems()
end

--
-- Override the method adjust view position.
--
function NavigationSubView:setPosition(x, y)
	self.container:setPosition(x, y)
end

function NavigationSubView:measureWidth()
	local numOfItem = (self._subItemConfigs and #self._subItemConfigs) or 1
	return numOfItem * ITEM_SIZE.width
end

function NavigationSubView:createNavigationItems()
	if self._subItemConfigs and #self._subItemConfigs == 0 then return end
	if self.curSelItem then
		self.curSelItem:setSelect(false)
	end
	for index, config in ipairs(self._subItemConfigs) do

		local item = self.itemList[config.win]
		if item == nil then
			item = NavigationBtn.new(config)
			self.itemList[config.win] = item
			if config.win == WinName.MEDALUPWIN then
				local dd = BaseTipsBtn.new(BtnTipsType.BTN_MEDAL,item)
			end
			item:setTouchEnabled(true)
			item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				if event.name == "began" then
					item:setScale(1.1)
				elseif event.name == "ended" then
					item:setScale(1)
					if self.curSelItem then
						self.curSelItem:setSelect(false)
					end
					self.curSelItem = item
					self.curSelItem:setSelect(true)
					self:onItemClick(config)
				end				
				return true			
		    end)

		    self.itemContainer:addChild(item)
		end
		
		item:setPositionX((index - 1) * ITEM_SIZE.width + ITEM_SIZE.width * .5)
		
	end
	self.itemContainer:setPositionX(-self:measureWidth() * .5)
	--self.centerContainer:addChild(self.itemContainer)
	--return self.centerContainer
end

function NavigationSubView:onItemClick(config)
	if self._handler then
		self._handler(config)
	end
end

function NavigationSubView:setOnItemClickeHandler(handler)
	self._handler = handler
end

function NavigationSubView:close()
	self._handler = nil
	self:removeSelfSafety()
end

return NavigationSubView