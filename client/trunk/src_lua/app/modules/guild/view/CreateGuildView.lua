local CreateGuildView = class("CreateGuildView", function()
	return display.newNode()
end)

function CreateGuildView:ctor()
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
    	text = "创建行会",
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
	        if str == "" then
	        	GlobalAlert:show("请输入行会名称!")
	        	return 
	        end
	        if string.len(str) > 18 then
	        	--editbox:setText(string.sub(str,1,18))
	        	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"行会名称最多六个字")
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
					GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, "行会名称请输入汉字")
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
	self.inputLab:setPlaceHolder("点击输入行会名称")
	self.inputLab:setReturnType(1)
    self.inputLab:setFontSize(20)
    self.inputLab:setPosition(200, 175)
    self.inputLab:setMaxLength(6)
    bg:addChild(self.inputLab)
    self.inputLab:setColor(cc.c3b(61,61,61))

    self.newGoods = configHelper:getGoodsByGoodId(110048)
	--富文本内容
	local richStr = "<font color='0xffd3af' size='20' >1.行会名称最多可输入<font color='0x6fc491'>六个汉字</font><br gap='10'/>2.创建行会需要:<font color='0xecb74c'>行会号角x1</font>或<font color='0xecb74c'>"..self.newGoods.price_jade.."元宝 </font></font>"
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
    local function onJoinGuild()
        self:onCancelClick()
        -- GlobalEventSystem:removeEventListenerByHandle(self.joinGuildEvent)
        -- self.joinGuildEvent = nil
    end
    self.joinGuildEvent = GlobalEventSystem:addEventListener(GuildEvent.JOIN_GUILD,onJoinGuild)
end

function CreateGuildView:onCancelClick()
	GlobalEventSystem:removeEventListenerByHandle(self.joinGuildEvent)
	self.joinGuildEvent = nil
	self:removeSelfSafety()
end

function CreateGuildView:onCreateClick()
	if self.inputLab:getText()=="" then GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"行会名称不能为空") return end
	local ret = StringUtil.CheckChinese(self.inputLab:getText())
	local allChinese = true
	for k,v in ipairs(ret) do
		if v.isChinese == false then
			allChinese = false
			break
		end
	end
	if allChinese then
		local s = StringUtil:replaceStr(self.inputLab:getText(),configHelper:getSensitiveWord())
		if 0 == BagManager:getInstance():findItemCountByItemId(self.newGoods.id) then
			local param = {enterTxt = "是",backTxt="否",tipTxt = "材料不足，是否花费"..self.newGoods.price_jade.."元宝创建行会",enterFun = function () 
			   GameNet:sendMsgToSocket(17001, {guild_name = s, is_jade = 1})
			end}
			GlobalMessage:alert(param)
		else
			GameNet:sendMsgToSocket(17001, {guild_name = s, is_jade = 0})
		end	
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS, "行会名称请输入汉字")
	end
end

return CreateGuildView