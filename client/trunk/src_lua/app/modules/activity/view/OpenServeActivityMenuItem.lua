--
-- Author: Yi hanneng
-- Date: 2016-08-23 15:49:27
--
local UIAsynListViewItem = import("app.gameui.listViewEx.UIAsynListViewItem")
local OpenServeActivityMenuItem = OpenServeActivityMenuItem or class("OpenServeActivityMenuItem", UIAsynListViewItem)

function OpenServeActivityMenuItem:ctor()

	self:init()
end

function OpenServeActivityMenuItem:init()

	self.bg = display.newSprite("#com_labBtn4.png")
	self.txt = display.newTTFLabel({
    text = "",
    size = 20,
    color = cc.c3b(255, 255, 255), -- 使用纯红色
    align = cc.TEXT_ALIGNMENT_LEFT,
    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    
	})
 
	self.bg:addChild(self.txt)
	self.txt:setPosition(self.bg:getContentSize().width/2,self.bg:getContentSize().height/2)
	
	self:addChild(self.bg)
	self:setContentSize(cc.size(self.bg:getContentSize().width,self.bg:getContentSize().height+10))
	self.bg:setPosition(self.bg:getContentSize().width/2,self.bg:getContentSize().height/2)

	self.headIcon = display.newSprite()
    self.bg:addChild(self.headIcon)
    self.headIcon:setTag(100)
    

end

function OpenServeActivityMenuItem:setData(data)
 
	self.data = data
	self.txt:setString(data.name)

	if data.state == 3 then
		self.headIcon:setVisible(false)
	else
		self.headIcon:setVisible(true)
		if data.state == 0 then
			self.headIcon:setSpriteFrame("serveActivity_coming.png")
		elseif data.state == 1 then
			self.headIcon:setSpriteFrame("serveActivity_active.png")
		elseif data.state == 2 then
			self.headIcon:setSpriteFrame("serveActivity_end.png")
		end

		self.headIcon:setPosition(self.headIcon:getContentSize().width/2 + 2, self:getContentSize().height - self.headIcon:getContentSize().height - 2)

	end

	-----红点提示
 
	if data.id == 1 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_RECHARGE,self.bg,162,36)
    elseif data.id == 2 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_STREN_ZK,self.bg,162,36)
    elseif data.id == 3 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_YBXH,self.bg,162,36)
      elseif data.id == 4 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_SMSDHK,self.bg,162,36)
      elseif data.id == 5 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_YJZK,self.bg,162,36)
      elseif data.id == 6 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_SMSDHK2,self.bg,162,36)
      elseif data.id == 7 then
      	local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_CYZZ,self.bg,162,36)
      elseif data.id == 8 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_LCJY,self.bg,162,36)
      elseif data.id == 9 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_BSS,self.bg,162,36)
    end
 
end

function OpenServeActivityMenuItem:getData()
	return self.data
end

function OpenServeActivityMenuItem:setSpriteFrame(frame)

	if frame == nil or self.bg == nil then
		return
	end

	self.bg:setSpriteFrame(frame)

end

return OpenServeActivityMenuItem