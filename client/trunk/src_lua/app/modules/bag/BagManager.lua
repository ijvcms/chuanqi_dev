--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-09-09 
-- 背包数据管理器
BagManager = BagManager or class("BagManager",BaseManager)

BAG_TYPE_PROP  = 1 --道具
BAG_TYPE_EQUIP = 2 --装备
BAG_TYPE_GEM   = 3 --宝石

--构造
function BagManager:ctor()	
	BagManager.Instance=self
	self.bagInfo = BagInfo.new()	--主角相关信息
	self.bagMessage = nil
end

function BagManager:getInstance()
	if BagManager.Instance==nil then
		BagManager.new()
	end
	return BagManager.Instance
end

function BagManager:findItemCountByItemId(itemId)
	return self.bagInfo:findItemCountByItemId(itemId)
end

--取背包剩余数
function BagManager:getBagRemain()
	return self.bagInfo:getBagRemain()
end

function BagManager:getBagConfig()

	if self.bagMessage then
		return self.bagMessage
	end

	local config = configHelper:getBagConfig()
	local baglist = {}

	for i=1,#config do
		if i ~= 1 then
			baglist[#baglist + 1] = {min = config[i].min_lv,max = config[i].max_lv,num = config[i].cell,lock = config[i].cell - config[i-1].cell}
		else
			baglist[#baglist + 1] = {min = config[i].min_lv,max = config[i].max_lv,num = config[i].cell,lock = 0}
		end
	end

	self.bagMessage = baglist

	return baglist

end

function BagManager:getBagLock(page,num)

	--print(page,num)
	local baglist = self:getBagConfig()
	local roleInfo = RoleManager:getInstance().roleInfo
	local bagMap = {}
	 
	for i=1,#baglist do
		if roleInfo.lv < baglist[i].min then
			
			if baglist[i].num - baglist[i].lock >= (page - 1)*20 then
	 
	 		if num >= baglist[i].lock and num > 0 then
			 	--bagMap[baglist[i].min] = baglist[i].lock
			 	table.insert(bagMap, {lv = baglist[i].min,value = baglist[i].lock})
			 	num = num - baglist[i].lock
			else
				if num > 0 then
					--bagMap[baglist[i].min] = num
					table.insert(bagMap, {lv = baglist[i].min,value = num})
				end
			 	break
			end

			else
			
			local lock = baglist[i].num - (page - 1)*20
			
			if num >= lock and lock > 0 then
			 	--bagMap[baglist[i].min] = lock
			 	table.insert(bagMap, {lv = baglist[i].min,value = lock})
			 	num = num - lock
			end

			end

		end
	end
	if #bagMap > 1 then
		table.sort(bagMap,function(a,b)return a.lv < b.lv end)
	end
	return bagMap
end