--领红包发红包界面

local GuildBriberyMoneyView = class("GuildBriberyMoneyView", function()
	return display.newNode()
end)


function GuildBriberyMoneyView:ctor()
	self.maskLyr = display.newColorLayer(cc.c4b(0,0,0,100))
    self.maskLyr:setContentSize(display.width, display.height)
    self:addChild(self.maskLyr)
    self:setTouchEnabled(true)
end

function GuildBriberyMoneyView:showWithSendModel(bm_type)
    self.bm_type = bm_type
    if self.sendBMoneyView == nil then
        self.sendBMoneyView = cc.uiloader:load("resui/guildmoney_3.ExportJson")
        self.sendBMoneyView:setAnchorPoint(0.5,0.5)
        self.sendBMoneyView:setPosition(display.width / 2, display.height / 2)
        local closeBtn = cc.uiloader:seekNodeByName(self.sendBMoneyView, "close")
        closeBtn:setTouchEnabled(true)
        closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        	if event.name == "began" then
        		SoundManager:playClickSound()
            elseif event.name == "ended" then
                self.sendBMoneyView:setVisible(false)
                self:removeFromParent(false)
            end     
            return true
        end)
        self.peopleNumLabel = cc.uiloader:seekNodeByName(self.sendBMoneyView, "number") --行会人数
        local sendBtn = cc.uiloader:seekNodeByName(self.sendBMoneyView, "sendbtn") -- 发红包按钮
        sendBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        	if event.name == "began" then
        		SoundManager:playClickSound()
        		sendBtn:setScale(1.2, 1.2)
            elseif event.name == "ended" then
                self:sendBriberyMoney(self.bm_type)
                sendBtn:setScale(1, 1)
            end     
            return true
        end)
        self.briberyMoneyTitle = cc.uiloader:seekNodeByName(self.sendBMoneyView, "title") --红包标题
        self.briberyMoneyType = cc.uiloader:seekNodeByName(self.sendBMoneyView, "type") --元宝类型文字描述

        local briberyMoneyNumLyr = cc.uiloader:seekNodeByName(self.sendBMoneyView, "input2") -- 红包个数
        self.briberyMoneyNum = cc.ui.UIInput.new({
          UIInputType = 1,
          size = briberyMoneyNumLyr:getContentSize(),
          listener = handler(self,self.onEdit),
          image = "com_moneyBg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = briberyMoneyNumLyr:getContentSize()
        })
        self.briberyMoneyNum:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
        self.briberyMoneyNum:setReturnType(1)
        self.briberyMoneyNum:setFontSize(18)
        self.briberyMoneyNum:setAnchorPoint(0, 0)
        briberyMoneyNumLyr:addChild(self.briberyMoneyNum)
        
        local briberyMoneyTotalLyr = cc.uiloader:seekNodeByName(self.sendBMoneyView, "input1") -- 红包总额
        self.briberyMoneyTotal = cc.ui.UIInput.new({
          UIInputType = 1,
          size = briberyMoneyTotalLyr:getContentSize(),
          listener = handler(self,self.onEdit),
          image = "com_moneyBg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = briberyMoneyTotalLyr:getContentSize()
        })
        self.briberyMoneyTotal:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
        self.briberyMoneyTotal:setReturnType(1)
        self.briberyMoneyTotal:setFontSize(18)
        self.briberyMoneyTotal:setAnchorPoint(0, 0)
        briberyMoneyTotalLyr:addChild(self.briberyMoneyTotal)

        local briberyMoneyDesLyr = cc.uiloader:seekNodeByName(self.sendBMoneyView, "input3") -- 红包描述
        self.briberyMoneyDes = cc.ui.UIInput.new({
          UIInputType = 1,
          size = briberyMoneyDesLyr:getContentSize(),
          listener = handler(self,self.onDesEdit),
          image = "com_moneyBg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = briberyMoneyTotalLyr:getContentSize()
        })
        self.briberyMoneyDes:setReturnType(1)
        self.briberyMoneyDes:setFontSize(18)
        self.briberyMoneyDes:setAnchorPoint(0, 0)
        briberyMoneyDesLyr:addChild(self.briberyMoneyDes)
        self.maskLyr:addChild(self.sendBMoneyView)
        self:registerEvent()
    end
    --获取行会详细信息，多个界面用到
    GameNet:sendMsgToSocket(17010, {})
    if bm_type == 1 then
        self.briberyMoneyTitle:setSpriteFrame("guildmoney_listbg27.png")
        self.briberyMoneyType:setString("总金额")
    else
    	self.briberyMoneyTitle:setSpriteFrame("guildmoney_listbg22.png")
    	self.briberyMoneyType:setString("单个金额")
    end
    self.briberyMoneyDes:setText("行会福利红包")
    self.peopleNumLabel:setString(tostring(GlobalController.guild:getGuildDetailedInfo().number))
    self.sendBMoneyView:setVisible(true)
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, self)
end

function GuildBriberyMoneyView:onDesEdit(event, editbox)
     if event == "ended" or event == "return" then
        local checkText = editbox:getText()
        if StringUtil.Utf8strlen(checkText) > 10 then
            editbox:setText(StringUtil.SubUTF8String(checkText, 1, 9).."...")
        end
      
    end
end

function GuildBriberyMoneyView:onEdit(event, editbox)
    if event == "changed" then
    	--if device.platform == "ios" then
    		local checkText = editbox:getText()
            local text = string.gsub(checkText,"[\\.]", "")
            if checkText ~= text then
        	    editbox:setText(text)
            end
    	--end
    end
end


--发送红包
--type ： 1 拼手气 2 固定额度
function GuildBriberyMoneyView:sendBriberyMoney(bm_type)
    if self.briberyMoneyNum:getText() == "" then
        GlobalController.guild:handleResultCode(406)--红包数量不能为空
        return
    end
    if self.briberyMoneyTotal:getText() == "" then
        GlobalController.guild:handleResultCode(407)--红包金额不能为空
        return
    end
    local count = tonumber(self.briberyMoneyNum:getText(), 10)
    local jade = tonumber(self.briberyMoneyTotal:getText(), 10)
    if jade == nil or count == nil then
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"输入有误！")
        return
    end
    local total = jade
    if bm_type == 2 then
        total = jade * count
    end
    if total > RoleManager:getInstance().wealth.jade or total <= 0 then
        GlobalController.guild:handleResultCode(4)--当前元宝不足
        return
    end

    if count <= 0 or count > GlobalController.guild:getGuildDetailedInfo().number then
    	GlobalController.guild:handleResultCode(405)--发送的人数错误
    	return
    end
    if bm_type == 1 then
    	if count > jade then
            GlobalController.guild:handleResultCode(408)--总金额必须大于红包个数
    	    return
        end
    end
    GlobalController.guild:sendBriberyMoney(jade, count, bm_type, self.briberyMoneyDes:getText())
    self.sendBMoneyView:setVisible(false)
    self:removeFromParent(false)
end

function GuildBriberyMoneyView:showWithReceiveModel(jade)

    if self.getBMoneyView == nil then
    	self.armatureDataManager = ccs.ArmatureDataManager:getInstance()
        self.effectID = "money"
        --self.armatureDataManager:addArmatureFileInfo("effect/money/money.ExportJson")
        if  ArmatureManager:getInstance():loadEffect(self.effectID) then
            self.armatureEff = ccs.Armature:create(self.effectID)
            self.armatureEff:setPosition(display.cx, display.cy)
            self.maskLyr:addChild(self.armatureEff)
        end
        self.getBMoneyView = cc.uiloader:load("resui/guildmoney_4.ExportJson")
        self.getBMoneyView:setAnchorPoint(0.5,0.5)
        self.getBMoneyView:setPosition(display.width / 2, display.height / 2)
        local closeBtn = cc.uiloader:seekNodeByName(self.getBMoneyView, "close")
        closeBtn:setTouchEnabled(true)
        closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
            	SoundManager:playClickSound()
            elseif event.name == "ended" then
                self.getBMoneyView:setVisible(false)
                self.armatureEff:getAnimation():stop()
                self.armatureEff:setVisible(false)
                self:removeFromParent(false)
            end     
            return true
        end)
        self.BMoneyPrice = cc.uiloader:seekNodeByName(self.getBMoneyView, "number") --元宝数量
        local sureBtn = cc.uiloader:seekNodeByName(self.getBMoneyView, "surebtn")--红包领取
        sureBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
           		SoundManager:playClickSound()
           		sureBtn:setScale(1.2, 1.2)
            elseif event.name == "ended" then
                sureBtn:setScale(1, 1)
                self.getBMoneyView:setVisible(false)
                self.armatureEff:getAnimation():stop()
                self.armatureEff:setVisible(false)
                self:removeFromParent(false)
            end    
            return true
        end)
        self.maskLyr:addChild(self.getBMoneyView)
    end
    self.getBMoneyView:setVisible(true)
    self.armatureEff:setVisible(true)
    self.armatureEff:getAnimation():play("effect")
    self.BMoneyPrice:setString(tostring(jade))
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, self)
end

function GuildBriberyMoneyView:registerEvent()
    --取得行会详细信息
    local function onGuildDetailedInfo(data)
       self.peopleNumLabel:setString(tostring(data.data.number))
    end
    self.registerEventId = GlobalEventSystem:addEventListener(GuildEvent.GUILD_DETAILED_INFO, onGuildDetailedInfo)
  
end

function GuildBriberyMoneyView:unregisterEvent()
    if self.registerEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId)
    end
end

function GuildBriberyMoneyView:onCleanup()
    self:unregisterEvent()
	if self.armatureEff then
        self.armatureEff:getAnimation():stop()
        if self.armatureEff:getParent() then
            self.armatureEff:getParent():removeChild(self.armatureEff)
        end 
        self.armatureEff = nil
    end
    self:cleanup()--非常重要，因为self:removeFromParent(false)
end 

return GuildBriberyMoneyView

