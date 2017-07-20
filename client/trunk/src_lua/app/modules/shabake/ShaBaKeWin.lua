--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-15 17:02:17
-- 沙巴克
local ShaBaKeWin = class("ShaBaKeWin", BaseView)

function ShaBaKeWin:ctor(winTag,data,winconfig)
	  ShaBaKeWin.super.ctor(self,winTag,data,winconfig)
  	self.data = data
 
    self.occupyGuildName = self:seekNodeByName("Label_guild") --占领工会名
    self.occupyDays = self:seekNodeByName("Label_days") --占领时间天
    self.nextDate = self:seekNodeByName("Label_date") --下次开启日期
    self.nextTime = self:seekNodeByName("Label_time") --开启时间

    self.appointmentBtn = self:seekNodeByName("Btn_appointment") --官员任命按钮
    self.appointmentBtn:setTouchEnabled(true)
      self.appointmentBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          if event.name == "began" then
              self.appointmentBtn:setScale(1.1)
          elseif event.name == "ended" then
              self.appointmentBtn:setScale(1)
              if ShaBaKeModel.officer_id ~= 0 then
                --GlobalWinManger:openWin(WinName.SHABAKE_APPOINT_WIN)
                local DTRewardView = require("app.modules.shabake.ShaBaKeAppointWin").new()
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,DTRewardView) 
              else
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您没有权限!")
              end
              
          end
          return true
      end)
    self.ruleBtn = self:seekNodeByName("Btn_rule") --沙巴克规则按钮
    self.ruleBtn:setTouchEnabled(true)
      self.ruleBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          if event.name == "began" then
              self.ruleBtn:setScale(1.1)
          elseif event.name == "ended" then
              self.ruleBtn:setScale(1)
              --GlobalWinManger:openWin(WinName.SHABAKE_RULE_WIN)
              local DTRewardView = require("app.modules.shabake.ShaBaKeRuleWin").new()
          GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,DTRewardView)  
          end
          return true
      end)
    self.shadow01Pic = self:seekNodeByName("shadow01Pic")
    self.shadow02Pic = self:seekNodeByName("shadow02Pic")
    self.shadow03Pic = self:seekNodeByName("shadow03Pic")
    self.shadow04Pic = self:seekNodeByName("shadow04Pic")
    self.shadow05Pic = self:seekNodeByName("shadow05Pic")

    self.nameLab1 = self:seekNodeByName("nameLab1")
    self.nameLab2 = self:seekNodeByName("nameLab2")
    self.nameLab3 = self:seekNodeByName("nameLab3")
    self.nameLab4 = self:seekNodeByName("nameLab4")
    self.nameLab5 = self:seekNodeByName("nameLab5")

    self.ItemBg = self:seekNodeByName("ItemBg")
    self.enterBtn = self:seekNodeByName("Btn_entersbk")
    self.enterBtn:setTouchEnabled(true)
      self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          if event.name == "began" then
              self.enterBtn:setScale(1.1)
          elseif event.name == "ended" then
              self.enterBtn:setScale(1)
              GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = 20015})
              GlobalWinManger:closeWin(self.winName)
          end
          return true
      end)

    self.roleLay = self:seekNodeByName("roleLay")
    self.roleLay:setScale(1)

    self.prizeBtn = self:seekNodeByName("prizeBtn")
     self.prizeBtn:setTouchEnabled(true)
      self.prizeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          if event.name == "began" then
              self.prizeBtn:setScale(1.1)
          elseif event.name == "ended" then
              self.prizeBtn:setScale(1)
              self:showPrizeView()
          end
          return true
      end)
end	

function ShaBaKeWin:showPrizeView(data)
    if self.sbkPrizeView == nil then
        self.sbkPrizeView = require("app.modules.shabake.SbkPrizeView").new("resui/shabakeawardWin.ExportJson",self.winTag)
        self:addChild(self.sbkPrizeView)
        self.sbkPrizeView:setPosition((display.width-960)/2,(display.height-640)/2)
    end
    self.sbkPrizeView:open()
end
    
function ShaBaKeWin:open()
	  if self.updateHonorListEventId == nil then
        self.updateHonorListEventId = GlobalEventSystem:addEventListener(ShaBaKeEvent.UPDATE_HONOR_LIST,handler(self,self.updateHonorList))
    end
    if self.roleList then
        for i=1,#self.roleList do
          self.roleLay:removeChild(self.roleList[i])
          self.roleList[i] = nil
        end
    end
    self.roleList = {}
    --ShaBaKeController:onHandle25006(data)
    GameNet:sendMsgToSocket(25006, {})
    
end

-- --角色职业ID
-- ShabakeOfficeType = {
--  CASTELLAN = 1, --城主
--  VICECASTELLAN = 2, --副城主
--  PRESBYTER = 3, --长老
--  MEMBER = 4,--会员
-- }
function ShaBaKeWin:updateHonorList()
  self.occupyGuildName:setString(ShaBaKeModel.occupyGuildName)
  self.occupyDays:setString(ShaBaKeModel.occupyDays)
  self.nextDate:setString(os.date("%m月%d日",ShaBaKeModel.nextTimeNum))--%Y年
  self.nextTime:setString(os.date("%H:%M",ShaBaKeModel.nextTimeNum))--\n %H:%M
  for k,v in pairs(self.roleList) do
    self.roleLay:removeChild(v)
    self.roleList[k] = nil
  end
  for k,v in pairs(ShaBaKeModel.honorRoleList) do
    v.init = false
  end
  local oid = 1
  local isfind = nil
  for i=1,5 do
    isfind = nil
    if i <=2 then
      oid = i
    else
      oid = 3
    end

    for k,v in pairs(ShaBaKeModel.honorRoleList) do
      if v.init == false and v.officeId == oid then
        v.init = true
        isfind = v
        break
      end
    end

    local px,py = self["shadow0"..i.."Pic"]:getPosition()
    local role = InnerModelView.new()

    if isfind then
      role:setSex(isfind.sex)
        role:setBodyId(isfind.clothes)
        role:setWeaponId(isfind.weapon)
        role:setWingId(isfind.wing)
        self["nameLab"..i]:setString(isfind.name)
    else
      role:setSex(1)
        role:setBodyId(10)
        role:setWeaponId(0)
        role:setWingId(0)
        self["nameLab"..i]:setString("")
    end

    role:setPosition(px,py+50)
    self.roleLay:addChild(role)
    table.insert(self.roleList,role)
-- {sex = vo.sex,
-- career = vo.career,
-- clothes = vo.guise.clothes,
-- wing = vo.guise.wing,
-- weapon = vo.guise.weapon,
-- id= vo.tplayer_id,
-- name = vo.tname,
-- officeId = vo.officer_id})
  end
  local infos = configHelper.getInstance():GetShabakeRewardsInfo()
 
  if self.firstPrizeItem == nil then
    self.firstPrizeItem = CommonItemCell.new()
    self.firstPrizeItem:setBgVisible(true)
    self.root:addChild(self.firstPrizeItem,200)
    self.firstPrizeItem:setData(infos.master.frist_reward_goods[1])
    self.firstPrizeItem:setCount(infos.master.frist_reward_goods[1].num)
    local px,py = self.ItemBg:getPosition()
    self.firstPrizeItem:setPosition(px,py)
  end
end

	
function ShaBaKeWin:close()
    if self.updateHonorListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateHonorListEventId)
        self.updateHonorListEventId = nil
    end
    if self.sbkPrizeView then
        self.sbkPrizeView:close()
    end
end

function ShaBaKeWin:destory()
    self:close()
    if self.firstPrizeItem then
    self.firstPrizeItem:clear()
    self.firstPrizeItem = nil
  end
  for i=1,#self.roleList do
      self.roleLay:removeChild(self.roleList[i])
      self.roleList[i] = nil
    end
    self.roleList = {}
    if self.sbkPrizeView and self.sbkPrizeView:getParent() then
    	self.sbkPrizeView:destory()
    	--self.sbkPrizeView = nil
    end
    self.sbkPrizeView = nil
    self.super.destory(self)
end


return ShaBaKeWin