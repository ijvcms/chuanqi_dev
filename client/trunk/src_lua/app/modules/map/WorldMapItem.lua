--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-02-22 11:38:49
--

--
-- 世界地图上面的地点项目。
--
local WorldMapItem = class("WorldMapItem", display.newNode)

function WorldMapItem:ctor()
	self:initialization()
end

function WorldMapItem:initialization()
	self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.onClick))

    self.img_icon = display.newSprite()
    	:addTo(self)
    self.txtBgY = 36
    self.bg = display.newSprite("#wm_txtBg.png")
    self:addChild(self.bg)
    self.bg:setPosition(0,self.txtBgY)
    self.lbl_placeName = display.newTTFLabel({text = "", size = 18})
	    :align(display.CENTER,0,0)
	    :addTo(self)
	    :pos(0, self.txtBgY)
	display.setLabelFilter(self.lbl_placeName)
	self.lbl_placeLv = display.newTTFLabel({text = "", size = 14})
	    :align(display.CENTER,0,0)
	    :addTo(self)
	    :pos(0, 10)
	display.setLabelFilter(self.lbl_placeLv)
end

function WorldMapItem:onClick(event)
	if event.name == "began" then
        SoundManager:playClickSound()
        self.img_icon:setScale(1.1)
    elseif event.name == "ended" then
        self.img_icon:setScale(1)
        if self._handler then--and self.img_icon:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y))
        	self._handler(self)
        end
    end     
    return true
end

function WorldMapItem:setOnClickHandler(handler)
	self._handler = handler
end

function WorldMapItem:getData() return self._data end
function WorldMapItem:setData(data)
	self._data = data
	self:invalidateData()
end

function WorldMapItem:invalidateData()
	local data = self._data
	if not data then return end

	self:setPosition(data.icon_x, data.icon_y)
	self.img_icon:setSpriteFrame(string.format("%s.png", data.icon))
	self.lbl_placeName:setString(data.name)
	self.lbl_placeName:setColor(DisplayUtil.convertToCCC3(data.name_color))


	if data.lv_label and data.lv_label ~= "" then
		self.bg:setScaleY(1)
		self.lbl_placeLv:setString(data.lv_label)
		self.lbl_placeLv:setColor(DisplayUtil.convertToCCC3(data.lv_color))
		self.lbl_placeName:setPosition(0,self.txtBgY +8)
		self.lbl_placeLv:setPosition(0,self.txtBgY -8)
	else
		self.lbl_placeLv:setVisible(false)
		self.bg:setScaleY(0.7)
	end
end

return WorldMapItem