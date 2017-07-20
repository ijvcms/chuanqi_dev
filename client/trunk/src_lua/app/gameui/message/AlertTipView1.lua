--
-- Author: zhangshunqiu
-- Date: 2015-02-04 09:20:06
-- 弹窗提示界面，显示标题，内容文字和一张图片，还有一个确定按钮
--data = {title = "标题",tipText ="内容", image = "res/publicUI/Button01.png",backFun = backFun}
--用法：
--GlobalMessage:alertTips({title = "标题",tipText ="内容", image = "res/publicUI/Button01.png",backFun = handler(self,self.backFun)})

local AlertTipView1 = class("AlertTipView1", function()
	return display.newNode()
end)

function AlertTipView1:ctor(data)	
	self.curWidth = 400
	self:open(data)
end	

--打开界面
function AlertTipView1:open(data)
	local titleText = data.titleText or "提示"
	local tipText = data.tipText
	local image = data.image
	local btnText = data.btnText or "确  认"

	self.backFun = data.backFun

	if self.bg == nil then
		self.bg = display.newColorLayer(
	            cc.c4b(255,
	                255,
	                255,
	                10))
	    self.bg:setContentSize(display.width, display.height)
	    self.bg:setTouchEnabled(true)
	    self:addChild(self.bg)
	end

	self.contentLay =  display.newLayer()
	self.contentLay:setPosition(display.cx,display.cy)
	self:addChild(self.contentLay)

	self.bgPic = display.newScale9Sprite("res/publicUI/bj_game_highlighted@2x.png")
    self.bgPic:setContentSize(self.curWidth, 500)
    self.bgPic:pos(0, 0)
    self.bgPic:addTo(self.contentLay)
    --self.bgPic:setOpacity(180)
    self.bgPic:setTouchEnabled(false)

	self.titleLab = display.newTTFLabel({
    		text = titleText,
    		-- font = "Arial",
    		size = 34,
    		color = cc.c3b(0, 0, 0), -- 使用纯红色
    		-- align = cc.TEXT_ALIGNMENT_LEFT,
    		-- valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    		-- dimensions = cc.size(400, 200)
	})		
	self.titleLab:setAnchorPoint(0.5,0.5)
 	self.titleLab:setPosition(0, 0)
	-- self:setPosition(300,300)
	self.contentLay:addChild(self.titleLab)
	self.titleLab:setTouchEnabled(false)
	if tipText and tipText ~= "" then
		self.txtLab = display.newTTFLabel({
    		text = "    "..tipText,
    		-- font = "Arial",
    		size = 30,
    		color = cc.c3b(0, 0, 0), -- 使用纯红色
    		-- align = cc.TEXT_ALIGNMENT_LEFT,
    		-- valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    		-- dimensions = cc.size(400, 200)
		})	
		self.txtLab:setWidth(self.curWidth - 30)
		-- self:setPosition(300,300)
		self.contentLay:addChild(self.txtLab)
		self.txtLab:setTouchEnabled(false)
	end
		
	if image and image ~= "" then
		self.imgSprite = display.newSprite(image)
		self.contentLay:addChild(self.imgSprite)
    	self.imgSprite:setTouchEnabled(false)
	end

	local enterBtn = cc.ui.UIPushButton.new({
        normal = "res/publicUI/Button01.png",
        pressed = "res/publicUI/Button01.png",
        disabled = "res/publicUI/Button01.png"
        }, {scale9 = true})
        :setButtonSize(200, 60)
        :setButtonLabel(cc.ui.UILabel.new({
            text = btnText
            }))
        :onButtonClicked(handler(self, self.onEnterClick))
        :align(display.CENTER, 0, 0)
        :addTo(self.contentLay)

	local titleLabSize = self.titleLab:getContentSize()--titleLabSize.height,titleLabSize.width

	local txtLabSize = {height = 0}
	if self.txtLab then
		txtLabSize = self.txtLab:getContentSize()
	end

	local imgSpriteSize = {height = 0}
	if self.imgSprite then
		imgSpriteSize = self.imgSprite:getContentSize()
	end	

	local totalHeight = titleLabSize.height + txtLabSize.height + imgSpriteSize.height + 150
	self.bgPic:setContentSize(self.curWidth, totalHeight)

	self.titleLab:setPositionY(totalHeight/2 - titleLabSize.height - 10 )
	if self.txtLab then
		self.txtLab:setPositionY(totalHeight/2 - titleLabSize.height - 10  - txtLabSize.height -10)
	end
	if self.imgSprite then
		self.imgSprite:setPositionY(totalHeight/2 - titleLabSize.height - 10  - txtLabSize.height -10 - imgSpriteSize.height -10)
	end
	if enterBtn then
		enterBtn:setPositionY(totalHeight/2 - totalHeight + 40)
		--enterBtn:setColor(cc.c3b(255, 0, 0))
	end

	self.contentLay:setPosition(display.cx,0-display.cy)
	transition.moveTo(self.contentLay, {x = display.cx, y = display.cy, time = 0.3})
end

function AlertTipView1:onEnterClick()	
	if self.backFun ~= nil then
		self.backFun()
	end
	local sequence = transition.sequence({
    cc.MoveTo:create(0.3, cc.p(display.cx, 0-display.cy+50)),
    cc.CallFunc:create(self.close),
	})
	self.contentLay:runAction(sequence)
end

--关闭界面
function AlertTipView1:close()
	local parent = self:getParent()
	if parent ~= nil then
		parent:removeChild(self)
	end
end

--清理界面
function AlertTipView1:destory()

end

return AlertTipView1