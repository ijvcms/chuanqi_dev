--
-- Author: Yi hanneng
-- Date: 2016-05-10 15:51:32
--
local OpenServeAngPaoView = OpenServeAngPaoView or class("OpenServeAngPaoView", BaseView)

function OpenServeAngPaoView:ctor()

	self.ccui = cc.uiloader:load("resui/serveLuckMoneyItem.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function OpenServeAngPaoView:init()
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
end

function OpenServeAngPaoView:setViewInfo(data)
	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
end

function OpenServeAngPaoView:open()
end

function OpenServeAngPaoView:close()
end

function OpenServeAngPaoView:destory()
	self:close()
	OpenServeAngPaoView.super.destory(self)
end

return OpenServeAngPaoView