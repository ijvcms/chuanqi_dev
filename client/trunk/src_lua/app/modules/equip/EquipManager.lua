--
-- Author: Yi hanneng
-- Date: 2016-01-20 14:16:40
--
EquipManager = EquipManager or class("EquipManager", BaseManager)

function EquipManager:ctor()
	EquipManager.instance = self
	self.equipProduList = {}
	self.menuDataList = {}
	self.subDatalist = {}

	self.npcMenuDataList = {}
	self.npcSubDatalist = {}

	--特装
	self.spMenuDataList = {}
	self.spSubDatalist = {}

	self.purList = {}
	self.equipProductGoodsList = {}

	
	self:setPurList()
end

function EquipManager:getInstance()
	if EquipManager.instance == nil then
		EquipManager.new()
	end
	return EquipManager.instance
end

function EquipManager:setEquipProduList()
	local config = configHelper:getAFByCareer(RoleManager:getInstance().roleInfo.career)
	self.equipProduList = config
end
--1：NPC打造
--2：功能打造
function EquipManager:getEquipProduList(type)
	 
	if type == 2 then
		if #self.menuDataList ~= 0 then
			
			return self.menuDataList, self.subDatalist
		end
	elseif type == 1 then
		if #self.npcMenuDataList ~= 0 then
			return self.npcMenuDataList, self.npcSubDatalist
		end
	elseif type == 3 then
		if #self.spMenuDataList ~= 0 then
			return self.spMenuDataList, self.spSubDatalist
		end
	end
 
	self:setEquipProduList()
 	local tem = {}
 	local info = {}

	for k,v in pairs(self.equipProduList) do
		if v[1].fusion_type == 2 then
			self.menuDataList[#self.menuDataList + 1] = {key = k, type = SCLIST_TYPE.SCLIST_MENU,  name = v[1].name, resType = 1,subKey = k}
			
			local list = {}
			for i=1,#v do
				local goods_id = v[i].product[1][2]
				if v[i].fusion_type == 2 then
					list[i] = {key = i, type = SCLIST_TYPE.SCLIST_SUBITEM,  name = configHelper:getGoodNameByGoodId(goods_id), resType = 2,data = v[i] }
				end
				
			end

			self.subDatalist[k] = list
		elseif v[1].fusion_type == 1 then
			self.npcMenuDataList[#self.npcMenuDataList + 1] = {key = k, type = SCLIST_TYPE.SCLIST_MENU,  name = v[1].name, resType = 1,subKey = k}
			local nlist = {}
	 
			for i=1,#v do
				local goods_id = v[i].product[1][2]
				if v[i].fusion_type == 1 then
					nlist[i] = {key = i, type = SCLIST_TYPE.SCLIST_SUBITEM,  name = configHelper:getGoodNameByGoodId(goods_id), resType = 2,data = v[i] }
				end
				
			end
			self.npcSubDatalist[k] =nlist
		elseif v[1].fusion_type == 3 then
			self.spMenuDataList[#self.spMenuDataList + 1] = {key = k, type = SCLIST_TYPE.SCLIST_MENU,  name = v[1].name, resType = 1,subKey = k}
			
			local list = {}
			for i=1,#v do
				local goods_id = v[i].product[1][2]
				if v[i].fusion_type == 3 then
					list[i] = {key = i, type = SCLIST_TYPE.SCLIST_SUBITEM,  name = configHelper:getGoodNameByGoodId(goods_id), resType = 2,data = v[i] }
				end
				
			end

			self.spSubDatalist[k] = list
		end
		
	end
		
	if type == 2 then
		if #self.menuDataList > 1 then
			table.sort(self.menuDataList, function (a,b) return a.key < b.key end )
		end
		 
		return self.menuDataList, self.subDatalist
	elseif type == 1 then
		if #self.npcMenuDataList > 1 then
			table.sort(self.npcMenuDataList, function (a,b) return a.key < b.key end ) 
		end
		return self.npcMenuDataList, self.npcSubDatalist
	elseif type == 3 then
		if #self.spMenuDataList > 1 then
			table.sort(self.spMenuDataList, function (a,b) return a.key < b.key end ) 
		end
		return self.spMenuDataList, self.spSubDatalist
	end
end

function EquipManager:getProductGoodsList()
	
	if #self.equipProductGoodsList == 0 and #self.equipProductGoodsList == 0 then
	
		local list = configHelper:getProductGoodsyCareer(RoleManager:getInstance().roleInfo.career)

		for i=1,#list do
			if list[i].stuff then
				for j = 1,#list[i].stuff do
					if list[i].stuff[j][1]  == "goods" then
						if self.equipProductGoodsList[list[i].stuff[j][2]] == nil then
							self.equipProductGoodsList[list[i].stuff[j][2]] = {}
						end

						table.insert(self.equipProductGoodsList[list[i].stuff[j][2]], list[i])
					end
				end
			end
			
		end
	end

	return self.equipProductGoodsList
end

function EquipManager:setPurList()
	self.purList = configHelper:getPur()
end

function EquipManager:isInPurList(id)
	
	if not self.purList then return  false end
	if #self.purList == 0 then
		self:setPurList()
	end
	for i=1,#self.purList do
		if id == self.purList[i].stuff[1][2] then
			return true
		end
	end
	return false
end

function EquipManager:getPurNum(id)
	if not self.purList then return end
	for i=1,#self.purList do
		if id == self.purList[i].stuff[1][2] then
			return self.purList[i].stuff[1][3]
		end
	end
	return 0
end
--获取提纯key即提纯配方
function EquipManager:getPurKey(id)
	
	if not self.purList then return end
	for i=1,#self.purList do
		if id == self.purList[i].stuff[1][2] then
			return self.purList[i].key
		end
	end
	return nil
end
--提纯后
function EquipManager:getAfterPur(id)
	if not self.purList then return end
	for i=1,#self.purList do
		if id == self.purList[i].stuff[1][2] then
			return self.purList[i].product
		end
	end
	return nil
end
--判断是否可以分解
function EquipManager:canDecompose(data)

	if data.stren_lv > 0 then
		return true
	else
		return self:inCanDecompose(data.goods_id)
	end

	return false

end
--判断是否在可以分解表中
function EquipManager:inCanDecompose(id)
	return configHelper:canDecompose(id)
end

function EquipManager:clear()
	print("===================EquipManager:clear===================================")
	self.equipProduList = {}
	self.purList = {}
	self.menuDataList = {}
	self.subDatalist = {}
	self.npcMenuDataList = {}
	self.npcSubDatalist = {}
	self.spMenuDataList = {}
	self.spSubDatalist = {}
end

