--
-- Author: Allen    21102585@qq.com
-- Date: 2017-06-14 20:37:25
-- 场景提示自动寻路or自动战斗效果
local GoodsUtil = require("app.utils.GoodsUtil")
local SceneAutoTipEff = class("SceneAutoTipEff", function()
	return display.newNode()
end)

function SceneAutoTipEff:ctor()
	self.curEffAction = ""
	self.isPlayEff = false
	if self.effArmature == nil then
		local callback = function()
            self.effArmature =  ccs.Armature:create("sceneAutoEff")
            self:addChild(self.effArmature)
            self.effArmature:setTouchEnabled(false)
            -- self.effArmature:getAnimation():play("effect")
            if self.curEffAction ~= "" and self.isPlayEff then
            	self.effArmature:getAnimation():play(self.curEffAction)
            else
            	self.effArmature:getAnimation():stop()
        		self.effArmature:setVisible(false)
            end
        end
		ArmatureManager:getInstance():loadEffect("sceneAutoEff", callback)
	end
end

--开启
function SceneAutoTipEff:open()
	self:setVisible(true)
end

function SceneAutoTipEff:showAutoFighting()
	--print("showAutoFighting",FightModel:getAutoAttackStates(true))
	if FightModel:getAutoAttackStates(true) then
		if FightModel.autoWayStates then return end --如果是自动寻路return
		if self.isPlayEff == true and self.curEffAction == "zhandouEff" then return end
		self.isPlayEff = true
		self.curEffAction = "zhandouEff"
		if self.effArmature then
			self.effArmature:getAnimation():play(self.curEffAction)
			self.effArmature:setVisible(true)
		end
		if self.flyShoes then
			self.flyShoes:setVisible(false)
		end
		if self.deliverRingIcon then 
			self.deliverRingIcon:setVisible(false)
		end
	else
		self:stopEffect()
		self.isPlayEff = false
	end
end

function SceneAutoTipEff:showAutoWay()
	--print("showAutoWay",FightModel.autoWayStates)
	if FightModel.autoWayStates then
		if self.isPlayEff == true and self.curEffAction == "xunluEff" then 
		else
			self.curEffAction = "xunluEff"
			self.isPlayEff = true
			if self.effArmature then
				self.effArmature:getAnimation():play(self.curEffAction)
				self.effArmature:setVisible(true)
			end
		end
		if self.propChangEventId == nil then
	        self.propChangEventId = GlobalEventSystem:addEventListener(BagEvent.PROP_CHANGE, handler(self, self.updateGoodsNum))
	    end
		if self.flyShoes == nil then
			self.flyShoes = display.newSprite("#scene/scene_flyShoes.png")
	    	self:addChild(self.flyShoes)
	    	self.flyShoesNum = BagManager:getInstance():findItemCountByItemId(110078)
	    	self.flyShoesNumLab = display.newBMFontLabel({
	            text = "x"..self.flyShoesNum,
	            font = "fonts/bitmapText_22.fnt",
	        	})
		    self.flyShoesNumLab:setTouchEnabled(false)
		    self.flyShoesNumLab:setColor(cc.c3b(0,255,0))
		    self.flyShoesNumLab:setPosition(35,20)
		    self.flyShoes:addChild(self.flyShoesNumLab)
		    self.flyShoes:setContentSize(100,100)
		    self.flyShoes:setPosition(131,36)
		    self.flyShoes:setTouchEnabled(true)
	    	self.flyShoes:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)

		        if  event.name == "ended" then
		            self.flyShoes:setScale(1)
		            GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_MAIN_SHOES)
		            if self.flyShoesNum > 0 then
		                if SceneManager.autoAwayToSceneId == GameSceneModel.sceneId then
		                    if SceneManager.autoAwayGrid then
		                        local playerVo = GameSceneModel:getPlayerVO()
		                        local dis = FightUtil:getDistance(playerVo.mGrid.x,playerVo.mGrid.y,SceneManager.autoAwayGrid.x,SceneManager.autoAwayGrid.y)
		                        if dis > 2 then
		                            GameNet:sendMsgToSocket(29005,{scene_id = SceneManager.autoAwayToSceneId,x=SceneManager.autoAwayGrid.x ,y = SceneManager.autoAwayGrid.y,is_equip = 0})
		                        else
		                            GlobalAlert:show("距离太近，无需传送")
		                        end
		                    end
		                else
		                    if SceneManager.autoAwayGrid then
		                        GameNet:sendMsgToSocket(29005,{scene_id = SceneManager.autoAwayToSceneId,x=SceneManager.autoAwayGrid.x ,y = SceneManager.autoAwayGrid.y,is_equip = 0})
		                    end
		                end
		            else
		                GlobalAlert:show("小飞鞋不足")
		            end
		        elseif event.name == "began" then
		            self.flyShoes:setScale(1.1)
		        end       
		        return true 
		    end)
		end
		if self.flyShoes then
			self:updateGoodsNum()
			self.flyShoes:setVisible(true)
		end
		local deliverId = self:hasDeliverRingGoodsId()
		if deliverId == 0 then
			if self.deliverRingIcon then
				self.deliverRingIcon:setVisible(false)
			end
		else
			if self.deliverRingIcon == nil then
			    self.deliverRingIcon = display.newSprite(GoodsUtil.getIconPathByGoodId(deliverId))
			    self:addChild(self.deliverRingIcon)
			    self.deliverRingIcon:setPosition(cc.p(160,9))
			    self.deliverRingIcon:setTouchEnabled(true)
			    self.deliverRingIcon:setScale(0.8)
			    self.deliverRingIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			        if  event.name == "ended" then
			            self.deliverRingIcon:setScale(1)
			            if SceneManager.autoAwayToSceneId == GameSceneModel.sceneId then
			                local playerVo = GameSceneModel:getPlayerVO()
			                local dis = FightUtil:getDistance(playerVo.mGrid.x,playerVo.mGrid.y,SceneManager.autoAwayGrid.x,SceneManager.autoAwayGrid.y)
			                if dis > 2 then
			                    GameNet:sendMsgToSocket(29005,{scene_id = SceneManager.autoAwayToSceneId,x=SceneManager.autoAwayGrid.x ,y = SceneManager.autoAwayGrid.y,is_equip = 1})
			                else
			                    GlobalMessage:show("距离太近，无需传送")
			                end
			            else
			                GameNet:sendMsgToSocket(29005,{scene_id = SceneManager.autoAwayToSceneId,x=SceneManager.autoAwayGrid.x ,y = SceneManager.autoAwayGrid.y,is_equip = 1})
			            end
			            
			        elseif event.name == "began" then
			            self.deliverRingIcon:setScale(1.1)
			        end       
			        return true  
			    end)
			end
			self.deliverRingIcon:setVisible(true)
		end
	else
		if self.propChangEventId then
            GlobalEventSystem:removeEventListenerByHandle(self.propChangEventId)
            self.propChangEventId = nil
        end
        if self.deliverRingIcon then
			self.deliverRingIcon:setVisible(false)
		end
		if self.flyShoes then
			self.flyShoes:setVisible(false)
		end
        self:stopEffect()
        self.isPlayEff = false
		self:showAutoFighting()
	end
end

--停止效果
function SceneAutoTipEff:stopEffect()
	if self.effArmature and self.isPlayEff then
		self.effArmature:getAnimation():stop()
		self.effArmature:setVisible(false)
	end
end


--更新物品数量
function SceneAutoTipEff:updateGoodsNum(data)
    if self.flyShoesNumLab then
        self.flyShoesNum = BagManager:getInstance():findItemCountByItemId(110078)
        self.flyShoesNumLab:setString("x"..self.flyShoesNum)
    end
end
--判断是否有传送芥子
function SceneAutoTipEff:hasDeliverRingGoodsId()
    --getGoodsByGoodId
    local roleManager = RoleManager:getInstance()
    if not roleManager.roleInfo  then return end
    local equipList = roleManager.roleInfo.equip
    for _,equipItem in ipairs(equipList or {}) do
        if GoodsUtil.canDeliverByGoodsId(equipItem.goods_id) then
            return equipItem.goods_id
        end
    end
    return 0
end

--关闭
function SceneAutoTipEff:close()
    if self.propChangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.propChangEventId)
        self.propChangEventId = nil
    end
    if self.effArmature then
		self.effArmature:getAnimation():stop()
		self.effArmature:setVisible(false)
	end
	self:setVisible(false)
end
--销毁
function SceneAutoTipEff:destory()
	self:close()
end

return SceneAutoTipEff
