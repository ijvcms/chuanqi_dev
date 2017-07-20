--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-08-19 20:18:44
--
local LoginSelRoleItem = class("LoginSelRoleItem", function()
	return display.newNode()
end)

function LoginSelRoleItem:ctor(pointList)
	self.posScale = 2
	self.nodeScale = 0.7

	self.pointList = pointList
	self:setScale(self.nodeScale)
	self:setAnchorPoint(0.5,0)
	self.width = 500
	self.height = 568

	-- self.rolePicbg = display.newSprite("common/login/login_roleBg.jpg")
	-- self.rolePicbg:setScale(568/269)
	-- self.rolePicbg:setOpacity(200)
	-- self.rolePicbg:setPosition(0,self.height/2)
	-- self:addChild(self.rolePicbg)

	self.defRole = display.newSprite(ResUtil.getLoginSexCarrerModel(-1,-1))
	self:addChild(self.defRole)
	self.defRole:setPosition(0,self.height/2)

	self.rolePic = display.newSprite()
	self.rolePic:setPosition(0,self.height/2)
	self:addChild(self.rolePic)

	self.txtCreatRole = display.newSprite("#login/login_clickcreatetxt.png")
	self:addChild(self.txtCreatRole)
	self.txtCreatRole:setPosition(0,self.height/2)


	self.careerBg = display.newSprite("#login/login_carrersbg.png")
	self:addChild(self.careerBg)
	self.careerBg:setPosition(-120,self.height-110)

	self.careerIcon = display.newSprite()
	self.careerBg:addChild(self.careerIcon)
	self.careerIcon:setPosition(27,56)

	self.namebg = display.newSprite("#login/login_nameLine1.png")
	self:addChild(self.namebg)
	self.namebg:setPosition(0,self.height-50)

	self.nameLabs = display.newTTFLabel({
        text = "",
        size = 22,
        color = cc.c3b(255, 255, 255)
    })
    --selectTips:setAnchorPoint(0,0)
    self.nameLabs:setPosition(105,27)
    self.namebg:addChild(self.nameLabs)


	self.name = ""
	self.career = 0
	self.lv = 0
	self.sex = 0
end


function LoginSelRoleItem:destory()    
    
end


function LoginSelRoleItem:setRoleVO(vo)
	self.vo = vo
	if vo then
		self.name = vo.name
		self.career = vo.career
		self.lv = vo.lv or 1
		self.sex = vo.sex
		self.playId = vo.player_id
		
		self.txtCreatRole:setVisible(false)
		self.defRole:setVisible(false)
		if self.name then
			self.nameLabs:setString("LV"..self.lv.."  "..self.name)
			self.namebg:setVisible(true)
		else
			self.namebg:setVisible(false)
		end
	
		local url = ResUtil.getLoginSexCarrerModel(vo.sex,vo.career)
		-- if self.skeletonNode then
		-- 	self.modeLay:removeChild(self.skeletonNode) 
		-- end
		-- self.skeletonNode = sp.SkeletonAnimation:create(url..".json",url..".atlas", 1)
  --   	self.modeLay:addChild(self.skeletonNode) 
  --   	self.skeletonNode:setPosition(0,0)
  --   	self.skeletonNode:setAnimation(0, "animation", true)
  --   --skeletonNode:addAnimation(0, "attack", true);

  --   --skeletonNode:setMix("attack", "shengli", 0.2);
  --   	self.skeletonNode:setDebugBonesEnabled(false)
  		self.rolePic:setTexture(url)
  		self.rolePic:setVisible(true)
		self.careerIcon:setSpriteFrame(ResUtil.getLoginCarrerIcon(vo.career))
		self.careerBg:setVisible(true)
	else
		self.namebg:setVisible(false)
		self.careerBg:setVisible(false)
		self.defRole:setVisible(true)
		self.txtCreatRole:setVisible(true)
		self.rolePic:setVisible(false)
		-- if self.skeletonNode then
		-- 	self.modeLay:removeChild(self.skeletonNode) 
		-- 	self.skeletonNode = nil
		-- end
	end
end


function LoginSelRoleItem:setIndex(index)
	self.index = index
	self:setPos(self.pointList[self.index][1]*self.posScale,self.pointList[self.index][2]*self.posScale)
end

function LoginSelRoleItem:update(offset)
	offset = math.max(offset,-398)
	offset = math.min(offset,398)
	self.index = self.index +offset
    if self.index > 399 then
        self.index = self.index - 399
    elseif self.index <= 0 then
    	self.index = 399 + self.index
    end
    self:setPos(self.pointList[self.index][1]*self.posScale,self.pointList[self.index][2]*self.posScale)
end


function LoginSelRoleItem:getIndex()
	return self.index
end

function LoginSelRoleItem:hitTestPos(p)
	local localp = self:convertToNodeSpace(p)
	if localp.y > 0 and localp.y < self.width and localp.x < self.height/2 and localp.x > 0-self.height/2 then
		return true
	end
	return false
end


function LoginSelRoleItem:setPos(xx,yy)
	local scale = ((20*self.posScale-yy)+50)/(20*self.posScale*2+50)
	self.rolePic:setOpacity(255*scale)
	self.defRole:setOpacity(255*scale)
	self:setScale(self.nodeScale*scale)
	self:setPosition(xx,yy)
	self:setLocalZOrder(2000-yy)
end

return LoginSelRoleItem