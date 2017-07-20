--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-14 17:13:46
--
--[[
	排位赛模块控制器。
	与服务器收发数据并更新排位赛数据。
	操作数据并抛出相应的事件。
]]
QualifyingController = QualifyingController or class("QualifyingController", BaseController)

local QualifyingData = import(".model.QualifyingData")

local QualifyingProtos = {
	RANK_OF_QUALIFYING  = 23001, -- 获取我在排位赛中的排名
	COUNT_OF_CHALLENGE  = 23002, -- 获取我当前的挑战次数
	LIST_OF_CHALLENGE   = 23003, -- 获取挑战列表
	LIST_OF_TOTAL_RANK  = 23004, -- 获取总排行列表
	LIST_OF_RECORD      = 23005, -- 获取我的挑战记录列表
	DO_CONVERT_GOODS    = 23006, -- 兑换商品
	VALUE_OF_FAME       = 23007, -- 获取排位赛声望
	DO_CHALLENGE_PLAYER = 23008, -- 发起挑战
	DO_RELOAD_CHALLENGE = 23009, -- 换一批挑战列表
	DO_CLEAR_RECORD     = 23010, -- 清空挑战记录
	CHALLENGE_RESULT    = 23011, -- 挑战结束结果
}

function QualifyingController:ctor()
	self:initialization()
end

function QualifyingController:initialization()
	self._qualifyingData = QualifyingData.new()
	self:registerProto()
end

-- ==========================================================================================
-- Public Query Interface.
-- ------------------------------------------------------------------------------------------

--
-- 获取我在排位赛中的排名
--
function QualifyingController:GetQualifyingRank()
	return self._qualifyingData:GetQualifyingRank()
end

--
-- 获取我当前的剩余挑战次数
--
function QualifyingController:GetChallengeCount()
	return self._qualifyingData:GetChallengeCount()
end

--
-- 获取我当前的声望
--
function QualifyingController:GetFame()
	return self._qualifyingData:GetFame()
end

--
-- 获取挑战列表
--
function QualifyingController:GetChallengeList()
	return self._qualifyingData:GetChallengeList():GetElements()
end

--
-- 获取总排行列表
--
function QualifyingController:GetTotalRankList()
	return self._qualifyingData:GetTotalRankList():GetElements()
end

--
-- 获取我的挑战记录列表
--
function QualifyingController:GetRecordList()
	return self._qualifyingData:GetRecordList():GetElements()
end

-- ==========================================================================================
-- Public Function menbers.
-- ------------------------------------------------------------------------------------------

--
-- 刷新我当前的排名数据。
--
function QualifyingController:RefreshMyRank()
	self:sendDataToServer(QualifyingProtos.RANK_OF_QUALIFYING)
end

--
-- 刷新我当前的挑战次数。
--
function QualifyingController:RefreshChallengeCount()
	self:sendDataToServer(QualifyingProtos.COUNT_OF_CHALLENGE)
end

--
-- 刷新当前可以挑战的列表。
--
function QualifyingController:RefreshChallengeList()
	self:sendDataToServer(QualifyingProtos.LIST_OF_CHALLENGE)
end

--
-- 刷新当前排位赛的总排行榜。
--
function QualifyingController:RefreshTotalRankList()
	self:sendDataToServer(QualifyingProtos.LIST_OF_TOTAL_RANK)
end

--
-- 刷新我的挑战记录列表。
--
function QualifyingController:RefreshRecordList()
	self:sendDataToServer(QualifyingProtos.LIST_OF_RECORD)
end

--
-- 刷新我的排位赛声望
--
function QualifyingController:RefreshFame()
	self:sendDataToServer(QualifyingProtos.VALUE_OF_FAME)
end

--
-- 清空挑战记录
--
function QualifyingController:ClearRecords()
	self:sendDataToServer(QualifyingProtos.DO_CLEAR_RECORD)
end

--
-- 兑换物品。
-- @param goodsId 兑换的物品ID。
--
function QualifyingController:ConvertGoods(goodsId)
	--[[
		<Packet proto="23006" type="c2s" name="req_arena_shop" describe="竞技场商店兑换">
			<Param name="id" type="int32" describe="商品id"/>
		</Packet>
	]]
	local __goodsId = checknumber(goodsId)
	self:sendDataToServer(QualifyingProtos.DO_CONVERT_GOODS, {id = __goodsId})
end


--
-- 挑战排位赛玩家
-- @param playerId 玩家Id
--
function QualifyingController:ChallengePlayer(playerId)
	--[[
		<Packet proto="23008" type="c2s" name="req_challenge_arena" describe="发起挑战">
			<Param name="player_id" type="int64" describe="挑战玩家id"/>
		</Packet>
	]]
	local __playerId = checknumber(playerId)
	self:sendDataToServer(QualifyingProtos.DO_CHALLENGE_PLAYER, {player_id = __playerId})
end

--
-- 换一批挑战列表，与刷新不同，此方法将会返回不同的挑战列表。
-- 通知成功之后，服务器会主动推送LIST_OF_CHALLENGE协议，因此不用再次手动请求。
--
function QualifyingController:ReloadChallengeList()
	self:sendDataToServer(QualifyingProtos.DO_RELOAD_CHALLENGE)
end

--销毁
function QualifyingController:destory()
	self:unRegisterProto()
	self:clear()
	QualifyingController.super.destory(self)
end

--清理
function QualifyingController:clear()
	if self._qualifyingData then
		self._qualifyingData:Destory()
		self._qualifyingData = nil
	end
	QualifyingController.super.clear(self)
end

-- ==========================================================================================
-- Private Function menbers.
-- ------------------------------------------------------------------------------------------
-- 注册服务端业务数据回调
function QualifyingController:registerProto()
	self:registerProtocal(QualifyingProtos.RANK_OF_QUALIFYING,  handler(self, self.onHandle_RANK_OF_QUALIFYING))
	self:registerProtocal(QualifyingProtos.COUNT_OF_CHALLENGE,  handler(self, self.onHandle_COUNT_OF_CHALLENGE))
	self:registerProtocal(QualifyingProtos.LIST_OF_CHALLENGE,   handler(self, self.onHandle_LIST_OF_CHALLENGE))
	self:registerProtocal(QualifyingProtos.LIST_OF_TOTAL_RANK,  handler(self, self.onHandle_LIST_OF_TOTAL_RANK))
	self:registerProtocal(QualifyingProtos.LIST_OF_RECORD,      handler(self, self.onHandle_LIST_OF_RECORD))
	self:registerProtocal(QualifyingProtos.DO_CONVERT_GOODS,    handler(self, self.onHandle_DO_CONVERT_GOODS))
	self:registerProtocal(QualifyingProtos.VALUE_OF_FAME,       handler(self, self.onHandle_VALUE_OF_FAME))
	self:registerProtocal(QualifyingProtos.DO_CHALLENGE_PLAYER, handler(self, self.onHandle_DO_CHALLENGE_PLAYER))
	self:registerProtocal(QualifyingProtos.DO_RELOAD_CHALLENGE, handler(self, self.onHandle_DO_RELOAD_CHALLENGE))
	self:registerProtocal(QualifyingProtos.DO_CLEAR_RECORD,     handler(self, self.onHandle_DO_CLEAR_RECORD))
	self:registerProtocal(QualifyingProtos.CHALLENGE_RESULT,    handler(self, self.onHandle_CHALLENGE_RESULT))
end

-- 取消业务数据的回调监听
function QualifyingController:unRegisterProto()
	for _, v in pairs(QualifyingProtos) do
		self:unRegisterProtocal(v)
	end
end

-- 派发事件。
function QualifyingController:dispatchEventWith(type, data)
	GlobalEventSystem:dispatchEvent(type, data)
end

-- 发送数据至服务器。
function QualifyingController:sendDataToServer(protoId, data)
	GameNet:sendMsgToSocket(protoId, data)
end

-- 处理错误代码。
function QualifyingController:handleResultCode(resultCode)
	self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(resultCode))
end

-- ==========================================================================================
-- Receive data change from server & handle data & diapatch events
-- 接收服务端针对排位赛信息发生的变化
-- ------------------------------------------------------------------------------------------

function QualifyingController:onHandle_RANK_OF_QUALIFYING(data)
	--[[
		<Packet proto="23001" type="s2c" name="rep_get_arena_rank" describe="获取竞技场排名">
			<Param name="rank" type="int32" describe="排名"/>
		</Packet>
	]]
	self._qualifyingData:SetQualifyingRank(data.rank)
	self:dispatchEventWith(QualifyingEvent.RANK_OF_QUALIFYING)
end

function QualifyingController:onHandle_COUNT_OF_CHALLENGE(data)
	--[[
		<Packet proto="23002" type="s2c" name="rep_get_arena_count" describe="获取挑战次数">
			<Param name="count" type="int8" describe="挑战次数"/>
		</Packet>
	]]

	self._qualifyingData:SetChallengeCount(data.count)
	self:dispatchEventWith(QualifyingEvent.COUNT_OF_CHALLENGE)
end

function QualifyingController:onHandle_LIST_OF_CHALLENGE(data)
	--[[
		<Packet proto="23003" type="s2c" name="rep_arena_challenge_list" describe="获取竞技场挑战列表">
			<Param name="list" type="list" sub_type="proto_arena_challenge_list" describe="挑战玩家信息"/>
		</Packet>
	]]
	self._qualifyingData:GetChallengeList():Set(data.list)
	self:dispatchEventWith(QualifyingEvent.LIST_OF_CHALLENGE)
end

function QualifyingController:onHandle_LIST_OF_TOTAL_RANK(data)
	--[[
		<Packet proto="23004" type="s2c" name="rep_arena_rank_list" describe="获取竞技场排行列表">
			<Param name="list" type="list" sub_type="proto_arena_rank_list" describe="排名信息"/>
		</Packet>
	]]
	self._qualifyingData:GetTotalRankList():Set(data.list)
	self:dispatchEventWith(QualifyingEvent.LIST_OF_TOTAL_RANK)
end

function QualifyingController:onHandle_LIST_OF_RECORD(data)
	--[[
		<Packet proto="23005" type="s2c" name="rep_arena_record_list" describe="获取竞技场挑战记录列表">
			<Param name="list" type="list" sub_type="proto_arena_record" describe="挑战记录"/>
		</Packet>
	]]
	self._qualifyingData:GetRecordList():Set(data.list)
	self:dispatchEventWith(QualifyingEvent.LIST_OF_RECORD)
end

function QualifyingController:onHandle_DO_CONVERT_GOODS(data)
	--[[
		<Packet proto="23006" type="s2c" name="rep_arena_shop" describe="竞技场商店兑换">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function QualifyingController:onHandle_VALUE_OF_FAME(data)
	--[[
		<Packet proto="23007" type="s2c" name="rep_get_arena_reputation" describe="获取竞技场声望">
			<Param name="reputation" type="int32" describe="声望"/>
		</Packet>
	]]
	self._qualifyingData:SetFame(data.reputation)
	self:dispatchEventWith(QualifyingEvent.VALUE_OF_FAME)
end

function QualifyingController:onHandle_DO_CHALLENGE_PLAYER(data)
	--[[
		<Packet proto="23008" type="s2c" name="rep_challenge_arena" describe="发起挑战反回">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	else
		-- 挑战成功之后，推一个事件。
		self:dispatchEventWith(QualifyingEvent.CHALLENGE_START)
	end
end

function QualifyingController:onHandle_DO_RELOAD_CHALLENGE(data)
	--[[
		<Packet proto="23009" type="s2c" name="rep_refuse_match_list" describe="刷新匹配列表">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function QualifyingController:onHandle_DO_CLEAR_RECORD(data)
	--[[
		<Packet proto="23010" type="s2c" name="rep_clear_arena_record" describe="清空竞技场记录">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function QualifyingController:onHandle_CHALLENGE_RESULT(data)
	--[[
		<Packet proto="23011" type="s2c" name="rep_arena_result" describe="挑战结果广播">
			<Param name="result" type="int16" describe="结果 0成功 1失败"/>
			<Param name="goods_list" type="list" sub_type="proto_goods_list" describe="道具列表"/>
			<Param name="rank" type="int32" describe="胜利后排名"/>
		</Packet>
	]]
	-- 先导入：
	local QualifyingResultView = import("app.modules.qualifying.view.QualifyingResultView")
	local configInstance = configHelper.getInstance()

	local batchAddGoodsName = function(goodsList)
		for i = 1, #goodsList do
			goodsList[i].name = configInstance:getGoodNameByGoodId(goodsList[i].goods_id)
		end
	end

	-- 为物品添加名称
	batchAddGoodsName(data.goods_list)

	-- 使用
	local view = QualifyingResultView:new()
	view:Show({
		isWin     = data.result == 0, -- 是否胜利
		rank      = data.rank,        -- 排名
		goodsList = data.goods_list   -- 奖励物品列表
	})
	self:dispatchEventWith(GlobalEvent.SHOW_BOX, view)
	self:dispatchEventWith(QualifyingEvent.CHALLENGE_RESULT, data)
	--统计排位赛情况
    GlobalAnalytics:setActiveEvent("排位赛", 0, data.result + 1)
end