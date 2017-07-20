--
-- Author: Yi hanneng
-- Date: 2016-06-13 16:00:44
--

--[[
------------------印记-------------------
--]]
local HallMarkView = HallMarkView or class("HallMarkView", BaseView)

function HallMarkView:ctor()

	self.ccui = cc.uiloader:load("resui/roleStampWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function HallMarkView:init()

	self.type = 0

	self.leftLayer = cc.uiloader:seekNodeByName(self.ccui, "leftLayer")
	self.rightLayer = cc.uiloader:seekNodeByName(self.ccui, "rightLayer")
	self.AttrLayer = cc.uiloader:seekNodeByName(self.ccui, "AttrLayer")
	self.normalLevelUp = cc.uiloader:seekNodeByName(self.ccui, "normalLevelUp")
	self.specialLevelUp = cc.uiloader:seekNodeByName(self.ccui, "specialLevelUp")

	self.leftLabel = {}
	self.leftBtn = {}
	self.rightLv ={}
	self.attr = {}
	-------------leftLayer-------
	for i=1,5 do
		
		cc.uiloader:seekNodeByName(self.ccui, "itemSelect"..i):setVisible(false)
		self.leftLabel[i] = cc.uiloader:seekNodeByName(self.ccui, "levelLabel"..i)
		self.leftBtn[i] = cc.uiloader:seekNodeByName(self.ccui, "stamp"..i)
		self.leftBtn[i]:setTouchEnabled(true)
		self.leftBtn[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            --self.btnGet:setScale(1.2)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            --self.btnGet:setScale(1.0)
	            self:handleClick(i)
	         end     
	        return true
	    end)
	end

	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_STAMP_HP,self.leftBtn[1],45,45)
	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_STAMP_ATK,self.leftBtn[2],45,45)
	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_STAMP_DEF,self.leftBtn[3],45,45)
	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_STAMP_MDEF,self.leftBtn[4],45,45)
	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_STAMP_HOLY,self.leftBtn[5],55,55)
	-------------rightLayer------
	-------------AttrLayer-------
	self.rightLv[1] = cc.uiloader:seekNodeByName(self.ccui, "life_LV")
	self.lifeAttr1 = cc.uiloader:seekNodeByName(self.ccui, "lifeAttr1")
	self.lifeAttr2 = cc.uiloader:seekNodeByName(self.ccui, "lifeAttr2")
	self.rightLv[2] = cc.uiloader:seekNodeByName(self.ccui, "attack_LV")
	self.attr[2] = cc.uiloader:seekNodeByName(self.ccui, "attackAttr")
	self.rightLv[3] = cc.uiloader:seekNodeByName(self.ccui, "def_LV")	
	self.attr[3] = cc.uiloader:seekNodeByName(self.ccui, "defAttr")
	self.rightLv[4] = cc.uiloader:seekNodeByName(self.ccui, "magic_LV")
	self.attr[4] = cc.uiloader:seekNodeByName(self.ccui, "magicAttr")
	self.rightLv[5] = cc.uiloader:seekNodeByName(self.ccui, "holy_LV")
	self.attr[5] = cc.uiloader:seekNodeByName(self.ccui, "holyAttr")
	-------------normalLevelUp-------
	self.lvItem1 = cc.uiloader:seekNodeByName(self.ccui, "lvItem1")
	self.lvItem2 = cc.uiloader:seekNodeByName(self.ccui, "lvItem2")
	self.lvLabel1 = cc.uiloader:seekNodeByName(self.ccui, "lvLabel1")
	self.lvLabel2 = cc.uiloader:seekNodeByName(self.ccui, "lvLabel2")
	self.itemName1 = cc.uiloader:seekNodeByName(self.ccui, "itemName1")
	self.itemName2 = cc.uiloader:seekNodeByName(self.ccui, "itemName2")

	self.moneyLabel = cc.uiloader:seekNodeByName(self.ccui, "moneyLabel")
	self.materialLabel = cc.uiloader:seekNodeByName(self.ccui, "materialLabel")

	self.itemAttr1 = cc.uiloader:seekNodeByName(self.ccui, "itemAttr1")
	self.itemAttr2 = cc.uiloader:seekNodeByName(self.ccui, "itemAttr2")
	self.itemNewAttr1 = cc.uiloader:seekNodeByName(self.ccui, "itemNewAttr1")
	self.itemNewAttr2 = cc.uiloader:seekNodeByName(self.ccui, "itemNewAttr2")

	---------------specialLevelUp-----------
	--self.attackLabel = cc.uiloader:seekNodeByName(self.ccui, "attackLabel")
	--self.magicLabel = cc.uiloader:seekNodeByName(self.ccui, "magicLabel")
	--self.lifeLabel = cc.uiloader:seekNodeByName(self.ccui, "lifeLabel")
	--self.defLabel = cc.uiloader:seekNodeByName(self.ccui, "defLabel")

	self.btnGet = cc.uiloader:seekNodeByName(self.ccui, "levelUpBtn")


	self.btnGet:setTouchEnabled(true)
	self.btnGet:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnGet:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnGet:setScale(1.0)
            RoleController:getInstance():requestMarkUpgrade(self.type)
            
         end     
        return true
    end)
end

function HallMarkView:setViewInfo(data)

	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    local wealth = roleManager.wealth
    self.career = career or roleInfo.career
 
    for i=1,#self.leftLabel do
    	self.leftLabel[i]:setString("LV"..roleInfo.mark[i])
    	self.rightLv[i]:setString("LV"..roleInfo.mark[i])
    	
    	local config = configHelper:getMarkByTypeCareerLv(i, self.career, roleInfo.mark[i])

    	if config == nil then
	    	if i == 1 then
	    		self.lifeAttr1:setString(0)
	    		self.lifeAttr2:setString(0)
	    	else
	    		if i == 2 then
	    			cc.uiloader:seekNodeByName(self.ccui, "attackTxt"):setString(self:getMarkNameType(self.career))
	    		end
	    		self.attr[i]:setString(0)
	    	end
    	else
    	
	    	local showArr = self:handlerData(config)
	    	if i == 1 then
	    		self.lifeAttr1:setString(showArr[1].value)
	    		self.lifeAttr2:setString(showArr[2].value)
	    	else
	    		if i == 2 then
	    			cc.uiloader:seekNodeByName(self.ccui, "attackTxt"):setString(self:getMarkNameType(self.career))
	    		end
	    		self.attr[i]:setString(showArr[1].value)
	    	end
    	end
    end

    if self.type ~= 0 then
    	self:handleClick(self.type)
    end

end

function HallMarkView:handleClick(tag)

	self.type = tag

	for i=1,5 do
		if i == tag then
			cc.uiloader:seekNodeByName(self.ccui, "itemSelect"..i):setVisible(true)
		else
			cc.uiloader:seekNodeByName(self.ccui, "itemSelect"..i):setVisible(false)
		end
		
	end

	if self.lvItem1:getChildByTag(10) then
			self.lvItem1:removeChildByTag(10, true)
		end
		local item = display.newSprite("#roleWin_Stamp"..tag..".png")
		item:setTag(10)
		self.lvItem1:addChild(item)
		item:setPosition(self.lvItem1:getContentSize().width/2, self.lvItem1:getContentSize().height/2)

		if self.lvItem2:getChildByTag(10) then
			self.lvItem2:removeChildByTag(10, true)
		end
		local item = display.newSprite("#roleWin_Stamp"..tag..".png")
		item:setTag(10)
		self.lvItem2:addChild(item)
		item:setPosition(self.lvItem2:getContentSize().width/2, self.lvItem2:getContentSize().height/2)
	
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    local wealth = roleManager.wealth
    self.career = career or roleInfo.career

	local config = configHelper:getMarkByTypeCareerLv(tag, self.career, roleInfo.mark[tag])
	local nextconfig = configHelper:getMarkByTypeCareerLv(tag, self.career, roleInfo.mark[tag] + 1 )

	self.lvLabel1:setString("LV"..roleInfo.mark[tag])

	if nextconfig then
		self.lvLabel2:setString("LV"..nextconfig.lv)
		self.btnGet:setButtonLabelString("升级")
		self.btnGet:setButtonEnabled(true)
	else
		self.lvLabel2:setString("LV"..roleInfo.mark[tag])
		self.btnGet:setButtonLabelString("已满级")
		self.btnGet:setButtonEnabled(false)
	end

	if tag == 5 then

		self.normalLevelUp:setVisible(false)
		self.specialLevelUp:setVisible(true)
		self.itemAttr2:setVisible(false)
		self.itemNewAttr2:setVisible(false)

		if config == nil then
	    	self.itemAttr1:setString("神圣值:"..0)
    	else
	    	local showArr = self:handlerData(config)
	    	self.itemAttr1:setString(showArr[1].name..showArr[1].value)
    	end

    	if nextconfig == nil then
	    	self.itemNewAttr1:setString(self.itemAttr1:getString())
	    	self.moneyLabel:setString(wealth.coin.."/"..0)
    	else
	    	local showArr = self:handlerData(nextconfig)
	    	self.itemNewAttr1:setString(showArr[1].name..showArr[1].value)
	    	local limit_cond = nextconfig.limit_cond
 
	    	for i=1,#limit_cond do
	    		cc.uiloader:seekNodeByName(self.ccui, "Lv"..i):setString("LV"..limit_cond[i][2])
	    		if roleInfo.mark[i] >= limit_cond[i][2]  then
	    			cc.uiloader:seekNodeByName(self.ccui, "Lv"..i):setColor(cc.c3b(0, 255, 0))
	    		else
	    			cc.uiloader:seekNodeByName(self.ccui, "Lv"..i):setColor(cc.c3b(255, 0, 0))
	    			self.btnGet:setButtonEnabled(false)
	    		end
	    	end

	    	self.moneyLabel:setString(wealth.coin.."/"..nextconfig.upgrade_stuff[1][2])
	    	if wealth.coin >= nextconfig.upgrade_stuff[1][2] then
	    		self.moneyLabel:setColor(cc.c3b(0, 255, 0))
	    	else
	    		self.moneyLabel:setColor(cc.c3b(255, 0, 0))
	    		self.btnGet:setButtonEnabled(false)
	    	end

    	end

	else

		cc.uiloader:seekNodeByName(self.ccui, "materialTxt"):setString("需要"..self:getMarkTitleName(tag)..":")

		if config == nil then
	    	if tag == 1 then
	    		self.itemAttr1:setString("生命值:"..0)
	    		self.itemAttr2:setString("魔法值:"..0)
	    		self.itemAttr2:setVisible(true)
	    	else
	    		self.itemAttr2:setVisible(false)
	    		self.itemAttr1:setString(self:getMarkName(tag,self.career)..0)
	    		
	    	end
    	else
    	
	    	local showArr = self:handlerData(config)
	    	if tag == 1 then
	    		self.itemAttr1:setString(showArr[1].name..showArr[1].value)
	    		self.itemAttr2:setString(showArr[2].name..showArr[2].value)
	    		self.itemAttr2:setVisible(true)
	    	else
	    		self.itemAttr1:setString(showArr[1].name..showArr[1].value)
	    		self.itemAttr2:setVisible(false)
	    	end
    	end

    	if nextconfig == nil then
	    	if tag == 1 then
	    		self.itemNewAttr1:setString(self.itemAttr1:getString())
	    		self.itemNewAttr2:setString(self.itemAttr2:getString())
	    		self.itemNewAttr2:setVisible(true)
	    	else
	    		self.itemNewAttr2:setVisible(false)
	    		self.itemNewAttr1:setString(self.itemAttr1:getString())
	    		
	    	end
	    	--dump(wealth.markValue,wealth.markValue[tag])
	    	self.moneyLabel:setString(wealth.coin.."/"..0)
	    	self.materialLabel:setString(wealth.markValue[tag].."/"..0)

    	else
    	
	    	local showArr = self:handlerData(nextconfig)
	    	if tag == 1 then
	    		self.itemNewAttr1:setString(showArr[1].name..showArr[1].value)
	    		self.itemNewAttr2:setString(showArr[2].name..showArr[2].value)
	    		self.itemNewAttr2:setVisible(true)
	    	else
	    		self.itemNewAttr1:setString(showArr[1].name..showArr[1].value)
	    		self.itemNewAttr2:setVisible(false)
	    	end

	    	self.moneyLabel:setString(wealth.coin.."/"..nextconfig.upgrade_stuff[2][2])
	    	self.materialLabel:setString(wealth.markValue[tag].."/"..nextconfig.upgrade_stuff[1][2])
	    	
	    	if wealth.markValue[tag] >= nextconfig.upgrade_stuff[1][2] then
	    		self.materialLabel:setColor(cc.c3b(0, 255, 0))
	    	else
	    		self.materialLabel:setColor(cc.c3b(255, 0, 0))
	    		self.btnGet:setButtonEnabled(false)
	    	end

	    	if wealth.coin >= nextconfig.upgrade_stuff[2][2] then
	    		self.moneyLabel:setColor(cc.c3b(0, 255, 0))
	    	else
	    		self.moneyLabel:setColor(cc.c3b(255, 0, 0))
	    		self.btnGet:setButtonEnabled(false)
	    	end

    	end

		self.normalLevelUp:setVisible(true)
		self.specialLevelUp:setVisible(false)
 
	end

	

end

function HallMarkView:open()
	self.btnGet:setButtonEnabled(false)
    self:setViewInfo(nil)
end


function HallMarkView:getMarkName(tag,career)
	local str = ""
	if tag == 2 then
		str = "物理攻击:"
		if career == 2000 then
			str = "魔法攻击:"
		elseif career == 3000 then
			str = "道术攻击:"
		end
	elseif tag ==3 then
		str = "物理防御:"
	elseif tag == 4 then
		str = "魔法防御:"
	end
	return str
end

function HallMarkView:getMarkNameType(career)
	local str = ""
		str = "物攻"
		if career == 2000 then
			str = "魔攻"
		elseif career == 3000 then
			str = "道攻"
		end
	return str
end

function HallMarkView:getMarkTitleName(tag)
	local str = ""
	if tag == 2 then
		str = "攻击印记"
	elseif tag ==3 then
		str = "物防印记"
	elseif tag == 4 then
		str = "魔防印记"
	elseif tag == 1 then
		str = "生命印记"
	end
	return str
end

function HallMarkView:handlerData(data)

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

	if data.holy and data.holy > 0 then
		table.insert(tem, {name = "神圣:", value = data.holy})
	end

	return tem
 
end

return HallMarkView