--
-- Author: Yi hanneng
-- Date: 2016-05-13 16:30:38
--

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
local OpenServeExpItem = OpenServeExpItem or class("OpenServeExpItem", UIAsynListViewItemEx)

function OpenServeExpItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/serveExpItem.ExportJson")
	self.ccui = loader:BuildNodesByCache(layoutFile)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function OpenServeExpItem:init()

	self.itemList = {}

	self.numLabel = cc.uiloader:seekNodeByName(self.ccui, "numLabel")
	self.btn_get = cc.uiloader:seekNodeByName(self.ccui, "getBtn")

	self.btn_get:setTouchEnabled(true)
  	self.btn_get:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_get:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_get:setScale(1.0)
            if self.func then
            	self.func(self)
            end
            --GlobalController.activity:requestActivityServiceReward(self.data.active_service_id)
        end
        return true
    end)
end

function OpenServeExpItem:setData(data)
	if data == nil then
		return 
	end
	self.data = data
	if data.is_receive == 0 then
		self.btn_get:setButtonLabelString("领取")
		self.btn_get:setButtonEnabled(true)
	elseif data.is_receive == 1 then
		self.btn_get:setButtonLabelString("未获得")
		self.btn_get:setButtonEnabled(false)
	elseif data.is_receive == 2 then
		self.btn_get:setButtonLabelString("已领取")
		self.btn_get:setButtonEnabled(false)
	elseif data.is_receive == 3 then
		self.btn_get:setButtonLabelString("已领完")
		self.btn_get:setButtonEnabled(false)
	end

	self.numLabel:setString(data.condition_text)

    local  goods = data["reward_"..RoleManager:getInstance().roleInfo.career]
    local w = self:getContentSize().width
 
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
                self.ccui:addChild(item)
                --item:setScale(0.8)
                self.itemList[#self.itemList + 1] = item
                    
                itemWidth = item:getContentSize().width + 20
                itemHeight = item:getContentSize().height + 28

                item:setPosition((i-1)*itemWidth + itemWidth/2 + 10 + w/2 - 80,itemHeight/2)
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
            self.ccui:addChild(item)
            --item:setScale(0.8)
            self.itemList[#self.itemList + 1] = item
            	
     		itemWidth = item:getContentSize().width + 20
     		itemHeight = item:getContentSize().height + 28

            item:setPosition((i-1)*itemWidth + itemWidth/2 + 10  + w/2 - 80,itemHeight/2)
        
        end
    end
end

function OpenServeExpItem:getData()

	return self.data

end
 
function OpenServeExpItem:setItemClick(func)

	self.func = func

end

function OpenServeExpItem:setTouchEnabled(enable)

	if self.btn_get then
		if enable then
			self.btn_get:setButtonLabelString("领取")
		else
			self.btn_get:setButtonLabelString("已领取")
		end
		
		self.btn_get:setButtonEnabled(enable)
	end
 
end

function OpenServeExpItem:open()
end

function OpenServeExpItem:close()
end

function OpenServeExpItem:destory()
end

return OpenServeExpItem