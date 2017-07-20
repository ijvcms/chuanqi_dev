--
-- Author: gxg
-- Date: 2017-1-18
--
-- 跨服幻境之城 - Controller
--

require("app.modules.dreamland.DreamlandManager")

DreamlandController = DreamlandController or class("DreamlandController", BaseController)

function DreamlandController:ctor()
	DreamlandController.instance = self
	self:initProtocal()

end

function DreamlandController:getInstance()
	if DreamlandController.instance == nil then
		DreamlandController.new()
	end
	return DreamlandController.instance
end

function DreamlandController:initProtocal()
	-- 获取幻境之城的排名信息
	self:registerProtocal(11103,handler(self,self.onHandle11103)) 

	-- 获取玩家幻境之城的点亮信息
	self:registerProtocal(11104,handler(self,self.onHandle11104)) 

end

--[[
========================= C2S =========================
--]]
function DreamlandController:req_get_hjzc_rank_list()
	print("请求 11103 获取幻境之城的排名信息")
	GameNet:sendMsgToSocket(11103)

end

function DreamlandController:req_get_hjzc_plyaer_info()
	print("请求 11104 获取玩家幻境之城的点亮信息")
	GameNet:sendMsgToSocket(11104)

end

--[[
========================= S2C =========================
--]]
function DreamlandController:onHandle11103(data)
	-- <Param name="rank_list" type="list" sub_type="proto_hjzc_rank_info" describe="排名列表"/>
	print("回复 11103 获取幻境之城的排名信息")
	--dump(data)
	GlobalEventSystem:dispatchEvent(DreanlandEvent.hjzc_rank_list, data)

end

function DreamlandController:onHandle11104(data)
	-- <Param name="room_num" type="int8" describe="当前房间编号" />
	-- <Param name="pass_room_num_list" type="list" sub_type="int16" describe="玩家已经通关的房间编号" />
	print("回复 11104 获取玩家幻境之城的点亮信息")
	--dump(data)

	if DreamlandManager:getInstance():isSafeArea(data.room_num) == true then
		-- 安全区设置为通关状态
		GameSceneModel:setKfhjRoomPass(1) -- 当前房间状态  0 该场景还未通关，1，该场景已经通关
	end
	GlobalEventSystem:dispatchEvent(DreanlandEvent.hjzc_plyaer_info, data)

end
--[[
========================= 分割线 =========================
--]]

