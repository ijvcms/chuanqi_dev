local UIAsynListViewItem = import("app.gameui.listViewEx.UIAsynListViewItem")

local GuildLogItem = class("GuildLogItem", UIAsynListViewItem)

local ZW_TYPE = {
	[1] = "会长",
	[2] = "副会长",
	[3] = "长老",
	[4] = "精英",
	[5] = "成员"
}


function GuildLogItem:ctor()
	self.date = display.newTTFLabel({
        size = 18,
        color = cc.c3b(212, 184, 166)
    })
    self.date:setAnchorPoint(0, 0.5)
    self:addChild(self.date)

	self.name = display.newTTFLabel({
        size = 18,
        color = cc.c3b(97, 230, 87)
    })
    self.name:setAnchorPoint(0, 0.5)
    self:addChild(self.name)

    self.describe = display.newTTFLabel({
        size = 18,
        color = cc.c3b(212, 184, 166)
    })
    self.describe:setAnchorPoint(0, 0.5)
    self:addChild(self.describe)

    self.money = display.newTTFLabel({
        size = 18,
        color = cc.c3b(240, 243, 20)
    })
    self.money:setAnchorPoint(0, 0.5)
    self:addChild(self.money)
end

function GuildLogItem:setData(params)
	local date = os.date("%Y-%m-%d %H:%M", params.parameter1)
	self.date:setString(date)
    self.name:setPositionX(self.date:getContentSize().width + 30)
    self.name:setString(params.parameter2)
    self.describe:setPositionX(self.name:getPositionX() + self.name:getContentSize().width)
    self.money:setVisible(false)
    if params.type == 1 then
    	self.describe:setString("加入行会")
    elseif params.type == 2 then
    	self.describe:setString("退出行会")
    elseif params.type == 3 then
    	self.describe:setString("被踢出行会")
    elseif params.type == 4 then
    	self.describe:setString("捐献了")
    	self.money:setPositionX(self.describe:getPositionX() + self.describe:getContentSize().width)
    	self.money:setVisible(true)
    	self.money:setString(configHelper:getGuildDonation(params.parameter3).consume_value..(params.parameter3 == 1 and "金币" or "元宝"))
    elseif params.type == 5 then
    	self.describe:setString("职位变更为"..ZW_TYPE[params.parameter3])
    elseif params.type == 6 then
    	self.describe:setString("发放了")
    	self.money:setPositionX(self.describe:getPositionX() + self.describe:getContentSize().width)
    	self.money:setVisible(true)
    	self.money:setString(params.parameter3.."元宝红包")
    elseif params.type == 10 then
    	self.describe:setString("创建了行会")
    end
    local width
    if self.money:isVisible() then
    	width = self.money:getPositionX() + self.money:getContentSize().width
    else
    	width = self.describe:getPositionX() + self.describe:getContentSize().width
    end
     
    self:setContentSize(width, self.describe:getContentSize().height)
end



return GuildLogItem