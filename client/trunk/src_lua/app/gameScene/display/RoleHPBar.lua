local RoleHPBar = class("RoleHPBar",function()
	return display.newNode();
end)

function RoleHPBar:ctor(vo,ww)
	local kHpBarWidth = 62
	self.scaleParam = vo.scaleParam or 1 --总体缩放z
	self.bodySize = cc.p(50*self.scaleParam,100*self.scaleParam)
	local hpBarBg = display.newSprite("#scene/scene_mbloodBg.png")
    local bgW = ww or kHpBarWidth
    hpBarBg:setContentSize(bgW, 8)
    local rect = hpBarBg:getTextureRect()
    hpBarBg:setScale(bgW / rect.width, 8 / rect.height)
    --self:addChild(node)
    hpBarBg:addTo(self)
    hpBarBg:setAnchorPoint(0,0.5)
    hpBarBg:setPosition(-bgW / 2, 4)
    self.hpBarBg = hpBarBg

    self.hpBarPic =  display.newSprite("#scene/scene_mbloodHp.png")
    rect = self.hpBarPic:getTextureRect()
    self.hpScale =(kHpBarWidth-2) / rect.width
    self.hpBarPic:setScale(self.hpScale, 6 / rect.height)
    self.hpBarPic:setAnchorPoint(0,0)
    self.hpBarPic:addTo(self)
    self.hpBarPic:setPosition(hpBarBg:getPositionX() + 1,1)
end

function RoleHPBar:updateRolePosition(xx,yy)
	self:setLocalZOrder(RoleLayerArr.kHpContainerLayerId-yy)
	self:setPosition(xx,(self.bodySize.y+10+yy))--*self.scaleParam)
end

function RoleHPBar:updateHp(curHp,totalHp)
	self.hpBarPic:setScaleX(curHp /totalHp * self.hpScale)
end

return RoleHPBar