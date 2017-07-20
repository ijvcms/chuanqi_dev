--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-15 15:25:45
-- 快捷设置列表Item
local SkillQuickListItem = SkillQuickListItem or class("SkillQuickListItem", function()
    return display.newNode()
end)

function SkillQuickListItem:ctor(vo)
	self.vo = vo
	self.bg = display.newSprite("#scene/scene_useSkillBtn.png")
  	self:addChild(self.bg)
  	
  	self.skillIcon = display.newSprite("icons/skill/"..self.vo.id..".png")
  	self:addChild(self.skillIcon)
    self.skillIcon:setScale(0.9)

  	self.skillNameLab = display.newTTFLabel({text = vo.conf.name,
        size = 20,color = TextColor.TEXT_W})
            :align(display.CENTER,0,0)
            :addTo(self)
    self.skillNameLab:setPosition(0,-46)
    display.setLabelFilter(self.skillNameLab)
end

function SkillQuickListItem:setNameVisible(b)
	if self.skillNameLab then
		self.skillNameLab:setVisible(b)
	end
end

function SkillQuickListItem:setSelect(b)
    if b then
        if self.selBg then
            self.selBg:setVisible(true)
        else
            self.selBg = display.newSprite("#scene/scene_skillSelRoundBg.png")
            self:addChild(self.selBg)
            self.selBg:setPosition(0,0)
        end
    else
        if self.selBg then
            self.selBg:setVisible(false)
            self.selBg = false
        end
    end
end

function SkillQuickListItem:getSkillVO()
	return self.vo
end


return SkillQuickListItem