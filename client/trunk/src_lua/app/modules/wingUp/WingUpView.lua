--
-- Author: shine
--


local WingUpView = class("WingUpView", BaseView)

function WingUpView:ctor(winTag,data,winconfig)
	WingUpView.super.ctor(self,winTag,data,winconfig)
  local root = self:getRoot()

  self.controller = GlobalController.wingUp
  -- 左边
  self.goldBuyBtn = self:seekNodeByName("coinBtn")
  self.goldLabel =  cc.uiloader:seekNodeByName(self.goldBuyBtn, "valueLabel")

  self.jadeBuyBtn = self:seekNodeByName("coinBtn2")
  self.jadeLabel =  cc.uiloader:seekNodeByName(self.jadeBuyBtn, "valueLabel")
  
  self.curWingNameLabel = self:seekNodeByName("leftName")
  self.goldLabel = self:seekNodeByName("valueLabel")
  self.leftBgImg = self:seekNodeByName("leftImg")
  self.hiddenBtn = self:seekNodeByName("hiddenBtn")
  self.checkFlag = self:seekNodeByName("tick")
  self.redBar = self:seekNodeByName("redBar")
  self.needsGoodsLabel = self:seekNodeByName("featherLabel")
  self.needGoodsCountLabel = self:seekNodeByName("amountLabel")
  self.upgrageLvBtn = self:seekNodeByName("levelupBtn")
  self.levelUpLabel = self:seekNodeByName("levelUpLabel")
 
  self.choose = self:seekNodeByName("choose")
  self.choose:onButtonStateChanged(handler(self, self.saveAlertSetting))
  self.choosetxt = self:seekNodeByName("choosetxt")
  --右边
  self.nextWingNameLabel = self:seekNodeByName("rightName")
  self.rightBgImg = self:seekNodeByName("rightImg")
  self.goBtn = self:seekNodeByName("goBtn")
  
  --中间
  --self.powerLabel = self:seekNodeByName("powerLabel")
  self.powerValue1 = self:seekNodeByName("powerValue1")
  self.powerValue2 = self:seekNodeByName("powerValue2")
  self.attackLabel = self:seekNodeByName("attackLabel")
  self.attackValue1 = self:seekNodeByName("attackValue1")
  self.attackValue2 = self:seekNodeByName("attackValue2")
  --self.defenceLabel = self:seekNodeByName("defenceLabel")
  self.defenceValue1 = self:seekNodeByName("defenceValue1")
  self.defenceValue2 = self:seekNodeByName("defenceValue2")
  --self.magicDefenceLabel = self:seekNodeByName("magicDefenceLabel")
  self.magicDefenceValue1 = self:seekNodeByName("magicDefenceValue1")
  self.magicDefenceValue2 = self:seekNodeByName("magicDefenceValue2")
  --self.hpLabel = self:seekNodeByName("hpLabel")
  self.hpValue1 = self:seekNodeByName("hpValue1")
  self.hpValue2 = self:seekNodeByName("hpValue2")

  self.desLayer = self:seekNodeByName("desLayer")
  self.desLayer2 = self:seekNodeByName("desLayer2")
  self.desLayer:setVisible(false)
  self.desLayer2:setVisible(false)


  self.upgrageLvBtn:setTouchEnabled(true)
  self.upgrageLvBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      self.upgrageLvBtn:setScale(1.1)
      SoundManager:playClickSound()
    elseif event.name == "ended" then
      self.upgrageLvBtn:setScale(1.0)
      self.controller:updateWing(self.wing, self.choose:isButtonSelected())
      -- GUIDE CONFIRM
      GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_WING_OP_UPGRADE)
    end     
      return true
  end)

  self.hiddenBtn:setTouchEnabled(true)
  self.hiddenBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      SoundManager:playClickSound()
    elseif event.name == "ended" then
      local v = self.checkFlag:isVisible() == false
      self.checkFlag:setVisible(v)
      if v then
        self.controller:setWingVisible(1)
      else
        self.controller:setWingVisible(0)
      end
    end     
      return true
  end)

  self.goldBuyBtn:setTouchEnabled(true)
  self.goldBuyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      self.goldBuyBtn:setScale(1.1)
      SoundManager:playClickSound()
    elseif event.name == "ended" then
      self.goldBuyBtn:setScale(1.0)
      GlobalWinManger:openWin(WinName.STOREWIN) --打开商城
    end     
      return true
  end)

  self.jadeBuyBtn:setTouchEnabled(true)
  self.jadeBuyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      self.jadeBuyBtn:setScale(1.1)
      SoundManager:playClickSound()
    elseif event.name == "ended" then
      self.jadeBuyBtn:setScale(1.0)
      GlobalWinManger:openWin(WinName.RECHARGEWIN) --打开充值界面
    end     
      return true
  end)

  self:init()
  self.controller:onUpdateWingCompleted(handler(self,self.update))

  self:initCheckButton()

end

function WingUpView:init()
  self:update({result = 0})
end

function WingUpView:setViewInfo(data)
  local goods_id = data.goods_id
	--左边
  local roleWealth = RoleManager:getInstance().wealth
  self.goldLabel:setString(tostring(roleWealth.coin))
  self.jadeLabel:setString(tostring(roleWealth.jade))
	self.wing = configHelper:getWing(goods_id)
  if 0 == self.wing then --错误
    return
  end
  local roleInfo = RoleManager:getInstance().roleInfo
  --需要的物品名称，如羽毛
  local needGoodsName =  configHelper:getGoodNameByGoodId(self.wing.need_goods)
  if nil == self.currentWing then
    self.currentWing = display.newSprite(ResUtil.getWingInnerModel(self.wing.goods_info.res))
    local p_size = self.leftBgImg:getContentSize()
    self.currentWing:setPosition(p_size.width / 2, 90)
    self.leftBgImg:addChild(self.currentWing)
  else
    self.currentWing:setTexture(ResUtil.getWingInnerModel(self.wing.goods_info.res))
  end
  self.curWingNameLabel:setString(self.wing.goods_info.name)
  self.checkFlag:setVisible(roleInfo.wing_state == 1)
  self:setLevel(self.wing)
  self.needsGoodsLabel:setString(""..needGoodsName.."：")
  --self.choosetxt:setString("材料不足不提示")
  local has_count = BagManager:getInstance():findItemCountByItemId(self.wing.need_goods)--当前拥有数量
  self.needGoodsCountLabel:setString(has_count.."/"..self.wing.need_num)
  dump(self.wing.lv)
  if self.wing.lv[2] == 10 then
      self.levelUpLabel:setString("进阶")
  else
      self.levelUpLabel:setString("升级")
  end


  --中间
  --战斗力
  self.powerValue1:setString(tostring(data.fighting))
  
  local currWingAttr = configHelper:getEquipValidAttrByEquipId(goods_id)
  --生命
  self.hpValue1:setString(tostring(currWingAttr[1][2]))
  --攻击
  local currentAkmin
  local currentAkmax
  if roleInfo.career == 1000 then
    self.attackLabel:setString("物理攻击：")
    currentAkmin, currentAkmax = configHelper:getAtkByEquipId(goods_id,1)
  elseif roleInfo.career == 2000 then
    self.attackLabel:setString("魔法攻击：")
    currentAkmin, currentAkmax = configHelper:getAtkByEquipId(goods_id,2)
  elseif roleInfo.career == 3000 then
    self.attackLabel:setString("道术攻击：")
    currentAkmin, currentAkmax = configHelper:getAtkByEquipId(goods_id,3)
  end
  self.attackValue1:setString(currentAkmin.."-"..currentAkmax)
  --物防
  self.defenceValue1:setString(currWingAttr[4][2].."-"..currWingAttr[5][2])
  --法防
  self.magicDefenceValue1:setString(currWingAttr[6][2].."-"..currWingAttr[7][2])

  if self.wing.next_id == 0 then --已经是最高级
    self.rightBgImg:setVisible(false)
    self.needGoodsCountLabel:setVisible(false)
    self.upgrageLvBtn:setVisible(false)
    self.needsGoodsLabel:setVisible(false)
    self.powerValue2:setVisible(false)
    self.hpValue2:setVisible(false)
    self.attackValue2:setVisible(false)
    self.defenceValue2:setVisible(false)
    self.magicDefenceValue2:setVisible(false)
    self.goBtn:setVisible(false)
    self.nextWingNameLabel:setVisible(false)
    self:seekNodeByName("maxTipsLabel"):setVisible(true)
  else
    local nextWingAttr = configHelper:getEquipValidAttrByEquipId(self.wing.next_id)
     -- 战斗力增加
    local nextPowerData = EquipUtil.formatEquipItem({goods_id = self.wing.next_id})
    local addPower = nextPowerData.fighting - data.fighting
    if addPower ~= 0 then
      self.powerValue2:setString("(+"..addPower..")")
      self.powerValue2:setVisible(true)
    else
      self.powerValue2:setVisible(false)
    end
  

    --生命增加
    local addHp = nextWingAttr[1][2] - currWingAttr[1][2]
    if addHp ~= 0 then
      self.hpValue2:setString("+" .. addHp)
      self.hpValue2:setVisible(true)
    else
      self.hpValue2:setVisible(false)
    end
    --攻击增加
    local nextAkmin
    local nextAkmax
    if roleInfo.career == 1000 then
      nextAkmin, nextAkmax = configHelper:getAtkByEquipId(self.wing.next_id,1)
    elseif roleInfo.career == 2000 then
      nextAkmin, nextAkmax = configHelper:getAtkByEquipId(self.wing.next_id,2)
    elseif roleInfo.career == 3000 then
      nextAkmin, nextAkmax = configHelper:getAtkByEquipId(self.wing.next_id,3)
    end
    local addAkmin = nextAkmin - currentAkmin
    local addAkmax =  nextAkmax - currentAkmax
    if addAkmin ~= 0 or addAkmax ~= 0 then
      self.attackValue2:setString("(+"..addAkmin.."-"..addAkmax..")")
      self.attackValue2:setVisible(true)
    else
      self.attackValue2:setVisible(false)
    end
  --物防增加
    local addDefMin = nextWingAttr[4][2] - currWingAttr[4][2]
    local addDefMax = nextWingAttr[5][2] - currWingAttr[5][2]
    if addDefMin ~= 0 or addDefMax ~= 0 then
      self.defenceValue2:setString("(+"..addDefMin.."-"..addDefMax..")")
      self.defenceValue2:setVisible(true)
    else
      self.defenceValue2:setVisible(false)
    end
  
    --法防增加
    local addDefMagicMin = nextWingAttr[6][2] - currWingAttr[6][2]
    local addDefMagicMax = nextWingAttr[7][2] - currWingAttr[7][2]
    if addDefMagicMin ~= 0 or addDefMagicMax ~= 0 then
      self.magicDefenceValue2:setString("(+"..addDefMagicMin.."-"..addDefMagicMax..")")
      self.magicDefenceValue2:setVisible(true)
    else
      self.magicDefenceValue2:setVisible(false)
    end

    --右边
    local next_wing = configHelper:getGoodsByGoodId(self.wing.next_id)
    self.nextWingNameLabel:setString(next_wing.name)
    if nil == self.nextWing then
      self.nextWing = display.newSprite(ResUtil.getWingInnerModel(next_wing.res))
      p_size = self.rightBgImg:getContentSize()
      self.nextWing:setPosition(p_size.width / 2, 90)
      self.rightBgImg:addChild(self.nextWing)
    else
      self.nextWing:setTexture(ResUtil.getWingInnerModel(next_wing.res))
    end
  end

  if self.wing.lv[1] < 10 then
      self.desLayer:setVisible(true)
      self.desLayer2:setVisible(false)
  elseif (self.wing.lv[1] == 10 and self.wing.lv[2] == 10) or  self.wing.lv[1] >10 then
      self.desLayer:setVisible(false)
      self.desLayer2:setVisible(true)
  end

end

--UI进度条
function WingUpView:setLevel(wing)
  local i = 1
  while i<= wing.lv[2] do
    local star = self:seekNodeByName("star"..i)
    star:setSpriteFrame("wing_star2.png")
    i = i + 1
  end
  while i<= 10 do
    local star = self:seekNodeByName("star"..i)
    star:setSpriteFrame("wing_star1.png")
    i = i + 1
  end
  self.redBar:setPercent(wing.lv[2] / 10 * 100)
end

function WingUpView:update(data)
  if data.result ~= 0 then
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
    return
  end
	local equipList = RoleManager:getInstance().roleInfo.equip
  for i=1,#equipList do
    local subTypeName,subType = configHelper:getEquipTypeByEquipId(equipList[i].goods_id)
    if subType == 13 then -- 翅膀
      self:setViewInfo(equipList[i])--装备的信息
      break
    end
  end
end

function WingUpView:initCheckButton()
    local setting = cc.UserDefault:getInstance():getStringForKey("WingAlert"..self.wing.money_type)
    if setting == os.date("%x") then
        self.choose:setButtonSelected(true)
    else
        self.choose:setButtonSelected(false)
    end
end

function WingUpView:saveAlertSetting(isChecked)
    local setting = ""
    if self.choose:isButtonSelected() then
       setting = os.date("%x")
    end
    cc.UserDefault:getInstance():setStringForKey("WingAlert"..self.wing.money_type, setting)
    cc.UserDefault:getInstance():flush()
end


function WingUpView:close()
  	 self.controller:clean()
end

function WingUpView:destory()
  self:close()
  self.super.destory(self)
end

--点击关闭按钮
function WingUpView:onClickCloseBtn()
    GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_WIN_CLOSE_BUTTON)--在关闭之前
    self.super.onClickCloseBtn(self)
end

return WingUpView