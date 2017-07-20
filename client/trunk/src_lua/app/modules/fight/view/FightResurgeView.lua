--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-10 17:51:20
-- 战斗复活页面
local FightResurgeView = class("FightResurgeView", BaseView)

function FightResurgeView:ctor(winTag,data,winconfig)
  FightResurgeView.super.ctor(self,winTag,data,winconfig)
  self.data = data
	self.width = 553
	self.height = 345

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,180))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    self.tipsBg = display.newScale9Sprite("#com_panelBg1.png", 0, 0, cc.size(self.width, self.height),cc.rect(86, 60,1, 1))
    self.tipsBg:setAnchorPoint(cc.p(0, 0))
    self.tipsBg:setPosition((display.width-self.width)/2,(display.height-self.height)/2+50)
    self:addChild(self.tipsBg)

    self.txtBg = display.newScale9Sprite("#com_viewBg1.png", 0, 0, cc.size(self.width-40, self.height-70-30))
    self.txtBg:setAnchorPoint(cc.p(0.5, 0))
    self.txtBg:setPosition(self.width/2,30)
    self.tipsBg:addChild(self.txtBg)

    self.titleLab = display.newTTFLabel({text = "复  活",
        size = 26,color = TextColor.TITLE})
            :align(display.CENTER,0,0)
            :addTo(self.tipsBg)
    self.titleLab:setPosition(self.width/2,self.height-24)
    display.setLabelFilter(self.titleLab)


    self.safeResurgeBtn = TextButton.create({text = "安全复活"})
    -- self.enterBtn:setColor(cc.c3b(217, 108, 87))     
    self.txtBg:addChild(self.safeResurgeBtn)
    self.safeResurgeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)         
            if event.name == "began" then               
                self.safeResurgeBtn:setScale(1.1)
            elseif event.name == "ended" then               
                self.safeResurgeBtn:setScale(1)
                self:onResurgeClick(1,true)
            end
            return true
        end)
    self.safeResurgeBtn:setPosition((self.width-40)/2-130,140)


    self.sceneResurgeBtn = TextButton.create({text = "原地复活"})
    -- self.enterBtn:setColor(cc.c3b(217, 108, 87))     
    self.txtBg:addChild(self.sceneResurgeBtn)
    self.sceneResurgeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)         
            if event.name == "began" then               
                self.sceneResurgeBtn:setScale(1.1)
            elseif event.name == "ended" then               
                self.sceneResurgeBtn:setScale(1)
                self:onResurgeClick(2,true)
            end
            return true
        end)
    self.sceneResurgeBtn:setPosition((self.width-40)/2+130,140)
 

   	self.tipLab3 = display.newTTFLabel({text = "在指定地点复活",size = 18,color = TextColor.TEXT_W})
        	:align(display.CENTER,0,0)
        	:addTo(self.txtBg)
   	self.tipLab3:setTouchEnabled(false)
   	self.tipLab3:setPosition((self.width-40)/2-130,90)

    self.syLbl = display.newTTFLabel({text = "使用",size = 18,color = TextColor.TEXT_W})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    self.syLbl:setTouchEnabled(false)
    self.syLbl:setPosition((self.width-40)/2+125-15 - 30,90)
    self.isRedName = (RoleManager:getInstance().roleInfo.pkValue >= 60)
    local fuhuodanTip = "复活丹"
    local yuanbaoTip = "50元宝"
    --[[
    if self.isRedName then
      fuhuodanTip = fuhuodanTip.."x3"
      yuanbaoTip = "150元宝"
    end
    --]]
   	self.goodsNameLab = display.newTTFLabel({text = fuhuodanTip,size = 18,color = TextColor.TEXT_G})
        	:align(display.CENTER,0,0)
        	:addTo(self.txtBg)
   	self.goodsNameLab:setTouchEnabled(false)
   	self.goodsNameLab:setPosition(self.syLbl:getPositionX() + self.syLbl:getContentSize().width/2 + self.goodsNameLab:getContentSize().width/2 + 2,self.syLbl:getPositionY())

  
    self.hzLbl = display.newTTFLabel({text = "或者",size = 18,color = TextColor.TEXT_W})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    self.hzLbl:setTouchEnabled(false)
    self.hzLbl:setPosition(self.goodsNameLab:getPositionX() + self.goodsNameLab:getContentSize().width/2 + self.hzLbl:getContentSize().width/2 + 2,self.syLbl:getPositionY())

   	
   	self.moneyLab = display.newTTFLabel({text = yuanbaoTip,size = 18,color = TextColor.TEXT_G})
        	:align(display.CENTER,0,0)
        	:addTo(self.txtBg)
   	self.moneyLab:setTouchEnabled(false)
   	self.moneyLab:setPosition(self.syLbl:getPositionX() + self.moneyLab:getContentSize().width/2 - self.syLbl:getContentSize().width/2,60)

    self.ybfh = display.newTTFLabel({text = "复活",size = 18,color = TextColor.TEXT_W})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    self.ybfh:setTouchEnabled(false)
    self.ybfh:setPosition(self.moneyLab:getPositionX() + self.moneyLab:getContentSize().width/2 + self.ybfh:getContentSize().width/2 + 2,self.moneyLab:getPositionY())
 
   	-- self.tipLab:enableShadow(cc.c4b(0 , 0, 0, 1 ), cc.size(2,-2))
   	-- self.tipLab:enableOutline(cc.c4b(1,1,0,1),3)
    -- self.tipLab:enableGlow(cc.c4b(1,1,0,1))
    self.curtime = 10
    self.tips = "%d秒"
    self:init(self.data)
end

function FightResurgeView:init(data)

  local niLbl = display.newTTFLabel({text = "你被",size = 18,color = TextColor.TEXT_O})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    niLbl:setTouchEnabled(false)
    niLbl:setPosition((self.width-40)/2 - 72,220)
    if GameSceneModel.curSceneHideName == true then
        data.caster_name = "神秘人"
    end
    local nameLab = display.newTTFLabel({text = data.caster_name or "怪物or玩家",size = 18,color = TextColor.TEXT_R})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    nameLab:setTouchEnabled(false)
    nameLab:setPosition(niLbl:getPositionX() + niLbl:getContentSize().width/2 + nameLab:getContentSize().width/2 + 2,niLbl:getPositionY()) 

    local haiLbl = display.newTTFLabel({text = "杀害了",size = 18,color = TextColor.TEXT_O})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    haiLbl:setTouchEnabled(false)
    haiLbl:setPosition(nameLab:getPositionX() + nameLab:getContentSize().width/2 + haiLbl:getContentSize().width/2 + 2,niLbl:getPositionY())


    local vipLbl = display.newTTFLabel({text = "VIP剩余",size = 18,color = TextColor.TEXT_W})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    vipLbl:setTouchEnabled(false)
    vipLbl:setPosition(self.syLbl:getPositionX()+ vipLbl:getContentSize().width/2 - self.syLbl:getContentSize().width/2,30)

   local vipTimesLab = display.newTTFLabel({text = data.fh_vip_num or 0,size = 18,color = TextColor.TEXT_G})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    vipTimesLab:setTouchEnabled(false)
    vipTimesLab:setPosition(vipLbl:getPositionX() + vipLbl:getContentSize().width/2 + vipTimesLab:getContentSize().width/2 + 2,vipLbl:getPositionY())

    local mfLbl = display.newTTFLabel({text = "次免费",size = 18,color = TextColor.TEXT_W})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    mfLbl:setTouchEnabled(false)
    mfLbl:setPosition(vipTimesLab:getPositionX() + vipTimesLab:getContentSize().width/2 + mfLbl:getContentSize().width/2 + 2,vipLbl:getPositionY())
  	 
    if GameSceneModel.sceneConfig and GameSceneModel.sceneConfig.iRevive == 1 then
        self.sceneResurgeBtn:setBtnEnable(true)
    else
        self.sceneResurgeBtn:setBtnEnable(false)
    end
end

function FightResurgeView:open()

    self.curtime = 60

    local timeLbl = display.newTTFLabel({text = string.format(self.tips,self.curtime),size = 18,color = TextColor.TEXT_G})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    timeLbl:setTouchEnabled(false)
    timeLbl:setPosition((self.width-40)/2 - 72,195)

    local fhLbl = display.newTTFLabel({text = "后自动安全复活",size = 18,color = TextColor.TEXT_O})
          :align(display.CENTER,0,0)
          :addTo(self.txtBg)
    fhLbl:setTouchEnabled(false)
    fhLbl:setPosition(timeLbl:getPositionX() + timeLbl:getContentSize().width/2 + fhLbl:getContentSize().width/2 + 2,timeLbl:getPositionY())
 
  	local listenerFun =  function()
    		self.curtime = self.curtime -1
    		if self.curtime <= 0 then
    			  self:onResurgeClick(1,false)
    		else
    			  timeLbl:setString(string.format(self.tips,self.curtime))
            fhLbl:setPosition(timeLbl:getPositionX() + timeLbl:getContentSize().width/2 + fhLbl:getContentSize().width/2 + 2,timeLbl:getPositionY())
    		end
  	end
  	if self.scheduleTimeId == nil then
  		  self.scheduleTimeId =  GlobalTimer.scheduleGlobal(listenerFun,1)
  	end
end

--<Param name="type" type="int8" describe="复活类型: 1 复活点复活, 2 原地复活"/>
function FightResurgeView:onResurgeClick(ctype,isClick)
    local function enterFun()
        FightModel.isRelive = true
        GameNet:sendMsgToSocket(10005, {type = ctype})
        GlobalWinManger:closeWin(self.winTag)
    end

    if ctype == 2 then
        local bagManager = BagManager:getInstance()
        local goodsNum = bagManager:findItemCountByItemId(110054)
        local numScale = 1
        if self.isRedName then
          numScale = 3
        end
        if self.data.fh_vip_num > 0 then
            enterFun()
            return
        elseif goodsNum > 1*numScale or RoleManager:getInstance().wealth.jade > 50*numScale then
            enterFun()
            return
        else
            GlobalMessage:show("你不能原地复活，缺少复活丹或元宝不够")
            return
        end
    elseif ctype == 1 then
        -- if GameSceneModel.isInterService and isClick == true then
        --     GlobalMessage:alert({
        --       enterTxt = "确定",
        --       backTxt= "取消",
        --       tipTxt = "选择安全区复活会回到本服土城，需要重新消耗门票才能进入2，3层地图，是否如此？",
        --       enterFun = enterFun,
        --       tipShowMid = true
        --     })
        -- else
        --   enterFun()
        -- end
        enterFun()
    else
        enterFun()
    end
  	-- FightModel.isRelive = true
  	-- GameNet:sendMsgToSocket(10005, {type = ctype})
  	-- --<Param name="type" type="int8" describe="复活类型: 1 复活点复活, 2 原地复活"/>
    --  GlobalWinManger:closeWin(self.winTag)
end

function FightResurgeView:close()
  self.super.close(self)
	if self.scheduleTimeId then
		GlobalTimer.unscheduleGlobal(self.scheduleTimeId)
		self.scheduleTimeId = nil
	end
end


function FightResurgeView:destory()
  self:close()
	--self:close()
	--self:setVisible(false) 
  self.super.destory(self)
	-- if self:getParent() then
	-- 	self:getParent():removeChild(self)
	-- end
end

return FightResurgeView


