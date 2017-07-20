--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 15:29:32
--
local MergeActivityListItem = MergeActivityListItem or class("MergeActivityListItem", function()
    return display.newNode()
end)

--构造
function MergeActivityListItem:ctor(vo)
	self.vo = vo
	self.bg = display.newSprite("#com_labBtn4.png") --183,53
  	self:addChild(self.bg)
  	self.bg:setPosition(0,0)

  	self.selbg = display.newSprite("#com_labBtn4Sel.png")
  	self:addChild(self.selbg)
  	self.selbg:setPosition(0,0)
    self.selbg:setVisible(false)

    self.titleLab = display.newTTFLabel({text = self.vo.name,
        size = 18,color = TextColor.TEXT_W})
            :align(display.CENTER,0,0)
            :addTo(self)
    self.titleLab:setPosition(0,0)
    --display.setLabelFilter(self.titleLab)
end

function MergeActivityListItem:setSelect(bool)
	if bool then
		self.bg:setVisible(false)
		self.selbg:setVisible(true)
	else
		self.bg:setVisible(true)
		self.selbg:setVisible(false)
	end
end

function MergeActivityListItem:getId()
	return self.vo.id
end

return MergeActivityListItem