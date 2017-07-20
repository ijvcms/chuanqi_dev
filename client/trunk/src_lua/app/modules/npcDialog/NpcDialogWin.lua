--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-01-06 10:55:06
-- NPC对话框
require("app.modules.dailyTask.model.TaskManager")
local NpcDialogWin = class("NpcDialogWin", BaseView)


function NpcDialogWin:ctor(winTag,data,winconfig)

  	NpcDialogWin.super.ctor(self,winTag,data,winconfig)
  	self.npcVO = data
  	--self.root:setPosition((display.width-620)/2,(display.height-430)/2)
  	self.titile = self:seekNodeByName("name")
  	self.contentLab = self:seekNodeByName("speak")
  	self.closeBtn = self:seekNodeByName("close")
  	self.closeBtn:setTouchEnabled(true)
  	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
  	end)

    -- 添加遮罩。点击遮罩关闭
    local maskBg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    maskBg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          if event.name == "ended" then
              GlobalWinManger:closeWin(self.winTag)
          end     
          return true
      end)
    self:addChild(maskBg,-1)

    --dump(self.npcVO)
    self:setData(data)
  	self.leaveBtn = self:seekNodeByName("closeBtn")
  	self.leaveBtn:setTouchEnabled(true)
  	self.leaveBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.leaveBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.leaveBtn:setScale(1)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
  	end)

    self.taskId = 0
    self.taskState = -1
    self.taskType = 0
    self.npcWinClick = false
 
    self.npcspeak1 = self:seekNodeByName("npcspeak1")
   
  	self.taskLay = self:seekNodeByName("task")
  	self.good1 = self:seekNodeByName("good1")
  	self.good2 = self:seekNodeByName("good2")
  	self.good3 = self:seekNodeByName("good3")
  	self.good4 = self:seekNodeByName("good4")
  	self.good5 = self:seekNodeByName("good5")
  	self.taskBtn = self:seekNodeByName("taskbutton")
 
    ---------------------
    self.npcspeak2 = self:seekNodeByName("npcspeak2")
    self.speak2 = self:seekNodeByName("speak2")
    self.normalgoods = self:seekNodeByName("normalgoods")
    self.goods1 = self:seekNodeByName("goods1")
    self.goods2 = self:seekNodeByName("goods2")
    self.goods3 = self:seekNodeByName("goods3")
    self.specialgoods = self:seekNodeByName("specialgoods")
    self.specialgoods1 = self:seekNodeByName("specialgoods1")
    self.specialgoods2 = self:seekNodeByName("specialgoods2")
    self.taskbutton2 = self:seekNodeByName("taskbutton2")
    self.quickbutton2 = self:seekNodeByName("quickbutton2")

    self.goods1:setVisible(false)
    self.goods2:setVisible(false)
    self.goods3:setVisible(false)

    self.specialgoods1:setVisible(false)
    self.specialgoods2:setVisible(false)
 
    self.good1:setVisible(false)
    self.good2:setVisible(false)
    self.good3:setVisible(false)
    self.good4:setVisible(false)
    self.good5:setVisible(false)
 
    self.taskBtnEffect = "confirmBtnEffect"
    ArmatureManager:getInstance():loadEffect(self.taskBtnEffect)
    self.frameBgSpriteAction = ccs.Armature:create(self.taskBtnEffect)
    --self.frameBgSpriteAction:setPosition(1, -2)
    self.frameBgSpriteAction:setVisible(false)
    self.taskBtn:addChild(self.frameBgSpriteAction)
    self.taskBtn:setTouchEnabled(true)
    self.taskBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.taskBtn:setScale(1.1)
        elseif event.name == "ended" then
           self:onTaskBtnClick()
           self.taskBtn:setScale(1)
        end
        return true
    end)

    self.frameBgSpriteAction2 = ccs.Armature:create(self.taskBtnEffect)
    --self.frameBgSpriteAction:setPosition(1, -2)
    self.frameBgSpriteAction2:setVisible(false)
    self.taskbutton2:addChild(self.frameBgSpriteAction2)
    self.taskbutton2:setTouchEnabled(true)
    self.taskbutton2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.taskbutton2:setScale(1.1)
        elseif event.name == "ended" then
            self.taskbutton2:setScale(1)
            self:onTaskBtnClick()

        end
        return true
    end)

    self.quickbutton2:setTouchEnabled(true)
    self.quickbutton2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.quickbutton2:setScale(1.1)
        elseif event.name == "ended" then
            self.quickbutton2:setScale(1)
          --GameNet:sendMsgToSocket(26001,{task_id = self.taskId})
 
          local taskdata = TaskManager:getInstance():getTaskById(self.taskId)
          GlobalController.task:queryQuickFinishPrice(taskdata.type)
        end
        return true
    end)
    --self:setTouchCaptureEnabled(true)
    self:setTouchEnabled(true)
end

function NpcDialogWin:tipFunc(event)
 
            local function enterFun()
                GameNet:sendMsgToSocket(26007,{task_id = self.taskId})
                self.taskId = 0
                self.taskState = -1
                GlobalWinManger:closeWin(self.winTag)
            end
             
            local goodsName = configHelper:getGoodNameByGoodId(self.extraGoods[1][1])
            local tipTxt = ""
            if self.taskData.type == 8 then
              if self.taskState == 2 or  self.taskState == 0 then
                    tipTxt = "一键完成需要花费"..event.data.."元宝\n".."可额外获得奖励："..goodsName.."x"..self.extraGoods[1][3]
              elseif self.taskState == 1 then
                    tipTxt = "额外奖励需要花费"..event.data.."元宝\n".."可额外获得奖励："..goodsName.."x"..self.extraGoods[1][3]
              end
            else
              if self.taskState == 2 or  self.taskState == 0 then
                    tipTxt = "一键完成需要花费"..event.data.."元宝\n可额外获得奖励："..goodsName..self.extraGoods[1][3]
              elseif self.taskState == 1 then
                    tipTxt = "额外奖励需要花费"..event.data.."元宝\n可额外获得奖励："..goodsName..self.extraGoods[1][3]
              end
            end
            GlobalMessage:alert({
              enterTxt = "确定",
              backTxt= "取消",
              tipTxt = tipTxt,
              enterFun = enterFun,
              tipShowMid = true
            })
end

function NpcDialogWin:onTaskBtnClick()
    --state == 2 可以领取任务
    
    if self.taskData.state  == 2 then
        GameNet:sendMsgToSocket(26001,{task_id = self.taskId})
        -- 引导触发 - 当领取任务的时候
        -- Start_of_Guide --------------
        local ret = GlobalController.guide:getTriggerManager():tryTrigger(TriggerType.TASK_ACCEPT, {
             current_task_id = self.taskId
        })
        if not ret then
          GlobalController.guide:getTriggerManager():tryTrigger(TriggerType.TASK_ACCEPT_NOSTOP, {
             current_task_id = self.taskId
          })
        end
          -- End_of_Guide --------------
    elseif self.taskData.state == 1 then
            --state == 1 完成任务
        GameNet:sendMsgToSocket(26002,{task_id = self.taskId})

        -- 引导触发 - 当领取任务的时候
        -- Start_of_Guide --------------
        GlobalController.guide:getTriggerManager():tryTrigger(TriggerType.TASK_FINISH, {
            current_task_id = self.taskId
        })
            -- End_of_Guide --------------

    elseif self.taskData.state == 0 and (self.taskData.type == 3 or self.taskData.type == 4   or self.taskData.type == 8 )then
        self.npcWinClick = true
        self:AcceptTask()
        self.npcWinClick = false
    end
    self.taskId = 0
    self.taskState = -1
    GlobalWinManger:closeWin(self.winTag)
end

function NpcDialogWin:setData(data)
    self.npcVO = data
    --仓库特殊处理，仓库param：4
  
    if tonumber(string.split(self.npcVO.param,",")[1]) == 4 then
      
      self:seekNodeByName("npcfunction"):setVisible(false)
      self:seekNodeByName("function1"):setVisible(false)
      self:seekNodeByName("function2"):setVisible(false)
      self:seekNodeByName("function3"):setVisible(false)

      self.functionLay = self:seekNodeByName("exchangeGold")
      self.function1Lab = self:seekNodeByName("warehouse")
      self.function2Lab = self:seekNodeByName("exchange1")
      self.function3Lab = self:seekNodeByName("exchange2")
      self.functionLay:setVisible(true)

    else
    
      self:seekNodeByName("exchangeGold"):setVisible(false)
      self.functionLay = self:seekNodeByName("npcfunction")
      self.function1Lab = self:seekNodeByName("function1")
      self.function2Lab = self:seekNodeByName("function2")
      self.function3Lab = self:seekNodeByName("function3")

      self.functionLay:setVisible(true)
      self.function1Lab:setVisible(true)
      self.function2Lab:setVisible(true)
      self.function3Lab:setVisible(true)
    end
end

--执行下一关
function NpcDialogWin:initView(data)

  local tab = 0
  local  taskdata = nil
  if data.data ~= 0 then

      self.taskId = data.data
      self.taskType = data.type
      taskdata  = TaskManager:getInstance():getTaskById(self.taskId)
      if taskdata == nil then
        dump("============没有对应的任务数据======>")
      end
      self.taskData = taskdata
       
       if taskdata.state == 0 and (taskdata.type == 1 or taskdata.type == 5 or taskdata.type == 6 or taskdata.type == 7)  then
        tab = 0
      elseif taskdata.state == 1 and (taskdata.type == 1 or taskdata.type == 5 or taskdata.type == 6 or taskdata.type == 7)  then
        tab = 1
      elseif taskdata.state == 2 and (taskdata.type == 1 or taskdata.type == 5 or taskdata.type == 6 or taskdata.type == 7) then
        tab = 1
      elseif taskdata.type == 3 or taskdata.type == 4  or taskdata.type == 8 then
        tab = 1
        self.extraGoods = taskdata.exRewardList
      end

  else
    tab = 0
  end
    if self.specialFunctionLab then
       self.functionLay:removeChild(self.specialFunctionLab)
       self.specialFunctionLab = nil
    end
	if tab == 0 then --npc功能

		self.contentLab:setString(self.npcVO.dialogue)
		self.functionLay:setVisible(true)
		local functionArr = StringUtil.split(tostring(self.npcVO.param), ",")
		local item
		local functioinId

		for i=1,3 do
			functioinId = functionArr[i]
			item = self["function"..i.."Lab"]

			if functioinId ~= nil then
  				local functionConf = configHelper.getInstance():getNpcFunctionByID(tonumber(functioinId))
  				if functionConf then
              --if tonumber(functioinId) == 17 or tonumber(functioinId) == 18 or tonumber(functioinId) == 20 then
              if functionConf.win == "needGoods" then
                  self:needGoodsTips(functionConf)
                  item:setVisible(false)
              elseif functionConf.win == "needVip" then
                  self:needVipTips(functionConf)
                  item:setVisible(false)
              elseif functionConf.win == "killBossNum" then
                  self:killBossNumTips(functionConf)
                  item:setVisible(false)
              else

                  -- if tonumber(functioinId) == 19 then
                  --     item:setVisible(false)
                  --     return
                  -- end
        					item:setVisible(true)
        					item:setString(self:getNPCFunctionTips(functionConf))
        					item:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
        					item:setTouchEnabled(true)
        				  item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        				      if event.name == "began" then
        				      elseif event.name == "ended" then
        				          self:onNpcFunctionBtnClick(functionConf)
        				      end
        				      return true
        				  end)
              end
  			  end
			else
				  item:setVisible(false)
			end
		end

	else
   
		self.taskLay:setVisible(true)
		self:onNpcFunctionTask(self.taskData)
    --[[
    if taskdata.type == 3 or taskdata.type == 4 or taskdata.type == 8 then
      self.npcspeak2:setVisible(true)
      self.npcspeak1:setVisible(false)
 
    elseif taskdata.type == 1  or taskdata.type == 5 or taskdata.type == 6 or taskdata.type == 7 then
      
      self.npcspeak2:setVisible(false)
      self.npcspeak1:setVisible(true)
 
      if DEBUG == 1  and AUTO == 1 then
          require("framework.scheduler").performWithDelayGlobal(function() 
            self:onTaskBtnClick()
            end, 0.4)
      end
    end

    --]]
 
	end
  	
end


function NpcDialogWin:killBossNumTips(conf)
    if self.specialFunctionLab == nil then
        self.specialFunctionLab = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'></font>")
        self.specialFunctionLab:setPosition(0,100)
        self.specialFunctionLab:setContentSize(200,30)
        self.functionLay:addChild(self.specialFunctionLab)
    end
    local paramList = StringUtil.split(conf.param, "_")
    local killNum = tonumber(paramList[2])
    local sceneId = tonumber(paramList[1])
    local curKillNum = 0
    local list = SceneManager.aberrancePalaceData.kill_boss or {}
    for i=1,#list do
       local vo= list[i]
       if vo.scene_id == sceneId then
          curKillNum = vo.num
       end
    end
    local color = '0x6fc491'
    if curKillNum >= killNum then
        color = '0x54FF00'
    else
        color = '0xFF0000'
    end
    local tips = ""
    tips = "<font color='0xF2AE42' size='20' opacity='255'>"..conf.btnlab.."       <font color='"..color.."' size='20' opacity='255'>(需要击杀BOSS数量："..killNum..")</font></font>"
    self.specialFunctionLab:renderXml(tips)

    self.specialFunctionLab:setTouchEnabled(true)
    self.specialFunctionLab:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            --self:onNpcFunctionBtnClick(conf)
            if curKillNum >= killNum then
                GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(paramList[3])})
            else
                GlobalMessage:show("需要击杀BOSS数量"..killNum.."个以上")
            end
        end
        return true
    end)
end


function NpcDialogWin:needVipTips(conf)
    if self.specialFunctionLab == nil then
        self.specialFunctionLab = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'>jijiodssdadadadadadadadjjlk</font>")
        self.specialFunctionLab:setPosition(0,100)
        self.specialFunctionLab:setContentSize(200,30)
        self.functionLay:addChild(self.specialFunctionLab)
    end
    local paramList = StringUtil.split(conf.param, "_")
    local vipLv = tonumber(paramList[2])
    local curVipLv = RoleManager:getInstance().roleInfo.vip
    local color = '0x6fc491'
    if curVipLv >= vipLv then
        color = '0x54FF00'
    else
        color = '0xFF0000'
    end
    local tips = ""
    tips = "<font color='0xF2AE42' size='20' opacity='255'>"..conf.btnlab.."    <font color='"..color.."' size='20' opacity='255'>(VIP "..vipLv..")</font></font>"
    self.specialFunctionLab:renderXml(tips)

    self.specialFunctionLab:setTouchEnabled(true)
    self.specialFunctionLab:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            --self:onNpcFunctionBtnClick(conf)
            if curVipLv >= vipLv then
                GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(paramList[1])})
            else
                GlobalMessage:show("需要VIP"..vipLv)
            end
        end
        return true
    end)
end

function NpcDialogWin:needGoodsTips(conf)
    if self.specialFunctionLab == nil then
        self.specialFunctionLab = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'>T</font>")
        self.specialFunctionLab:setPosition(0,100)
        self.specialFunctionLab:setContentSize(200,30)
        self.functionLay:addChild(self.specialFunctionLab)
    end

    local paramList = StringUtil.split(conf.param, "_")
    local goodsId = tonumber(paramList[2])
    local goodsNum = 0
    local tips = ""
    if goodsId == 0 or goodsId == nil then
        tips = "<font color='0xF2AE42' size='20' opacity='255'>"..conf.btnlab.."</font>"
    else
        goodsNum = BagManager:getInstance().bagInfo:findItemCountByItemId(goodsId)
        local color = '0x6fc491'
        if BagManager:getInstance().bagInfo:findItemCountByItemId(goodsId) >= tonumber(paramList[3]) then
            color = '0x54FF00'
        else
            color = '0xFF0000'
        end
        local num = goodsNum.."/"..paramList[3]
        tips = "<font color='0xF2AE42' size='20' opacity='255'>"..conf.btnlab.."       "..configHelper:getGoodNameByGoodId(goodsId).."<font color='"..color.."' size='20' opacity='255'>("..num..")</font></font>"
    end
    self.specialFunctionLab:renderXml(tips)

    self.specialFunctionLab:setTouchEnabled(true)
    self.specialFunctionLab:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            --self:onNpcFunctionBtnClick(conf)
            if goodsNum == 0 or goodsNum >= tonumber(paramList[3]) then
                GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(paramList[1])})
            else
                GlobalMessage:show(configHelper:getGoodNameByGoodId(goodsId).." 数量不够")
            end
        end
        return true
    end)
end

function NpcDialogWin:getNPCFunctionTips(conf)
  return conf.btnlab
end


function NpcDialogWin:AcceptTask()
  
  
  if self.taskData and self.npcWinClick then
    if self.taskData.state == 2 then
        SceneManager:playerMoveToNPC(self.taskData.accept_npc_id,true)
    elseif self.taskData.state == 1 then
        SceneManager:playerMoveToNPC(self.taskData.finish_npc_id,true)
    elseif self.taskData.state == 0 then
          local pos = string.split(self.taskData.pos, ",")
          if self.taskData.sort_id == 9 or self.taskData.sort_id == 13  then
          --杀怪或收集材料
          TaskManager:getInstance():setCurrentTaskMonsterId(self.taskData.tool)
          SceneManager:playerMoveToMonster(self.taskData.sceneId,cc.p(pos[1],pos[2]),self.taskData.tool)
        
          end
    end
  end
  
end


--处理任务相关功能
function NpcDialogWin:onNpcFunctionTask(data)

  self.taskState = data.state

  if data.type == 3 or data.type == 4 or data.type == 8 then
      self.npcspeak2:setVisible(true)
      self.npcspeak1:setVisible(false)

      if data.state == 2 then
        self.speak2:setString(data.accept_info)
        self.taskbutton2:setButtonLabelString("接受任务")
         --self.quickBtnLab:setString("一键完成")
      elseif data.state == 1 then
        self.speak2:setString(data.finish_info)
        self.taskbutton2:setButtonLabelString("完成任务")
        --self.quickBtnLab:setString("额外奖励")
      elseif data.state == 0 then
          self.taskbutton2:setButtonLabelString("立即前往")
          self.speak2:setString(data.accept_info)
      end

      local index = 1
      for i=1,#data.rewardList do
          local commonItem
          if self["commonItems"..i] == nil then
            commonItem = CommonItemCell.new()
            self.normalgoods:addChild(commonItem, 10, 10)
            commonItem:setPosition(self["goods"..i]:getPosition())
            self["commonItems"..i] = commonItem
          else
            commonItem = self["commonItems"..i]
            commonItem:setVisible(true)
          end
          local goodsList = data.rewardList[i]
          commonItem:setData({goods_id = goodsList[1], is_bind = goodsList[2]})
          commonItem:setCount(goodsList[3])
          index = index + 1
      end

      while self["commonItems"..index] ~= nil do
          self["commonItems"..index]:setVisible(false)
          index = index + 1
      end

      local index = 1
      for i=1,#data.exRewardList do
          local commonItem
          if self["specialcommonItem"..i] == nil then
            commonItem = CommonItemCell.new()
            self.specialgoods:addChild(commonItem, 10, 10)
            commonItem:setPosition(self["specialgoods"..i]:getPosition())
            self["specialcommonItem"..i] = commonItem
          else
            commonItem = self["specialcommonItem"..i]
            commonItem:setVisible(true)
          end
          local goodsList = data.exRewardList[i]
          commonItem:setData({goods_id = goodsList[1], is_bind = goodsList[2]})
          commonItem:setCount(goodsList[3])
          index = index + 1
      end

      while self["specialcommonItem"..index] ~= nil do
          self["specialcommonItem"..index]:setVisible(false)
          index = index + 1
      end

      --按钮效果
    if data.btn_effect == 1  then
        self.frameBgSpriteAction2:setVisible(true)
        self.frameBgSpriteAction2:getAnimation():play("effect")
    else
        self.frameBgSpriteAction2:getAnimation():stop()
        self.frameBgSpriteAction2:setVisible(false)
    end

    elseif data.type == 1  or data.type == 5 or data.type == 6 or data.type == 7 then
      
      self.npcspeak2:setVisible(false)
      self.npcspeak1:setVisible(true)

      if DEBUG == 1  and AUTO == 1 then
          require("framework.scheduler").performWithDelayGlobal(function() 
            self:onTaskBtnClick()
            end, 0.4)
      end
      
      if data.state == 2 then
        self.contentLab:setString(data.accept_info)
         self.taskBtn:setButtonLabelString("接受任务")
      elseif data.state == 1 then
        self.contentLab:setString(data.finish_info)
        self.taskBtn:setButtonLabelString("完成任务")
        --self.quickBtnLab:setString("额外奖励")
      elseif data.state == 0 then
          self.contentLab:setString(data.des)
      end

      local index = 1
      for i=1,#data.rewardList do
          local commonItem
          if self["commonItem"..i] == nil then
            commonItem = CommonItemCell.new()
            self.taskLay:addChild(commonItem, 10, 10)
            commonItem:setPosition(self["good"..i]:getPosition())
            self["commonItem"..i] = commonItem
          else
            commonItem = self["commonItem"..i]
            commonItem:setVisible(true)
          end
          local goodsList = data.rewardList[i]
          commonItem:setData({goods_id = goodsList[1], is_bind = goodsList[2]})
          commonItem:setCount(goodsList[3])
          index = index + 1
      end
      while self["commonItem"..index] ~= nil do
          self["commonItem"..index]:setVisible(false)
          index = index + 1
      end

      --按钮效果
    if data.btn_effect == 1  then
        self.frameBgSpriteAction:setVisible(true)
        self.frameBgSpriteAction:getAnimation():play("effect")
    else
        self.frameBgSpriteAction:getAnimation():stop()
        self.frameBgSpriteAction:setVisible(false)
    end
  
  end

 
end

--处理Npc默认功能
function NpcDialogWin:onNpcFunctionBtnClick(functionConf)
	if functionConf.win ~= "" then

      --仓库兑换功能，特殊处理
      if functionConf.win == "tips" then

        local bagInfo = BagManager:getInstance().bagInfo
        local wealthInfo = RoleManager:getInstance().wealth
        local key = functionConf.param
        local goodList = configHelper:getFusionStuffByKey(key)

        for i=1,#goodList do
          if goodList[i][1] == "jade" or goodList[i][1] == "coin"  then

            if goodList[i][1] == "jade" and goodList[i][2] > wealthInfo.jade then
              --GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,configHelper:getGoodNameByGoodId(goodList[i][1]).."数量不足！")
                
                 function exfunc()
                    GlobalWinManger:openWin(WinName.RECHARGEWIN)
                  end

                 GlobalMessage:alert({
                    enterTxt = "是",
                    backTxt= "否",
                    tipTxt = "元宝数量不足,是否充值？",
                    enterFun = exfunc,
                    tipShowMid = true,
                })
              return
            elseif goodList[i][1] == "coin" and goodList[i][2] > wealthInfo.coin then
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, "金币数量不足！")
               return
             end

          elseif goodList[i][1] == "goods" and goodList[i][3] > bagInfo:findItemCountByItemId(goodList[i][2]) then
       
              GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,configHelper:getGoodNameByGoodId(goodList[i][2]).."数量不足！")
              return
          end
        end

        function exfunc()
          GameNet:sendMsgToSocket(14031,{formula_id = key})
        end
 
         GlobalMessage:alert({
            enterTxt = "确定",
            backTxt= "取消",
            tipTxt = functionConf.desc,
            enterFun = exfunc,
            tipShowMid = true,
        })
        return 
      end

      if FunctionOpenManager:getFunctionOpenByWinName(functionConf.win) then
          if functionConf.win == WinName.NPCTRANSFER or functionConf.win == WinName.NPCBUYWIN then
              GlobalWinManger:openWin(functionConf.win,self.npcVO)
          else
              GlobalWinManger:openWin(functionConf.win)
          end
      else
          FunctionOpenManager:showFunctionOpenTips(functionConf.win)
      end
	end
end

function NpcDialogWin:open()

    self.npcspeak1:setVisible(true)
    self.npcspeak2:setVisible(false)
    
    if self.handle == nil then
          self.handle = GlobalEventSystem:addEventListener(TaskEvent.ON_RCV_QUICK_FINISH_PRICE, handler(self,self.tipFunc))
    end 

	  if self.npcOpenDialogEventId == nil then
        self.npcOpenDialogEventId = GlobalEventSystem:addEventListener(SceneEvent.NPC_OPEN_DIALOG,handler(self,self.initView))
    end
    if self.AutoFightEventId == nil then
        self.AutoFightEventId = GlobalEventSystem:addEventListener(SceneEvent.NPC_ACCEPT_FIGHT,handler(self,self.AcceptTask))
    end    

    GameNet:sendMsgToSocket(11025,{id = self.npcVO.id})
	  self.titile:setString(self.npcVO.name)
  	self.contentLab:setString("")
  	self.taskLay:setVisible(false)
  	self.functionLay:setVisible(false)
    FightModel.pauseAutoAtk = true

    --self:initView({data = 0})
end

local function _removeEvent(self)
  if self.npcOpenDialogEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.npcOpenDialogEventId)
        self.npcOpenDialogEventId = nil
    end

    if self.AutoFightEventId == nil then
         GlobalEventSystem:removeEventListenerByHandle(self.AutoFightEventId)
        self.AutoFightEventId = nil
    end
    
    if self.handle ~= nil then
        GlobalEventSystem:removeEventListenerByHandle(self.handle)
        self.handle  = nil
    end
end

function NpcDialogWin:close()
    FightModel.pauseAutoAtk = false
  	
    _removeEvent(self)
    self.super.close(self)
    self.frameBgSpriteAction:getAnimation():stop()
    self.frameBgSpriteAction2:getAnimation():stop()
end

function NpcDialogWin:destory()
    _removeEvent(self)
    NpcDialogWin.super.destory(self)
    ArmatureManager:getInstance():unloadEffect(self.taskBtnEffect)
end

return NpcDialogWin



