
--行会红包记录UI
local UIAsynListViewItem = import("app.gameui.listViewEx.UIAsynListViewItem")

local RecordItem =  class("RecordItem", UIAsynListViewItem)


function RecordItem:ctor()
	self.name = display.newTTFLabel({
        size = 18,
        color = cc.c3b(231, 211, 173)
    })
    self.name:setAnchorPoint(0, 0.5)
    self:addChild(self.name)
    self.describe = display.newTTFLabel({
        size = 18,
        color = cc.c3b(255, 167, 0)
    })
    self.describe:setAnchorPoint(0, 0.5)
    self:addChild(self.describe)
end

function RecordItem:setData(params)
	self.name:setString(params.name)
	self.name:setPositionX(0)
	local size = self.name:getContentSize()
    self.describe:setString("领取了"..params.jade.."元宝")
    self.describe:setPositionX(size.width)
    self:setContentSize(size.width + self.describe:getContentSize().width, size.height)
end

return RecordItem