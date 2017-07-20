--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-09-09 
-- 背包控制器
require("app.modules.bag.BagInfo")
require("app.modules.bag.BagManager")
import("app.utils.EquipUtil")
BagController = BagController or class("BagController",BaseController)

local EquipSounds = {
	[1]  = SoundType.EQUIP_WEPONE,    -- "武器"
	[2]  = SoundType.EQUIP_CLOTHES,   -- "衣服"
	[3]  = SoundType.EQUIP_HELMET,    -- "头盔"
	[4]  = SoundType.EQUIP_NECKLACE,  -- "项链"
	[5]  = nil,                       -- "勋章"
	[6]  = SoundType.EQUIP_BRACELET,  -- "手镯"
	[7]  = SoundType.EQUIP_RING,      -- "戒指"
	[8]  = SoundType.EQUIP_BELT,      -- "腰带"
	[9]  = nil,                       -- "裤子"
	[10] = SoundType.EQUIP_SHOE,      -- "鞋子"
	[11] = nil,
	[12] = nil,
	[13] = nil,                       -- "翅膀"
	[14] = nil,                       -- "宠物"
	[15] = nil,                       -- "坐骑"
}

function BagController:ctor()	
	BagController.Instance = self
	self:initProtocal()
end

function BagController:getInstance()
	if BagController.Instance==nil then
		BagController.new()
	end
	
	return BagController.Instance
end

function BagController:initProtocal( )
	--取得道具信息列表
	self:registerProtocal(14001,handler(self,self.onHandle14001))
	--道具信息变更广播
	self:registerProtocal(14002,handler(self,self.onHandle14002))
	--添加道具结果
	self:registerProtocal(14003,handler(self,self.onHandle14003))
	--根据装备品质批量出售装备
	self:registerProtocal(14004,handler(self,self.onHandle14004))
	--根据唯一id批量出售道具
	self:registerProtocal(14005,handler(self,self.onHandle14005))
	--出售指定数量的道具
	self:registerProtocal(14006,handler(self,self.onHandle14006))
	--使用道具结果
	self:registerProtocal(14007,handler(self,self.onHandle14007))
	--扩展背包
	self:registerProtocal(14008,handler(self,self.onHandle14008))
	--礼包奖励
	self:registerProtocal(14009,handler(self,self.onHandle14009))
	--获取血包剩余血量
	self:registerProtocal(14010,handler(self,self.onHandle14010))
	--取得装备信息列表
	self:registerProtocal(14020,handler(self,self.onHandle14020))
	--装备信息变更广播
	self:registerProtocal(14021,handler(self,self.onHandle14021))
	--装备更换
	self:registerProtocal(14022,handler(self,self.onHandle14022))
	--装备拆卸
	self:registerProtocal(14023,handler(self,self.onHandle14023))
	--装备强化结果
	self:registerProtocal(14024,handler(self,self.onHandle14024))

	--装备熔炼
	self:registerProtocal(14025,handler(self,self.onHandle14025))
	--装备洗炼
	self:registerProtocal(14026,handler(self,self.onHandle14026))
	--装备洗炼属性保存
	self:registerProtocal(14027,handler(self,self.onHandle14027))

	--请求锻造的装备信息
	self:registerProtocal(14028, handler(self,self.onHandle14028))
	--请求锻造装备
	self:registerProtocal(14029, handler(self,self.onHandle14029))
	--请求刷新锻造信息
	self:registerProtocal(14030, handler(self,self.onHandle14030))

	--道具合成
	self:registerProtocal(14031, handler(self,self.onHandle14031))

	--神器吞噬
	self:registerProtocal(14032, handler(self,self.onHandle14032))

	--神器传承
	self:registerProtocal(14033, handler(self,self.onHandle14033))

	self:registerProtocal(14051, handler(self,self.onHandle14051))
	--翅膀过期提示
	self:registerProtocal(14052, handler(self,self.onHandle14052))
end

function BagController:onHandle14052(data)
	print("BagController:onHandle14052")
	if data.result == 0 then
		GlobalWinManger:openWin(WinName.UPGRADEWINGTIPSVIEW)
	end
end

function BagController:onHandle14051(data)
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end

	local bagManager = BagManager:getInstance()
    local item = bagManager.bagInfo:findCangBaoTu()
    if item then
        local putonTips = import("app.modules.bag.view.putOnTips").new()
		putonTips:setData(item)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,putonTips)
	end
end

function BagController:onHandle14001(data)
	print("on14001")
	--dump(data.goods_list)
	local bagManager = BagManager:getInstance()
	bagManager.bagInfo:initPropData(data.goods_list)

	self:updateAutoDrug()
end


function BagController:updateAutoDrug()
	local localData = RoleManager:getInstance().roleInfo.autoDrugOption 
	local needBtnTips = false
	for i=1,4 do
		local needTips = false
		local drugType = i
		local list = configHelper:getAutoDrugIdList(drugType)
		if localData["drugType"..i] == nil or localData["drugType"..i] == 0 then
			for j=1,#list do
				local count = BagManager:getInstance():findItemCountByItemId(list[j])
				--print(list[j],count)
				if count > 0 then
					needTips = true
					break
				end
			end

			if needTips then
				--print(BtnTipsType["BIN_AUTO_DRINK"..i],"HH")
				BtnTipManager:setKeyValue(BtnTipsType["BIN_AUTO_DRINK"..i], 1)
				needBtnTips = true
			else
				BtnTipManager:setKeyValue(BtnTipsType["BIN_AUTO_DRINK"..i], 0)
			end
		else
			needTips = false
			if BagManager:getInstance():findItemCountByItemId(tonumber(localData["drugType"..i]))>0 then
				BtnTipManager:setKeyValue(BtnTipsType["BIN_AUTO_DRINK"..i], 0)
			else
				for j=1,#list do
					local count = BagManager:getInstance():findItemCountByItemId(list[j])
					--print(list[j],count)
					if count > 0 then
						needTips = true
						break
					end
				end
				if needTips then
					print(BtnTipsType["BIN_AUTO_DRINK"..i],"HH@")
					BtnTipManager:setKeyValue(BtnTipsType["BIN_AUTO_DRINK"..i], 1)
					needBtnTips = true
				else
					BtnTipManager:setKeyValue(BtnTipsType["BIN_AUTO_DRINK"..i], 0)
				end
			end
		end
	end

	if needBtnTips then
		BtnTipManager:setKeyValue(BtnTipsType.BIN_AUTO_DRINK, 1)
	else
		BtnTipManager:setKeyValue(BtnTipsType.BIN_AUTO_DRINK, 0)
	end
	-- print(BtnTipManager:getKeyValue(BtnTipsType.BIN_AUTO_DRINK1))
	-- print(BtnTipManager:getKeyValue(BtnTipsType.BIN_AUTO_DRINK2))
	-- print(BtnTipManager:getKeyValue(BtnTipsType.BIN_AUTO_DRINK3))
	-- print(BtnTipManager:getKeyValue(BtnTipsType.BIN_AUTO_DRINK4))
end

function BagController:onHandle14002(data)
	print("on14002")
	local bagManager = BagManager:getInstance()
	bagManager.bagInfo:changeItems(data.goods_list)
	GlobalEventSystem:dispatchEvent(BagEvent.PROP_CHANGE)
end

function BagController:onHandle14003(data)
	print("on14003")
end

function BagController:onHandle14004(data)
	print("on14004")
	if data.result == ERR_COMMON_SUCCESS then
		local bagManager = BagManager:getInstance()
		bagManager.bagInfo:batchDeleteItem(data.goods_list)
		GlobalEventSystem:dispatchEvent(BagEvent.EQUIP_CHANGE)
		GlobalEventSystem:dispatchEvent(BagEvent.PROP_CHANGE)
		if data.get_coin > 0 then
			--GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,string.format("获得铜钱: %d",data.get_coin)))
		end
	end
end

function BagController:onHandle14005(data)
	print("on14005")
	--dump(data)
	if data.result == ERR_COMMON_SUCCESS then
		local bagManager = BagManager:getInstance()
		bagManager.bagInfo:batchDeleteItem(data.goods_list)
		GlobalEventSystem:dispatchEvent(BagEvent.EQUIP_CHANGE)
		GlobalEventSystem:dispatchEvent(BagEvent.PROP_CHANGE)
		GlobalEventSystem:dispatchEvent(BagEvent.CHANGE_EQUIP_TO_BAG)
		if data.get_coin> 0 then
			--GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,string.format("获得铜钱: %d",data.get_coin)))
		end
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function BagController:onHandle14006(data)
	print("on14006")
	if data.result == ERR_COMMON_SUCCESS then
		if data.get_coin> 0 then
			--GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,string.format("获得铜钱: %d",data.get_coin)))
		end
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:requestUseGoods(data,useNum)

	if data ~= nil then
		if data.goods_id then
			
			local buff_id = configHelper:getGoodsBuffIdByGoodsId(data.goods_id)
			local goodsName = configHelper:getGoodNameByGoodId(data.goods_id)
			
			if buff_id ~= nil and buff_id > 0 and RoleManager:getInstance():checkBuff(buff_id) then

				local enterFun = function()
					data.num = useNum or 1
					GameNet:sendMsgToSocket(14007, data)
				end
			
				local tipTxt  = "当前已有["..goodsName.."]效果,是否替换？"
				GlobalMessage:alert({
	                enterTxt = "使用",
	                backTxt= "返回",
	                tipTxt = tipTxt,
	          		enterFun = handler(self, enterFun),
	                tipShowMid = true,
            	})

            	return
			end
		end
		
		data.num = useNum or 1
		GameNet:sendMsgToSocket(14007, data)
		
	end

end

function BagController:onHandle14007(data)
	print("on14007")
	if data.result == ERR_GOODS_CANNOT_USE then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_CANNOT_USE,"使用道具失败:道具不能使用"))
	elseif data.result == ERR_GOODS_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_NOT_ENOUGH,"使用道具失败:道具不足"))
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14008(data)
	if data.result == ERR_COMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"背包扩展成功!"))
		GlobalEventSystem:dispatchEvent(BagEvent.EXPAND_BAG_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14009(data)
	print("on14009")
	local node = require("app.modules.bag.view.GiftBoxView").new()
	node:setDatas(data.goods_list)
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
	-- GlobalEventSystem:dispatchEvent(BagEvent.GITFBOX_OPEN,data.goods_list)
end

function BagController:onHandle14010(data)
	print("on14010")

    GlobalEventSystem:dispatchEvent(BagEvent.GET_BLOOD_BAG,data.value)
end

function BagController:onHandle14020(data)
	print("onHandle14020")
	local equips_list = data.equips_list
	--初始化装备数据,加上前端计算的装备评分
	for i=1,#equips_list do
		equips_list[i] = EquipUtil.formatEquipItem(equips_list[i])
	end
	local roleManager = RoleManager:getInstance()
	if not roleManager.roleInfo  then
		local roleInfo = RoleInfoVO.new()	--主角相关信息
		roleManager.roleInfo = roleInfo
	end
	--更新主角装备列表
	roleManager.roleInfo:updateFrom14020(equips_list)
	--派发主角装备列表更新事件
	--GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_MAINROLE_EQUIPLIST)

	local equipList = {}
	for i=1,#equips_list do
		if equips_list[i].location == 0 then
			table.insert(equipList,equips_list[i])
		end
	end
	local bagManager = BagManager:getInstance()
	bagManager.bagInfo:initEquipData(equipList)
end

function BagController:onHandle14021(data)
	print("onHandle14021")
	local bagManager = BagManager:getInstance()
	local equips = {}
	for _, equips_info in ipairs(data.equips_list) do
		local equip =  EquipUtil.formatEquipItem(equips_info)--计算了战斗力
		--更新主角装备列表
	    --RoleManager:getInstance().roleInfo:updateFrom14021(equip)
	    local typeName, typeEnum = configHelper:getEquipTypeByEquipId(equip.goods_id)
	    if typeEnum then
	    	local soundType = EquipSounds[typeEnum]
		    if soundType then
			    SoundManager:playSound(soundType)
		    end
	    end
		table.insert(equips, equip)
		
		if equips_info.goods_id%10 == 1 and equips_info.grid == 15 and equips_info.stren_lv == 0 and equips_info.soul == 0  and equips_info.luck == 0 then
			 GlobalWinManger:openWin(WinName.WEARRIDETIPSVIEW)
		end
	end
	bagManager.bagInfo:changeItems(equips)
	GlobalEventSystem:dispatchEvent(BagEvent.EQUIP_CHANGE, equips)

	--派发主角装备列表更新事件
	--GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_MAINROLE_EQUIPLIST)
	-- https://tower.im/projects/d3a2760cad124566b4057bd59b3f9a45/todos/7cb411de74b8486b9767e122a93f2752/
	-- 装备变更【脱下/穿上】时播放相应的音效
	
end

function BagController:onHandle14022(data)
	print("onHandle14022")
	if data.result == ERR_GOODS_NOT_EXIST then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_NOT_EXIST,"装备穿戴失败:装备不存在"))
	elseif data.result == ERR_PLAYER_LV_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_PLAYER_LV_NOT_ENOUGH,"装备穿戴失败:等级不足"))
	elseif data.result == ERR_WEAR_GRID_ERROR then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_WEAR_GRID_ERROR,"装备穿戴失败:穿戴位置不正确"))
	elseif data.result == ERR_PLAYER_CAREER_LIMIT then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_PLAYER_CAREER_LIMIT,"装备穿戴失败:职业不符"))
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14023(data)
	print("onHandle14023")
	if data.result == ERR_GOODS_NOT_EXIST then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_NOT_EXIST,"装备卸装失败:装备不存在"))
	elseif data.result == ERR_PLAYER_BAG_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_PLAYER_BAG_NOT_ENOUGH,"装备卸装失败:背包已满"))
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14024(data)
	print("onHandle14024")
	if data.result == ERR_COMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"装备强化成功!"))
		GlobalEventSystem:dispatchEvent(BagEvent.STRENG_SUCCESS)
	elseif data.result == ERR_GOODS_NOT_EXIST then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_NOT_EXIST,"装备强化失败:装备不存在"))
	elseif data.result == ERR_PLAYER_COIN_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_PLAYER_COIN_NOT_ENOUGH,"装备强化失败:金币不足"))
	elseif data.result == ERR_GOODS_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_NOT_ENOUGH,"装备强化失败:道具不足"))
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
		GlobalEventSystem:dispatchEvent(BagEvent.STRENG_FAIL)
	end
end

function BagController:onHandle14025(data)
	print("onHandle14025")
	if data.result == ERR_COMMON_SUCCESS then

	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14026(data)
	print("onHandle14026")
	if data.result == ERR_PLAYER_COIN_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_PLAYER_COIN_NOT_ENOUGH,"装备洗炼失败:金币不足"))
		return
	elseif data.result == ERR_GOODS_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_NOT_ENOUGH,"装备洗炼失败:道具不足"))
		return
	elseif data.result == ERR_EQUIPS_CANNOT_BAP then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_EQUIPS_CANNOT_BAP,"装备洗炼失败:装备不能洗炼"))
		return
	elseif data.result == ERR_GOODS_NOT_EXIST then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_NOT_EXIST,"装备洗炼失败:装备不存在"))
		return
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	elseif data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.BAPTIZE_SUCCESS,data.attr_list)
	end
	
end

function BagController:onHandle14027(data)
	print("onHandle14027")
	if data.result == ERR_COMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"装备洗炼属性保存成功!"))
	elseif data.result == ERR_COMMON_FAIL then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_FAIL,"装备洗炼保存失败"))
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14028(data)
	print("onHandle14028")
	GlobalEventSystem:dispatchEvent(BagEvent.FORGE_REP,data)
end

function BagController:onHandle14029(data)
	print("onHandle14029")
	if data.result == ERR_COMMON_SUCCESS then
		--不需要提示
		-- GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"装备锻造成功!"))
	elseif data.result == ERR_PLAYER_SMELT_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_PLAYER_SMELT_NOT_ENOUGH,"装备锻造失败:熔炼值不足"))
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14030(data)
	print("onHandle14030")
	if data.result == ERR_COMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"锻造刷新成功!"))
	elseif data.result == ERR_FORGE_UPDATE_TIMES_NOT_ENOUGH then
		-- GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_FORGE_UPDATE_TIMES_NOT_ENOUGH,"锻造刷新失败:刷新次数不足"))
		GlobalEventSystem:dispatchEvent(BagEvent.NEED_JADE_REFRESH_FORGE)
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14031(data)
	print("onHandle14031")
	if data.result == ERR_COMMON_SUCCESS then
		-- 不需要提示
		-- GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"合成道具成功!"))
		GlobalEventSystem:dispatchEvent(BagEvent.FUSION_SUCCESS)
		GlobalEventSystem:dispatchEvent(HolidayEvent.HOLIDAY_COMPOSE_SUCCESS)
		
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14032(data)
	print("onHandle14032")
	if data.result == ERR_COMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"神器吞噬成功!"))
		GlobalEventSystem:dispatchEvent(BagEvent.ARTSWALLOW_SUCCESS)
	elseif data.result == ERR_PLAYER_COIN_NOT_ENOUGH then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_PLAYER_COIN_NOT_ENOUGH,"神器吞噬失败:金币不足"))
	elseif data.result == ERR_NOT_ART_CANNOT_DEVOUR then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_NOT_ART_CANNOT_DEVOUR,"非神器不能吞噬"))
	elseif data.result == ERR_GOODS_NOT_ART then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_GOODS_NOT_ART,"主物品不是神器"))
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function BagController:onHandle14033(data)
	print("onHandle14033")
	if data.result == ERR_COMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"神器传承成功!"))
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

