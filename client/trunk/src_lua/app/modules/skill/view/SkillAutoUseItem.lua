--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-15 18:14:02
-- 自动释放列表
local SkillAutoUseItem = SkillAutoUseItem or class("SkillAutoUseItem", function()
    return display.newNode()
end)

--构造
function SkillAutoUseItem:ctor(vo)
    self.vo = vo
	  local zdsfTxt = display.newTTFLabel({text = self.vo.conf.autodesc,
        size = 18,color = TextColor.TEXT_W})
    --        :align(display.LEFT,0,0)
            :addTo(self)
    zdsfTxt:setPosition(40,15)
    --display.setLabelFilter(zdsfTxt)

    local selectBg = display.newSprite("#com_chkBtn1.png")
    self:addChild(selectBg)
    selectBg:setPosition(-180,0)
    selectBg:setTouchEnabled(true)
    selectBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then         
            elseif event.name == "ended" then
                if self.vo.autoSet == 0 then
                    self.vo.autoSet = 1
                    GlobalMessage:show("激活技能"..self.vo.conf.name)
                else
                    self.vo.autoSet = 0
                    GlobalMessage:show("关闭自动技能"..self.vo.conf.name)
                end
                GameNet:sendMsgToSocket(12007,{skill_id = self.vo.id,switch = self.vo.autoSet})
                self:setAutoStates(self.vo)
            end
            return true
    end)

    self.selectPic = display.newSprite("#com_chkBtn1Sel.png")
    self:addChild(self.selectPic)
    self.selectPic:setPosition(-180,0)

	  self.itemBg = display.newSprite("#com_propBg1.png")
  	self:addChild(self.itemBg)
  	self.itemBg:setPosition(80-180,10)

    self.skillIcon = display.newSprite(ResUtil.getSkillIcon2(self.vo.id))
    self.itemBg:addChild(self.skillIcon)
    self.skillIcon:setPosition(38,38)

  	self.skillName = display.newTTFLabel({text = self.vo.conf.name,
        size = 20,color = TextColor.TEXT_W})
           -- :align(display.LEFT,0,0)
            :addTo(self)
    self.skillName:setPosition(80-180,-40)
    --display.setLabelFilter(self.skillName)

  	local line = display.newSprite("#com_uiLine1.png")
  	self:addChild(line)
    line:setScaleX(100)
  	line:setPosition(0,-60)

    self:setAutoStates(self.vo)
end

function SkillAutoUseItem:setAutoStates(vo)
    self.vo = vo
	  if vo.autoSet == 0 then
        self.selectPic:setVisible(false)
    else
        self.selectPic:setVisible(true)
    end 
end
return SkillAutoUseItem