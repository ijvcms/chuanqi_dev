--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-15 15:27:22
-- 快捷设置使用Item
local SkillQuickUseItem = SkillQuickUseItem or class("SkillQuickUseItem", function()
    return display.newNode()
end)

--构造
function SkillQuickUseItem:ctor(index)
    self.index = index
	  local bg = display.newSprite("#scene/scene_useSkillBtn.png")
  	self:addChild(bg)
  	
  	self.skillLay = display.newNode()
  	self:addChild(self.skillLay)

  	local numBg = display.newSprite("#scene/scene_skillIndexBg.png")
  	self:addChild(numBg)
  	numBg:setPosition(-26,25)

  	self.numLab = display.newTTFLabel({text = self.index,
        size = 16,color = TextColor.TEXT_W})
            :align(display.CENTER,0,0)
            :addTo(numBg)
   	self.numLab:setPosition(12,12)
    --display.setLabelFilter(self.numLab)

    self.clearBtn = display.newSprite("#skill_delBtn.png")
  	self:addChild(self.clearBtn)
  	self.clearBtn:setPosition(26,25)
  	self.clearBtn:setTouchEnabled(true)
  	self.clearBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      			if event.name == "began" then         
      				self.clearBtn:setScale(1.1)   	
                elseif event.name == "ended" then
                	self.clearBtn:setScale(1) 
                	if self.vo then
                		self:setSkillVO(nil,true)
                	end
      			end
            return true
    end)

  	self.nameLab = display.newTTFLabel({text = "",
        size = 30,color = TextColor.TEXT_R})
            :align(display.CENTER,0,0)
            :addTo(self)
   	self.nameLab:setPosition(0,0)

   	self.isClearVisible = false
   	self:setClearBtnVisible(self.isClearVisible)
end

function SkillQuickUseItem:setSkillVO(vo,isSend)
  local oldId = 0
  if self.vo then
      oldId = self.vo.id
  end
	if vo ~= nil and self.vo ~= nil and self.vo.id == vo.id then
		return
	end
	self.vo = vo
	if self.skillIcon then
		self.skillLay:removeChild(self.skillIcon)
		self.skillIcon = nil
	end
	if self.vo ~= nil then
		  --替换技能
		  self.skillIcon = display.newSprite("icons/skill/"..self.vo.id..".png")
  		self.skillLay:addChild(self.skillIcon)
      self.skillIcon:setScale(0.9)
      if isSend then
        GameNet:sendMsgToSocket(12005,{skill_id = self.vo.id,pos = self.index})
      end
  else
  		--清理技能
  		--self.clearBtn:setVisible(false)
      if isSend and oldId ~= 0 then
        GameNet:sendMsgToSocket(12006,{skill_id = oldId})
      end
	end
end

function SkillQuickUseItem:setClearBtnVisible(b)
	self.isClearVisible = b
	self.clearBtn:setVisible(self.isClearVisible)
	if self.vo == nil then
		  --self.clearBtn:setVisible(false)
	end
end


return SkillQuickUseItem