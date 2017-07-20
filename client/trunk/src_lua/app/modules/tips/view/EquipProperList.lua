--
-- Author: Yi hanneng
-- Date: 2016-03-23 15:45:28
--
local EquipProperList = EquipProperList or class("EquipProperList", function() return display.newNode() end )

function EquipProperList:ctor()
	self.Height = 0
	self:setAnchorPoint(0,1)
end

function EquipProperList:setViewInfo(data)
 
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    local bodyEquip = roleInfo.equip
    local subTypeName,subType = configHelper:getEquipTypeByEquipId(data.goods_id)
--洗炼属性
	local validAttr = data.baptize_attr_list
    local showAttr = EquipUtil.showBaptizeAttrFormat(validAttr)

  	local colorArr = {}
  	local per = 0
  	local leftPos = 30
  	local rightPos = 140

  	local quality = configHelper:getGoodQualityByGoodId(data.goods_id)
  	local baptizeNum = configHelper:getEquipBaptizeNumByQuality(quality)
 
  	if validAttr then
  		for i=1,#validAttr do
   			per = validAttr[i].value/configHelper:getEquipBaptizeMaxById(validAttr[i].key)*100
  			if per <= 30 then
  				table.insert(colorArr, TextColor.TEXT_W)
  			elseif per > 30 and per <= 60 then
  				table.insert(colorArr, TextColor.TEXT_G)
  			elseif per > 60 and per <= 80 then
  				table.insert(colorArr, TextColor.TEXT_B)
  			elseif per > 80 and per <= 100 then
  				table.insert(colorArr, TextColor.TEXT_P)
  			end
  		end
  	end

    if #showAttr > 0 and quality > 1 then
  	
    	--洗炼属性
    	for i=1,#showAttr do
    
	        local labAttrName = self:createTxtItem(showAttr[i][1]..":", colorArr[i])
	        labAttrName:setPosition(leftPos, self.Height)
	        self:addChild(labAttrName)
	        self.Height = self.Height + labAttrName:getContentSize().height

	        local str
	        if showAttr[i].max then
	            str = "+ ("..showAttr[i].min.."-"..showAttr[i].max..")"
	        else
	            str = "+"..showAttr[i].min
	        end
	        if TextColor.TEXT_P == colorArr[i] then
                str = str.."(极品)"
            end
	        local labCurValue = self:createTxtItem(str, colorArr[i])
	        labCurValue:setString(str)
	        labCurValue:setPosition(rightPos, labAttrName:getPositionY())
	        self:addChild(labCurValue)
    	end

    	if baptizeNum > #showAttr then
    		for i=#showAttr+1,baptizeNum do
    			local labAttrName = self:createTxtItem("[可洗炼]", cc.c3b(0, 255, 0))
			    labAttrName:setPosition(leftPos, self.Height)
			    self:addChild(labAttrName)
			    self.Height = self.Height + labAttrName:getContentSize().height
    		end
    	end

    	--洗炼标题
    	local xlTitle = self:createTxtItem("洗炼属性:", cc.c3b(240, 147, 24))
    	self:addChild(xlTitle)
    	xlTitle:setPosition(0, self.Height)
    	self.Height = self.Height + xlTitle:getContentSize().height

    elseif quality > 1 and configHelper:getEquipCanBaptizeBySubType(subType) then

    	if baptizeNum > 0 then
    		for i=1,baptizeNum do
    			local labAttrName = self:createTxtItem("[可洗炼]", cc.c3b(0, 255, 0))
			    labAttrName:setPosition(leftPos, self.Height)
			    self:addChild(labAttrName)
			    self.Height = self.Height + labAttrName:getContentSize().height
    		end
    	end
    	--[[
    	local labAttrName = self:createTxtItem("未洗炼", cc.c3b(0, 255, 0))
	    labAttrName:setPosition(leftPos, self.Height)
	    self:addChild(labAttrName)
	    self.Height = self.Height + labAttrName:getContentSize().height
		--]]
	    local xlTitle = self:createTxtItem("洗炼属性:", cc.c3b(240, 147, 24))
    	self:addChild(xlTitle)
    	xlTitle:setPosition(0, self.Height)
    	self.Height = self.Height + xlTitle:getContentSize().height
    else

    	local labAttrName = self:createTxtItem("不可洗炼", cc.c3b(0, 255, 0))
	    labAttrName:setPosition(leftPos, self.Height)
	    self:addChild(labAttrName)
	    self.Height = self.Height + labAttrName:getContentSize().height
	 
	    local xlTitle = self:createTxtItem("洗炼属性:", cc.c3b(240, 147, 24))
    	self:addChild(xlTitle)
    	xlTitle:setPosition(0, self.Height)
    	self.Height = self.Height + xlTitle:getContentSize().height
    end

    --套装属性

	local suit_id = configHelper:getSuitIdByGoodId(data.goods_id)
	local tempArr = {}
	local tempShowArr = {}
	if suit_id ~= nil and suit_id > 0 then 

		function findById(id,arr)

			for i=1,#arr do
				if id == arr[i] then
					return true
				end
			end
			return false
		end

		function find(id)
			for j=1,#bodyEquip do
				if id == bodyEquip[j].goods_id and not findById(bodyEquip[j].id,tempArr) then
					table.insert(tempArr, bodyEquip[j].id)
					return true
				end
			end

			return false
		end

		function findShow(id)
			for j=1,#bodyEquip do
				if id == bodyEquip[j].goods_id and not findById(bodyEquip[j].id,tempShowArr) then
					table.insert(tempShowArr, bodyEquip[j].id)
					return true
				end
			end

			return false
		end

		local suitConfig = configHelper:getSuitArr(suit_id)
		local suitArr
		local hasNum = 0
		local suitName 

		if suitConfig then

			suitArr = suitConfig.goods
			suitName = suitConfig.name
			for i=1,#suitArr do
				if find(suitArr[i]) then
					hasNum = hasNum + 1
				end
			end
		else
			print("================>策划没配该套装信息:"..suit_id)
		end
 
		local suitTypeArr  = configHelper:getSuitProperById(suit_id)
		local suitType = 0
 
	 	if suitTypeArr then

			for i=1,#suitTypeArr do
				if hasNum >= suitTypeArr[i].count then
					suitType = suitType + 1					
				end		
			end

		else
			print("================>策划没配该套装件套属性信息:"..suit_id)
		end
		if #suitTypeArr > 0 then
			--已满足具体套装要求属性
			local color
			for i=#suitTypeArr,1,-1 do
				if i <= suitType then
					color = cc.c3b(0, 255, 0)
				else
					color = cc.c3b(112, 112, 112)
				end
				local showAttr = self:handlerData(suitTypeArr[i])
		    	for j = #showAttr,1,-1 do
		    		local labAttrName = self:createTxtItem(showAttr[j].name, color)
			        labAttrName:setPosition(leftPos, self.Height)
			        self:addChild(labAttrName)
			        self.Height = self.Height + labAttrName:getContentSize().height
 
			        local labCurValue = self:createTxtItem(showAttr[j].value, color)
			        labCurValue:setPosition(rightPos, labAttrName:getPositionY())
			        self:addChild(labCurValue)
		    	end

		    	local suitTitle = self:createTxtItem("装备"..suitTypeArr[i].count..":件", color)
		    	self:addChild(suitTitle)
		    	suitTitle:setPosition(0, self.Height)
				self.Height = self.Height + suitTitle:getContentSize().height
			end
	    		    	 
		end
		--套装配件
    	for i=1,#suitArr do
    		local equipName = self:createTxtItem(configHelper:getGoodNameByGoodId(suitArr[i]), (findShow(suitArr[i]) and cc.c3b(0, 255, 0)) or cc.c3b(112, 112, 112))
	    	self:addChild(equipName)
	    	equipName:setPosition(leftPos, self.Height)
	    	self.Height = self.Height + equipName:getContentSize().height
    	end

    	local suitTitle = self:createTxtItem(suitName.."("..hasNum.."/"..#suitArr..")", cc.c3b(240, 147, 24))
    	self:addChild(suitTitle)
    	suitTitle:setPosition(0, self.Height)
    	self.Height = self.Height + suitTitle:getContentSize().height

	end

--诅咒
 
 	if data.luck and data.luck < 0 and subType == 1 then
		local zzTitle = self:createTxtItem("诅咒", cc.c3b(240, 147, 24))
		local zzValue = self:createTxtItem(math.abs(data.luck), cc.c3b(0, 255, 0))
		self:addChild(zzTitle)
		self:addChild(zzValue)
		zzTitle:setPosition(0, self.Height)
		zzValue:setPosition(rightPos, zzTitle:getPositionY())
		self.Height = self.Height + zzTitle:getContentSize().height
	end


--幸运
	if data.luck and data.luck > 0  and subType == 1 then
		local luckTitle = self:createTxtItem("幸运", cc.c3b(240, 147, 24))
		local luckValue = self:createTxtItem(math.abs(data.luck), cc.c3b(0, 255, 0))
		self:addChild(luckTitle)
		self:addChild(luckValue)
		luckTitle:setPosition(0, self.Height)
		luckValue:setPosition(rightPos, luckTitle:getPositionY())
		self.Height = self.Height + luckTitle:getContentSize().height
	end

	if data.expire_time and data.expire_time > 0 then
		local luckTitle = self:createTxtItem("到期时间:", cc.c3b(0, 255, 0))
		local luckValue = self:createTxtItem(os.date("%Y年%m月%d日%H时%M分",data.expire_time), cc.c3b(0, 255, 0))
		self:addChild(luckTitle)
		self:addChild(luckValue)
		luckTitle:setPosition(0, self.Height)
		luckValue:setPosition(rightPos-20, luckTitle:getPositionY())
		self.Height = self.Height + luckTitle:getContentSize().height
	end
 	
    self:setContentSize(cc.size(500, self.Height))

end

function EquipProperList:setRideInfo(data)

	if data == nil then
		return
	end
 
 	local leftPos = 30
  	local rightPos = 150
	local info = configHelper:getEquipConfigByEquipId(data.goods_id)
	local color = cc.c3b(0, 255, 0)
 
	local showAttr = self:handlerRideData(info)

	for j = #showAttr,1,-1 do
		local labAttrName = self:createTxtItem(showAttr[j].name, cc.c3b(231, 211, 173))
		labAttrName:setPosition(leftPos, self.Height)
		self:addChild(labAttrName)
		self.Height = self.Height + labAttrName:getContentSize().height
 
		local labCurValue = self:createTxtItem(showAttr[j].value, cc.c3b(0, 255, 0))
		labCurValue:setPosition(rightPos, labAttrName:getPositionY())
		self:addChild(labCurValue)
	end

	self:setContentSize(cc.size(500, self.Height))
 
end

function EquipProperList:createTxtItem(str,color)
	return cc.ui.UILabel.new({text = str, size = 18, color = color})
end

function EquipProperList:handlerData(data)

	local tem = {}
	if data.hp and data.hp > 0 then
		table.insert(tem, {name = "生命:", value = data.hp})
	end

	if data.mp and data.mp > 0 then
		table.insert(tem, {name = "魔法:", value = data.mp})
	end

	if data.max_ac and data.max_ac > 0 then
		table.insert(tem, {name = "物理攻击:", value = data.min_ac.."-"..data.max_ac})
	end

	if data.max_mac and data.max_mac > 0 then
		table.insert(tem, {name = "魔法攻击:", value = data.min_mac.."-"..data.max_mac})
	end

	if data.max_sc and data.max_sc > 0 then
		table.insert(tem, {name = "道术攻击:", value = data.min_sc.."-"..data.max_sc})
	end

	if data.max_def and data.max_def > 0 then
		table.insert(tem, {name = "物理防御:", value = data.min_def.."-"..data.max_def})
	end

	if data.max_res and data.max_res > 0 then
		table.insert(tem, {name = "魔法防御:", value = data.min_res.."-"..data.max_res})
	end

	return tem
 
end


function EquipProperList:handlerRideData(data)

	local tem = {}
	
	if data.speed > 0 then
		table.insert(tem, {name = "移动速度：", value = (data.speed).."%"})
	end
	
	if data.hp and data.hp_p > 0 then
		table.insert(tem, {name = "生命(基础):", value = (data.hp_p/100).."%"})
	end

	if data.mp and data.mp_p > 0 then
		table.insert(tem, {name = "魔法(基础):", value = (data.mp_p/100).."%"})
	end

	if data.max_ac and data.max_ac_p > 0 then
		table.insert(tem, {name = "物理攻击(基础):", value = (data.max_ac_p/100).."%"})
	end

	if data.max_mac and data.max_mac_p > 0 then
		table.insert(tem, {name = "魔法攻击(基础):", value = (data.max_mac_p/100).."%"})
	end

	if data.max_sc and data.max_sc_p > 0 then
		table.insert(tem, {name = "道术攻击(基础):", value = (data.max_sc_p/100).."%"})
	end

	if data.max_def and data.max_def_p > 0 then
		table.insert(tem, {name = "物理防御(基础):", value = (data.max_def_p/100).."%"})
	end

	if data.max_res and data.max_res_p > 0 then
		table.insert(tem, {name = "魔法防御(基础):", value = (data.max_res_p/100).."%"})
	end

	return tem
 
end

return EquipProperList