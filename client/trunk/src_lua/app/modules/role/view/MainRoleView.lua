--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-23 11:46:57
-- 主角主界面
local MainRoleView = class("MainRoleView", BaseView)
function MainRoleView:ctor(winTag,data,winconfig)
	MainRoleView.super.ctor(self,winTag,data,winconfig)
	
	self.roleInfoVO = RoleManager:getInstance().roleInfo
	self.roleWealthVO = RoleManager:getInstance().wealth

	self.topH = 160
	self.topContainer = display.newNode()
	self:addChild(self.topContainer)
	self.topContainer:setPosition(0,display.height-self.topH)
	
	self.middleH = 600
	self.middleW = 600
	self.middleContainer = display.newNode()
	self:addChild(self.middleContainer)
	self.middleContainer:setPosition(20,display.cy - self.middleH/2-20)
	self.resList = {
		[1] = "ui/pic_side_line.png",
		[2] = "",
		[3] = "",
		[4] = "",
		[5] = "",
		[6] = "",
	}
	self:initTopView()
	self:initMiddleView()
end

--初始化顶部属性
function MainRoleView:initTopView()
	local topBg = display.newScale9Sprite(self.resList[1], 0, 0,cc.size(display.width,self.topH))
	topBg:setPosition(display.cx,self.topH/2)
	topBg:setTouchEnabled(false)
	self.topContainer:addChild(topBg)
	
	--职业
	self.careerLab =  self:createLab(RoleCareerName[self.roleInfoVO.career])
	self.topContainer:addChild(self.careerLab)
	self.careerLab:setPosition(20,self.topH - 60)

	--级别
	self.lvLab =  self:createLab("lv."..self.roleInfoVO.lv)
	self.topContainer:addChild(self.lvLab)
	self.lvLab:setPosition(100,self.topH - 60)

	--金币
	self.coinLab =  self:createLab("金币:"..self.roleWealthVO.coin)
	self.topContainer:addChild(self.coinLab)
	self.coinLab:setPosition(230,self.topH - 60)

	--元宝
	self.jadeLab =  self:createLab("元宝:"..self.roleWealthVO.jade)
	self.topContainer:addChild(self.jadeLab)
	self.jadeLab:setPosition(380,self.topH - 60)

	--VIP
	self.vipLab =  self:createLab("VIP:"..self.roleInfoVO.vip)
	self.topContainer:addChild(self.vipLab)
	self.vipLab:setPosition(520,self.topH - 60)

	--jingyan
	self.expLab =  self:createLab("EXP:"..self.roleInfoVO.exp)
	self.topContainer:addChild(self.expLab)
	self.expLab:setPosition(20,self.topH - 100)

	--jingyan
	self.equipLab =  self:createLab("装 备",50)
	self.topContainer:addChild(self.equipLab)
	self.equipLab:setPosition(260,self.topH - 150)
end

--初始化中间装备
function MainRoleView:initMiddleView()
	local middleBg = display.newScale9Sprite(self.resList[1], 0, 0,cc.size(self.middleW,self.middleH))
	middleBg:setPosition(self.middleW/2,self.middleH/2)
	middleBg:setTouchEnabled(false)
	self.middleContainer:addChild(middleBg)

	--生命
	self.hpLab =  self:createLab("生命:"..self.roleInfoVO.hp)
	self.middleContainer:addChild(self.hpLab)
	self.hpLab:setPosition(20,self.middleH - 40)

	--法力
	self.mpLab =  self:createLab("法力:"..self.roleInfoVO.mp)
	self.middleContainer:addChild(self.mpLab)
	self.mpLab:setPosition(300,self.middleH - 40)

	--物攻
	self.acLab =  self:createLab("物攻:"..self.roleInfoVO.min_ac.."-"..self.roleInfoVO.max_ac)
	self.middleContainer:addChild(self.acLab)
	self.acLab:setPosition(20,self.middleH - 80)

	--法攻
	self.macLab =  self:createLab("法攻:"..self.roleInfoVO.min_mac.."-"..self.roleInfoVO.max_mac)
	self.middleContainer:addChild(self.macLab)
	self.macLab:setPosition(20,self.middleH - 110)

	--道攻
	self.scLab =  self:createLab("道攻:"..self.roleInfoVO.min_sc.."-"..self.roleInfoVO.max_sc)
	self.middleContainer:addChild(self.scLab)
	self.scLab:setPosition(20,self.middleH - 140)


	--物防
	self.defLab =  self:createLab("物防:"..self.roleInfoVO.def)
	self.middleContainer:addChild(self.defLab)
	self.defLab:setPosition(207,self.middleH - 80)

	--法防
	self.resLab =  self:createLab("法防:"..self.roleInfoVO.res)
	self.middleContainer:addChild(self.resLab)
	self.resLab:setPosition(207,self.middleH - 110)

	--准确
	self.hitLab =  self:createLab("准确:"..self.roleInfoVO.hit)
	self.middleContainer:addChild(self.hitLab)
	self.hitLab:setPosition(207,self.middleH - 140)


	--敏捷
	self.dodgeLab =  self:createLab("敏捷:"..self.roleInfoVO.dodge)
	self.middleContainer:addChild(self.dodgeLab)
	self.dodgeLab:setPosition(394,self.middleH - 80)

	--更多
	self.moreLab =  self:createLab("更多...",30,cc.c3b(255,0,0))
	self.middleContainer:addChild(self.moreLab)
	self.moreLab:setPosition(394+100,self.middleH - 140)


	local manager = ccs.ArmatureDataManager:getInstance()
	self.indexx = 0 
	local function dataLoaded(percent)
		self.indexx = self.indexx +1
		if self.indexx < 2 then return end
		self.armature = ccs.Armature:create(500)
		--self.armature:setScale(2)

		self.middleContainer:addChild(self.armature)
		--self.armature:getAnimation():setSpeedScale(self.animationSpeed)
    	self.armature:stopAllActions()    
    	self.armature:getAnimation():play("walk_1")--FightAction.STAND)
    	self.armature:setPosition(self.middleW/2,self.middleH/2-200)
		--self.armature:init(modelID)


		self.equip = ccs.Armature:create(309)
		self.middleContainer:addChild(self.equip)
		self.equip:getAnimation():play("effect")
		self.equip:setPosition(self.middleW/2,self.middleH/2-80)

		self.btnClose = display.newSprite("ttgame/btnClose.png")
		self.middleContainer:addChild(self.btnClose)
		self.btnClose:setPosition(self.middleW/2,self.middleH/2-200)
	end
	manager:addArmatureFileInfoAsync("model/500/500.ExportJson", dataLoaded)
	manager:addArmatureFileInfoAsync("ttgame/effect/309/309.ExportJson", dataLoaded)


	self.pos = cc.p(self.middleW/2,self.middleH/2-200)
	self.index = 1
	self.middleContainer:setTouchEnabled(true)
	self.middleContainer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)  
	  				
         			if event.name == "began" then
         				local nodePoint = self.middleContainer:convertToNodeSpace(cc.p(event.x, event.y))

         				--print(nodePoint.x,nodePoint.y,self.middleW/2,self.middleH/2-200)
         				--dump(nodePoint)

         				local ang = FightUtil:getAngle(self.pos,nodePoint)
         				print(ang)
         				if ang<-67.5 and ang >= -112.5 then
         					self.index = 1
         				elseif ang<-22.5 and ang >= -67.5 then
         					self.index = 2
         				elseif ang<22.5 and ang >= -22.5 then
         					self.index = 3
         				elseif ang<67.5 and ang >= 22.5 then
         					self.index = 4
         				elseif ang<112.5 and ang >= 67.5 then
         					self.index = 5
         				elseif ang<157.5 and ang >= 112.5 then
         					self.index = 6
         				elseif ang>=157.5 or ang < -157.5 then
         					self.index = 7
         				elseif ang>=-157.5 and ang < -112.5 then
         					self.index = 8
         				end

         				self.armature:setPosition(self.middleW/2,self.middleH/2-200)
         				self.armature:setPosition(self.middleW/2,self.middleH/2-200)

         				--self.index = self.index +1
         				if self.index > 8 then
         					self.index = 1
         				end
         				--print("GGG",self.index)
         				local action = "walk"--"attack"--"walk"--"stand"

         				if self.index== 5 then
         					self.armature:setLocalZOrder(1999)
         					self.equip:setLocalZOrder(1998)
         				else
         					self.armature:setLocalZOrder(1998)
         					self.equip:setLocalZOrder(1999)
         				end
         				if self.index == 1 then
         					self.armature:setScaleX(1)
         					self.armature:getAnimation():play(action.."_1")
         				elseif self.index == 2 then
         					self.armature:setScaleX(1)
         					self.armature:getAnimation():play(action.."_2")
         				elseif self.index == 3 then
         					self.armature:setScaleX(1)
         					self.armature:getAnimation():play(action.."_3")
         				elseif self.index == 4 then
         					self.armature:setScaleX(1)
         					self.armature:getAnimation():play(action.."_4")
         				elseif self.index == 5 then
         					self.armature:setScaleX(1)
         					self.armature:getAnimation():play(action.."_5")
         				elseif self.index == 6 then
         					self.armature:setScaleX(-1)
         					self.armature:getAnimation():play(action.."_4")
         				elseif self.index == 7 then
         					self.armature:setScaleX(-1)
         					self.armature:getAnimation():play(action.."_3")
         				elseif self.index == 8 then
         					self.armature:setScaleX(-1)
         					self.armature:getAnimation():play(action.."_2")
         				end




         			end
         			
         			return true
       			end)

end

function MainRoleView:destory()
	if self.armature then
		self.armature:stopAllActions() 
		self.middleContainer:removeChild(self.armature) 
		self.armature = nil
	end
	local manager = ccs.ArmatureDataManager:getInstance()
	manager:removeArmatureFileInfo("model/500/500.ExportJson")
    self.super.destory(self)
end

function MainRoleView:createLab(text,fontSize,textColor)
	local text = display.newTTFLabel({
    	  	text = text or " ",    	
    	  	size = fontSize or 30,
    	  	color = textColor or cc.c3b(255,255,255),  
    	  	align = cc.TEXT_ALIGNMENT_LEFT,    	
    	  	-- dimensions = cc.size(600, 60)
	  	})
	text:setAnchorPoint(0,0)
    text:setTouchEnabled(false)
    return text
end

return MainRoleView