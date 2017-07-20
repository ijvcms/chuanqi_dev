--
-- Author: 21102585@qq.com
-- Date: 2014-12-13 15:20:19
-- 战斗效果管理，用来管理战斗中大招和头上和脚下和脚底阴影部分
FightEffectManager = FightEffectManager or {}




function FightEffectManager:setLay(bottomLay,topLay,sceneObjLay)
    self.bottomLay = bottomLay
    self.topLay = topLay
    self.sceneObjLay = sceneObjLay
    self.topLay:setNodeEventEnabled(true, handler(self, self.onNodeEvent))
    self.bottomLay:setNodeEventEnabled(true, handler(self, self.onNodeEvent))
    self.sceneObjLay:setNodeEventEnabled(true, handler(self, self.onNodeEvent))
    self.isDestory_ = false
end

function FightEffectManager:ctor()

  self.hurtLabDic1 = {}
  self.hurtLabDic2 = {}
  self.hurtLabDic3 = {}

  self.flyEffTable = {}
  self.name = "zhang"
  self.effDic = {}  --效果字典
  self.ShadowPool = {}

  --目前只有光环使用了这个,为了避免影响shadow的渲染,设置单独的层次
	  local function onAddRoleShadow(view)
      if view.data then
          self.bottomLay:addChild(view.data,RoleLayerArr.kGHEffectLayerId)
      end  
    end
    GlobalEventSystem:addEventListener(FightEvent.ADD_ROLE_SHADOW,onAddRoleShadow)

    local function onAddRoleTopContainer(view)
      if view.data then
          self.topLay:addChild(view.data,RoleLayerArr.kTopContainerLayerId)
      end  
    end
    GlobalEventSystem:addEventListener(FightEvent.ADD_ROLE_TOP_CONTAINER,onAddRoleTopContainer)

    local function onAddRoleHurtLab(view)
      if view.data then
          self.topLay:addChild(view.data,RoleLayerArr.kManualAddHurtLayerId)
      end  
    end
    GlobalEventSystem:addEventListener(FightEvent.ADD_ROLE_HURT_LAB,onAddRoleHurtLab)

    local function onAddRoleHpContainer(view)
      if view.data then
          self.topLay:addChild(view.data,RoleLayerArr.kHpContainerLayerId)
      end
    end 
    GlobalEventSystem:addEventListener(FightEvent.ADD_ROLE_HP_CONTAINER,onAddRoleHpContainer)
    

    local function onAddRoleTopEff(view) 
      if view.data then      
        self:playEffect(view.data.effID,self.topLay,view.data.pos,RoleLayerArr.kTopEffectLayerId)
      end  
    end
    GlobalEventSystem:addEventListener(FightEvent.PLAY_TOP_EFFECT,onAddRoleTopEff)

    local function onAddRoleFootEff(view) 
      if view.data then           
        self:playEffect(view.data.effID,self.bottomLay,view.data.pos,RoleLayerArr.kFootLayerId)
      end  
    end
    GlobalEventSystem:addEventListener(FightEvent.PLAY_FOOT_EFFECT,onAddRoleFootEff)
   
   local function onAddFlyEff(view) 
      if view.data then           
        self:addFlyEffect(view.data)
      end  
    end
    GlobalEventSystem:addEventListener(FightEvent.PLAY_FLY_EFFECT,onAddFlyEff)

    local function onAddTeamIcon(view) 
      if view.data then           
        self.topLay:addChild(view.data,RoleLayerArr.kTeamLayerId)
      end  
    end
    GlobalEventSystem:addEventListener(FightEvent.ADD_TEAM_ICON,onAddTeamIcon)

    local function onAddUnionIcon(view) 
      if view.data then           
        self.topLay:addChild(view.data,RoleLayerArr.kUnionLayerId)
      end  
    end
    GlobalEventSystem:addEventListener(FightEvent.ADD_UNION_ICON,onAddUnionIcon)
    


end


function FightEffectManager:onNodeEvent(event)
    if event.name == "cleanup" then
        self.isDestory_ = true
    end
end


--显示阴影效果
function FightEffectManager:addShadowEff()
    local shadow
    if #self.ShadowPool > 0 then
        shadow = table.remove(self.ShadowPool)
        self.bottomLay:addChild(shadow,RoleLayerArr.kShadowLayerId)
        shadow:release()
        shadow:setVisible(true)
    else
        shadow = display.newSprite("#scene/scene_shadow.png")
        self.bottomLay:addChild(shadow,RoleLayerArr.kShadowLayerId)
    end
    return shadow
end

--移除阴影效果
function FightEffectManager:removeShadowEff(shadow)
    if self.selShadow and self.selShadow == shadow then
       self.selShadow:setVisible(false)
       return
    end
    shadow:retain()
    self.bottomLay:removeChild(shadow)
    table.insert(self.ShadowPool, shadow)

end

--选中效果
function FightEffectManager:showSelection(oldShadow)
    if not self.selShadow then
      

        self.selShadow = display.newSprite("#scene/scene_shadowSel.png")
        self.bottomLay:addChild(self.selShadow,RoleLayerArr.kShadowLayerId)
    else
        self.selShadow:setVisible(true)
        if self.selShadow == oldShadow then
            return oldShadow
        end
    end
    self:removeShadowEff(oldShadow)
    return self.selShadow
end

--隐藏选中
function FightEffectManager:hideSelection(oldShadow)
    if self.selShadow then
        self.selShadow:setVisible(false)
        if oldShadow ~= self.selShadow then
           return oldShadow
        end
    end
    return self:addShadowEff()
end

function FightEffectManager:addAttackEffect(view,effectId,isTop)
  if not view then return end
  effectId = tonumber(effectId) or 0

  if isTop then
    self.topLay:addChild(view,RoleLayerArr.kTopAttackEffectlayerId + effectId)
  else
    self.bottomLay:addChild(view,RoleLayerArr.kButtomAttackEffectLayerId + effectId)
  end
end



function FightEffectManager:getHurtLabEff(text,font,xx,yy)
    local view
    if font == 1 then
        if #self.hurtLabDic1 > 0 then
            view = table.remove(self.hurtLabDic1,1)
        else
          view = cc.LabelAtlas:_create()
          view:initWithString(
            text,
            "fonts/num_style_fight2.png",
            27,
            60,
            string.byte(0))
            -- view = display.newBMFontLabel({
            --     text = "",
            --     font = "fonts/num_style_fight.fnt",
            --     x = 0,
            --     y = yy,
            --   })
            -- --view:setOpacity(180)
            view:setTouchEnabled(false)
            self.topLay:addChild(view,RoleLayerArr.kHurtType1LayerId)
            --view:setLocalZOrder(300000)
        end
        view.labType = 1
        view:setString(text)
        --self.tipLabel:setScale(1.4)
        view:setPosition(xx,yy)
        view:setVisible(true)
        view:stopAllActions()
       

    elseif font == 2 then
        if #self.hurtLabDic2 > 0 then
            view = table.remove(self.hurtLabDic2,1)
        else
            view = cc.LabelAtlas:_create()
            view:initWithString(
              text,
              "fonts/roleHpNumGreenFont2.png",
              17,
              21,
              string.byte(0))

           --  view = display.newBMFontLabel({
           --      text = "",
           --      font = "ui/font/roleHpNumGreenFont.fnt",
           --      x = 0,
           --      y = yy,
           --    })
           -- -- view:setOpacity(180)
            view:setTouchEnabled(false)
            self.topLay:addChild(view,RoleLayerArr.kHurtType2LayerId)
            --view:setLocalZOrder(300000)
        end
        view.labType = 2
        view:setString(text)
        --self.tipLabel:setScale(1.4)
        view:setPosition(xx,yy)
        view:setVisible(true)
        view:stopAllActions()
    elseif font == 3 then
        if #self.hurtLabDic3 > 0 then
            view = table.remove(self.hurtLabDic3,1)
        else
            view = cc.LabelAtlas:_create()
            view:initWithString(
              text,
              "fonts/num_style_mana.png",
              27,
              60,
              string.byte(0))

           --  view = display.newBMFontLabel({
           --      text = "",
           --      font = "fonts/roleHpNumGreenFont.fnt",
           --      x = 0,
           --      y = yy,
           --    })
           -- -- view:setOpacity(180)
            view:setTouchEnabled(false)
            self.topLay:addChild(view,RoleLayerArr.kHurtType3LayerId)
            --view:setLocalZOrder(300000)
        end
        view.labType = 3
        view:setString(text)
        --self.tipLabel:setScale(1.4)
        view:setPosition(xx,yy)
        view:setVisible(true)
        view:stopAllActions()
    end
    
    return view
end

function FightEffectManager:addHurtLabEff(view)
    if view.labType == 1 then
        if #self.hurtLabDic1 >10 then
          local pare = view:getParent()
          if pare ~= nil then           
               pare:removeChild(view)
          end
        else
          table.insert(self.hurtLabDic1,view)
        end
    elseif view.labType == 3 then
        if #self.hurtLabDic3 >10 then
          local pare = view:getParent()
          if pare ~= nil then           
               pare:removeChild(view)
          end
        else
          table.insert(self.hurtLabDic3,view)
        end
    else
        if #self.hurtLabDic2 >6 then
            local pare = view:getParent()
            if pare ~= nil then           
                 pare:removeChild(view)
            end
        else
            table.insert(self.hurtLabDic2,view)
        end
    end
end


function FightEffectManager:addFlyEffect(data)
    local callback = function()
        if self.isDestory_ then
          return
        end
        local effArmature = ccs.Armature:create(data.effId)
        effArmature:setScaleX(1)
        effArmature:setScaleY(1)
        effArmature:getAnimation():setSpeedScale(1)
        --effArmature:setPosition(pos.x,pos.y)
        self.sceneObjLay:addChild(effArmature)

        effArmature:stopAllActions()
        effArmature:getAnimation():play("effect")

        --  local function animationEvent(armatureBack,movementType,movementID)
        --    if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
        --      armatureBack:getAnimation():setMovementEventCallFunc(function()end)
        --      armatureBack:stopAllActions()
        --      armatureBack:getAnimation():stop()
        --      if armatureBack:getParent() then
        --        armatureBack:getParent():removeChild(armatureBack)
        --      end
        --    end
        --  end 
        -- effArmature:getAnimation():setMovementEventCallFunc(animationEvent)
        local vo = SkillFlyEffVO.new(data,effArmature)
        self.flyEffTable[vo.id] = vo
    end
    ArmatureManager:getInstance():loadEffect(data.effId, callback)
end 

function FightEffectManager:delFlyEffect(id)
    local armature = self.flyEffTable[id].armature
    armature:stopAllActions()
    armature:getAnimation():stop()
    if armature:getParent() then
        armature:getParent():removeChild(armature)
        ArmatureManager:getInstance():unloadEffect(self.flyEffTable[id].effId)
    end 
    self.flyEffTable[id] = nil
end 

function FightEffectManager:update(curTime)
    for k,v in pairs(self.flyEffTable) do
        v:update(curTime)
    end
end 

function FightEffectManager:playEffect(effectID,parent,pos,layerId)
  local xx = math.floor(pos.x)
  local yy = math.floor(pos.y)
  local key =effectID..xx..yy

  if self.effDic[key] == nil then
    self.effDic[key] = socket.gettime()
  else
      local curEffTime =  self.effDic[key] 
      if  socket.gettime() - curEffTime < 0.2 then      
        return 
      else          
         self.effDic[key] = socket.gettime()
      end 
  end
  local callback = function()
      if self.isDestory_ then
          return
      end
      layerId = layerId or 1
      local effArmature = ccs.Armature:create(effectID)
      effArmature:setScaleX(1)
      effArmature:setScaleY(1) 
      effArmature:getAnimation():setSpeedScale(1)
      effArmature:setPosition(pos.x,pos.y)   
      parent:addChild(effArmature,layerId)

      effArmature:stopAllActions()
      effArmature:getAnimation():play("effect")

      local function animationEvent(armatureBack,movementType,movementID)
         if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
              armatureBack:getAnimation():setMovementEventCallFunc(function()end)
              armatureBack:stopAllActions()
              armatureBack:getAnimation():stop()
              if armatureBack:getParent() then
                  armatureBack:getParent():removeChild(armatureBack)
                  ArmatureManager:getInstance():unloadEffect(effectID)
              end
         end
      end 
      effArmature:getAnimation():setMovementEventCallFunc(animationEvent)  
  end 
  ArmatureManager:getInstance():loadEffect(effectID, callback)
	 	
end	

--暂停
function FightEffectManager:pause()
  self.isPause = true
  if self.armature then
    self.armature:getAnimation():pause()
  end
  if self.ackEffArmature then
    self.ackEffArmature:getAnimation():pause()
  end 
end 

--恢复暂停
function FightEffectManager:resume()
  for k,v in pairs(self.effDic) do
      print(k,v)
   end 
end 

function FightEffectManager:close()
    for k,v in pairs(self.flyEffTable) do
        v:clear()
    end
    self.flyEffTable = {}

    local arr = self.bottomLay:getChildren()
    for i=1,#arr do
        arr[i]:stopAllActions()
    end
    self.bottomLay:removeAllChildren()

    arr = self.topLay:getChildren()
    for i=1,#arr do
        arr[i]:stopAllActions()
    end
    self.topLay:removeAllChildren()

    arr = self.sceneObjLay:getChildren()
    for i=1,#arr do
        arr[i]:stopAllActions()
    end
    self.sceneObjLay:removeAllChildren()
    self.hurtLabDic1 = {}
    self.hurtLabDic2 = {}
    self.hurtLabDic3 = {}
    self.effDic = {}  --效果字典
    self.selShadow = nil
end

function FightEffectManager:destory()
    self:close()

  	-- self.bottomLay = nil
  	-- self.topLay = nil
   --  self.sceneObjLay = nil
   --  self.effDic = {} 
  	-- GlobalEventSystem:removeEventListener(FightEvent.ADD_ROLE_SHADOW)
  	-- GlobalEventSystem:removeEventListener(FightEvent.PLAY_FOOT_EFFECT)
  	-- GlobalEventSystem:removeEventListener(FightEvent.PLAY_TOP_EFFECT)	
   --  GlobalEventSystem:removeEventListener(FightEvent.PLAY_FLY_EFFECT)
   --  GlobalEventSystem:removeEventListener(FightEvent.ADD_ROLE_HURT_LAB)
end	
