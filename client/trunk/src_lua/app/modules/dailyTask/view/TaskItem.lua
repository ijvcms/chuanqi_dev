--
-- Author: Yi hanneng
-- Date: 2016-01-05 15:42:58
--
local  TaskItem = TaskItem or class("TaskItem", function()
	return display.newNode()
	end)

function TaskItem:ctor(size)
  self.itemSize = size

  self.line = display.newSprite("#scene/scene_taskLine.png")--display.newSprite("#scene/scene_taskLine.png")
  self.line:setScaleX(37)
  self:addChild(self.line)
  self.line:setPosition(0, -size.height/2+1)
  --dump(size)--223,58
  self.lbl = SuperRichText.new()
  self:addChild(self.lbl)
  --self:setContentSize(size)
end

function TaskItem:setData(data)
  self.data = data
  local str
  if data.state == 0 then
      str = data.name..data.des
    elseif data.state == 1 then
      str = data.name..data.finish_des
    elseif data.state == 2 then
      str = data.name..data.accept_des
    end   
  if str ~= nil then
    str = StringUtil.replaceKeyVal(str, data.currentNum.."/"..data.needNum)
  end
 
  if str ~= nil and RichTextHelper.checkIsXmlString(str) then   
      self.lbl:renderXml(str)
      self.lbl:setPosition(- 106, 0 - self.lbl:getContentSize().height/2)
      --self.lbl:setContentSize(cc.size(self.lbl:getBoundingBox().width, 10))
  end
  if data.effect ~= nil and data.effect ~= "" then
      self:playEffect(data.effect)
  else
      if self.effect then
          self.effect:stopAllActions()
          self.effect:setVisible(false)
      end
  end
  self:setNodeEventEnabled(true, function(event)
        if event.name == "cleanup" then
          -- if self.frameBgSpriteAction then
          --   self.frameBgSpriteAction:removeSelf()
          --   self.frameBgSpriteAction = nil
          -- end
          --  ArmatureManager:getInstance():unloadEffect(self.data.effect)
            if self.effect then
                self.effect:stopAllActions()
                self.effect:setVisible(false)
            end
        end 
  end)
end

function TaskItem:playEffect(action)
    -- local callback = function()
    --     if self.frameBgSpriteAction then
    --       self.frameBgSpriteAction:removeSelf()
    --       self.frameBgSpriteAction = nil
    --     end
    --     self.frameBgSpriteAction = ccs.Armature:create(action)
    --     self:addChild(self.frameBgSpriteAction, 10)
    --     self.frameBgSpriteAction:getAnimation():play("effect")
    --     self.frameBgSpriteAction:setPosition(0, 0)
    -- end
    -- ArmatureManager:getInstance():loadEffect(action, callback)
    if self.effect == nil then
        self.effect = display.newSprite("#scene/scene_taskSelFrame.png")
        --self.effect:setScale(self.itemSize.width/60,(self.itemSize.height - 4)/60)
        self:addChild(self.effect,-1)
    end
    self.effect:setVisible(true)
    local action1 = cc.FadeIn:create(0.3)
    local action2 = cc.FadeOut:create(0.3)
    local action5 = transition.sequence({
                action1,
                action2,
            })
    local action6 = cc.RepeatForever:create(action5)
    self.effect:runAction(action6)
end

function TaskItem:getData()
  return self.data
end

return TaskItem