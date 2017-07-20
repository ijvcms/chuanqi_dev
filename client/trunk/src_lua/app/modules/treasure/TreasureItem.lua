--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-07-01 11:48:25
-- 探宝Item

local TreasureItem = class("TreasureItem", function()
	return display.newNode()
end)

function TreasureItem:ctor(winTag,data,winconfig)

   	self.root = cc.uiloader:load("resui/treasureItem.ExportJson")
	self:addChild(self.root)

    self.mianBg = cc.uiloader:seekNodeByName(self.root, "mianBg")
    self.bgSel = cc.uiloader:seekNodeByName(self.root, "bgSel")
    self.nameLabel = cc.uiloader:seekNodeByName(self.root, "nameLabel")
    self.priceLabel = cc.uiloader:seekNodeByName(self.root, "priceLabel")
  	self.buyBtn = cc.uiloader:seekNodeByName(self.root, "buyBtn")

  	self.coinImg = cc.uiloader:seekNodeByName(self.root, "coinImg") --jb
  	self.coinImg2 = cc.uiloader:seekNodeByName(self.root, "coinImg2") --yb
  	self.coinImg3 = cc.uiloader:seekNodeByName(self.root, "coinImg3") --bdyb

  	self.shadeImg = cc.uiloader:seekNodeByName(self.root, "shadeImg") --bdyb

  	self.signalImg = cc.uiloader:seekNodeByName(self.root, "signalImg")

  	self.vipImg = cc.uiloader:seekNodeByName(self.root, "vipImg")
  	-- self.vipLevelLab = cc.LabelAtlas:_create()
   --  self.vipLevelLab:initWithString(
   --          "",
   --          "fonts/num_style_fight2.png",
   --          27,
   --          60,
   --          string.byte(0))
    
   --          self.vipLevelLab:setTouchEnabled(false)
   --          self:addChild(self.vipLevelLab)

   --      self.vipLevelLab.labType = 1
   --      self.vipLevelLab:setString("")
    self.vipLevelLab = display.newBMFontLabel({
                text = "1234",
                font = "fonts/yellowNumber1.fnt",
                x = 70,
                y = 8,
              })
            --view:setOpacity(180)
    self.vipImg:addChild(self.vipLevelLab)

  	self.openLabel = cc.uiloader:seekNodeByName(self.root, "openLabel")


  	self.mystery_shop_id = 0
  	self.canBuy = false
  	self.buyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
  		if self.canBuy == false then
  			return true
  		end
        if event.name == "began" then
            self.buyBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.buyBtn:setScale(1)
			if self.curr_type == 1 then
				if RoleManager:getInstance().wealth.coin < self.price then
					GlobalMessage:show("金币不足")
					return true
				end
			elseif self.curr_type == 2 then
				if RoleManager:getInstance().wealth.jade < self.price then
					GlobalMessage:show("元宝不足")
					return true
				end
			elseif self.curr_type == 3 then
				if RoleManager:getInstance().wealth.gift < self.price then
					GlobalMessage:show("绑定元宝不足")
					return true
				end
			end
            GameNet:sendMsgToSocket(16101,{mystery_shop_id = self.mystery_shop_id})
            GlobalController.treasure.curBuyItemId = self.mystery_shop_id
        end
        return true
    end)
end


--          <Param name="mystery_shop_id" type="int16" describe="神秘商品id"/>
-- 			<Param name="goods_id" type="int32" describe="道具id"/>
-- 			<Param name="is_bind" type="int8" describe="是否绑定 0非绑 1绑定"/>
-- 			<Param name="num" type="int32" describe="数量"/>
-- 			<Param name="curr_type" type="int8" describe="货币类型"/>
-- 			<Param name="price" type="int32" describe="出售价格"/>
-- 			<Param name="vip" type="int16" describe="vip等级限制"/>
-- 			<Param name="is_buy" type="int8" describe="1 已经被购买，0还未购买"/>
function TreasureItem:setData(data)
	self.vo = data
	local curVIPLevel = RoleManager:getInstance().roleInfo.vip
	self.mystery_shop_id = data.mystery_shop_id
	self.goods_id = data.goods_id
	self.is_bind = data.is_bind
	self.num = data.num
	self.curr_type = data.curr_type
	self.price = data.price
	self.vip = data.vip
	self.is_buy = data.is_buy
	if data.discount ~= self.discount then
		self.discount = data.discount
		if self.discountPic then
			self.signalImg:removeChild(self.discountPic)
			self.discountPic = nil
		end
		self.discountPic = display.newSprite("#"..data.discount..".png")
		self.signalImg:addChild(self.discountPic)
		self.discountPic:setPosition(40,19)
	end


	local goodsConf = configHelper:getGoodsByGoodId(self.goods_id)
	if goodsConf then
		self.nameLabel:setString(goodsConf.name)
	end
	if self.itemCell == nil then
		self.itemCell = CommonItemCell.new()
		self.mianBg:addChild(self.itemCell)
		self.itemCell:setPosition(158/2,260/2+16)
	end
	--self.itemCell:
	self.itemCell:setData({goods_id = self.goods_id, is_bind = self.is_bind, num = self.num})
	self.itemCell:setCount(self.num)

	local goodsConf = configHelper:getGoodsByGoodId(self.goods_id)
	self.itemEffectId = ""
	self:clearItemEffect()
	if goodsConf and goodsConf.quality >= 4 then
		if goodsConf.quality == 4 then
			self.itemEffectId = "treasurePurple"
		elseif goodsConf.quality == 5 then
			self.itemEffectId = "treasureOrange"
		elseif goodsConf.quality == 6 then
			self.itemEffectId = "treasureRed"
		end

		if self.itemEffectId ~= "" then
			ArmatureManager:getInstance():loadEffect(self.itemEffectId)
			self.itemEffect = ccs.Armature:create(self.itemEffectId)
			self.itemEffect:setScaleX(1)
			self.itemEffect:setScaleY(1) 
			self.itemEffect:getAnimation():setSpeedScale(1)
			self:addChild(self.itemEffect,9999)
			self.itemEffect:setPosition(158/2,260/2+16)
			self.itemEffect:stopAllActions()
			self.itemEffect:getAnimation():play("effect")

			local function animationEvent(armatureBack,movementType,movementID)
		    	if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
		    		armatureBack:getAnimation():setMovementEventCallFunc(function()end)
		    		self:clearItemEffect()
		    	end
		    end	
		   	self.itemEffect:getAnimation():setMovementEventCallFunc(animationEvent)
		end
	end

	if self.is_buy == 1 then
		self.buyBtn:setButtonLabelString("已购买")
		self.buyBtn:setTouchEnabled(false)
		local filter = filter.newFilter("GRAY")
    	filter:initSprite(nil)
    	--dump(self.buyBtn.sprite_)
    	for k,v in pairs(self.buyBtn.sprite_) do
    		v:setGLProgramState(filter:getGLProgramState())
    	end
    	--self.buyBtn:setGLProgramState(filter:getGLProgramState()) --使用
    	self.canBuy = false
    	self.shadeImg:setVisible(false)
	else
		self.buyBtn:setButtonLabelString("购买")
		self.buyBtn:setTouchEnabled(true)
		for k,v in pairs(self.buyBtn.sprite_) do
    		--v:setGLProgramState(filter:getGLProgramState())
    		v:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")) --清除
    	end
		
		self.canBuy = true
		self.shadeImg:setVisible(false)
	end

	self.vipLevelLab:setString(self.vip)
	if curVIPLevel >= self.vip then
		self.vipImg:setVisible(false)
		self.openLabel:setVisible(false)
		if self.vipLevelLab then
			self.vipLevelLab:setVisible(false)
		end
	else
		self.canBuy = false
		self.shadeImg:setVisible(true)

		self.vipImg:setVisible(true)
		self.openLabel:setVisible(true)
		if self.vipLevelLab then
			self.vipLevelLab:setVisible(true)
		end
	end

	if self.price then
		self.priceLabel:setString(self.price)
	end
	if self.curr_type == 1 then
		self.coinImg:setVisible(true)
		self.coinImg2:setVisible(false)
		self.coinImg3:setVisible(false)
	elseif self.curr_type == 2 then
		self.coinImg:setVisible(false)
		self.coinImg2:setVisible(true)
		self.coinImg3:setVisible(false)
	elseif self.curr_type == 3 then
		self.coinImg:setVisible(false)
		self.coinImg2:setVisible(false)
		self.coinImg3:setVisible(true)
	end

end

function TreasureItem:setBuy(itemId)
	if self.mystery_shop_id == itemId then
		self.vo.is_buy = 1
		self:setData(self.vo)
	end
end

function TreasureItem:clearItemEffect()
	if self.itemEffect then 
		self.itemEffect:stopAllActions()
		self.itemEffect:getAnimation():stop()
		if self.itemEffect:getParent() then
			self.itemEffect:getParent():removeChild(self.itemEffect)
		end
		self.itemEffect = nil
	end
	if self.itemEffectId ~= "" then
		ArmatureManager:getInstance():unloadEffect(self.itemEffectId)
	end
end
--清理界面
function TreasureItem:destory()
	if self.itemCell then
		self.itemCell:destory()
	end
	self:clearItemEffect()
end

return TreasureItem