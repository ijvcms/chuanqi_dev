--
-- Author: Yi hanneng
-- Date: 2016-04-20 15:16:49
--
local BuffListView = BuffListView or class("BuffListView", function() return display.newNode()end)

function BuffListView:ctor(param)
	self:init(param)
	self:open()
end

function BuffListView:init(param)

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,20))

    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            self:close()
        end
        return true
    end)

	self.itemList = {}

	self.listView = SCUIList.new {
        viewRect = cc.rect(0,0,330, 250),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :addTo(self):pos(0,display.height - 350 -  param.yy  - 26)

end

function BuffListView:setViewInfo(data)

	if data == nil then
		return
	end

	if self.listView then
		self.listView:removeAllItems()
	end
	
	self.itemList = {}
	data = data.data

	for i=1,#data.spec_buff_list do
		local config = configHelper:getBuffConfigById(data.spec_buff_list[i].type)
		config.value = data.spec_buff_list[i].value
		local item = self.listView:newItem()
		local content = require("app.modules.buff.BuffItem").new()
		content:setData(config)
		item:addContent(content)
		self.itemList[#self.itemList + 1] = content
	    item:setItemSize(content:getContentSize().width, content:getContentSize().height)
		self.listView:addItem(item)
	end
	 
	for i=1,#data.buff_list do
		local config = configHelper:getBuffConfigById(data.buff_list[i].buff_id)
		config.value = data.buff_list[i].countdown
		local item = self.listView:newItem()
		local content = require("app.modules.buff.BuffItem").new()
		content:setData(config)
		item:addContent(content)
		self.itemList[#self.itemList + 1] = content
	    item:setItemSize(content:getContentSize().width, content:getContentSize().height)
		self.listView:addItem(item)
	end
	--没有buff的情况
	if self.itemList and #self.itemList == 0 then
		 
		local item = self.listView:newItem()
		local content = require("app.modules.buff.BuffItem").new()
		content:setData(nil)
		item:addContent(content)
		self.itemList[#self.itemList + 1] = content
	    item:setItemSize(content:getContentSize().width, content:getContentSize().height)
		self.listView:addItem(item)
		
	end
	
	self.listView:reload()

end

function BuffListView:open()
	GlobalEventSystem:addEventListener(BuffEvent.Buff_INFO,handler(self,self.setViewInfo))
	GlobalController.buff:requestBuffInfo()
end

function BuffListView:close()
	GlobalEventSystem:removeEventListener(BuffEvent.Buff_INFO)
	if self.itemList then
		for i=1,#self.itemList do
			self.itemList[i]:destory()
		end
		self.itemList = {}
	end

	if self.listView then
		self.listView:removeAllItems()
	end
	self:removeSelfSafety()
end

return BuffListView