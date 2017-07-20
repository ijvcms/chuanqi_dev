--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-02-27 11:15:23
-- 红点提示按钮基类
BaseTipsBtn = class("BaseTipsBtn", function()
	return display.newNode()
end)

function BaseTipsBtn:ctor(btnTipskey,parent,xx,yy)
	xx = xx or 22
	yy = yy or 22
	self:setPosition(xx,yy)
	self.btnTipskey = btnTipskey
	BtnTipManager:setKeyBtn(btnTipskey,self)
	parent:addChild(self)
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
	local num = BtnTipManager:getKeyValue(self.btnTipskey)
	if num > 0 then
		self:showClickTip(num)
	else
		self:closeClickTip()
	end
end

function BaseTipsBtn:onNodeEvent(data)
    if data.name == "enterTransitionFinish" then
        -- self:registerEvent()
    elseif data.name == "exit" then
    	self:close()
        -- if self:getParent() then
        -- 	self:getParent():removeChild(self)
        -- end
    end

end

function BaseTipsBtn:showClickTip(num)
	if self.redBg == nil then
		self.redBg = display.newSprite("#scene/scene_redPointPic.png")
	    self:addChild(self.redBg)
	    self.redBg:setTouchEnabled(false)
	    -- self.redBg:setPosition(xx,yy)
	    -- self.btnTipNum = display.newTTFLabel({
	    -- 	  	text = num,    	
	    -- 	  	size = 20,
	    -- 	  	color = TextColor.BTN_W,  
	    -- 	  	-- align = cc.TEXT_ALIGNMENT_LEFT,
	    -- 	  	-- dimensions = cc.size(600, 60)
		  	-- })
	    -- self.btnTipNum:setPosition(15,15)
	    -- self.redBg:addChild(self.btnTipNum)
	    -- self.btnTipNum:setTouchEnabled(false)
	end
	--self.btnTipNum:setString(num)
end

function BaseTipsBtn:closeClickTip()
	if self.redBg then
		self:removeChild(self.redBg)
		self.btnTipNum = nil
		self.redBg = nil
	end
end

function BaseTipsBtn:close()
	BtnTipManager:delKeyBtn(self.btnTipskey)
end




