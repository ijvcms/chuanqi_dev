--
-- Author: Yi hanneng
-- Date: 2016-01-19 18:06:21
--
require("app.modules.medalUp.MedalUpManager")
require("app.modules.equip.EquipManager")

Equip_tip = {
	EQUI_TIP_MEDAL = "EQUI_TIP_MEDAL",--功勋


}

EquipController = EquipController or class("EquipController", BaseController)

function EquipController:ctor()
	EquipController.instance = self
	self.equipProductGoodsList = {}
	self:initProtocal()
end

function EquipController:getInstance()
	if EquipController.instance == nil then
		EquipController.new()
	end
	return EquipController.instance
end

function EquipController:initProtocal()
	 
	self:registerProtocal(14035,handler(self,self.onHandle14035))
	self:registerProtocal(14036,handler(self,self.onHandle14036))
	self:registerProtocal(14037,handler(self,self.onHandle14037))
	self:registerProtocal(14038,handler(self,self.onHandle14038))
	self:registerProtocal(14045,handler(self,self.onHandle14045))
	self:registerProtocal(14046,handler(self,self.onHandle14046))
	self:registerProtocal(14047,handler(self,self.onHandle14047))

	self:registerProtocal(14049,handler(self,self.onHandle14049))
	self:registerProtocal(14050,handler(self,self.onHandle14050))
	GlobalEventSystem:addEventListener(EquipEvent.EQUIP_TIP,handler(self,self.handlerBaseTip))

end
--提纯
function EquipController:onHandle14035(data)
	print("EquipController:onHandle14035")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.COMPOSE_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end
--分解选中装备

function EquipController:requestDecompose(id)
	GameNet:sendMsgToSocket(14037, {goods_list = {id}})
end

function EquipController:requestBathDecompose(id)
	GameNet:sendMsgToSocket(14038, {quality_list = {id}})
end

function EquipController:onHandle14036(data)
	print("EquipController:onHandle14036")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.DECOMPOSE_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function EquipController:onHandle14037(data)
	print("EquipController:onHandle14037")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.DECOMPOSE_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end
--分解选中品质装备
function EquipController:onHandle14038(data)
	print("EquipController:onHandle14038")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.DECOMPOSE_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end
--强化继承
function EquipController:requestExtends(sId,dId)
	GameNet:sendMsgToSocket(14045, {idA = sId,idB = dId})
end
--铸魂回收
function EquipController:requestSouldBack(id)
	print(id)
	GameNet:sendMsgToSocket(14049, {id  = id})
end
--洗炼继承
function EquipController:requestBaptizeExtends(sId,dId)
	print(sId,dId)
	GameNet:sendMsgToSocket(14050, {idA = sId,idB = dId})
end

function EquipController:onHandle14045(data)
	print("EquipController:onHandle14045")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.EXTENDS_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function EquipController:onHandle14049(data)
	print("EquipController:onHandle14049")

	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.EXTENDS_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function EquipController:onHandle14050(data)
	print("EquipController:onHandle14050")
	dump(data)
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.EXTENDS_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end


function EquipController:requestSoul(id)
	GameNet:sendMsgToSocket(14046, {id = id})
end

function EquipController:onHandle14046(data)
	print("EquipController:onHandle14046")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(EquipEvent.SOUL_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function EquipController:requestEquipBaptizeLock(id,lockId,state)
	GameNet:sendMsgToSocket(14047, {id = id,baptize_id = lockId,state = state})
end
 
function EquipController:onHandle14047(data)
	print("EquipController:onHandle14047")
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
		GlobalEventSystem:dispatchEvent(EquipEvent.BAPTIZE_LOCK_SUCCESS)
	end
	
end

function EquipController:handlerBaseTip(data)
	if data.data == Equip_tip.EQUI_TIP_MEDAL then
		self:medal()
	end
end
--功勋
function EquipController:medal()

	local top = false
	local meadlupId
	local equipList = RoleManager:getInstance().roleInfo.equip
	for i=1,#equipList do
		local subTypeName,subType = configHelper:getEquipTypeByEquipId(equipList[i].goods_id)
		if subType == 5 then
			meadlupId = equipList[i].goods_id
			break
		end
	end

	local roleInfo = RoleManager:getInstance().roleInfo
	local wealthInfo = RoleManager:getInstance().wealth
 	local medalList = MedalUpManager:getInstance():getMedalListInfo()
	local currentConfig
	for i=1,#medalList do
		if meadlupId == medalList[i].goods_id then
			currentConfig = medalList[i]
			break
		end
	end

	if currentConfig == nil then
		return 
	end

	local currentEqui = configHelper:getEquipValidAttrByEquipId(meadlupId)
	local nextEquie = configHelper:getEquipValidAttrByEquipId(currentConfig.next_id)
 
  if currentConfig.next_id  == 0 then
    currentConfig.next_id = meadlupId
    nextEquie = currentEqui
    top = true
  end

  if roleInfo.lv >=  currentConfig.limit_lv and wealthInfo.feats >=  currentConfig.need_feats then
   		if not top then
   			BtnTipManager:setKeyValue(BtnTipsType.BTN_EQUIP, 1)
   			BtnTipManager:setKeyValue(BtnTipsType.BTN_MEDAL, 1)
   		else
   			BtnTipManager:setKeyValue(BtnTipsType.BTN_EQUIP, 0)
   			BtnTipManager:setKeyValue(BtnTipsType.BTN_MEDAL, 0)
   		end
  else
  		BtnTipManager:setKeyValue(BtnTipsType.BTN_EQUIP, 0)
   		BtnTipManager:setKeyValue(BtnTipsType.BTN_MEDAL, 0)
  end


end
--装备打造
function EquipController:product(goodsId)
	 local list = EquipManager:getInstance():getProductGoodsList()[goodsId]

	 local temList = {}
	 local find = false
	 if list ~= nil then
	 	for i=1,#list do
	 		find = true
	 		for j=1,#list[i].stuff do
	 			if list[i].stuff[j][1] == "goods" then
	 				if list[i].stuff[j][3] > BagManager:getInstance().bagInfo:findItemCountByItemId(goodsId) then
	 					find = false
	 					break
	 				end
	 			end
	 		end
	 		--满足条件
	 		if find then
	 			--BtnTipManager:setKeyValue(BtnTipsType.BTN_EQUIP, 1)
	 			--BtnTipManager:setKeyValue(BtnTipsType.BTN_EQUIP, 1)
	 			--BtnTipManager:setKeyValue(list[i].product[1][2], 1)
	 		end
	 	end
	 end
end