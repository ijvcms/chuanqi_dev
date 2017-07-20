
local PowerView = class("PowerView", function()
	return display.newNode() --cc.Sprite:create() -- 
end)

local powerViewShowing = false
g_curPowerView = nil

local getCanShowPowerView = function()
	if not g_curPowerView then
		g_curPowerView = PowerView.new()
	end
	return g_curPowerView
end

local setCurPowerView = function(powerView)
	g_curPowerView = powerView
end

function PowerView.isShowing()
	if g_curPowerView then
		return true
	else
		return false
	end
end

function PowerView.showPower(newPower)
	local pv = getCanShowPowerView()
	if not pv then
		pv = PowerView.new()
	end
	if not pv.setPower then
		pv = PowerView.new()
	end
	pv:setPower(newPower, false)
	return pv
end

function PowerView:ctor()	
	-- self.powerLayer = cc.LayerColor:create(cc.c4b(0,0,0,100))
	self.powerLayer = display.newLayer()
	self.powerLayer:setTouchEnabled(false)
	self.labName = display.newTTFLabel({
	    text = "战斗力:",
	    --font = "simhei",
	    size = 24,
	    color = TextColor.TEXT_Y
	})
	display.setLabelFilter(self.labName)

	self.labName:setAnchorPoint(0,0)
	self.labName:setPosition(0,0)
	self.powerLayer:addChild(self.labName)
	self.powerLayer:setVisible(false)
	self:addChild(self.powerLayer)

	self.dropArrow = display.newSprite("#com_equipDownArr.png")
	self.powerLayer:addChild(self.dropArrow)
	self.promoteArrow = display.newSprite("#com_equipUpArr.png")
	self.powerLayer:addChild(self.promoteArrow)

	self.curArrow = nil

	self.scrollNums = {}

	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo

    self.lastFighting = roleInfo.fighting
    self:setPower(roleInfo.fighting,true)


    setCurPowerView(self)
	self:setNodeEventEnabled(true)
    self:registerEvent()
end

function PowerView:onCleanup()
	setCurPowerView(nil)
	self:unregisterEvent()
end

function PowerView:setPower(newPower,hideShow)
	if not hideShow then
		self.powerLayer:setVisible(true)
	end
	if not newPower then return end

	local scrollNumGap = 5
	local scrollNumCount = 1
	local temp = newPower
	while true do
		if temp/10 >= 1 then
			scrollNumCount = scrollNumCount+1
			temp = temp/10
		else
			break
		end
	end

	--[1]对应个位,[2]对应10位......
	local nums = {}
	local temp = newPower
	for i=1,scrollNumCount do
		nums[scrollNumCount-i+1] = math.floor(temp/(10^(scrollNumCount-i)))
		temp = temp - nums[scrollNumCount-i+1]*(10^(scrollNumCount-i))
	end

	if #self.scrollNums < scrollNumCount then
		for i=1,scrollNumCount-#self.scrollNums do
			table.insert(self.scrollNums,ScrollNum.new())
		end
	elseif #self.scrollNums > scrollNumCount then
		local removeTable = {}

		for i=#self.scrollNums,scrollNumCount do
			self.scrollNums[i]:removeSelf()
			--
			table.insert(removeTable,i)
		end
		for i=1,#removeTable,1 do
			self.scrollNums[removeTable[i]] = nil
		end
	end

	self.powerLayer:setContentSize(self.labName:getContentSize().width+100+scrollNumCount*(scrollNumGap+23),50)

	for i=1,scrollNumCount do
		local scrollNum = self.scrollNums[i]
		scrollNum:setPosition(self.labName:getContentSize().width+50+(scrollNumCount-i+1)*(scrollNumGap+23)-23, (50-30)/2)
		if hideShow then
			scrollNum:setNum(nums[i],true)
		else
			scrollNum:setNum(nums[i],false)
		end
		if not scrollNum:getParent() then
			self.powerLayer:addChild(scrollNum)
		end
	end

	if self.curArrow then
		self.curArrow:stopAllActions()
	end

	local arrow
	if newPower >= self.lastFighting then
		self.promoteArrow:setVisible(true)
		self.dropArrow:setVisible(false)
		arrow = self.promoteArrow
	else
		self.promoteArrow:setVisible(false)
		self.dropArrow:setVisible(true)
		arrow = self.dropArrow
	end
	self.lastFighting = newPower

	self.labName:setPosition(50,(self.powerLayer:getContentSize().height-self.labName:getContentSize().height)/2)
	self.powerLayer:setPosition((display.width-self.powerLayer:getContentSize().width)/2,display.height-160)
	if arrow then
		arrow:setPosition(self.scrollNums[1]:getPositionX()+23+arrow:getContentSize().width/2,25)
	end

	-- self.powerLayer:stopAllActions()
	self.labName:stopAllActions()

	local ac = function()
		local sequence = transition.sequence({
		    cc.FadeIn:create(0.3),
		    cc.DelayTime:create(1.5),
		    cc.FadeOut:create(0.3),
		})
		return sequence
	end
	
	-- self.powerLayer:runAction(ac())
	self.labName:runAction(ac())
	for i=1,scrollNumCount do
		self.scrollNums[i]:stopAllActions()
		self.scrollNums[i]:runAction(ac())
	end

	self.curArrow = arrow
	self.curArrow:runAction(ac())

	self:stopAllActions()
	self:runAction(transition.sequence({
		    cc.DelayTime:create(2.1),
		    cc.CallFunc:create(function()
		    	setCurPowerView(nil)
		    	self:unregisterEvent()
		    	self:removeSelf()
		    end)
		}))
end

function PowerView:registerEvent()
	self:unregisterEvent()
    local function onSceneChange(data)
        setCurPowerView(nil)
      	self:unregisterEvent()
      	self:removeSelf()
    end
    if self.registerEventId == nil then
	    self.registerEventId = GlobalEventSystem:addEventListener(FightEvent.CHANG_SCENE, onSceneChange)
	end
end

function PowerView:unregisterEvent()
	if self.registerEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.registerEventId)
		self.registerEventId = nil
	end
end

return PowerView