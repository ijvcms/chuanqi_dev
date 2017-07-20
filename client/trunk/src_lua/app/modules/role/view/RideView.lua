--
-- Author: Yi hanneng
-- Date: 2016-09-02 17:26:27
--
local RideView = RideView or class("RideView", BaseView)

function RideView:ctor()

	self.ccui = cc.uiloader:load("resui/roleMountWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setNodeEventEnabled(true)

end

function RideView:init()

	self.type = 0

	self.helpBtn = cc.uiloader:seekNodeByName(self.ccui, "helpBtn")
	self.mountLayer = cc.uiloader:seekNodeByName(self.ccui, "mountLayer")
 
	self.attrList = {}
	self.attrList[1] = cc.uiloader:seekNodeByName(self.ccui, "attr1")
	self.attrList[2] = cc.uiloader:seekNodeByName(self.ccui, "attr2")
	self.attrList[3] = cc.uiloader:seekNodeByName(self.ccui, "attr3")
	self.attrList[4] = cc.uiloader:seekNodeByName(self.ccui, "attr4")
	self.attrList[5] = cc.uiloader:seekNodeByName(self.ccui, "attr5")
	self.attrList[6] = cc.uiloader:seekNodeByName(self.ccui, "attr6")

	self.des3 = cc.uiloader:seekNodeByName(self.ccui, "des3")
	self.levelUpBtn = cc.uiloader:seekNodeByName(self.ccui, "levelUpBtn")
	self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
	
	self.nameList = {}
	self.iconList = {}
	self.strengthenBtn = {}
 
	-------------leftLayer-------
	for i=1,4 do
		
		self.iconList[i] = display.newSprite():addTo(cc.uiloader:seekNodeByName(self.ccui, "iconImg"..i))
		self.iconList[i]:setAnchorPoint(0.5,0.5)
		self.iconList[i]:setPosition(cc.uiloader:seekNodeByName(self.ccui, "iconImg"..i):getContentSize().width/2, cc.uiloader:seekNodeByName(self.ccui, "iconImg"..i):getContentSize().height/2)

		self.nameList[i] = cc.uiloader:seekNodeByName(self.ccui, "nameLabel"..i)
		self.strengthenBtn[i] = cc.uiloader:seekNodeByName(self.ccui, "strengthenBtn"..i)

		local btnTips = BaseTipsBtn.new(BtnTipsType["BTN_ROLE_RIDE_STRENG"..i],self.strengthenBtn[i],48,13)
		 
		self.strengthenBtn[i]:setTouchEnabled(true)
		self.strengthenBtn[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
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
 
 	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_RIDE_UP,self.levelUpBtn,56,18)
	self.levelUpBtn:setTouchEnabled(true)
	self.levelUpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.levelUpBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.levelUpBtn:setScale(1.0)
            local upWin = require("app.modules.role.view.RideUpView").new()
            --upWin:setViewInfo(itemData)
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,upWin) 
            
         end     
        return true
    end)
 
    self.helpBtn:setTouchEnabled(true)
    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.helpBtn:setScale(1.0)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(23),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)


    self:setViewInfo(nil)

end

function RideView:setViewInfo(data)
 
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    local wealth = roleManager.wealth
    self.career = career or roleInfo.career
 
    if roleInfo.rideInfo ~= nil  then
        self.animationId = configHelper:getGoodResId(roleInfo.rideInfo.goods_id) 
        ArmatureManager:getInstance():loadModel(self.animationId, handler(self, self.onLoadModelCompleted))
    else
    	self.levelUpBtn:setButtonEnabled(false)
    	for i=1,4 do 
			self.strengthenBtn[i]:setTouchEnabled(false)
		end
    	return
    end

    self.nameLabel:setString(configHelper:getGoodNameByGoodId(roleInfo.rideInfo.goods_id))

    local equipAttr = configHelper:getEquipValidAllAttrByEquipId(roleInfo.rideInfo.goods_id)
  	local hp = 0--equipAttr.hp
 	local mp = 0--equipAttr.mp
 	local min_ac = 0--equipAttr.min_ac
 	local max_ac = 0--equipAttr.max_ac
 	local min_mac = 0--equipAttr.min_mac
 	local max_mac = 0--equipAttr.max_mac
 	local min_sc = 0--equipAttr.min_sc
 	local max_sc = 0--equipAttr.max_sc
 	local min_def = 0--equipAttr.min_def
 	local max_def = 0--equipAttr.max_def
 	local min_res = 0--equipAttr.min_res
 	local max_res = 0--equipAttr.max_res
 	local speed = 0--equipAttr.speed
 
    for i=1,4 do
		
		local config = configHelper:getMarkByTypeCareerLv(i+5, self.career, roleInfo.mark[i+5])
		 
		if config then

			hp = config.hp + hp
		 	mp = config.mp + mp
		 	min_ac = config.min_ac + min_ac
		 	max_ac = config.max_ac + max_ac
		 	min_mac = config.min_mac + min_mac
		 	max_mac = config.max_mac + max_mac
		 	min_sc = config.min_sc + min_sc
		 	max_sc = config.max_sc + max_sc
		 	min_def = config.min_def + min_def
		 	max_def = config.max_def + max_def
		 	min_res = config.min_res + min_res
		 	max_res = config.max_res + max_res
		 	--speed = config.speed +speed

			local Img = ResUtil.getGoodsIcon(config.icon)
			local fileUtil = cc.FileUtils:getInstance()
		    if fileUtil:isFileExist(Img) then
		        display.addImageAsync(Img, function()
		            if self.iconList[i] then
		                self.iconList[i]:setTexture(Img)
		            end
		        end)
		         
		    else
		        self.iconList[i]:setTexture("common/input_opacity1Bg.png")
		    end
	 
			self.nameList[i]:setString(config.name)
		end

	end

	hp = math.floor( (equipAttr.mounts_p/10000 + 1)*hp + equipAttr.hp )
	mp = math.floor( (equipAttr.mounts_p/10000 + 1)*mp + equipAttr.mp )
	min_ac = math.floor( (equipAttr.mounts_p/10000 + 1)*min_ac + equipAttr.min_ac )
	max_ac = math.floor( (equipAttr.mounts_p/10000 + 1)*max_ac + equipAttr.max_ac )
	min_mac = math.floor( (equipAttr.mounts_p/10000 + 1)*min_mac + equipAttr.min_mac )
	max_mac = math.floor( (equipAttr.mounts_p/10000 + 1)*max_mac + equipAttr.max_mac )
	min_sc = math.floor( (equipAttr.mounts_p/10000 + 1)*min_sc + equipAttr.min_sc )
	max_sc = math.floor( (equipAttr.mounts_p/10000 + 1)*max_sc + equipAttr.max_sc )
	min_def = math.floor( (equipAttr.mounts_p/10000 + 1)*min_def + equipAttr.min_def )
	max_def = math.floor( (equipAttr.mounts_p/10000 + 1)*max_def + equipAttr.max_def )
	min_res = math.floor( (equipAttr.mounts_p/10000 + 1)*min_res + equipAttr.min_res )
	max_res = math.floor( (equipAttr.mounts_p/10000 + 1)*max_res + equipAttr.max_res )
	speed = math.floor( (equipAttr.mounts_p/10000 + 1)*speed + equipAttr.speed )


	self.attrList[1]:setString(hp)
	self.attrList[2]:setString(mp)
	
	if self.career == 1000 then
		self.des3:setString("物理攻击:")
		self.attrList[3]:setString(min_ac.."-"..max_ac)
	elseif self.career == 2000 then
		self.des3:setString("魔法攻击:")
		self.attrList[3]:setString(min_mac.."-"..max_mac)
	elseif self.career == 3000 then
		self.des3:setString("道术攻击:")
		self.attrList[3]:setString(min_sc.."-"..max_sc)
	end
	
	self.attrList[4]:setString(min_def.."-"..max_def)
	self.attrList[5]:setString(min_res.."-"..max_res)
	self.attrList[6]:setString(speed)


end

function RideView:onLoadModelCompleted(armatureData, mid)
	 
    if self.animationId == nil then
        return 
    end
    if self.animation then
       self.animation:removeSelf()
       self.animation = nil
    end
 
    self.animation = ccs.Armature:create(mid)
    self.animation:setPosition(130, 0)
    self.animation:setScale(1.4)
    self.mountLayer:addChild(self.animation)
    self.animation:getAnimation():play("stand_3")
end

function RideView:handleClick(tag)

	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
	self.type = tag
	local info = configHelper:getMarkByTypeCareerLv(tag+5, self.career, roleInfo.mark[tag+5])
 	local upWin = require("app.modules.role.view.RideStrengView").new()
    upWin:setViewInfo(info)
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,upWin)

end

function RideView:open()
	GlobalEventSystem:addEventListener(RoleEvent.UPDATE_RIDE_INFO,handler(self,self.setViewInfo))
	--self.levelUpBtn:setButtonEnabled(false)
    --self:setViewInfo(nil)

end

function RideView:close()
	GlobalEventSystem:removeEventListener(RoleEvent.UPDATE_RIDE_INFO)
end

function RideView:destory()
	self:close()
	self.super.destory(self)
end
 

return RideView