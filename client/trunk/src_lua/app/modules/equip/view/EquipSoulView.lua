--
-- Author: Yi hanneng
-- Date: 2016-05-12 11:44:44
--
--[[
装备铸魂
--]]
local EquipSoulView = EquipSoulView or class("EquipSoulView", BaseView)

function EquipSoulView:ctor(winTag,data,winconfig)
	EquipSoulView.super.ctor(self,winTag,data,winconfig)
	 local root = self:getRoot()
  	self:init()
end

function EquipSoulView:init()

	self.itemlist = {}

	self.helpBtn = self:seekNodeByName("helpBtn")
  	self.equipSoulBtn = self:seekNodeByName("equipSoulBtn")
  	self.item1 = self:seekNodeByName("item1")
  	self.itemAdd = self:seekNodeByName("itemAdd")
  	self.item2 = self:seekNodeByName("item2")
  	self.nameLabel1 = self:seekNodeByName("nameLabel1")
  	self.nameLabel2 = self:seekNodeByName("nameLabel2")
  	self.numLabel = self:seekNodeByName("numLabel")
  	self.rightLayer = self:seekNodeByName("rightLayer")
  	self.AttributesLayer = self:seekNodeByName("AttributesLayer")
  	self.txtLabel = self:seekNodeByName("txtLabel")

  	---------  	

  	self.itemAdd:setTouchEnabled(true)
  	self.itemAdd:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.itemAdd:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.itemAdd:setScale(1.0)
           	self:equipClick()
        end     
        return true
    end)

  	self.helpBtn:setTouchEnabled(true)
  	self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.helpBtn:setScale(1.0)
           	 GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(11),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)

    self.equipSoulBtn:setTouchEnabled(true)
    self.equipSoulBtn:setButtonEnabled(false)
  	self.equipSoulBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.equipSoulBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.equipSoulBtn:setScale(1.0)
            self.currentEquipId = self.data.id
            GlobalController.equip:requestSoul(self.data.id)
        end     
        return true
    end)

end

function EquipSoulView:setViewInfo(data)

	if data == nil then
		return
	end
	data = data.data
	self.data = data
	self.equipSoulBtn:setButtonEnabled(true)
	 
	if self.itemAdd:getChildByTag(10) then
		self.itemAdd:removeChildByTag(10, true)
	end
 
	local commonItem = CommonItemCell.new()
	commonItem:setData(data)
	commonItem:setTag(10)
	self.itemAdd:addChild(commonItem)
	commonItem:setItemClickFunc(handler(self,self.equipClick))
	commonItem:setPosition(self.itemAdd:getContentSize().width/2, self.itemAdd:getContentSize().height/2)
	self.nameLabel1:setString(configHelper:getGoodNameByGoodId(data.goods_id))

	-----------------------
	if self.item2:getChildByTag(10) then
		self.item2:removeChildByTag(10, true)
	end
 
 	local soulRateConfig = configHelper:getSoulAddConfig(data.soul)
 	local nextSoulRateConfig = configHelper:getSoulAddConfig(data.soul+1)
	local soulConfig = configHelper:getSoulConfigByIdAndLv(data.goods_id,data.soul+1)
	self.txtLabel:setVisible(false)

 	if soulConfig ~= nil then
		local item = CommonItemCell.new()
		item:setData(data)
		item:setSoul(data.soul+1)
		item:setTag(10)
		self.item2:addChild(item)
		item:setPosition(self.item2:getContentSize().width/2, self.item2:getContentSize().height/2)

		local bagNum = BagManager.getInstance():findItemCountByItemId(soulConfig[1][1])
		self.numLabel:setString(bagNum.."/"..soulConfig[1][2])
		self.numLabel:setVisible(true)
		self.equipSoulBtn:setButtonEnabled(true)

		if bagNum >= soulConfig[1][2] then
			self.numLabel:setColor(cc.c3b(0,255,13))
		else
			self.numLabel:setColor(cc.c3b(255,0,13))
		end
		--设置属性

	    local equipAttr = configHelper:getEquipValidAllAttrByEquipId(data.goods_id)
	 	local showArr = self:handlerData(equipAttr,nextSoulRateConfig.modulus)
	 	
	 	for i=1,#self.itemlist do
	 		self.itemlist[i]:removeSelf()
	 	end

	 	self.itemlist = {}

	 	local titleItem = self:createItem("当前铸魂等级:",soulRateConfig.name,nextSoulRateConfig.name,SoulColorArr[tostring(data.soul)],SoulColorArr[tostring(data.soul+1)]):addTo(self.AttributesLayer)
	 	titleItem:setPosition(self.AttributesLayer:getContentSize().width/2 - 100, self.AttributesLayer:getContentSize().height - 30)
	 	self.itemlist[#self.itemlist+1] = titleItem

	 	for i=1,#showArr do
	 		local item = self:createItem(showArr[i].name,showArr[i].base,showArr[i].value,SoulColorArr[tostring(data.soul)],SoulColorArr[tostring(data.soul+1)]):addTo(self.AttributesLayer)
	 		item:setPosition(self.AttributesLayer:getContentSize().width/2 - 100, self.AttributesLayer:getContentSize().height - 30*(i+1))
	 		self.itemlist[#self.itemlist+1] = item
	 	end

	 else
	 	local item = CommonItemCell.new()
		item:setData(data)
		item:setSoul(data.soul)
		item:setTag(10)
		self.item2:addChild(item)
		item:setPosition(self.item2:getContentSize().width/2, self.item2:getContentSize().height/2)
		item:setScale(0.98)

		self.numLabel:setVisible(false)
		self.equipSoulBtn:setButtonEnabled(false)

		local equipAttr = configHelper:getEquipValidAllAttrByEquipId(data.goods_id)
	 	local showArr = self:handlerData(equipAttr,0)
	 
	 	for i=1,#self.itemlist do
	 		self.itemlist[i]:removeSelf()
	 	end

	 	self.itemlist = {}

	 	local titleItem = self:createItem("当前铸魂等级:",soulRateConfig.name,"已满级",SoulColorArr[tostring(data.soul)],SoulColorArr[tostring(data.soul)]):addTo(self.AttributesLayer)
	 	titleItem:setPosition(self.AttributesLayer:getContentSize().width/2 - 100, self.AttributesLayer:getContentSize().height - 30)
	 	self.itemlist[#self.itemlist+1] = titleItem

	 	for i=1,#showArr do
	 		local item = self:createItem(showArr[i].name,showArr[i].base,"",SoulColorArr[tostring(data.soul)],SoulColorArr[tostring(data.soul)]):addTo(self.AttributesLayer)
	 		item:setPosition(self.AttributesLayer:getContentSize().width/2 - 100, self.AttributesLayer:getContentSize().height - 30*(i+1))
	 		self.itemlist[#self.itemlist+1] = item
	 	end
	end
	
	self.nameLabel2:setString(configHelper:getGoodNameByGoodId(data.goods_id))

end

function EquipSoulView:equipClick()

	local bodylist = {}
	local baglist = {}
	local body = RoleManager:getInstance().roleInfo.equip
	local bag = BagManager:getInstance().bagInfo:getEquipList()

	for i=1,#body do
		if configHelper:canSoulByGoodsId(body[i].goods_id) then
			table.insert(bodylist, body[i])
		end
	end

	for j=1,#bag do
		if configHelper:canSoulByGoodsId(bag[j].goods_id) then
			table.insert(baglist, bag[j])
		end
	end

	local selectItemsWin = require("app.modules.equip.view.SelectItemsWin").new({name = "选择装备",type = 1,from = 1, bodyEquiplist = bodylist,bagEquipList = baglist})--
  	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,selectItemsWin) 
end

function EquipSoulView:createItem(title,base,value,color,color2)

	local node = display.newNode()
	local titleTxt = display.newTTFLabel({
    text =title,
    size = 18,
    color = cc.c3b(231, 211, 173),
    align = cc.TEXT_ALIGNMENT_RIGHT -- 文字内部居中对齐
	})
	titleTxt:setAnchorPoint(1,0.5)

	local baseTxt = display.newTTFLabel({
    text =base,
    size = 18,
    color = color,
    align = cc.TEXT_ALIGNMENT_LEFT -- 文字内部居中对齐
	})
	baseTxt:setAnchorPoint(0,0.5)

	local valueTxt = display.newTTFLabel({
    text =value,
    size = 18,
    color = color2 or cc.c3b(0, 255, 13),
    align = cc.TEXT_ALIGNMENT_LEFT -- 文字内部居中对齐
	})

	valueTxt:setAnchorPoint(0,0.5)

	node:addChild(titleTxt)
	node:addChild(baseTxt)
	node:addChild(valueTxt)

	titleTxt:setPositionX(60)
	baseTxt:setPositionX(65)
	valueTxt:setPositionX(180)

	return node

end

function EquipSoulView:handlerData(data,rate)

	local tem = {}
	if data.hp and data.hp > 0 then
		table.insert(tem, {name = "生命:", base = data.hp, value = "+"..math.floor(data.hp*rate)})
	end

	if data.mp and data.mp > 0 then
		table.insert(tem, {name = "魔法:", base = data.mp, value = "+"..math.floor(data.mp*rate)})
	end

	if data.max_ac and data.max_ac > 0 then
		table.insert(tem, {name = "物理攻击:", base = data.min_ac.."-"..data.max_ac, value = "+"..math.floor(data.min_ac*rate).."-"..math.floor(data.max_ac*rate)})
	end

	if data.max_mac and data.max_mac > 0 then
		table.insert(tem, {name = "魔法攻击:", base = data.min_mac.."-"..data.max_mac, value = "+"..math.floor(data.min_mac*rate).."-"..math.floor(data.max_mac*rate)})
	end

	if data.max_sc and data.max_sc > 0 then
		table.insert(tem, {name = "道术攻击:", base = data.min_sc.."-"..data.max_sc, value = "+"..math.floor(data.min_sc*rate).."-"..math.floor(data.max_sc*rate)})
	end

	if data.max_def and data.max_def > 0 then
		table.insert(tem, {name = "物理防御:", base = data.min_def.."-"..data.max_def, value = "+"..math.floor(data.min_def*rate).."-"..math.floor(data.max_def*rate)})
	end

	if data.max_res and data.max_res > 0 then
		table.insert(tem, {name = "魔法防御:", base = data.min_res.."-"..data.max_res, value = "+"..math.floor(data.min_res*rate).."-"..math.floor(data.max_res*rate)})
	end

	return tem
 
end

function EquipSoulView:strenSuccess()

	self:reset()
	self:playStrengEffect()
end
 
function EquipSoulView:reset()
	 
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
	self:setViewInfo({data = info})
end

--播强化成功特效
function EquipSoulView:playStrengEffect()
    if self.streng then
        self.streng:getAnimation():play("effect")
        self.streng:setPosition(235,470)
        return
    end
    ArmatureManager:getInstance():loadEffect("qianghua")
    self.streng = ccs.Armature:create("qianghua")
    self.itemAdd:addChild(self.streng, 100,100)
    self.streng:setPosition(self.itemAdd:getContentSize().width/2,self.itemAdd:getContentSize().height/2)
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

function EquipSoulView:open()
	GlobalEventSystem:addEventListener(EquipEvent.SELECT_GOODS_SUCCESS,handler(self,self.setViewInfo))
	GlobalEventSystem:addEventListener(EquipEvent.SOUL_SUCCESS,handler(self,self.strenSuccess))
end

function EquipSoulView:close()
	GlobalEventSystem:removeEventListener(EquipEvent.SELECT_GOODS_SUCCESS)
	GlobalEventSystem:removeEventListener(EquipEvent.SOUL_SUCCESS)
end

function EquipSoulView:destory()
	self:close()
	EquipSoulView.super.destory(self)
end

return EquipSoulView