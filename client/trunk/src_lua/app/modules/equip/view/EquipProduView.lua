--
-- Author: Yi hanneng
-- Date: 2016-01-19 17:57:02
--
--[[
装备打造
--]]
--[[
目标装备：goalgoods
材料1：material1 materialname1
材料2：material2 materialname2
目标装备展示：goalgoods1 goodsname lv
属性1：labAttr1 labAttrValue1
属性2：labAttr2 labAttrValue2
属性3：labAttr3 labAttrValue3
金币消耗：coinnumber
打造按钮：production
关闭按钮：close
默认界面：artifactLayer1
正常界面：artifactMask1
--]]
require("app.modules.equip.EquipManager")
local EquipProduView = EquipProduView or class("EquipProduView", BaseView)

function EquipProduView:ctor(winTag,data,winconfig)
	EquipProduView.super.ctor(self,winTag,data,winconfig)
	local root = self:getRoot()
  	--root:setPosition((display.width-960)/2,(display.height-640)/2)
	self.itemList = {}
	self.subItemList = {}

	self.goalgoods = self:seekNodeByName("goalgoods")

  	self.goalgoods1 = self:seekNodeByName("goalgoods1")
  	self.goodsname = self:seekNodeByName("goodsname")
  	self.lv = self:seekNodeByName("lv")
 
  	self.coinnumber = self:seekNodeByName("coinnumber")
  	self.productionBtn = self:seekNodeByName("production")
  	self.closeBtn = self:seekNodeByName("close")
  	self.artifactLayer1 = self:seekNodeByName("artifactLayer1")
  	self.artifactMask1 = self:seekNodeByName("artifactMask1")

  	self.itemLayer1 = self:seekNodeByName("itemLayer1")
  	self.itemLayer2 = self:seekNodeByName("itemLayer2")
  	self.itemLayer3 = self:seekNodeByName("itemLayer3")
  	self.itemLayer4 = self:seekNodeByName("itemLayer4")
  	self.itemLayer5 = self:seekNodeByName("itemLayer5")

  	self.productionBtnLab = self:seekNodeByName("Label_155")

  	self.tipsLabel = self:seekNodeByName("tipsLabel")

  	self.artifactMask1:setVisible(false)
 	self.productionBtn:setVisible(false)

    self.productionBtn:setTouchEnabled(true)
  	self.productionBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.productionBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.productionBtn:setScale(1.0)
            if self.tip then
            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,self.tip)
            	return 
            end
            if self.currentKey then

            	local enterFun = function()
					GameNet:sendMsgToSocket(14031,{formula_id = self.currentKey})
           			self.currentKey = nil
           			self.currentGoodsLv = nil
				end

				local tipTxt  = ""

				if self.currentGoodsLv > RoleManager:getInstance().roleInfo.lv then
					tipTxt  = "本次打造会让装备超过人物等级，造成穿戴不能，是否继续打造。"
				elseif self.currentGoodsLv and self.needBodyEquip then
					tipTxt  = "本次打造身上装备会消失，替换成新的打造装备，并且强化等级全部继承，铸魂精华将用于新装备的铸魂升级，不足升级部分将进行返还，是否打造。"
				else
					enterFun()
					return
				end
				
				GlobalMessage:alert({
	                enterTxt = "确定",
	                backTxt= "取消",
	                tipTxt = tipTxt,
	          		enterFun = handler(self, enterFun),
	                tipShowMid = true,
            	})

            	--GameNet:sendMsgToSocket(14031,{formula_id = self.currentKey})
           		--self.currentKey = nil
            end
           	
        end     
        return true
    end)

	self.tag1 = self:seekNodeByName("tag1")
	--self.label1 = self:seekNodeByName("label1")
  	--self.label1:setString("特\n装\n合\n成")
  	self.select1 = self:seekNodeByName("select1")
  	self.tag2 = self:seekNodeByName("tag2")
  	--self.label2 = self:seekNodeByName("label2")
  	--self.label2:setString("特\n装\n合\n成")
  	self.select2 = self:seekNodeByName("select2")

  	self.tag1:setTouchEnabled(true)
  	self.tag1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            --self.tag1:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            --self.tag1:setScale(1.0)
            self:onTabClick(1)
        end     
        return true
    end)

    self.tag2:setTouchEnabled(true)
  	self.tag2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            --self.tag2:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            --self.tag2:setScale(1.0)
            self:onTabClick(2)
        end     
        return true
    end)

	if data == 1 then
 		self:createMenu(1)
 		self.tag1:setVisible(false)
 		self.tag2:setVisible(false)
	else
	 	self:createMenu(2)
	 	self:onTabClick(1)
	end
end

function EquipProduView:onTabClick(index)
	self.select1:setVisible(false)
	self.select2:setVisible(false)
	self["select"..index]:setVisible(true)

	self.listView1:setVisible(false)
	self.listView2:setVisible(false)
	self["listView"..index]:setVisible(true)

	if index == 1 then
		self.productionBtnLab:setString("打造")
	else
		self.productionBtnLab:setString("合成")
	end
end

function EquipProduView:createMenu(data)
	if data == 1 then
		self.listView1 = require("app.gameui.CQMenuList").new(cc.rect(0,0,172, 478),cc.ui.UIScrollView.DIRECTION_VERTICAL,172,50)
		self:getRoot():addChild(self.listView1)
		self.listView1:setPosition(16, 503 - self.listView1:getContentSize().height-15)
	 	self.menuDataList, self.subDatalist = EquipManager:getInstance():getEquipProduList(1)
		self.listView1:setData(self.menuDataList,self.subDatalist,require("app.modules.exChange.view.ExchangeMenuItem"))
		self.listView1:setItemClickFunc(handler(self, self.itemClick))
	else
		self.listView1 = require("app.gameui.CQMenuList").new(cc.rect(0,0,172, 478),cc.ui.UIScrollView.DIRECTION_VERTICAL,172,50)
		self:getRoot():addChild(self.listView1)
		self.listView1:setPosition(16, 503 - self.listView1:getContentSize().height-15)
	 	self.menuDataList, self.subDatalist = EquipManager:getInstance():getEquipProduList(2)
		self.listView1:setData(self.menuDataList,self.subDatalist,require("app.modules.exChange.view.ExchangeMenuItem"))
		self.listView1:setItemClickFunc(handler(self, self.itemClick))

		self.listView2 = require("app.gameui.CQMenuList").new(cc.rect(0,0,172, 478),cc.ui.UIScrollView.DIRECTION_VERTICAL,172,50)
		self:getRoot():addChild(self.listView2)
		self.listView2:setPosition(16, 503 - self.listView2:getContentSize().height-15)
	 	self.menuDataList2, self.subDatalist2 = EquipManager:getInstance():getEquipProduList(3)
		self.listView2:setData(self.menuDataList2,self.subDatalist2,require("app.modules.exChange.view.ExchangeMenuItem"))
		self.listView2:setItemClickFunc(handler(self, self.itemClick))
	end

end

function EquipProduView:setViewInfo(data)
 
	if self.goalgoods:getChildByTag(10) then
		self.goalgoods:removeChildByTag(10, true)
	end

	if self.goalgoods1:getChildByTag(10) then
		self.goalgoods1:removeChildByTag(10, true)
	end

	if self.artifactMask1:getChildByTag(100) then
		self.artifactMask1:removeChildByTag(100, true)
	end

	local info = {goods_id = data.product[1][2]}
	local commonItem = CommonItemCell.new()
	commonItem:setData(info)

	local commonItem2 = CommonItemCell.new()
	commonItem2:setData(info)

	self.goalgoods:addChild(commonItem,10,10)
	self.goalgoods1:addChild(commonItem2,10,10)

	--commonItem:setScale(0.98)
	commonItem2:setScale(0.8)

	commonItem:setPosition(self.goalgoods:getContentSize().width/2, self.goalgoods:getContentSize().height/2)
	commonItem2:setPosition(self.goalgoods1:getContentSize().width/2, self.goalgoods1:getContentSize().height/2)

	self.goodsname:setString(configHelper:getGoodNameByGoodId(info.goods_id))
	self.lv:setString(configHelper:getGoodLVByGoodId(info.goods_id))

	 
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    local wealthInfo = roleManager.wealth
    local index = 1
    self.itemLayer1:setVisible(false)
    self.itemLayer2:setVisible(false)
  	self.itemLayer3:setVisible(false)
  	self.itemLayer4:setVisible(false)
  	self.itemLayer5:setVisible(false)
  	self.tipsLabel:setVisible(true)

	for i=1,#data.stuff do
		if data.stuff[i][1] == "coin" then
			self.coinnumber:setString(data.stuff[i][2])
			if wealthInfo.coin < data.stuff[i][2] then
				self.tip = "金币不足"
				self.coinnumber:setColor(cc.c3b(255,0,0))
			else
				self.coinnumber:setColor(cc.c3b(0,255,0))
			end
		elseif data.stuff[i][1] == "goods" then

			local iteminfo
			local name = "材料"
			if data.wear_equips ~= 0 and data.wear_equips == data.stuff[i][2] then
				name = "身上装备"
				iteminfo = {goods_id = data.stuff[i][2],needNum = data.stuff[i][3],nowNum = RoleManager:getInstance().roleInfo:getEquipByGoodsId(data.wear_equips) and 1 or 0 }
				self.needBodyEquip = true
				self:createItem(iteminfo,name,5)--CommonItemCell.new()
				self.tipsLabel:setVisible(false)
				if iteminfo.nowNum < iteminfo.needNum then
					self.tip = "身上装备不足"
				end
			else
				iteminfo = {goods_id = data.stuff[i][2],needNum = data.stuff[i][3],nowNum = BagManager:getInstance():findItemCountByItemId(data.stuff[i][2])}
				if iteminfo.nowNum < iteminfo.needNum then
					self.tip = "材料不足"
				end

				self:createItem(iteminfo,name,index)
				index = index + 1

			end
			
			--self:createItem(iteminfo,name,i)--CommonItemCell.new()

			--index = index + 1
		end
	end
 
	self.labAttr1 = self:seekNodeByName("labAttr1")
  	self.labAttrValue1 = self:seekNodeByName("labAttrValue1")
  	self.labAttr2 = self:seekNodeByName("labAttr2")
  	self.labAttrValue2 = self:seekNodeByName("labAttrValue2")
  	self.labAttr3 = self:seekNodeByName("labAttr3")
  	self.labAttrValue3 = self:seekNodeByName("labAttrValue3")
  	self.labAttr4 = self:seekNodeByName("labAttr4")
  	self.labAttrValue4 = self:seekNodeByName("labAttrValue4")

  	for i=1,4 do
        local labAttrName = self:seekNodeByName("labAttr"..i)
        labAttrName:setVisible(false)
        local labCurValue = self:seekNodeByName("labAttrValue"..i)
        labCurValue:setVisible(false)
    end
 
    local equipItem = configHelper:getEquipValidAttrByEquipId(info.goods_id)

    local num = #equipItem/2
    if #equipItem%2 > 0 then
            --生命
            self:seekNodeByName("labAttr"..1):setVisible(true)
            self:seekNodeByName("labAttr"..1):setString(self:getName(equipItem[1][1]))
            self:seekNodeByName("labAttrValue"..1):setVisible(true)
            self:seekNodeByName("labAttrValue"..1):setString(equipItem[1*2 - 1][2])
            
            table.remove(equipItem,1)
            for i=1,num do
		    	local labAttrName = self:seekNodeByName("labAttr"..(i+1))
		        labAttrName:setVisible(true)
		        labAttrName:setString(self:getName(equipItem[i*2 - 1][1]))
		        local labCurValue = self:seekNodeByName("labAttrValue"..(i+1))
		        labCurValue:setVisible(true)
		        labCurValue:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
		    end
    else
		for i=1,num do
		    	local labAttrName = self:seekNodeByName("labAttr"..i)
		        labAttrName:setVisible(true)
		        labAttrName:setString(self:getName(equipItem[i*2 - 1][1]))
		        local labCurValue = self:seekNodeByName("labAttrValue"..i)
		        labCurValue:setVisible(true)
		        labCurValue:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
		end

    end
    
    local equipItem2 = configHelper:getEquipValidAttrByEquipIdSPJZ(info.goods_id)
    if #equipItem2 > 0 then
	    for i=1,4 do
	    	if self["labAttr"..i]:isVisible() == false then
	    		self["labAttr"..i]:setVisible(true)
	    		self["labAttr"..i]:setString(self:getName(equipItem2[1][1]))

	    		self["labAttrValue"..i]:setVisible(true)
	    		--if equipItem2[1][1] == "palsy_rate" or equipItem2[1][1] == "mana_consume" then
		    		self["labAttrValue"..i]:setString(equipItem2[1][2].." %")
		    	--else
		    	--	self["labAttrValue"..i]:setString(equipItem2[1][2].."&")
	    		--end
	    	end
	    end
	end
    ------------------------------------
    --[[
    for i=1,num do
    	local labAttrName = self:seekNodeByName("labAttr"..i)
        labAttrName:setVisible(true)
        labAttrName:setString(self:getName(equipItem[i*2 - 1][1]))
        local labCurValue = self:seekNodeByName("labAttrValue"..i)
        labCurValue:setVisible(true)
        labCurValue:setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
    end
	--]]

end

-- function EquipProduView:setMenu(data)
-- 	self.menuDataList, self.subDatalist = EquipManager:getInstance():getEquipProduList(data)
--  	dump(self.menuDataList)
--  	dump(self.subDatalist)
-- 	self.listView:setData(self.menuDataList,self.subDatalist,require("app.modules.exChange.view.ExchangeMenuItem"))
-- 	self.listView:setItemClickFunc(handler(self, self.itemClick))
-- end

function EquipProduView:getName(str)

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
	elseif str == "palsy_rate" then
		return "麻痹概率增加:"
	elseif str == "revive_time" then
		return "复活时间缩短:"
	elseif str == "mana_consume" then
		return "伤害抵消增加:"
	end
	return ""
end

function EquipProduView:itemClick(item)

	self.selectItem = item
	--self.artifactLayer1:setVisible(false)
	self.artifactMask1:setVisible(true)
 	self.productionBtn:setVisible(true)
 	local data = item:getData().data
 	self.currentKey = data.key
 	self.currentGoodsLv = configHelper:getGoodLVByGoodId(data.product[1][2])
 	self.tip = nil
 	self.needBodyEquip = false
 	self:setViewInfo(data)

end

function EquipProduView:open()
	self.selectItem = nil
	GlobalEventSystem:addEventListener(BagEvent.FUSION_SUCCESS,handler(self,self.reset))
end

function EquipProduView:close()
	self.selectItem = nil
	GlobalEventSystem:removeEventListener(BagEvent.FUSION_SUCCESS)
end

function EquipProduView:destory()
	self:close()
	self.super.destory(self)
end

function EquipProduView:reset()
	--[[
	self.artifactMask1:setVisible(false)
 	self.productionBtn:setVisible(false)
 	self.artifactLayer1:setVisible(true)
 	--]]
 	if self.selectItem then
 		self:itemClick(self.selectItem)
 	end
end

function EquipProduView:createItem(info,str,index)

	self["itemLayer"..index]:setVisible(true)
	
	self:seekNodeByName("itemName"..index):setString(configHelper:getGoodNameByGoodId(info.goods_id))
	self:seekNodeByName("typeLabel"..index):setString(str)
	self:seekNodeByName("num"..index):setString(info.nowNum.."/"..info.needNum)

	if info.needNum > info.nowNum then
		self:seekNodeByName("num"..index):setColor(cc.c3b(255, 0, 0))
	else
		self:seekNodeByName("num"..index):setColor(cc.c3b(0, 255, 0))
	end

	local quality = configHelper:getGoodQualityByGoodId(info.goods_id)
		    if quality then
		        local color
		        if quality == 1 then            --白
		            color = TextColor.TEXT_W
		        elseif quality == 2 then        --绿
		            color = TextColor.TEXT_G
		        elseif quality == 3 then        --蓝
		            color = TextColor.ITEM_B
		        elseif quality == 4 then        --紫
		            color = TextColor.ITEM_P
		        elseif quality == 5 then        --橙
		            color = TextColor.TEXT_O
		        elseif quality == 6 then        --红
		            color = TextColor.TEXT_R
		        end 
		        if color then
		            self:seekNodeByName("itemName"..index):setTextColor(color)
		            self:seekNodeByName("typeLabel"..index):setTextColor(color)
		        end
		    end

	local commonItem
 	if self["commonItem"..index] == nil then
 		commonItem = CommonItemCell.new()
 		self["commonItem"..index] = commonItem
 		self:seekNodeByName("item"..index):addChild(commonItem)
		commonItem:setScale(0.8)
	else
		commonItem = self["commonItem"..index]
 	end
	
	commonItem:setData(info)
	commonItem:setPosition(self:seekNodeByName("item"..index):getContentSize().width/2,self:seekNodeByName("item"..index):getContentSize().height/2)
 
end
 
return EquipProduView