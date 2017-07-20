--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-27 20:23:29
--

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

local StorageData = class("StorageData")

function StorageData:ctor()
	self:init()
end

function StorageData:init()
	self._storageItems  = {}
	self._numOfCapacity = 0
end

function StorageData:SetStorageCapacity(numOfCapacity)
	self._numOfCapacity = numOfCapacity
end

function StorageData:GetStorageCapacity()
	return self._numOfCapacity
end

function StorageData:SetItems(items)
	self:ClearItems()
	self:AddItems(items)
end

function StorageData:AddItems(items)
	if nil == items then return end
	for _, v in pairs(items) do
		self:AddItem(v)
	end
end

function StorageData:AddItem(item)
	if nil == item then return end
	table.insert(self._storageItems, item)
end

function StorageData:RemoveItem(item)
	if nil == item then return end
	local index = table.indexof(self._storageItems, item)
	table.remove(self._storageItems, index)
end

function StorageData:RemoveItemById(id)
	local goodsItem = self:GetItemById(id)
	if goodsItem then
		self:RemoveItem(goodsItem)
	end
end

function StorageData:ClearItems()
	self._storageItems = {}
end

function StorageData:GetItems()
	local items = {}
	for k, v in ipairs(self._storageItems) do
		items[k] = v
	end
	return items
end

function StorageData:GetItemById(id)
	local item = nil
	for _, v in ipairs(self._storageItems) do
		if v.id == id then
			item = v
			break
		end
	end
	return item
end

function StorageData:NumOfItems()
	return #self._storageItems
end

return StorageData