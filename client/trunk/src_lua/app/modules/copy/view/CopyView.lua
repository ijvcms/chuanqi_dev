--
-- Author: Your Name
-- Date: 2015-12-08 19:32:18
--

require("app.modules.copy.model.CopyManager")
require("app.modules.role.RoleManager")

local  CopyView = class("CopyView", BaseView)

function CopyView:ctor(winTag,data,winconfig)

  display.addSpriteFrames("resui/monster.plist", "resui/monster.png")
  display.addSpriteFrames("resui/boss.plist", "resui/boss.png")
	CopyView.super.ctor(self, winTag,data,winconfig)
 
  self.currentRewardList = {}
  self.nextRewardList = {}

  self.currentCopyId = 0
  self.currentCopyTime = 0
  self.currentJZNum = 0
  self.useJZnum = 0
  self.needLv = 0
  
 	local root = self:getRoot()
  root:setTouchEnabled(true)
  root:setTouchSwallowEnabled(true)
 
	self.lblNum = cc.uiloader:seekNodeByName(root,"number1")
	self.number2 = cc.uiloader:seekNodeByName(root,"number2")
	self.number3 = cc.uiloader:seekNodeByName(root,"number3")
  
  local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0,0,295, 480)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,320, 496))
    self.listView:onTouch(handler(self, self.touchListener))
    self.listView:setPosition(18, 10)

    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/fubenWin_2.ExportJson", "app.modules.copy.view.CopyItem", 6)
    self.listView:setAdapter(self.rankListAdapter)
    root:addChild(self.listView)


  self.buytBtn = cc.uiloader:seekNodeByName(root,"Image_20")
	self.enterBtn = cc.uiloader:seekNodeByName(root,"Image_15")
	self.bossName = cc.uiloader:seekNodeByName(root,"bossName")

	self.enterBtn:setTouchEnabled(true)
	self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.enterBtn:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.enterBtn:setScale(1)
        --CopyManager:getInstance():getReward(20012)
        if self.needLv > RoleManager:getInstance().roleInfo.lv then
          GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"等级不够!")
        elseif self.now_times <= 0 and self.limit_buy_times > self.buy_times then
           local function enterFun()
                GameNet:sendMsgToSocket(11035, {scene_id = self.currentCopyId})
            end
     
            local tipTxt = "是否花"..self.need_jade.."元宝，购买当前副本次数？"
        
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = tipTxt,
                  enterFun = enterFun,
                  tipShowMid = true
            })
        elseif self.now_times <= 0 then
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"副本次数已用完!")
        else
          GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(self.currentCopyId)})
          GlobalWinManger:closeWin(self.winTag)
        end
       
    end
      return true
  end)

  self.buytBtn:setTouchEnabled(true)
  self.buytBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.buytBtn:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.buytBtn:setScale(1)

        if self.limit_buy_times <= self.buy_times then
          GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"购买次数已用完!")
          return
        end

        local function enterFun()
          GameNet:sendMsgToSocket(11035, {scene_id = self.currentCopyId})
        end
 
        local tipTxt = "是否花"..self.need_jade.."元宝，购买当前副本次数？"
    
        GlobalMessage:alert({
              enterTxt = "确定",
              backTxt= "取消",
              tipTxt = tipTxt,
              enterFun = enterFun,
              tipShowMid = true
        })
    end

      return true
  end)
 
  --self:open()

end

function CopyView:open()
  
  GlobalEventSystem:addEventListener(CopyEvent.COPY_ALLINFO, handler(self, self.setViewInfo))
  GlobalEventSystem:addEventListener(CopyEvent.COPY_UPDATECOPYTIME, handler(self, self.updateCopyItem))
  GameNet:sendMsgToSocket(11034)
end

function CopyView:setViewInfo(data)
      
      if data.data == nil then
        return
      end
      self.lastItem = nil
      self.data = data.data.list

      self.rankListAdapter:setData(self.data)

      local firstItem = self.listView:getFirstItem()
  
    if firstItem then

      local item = firstItem:getChildByTag(11)
        if item ~= self.lastItem then
          if  self.lastItem then
            self.lastItem:setSelect(false)
          end
   
          self.lastItem = item
          item:setSelect(true)

          local data  = item:getData()
          self:clickBack(data)
        end
    end
 
end
 
function CopyView:updateCopyItem(data)

  if data.data == nil then
    return
  end

  local info =  self.lastItem:getData()

  info.now_times = data.data.now_times
  info.buy_times = data.data.buy_times
  info.limit_buy_times = data.data.limit_buy_times
  info.next_scene_id = data.data.next_scene_id
  info.need_jade = data.data.need_jade

  self.lastItem:setData(info)

  if data.data.scene_id == self.currentCopyId then
    self.lblNum:setString(data.data.now_times.."次")
    self.currentCopyId = data.data.scene_id
    self.need_jade = data.data.need_jade
    self.limit_buy_times = data.data.limit_buy_times
    self.buy_times = data.data.buy_times
    self.now_times = data.data.now_times
  end

 end
--设置副本boss
function CopyView:setBoss(bossId)

  local bossName = configHelper:getMonsterNameById(bossId)
  local bossLv = configHelper:getMonsterLvById(bossId)
  local bossRes = configHelper:getMonsterResById(bossId)
 
   if self.bossImg ~= nil then
      self.bossImg:setSpriteFrame("m_"..bossRes..".png")
  else
      self.bossImg = display.newSprite("#m_"..bossRes..".png")
      self:getRoot():addChild(self.bossImg)
      self.bossImg:setPosition(600, 300)
  end
  self.bossName:setString(bossName)
  -- if self.bossNameImg ~= nil  then
  --     self.bossNameImg:setSpriteFrame("copy_"..bossName..".png")
  -- else
  --     self.bossNameImg = display.newSprite("#copy_"..bossName..".png")
  --     self:getRoot():addChild(self.bossNameImg)
  --     self.bossNameImg:setAnchorPoint(0,0.5)
  --     self.bossNameImg:setPosition(390, 520)
  -- end
 
end
 
function CopyView:touchListener(event)
    local listView = event.listView

    if "clicked" == event.name then
 
        local item = event.item:getChildByTag(11)
      
      if item ~= self.lastItem then
        if  self.lastItem then
            self.lastItem:setSelect(false)
        end
 
        self.lastItem = item
        item:setSelect(true)

        local data  = item:getData()
        self:clickBack(data)
      end

    elseif "moved" == event.name then
         
    elseif "ended" == event.name then
        
    end
end

function CopyView:clickBack(data)
 
  if self.currentCopyId == data.copyId then
    return
  end
 
  self.currentCopyId = data.copyId
  self.needLv = data.copyInfo.lv
  self.need_jade = data.need_jade
  self.limit_buy_times = data.limit_buy_times
  self.buy_times = data.buy_times
  self.now_times = data.now_times

  self.lblNum:setString(data.now_times.."次")
 
--副本boss信息
  if data.bossId then
    self:setBoss(data.bossId)
  end

--当前副本等级信息
  if self.currentRewardList then
    for i = #self.currentRewardList,#data.copyRewardInfo.goodsList + 1,-1 do
      self.currentRewardList[i]:setVisible(false)
    end
  end

  self.number2:setString(data.lv)
  if data.copyRewardInfo then
     for i=1,#data.copyRewardInfo.goodsList do
      if self.currentRewardList[i] == nil then
          self.currentRewardList[i] = require("app.modules.copy.view.CopyRewardItem").new()
          self:getRoot():addChild(self.currentRewardList[i])
          self.currentRewardList[i]:setPosition(430-4, 276 - (i-1)*70 - 70)
      end

      self.currentRewardList[i]:setVisible(true)
      self.currentRewardList[i]:setData(data.copyRewardInfo.goodsList[i])
 
     end
  end

--下一阶副本信息
 
  local nextData = configHelper:getCopyInfo(data.next_scene_id)
  if nextData then
      self.number3:setString(nextData.lv)
      local copyRewardInfo = require("app.modules.copy.model.CopyRewardInfo").new()
      copyRewardInfo:setData(nextData.prize)
     
      if copyRewardInfo then

        if self.nextRewardList then
          for i = #self.nextRewardList,#copyRewardInfo.goodsList + 1,-1 do
            self.nextRewardList[i]:setVisible(false)
          end
        end

        for i=1,#copyRewardInfo.goodsList do

          if self.nextRewardList[i] == nil then
            self.nextRewardList[i] = require("app.modules.copy.view.CopyRewardItem").new()
            self:getRoot():addChild(self.nextRewardList[i])
            self.nextRewardList[i]:setPosition(760-4, 276 - (i-1)*70- 70)
          end

          self.nextRewardList[i]:setVisible(true)
          self.nextRewardList[i]:setData(copyRewardInfo.goodsList[i])
 
         end
     end
  end

end

function CopyView:close()
  self:destory()
end

function CopyView:destory()
      GlobalEventSystem:removeEventListener(CopyEvent.COPY_ALLINFO)
      GlobalEventSystem:removeEventListener(CopyEvent.COPY_UPDATECOPYTIME)
      display.removeSpriteFramesWithFile("resui/monster.plist","resui/monster.png")
      display.removeSpriteFramesWithFile("resui/boss.plist","resui/boss.png")
end

return CopyView