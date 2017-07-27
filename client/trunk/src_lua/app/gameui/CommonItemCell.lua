--[[
Copyright (c) 2013--2015,rongyao/chuanqi
All rights reserved.

文件名称：CommonItemCell.lua
摘    要：通用物品显示框 (用于显示物品的形象，数量，边框)
--]]
local itemTipsWin = require("app.modules.tips.view.itemTipsWin")
local equipTipsWin = require("app.modules.tips.view.equipTipsWin")
local cellWidth = 76
local cellHeight = 76

local CommonItemCell = class("CommonItemCell", function ()
	return display.newNode()
end)

CommonItemCell.isDestory_ = false

--构造与初始化
function CommonItemCell:ctor()
	self.isDestory_ = false
	self:setContentSize(cellWidth,cellHeight)
	-- 背景			
	self.bg = display.newSprite("#com_propBg1.png")
	self:addChild(self.bg, 0)
	self.bg:setVisible(false)
	-- 道具
	self.itemSprite = display.newFilteredSprite():addTo(self,5)
	self.moved = false
	--点击事件
	self.itemSprite:setTouchEnabled(true)
    self.itemSprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.touchBeganX = event.x
            self.touchBeganY = event.y
        elseif event.name == "moved" then
        	self.moved = math.abs(event.x - self.touchBeganX) > 6 or math.abs(event.y - self.touchBeganY) > 6
        elseif event.name == "ended" then
            if not self.moved and self.itemSprite:getCascadeBoundingBox():containsPoint(cc.p(self.touchBeganX, self.touchBeganY)) then
            	SoundManager:playClickSound()
            	self:onItemClick()
            end
            self.moved = false
        end     
        return true
    end)

	self.itemSpriteType     = nil               

	-- 背景框
	self.frameBgSpriteAction 		= nil					
	self.frameBgSprite = display.newSprite():addTo(self,10)
	--self.frameBgSprite:setAnchorPoint(ccp(0.5, 0.5))
	--self.frameBgSprite:setPosition(ccp(cellWidth / 2, cellHeight / 2))
	-- 数量显示			
	self.countLabel 		= display.newTTFLabel({}):addTo(self,17)
	self.countLabel:setTextColor(TextColor.TEXT_WHITE)
	self.countLabel:setString("")
	self.countLabel:setSystemFontSize(18)
	self.countLabel:setAnchorPoint(ccp(1.0, 0.5))
	self.countLabel:setPosition(ccp(cellWidth/2-8, -cellHeight / 2 + 16))

	--名称显示
	self.nameLabel 			= nil

	self.isLock 			= false					-- 显示lock
	self.lockSprite 		= nil					-- lock精灵
	self.secureSprite = nil -------secure

	self.scale 				= 1.0                  	-- 缩放比例

	self.data 				= nil					-- 物品配置

	self.itemClickFunc 		= nil 					-- 点击回调
	self:setNodeEventEnabled(true)
end

function CommonItemCell:initCheckButton()
	if self.cb then
		return
	end
	-- 选中复选框
	self.cb = cc.ui.UICheckBoxButton.new({off = "#com_chkBtn1.png",on ="#com_chkBtn1Sel.png"}):addTo(self,15)
	self.cb:setTouchEnabled(false)
	self.cb:setPosition(ccp(cellWidth/2-12, cellHeight / 2 - 12))
	
end

--设置数据
function CommonItemCell:setData(data)
	if self.data and table.nums(self.data) == table.nums(data) then
		local same = true
		for k,v in pairs(self.data) do
			if type(v) ~= "table" and v ~= data[k] then
				same = false
				break
			end
		end
		if same then
			self.data = data --里面的字典没判定，但是界面不需要用到
			return
		end
	end
	self:clear()
	self.data = data
	self.isFrameBgSpriteAction = true
	self:setItemSpriteByData(data)
	self.bg:setVisible(true)

end

function CommonItemCell:onEnter()
end

function CommonItemCell:onCleanup()
	self.isDestory_ = true
	self:clearGuide()
	if self.itemSprite then
		self.itemSprite:removeSelf()
	end
	if self.path then
		local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(self.path)
		if texture and texture:getReferenceCount() == 1 then
			cc.Director:getInstance():getTextureCache():removeTextureForKey(self.path)
		end
	end
	self.itemSprite = nil
	self:unscheduleUpdate()

end

function CommonItemCell:getData()
	return self.data
end

-- 按配置设置物品精灵
function CommonItemCell:setItemSpriteByData(data)

	if data.goods_id == 0 then
		return
	end
	local goodId = data.goods_id 			--物品id
	--根据物品id取得图标id
	-- local configHelper = import("app.utils.ConfigHelper").getInstance()
	local iconId = configHelper:getIconByGoodId(goodId)
 
	--图标id
	self.path = ResUtil.getGoodsIcon(iconId)
	--是否存在这个文件
	local fileUtil = cc.FileUtils:getInstance()
	--清掉原来的物品精灵
	self.itemSprite:clearFilter()
	--设置物品精灵
	if fileUtil:isFileExist(self.path) then
		display.addImageAsync(self.path, function()
			-- local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(path)
			-- if texture then
			-- 	self.itemSprite:setTexture(texture)
   --              self.itemSprite:setTextureRect(texture:getContentSize());
			-- end--和下面的一样
			if self.itemSprite then
				self.itemSprite:setTexture(self.path)
			end
			
			
		end)
		self.itemSpriteType = 1
	else
		self.itemSprite:setTexture("common/input_opacity1Bg.png")
		self.itemSprite:setContentSize(70,70)
		self.itemSprite:setPosition(-35,-35)
		self.itemSpriteType = 2
	end
    --强化等级
    if data.stren_lv and data.stren_lv > 0 then
    	self:setStrengVisible(true)
    	self:setStreng(data.stren_lv)
    else
    	self:setStrengVisible(false)
    end
 
    --单神,双神
    self:setArtifact(data.artifact_star)

    if self.frameBgSpriteAction then
    	self.frameBgSpriteAction:removeSelf()
    	self.frameBgSpriteAction = nil
    end
    local quality = configHelper:getGoodQualityByGoodId(goodId)
    --1品质只有静态图片，其他动画特效
    --边框颜色
    self.frameBgSprite:setSpriteFrame(self:getQualityPic(quality))
    if configHelper:getGoodIconEffectByGoodId(goodId) ~= "" and quality > 1 then 
    	self.realEffect = configHelper:getGoodIconEffectByGoodId(goodId)
    	self:playEffect(self.realEffect)
    else
    	self.realEffect = nil
    end
    --是否绑定 --投保
    self:setLock(data.is_bind == 1)
    --投保
   
    if data.secure and data.secure > 0 then
    	self:setSecure(true)
    else
    	self:setSecure(false)
    end

     --设置铸魂图标
    self:setSoul(data.soul)
    self:showKuaFu(data.is_use)
end

local function _getEquipCanUse(is_use)
	if is_use == nil then
        --print(is_use,"true")
        return true
    elseif is_use == 0 then
        --print(is_use,"false")
        return false
    end
    --print(is_use,"true")
    return true
end

local function _isEquipCanUse(is_use)
	if EquipUtil and EquipUtil.getEquipCanUse then
		return EquipUtil.getEquipCanUse(is_use)
	else
		return _getEquipCanUse(is_use)
	end
end

-- 显示提升箭头
function CommonItemCell:showKuaFu(is_use)

		-- 提升箭头
	if _isEquipCanUse(is_use) then
		if self.pa then
			self.pa:setVisible(false)
		end
	else
		if self.pa == nil then
			self.pa = display.newSprite("#com_equipUpArr.png"):addTo(self,15)
			self.pa:setPosition(ccp(cellWidth/2-16, -cellHeight / 2 + 50))
			self.pa:setTouchEnabled(false)
		end
		self.pa:setVisible(true)
	end
end


--播放品质动画特效
function CommonItemCell:playEffect(action)
    self.effectAction = action 
    
  --   if nil == self.frameHandle then
  --   	self.frameHandle = self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
		-- 	self:update_(...)
		-- end)
  --   end
  --   self:scheduleUpdate()
  --   ArmatureManager:getInstance():asyLoadEffect(action)
end

function CommonItemCell:update_()
	if self.isDestory_ or self.isDestory_ == nil then return end
	if ccs.ArmatureDataManager:getInstance():getArmatureData(self.effectAction) then
		self:unscheduleUpdate()
		if  not self.isFrameBgSpriteAction or self.effectAction ~= self.realEffect then
        	return
        end
        if self.frameBgSpriteAction then
        	self.frameBgSpriteAction:removeSelf()
        end
        self.frameBgSpriteAction = ccs.Armature:create(self.effectAction)
        self:addChild(self.frameBgSpriteAction, 10)
        self.frameBgSpriteAction:getAnimation():play("effect")
        self.frameBgSpriteAction:setNodeEventEnabled(true, function(event)
            if event.name == "cleanup" then
                ArmatureManager:getInstance():unloadEffect(self.effectAction)
            end 
        end)
	end
end

function CommonItemCell:setFrameVisible(b)
	if self.frameBgSprite then
		self.frameBgSprite:setVisible(b)
	end
	if self.frameBgSpriteAction then
		self.frameBgSpriteAction:setVisible(b)
	end

	self.isFrameBgSpriteAction = b

end

function CommonItemCell:setBgVisible(b)
	if self.bg then
		self.bg:setVisible(b)
	end
end

function CommonItemCell:setTouchSwallowEnabled(bSwallow)
	if self.itemSprite then
		self.itemSprite:setTouchSwallowEnabled(bSwallow)
	end
end

function CommonItemCell:setTouchEnabled(bSwallow)
	if self.itemSprite then
		self.itemSprite:setTouchEnabled(bSwallow)
	end
end

-- 设置点击回调函数
function CommonItemCell:setItemClickFunc(func)
	self.itemClickFunc = func
end

-- 点击回调
function CommonItemCell:onItemClick()
	if self.itemClickFunc then
		self.itemClickFunc(self)
	else

        local goodType = configHelper:getGoodTypeByGoodId(self.data.goods_id)
        if not goodType then return end
        if goodType == 2 then           --装备
           local eTWin = equipTipsWin.new()
           	eTWin:setData(EquipUtil.formatEquipItem(self.data),true)
           	eTWin.btnSell:setVisible(false)
           	eTWin.btnPutOn:setVisible(false)
           	eTWin.btnTakeOff:setVisible(false)
           	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,eTWin)
        else      --道具
           	local itWin = itemTipsWin.new()
            itWin:setData(self.data)
            itWin.btnUse:setVisible(false)
            itWin.btnSell:setVisible(false)
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,itWin)
        end
    end

    if self.data then
    	GlobalController.guide:notifyEventWithConfirm(self.data.goods_id)
    end
end

-- 设置整个cell是否显示
function CommonItemCell:setChildVisible(bVisible)
	self.bg:setVisible(bVisible)
	self.frameBgSprite:setVisible(bVisible)
	if self.frameBgSpriteAction then
		self.frameBgSpriteAction:setVisible(bVisible)
	end
	self.isFrameBgSpriteAction = bVisible
	self.itemSprite:setVisible(bVisible)
	self.countLabel:setVisible(bVisible)
end

-- 设置数字 默认并显示
function CommonItemCell:setCount(count)
	if count == nil then return end
	self.countLabel:setString("x"..count)
end

-- 设置数字显示 默认是0
function CommonItemCell:setCountVisible(bVisible)
	self.countLabel:setVisible(bVisible)
end

function CommonItemCell:setCBVisible(enabled)
	if not enabled and self.cb == nil then
		return
	end
	self:initCheckButton()
	self.cb:setVisible(enabled)
end

function CommonItemCell:getCBVisible()
	if  self.cb == nil then
		return false
	end
	return self.cb:isVisible()
end

function CommonItemCell:setSelected(enabled)
	if not enabled and self.cb == nil then
		return
	end
	self:initCheckButton()
	self.cb:setButtonSelected(enabled)
end

function CommonItemCell:getSelected()
	if  self.cb == nil then
		return false
	end
	return self.cb:isButtonSelected()
end

function CommonItemCell:initStrengLabel()
	if self.streng then
		return
	end
	--强化等级显示
	self.streng = display.newTTFLabel({}):addTo(self,15)
	self.streng:setString(0)
	self.streng:setAnchorPoint(ccp(0.5, 0.5))
	self.streng:setPosition(ccp(cellWidth/2 - 24, cellHeight / 2 - 18))
end

function CommonItemCell:setStrengVisible(enabled)
	self.isStreng = enabled
	if  self.streng then
		self.streng:setVisible(enabled)
	end
	if enabled then
		self:initStrengLabel()
	end
end

function CommonItemCell:setStreng(value)
	self:initStrengLabel()
	self.streng:setString("+"..value)
end

function CommonItemCell:setArtifact(star)
	if self.artifact then
		self.artifact:removeSelf()
		self.artifact = nil
	end
	if not star then return end

	if star == 1 then 			--单神
		self.artifact = display.newSprite("#com_singleArt.png"):addTo(self, 15)
		self.artifact:setPosition(-20, -12)
	elseif star == 2 then 		--双神
		self.artifact = display.newSprite("#com_doubleArt.png"):addTo(self, 15)
		self.artifact:setPosition(-20, -12)
	end
end

function CommonItemCell:setNameShow(b,yy)
	if not self.data then return end
	if b==true then
		if not self.nameLabel then				
			self.nameLabel 		= display.newTTFLabel({size=18}):addTo(self,15)
			--display.setLabelFilter(self.nameLabel)
			self.nameLabel:setString(configHelper:getGoodNameByGoodId(self.data.goods_id))
			self.nameLabel:setVisible(true)
			self.nameLabel:setAnchorPoint(ccp(0.5, 0.5))
			yy = yy or -cellHeight / 2 - 18
			self.nameLabel:setPosition(cc.p(0, yy))
			local quality = configHelper:getGoodQualityByGoodId(self.data.goods_id)
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
		            self.nameLabel:setColor(color)
		        end
		    end
		end
	else
		if self.nameLabel then
			self.nameLabel:setVisible(false)
		end
	end
end

-- 检查并设置变灰
function CommonItemCell:checkAndSetGray(bIsGray)
	
	if bIsGray then
		local curfilter = filter.newFilter("GRAY")
	    curfilter:initSprite(nil)
		self.itemSprite:setGLProgramState(curfilter:getGLProgramState()) --使用

		self:setFrameVisible(false)
	else
		self.itemSprite:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP"))
		self:setFrameVisible(true)
	end
	 
end

-- 设置是否显示锁
function CommonItemCell:setLock(bisLock)
	if bisLock then 
		if not self.lockSprite then
			self.lockSprite = display.newSprite("#com_propTbLock.png")
			self.lockSprite:setVisible(false)
			--self.lockSprite:setAnchorPoint(ccp(0.5, 0.5))
			self.lockSprite:setPosition(-self.lockSprite:getContentSize().width - 8 , -self.lockSprite:getContentSize().height-2)
			--self.lockSprite:setScale(self.m_scale)
			self:addChild(self.lockSprite,16)
		end
		self.lockSprite:setVisible(true)
		self.isLock = true 
	else
		if self.lockSprite then 
			self.lockSprite:setVisible(false)
		end
		self.isLock = false 
	end
end

function CommonItemCell:setSecure(bisLock)
	if bisLock then 
		if not self.secureSprite then
			self.secureSprite = display.newSprite("#com_propGoldLock.png")
			self.secureSprite:setVisible(false)
			--self.lockSprite:setAnchorPoint(ccp(0.5, 0.5))
			self.secureSprite:setPosition(-self.secureSprite:getContentSize().width - 8 , -self.secureSprite:getContentSize().height-2)
			--self.lockSprite:setScale(self.m_scale)
			self:addChild(self.secureSprite,16)
		end
		self.secureSprite:setVisible(true)
		self.isLock = true 
	else
		if self.secureSprite then 
			self.secureSprite:setVisible(false)
		end
		self.isLock = false 
	end
end

function CommonItemCell:setSoul(soulLv)
	if self.soulRes then
		if self.soulAction then
			self.soulAction:stopAllActions()
			self.itemSprite:removeChild(self.soulAction)
			self.soulAction = nil
			self.soulRes = nil
		end
	end
	if soulLv == nil or soulLv < 1 then
 		return
	end
	
	if self.soulSprite == nil then
		self.soulSprite = display.newSprite("#com_equipSoul_"..soulLv..".png")
		self.soulSprite:setPosition(self.soulSprite:getContentSize().width/2, self.soulSprite:getContentSize().height/2 + 8)
		self.itemSprite:addChild(self.soulSprite)
		self.soulSprite:setLocalZOrder(10)
	else
		self.soulSprite:setSpriteFrame("com_equipSoul_"..soulLv..".png")
	end
	self.soulRes = "equipSoul_effect";
	if soulLv == 6 then
		self.soulRes = "equipSoul_effect2";
	elseif soulLv == 7 then
		self.soulRes = "equipSoul_effect3";
	end
	
	if soulLv >= 5 then
		local callback = function()
		    if self.isDestory_ or self.isDestory_ == nil then
		    	return
		    end
		    self.soulAction = ccs.Armature:create(self.soulRes)
    	    self.itemSprite:addChild(self.soulAction, 10)
    	    self.soulAction:stopAllActions()
    	    self.soulAction:setPosition(self.soulSprite:getPositionX(), self.soulSprite:getPositionY())
    	    self.soulAction:setLocalZOrder(0)
    	    self.soulAction:getAnimation():play("effect")
    	    self.soulAction:setNodeEventEnabled(true, function(event)
                if event.name == "cleanup" then
                    ArmatureManager:getInstance():unloadEffect(self.soulRes)
                end 
            end)
	    end
		ArmatureManager:getInstance():loadEffect(self.soulRes, callback)
    	
	end
	
end

-- 显示提升箭头
function CommonItemCell:showArrow()
		-- 提升箭头
	if self.pa == nil then
		self.pa = display.newSprite("#com_equipUpArr.png"):addTo(self,15)
	    self.pa:setPosition(ccp(cellWidth/2-16, -cellHeight / 2 + 12))
	end
	self.pa:setVisible(true)
end

-- 自动判断显示箭头或是数量
function CommonItemCell:checkNumAndArrow()
	if not self.data then return end
	local goodType = configHelper:getGoodTypeByGoodId(self.data.goods_id)
    if not goodType then return end
    if goodType == 1 or goodType == 3 or goodType == 6 or goodType == 4 or goodType == 5 then
    	--如果是道具或宝石，需要显示数量
        self:setCount(self.data.num)
        self:setCountVisible(true)
    elseif goodType == 2 then
    	--如果是装备，则需要判断是否需要显示提升箭头
        --如果是可穿戴的本职业的装备,并且评分高于身上的装备,则装备显示提升的小箭头
        if EquipUtil.checkPutonEquipPromote(self.data) then
            self:showArrow()
        end
    end
end

-- 自动判断并显示是否已装备的图标
function CommonItemCell:checkIsEquiped()
	local isEquip = false
	if self.data then
		isEquip = self.data.__show_equip_flag__ or false
	end

	if isEquip then
		if not self._view_puton then
			local puton = display.newSprite("#com_wearSign.png")
			puton:setPosition(15, 15)
			self:addChild(puton, 30)
			self._view_puton = puton
		end
	else
		if self._view_puton then
			self._view_puton:removeFromParent()
			self._view_puton = nil
		end
	end
end

-- 清空显示
function CommonItemCell:clear()
	self:setArtifact(nil)  -- 神器单身双神标识
	self.bg:setVisible(false)
	if self.pa then
		self.pa:setVisible(false)
	end
	if self.soulSprite then
		self.soulSprite:removeSelf()
	end

	self.soulSprite = nil

	self.frameBgSprite:setVisible(true)
	if self.frameBgSpriteAction then
		self.frameBgSpriteAction:removeSelf()
		self.frameBgSpriteAction = nil
	end
	self.isFrameBgSpriteAction = false
	
	self.countLabel:setString("")
	self.countLabel:setVisible(true)
	if self.nameLabel then
		self.nameLabel:removeSelf()
		self.nameLabel = nil
	end
	if self.lockSprite then
		self.lockSprite:setVisible(false)
	end

	if self.secureSprite then
		self.secureSprite:setVisible(false)
	end
	self.itemSpriteType     = nil
	self.isLock 			= false					-- 显示lock
	self.scale 				= 1.0                  	-- 缩放比例

	self.data 				= nil					-- 物品配置
	self.itemClickFunc 		= nil
end

function CommonItemCell:setFilter(filter)
	if self.itemSprite and self.itemSpriteType and self.itemSpriteType==1 then
		self.itemSprite:setFilter(filter)
	end
end


-----------------------------------------------------------------------------
-- START---------------------------------------------------------------------
-- MARK GUIDE DEMAND SETUP & CLEAR
function CommonItemCell:setupGuide()
	if self.guideHandle then return end

	-- 处理这个动态引导需求。
	-- 此引导需求用于反馈这个物品在世界坐标系中的位置以及大小。
	self.guideHandle = GlobalController.guide:addDemandEventListener(function(event)
		local demandEvent = event.data
		local guideMark = demandEvent:getGuideMark()

        if guideMark:isDynamic() then
        	local omt_type = guideMark:getOptionType()

        	-- 这里，动态需求类型判断，只有为这个类型的才进行处理。
            if omt_type == GUIMR.OMT_AUTO_CLICK_BAG then
            	local goods_id = self.data.goods_id
            	local goods_id_list = guideMark:getOptionList()
            	for _, v in ipairs(goods_id_list) do
            		if checknumber(v) == goods_id then
	            		local itemParent = self:getParent()
	            		if itemParent then
	            			event:stop()
	            			demandEvent:processed()

	            			-- get item rect box in world space
	            			local worldPoint = itemParent:convertToWorldSpace(cc.p(self:getPosition()))
							local rect = cc.rect(worldPoint.x - 40, worldPoint.y - 40, 80, 80)
							local notifyEvent = GlobalController.guide:createEventWithDemandBack(guideMark:getMark())
							notifyEvent:setData(rect)
							GlobalController.guide:notifyEvent(notifyEvent)
	            		end
	            		break
	            	end
            	end
            end
        end
    end)
end


function CommonItemCell:getQualityPic(quality)
	if quality == GoodsQualityType.WHITE then
		return "com_propWhitePic.png"
	elseif quality == GoodsQualityType.GREEN then
		return "com_propGreenPic.png"
	elseif quality == GoodsQualityType.BLUE then
		return "com_propbluePic.png"
	elseif quality == GoodsQualityType.PURPLE then
		return "com_propPurplePic.png"
	elseif quality == GoodsQualityType.ORANGE then
		return "com_propOrangPic.png"
	elseif quality == GoodsQualityType.RED then
		return "com_propRedPic.png"
	end
	return "com_propWhitePic.png"
end

function CommonItemCell:destory()
	self:unscheduleUpdate()
	self:clear()
end

function CommonItemCell:clearGuide()
	if self.guideHandle then
		GlobalController.guide:removeDemandEventByHandle(self.guideHandle)
		self.guideHandle = nil
	end
end
-- END OF GUIDE ---------------------------------------------------------------

return CommonItemCell