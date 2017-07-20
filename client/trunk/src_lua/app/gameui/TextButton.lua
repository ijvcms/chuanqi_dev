--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-03-24 09:42:15
-- 文本按钮
TextButton = class("TextButton", function()
	return display.newNode() 
end)


function TextButton.create(param)
	return TextButton.new(param)
end

function TextButton:ctor(param)
	
	self.text = param.text
	self.image = param.image or "#com_labBtn1.png"
	self.disableImage = param.disableImage or "#com_labBtn1Dis.png"
	self.fontSize = param.fontSize or 20
	self.width = param.width or 140
	self.height = param.height or 44
	self.color = param.color or TextColor.BTN_W
	self.scale9 = param.scale9 or true
	self.isEnable = true

	--self:setTouchSwallowEnabled(true)
	self:setTouchEnabled(true)
	self.btnImage = self:creatImage(self.image,1)
	self:creatText(self.text)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)		
        if event.name == "began" then
        	self:setScale(1.1)
        elseif event.name == "ended" then
        	SoundManager:playClickSound()
        	self:setScale(1)
        end       			
        return true
    end)
end	

--添加图片
function TextButton:creatImage(adressUrl,index)
	if adressUrl and adressUrl ~= "" then
		local sprite
		if self.width then
			if self.width == nil or self.height == nil then
				sprite = display.newScale9Sprite(adressUrl)
			else
				sprite = display.newScale9Sprite(adressUrl, 0, 0, cc.size(self.width, self.height))
			end
		else
			sprite = display.newSprite(adressUrl)	
		end
		if index then
			self:addChild(sprite,index)	
		else
			self:addChild(sprite)
		end
		return sprite
	end
	return nil
end
--添加文本
function TextButton:creatText(text)
	if text and text ~= "" then
		self.textLab = display.newTTFLabel({
    	  	text = text,    	
    	  	size = self.fontSize,
    	  	color = self.color,  
    	  	-- align = cc.TEXT_ALIGNMENT_LEFT,    	
    	  	-- dimensions = cc.size(600, 60)
	  	})
    	self:addChild(self.textLab,3)
    	self.textLab:setTouchEnabled(false)
    	--self.textLab:setPosition(self.width/2,self.height/2)
    else
    	if self.textLab then
    		self:removeChild(self.textLab)
    		self.textLab = nil
    	end
	end
end


--设置按钮文本
function TextButton:setBtnText(str)
	self.text = str
	if str == "" or str == nil then
		if self.textLab then
			self:removeChild(self.textLab)
    		self.textLab = nil
		end
	else
		if self.textLab then
			self.textLab:setString(str)
		else
			self:creatText(self.text)
		end
	end	
end

--设置是否可用
function TextButton:setBtnEnable(bool)
	self.isEnable = bool
	if self.isEnable then
		if self.btnImage then
			self.btnImage:setVisible(true)
		end
		if self.btnDisableImage then
			self.btnDisableImage:setVisible(false)
		end
		self:setTextColor(self.color)
		self:setTouchEnabled(true)
	else
		if self.btnImage then
			self.btnImage:setVisible(false)
		end
		if self.btnDisableImage then
			self.btnDisableImage:setVisible(true)
		else
			self.btnDisableImage = self:creatImage(self.disableImage,2)
		end
		self:setTextColor(TextColor.TEXT_GRAY)
		self:setTouchEnabled(false)
	end
end

--设置文本颜色
function TextButton:setTextColor(color)
	self.color = color
	if self.textLab then
		self.textLab:setColor(color)
	end	
end

--设置透明度
function TextButton:setOpacity(value)
	if self.btnImage then
		self.btnImage:setOpacity(value)
	end
	if self.btnDisableImage then
		self.btnDisableImage:setOpacity(value)
	end
	if self.textLab then
		self.textLab:setOpacity(value)
	end	
end




--缩放动作
--@param scale 缩放大小
--@param time 时间（秒）
function TextButton:setBtnScale(scale)
	self:setScale(scale)
end	

--闪耀
--@param time 时间（秒）
--@param timers 次数
function TextButton:blink(time,timers)
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


-- function SpriteButton:runAction(action)
-- 	if self.btnBg then
-- 		self.btnBg:setOpacity(value)
-- 	end
-- 	if self.text then
-- 		self.text:setOpacity(value)
-- 	end	
-- end