--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- 结盟
UnionController = UnionController or class("UnionController",BaseController)

function UnionController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function UnionController:registerProto()
	self:registerProtocal(17085,handler(self,self.onHandle17085))
	self:registerProtocal(17086,handler(self,self.onHandle17086))
	self:registerProtocal(17087,handler(self,self.onHandle17087))
	self:registerProtocal(17089,handler(self,self.onHandle17089))
	self:registerProtocal(17090,handler(self,self.onHandle17090))
	self:registerProtocal(17091,handler(self,self.onHandle17091))
	self:registerProtocal(17092,handler(self,self.onHandle17092))
	self:registerProtocal(17093,handler(self,self.onHandle17093))
	self:registerProtocal(17094,handler(self,self.onHandle17094))
end

--发起结盟 
-- GameNet:sendMsgToSocket(17085,{server_id_b = GlobalModel.curServerId,player_id_b= RoleManager:getInstance().roleInfo.player_id,guild_id_b = RoleManager:getInstance().guildInfo.guild_id})
function UnionController:onHandle17085(data)
	if data.result == 0 then
		GlobalMessage:show("发起结盟成功！")
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end
--收到行会结盟请求">
function UnionController:onHandle17086(data)
	if GlobalController.fight:getScene().loading then 			--如果loading界面正在显示,那么等loading完再显示
		self.eventForNewUnion = nil 
		local function onShow()
			SystemNotice:newUnionNotice(data)
			GlobalEventSystem:removeEventListenerByHandle(self.eventForNewUnion)
			self.eventForNewUnion = nil
		end
		self.eventForNewUnion = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
	else
		SystemNotice:newUnionNotice(data)
	end
	-- <Param name="server_id_a" type="int32" describe="发起方区服id"/>
	-- <Param name="guild_id_a" type="int64" describe="发起方帮派id"/>
	-- <Param name="guild_name_a" type="string" describe="发起方帮派名称"/>
	-- <Param name="player_id_a" type="int64" describe="发起的玩家id"/>
	-- <Param name="player_name_a" type="string" describe="发起的玩家姓名"/>
end

--同意行会结盟">
-- <Param name="server_id_a" type="int32" describe="发起方区服id"/>
-- 				<Param name="guild_id_a" type="int64" describe="发起方对方帮派id"/>
-- 				<Param name="player_id_a" type="int64" describe="发起的玩家id"/>
-- 				<Param name="type" type="int8" describe="同意或拒绝,0拒绝，1同意"/>
--GameNet:sendMsgToSocket(17085,{type = 0or1 0拒绝,server_id_a = data.server_id_a,guild_id_a= data.guild_id_a,player_id_a= data.player_id_a})
function UnionController:onHandle17087(data)
	if data.result == 0 then 
		if data.type == 1 then
			GlobalMessage:show("同意结盟成功！")
		else
			GlobalMessage:show("拒绝结盟成功！")
		end
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end
--反馈给发起方结盟请求"> 已删除
function UnionController:onHandle17088(data)

	-- <Param name="server_id_b" type="int32" describe="接收方区服id"/>
	-- 			<Param name="guild_id_b" type="int64" describe="接收方帮派id"/>
	-- 			<Param name="guild_name_b" type="string" describe="接收方帮派名称"/>
	-- 			<Param name="player_id_b" type="int64" describe="接收方玩家id"/>
	-- 			<Param name="player_name_b" type="string" describe="接收方玩家姓名"/>
end
--退出行会结盟">
--GameNet:sendMsgToSocket(17089)
function UnionController:onHandle17089(data)
	if data.result == 0 then 
		GlobalMessage:show("退出结盟成功！")
		GlobalWinManger:closeWin(WinName.UNIONWIN)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

--踢出行会结盟">
-- <Param name="server_id_b" type="int32" describe="接收方区服id"/>
-- 				<Param name="guild_id_b" type="int64" describe="接收方帮派id"/>
--GameNet:sendMsgToSocket(17089,{server_id_b=server_id_b,guild_id_b = guild_id_b})
function UnionController:onHandle17090(data)
	if data.result == 0 then 
		GlobalMessage:show("踢出结盟成功！")
		GameNet:sendMsgToSocket(17093)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

--收到踢出行会结盟">
function UnionController:onHandle17091(data)
	GlobalMessage:show("你的行会已经被踢出结盟")
	-- <Param name="guild_id" type="int64" describe="被踢帮派id"/>
	-- <Param name="guild_name" type="string" describe="被踢帮派名称"/>
	-- <Param name="player_name" type="string" describe="踢人的玩家名"/>
end

--<!-- 推送结盟状态，也可主动请求协议10017 --> 
--推送结盟状态">
--GameNet:sendMsgToSocket(10017,{push_list={17092}})
function UnionController:onHandle17092(data)
	if data.list then
		local arr = {}
		for i=1,#data.list do
		 	arr[data.list[i].guild_id] = data.list[i]
		end
		RoleManager:getInstance().guildInfo.union = arr
	end

	if data.list then
		--GlobalEventSystem:dispatchEvent(UnionEvent.GET_UNION_LIST)
		--  <Param name="server_id" type="int32" describe="区服"/>
		-- 	<Param name="guild_id" type="int64" describe="帮派id"/>
		-- 	<Param name="guild_name" type="string" describe="帮派名称"/>
		GlobalController.fight:updateUnionStates()
		if RoleManager:getInstance().guildInfo.position == 1 or  RoleManager:getInstance().guildInfo.position == 2 then
			GameNet:sendMsgToSocket(17093)
		end
	end
end


function UnionController:onHandle17093(data)
	if data.list then
		local arr = {}
		for i=1,#data.list do
		 	arr[data.list[i].guild_id] = data.list[i]
		end
		RoleManager:getInstance().guildInfo.unionInfo = arr
		GlobalEventSystem:dispatchEvent(UnionEvent.GET_UNION_INFO_LIST)
		--  <Param name="server_id" type="int32" describe="区服"/>
		-- 	<Param name="guild_id" type="int64" describe="帮派id"/>
		-- 	<Param name="guild_name" type="string" describe="帮派名称"/>
		-- 	<Param name="chairman_name" type="string" describe="会长名称"/>
		-- 	<Param name="guild_lv" type="int8" describe="帮派等级"/>
		-- 	<Param name="number" type="int16" describe="人数"/>
	end
end

--获取单个帮派信息
--GameNet:sendMsgToSocket(17094,{guild_id=17092})
function UnionController:onHandle17094(data)
	if data.result == 0 then 
		GlobalEventSystem:dispatchEvent(UnionEvent.PLAYER_INFO,data.guild_info)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end
