--
-- Author: Yi hanneng
-- Date: 2016-08-23 18:07:11
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
local OpenServeRankItem = OpenServeRankItem or class("OpenServeRankItem", UIAsynListViewItemEx)

function OpenServeRankItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/OpenServeRankItem.ExportJson")
    
    self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height + 10))
    self:init()
end

function OpenServeRankItem:init()
 
    self.rank = cc.uiloader:seekNodeByName(self.ccui, "rank")
    self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
 
 	self.itemList = {}
  
end

function OpenServeRankItem:setData(data)

	if data == nil then
		 
        return 
    end

    self.rank:setString(data.desc)
 	local  goods = data["reward_"..RoleManager:getInstance().roleInfo.career]
 
    if #self.itemList > 0 then

        for i=#self.itemList,#goods + 1, -1 do
            self.itemList[i]:setVisible(false)
        end

        for i=1,#goods do
            if self.itemList[i] == nil then
                local item = CommonItemCell.new()
                item:setData({goods_id = goods[i][1],is_bind = goods[i][2]})
                item:setCount(goods[i][3])
                item:setTouchSwallowEnabled(false)
                self.mainLayer:addChild(item)
                --item:setScale(0.8)
                self.itemList[#self.itemList + 1] = item
                    
                itemWidth = item:getContentSize().width + 20
                itemHeight = item:getContentSize().height + 25

                item:setPosition((i-1)*itemWidth + itemWidth/2 + 10,itemHeight/2)
            else
                self.itemList[i]:setVisible(true)
                self.itemList[i]:setData({goods_id = goods[i][1],is_bind = goods[i][2]})
                self.itemList[i]:setCount(goods[i][3])
 
            end
 
        end
    else
        for i=1,#goods do
                
            local item = CommonItemCell.new()
            item:setData({goods_id = goods[i][1],is_bind = goods[i][2]})
            item:setCount(goods[i][3])
            item:setTouchSwallowEnabled(false)
            self.mainLayer:addChild(item)
            --item:setScale(0.8)
            self.itemList[#self.itemList + 1] = item
            	
     		itemWidth = item:getContentSize().width + 20
     		itemHeight = item:getContentSize().height + 25

            item:setPosition((i-1)*itemWidth + itemWidth/2 + 10,itemHeight/2)
        
        end
    end

         
end

function OpenServeRankItem:setItemClick(func)
	self.itemClickFunc = func
end

function OpenServeRankItem:getData()
	return self.data
end

function OpenServeRankItem:destory()
end

return OpenServeRankItem