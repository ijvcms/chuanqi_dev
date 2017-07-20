--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-04 17:29:14
--

--[[
    视图：仓库批量存/取对话框。
]]
local BatchAccessDialog = BatchAccessDialog or class("BatchAccessDialog", function()
    return display.newNode()
end)

BatchAccessDialog.ACCESS_TYPE_SAVE = 1
BatchAccessDialog.ACCESS_TYPE_TAKE = 2

function BatchAccessDialog:ctor()
	self:initialization()
end

function BatchAccessDialog:initialization()
	self._accessType    = nil
	self._dialogData    = nil
	self._currentNumber = nil
	self:initComponents()
end

function BatchAccessDialog:initComponents()
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    local ccui = cc.uiloader:load("resui/batchBuyWin.ExportJson")
    self:addChild(ccui)

    local root = cc.uiloader:seekNodeByName(ccui, "root")
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:removeFromParent()
        end
        return true
    end)

    local win = cc.uiloader:seekNodeByName(root, "win")
    self.win = win

    local winbg = cc.uiloader:seekNodeByName(win, "bg")
    winbg:setTouchEnabled(true)
    winbg:setTouchSwallowEnabled(true)

    --关闭按钮
    self.closeBtn = cc.uiloader:seekNodeByName(win,"btnClose")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:removeFromParent()
        end
        return true
    end)
    ----------------
    local function setFunc(value)
        self._currentNumber = value
        self:setNumber(self._currentNumber)
    end

    local function getFunc()
        return self._currentNumber or 1
    end

    self.ctl = require("app.utils.QuickQuantityController").new(setFunc, getFunc)
    self.ctl:setMinimumValue(1)
    --增加按钮
    self.btnAdd = cc.uiloader:seekNodeByName(win,"btnAdd")
    self.btnAdd:setTouchEnabled(true)
    self.btnAdd:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnAdd:setScale(1.2)
            SoundManager:playClickSound()
            self.ctl:start(.5, true)
        elseif event.name == "ended" then
            self.btnAdd:setScale(1.0)
            if not self.ctl:stop() then
                self:addNumber()
            end
        end     
        return true
    end)

    --减少按钮
    self.btnRedu = cc.uiloader:seekNodeByName(win,"btnRedu")
    self.btnRedu:setTouchEnabled(true)
    self.btnRedu:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnRedu:setScale(1.2)
            SoundManager:playClickSound()
            self.ctl:start(.5, false)
        elseif event.name == "ended" then
            self.btnRedu:setScale(1.0)
            if not self.ctl:stop() then
                self:subNumber()
            end
        end     
        return true
    end)
    -------------------
   
    -- 存入/取出按钮
    self.confirmButton = cc.uiloader:seekNodeByName(win,"btnBuy")
    self.confirmButton:setTouchEnabled(true)
    self.confirmButton:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.confirmButton:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.confirmButton:setScale(1.0)
            self:onClickConfirmButton()
        end     
        return true
    end)

    self.labConfirmButton = cc.uiloader:seekNodeByName(win, "Label_59")
    self.labBg = cc.uiloader:seekNodeByName(win,"Image_52")
    self.labCurCount = cc.ui.UIInput.new({
          UIInputType = 1,
          size = self.labBg:getContentSize(),
          listener = handler(self,self.onEdit),
          image = "common/input_opacity1Bg.png"
        })
    self.labCurCount:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.labCurCount:setReturnType(1)
    self.labCurCount:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.labCurCount:setFontSize(18)
    self.labCurCount:setAnchorPoint(0, 0)
    self.labCurCount:setPosition(0, -2)
    self.labBg:addChild(self.labCurCount)
    self.labTitle    = cc.uiloader:seekNodeByName(win, "labTitle")
    self.labTotal    = cc.uiloader:seekNodeByName(win, "labPart1")
    self.labName     = cc.uiloader:seekNodeByName(self.win, "labName")
    self.labContent  = cc.uiloader:seekNodeByName(self.win, "labContent")
    self.itemBg      = cc.uiloader:seekNodeByName(self.win, "itemBg")

    cc.uiloader:seekNodeByName(win, "labPart2"):removeFromParent()
    cc.uiloader:seekNodeByName(win, "labPart3"):removeFromParent()
end

function BatchAccessDialog:onEdit(event, editbox)
    if event == "changed" then
        --if device.platform == "ios" then
            local checkText = editbox:getText()
            local text = string.gsub(checkText,"[\\.]", "")
            local count = tonumber(text, 10) or 1
            self._currentNumber = count
            if count > self:getDataNumber() then
                count = self:getDataNumber()
            end
            if count < 1 then
                count = 1
            end
            if checkText ~= text or self._currentNumber ~= count then
                editbox:setText(tostring(count))
            end
            self._currentNumber = count
        --end
    end
end

function BatchAccessDialog:SetAccessType(type)
	self._accessType = type
	self:invalidateAccessType()
end

function BatchAccessDialog:SetDialogData(data)
	self._dialogData = data
    self.ctl:setMaximumValue(self:getDataNumber())
	self:invalidateDialogData()
end

function BatchAccessDialog:Destory()
	self:removeSelfSafety()
end

function BatchAccessDialog:invalidateAccessType()
	local titleLabel   = ""
	local confirmLabel = ""

	if self._accessType == BatchAccessDialog.ACCESS_TYPE_SAVE then
		titleLabel   = "道具存入"
		confirmLabel = "确认存入"
	end

	if self._accessType == BatchAccessDialog.ACCESS_TYPE_TAKE then
		titleLabel   = "道具取回"
		confirmLabel = "确认取回"
	end

	self.labTitle:setString(titleLabel)
	self.labConfirmButton:setString(confirmLabel)
end

function BatchAccessDialog:invalidateDialogData()
	local data = self._dialogData
	local totleLabel   = "总数:" .. data.num

    --物品名
    self.labName:setString(configHelper:getGoodNameByGoodId(data.goods_id))

    --物品描述
    self.labContent:setString(configHelper:getGoodDescByGoodId(data.goods_id))

    --物品图标
    if self.itemBg:getChildByTag(10) then
        self.itemBg:removeChildByTag(10)
    end
    local commonItem = CommonItemCell.new()
    commonItem:setData(data)
    commonItem:setTag(10)
    commonItem:setPosition(self.itemBg:getContentSize().width/2, self.itemBg:getContentSize().height/2)
    commonItem:setFrameVisible(false)
    self.itemBg:addChild(commonItem)

	self.labTotal:setString(totleLabel)
	self._currentNumber = 0
	self:setNumber(1)
end

function BatchAccessDialog:setNumber(newNumber)
	self._currentNumber = newNumber
    if self._currentNumber > self:getDataNumber() then
        self._currentNumber = self:getDataNumber()
    end
    if self._currentNumber < 1 then
        self._currentNumber = 1
    end
	self.labCurCount:setText(tostring(self._currentNumber))
end

function BatchAccessDialog:addNumber()
	self:setNumber(self._currentNumber + 1)
end

function BatchAccessDialog:subNumber()
	self:setNumber(self._currentNumber - 1)
end

function BatchAccessDialog:getDataNumber()
	return self._dialogData.num
end

--
-- 当点击了确认存/取按钮。
--
function BatchAccessDialog:onClickConfirmButton()
	if self._accessType == BatchAccessDialog.ACCESS_TYPE_SAVE then
		self:doSave()
	end

	if self._accessType == BatchAccessDialog.ACCESS_TYPE_TAKE then
		self:doTake()
	end
end

function BatchAccessDialog:doSave()
    if self.SaveFunc then
        self.SaveFunc(self._dialogData, self._currentNumber)
    end
	--GlobalController.storage:Save(self._dialogData, self._currentNumber)
	self:Destory()
end

function BatchAccessDialog:doTake()
    if self.TakeFunc then
        self.TakeFunc(self._dialogData, self._currentNumber)
    end
	--GlobalController.storage:Take(self._dialogData, self._currentNumber)
	self:Destory()
end

function BatchAccessDialog:setSaveFunc(func)
    self.SaveFunc = func
end

function BatchAccessDialog:setTakeFunc(func)
    self.TakeFunc = func
end

return BatchAccessDialog