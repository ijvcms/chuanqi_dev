--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-03-04 11:44:50
-- 图片按钮

local SpriteButton = class("SpriteButton", function()
	return display.newNode() --cc.Sprite:create() -- 
end)


function SpriteButton.create(btnImage,bgImage,width,height,setScale)
	return SpriteButton.new(btnImage,bgImage,width,height,setScale)
end

function SpriteButton:ctor(btnImage,bgImage,width,height,setScale)	
	if setScale == nil then
		setScale = true
	end 
	self:setTouchSwallowEnabled(true)
	self:setTouchEnabled(true)
	if bgImage and bgImage ~= "" then		
		if width == nil or height == nil then
			self.btnBg = display.newScale9Sprite(bgImage)
		else
			self.btnBg = display.newScale9Sprite(bgImage, 0, 0, cc.size(width, height))
		end			
		self:addChild(self.btnBg)
	end	
	if btnImage and btnImage ~= "" then
		local size = self:getContentSize()
		self.btnPic = display.newSprite(btnImage)
    	self:addChild(self.btnPic)
    	self.btnPic:setTouchEnabled(false)
    	self.btnPic:setPosition(size.width/2,size.height/2)
	end	  
	if setScale then
		self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)		
	        if event.name == "began" then
	        	self:setScale(1.1)
	        elseif event.name == "ended" then
	        	self:setScale(1)
	        end       			
	        return true
	    end)
	end
end	

--缩放动作
--@param scale 缩放大小
--@param time 时间（秒）
function SpriteButton:scaleTo(time,scale)
	scale = scale or 1.2
	time = time or 0.05
	transition.scaleTo(self, {scale = scale, time = time})
end	

--闪耀
--@param time 时间（秒）
--@param timers 次数
function SpriteButton:blink(time,timers)
	time = time or 0.15
	timers = timers or 2
	local action1 = cc.Blink:create(time,timers)
    local action2 = cc.CallFunc:create(function(event)            
            self:setVisible(true)  
            end)
    local action3 = transition.sequence({
          action1,
          action2,
      })
    self:runAction(action3)
end	

function SpriteButton:setColor(color)
	if self.btnBg then
		self.btnBg:setColor(color)
	end
	if self.btnPic then
		self.btnPic:setColor(color)
	end	
end

function SpriteButton:setBgColor(color)
	if self.btnBg then
		self.btnBg:setColor(color)
	end	
end
function SpriteButton:setTxtColor(color)
	if self.btnPic then
		self.btnPic:setColor(color)
	end	
end

function SpriteButton:setOpacity(value)
	if self.btnBg then
		self.btnBg:setOpacity(value)
	end
	if self.btnPic then
		self.btnPic:setOpacity(value)
	end	
end

-- function SpriteButton:runAction(action)
-- 	if self.btnBg then
-- 		self.btnBg:setOpacity(value)
-- 	end
-- 	if self.btnPic then
-- 		self.btnPic:setOpacity(value)
-- 	end	
-- end

return SpriteButton