--
-- Author: Yi hanneng
-- Date: 2016-01-19 18:15:02
--

--[[
						装备强化
--]]
--[[
close：关闭
equip1：放入装备
goods1-5：放入道具
alladd：一键加入
strengthen：强化
rate：强化成功率
lv：强化等级
lvnumber：当前强化等级
addlv：增加强化等级
ac：属性1
acnumber：当前属性1的数值
acadd：强化属性1增加的数值
mac：属性2
macnumber：当前属性2的数值
macadd：强化属性2增加的数值
sc：属性3
scnumber：当前属性3的数值
scadd：强化属性3增加的数值
rule：打开后是规则界面，目前还没有
neednumber：消耗金币
nownumber：当前金币，金币不足，使用红色。
规则
1.	强化可以提高基础属性。
2.	强化+1到+10需要消耗黑铁矿，强化+11到+20需要消耗紫水晶，强化+21到+30需要消耗玄冰铁。
3.	所用材料等级越高，所增加的强化成功率越高。
4.	强化失败只会消耗强化材料，不会有其他损失。
--]]

local EquipStrengView = EquipStrengView or class("EquipStrengView", BaseView)

function EquipStrengView:ctor(winTag,data,winconfig)
  	EquipStrengView.super.ctor(self,winTag,data,winconfig)
  	local root = self:getRoot()
  	self.currentEquipId = nil
  	self.currentClickGoodsIndex = 0

  	--背包道具列表
  	self.temGoodsList = {}
  	--对应强化等级的强化道具列表
  	self.fitGoodsList = {}
  	--背包里属于强化列表的道具列表
  	self.goodsList = {}
   
  	self.equip1 = self:seekNodeByName("equip1") 
  	self.equipped = self:seekNodeByName("equipped")

  	self.goods1 = self:seekNodeByName("goods1")
  	self.goods2 = self:seekNodeByName("goods2")
  	self.goods3 = self:seekNodeByName("goods3")
  	self.goods4 = self:seekNodeByName("goods4")
  	self.goods5 = self:seekNodeByName("goods5")

    self.Label_34 = self:seekNodeByName("Label_34")

  	self.rate = self:seekNodeByName("rate")
  	self.lv = self:seekNodeByName("lv")
 
  	self.lvnumber = self:seekNodeByName("lvnumber")
  	self.addlv = self:seekNodeByName("addlv")

  	self.neednumber = self:seekNodeByName("neednumber")
  	self.nownumber = self:seekNodeByName("nownumber")
  	
  	self.labAttr1 = self:seekNodeByName("ac")
  	self.labAttrValue1 = self:seekNodeByName("acnumber")
  	self.labAttrAdd1 = self:seekNodeByName("acadd")

  	self.labAttr2 = self:seekNodeByName("mac")
  	self.labAttrValue2 = self:seekNodeByName("macnumber")
  	self.labAttrAdd2 = self:seekNodeByName("macadd")

  	self.labAttr3 = self:seekNodeByName("sc")
  	self.labAttrValue3 = self:seekNodeByName("scnumber")
  	self.labAttrAdd3 = self:seekNodeByName("scadd")

  	self.rule = self:seekNodeByName("rule")
  	self.alladd = self:seekNodeByName("alladd")
  	self.strengBtn = self:seekNodeByName("strengthen")
  	self.common = self:seekNodeByName("common")
  	self.attribute = self:seekNodeByName("attribute")

  	--祝福
  	self.bless = self:seekNodeByName("bless")
  	self.progress_2 = self:seekNodeByName("progress_2")
  	self.wish_number = self:seekNodeByName("wish_number")
    self.bless_vip = self:seekNodeByName("bless_vip")
    self.bless_full = self:seekNodeByName("bless_full")
    
  	self.equipped:setVisible(false)
  	self.common:setVisible(true)
  	self.attribute:setVisible(false)
  	self.rate:setString("0%")

  	self:addEvent()
end
--设置界面信息
function EquipStrengView:setViewInfo(data)
	data = data.data
  self.bless_full:setVisible(false)
  self.rate:setVisible(true)
  self.Label_34:setVisible(true)
	if data.type == 1 then
		self.common:setVisible(false)
		self.attribute:setVisible(true)
		if self.equip1:getChildByTag(10) then
			self.equip1:removeChildByTag(10, true)
		end

		for i=1,5 do
      local item = self["goods"..i]:getChildByTag(10)
			if item then
			local info = item:getData()
			self.goodsList[info.goods_id].num = self.goodsList[info.goods_id].num + 1
			self["goods"..i]:removeChildByTag(10, true)
			end
		end

		local commonItem = CommonItemCell.new()
		commonItem:setData(data)
		
		self.equip1:addChild(commonItem, 10,10)
		commonItem:setItemClickFunc(handler(self,self.equipClick))
		commonItem:setPosition(self.equip1:getContentSize().width/2, self.equip1:getContentSize().height/2)
		--commonItem:setScale(0.9)
		self.lvnumber:setString(data.stren_lv)
		self.equipped:setVisible(data.location == 1)
    commonItem:setNameShow(true)
		-------

		local equipSubType = configHelper:getGoodSubTypeByGoodId(data.goods_id)


--      设置界面属性

		for i=1,3 do
	        self["labAttr"..i]:setVisible(false)
	        self["labAttrValue"..i]:setVisible(false)
	        self["labAttrAdd"..i]:setVisible(false)
    	end
 
    	local validAttr = configHelper:getStengPlusStrengLv(data.stren_lv+1, equipSubType)
    	local equipItem = configHelper:getEquipValidAttrByEquipId(data.goods_id)
 	 
    	local num = #equipItem/2

		 if #equipItem%2 > 0 then
            --生命
            self["labAttr"..1]:setVisible(true)
            self["labAttr"..1]:setString(self:getName(equipItem[1][1]))
            self["labAttrValue"..1]:setVisible(true)
            if validAttr ~= nil then
        
                if validAttr[equipItem[1][1]] and validAttr[equipItem[1][1]] > 0  then
                self["labAttrValue"..1]:setString(equipItem[1][2])
                self["labAttrAdd"..1]:setVisible(true)
                self["labAttrAdd"..1]:setString(" + ("..validAttr[equipItem[1][1]]..")")
                else
                self["labAttrValue"..1]:setString(equipItem[1][2])
                end
                --validAttr[equipItem[1][1]] = nil
            else
                self["labAttrValue"..1]:setString(equipItem[1][2])
            end

            
            table.remove(equipItem,1)

            if validAttr ~= nil then
                 for i=1,num do
                 	if self["labAttr"..(i+1)] then
	                self["labAttr"..(i+1)]:setVisible(true)
	                self["labAttr"..(i+1)]:setString(self:getName(equipItem[i*2 - 1][1]))
	                self["labAttrValue"..(i+1)]:setVisible(true)
                    if validAttr[equipItem[i*2][1]] > 0  then
                        self["labAttrValue"..(i+1)]:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                    	self["labAttrAdd"..(i+1)]:setVisible(true)
                		self["labAttrAdd"..(i+1)]:setString(" + ("..validAttr[equipItem[i*2 - 1][1]].."-"..validAttr[equipItem[i*2][1]]..")")
                    else
                        self["labAttrValue"..(i+1)]:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                    end
                end
                end
            else
                for i=1,num do
                	if self["labAttr"..(i+1)] then
                		self["labAttr"..(i+1)]:setVisible(true)
		                self["labAttr"..(i+1)]:setString(self:getName(equipItem[i*2 - 1][1]))
		                self["labAttrValue"..(i+1)]:setVisible(true)
		                self["labAttrValue"..(i+1)]:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                	end     
                end
            end

        else

            if validAttr ~= nil then
                 for i=1,num do

                self["labAttr"..i]:setVisible(true)
                self["labAttr"..i]:setString(self:getName(equipItem[i*2 - 1][1]))
                self["labAttrValue"..i]:setVisible(true)
                    if validAttr[equipItem[i*2][1]] > 0  then
                        self["labAttrValue"..i]:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                    	self["labAttrAdd"..i]:setVisible(true)
                		self["labAttrAdd"..i]:setString(" + ("..validAttr[equipItem[i*2 - 1][1]].."-"..validAttr[equipItem[i*2][1]]..")")
                    else
                        self["labAttrValue"..i]:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                    end
                end
            else
                for i=1,num do

                self["labAttr"..i]:setVisible(true)
                self["labAttr"..i]:setString(self:getName(equipItem[i*2 - 1][1]))
                self["labAttrValue"..i]:setVisible(true)
                self["labAttrValue"..i]:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
     
                end
            end

        end
-----设置当前金币、需要金币
		local roleManager = RoleManager:getInstance()
        local wealthInfo = roleManager.wealth

        self.nownumber:setString(wealthInfo.coin or 0)
 
        local needMoney = configHelper:getStrengCByEquipId(data.stren_lv+1)
         
        if needMoney then
          	self.neednumber:setString(needMoney.coin)
          	 --设置祝福值
          if needMoney.max_bless > 0 and roleManager.roleInfo.vip >= 8 then
          	self.bless:setVisible(true)
  	  			self.progress_2:setPercent(math.min(data.bless/needMoney.max_bless*100,100))
  	  			self.wish_number:setString(math.min(data.bless,needMoney.max_bless).."/"..needMoney.max_bless)
            if math.min(data.bless/needMoney.max_bless*100,100) == 100 then
               self.bless_full:setVisible(true)
               self.bless:setVisible(false)
               self.rate:setVisible(false)
               self.Label_34:setVisible(false)
            end
  	  		else
  	  			self.bless:setVisible(false)
            self.bless_full:setVisible(false)
            self.rate:setVisible(true)
            self.Label_34:setVisible(true)
          end
          	
        else
          	self.neednumber:setString(0)
          	self.bless:setVisible(false)
            self.bless_full:setVisible(false)
        end

        if roleManager.roleInfo.vip < 8 and needMoney.max_bless > 0 then
          self.bless_vip:setVisible(true)
        else
          self.bless_vip:setVisible(false)
        end
        

        self.fitGoodsList = configHelper:getStrenGoodsList(data.stren_lv + 1)
        self:getGoodsList(data.stren_lv + 1)
        
       
 
   

	elseif data.type == 2 then
    local item = self["goods"..data.from]:getChildByTag(10)
		if item then
			local info = item:getData()
			self.goodsList[info.goods_id].num = self.goodsList[info.goods_id].num + 1
			self["goods"..data.from]:removeChildByTag(10, true)
		end

		self.goodsList[data.goods_id].num = self.goodsList[data.goods_id].num - 1

		local commonItem = CommonItemCell.new()
		commonItem:setData(data)
		self["goods"..data.from]:addChild(commonItem,10,10)
		commonItem:setItemClickFunc(handler(self,self.onItemClick))
		commonItem:setPosition(self["goods"..data.from]:getContentSize().width/2, self["goods"..data.from]:getContentSize().height/2)
		--commonItem:setScale(0.81)
	end

 	self:sumRate()
end
 
function EquipStrengView:addEvent()
 
	for i=1,5 do
		self["goods"..i]:setTouchEnabled(true)
		self["goods"..i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
        	self.currentClickGoodsIndex = i
          	self:goodsClick(i)
        end     
        return true
    	end)
	end

	self.equip1:setTouchEnabled(true)
    self.equip1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:equipClick() 
            -- GUIDE CONFIRM
            GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_STRENG_OP_SEL)
        end     
        return true
    end)

    self.alladd:setTouchEnabled(true)
    self.alladd:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.alladd:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.alladd:setScale(1.0)
           	if self.equip1:getChildByTag(10) then
           		  self:handlerGoodsList()
                -- GUIDE CONFIRM
                GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_STRENG_OP_ADD_ALL)
			      else
				       GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请放入需要强化的物品!")
			      end
        end     
        return true
    end)

    self.strengBtn:setTouchEnabled(true)
    self.strengBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.strengBtn:setScale(1.1)
            SoundManager:playClickSound()
            -- GUIDE CONFIRM
            GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_STRENG_OP_STRENG)
        elseif event.name == "ended" then
            self.strengBtn:setScale(1.0)

		 	local id = 0
		 	local lv = 0
		 	if self.equip1:getChildByTag(10) then
				local item = self.equip1:getChildByTag(10)
				id = item:getData().id
				self.currentEquipId = id
				lv = item:getData().stren_lv + 1
			end
			local list = {}
			local rate = 0
			for i=1,5 do
				if self["goods"..i]:getChildByTag(10) then
					local item = self["goods"..i]:getChildByTag(10)
					local info = item:getData()
					table.insert(list,info.goods_id) 
					rate = rate + configHelper:getStrenRate(info.goods_id,lv)
				end
			end

			if rate > 10000 then

				local enterFun = function()
					GameNet:sendMsgToSocket(14024, {id = id,goods_list = list})
				end
				local tipTxt  = "所放入材料的成功率溢出,会有一定程度的浪费,确认强化吗？"
          		
            	GlobalMessage:alert({
	                enterTxt = "确定",
	                backTxt= "取消",
	                tipTxt = tipTxt,
	          		enterFun = handler(self, enterFun),
	                tipShowMid = true,
            	})
            else
            	if rate == 0 then
            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请放入强化道具!")
            	else
            	GameNet:sendMsgToSocket(14024, {id = id,goods_list = list})
            	end
			end

           	
        end     
        return true
    end)

    self.rule:setTouchEnabled(true)
    self.rule:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.rule:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.rule:setScale(1.0)
 
            	 GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(1),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)
end

function EquipStrengView:equipClick()
	local bodylist = {}
	local baglist = {}
	local body = RoleManager:getInstance().roleInfo.equip
	local bag = BagManager:getInstance().bagInfo:getEquipList()

	for i=1,#body do
		if body[i].stren_lv < 40 and configHelper:getGoodTimeLinessByGoodId(body[i].goods_id) ~= 1 then
			table.insert(bodylist, body[i])
		end
	end

	for j=1,#bag do
		if bag[j].stren_lv < 40 and configHelper:getGoodTimeLinessByGoodId(bag[j].goods_id) ~= 1  then
			table.insert(baglist, bag[j])
		end
	end
	local selectItemsWin = require("app.modules.equip.view.SelectItemsWin").new({name = "选择装备",type = 1,from = 1, bodyEquiplist = bodylist,bagEquipList = baglist})--
  	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,selectItemsWin) 
end
--移除道具
function EquipStrengView:onItemClick(item)
 	if not item then return end
	local info = item:getData()
	self.goodsList[info.goods_id].num = self.goodsList[info.goods_id].num + 1
	item:removeSelf()
 	self:sumRate()
end

function EquipStrengView:goodsClick(index)
	local selectItemsWin = require("app.modules.equip.view.SelectItemsWin").new({name = "选择道具",type = 2, from = index,bagEquipList = self.goodsList})
  	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,selectItemsWin)
end
 
function EquipStrengView:open()
	GlobalEventSystem:addEventListener(EquipEvent.SELECT_GOODS_SUCCESS,handler(self,self.setViewInfo))
	GlobalEventSystem:addEventListener(BagEvent.STRENG_SUCCESS,handler(self,self.strenSuccess))
	GlobalEventSystem:addEventListener(BagEvent.STRENG_FAIL,handler(self,self.strenFail))
	local list = BagManager:getInstance().bagInfo:getPropList()
	for i=1,#list do
		if not self.temGoodsList[list[i].goods_id] then
			self.temGoodsList[list[i].goods_id] = {goods_id = list[i].goods_id, num = list[i].num, id = list[i].id, is_bind = list[i].is_bind,location = list[i].location, stren_lv = list[i].stren_lv}
		else
			self.temGoodsList[list[i].goods_id].num = self.temGoodsList[list[i].goods_id].num + list[i].num
		end
	end
end

function EquipStrengView:close()
	GlobalEventSystem:removeEventListener(EquipEvent.SELECT_GOODS_SUCCESS)
	GlobalEventSystem:removeEventListener(BagEvent.STRENG_SUCCESS)
	GlobalEventSystem:removeEventListener(BagEvent.STRENG_FAIL)
end


function EquipStrengView:destory()
  self:close()
  self.super.destory(self)
end

--计算所有道具成功率和
function EquipStrengView:sumRate()

	local rate = 0
 	local lv = 0
 	if self.equip1:getChildByTag(10) then
		local item = self.equip1:getChildByTag(10)
		lv = item:getData().stren_lv + 1
	end

	for i=1,5 do
		if self["goods"..i]:getChildByTag(10) then
			local item = self["goods"..i]:getChildByTag(10)
			local info = item:getData()
			rate = rate + configHelper:getStrenRate(info.goods_id,lv)
		end
	end

	self.rate:setString(((rate/10000)*100).."%")

end

--处理对应的道具列表
function EquipStrengView:getGoodsList(lv)
	self.goodsList = {}
	for k,v in pairs(self.temGoodsList) do
		for j=1,#self.fitGoodsList do
			if v.goods_id ==  self.fitGoodsList[j] then
				self.goodsList[v.goods_id] = v
				self.goodsList[v.goods_id].rate = configHelper:getStrenRate(v.goods_id,lv)
			end
		end
	end
end

function EquipStrengView:findGoodsByRate(rate)
	for k,v in pairs(self.goodsList) do
		if rate == v.rate then
			return v
		end
	end
end
--一键放入道具

function EquipStrengView:handlerGoodsList()
 
	for i=1,5 do
		if self["goods"..i]:getChildByTag(10) then
			local item = self["goods"..i]:getChildByTag(10)
			local info = item:getData()
			self.goodsList[info.goods_id].num = self.goodsList[info.goods_id].num + 1
			self["goods"..i]:removeChildByTag(10, true)
		end
	end
 
	local tem = self:getList()
	local list = {}
	if not tem then
		return 
	end

	for i = 1, #tem do
		list[#list + 1] = self:findGoodsByRate(tem[i])
	end

	if #list > 0 then
 
		for i=1,#list do
			local info = list[i]
			info.type = 2
 			info.from = i
 			self:setViewInfo({data = info})
		end

	end

end

function EquipStrengView:getList()

	--处理列表并排序
	local list = {}
	local tem = {}
	local num = 5
	for k,v in pairs(self.goodsList) do
		num = v.num
		if num > 5 then
			num = 5
		end
		 for i=1,num do
		 	list[ #list + 1] = v.rate
		 end
	end
  if #list > 1 then
    table.sort(list,function (a,b) return a < b end)
  end
 	--情况处理
 	local sum = 0

 	for i=1,#list do
		sum = sum + list[i]
	end

	if sum < 10000 then

		if #list < 5 then
			return list
		else
			for i=#list,#list - 4,-1 do
				tem[#tem + 1] = i
			end
		end
	else
		--匹配到100%成功率
		tem = self:getEqualList(list,10000)
		if tem == nil then
			--匹配大于100%成功率
			tem = self:getGreaterList(list,10000)
			if tem == nil then
				tem = {}
				for i=#list,#list - 4,-1 do
					tem[#tem + 1] = i
				end
			else
				--匹配到大于100%成功率
				local sss = {}
				for i=1,#tem do
					sss[#sss + 1] = list[tem[i]]
				end
        if #sss > 1 then
          table.sort(sss,function (a,b) return a > b end)
        end
				local sum = 0
				local returnList = {}
				for i=1,#sss do

					sum = sum + sss[i]
					returnList[#returnList + 1] = sss[i]

					if sum >= 10000 then
				 		return returnList
					end
				end
			end
		end
	end

	if tem and #tem > 0 then
		local returnList = {}
		for i=1,#tem do
			returnList[#returnList + 1] = list[tem[i]]
		end
	
		return returnList
	end
 	
 	return nil

end

function EquipStrengView:getEqualList(list,rate)
	if not list then return end
	local len = #list
 	local find = false
 	if list[1] >=  rate then
 		find = true
 		return {1}
 	end
  	--五个
 	if len >= 5 and find == false then
	  	for i=1,len do
	  		for j=i+1,len do
	  			for k=j+1,len do
	  				local n,m = self:getEqualSum(list,rate - list[i] - list[j] - list[k], k+1)
	  				if n ~= -1 and m ~= -1 then
	  					find = true
			  			return {i,j,k,n,m}
		  			end
	  			end
	  		end
	  	end
  	end

  	--四个
  	if len >= 4 and find == false then
	  	for i=1,len do
	  		for j=i+1,len do
	  			local n,m = self:getEqualSum(list,rate - list[i] - list[j] , j+1)
	  			if n ~= -1 and m ~= -1 then
	  				find = true
	  				return {i,j,n,m}
	  			end
	  		end
	  	end
  	end

 	--三个
 	if len >= 3 and find == false then
 		for i=1,len do
	  		local n,m = self:getEqualSum(list,rate - list[i], i+1)
	  		if n ~= -1 and m ~= -1 then
	  			find = true
	  			return {i,n,m}
	  		end
  		end
 	end


  		--两个
  	if len >= 2 and find == false then
	 	local n,m  = self:getEqualSum(list, rate, 1)
	 	if n ~= -1 and m ~= -1 then
	 		find = true
	 		return {n,m} 
	 	elseif n ~= -1 then
	 		return {n}
	 	end
 	end
  	

  	return nil
end

function EquipStrengView:getGreaterList(list,rate)
	if not list then return end
	local len = #list
 	local find = false
 	if list[1] >=  rate then
 		find = true
 		return {1}
 	end
  	--五个
 	if len >= 5 and find == false then
	  	for i=1,len do
	  		for j=i+1,len do
	  			for k=j+1,len do
	  		 
	  				local n,m = self:getGreaterSum(list,rate - list[i] - list[j] - list[k],k+1)
		  			if n ~= -1 and m ~= -1 then
		  				find = true
				  		return {i,j,k,n,m}
			  		end
	  			 
	  				
	  			end
	  		end
	  	end
  	end

  	--四个
  	if len >= 4 and find == false then
	  	for i=1,len do
	  		for j=i+1,len do
	  			local n,m = self:getGreaterSum(list,rate - list[i] - list[j] , j+1)
			  	if n ~= -1 and m ~= -1 then
			  		find = true
			  		return {i,j,n,m}
			  	end
	  		end
	  	end
  	end


 	--三个
 	if len >= 3 and find == false then
 		for i=1,len do
	  		local n,m = self:getGreaterSum(list,rate - list[i], i+1)
		  	if n ~= -1 and m ~= -1 then
		  		find = true
		  		return {i,n,m}
		  	end
  		end
 	end

 	--两个
  	if len >= 2 and find == false then
	 	local n,m  = self:getGreaterSum(list, rate, 1)
	 	if n ~= -1 and m ~= -1 then
	 		find = true
	 		return {n,m} 
	 	elseif n ~= -1 then
	 		return {n}
	 	end
 	end
  	
  	return nil
end
 
function EquipStrengView:getEqualSum(list,sum,index)

	if not list or sum <= 0 then return -1,-1 end
	local j = #list
	if index >= j or sum == list[index] then
		return -1,-1
	end
 
	for i=index,#list do

		if list[i] == sum then
			return i
		end

		for j=i+1,#list do
			if (list[i] + list[j]) == sum then
				return i,j
			end
		end
	end
 
	return -1,-1
end

function EquipStrengView:getGreaterSum(list,sum,index)
	if not list or sum <= 0 then return -1,-1 end
	local j = 0

	if index >= #list or sum <= list[index] then
		return -1,-1
	end
 
	for i=1,#list do
		for j=i+1,#list do
			if (list[i] + list[j]) > sum then
				return i,j
			end
		end
	end
 
	return -1,-1
end

function EquipStrengView:getName(str)

	if str == "min_ac" then
		return "物理攻击:"
	elseif str == "min_def" then
		return "物理防御:"
	elseif str == "min_res" then
		return "魔法防御:"
	elseif str == "hp" then
		return "生命:"
	elseif str == "min_mac" then
		return "魔法攻击:"
	elseif str == "min_sc" then
		return "道术攻击:"
	end

end

--强化成功
function EquipStrengView:strenSuccess()

	self:reset()
	self:playStrengEffect()
end
--强化失败
function EquipStrengView:strenFail()
	self:reset()
end

function EquipStrengView:reset()
	if self.equip1:getChildByTag(10) then
		self.equip1:removeChildByTag(10, true)
	end

	for i=1,5 do
		if self["goods"..i]:getChildByTag(10) then
			self["goods"..i]:removeChildByTag(10, true)
		end
	end

	self.goodsList = {}
	self.temGoodsList = {}
	self.fitGoodsList = {}

	self.bless:setVisible(false)

	local list = BagManager:getInstance().bagInfo:getPropList()
	for i=1,#list do
		if not self.temGoodsList[list[i].goods_id] then
			self.temGoodsList[list[i].goods_id] = {goods_id = list[i].goods_id, num = list[i].num, id = list[i].id, is_bind = list[i].is_bind,location = list[i].location, stren_lv = list[i].stren_lv}
		else
			self.temGoodsList[list[i].goods_id].num = self.temGoodsList[list[i].goods_id].num + list[i].num
		end
	end
-- 自动把强化完的物品放上强化框
	local find = false
	local info = nil
	for i=1,#RoleManager:getInstance().roleInfo.equip do
		if RoleManager:getInstance().roleInfo.equip[i].id ==  self.currentEquipId then
			find = true
			info = RoleManager:getInstance().roleInfo.equip[i]
			break
		end
	end

	if not find then
		for i=1,#BagManager:getInstance().bagInfo:getEquipList() do
		if BagManager:getInstance().bagInfo:getEquipList()[i].id ==  self.currentEquipId then
			find = true
			info = BagManager:getInstance().bagInfo:getEquipList()[i]
			break
		end
		end
	end
	
	if info and info.stren_lv < 40 then
		info.type = 1
 		info.from = 1
 		self:setViewInfo({data = info})

 	else
 		local roleManager = RoleManager:getInstance()
        local wealthInfo = roleManager.wealth
        self.nownumber:setString(wealthInfo.coin or 0)
        self.neednumber:setString(0)
	end
end

--播强化成功特效
function EquipStrengView:playStrengEffect()
    if self.streng then
        self.streng:getAnimation():play("effect")
        self.streng:setPosition(235,470)
        return
    end
    ArmatureManager:getInstance():loadEffect("qianghua")
    self.streng = ccs.Armature:create("qianghua")
    self.equip1:addChild(self.streng, 100,100)
    self.streng:setPosition(self.equip1:getContentSize().width/2,self.equip1:getContentSize().height/2)
    self.streng:stopAllActions()

    local function animationEvent(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
            armatureBack:getAnimation():setMovementEventCallFunc(function()end)
            --self:clearBuffEffectByID(buffEffId)
            self.streng:stopAllActions()
            self.streng:getAnimation():stop()      
            if self.streng:getParent() then
                self.streng:getParent():removeChild(self.streng)
            end 
            self.streng = nil
            ArmatureManager:getInstance():unloadEffect("qianghua")
        end
    end
    self.streng:getAnimation():setMovementEventCallFunc(animationEvent)
    self.streng:getAnimation():play("effect")
end

  --点击关闭按钮
function EquipStrengView:onClickCloseBtn()
    GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_WIN_CLOSE_BUTTON)--在关闭之前
    self.super.onClickCloseBtn(self)
end

return EquipStrengView