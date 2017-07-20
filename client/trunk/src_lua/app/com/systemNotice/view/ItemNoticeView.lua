--
-- Author: Allen    21102585@qq.com
-- Date: 2017-05-25 23:31:45
-- 物品通知

local ItemNoticeView = class("ItemNoticeView", function()
	return display.newNode()
end)

function ItemNoticeView:ctor(noticeManager,itemData)
	self.manager = noticeManager
	self.isDestory = false
	self.lab1 = display.newTTFLabel({
			    text = "获得物品:",
			    --font = "simhei",
			    size = 20,
			    --color = TextColor.TEXT_W
			})
	--display.setLabelFilter(lab1)
	self.lab1:setAnchorPoint(0,0)

	--物品名与物品品质
	local goodName = configHelper:getGoodNameByGoodId(itemData.goods_id)
	local quality = configHelper:getGoodQualityByGoodId(itemData.goods_id)

	local color = TextColor.TEXT_W
	if quality == 1 then            --白
        color = TextColor.TEXT_W
    elseif quality == 2 then        --绿
        color = TextColor.TEXT_G
    elseif quality == 3 then        --蓝
        color = TextColor.ITEM_B
    elseif quality == 4 then        --紫
        color = TextColor.ITEM_P
    elseif quality == 5 then        --橙
        color = TextColor.TEXT_O
    end 

	self.lab2 = display.newTTFLabel({
			    text = goodName,
			    --font = "simhei",
			    size = 18,
			    color = color
			})
	--display.setLabelFilter(self.)
	self.lab2:setAnchorPoint(0,0)

	--物品数量	
	self.lab3 = display.newTTFLabel({
			    text = "+"..itemData.num,
			    --font = "simhei",
			    size = 18,
			    --color = TextColor.TEXT_W
			})
	--display.setLabelFilter(self.)
	self.lab3:setAnchorPoint(0,0)

	--总长度与高度
	local width = self.lab1:getContentSize().width + self.lab2:getContentSize().width + self.lab3:getContentSize().width
	local height = self.lab1:getContentSize().height + 8
	--GradientTips
	self.bg = display.newSprite("#scene/scene_popTipsBg.png")
	self.bg:setPosition(display.cx,display.height-200)
	self:addChild(self.bg)

	self.bg:addChild(self.lab1)
	self.bg:addChild(self.lab2)
	self.bg:addChild(self.lab3)
	self.lab1:setPosition(54, (self.bg:getContentSize().height-self.lab1:getContentSize().height)/2)
	self.lab2:setPosition(60+self.lab1:getContentSize().width, (self.bg:getContentSize().height-self.lab2:getContentSize().height)/2)
	self.lab3:setPosition(self.lab2:getPositionX()+self.lab2:getContentSize().width, (self.bg:getContentSize().height-self.lab3:getContentSize().height)/2)

	local ac1 = function()
		local sequence = transition.sequence({
		    cc.MoveTo:create(0.5, cc.p(display.cx, display.height-self.bg:getContentSize().height-70)),
		    cc.CallFunc:create(function()
		    	self:showNext()
		    end),
		    cc.DelayTime:create(0.5),
		    cc.CallFunc:create(function()
		    	-- self.bg:childRunAction(cc.FadeOut:create(0.5))
		    	self.bg:fadeOut(0.5)
		    end),
		    cc.DelayTime:create(0.5),
		    cc.CallFunc:create(function()
				--self.bg:unScheFadeOut()
				-- self:showNext()
				self.runActionIng = false
		    	self:destory()
		    end)
		})
		return sequence
	end

	local ac2 = function()
		local sequence = transition.sequence({
		    cc.DelayTime:create(1.0),
		    cc.FadeOut:create(0.5)
		})
		return sequence
	end

	self.bg:runAction(ac1())
	self.runActionIng = true
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
	self.lab1:runAction(ac2())
	self.lab2:runAction(ac2())
	self.lab3:runAction(ac2())
end

function ItemNoticeView:showNext()
	if self.viewKey then 
		self.manager:clearNoticeViewKey(self.viewKey)
	end
	--显示下一个
	SystemNotice:popGetItemsTips()
end

function ItemNoticeView:onNodeEvent(data)
	--动作还没执行完就被移除,那么需要从tips队列里删掉这个tips
	if data.name == "cleanup" then
		if self.viewKey then 
			self.manager:clearNoticeViewKey(self.viewKey)
		end

		if self.bg then self.bg:stopAllActions() end
		if self.lab1 then self.lab1:stopAllActions() end
		if self.lab2 then self.lab2:stopAllActions() end
		if self.lab3 then self.lab3:stopAllActions() end
    end
end


function ItemNoticeView:destory()
	if self.isDestory == false then
		self.isDestory = true
		if self.bg then self.bg:stopAllActions() end
		if self.lab1 then self.lab1:stopAllActions() end
		if self.lab2 then self.lab2:stopAllActions() end
		if self.lab3 then self.lab3:stopAllActions() end
		if self.viewKey then 
			self.manager:clearNoticeViewKey(self.viewKey)
		end
	    self:removeSelf()
	end
end

return ItemNoticeView