--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-29 19:56:59
-- 系统设置模型
local LocalDatasManager = require("common.manager.LocalDatasManager")
local LOCAL_DATA_KEY = "system_options"
SysOptionModel = SysOptionModel or {}

DefineOptions = {
	AUTO_SALE_MAIN    = 1,  -- 自动出售总开关
	SALE_EQUIP_WHITE  = 2,  -- 自动出售白色装备
	SALE_EQUIP_GREEN  = 3,  -- 自动出售绿色装备
	SALE_EQUIP_BLUE   = 4,  -- 自动出售蓝色装备
	SALE_EQUIP_PURPLE = 5,  -- 自动出售紫色装备

	PICK_MONEY        = 7,  -- 自动捡取金币
	PICK_PROP         = 8,  -- 自动捡取道具


	AUTO_PICK_MAIN    = 6,  -- 自动捡取总开关

	PICK_PROP_MAIN   = 31,  -- 自动捡取道具总开关
	PICK_PROP_WHITE  = 32, -- 自动捡取白色装备
	PICK_PROP_GREEN  = 33, -- 自动捡取绿色装备
	PICK_PROP_BLUE   = 34, -- 自动捡取蓝色装备
	PICK_PROP_PURPLE = 35, -- 自动捡取紫色装备
	PICK_PROP_ORANGE = 36, -- 自动捡取橙色装备

	PICK_EQUIP_MAIN   = 37,  -- 自动捡取装备总开关
	PICK_EQUIP_WHITE  = 38, -- 自动捡取白色装备
	PICK_EQUIP_GREEN  = 39, -- 自动捡取绿色装备
	PICK_EQUIP_BLUE   = 40, -- 自动捡取蓝色装备
	PICK_EQUIP_PURPLE = 41, -- 自动捡取紫色装备
	PICK_EQUIP_ORANGE = 42, -- 自动捡取橙色装备

	PICK_SP_1 = 43,  --特殊物品1
	PICK_SP_2 = 44,  --特殊物品2
	PICK_SP_3 = 45,  --特殊物品3
	PICK_SP_4 = 46,  --特殊物品4
	PICK_SP_5 = 47,  --特殊物品5
	PICK_SP_6 = 48,  --特殊物品6
	PICK_SP_7 = 49,  --特殊物品7
	PICK_SP_8 = 50,  --特殊物品8
	PICK_SP_9 = 51,  --特殊物品9
	PICK_SP_10 = 52,  --特殊物品10

	SYS_MUSIC       = 14, -- 系统音乐
	SYS_SOUND       = 15, -- 系统声音
	SYS_PLAYER      = 16, -- 显示玩家
	SYS_EFFECT      = 17, -- 显示特效
	SYS_PLAYER_NAME = 18, -- 显示玩家名
	SYS_GOODS_NAME  = 19, -- 显示物品名
	SYS_MESSAGE     = 20, -- 推送消息

	SYS_MOUNT     = 120, -- 自动上下坐骑

	HIDE_SPEQUIP     = 1120, -- 是否隐藏特装
}

function SysOptionModel:ctor()
	self.switchSound = true --音效开关
	self.switchMusic = true --音乐开关
	self.switchShowPlayer = true --显示玩家开关
	self.switchShowEffect = true --显示特效开关
	self.switchShowPlayerName = true --显示玩家名称开关
	self.switchShowGoodsName  = true --显示物品名称开关
	self.switchPushMessage    = true --推送消息开关

	self.switchMount    = true --自动上下坐骑
	self.hideSpEquip = true --是否隐藏特装

	self.switchSaleMain   = true --自动出售总开关
	self.switchSaleEquipW = true --挂机自动售出白色装备开关
	self.switchSaleEquipG = true --挂机自动售出绿色装备开关
	self.switchSaleEquipB = true --挂机自动售出蓝色装备开关
	self.switchSaleEquipP = true --挂机自动售出紫色装备开关

	self.switchPickupMain      = true --自动拾取总开关
	self.switchPickupMoney     = true --自动拾取金币开关
	self.switchPickupProp      = true --自动拾取道具开关
	self.switchPickupEquipMain = true --自动拾取装备总开关
	self.switchPickupEquipW = true --自动拾取白色装备开关
	self.switchPickupEquipG = true --自动拾取绿色装备开关
	self.switchPickupEquipB = true --自动拾取蓝色装备开关
	self.switchPickupEquipP = true --自动拾取紫色装备开关

	--
	-- 先注册钩子函数，再初始化选项，这样就得以执行。
	--

	self:initHooks()
	self:initOptions()
end

function SysOptionModel:initOptions()
	self._userOptions = {}
	for _, v in pairs(DefineOptions) do
		self._userOptions[v] = true
		if v == DefineOptions.HIDE_SPEQUIP then
			self._userOptions[v] = false
		end
	end
	self:readLocalOptions()
end

function SysOptionModel:initHooks()
	local function hookAccess(option, handler)
		self:hookOptionChanged(option, function(value)
			--
			-- 复制值到变量
			--
			if option == DefineOptions.AUTO_SALE_MAIN then
				self.switchSaleMain = value
			elseif option == DefineOptions.SALE_EQUIP_WHITE then
				self.switchSaleEquipW = value
			elseif option == DefineOptions.SALE_EQUIP_GREEN then
				self.switchSaleEquipG = value
			elseif option == DefineOptions.SALE_EQUIP_BLUE then
				self.switchSaleEquipB = value
			elseif option == DefineOptions.SALE_EQUIP_PURPLE then
				self.switchSaleEquipP = value

			elseif option == DefineOptions.AUTO_PICK_MAIN then
				self.switchPickupMain = value
			elseif option == DefineOptions.PICK_MONEY then
				self.switchPickupMoney = value
			elseif option == DefineOptions.PICK_PROP then
				self.switchPickupProp = value

			elseif option == DefineOptions.PICK_EQUIP_MAIN then
				self.switchPickupEquipMain = value
			elseif option == DefineOptions.PICK_EQUIP_WHITE then
				self.switchPickupEquipW = value
			elseif option == DefineOptions.PICK_EQUIP_GREEN then
				self.switchPickupEquipG = value
			elseif option == DefineOptions.PICK_EQUIP_BLUE then
				self.switchPickupEquipB = value
			elseif option == DefineOptions.PICK_EQUIP_PURPLE then
				self.switchPickupEquipP = value

			elseif option == DefineOptions.SYS_MUSIC then
				self.switchMusic = value
			elseif option == DefineOptions.SYS_SOUND then
				self.switchSound = value
			elseif option == DefineOptions.SYS_PLAYER then
				self.switchShowPlayer = value
			elseif option == DefineOptions.SYS_EFFECT then
				self.switchShowEffect = value
			elseif option == DefineOptions.SYS_PLAYER_NAME then
				self.switchShowPlayerName = value
			elseif option == DefineOptions.SYS_GOODS_NAME then
				self.switchShowGoodsName = value
			elseif option == DefineOptions.SYS_MESSAGE then
				self.switchPushMessage = value
			elseif option == DefineOptions.SYS_MOUNT then
				self.switchMount = value
			end
			-- 执行钩子
			if handler then
				handler(value)
			end
		end)
	end

	-- 背景音乐选项改动
	hookAccess(DefineOptions.SYS_MUSIC, function(value)
		if value then
			if SoundManager == nil then return end
			SoundManager:stopMusic()
		else
			if GameSceneModel.sceneId == nil or GameSceneModel.sceneId == 0  then return end
			local bgMusic = getConfigObject(GameSceneModel.sceneId,ActivitySceneConf).music
	        SoundManager:playMusic(bgMusic,true)
		end
	end)

	-- 游戏音效选项改动
	hookAccess(DefineOptions.SYS_SOUND, function(value)
		if value then
			SoundManager:stopAllSounds()
		else
		end
	end)

	-- 显示人物选项开启
	hookAccess(DefineOptions.SYS_PLAYER, function(value)
		if GlobalController == nil then return end
		GlobalController.fight:setPlayerVisible(value)
	end)

	hookAccess(DefineOptions.AUTO_SALE_MAIN)
	hookAccess(DefineOptions.SALE_EQUIP_WHITE)
	hookAccess(DefineOptions.SALE_EQUIP_GREEN)
	hookAccess(DefineOptions.SALE_EQUIP_BLUE)
	hookAccess(DefineOptions.SALE_EQUIP_PURPLE)
	hookAccess(DefineOptions.AUTO_PICK_MAIN)
	hookAccess(DefineOptions.PICK_MONEY)
	hookAccess(DefineOptions.PICK_PROP)
	hookAccess(DefineOptions.PICK_EQUIP_MAIN)
	hookAccess(DefineOptions.PICK_EQUIP_WHITE)
	hookAccess(DefineOptions.PICK_EQUIP_GREEN)
	hookAccess(DefineOptions.PICK_EQUIP_BLUE)
	hookAccess(DefineOptions.PICK_EQUIP_PURPLE)
	hookAccess(DefineOptions.SYS_EFFECT)
	hookAccess(DefineOptions.SYS_PLAYER_NAME)
	hookAccess(DefineOptions.SYS_GOODS_NAME)
	hookAccess(DefineOptions.SYS_MESSAGE)
	hookAccess(DefineOptions.SYS_MOUNT)
end

--
-- 注入一个钩子函数，在选项改变的时候调用此函数。
--
function SysOptionModel:hookOptionChanged(option, handler)
	local handlers = self._hookHandlers or {}
	handlers[option] = handler
	self._hookHandlers = handlers
end

--------------------------------------------------------------------------------
-- 保留旧的公开接口
function SysOptionModel:setSoundSwitch(b)
	self:setOptionByDefine(DefineOptions.SYS_SOUND, b)
end

function SysOptionModel:getSoundSwitch()
	return self:getOptionByDefine(DefineOptions.SYS_SOUND)
end

function SysOptionModel:setMusicSwitch(b)
	self:setOptionByDefine(DefineOptions.SYS_MUSIC, b)
	
end

function SysOptionModel:getMusicSwitch()
	return self:getOptionByDefine(DefineOptions.SYS_MUSIC)
end

function SysOptionModel:setShowPlaySwitch(b)
	self:setOptionByDefine(DefineOptions.SYS_PLAYER, b)
end

function SysOptionModel:getShowPlaySwitch()
	return self:getOptionByDefine(DefineOptions.SYS_PLAYER)
end


----------------------------------------------------------------------
-- 新的设置接口。
function SysOptionModel:updateFrom10003(player_info)
	 
	local options2 = player_info.equip_sell_set
	local options1 = player_info.pickup_set

	local setOptionData = function(option, data)
		self:setOptionByDefine(option, checknumber(data) == 1 and true or false)
	end
 
	setOptionData(DefineOptions.AUTO_SALE_MAIN,    options2.isauto)
	setOptionData(DefineOptions.SALE_EQUIP_WHITE,  options2.white)
	setOptionData(DefineOptions.SALE_EQUIP_GREEN,  options2.green)
	setOptionData(DefineOptions.SALE_EQUIP_BLUE,   options2.blue)
	setOptionData(DefineOptions.SALE_EQUIP_PURPLE , options2.purple)
 

	setOptionData(DefineOptions.AUTO_PICK_MAIN,    options1.isauto)

	setOptionData(DefineOptions.PICK_EQUIP_WHITE,  options1.equip_set[1])
	setOptionData(DefineOptions.PICK_EQUIP_GREEN,  options1.equip_set[2])
	setOptionData(DefineOptions.PICK_EQUIP_BLUE,   options1.equip_set[3])
	setOptionData(DefineOptions.PICK_EQUIP_PURPLE, options1.equip_set[4])
	setOptionData(DefineOptions.PICK_EQUIP_ORANGE, options1.equip_set[5])

	setOptionData(DefineOptions.PICK_PROP_WHITE,  options1.prop_set[1])
	setOptionData(DefineOptions.PICK_PROP_GREEN,  options1.prop_set[2])
	setOptionData(DefineOptions.PICK_PROP_BLUE,   options1.prop_set[3])
	setOptionData(DefineOptions.PICK_PROP_PURPLE, options1.prop_set[4])
	setOptionData(DefineOptions.PICK_PROP_ORANGE, options1.prop_set[5])

	for i=1,10 do
		setOptionData(DefineOptions["PICK_SP_"..i], options1.spec_set[i])
	end
 
end

function SysOptionModel:getOptionByDefine(defineFlag)
	return self._userOptions[defineFlag] or false
end

function SysOptionModel:setOptionByDefine(defineFlag, value)
	-- print(defineFlag .. (value and " = true" or " = false"))
	self._userOptions[defineFlag] = value
	-- Execute hook handler
	local handlers = self._hookHandlers or {}
	local handler  = handlers[defineFlag]
	if handler then
		handler(value)
	end
end

--
-- 读取本地系统设置选项
--
function SysOptionModel:readLocalOptions()
	local data = LocalDatasManager:getLocalData(LOCAL_DATA_KEY)
	if data then
		for k, v in pairs(data) do
			if k ~= "__a" then
				self:setOptionByDefine(tonumber(k), v)
			end
		end
	end
end

--
-- 保存本地系统设置选项
--
function SysOptionModel:saveLocalOptions()
	local localDefineFlags = {
		DefineOptions.SYS_MUSIC,
		DefineOptions.SYS_SOUND,
		DefineOptions.SYS_PLAYER,
		DefineOptions.SYS_EFFECT,
		DefineOptions.SYS_PLAYER_NAME,
		DefineOptions.SYS_GOODS_NAME,
		DefineOptions.SYS_MESSAGE,
		DefineOptions.SYS_MOUNT,
		DefineOptions.HIDE_SPEQUIP,
	}

	local data = {}
	for _, v in pairs(localDefineFlags) do
		data[v] = self:getOptionByDefine(v)
	end

	--
	-- 纯数字索引不能转为JSON字符串，必须要加一个属性。s
	--
	data.__a = 1
	LocalDatasManager:saveLocalData(data, LOCAL_DATA_KEY)
end

function SysOptionModel:commitOptions()
	--------------------------------------------------------------
	-- 服务器保存
	local getOptionData = function(option)
		return self:getOptionByDefine(option) and 1 or 0
	end

	local equip_set = {
		getOptionData(DefineOptions.PICK_EQUIP_WHITE),
		getOptionData(DefineOptions.PICK_EQUIP_GREEN),
		getOptionData(DefineOptions.PICK_EQUIP_BLUE),
		getOptionData(DefineOptions.PICK_EQUIP_PURPLE),
		getOptionData(DefineOptions.PICK_EQUIP_ORANGE),
	}

	local prop_set = {
		getOptionData(DefineOptions.PICK_PROP_WHITE),
		getOptionData(DefineOptions.PICK_PROP_GREEN),
		getOptionData(DefineOptions.PICK_PROP_BLUE),
		getOptionData(DefineOptions.PICK_PROP_PURPLE),
		getOptionData(DefineOptions.PICK_PROP_ORANGE),
	}

	local spec_set = {
		getOptionData(DefineOptions.PICK_SP_1),
		getOptionData(DefineOptions.PICK_SP_2),
		getOptionData(DefineOptions.PICK_SP_3),
		getOptionData(DefineOptions.PICK_SP_4),
		getOptionData(DefineOptions.PICK_SP_5),
		getOptionData(DefineOptions.PICK_SP_6),
		getOptionData(DefineOptions.PICK_SP_7),
		getOptionData(DefineOptions.PICK_SP_8),
		getOptionData(DefineOptions.PICK_SP_9),
		getOptionData(DefineOptions.PICK_SP_10),
	}
	local  data = {equip_set = equip_set, prop_set = prop_set, spec_set = spec_set,isauto = getOptionData(DefineOptions.AUTO_PICK_MAIN)}
	GameNet:sendMsgToSocket(22001, {pickup_set = data})

	--------------------------------------------------------------
	-- 本地保存
	self:saveLocalOptions()
end
