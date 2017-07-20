--
-- Author: Yi hanneng
-- Date: 2016-08-30 17:38:44
--


local UIAsynListViewItem = import("app.gameui.listViewEx.UIAsynListViewItem")
require("app.modules.role.RoleManager")

local CopyRewardItem = CopyRewardItem or class("CopyRewardItem",UIAsynListViewItem)

function CopyRewardItem:ctor()
	 
    self:init()
end

function CopyRewardItem:init()

    self.numLbl = display.newTTFLabel({
      text = "",
      size = 18,
      color = TextColor.TEXT_W
    })
 
    self:addChild(self.numLbl)
    
    self.numLbl:setAnchorPoint(0,0.5)
    
end
 
function CopyRewardItem:setData(data)

    self.numLbl:setString( "x"..data.goodsNum)

    if self.commonItem == nil then
    	self.commonItem = CommonItemCell.new()
    	self:addChild(self.commonItem)
    	self.commonItem:setScale(1)
    end
    
 	self.commonItem:setData({goods_id = data.goodsId})
 	self.numLbl:setPositionX(self.commonItem:getPositionX() + self.commonItem:getContentSize().width/2 + 10)

end

function CopyRewardItem:getData()
    return self.data
end
 

function CopyRewardItem:destory()
 
end

return CopyRewardItem