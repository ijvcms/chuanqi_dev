--
-- Author: Yi hanneng
-- Date: 2016-06-12 15:41:51
--
--[[
－－－－－－－－－－－－－－－－投保系统－－－－－－－－－－－－－－－－－
--]]

local SecureView = SecureView or class("SecureView", BaseView)

local InsuranceDesWin = class("InsuranceDesWin", function()
    return display.newNode()
end)

function SecureView:ctor(data)--winTag,data,winconfig
	--SecureView.super.ctor(self,winTag,data,winconfig)

    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)
	self.ccui = cc.uiloader:load("resui/insuranceWin.ExportJson")     
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    self.ccui:setPosition((display.width-self.ccui:getContentSize().width)/2,(display.height-self.ccui:getContentSize().height)/2)

    self.data = data
	self:init()
    self:open()
end

function SecureView:init()

	local root = cc.uiloader:seekNodeByName(self.ccui, "root")
	self.btnlist = {}
	self.desLayer = cc.uiloader:seekNodeByName(root, "desLayer")
	self.nameLabel = cc.uiloader:seekNodeByName(root, "nameLabel")
	self.typeLabel = cc.uiloader:seekNodeByName(root, "typeLabel")
	self.occupationLabel = cc.uiloader:seekNodeByName(root, "occupationLabel")
	self.scoreLabel = cc.uiloader:seekNodeByName(root, "scoreLabel")
	self.itemBg = cc.uiloader:seekNodeByName(root, "itemBg")
	self.timesLabel = cc.uiloader:seekNodeByName(root, "timesLabel")
	self.timesLabel2 = cc.uiloader:seekNodeByName(root, "timesLabel2")
	self.btnRedu = cc.uiloader:seekNodeByName(root, "minusBtn")
	self.btnAdd = cc.uiloader:seekNodeByName(root, "addBtn")
	self.InputBg = cc.uiloader:seekNodeByName(root, "InputBg")

	self.numLabel = cc.uiloader:seekNodeByName(root, "numLabel")

	self.cancelBtn = cc.uiloader:seekNodeByName(root, "cancelBtn")
	self.confirmBtn = cc.uiloader:seekNodeByName(root, "confirmBtn")
	self.helpBtn = cc.uiloader:seekNodeByName(root, "helpBtn")
	self.closeBtn = cc.uiloader:seekNodeByName(root, "closeBtn")
    self.maxBtn = cc.uiloader:seekNodeByName(self.ccui, "maxBtn")

	self.labCurCount = cc.ui.UIInput.new({
          UIInputType = 1,
          size = self.InputBg:getContentSize(),
          listener = handler(self,self.onEdit),
          image = "common/input_opacity1Bg.png"
        })

    self.labCurCount:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.labCurCount:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
    self.labCurCount:setReturnType(1)
    self.labCurCount:setFontSize(18)
    self.labCurCount:setAnchorPoint(0, 0)
    self.labCurCount:setPosition(0, -2)
    self.InputBg:addChild(self.labCurCount)

	--------------------------------------

    --特殊
    local specialBtn = cc.uiloader:seekNodeByName(root, "specialBtn")
    self.specialBtn = specialBtn
    specialBtn:setTouchEnabled(true)
    specialBtn:onButtonPressed(function ()
        specialBtn:setScale(1.1)
        SoundManager:playClickSound()
    end)
    specialBtn:onButtonRelease(function()
        specialBtn:setScale(0.9)
    end)
    specialBtn:onButtonClicked(function ()
        specialBtn:setScale(0.9)
        self:onSpecialClick()
    end)
	

    local function setFunc(value)
    	if value < self.less then
    		value = self.less
    	end

    	if value > self.totalSecure then
    		value = self.totalSecure
    	end
        self.curCount = value
        self:refreshCount()
    end

    local function getFunc()
        return self.curCount or self.less
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

	self.helpBtn:setTouchEnabled(true)
	self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.helpBtn:setScale(1.0)

            if self.helpView == nil then
            	self.helpView = InsuranceDesWin.new()
            	self.desLayer:addChild(self.helpView)
            end
            self.helpView:setVisible(true)
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
            self:destory()
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
            SecureController:getInstance():requestSecure(self.data.id, self.curCount)
         end     
        return true
    end)

    self.cancelBtn:setTouchEnabled(true)
	self.cancelBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.cancelBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.cancelBtn:setScale(1.0)
            self:destory()
            --GlobalWinManger:closeWin(self.winTag)      
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

    if self.helpView == nil then
        self.helpView = InsuranceDesWin.new()
        self.desLayer:addChild(self.helpView)
    end
    self.helpView:setVisible(true)

end

function SecureView:setData(data)

	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    career = career or roleInfo.career

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
            self.nameLabel:setColor(color)
        end
    end
    --类型
    local eType = configHelper:getEquipTypeByEquipId(data.goods_id)
    self.typeLabel:setString(eType or "")

    --职业
    local eType,eId = configHelper:getEquipCareerByEquipId(data.goods_id)
    --[[
    if eId ~= roleInfo.career then
        self.occupationLabel:setColor(TextColor.TEXT_R)
    else
        self.occupationLabel:setColor(cc.c3b(23,7,8))
    end
    --]]
    self.occupationLabel:setString(eType or "")


    --评分
    self.scoreLabel:setString(data.fighting)

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

    self.timesLabel2:setString(data.secure)
    self.timesLabel:setString(data.secure)

    self.totalSecure = 10 - data.secure
    if self.totalSecure > 0 then
        self.less = 1
    else
        self.less = 0
    end
    self.curCount = 1
    
    self.ctl:setMaximumValue(self.totalSecure)
    self.securePrice = configHelper:getGoodsSecurePriceByGoodsId(data.goods_id)

    --是否显示特殊装备按钮
    if configHelper:getGoodsSpecialByGoodsId(data.goods_id) == 1 then
        self.specialBtn:setVisible(true)
    else
        self.specialBtn:setVisible(false)
    end

    self:refreshCount()
end

function SecureView:onEdit(event, editbox)
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
            if count < self.less then
                count = self.less
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


function SecureView:resetCount()
    self.curCount = self.less 
    self:refreshCount()
end

function SecureView:onAddClick( )
    self.curCount = self.curCount + 1
 
    if self.curCount > self.totalSecure then
    	self.curCount = self.totalSecure
    end
    self:refreshCount()
end

function SecureView:onReduClick( )
    self.curCount = self.curCount - 1 
    if self.curCount < self.less then
    	self.curCount = self.less
    end
    self:refreshCount()
end

function SecureView:refreshCount()
    self.labCurCount:setText(tostring(self.curCount))
    self.numLabel:setString(self.curCount*self.securePrice)
    if self.countChangeListener then
        self.countChangeListener(self.curCount,self.labPart1)
    end
end

function SecureView:reset()
    --self.data.secure = self.data.secure+self.curCount--由背包变更协议去更新数据 by shine，修改请咨询
	local secure = self.data.secure+self.curCount
    self.totalSecure = 10 - secure
    if self.totalSecure > 0 then
        self.less = 1
    else
        self.less = 0
    end
	self.timesLabel2:setString(secure)
    self.timesLabel:setString(secure)
    self.curCount = 0
	self:refreshCount()

end

function SecureView:open()
	
	GlobalEventSystem:addEventListener(SecureEvent.SECURE_SUCCESS,handler(self, self.reset))
	self:setData(self.data)
end

function SecureView:close()
	GlobalEventSystem:removeEventListener(SecureEvent.SECURE_SUCCESS)
end

function SecureView:destory()
    self:close();
    self.super.destory(self)
    self:removeSelf()
end

----------------------------------------------------------

function InsuranceDesWin:ctor()

	self.ccui = cc.uiloader:load("resui/insuranceDesWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function InsuranceDesWin:init()

	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")

	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:setVisible(false)
         end     
        return true
    end)

end

function InsuranceDesWin:onSpecialClick( )
    local upWin = require("app.modules.tips.view.SpecialTips").new()
    upWin:setData({title = "特殊说明",content = configHelper:getGoodDescByGoodId(self.data.goods_id)})
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,upWin)
end

function InsuranceDesWin:open()
end

function InsuranceDesWin:close()
end

return SecureView