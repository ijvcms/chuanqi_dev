--
-- Author: Yi hanneng
-- Date: 2016-05-11 19:29:49
--
local EquipDecomposeViewII = EquipDecomposeViewII or class("EquipDecomposeViewII", BaseView)

function EquipDecomposeViewII:ctor()
	self.ccui = cc.uiloader:load("resui/resolveTipsWin.ExportJson")
	
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
   	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self.ccui:setPosition(display.width/2 - self:getContentSize().width/2,display.height/2 - self:getContentSize().height/2)
   	self:init()

end

function EquipDecomposeViewII:init()

	self.itemLayer = cc.uiloader:seekNodeByName(self.ccui, "itemLayer")
	self.resolveBtn = cc.uiloader:seekNodeByName(self.ccui, "resolveBtn")
	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")

	self.resolveBtn:setTouchEnabled(true)
  	self.resolveBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.resolveBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.resolveBtn:setScale(1.0)
            GlobalController.equip:requestDecompose(self.data.id)
            self:onClickClose()
        end
        return true
    end)

    self.closeBtn:setTouchEnabled(true)
  	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:onClickClose()
        end
        return true
    end)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            
        end     
        return true
    end)
end

function EquipDecomposeViewII:setData(data)

	self.data = data
	local info = configHelper:getDecomposeById(data.goods_id)
	local soulNum = 0

	if data.soul > 0 then
		for i=1,data.soul do
			soulNum = soulNum + configHelper:getSoulConfigByIdAndLv(data.goods_id,i)[1][2]
		end
	end

	if info ~= nil then
		for i=1,#info.goods_list do
			local temp = info.goods_list[i][3]
			if info.goods_list[i][1] ==  110160 then
				temp = info.goods_list[i][3] + math.floor(soulNum*0.3)
			end
			local commonItem = self:createItem({goods_id = info.goods_list[i][1],is_bind = info.goods_list[i][2],num =temp})
			commonItem:setPosition(i*(commonItem:getContentSize().width+20) - 50, 80)
			self.itemLayer:addChild(commonItem)
		end
	end
 
end

function EquipDecomposeViewII:createItem(info)
	local node = display.newNode()
	local bg = display.newSprite("#com_propBg1.png")
	local commonItem = CommonItemCell.new()
	commonItem:setData(info)
	commonItem:setCount(info.num)
	node:setContentSize(cc.size(bg:getContentSize().width, bg:getContentSize().height))
	node:addChild(bg)
	node:addChild(commonItem)
	--commonItem:setPosition(commonItem:getContentSize().width/2,commonItem:getContentSize().height/2)
	local nameLabel = display.newTTFLabel({
    text = configHelper:getGoodNameByGoodId(info.goods_id),
    size = 20,
    align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})

	node:addChild(nameLabel)
	nameLabel:setPosition(0, - bg:getContentSize().height/2 - 22)

	local quality = configHelper:getGoodQualityByGoodId(info.goods_id)
		    if quality then
		        local color
		        if quality == 1 then            --白
		            color = TextColor.TEXT_W
		        elseif quality == 2 then        --绿
		            color = TextColor.TEXT_G
		        elseif quality == 3 then        --蓝
		            color = TextColor.ITEM_B
		        elseif quality == 4 then        --紫
		            color = TextColor.ITEM_P
		        elseif quality == 5 then        --橙
		            color = TextColor.TEXT_O
		        elseif quality == 6 then        --红
		            color = TextColor.TEXT_R
		        end 
		        if color then
		            nameLabel:setColor(color)
		        end
		    end

	return node
end

function EquipDecomposeViewII:open()
end


function EquipDecomposeViewII:onClickClose()
	self:removeSelf()
end

return EquipDecomposeViewII