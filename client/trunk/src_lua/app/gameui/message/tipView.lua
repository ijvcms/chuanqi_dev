local tipView = class("tipView", function ()
	return cc.Sprite:create()
end)

function tipView:ctor()	
	self:init()
end

function tipView:init()

end

function tipView:moveIn(panel,beginScale,endScale,completeFun,time)	
	time = time or 0.3
	beginScale = beginScale or 0.2
	endScale = endScale or 1
	panel:setScale(beginScale)
	local spawn = cc.Spawn:create({
		cc.ScaleTo:create(time, endScale),
		-- cc.MoveTo:create(time, cc.p(50, 50))
	})

	local cureasing = "BACKOUT" 
	if endScale < beginScale then
		cureasing = "BACKIN"
	end
	transition.execute(panel, spawn, {
		time = time,
		easing = cureasing,--{"ELASTICOUT",0.5},--"BACKIN"
		onComplete = function()
			if completeFun then
				completeFun()
			end	
		end
		})
end	

function tipView:setFun(font,p)
	self.black = display.newColorLayer(cc.c4b(0, 0, 0, 70))
	-- black:setAnchorPoint(0.5,0.5)
	self.black:setPosition(-display.width/2,-display.height/2)
	self:addChild(self.black)


	self.content = display.newNode()
	self:addChild(self.content)
	--self.content:setAnchorPoint(0,0)
	local tipBg = display.newScale9Sprite("res/ui/images/grid_3_bg.png")
	--tipBg:setAnchorPoint(0,0)
	tipBg:setContentSize(cc.size(400,300))
	self.content:addChild(tipBg)

	local tipTitle = cc.ui.UILabel.new({
		UILabelType = 2,
		text = "提示框",
		size = 30,
		color = display.COLOR_WHITE
		})
	tipTitle:align(display.CENTER)
	tipTitle:setPosition(0,150 - 30)
	self.content:addChild(tipTitle)

	local label = cc.ui.UILabel.new({
		UILabelType = 2,
		text = font,
		color = display.COLOR_WHITE
		})
	label:align(display.TOP_LEFT)
	label:setPosition(-180,85)
	label:setWidth(360)
	self.content:addChild(label)

	local okBtnFun = function(evt)
		tipView.closeView(self)
	end

	if p == nil then
        p = function()
        	self:closeView()
    	end
    end
    
	local okBtn = cc.ui.UIPushButton.new("btn_green_bg2.png", {scale9 = true})
    okBtn:addButtonPressedEventListener(handler(self, p))
    okBtn:onButtonRelease(okBtnFun)
    okBtn:setButtonSize(124, 50)
    okBtn:setButtonLabel(cc.ui.UILabel.new({text = "确定", size = 20,color = display.COLOR_WHITE}))
    -- okBtn:align(display.BOTTOM_LEFT,-123+25,-90)
    okBtn:setPosition(-90,-100)
    okBtn:addTo(self.content)

    local cancelBtn = cc.ui.UIPushButton.new("btn_green_bg2.png", {scale9 = true})
    cancelBtn:onButtonClicked(handler(self, self.closeView))
    cancelBtn:setButtonLabel(cc.ui.UILabel.new({text = "取消", size = 20,color = display.COLOR_WHITE}))
    cancelBtn:setButtonSize(124, 50)
    -- cancelBtn:align(display.BOTTOM_LEFT,25,-90)
    cancelBtn:setPosition(90,-100)
    cancelBtn:addTo(self.content)

    -- self.fff = "FFFFF"
 --    local closeFun = function(evt)
	-- 	print(self.fff )
	-- end

    self:moveIn(self.content,0.2,1)
end

function tipView:closeView()	
	local closeFun = function(evt)
		local viewParent = self:getParent()
		if viewParent~= nil then
			viewParent:removeChild(self)
		end
	end
	self:removeChild(self.black)
	self:moveIn(self.content,1,0.7,closeFun,0.1)
end

function tipView:initWithSprite(p)
 --    self:setTouchSwallowEnabled(false) --下层响应

	-- self.sprite = display.newSprite(p.image,0,0,{class=cc.FilteredSpriteWithOne})
 --    -- self.sprite:setTouchSwallowEnabled(false)
	-- self.sprite:addTo(self)

 --    local cs = self.sprite:getContentSize()

 --    local labe = display.newBMFontLabel({
 --    text = p.label,
 --    font = "fieldBitmap.fnt",
 --    })
 --    labe:setPosition(cs.width/2,labe:getContentSize().height)

 --    self.sprite:addChild(labe)
end

return tipView