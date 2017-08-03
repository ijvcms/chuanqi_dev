--
-- Author: 21102585@qq.com
-- Date: 2014-11-04 17:56:59
-- 登陆控制器
-- 登陆流程
-- 1.连接Socket GlobalController.login:connectSocket()
-- 2.登陆 GlobalController.login:onLogin() 10000协议获取玩家角色列表
-- 3.登陆帐号 GlobalController.login:sendMsg10002() 10002 登陆角色
-- 3.获取帐号信息 10003 登陆角色帐号信息
require("app.modules.vip.VipManager")
local LocalDatasManager = require("common.manager.LocalDatasManager")
LoginController = LoginController or class("LoginController",BaseController)
local NetworkMonitor = require("app.gameui.statusBar.NetworkMonitor")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function LoginController:ctor()
	self.downResOK = false
	self:init()
end

--保存本地用户数据
function LoginController:saveLocalUserInf()
	for i=#GlobalModel.loginServerList,1,-1 do
		if GlobalModel.curServerId == GlobalModel.loginServerList[i] then
			table.remove(GlobalModel.loginServerList,i)
		end
	end
	table.insert(GlobalModel.loginServerList,1,GlobalModel.curServerId)
	for i=10,#GlobalModel.loginServerList do
		table.remove(GlobalModel.loginServerList,i)
	end
	self.userInf = {open_id = GlobalModel.open_id,platform = GlobalModel.platform,curServerId = GlobalModel.curServerId,loginServerList = GlobalModel.loginServerList,player_id = GlobalModel.player_id}
	local userInfStr = json.encode(self.userInf)
	cc.UserDefault:getInstance():setStringForKey("localUserInf", userInfStr)
	cc.UserDefault:getInstance():flush()
end
--获取本地用户数据
function LoginController:getLocalUserInfo()
	local localData = cc.UserDefault:getInstance():getStringForKey("localUserInf")
	if localData ~= "" then
 		self.userInf = json.decode(localData)
 		-- GlobalModel.platform = self.userInf.platform or 0
 		GlobalModel.open_id = self.userInf.open_id or ""
 		GlobalModel.curServerId = self.userInf.curServerId or 0
 		GlobalModel.loginServerList = self.userInf.loginServerList or {}
 		GlobalModel.player_id = self.userInf.player_id or "" --读取玩家的角色ID
 	end	
end	
--清理本地用户数据
function LoginController:clearLocalUserInfo()
	local data = {
           selected =  false
    }
	LocalDatasManager:saveLocalData(data, "ZF_TIP")
	self.userInf = {open_id = "",platform = 0,curServerId = 0}
	local userInfStr = json.encode(self.userInf)
	cc.UserDefault:getInstance():setStringForKey("localUserInf", userInfStr)
	cc.UserDefault:getInstance():flush()
end	

function LoginController:init()
	self.heartTime = 0
	self.isInit = false
	self.userInf = {plaformid = self.plaformID,gameAccount = self.gameAccount}
	self.isConnect = false
	self:getLocalUserInfo()
	self.angPaoIdList = {}
	self.angPaoFunIdList = {[1]=63,[2]=64,[3]=65,[4]=66,[5]=67}
	self.angPaoTimerList = {}
	self:registerProtocal(10000,handler(self,self.onHandle10000))
	self:registerProtocal(10001,handler(self,self.onHandle10001))
	self:registerProtocal(10002,handler(self,self.onHandle10002))
	self:registerProtocal(10003,handler(self,self.onHandle10003))
	self:registerProtocal(10004,handler(self,self.onHandle10004))
	self:registerProtocal(10005,handler(self,self.onHandle10005))
	self:registerProtocal(10006,handler(self,self.onHandle10006))
	self:registerProtocal(10007,handler(self,self.onHandle10007))
	self:registerProtocal(10008,handler(self,self.onHandle10008))
	self:registerProtocal(10009,handler(self,self.onHandle10009))
	self:registerProtocal(10010,handler(self,self.onHandle10010))
	self:registerProtocal(10011,handler(self,self.onHandle10011))
	self:registerProtocal(10018,handler(self,self.onHandle10018))
	self:registerProtocal(28000,handler(self,self.onHandle28000))
	self:registerProtocal(22002,handler(self,self.onHandle22002))
	self:registerProtocal(23012,handler(self,self.onHandle23012))

	self:registerProtocal(28002,handler(self,self.onHandle28002))

	self:registerProtocal(28003,handler(self,self.onHandle28003))
	--下载40级资源通知
	self:registerProtocal(32034,handler(self,self.onHandle32034))

	self:registerProtocal(32037,handler(self,self.onHandle32037))
	self:registerProtocal(32038,handler(self,self.onHandle32038))
	--开服活动红包推送
	self:registerProtocal(34000,handler(self,self.onHandle34000))
	self:registerProtocal(34001,handler(self,self.onHandle34001))
	--下线控制
    self:registerProtocal(9997,handler(self,self.onHandle9997))
	self.heartStop = false
	self:clearAngPaoTimer()
	local reqHeartFun =  function()
		if socket.gettime() - self.heartTime > 40 and self.heartStop == false then
			GameNet:disconnect()
		else
			self.checkNetworkTime = socket.gettime()
			GameNet:sendMsgToSocket(10006, {client_time = os.time()})
		end
	end
	
	local onSocketConnected = function(data)
		if self.reqHeartTimeId == nil then
			self.heartTime = socket.gettime()
			self.reqHeartTimeId =  GlobalTimer.scheduleGlobal(reqHeartFun,7)
		end
		self.isConnect = true
		GlobalModel:setIsConnect(true)
		--socket连接后,如果在游戏场景则直接重新登陆，否则重新跑完整登陆流程
		if SCENE_MAIN == GlobalController.curScene then
			self:sendMsg10002()
			--GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
		elseif SCENE_LOGIN == GlobalController.curScene then
			self:onLogin()
		end
		print("Socket   Connected  ------------------------------------------------------------------------------")
	end

	local onSocketDisConnect = function(data)
		if self.reqHeartTimeId then
			GlobalTimer.unscheduleGlobal(self.reqHeartTimeId)
			self.reqHeartTimeId = nil
		end
		self.isConnect = false
		GlobalModel:setIsConnect(false)
    	print("Socket   Closeed  --------------------------------------------------------------------------------")
	end

	local onSocketConnectChanged = function(data)
	
	    if data.data ~= NetworkMonitor.TypeNone then
	   	    if self.reqHeartTimeId then
	   	        GameNet:disconnect()
	   	    end
	    else
	    	GlobalModel.showDisconnectTip = false
	    	GameNet:disconnect()
	    	local param = {enterTxt = "返 回",tipTxt = "无可用网络",enterFun = handler(self, self.quit),hideBackBtn = true,alertName = "netErrorTips"}
			GlobalAlert:pop(param)
	    end
    end
    GlobalEventSystem:addEventListener(NetworkMonitorEvent.EVENT_TYPE_CHANGED,onSocketConnectChanged)
	GlobalEventSystem:addEventListener(LoginEvent.SOCKET_CONNECTED,onSocketConnected)
	GlobalEventSystem:addEventListener(LoginEvent.SOCKET_DISCONNECTED,onSocketDisConnect)
	GlobalEventSystem:addEventListener(LoginEvent.START_CHECK_HEART,handler(self, self.onStartCheckHeart))
	GlobalEventSystem:addEventListener(LoginEvent.STOP_CHECK_HEART,handler(self, self.onStopCheckHeart))
	GlobalEventSystem:addEventListener(LoginEvent.SOCKET_CONNECT_FAILURE,handler(self, self.onConnectFailure))
end

--登陆失败
function LoginController:onConnectFailure()
	if GlobalController.curScene == SCENE_LOGIN then
		GlobalAlert:pop({tipTxt = "连接游戏区服失败，请稍后再试！",hideBackBtn = true,alertName = "netErrorTips"})
        GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_ENTER)
	end
    
end


function LoginController:onStartCheckHeart()
	self.heartStop = false
	self.heartTime = socket.gettime()
end

function LoginController:onStopCheckHeart()
	self.heartStop = true
end


function LoginController:connectSocket()
	if GlobalModel:getIsConnect() then
		GlobalModel.showDisconnectTip = false
        GameNet:disconnect()
    end
    if GlobalModel.selServerInfo ~= nil then
		print("LoginController:connectSocket() = ",GlobalModel.selServerInfo.ip,GlobalModel.selServerInfo.service_port)
		GameNet:connect(GlobalModel.selServerInfo.ip, GlobalModel.selServerInfo.service_port, false, "wewars")
	end
end

--点击登录
function LoginController:onLogin()
    if GlobalModel.open_id ~= "" then
        GameNet:sendMsgToSocket(10000, {open_id=GlobalModel.open_id,platform = GlobalModel.platform, server_id = GlobalModel.selServerInfo.service_id})
    else
        GlobalAlert:showTips("帐号不正确！")
    end 
end


function LoginController:sendMsg10002()
	self:saveLocalUserInf()
	GameNet:sendMsgToSocket(10002, {player_id = GlobalModel.player_id,os_type=GlobalModel.os_type,open_id=GlobalModel.open_id,platform = GlobalModel.platform})
end


--登录平台基本信息验证
function LoginController:onHandle10000(data)
	if data.result == 0 then
		GlobalModel.curServerRoleArr = data.player_list or {}

		if data.player_list and #data.player_list > 0 then

			if #data.player_list == 10 then
				local role = data.player_list[1]
				GlobalModel.player_id = role.player_id
				GlobalModel.name = role.name
				GlobalModel.sex = role.sex
				GlobalModel.career = role.careeri
				GlobalModel.lv = role.lv
				self:sendMsg10002()
			else
				if GlobalController.curScene == SCENE_MAIN then
					GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
					self:dispatchEvent(LoginEvent.LOGIN_SHOW_SELROLE)
				else
					self:dispatchEvent(LoginEvent.LOGIN_SHOW_SELROLE)
				end
			end
		else
			--GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_REGITER)
			self:dispatchEvent(LoginEvent.LOGIN_SHOW_REGITER)
		end
	else
		GlobalAlert:showTips("平台验证失败")	
	end
end

--创建角色
function LoginController:onHandle10001(data)
	--print("onHandle10001")
	--dump(data)
	if data.result == 0 then 
		local playInfo = data.player_info

		GlobalModel.player_id = playInfo.player_id
		GlobalModel.name = playInfo.name
		GlobalModel.sex = playInfo.sex
		GlobalModel.career = playInfo.career
		GlobalModel.lv = playInfo.lv
		--self:saveLocalUserInf()
		self:sendMsg10002()
		self.isNewCreateRole = true
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function LoginController:onHandle10005(data)

end

--心跳包
function LoginController:onHandle10006(data)
	if os.time() - data.server_time > 360 then--外挂判断
		GlobalModel.showDisconnectTip = false
		--GameNet:disconnect()--必须服务器端或客户端其中一端断链，都断导致两次调用CLOSE函数，自动重连，服务器已经断了
	    local param = {tipTxt = "系统异常[0x360]，请联系客服", enterFun = handler(self, self.quit),hideBackBtn = true}
	    --GlobalAlert:pop(param)
	end
	GlobalEventSystem:dispatchEvent(NetworkMonitorEvent.EVENT_SPEED_CHANGED, socket.gettime() - self.checkNetworkTime)
	self.heartTime = socket.gettime()
	GlobalModel.serverTime = data.server_time
end

--退出 <Param name="flag" type="int8" describe="退出标识: 1 退出角色, 2 退出账号, 3 其他设备登陆"/>
function LoginController:onHandle10007(data)
	print("onHandle10007")
	-- GlobalWinManger:closeAllWindow()
	--清理队伍信息
	GlobalController.team:clear()
	--清理背包数据
	BagManager:getInstance().bagInfo:clear()
	--清理vip数据
	VipManager:getInstance():destory()
	--清理坐骑强化祝福值提示
	local fdata = {
           selected =  false
    }
	LocalDatasManager:saveLocalData(fdata, "ZF_TIP")

	self:clearAngPaoTimer()
	if data.flag > 1 then
		local function enterFun()
            cc.UserDefault:getInstance():setStringForKey("LoginType", "")
            cc.UserDefault:getInstance():flush()
			GlobalModel.showDisconnectTip = false
			GlobalModel.isGaming = false
			GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
        end
        if data.flag == 2 then
        	enterFun()
        elseif data.flag == 3 then
			GlobalAlert:pop({tipTxt = "该帐号已在别处登录，您将退出登录，回到初始画面",enterFun = handler(self, enterFun),hideBackBtn = true,alertName = "hasLogin"})
        end
	elseif data.flag == 1 then --退出角色
		GameNet:sendMsgToSocket(10000, {open_id=GlobalModel.open_id,platform = GlobalModel.platform, server_id = GlobalModel.selServerInfo.service_id})
	end
end

--切换PK模式
function LoginController:onHandle10008(data)
	local mode = data.pk_mode
		local str = "该"
		if mode == FightModelType.PEACE then
			str = "和平"
		elseif mode == FightModelType.GOODEVIL then
			str = "善恶"
		elseif mode == FightModelType.TEAM then
			str = "组队"
		elseif mode == FightModelType.GUILD then
			str = "行会"
		elseif mode == FightModelType.ALL then
			str = "全体"
		elseif mode == FightModelType.CORPS then
			str = "军团"
		elseif mode == FightModelType.UNION then
			str = "联盟"
		end

	if data.result == 1 then
		GlobalAlert:showTips("该场景不支持"..str.."PK模式")
	elseif data.result == 0 then
		GlobalAlert:showTips("切换到"..str.."PK模式")
	end
end

--删除角色
function LoginController:onHandle10009(data)
	if data.player_id then
		GlobalEventSystem:dispatchEvent(LoginEvent.DELECT_ROLE,data.player_id)
		GlobalAlert:showTips("删除角色成功！")
	end
end

--玩家死亡"
function LoginController:onHandle10010(data)
	GlobalEventSystem:dispatchEvent(FightEvent.SHOW_RESURGE,data)
end

function LoginController:onHandle10011(data)
	--查看玩家信息
	print("onHandle10011")
	if data.result == ERR_COMMON_SUCCESS then
		local node = require("app.modules.role.view.OtherRoleView").new()
		node:setData(data)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node) 
	elseif data.result ~= ERR_COrMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

--属性更新
function LoginController:onHandle10004(data)
    SystemNotice:showEquipAttChangTips(data.update_list)

	local roleInfo = RoleManager:getInstance().roleInfo
	local wealthInfo = RoleManager:getInstance().wealth
	local baseAttDispatch = false
	local fightAttDispatch = false
	local wealthDispatch = false
	local hangUpSceneIdDispatch = false
	local lvChange = false
	local expChange = false
	local lastExpValue = 0
	local lastLvValue = 0
	for k,v in pairs(data.update_list) do
		if v.key >=1 and v.key <= 6 then
			baseAttDispatch = true
		elseif  v.key <= 30 then
			fightAttDispatch = true
		end
		if v.key == 1 then -- 			1 等级,
			lvChange = true
			lastLvValue = roleInfo.lv
			roleInfo.lv = v.value
			local player = GlobalController.fight:getSelfPlayerModel()
			if player then
				player:playUpgrade()
				SoundManager:playSoundByType(SoundType.ROLE_UPGRADE)
			end
			GameNet:sendMsgToSocket(32037, {})
			GlobalEventSystem:dispatchEvent(RoleEvent.MAINROLE_LEVEL_UP)
			LoadingPackageManager:checkToLoadPackage()
            --统计等级升级
            GlobalAnalytics:updateLevel(v.value)
            ChannelAPI:updateLevel(v.value)
            if v.value == 15 then
            	GlobalWinManger:openWin(WinName.SEVENLOGINWIN)
            end
		elseif v.key == 2 then -- 			2 经验,
			expChange = true
			lastExpValue = roleInfo.exp
			roleInfo.exp = v.value
		elseif v.key == 3 then -- 			3 当前血量,
			roleInfo.cur_hp = v.value
		elseif v.key == 4 then -- 			4 当前魔法,
			roleInfo.cur_mp = v.value
		elseif v.key == 5 then -- 			5 血量上限,
			roleInfo.hp = v.value
		elseif v.key == 6 then -- 			6 魔法上限,
			roleInfo.mp = v.value

		elseif v.key == 7 then 	--最小物理攻击,
			roleInfo.min_ac = v.value
		elseif v.key == 8 then -- 			8 最大物理攻击,
			roleInfo.max_ac = v.value
		elseif v.key == 9 then -- 			9 最小魔法攻击,
			roleInfo.min_mac = v.value
		elseif v.key == 10 then -- 			10 最大魔法攻击,
			roleInfo.max_mac = v.value
		elseif v.key == 11 then -- 			11 最小道术攻击,
			roleInfo.min_sc = v.value
		elseif v.key == 12 then -- 			12 最大道术攻击,
			roleInfo.max_sc = v.value
		elseif v.key == 13 then -- 			13 最小物防,
			roleInfo.min_def = v.value
		elseif v.key == 14 then -- 			14 最大物防,
			roleInfo.max_def = v.value
		elseif v.key == 15 then -- 			15 最小魔防,
			roleInfo.min_res = v.value
		elseif v.key == 16 then -- 			16 最大魔防,
			roleInfo.max_res = v.value
		elseif v.key == 17 then -- 			17 暴击,
			roleInfo.crit = v.value
		elseif v.key == 18 then -- 			18 暴击伤害,
			roleInfo.crit_att = v.value
		elseif v.key == 19 then -- 			19 准确,
			roleInfo.hit = v.value
		elseif v.key == 20 then -- 			20 敏捷,
			roleInfo.dodge = v.value
		elseif v.key == 21 then -- 			21 伤害加深,
			roleInfo.damage_deepen = v.value
		elseif v.key == 22 then -- 			22 伤害减免,
			roleInfo.damage_reduction = v.value
		elseif v.key == 23 then -- 			23 神圣,
			roleInfo.holy = v.value
		elseif v.key == 24 then -- 			24 技能伤害追加,
			roleInfo.skill_add = v.value
		elseif v.key == 25 then -- 			25 魔法命中,
			roleInfo.m_hit = v.value
		elseif v.key == 26 then -- 			26 魔法闪避,
			roleInfo.m_dodge = v.value
		elseif v.key == 27 then -- 			27 生命恢复,
			roleInfo.hp_recover = v.value
		elseif v.key == 28 then -- 			28 魔法恢复,
			roleInfo.mp_recover = v.value
		elseif v.key == 29 then -- 			29 死亡恢复,
			roleInfo.resurgence = v.value
		elseif v.key == 30 then -- 			30 伤害抵消,
			roleInfo.damage_offset = v.value

		elseif v.key == 31 then -- 			31 元宝,
			
			if v.value - wealthInfo.jade > 0 then
				SystemNotice:popAttValueTips(v.value - wealthInfo.jade,BPTIPS_TYPE_JADE)
			end
			wealthInfo.jade = v.value
			wealthDispatch = true
		elseif v.key == 32 then -- 			32 金币,
			if v.value  - wealthInfo.coin > 0 then
				SystemNotice:popAttValueTips(v.value - wealthInfo.coin,BPTIPS_TYPE_COIN)
			end
			wealthInfo.coin = v.value
			wealthDispatch = true
		elseif v.key == 33 then -- 			33 武器外观,
			roleInfo.weapon = v.value
			baseAttDispatch = true
		elseif v.key == 34 then -- 			34 衣服外观,
			roleInfo.clothes = v.value
			baseAttDispatch = true
		elseif v.key == 35 then -- 			35 熔炼值,
			wealthInfo.smelt_value = v.value
			wealthDispatch = true
		elseif v.key == 77 then -- 			35 功勋值,
			if  v.value ~= wealthInfo.feats then
				SystemNotice:popAttValueTips(v.value - wealthInfo.feats,BPTIPS_TYPE_FEAT)
			end
			wealthInfo.feats = v.value
			wealthDispatch = true
			GlobalEventSystem:dispatchEvent(EquipEvent.EQUIP_TIP,Equip_tip.EQUI_TIP_MEDAL)
		elseif v.key == 36 then -- 			36当前挂机场景
			roleInfo.hookSceneId = v.value
			hangUpSceneIdDispatch = true
		elseif v.key == 37 then -- 			37 通关挂机场景
			roleInfo.passHookSceneId = v.value
			hangUpSceneIdDispatch = true
		elseif v.key == 38 then -- 			38 血量百分比加成
			roleInfo.hp_p = v.value
		elseif v.key == 39 then -- 			39 魔法百分比加成
			roleInfo.mp_p = v.value
		elseif v.key == 40 then -- 			40 最小物理攻击百分比加成
			roleInfo.min_ac_p = v.value
		elseif v.key == 41 then -- 			41 最大物理攻击百分比加成
			roleInfo.max_ac_p = v.value
		elseif v.key == 42 then -- 			42 最小魔法攻击百分比加成
			roleInfo.min_mac_p = v.value
		elseif v.key == 43 then -- 			43 最大魔法攻击百分比加成
			roleInfo.max_mac_p = v.value
		elseif v.key == 44 then -- 			44 最小道术攻击百分比加成
			roleInfo.min_sc_p = v.value
		elseif v.key == 45 then -- 			45 最大道术攻击百分比加成
			roleInfo.max_sc_p = v.value
		elseif v.key == 46 then -- 			46 最小物防百分比加成
			roleInfo.min_def_p = v.value
		elseif v.key == 47 then -- 			47 最大物防百分比加成
			roleInfo.max_def_p = v.value
		elseif v.key == 48 then -- 			48 最小魔防百分比加成
			roleInfo.min_def_p = v.value
		elseif v.key == 49 then -- 			49 最大魔防百分比加成
			roleInfo.max_res_p = v.value
		elseif v.key == 50 then --			50 暴击百分比加成
			roleInfo.crit_p = v.value
		elseif v.key == 51 then -- 			51 暴击伤害百分比加成
			roleInfo.crit_att_p = v.value
		elseif v.key == 52 then -- 			52 准确百分比加成
			roleInfo.hit_p = v.value
		elseif v.key == 53 then -- 			53 敏捷百分比加成
			roleInfo.dodge_p = v.value
		elseif v.key == 54 then -- 			54 伤害加深百分比加成
			roleInfo.damage_deepen_p = v.value
		elseif v.key == 55 then --			55 伤害减免百分比加成
			roleInfo.damage_reduction_p = v.value
		elseif v.key == 56 then -- 			56 神圣百分比加成
			roleInfo.holy_p = v.value
		elseif v.key == 57 then -- 			57 技能伤害追加百分比加成
			roleInfo.skill_add_p = v.value
		elseif v.key == 58 then -- 			58 魔法命中百分比加成
			roleInfo.m_hit_p = v.value
		elseif v.key == 59 then -- 			59 魔法闪避百分比加成
			roleInfo.m_dodge_p = v.value
		elseif v.key == 60 then -- 			60 生命恢复百分比加成
			roleInfo.hp_recover_p = v.value
		elseif v.key == 61 then -- 			61 魔法恢复百分比加成
			roleInfo.mp_recover_p = v.value
		elseif v.key == 62 then -- 			62 死亡恢复百分比加成
			roleInfo.resurgence_p = v.value
		elseif v.key == 63 then -- 			63 伤害减免百分比加成
			roleInfo.damage_offset_p = v.value

		elseif v.key == 64 then -- 			64 玩家战斗力
			SystemNotice:showPowerChangTips(v.value)
			roleInfo.fighting = v.value
		elseif v.key == 65 then -- 			65 玩家背包格子数
			roleInfo.bag = v.value
			GlobalEventSystem:dispatchEvent(BagEvent.BAG_COUNT_CHANGE)
		elseif v.key == 66 then -- 			66 翅膀外观
			roleInfo.wing = v.value
		elseif v.key == 67 then -- 			67 宠物外观
			roleInfo.pet = v.value
		elseif v.key == 70 then --			70 礼券
			if v.value - wealthInfo.gift >0 then
				SystemNotice:popAttValueTips(v.value - wealthInfo.gift,BPTIPS_TYPE_GIFT)
			end
			wealthInfo.gift = v.value
			wealthDispatch = true
		elseif v.key == 71 then --			71 pk值
			local vv = v.value - roleInfo.pkValue
			roleInfo.pkValue = v.value
			if vv > 0 then
				GlobalAlert:showTips("您犯了谋杀罪，增加"..vv.."PK值")
			end
			baseAttDispatch = true
		elseif v.key == 72 then --			72 pk模式
			roleInfo.pkMode = v.value
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_PKMODE)
		elseif v.key == 75 then
			roleInfo.nameColor = v.value
		elseif v.key == 73 then -- 			vip
			baseAttDispatch = true
			roleInfo.vip = v.value
		elseif v.key == 74 then --			幸运
			roleInfo.lucky = v.value
			baseAttDispatch = true
		elseif v.key == 76 then --			称号
			roleInfo.honorId = v.value
		elseif v.key == 78 then --			vip经验值
			roleInfo.vip_exp = v.value
		elseif v.key == 79 then -- 翅膀外观显示状态
			roleInfo.wing_state = v.value
		elseif v.key == 109 then -- 翅膀外观显示状态
			roleInfo.weapon_state = v.value
		elseif v.key == 80 then --			"宠物攻击模式"/>
			roleInfo.petStates = v.value
			--GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(v.value))
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_PET_ATT_STATES)
		elseif v.key == 81 then --			"宠物攻击模式"/>
			roleInfo.petNum = v.value
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_PET_NUM)
		elseif v.key == 83 then
			roleInfo.teamId = v.value
		elseif v.key == 84 then
			if  v.value ~= wealthInfo.markValue[1] then
				SystemNotice:popAttValueTips(v.value - wealthInfo.markValue[1],BPTIPS_TYPE_MARK1)
			end
			wealthInfo.markValue[1] = v.value
		elseif v.key == 85 then
			if  v.value ~= wealthInfo.markValue[2] then
				SystemNotice:popAttValueTips(v.value - wealthInfo.markValue[2],BPTIPS_TYPE_MARK2)
			end
			wealthInfo.markValue[2] = v.value
		elseif v.key == 86 then
			if  v.value ~= wealthInfo.markValue[3] then
				SystemNotice:popAttValueTips(v.value - wealthInfo.markValue[3],BPTIPS_TYPE_MARK3)
			end
			wealthInfo.markValue[3] = v.value
		elseif v.key == 87 then
			if  v.value ~= wealthInfo.markValue[4] then
				SystemNotice:popAttValueTips(v.value - wealthInfo.markValue[4],BPTIPS_TYPE_MARK4)
			end
			wealthInfo.markValue[4] = v.value
		elseif v.key == 88 then
			roleInfo.mark[1] = v.value
		elseif v.key == 89 then
			roleInfo.mark[2] = v.value
		elseif v.key == 90 then
			roleInfo.mark[3] = v.value
		elseif v.key == 91 then
			roleInfo.mark[4] = v.value
		elseif v.key == 92 then
			roleInfo.mark[5] = v.value
		elseif v.key == 93 then
			roleInfo.mark[6] = v.value
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_INFO)
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_EQUIP_INFO)
			
		elseif v.key == 94 then
			roleInfo.mark[7] = v.value
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_INFO)
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_EQUIP_INFO)
		elseif v.key == 95 then
			roleInfo.mark[8] = v.value
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_INFO)
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_EQUIP_INFO)
		elseif v.key == 96 then
			roleInfo.mark[9] = v.value
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_INFO)
			GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_EQUIP_INFO)
		end

		GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_MARK_SUCCESS)

	end
	RoleManager:getInstance().roleInfo = roleInfo
	RoleManager:getInstance().wealth = wealthInfo

	if baseAttDispatch then
		GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_ROLE_BASE_ATTR,data.update_list)
	end
	if fightAttDispatch then
		GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_ROLE_FIGHT_ATTR)
	end
	if wealthDispatch then
		GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_WEALTH)
	end
	if hangUpSceneIdDispatch then
		GlobalEventSystem:dispatchEvent(FightEvent.CHANG_HANGUP_SCENE,{})
	end
	if expChange==true then
		if lvChange==true then 			--经验改变,等级也变了
			local lvUp = roleInfo.lv-lastLvValue
			if lvUp>0 then
				local part1 = configHelper:getLevelUpgradeExp(lastLvValue)-lastExpValue
				local part2 = 0
				for i=lastLvValue+1,roleInfo.lv-1,1 do
					part2 = part2 + configHelper:getLevelUpgradeExp(i)
				end
				local part3 = roleInfo.exp
				local newVal = part1 + part2 + part3
				if newVal ~= 0 then
					SystemNotice:popAttValueTips(newVal,BPTIPS_TYPE_EXP)
				end
				
			end
		else 							--经验改变,等级不变
			if  roleInfo.exp ~= lastExpValue then
				SystemNotice:popAttValueTips(roleInfo.exp-lastExpValue,BPTIPS_TYPE_EXP)
			end

		end
	end
end


--更新角色
function LoginController:onHandle10003(data)
	GlobalModel.initDataOK = false
	GlobalController.fight:stopSchedule()
	--print("onHandle10003")
	--print(data.result)
 	
	if data.result == 0 then
		local playInfo = data.player_info
		local roleManager = RoleManager:getInstance()

		local roleInfo = RoleInfoVO.new()	--主角相关信息
		local roleWealth = RoleWealthVO.new()
		
		roleInfo:updateFrom10003(playInfo)
		roleWealth:updateFrom10003(playInfo)
		FunctionOpenManager:initFunctionOpenList(playInfo.function_open_list)

		--设置选项
		SysOptionModel:updateFrom10003(playInfo)
		--新手引导
		GlobalController.guide:updateFrom10003(playInfo)

		roleManager.roleInfo = roleInfo
		roleManager.wealth = roleWealth

		roleManager:init()

		--派发主角基础属性改变的消息
		GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_MAINROLE_ATTR)
		--print("onHandle10003")
        local queueMsg = {
            {id = 26000},--导航信息
            {id = 10012},--获取玩家身上效果标识
            {id = 28003, data = {channel = ChannelAPI:getChannelId(), cps = ChannelAPI:getSubChannelId() }},--刷新开启功能
            {id = 9000},--获取按钮提示
            {id = 17011},--请求玩家行会信息
            {id = 12008, data = {type = 2}},--获取是否自动使用群体技能
            {id = 14020},--请求装备列表
            {id = 14001},--请求道具列表
            {id = 24000, data = {type = 3}},--获取黑名单(聊天使用)
            {id = 11040}, --获取玩家的仇人列表
            {id = 15001},--请求邮件列表
            {id = 12001},--请求技能列表
            {id = 27000},--获取各个职业的第一名
            {id = 11018},--获取沙城活动信息
        }

        GameNet:sendMsgToSocketByQueue(queueMsg)
		--modfiy by shine
		--统计玩家信息
		if self.isNewCreateRole then
			ChannelAPI:setCreateRole(playInfo)
			GlobalAnalytics:register(playInfo)
			self.isNewCreateRole = false
		end
		
		GlobalAnalytics:setPlayInfo(playInfo)
		ChannelAPI:setRoleData(playInfo)--设置角色基本数据
        ChannelAPI:bindingDeviceToken(playInfo.player_id)--提交别名用于推送
 

	

		if LoadingPackageManager.isLoadRes then
			--暂时波哥根据等级去处理
			--GameNet:sendMsgToSocket(32043, {type = 1})
		end
	else
		self:dispatchEvent(LoginEvent.LOGIN_SHOW_REGITER)
	end


	-- GameNet:sendMsgToSocket(16100)
end

function LoginController:onHandle28000(data)
	print("LoginController:onHandle28000")
	FunctionOpenManager:UpdateFunctionOpenByList(data.function_open_list, true)
end

function LoginController:onHandle28002(data)
	print("LoginController:onHandle28002")
	if #data.function_close_list == 0 then
		return
	end
	FunctionOpenManager:UpdateFunctionOpenByList(data.function_close_list, false)
end

function LoginController:onHandle28003(data)
	print("LoginController:onHandle28003")
	GlobalModel.card_state = data.state
end

--开服活动红包推送
function LoginController:requestAngPao(id)

	if self.angPaoIdList[id] then
		FunctionOpenManager:UpdateFunctionOpenByList({id}, false)
		GameNet:sendMsgToSocket(34000,{red_id = self.angPaoIdList[id]})
	end

	if self.angPaoTimerList[id] then
		scheduler.unscheduleGlobal(self.angPaoTimerList[id])
		self.angPaoTimerList[id] = nil
	end

	self.angPaoIdList[id] = nil
end

--下载40资源
function LoginController:onHandle32034(data)
	if data.result == 0 then
		self.downResOK = true
	end
end

--获取功能开启功能
function LoginController:onHandle32037(data)
	local conf = configHelper:getFunctionNotice()
	local lv = RoleManager:getInstance().roleInfo.lv
	if data.key ~= 0 then
		GlobalEventSystem:dispatchEvent(SceneEvent.FUNCTION_OPEN_PRIZE_TIPS,{isOpen = true,conf = conf[data.key],hasPrize = true})
	else
		local functionConf = nil
		local t= 1000
		for k,v in pairs(conf) do
			if v.lv > lv and v.lv - lv < t then
				t = v.lv - lv
				functionConf = v
			end
		end
		if functionConf then
			GlobalEventSystem:dispatchEvent(SceneEvent.FUNCTION_OPEN_PRIZE_TIPS,{isOpen = true,conf = functionConf,hasPrize = false})
		else
			GlobalEventSystem:dispatchEvent(SceneEvent.FUNCTION_OPEN_PRIZE_TIPS,{isOpen = false})
		end
	end
end

--领取功能开启奖励
function LoginController:onHandle32038(data)
	if data.result == 0 then
		GlobalAlert:showTips("领取奖励成功")
		GameNet:sendMsgToSocket(32037, {})
		GlobalEventSystem:dispatchEvent(SceneEvent.FUNCTION_OPEN_GET_PRIZE)
	else
		GlobalAlert:showTips(ErrorCodeNormalInfo[data.result])
	end
end

function LoginController:onHandle34000(data)
	print("LoginController:onHandle34000")
	if data.result ~= 0 then
		GlobalAlert:showTips(ErrorCodeNormalInfo[data.result])
	end
end

function LoginController:onHandle34001(data)
	print("LoginController:onHandle34001")
	local index = self:findFunctionId()
	--dump(index)
	if index ~= nil then
		self.angPaoIdList[index] = data.red_id
		FunctionOpenManager:UpdateFunctionOpenByList({index}, true)
		self.angPaoTimerList[index] = scheduler.scheduleGlobal(function() 
		FunctionOpenManager:UpdateFunctionOpenByList({index}, false) 
		scheduler.unscheduleGlobal(self.angPaoTimerList[index])
		self.angPaoIdList[index] = nil
		self.angPaoTimerList[index] = nil end, 15)
	end
end

function LoginController:findFunctionId()
	for i=1,5 do
		if self.angPaoIdList[self.angPaoFunIdList[i]] == nil then
			return self.angPaoFunIdList[i]
		end
	end
	return nil
end

function LoginController:clearAngPaoTimer()

	for k,v in pairs(self.angPaoTimerList) do
		scheduler.unscheduleGlobal(v)
	end
	self.angPaoTimerList = {}
end

--使用角色id登录游戏
function LoginController:onHandle10002(data)
	--print("onHandle10002")
	--dump(data)
	if data.result == 0 then 
		GameNet:sendMsgToSocket(10003, {})
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(data.result))
	end
end

function LoginController:onHandle22002(data)
	--dump(data)
	if data.result ~= 0 then
		GlobalAlert:showTips(ErrorCodeNormalInfo[data.result])
	end
end

function LoginController:onHandle23012(data)--声望变化
	SystemNotice:popAttValueTips(data.reputation,BPTIPS_TYPE_CREDIT)
end

function LoginController:onHandle10018(data)
	if data then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_SERVER_TIME, data)
	end
end

function LoginController:onHandle9997(data)
	GlobalModel.showDisconnectTip = false
	--GameNet:disconnect()--必须服务器端或客户端其中一端断链，都断导致两次调用CLOSE函数，自动重连，服务器已经断了
	local param = {enterTxt = "确 定", tipTxt = ErrorCodeNormalInfo[data.result], enterFun = handler(self, self.quit),hideBackBtn = true,alertName = "netErrorTips"}
	GlobalAlert:pop(param)
end

function LoginController:quit()
	if GlobalController.curScene == SCENE_MAIN then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
	elseif SCENE_LOGIN == GlobalController.curScene then
		GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_ENTER)
	end
end





