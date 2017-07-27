--
-- Author: Yi hanneng
-- Date: 2016-09-05 17:13:57
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local LocalDatasManager = require("common.manager.LocalDatasManager")
local RideStrengView = RideStrengView or class("RideStrengView", BaseView)

function RideStrengView:ctor()
	
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)
    RideStrengView.super.ctor(self,nil,nil,{url = "resui/roleMountEquipWin.ExportJson"})

    self.ccui = self.root
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	
   	self.ccui:setPosition(display.width/2 - self.ccui:getContentSize().width/2, display.height/2 - self.ccui:getContentSize().height/2)

   	self:init()
end

function RideStrengView:init()

	self.type = 0
	self.nowNum = 0
	self.needNum = 0
	self.needGoodsId = 0
	self.isFull = false
	self.auto = false

	self.addGoodsId = 0
	--记录有没有请求过祝福值
	self.first = false
	self.currentZFValue = 0


	self.itemName = cc.uiloader:seekNodeByName(self.ccui, "itemName")
	self.itemLayer = cc.uiloader:seekNodeByName(self.ccui, "itemLayer")
	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")

	self.lv = cc.uiloader:seekNodeByName(self.ccui, "lv")
	self.lv2 = cc.uiloader:seekNodeByName(self.ccui, "lv2")

	self.itemNum = cc.uiloader:seekNodeByName(self.ccui, "numLabel")
	self.itemBg = cc.uiloader:seekNodeByName(self.ccui, "itemBg")
	self.helpBtn = cc.uiloader:seekNodeByName(self.ccui, "helpBtn")
	self.checkBox = cc.uiloader:seekNodeByName(self.ccui, "checkBox")
	self.confirmBtn = cc.uiloader:seekNodeByName(self.ccui, "confirmBtn")
	self.autoBtn = cc.uiloader:seekNodeByName(self.ccui, "autoBtn")
	self.progressBar = cc.uiloader:seekNodeByName(self.ccui, "progressBar")
	self.progressNum = cc.uiloader:seekNodeByName(self.ccui, "progressNum")
 
 	self.attrList = {}
	self.attrList[1] = cc.uiloader:seekNodeByName(self.ccui, "attr1")
	self.attrList[2] = cc.uiloader:seekNodeByName(self.ccui, "attr2")
	self.attrList[3] = cc.uiloader:seekNodeByName(self.ccui, "attr3")

	self.attrLabelList = {}
	self.attrLabelList[1] = cc.uiloader:seekNodeByName(self.ccui, "attrLabel1")
	self.attrLabelList[2] = cc.uiloader:seekNodeByName(self.ccui, "attrLabel2")
	self.attrLabelList[3] = cc.uiloader:seekNodeByName(self.ccui, "attrLabel3")
 

	self.addtionList = {}
	self.addtionList[1] = cc.uiloader:seekNodeByName(self.ccui, "addtion1")
	self.addtionList[2] = cc.uiloader:seekNodeByName(self.ccui, "addtion2")
	self.addtionList[3] = cc.uiloader:seekNodeByName(self.ccui, "addtion3")
 	
 	--[[
 	self.blackList = {}
 	self.blackList[1] = cc.uiloader:seekNodeByName(self.ccui, "black1")
 	self.blackList[2] = cc.uiloader:seekNodeByName(self.ccui, "black2")
 	self.blackList[3] = cc.uiloader:seekNodeByName(self.ccui, "black3")
	--]]
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
                  tipTxt = configHelper:getRuleByKey(23),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
         end     
        return true
    end)

    self.autoBtn:setTouchEnabled(true)
	self.autoBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.autoBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.autoBtn:setScale(1.0)
      		self.auto = not self.auto
      		
      		if self.auto then
      			self.confirmBtn:setButtonEnabled(false)
      			self.autoBtn:setButtonImage("normal", "#com_labBtn2.png")
        		self.autoBtn:setButtonImage("pressed", "#com_labBtn2.png")
        		self.autoBtn:setButtonLabelString("停止强化")
        		self:requestUpgrade()
      		else
      			self.confirmBtn:setButtonEnabled(true)
      			self.autoBtn:setButtonImage("normal", "#com_labBtn2.png")
        		self.autoBtn:setButtonImage("pressed", "#com_labBtn2.png")
        		self.autoBtn:setButtonLabelString("自动强化")
      		end

         end     
        return true
    end)
	
	self.confirmBtn:setTouchEnabled(true)
	self.confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.confirmBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.confirmBtn:setScale(1.0)
            self:requestUpgrade()

         end     
        return true
    end)
 
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)

            local b = LocalDatasManager:getLocalData("ZF_TIP")

		    if b ~= nil and b.selected  or self.currentZFValue < 1 then
		    	self:close()
		    	return	
		    end
            
            local upWin = require("app.modules.role.view.ZFTips").new()
			upWin:setCallBack(handler(self, self.close))
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,upWin)
            --self:close()
        end     
        return true
    end)

    self.itemImg = display.newSprite():addTo(self.itemLayer)
	self.itemImg:setAnchorPoint(0.5,0.5)
	self.itemImg:setPosition(self.itemLayer:getContentSize().width/2, self.itemLayer:getContentSize().height/2)

	self:open()

end

function RideStrengView:setViewInfo(data)

	if data == nil then
		return
	end

	self.data = data
 
	local Img = ResUtil.getGoodsIcon(data.icon)
	local fileUtil = cc.FileUtils:getInstance()
	if fileUtil:isFileExist(Img) then
		display.addImageAsync(Img, function()
		    if self.itemImg then
		        self.itemImg:setTexture(Img)
		    end
		end)
		         
	else
		self.itemImg:setTexture("common/input_opacity1Bg.png")
	end
	 
	self.itemName:setString(data.name)
	self.lv:setString(data.lv)

	local showArr = self:handlerData(data)

	for i=1,3 do
		if showArr[i] then
			self.attrLabelList[i]:setString(showArr[i].name)
			self.attrList[i]:setString(showArr[i].value)
			--self.blackList[i]:setVisible(true)
		else
			self.attrLabelList[i]:setString("")
			self.attrList[i]:setString("")
			--self.blackList[i]:setVisible(false)
		end
	end
 
	--下一级"type", "lv", "career"
	local nextconfig = configHelper:getMarkByTypeCareerLv(data.type, data.career, data.lv + 1)

	if nextconfig == nil then

		self.isFull = true
		--self.autoBtn:setButtonEnabled(false)
		--self.confirmBtn:setButtonEnabled(false)
		self.nowNum = 0
		self.needNum = 0
		self.needGoodsId = 0
		self.currentZFValue = 0

		self.itemNum:setString("")
		--self.confirmBtn:setButtonLabelString("已满级")
		self.addtionList[1]:setString("")
		self.addtionList[2]:setString("")
		self.addtionList[3]:setString("")

		self.progressNum:setString("0/0")
		self.progressBar:setPercent(0)

		local lastConfig = configHelper:getMarkByTypeCareerLv(data.type, data.career, data.lv - 1)
 		if self.commonItem == nil then
	        self.commonItem = CommonItemCell.new()
	        self.commonItem:setData({goods_id = lastConfig.upgrade_stuff[1][1]})
	        self.itemBg:addChild(self.commonItem, 10,10)
	        self.commonItem:setPosition(self.itemBg:getContentSize().width/2, self.itemBg:getContentSize().height/2)
	        --self.commonItem:setScale(0.8)
	    else
	        self.commonItem:setData({goods_id = lastConfig.upgrade_stuff[1][1]})
	    end

		return
	end

	local showArr2 = self:handlerData2(nextconfig,data)

	for i=1,3 do
		if showArr2[i] then
			self.addtionList[i]:setString("+("..showArr2[i].value..")")
		else
			self.addtionList[i]:setString("")
		end
	end

	-----------
	if self.commonItem == nil then
        self.commonItem = CommonItemCell.new()
        self.commonItem:setData({goods_id = data.upgrade_stuff[1][1]})
        self.itemBg:addChild(self.commonItem, 10,10)
        self.commonItem:setPosition(self.itemBg:getContentSize().width/2, self.itemBg:getContentSize().height/2)
        --self.commonItem:setScale(0.8)
    else
        self.commonItem:setData({goods_id = data.upgrade_stuff[1][1]})
    end

    self.needNum = data.upgrade_stuff[1][2]
    self.nowNum = BagManager:getInstance():findItemCountByItemId(data.upgrade_stuff[1][1])
    self.needGoodsId = data.upgrade_stuff[1][1]

    self.itemNum:setString(self.nowNum.."/"..self.needNum)


    --获取祝福值
    if self.first == false then
    	self.first = true
    	RoleController:getInstance():requestRideEquipZF(self.data.type)
    end
	
end

function RideStrengView:handleClick(tag)

	self.type = tag

end


--强化成功
function RideStrengView:strenSuccess()
 
	self:playStrengEffect()

end

--播强化成功特效
function RideStrengView:playStrengEffect()
    if self.streng then
        self.streng:getAnimation():play("effect")
        self.streng:setPosition(235,470)
        return
    end
    ArmatureManager:getInstance():loadEffect("qianghua")
    self.streng = ccs.Armature:create("qianghua")
    self.itemLayer:addChild(self.streng, 100,100)
    self.streng:setPosition(self.itemLayer:getContentSize().width/2,self.itemLayer:getContentSize().height/2)
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

function RideStrengView:open()

	GlobalEventSystem:addEventListener(RoleEvent.GET_RIDE_ZFINFO,function(data) 

		if data == nil or self.data == nil or self.data.type ~= data.data.mark_type then
			return
		end

		self.needMoney = configHelper:getMarkByTypeCareerLv(self.data.type, self.data.career, self.data.lv + 1)
  	  	if self.needMoney == nil then
  	  		self.currentZFValue = 0
  	  		self.progressNum:setString("0/0")
			self.progressBar:setPercent(0)
  	  		return
  	  	end

  	  	self.currentZFValue = data.data.bless
  	  	self.progressNum:setString(data.data.bless.."/"..self.needMoney.max_bless)
		self.progressBar:setPercent(data.data.bless/self.needMoney.max_bless*100)

		if self.auto then

			if self._handle == nil then
				self._handle = scheduler.scheduleGlobal(function() 
	            	self:requestUpgrade()
	            	scheduler.unscheduleGlobal(self._handle)
					self._handle = nil
	            end, 1)
			end
			
		end

	end)

	GlobalEventSystem:addEventListener(BagEvent.STRENG_SUCCESS,handler(self,self.strenSuccess))
 
	GlobalEventSystem:addEventListener(RoleEvent.UPDATE_RIDE_EQUIP_INFO,function(data) 
		local roleManager = RoleManager:getInstance()
	    local roleInfo = roleManager.roleInfo
		local info = configHelper:getMarkByTypeCareerLv(self.data.type, roleInfo.career, roleInfo.mark[self.data.type])
		self:setViewInfo(info)
	end)
	 
    --self:setViewInfo(nil)
end

local function removeEvent(self)
	if self._handle then

	    scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	      
	end

	GlobalEventSystem:removeEventListener(RoleEvent.GET_RIDE_ZFINFO)
	GlobalEventSystem:removeEventListener(BagEvent.STRENG_SUCCESS)
	GlobalEventSystem:removeEventListener(RoleEvent.UPDATE_RIDE_EQUIP_INFO)
end

function RideStrengView:close()
	removeEvent(self)
	self:removeSelf()
end

function RideStrengView:destory()
	removeEvent(self)
	self.super.destory(self)
end

function RideStrengView:handlerData(data)

	local tem = {}
	if data.hp and data.hp > 0 then
		table.insert(tem, {name = "生命值:", value = data.hp})
	end

	if data.mp and data.mp > 0 then
		table.insert(tem, {name = "魔法值:", value = data.mp})
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

function RideStrengView:handlerData2(data,old)

	local tem = {}
	if data.hp and data.hp > 0 then
		table.insert(tem, {name = "生命值:", value = data.hp - old.hp})
	end

	if data.mp and data.mp > 0 then
		table.insert(tem, {name = "魔法值:", value = data.mp - old.mp})
	end

	if data.max_ac and data.max_ac > 0 then
		table.insert(tem, {name = "物理攻击:", value = data.min_ac - old.min_ac.."-"..data.max_ac - old.max_ac})
	end

	if data.max_mac and data.max_mac > 0 then
		table.insert(tem, {name = "魔法攻击:", value = data.min_mac - old.min_mac.."-"..data.max_mac - old.max_mac})
	end

	if data.max_sc and data.max_sc > 0 then
		table.insert(tem, {name = "道术攻击:", value = data.min_sc - old.min_sc.."-"..data.max_sc - old.max_sc})
	end

	if data.max_def and data.max_def > 0 then
		table.insert(tem, {name = "物理防御:", value = data.min_def - old.min_def.."-"..data.max_def - old.max_def})
	end

	if data.max_res and data.max_res > 0 then
		table.insert(tem, {name = "魔法防御:", value = data.min_res - old.min_res.."-"..data.max_res - old.max_res})
	end

	if data.holy and data.holy > 0 then
		table.insert(tem, {name = "神圣:", value = data.holy - old.holy})
	end

	return tem
 
end

function RideStrengView:requestUpgrade()

	if self.isFull then
		self.confirmBtn:setButtonEnabled(true)
		self.auto = false
		self.autoBtn:setButtonImage("normal", "#com_labBtn2.png")
        self.autoBtn:setButtonImage("pressed", "#com_labBtn2.png")
        self.autoBtn:setButtonLabelString("自动强化")
	    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"所选装备已达最高强化等级")
	    return
	end

	if self.auto or self.checkBox:isButtonSelected() then
		--自动强化或勾选自动购买材料
		if self.data then
		    if self.checkBox:isButtonSelected() then
		    	--勾选自动购买
		    	local roleManager = RoleManager:getInstance()
	    		local wealth = roleManager.wealth
 
	    		if self.needGoodsId ~= 0 then
				    if self.nowNum < self.needNum then
				        if wealth.jade < self.needNum*self.needMoney.stuff_jade then

				        	self.auto = false
							self.autoBtn:setButtonImage("normal", "#com_labBtn2.png")
					        self.autoBtn:setButtonImage("pressed", "#com_labBtn2.png")
					        self.autoBtn:setButtonLabelString("自动强化")
					        self.confirmBtn:setButtonEnabled(true)

				        	local upWin = require("app.modules.recharge.RechargeTips").new()
				        	upWin:setCallBack(handler(self, self.close))
				            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,upWin) 
				        	return 
				        end
				        
				    end
				end
		        RoleController:getInstance():requestRideEquipUpgrade(self.data.type,1)
		        return
		    end
		    --没有勾选自动购买
		    if self.needGoodsId ~= 0 then
			    if self.nowNum < self.needNum then
			    	self.auto = false
					self.autoBtn:setButtonImage("normal", "#com_labBtn2.png")
			        self.autoBtn:setButtonImage("pressed", "#com_labBtn2.png")
			        self.autoBtn:setButtonLabelString("自动强化")
			        self.confirmBtn:setButtonEnabled(true)
			        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, "很抱歉,"..configHelper:getGoodNameByGoodId(self.needGoodsId).."数量不足,可勾选自动购买")
			        return 
			    end
			end

		    RoleController:getInstance():requestRideEquipUpgrade(self.data.type,0)
		end

	else
		--一般的点击强化(非自动强化或非自动购买材料强化)
		if self.needGoodsId ~= 0 then
		    if self.nowNum < self.needNum then
		        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, "很抱歉,"..configHelper:getGoodNameByGoodId(self.needGoodsId).."数量不足,可勾选自动购买")
		        return 
		    end
		end
		 
		if self.data then
		    RoleController:getInstance():requestRideEquipUpgrade(self.data.type,0)
		end

	end

end

return RideStrengView