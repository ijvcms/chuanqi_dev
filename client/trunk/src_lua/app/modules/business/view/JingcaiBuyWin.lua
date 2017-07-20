--
-- Author: Yi hanneng
-- Date: 2016-09-26 19:27:17
--

-------------限购--------------
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local  JingcaiBuyItem = import(".JingcaiBuyItem")

local JingcaiBuyWin = JingcaiBuyWin or class("JingcaiBuyWin", BaseView)

function JingcaiBuyWin:ctor()
	self.ccui = cc.uiloader:load("resui/jingcaiBuyWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setNodeEventEnabled(true)
end

function JingcaiBuyWin:init()

	self.itemList = {}
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")
 
	self.layer = display.newNode()
	self.layer:setContentSize(cc.size(self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10))
	self.listView = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10)}):addScrollNode(self.layer):pos(0,2)
	self.listView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
	self.listView:setTouchSwallowEnabled(false)
	self.mainLayer:addChild(self.listView)
 
end

function JingcaiBuyWin:setViewInfo(data)
	if data == nil then
		return
	end
 
	self.titleLabel:setString(data.title)
	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.start_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
 
 	self.data = data
 
 	local bossDataList = data.sub_list
 
    local itemWidth = 0
    local itemHeight = 0
    local len = #bossDataList
    local loaded = 0

    if len == 0 then
    	return
    end

    for i=#self.itemList,len + 1, -1 do
        self.itemList[i]:setVisible(false)
    end

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function()
            
    	if bossDataList and  loaded < len then
           	loaded = loaded + 1
            local info = bossDataList[loaded]
            if info then

            	if self.itemList[loaded] == nil then
            		local item = JingcaiBuyItem.new()
	                self:selectFunc(item)
	                self.layer:addChild(item)
	                self.itemList[loaded] = item
            	end
               	
                self.itemList[loaded]:setVisible(true)
               	self.itemList[loaded]:setData(info)
                itemWidth = self.itemList[loaded]:getContentSize().width + 20
                itemHeight = self.itemList[loaded]:getContentSize().height + 10

                self.itemList[loaded]:setPosition(((loaded-1)%2)*itemWidth + 10,itemHeight*math.ceil(#bossDataList/2) - math.floor((loaded-1)/2)*itemHeight - itemHeight )
            end
        end

        if loaded == len then
            self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
            self.layer:setContentSize(cc.size(itemWidth*2, itemHeight*math.ceil(#bossDataList/2)))
            self.layer:setPosition(0, self:getContentSize().height - self.layer:getContentSize().height - itemHeight/2 - 30 )
        end
    end)

    self:scheduleUpdate()
	
end


function JingcaiBuyWin:selectFunc(item)

	if item ~= nil then

        item:setItemClick(handler(self, self.itemClick))
 
	end

end

function JingcaiBuyWin:ddd(data)
	
	if self.data.active_id == data.data.active_id then
 		--[[
		for i=1,#self.data.sub_list do
			 
			if self.data.sub_list[i].sub_type == data.data.sub_type then
				self.data.sub_list[i].count = data.data.value
			end
	 
		end
		--]]
		for i=1,#self.itemList do

			local info = self.itemList[i]:getData()
			if info.sub_type == data.data.sub_type then
				info.count = data.data.value
				self.itemList[i]:setData(info)
				break
			end
	 
		end
		 
	end

end

function JingcaiBuyWin:itemClick(data)
	if data == nil then
		return
	end

	GlobalController.business:requestBusinessReceiveReward(self.data.active_id,data.sub_type)
end

function JingcaiBuyWin:open()
	GlobalEventSystem:addEventListener(BusinessEvent.RCV_BUSINESS_REWARD,handler(self, self.ddd))
end

function JingcaiBuyWin:close()
	GlobalEventSystem:removeEventListener(BusinessEvent.RCV_BUSINESS_REWARD)
end

function JingcaiBuyWin:destory()
	self:close()
	JingcaiBuyWin.super.destory(self)
end

return JingcaiBuyWin