--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-22 17:35:52
-- 角色控制器
require("app.modules.role.vo.RoleBaseAttrVO")
require("app.modules.role.vo.RoleInfoVO")
require("app.modules.role.vo.RoleWealthVO")
require("app.modules.role.vo.RoleGuildInfoVO")
require("app.modules.role.vo.RoleCorpsInfoVO")
require("app.modules.role.vo.RoleUseSkillVO")
require("app.modules.role.RoleManager")

RoleController = RoleController or class("RoleController",BaseController)

function RoleController:ctor()	
	RoleController.Instance = self
	self.zfValue = 0
	self:initProtocal()
end

function RoleController:getInstance()
	if RoleController.Instance==nil then
		RoleController.new()
	end
	return RoleController.Instance
end

function RoleController:initProtocal( )
	-- self:registerProtocal(20000,handler(self,self.onHandle20000))
	-- self:registerProtocal(20001,handler(self,self.onHandle20001))
	-- self:registerProtocal(20002,handler(self,self.onHandle20002))
	-- self:registerProtocal(20003,handler(self,self.onHandle20003))
	-- self:registerProtocal(10000,handler(self,self.onHandle10000))
	-- 主角装备列表
	--self:registerProtocal(14020,handler(self,self.onHandle14020))
	
	self:registerProtocal(10015,handler(self,self.onHandle10015))

	self:registerProtocal(14053,handler(self,self.onHandle14053))
	self:registerProtocal(14054,handler(self,self.onHandle14054))
	self:registerProtocal(14055,handler(self,self.onHandle14055))

	GlobalEventSystem:addEventListener(RoleEvent.RIDE_HONG_TIP,handler(self,self.handlerBaseTip))
end

function RoleController:requestMarkUpgrade(type)
	if type == nil or type == 0 then
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请输入投保次数！")
		return
	end
	GameNet:sendMsgToSocket(10015, {type = type})
end

function RoleController:requestRideUpgrade(id)
	if id == nil or id == 0 then
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请输入投保次数！")
		return
	end
	GameNet:sendMsgToSocket(14053, {id = id})
end

function RoleController:requestRideEquipUpgrade(mark_type,type)
	if mark_type == nil or mark_type == 0 then
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请输入投保次数！")
		return
	end
	GameNet:sendMsgToSocket(14054, {mark_type = mark_type, type = type})
end

function RoleController:requestRideEquipZF(mark_type)
	if mark_type == nil or mark_type == 0 then
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请输入投保次数！")
		return
	end
	GameNet:sendMsgToSocket(14055, {mark_type = mark_type})
end

function RoleController:onHandle10015(data)

	print("RoleController:onHandle10015")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"印记升级成功")
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function RoleController:onHandle14053(data)

	print("RoleController:onHandle14053")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"坐骑升阶成功")
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function RoleController:onHandle14054(data)

	print("RoleController:onHandle14054")
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
	local config = configHelper:getMarkByTypeCareerLv(data.mark_type, roleInfo.career, roleInfo.mark[data.mark_type])

	if data.result == 0 then
		local lastconfig = configHelper:getMarkByTypeCareerLv(data.mark_type, roleInfo.career, roleInfo.mark[data.mark_type] - 1)
		self.zfValue = data.bless
		GlobalEventSystem:dispatchEvent(BagEvent.STRENG_SUCCESS)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"恭喜您，成功将"..lastconfig.name.."强化至+"..config.lv)
	else
		GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_EQUIP_INFO)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"恭喜您获得"..(data.bless-self.zfValue).."点祝福值")
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"强化失败，"..config.name.."的强化等级降到了"..config.lv.."级")
		self.zfValue = data.bless
	end

	GlobalEventSystem:dispatchEvent(RoleEvent.GET_RIDE_ZFINFO,{mark_type = data.mark_type,bless = self.zfValue})

end

function RoleController:onHandle14055(data)

	print("RoleController:onHandle14055")
	self.zfValue = data.bless
	GlobalEventSystem:dispatchEvent(RoleEvent.GET_RIDE_ZFINFO,data)
	
end


--功勋
function RoleController:handlerBaseTip()

	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    self.career = career or roleInfo.career

    if roleInfo.rideInfo == nil then
    	return
    end

    local nowNum = 0
    local needNum = 0
    local top = 0
    --强化
    for i=1,4 do
		
		local config = configHelper:getMarkByTypeCareerLv(i+5, self.career, roleInfo.mark[i+5])
 
		if config ~= nil and #config.upgrade_stuff > 0 then
 			 
			needNum = config.upgrade_stuff[1][2]
		    nowNum = BagManager:getInstance():findItemCountByItemId(config.upgrade_stuff[1][1])
 
		    if nowNum >= needNum then
		    	top = 1
	   			BtnTipManager:setKeyValue(BtnTipsType["BTN_ROLE_RIDE_STRENG"..i], 1)
	   			BtnTipManager:setKeyValue(BtnTipsType.BTN_ROLE, BtnTipManager:getKeyValue(BtnTipsType.BTN_ROLE) + 1)
	   		else

	   			if BtnTipManager:getKeyValue(BtnTipsType["BTN_ROLE_RIDE_STRENG"..i]) > 0 then
	   				BtnTipManager:setKeyValue(BtnTipsType.BTN_ROLE, BtnTipManager:getKeyValue(BtnTipsType.BTN_ROLE) - 1)
	   			end
	   			BtnTipManager:setKeyValue(BtnTipsType["BTN_ROLE_RIDE_STRENG"..i], 0)

		    end

	    end

	end

	--升阶
 	local nextConfig = configHelper:getRideConfigById(roleInfo.rideInfo.goods_id)
 	if nextConfig ~= nil  and #nextConfig.stuff > 0 then
 
	 	needNum = nextConfig.stuff[1][2]
	    nowNum = BagManager:getInstance():findItemCountByItemId(nextConfig.stuff[1][1])

	    if nowNum >= needNum then
	    	top = 1
	    	BtnTipManager:setKeyValue(BtnTipsType.BTN_ROLE, BtnTipManager:getKeyValue(BtnTipsType.BTN_ROLE) + 1)
		   	BtnTipManager:setKeyValue(BtnTipsType.BTN_ROLE_RIDE_UP, 1)
		else
			if BtnTipManager:getKeyValue(BtnTipsType.BTN_ROLE_RIDE_UP) > 0 then
	   			BtnTipManager:setKeyValue(BtnTipsType.BTN_ROLE, BtnTipManager:getKeyValue(BtnTipsType.BTN_ROLE) - 1)
	   		end
		   	BtnTipManager:setKeyValue(BtnTipsType.BTN_ROLE_RIDE_UP, 0)
		end
	end

	if top == 1 then
		BtnTipManager:setKeyValue(BtnTipsType.BTN_ROLE_RIDE, 1)
	else
		BtnTipManager:setKeyValue(BtnTipsType.BTN_ROLE_RIDE, 0)
	end

end

--登录平台基本信息验证
-- function RoleController:onHandle20000(data)	
-- 	if data.success == 1 then 		
-- 		GlobalModel.playerId = data.player_id
-- 		GlobalModel.serverVer = data.serverVer
-- 		self:dispatchEvent(LoginEvent.LOGIN_PLATEFORM_OK, data)
-- 		GlobalMessage:show("登录平台成功",1,cc.p(0,0))	
-- 		self:saveLocalUserInf()
-- 	else
-- 		self:saveLocalUserInf()
-- 		GlobalMessage:show("平台验证失败",1,cc.p(0,0))	
-- 		--self:dispatchEvent(LoginEvent.SHOW_PLAFORM)
-- 		self:dispatchEvent(LoginEvent.LOGIN_GOTO_REGITER)
-- 	end
-- end

-- 主角装备列表
-- function RoleController:onHandle14020(data)
-- 	local equips_list = data.equips_list
-- 	local roleManager = RoleManager:getInstance()

-- 	if not roleManager.roleInfo  then
-- 		local roleInfo = RoleInfoVO.new()	--主角相关信息
-- 		roleManager.roleInfo = roleInfo
-- 	end
-- 	--更新主角装备列表
-- 	roleManager.roleInfo:updateFrom14020(equips_list)
-- 	--派发主角装备列表更新事件
-- 	GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_MAINROLE_EQUIPLIST)
-- end
