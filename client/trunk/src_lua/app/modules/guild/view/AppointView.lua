--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:16:41
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--
--更改职位界面
local AppointView = class("AppointView", function()
	return display.newNode()
end)

local APV_TEXT = {
	[1] = "会长",
	[2] = "副会长",
	[3] = "长老",
	[4] = "精英",
	[5] = "成员"
}

function AppointView:ctor(showButtonTable,data,isCorps)
	if not showButtonTable then return end
	self.isCorps = isCorps
	if isCorps then
		APV_TEXT[1] = "团长"
		APV_TEXT[2] = "副团长"
	end
	self.data = data
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:removeSelfSafety()
        end     
        return true
    end)
	--颜色层
	local maskbg = cc.LayerColor:create(cc.c4b(0,0,0,100))
	self:addChild(maskbg)
	--背景1
	local bg = display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(250,320),cc.rect(63, 49,1, 1))
	self:addChild(bg)
	bg:setPosition(display.width/2,display.height/2)
	--背景2
	local bg2 = display.newScale9Sprite("#com_viewBg2.png", 0, 0, cc.size(210,190))
	bg:addChild(bg2)
	bg2:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2)
	--标题
	local label = display.newTTFLabel({
	    	text = "更改职位",
	    	size = 22,
	    	color = TextColor.TEXT_O
		})
	label:setPosition(bg:getContentSize().width/2,bg:getContentSize().height-35)
	bg:addChild(label)
	display.setLabelFilter(label)
	--复选框
	self.tags = {}
	for i=1,#showButtonTable do
		local sp = display.newLayer()
		sp:setContentSize(210,40)
		sp:setPosition(20,205-(i-1)*40)
		local tagsp = display.newSprite("#com_radioBg.png")
		tagsp:setPosition(20,20)
		sp:addChild(tagsp)
		local selected = display.newSprite("#com_radioPic.png")
		sp:addChild(selected)
		selected:setPosition(20,20)
		selected:setVisible(false)
		selected:setTag(10)
		local label = display.newTTFLabel({
	    	text = APV_TEXT[showButtonTable[i]],
	    	size = 22,
	    	color = TextColor.TEXT_W
		})
		label:setPosition(55,20)
		label:setAnchorPoint(0,0.5)
		sp:addChild(label)
		display.setLabelFilter(label)
		bg:addChild(sp)

		if showButtonTable[i]==self.data.position then
			self.curTag = sp
			self.curPosition = showButtonTable[i]
			selected:setVisible(true)
		end

		sp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            if self.curTag then
	            	self.curTag:getChildByTag(10):setVisible(false)
	            end
	            self.curTag = sp
	            self.curPosition = showButtonTable[i]
	            sp:getChildByTag(10):setVisible(true)
	        end     
	        return true
	    end)
	end

	--确定按钮
	local btnSure = display.newSprite("#com_labBtn1.png")
	btnSure:setTouchEnabled(true)
    btnSure:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnSure:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnSure:setScale(1.0)
            self:onSureClick()
        end     
        return true
    end)
    btnSure:setPosition(bg:getContentSize().width/2,35)
    local label = display.newTTFLabel({
    	text = "确定",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	label:setPosition(btnSure:getContentSize().width/2,btnSure:getContentSize().height/2)
	btnSure:addChild(label)
	display.setLabelFilter(label)
	bg:addChild(btnSure) 
	--关闭按钮
	local btnClose = display.newSprite("#com_closeBtn1.png")
	btnClose:setTouchEnabled(true)
    btnClose:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnClose:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnClose:setScale(1.0)
            self:removeSelfSafety()
        end     
        return true
    end)
    btnClose:setPosition(bg:getContentSize().width-30,bg:getContentSize().height-30)
    bg:addChild(btnClose)
end

function AppointView:onSureClick(position)
	local proto = 17019
	if self.isCorps then
		proto = 37019
	end
	GameNet:sendMsgToSocket(proto, {player_id = self.data.player_id, position = self.curPosition})
	self:removeSelfSafety()
end

return AppointView