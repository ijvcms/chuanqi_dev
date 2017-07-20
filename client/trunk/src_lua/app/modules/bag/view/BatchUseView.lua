--
-- Author: Yi hanneng
-- Date: 2016-06-16 10:17:29
--

local BatchUseView = BatchUseView or class("BatchUseView", BaseView)

function BatchUseView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)
	self.ccui = cc.uiloader:load("resui/batchUsingWin.ExportJson")
	self.ccui:setPosition((display.width-400)/2,(display.height-336)/2)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function BatchUseView:init()

	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
	self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
	self.itemBg = cc.uiloader:seekNodeByName(self.ccui, "itemBg")
	self.btnRedu = cc.uiloader:seekNodeByName(self.ccui, "reduceBtn")
	self.btnAdd = cc.uiloader:seekNodeByName(self.ccui, "addBtn")
	self.InputBg = cc.uiloader:seekNodeByName(self.ccui, "inputBg")
	self.confirmBtn = cc.uiloader:seekNodeByName(self.ccui, "confirmBtn")
	self.maxBtn = cc.uiloader:seekNodeByName(self.ccui, "maxBtn")

	self.labCurCount = cc.ui.UIInput.new({
          UIInputType = 1,
          size = self.InputBg:getContentSize(),
          listener = handler(self,self.onEdit),
          image = "common/input_opacity1Bg.png"
        })

    --self.labCurCount:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.labCurCount:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
    self.labCurCount:setReturnType(1)
    self.labCurCount:setFontSize(18)
    self.labCurCount:setAnchorPoint(0, 0)
    self.labCurCount:setPosition(0, -2)
    self.InputBg:addChild(self.labCurCount)

    --------------------------------------
	self.curCount = 1

    local function setFunc(value)
    	if value < 1 then
    		value = 1
    	end

    	if value > self.totalSecure then
    		value = self.totalSecure
    	end
        self.curCount = value
        self:refreshCount()
    end

    local function getFunc()
        return self.curCount or 1
    end

	self.ctl = require("app.utils.QuickQuantityController").new(setFunc, getFunc)
    self.ctl:setMinimumValue(1)
    --增加按钮
 
    self.btnAdd:setTouchEnabled(true)
    self.btnAdd:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnAdd:setScale(1.2)
            SoundManager:playClickSound()
            self.ctl:start(.5, true)
        elseif event.name == "ended" then
            self.btnAdd:setScale(1.0)
            if not self.ctl:stop() then
                self:onAddClick()
            end
        end     
        return true
    end)

    --减少按钮
 
    self.btnRedu:setTouchEnabled(true)
    self.btnRedu:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnRedu:setScale(1.2)
            SoundManager:playClickSound()
            self.ctl:start(.5, false)
        elseif event.name == "ended" then
            self.btnRedu:setScale(1.0)
            if not self.ctl:stop() then
                self:onReduClick()
            end
        end     
        return true
    end)

    self.closeBtn:setTouchEnabled(true)
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:onClickClose()
            --GlobalWinManger:closeWin(self.winTag)     
         end     
        return true
    end)

    self.confirmBtn:setTouchEnabled(true)
	self.confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.confirmBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.confirmBtn:setScale(1.0)
            local data = {
            	goods_id = self.data.goods_id
        	}
            BagController:getInstance():requestUseGoods(data, self.curCount)

            -- GUIDE CONFIRM
            GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_BAG_USE_BUTTON) 
            self:onClickClose()
            
         end     
        return true
    end)

    self.maxBtn:setTouchEnabled(true)
	self.maxBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.maxBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.maxBtn:setScale(1.0)
			self.curCount = self.totalSecure
			self:refreshCount()      
         end     
        return true
    end)

end

function BatchUseView:onEdit(event, editbox)
    if event == "changed" then
        --if device.platform == "ios" then
            local checkText = editbox:getText()
            local text = string.gsub(checkText,"[\\.]", "")
            local count = tonumber(text, 10) or 1
            self.curCount = count
            if self.totalSecure then
                if count > self.totalSecure then
                    count = self.totalSecure
                end
            end
            if count < 1 then
                count = 1
            end
            if count > self.totalSecure then
            	count = self.totalSecure
            end
            if checkText ~= text or self.curCount ~= count then
                editbox:setText(tostring(count))
            end
            self.curCount = count
        --end
    end
end


function BatchUseView:resetCount()
    self.curCount = 1 
    self:refreshCount()
end

function BatchUseView:onAddClick( )
    self.curCount = self.curCount + 1
 
    if self.curCount > self.totalSecure then
    	self.curCount = self.totalSecure
    end
    self:refreshCount()
end

function BatchUseView:onReduClick( )
    self.curCount = self.curCount - 1 
    if self.curCount < 1 then
    	self.curCount = 1
    end
    self:refreshCount()
end

function BatchUseView:refreshCount()
    self.labCurCount:setText(tostring(self.curCount))
    if self.countChangeListener then
        self.countChangeListener(self.curCount,self.labPart1)
    end
end

function BatchUseView:setViewInfo(data)

	self.data = data
	local equipName = configHelper:getGoodNameByGoodId(data.goods_id)
    if data.stren_lv >0 then
        self.nameLabel:setString(equipName.."+"..data.stren_lv)
    else
        self.nameLabel:setString(equipName)
    end
    local quality = configHelper:getGoodQualityByGoodId(data.goods_id)
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
            self.nameLabel:setTextColor(color)
        end
    end

	--图标
    local commonItem = CommonItemCell.new()
    commonItem:setData(data)
    
    if self.itemBg:getChildByTag(10) then
        self.itemBg:removeChildByTag(10)
    end
    self.itemBg:addChild(commonItem)
    commonItem:setTag(10)
    commonItem:setItemClickFunc(handler(self,self.onItemClick))
    commonItem:setPosition(self.itemBg:getContentSize().width/2,self.itemBg:getContentSize().height/2)
 
    self.totalSecure = data.num
    self.ctl:setMaximumValue(self.totalSecure)
   
    self:refreshCount()
end

function BatchUseView:open()
end

function BatchUseView:onClickClose()
    self:removeSelf()
end


return BatchUseView