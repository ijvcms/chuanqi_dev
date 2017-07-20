--
-- Author: Yi hanneng
-- Date: 2016-08-23 16:55:01
--

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
local OpenServeSMShopItem = OpenServeSMShopItem or class("OpenServeSMShopItem", UIAsynListViewItemEx)

function OpenServeSMShopItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/OpenServeSMShopItem.ExportJson")
    
    self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height + 10))
    self:init()
end

function OpenServeSMShopItem:init()
 
    self.tipsLabel = cc.uiloader:seekNodeByName(self.ccui, "tipsLabel")
    self.numLabel = cc.uiloader:seekNodeByName(self.ccui, "numLabel")
    self.getBtn = cc.uiloader:seekNodeByName(self.ccui, "getBtn")
 
 	self.itemList = {}

 	self.getBtn:setTouchEnabled(true)
    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.getBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.getBtn:setScale(1.0)
            if self.itemClickFunc then
            	self.itemClickFunc(self)
            end
        end
        return true
    end)
 
end

function OpenServeSMShopItem:setData(data)

	if data == nil then
		 
        return 
    end
    self.data = data
    if data.is_receive == 0 then
		self.getBtn:setButtonLabelString("领取")
		self.getBtn:setButtonEnabled(true)
	elseif data.is_receive == 1 then
		self.getBtn:setButtonLabelString("未获得")
		self.getBtn:setButtonEnabled(false)
	elseif data.is_receive == 2 then
		self.getBtn:setButtonLabelString("已领取")
		self.getBtn:setButtonEnabled(false)
	elseif data.is_receive == 3 then
		self.getBtn:setButtonLabelString("已领完")
		self.getBtn:setButtonEnabled(false)
	end

    self.tipsLabel:setString(data.desc)
    self.numLabel:setString(data.value)

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

                item:setPosition((i-1)*itemWidth + itemWidth/2 + 10 + w/2 - 20,itemHeight/2)
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

            item:setPosition((i-1)*itemWidth + itemWidth/2 + 10  + w/2 - 20,itemHeight/2)
        
        end
    end
          
end

function OpenServeSMShopItem:setItemClick(func)
	self.itemClickFunc = func
end

function OpenServeSMShopItem:setTouchEnabled(enable)

	if self.getBtn then
		if enable then
			self.getBtn:setButtonLabelString("领取")
		else
			self.getBtn:setButtonLabelString("已领取")
		end
		
		self.getBtn:setButtonEnabled(enable)
	end
 
end

function OpenServeSMShopItem:getData()
	return self.data
end

function OpenServeSMShopItem:destory()
end

return OpenServeSMShopItem