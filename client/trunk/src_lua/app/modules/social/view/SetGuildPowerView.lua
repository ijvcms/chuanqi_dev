local SetGuildPowerView = class("SetGuildPowerView", function()
	return display.newNode()
end)

function SetGuildPowerView:ctor()
	local maskBg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    maskBg:setContentSize(display.width, display.height)
    self:addChild(maskBg)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "ended" then
	            self:onCancelClick()
	        end     
	        return true
	    end)

    --背景
	local bg = display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(400,260),cc.rect(63, 49,1, 1))
	bg:setAnchorPoint(0,0)
	self:addChild(bg)
	bg:setPosition((display.width-400)/2,(display.height-260)/2)
	bg:setTouchEnabled(true)
	bg:setTouchSwallowEnabled(true)

	--标题背景
	local titleBg = display.newSprite("#com_alertTitleBg.png")
	bg:addChild(titleBg)
	titleBg:setPosition(200,220)

	--标题
	local labCJBH = display.newTTFLabel({
    	text = "申请设置",
    	size = 24,
    	color = TextColor.TEXT_O
	})
	display.setLabelFilter(labCJBH)
	labCJBH:setPosition(titleBg:getContentSize().width/2,titleBg:getContentSize().height/2)
	titleBg:addChild(labCJBH)

	--输入框
	local function onEdit(event, editbox)
	    if event == "ended" then
	        -- 输入结束
	        local str = editbox:getText()
	        if str == "" then return end
			if (string.match(str,"%d+") == str) == false then
				GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请输入纯数字")
	        	editbox:setText("")
			end
	    end
	end
	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(264, 40),
          listener = onEdit,
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(264, 40)
        })
	self.inputLab:setPlaceHolder("点击输入战斗力")
    self.inputLab:setFontSize(20)
    self.inputLab:setPosition(200, 165)
    self.inputLab:setMaxLength(20)
    bg:addChild(self.inputLab)
    self.inputLab:setColor(cc.c3b(61,61,61))

    --当前设置的战斗力
    local labDQZL = display.newTTFLabel({
    	text = "当前申请战力:",
    	size = 20,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(labDQZL)
	labDQZL:setAnchorPoint(0,0.5)
	labDQZL:setPosition(15,125)
	bg:addChild(labDQZL)
	labDQZL:setVisible(false)
	self.labDQZL = labDQZL

	local labDQZL2 = display.newTTFLabel({
    	text = "1000",
    	size = 20,
    	color = TextColor.TEXT_R
	})
	display.setLabelFilter(labDQZL2)
	labDQZL2:setAnchorPoint(0,0.5)
	labDQZL2:setPosition(labDQZL:getContentSize().width+labDQZL:getPositionX(),125)
	bg:addChild(labDQZL2)
	labDQZL2:setVisible(false)
	self.labDQZL2 = labDQZL2

	--富文本内容
	local richStr = "<font color='0xffd3af' size='20' >1.入会条件可以设置战斗力,仅限数字输入</font>"
	local strRT = SuperRichText.new(richStr)
    -- strRT:setAnchorPoint(0,1)
    strRT:setPosition(15,95)
    bg:addChild(strRT)

	--取消按钮
	local btnCancel = display.newSprite("#com_labBtn1.png")
    btnCancel:setTouchEnabled(true)
    btnCancel:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnCancel:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnCancel:setScale(1.0)
            self:onCancelClick()
        end     
        return true
    end)
    local label = display.newTTFLabel({
    	text = "取消",
    	size = 22,
    	color = TextColor.TEXT_W
	})
	label:setPosition(btnCancel:getContentSize().width/2,btnCancel:getContentSize().height/2)
	btnCancel:addChild(label)
	display.setLabelFilter(label)
	btnCancel:setPosition(110,30)
	bg:addChild(btnCancel)
	--修改按钮
	local btnModify = display.newSprite("#com_labBtn1.png")
    btnModify:setTouchEnabled(true)
    btnModify:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnModify:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnModify:setScale(1.0)
            self:onModifyClick()
        end     
        return true
    end)
    local label = display.newTTFLabel({
    	text = "修改",
    	size = 22,
    	color = TextColor.TEXT_W
	})
	label:setPosition(btnModify:getContentSize().width/2,btnModify:getContentSize().height/2)
	btnModify:addChild(label)
	display.setLabelFilter(label)
	btnModify:setPosition(290,30)
	bg:addChild(btnModify)

	--注册监听
	self:registerEvent()

	--获取当前设置的战力值
	local roleManager = RoleManager:getInstance()
    local guildInfo = roleManager.guildInfo
	GameNet:sendMsgToSocket(17002, {guild_id = guildInfo.guild_id})
end

function SetGuildPowerView:registerEvent()
	self.registerEventId = {}
    --取得入行会条件
    local function onGetCondition(data)
    	self.labDQZL:setVisible(true)
    	self.labDQZL2:setVisible(true)
    	self.labDQZL2:setString(data.data.fight)
    	local posX = (400-self.labDQZL:getContentSize().width-self.labDQZL2:getContentSize().width)/2
    	self.labDQZL:setPositionX(posX)
    	self.labDQZL2:setPositionX(posX+self.labDQZL:getContentSize().width)
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.REQ_ENTER_GUILD_COND,onGetCondition)
end

function SetGuildPowerView:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function SetGuildPowerView:onCancelClick()
	self:unregisterEvent()
	self:removeSelfSafety()
end

function SetGuildPowerView:onModifyClick()
	if self.inputLab:getText()=="" then return end
	GameNet:sendMsgToSocket(17003,{fight = self.inputLab:getText()})
	self:onCancelClick()
end

return SetGuildPowerView

