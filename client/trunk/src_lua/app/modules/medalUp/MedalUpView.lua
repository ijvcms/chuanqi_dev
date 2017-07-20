--
-- Author: Yi hanneng
-- Date: 2016-01-18 18:04:34
--

--[[

生命：hp hpnumber hpadd
物防：def defnumber defadd
法防：res resnumber resadd
攻击：attack attacknumber attackadd
需要功勋值：medalnumber
需要等级：lv

当前勋章：medalnow medalnowname
升级勋章：medalup medalupname

升级：lvup
左滑动：btnleft
右滑动：btnright

--]]

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local itemTipsWin = require("app.modules.tips.view.itemTipsWin")
local equipTipsWin = require("app.modules.tips.view.equipTipsWin")

require("app.modules.medalUp.MedalUpManager")
local MedalUpView = MedalUpView or class("MedalUpView", BaseView)


function MedalUpView:ctor(winTag,data,winconfig)
	  MedalUpView.super.ctor(self,winTag,data,winconfig)
  	--self:getRoot():setPosition((display.width-620)/2,(display.height-430)/2)
    local root = self:getRoot()

  	self.itemList = {}
  	self.medalList = {}
  	self.currentKey = -1

    self.lvenable = false
    self.featenable = false

	self.hp = self:seekNodeByName("hp")
  	self.hpnumber = self:seekNodeByName("hpnumber")
  	self.hpadd = self:seekNodeByName("hpadd")

  	self.def = self:seekNodeByName("def")
  	self.defnumber = self:seekNodeByName("defnumber")
  	self.defadd = self:seekNodeByName("defadd")

  	self.res = self:seekNodeByName("res")
  	self.resnumber = self:seekNodeByName("resnumber")
  	self.resadd = self:seekNodeByName("resadd")

  	self.attack = self:seekNodeByName("attack")
  	self.attacknumber = self:seekNodeByName("attacknumber")
  	self.attackadd = self:seekNodeByName("attackadd")

  	self.medalnow = self:seekNodeByName("medalnow")
  	self.medalup = self:seekNodeByName("medalup")
  	self.medalnowname = self:seekNodeByName("medalnowname")
  	self.medalupname = self:seekNodeByName("medalupname")

  	self.medalnumber = self:seekNodeByName("medalnumber")
  	self.lv = self:seekNodeByName("lv")
 
  	self.lvup = self:seekNodeByName("lvup")
  	self.btnleft = self:seekNodeByName("btnleft")
  	self.btnright = self:seekNodeByName("btnright")
  	self.rule = self:seekNodeByName("rule")
  	self.Image_7 = self:seekNodeByName("Image_7")

    self.lvup:setTouchEnabled(true)
    local lvUptip = BaseTipsBtn.new(BtnTipsType.BTN_MEDAL_UPGRADE,self.lvup,50,12)
    self.lvup:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.lvup:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.lvup:setScale(1.0)
            
            if not self.lvenable then
              GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"等级不够！")
            end

            if not self.featenable then
              GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"功勋不足！")
            end

            if self.isTop then
              GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"已升到最高级！")
            end

            if self.lvenable and self.featenable and not self.isTop then
              GameNet:sendMsgToSocket(14034, {id = self.currentKey})
            end

        end     
        return true
    end)

    self.rule:setTouchEnabled(true)
    self.rule:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.rule:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.rule:setScale(1.0)
 
            	local tipTxt  = "1.使用功勋值升级勋章等级,勋章等级提升,属性加成也越高.".."\n"..
								"2.功勋值可以通过日常功勋任务获得.".."\n"..
								"3.勋章永久绑定玩家身上,不会被爆出。" 
          
            	GlobalMessage:alert({
	                enterTxt = "确定",
	                backTxt= "取消",
	                tipTxt = tipTxt,
	               hideBackBtn = true,
	                tipShowMid = true,
            	})
        end     
        return true
    end)

	self.ListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0,0,self.Image_7:getContentSize().width - 100, self.Image_7:getContentSize().height + 30),
        direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self:getRoot()):pos(self.Image_7:getPositionX() - self.Image_7:getContentSize().width/2 + 50, self.Image_7:getPositionY() - 30)
    self.isInit = false
    self:init()
    GlobalEventSystem:addEventListener(MedalUpEvent.MedalUp_UP,handler(self,self.update))

end

function MedalUpView:init()

  --读取配置
	self.medalList = MedalUpManager:getInstance():getMedalListInfo()
  --列表
  if self.ListView then
    self.ListView:removeAllItems()
  end

  local curGoodsId
  local equipList = RoleManager:getInstance().roleInfo.equip
      for i=1,#equipList do
      local subTypeName,subType = configHelper:getEquipTypeByEquipId(equipList[i].goods_id)
        if subType == 5 then
          self:setViewInfo(equipList[i].goods_id)
          curGoodsId = equipList[i].goods_id
          break
        end
      end

 
  local len = #self.medalList
  local loaded = 0
  --self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function()
  for i=1,#self.medalList do
    if self.medalList and  loaded < len then
      loaded = loaded + 1
      local info = self.medalList[loaded]
      if info then
        local item = self.ListView:newItem()
        local commonItem= display.newNode()
        commonItem:setContentSize(90,80)
 
        local commonItem2 = CommonItemCell.new()
        commonItem2:setData(info)
        commonItem2.itemSprite:setTouchEnabled(false)
        commonItem2:setPosition(40,0)
        commonItem:addChild(commonItem2)
        -- commonItem:setAnchorPoint(1,1)
        --commonItem:setPosition(100,0)
        item:addContent(commonItem)
        item:setItemSize(commonItem2:getContentSize().width + 10, 80)
        --item:setItemSize(80, 80)
        self.itemList[loaded] = commonItem2
        self.ListView:addItem(item)
        self.ListView:reload()
      end
    --end
    end
  end

    if loaded == len then
      self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
      self.ListView:reload()
      -- local equipList = RoleManager:getInstance().roleInfo.equip
      -- for i=1,#equipList do
      -- local subTypeName,subType = configHelper:getEquipTypeByEquipId(equipList[i].goods_id)
      --   if subType == 5 then
      --     print("GGGGGGGGGGG")
      --     self:setViewInfo(equipList[i].goods_id)
      --     break
      --   end
      -- end
    end
    self:scrollto(curGoodsId)
    self.isInit = true
  --end)

  --self:scheduleUpdate()


  --[[
	if self.ListView then
		self.ListView:removeAllItems()
	end
	for i=1,#self.medalList do
		local info = self.medalList[i]
	    local item = self.ListView:newItem()
		local commonItem = CommonItemCell.new()
	    commonItem:setData(info)
	    commonItem.itemSprite:setTouchEnabled(false)
		item:addContent(commonItem)
        item:setItemSize(commonItem:getContentSize().width + 10, self.Image_7:getContentSize().height)
		self.itemList[i] = commonItem
		self.ListView:addItem(item)
		self.ListView:reload()
	end
  
	--self:setViewInfo(306007)

	local equipList = RoleManager:getInstance().roleInfo.equip
	for i=1,#equipList do
		local subTypeName,subType = configHelper:getEquipTypeByEquipId(equipList[i].goods_id)
		if subType == 5 then
			self:setViewInfo(equipList[i].goods_id)
			break
		end
	end
  --]]
end

function MedalUpView:setViewInfo(data)
	--赋值
	local roleInfo = RoleManager:getInstance().roleInfo
	local wealthInfo = RoleManager:getInstance().wealth
	local goodsName = configHelper:getGoodNameByGoodId(data)

	local currentConfig
	for i=1,#self.medalList do
		if data == self.medalList[i].goods_id then
			currentConfig = self.medalList[i]
			break
		end
	end

	local currentEqui = configHelper:getEquipValidAttrByEquipId(data)
	local nextEquie = configHelper:getEquipValidAttrByEquipId(currentConfig.next_id)
	local nextName = configHelper:getGoodNameByGoodId(currentConfig.next_id)

  if currentConfig.next_id  == 0 then
    currentConfig.next_id = data
    nextEquie = currentEqui
    nextName = goodsName
    --self.lvup:setTouchEnabled(false)
    self.isTop = true
  end

	self.currentKey = currentConfig.key

	local currentAkmin
	local currentAkmac
	local nextAkmin
	local nextAkmac
 
  if self.item == nil then
    self.item = CommonItemCell.new()
    self.medalnow:addChild(self.item, 10, 10)
    self.item:setPosition(self.medalnow:getContentSize().width/2, self.medalnow:getContentSize().height/2)
  end
	
	self.item:setData(currentConfig)

  if self.item2 == nil then
    self.item2 = CommonItemCell.new()
    self.medalup:addChild(self.item2, 10, 10)
    self.item2:setPosition(self.medalup:getContentSize().width/2, self.medalup:getContentSize().height/2)
    self.item2:setScale(0.96)
  end
	
	self.item2:setData({goods_id = currentConfig.next_id})
 
  self.medalnowname:setString(goodsName)
  self.medalupname:setString(nextName)

	self.lv:setString(roleInfo.lv.."/"..currentConfig.limit_lv)
	self.medalnumber:setString(wealthInfo.feats.."/"..currentConfig.need_feats)

  if roleInfo.lv <  currentConfig.limit_lv then
    self.lv:setColor(cc.c3b(255, 0, 0))
    self.lvenable = false
  else
    self.lv:setColor(cc.c3b(0, 255, 0))
    self.lvenable = true
  end

  if wealthInfo.feats <  currentConfig.need_feats then
    self.medalnumber:setColor(cc.c3b(255, 0, 0))
    self.featenable = false
  else
    self.medalnumber:setColor(cc.c3b(0, 255, 0))
    self.featenable = true
  end

  	self.hpnumber:setString(currentEqui[1][2])
     if nextEquie[1][2] - currentEqui[1][2] > 0 then
      self.hpadd:setVisible(true)
      self.hpadd:setString("(+"..(nextEquie[1][2] - currentEqui[1][2])..")")
    else
      self.hpadd:setVisible(false)
    end
  	

  	self.defnumber:setString(currentEqui[4][2].."-"..currentEqui[5][2])

  	 if nextEquie[5][2] - currentEqui[5][2] > 0 then
      self.defadd:setVisible(true)
      self.defadd:setString("(+"..(nextEquie[4][2] - currentEqui[4][2]).."-"..(nextEquie[5][2] - currentEqui[5][2])..")")
    else
      self.defadd:setVisible(false)
    end

   	self.resnumber:setString(currentEqui[6][2].."-"..currentEqui[7][2])
    if nextEquie[7][2] - currentEqui[7][2] > 0 then
      self.resadd:setVisible(true)
      self.resadd:setString("(+"..(nextEquie[6][2] - currentEqui[6][2]).."-"..(nextEquie[7][2] - currentEqui[7][2])..")")
    else
      self.resadd:setVisible(false)
    end
  	

  	if roleInfo.career == 1000 then
  		self.attack:setString("物理攻击:")
  		currentAkmin, currentAkmac = configHelper:getAtkByEquipId(data,1)
  		nextAkmin, nextAkmac = configHelper:getAtkByEquipId(currentConfig.next_id,1)
  	elseif roleInfo.career == 2000 then
  		self.attack:setString("魔法攻击:")
  		currentAkmin, currentAkmac = configHelper:getAtkByEquipId(data,2)
  		nextAkmin, nextAkmac = configHelper:getAtkByEquipId(currentConfig.next_id,2)
  	elseif roleInfo.career == 3000 then
  		self.attack:setString("道术攻击:")
  		currentAkmin, currentAkmac = configHelper:getAtkByEquipId(data,3)
  		nextAkmin, nextAkmac = configHelper:getAtkByEquipId(currentConfig.next_id,3)
 	end

  	self.attacknumber:setString(currentAkmin.."-"..currentAkmac)
    if nextAkmac - currentAkmac > 0 then
      self.attackadd:setVisible(true)
      self.attackadd:setString("(+"..(nextAkmin - currentAkmin).."-"..(nextAkmac - currentAkmac)..")")
    else
      self.attackadd:setVisible(false)
    end
  	
    if self.isInit then
  	    self:scrollto(data)
  	end
end

function MedalUpView:update()
	local equipList = RoleManager:getInstance().roleInfo.equip
	for i=1,#equipList do
		local subTypeName,subType = configHelper:getEquipTypeByEquipId(equipList[i].goods_id)
		if subType == 5 then
			self:setViewInfo(equipList[i].goods_id)
			break
		end
	end
end

function MedalUpView:scrollto(id)
	local item
	for i=1,#self.itemList do
		if self.itemList[i]:getData().goods_id == id then
			item  = self.itemList[i]
			break			
		end
	end
	local pos = self.ListView:getItemPos(item:getParent())
 
	self.ListView:scrollTo(-item:getParent():getParent():getPositionX(), item:getParent():getParent():getPositionY())

end

function MedalUpView:touchListener(event)
local listView = event.listView

    if "clicked" == event.name then
    	local item = self.itemList[event.itemPos]
      if item == nil then return end
    	local data = item:getData()
    	local goodType = configHelper:getGoodTypeByGoodId(data.goods_id)
        if not goodType then return end
        if goodType == 2 then           --装备
           local eTWin = equipTipsWin.new()
           	eTWin:setData(EquipUtil.formatEquipItem(data))
           	eTWin.btnSell:setVisible(false)
           	eTWin.btnPutOn:setVisible(false)
           	eTWin.btnTakeOff:setVisible(false)
           	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,eTWin)
        else      --道具
           	local itWin = itemTipsWin.new()
            itWin:setData(data)
            itWin.btnUse:setVisible(false)
            itWin.btnSell:setVisible(false)
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,itWin)
        end
 
     elseif "moved" == event.name then
         
    elseif "ended" == event.name then
        
    end
end

function MedalUpView:close()
      self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
  	 GlobalEventSystem:removeEventListener(MedalUpEvent.MedalUp_UP)
     self.super.close(self)
end

function MedalUpView:destory()
  self:close()
    self.super.destory(self)
end

return MedalUpView