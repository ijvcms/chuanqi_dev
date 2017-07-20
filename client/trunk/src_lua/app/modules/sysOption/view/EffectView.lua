--
-- 系统设置子视图：
-- 		游戏效果设置。
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-30 14:00:21
--
local LocalDatasManager = require("common.manager.LocalDatasManager")
local EffectView = class("EffectView", function()
    return display.newNode()
end)

function EffectView:ctor()
	self:initialization()
end

function EffectView:open()

end

function EffectView:initialization()
	self:initComponents()
	self:initListeners()
end

function EffectView:initComponents()
	self:loadUIFromJson()
	self:initButtons()
end

function EffectView:initButtons()
	local root = self.root

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

	-- 自动卖出
	self.switch_music       = cc.uiloader:seekNodeByName(root, "musicSwitch")
	self.switch_sound       = cc.uiloader:seekNodeByName(root, "soundSwitch")
	self.switch_player      = cc.uiloader:seekNodeByName(root, "playerSwitch")
	self.switch_effect      = cc.uiloader:seekNodeByName(root, "effectSwitch")
	self.switch_player_name = cc.uiloader:seekNodeByName(root, "playerNameSwitch")
	self.switch_goods_name  = cc.uiloader:seekNodeByName(root, "goodsNameSwitch")
	self.switch_message     = cc.uiloader:seekNodeByName(root, "messageSwitch")
	self.switch_mount     = cc.uiloader:seekNodeByName(root, "mountSwitch")

	initBindSwitchButton(self.switch_music,  DefineOptions.SYS_MUSIC)
	initBindSwitchButton(self.switch_sound,  DefineOptions.SYS_SOUND)
	initBindSwitchButton(self.switch_player, DefineOptions.SYS_PLAYER)
	initBindSwitchButton(self.switch_effect,      DefineOptions.SYS_EFFECT)
	initBindSwitchButton(self.switch_player_name, DefineOptions.SYS_PLAYER_NAME)
	initBindSwitchButton(self.switch_goods_name,  DefineOptions.SYS_GOODS_NAME)
	initBindSwitchButton(self.switch_message,     DefineOptions.SYS_MESSAGE)
	initBindSwitchButton(self.switch_mount,     DefineOptions.SYS_MOUNT)
end

function EffectView:initListeners()
end

--
-- 设置开关按钮。
--
function EffectView:setSwitchButton(button, isSwitch)
	if not button then return end
	local pointSp = cc.uiloader:seekNodeByName(button, "slider")
	local clearance = 12
	if isSwitch then
		pointSp:setPositionX(button:getContentSize().width - clearance)
	else
		pointSp:setPositionX(0 + clearance)
	end
end

--
-- 注册全局事件监听。
--
function EffectView:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function EffectView:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

function EffectView:destory()
	self:removeAllEvents()
end

function EffectView:loadUIFromJson()
	self.root = cc.uiloader:load("resui/SOW_Effect.ExportJson")
	self:addChild(self.root)
end

return EffectView