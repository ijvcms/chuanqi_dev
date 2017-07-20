--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-27 19:01:36
--

--[[
	仓库功能控制器。
	与服务器收发数据并更新仓库数据。
	操作数据并抛出相应的事件。
]]
StorageController = StorageController or class("StorageController", BaseController)

local StorageData = import(".model.StorageData")

local StorageProtos = {
	DATA    = 14040,
	CHANGED = 14041,
	ADDED   = 14042,
	REMOVED = 14043,
}


--构造器
function StorageController:ctor()
	self:initialization()
	StorageController.super.ctor(self)
end

function StorageController:initialization()
	self.storageData = StorageData.new()
	self:registerProto()
end

function StorageController:registerProto()
	-- 获得仓库道具信息列表
	self:registerProtocal(StorageProtos.DATA, handler(self, self.onHandle14040))

	-- 仓库道具信息列表变更
	self:registerProtocal(StorageProtos.CHANGED, handler(self, self.onHandle14041))

	-- 把道具存入仓库
	self:registerProtocal(StorageProtos.ADDED, handler(self, self.onHandle14042))

	-- 从仓库取出道具
	self:registerProtocal(StorageProtos.REMOVED, handler(self, self.onHandle14043))
end

function StorageController:unRegisterProto()
	for _, v in pairs(StorageProtos) do
		self:unRegisterProtocal(v)
	end
end

--
-- 刷新仓库内的物品列表。
--
function StorageController:RefreshStorageGoodsList()
	self:sendDataToServer(StorageProtos.DATA)
end

--
-- 保存一个物品至仓库。
--
function StorageController:Save(item, num)
	--[[
		<Packet proto="14042" type="c2s" name="req_bag_to_store" describe="道具存入仓库">
			<Param name="id" type="int64" describe="道具唯一id"/>
			<Param name="goods_id" type="int32" describe="道具id"/>
			<Param name="num" type="int32" describe="道具数量"/>
		</Packet>
	]]
	assert(item, "Save item to storage can't be nil")
	assert(num, "Save item number to storage can't be nil")
	if not item then return end

	local uniqueId  = item.id
	local goodsId   = item.goods_id
	local numOfSave = math.min(num, item.num)

	self:sendDataToServer(StorageProtos.ADDED, {id = uniqueId, goods_id = goodsId, num = numOfSave})
end

--
-- 从仓库取出一个物品。
--
function StorageController:Take(item, num)
	--[[
		<Packet proto="14043" type="c2s" name="req_store_to_bag" describe="仓库取出道具">
			<Param name="id" type="int64" describe="道具唯一id"/>
			<Param name="goods_id" type="int32" describe="道具id"/>
			<Param name="num" type="int32" describe="道具数量"/>
		</Packet>
	]]
	assert(item, "Take item from storage can't be nil")
	assert(num, "Take item number from storage can't be nil")
	if not item then return end

	local uniqueId  = item.id
	local goodsId   = item.goods_id
	local numOfSave = math.min(num, item.num)

	self:sendDataToServer(StorageProtos.REMOVED, {id = uniqueId, goods_id = goodsId, num = numOfSave})
end

-- ==========================================================================================
-- 数据查询接口。
-- ------------------------------------------------------------------------------------------
function StorageController:GetStorageItems()
	return self.storageData:GetItems()
end

function StorageController:GetStorageCapacity()
	return self.storageData:GetStorageCapacity()
end

-- ==========================================================================================
-- 接收服务端针对仓库数据发生的变化
-- ------------------------------------------------------------------------------------------
function StorageController:onHandle14040(data)
	--[[
		<Packet proto="14040" type="s2c" name="rep_store_list" describe="仓库道具信息列表">
			<Param name="store_cell" type="int8" describe="仓库格子数"/>
			<Param name="goods_list" type="list" sub_type="proto_goods_full_info" describe="道具信息列表"/>
		</Packet>
	]]
	local numOfCapacity = data.store_cell
	local goodsList     = data.goods_list

	self.storageData:SetStorageCapacity(numOfCapacity)
	self.storageData:SetItems(goodsList)
	self:dispatchEventWith(StorageEvent.DATA_CHANGED)
end

function StorageController:onHandle14041(data)
	--[[
		<Packet proto="14041" type="s2c" name="rep_broadcast_store_goods_info" describe="仓库道具信息变更广播">
			<Param name="goods_info" type="proto_goods_full_info" describe="变更的道具信息"/>
		</Packet>
	]]

	--[[
		<Type name="proto_goods_full_info" describe="道具完整信息">
			<Param name="id" type="int64" describe="道具唯一id"/>
			<Param name="goods_id" type="int32" describe="道具id"/>
			<Param name="is_bind" type="int8" describe="是否绑定 0非绑 1绑定"/>
			<Param name="num" type="int32" describe="数量"/>
			<Param name="stren_lv" type="int8" describe="强化等级"/>
			<Param name="location" type="int8" describe="存放位置"/>
			<Param name="grid" type="int8" describe="存放所在格子"/>
			<Param name="baptize_attr_list" type="list" sub_type="proto_attr_value" describe="装备的洗练属性"/>
			<Param name="artifact_star" type="int8" describe="神器星级"/>
			<Param name="artifact_lv" type="int8" describe="神器等级"/>
			<Param name="artifact_exp" type="int8" describe="神器经验"/>
		</Type>
	]]
	local goodsItem   = data.goods_info
	local goodsId     = goodsItem.id

	while true do
		-- 删除
		if 0 == goodsItem.num then
			self.storageData:RemoveItemById(goodsId)
			break
		end

		-- 修改
		local storageItem = self.storageData:GetItemById(goodsId)
		if storageItem then
			self.storageData:RemoveItem(storageItem)
		end

		-- 增加
		self.storageData:AddItem(goodsItem)
		break
	end

	self:dispatchEventWith(StorageEvent.DATA_CHANGED)
end

function StorageController:onHandle14042(data)
	--[[
		<Packet proto="14042" type="s2c" name="rep_bag_to_store" describe="道具存入仓库">
			<Param name="result" type="int16" describe="结果:0成功 非0请见错误码"/>
		</Packet>
	]]

	local result = data.result
	if result ~= 0 then
		self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(result))
	end
end

function StorageController:onHandle14043(data)
	--[[
		<Packet proto="14043" type="s2c" name="rep_store_to_bag" describe="仓库取出道具">
				<Param name="result" type="int16" describe="结果:0成功 非0请见错误码"/>
		</Packet>
	]]

	local result = data.result
	if result ~= 0 then
		self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(result))
	end
end

-- 派发事件。
function StorageController:dispatchEventWith(type, data)
	GlobalEventSystem:dispatchEvent(type, data)
end

-- 发送数据至服务器。
function StorageController:sendDataToServer(protoId, data)
	GameNet:sendMsgToSocket(protoId, data)
end

--销毁
function StorageController:destory()
	self:unRegisterProto()
	self:clear()
	StorageController.super.destory(self)
end

--清理
function StorageController:clear()
	if self.storageData then
		self.storageData:ClearItems()
		self.storageData = nil
	end
	StorageController.super.clear(self)
end