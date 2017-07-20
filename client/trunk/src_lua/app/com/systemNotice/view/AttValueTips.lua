--
-- Author: Allen    21102585@qq.com
-- Date: 2017-05-26 14:53:59
-- 货币值属性提示
local AttValueTips = class("AttValueTips", function()
	return display.newNode()
end)

function AttValueTips:ctor(noticeManager)
	self.manager = noticeManager
	self.tip = display.newLayer()
	self.tip:setCascadeOpacityEnabled(true)--不然没有FadeOut效果
	self.tip:setAnchorPoint(0.5,0.5)
	self.tip:setTouchEnabled(false)
    self.labelName = display.newSprite()--名字
    self.labelAdd = display.newSprite()--加减符号
	self.labelName:setAnchorPoint(0,0.5)
	self.labelAdd:setAnchorPoint(0,0.5)
    self.tip:addChild(self.labelName)
    self.tip:addChild(self.labelAdd)
	self:addChild(self.tip)
	self.numCount = 0--字数值个数
	self.isDestory = false
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end

function AttValueTips:onNodeEvent(data)
	--动作还没执行完就被移除,那么需要从tips队列里删掉这个tips
	if data.name == "exit" then
       self:destory()
    end
end

function AttValueTips:show(value,valueType,index)
	self.isDestory = false
	if not valueType then return end
	local vStr
	if valueType == BPTIPS_TYPE_EXP then 			--经验
		self.labelName:setSpriteFrame("scene/attrName_exp.png")--名字
        self.labelAdd:setSpriteFrame("scene/attrName_y_a.png")--加减符号
        vStr = "y"
	elseif valueType == BPTIPS_TYPE_COIN then 		--金币
		self.labelName:setSpriteFrame("scene/attrName_gold.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_h_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_h_d.png")
        end
        vStr = "h"
    elseif valueType == BPTIPS_TYPE_FEAT then 		--功勋
		self.labelName:setSpriteFrame("scene/attrName_meda.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_y_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_y_d.png")
        end
        vStr = "y"
	elseif valueType == BPTIPS_TYPE_JADE then 		--元宝
		self.labelName:setSpriteFrame("scene/attrName_jade.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_h_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_h_d.png")
        end
        vStr = "h"
	elseif valueType == BPTIPS_TYPE_GIFT then 		--礼券
		self.labelName:setSpriteFrame("scene/attrName_token.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_h_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_h_d.png")
        end
        vStr = "h"
	elseif valueType == BPTIPS_TYPE_CREDIT then 	--声望
		self.labelName:setSpriteFrame("scene/attrName_credit.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_y_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_y_d.png")
        end
        vStr = "y"
    elseif valueType == BPTIPS_TYPE_MARK1 then 	--生命印记
		self.labelName:setSpriteFrame("scene/attrName_stamp1.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_h_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_h_d.png")
        end
        vStr = "h"
    elseif valueType == BPTIPS_TYPE_MARK2 then 	--攻击印记
		self.labelName:setSpriteFrame("scene/attrName_stamp2.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_h_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_h_d.png")
        end
        vStr = "h"
    elseif valueType == BPTIPS_TYPE_MARK3 then 	--物理防御印记
		self.labelName:setSpriteFrame("scene/attrName_stamp3.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_h_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_h_d.png")
        end
        vStr = "h"
    elseif valueType == BPTIPS_TYPE_MARK4 then 	--魔法防御印记
		self.labelName:setSpriteFrame("scene/attrName_stamp4.png")
		if value > 0 then
            self.labelAdd:setSpriteFrame("scene/attrName_h_a.png")
        else
        	self.labelAdd:setSpriteFrame("scene/attrName_h_d.png")
        end
        vStr = "h"
	end
    local width = self.labelName:getContentSize().width
    self.labelAdd:setPosition(width, 0)
    width = width + self.labelAdd:getContentSize().width
	local numStrs = self:getNumStrArray(math.abs(value))
    local vLabel
    local findIdx = 1
    while (findIdx <= #numStrs) do
    	vLabel = self.tip:getChildByTag(findIdx)
    	if not vLabel then
    		vLabel = display.newSprite("#scene/attrName_"..vStr..numStrs[findIdx]..".png")
            vLabel:setAnchorPoint(0,0.5)
            vLabel:setTag(findIdx)
            self.tip:addChild(vLabel)
            self.numCount = findIdx
    	else
            vLabel:setSpriteFrame("scene/attrName_"..vStr..numStrs[findIdx]..".png")
            vLabel:setOpacity(255)
    	end
    	vLabel:setPosition(width, 0)
        width = width + vLabel:getContentSize().width
        findIdx = findIdx + 1
    end
    self.tip:setOpacity(255)

    while (findIdx <= self.numCount) do --多余的隐藏
    	vLabel = self.tip:getChildByTag(findIdx)
    	vLabel:setOpacity(0)
    	findIdx = findIdx + 1
    end

    self.tip:setContentSize(width, self.labelName:getContentSize().height)
    self.tip:setPosition(display.width/2, display.height - 195+index*30)
	self.ac2 = function()
		local sequence = transition.sequence({
		    cc.DelayTime:create(0.4),
		    cc.FadeOut:create(0.3),
		    cc.CallFunc:create(function()
		    	self:destory()
		    end)
		})
		return cc.Spawn:create({
			    cc.MoveTo:create(0.6, cc.p(display.width/2, display.height - 50+index*30)),
			    sequence
			})
	end
	
	
	self.tip:runAction(self.ac2())
end

function AttValueTips:showAC()
	self.tip:runAction(self.ac2())
end


function AttValueTips:getNumStrArray(inputNumber)
	local numStr = tostring(inputNumber)
	local numsStr = {}
	local len = string.len(numStr)
	local index = 1
	for i=1,len do
		numsStr[i] = string.sub(numStr, index, index)
		index = index + 1
	end
	return numsStr
end

function AttValueTips:destory()
	if self.isDestory == false then 
		self.isDestory = true
		if self.tip then
			self.tip:stopAllActions()
		end
		self:removeSelf()
		if self.manager then 
			self.manager:addAttTips(self)
			self.manager:popAttValueTips(nil,nil,true)
		end
	end
end

return AttValueTips