--
-- Author: Yi hanneng
-- Date: 2016-09-05 14:19:10
--
local RideUpView = RideUpView or class("RideUpView", BaseView)

function RideUpView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)
    RideUpView.super.ctor(self,nil,nil,{url = "resui/roleMountLvWin.ExportJson"})
	self.ccui = self.root
	 
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	
   	self.ccui:setPosition(display.width/2 - self.ccui:getContentSize().width/2, display.height/2 - self.ccui:getContentSize().height/2)

   	self:init()
   	self:setNodeEventEnabled(true)

end

function RideUpView:init()

	self.type = 0
	self.nowNum = 0
	self.needNum = 0
	self.needGoodsId = 0
	self.isFull = false

	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
	self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
	self.mountLayerL = cc.uiloader:seekNodeByName(self.ccui, "mountLayerL")

	self.nameLabel2 = cc.uiloader:seekNodeByName(self.ccui, "nameLabel2")
	self.mountLayerR = cc.uiloader:seekNodeByName(self.ccui, "mountLayerR")

	self.itemBg = cc.uiloader:seekNodeByName(self.ccui, "itemBg")
	self.itemNum = cc.uiloader:seekNodeByName(self.ccui, "itemNum")
	self.confirmBtn = cc.uiloader:seekNodeByName(self.ccui, "confirmBtn")
 	self.attrLabel3 = cc.uiloader:seekNodeByName(self.ccui, "attrLabel3")

 	self.tipsLayer = cc.uiloader:seekNodeByName(self.ccui, "tipsLayer")
 	self.fullLabel = cc.uiloader:seekNodeByName(self.ccui, "fullLabel")

	self.attrList = {}
	self.attrList[1] = cc.uiloader:seekNodeByName(self.ccui, "attr1")
	self.attrList[2] = cc.uiloader:seekNodeByName(self.ccui, "attr2")
	self.attrList[3] = cc.uiloader:seekNodeByName(self.ccui, "attr3")
	self.attrList[4] = cc.uiloader:seekNodeByName(self.ccui, "attr4")
	self.attrList[5] = cc.uiloader:seekNodeByName(self.ccui, "attr5")
	self.attrList[6] = cc.uiloader:seekNodeByName(self.ccui, "attr6")
	self.attrList[7] = cc.uiloader:seekNodeByName(self.ccui, "attr7")

	self.addtionList = {}
	self.addtionList[1] = cc.uiloader:seekNodeByName(self.ccui, "addtion1")
	self.addtionList[2] = cc.uiloader:seekNodeByName(self.ccui, "addtion2")
	self.addtionList[3] = cc.uiloader:seekNodeByName(self.ccui, "addtion3")
	self.addtionList[4] = cc.uiloader:seekNodeByName(self.ccui, "addtion4")
	self.addtionList[5] = cc.uiloader:seekNodeByName(self.ccui, "addtion5")
	self.addtionList[6] = cc.uiloader:seekNodeByName(self.ccui, "addtion6")
	self.addtionList[7] = cc.uiloader:seekNodeByName(self.ccui, "addtion7")
 
 
	self.confirmBtn:setTouchEnabled(true)
	self.confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.confirmBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.confirmBtn:setScale(1.0)
            
            if self.isFull then
            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"已经满阶")
            	return
            end

            if self.needGoodsId ~= 0 then
            	if self.nowNum < self.needNum then
            		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, configHelper:getGoodNameByGoodId(self.needGoodsId).."数量不足!")
            		return 
            	end
            end
 
            if self.upgradeKey then
            	RoleController:getInstance():requestRideUpgrade(self.upgradeKey)
            end

         end     
        return true
    end)
 
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:onClickClose()
        end     
        return true
    end)

    self:open()
    self:setViewInfo(nil)

end

function RideUpView:setViewInfo(data)
	print("=====RideUpView:setViewInfo====>")
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    local wealth = roleManager.wealth
    self.career = career or roleInfo.career
 
 	--当前坐骑
    if roleInfo.rideInfo ~= nil  then
        self.animationId = configHelper:getGoodResId(roleInfo.rideInfo.goods_id) 
        ArmatureManager:getInstance():loadModel(self.animationId, function(armatureData, mid)
        	if self.isDestory then return end
        	if self.animationId == nil then
		        return 
		    end
		    if self.animation then
		       self.animation:removeSelf()
		       self.animation = nil
		    end
		 
		    self.animation = ccs.Armature:create(mid)
		    self.animation:setPosition(100, 72)
		    self.animation:setScale(1.4)
		    self.mountLayerL:addChild(self.animation)
		    self.animation:getAnimation():play("stand_3")
        	end)
    end

    self.nameLabel:setString(configHelper:getGoodNameByGoodId(roleInfo.rideInfo.goods_id))

    local equipAttr = configHelper:getEquipValidAllAttrByEquipId(roleInfo.rideInfo.goods_id)
 
  	local hp = equipAttr.hp
 	local mp = equipAttr.mp
 	local min_ac = equipAttr.min_ac
 	local max_ac = equipAttr.max_ac
 	local min_mac = equipAttr.min_mac
 	local max_mac = equipAttr.max_mac
 	local min_sc = equipAttr.min_sc
 	local max_sc = equipAttr.max_sc
 	local min_def = equipAttr.min_def
 	local max_def = equipAttr.max_def
 	local min_res = equipAttr.min_res
 	local max_res = equipAttr.max_res
 	local speed = equipAttr.speed
 
	self.attrList[1]:setString(hp)
	self.attrList[2]:setString(mp)
	
	if self.career == 1000 then
		self.attrLabel3:setString("物理攻击:")
		self.attrList[3]:setString(min_ac.."-"..max_ac)
	elseif self.career == 2000 then
		self.attrLabel3:setString("魔法攻击:")
		self.attrList[3]:setString(min_mac.."-"..max_mac)
	elseif self.career == 3000 then
		self.attrLabel3:setString("道术攻击:")
		self.attrList[3]:setString(min_sc.."-"..max_sc)
	end
	
	self.attrList[4]:setString(min_def.."-"..max_def)
	self.attrList[5]:setString(min_res.."-"..max_res)
	self.attrList[6]:setString((equipAttr.mounts_p/100).."%")
	self.attrList[7]:setString(speed)

	--升阶坐骑

	local nextConfig = configHelper:getRideConfigById(roleInfo.rideInfo.goods_id)
 
	if nextConfig == nil or nextConfig.next_id == 0 then
		self.isFull = true
		self.confirmBtn:setButtonEnabled(false)
		self.nowNum = 0
		self.needNum = 0
		self.needGoodsId = 0
		self.upgradeKey = 0

		self.tipsLayer:setVisible(false)
 		self.fullLabel:setString("坐骑已满级")
 		self.fullLabel:setVisible(true)

		self.addtionList[1]:setString("")
		self.addtionList[2]:setString("")
		self.addtionList[3]:setString("")
		self.addtionList[4]:setString("")
		self.addtionList[5]:setString("")
		self.addtionList[6]:setString("")
		self.addtionList[7]:setString("")
		self.nameLabel2:setString("")
		if self.animation2 then
		    self.animation2:setVisible(false)
		    --self.animation2 = nil
		end

		return
	end

	local nextEquipAttr = configHelper:getEquipValidAllAttrByEquipId(nextConfig.next_id)
	self.nameLabel2:setString(configHelper:getGoodNameByGoodId(nextConfig.next_id))

	if nextConfig ~= nil  then
        self.animationId2 = configHelper:getGoodResId(nextConfig.next_id) 
        ArmatureManager:getInstance():loadModel(self.animationId2, function(armatureData, mid)
        	if self.isDestory then return end
        	if self.animationId2 == nil then
		        return 
		    end
		    if self.animation2 then
		       self.animation2:removeSelf()
		       self.animation2 = nil
		    end
		 
		    self.animation2 = ccs.Armature:create(mid)
		    self.animation2:setPosition(100, 72)
		    self.animation2:setScale(1.4)
		    self.mountLayerR:addChild(self.animation2)
		    self.animation2:getAnimation():play("stand_3")
        	end)
    end

	hp = nextEquipAttr.hp - hp
 	mp = nextEquipAttr.mp - mp
 	min_ac = nextEquipAttr.min_ac - min_ac
 	max_ac = nextEquipAttr.max_ac - max_ac
 	min_mac = nextEquipAttr.min_mac - min_mac
 	max_mac = nextEquipAttr.max_mac - max_mac
 	min_sc = nextEquipAttr.min_sc - min_sc
 	max_sc = nextEquipAttr.max_sc - max_sc
 	min_def = nextEquipAttr.min_def - min_def
 	max_def = nextEquipAttr.max_def - max_def
 	min_res = nextEquipAttr.min_res - min_res
 	max_res = nextEquipAttr.max_res - max_res
 	speed = nextEquipAttr.speed - speed

	self.addtionList[1]:setString("+"..hp)
	self.addtionList[2]:setString("+"..mp)
	
	if self.career == 1000 then
		self.addtionList[3]:setString("+"..min_ac.."-"..max_ac)
	elseif self.career == 2000 then
		self.addtionList[3]:setString("+"..min_mac.."-"..max_mac)
	elseif self.career == 3000 then
		self.addtionList[3]:setString("+"..min_sc.."-"..max_sc)
	end
	
	self.addtionList[4]:setString("+"..min_def.."-"..max_def)
	self.addtionList[5]:setString("+"..min_res.."-"..max_res)
	self.addtionList[6]:setString("+"..(nextEquipAttr.mounts_p/100).."%")
	self.addtionList[7]:setString("+"..speed)

	if self.commonItem == nil then
        self.commonItem = CommonItemCell.new()
        self.commonItem:setData({goods_id = nextConfig.stuff[1][1]})
        self.itemBg:addChild(self.commonItem, 10,10)
        self.commonItem:setPosition(self.itemBg:getContentSize().width/2, self.itemBg:getContentSize().height/2)
        self.commonItem:setScale(0.8)
    else
        self.commonItem:setData({goods_id = nextConfig.stuff[1][1]})
    end

    self.needNum = nextConfig.stuff[1][2]
    self.nowNum = BagManager:getInstance():findItemCountByItemId(nextConfig.stuff[1][1])
    self.needGoodsId = nextConfig.stuff[1][1]

    self.upgradeKey = nextConfig.key

    self.itemNum:setString(self.nowNum.."/"..self.needNum)

end

function RideUpView:handleClick(tag)

	self.type = tag
end

function RideUpView:onLoadModelCompleted(armatureData, mid)
	 
    
end

function RideUpView:open()
	GlobalEventSystem:addEventListener(RoleEvent.UPDATE_RIDE_INFO,handler(self,self.setViewInfo))
	--self.confirmBtn:setButtonEnabled(false)
    --self:setViewInfo(nil)
end

function RideUpView:onClickClose()
	GlobalEventSystem:removeEventListener(RoleEvent.UPDATE_RIDE_INFO)
	self:removeSelf()
end

function RideUpView:destory()
	GlobalEventSystem:removeEventListener(RoleEvent.UPDATE_RIDE_INFO)
	self.super.destory(self)
end
 
return RideUpView