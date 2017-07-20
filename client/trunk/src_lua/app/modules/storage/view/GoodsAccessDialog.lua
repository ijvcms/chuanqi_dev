--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-04 14:49:17
--

--[[
    视图：仓库存/取道具对话框。
]]

local BatchAccessDialog = import(".BatchAccessDialog")
local GoodsAccessDialog = class("GoodsAccessDialog", function()
	return display.newNode()
end)

GoodsAccessDialog.ACCESS_TYPE_SAVE = 1
GoodsAccessDialog.ACCESS_TYPE_TAKE = 2

function GoodsAccessDialog:ctor()
	self:initialization()
end

function GoodsAccessDialog:initialization()
	self._accessType = nil
	self._dialogData = nil
	self:initComponents()
end

function GoodsAccessDialog:initComponents()
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    local ccui = cc.uiloader:load("resui/tt_itemBox.ExportJson")

    local x = (display.width - ccui:getContentSize().width) * 0.5
    local y = (display.height - ccui:getContentSize().height) * 0.5
    ccui:setPosition(x, y)
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
    local btnClose = cc.uiloader:seekNodeByName(win, "btnClose") 
    btnClose:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)

        if event.name == "began" then
            btnClose:setScale(1.1)
        elseif event.name == "ended" then
            btnClose:setScale(1)
            self:removeFromParent()
        end
        return true
    end)

    -- 左边的按钮
    local btn_left = cc.uiloader:seekNodeByName(win, "btnSell")
    self.btn_left = btn_left
    btn_left:setTouchEnabled(true)
    btn_left:onButtonPressed(function ()
        btn_left:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btn_left:onButtonRelease(function()
        btn_left:setScale(1.0)
    end)
    btn_left:onButtonClicked(function ()
        btn_left:setScale(1.0)
        self:onClickLeftButton()
    end)

    -- 右边的按钮
    local btn_right = cc.uiloader:seekNodeByName(win, "btnUse")
    cc.uiloader:seekNodeByName(win, "btnSet"):setVisible(false)
    self.btn_right = btn_right
    btn_right:setTouchEnabled(true)
    btn_right:onButtonPressed(function ()
        btn_right:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btn_right:onButtonRelease(function()
        btn_right:setScale(1.0)
    end)
    btn_right:onButtonClicked(function ()
        btn_right:setScale(1.0)
        self:onClickRightButton()
    end)

    self.labName      = cc.uiloader:seekNodeByName(win, "labName")
    self.labLevel     = cc.uiloader:seekNodeByName(win, "labLevel")
    self.labBind      = cc.uiloader:seekNodeByName(win, "labBind")
    self.itemBg       = cc.uiloader:seekNodeByName(win, "itemBg")
    self.labTypeValue = cc.uiloader:seekNodeByName(win, "labTypeValue")
    self.labContent   = cc.uiloader:seekNodeByName(win, "labContent")

    -- 隐藏发送按钮。
    cc.uiloader:seekNodeByName(win, "btnSend"):setVisible(false)
end

function GoodsAccessDialog:SetAccessType(type)
	self._accessType = type
	self:invalidateAccessType()
end

function GoodsAccessDialog:SetDialogData(data)
	self._dialogData = data
	self:invalidateDialogData()
end

function GoodsAccessDialog:Destory()
	self:removeFromParent()
end

function GoodsAccessDialog:invalidateAccessType()
	local leftButtonLabel = ""
	local rightButtonLabel = ""

	if self._accessType == GoodsAccessDialog.ACCESS_TYPE_SAVE then
		leftButtonLabel  = "存入"
		rightButtonLabel = "全部存入"
	end

	if self._accessType == GoodsAccessDialog.ACCESS_TYPE_TAKE then
		leftButtonLabel  = "取回"
		rightButtonLabel = "全部取回"
	end

	self.btn_left:setButtonLabelString(leftButtonLabel)
	self.btn_right:setButtonLabelString(rightButtonLabel)
end

function GoodsAccessDialog:invalidateDialogData()
	local data = self._dialogData
    --标题部分
    --装备名
    local equipName = configHelper:getGoodNameByGoodId(data.goods_id)
    self.labName:setString(equipName or "")

    --装备等级
    local equipLevel = configHelper:getGoodLVByGoodId(data.goods_id)
    self.labLevel:setString("LV."..(equipLevel or 0))

    --是否绑定
    self.labBind:setVisible((data.is_bind == 1) or false)

    --调整位置
    local x1 = self.labName:getContentSize().width + self.labName:getPositionX()
    self.labLevel:setPositionX(x1+10)
    local x2 = x1 + 10 + self.labLevel:getContentSize().width
    self.labBind:setPositionX(x2+10) 

    --图标
    local commonItem = CommonItemCell.new()
    commonItem:setData(data)
    if self.itemBg:getChildByTag(10) then
        self.itemBg:removeChildByTag(10,true)
    end
    self.itemBg:addChild(commonItem)
    commonItem:setPosition(self.itemBg:getContentSize().width/2,self.itemBg:getContentSize().height/2)
    commonItem:setTag(10)

    --类型
    local eType = configHelper:getGoodTypeStringByGoodId(data.goods_id)
    self.labTypeValue:setString(eType or "")

    --物品描述
    local describe = configHelper:getGoodDescByGoodId(data.goods_id)
    self.labContent:setString(describe or "")
end

--
-- 当点击了左边的按钮。
--
function GoodsAccessDialog:onClickLeftButton()
	if self._accessType == GoodsAccessDialog.ACCESS_TYPE_SAVE then
		self:doSave(false)
	end

	if self._accessType == GoodsAccessDialog.ACCESS_TYPE_TAKE then
		self:doTake(false)
	end
end

--
-- 当点击了右边的按钮。
--
function GoodsAccessDialog:onClickRightButton()
	if self._accessType == GoodsAccessDialog.ACCESS_TYPE_SAVE then
		self:doSave(true)
	end

	if self._accessType == GoodsAccessDialog.ACCESS_TYPE_TAKE then
		self:doTake(true)
	end
end

function GoodsAccessDialog:doSave(isAll)
	--[[
		判断物品数量是否大于1, 如果大于1并且不是全部存的话那么就打开批量存取对话框。
	]]
	local data = self._dialogData
	local numOfItem = data.num or 1
	if not isAll and data.num > 1 then
		-- TODO 打开批量存取对话框。
        self:openBatchDialog()
	else
         if self.SaveFunc then
            self.SaveFunc(data, numOfItem)
        end
		--GlobalController.storage:Save(data, numOfItem)
	end
    self:Destory()
end

function GoodsAccessDialog:doTake(isAll)
	--[[
		判断物品数量是否大于1, 如果大于1并且不是全部取的话那么就打开批量存取对话框。
	]]
	local data = self._dialogData
	local numOfItem = data.num or 1
	if not isAll and numOfItem > 1 then
		-- TODO 打开批量存取对话框。
        self:openBatchDialog()
	else
        if self.TakeFunc then
            self.TakeFunc(data, numOfItem)
        end
		--GlobalController.storage:Take(data, numOfItem)
	end
    self:Destory()
end

function GoodsAccessDialog:setSaveFunc(func)
    self.SaveFunc = func
end

function GoodsAccessDialog:setTakeFunc(func)
    self.TakeFunc = func
end

--
-- 打开批量存取对话框。
--
function GoodsAccessDialog:openBatchDialog()
    local dialog = BatchAccessDialog.new()
    dialog:SetAccessType(self._accessType)
    dialog:setSaveFunc(self.SaveFunc)
    dialog:setTakeFunc(self.TakeFunc)
    dialog:SetDialogData(self._dialogData)
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, dialog)
end


return GoodsAccessDialog