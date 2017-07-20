--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-26 16:47:27
-- 创建角色
--
local LoginCreatRoleItem = class("LoginCreatRoleItem", function()
	return display.newNode()
end)

function LoginCreatRoleItem:ctor(pointList)
	self.width = 500
	self.height = 568
	self.posScale = 3
	self.nodeScale = 0.8
	self.pointList = pointList
	self:setScale(self.nodeScale)
	self:setAnchorPoint(0.5,0)

	-- self.rolePicbg = display.newSprite("common/login/login_roleBg.jpg")
	-- self.rolePicbg:setScale(568/269)
	-- --self.rolePicbg:setContentSize(500,568)--269
	-- self.rolePicbg:setOpacity(200)
	-- self.rolePicbg:setPosition(0,self.height/2)
	-- self:addChild(self.rolePicbg)

	self.rolePic = display.newSprite()
	self.rolePic:setPosition(0,self.height/2)
	self:addChild(self.rolePic)

	self.careerBg = display.newSprite("#login/login_carrersbg.png")
	self:addChild(self.careerBg)
	self.careerBg:setPosition(-120,self.height-110)

	self.careerIcon = display.newSprite()
	self.careerBg:addChild(self.careerIcon)
	self.careerIcon:setPosition(27,56)
end


function LoginCreatRoleItem:destory()    

end


function LoginCreatRoleItem:setRoleVO(vo)
	if vo then
		self.vo = vo
		self.name = vo.name
		self.career = vo.career
		self.lv = vo.lv or 1
		self.sex = vo.sex
	
		local url = ResUtil.getLoginSexCarrerModel(vo.sex,vo.career)
		-- if self.skeletonNode then
		-- 	self:removeChild(self.skeletonNode)
		-- end
		-- self.skeletonNode = sp.SkeletonAnimation:create(url..".json",url..".atlas", 1)
  		--   	self:addChild(self.skeletonNode) 
  		--   	self.skeletonNode:setPosition(0,0)
  		--   	self.skeletonNode:setAnimation(0, "animation", true)
    	--skeletonNode:addAnimation(0, "attack", true);
    	--skeletonNode:setMix("attack", "shengli", 0.2);
    	--self.skeletonNode:setDebugBonesEnabled(false)
    	self.rolePic:setTexture(url)
  		--self.rolePic:setVisible(true)
		self.careerIcon:setSpriteFrame(ResUtil.getLoginCarrerIcon(vo.career))
		--self.careerBg:setVisible(true)
	end
end

function LoginCreatRoleItem:showGuangHuang(bool)
	if self.rolePic then
		if bool then
			self.rolePic:setColor(display.COLOR_WHITE)
			self.rolePic:setOpacity(255)
		else
			self.rolePic:setColor(cc.c3b(99,99, 99))
			self.rolePic:setOpacity(200)
		end
	end
end


function LoginCreatRoleItem:setIndex(index)
	self.index = index
	self:setPos(self.pointList[self.index][1]*self.posScale,self.pointList[self.index][2]*self.posScale)
end

function LoginCreatRoleItem:update(offset)
	offset = math.max(offset,-248)
	offset = math.min(offset,248)
	self.index = self.index +offset
    if self.index > 249 then
        self.index = self.index - 249
    elseif self.index <= 0 then
    	self.index = 249 + self.index
    end
    self:setPos(self.pointList[self.index][1]*self.posScale,self.pointList[self.index][2]*self.posScale)
end


function LoginCreatRoleItem:getIndex()
	return self.index
end

function LoginCreatRoleItem:hitTestPos(p)
	local localp = self:convertToNodeSpace(p)
	if localp.y > 0 and localp.y < self.width and localp.x < self.height/2 and localp.x > 0-self.height/2 then
		return true
	end
	return false
end

function LoginCreatRoleItem:setPos(xx,yy)
	local scale = ((20*self.posScale-yy)+80)/(20*self.posScale*2+80)
	self:setScale(self.nodeScale*scale)
	self:setPosition(xx,yy)
	self:setLocalZOrder(2000-yy)
end

return LoginCreatRoleItem
