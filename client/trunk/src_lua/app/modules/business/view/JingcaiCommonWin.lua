--
-- Author: Yi hanneng
-- Date: 2016-09-26 19:35:55
--
-------------通用（以前精彩活动）--------------
local JingcaiCommonWin = JingcaiCommonWin or class("JingcaiCommonWin", BaseView)

function JingcaiCommonWin:ctor()
	self.ccui = cc.uiloader:load("resui/jingcaiCommonWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setNodeEventEnabled(true)
end

function JingcaiCommonWin:init()

 
	self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.itemLayer = cc.uiloader:seekNodeByName(self.ccui, "itemLayer")
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	self.btn = cc.uiloader:seekNodeByName(self.ccui, "getBtn")
 
	self.itemList = {}

	self.container = display.newNode():addTo(self.itemLayer)
 	self.container:setAnchorPoint(0,0)

	self.ruleRich = SuperRichText.new(nil,self.mainLayer:getContentSize().width-10)
    self.ruleRich:setAnchorPoint(0,1)
  
 	self.layer = display.newNode()
	self.layer:setContentSize(cc.size(self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10))
	self.listView = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10)}):addScrollNode(self.layer)
	self.listView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
	self.listView:setTouchSwallowEnabled(false)
	self.mainLayer:addChild(self.listView)
	self.layer:addChild(self.ruleRich)
	self.listView:setPosition(5, 5)


	self.btn:setTouchEnabled(true)
  	self.btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	self.btn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
        	self.btn:setScale(1.0)
            if self.data then
            	if self.data.is_window == 0 then
            		GlobalController.business:requestBusinessById(self.data.active_id)
            	elseif self.data.is_window == 1 then
            		function exfunc()
				        GlobalController.business:requestBusinessById(self.data.active_id)
				    end

			        GlobalMessage:alert({
			                enterTxt = "确定",
			                backTxt= "取消",
			                tipTxt = self.data.window_content,
			                enterFun = exfunc,
			                tipShowMid = true,
			        })
            	end
            end
        end
        return true
    end)
 
end

function JingcaiCommonWin:setViewInfo(data)
	
	if data == nil then
		return
	end
	--dump(data)
	self.data = data
	
	self.titleLabel:setString(data.title)
	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.start_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
 
	self.ruleRich:renderXml("<font color='ffffff' size='18' opacity='255'>"..data.content.."</font>")
 	self.ruleRich:setPositionY(self.mainLayer:getContentSize().height - self.ruleRich:getContentSize().height + 10)

 	if #self.itemList > 0 then

		for i=1,#self.itemList do
			self.itemList[i]:removeFromParent()
		end
	 
	end

	self.itemList = {}
 	local info

	for i=1,#data.show_reward do
		info = data.show_reward[i]
		local commonItem = CommonItemCell.new():addTo(self.container)
	    commonItem:setData(info)
	    commonItem:setTouchSwallowEnabled(false)
		commonItem:setPosition(80*(i-1), 0)
		self.itemList[i] = commonItem
	end

	self.container:setContentSize(cc.size(80*#data.show_reward, 80))
	self.container:setPosition(self.itemLayer:getPositionX() - self.container:getContentSize().width/2 - 80, self.itemLayer:getPositionY() - 70 )
 	self:setButtonEnabled(data.state == 1)
 	if self.btn then
		self.btn:setVisible(data.is_button == 1)
	end
end
 
function JingcaiCommonWin:setButtonEnabled(enabled)

	if self.btn then
		self.btn:setButtonEnabled(enabled)
	end

end

function JingcaiCommonWin:ddd(data)
    self.data.state = data.data.state
    self:setButtonEnabled(data.data.state == 1)
end

function JingcaiCommonWin:open(data)
	GlobalEventSystem:addEventListener(BusinessEvent.RCV_BUSINESS_REWARD,handler(self, self.ddd))
end

function JingcaiCommonWin:close()
	GlobalEventSystem:removeEventListener(BusinessEvent.RCV_BUSINESS_REWARD)
end

function JingcaiCommonWin:destory()
	self:close()
	JingcaiCommonWin.super.destory(self)
end

return JingcaiCommonWin