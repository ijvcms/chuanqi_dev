--人物内观

local InnerModelView = class("InnerModelView", function ()
	return display.newNode()
end)

local IMTAG_BODY 		= 1
local IMTAG_WEAPON 		= 2
local IMTAG_HAT  		= 3
local IMTAG_WING 		= 4
local IMTAG_FOOTEFFECT	= 5
local IMTAG_BODYEFFECT 	= 6
local IMTAG_HANDEFFECT 	= 7

local ZORDER_WING		= 0		
local ZORDER_BODY  		= 5
local ZORDER_WEAPON 	= 10

--构造与初始化
function InnerModelView:ctor()	
	self.nBody 				= nil; 				--身体内观id              		
	self.nSex  				= nil;				--性别id							
	self.nWeapon 			= nil;				--武器内观id						
	self.nHat 				= nil;				--发型内观id						
	self.nWing 				= nil; 				--翅膀内观id					
	self.nFootEffectID 		= nil;				--脚部特效id				
	self.nBodyEffectID 		= nil;				--身体特效id
	self.nHandEffectID 		= nil;				--手部特效id			

 	--self.pBody 				= nil;			 	--身体精灵
 	--self.pWeapon 			= nil;			 	--武器精灵
	--self.pWing 				= nil;	 			--翅膀精灵		
	self.pHat 				= nil;				--发型精灵				
	self.pFootEffect 		= nil;				--脚部特效
	self.pBodyEffect  		= nil;				--身体特效
	self.pHandEffect 		= nil;				--手部特效
 
	self:setAnchorPoint(0.5,0.5)

	self.pBody = display.newSprite()
	self.pBody:setAnchorPoint(0.5,0.5) 
	self.pBody:addTo(self, ZORDER_BODY, IMTAG_BODY)
 
	self.pWeapon = display.newSprite()
	self.pWeapon:setAnchorPoint(0.5,0.5)
	self.pWeapon:addTo(self, ZORDER_WEAPON, IMTAG_WEAPON)
 
	self.pWing = display.newSprite()
	self.pWing:setAnchorPoint(0.5,0.5)
	self.pWing:setPosition(0, 0)
	self.pWing:addTo(self, ZORDER_WING, IMTAG_WING)
 
end

--设置身体
function InnerModelView:setBodyId(bodyId)
	--[[
	if self.pBody then
		self:removeChildByTag(IMTAG_BODY)
	end
	--]]
	if not self.nSex then return end
	if not bodyId then return end
	if self.nBody == bodyId then return end
	self.nBody = bodyId
	--判断这个id有多少位
	local temp = bodyId
	local b = 1
	while math.floor(temp/10)>0 do
		temp = temp / 10
		b = b + 1
	end
	if self.nSex == 1 then 			--男
		bodyId = 10^b+bodyId
	elseif self.nSex == 2 then 		--女
		bodyId = (10^b)*2+bodyId
	end
	
	local Img = "pic/body/"..bodyId..".png"
	--[[
	local fileUtil = cc.FileUtils:getInstance()
	if not fileUtil:isFileExist(Img) then return end
	self.pBody = display.newSprite(Img)
	self.pBody:setAnchorPoint(0.5,0.5) 
	self.pBody:addTo(self, ZORDER_BODY, IMTAG_BODY)
	--]]
	local fileUtil = cc.FileUtils:getInstance()
    if fileUtil:isFileExist(Img) then
        display.addImageAsync(Img, function()
            if self.pBody then
                self.pBody:setTexture(Img)
            end
        end)
    else
        self.pBody:setTexture("common/input_opacity1Bg.png")
    end
end

--设置性别
function InnerModelView:setSex(sex)
	if not sex then return end
	self.nSex = sex
end

--设置武器
function InnerModelView:setWeaponId(weaponId)
	--[[
	if self.pWeapon then
		self:removeChildByTag(IMTAG_WEAPON)
	end
	--]]
	if not self.nSex then return end
	if not weaponId then return end
	if self.nWeapon == weaponId then return end

	self.nWeapon = weaponId
	--判断这个id有多少位
	local temp = weaponId
	local b = 1
	while math.floor(temp/10)>0 do
		temp = temp / 10
		b = b + 1
	end

	--男女的武器内观是同样的，固定为男的就好
	 if self.nSex == 1 then 			--男
		weaponId = (10^b)*3+weaponId
	elseif self.nSex == 2 then 		--女
	 	weaponId = (10^b)*4+weaponId
	end
	
	local Img = "pic/weapon/"..weaponId..".png"
	
	--[[
	local fileUtil = cc.FileUtils:getInstance()
	if not fileUtil:isFileExist(Img) then return end
	self.pWeapon = display.newSprite(Img)
	self.pWeapon:setAnchorPoint(0.5,0.5)
	self.pWeapon:addTo(self, ZORDER_WEAPON, IMTAG_WEAPON)
	--]]
	
	local fileUtil = cc.FileUtils:getInstance()
    if fileUtil:isFileExist(Img) then
        display.addImageAsync(Img, function()
            if self.pWeapon then
                self.pWeapon:setTexture(Img)
            end
        end)
         
    else
        self.pWeapon:setTexture("common/input_opacity1Bg.png")
    end
	--]]
end

-- --设置发型
-- function InnerModelView:setHatId(hatId)
-- 	if not hatId then return end
-- 	self.nHat = hatId
-- 	if self:getParent() and self:getParent():getChildByTag(IMTAG_HAT) then
-- 		self.pHat:removeFromParentAndCleanup(true)
-- 	end
-- 	local Img = "innerModel/innerHat/"..hatId..".png"
-- 	local fileUtil = cc.FileUtils:getInstance()
-- 	if not fileUtil:isFileExist(Img) then return end
-- 	self.pHat = display.newSprite(Img):setAnchorPoint(0.5,0):addTo(self, 0, IMTAG_HAT)
-- end

--设置翅膀
function InnerModelView:setWingId(wingId)
	--[[
	if self.pWing then
		self:removeChildByTag(IMTAG_WING)
	end
	--]]
	-- if not self.nSex then return end
	if not wingId then return end
	if self.nWing == wingId then return end

	self.nWing = wingId
	
	local Img = "pic/wing/"..wingId..".png"
	
	--[[
	local fileUtil = cc.FileUtils:getInstance()
	if not fileUtil:isFileExist(Img) then return end
	self.pWing = display.newSprite(Img)
	self.pWing:setAnchorPoint(0.5,0.5)
	self.pWing:setPosition(0, 65)
	self.pWing:addTo(self, ZORDER_WING, IMTAG_WING)
	--]]
	
	local fileUtil = cc.FileUtils:getInstance()
    if fileUtil:isFileExist(Img) then
        display.addImageAsync(Img, function()
            if self.pWing then
                self.pWing:setTexture(Img)
            end
        end)
         
    else
        self.pWing:setTexture("common/input_opacity1Bg.png")
    end
	
end

-- --设置脚部特效
-- function InnerModelView:setFootEffectId(footEffectId)
-- 	if not footEffectId then return end
-- 	self.nFootEffectID = footEffectId
-- 	if self:getParent() and self:getParent():getChildByTag(IMTAG_FOOTEFFECT) then
-- 		self.pFootEffect:removeFromParentAndCleanup(true)
-- 	end
-- 	local Img = "innerModel/innerFootEffect/"..footEffectId..".png"
-- 	local fileUtil = cc.FileUtils:getInstance()
-- 	if not fileUtil:isFileExist(Img) then return end
-- 	self.pFootEffect = display.newSprite(Img):setAnchorPoint(0.5,0):addTo(self, 0, IMTAG_FOOTEFFECT)
-- end

-- --设置身体特效
-- function InnerModelView:setBodyEffectId(EffectId)
-- 	if not EffectId then return end
-- 	self.nBodyEffectID = EffectId
-- 	if self:getParent() and self:getParent():getChildByTag(IMTAG_BODYEFFECT) then
-- 		self.pBodyEffect:removeFromParentAndCleanup(true)
-- 	end
-- 	local Img = "innerModel/innerBodyEffect/"..EffectId..".png"
-- 	local fileUtil = cc.FileUtils:getInstance()
-- 	if not fileUtil:isFileExist(Img) then return end
-- 	self.pBodyEffect = display.newSprite(Img):setAnchorPoint(0.5,0):addTo(self, 0, IMTAG_BODYEFFECT)
-- end

-- --设置手部特效
-- function InnerModelView:setHandEffectId(EffectId)
-- 	if not EffectId then return end
-- 	self.nHandEffectID = EffectId
-- 	if self:getParent() and self:getParent():getChildByTag(IMTAG_HANDEFFECT) then
-- 		self.pHandEffect:removeFromParentAndCleanup(true)
-- 	end
-- 	local Img = "innerModel/innerHandEffect/"..EffectId..".png"
-- 	local fileUtil = cc.FileUtils:getInstance()
-- 	if not fileUtil:isFileExist(Img) then return end
-- 	self.pHandEffect = display.newSprite(Img):setAnchorPoint(0.5,0):addTo(self, 0, IMTAG_HANDEFFECT)
-- end

-- --开始播放动画
-- function InnerModelView:play( )
-- 	-- body
-- end

-- --停止播放动画
-- function InnerModelView:stop( )
-- 	-- body
-- end

return InnerModelView