--
-- Author: Yi hanneng
-- Date: 2016-08-18 14:44:56
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
local HolidayActivityKillItem = HolidayActivityKillItem or class("HolidayActivityKillItem", UIAsynListViewItemEx)
function HolidayActivityKillItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/HolidayActivityKillItem.ExportJson")
    
    self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height + 10))
    self:init()
end

function HolidayActivityKillItem:init()

    self.itemList = {}
    self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")
    self.getBtn = cc.uiloader:seekNodeByName(self.ccui, "getBtn")
 
end
 
function HolidayActivityKillItem:setData(data)

	if data == nil then
        return 
    end
 
    self.titleLabel:setString(data[2])
 
    local itemWidth = 0
    local itemHeight = 0

    if #self.itemList > 0 then

        for i=#self.itemList,#data[3] + 1, -1 do
            self.itemList[i]:setVisible(false)
        end

        for i=1,#data[3] do
            if self.itemList[i] == nil then
                local item = CommonItemCell.new()
                item:setData({goods_id = data[3][i][1],is_bind = data[3][i][2]})
                item:setCount(data[3][i][3])
                item:setTouchSwallowEnabled(false)
                self.ccui:addChild(item)
                --item:setScale(0.8)
                self.itemList[#self.itemList + 1] = item
                    
                itemWidth = item:getContentSize().width + 20
                itemHeight = item:getContentSize().height + 10

                item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2 + 12)
            else
            	self.itemList[i]:setVisible(true)
                self.itemList[i]:setData({goods_id = data[3][i][1],is_bind = data[3][i][2]})
                self.itemList[i]:setCount(data[3][i][3])
            end
 
        end
    else
        for i=1,#data[3] do
                
            local item = CommonItemCell.new()
            item:setData({goods_id = data[3][i][1],is_bind = data[3][i][2]})
            item:setCount(data[3][i][3])
            item:setTouchSwallowEnabled(false)
            self.ccui:addChild(item)
            --item:setScale(0.8)
            self.itemList[#self.itemList + 1] = item
            	
     		itemWidth = item:getContentSize().width + 20
     		itemHeight = item:getContentSize().height + 10

            item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2 + 12)
        
        end
    end
 
end

 
function HolidayActivityKillItem:getData()
	return self.data
end

function HolidayActivityKillItem:destory()
end

return HolidayActivityKillItem