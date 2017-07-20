--
-- Author: Yi hanneng
-- Date: 2016-09-26 19:39:24
--

-------------公告--------------

local JingcaiAnnounceWin = JingcaiAnnounceWin or class("JingcaiAnnounceWin", BaseView)

function JingcaiAnnounceWin:ctor()
	self.ccui = cc.uiloader:load("resui/jingcaiAnnounceWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function JingcaiAnnounceWin:init()
 
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
 
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
end

function JingcaiAnnounceWin:setViewInfo(data)
	if data == nil then
		return
	end
 	self.data = data
 	self.ruleRich:renderXml("<font color='ffffff' size='18' opacity='255'>"..data.content.."</font>")
 	self.ruleRich:setPositionY(self.layer:getContentSize().height -  10)
end
 
function JingcaiAnnounceWin:open(data)
 
end

function JingcaiAnnounceWin:close()

end

return JingcaiAnnounceWin