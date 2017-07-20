--
-- 系统设置子视图：
-- 		捡取设置。
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-30 14:00:21
--
local PickupView = class("PickupView", function()
    return display.newNode()
end)

function PickupView:ctor()
	self:initialization()
end

function PickupView:open()
	
end

function PickupView:initialization()
	self:initComponents()
	self:initListeners()
end

function PickupView:initComponents()
	self:loadUIFromJson()
	self:initButtons()
end

function PickupView:initButtons()
	local root = self.root

	--特殊拾取物品容器
	self.pickLay = cc.uiloader:seekNodeByName(root, "mainLayer")

	self.switch_auto_pick  = cc.uiloader:seekNodeByName(root, "switch1")

	self.pick_equip_white  = cc.uiloader:seekNodeByName(root, "equipChose1")
	self.pick_equip_green  = cc.uiloader:seekNodeByName(root, "equipChose2")
	self.pick_equip_blue  = cc.uiloader:seekNodeByName(root, "equipChose3")
	self.pick_equip_purple  = cc.uiloader:seekNodeByName(root, "equipChose4")
	self.pick_equip_orange  = cc.uiloader:seekNodeByName(root, "equipChose5")
	
	self.pick_prop_white  = cc.uiloader:seekNodeByName(root, "itemChose1")
	self.pick_prop_green  = cc.uiloader:seekNodeByName(root, "itemChose2")
	self.pick_prop_blue  = cc.uiloader:seekNodeByName(root, "itemChose3")
	self.pick_prop_purple  = cc.uiloader:seekNodeByName(root, "itemChose4")
	self.pick_prop_orange  = cc.uiloader:seekNodeByName(root, "itemChose5")


	local spPickUpconfigs = configHelper.pickup_setting.datas
	local spPickFields = configHelper.pickup_setting.fields
	for i=1,10 do
		self["spChose"..i] = cc.uiloader:seekNodeByName(root, "spChose"..i)
		self["labSpChose"..i] = cc.uiloader:seekNodeByName(self["spChose"..i], "label")
		if spPickUpconfigs[i] then
			self["labSpChose"..i]:setString(spPickUpconfigs[i][spPickFields[2]])
		else
			self["spChose"..i]:setVisible(false)
			self["labSpChose"..i]:setVisible(false)
		end
		
	end



	-- -- 自动卖出
	-- local checkContainer = cc.uiloader:seekNodeByName(root, "Image_1")
	-- self.switch_auto_sale  = cc.uiloader:seekNodeByName(root, "switch1")
	-- self.check_white_sale  = cc.uiloader:seekNodeByName(checkContainer, "witheChoseSelect")
	-- self.check_green_sale  = cc.uiloader:seekNodeByName(checkContainer, "purpleChoseSelect")
	-- self.check_blue_sale   = cc.uiloader:seekNodeByName(checkContainer, "blueChoseSelect")
	-- self.check_purple_sale = cc.uiloader:seekNodeByName(checkContainer, "greenChoseSelect")

	-- -- 自动捡取
	-- checkContainer = cc.uiloader:seekNodeByName(root, "Image_2")
	-- self.switch_auto_pick  = cc.uiloader:seekNodeByName(root, "switch2")
	-- self.switch_money_pick = cc.uiloader:seekNodeByName(checkContainer, "pickupCoinSwitch")
	-- self.switch_prop_pick  = cc.uiloader:seekNodeByName(checkContainer, "pickupGoodsSwitch")
	-- self.switch_equip_pick = cc.uiloader:seekNodeByName(checkContainer, "pickupEquipSwitch")

	-- self.check_white_pick  = cc.uiloader:seekNodeByName(checkContainer, "wihteSelect")
	-- self.check_green_pick  = cc.uiloader:seekNodeByName(checkContainer, "greenSelect")
	-- self.check_blue_pick   = cc.uiloader:seekNodeByName(checkContainer, "blueSelect")
	-- self.check_purple_pick = cc.uiloader:seekNodeByName(checkContainer, "purpleSelect")

	local initBindSwitchButton = function(button, option)
		local buttonPkg = {
			btn = button,
			opt = option,
			isSelected = SysOptionModel:getOptionByDefine(option),
		}

		self:setSwitchButton(button, buttonPkg.isSelected)
		button:setTouchEnabled(true)
		button:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			if event.name == "began" then
				SoundManager:playClickSound()
			elseif event.name == "ended" then
				buttonPkg.isSelected = not buttonPkg.isSelected
				self:setSwitchButton(button, buttonPkg.isSelected)
				SysOptionModel:setOptionByDefine(buttonPkg.opt, buttonPkg.isSelected)
			end
	        return true
	    end)
	end

	local initBindCheckButton = function(button, option)
		local buttonPkg = {
			btn = button,
			opt = option,
			isSelected = SysOptionModel:getOptionByDefine(option),
		}

		button:setButtonSelected(buttonPkg.isSelected)
		button:onButtonStateChanged(function()
			buttonPkg.isSelected = button:isButtonSelected()
			SysOptionModel:setOptionByDefine(option, buttonPkg.isSelected)
		end)
	end

	initBindSwitchButton(self.switch_auto_pick,  DefineOptions.AUTO_PICK_MAIN)--自动拾取

	initBindCheckButton(self.pick_equip_white,  DefineOptions.PICK_EQUIP_WHITE)
	initBindCheckButton(self.pick_equip_green,  DefineOptions.PICK_EQUIP_GREEN)
	initBindCheckButton(self.pick_equip_blue,  DefineOptions.PICK_EQUIP_BLUE)
	initBindCheckButton(self.pick_equip_purple,  DefineOptions.PICK_EQUIP_PURPLE)
	initBindCheckButton(self.pick_equip_orange,  DefineOptions.PICK_EQUIP_ORANGE)

	initBindCheckButton(self.pick_prop_white,  DefineOptions.PICK_PROP_WHITE)
	initBindCheckButton(self.pick_prop_green,  DefineOptions.PICK_PROP_GREEN)
	initBindCheckButton(self.pick_prop_blue,  DefineOptions.PICK_PROP_BLUE)
	initBindCheckButton(self.pick_prop_purple,  DefineOptions.PICK_PROP_PURPLE)
	initBindCheckButton(self.pick_prop_orange,  DefineOptions.PICK_PROP_ORANGE)

	for i=1,10 do
		initBindCheckButton(self["spChose"..i],  DefineOptions["PICK_SP_"..i])
	end

	-- initBindSwitchButton(self.switch_auto_sale,  DefineOptions.AUTO_SALE_MAIN)--自动出售
	-- initBindSwitchButton(self.switch_auto_pick,  DefineOptions.AUTO_PICK_MAIN)--自动拾取
	-- initBindSwitchButton(self.switch_money_pick, DefineOptions.PICK_MONEY) --自动拾取金币
	-- initBindSwitchButton(self.switch_prop_pick,  DefineOptions.PICK_PROP) --自动拾取道具
	-- initBindSwitchButton(self.switch_equip_pick, DefineOptions.PICK_EQUIP_MAIN) --自动拾取装备

	-- initBindCheckButton(self.check_white_sale,  DefineOptions.SALE_EQUIP_WHITE)--出售白色装备
	-- initBindCheckButton(self.check_green_sale,  DefineOptions.SALE_EQUIP_GREEN)--出售绿色装备
	-- initBindCheckButton(self.check_blue_sale,   DefineOptions.SALE_EQUIP_BLUE) --出售蓝色装备
	-- initBindCheckButton(self.check_purple_sale, DefineOptions.SALE_EQUIP_PURPLE)--出售紫色装备
	-- initBindCheckButton(self.check_white_pick,  DefineOptions.PICK_EQUIP_WHITE) --拾取白色装备
	-- initBindCheckButton(self.check_green_pick,  DefineOptions.PICK_EQUIP_GREEN) --拾取绿色装备
	-- initBindCheckButton(self.check_blue_pick,   DefineOptions.PICK_EQUIP_BLUE)  --拾取蓝色装备
	-- initBindCheckButton(self.check_purple_pick, DefineOptions.PICK_EQUIP_PURPLE) --拾取紫色装备
end

function PickupView:initListeners()
end

--
-- 从JSON布局文件中加载布局。
--
function PickupView:loadUIFromJson()
	self.root = cc.uiloader:load("resui/SOW_Pickup.ExportJson")
	self:addChild(self.root)
end

--
-- 设置开关按钮。
--
function PickupView:setSwitchButton(button, isSwitch)
	if not button then return end
	local pointSp = cc.uiloader:seekNodeByName(button, "slider")
	if isSwitch then
		pointSp:setPositionX(button:getContentSize().width)
	else
		pointSp:setPositionX(0)
	end
end

--
-- 注册全局事件监听。
--
function PickupView:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function PickupView:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

function PickupView:destory()
	self:removeAllEvents()
end

return PickupView