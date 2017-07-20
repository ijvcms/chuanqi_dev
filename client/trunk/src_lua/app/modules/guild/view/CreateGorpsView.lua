--创建军团
local CreateGorpsView = class("CreateGorpsView", function()
	return display.newNode()
end)

function CreateGorpsView:ctor()
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
    	text = "创建军团",
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
	        if string.len(str) > 18 then
	        	--editbox:setText(string.sub(str,1,18))
	        	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"军团名称最多六个字")
	        	editbox:setText("")
	        else
	        	local ret = StringUtil.CheckChinese(editbox:getText())
				local allChinese = true
				for k,v in ipairs(ret) do
					if v.isChinese == false then
						allChinese = false
						break
					end
				end
				if allChinese then

				else
					GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, "军团名称请输入汉字")
					editbox:setText("")
				end
			end
	    end
	end
	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(264, 40),
          listener = onEdit,
          image = "#com_moneyBg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(264, 40)
        })
	self.inputLab:setPlaceHolder("点击输入军团名称")
	self.inputLab:setReturnType(1)
    self.inputLab:setFontSize(20)
    self.inputLab:setPosition(200, 175)
    self.inputLab:setMaxLength(6)
    bg:addChild(self.inputLab)
    self.inputLab:setColor(cc.c3b(61,61,61))
	--富文本内容
	local richStr = "<font color='0xffd3af' size='20' >1.军团名称最多可输入<font color='0x6fc491'>六个汉字</font><br gap='10'/>2.创建军团需要:<font color='0xecb74c'>XXX元宝 </font><br gap='10'/>3.创建和加入军团须满足80级及25000战力</font>"
	local strRT = SuperRichText.new(richStr)
    -- strRT:setAnchorPoint(0,1)
    strRT:setPosition(15, 80)
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
	btnCancel:setPosition(110,40)
	bg:addChild(btnCancel)
	--创建按钮
	local btnCreate = display.newSprite("#com_labBtn1.png")
    btnCreate:setTouchEnabled(true)
    btnCreate:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnCreate:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnCreate:setScale(1.0)
            self:onCreateClick()
        end     
        return true
    end)
    local label = display.newTTFLabel({
    	text = "创建",
    	size = 22,
    	color = TextColor.TEXT_W
	})
	label:setPosition(btnCreate:getContentSize().width/2,btnCreate:getContentSize().height/2)
	btnCreate:addChild(label)
	display.setLabelFilter(label)
	btnCreate:setPosition(290,40)
	bg:addChild(btnCreate)

	--监听加入行会
    local function onJoinCorps()
        self:onCancelClick()
        -- GlobalEventSystem:removeEventListenerByHandle(self.joinCorpsEvent)
        -- self.joinCorpsEvent = nil
    end
    self.joinGuildEvent = GlobalEventSystem:addEventListener(CorpsEvent.JOIN_CORPS,onJoinCorps)
end

function CreateGorpsView:onCancelClick()
	GlobalEventSystem:removeEventListenerByHandle(self.joinCorpsEvent)
	self.joinCorpsEvent = nil
	self:removeSelfSafety()
end

function CreateGorpsView:onCreateClick()
	if self.inputLab:getText()=="" then GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"军团名称不能为空") return end
	local ret = StringUtil.CheckChinese(self.inputLab:getText())
	local allChinese = true
	for k,v in ipairs(ret) do
		if v.isChinese == false then
			allChinese = false
			break
		end
	end
	if allChinese then
		local roleInfo = RoleManager:getInstance().roleInfo
		if roleInfo.fighting >= 25000 and roleInfo.lv >= 80 then
			GameNet:sendMsgToSocket(37001, {legion_name = self.inputLab:getText(), is_jade = 1})
		else
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, "不满足创建军团的条件")
		end
		
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, "军团名称请输入汉字")
	end
end

return CreateGorpsView