--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-09-09 
-- 背包数据管理器

import("app.utils.EquipUtil")

-- local configHelper = import("app.utils.ConfigHelper").getInstance()

BagInfo = BagInfo or class("BagInfo")

--构造
function BagInfo:ctor()	
	self.items = {}
	self.items[1] = {}			--道具表
	self.items[2] = {}			--装备表
	self.items[3] = {}			--宝石表

	self.total = {}

	self.firstSort = false
	self.autoSort = true
	-- self.commonItems = {}
	-- self.commonItems[1] = {}
	-- self.commonItems[2] = {}
	-- self.commonItems[3] = {}
end

function BagInfo:initEquipData(data)
	self.items[2] = data
	--self:initEquipCommonItems()
	
	self:sortEquipBag(self.items[2])
end

function BagInfo:initPropData(data)
	self.items[1] = data
	--根据策划需求前端坐骑红点
	for i=1,#data do
		if 110260 == data[i].goods_id or data[i].goods_id == 110259 then
			GlobalEventSystem:dispatchEvent(RoleEvent.RIDE_HONG_TIP)
			break
		end
	end
	
	self:sortEquipBag(self.items[1])
	--self:initPropCommonItems()
end

function BagInfo:initGemData(data)
	self.items[3] = data
	self:sortEquipBag(self.items[3])
	--self:initGemCommonItems()
end

function BagInfo:getEquipList()
	if self.autoSort then
		self:sortEquipBag(self.items[2])
	end
	return self.items[2]
end

function BagInfo:getPropList()
	if self.autoSort then
		self:sortEquipBag(self.items[1])
	end
	return self.items[1]
end

function BagInfo:getGemList()
	if self.autoSort then
		self:sortEquipBag(self.items[3])
	end
	return self.items[3]
end

function BagInfo:getTotalList()
	
	if self.firstSort then
		if #self.total ~= #self.items[1] + #self.items[2] + #self.items[3] then
			self:handleTotal()
		end
		return self.total
	end
	self.total = {}
	for k=1,3 do
		for i=1,#self.items[k] do
			table.insert(self.total,self.items[k][i])
		end
	end

	if self.firstSort == false or self.autoSort then
		self:sortEquipBag(self.total)
		self.firstSort = true
	end

	return self.total
end

function BagInfo:getBagRemain()
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    return roleInfo.bag - (#self.items[1]+#self.items[2]+#self.items[3])
end

function BagInfo:handleTotal()
	for i=#self.total,1,-1 do
		local goodType = configHelper:getGoodTypeByGoodId(self.total[i].goods_id)
		if goodType == 1 or goodType == 4 or goodType == 6 or goodType == 7 then --道具
			local pos = self:findItemInPropBag(self.total[i])
			if pos == nil then
				table.remove(self.total,i)
			end
		elseif goodType == 2 then 		--装备
			local pos = self:findItemInEquipBag(self.total[i])
			if pos == nil then
				table.remove(self.total,i)
			end
		elseif goodType == 3 then 		--宝石
			local pos = self:findItemInGemBag(self.total[i])
			if pos == nil then
				table.remove(self.total,i)
			end
		end
	end
end

function BagInfo:sortEquipBag(bagItemList)

    --装备背包排列顺序修改：sortId 由小到大，然后再按id由小到大；
    if #bagItemList > 1 then
 
    table.sort(bagItemList,function(a,b)
        --品质由高到低
        local sortA = configHelper:getGoodSortIdByGoodId(a.goods_id)
        local sortB = configHelper:getGoodSortIdByGoodId(b.goods_id)
        if sortA < sortB then
            return true
        elseif sortA > sortB then
            return false
        elseif sortA==sortA then
            --return a.id>=b.id
            --同品sortId，按照装备ID从高到低
            local idA = a.id
            local idB = b.id
            if idA < idB then
                return true
            elseif idA > idB then
                return false
            end
        end
    end)

    end

	--[[
	--装备背包排列顺序修改：优先品质，品质由高到低；同品质下，按照装备等级从高到低；同等级下，同职业、同部位的装备放在一起，按照部位ID从小到大排列；
    table.sort(bagItemList,function(a,b)
        --品质由高到低
        local qualityA = configHelper:getGoodQualityByGoodId(a.goods_id)
        local qualityB = configHelper:getGoodQualityByGoodId(b.goods_id)
        if qualityA>qualityB then
            return true
        elseif qualityA<qualityB then
            return false
        elseif qualityA==qualityB then
            --return a.id>=b.id
            --同品质下，按照装备等级从高到低
            local lvA = configHelper:getGoodLVByGoodId(a.goods_id)
            local lvB = configHelper:getGoodLVByGoodId(b.goods_id)
            if lvA>lvB then
                return true
            elseif lvA<lvB then
                return false
            elseif lvA==lvB then
                --同等级下，与玩家职业相同的排在前面
                local careerName,careerA = configHelper:getEquipCareerByEquipId(a.goods_id) 
                local careerName,careerB = configHelper:getEquipCareerByEquipId(b.goods_id)
                if careerA==roleInfo.career and careerB==roleInfo.career then           --两者都与玩家同职业
                    --与玩家同职业,按部位ID从小到大排列
                    if a.grid == b.grid then 		--部位id相同,则按道具id从小到大排序
                    	return a.goods_id<b.goods_id
                    else
                    	return a.grid<b.grid
                    end
                elseif careerA~=roleInfo.career and careerB~=roleInfo.career then       --两者都与玩家不同职业
                    --不与玩家同职业
                    if careerA<careerB then
                        return true
                    elseif careerA>careerB then
                        return false
                    elseif careerA==careerB then
                        --按部位ID从小到大排列
                        if a.grid == b.grid then 		--部位id相同,则按道具id从小到大排序
	                    	return a.goods_id<b.goods_id
	                    else
	                    	return a.grid<b.grid
	                    end
                    end
                elseif careerA==roleInfo.career and careerB~=roleInfo.career then       --a与玩家职业相同
                    return true
                elseif careerA~=roleInfo.career and careerB==roleInfo.career then       --b与玩家职业相同
                    return false
                end
            end
        end
    end)
--]]
	-- table.sort(self.commonItems[2],function(a,b)
 --        --品质由高到低
 --        local qualityA = configHelper:getGoodQualityByGoodId(a.data.goods_id)
 --        local qualityB = configHelper:getGoodQualityByGoodId(b.data.goods_id)
 --        if qualityA>qualityB then
 --            return true
 --        elseif qualityA<qualityB then
 --            return false
 --        elseif qualityA==qualityB then
 --            --return a.id>=b.id
 --            --同品质下，按照装备等级从高到低
 --            local lvA = configHelper:getGoodLVByGoodId(a.data.goods_id)
 --            local lvB = configHelper:getGoodLVByGoodId(b.data.goods_id)
 --            if lvA>lvB then
 --                return true
 --            elseif lvA<lvB then
 --                return false
 --            elseif lvA==lvB then
 --                --同等级下，与玩家职业相同的排在前面
 --                local careerName,careerA = configHelper:getEquipCareerByEquipId(a.data.goods_id) 
 --                local careerName,careerB = configHelper:getEquipCareerByEquipId(b.data.goods_id)
 --                if careerA==roleInfo.career and careerB==roleInfo.career then           --两者都与玩家同职业
 --                    --与玩家同职业,按部位ID从小到大排列
 --                    return a.data.grid<b.data.grid
 --                elseif careerA~=roleInfo.career and careerB~=roleInfo.career then       --两者都与玩家不同职业
 --                    --不与玩家同职业
 --                    if careerA<careerB then
 --                        return true
 --                    elseif careerA>careerB then
 --                        return false
 --                    elseif careerA==careerB then
 --                        --按部位ID从小到大排列
 --                        return a.data.grid<b.data.grid
 --                    end
 --                elseif careerA==roleInfo.career and careerB~=roleInfo.career then       --a与玩家职业相同
 --                    return true
 --                elseif careerA~=roleInfo.career and careerB==roleInfo.career then       --b与玩家职业相同
 --                    return false
 --                end
 --            end
 --        end
 --    end)
 end

function BagInfo:pushBackItem(item)
	-- local configHelper = import("app.utils.ConfigHelper").getInstance()
	local goodType = configHelper:getGoodTypeByGoodId(item.goods_id)
	if goodType == 1 or goodType == 4 or goodType == 6 or goodType == 7 then 			--道具
		table.insert(self.items[1],item)
	elseif goodType == 2 then 		--装备
		item = EquipUtil.formatEquipItem(item)
		table.insert(self.items[2],item)
	elseif goodType == 3 then 		--宝石
		table.insert(self.items[3],item)
	end
end

function BagInfo:deleteItem(item)

end

function BagInfo:changeItems(items)
	local eventType = 0
	for _, item in ipairs(items) do
		local evt = self:changeItem(item, true)
		if evt > eventType then
			eventType = evt
		end
	end
	if eventType == 1 then
		GlobalEventSystem:dispatchEvent(BagEvent.BODY_EQUIP_CHANGE)
	elseif  eventType == 2 then
		GlobalEventSystem:dispatchEvent(BagEvent.CHANGE_EQUIP_TO_BAG)
	elseif  eventType == 3 then
		GlobalEventSystem:dispatchEvent(BagEvent.BODY_EQUIP_CHANGE)
		GlobalEventSystem:dispatchEvent(BagEvent.CHANGE_EQUIP_TO_BAG)
	end
end

-- 
function BagInfo:changeItem(item, noNotifyEvent)

	local eventType = 0
	-- local configHelper = import("app.utils.ConfigHelper").getInstance()
	local goodType = configHelper:getGoodTypeByGoodId(item.goods_id)
	local goodPos = self:findItemInBag(item)--在全部大类里的位置

	if goodType == 1 or goodType == 4 or goodType == 6 or goodType == 7 then 			--道具
		local pos = self:findItemInPropBag(item)
		if pos then
			if item.num == 0 then
				table.remove(self.items[1],pos)
				table.remove(self.total,goodPos)
				--回城石
				if 110152 == item.goods_id then
					GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_HOME_NUM,{num = 0})
				end
			else
				local oldItem = self.items[1][pos]
				--数量增加,提示获得某物品
				if item.num - oldItem.num > 0 then
					oldItem.num  = item.num - oldItem.num--重复使用原有数据
					SystemNotice:popGetItemsTips(oldItem)
				end
				self.items[1][pos] = item
				if goodPos then
					self.total[goodPos] = item
				end
				if goodType == 7 then--藏宝图
		    	    local putonTips = import("app.modules.bag.view.putOnTips").new()
		    	    putonTips:setData(oldItem)
		    	    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,putonTips)
			    end
			end
			
		else

			--回城石
			if 110152 == item.goods_id then
				GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_HOME_NUM,{num = item.num})
			end

			table.insert(self.items[1],item)
			table.insert(self.total,item)
			--添加道具,提示获得某物品
			SystemNotice:popGetItemsTips(item)
			-- 主场景内
			if GlobalController.curScene == SCENE_MAIN then
				if goodType == 6 or goodType == 7 then --立即使用礼包
                    local putonTips = import("app.modules.bag.view.putOnTips").new()
		    		putonTips:setData(item)
		    		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,putonTips)
				-- 如果是技能书，判断这个技能是否达到了学习要求，如果达到了就弹出立即使用窗口。
				elseif configHelper:isSkillBookByGoodsId(item.goods_id) and 
					RoleManager:getInstance():getSkillEnableLearnById(item.goods_id) then

		    		local putonTips = import("app.modules.bag.view.putOnTips").new()
		    		putonTips:setData(item)
		    		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,putonTips)
		    	end
		    elseif goodType == 7 then
		    	local putonTips = import("app.modules.bag.view.putOnTips").new()
		    	putonTips:setData(item)
		    	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,putonTips) 
			end
		end

		--坐骑(scott说坐骑升阶和坐骑装备强化所用的道具固定不变)
		if 110260 == item.goods_id or item.goods_id == 110259 then
			GlobalEventSystem:dispatchEvent(RoleEvent.RIDE_HONG_TIP)
		end

	elseif goodType == 2 then 		--装备				   
		local pos = self:findItemInEquipBag(item)

		if pos then
			if item.num == 0 or item.location == 1 then
				table.remove(self.items[2],pos)--从背包移除装备
				table.remove(self.total,goodPos)
				-- local commonItem = self.commonItems[2][pos]
				-- commonItem:release()
				-- table.remove(self.commonItems[2],pos)
				--self:sortEquipBag()
				--如果是穿上装备,那么需要添加该装备到人物的装备列表上

				if item.location == 1 then
					--穿上装备
					local roleManager = RoleManager:getInstance()
				    local equipList = roleManager.roleInfo.equip
				    table.insert(equipList,item)

				    --保存坐骑id
					if item.grid == 15 then
						roleManager.roleInfo.rideInfo = item
						GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_INFO)
					end
				    --roleManager.roleInfo.equip = equipList
				    if  noNotifyEvent then
				    	eventType = eventType + 1
				    else
				       GlobalEventSystem:dispatchEvent(BagEvent.BODY_EQUIP_CHANGE)
				    end
				end
				if noNotifyEvent then
					eventType = eventType + 2
				else
					GlobalEventSystem:dispatchEvent(BagEvent.CHANGE_EQUIP_TO_BAG)
				end
				
			else
				-- --数量增加,提示获得某物品
				-- if item.num - self.items[2][pos].num then
					-- tipsItem = {}
					-- for k,v in pairs(item) do
					-- 	tipsItem[k] = v
					-- end
					-- tipsItem.num = item.num - self.items[2][pos].num
					-- SystemNotice:popGetItemsTips(tipsItem)
				-- end
				--背包上的装备信息改变了
				self.items[2][pos] = item
				if goodPos then
					self.total[goodPos] = item
				end
--				GlobalEventSystem:dispatchEvent(BagEvent.EQUIP_CHANGE_ON_BAG,item)
			end
		else
			local roleManager = RoleManager:getInstance()
		    local equipList = roleManager.roleInfo.equip
			--如果是脱下装备,那么人物的装备列表需要删除这个装备
			--或者是新加装备到装备背包
			if item.location == 0 then
				table.insert(self.items[2],item)--新加装备到装备背包
				table.insert(self.total,item)
				-- local commonItem = CommonItemCell.new()
				-- commonItem:setData(item)
				-- table.insert(self.commonItems[2],commonItem)
				-- commonItem:retain()
				--self:sortEquipBag()

				local takeOff = false
				--移除坐骑
				if item.grid == 15 then
					roleManager.roleInfo.rideInfo = nil
					GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_INFO)
				end

			    for i=1,#equipList do
			    	if equipList[i].id == item.id then
			    		--脱下装备
			    		table.remove(equipList,i)
			    		--roleManager.roleInfo.equip = equipList
			    		if  noNotifyEvent then
				    	    eventType = eventType + 1
				        else
				            GlobalEventSystem:dispatchEvent(BagEvent.BODY_EQUIP_CHANGE)
				        end
			    		takeOff = true
			    		break
			    	end
			    end
			    if not takeOff then	
			    	--如果不是从身上脱下来的装备,需要看是否可以穿并且能提高战斗力,如果能提高战斗力,显示穿戴提示
			    	--还没进入主场景时不显示
			    	if EquipUtil.getEquipCanUse(item.is_use) and GlobalController.curScene == SCENE_MAIN and EquipUtil.checkPutonEquipPromote(item) then
			    		local putonTips = import("app.modules.bag.view.putOnTips").new()
			    		putonTips:setData(item)
			    		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,putonTips)  
			    	end
			    	--如果不是从身上脱下来的装备,提示获得某物品
			    	SystemNotice:popGetItemsTips(item)
			    end
			    if noNotifyEvent then
					eventType = eventType + 2
				else
					GlobalEventSystem:dispatchEvent(BagEvent.CHANGE_EQUIP_TO_BAG)
				end
			else
				--如果在装备背包里没找到,并且又不是脱下装备,那么就是改变身上装备的属性
				if item.goods_id == 309000 or item.goods_id == 309200 or item.goods_id == 309400 then --GlobalController.wingUp:isTempWing(item) then
					GlobalWinManger:openWin(WinName.WEARTEMPORARYWINGVIEW,item)
				end
				local added = false
				for i=1,#equipList do
			    	if equipList[i].id == item.id then
			    		--身上的装备信息改变了
			    		equipList[i] = item
			    		--roleManager.roleInfo.equip = equipList
			    		added = true
			    		break
			    	end
			    end

			    --保存坐骑id
				if item.grid == 15 then
					roleManager.roleInfo.rideInfo = item
					GlobalEventSystem:dispatchEvent(RoleEvent.UPDATE_RIDE_INFO)
				end

			    if not added then
			    	table.insert(equipList, item)
			    end
			    if  noNotifyEvent then
				    eventType = eventType + 1
				else
				    GlobalEventSystem:dispatchEvent(BagEvent.BODY_EQUIP_CHANGE)
				end
			end
		end
	elseif goodType == 3 then 		--宝石
		local pos = self:findItemInGemBag(item)
		if pos then
			if item.num == 0 then
				table.remove(self.items[3],pos)
				table.remove(self.total,goodPos)
			else
				--数量增加,提示获得某物品
				local oldItem = self.items[3][pos]
				if item.num - oldItem.num > 0 then
					oldItem.num = item.num - oldItem.num
					SystemNotice:popGetItemsTips(oldItem)
				end
				self.items[3][pos] = item
				if goodPos then
					self.total[goodPos] = item
				end
			end
		else
			table.insert(self.items[3],item)
			table.insert(self.total,item)
			--添加宝石,提示获得某物品
			SystemNotice:popGetItemsTips(item)
		end
	end
    return eventType
	--self:sortEquipBag()

end

function BagInfo:findItemInEquipBag(item)
	for i=1,#self.items[2] do
		if item.id == self.items[2][i].id then
			return i
		end
	end
	return nil
end

function BagInfo:findItemInPropBag(item)
	for i=1,#self.items[1] do
		if item.id == self.items[1][i].id then
			return i
		end
	end
	return nil	
end

function BagInfo:findItemInGemBag(item)
	for i=1,#self.items[3] do
		if item.id == self.items[3][i].id then
			return i
		end
	end
	return nil	
end

function BagInfo:findItemInBag(item)
	for i=1,#self.total do
		if item.id == self.total[i].id then
			return i
		end
	end
	return nil	
end

function BagInfo:findCangBaoTu()
	for i=1,#self.items[1] do
		if self.items[1][i].goods_id == 110223 then
			return self.items[1][i]
		end
	end
end

function BagInfo:findItemCountByItemId(itemId)
	-- local configHelper = import("app.utils.ConfigHelper").getInstance()
	local goodType = configHelper:getGoodTypeByGoodId(itemId)
	local itemCount = 0
	if goodType == 1 or goodType == 4 or goodType == 6 or goodType == 7 then 			--道具
		for i=1,#self.items[1] do
			if self.items[1][i].goods_id == itemId then
				itemCount = itemCount + self.items[1][i].num
			end
		end
	elseif goodType == 2 then 		--装备
		for i=1,#self.items[2] do
			if self.items[2][i].goods_id == itemId then
				itemCount = itemCount + self.items[2][i].num
			end
		end
	elseif goodType == 3 then 		--宝石
		for i=1,#self.items[3] do
			if self.items[3][i].goods_id == itemId then
				itemCount = itemCount + self.items[3][i].num
			end
		end
	end
	return itemCount
end

function BagInfo:deleteItemById(id,needSort)

	local goodPos = self:findItemInBag({id = id})
	if goodPos then
		table.remove(self.total,goodPos)
		if needSort then
			self:sortEquipBag(self.total)
		end
	end

	if self:findItemInPropBag({id = id}) then
		local pos = self:findItemInPropBag({id = id})
		table.remove(self.items[1],pos)

		if needSort then
		self:sortEquipBag(self.items[1])
		end
	elseif self:findItemInEquipBag({id = id}) then
		local pos = self:findItemInEquipBag({id = id})
		table.remove(self.items[2],pos)
		if needSort then
		self:sortEquipBag(self.items[2])
		end
	elseif self:findItemInGemBag({id = id}) then
		local pos = self:findItemInGemBag({id = id})
		table.remove(self.items[3],pos)
		if needSort then
		self:sortEquipBag(self.items[3])
		end
	end

	
end

function BagInfo:batchDeleteItem(itemIdList)
	for i=1,#itemIdList do
		self:deleteItemById(itemIdList[i],i==#itemIdList)
	end
end

function BagInfo:clear()
	self.items = {}
	self.items[1] = {}			--道具表
	self.items[2] = {}			--装备表
	self.items[3] = {}			--宝石表

	self.total = {}

	self.firstSort = false
	self.autoSort = true
end

-- function BagInfo:initEquipCommonItems()
-- 	for i=1,#self.items[2] do
-- 		local commonItem = CommonItemCell.new()
-- 		commonItem:setData(self.items[2][i])
-- 		self.commonItems[2][i] = commonItem
-- 		commonItem:retain()
-- 	end
-- end

-- function BagInfo:initPropCommonItems()
-- 	for i=1,#self.items[1] do
-- 		local commonItem = CommonItemCell.new()
-- 		commonItem:setData(self.items[1][i])
-- 		self.commonItems[1][i] = commonItem
-- 		commonItem:retain()
-- 	end
-- end

-- function BagInfo:initGemCommonItems()
-- 	for i=1,#self.items[3] do
-- 		local commonItem = CommonItemCell.new()
-- 		commonItem:setData(self.items[3][i])
-- 		self.commonItems[3][i] = commonItem
-- 		commonItem:retain()
-- 	end
-- end

-- function BagInfo:getEquipCommonItems()
-- 	return self.commonItems[2]
-- end

